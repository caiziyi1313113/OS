#include <pmm.h>
#include <memlayout.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define LEFT_LEAF(index)  ((index) * 2 + 1)//左子节点
#define RIGHT_LEAF(index) ((index) * 2 + 2)//右子节点
#define PARENT(index)     (((index) + 1) / 2 - 1)//父节点
#define MAX(a, b)         ((a) > (b) ? (a) : (b))//取较大值

// 记录 buddy 系统全局状态
static unsigned buddy_size;             // 可管理页数（必须是 2 的幂）
static unsigned *buddy_longest = NULL;  // 完全二叉树数组，存放管理的最大空闲块大小
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
//把一段连续的物理页（从 base 开始的 n 个页）交给 buddy system 管理
//在 pages[] 后面建立 buddy 树数组（buddy_longest[]），
//并且把所有页初始化为“可用状态”。
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    cprintf("buddy_init_memmap: init_base=%p (PA=0x%lx), init_n=%d\n",
            base, page2pa(base), n);

    /* Step 1. 计算 buddy 树大小（节点数） */
    buddy_size = fixsize(n);
    if (buddy_size > n) {
        buddy_size >>= 1; // 避免超出可管理页数
        cprintf("[buddy] adjust fixsize down to %u\n", buddy_size);
    }
    buddy_node_count = buddy_size * 2 - 1;

    /* Step 2. 在 pages[] 后放置 buddy_longest[] */
    extern struct Page *pages;
    uintptr_t buddy_start_addr =
        ROUNDUP((uintptr_t)(pages + npage - nbase), PGSIZE);
    buddy_longest = (unsigned *)buddy_start_addr;
    uintptr_t buddy_meta_end = (uintptr_t)(buddy_longest + buddy_node_count);

    /* Step 3. 检查元数据是否占用了物理可分配区前部 */
    uintptr_t base_kva = (uintptr_t)base;
    if (buddy_meta_end > base_kva) {
        size_t skip_bytes = ROUNDUP(buddy_meta_end - base_kva, PGSIZE);
        size_t skip_pages = skip_bytes / PGSIZE;
        base += skip_pages;
        n -= skip_pages;
        cprintf("[buddy] skip %u pages\n ", skip_pages);
        cprintf("(%u for buddy metadata(B)\n", skip_bytes);
    }

    buddy_base = base;
    nr_buddy_free_pages = n;

    /* Step 4. 初始化 buddy_longest[] 树 */
    unsigned node_size = buddy_size * 2;
    for (unsigned i = 0; i < buddy_node_count; i++) {
        if ((i + 1) & i) {
            // 非 2 的幂，不变
        } else {
            node_size >>= 1;
        }
        buddy_longest[i] = node_size;
    }

    /* Step 5. 初始化 Page 状态 */
    for (size_t i = 0; i < n; i++) {
        ClearPageReserved(base + i);
        ClearPageProperty(base + i);
        set_page_ref(base + i, 0);
    }

    /* Step 6. 打印初始化结果 */
    cprintf("buddy_init_memmap done:\n");
    cprintf("  buddy_base  = %p (PA=0x%lx)\n", base, page2pa(base));
    cprintf("  tree_nodes  = %u, buddy_size=%u\n", buddy_node_count, buddy_size);
}

// ======== 分配物理页 ========
static struct Page *buddy_alloc_pages(size_t n) {
    if (n == 0) return NULL;
    unsigned size = fixsize(n);
    if (buddy_longest[0] < size) return NULL;

    unsigned index = 0, node_size;
    //遍历左右节点，寻找可用内存空间
    for (node_size = buddy_size; node_size != size; node_size >>= 1) {
        if (buddy_longest[LEFT_LEAF(index)] >= size)
            index = LEFT_LEAF(index);
        else
            index = RIGHT_LEAF(index);
    } 

    // 分配成功
    //不需要通过额外的标志位判断当前块是否可用
    //buddy_longest[index] = 0;表明当前快不可用，没有空闲空间
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
        set_page_ref(base+i, 0);
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
/*
static void buddy_check(void) {
    cprintf("[buddy_check] total free: %u pages\n", nr_buddy_free_pages);

    struct Page *p0, *p1, *p2;
    p0 = buddy_alloc_pages(1);
    cprintf("p0 = %p\n", p0);
    assert(p0 != NULL);
    p1 = buddy_alloc_pages(2);
    cprintf("p1 = %p\n", p1);
    assert(p1 != NULL);
    p2 = buddy_alloc_pages(45);
    cprintf("p2 = %p\n", p2);
    assert(p2 != NULL);
    buddy_free_pages(p0, 1);
    buddy_free_pages(p1, 2);
    buddy_free_pages(p2, 4);

    cprintf("[buddy_check] passed!\n");
}
*/

// ======== 打印树摘要（只显示每层的最大空闲块） ========
static void print_buddy_summary(void) {
    cprintf("---- buddy tree summary ----\n");
    unsigned index = 0, level = 0, nodes_in_level = 1;

    while (index < buddy_node_count) {
        unsigned min_val = 32000;
        for (unsigned i = 0; i < nodes_in_level && index < buddy_node_count; i++, index++) {
            if (buddy_longest[index] < min_val)
                min_val = buddy_longest[index];
        }
        cprintf("  Level %-2u : min_free_block = %-5u\n", level, min_val);
        level++;
        nodes_in_level <<= 1;
    }
    cprintf("-----------------------------\n");
}

// ======== 打印分配的物理页范围 ========
static void print_page_range(struct Page *p, unsigned pages) {
    if (!p) {
        cprintf("  null allocation\n");
        return;
    }
    uintptr_t start_pa = page2pa(p);
    uintptr_t end_pa = page2pa(p + pages);
    cprintf("  pages=%-4u  PA=[0x%08lx, 0x%08lx)\n", pages, start_pa, end_pa);
}

// ======== 自检函数（精简版） ========
static void buddy_check(void) {
    cprintf("\n=== buddy_check start ===\n");
    cprintf("total free pages: %u\n", (unsigned)nr_buddy_free_pages);
    cprintf("buddy_size (leaves): %u, node_count: %u\n", buddy_size, buddy_node_count);

    cprintf("\nInitial buddy tree:\n");
    print_buddy_summary();

    // 测试分配请求
    unsigned test_sizes[] = {1, 2, 3, 7, 16, 64};
    const unsigned test_count = sizeof(test_sizes) / sizeof(test_sizes[0]);
    struct Page *allocated[test_count];
    memset(allocated, 0, sizeof(allocated));

    cprintf("\n--- Allocation phase ---\n");
    for (unsigned i = 0; i < test_count; i++) {
        unsigned req = test_sizes[i];
        cprintf("[alloc] request %u pages\n", req);
        struct Page *p = buddy_alloc_pages(req);
        if (!p) {
            cprintf("  -> FAILED (free=%u)\n", (unsigned)nr_buddy_free_pages);
        } else {
            unsigned actual = 1;
            while (PageReserved(p + actual)) actual++;
            allocated[i] = p;
            print_page_range(p, actual);
            cprintf("  free after alloc: %u\n", (unsigned)nr_buddy_free_pages);
        }
    }

    cprintf("\nBuddy tree after allocations:\n");
    print_buddy_summary();

    // 测试超分配
    cprintf("\n[alloc] over-allocation test:\n");
    unsigned want = (unsigned)nr_buddy_free_pages + 10;
    struct Page *po = buddy_alloc_pages(want);
    if (!po)
        cprintf("  -> correctly failed when requesting %u pages\n", want);
    else {
        cprintf("  -> UNEXPECTED success! freeing...\n");
        buddy_free_pages(po, want);
    }

    struct Page *p01 = buddy_alloc_pages(8194);
    if (!p01)
        cprintf("  -> correctly failed when requesting 8194 pages\n");
    else {
        cprintf("  -> UNEXPECTED success! freeing...\n");
        buddy_free_pages(p01, 8194);
    }

    // 释放
    cprintf("\n--- Free phase ---\n");
    for (int i = test_count - 1; i >= 0; i--) {
        if (!allocated[i]) continue;
        unsigned actual = 1;
        while (PageReserved(allocated[i] + actual)) actual++;
        cprintf("[free] %u pages at %p\n", actual, page2pa(allocated[i]));
        buddy_free_pages(allocated[i], actual);
        cprintf("  free after free: %u\n", (unsigned)nr_buddy_free_pages);
        print_buddy_summary();
    }

    cprintf("\nBuddy tree after all frees:\n");
    print_buddy_summary();

    cprintf("=== buddy_check nosort ===\n\n");
    struct Page *p1 = buddy_alloc_pages(3);
    struct Page *p2 =buddy_alloc_pages(98);
    struct Page *p3 =buddy_alloc_pages(3);
    buddy_free_pages(p3,3);
    buddy_free_pages(p2,98);
    struct Page *p4 =buddy_alloc_pages(100);
    struct Page *p5 =buddy_alloc_pages(1);
    buddy_free_pages(p5,1);
    buddy_free_pages(p4,100);
    struct Page *p6 =buddy_alloc_pages(1086);
    buddy_free_pages(p1,3);
    buddy_free_pages(p6,1086);    
    cprintf("Buddy tree after nosort test:\n");
    print_buddy_summary();
    cprintf("=== buddy_check nosort end ===\n\n");

    cprintf("=== buddy_check end ===\n\n");
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
