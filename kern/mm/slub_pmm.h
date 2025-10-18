#ifndef __KERN_MM_SLUB_PMM_H__
#define __KERN_MM_SLUB_PMM_H__

#include <defs.h>

// Slub分配器函数接口声明
void kmalloc_init(void);
void *kmalloc(size_t size);
void kfree(void *ptr);

#endif /* !__KERN_MM_SLUB_PMM_H__ */