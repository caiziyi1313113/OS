#include <riscv.h>

    .macro SAVE_ALL

    # 把当前的 栈指针（sp） 保存到 sscratch，之后返回时能恢复原来的栈位置
    csrw sscratch, sp
 
    # 一共要保存 36 个寄存器（32 个通用寄存器 + 4 个 CSR），每个是REGBYTES大小
    # 在当前栈上向下开辟 36 个寄存器大小的空间，用来存放 trapframe
    # sp → 指向 trapframe 底部
    addi sp, sp, -36 * REGBYTES
    # save x registers
    STORE x0, 0*REGBYTES(sp)
    STORE x1, 1*REGBYTES(sp)
    STORE x3, 3*REGBYTES(sp)
    STORE x4, 4*REGBYTES(sp)
    STORE x5, 5*REGBYTES(sp)
    STORE x6, 6*REGBYTES(sp)
    STORE x7, 7*REGBYTES(sp)
    STORE x8, 8*REGBYTES(sp)
    STORE x9, 9*REGBYTES(sp)
    STORE x10, 10*REGBYTES(sp)
    STORE x11, 11*REGBYTES(sp)
    STORE x12, 12*REGBYTES(sp)
    STORE x13, 13*REGBYTES(sp)
    STORE x14, 14*REGBYTES(sp)
    STORE x15, 15*REGBYTES(sp)
    STORE x16, 16*REGBYTES(sp)
    STORE x17, 17*REGBYTES(sp)
    STORE x18, 18*REGBYTES(sp)
    STORE x19, 19*REGBYTES(sp)
    STORE x20, 20*REGBYTES(sp)
    STORE x21, 21*REGBYTES(sp)
    STORE x22, 22*REGBYTES(sp)
    STORE x23, 23*REGBYTES(sp)
    STORE x24, 24*REGBYTES(sp)
    STORE x25, 25*REGBYTES(sp)
    STORE x26, 26*REGBYTES(sp)
    STORE x27, 27*REGBYTES(sp)
    STORE x28, 28*REGBYTES(sp)
    STORE x29, 29*REGBYTES(sp)
    STORE x30, 30*REGBYTES(sp)
    STORE x31, 31*REGBYTES(sp)

    # get sr, epc, badvaddr, cause
    # Set sscratch register to 0, so that if a recursive exception
    # occurs, the exception vector knows it came from the kernel
    # csrrw作用是读写 CSR 寄存器

    #读取 sscratch 的值到 s0，同时把 x0（值为 0）写回 sscratch。
    csrrw s0, sscratch, x0
    # 读取 S 模式状态寄存器 sstatus，包含中断使能位SIE，上次特权级SPP，权限切换状态等
    csrr s1, sstatus
    # 读取 异常返回地址寄存器
    csrr s2, sepc

    #这里有一个寄存器名字的修改
    # 与异常相关的“附加信息”
    # 如果是指令异常：保存出错的指令地址；果是访存异常：保存出错的虚拟地址；如果是非法指令：保存触发的非法指令本身
    csrr s3, stval
    # 读取异常原因寄存器，最高位是0，是异常，最高位是1，是中断！
    csrr s4, scause

    # 保存这些 存储着CSR 寄存器值的寄存器到 trapframe
    # 所以目前sp指向的是trapframe 底部
    STORE s0, 2*REGBYTES(sp)
    STORE s1, 32*REGBYTES(sp)
    STORE s2, 33*REGBYTES(sp)
    STORE s3, 34*REGBYTES(sp)
    STORE s4, 35*REGBYTES(sp)
    .endm

    .macro RESTORE_ALL

    LOAD s1, 32*REGBYTES(sp)
    LOAD s2, 33*REGBYTES(sp)

    csrw sstatus, s1
    csrw sepc, s2

    # restore x registers
    LOAD x1, 1*REGBYTES(sp)
    LOAD x3, 3*REGBYTES(sp)
    LOAD x4, 4*REGBYTES(sp)
    LOAD x5, 5*REGBYTES(sp)
    LOAD x6, 6*REGBYTES(sp)
    LOAD x7, 7*REGBYTES(sp)
    LOAD x8, 8*REGBYTES(sp)
    LOAD x9, 9*REGBYTES(sp)
    LOAD x10, 10*REGBYTES(sp)
    LOAD x11, 11*REGBYTES(sp)
    LOAD x12, 12*REGBYTES(sp)
    LOAD x13, 13*REGBYTES(sp)
    LOAD x14, 14*REGBYTES(sp)
    LOAD x15, 15*REGBYTES(sp)
    LOAD x16, 16*REGBYTES(sp)
    LOAD x17, 17*REGBYTES(sp)
    LOAD x18, 18*REGBYTES(sp)
    LOAD x19, 19*REGBYTES(sp)
    LOAD x20, 20*REGBYTES(sp)
    LOAD x21, 21*REGBYTES(sp)
    LOAD x22, 22*REGBYTES(sp)
    LOAD x23, 23*REGBYTES(sp)
    LOAD x24, 24*REGBYTES(sp)
    LOAD x25, 25*REGBYTES(sp)
    LOAD x26, 26*REGBYTES(sp)
    LOAD x27, 27*REGBYTES(sp)
    LOAD x28, 28*REGBYTES(sp)
    LOAD x29, 29*REGBYTES(sp)
    LOAD x30, 30*REGBYTES(sp)
    LOAD x31, 31*REGBYTES(sp)
    # restore sp last
    # 最后恢复 sp，x2中存储上下文切换前栈帧顶部位置
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL

    move  a0, sp
    # jr和jal不同，此处返回跳转处
    jal trap
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
    # return from supervisor call
    # 执行 sret：CPU 从 sepc 返回到异常前的指令处， sp 回到原来的栈位置，恢复之前的状态
    sret
