#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>
#include <stdio.h>
#include <slub_pmm.h>
#include <memlayout.h>


// 管理特定大小对象缓存的核心结构体
struct kmem_cache {
    list_entry_t slabs_full;      // 全满slab链表
    list_entry_t slabs_partial;   // 部分空闲slab链表
    list_entry_t slabs_free;      // 完全空闲slab链表

    uint32_t object_size;         // 本缓存中每个对象的大小
    uint32_t objects_per_slab;    // 本缓存中每个slab可以存放的对象数
    uint32_t slab_pages;          // 每个slab占用的物理页数量（为了简单起见，初始值设为1）

    // lock_t lock;               // 因为处理器是单核，所以先不用锁

    char name[32];                // 缓存名称
};

struct kmem_cache *
kmem_cache_create(const char *name, size_t size) {
    // 使用buddy分配器来获取缓存描述符的内存
    struct Page* page = alloc_pages(1);
    if (page == NULL) {
        return NULL;
    }
    struct kmem_cache *cache = (struct kmem_cache *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);

    // 初始化缓存结构体
    memset(cache, 0, sizeof(struct kmem_cache));
    list_init(&(cache->slabs_full));
    list_init(&(cache->slabs_partial));
    list_init(&(cache->slabs_free));

    cache->object_size = size;
    cache->slab_pages = 1; // 为了简单起见，每个slab从1页开始
    cache->objects_per_slab = (cache->slab_pages * PGSIZE) / cache->object_size;
    
    strncpy(cache->name, name, sizeof(cache->name) - 1);
    cache->name[sizeof(cache->name) - 1] = '\0';

    return cache;
}

static void
slab_init(struct kmem_cache *cache, struct Page *page) {
    page->inuse = 0;
    page->cache = cache;
    page->freelist = NULL;

    void *slab_base = (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
    for (int i = 0; i < cache->objects_per_slab; i++) {
        void *obj = (void *)((char *)slab_base + i * cache->object_size);
        *(void **)obj = page->freelist;
        page->freelist = obj;
    }
}
// 扩展缓存：为缓存分配新的slab
static bool
kmem_cache_grow(struct kmem_cache *cache) {
    struct Page *page = alloc_pages(cache->slab_pages);
    if (page == NULL) {
        return false;
    }

    slab_init(cache, page);

    list_add(&(cache->slabs_free), &(page->page_link));
    return true;
}

void *
kmem_cache_alloc(struct kmem_cache *cache) {
    list_entry_t *le;
    struct Page *page;

    // 1. 尝试在部分空闲链表中找到一个slab
    if (!list_empty(&(cache->slabs_partial))) {
        le = list_next(&(cache->slabs_partial));
        page = le2page(le, page_link);
    } else {
        // 2. 如果部分空闲链表为空，尝试完全空闲链表
        if (list_empty(&(cache->slabs_free))) {
            // 3. 如果完全空闲链表也为空，扩展缓存
            if (!kmem_cache_grow(cache)) {
                return NULL; // 扩展失败
            }
        }
        le = list_next(&(cache->slabs_free));
        page = le2page(le, page_link);
    }

    // 此时，'page'指向一个有空闲对象的slab
    void *obj = page->freelist;
    page->freelist = *(void **)obj;
    page->inuse++;

    // 更新slab链表
    list_del(le);
    if (page->inuse == cache->objects_per_slab) {
        // slab现在已满
        list_add(&(cache->slabs_full), le);
    } else {
        // slab现在是部分空闲
        list_add(&(cache->slabs_partial), le);
    }

    return obj;
}

void
kmem_cache_free(void *obj) {
    if (obj == NULL) {
        return;
    }

    // 从对象的虚拟地址获取页面描述符
    struct Page *page = pa2page((uintptr_t)obj - PHYSICAL_MEMORY_OFFSET);
    struct kmem_cache *cache = page->cache;

    // 将对象添加回slab的空闲链表
    *(void **)obj = page->freelist;
    page->freelist = obj;

    bool was_full = (page->inuse == cache->objects_per_slab);
    page->inuse--;

    // 只有当slab状态改变时才移动它
    if (page->inuse == 0) {
        // 从部分空闲转换为完全空闲
        list_del(&(page->page_link));
        list_add(&(cache->slabs_free), &(page->page_link));
    } else if (was_full) {
        // 从全满转换为部分空闲
        list_del(&(page->page_link));
        list_add(&(cache->slabs_partial), &(page->page_link));
    }
    // 如果原来是部分空闲且仍然是部分空闲，则不做任何操作
}

static struct kmem_cache *kmalloc_caches[KMALLOC_MAX_SHIFT + 1];

// 辅助函数：为给定大小找到正确的缓存索引
static inline size_t size_to_index(size_t size) {
    size_t shift = KMALLOC_MIN_SHIFT;
    size_t current_size = 1 << shift;
    while (current_size < size) {
        shift++;
        current_size <<= 1;
    }
    return shift;
}

void kmalloc_init(void) {
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
        size_t size = 1 << i;
        char name[32];
        snprintf(name, sizeof(name), "size-%d", (int)size);
        kmalloc_caches[i] = kmem_cache_create(name, size);
        // 在真实系统中，如果失败应该panic
    }
}

void *kmalloc(size_t size) {
    if (size > (1 << KMALLOC_MAX_SHIFT)) {
        // 分配请求对于任何slab缓存都太大，回退到buddy分配器
        uint32_t num_pages = (size + PGSIZE - 1) / PGSIZE;
        struct Page *page = alloc_pages(num_pages);
        if (page == NULL) {
            return NULL;
        }
        // 标记这些页面不由slab缓存管理，并存储页面数量
        page->property = num_pages;
        for(int i = 0; i < num_pages; i++) {
            (page + i)->cache = NULL;
        }
        return (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
    }

    size_t index = size_to_index(size);
    if (kmalloc_caches[index]) {
        return kmem_cache_alloc(kmalloc_caches[index]);
    }
    return NULL;
}

void kfree(void *ptr) {
    if (ptr == NULL) {
        return;
    }

    // 检查是否是大分配（直接来自buddy分配器）
    struct Page *page = pa2page((uintptr_t)ptr - PHYSICAL_MEMORY_OFFSET);
    if (page->cache == NULL) {
        // 这是一个大分配，直接释放给buddy分配器
        free_pages(page, page->property);
        return;
    }

    // 这是一个slab分配，使用slab释放
    kmem_cache_free(ptr);
}

// 测试辅助函数实现（仅用于测试）
struct kmem_cache *get_kmalloc_cache(size_t index) {
    if (index <= KMALLOC_MAX_SHIFT) {
        return kmalloc_caches[index];
    }
    return NULL;
}

size_t get_cache_objects_per_slab(struct kmem_cache *cache) {
    if (cache == NULL) {
        return 0;
    }
    return cache->objects_per_slab;
}

bool is_list_empty_slabs_full(struct kmem_cache *cache) {
    if (cache == NULL) {
        return true;
    }
    return list_empty(&(cache->slabs_full));
}

bool is_list_empty_slabs_partial(struct kmem_cache *cache) {
    if (cache == NULL) {
        return true;
    }
    return list_empty(&(cache->slabs_partial));
}

bool is_list_empty_slabs_free(struct kmem_cache *cache) {
    if (cache == NULL) {
        return true;
    }
    return list_empty(&(cache->slabs_free));
}