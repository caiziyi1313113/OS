#ifndef __KERN_MM_SLUB_PMM_H__
#define __KERN_MM_SLUB_PMM_H__

#include <defs.h>
#include <mmu.h>
#include <list.h>

// SLUB分配器相关常量定义
#define KMALLOC_MAX_SHIFT (PGSHIFT - 1) // 对于4KB页面，最大对象大小是2KB
#define KMALLOC_MIN_SHIFT 3             // 最小对象大小是8字节

// 前向声明
struct kmem_cache;

// Slub分配器函数接口声明
void kmalloc_init(void);
void *kmalloc(size_t size);
void kfree(void *ptr);

// 测试辅助函数声明（仅用于测试）
struct kmem_cache *get_kmalloc_cache(size_t index);
size_t get_cache_objects_per_slab(struct kmem_cache *cache);
bool is_list_empty_slabs_full(struct kmem_cache *cache);
bool is_list_empty_slabs_partial(struct kmem_cache *cache);
bool is_list_empty_slabs_free(struct kmem_cache *cache);

#endif /* !__KERN_MM_SLUB_PMM_H__ */