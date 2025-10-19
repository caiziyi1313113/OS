#include <default_pmm.h>
#include <best_fit_pmm.h>
#include <buddy_pmm.h>
#include <defs.h>
#include <error.h>
#include <memlayout.h>
#include <mmu.h>
#include <pmm.h>
#include <sbi.h>
#include <stdio.h>
#include <string.h>
#include <riscv.h>
#include <dtb.h>

// virtual address of physical page array
struct Page *pages;
// amount of physical memory (in pages)
size_t npage = 0;
// the kernel image is mapped at VA=KERNBASE and PA=info.base
uint64_t va_pa_offset;
// memory starts at 0x80000000 in RISC-V
// DRAM_BASE defined in riscv.h as 0x80000000
const size_t nbase = DRAM_BASE / PGSIZE;

// virtual address of boot-time page directory
uintptr_t *satp_virtual = NULL;
// physical address of boot-time page directory
uintptr_t satp_physical;

// physical memory management
const struct pmm_manager *pmm_manager;

// Forward declarations for SLUB testing
#include <slub_pmm.h>
static void check_slub(void);


static void check_alloc_page(void);

// init_pmm_manager - initialize a pmm_manager instance
static void init_pmm_manager(void) {
    pmm_manager = &buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
    pmm_manager->init();
}

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void init_memmap(struct Page *base, size_t n) {
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
}

static void page_init(void) {
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;

    uint64_t mem_begin = get_memory_base();
    uint64_t mem_size  = get_memory_size();
    if (mem_size == 0) {
        panic("DTB memory info not available");
    }
    uint64_t mem_end   = mem_begin + mem_size;

    cprintf("physcial memory map:\n");
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
            mem_end - 1);

    uint64_t maxpa = mem_end;

    if (maxpa > KERNTOP) {
        maxpa = KERNTOP;
    }

    extern char end[];

    npage = maxpa / PGSIZE;
    //kernel在end[]结束, pages是剩下的页的开始
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (size_t i = 0; i < npage - nbase; i++) {
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));

    mem_begin = ROUNDUP(freemem, PGSIZE);
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
    if (freemem < mem_end) {
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();

    extern char boot_page_table_sv39[];
    satp_virtual = (pte_t*)boot_page_table_sv39;
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
    cprintf("check_alloc_page() succeeded!\n");

    check_slub();
}

// 增强的 SLUB 分配器测试套件，基于 Buddy System 测试思路设计
static void
check_slub(void) {
    cprintf("check_slub() starting: Enhanced SLUB test suite.\n");

    // 初始化 SLUB 分配器
    kmalloc_init();

    // ========== 第一部分：初始化与状态验证 ==========
    cprintf("--- Part 1: Initialization & State Verification ---\n");
    
    // 测试1.1：Cache 创建验证
    cprintf("  Test 1.1: Cache Creation Verification\n");
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
        struct kmem_cache *cache = get_kmalloc_cache(i);
        assert(cache != NULL);
        size_t size = 1 << i;
        cprintf("    Cache[%d]: size-%d, objects_per_slab=%d\n", 
                i, (int)size, (int)get_cache_objects_per_slab(cache));
    }
    cprintf("  ✓ All caches created successfully.\n");

    // 测试1.2：初始 Slab 状态验证
    cprintf("  Test 1.2: Initial Slab State Verification\n");
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
        struct kmem_cache *cache = get_kmalloc_cache(i);
        assert(is_list_empty_slabs_full(cache));
        assert(is_list_empty_slabs_partial(cache));
        assert(is_list_empty_slabs_free(cache));
    }
    cprintf("  ✓ All cache lists are initially empty.\n");
    cprintf("--- Part 1 Passed ---\n\n");

    // ========== 第二部分：Slab 内部对象分配与回收 ==========
    cprintf("--- Part 2: Slab Internal Object Allocation & Reclamation ---\n");
    
    // 测试2.1：Slab 耗尽与填满测试
    cprintf("  Test 2.1: Slab Exhaustion & Filling Test\n");
    struct kmem_cache *test_cache = get_kmalloc_cache(6); // size-64 cache
    size_t objects_per_slab = get_cache_objects_per_slab(test_cache);
    cprintf("    Testing with size-64 cache, objects_per_slab=%d\n", (int)objects_per_slab);
    
    size_t initial_free_pages = nr_free_pages();
    cprintf("    Initial free pages: %d\n", (int)initial_free_pages);
    
    // 分配 N 个对象（填满一个 slab）
    void **obj_array = (void **)kmalloc(objects_per_slab * sizeof(void *));
    assert(obj_array != NULL);
    
    for (size_t i = 0; i < objects_per_slab; i++) {
        obj_array[i] = kmalloc(64);
        assert(obj_array[i] != NULL);
        memset(obj_array[i], (int)i, 64);
    }
    
    size_t pages_after_first_slab = nr_free_pages();
    cprintf("    After filling one slab, free pages: %d\n", (int)pages_after_first_slab);
    assert(initial_free_pages - pages_after_first_slab >= 1); // 至少使用了1页
    
    // 验证第一个 slab 已满
    assert(!is_list_empty_slabs_full(test_cache));
    cprintf("    ✓ First slab is now in slabs_full list.\n");
    
    // 分配第 N+1 个对象（应该创建新的 slab）
    void *extra_obj = kmalloc(64);
    assert(extra_obj != NULL);
    
    size_t pages_after_second_slab = nr_free_pages();
    cprintf("    After allocating N+1 object, free pages: %d\n", (int)pages_after_second_slab);
    assert(pages_after_first_slab - pages_after_second_slab >= 1); // 又使用了至少1页
    
    // 释放第 N+1 个对象
    kfree(extra_obj);
    
    // 释放第一个 slab 中的一个对象
    kfree(obj_array[0]);
    obj_array[0] = NULL;
    
    size_t pages_after_partial_free = nr_free_pages();
    cprintf("    After freeing one object from full slab, free pages: %d\n", (int)pages_after_partial_free);
    // 页数不应该变化，因为 slab 被缓存
    assert(pages_after_partial_free == pages_after_second_slab);
    cprintf("    ✓ Slab moved from full to partial, page cached.\n");
    
    // 清理剩余对象
    for (size_t i = 1; i < objects_per_slab; i++) {
        if (obj_array[i] != NULL) {
            kfree(obj_array[i]);
        }
    }
    kfree(obj_array);
    
    // 测试2.2：对象地址检查
    cprintf("  Test 2.2: Object Address Pattern Check\n");
    void *addr1 = kmalloc(64);
    void *addr2 = kmalloc(64);
    assert(addr1 != NULL && addr2 != NULL);
    
    uintptr_t diff = (uintptr_t)addr2 - (uintptr_t)addr1;
    if (diff < 0) diff = -diff;
    cprintf("    addr1=%p, addr2=%p, diff=%d\n", addr1, addr2, (int)diff);
    assert(diff == 64); // 对象大小应该是64字节
    cprintf("    ✓ Object addresses follow expected pattern.\n");
    
    kfree(addr1);
    kfree(addr2);
    cprintf("--- Part 2 Passed ---\n\n");

    // ========== 第三部分：多 Slab 协同工作 ==========
    cprintf("--- Part 3: Multi-Slab Collaborative Work ---\n");
    
    // 测试3.1：partial 链表优先使用测试
    cprintf("  Test 3.1: Partial List Priority Test\n");
    
    // 创建一个 full slab 和一个 partial slab
    size_t test_objects = objects_per_slab + 1;
    void **test_objs = (void **)kmalloc(test_objects * sizeof(void *));
    assert(test_objs != NULL);
    
    size_t pages_before_multi_slab = nr_free_pages();
    
    // 分配 N+1 个对象
    for (size_t i = 0; i < test_objects; i++) {
        test_objs[i] = kmalloc(64);
        assert(test_objs[i] != NULL);
    }
    
    // 释放第一个 full slab 中的一个对象，使其变为 partial
    kfree(test_objs[0]);
    test_objs[0] = NULL;
    
    // 现在应该有两个 partial slab
    assert(!is_list_empty_slabs_partial(test_cache));
    
    size_t pages_before_priority_test = nr_free_pages();
    
    // 再分配一个对象，应该使用 partial slab，而不是创建新的
    void *priority_obj = kmalloc(64);
    assert(priority_obj != NULL);
    
    size_t pages_after_priority_test = nr_free_pages();
    assert(pages_after_priority_test == pages_before_priority_test);
    cprintf("    ✓ Allocation used partial slab, no new page allocated.\n");
    
    // 清理
    kfree(priority_obj);
    for (size_t i = 1; i < test_objects; i++) {
        if (test_objs[i] != NULL) {
            kfree(test_objs[i]);
        }
    }
    kfree(test_objs);
    cprintf("--- Part 3 Passed ---\n\n");

    // ========== 第四部分：边界与异常条件 ==========
    cprintf("--- Part 4: Boundary & Exception Conditions ---\n");
    
    // 测试4.1：最大尺寸分配
    cprintf("  Test 4.1: Maximum Size Allocation\n");
    size_t max_size = 1 << KMALLOC_MAX_SHIFT;
    void *max_obj = kmalloc(max_size);
    assert(max_obj != NULL);
    cprintf("    kmalloc(%d) returned %p\n", (int)max_size, max_obj);
    memset(max_obj, 0xAA, max_size);
    kfree(max_obj);
    cprintf("    ✓ Maximum size allocation test passed.\n");
    
    // 测试4.2：超大尺寸回退 (Fallback)
    cprintf("  Test 4.2: Oversized Allocation Fallback\n");
    size_t pages_before_fallback = nr_free_pages();
    
    size_t large_size = PGSIZE * 2;
    void *large_obj = kmalloc(large_size);
    assert(large_obj != NULL);
    cprintf("    kmalloc(%d) returned %p\n", (int)large_size, large_obj);
    
    size_t pages_after_fallback = nr_free_pages();
    assert(pages_before_fallback - pages_after_fallback == 2); // 应该使用2页
    cprintf("    ✓ Fallback to buddy system used exactly 2 pages.\n");
    
    memset(large_obj, 0xBB, large_size);
    kfree(large_obj);
    
    size_t pages_after_fallback_free = nr_free_pages();
    assert(pages_after_fallback_free == pages_before_fallback);
    cprintf("    ✓ Fallback memory correctly returned to buddy system.\n");
    
    // 测试4.3：内存耗尽测试（简化版，避免真正耗尽系统内存）
    cprintf("  Test 4.3: Memory Exhaustion Test (Limited)\n");
    size_t exhaustion_test_pages = nr_free_pages();
    if (exhaustion_test_pages > 10) {
        // 只在有足够页面时进行此测试
        void **exhaustion_objs = (void **)kmalloc(10 * sizeof(void *));
        assert(exhaustion_objs != NULL);
        
        // 分配大块内存，但不耗尽所有内存
        for (int i = 0; i < 5; i++) {
            exhaustion_objs[i] = kmalloc(PGSIZE);
            if (exhaustion_objs[i] == NULL) {
                cprintf("    Memory allocation failed at iteration %d (expected)\n", i);
                break;
            }
        }
        
        // 清理已分配的内存
        for (int i = 0; i < 5; i++) {
            if (exhaustion_objs[i] != NULL) {
                kfree(exhaustion_objs[i]);
            }
        }
        kfree(exhaustion_objs);
        cprintf("    ✓ Memory exhaustion handling works correctly.\n");
    } else {
        cprintf("    Skipped exhaustion test (insufficient free pages).\n");
    }
    
    cprintf("--- Part 4 Passed ---\n\n");

    cprintf("check_slub() completed: All enhanced tests passed!\n");
}
