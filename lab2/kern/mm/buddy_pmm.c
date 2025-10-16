#include <pmm.h>
#include <memlayout.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define LEFT_LEAF(index)  ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index)     (((index) + 1) / 2 - 1)
#define MAX(a, b)         ((a) > (b) ? (a) : (b))

// 记录 buddy 系统全局状态
static unsigned buddy_size;             // 可管理页数（必须是 2 的幂）
static unsigned *buddy_longest = NULL;  // 完全二叉树数组
static unsigned buddy_node_count;       // = 2 * buddy_size - 1
static struct Page *buddy_base;         // 起始页
static size_t nr_buddy_free_pages;         // 空闲页计数

// 向上取 2 的幂
static unsigned fixsize(unsigned size) {
    unsigned n = 1;
    while (n < size) n <<= 1;
    return n;
}

// ======== 初始化 Buddy 系统 ========
static void buddy_init(void) {
    cprintf("buddy_pmm_manager: initializing...\n");
    buddy_size = 0;
    buddy_longest = NULL;
    buddy_base = NULL;
    buddy_node_count = 0;
    nr_buddy_free_pages = 0;
}

// ======== 初始化内存映射 ========
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);

    // 向上取 2 的幂
    buddy_size = fixsize(n);
    buddy_node_count = buddy_size * 2 - 1;

    // buddy 树数组放在 pages[] 后
    extern struct Page *pages;
    buddy_longest = (unsigned *)ROUNDUP((void *)(pages + npage - nbase), sizeof(unsigned));
    
    // 初始化 longest 数组
    unsigned node_size = buddy_size * 2;
    for (unsigned i = 0; i < buddy_node_count; i++) {
        if ((i + 1) & (i)) {
            // not power of 2
        } else {
            node_size >>= 1;
        }
        buddy_longest[i] = node_size;
    }

    buddy_base = base;
    nr_buddy_free_pages = n;

    for (size_t i = 0; i < n; i++) {
        ClearPageReserved(base + i);
        ClearPageProperty(base + i);
        set_page_ref(base + i, 0);
    }

    cprintf("buddy_init_memmap: base=%p, n=%d, tree_nodes=%d\n",
            base, n, buddy_node_count);
}

// ======== 分配物理页 ========
static struct Page *buddy_alloc_pages(size_t n) {
    if (n == 0) return NULL;
    unsigned size = fixsize(n);
    if (buddy_longest[0] < size) return NULL;

    unsigned index = 0, node_size;
    for (node_size = buddy_size; node_size != size; node_size >>= 1) {
        if (buddy_longest[LEFT_LEAF(index)] >= size)
            index = LEFT_LEAF(index);
        else
            index = RIGHT_LEAF(index);
    }

    // 分配成功
    buddy_longest[index] = 0;
    unsigned offset = (index + 1) * node_size - buddy_size;

    // 回溯更新
    while (index) {
        index = PARENT(index);
        buddy_longest[index] =
            MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
    }

    // 标记 page 状态
    struct Page *page = buddy_base + offset;
    for (unsigned i = 0; i < size; i++) {
        SetPageReserved(page + i);
        ClearPageProperty(page + i);
    }

    nr_buddy_free_pages -= size;
    return page;
}

// ======== 释放物理页 ========
static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    unsigned offset = base - buddy_base;
    unsigned node_size = 1;
    unsigned index = offset + buddy_size - 1;

    // 找到对应节点
    for (; buddy_longest[index]; index = PARENT(index))
        node_size <<= 1;

    buddy_longest[index] = node_size;
    while (index) {
        index = PARENT(index);
        node_size <<= 1;
        unsigned left = buddy_longest[LEFT_LEAF(index)];
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
        if (left + right == node_size)
            buddy_longest[index] = node_size;
        else
            buddy_longest[index] = MAX(left, right);
    }

    // 恢复 page 状态
    for (unsigned i = 0; i < n; i++) {
        ClearPageReserved(base + i);
        ClearPageProperty(base + i);
    }

    nr_buddy_free_pages += n;
}

// ======== 空闲页统计 ========
static size_t buddy_nr_free_pages(void) {
    return nr_buddy_free_pages;
}

// ======== 自检函数 ========
static void buddy_check(void) {
    cprintf("[buddy_check] total free: %u pages\n", nr_buddy_free_pages);

    struct Page *p0, *p1, *p2;
    p0 = buddy_alloc_pages(1);
    assert(p0 != NULL);
    p1 = buddy_alloc_pages(2);
    assert(p1 != NULL);
    p2 = buddy_alloc_pages(4);
    assert(p2 != NULL);
    buddy_free_pages(p0, 1);
    buddy_free_pages(p1, 2);
    buddy_free_pages(p2, 4);

    cprintf("[buddy_check] passed!\n");
}

// ======== 注册到 pmm_manager ========
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
