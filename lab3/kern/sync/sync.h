#ifndef __KERN_SYNC_SYNC_H__
#define __KERN_SYNC_SYNC_H__

#include <defs.h>
#include <intr.h>
#include <riscv.h>

//1、屏蔽中断

//读取控制状态寄存器sstatus
//检查中断使能位SIE是否被设置
//如果设置了SIE，表示中断是启用的
//调用intr_disable()函数禁用中断
//返回1，表示之前中断是启用的
//如果SIE没有被设置，表示中断已经是禁用的
//直接返回0，表示之前中断是禁用的
static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        intr_disable();
        return 1;
    }
    return 0;
}

//2、恢复中断

//根据传入的标志flag决定是否启用中断
//如果flag为真（非零），调用intr_enable()函数启用中断
//如果flag为假（零），不做任何操作，保持中断禁用状态
static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

//3、保存和恢复中断状态的宏定义
//宏只是“文本替换”，没有语法意识。if 只控制第一条语句，后面的就乱套了。
//整个 do{...}while(0); 被 if 当作一条语句处理（当作一个整体）
//主要是为了未来的可扩展性和一致性
#define local_intr_save(x) \
    do {                   \
        x = __intr_save(); \
    } while (0)
#define local_intr_restore(x) __intr_restore(x);

#endif /* !__KERN_SYNC_SYNC_H__ */
