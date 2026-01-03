#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <kdebug.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>
#include <intr.h>
#include <pmm.h>
#include <dtb.h>
#include <vmm.h>
#include <ide.h>
#include <proc.h>
#include <kmonitor.h>
#include <fs.h>

int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    cons_init(); // init the console

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);

    print_kerninfo();

    // grade_backtrace();

    dtb_init(); // init dtb
    pmm_init(); // init physical memory management

    pic_init(); // init interrupt controller
    idt_init(); // init interrupt descriptor table，中断描述符表和状态寄存器

    vmm_init(); // init virtual memory management，虚拟内存管理
    sched_init();// lab6新增，完成调度器和特定调度算法的绑定。
    proc_init(); // init process table，lab6对进程初始化有修改吗

    ide_init(); // init ide devices

    clock_init();  // init clock interrupt
    fs_init();// lab8的文件管理系统初始化
    intr_enable(); // enable irq interrupt，允许中断

    cpu_idle(); // run idle process
}


