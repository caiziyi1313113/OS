#ifndef __KERN_FS_SWAP_SWAPFS_H__
#define __KERN_FS_SWAP_SWAPFS_H__

#include <memlayout.h>
#include <mmu.h>

// swap_offset新增
// 从 swap_entry_t 里取出“交换区页号/偏移”。
static inline size_t swap_offset(swap_entry_t entry)
{
    return (size_t)(entry >> PTE_PPN_SHIFT);
}

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct Page *page);
int swapfs_write(swap_entry_t entry, struct Page *page);

#endif /* !__KERN_FS_SWAP_SWAPFS_H__ */
