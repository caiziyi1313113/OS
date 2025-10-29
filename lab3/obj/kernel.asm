
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00006297          	auipc	t0,0x6
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0206000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00006297          	auipc	t0,0x6
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0206008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02052b7          	lui	t0,0xc0205
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0205337          	lui	t1,0xc0205
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <kern_init>:
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
ffffffffc0200054:	00006517          	auipc	a0,0x6
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0206028 <free_area>
ffffffffc020005c:	00006617          	auipc	a2,0x6
ffffffffc0200060:	44460613          	addi	a2,a2,1092 # ffffffffc02064a0 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16 # ffffffffc0204ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	64f010ef          	jal	ffffffffc0201eba <memset>
    dtb_init();
ffffffffc0200070:	3c2000ef          	jal	ffffffffc0200432 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	3b0000ef          	jal	ffffffffc0200424 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	e5850513          	addi	a0,a0,-424 # ffffffffc0201ed0 <etext+0x4>
ffffffffc0200080:	088000ef          	jal	ffffffffc0200108 <cputs>

    print_kerninfo();
ffffffffc0200084:	0e0000ef          	jal	ffffffffc0200164 <print_kerninfo>

    // grade_backtrace();
    //idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management
ffffffffc0200088:	6c8010ef          	jal	ffffffffc0201750 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020008c:	6f8000ef          	jal	ffffffffc0200784 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200090:	352000ef          	jal	ffffffffc02003e2 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200094:	6e4000ef          	jal	ffffffffc0200778 <intr_enable>

    /* do nothing */
    while (1)
ffffffffc0200098:	a001                	j	ffffffffc0200098 <kern_init+0x44>

ffffffffc020009a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	ec06                	sd	ra,24(sp)
ffffffffc020009e:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc02000a0:	386000ef          	jal	ffffffffc0200426 <cons_putc>
    (*cnt) ++;
ffffffffc02000a4:	65a2                	ld	a1,8(sp)
}
ffffffffc02000a6:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc02000a8:	419c                	lw	a5,0(a1)
ffffffffc02000aa:	2785                	addiw	a5,a5,1
ffffffffc02000ac:	c19c                	sw	a5,0(a1)
}
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000b2:	1101                	addi	sp,sp,-32
ffffffffc02000b4:	862a                	mv	a2,a0
ffffffffc02000b6:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000b8:	00000517          	auipc	a0,0x0
ffffffffc02000bc:	fe250513          	addi	a0,a0,-30 # ffffffffc020009a <cputch>
ffffffffc02000c0:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000c2:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000c4:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c6:	0cd010ef          	jal	ffffffffc0201992 <vprintfmt>
    return cnt;
}
ffffffffc02000ca:	60e2                	ld	ra,24(sp)
ffffffffc02000cc:	4532                	lw	a0,12(sp)
ffffffffc02000ce:	6105                	addi	sp,sp,32
ffffffffc02000d0:	8082                	ret

ffffffffc02000d2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000d2:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000d4:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc02000d8:	f42e                	sd	a1,40(sp)
ffffffffc02000da:	f832                	sd	a2,48(sp)
ffffffffc02000dc:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000de:	862a                	mv	a2,a0
ffffffffc02000e0:	004c                	addi	a1,sp,4
ffffffffc02000e2:	00000517          	auipc	a0,0x0
ffffffffc02000e6:	fb850513          	addi	a0,a0,-72 # ffffffffc020009a <cputch>
ffffffffc02000ea:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc02000ec:	ec06                	sd	ra,24(sp)
ffffffffc02000ee:	e0ba                	sd	a4,64(sp)
ffffffffc02000f0:	e4be                	sd	a5,72(sp)
ffffffffc02000f2:	e8c2                	sd	a6,80(sp)
ffffffffc02000f4:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02000f6:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02000f8:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000fa:	099010ef          	jal	ffffffffc0201992 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000fe:	60e2                	ld	ra,24(sp)
ffffffffc0200100:	4512                	lw	a0,4(sp)
ffffffffc0200102:	6125                	addi	sp,sp,96
ffffffffc0200104:	8082                	ret

ffffffffc0200106 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200106:	a605                	j	ffffffffc0200426 <cons_putc>

ffffffffc0200108 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200108:	1101                	addi	sp,sp,-32
ffffffffc020010a:	e822                	sd	s0,16(sp)
ffffffffc020010c:	ec06                	sd	ra,24(sp)
ffffffffc020010e:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200110:	00054503          	lbu	a0,0(a0)
ffffffffc0200114:	c51d                	beqz	a0,ffffffffc0200142 <cputs+0x3a>
ffffffffc0200116:	e426                	sd	s1,8(sp)
ffffffffc0200118:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020011a:	4481                	li	s1,0
    cons_putc(c);
ffffffffc020011c:	30a000ef          	jal	ffffffffc0200426 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200120:	00044503          	lbu	a0,0(s0)
ffffffffc0200124:	0405                	addi	s0,s0,1
ffffffffc0200126:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc0200128:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020012a:	f96d                	bnez	a0,ffffffffc020011c <cputs+0x14>
    cons_putc(c);
ffffffffc020012c:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc020012e:	0027841b          	addiw	s0,a5,2
ffffffffc0200132:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc0200134:	2f2000ef          	jal	ffffffffc0200426 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200138:	60e2                	ld	ra,24(sp)
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	6442                	ld	s0,16(sp)
ffffffffc020013e:	6105                	addi	sp,sp,32
ffffffffc0200140:	8082                	ret
    cons_putc(c);
ffffffffc0200142:	4529                	li	a0,10
ffffffffc0200144:	2e2000ef          	jal	ffffffffc0200426 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200148:	4405                	li	s0,1
}
ffffffffc020014a:	60e2                	ld	ra,24(sp)
ffffffffc020014c:	8522                	mv	a0,s0
ffffffffc020014e:	6442                	ld	s0,16(sp)
ffffffffc0200150:	6105                	addi	sp,sp,32
ffffffffc0200152:	8082                	ret

ffffffffc0200154 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200154:	1141                	addi	sp,sp,-16
ffffffffc0200156:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200158:	2d6000ef          	jal	ffffffffc020042e <cons_getc>
ffffffffc020015c:	dd75                	beqz	a0,ffffffffc0200158 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020015e:	60a2                	ld	ra,8(sp)
ffffffffc0200160:	0141                	addi	sp,sp,16
ffffffffc0200162:	8082                	ret

ffffffffc0200164 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200164:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200166:	00002517          	auipc	a0,0x2
ffffffffc020016a:	d8a50513          	addi	a0,a0,-630 # ffffffffc0201ef0 <etext+0x24>
void print_kerninfo(void) {
ffffffffc020016e:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200170:	f63ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc0200174:	00000597          	auipc	a1,0x0
ffffffffc0200178:	ee058593          	addi	a1,a1,-288 # ffffffffc0200054 <kern_init>
ffffffffc020017c:	00002517          	auipc	a0,0x2
ffffffffc0200180:	d9450513          	addi	a0,a0,-620 # ffffffffc0201f10 <etext+0x44>
ffffffffc0200184:	f4fff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc0200188:	00002597          	auipc	a1,0x2
ffffffffc020018c:	d4458593          	addi	a1,a1,-700 # ffffffffc0201ecc <etext>
ffffffffc0200190:	00002517          	auipc	a0,0x2
ffffffffc0200194:	da050513          	addi	a0,a0,-608 # ffffffffc0201f30 <etext+0x64>
ffffffffc0200198:	f3bff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc020019c:	00006597          	auipc	a1,0x6
ffffffffc02001a0:	e8c58593          	addi	a1,a1,-372 # ffffffffc0206028 <free_area>
ffffffffc02001a4:	00002517          	auipc	a0,0x2
ffffffffc02001a8:	dac50513          	addi	a0,a0,-596 # ffffffffc0201f50 <etext+0x84>
ffffffffc02001ac:	f27ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001b0:	00006597          	auipc	a1,0x6
ffffffffc02001b4:	2f058593          	addi	a1,a1,752 # ffffffffc02064a0 <end>
ffffffffc02001b8:	00002517          	auipc	a0,0x2
ffffffffc02001bc:	db850513          	addi	a0,a0,-584 # ffffffffc0201f70 <etext+0xa4>
ffffffffc02001c0:	f13ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001c4:	00000717          	auipc	a4,0x0
ffffffffc02001c8:	e9070713          	addi	a4,a4,-368 # ffffffffc0200054 <kern_init>
ffffffffc02001cc:	00006797          	auipc	a5,0x6
ffffffffc02001d0:	6d378793          	addi	a5,a5,1747 # ffffffffc020689f <end+0x3ff>
ffffffffc02001d4:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d6:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001da:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001dc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001e0:	95be                	add	a1,a1,a5
ffffffffc02001e2:	85a9                	srai	a1,a1,0xa
ffffffffc02001e4:	00002517          	auipc	a0,0x2
ffffffffc02001e8:	dac50513          	addi	a0,a0,-596 # ffffffffc0201f90 <etext+0xc4>
}
ffffffffc02001ec:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ee:	b5d5                	j	ffffffffc02000d2 <cprintf>

ffffffffc02001f0 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001f0:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02001f2:	00002617          	auipc	a2,0x2
ffffffffc02001f6:	dce60613          	addi	a2,a2,-562 # ffffffffc0201fc0 <etext+0xf4>
ffffffffc02001fa:	04d00593          	li	a1,77
ffffffffc02001fe:	00002517          	auipc	a0,0x2
ffffffffc0200202:	dda50513          	addi	a0,a0,-550 # ffffffffc0201fd8 <etext+0x10c>
void print_stackframe(void) {
ffffffffc0200206:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200208:	17c000ef          	jal	ffffffffc0200384 <__panic>

ffffffffc020020c <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020020c:	1101                	addi	sp,sp,-32
ffffffffc020020e:	e822                	sd	s0,16(sp)
ffffffffc0200210:	e426                	sd	s1,8(sp)
ffffffffc0200212:	ec06                	sd	ra,24(sp)
ffffffffc0200214:	00003417          	auipc	s0,0x3
ffffffffc0200218:	aac40413          	addi	s0,s0,-1364 # ffffffffc0202cc0 <commands>
ffffffffc020021c:	00003497          	auipc	s1,0x3
ffffffffc0200220:	aec48493          	addi	s1,s1,-1300 # ffffffffc0202d08 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200224:	6410                	ld	a2,8(s0)
ffffffffc0200226:	600c                	ld	a1,0(s0)
ffffffffc0200228:	00002517          	auipc	a0,0x2
ffffffffc020022c:	dc850513          	addi	a0,a0,-568 # ffffffffc0201ff0 <etext+0x124>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200230:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200232:	ea1ff0ef          	jal	ffffffffc02000d2 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200236:	fe9417e3          	bne	s0,s1,ffffffffc0200224 <mon_help+0x18>
    }
    return 0;
}
ffffffffc020023a:	60e2                	ld	ra,24(sp)
ffffffffc020023c:	6442                	ld	s0,16(sp)
ffffffffc020023e:	64a2                	ld	s1,8(sp)
ffffffffc0200240:	4501                	li	a0,0
ffffffffc0200242:	6105                	addi	sp,sp,32
ffffffffc0200244:	8082                	ret

ffffffffc0200246 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200246:	1141                	addi	sp,sp,-16
ffffffffc0200248:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020024a:	f1bff0ef          	jal	ffffffffc0200164 <print_kerninfo>
    return 0;
}
ffffffffc020024e:	60a2                	ld	ra,8(sp)
ffffffffc0200250:	4501                	li	a0,0
ffffffffc0200252:	0141                	addi	sp,sp,16
ffffffffc0200254:	8082                	ret

ffffffffc0200256 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200256:	1141                	addi	sp,sp,-16
ffffffffc0200258:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020025a:	f97ff0ef          	jal	ffffffffc02001f0 <print_stackframe>
    return 0;
}
ffffffffc020025e:	60a2                	ld	ra,8(sp)
ffffffffc0200260:	4501                	li	a0,0
ffffffffc0200262:	0141                	addi	sp,sp,16
ffffffffc0200264:	8082                	ret

ffffffffc0200266 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200266:	7131                	addi	sp,sp,-192
ffffffffc0200268:	e952                	sd	s4,144(sp)
ffffffffc020026a:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020026c:	00002517          	auipc	a0,0x2
ffffffffc0200270:	d9450513          	addi	a0,a0,-620 # ffffffffc0202000 <etext+0x134>
kmonitor(struct trapframe *tf) {
ffffffffc0200274:	fd06                	sd	ra,184(sp)
ffffffffc0200276:	f922                	sd	s0,176(sp)
ffffffffc0200278:	f526                	sd	s1,168(sp)
ffffffffc020027a:	ed4e                	sd	s3,152(sp)
ffffffffc020027c:	e556                	sd	s5,136(sp)
ffffffffc020027e:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200280:	e53ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200284:	00002517          	auipc	a0,0x2
ffffffffc0200288:	da450513          	addi	a0,a0,-604 # ffffffffc0202028 <etext+0x15c>
ffffffffc020028c:	e47ff0ef          	jal	ffffffffc02000d2 <cprintf>
    if (tf != NULL) {
ffffffffc0200290:	000a0563          	beqz	s4,ffffffffc020029a <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200294:	8552                	mv	a0,s4
ffffffffc0200296:	6ce000ef          	jal	ffffffffc0200964 <print_trapframe>
ffffffffc020029a:	00003a97          	auipc	s5,0x3
ffffffffc020029e:	a26a8a93          	addi	s5,s5,-1498 # ffffffffc0202cc0 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc02002a2:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002a4:	00002517          	auipc	a0,0x2
ffffffffc02002a8:	dac50513          	addi	a0,a0,-596 # ffffffffc0202050 <etext+0x184>
ffffffffc02002ac:	24d010ef          	jal	ffffffffc0201cf8 <readline>
ffffffffc02002b0:	842a                	mv	s0,a0
ffffffffc02002b2:	d96d                	beqz	a0,ffffffffc02002a4 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002b4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002b8:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002ba:	e99d                	bnez	a1,ffffffffc02002f0 <kmonitor+0x8a>
    int argc = 0;
ffffffffc02002bc:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc02002be:	fe0b03e3          	beqz	s6,ffffffffc02002a4 <kmonitor+0x3e>
ffffffffc02002c2:	00003497          	auipc	s1,0x3
ffffffffc02002c6:	9fe48493          	addi	s1,s1,-1538 # ffffffffc0202cc0 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ca:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002cc:	6582                	ld	a1,0(sp)
ffffffffc02002ce:	6088                	ld	a0,0(s1)
ffffffffc02002d0:	37d010ef          	jal	ffffffffc0201e4c <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002d4:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002d6:	c149                	beqz	a0,ffffffffc0200358 <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002d8:	2405                	addiw	s0,s0,1
ffffffffc02002da:	04e1                	addi	s1,s1,24
ffffffffc02002dc:	fef418e3          	bne	s0,a5,ffffffffc02002cc <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02002e0:	6582                	ld	a1,0(sp)
ffffffffc02002e2:	00002517          	auipc	a0,0x2
ffffffffc02002e6:	d9e50513          	addi	a0,a0,-610 # ffffffffc0202080 <etext+0x1b4>
ffffffffc02002ea:	de9ff0ef          	jal	ffffffffc02000d2 <cprintf>
    return 0;
ffffffffc02002ee:	bf5d                	j	ffffffffc02002a4 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002f0:	00002517          	auipc	a0,0x2
ffffffffc02002f4:	d6850513          	addi	a0,a0,-664 # ffffffffc0202058 <etext+0x18c>
ffffffffc02002f8:	3b1010ef          	jal	ffffffffc0201ea8 <strchr>
ffffffffc02002fc:	c901                	beqz	a0,ffffffffc020030c <kmonitor+0xa6>
ffffffffc02002fe:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200302:	00040023          	sb	zero,0(s0)
ffffffffc0200306:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200308:	d9d5                	beqz	a1,ffffffffc02002bc <kmonitor+0x56>
ffffffffc020030a:	b7dd                	j	ffffffffc02002f0 <kmonitor+0x8a>
        if (*buf == '\0') {
ffffffffc020030c:	00044783          	lbu	a5,0(s0)
ffffffffc0200310:	d7d5                	beqz	a5,ffffffffc02002bc <kmonitor+0x56>
        if (argc == MAXARGS - 1) {
ffffffffc0200312:	03348b63          	beq	s1,s3,ffffffffc0200348 <kmonitor+0xe2>
        argv[argc ++] = buf;
ffffffffc0200316:	00349793          	slli	a5,s1,0x3
ffffffffc020031a:	978a                	add	a5,a5,sp
ffffffffc020031c:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020031e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200322:	2485                	addiw	s1,s1,1
ffffffffc0200324:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200326:	e591                	bnez	a1,ffffffffc0200332 <kmonitor+0xcc>
ffffffffc0200328:	bf59                	j	ffffffffc02002be <kmonitor+0x58>
ffffffffc020032a:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020032e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200330:	d5d1                	beqz	a1,ffffffffc02002bc <kmonitor+0x56>
ffffffffc0200332:	00002517          	auipc	a0,0x2
ffffffffc0200336:	d2650513          	addi	a0,a0,-730 # ffffffffc0202058 <etext+0x18c>
ffffffffc020033a:	36f010ef          	jal	ffffffffc0201ea8 <strchr>
ffffffffc020033e:	d575                	beqz	a0,ffffffffc020032a <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200340:	00044583          	lbu	a1,0(s0)
ffffffffc0200344:	dda5                	beqz	a1,ffffffffc02002bc <kmonitor+0x56>
ffffffffc0200346:	b76d                	j	ffffffffc02002f0 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200348:	45c1                	li	a1,16
ffffffffc020034a:	00002517          	auipc	a0,0x2
ffffffffc020034e:	d1650513          	addi	a0,a0,-746 # ffffffffc0202060 <etext+0x194>
ffffffffc0200352:	d81ff0ef          	jal	ffffffffc02000d2 <cprintf>
ffffffffc0200356:	b7c1                	j	ffffffffc0200316 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200358:	00141793          	slli	a5,s0,0x1
ffffffffc020035c:	97a2                	add	a5,a5,s0
ffffffffc020035e:	078e                	slli	a5,a5,0x3
ffffffffc0200360:	97d6                	add	a5,a5,s5
ffffffffc0200362:	6b9c                	ld	a5,16(a5)
ffffffffc0200364:	fffb051b          	addiw	a0,s6,-1
ffffffffc0200368:	8652                	mv	a2,s4
ffffffffc020036a:	002c                	addi	a1,sp,8
ffffffffc020036c:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020036e:	f2055be3          	bgez	a0,ffffffffc02002a4 <kmonitor+0x3e>
}
ffffffffc0200372:	70ea                	ld	ra,184(sp)
ffffffffc0200374:	744a                	ld	s0,176(sp)
ffffffffc0200376:	74aa                	ld	s1,168(sp)
ffffffffc0200378:	69ea                	ld	s3,152(sp)
ffffffffc020037a:	6a4a                	ld	s4,144(sp)
ffffffffc020037c:	6aaa                	ld	s5,136(sp)
ffffffffc020037e:	6b0a                	ld	s6,128(sp)
ffffffffc0200380:	6129                	addi	sp,sp,192
ffffffffc0200382:	8082                	ret

ffffffffc0200384 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200384:	00006317          	auipc	t1,0x6
ffffffffc0200388:	0bc32303          	lw	t1,188(t1) # ffffffffc0206440 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020038c:	715d                	addi	sp,sp,-80
ffffffffc020038e:	ec06                	sd	ra,24(sp)
ffffffffc0200390:	f436                	sd	a3,40(sp)
ffffffffc0200392:	f83a                	sd	a4,48(sp)
ffffffffc0200394:	fc3e                	sd	a5,56(sp)
ffffffffc0200396:	e0c2                	sd	a6,64(sp)
ffffffffc0200398:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020039a:	02031e63          	bnez	t1,ffffffffc02003d6 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020039e:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003a0:	103c                	addi	a5,sp,40
ffffffffc02003a2:	e822                	sd	s0,16(sp)
ffffffffc02003a4:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003a6:	862e                	mv	a2,a1
ffffffffc02003a8:	85aa                	mv	a1,a0
ffffffffc02003aa:	00002517          	auipc	a0,0x2
ffffffffc02003ae:	d7e50513          	addi	a0,a0,-642 # ffffffffc0202128 <etext+0x25c>
    is_panic = 1;
ffffffffc02003b2:	00006697          	auipc	a3,0x6
ffffffffc02003b6:	08e6a723          	sw	a4,142(a3) # ffffffffc0206440 <is_panic>
    va_start(ap, fmt);
ffffffffc02003ba:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003bc:	d17ff0ef          	jal	ffffffffc02000d2 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003c0:	65a2                	ld	a1,8(sp)
ffffffffc02003c2:	8522                	mv	a0,s0
ffffffffc02003c4:	cefff0ef          	jal	ffffffffc02000b2 <vcprintf>
    cprintf("\n");
ffffffffc02003c8:	00002517          	auipc	a0,0x2
ffffffffc02003cc:	d8050513          	addi	a0,a0,-640 # ffffffffc0202148 <etext+0x27c>
ffffffffc02003d0:	d03ff0ef          	jal	ffffffffc02000d2 <cprintf>
ffffffffc02003d4:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02003d6:	3a8000ef          	jal	ffffffffc020077e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02003da:	4501                	li	a0,0
ffffffffc02003dc:	e8bff0ef          	jal	ffffffffc0200266 <kmonitor>
    while (1) {
ffffffffc02003e0:	bfed                	j	ffffffffc02003da <__panic+0x56>

ffffffffc02003e2 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc02003e2:	1141                	addi	sp,sp,-16
ffffffffc02003e4:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc02003e6:	02000793          	li	a5,32
ffffffffc02003ea:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02003ee:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02003f2:	67e1                	lui	a5,0x18
ffffffffc02003f4:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02003f8:	953e                	add	a0,a0,a5
ffffffffc02003fa:	1cf010ef          	jal	ffffffffc0201dc8 <sbi_set_timer>
}
ffffffffc02003fe:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200400:	00006797          	auipc	a5,0x6
ffffffffc0200404:	0407b423          	sd	zero,72(a5) # ffffffffc0206448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200408:	00002517          	auipc	a0,0x2
ffffffffc020040c:	d4850513          	addi	a0,a0,-696 # ffffffffc0202150 <etext+0x284>
}
ffffffffc0200410:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200412:	b1c1                	j	ffffffffc02000d2 <cprintf>

ffffffffc0200414 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200414:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	1a90106f          	j	ffffffffc0201dc8 <sbi_set_timer>

ffffffffc0200424 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200424:	8082                	ret

ffffffffc0200426 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200426:	0ff57513          	zext.b	a0,a0
ffffffffc020042a:	1850106f          	j	ffffffffc0201dae <sbi_console_putchar>

ffffffffc020042e <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc020042e:	1b50106f          	j	ffffffffc0201de2 <sbi_console_getchar>

ffffffffc0200432 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200432:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc0200434:	00002517          	auipc	a0,0x2
ffffffffc0200438:	d3c50513          	addi	a0,a0,-708 # ffffffffc0202170 <etext+0x2a4>
void dtb_init(void) {
ffffffffc020043c:	f406                	sd	ra,40(sp)
ffffffffc020043e:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200440:	c93ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200444:	00006597          	auipc	a1,0x6
ffffffffc0200448:	bbc5b583          	ld	a1,-1092(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc020044c:	00002517          	auipc	a0,0x2
ffffffffc0200450:	d3450513          	addi	a0,a0,-716 # ffffffffc0202180 <etext+0x2b4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200454:	00006417          	auipc	s0,0x6
ffffffffc0200458:	bb440413          	addi	s0,s0,-1100 # ffffffffc0206008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020045c:	c77ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200460:	600c                	ld	a1,0(s0)
ffffffffc0200462:	00002517          	auipc	a0,0x2
ffffffffc0200466:	d2e50513          	addi	a0,a0,-722 # ffffffffc0202190 <etext+0x2c4>
ffffffffc020046a:	c69ff0ef          	jal	ffffffffc02000d2 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020046e:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200470:	00002517          	auipc	a0,0x2
ffffffffc0200474:	d3850513          	addi	a0,a0,-712 # ffffffffc02021a8 <etext+0x2dc>
    if (boot_dtb == 0) {
ffffffffc0200478:	10070163          	beqz	a4,ffffffffc020057a <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020047c:	57f5                	li	a5,-3
ffffffffc020047e:	07fa                	slli	a5,a5,0x1e
ffffffffc0200480:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200482:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc0200484:	d00e06b7          	lui	a3,0xd00e0
ffffffffc0200488:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed9a4d>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020048c:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200490:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200494:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200498:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020049c:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004a0:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a2:	8e49                	or	a2,a2,a0
ffffffffc02004a4:	0ff7f793          	zext.b	a5,a5
ffffffffc02004a8:	8dd1                	or	a1,a1,a2
ffffffffc02004aa:	07a2                	slli	a5,a5,0x8
ffffffffc02004ac:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ae:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02004b2:	0cd59863          	bne	a1,a3,ffffffffc0200582 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02004b6:	4710                	lw	a2,8(a4)
ffffffffc02004b8:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02004ba:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004bc:	0086541b          	srliw	s0,a2,0x8
ffffffffc02004c0:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02004c8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004cc:	0186151b          	slliw	a0,a2,0x18
ffffffffc02004d0:	0186959b          	slliw	a1,a3,0x18
ffffffffc02004d4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004dc:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e0:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02004e4:	01c56533          	or	a0,a0,t3
ffffffffc02004e8:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ec:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f0:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f4:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f8:	0ff6f693          	zext.b	a3,a3
ffffffffc02004fc:	8c49                	or	s0,s0,a0
ffffffffc02004fe:	0622                	slli	a2,a2,0x8
ffffffffc0200500:	8fcd                	or	a5,a5,a1
ffffffffc0200502:	06a2                	slli	a3,a3,0x8
ffffffffc0200504:	8c51                	or	s0,s0,a2
ffffffffc0200506:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200508:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020050a:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020050c:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020050e:	9381                	srli	a5,a5,0x20
ffffffffc0200510:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200512:	4301                	li	t1,0
        switch (token) {
ffffffffc0200514:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200516:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200518:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc020051c:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020051e:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200520:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200524:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200528:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052c:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200530:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200534:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200538:	8ed1                	or	a3,a3,a2
ffffffffc020053a:	0ff77713          	zext.b	a4,a4
ffffffffc020053e:	8fd5                	or	a5,a5,a3
ffffffffc0200540:	0722                	slli	a4,a4,0x8
ffffffffc0200542:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc0200544:	05178763          	beq	a5,a7,ffffffffc0200592 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200548:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc020054a:	00f8e963          	bltu	a7,a5,ffffffffc020055c <dtb_init+0x12a>
ffffffffc020054e:	07c78d63          	beq	a5,t3,ffffffffc02005c8 <dtb_init+0x196>
ffffffffc0200552:	4709                	li	a4,2
ffffffffc0200554:	00e79763          	bne	a5,a4,ffffffffc0200562 <dtb_init+0x130>
ffffffffc0200558:	4301                	li	t1,0
ffffffffc020055a:	b7d1                	j	ffffffffc020051e <dtb_init+0xec>
ffffffffc020055c:	4711                	li	a4,4
ffffffffc020055e:	fce780e3          	beq	a5,a4,ffffffffc020051e <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200562:	00002517          	auipc	a0,0x2
ffffffffc0200566:	d0e50513          	addi	a0,a0,-754 # ffffffffc0202270 <etext+0x3a4>
ffffffffc020056a:	b69ff0ef          	jal	ffffffffc02000d2 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020056e:	64e2                	ld	s1,24(sp)
ffffffffc0200570:	6942                	ld	s2,16(sp)
ffffffffc0200572:	00002517          	auipc	a0,0x2
ffffffffc0200576:	d3650513          	addi	a0,a0,-714 # ffffffffc02022a8 <etext+0x3dc>
}
ffffffffc020057a:	7402                	ld	s0,32(sp)
ffffffffc020057c:	70a2                	ld	ra,40(sp)
ffffffffc020057e:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200580:	be89                	j	ffffffffc02000d2 <cprintf>
}
ffffffffc0200582:	7402                	ld	s0,32(sp)
ffffffffc0200584:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200586:	00002517          	auipc	a0,0x2
ffffffffc020058a:	c4250513          	addi	a0,a0,-958 # ffffffffc02021c8 <etext+0x2fc>
}
ffffffffc020058e:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200590:	b689                	j	ffffffffc02000d2 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200592:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200594:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200598:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020059c:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a0:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005a4:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a8:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ac:	8ed1                	or	a3,a3,a2
ffffffffc02005ae:	0ff77713          	zext.b	a4,a4
ffffffffc02005b2:	8fd5                	or	a5,a5,a3
ffffffffc02005b4:	0722                	slli	a4,a4,0x8
ffffffffc02005b6:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02005b8:	04031463          	bnez	t1,ffffffffc0200600 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02005bc:	1782                	slli	a5,a5,0x20
ffffffffc02005be:	9381                	srli	a5,a5,0x20
ffffffffc02005c0:	043d                	addi	s0,s0,15
ffffffffc02005c2:	943e                	add	s0,s0,a5
ffffffffc02005c4:	9871                	andi	s0,s0,-4
                break;
ffffffffc02005c6:	bfa1                	j	ffffffffc020051e <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02005c8:	8522                	mv	a0,s0
ffffffffc02005ca:	e01a                	sd	t1,0(sp)
ffffffffc02005cc:	04d010ef          	jal	ffffffffc0201e18 <strlen>
ffffffffc02005d0:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005d2:	4619                	li	a2,6
ffffffffc02005d4:	8522                	mv	a0,s0
ffffffffc02005d6:	00002597          	auipc	a1,0x2
ffffffffc02005da:	c1a58593          	addi	a1,a1,-998 # ffffffffc02021f0 <etext+0x324>
ffffffffc02005de:	0a3010ef          	jal	ffffffffc0201e80 <strncmp>
ffffffffc02005e2:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02005e4:	0411                	addi	s0,s0,4
ffffffffc02005e6:	0004879b          	sext.w	a5,s1
ffffffffc02005ea:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005ec:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02005f0:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005f2:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02005f6:	00ff0837          	lui	a6,0xff0
ffffffffc02005fa:	488d                	li	a7,3
ffffffffc02005fc:	4e05                	li	t3,1
ffffffffc02005fe:	b705                	j	ffffffffc020051e <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200600:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200602:	00002597          	auipc	a1,0x2
ffffffffc0200606:	bf658593          	addi	a1,a1,-1034 # ffffffffc02021f8 <etext+0x32c>
ffffffffc020060a:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020060c:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200610:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200614:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200618:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061c:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200620:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200624:	8ed1                	or	a3,a3,a2
ffffffffc0200626:	0ff77713          	zext.b	a4,a4
ffffffffc020062a:	0722                	slli	a4,a4,0x8
ffffffffc020062c:	8d55                	or	a0,a0,a3
ffffffffc020062e:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200630:	1502                	slli	a0,a0,0x20
ffffffffc0200632:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200634:	954a                	add	a0,a0,s2
ffffffffc0200636:	e01a                	sd	t1,0(sp)
ffffffffc0200638:	015010ef          	jal	ffffffffc0201e4c <strcmp>
ffffffffc020063c:	67a2                	ld	a5,8(sp)
ffffffffc020063e:	473d                	li	a4,15
ffffffffc0200640:	6302                	ld	t1,0(sp)
ffffffffc0200642:	00ff0837          	lui	a6,0xff0
ffffffffc0200646:	488d                	li	a7,3
ffffffffc0200648:	4e05                	li	t3,1
ffffffffc020064a:	f6f779e3          	bgeu	a4,a5,ffffffffc02005bc <dtb_init+0x18a>
ffffffffc020064e:	f53d                	bnez	a0,ffffffffc02005bc <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200650:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200654:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200658:	00002517          	auipc	a0,0x2
ffffffffc020065c:	ba850513          	addi	a0,a0,-1112 # ffffffffc0202200 <etext+0x334>
           fdt32_to_cpu(x >> 32);
ffffffffc0200660:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200664:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200668:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020066c:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200670:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200674:	0187959b          	slliw	a1,a5,0x18
ffffffffc0200678:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067c:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200680:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200684:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200688:	01037333          	and	t1,t1,a6
ffffffffc020068c:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200690:	01e5e5b3          	or	a1,a1,t5
ffffffffc0200694:	0ff7f793          	zext.b	a5,a5
ffffffffc0200698:	01de6e33          	or	t3,t3,t4
ffffffffc020069c:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a0:	01067633          	and	a2,a2,a6
ffffffffc02006a4:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02006a8:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ac:	07a2                	slli	a5,a5,0x8
ffffffffc02006ae:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02006b2:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02006b6:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02006ba:	8ddd                	or	a1,a1,a5
ffffffffc02006bc:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c0:	0186979b          	slliw	a5,a3,0x18
ffffffffc02006c4:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006cc:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d0:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d8:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006dc:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e0:	08a2                	slli	a7,a7,0x8
ffffffffc02006e2:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e6:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ea:	0ff6f693          	zext.b	a3,a3
ffffffffc02006ee:	01de6833          	or	a6,t3,t4
ffffffffc02006f2:	0ff77713          	zext.b	a4,a4
ffffffffc02006f6:	01166633          	or	a2,a2,a7
ffffffffc02006fa:	0067e7b3          	or	a5,a5,t1
ffffffffc02006fe:	06a2                	slli	a3,a3,0x8
ffffffffc0200700:	01046433          	or	s0,s0,a6
ffffffffc0200704:	0722                	slli	a4,a4,0x8
ffffffffc0200706:	8fd5                	or	a5,a5,a3
ffffffffc0200708:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc020070a:	1582                	slli	a1,a1,0x20
ffffffffc020070c:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020070e:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200710:	9201                	srli	a2,a2,0x20
ffffffffc0200712:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200714:	1402                	slli	s0,s0,0x20
ffffffffc0200716:	00b7e4b3          	or	s1,a5,a1
ffffffffc020071a:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc020071c:	9b7ff0ef          	jal	ffffffffc02000d2 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200720:	85a6                	mv	a1,s1
ffffffffc0200722:	00002517          	auipc	a0,0x2
ffffffffc0200726:	afe50513          	addi	a0,a0,-1282 # ffffffffc0202220 <etext+0x354>
ffffffffc020072a:	9a9ff0ef          	jal	ffffffffc02000d2 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020072e:	01445613          	srli	a2,s0,0x14
ffffffffc0200732:	85a2                	mv	a1,s0
ffffffffc0200734:	00002517          	auipc	a0,0x2
ffffffffc0200738:	b0450513          	addi	a0,a0,-1276 # ffffffffc0202238 <etext+0x36c>
ffffffffc020073c:	997ff0ef          	jal	ffffffffc02000d2 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200740:	009405b3          	add	a1,s0,s1
ffffffffc0200744:	15fd                	addi	a1,a1,-1
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	b1250513          	addi	a0,a0,-1262 # ffffffffc0202258 <etext+0x38c>
ffffffffc020074e:	985ff0ef          	jal	ffffffffc02000d2 <cprintf>
        memory_base = mem_base;
ffffffffc0200752:	00006797          	auipc	a5,0x6
ffffffffc0200756:	d097b323          	sd	s1,-762(a5) # ffffffffc0206458 <memory_base>
        memory_size = mem_size;
ffffffffc020075a:	00006797          	auipc	a5,0x6
ffffffffc020075e:	ce87bb23          	sd	s0,-778(a5) # ffffffffc0206450 <memory_size>
ffffffffc0200762:	b531                	j	ffffffffc020056e <dtb_init+0x13c>

ffffffffc0200764 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200764:	00006517          	auipc	a0,0x6
ffffffffc0200768:	cf453503          	ld	a0,-780(a0) # ffffffffc0206458 <memory_base>
ffffffffc020076c:	8082                	ret

ffffffffc020076e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020076e:	00006517          	auipc	a0,0x6
ffffffffc0200772:	ce253503          	ld	a0,-798(a0) # ffffffffc0206450 <memory_size>
ffffffffc0200776:	8082                	ret

ffffffffc0200778 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200778:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020077c:	8082                	ret

ffffffffc020077e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020077e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200782:	8082                	ret

ffffffffc0200784 <idt_init>:

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    //设置sscratch寄存器的值为0，即在内核里出触发trap，不需要存储内核的地址
    write_csr(sscratch, 0);
ffffffffc0200784:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    //设置stvec寄存器，指向异常处理入口函数__alltraps，此处为直接位置，不需要映射
    //！！！！！重要！！！！
    write_csr(stvec, &__alltraps);
ffffffffc0200788:	00000797          	auipc	a5,0x0
ffffffffc020078c:	33c78793          	addi	a5,a5,828 # ffffffffc0200ac4 <__alltraps>
ffffffffc0200790:	10579073          	csrw	stvec,a5
}
ffffffffc0200794:	8082                	ret

ffffffffc0200796 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);//保存与异常有关的附加信息（
    cprintf("  cause    0x%08x\n", tf->cause);//指明陷入原因（中断/异常类型编号）
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200796:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200798:	1141                	addi	sp,sp,-16
ffffffffc020079a:	e022                	sd	s0,0(sp)
ffffffffc020079c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020079e:	00002517          	auipc	a0,0x2
ffffffffc02007a2:	b2250513          	addi	a0,a0,-1246 # ffffffffc02022c0 <etext+0x3f4>
void print_regs(struct pushregs *gpr) {
ffffffffc02007a6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007a8:	92bff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02007ac:	640c                	ld	a1,8(s0)
ffffffffc02007ae:	00002517          	auipc	a0,0x2
ffffffffc02007b2:	b2a50513          	addi	a0,a0,-1238 # ffffffffc02022d8 <etext+0x40c>
ffffffffc02007b6:	91dff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02007ba:	680c                	ld	a1,16(s0)
ffffffffc02007bc:	00002517          	auipc	a0,0x2
ffffffffc02007c0:	b3450513          	addi	a0,a0,-1228 # ffffffffc02022f0 <etext+0x424>
ffffffffc02007c4:	90fff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02007c8:	6c0c                	ld	a1,24(s0)
ffffffffc02007ca:	00002517          	auipc	a0,0x2
ffffffffc02007ce:	b3e50513          	addi	a0,a0,-1218 # ffffffffc0202308 <etext+0x43c>
ffffffffc02007d2:	901ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02007d6:	700c                	ld	a1,32(s0)
ffffffffc02007d8:	00002517          	auipc	a0,0x2
ffffffffc02007dc:	b4850513          	addi	a0,a0,-1208 # ffffffffc0202320 <etext+0x454>
ffffffffc02007e0:	8f3ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02007e4:	740c                	ld	a1,40(s0)
ffffffffc02007e6:	00002517          	auipc	a0,0x2
ffffffffc02007ea:	b5250513          	addi	a0,a0,-1198 # ffffffffc0202338 <etext+0x46c>
ffffffffc02007ee:	8e5ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02007f2:	780c                	ld	a1,48(s0)
ffffffffc02007f4:	00002517          	auipc	a0,0x2
ffffffffc02007f8:	b5c50513          	addi	a0,a0,-1188 # ffffffffc0202350 <etext+0x484>
ffffffffc02007fc:	8d7ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200800:	7c0c                	ld	a1,56(s0)
ffffffffc0200802:	00002517          	auipc	a0,0x2
ffffffffc0200806:	b6650513          	addi	a0,a0,-1178 # ffffffffc0202368 <etext+0x49c>
ffffffffc020080a:	8c9ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020080e:	602c                	ld	a1,64(s0)
ffffffffc0200810:	00002517          	auipc	a0,0x2
ffffffffc0200814:	b7050513          	addi	a0,a0,-1168 # ffffffffc0202380 <etext+0x4b4>
ffffffffc0200818:	8bbff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020081c:	642c                	ld	a1,72(s0)
ffffffffc020081e:	00002517          	auipc	a0,0x2
ffffffffc0200822:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0202398 <etext+0x4cc>
ffffffffc0200826:	8adff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020082a:	682c                	ld	a1,80(s0)
ffffffffc020082c:	00002517          	auipc	a0,0x2
ffffffffc0200830:	b8450513          	addi	a0,a0,-1148 # ffffffffc02023b0 <etext+0x4e4>
ffffffffc0200834:	89fff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200838:	6c2c                	ld	a1,88(s0)
ffffffffc020083a:	00002517          	auipc	a0,0x2
ffffffffc020083e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc02023c8 <etext+0x4fc>
ffffffffc0200842:	891ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200846:	702c                	ld	a1,96(s0)
ffffffffc0200848:	00002517          	auipc	a0,0x2
ffffffffc020084c:	b9850513          	addi	a0,a0,-1128 # ffffffffc02023e0 <etext+0x514>
ffffffffc0200850:	883ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200854:	742c                	ld	a1,104(s0)
ffffffffc0200856:	00002517          	auipc	a0,0x2
ffffffffc020085a:	ba250513          	addi	a0,a0,-1118 # ffffffffc02023f8 <etext+0x52c>
ffffffffc020085e:	875ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200862:	782c                	ld	a1,112(s0)
ffffffffc0200864:	00002517          	auipc	a0,0x2
ffffffffc0200868:	bac50513          	addi	a0,a0,-1108 # ffffffffc0202410 <etext+0x544>
ffffffffc020086c:	867ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200870:	7c2c                	ld	a1,120(s0)
ffffffffc0200872:	00002517          	auipc	a0,0x2
ffffffffc0200876:	bb650513          	addi	a0,a0,-1098 # ffffffffc0202428 <etext+0x55c>
ffffffffc020087a:	859ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020087e:	604c                	ld	a1,128(s0)
ffffffffc0200880:	00002517          	auipc	a0,0x2
ffffffffc0200884:	bc050513          	addi	a0,a0,-1088 # ffffffffc0202440 <etext+0x574>
ffffffffc0200888:	84bff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020088c:	644c                	ld	a1,136(s0)
ffffffffc020088e:	00002517          	auipc	a0,0x2
ffffffffc0200892:	bca50513          	addi	a0,a0,-1078 # ffffffffc0202458 <etext+0x58c>
ffffffffc0200896:	83dff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020089a:	684c                	ld	a1,144(s0)
ffffffffc020089c:	00002517          	auipc	a0,0x2
ffffffffc02008a0:	bd450513          	addi	a0,a0,-1068 # ffffffffc0202470 <etext+0x5a4>
ffffffffc02008a4:	82fff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02008a8:	6c4c                	ld	a1,152(s0)
ffffffffc02008aa:	00002517          	auipc	a0,0x2
ffffffffc02008ae:	bde50513          	addi	a0,a0,-1058 # ffffffffc0202488 <etext+0x5bc>
ffffffffc02008b2:	821ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02008b6:	704c                	ld	a1,160(s0)
ffffffffc02008b8:	00002517          	auipc	a0,0x2
ffffffffc02008bc:	be850513          	addi	a0,a0,-1048 # ffffffffc02024a0 <etext+0x5d4>
ffffffffc02008c0:	813ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02008c4:	744c                	ld	a1,168(s0)
ffffffffc02008c6:	00002517          	auipc	a0,0x2
ffffffffc02008ca:	bf250513          	addi	a0,a0,-1038 # ffffffffc02024b8 <etext+0x5ec>
ffffffffc02008ce:	805ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02008d2:	784c                	ld	a1,176(s0)
ffffffffc02008d4:	00002517          	auipc	a0,0x2
ffffffffc02008d8:	bfc50513          	addi	a0,a0,-1028 # ffffffffc02024d0 <etext+0x604>
ffffffffc02008dc:	ff6ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02008e0:	7c4c                	ld	a1,184(s0)
ffffffffc02008e2:	00002517          	auipc	a0,0x2
ffffffffc02008e6:	c0650513          	addi	a0,a0,-1018 # ffffffffc02024e8 <etext+0x61c>
ffffffffc02008ea:	fe8ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02008ee:	606c                	ld	a1,192(s0)
ffffffffc02008f0:	00002517          	auipc	a0,0x2
ffffffffc02008f4:	c1050513          	addi	a0,a0,-1008 # ffffffffc0202500 <etext+0x634>
ffffffffc02008f8:	fdaff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02008fc:	646c                	ld	a1,200(s0)
ffffffffc02008fe:	00002517          	auipc	a0,0x2
ffffffffc0200902:	c1a50513          	addi	a0,a0,-998 # ffffffffc0202518 <etext+0x64c>
ffffffffc0200906:	fccff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc020090a:	686c                	ld	a1,208(s0)
ffffffffc020090c:	00002517          	auipc	a0,0x2
ffffffffc0200910:	c2450513          	addi	a0,a0,-988 # ffffffffc0202530 <etext+0x664>
ffffffffc0200914:	fbeff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200918:	6c6c                	ld	a1,216(s0)
ffffffffc020091a:	00002517          	auipc	a0,0x2
ffffffffc020091e:	c2e50513          	addi	a0,a0,-978 # ffffffffc0202548 <etext+0x67c>
ffffffffc0200922:	fb0ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200926:	706c                	ld	a1,224(s0)
ffffffffc0200928:	00002517          	auipc	a0,0x2
ffffffffc020092c:	c3850513          	addi	a0,a0,-968 # ffffffffc0202560 <etext+0x694>
ffffffffc0200930:	fa2ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200934:	746c                	ld	a1,232(s0)
ffffffffc0200936:	00002517          	auipc	a0,0x2
ffffffffc020093a:	c4250513          	addi	a0,a0,-958 # ffffffffc0202578 <etext+0x6ac>
ffffffffc020093e:	f94ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200942:	786c                	ld	a1,240(s0)
ffffffffc0200944:	00002517          	auipc	a0,0x2
ffffffffc0200948:	c4c50513          	addi	a0,a0,-948 # ffffffffc0202590 <etext+0x6c4>
ffffffffc020094c:	f86ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200950:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200952:	6402                	ld	s0,0(sp)
ffffffffc0200954:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200956:	00002517          	auipc	a0,0x2
ffffffffc020095a:	c5250513          	addi	a0,a0,-942 # ffffffffc02025a8 <etext+0x6dc>
}
ffffffffc020095e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200960:	f72ff06f          	j	ffffffffc02000d2 <cprintf>

ffffffffc0200964 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200964:	1141                	addi	sp,sp,-16
ffffffffc0200966:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);//使用汇编语言定义的结构体指针tf的地址，方便c语言访问寄存器的值
ffffffffc0200968:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc020096a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);//使用汇编语言定义的结构体指针tf的地址，方便c语言访问寄存器的值
ffffffffc020096c:	00002517          	auipc	a0,0x2
ffffffffc0200970:	c5450513          	addi	a0,a0,-940 # ffffffffc02025c0 <etext+0x6f4>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200974:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);//使用汇编语言定义的结构体指针tf的地址，方便c语言访问寄存器的值
ffffffffc0200976:	f5cff0ef          	jal	ffffffffc02000d2 <cprintf>
    print_regs(&tf->gpr);//打印通用寄存器，函数在下方定义
ffffffffc020097a:	8522                	mv	a0,s0
ffffffffc020097c:	e1bff0ef          	jal	ffffffffc0200796 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);//保存当前 S 模式的状态位（中断使能、特权级、上一次状态等）
ffffffffc0200980:	10043583          	ld	a1,256(s0)
ffffffffc0200984:	00002517          	auipc	a0,0x2
ffffffffc0200988:	c5450513          	addi	a0,a0,-940 # ffffffffc02025d8 <etext+0x70c>
ffffffffc020098c:	f46ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);//保存引发异常/中断的指令地址
ffffffffc0200990:	10843583          	ld	a1,264(s0)
ffffffffc0200994:	00002517          	auipc	a0,0x2
ffffffffc0200998:	c5c50513          	addi	a0,a0,-932 # ffffffffc02025f0 <etext+0x724>
ffffffffc020099c:	f36ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);//保存与异常有关的附加信息（
ffffffffc02009a0:	11043583          	ld	a1,272(s0)
ffffffffc02009a4:	00002517          	auipc	a0,0x2
ffffffffc02009a8:	c6450513          	addi	a0,a0,-924 # ffffffffc0202608 <etext+0x73c>
ffffffffc02009ac:	f26ff0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);//指明陷入原因（中断/异常类型编号）
ffffffffc02009b0:	11843583          	ld	a1,280(s0)
}
ffffffffc02009b4:	6402                	ld	s0,0(sp)
ffffffffc02009b6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);//指明陷入原因（中断/异常类型编号）
ffffffffc02009b8:	00002517          	auipc	a0,0x2
ffffffffc02009bc:	c6850513          	addi	a0,a0,-920 # ffffffffc0202620 <etext+0x754>
}
ffffffffc02009c0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);//指明陷入原因（中断/异常类型编号）
ffffffffc02009c2:	f10ff06f          	j	ffffffffc02000d2 <cprintf>

ffffffffc02009c6 <interrupt_handler>:
void interrupt_handler(struct trapframe *tf) {
    //在 RISC-V 架构中，`scause` 是一个 **64 位寄存器**，用来说明“陷入内核”的原因。
    //当最高位（bit 63）为 **0** 时，表示 **异常（Exception）**,为1时是中断
    //去掉 scause 的最高位（中断标志位），得到真正的“中断/异常编号
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc02009c6:	11853783          	ld	a5,280(a0)
ffffffffc02009ca:	472d                	li	a4,11
ffffffffc02009cc:	0786                	slli	a5,a5,0x1
ffffffffc02009ce:	8385                	srli	a5,a5,0x1
ffffffffc02009d0:	0af76a63          	bltu	a4,a5,ffffffffc0200a84 <interrupt_handler+0xbe>
ffffffffc02009d4:	00002717          	auipc	a4,0x2
ffffffffc02009d8:	33470713          	addi	a4,a4,820 # ffffffffc0202d08 <commands+0x48>
ffffffffc02009dc:	078a                	slli	a5,a5,0x2
ffffffffc02009de:	97ba                	add	a5,a5,a4
ffffffffc02009e0:	439c                	lw	a5,0(a5)
ffffffffc02009e2:	97ba                	add	a5,a5,a4
ffffffffc02009e4:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02009e6:	00002517          	auipc	a0,0x2
ffffffffc02009ea:	cb250513          	addi	a0,a0,-846 # ffffffffc0202698 <etext+0x7cc>
ffffffffc02009ee:	ee4ff06f          	j	ffffffffc02000d2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02009f2:	00002517          	auipc	a0,0x2
ffffffffc02009f6:	c8650513          	addi	a0,a0,-890 # ffffffffc0202678 <etext+0x7ac>
ffffffffc02009fa:	ed8ff06f          	j	ffffffffc02000d2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02009fe:	00002517          	auipc	a0,0x2
ffffffffc0200a02:	c3a50513          	addi	a0,a0,-966 # ffffffffc0202638 <etext+0x76c>
ffffffffc0200a06:	eccff06f          	j	ffffffffc02000d2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200a0a:	00002517          	auipc	a0,0x2
ffffffffc0200a0e:	cae50513          	addi	a0,a0,-850 # ffffffffc02026b8 <etext+0x7ec>
ffffffffc0200a12:	ec0ff06f          	j	ffffffffc02000d2 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a16:	1141                	addi	sp,sp,-16
ffffffffc0200a18:	e406                	sd	ra,8(sp)
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
               // 1) 预约下次时钟中断
            clock_set_next_event();
ffffffffc0200a1a:	9fbff0ef          	jal	ffffffffc0200414 <clock_set_next_event>

            // 2) 递增全局时钟计数
            ticks++;
ffffffffc0200a1e:	00006797          	auipc	a5,0x6
ffffffffc0200a22:	a2a78793          	addi	a5,a5,-1494 # ffffffffc0206448 <ticks>
ffffffffc0200a26:	6394                	ld	a3,0(a5)

            // 3) 每到 100 次打印一次
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a28:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200a2c:	28f70713          	addi	a4,a4,655 # 28f5c28f <kern_entry-0xffffffff972a3d71>
            ticks++;
ffffffffc0200a30:	0685                	addi	a3,a3,1
ffffffffc0200a32:	e394                	sd	a3,0(a5)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a34:	6390                	ld	a2,0(a5)
ffffffffc0200a36:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200a3a:	1702                	slli	a4,a4,0x20
ffffffffc0200a3c:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <kern_entry-0xffffffff63f70a3d>
ffffffffc0200a40:	00265793          	srli	a5,a2,0x2
ffffffffc0200a44:	9736                	add	a4,a4,a3
ffffffffc0200a46:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200a4a:	06400593          	li	a1,100
ffffffffc0200a4e:	8389                	srli	a5,a5,0x2
ffffffffc0200a50:	02b787b3          	mul	a5,a5,a1
ffffffffc0200a54:	02f60963          	beq	a2,a5,ffffffffc0200a86 <interrupt_handler+0xc0>
                print_ticks(); // 输出 "100 ticks"（由 print_ticks() 完成）
                num++;         // 记录打印了几次“100 ticks”
            }

            // 4) 打印到第 10 次时关机
            if (num == 10) {
ffffffffc0200a58:	00006797          	auipc	a5,0x6
ffffffffc0200a5c:	a087b783          	ld	a5,-1528(a5) # ffffffffc0206460 <num>
ffffffffc0200a60:	4729                	li	a4,10
ffffffffc0200a62:	04e78263          	beq	a5,a4,ffffffffc0200aa6 <interrupt_handler+0xe0>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a66:	60a2                	ld	ra,8(sp)
ffffffffc0200a68:	0141                	addi	sp,sp,16
ffffffffc0200a6a:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a6c:	00002517          	auipc	a0,0x2
ffffffffc0200a70:	c7450513          	addi	a0,a0,-908 # ffffffffc02026e0 <etext+0x814>
ffffffffc0200a74:	e5eff06f          	j	ffffffffc02000d2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200a78:	00002517          	auipc	a0,0x2
ffffffffc0200a7c:	be050513          	addi	a0,a0,-1056 # ffffffffc0202658 <etext+0x78c>
ffffffffc0200a80:	e52ff06f          	j	ffffffffc02000d2 <cprintf>
            print_trapframe(tf);
ffffffffc0200a84:	b5c5                	j	ffffffffc0200964 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200a86:	00002517          	auipc	a0,0x2
ffffffffc0200a8a:	c4a50513          	addi	a0,a0,-950 # ffffffffc02026d0 <etext+0x804>
ffffffffc0200a8e:	e44ff0ef          	jal	ffffffffc02000d2 <cprintf>
                num++;         // 记录打印了几次“100 ticks”
ffffffffc0200a92:	00006797          	auipc	a5,0x6
ffffffffc0200a96:	9ce7b783          	ld	a5,-1586(a5) # ffffffffc0206460 <num>
ffffffffc0200a9a:	0785                	addi	a5,a5,1
ffffffffc0200a9c:	00006717          	auipc	a4,0x6
ffffffffc0200aa0:	9cf73223          	sd	a5,-1596(a4) # ffffffffc0206460 <num>
ffffffffc0200aa4:	bf75                	j	ffffffffc0200a60 <interrupt_handler+0x9a>
}
ffffffffc0200aa6:	60a2                	ld	ra,8(sp)
ffffffffc0200aa8:	0141                	addi	sp,sp,16
                sbi_shutdown();
ffffffffc0200aaa:	3540106f          	j	ffffffffc0201dfe <sbi_shutdown>

ffffffffc0200aae <trap>:
            break;
    }
}

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {//有符号数，最高位为1为中断，此时应该为负数
ffffffffc0200aae:	11853783          	ld	a5,280(a0)
ffffffffc0200ab2:	0007c763          	bltz	a5,ffffffffc0200ac0 <trap+0x12>
    switch (tf->cause) {
ffffffffc0200ab6:	472d                	li	a4,11
ffffffffc0200ab8:	00f76363          	bltu	a4,a5,ffffffffc0200abe <trap+0x10>
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}
ffffffffc0200abc:	8082                	ret
            print_trapframe(tf);
ffffffffc0200abe:	b55d                	j	ffffffffc0200964 <print_trapframe>
        interrupt_handler(tf);
ffffffffc0200ac0:	b719                	j	ffffffffc02009c6 <interrupt_handler>
	...

ffffffffc0200ac4 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200ac4:	14011073          	csrw	sscratch,sp
ffffffffc0200ac8:	712d                	addi	sp,sp,-288
ffffffffc0200aca:	e002                	sd	zero,0(sp)
ffffffffc0200acc:	e406                	sd	ra,8(sp)
ffffffffc0200ace:	ec0e                	sd	gp,24(sp)
ffffffffc0200ad0:	f012                	sd	tp,32(sp)
ffffffffc0200ad2:	f416                	sd	t0,40(sp)
ffffffffc0200ad4:	f81a                	sd	t1,48(sp)
ffffffffc0200ad6:	fc1e                	sd	t2,56(sp)
ffffffffc0200ad8:	e0a2                	sd	s0,64(sp)
ffffffffc0200ada:	e4a6                	sd	s1,72(sp)
ffffffffc0200adc:	e8aa                	sd	a0,80(sp)
ffffffffc0200ade:	ecae                	sd	a1,88(sp)
ffffffffc0200ae0:	f0b2                	sd	a2,96(sp)
ffffffffc0200ae2:	f4b6                	sd	a3,104(sp)
ffffffffc0200ae4:	f8ba                	sd	a4,112(sp)
ffffffffc0200ae6:	fcbe                	sd	a5,120(sp)
ffffffffc0200ae8:	e142                	sd	a6,128(sp)
ffffffffc0200aea:	e546                	sd	a7,136(sp)
ffffffffc0200aec:	e94a                	sd	s2,144(sp)
ffffffffc0200aee:	ed4e                	sd	s3,152(sp)
ffffffffc0200af0:	f152                	sd	s4,160(sp)
ffffffffc0200af2:	f556                	sd	s5,168(sp)
ffffffffc0200af4:	f95a                	sd	s6,176(sp)
ffffffffc0200af6:	fd5e                	sd	s7,184(sp)
ffffffffc0200af8:	e1e2                	sd	s8,192(sp)
ffffffffc0200afa:	e5e6                	sd	s9,200(sp)
ffffffffc0200afc:	e9ea                	sd	s10,208(sp)
ffffffffc0200afe:	edee                	sd	s11,216(sp)
ffffffffc0200b00:	f1f2                	sd	t3,224(sp)
ffffffffc0200b02:	f5f6                	sd	t4,232(sp)
ffffffffc0200b04:	f9fa                	sd	t5,240(sp)
ffffffffc0200b06:	fdfe                	sd	t6,248(sp)
ffffffffc0200b08:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200b0c:	100024f3          	csrr	s1,sstatus
ffffffffc0200b10:	14102973          	csrr	s2,sepc
ffffffffc0200b14:	143029f3          	csrr	s3,stval
ffffffffc0200b18:	14202a73          	csrr	s4,scause
ffffffffc0200b1c:	e822                	sd	s0,16(sp)
ffffffffc0200b1e:	e226                	sd	s1,256(sp)
ffffffffc0200b20:	e64a                	sd	s2,264(sp)
ffffffffc0200b22:	ea4e                	sd	s3,272(sp)
ffffffffc0200b24:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200b26:	850a                	mv	a0,sp
    # jr和jal不同，此处返回跳转处
    jal trap
ffffffffc0200b28:	f87ff0ef          	jal	ffffffffc0200aae <trap>

ffffffffc0200b2c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200b2c:	6492                	ld	s1,256(sp)
ffffffffc0200b2e:	6932                	ld	s2,264(sp)
ffffffffc0200b30:	10049073          	csrw	sstatus,s1
ffffffffc0200b34:	14191073          	csrw	sepc,s2
ffffffffc0200b38:	60a2                	ld	ra,8(sp)
ffffffffc0200b3a:	61e2                	ld	gp,24(sp)
ffffffffc0200b3c:	7202                	ld	tp,32(sp)
ffffffffc0200b3e:	72a2                	ld	t0,40(sp)
ffffffffc0200b40:	7342                	ld	t1,48(sp)
ffffffffc0200b42:	73e2                	ld	t2,56(sp)
ffffffffc0200b44:	6406                	ld	s0,64(sp)
ffffffffc0200b46:	64a6                	ld	s1,72(sp)
ffffffffc0200b48:	6546                	ld	a0,80(sp)
ffffffffc0200b4a:	65e6                	ld	a1,88(sp)
ffffffffc0200b4c:	7606                	ld	a2,96(sp)
ffffffffc0200b4e:	76a6                	ld	a3,104(sp)
ffffffffc0200b50:	7746                	ld	a4,112(sp)
ffffffffc0200b52:	77e6                	ld	a5,120(sp)
ffffffffc0200b54:	680a                	ld	a6,128(sp)
ffffffffc0200b56:	68aa                	ld	a7,136(sp)
ffffffffc0200b58:	694a                	ld	s2,144(sp)
ffffffffc0200b5a:	69ea                	ld	s3,152(sp)
ffffffffc0200b5c:	7a0a                	ld	s4,160(sp)
ffffffffc0200b5e:	7aaa                	ld	s5,168(sp)
ffffffffc0200b60:	7b4a                	ld	s6,176(sp)
ffffffffc0200b62:	7bea                	ld	s7,184(sp)
ffffffffc0200b64:	6c0e                	ld	s8,192(sp)
ffffffffc0200b66:	6cae                	ld	s9,200(sp)
ffffffffc0200b68:	6d4e                	ld	s10,208(sp)
ffffffffc0200b6a:	6dee                	ld	s11,216(sp)
ffffffffc0200b6c:	7e0e                	ld	t3,224(sp)
ffffffffc0200b6e:	7eae                	ld	t4,232(sp)
ffffffffc0200b70:	7f4e                	ld	t5,240(sp)
ffffffffc0200b72:	7fee                	ld	t6,248(sp)
ffffffffc0200b74:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200b76:	10200073          	sret

ffffffffc0200b7a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200b7a:	00005797          	auipc	a5,0x5
ffffffffc0200b7e:	4ae78793          	addi	a5,a5,1198 # ffffffffc0206028 <free_area>
ffffffffc0200b82:	e79c                	sd	a5,8(a5)
ffffffffc0200b84:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200b86:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b8a:	8082                	ret

ffffffffc0200b8c <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200b8c:	00005517          	auipc	a0,0x5
ffffffffc0200b90:	4ac56503          	lwu	a0,1196(a0) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200b94:	8082                	ret

ffffffffc0200b96 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200b96:	711d                	addi	sp,sp,-96
ffffffffc0200b98:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b9a:	00005917          	auipc	s2,0x5
ffffffffc0200b9e:	48e90913          	addi	s2,s2,1166 # ffffffffc0206028 <free_area>
ffffffffc0200ba2:	00893783          	ld	a5,8(s2)
ffffffffc0200ba6:	ec86                	sd	ra,88(sp)
ffffffffc0200ba8:	e8a2                	sd	s0,80(sp)
ffffffffc0200baa:	e4a6                	sd	s1,72(sp)
ffffffffc0200bac:	fc4e                	sd	s3,56(sp)
ffffffffc0200bae:	f852                	sd	s4,48(sp)
ffffffffc0200bb0:	f456                	sd	s5,40(sp)
ffffffffc0200bb2:	f05a                	sd	s6,32(sp)
ffffffffc0200bb4:	ec5e                	sd	s7,24(sp)
ffffffffc0200bb6:	e862                	sd	s8,16(sp)
ffffffffc0200bb8:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200bba:	31278b63          	beq	a5,s2,ffffffffc0200ed0 <default_check+0x33a>
    int count = 0, total = 0;
ffffffffc0200bbe:	4401                	li	s0,0
ffffffffc0200bc0:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200bc2:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200bc6:	8b09                	andi	a4,a4,2
ffffffffc0200bc8:	30070863          	beqz	a4,ffffffffc0200ed8 <default_check+0x342>
        count ++, total += p->property;
ffffffffc0200bcc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200bd0:	679c                	ld	a5,8(a5)
ffffffffc0200bd2:	2485                	addiw	s1,s1,1
ffffffffc0200bd4:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200bd6:	ff2796e3          	bne	a5,s2,ffffffffc0200bc2 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200bda:	89a2                	mv	s3,s0
ffffffffc0200bdc:	33f000ef          	jal	ffffffffc020171a <nr_free_pages>
ffffffffc0200be0:	75351c63          	bne	a0,s3,ffffffffc0201338 <default_check+0x7a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200be4:	4505                	li	a0,1
ffffffffc0200be6:	2c3000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200bea:	8aaa                	mv	s5,a0
ffffffffc0200bec:	48050663          	beqz	a0,ffffffffc0201078 <default_check+0x4e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200bf0:	4505                	li	a0,1
ffffffffc0200bf2:	2b7000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200bf6:	89aa                	mv	s3,a0
ffffffffc0200bf8:	76050063          	beqz	a0,ffffffffc0201358 <default_check+0x7c2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200bfc:	4505                	li	a0,1
ffffffffc0200bfe:	2ab000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200c02:	8a2a                	mv	s4,a0
ffffffffc0200c04:	4e050a63          	beqz	a0,ffffffffc02010f8 <default_check+0x562>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200c08:	40aa87b3          	sub	a5,s5,a0
ffffffffc0200c0c:	40a98733          	sub	a4,s3,a0
ffffffffc0200c10:	0017b793          	seqz	a5,a5
ffffffffc0200c14:	00173713          	seqz	a4,a4
ffffffffc0200c18:	8fd9                	or	a5,a5,a4
ffffffffc0200c1a:	32079f63          	bnez	a5,ffffffffc0200f58 <default_check+0x3c2>
ffffffffc0200c1e:	333a8d63          	beq	s5,s3,ffffffffc0200f58 <default_check+0x3c2>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200c22:	000aa783          	lw	a5,0(s5)
ffffffffc0200c26:	2c079963          	bnez	a5,ffffffffc0200ef8 <default_check+0x362>
ffffffffc0200c2a:	0009a783          	lw	a5,0(s3)
ffffffffc0200c2e:	2c079563          	bnez	a5,ffffffffc0200ef8 <default_check+0x362>
ffffffffc0200c32:	411c                	lw	a5,0(a0)
ffffffffc0200c34:	2c079263          	bnez	a5,ffffffffc0200ef8 <default_check+0x362>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c38:	00006797          	auipc	a5,0x6
ffffffffc0200c3c:	8587b783          	ld	a5,-1960(a5) # ffffffffc0206490 <pages>
ffffffffc0200c40:	ccccd737          	lui	a4,0xccccd
ffffffffc0200c44:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac682d>
ffffffffc0200c48:	02071693          	slli	a3,a4,0x20
ffffffffc0200c4c:	96ba                	add	a3,a3,a4
ffffffffc0200c4e:	40fa8733          	sub	a4,s5,a5
ffffffffc0200c52:	870d                	srai	a4,a4,0x3
ffffffffc0200c54:	02d70733          	mul	a4,a4,a3
ffffffffc0200c58:	00002517          	auipc	a0,0x2
ffffffffc0200c5c:	2a853503          	ld	a0,680(a0) # ffffffffc0202f00 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200c60:	00006697          	auipc	a3,0x6
ffffffffc0200c64:	8286b683          	ld	a3,-2008(a3) # ffffffffc0206488 <npage>
ffffffffc0200c68:	06b2                	slli	a3,a3,0xc
ffffffffc0200c6a:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c6c:	0732                	slli	a4,a4,0xc
ffffffffc0200c6e:	2cd77563          	bgeu	a4,a3,ffffffffc0200f38 <default_check+0x3a2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c72:	ccccd5b7          	lui	a1,0xccccd
ffffffffc0200c76:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac682d>
ffffffffc0200c7a:	02059613          	slli	a2,a1,0x20
ffffffffc0200c7e:	40f98733          	sub	a4,s3,a5
ffffffffc0200c82:	962e                	add	a2,a2,a1
ffffffffc0200c84:	870d                	srai	a4,a4,0x3
ffffffffc0200c86:	02c70733          	mul	a4,a4,a2
ffffffffc0200c8a:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c8c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200c8e:	4ed77563          	bgeu	a4,a3,ffffffffc0201178 <default_check+0x5e2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c92:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200c96:	878d                	srai	a5,a5,0x3
ffffffffc0200c98:	02c787b3          	mul	a5,a5,a2
ffffffffc0200c9c:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c9e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200ca0:	32d7fc63          	bgeu	a5,a3,ffffffffc0200fd8 <default_check+0x442>
    assert(alloc_page() == NULL);
ffffffffc0200ca4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200ca6:	00093c03          	ld	s8,0(s2)
ffffffffc0200caa:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200cae:	00005b17          	auipc	s6,0x5
ffffffffc0200cb2:	38ab2b03          	lw	s6,906(s6) # ffffffffc0206038 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200cb6:	01293023          	sd	s2,0(s2)
ffffffffc0200cba:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200cbe:	00005797          	auipc	a5,0x5
ffffffffc0200cc2:	3607ad23          	sw	zero,890(a5) # ffffffffc0206038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200cc6:	1e3000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200cca:	2e051763          	bnez	a0,ffffffffc0200fb8 <default_check+0x422>
    free_page(p0);
ffffffffc0200cce:	8556                	mv	a0,s5
ffffffffc0200cd0:	4585                	li	a1,1
ffffffffc0200cd2:	211000ef          	jal	ffffffffc02016e2 <free_pages>
    free_page(p1);
ffffffffc0200cd6:	854e                	mv	a0,s3
ffffffffc0200cd8:	4585                	li	a1,1
ffffffffc0200cda:	209000ef          	jal	ffffffffc02016e2 <free_pages>
    free_page(p2);
ffffffffc0200cde:	8552                	mv	a0,s4
ffffffffc0200ce0:	4585                	li	a1,1
ffffffffc0200ce2:	201000ef          	jal	ffffffffc02016e2 <free_pages>
    assert(nr_free == 3);
ffffffffc0200ce6:	00005717          	auipc	a4,0x5
ffffffffc0200cea:	35272703          	lw	a4,850(a4) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200cee:	478d                	li	a5,3
ffffffffc0200cf0:	2af71463          	bne	a4,a5,ffffffffc0200f98 <default_check+0x402>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200cf4:	4505                	li	a0,1
ffffffffc0200cf6:	1b3000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200cfa:	89aa                	mv	s3,a0
ffffffffc0200cfc:	26050e63          	beqz	a0,ffffffffc0200f78 <default_check+0x3e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d00:	4505                	li	a0,1
ffffffffc0200d02:	1a7000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d06:	8aaa                	mv	s5,a0
ffffffffc0200d08:	3c050863          	beqz	a0,ffffffffc02010d8 <default_check+0x542>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d0c:	4505                	li	a0,1
ffffffffc0200d0e:	19b000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d12:	8a2a                	mv	s4,a0
ffffffffc0200d14:	3a050263          	beqz	a0,ffffffffc02010b8 <default_check+0x522>
    assert(alloc_page() == NULL);
ffffffffc0200d18:	4505                	li	a0,1
ffffffffc0200d1a:	18f000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d1e:	36051d63          	bnez	a0,ffffffffc0201098 <default_check+0x502>
    free_page(p0);
ffffffffc0200d22:	4585                	li	a1,1
ffffffffc0200d24:	854e                	mv	a0,s3
ffffffffc0200d26:	1bd000ef          	jal	ffffffffc02016e2 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200d2a:	00893783          	ld	a5,8(s2)
ffffffffc0200d2e:	1f278563          	beq	a5,s2,ffffffffc0200f18 <default_check+0x382>
    assert((p = alloc_page()) == p0);
ffffffffc0200d32:	4505                	li	a0,1
ffffffffc0200d34:	175000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d38:	8caa                	mv	s9,a0
ffffffffc0200d3a:	30a99f63          	bne	s3,a0,ffffffffc0201058 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200d3e:	4505                	li	a0,1
ffffffffc0200d40:	169000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d44:	2e051a63          	bnez	a0,ffffffffc0201038 <default_check+0x4a2>
    assert(nr_free == 0);
ffffffffc0200d48:	00005797          	auipc	a5,0x5
ffffffffc0200d4c:	2f07a783          	lw	a5,752(a5) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200d50:	2c079463          	bnez	a5,ffffffffc0201018 <default_check+0x482>
    free_page(p);
ffffffffc0200d54:	8566                	mv	a0,s9
ffffffffc0200d56:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200d58:	01893023          	sd	s8,0(s2)
ffffffffc0200d5c:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200d60:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200d64:	17f000ef          	jal	ffffffffc02016e2 <free_pages>
    free_page(p1);
ffffffffc0200d68:	8556                	mv	a0,s5
ffffffffc0200d6a:	4585                	li	a1,1
ffffffffc0200d6c:	177000ef          	jal	ffffffffc02016e2 <free_pages>
    free_page(p2);
ffffffffc0200d70:	8552                	mv	a0,s4
ffffffffc0200d72:	4585                	li	a1,1
ffffffffc0200d74:	16f000ef          	jal	ffffffffc02016e2 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200d78:	4515                	li	a0,5
ffffffffc0200d7a:	12f000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200d7e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200d80:	26050c63          	beqz	a0,ffffffffc0200ff8 <default_check+0x462>
ffffffffc0200d84:	651c                	ld	a5,8(a0)
ffffffffc0200d86:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200d88:	8b85                	andi	a5,a5,1
ffffffffc0200d8a:	54079763          	bnez	a5,ffffffffc02012d8 <default_check+0x742>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200d8e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d90:	00093b83          	ld	s7,0(s2)
ffffffffc0200d94:	00893b03          	ld	s6,8(s2)
ffffffffc0200d98:	01293023          	sd	s2,0(s2)
ffffffffc0200d9c:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200da0:	109000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200da4:	50051a63          	bnez	a0,ffffffffc02012b8 <default_check+0x722>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200da8:	05098a13          	addi	s4,s3,80
ffffffffc0200dac:	8552                	mv	a0,s4
ffffffffc0200dae:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200db0:	00005c17          	auipc	s8,0x5
ffffffffc0200db4:	288c2c03          	lw	s8,648(s8) # ffffffffc0206038 <free_area+0x10>
    nr_free = 0;
ffffffffc0200db8:	00005797          	auipc	a5,0x5
ffffffffc0200dbc:	2807a023          	sw	zero,640(a5) # ffffffffc0206038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200dc0:	123000ef          	jal	ffffffffc02016e2 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200dc4:	4511                	li	a0,4
ffffffffc0200dc6:	0e3000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200dca:	4c051763          	bnez	a0,ffffffffc0201298 <default_check+0x702>
ffffffffc0200dce:	0589b783          	ld	a5,88(s3)
ffffffffc0200dd2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200dd4:	8b85                	andi	a5,a5,1
ffffffffc0200dd6:	4a078163          	beqz	a5,ffffffffc0201278 <default_check+0x6e2>
ffffffffc0200dda:	0609a503          	lw	a0,96(s3)
ffffffffc0200dde:	478d                	li	a5,3
ffffffffc0200de0:	48f51c63          	bne	a0,a5,ffffffffc0201278 <default_check+0x6e2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200de4:	0c5000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200de8:	8aaa                	mv	s5,a0
ffffffffc0200dea:	46050763          	beqz	a0,ffffffffc0201258 <default_check+0x6c2>
    assert(alloc_page() == NULL);
ffffffffc0200dee:	4505                	li	a0,1
ffffffffc0200df0:	0b9000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200df4:	44051263          	bnez	a0,ffffffffc0201238 <default_check+0x6a2>
    assert(p0 + 2 == p1);
ffffffffc0200df8:	435a1063          	bne	s4,s5,ffffffffc0201218 <default_check+0x682>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200dfc:	4585                	li	a1,1
ffffffffc0200dfe:	854e                	mv	a0,s3
ffffffffc0200e00:	0e3000ef          	jal	ffffffffc02016e2 <free_pages>
    free_pages(p1, 3);
ffffffffc0200e04:	8552                	mv	a0,s4
ffffffffc0200e06:	458d                	li	a1,3
ffffffffc0200e08:	0db000ef          	jal	ffffffffc02016e2 <free_pages>
ffffffffc0200e0c:	0089b783          	ld	a5,8(s3)
ffffffffc0200e10:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200e12:	8b85                	andi	a5,a5,1
ffffffffc0200e14:	3e078263          	beqz	a5,ffffffffc02011f8 <default_check+0x662>
ffffffffc0200e18:	0109aa83          	lw	s5,16(s3)
ffffffffc0200e1c:	4785                	li	a5,1
ffffffffc0200e1e:	3cfa9d63          	bne	s5,a5,ffffffffc02011f8 <default_check+0x662>
ffffffffc0200e22:	008a3783          	ld	a5,8(s4)
ffffffffc0200e26:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200e28:	8b85                	andi	a5,a5,1
ffffffffc0200e2a:	3a078763          	beqz	a5,ffffffffc02011d8 <default_check+0x642>
ffffffffc0200e2e:	010a2703          	lw	a4,16(s4)
ffffffffc0200e32:	478d                	li	a5,3
ffffffffc0200e34:	3af71263          	bne	a4,a5,ffffffffc02011d8 <default_check+0x642>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200e38:	8556                	mv	a0,s5
ffffffffc0200e3a:	06f000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200e3e:	36a99d63          	bne	s3,a0,ffffffffc02011b8 <default_check+0x622>
    free_page(p0);
ffffffffc0200e42:	85d6                	mv	a1,s5
ffffffffc0200e44:	09f000ef          	jal	ffffffffc02016e2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200e48:	4509                	li	a0,2
ffffffffc0200e4a:	05f000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200e4e:	34aa1563          	bne	s4,a0,ffffffffc0201198 <default_check+0x602>

    free_pages(p0, 2);
ffffffffc0200e52:	4589                	li	a1,2
ffffffffc0200e54:	08f000ef          	jal	ffffffffc02016e2 <free_pages>
    free_page(p2);
ffffffffc0200e58:	02898513          	addi	a0,s3,40
ffffffffc0200e5c:	85d6                	mv	a1,s5
ffffffffc0200e5e:	085000ef          	jal	ffffffffc02016e2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200e62:	4515                	li	a0,5
ffffffffc0200e64:	045000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200e68:	89aa                	mv	s3,a0
ffffffffc0200e6a:	48050763          	beqz	a0,ffffffffc02012f8 <default_check+0x762>
    assert(alloc_page() == NULL);
ffffffffc0200e6e:	8556                	mv	a0,s5
ffffffffc0200e70:	039000ef          	jal	ffffffffc02016a8 <alloc_pages>
ffffffffc0200e74:	2e051263          	bnez	a0,ffffffffc0201158 <default_check+0x5c2>

    assert(nr_free == 0);
ffffffffc0200e78:	00005797          	auipc	a5,0x5
ffffffffc0200e7c:	1c07a783          	lw	a5,448(a5) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200e80:	2a079c63          	bnez	a5,ffffffffc0201138 <default_check+0x5a2>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200e84:	854e                	mv	a0,s3
ffffffffc0200e86:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0200e88:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0200e8c:	01793023          	sd	s7,0(s2)
ffffffffc0200e90:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0200e94:	04f000ef          	jal	ffffffffc02016e2 <free_pages>
    return listelm->next;
ffffffffc0200e98:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e9c:	01278963          	beq	a5,s2,ffffffffc0200eae <default_check+0x318>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200ea0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ea4:	679c                	ld	a5,8(a5)
ffffffffc0200ea6:	34fd                	addiw	s1,s1,-1
ffffffffc0200ea8:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200eaa:	ff279be3          	bne	a5,s2,ffffffffc0200ea0 <default_check+0x30a>
    }
    assert(count == 0);
ffffffffc0200eae:	26049563          	bnez	s1,ffffffffc0201118 <default_check+0x582>
    assert(total == 0);
ffffffffc0200eb2:	46041363          	bnez	s0,ffffffffc0201318 <default_check+0x782>
}
ffffffffc0200eb6:	60e6                	ld	ra,88(sp)
ffffffffc0200eb8:	6446                	ld	s0,80(sp)
ffffffffc0200eba:	64a6                	ld	s1,72(sp)
ffffffffc0200ebc:	6906                	ld	s2,64(sp)
ffffffffc0200ebe:	79e2                	ld	s3,56(sp)
ffffffffc0200ec0:	7a42                	ld	s4,48(sp)
ffffffffc0200ec2:	7aa2                	ld	s5,40(sp)
ffffffffc0200ec4:	7b02                	ld	s6,32(sp)
ffffffffc0200ec6:	6be2                	ld	s7,24(sp)
ffffffffc0200ec8:	6c42                	ld	s8,16(sp)
ffffffffc0200eca:	6ca2                	ld	s9,8(sp)
ffffffffc0200ecc:	6125                	addi	sp,sp,96
ffffffffc0200ece:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200ed0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200ed2:	4401                	li	s0,0
ffffffffc0200ed4:	4481                	li	s1,0
ffffffffc0200ed6:	b319                	j	ffffffffc0200bdc <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0200ed8:	00002697          	auipc	a3,0x2
ffffffffc0200edc:	82868693          	addi	a3,a3,-2008 # ffffffffc0202700 <etext+0x834>
ffffffffc0200ee0:	00002617          	auipc	a2,0x2
ffffffffc0200ee4:	83060613          	addi	a2,a2,-2000 # ffffffffc0202710 <etext+0x844>
ffffffffc0200ee8:	0f000593          	li	a1,240
ffffffffc0200eec:	00002517          	auipc	a0,0x2
ffffffffc0200ef0:	83c50513          	addi	a0,a0,-1988 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200ef4:	c90ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200ef8:	00002697          	auipc	a3,0x2
ffffffffc0200efc:	8f068693          	addi	a3,a3,-1808 # ffffffffc02027e8 <etext+0x91c>
ffffffffc0200f00:	00002617          	auipc	a2,0x2
ffffffffc0200f04:	81060613          	addi	a2,a2,-2032 # ffffffffc0202710 <etext+0x844>
ffffffffc0200f08:	0be00593          	li	a1,190
ffffffffc0200f0c:	00002517          	auipc	a0,0x2
ffffffffc0200f10:	81c50513          	addi	a0,a0,-2020 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200f14:	c70ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200f18:	00002697          	auipc	a3,0x2
ffffffffc0200f1c:	99868693          	addi	a3,a3,-1640 # ffffffffc02028b0 <etext+0x9e4>
ffffffffc0200f20:	00001617          	auipc	a2,0x1
ffffffffc0200f24:	7f060613          	addi	a2,a2,2032 # ffffffffc0202710 <etext+0x844>
ffffffffc0200f28:	0d900593          	li	a1,217
ffffffffc0200f2c:	00001517          	auipc	a0,0x1
ffffffffc0200f30:	7fc50513          	addi	a0,a0,2044 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200f34:	c50ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200f38:	00002697          	auipc	a3,0x2
ffffffffc0200f3c:	8f068693          	addi	a3,a3,-1808 # ffffffffc0202828 <etext+0x95c>
ffffffffc0200f40:	00001617          	auipc	a2,0x1
ffffffffc0200f44:	7d060613          	addi	a2,a2,2000 # ffffffffc0202710 <etext+0x844>
ffffffffc0200f48:	0c000593          	li	a1,192
ffffffffc0200f4c:	00001517          	auipc	a0,0x1
ffffffffc0200f50:	7dc50513          	addi	a0,a0,2012 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200f54:	c30ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f58:	00002697          	auipc	a3,0x2
ffffffffc0200f5c:	86868693          	addi	a3,a3,-1944 # ffffffffc02027c0 <etext+0x8f4>
ffffffffc0200f60:	00001617          	auipc	a2,0x1
ffffffffc0200f64:	7b060613          	addi	a2,a2,1968 # ffffffffc0202710 <etext+0x844>
ffffffffc0200f68:	0bd00593          	li	a1,189
ffffffffc0200f6c:	00001517          	auipc	a0,0x1
ffffffffc0200f70:	7bc50513          	addi	a0,a0,1980 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200f74:	c10ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f78:	00001697          	auipc	a3,0x1
ffffffffc0200f7c:	7e868693          	addi	a3,a3,2024 # ffffffffc0202760 <etext+0x894>
ffffffffc0200f80:	00001617          	auipc	a2,0x1
ffffffffc0200f84:	79060613          	addi	a2,a2,1936 # ffffffffc0202710 <etext+0x844>
ffffffffc0200f88:	0d200593          	li	a1,210
ffffffffc0200f8c:	00001517          	auipc	a0,0x1
ffffffffc0200f90:	79c50513          	addi	a0,a0,1948 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200f94:	bf0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(nr_free == 3);
ffffffffc0200f98:	00002697          	auipc	a3,0x2
ffffffffc0200f9c:	90868693          	addi	a3,a3,-1784 # ffffffffc02028a0 <etext+0x9d4>
ffffffffc0200fa0:	00001617          	auipc	a2,0x1
ffffffffc0200fa4:	77060613          	addi	a2,a2,1904 # ffffffffc0202710 <etext+0x844>
ffffffffc0200fa8:	0d000593          	li	a1,208
ffffffffc0200fac:	00001517          	auipc	a0,0x1
ffffffffc0200fb0:	77c50513          	addi	a0,a0,1916 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200fb4:	bd0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fb8:	00002697          	auipc	a3,0x2
ffffffffc0200fbc:	8d068693          	addi	a3,a3,-1840 # ffffffffc0202888 <etext+0x9bc>
ffffffffc0200fc0:	00001617          	auipc	a2,0x1
ffffffffc0200fc4:	75060613          	addi	a2,a2,1872 # ffffffffc0202710 <etext+0x844>
ffffffffc0200fc8:	0cb00593          	li	a1,203
ffffffffc0200fcc:	00001517          	auipc	a0,0x1
ffffffffc0200fd0:	75c50513          	addi	a0,a0,1884 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200fd4:	bb0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200fd8:	00002697          	auipc	a3,0x2
ffffffffc0200fdc:	89068693          	addi	a3,a3,-1904 # ffffffffc0202868 <etext+0x99c>
ffffffffc0200fe0:	00001617          	auipc	a2,0x1
ffffffffc0200fe4:	73060613          	addi	a2,a2,1840 # ffffffffc0202710 <etext+0x844>
ffffffffc0200fe8:	0c200593          	li	a1,194
ffffffffc0200fec:	00001517          	auipc	a0,0x1
ffffffffc0200ff0:	73c50513          	addi	a0,a0,1852 # ffffffffc0202728 <etext+0x85c>
ffffffffc0200ff4:	b90ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(p0 != NULL);
ffffffffc0200ff8:	00002697          	auipc	a3,0x2
ffffffffc0200ffc:	90068693          	addi	a3,a3,-1792 # ffffffffc02028f8 <etext+0xa2c>
ffffffffc0201000:	00001617          	auipc	a2,0x1
ffffffffc0201004:	71060613          	addi	a2,a2,1808 # ffffffffc0202710 <etext+0x844>
ffffffffc0201008:	0f800593          	li	a1,248
ffffffffc020100c:	00001517          	auipc	a0,0x1
ffffffffc0201010:	71c50513          	addi	a0,a0,1820 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201014:	b70ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(nr_free == 0);
ffffffffc0201018:	00002697          	auipc	a3,0x2
ffffffffc020101c:	8d068693          	addi	a3,a3,-1840 # ffffffffc02028e8 <etext+0xa1c>
ffffffffc0201020:	00001617          	auipc	a2,0x1
ffffffffc0201024:	6f060613          	addi	a2,a2,1776 # ffffffffc0202710 <etext+0x844>
ffffffffc0201028:	0df00593          	li	a1,223
ffffffffc020102c:	00001517          	auipc	a0,0x1
ffffffffc0201030:	6fc50513          	addi	a0,a0,1788 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201034:	b50ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201038:	00002697          	auipc	a3,0x2
ffffffffc020103c:	85068693          	addi	a3,a3,-1968 # ffffffffc0202888 <etext+0x9bc>
ffffffffc0201040:	00001617          	auipc	a2,0x1
ffffffffc0201044:	6d060613          	addi	a2,a2,1744 # ffffffffc0202710 <etext+0x844>
ffffffffc0201048:	0dd00593          	li	a1,221
ffffffffc020104c:	00001517          	auipc	a0,0x1
ffffffffc0201050:	6dc50513          	addi	a0,a0,1756 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201054:	b30ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201058:	00002697          	auipc	a3,0x2
ffffffffc020105c:	87068693          	addi	a3,a3,-1936 # ffffffffc02028c8 <etext+0x9fc>
ffffffffc0201060:	00001617          	auipc	a2,0x1
ffffffffc0201064:	6b060613          	addi	a2,a2,1712 # ffffffffc0202710 <etext+0x844>
ffffffffc0201068:	0dc00593          	li	a1,220
ffffffffc020106c:	00001517          	auipc	a0,0x1
ffffffffc0201070:	6bc50513          	addi	a0,a0,1724 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201074:	b10ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201078:	00001697          	auipc	a3,0x1
ffffffffc020107c:	6e868693          	addi	a3,a3,1768 # ffffffffc0202760 <etext+0x894>
ffffffffc0201080:	00001617          	auipc	a2,0x1
ffffffffc0201084:	69060613          	addi	a2,a2,1680 # ffffffffc0202710 <etext+0x844>
ffffffffc0201088:	0b900593          	li	a1,185
ffffffffc020108c:	00001517          	auipc	a0,0x1
ffffffffc0201090:	69c50513          	addi	a0,a0,1692 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201094:	af0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201098:	00001697          	auipc	a3,0x1
ffffffffc020109c:	7f068693          	addi	a3,a3,2032 # ffffffffc0202888 <etext+0x9bc>
ffffffffc02010a0:	00001617          	auipc	a2,0x1
ffffffffc02010a4:	67060613          	addi	a2,a2,1648 # ffffffffc0202710 <etext+0x844>
ffffffffc02010a8:	0d600593          	li	a1,214
ffffffffc02010ac:	00001517          	auipc	a0,0x1
ffffffffc02010b0:	67c50513          	addi	a0,a0,1660 # ffffffffc0202728 <etext+0x85c>
ffffffffc02010b4:	ad0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010b8:	00001697          	auipc	a3,0x1
ffffffffc02010bc:	6e868693          	addi	a3,a3,1768 # ffffffffc02027a0 <etext+0x8d4>
ffffffffc02010c0:	00001617          	auipc	a2,0x1
ffffffffc02010c4:	65060613          	addi	a2,a2,1616 # ffffffffc0202710 <etext+0x844>
ffffffffc02010c8:	0d400593          	li	a1,212
ffffffffc02010cc:	00001517          	auipc	a0,0x1
ffffffffc02010d0:	65c50513          	addi	a0,a0,1628 # ffffffffc0202728 <etext+0x85c>
ffffffffc02010d4:	ab0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010d8:	00001697          	auipc	a3,0x1
ffffffffc02010dc:	6a868693          	addi	a3,a3,1704 # ffffffffc0202780 <etext+0x8b4>
ffffffffc02010e0:	00001617          	auipc	a2,0x1
ffffffffc02010e4:	63060613          	addi	a2,a2,1584 # ffffffffc0202710 <etext+0x844>
ffffffffc02010e8:	0d300593          	li	a1,211
ffffffffc02010ec:	00001517          	auipc	a0,0x1
ffffffffc02010f0:	63c50513          	addi	a0,a0,1596 # ffffffffc0202728 <etext+0x85c>
ffffffffc02010f4:	a90ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010f8:	00001697          	auipc	a3,0x1
ffffffffc02010fc:	6a868693          	addi	a3,a3,1704 # ffffffffc02027a0 <etext+0x8d4>
ffffffffc0201100:	00001617          	auipc	a2,0x1
ffffffffc0201104:	61060613          	addi	a2,a2,1552 # ffffffffc0202710 <etext+0x844>
ffffffffc0201108:	0bb00593          	li	a1,187
ffffffffc020110c:	00001517          	auipc	a0,0x1
ffffffffc0201110:	61c50513          	addi	a0,a0,1564 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201114:	a70ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(count == 0);
ffffffffc0201118:	00002697          	auipc	a3,0x2
ffffffffc020111c:	93068693          	addi	a3,a3,-1744 # ffffffffc0202a48 <etext+0xb7c>
ffffffffc0201120:	00001617          	auipc	a2,0x1
ffffffffc0201124:	5f060613          	addi	a2,a2,1520 # ffffffffc0202710 <etext+0x844>
ffffffffc0201128:	12500593          	li	a1,293
ffffffffc020112c:	00001517          	auipc	a0,0x1
ffffffffc0201130:	5fc50513          	addi	a0,a0,1532 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201134:	a50ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(nr_free == 0);
ffffffffc0201138:	00001697          	auipc	a3,0x1
ffffffffc020113c:	7b068693          	addi	a3,a3,1968 # ffffffffc02028e8 <etext+0xa1c>
ffffffffc0201140:	00001617          	auipc	a2,0x1
ffffffffc0201144:	5d060613          	addi	a2,a2,1488 # ffffffffc0202710 <etext+0x844>
ffffffffc0201148:	11a00593          	li	a1,282
ffffffffc020114c:	00001517          	auipc	a0,0x1
ffffffffc0201150:	5dc50513          	addi	a0,a0,1500 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201154:	a30ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201158:	00001697          	auipc	a3,0x1
ffffffffc020115c:	73068693          	addi	a3,a3,1840 # ffffffffc0202888 <etext+0x9bc>
ffffffffc0201160:	00001617          	auipc	a2,0x1
ffffffffc0201164:	5b060613          	addi	a2,a2,1456 # ffffffffc0202710 <etext+0x844>
ffffffffc0201168:	11800593          	li	a1,280
ffffffffc020116c:	00001517          	auipc	a0,0x1
ffffffffc0201170:	5bc50513          	addi	a0,a0,1468 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201174:	a10ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201178:	00001697          	auipc	a3,0x1
ffffffffc020117c:	6d068693          	addi	a3,a3,1744 # ffffffffc0202848 <etext+0x97c>
ffffffffc0201180:	00001617          	auipc	a2,0x1
ffffffffc0201184:	59060613          	addi	a2,a2,1424 # ffffffffc0202710 <etext+0x844>
ffffffffc0201188:	0c100593          	li	a1,193
ffffffffc020118c:	00001517          	auipc	a0,0x1
ffffffffc0201190:	59c50513          	addi	a0,a0,1436 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201194:	9f0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201198:	00002697          	auipc	a3,0x2
ffffffffc020119c:	87068693          	addi	a3,a3,-1936 # ffffffffc0202a08 <etext+0xb3c>
ffffffffc02011a0:	00001617          	auipc	a2,0x1
ffffffffc02011a4:	57060613          	addi	a2,a2,1392 # ffffffffc0202710 <etext+0x844>
ffffffffc02011a8:	11200593          	li	a1,274
ffffffffc02011ac:	00001517          	auipc	a0,0x1
ffffffffc02011b0:	57c50513          	addi	a0,a0,1404 # ffffffffc0202728 <etext+0x85c>
ffffffffc02011b4:	9d0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02011b8:	00002697          	auipc	a3,0x2
ffffffffc02011bc:	83068693          	addi	a3,a3,-2000 # ffffffffc02029e8 <etext+0xb1c>
ffffffffc02011c0:	00001617          	auipc	a2,0x1
ffffffffc02011c4:	55060613          	addi	a2,a2,1360 # ffffffffc0202710 <etext+0x844>
ffffffffc02011c8:	11000593          	li	a1,272
ffffffffc02011cc:	00001517          	auipc	a0,0x1
ffffffffc02011d0:	55c50513          	addi	a0,a0,1372 # ffffffffc0202728 <etext+0x85c>
ffffffffc02011d4:	9b0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02011d8:	00001697          	auipc	a3,0x1
ffffffffc02011dc:	7e868693          	addi	a3,a3,2024 # ffffffffc02029c0 <etext+0xaf4>
ffffffffc02011e0:	00001617          	auipc	a2,0x1
ffffffffc02011e4:	53060613          	addi	a2,a2,1328 # ffffffffc0202710 <etext+0x844>
ffffffffc02011e8:	10e00593          	li	a1,270
ffffffffc02011ec:	00001517          	auipc	a0,0x1
ffffffffc02011f0:	53c50513          	addi	a0,a0,1340 # ffffffffc0202728 <etext+0x85c>
ffffffffc02011f4:	990ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02011f8:	00001697          	auipc	a3,0x1
ffffffffc02011fc:	7a068693          	addi	a3,a3,1952 # ffffffffc0202998 <etext+0xacc>
ffffffffc0201200:	00001617          	auipc	a2,0x1
ffffffffc0201204:	51060613          	addi	a2,a2,1296 # ffffffffc0202710 <etext+0x844>
ffffffffc0201208:	10d00593          	li	a1,269
ffffffffc020120c:	00001517          	auipc	a0,0x1
ffffffffc0201210:	51c50513          	addi	a0,a0,1308 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201214:	970ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201218:	00001697          	auipc	a3,0x1
ffffffffc020121c:	77068693          	addi	a3,a3,1904 # ffffffffc0202988 <etext+0xabc>
ffffffffc0201220:	00001617          	auipc	a2,0x1
ffffffffc0201224:	4f060613          	addi	a2,a2,1264 # ffffffffc0202710 <etext+0x844>
ffffffffc0201228:	10800593          	li	a1,264
ffffffffc020122c:	00001517          	auipc	a0,0x1
ffffffffc0201230:	4fc50513          	addi	a0,a0,1276 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201234:	950ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201238:	00001697          	auipc	a3,0x1
ffffffffc020123c:	65068693          	addi	a3,a3,1616 # ffffffffc0202888 <etext+0x9bc>
ffffffffc0201240:	00001617          	auipc	a2,0x1
ffffffffc0201244:	4d060613          	addi	a2,a2,1232 # ffffffffc0202710 <etext+0x844>
ffffffffc0201248:	10700593          	li	a1,263
ffffffffc020124c:	00001517          	auipc	a0,0x1
ffffffffc0201250:	4dc50513          	addi	a0,a0,1244 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201254:	930ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201258:	00001697          	auipc	a3,0x1
ffffffffc020125c:	71068693          	addi	a3,a3,1808 # ffffffffc0202968 <etext+0xa9c>
ffffffffc0201260:	00001617          	auipc	a2,0x1
ffffffffc0201264:	4b060613          	addi	a2,a2,1200 # ffffffffc0202710 <etext+0x844>
ffffffffc0201268:	10600593          	li	a1,262
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	4bc50513          	addi	a0,a0,1212 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201274:	910ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201278:	00001697          	auipc	a3,0x1
ffffffffc020127c:	6c068693          	addi	a3,a3,1728 # ffffffffc0202938 <etext+0xa6c>
ffffffffc0201280:	00001617          	auipc	a2,0x1
ffffffffc0201284:	49060613          	addi	a2,a2,1168 # ffffffffc0202710 <etext+0x844>
ffffffffc0201288:	10500593          	li	a1,261
ffffffffc020128c:	00001517          	auipc	a0,0x1
ffffffffc0201290:	49c50513          	addi	a0,a0,1180 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201294:	8f0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201298:	00001697          	auipc	a3,0x1
ffffffffc020129c:	68868693          	addi	a3,a3,1672 # ffffffffc0202920 <etext+0xa54>
ffffffffc02012a0:	00001617          	auipc	a2,0x1
ffffffffc02012a4:	47060613          	addi	a2,a2,1136 # ffffffffc0202710 <etext+0x844>
ffffffffc02012a8:	10400593          	li	a1,260
ffffffffc02012ac:	00001517          	auipc	a0,0x1
ffffffffc02012b0:	47c50513          	addi	a0,a0,1148 # ffffffffc0202728 <etext+0x85c>
ffffffffc02012b4:	8d0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012b8:	00001697          	auipc	a3,0x1
ffffffffc02012bc:	5d068693          	addi	a3,a3,1488 # ffffffffc0202888 <etext+0x9bc>
ffffffffc02012c0:	00001617          	auipc	a2,0x1
ffffffffc02012c4:	45060613          	addi	a2,a2,1104 # ffffffffc0202710 <etext+0x844>
ffffffffc02012c8:	0fe00593          	li	a1,254
ffffffffc02012cc:	00001517          	auipc	a0,0x1
ffffffffc02012d0:	45c50513          	addi	a0,a0,1116 # ffffffffc0202728 <etext+0x85c>
ffffffffc02012d4:	8b0ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(!PageProperty(p0));
ffffffffc02012d8:	00001697          	auipc	a3,0x1
ffffffffc02012dc:	63068693          	addi	a3,a3,1584 # ffffffffc0202908 <etext+0xa3c>
ffffffffc02012e0:	00001617          	auipc	a2,0x1
ffffffffc02012e4:	43060613          	addi	a2,a2,1072 # ffffffffc0202710 <etext+0x844>
ffffffffc02012e8:	0f900593          	li	a1,249
ffffffffc02012ec:	00001517          	auipc	a0,0x1
ffffffffc02012f0:	43c50513          	addi	a0,a0,1084 # ffffffffc0202728 <etext+0x85c>
ffffffffc02012f4:	890ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012f8:	00001697          	auipc	a3,0x1
ffffffffc02012fc:	73068693          	addi	a3,a3,1840 # ffffffffc0202a28 <etext+0xb5c>
ffffffffc0201300:	00001617          	auipc	a2,0x1
ffffffffc0201304:	41060613          	addi	a2,a2,1040 # ffffffffc0202710 <etext+0x844>
ffffffffc0201308:	11700593          	li	a1,279
ffffffffc020130c:	00001517          	auipc	a0,0x1
ffffffffc0201310:	41c50513          	addi	a0,a0,1052 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201314:	870ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(total == 0);
ffffffffc0201318:	00001697          	auipc	a3,0x1
ffffffffc020131c:	74068693          	addi	a3,a3,1856 # ffffffffc0202a58 <etext+0xb8c>
ffffffffc0201320:	00001617          	auipc	a2,0x1
ffffffffc0201324:	3f060613          	addi	a2,a2,1008 # ffffffffc0202710 <etext+0x844>
ffffffffc0201328:	12600593          	li	a1,294
ffffffffc020132c:	00001517          	auipc	a0,0x1
ffffffffc0201330:	3fc50513          	addi	a0,a0,1020 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201334:	850ff0ef          	jal	ffffffffc0200384 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201338:	00001697          	auipc	a3,0x1
ffffffffc020133c:	40868693          	addi	a3,a3,1032 # ffffffffc0202740 <etext+0x874>
ffffffffc0201340:	00001617          	auipc	a2,0x1
ffffffffc0201344:	3d060613          	addi	a2,a2,976 # ffffffffc0202710 <etext+0x844>
ffffffffc0201348:	0f300593          	li	a1,243
ffffffffc020134c:	00001517          	auipc	a0,0x1
ffffffffc0201350:	3dc50513          	addi	a0,a0,988 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201354:	830ff0ef          	jal	ffffffffc0200384 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201358:	00001697          	auipc	a3,0x1
ffffffffc020135c:	42868693          	addi	a3,a3,1064 # ffffffffc0202780 <etext+0x8b4>
ffffffffc0201360:	00001617          	auipc	a2,0x1
ffffffffc0201364:	3b060613          	addi	a2,a2,944 # ffffffffc0202710 <etext+0x844>
ffffffffc0201368:	0ba00593          	li	a1,186
ffffffffc020136c:	00001517          	auipc	a0,0x1
ffffffffc0201370:	3bc50513          	addi	a0,a0,956 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201374:	810ff0ef          	jal	ffffffffc0200384 <__panic>

ffffffffc0201378 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201378:	1141                	addi	sp,sp,-16
ffffffffc020137a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020137c:	14058c63          	beqz	a1,ffffffffc02014d4 <default_free_pages+0x15c>
    for (; p != base + n; p ++) {
ffffffffc0201380:	00259713          	slli	a4,a1,0x2
ffffffffc0201384:	972e                	add	a4,a4,a1
ffffffffc0201386:	070e                	slli	a4,a4,0x3
ffffffffc0201388:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020138c:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc020138e:	c30d                	beqz	a4,ffffffffc02013b0 <default_free_pages+0x38>
ffffffffc0201390:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201392:	8b05                	andi	a4,a4,1
ffffffffc0201394:	12071063          	bnez	a4,ffffffffc02014b4 <default_free_pages+0x13c>
ffffffffc0201398:	6798                	ld	a4,8(a5)
ffffffffc020139a:	8b09                	andi	a4,a4,2
ffffffffc020139c:	10071c63          	bnez	a4,ffffffffc02014b4 <default_free_pages+0x13c>
        p->flags = 0;
ffffffffc02013a0:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02013a4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02013a8:	02878793          	addi	a5,a5,40
ffffffffc02013ac:	fed792e3          	bne	a5,a3,ffffffffc0201390 <default_free_pages+0x18>
    base->property = n;
ffffffffc02013b0:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02013b2:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02013b6:	4789                	li	a5,2
ffffffffc02013b8:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02013bc:	00005717          	auipc	a4,0x5
ffffffffc02013c0:	c7c72703          	lw	a4,-900(a4) # ffffffffc0206038 <free_area+0x10>
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	c6468693          	addi	a3,a3,-924 # ffffffffc0206028 <free_area>
    return list->next == list;
ffffffffc02013cc:	669c                	ld	a5,8(a3)
ffffffffc02013ce:	9f2d                	addw	a4,a4,a1
ffffffffc02013d0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02013d2:	0ad78563          	beq	a5,a3,ffffffffc020147c <default_free_pages+0x104>
            struct Page* page = le2page(le, page_link);
ffffffffc02013d6:	fe878713          	addi	a4,a5,-24
ffffffffc02013da:	4581                	li	a1,0
ffffffffc02013dc:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02013e0:	00e56a63          	bltu	a0,a4,ffffffffc02013f4 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc02013e4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02013e6:	06d70263          	beq	a4,a3,ffffffffc020144a <default_free_pages+0xd2>
    struct Page *p = base;
ffffffffc02013ea:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02013ec:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02013f0:	fee57ae3          	bgeu	a0,a4,ffffffffc02013e4 <default_free_pages+0x6c>
ffffffffc02013f4:	c199                	beqz	a1,ffffffffc02013fa <default_free_pages+0x82>
ffffffffc02013f6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02013fa:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02013fc:	e390                	sd	a2,0(a5)
ffffffffc02013fe:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201400:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201402:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201404:	02d70063          	beq	a4,a3,ffffffffc0201424 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201408:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc020140c:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc0201410:	02081613          	slli	a2,a6,0x20
ffffffffc0201414:	9201                	srli	a2,a2,0x20
ffffffffc0201416:	00261793          	slli	a5,a2,0x2
ffffffffc020141a:	97b2                	add	a5,a5,a2
ffffffffc020141c:	078e                	slli	a5,a5,0x3
ffffffffc020141e:	97ae                	add	a5,a5,a1
ffffffffc0201420:	02f50f63          	beq	a0,a5,ffffffffc020145e <default_free_pages+0xe6>
    return listelm->next;
ffffffffc0201424:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0201426:	00d70f63          	beq	a4,a3,ffffffffc0201444 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc020142a:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc020142c:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0201430:	02059613          	slli	a2,a1,0x20
ffffffffc0201434:	9201                	srli	a2,a2,0x20
ffffffffc0201436:	00261793          	slli	a5,a2,0x2
ffffffffc020143a:	97b2                	add	a5,a5,a2
ffffffffc020143c:	078e                	slli	a5,a5,0x3
ffffffffc020143e:	97aa                	add	a5,a5,a0
ffffffffc0201440:	04f68a63          	beq	a3,a5,ffffffffc0201494 <default_free_pages+0x11c>
}
ffffffffc0201444:	60a2                	ld	ra,8(sp)
ffffffffc0201446:	0141                	addi	sp,sp,16
ffffffffc0201448:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020144a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020144c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020144e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201450:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201452:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201454:	02d70d63          	beq	a4,a3,ffffffffc020148e <default_free_pages+0x116>
ffffffffc0201458:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020145a:	87ba                	mv	a5,a4
ffffffffc020145c:	bf41                	j	ffffffffc02013ec <default_free_pages+0x74>
            p->property += base->property;
ffffffffc020145e:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201460:	5675                	li	a2,-3
ffffffffc0201462:	010787bb          	addw	a5,a5,a6
ffffffffc0201466:	fef72c23          	sw	a5,-8(a4)
ffffffffc020146a:	60c8b02f          	amoand.d	zero,a2,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020146e:	6d10                	ld	a2,24(a0)
ffffffffc0201470:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201472:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201474:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201476:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201478:	e390                	sd	a2,0(a5)
ffffffffc020147a:	b775                	j	ffffffffc0201426 <default_free_pages+0xae>
}
ffffffffc020147c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020147e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201482:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201484:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201486:	e398                	sd	a4,0(a5)
ffffffffc0201488:	e798                	sd	a4,8(a5)
}
ffffffffc020148a:	0141                	addi	sp,sp,16
ffffffffc020148c:	8082                	ret
ffffffffc020148e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201490:	873e                	mv	a4,a5
ffffffffc0201492:	bf8d                	j	ffffffffc0201404 <default_free_pages+0x8c>
            base->property += p->property;
ffffffffc0201494:	ff872783          	lw	a5,-8(a4)
ffffffffc0201498:	56f5                	li	a3,-3
ffffffffc020149a:	9fad                	addw	a5,a5,a1
ffffffffc020149c:	c91c                	sw	a5,16(a0)
ffffffffc020149e:	ff070793          	addi	a5,a4,-16
ffffffffc02014a2:	60d7b02f          	amoand.d	zero,a3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02014a6:	6314                	ld	a3,0(a4)
ffffffffc02014a8:	671c                	ld	a5,8(a4)
}
ffffffffc02014aa:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02014ac:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02014ae:	e394                	sd	a3,0(a5)
ffffffffc02014b0:	0141                	addi	sp,sp,16
ffffffffc02014b2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02014b4:	00001697          	auipc	a3,0x1
ffffffffc02014b8:	5bc68693          	addi	a3,a3,1468 # ffffffffc0202a70 <etext+0xba4>
ffffffffc02014bc:	00001617          	auipc	a2,0x1
ffffffffc02014c0:	25460613          	addi	a2,a2,596 # ffffffffc0202710 <etext+0x844>
ffffffffc02014c4:	08300593          	li	a1,131
ffffffffc02014c8:	00001517          	auipc	a0,0x1
ffffffffc02014cc:	26050513          	addi	a0,a0,608 # ffffffffc0202728 <etext+0x85c>
ffffffffc02014d0:	eb5fe0ef          	jal	ffffffffc0200384 <__panic>
    assert(n > 0);
ffffffffc02014d4:	00001697          	auipc	a3,0x1
ffffffffc02014d8:	59468693          	addi	a3,a3,1428 # ffffffffc0202a68 <etext+0xb9c>
ffffffffc02014dc:	00001617          	auipc	a2,0x1
ffffffffc02014e0:	23460613          	addi	a2,a2,564 # ffffffffc0202710 <etext+0x844>
ffffffffc02014e4:	08000593          	li	a1,128
ffffffffc02014e8:	00001517          	auipc	a0,0x1
ffffffffc02014ec:	24050513          	addi	a0,a0,576 # ffffffffc0202728 <etext+0x85c>
ffffffffc02014f0:	e95fe0ef          	jal	ffffffffc0200384 <__panic>

ffffffffc02014f4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02014f4:	cd41                	beqz	a0,ffffffffc020158c <default_alloc_pages+0x98>
    if (n > nr_free) {
ffffffffc02014f6:	00005597          	auipc	a1,0x5
ffffffffc02014fa:	b425a583          	lw	a1,-1214(a1) # ffffffffc0206038 <free_area+0x10>
ffffffffc02014fe:	86aa                	mv	a3,a0
ffffffffc0201500:	02059793          	slli	a5,a1,0x20
ffffffffc0201504:	9381                	srli	a5,a5,0x20
ffffffffc0201506:	00a7ef63          	bltu	a5,a0,ffffffffc0201524 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc020150a:	00005617          	auipc	a2,0x5
ffffffffc020150e:	b1e60613          	addi	a2,a2,-1250 # ffffffffc0206028 <free_area>
ffffffffc0201512:	87b2                	mv	a5,a2
ffffffffc0201514:	a029                	j	ffffffffc020151e <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc0201516:	ff87e703          	lwu	a4,-8(a5)
ffffffffc020151a:	00d77763          	bgeu	a4,a3,ffffffffc0201528 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc020151e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201520:	fec79be3          	bne	a5,a2,ffffffffc0201516 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201524:	4501                	li	a0,0
}
ffffffffc0201526:	8082                	ret
        if (page->property > n) {
ffffffffc0201528:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc020152c:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201530:	6798                	ld	a4,8(a5)
ffffffffc0201532:	02089313          	slli	t1,a7,0x20
ffffffffc0201536:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020153a:	00e83423          	sd	a4,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    next->prev = prev;
ffffffffc020153e:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201542:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc0201546:	0266fc63          	bgeu	a3,t1,ffffffffc020157e <default_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc020154a:	00269713          	slli	a4,a3,0x2
ffffffffc020154e:	9736                	add	a4,a4,a3
ffffffffc0201550:	070e                	slli	a4,a4,0x3
            p->property = page->property - n;
ffffffffc0201552:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201556:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201558:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020155c:	00870313          	addi	t1,a4,8
ffffffffc0201560:	4889                	li	a7,2
ffffffffc0201562:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201566:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020156a:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020156e:	0068b023          	sd	t1,0(a7)
ffffffffc0201572:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201576:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020157a:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020157e:	9d95                	subw	a1,a1,a3
ffffffffc0201580:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201582:	5775                	li	a4,-3
ffffffffc0201584:	17c1                	addi	a5,a5,-16
ffffffffc0201586:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020158a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020158c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020158e:	00001697          	auipc	a3,0x1
ffffffffc0201592:	4da68693          	addi	a3,a3,1242 # ffffffffc0202a68 <etext+0xb9c>
ffffffffc0201596:	00001617          	auipc	a2,0x1
ffffffffc020159a:	17a60613          	addi	a2,a2,378 # ffffffffc0202710 <etext+0x844>
ffffffffc020159e:	06200593          	li	a1,98
ffffffffc02015a2:	00001517          	auipc	a0,0x1
ffffffffc02015a6:	18650513          	addi	a0,a0,390 # ffffffffc0202728 <etext+0x85c>
default_alloc_pages(size_t n) {
ffffffffc02015aa:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015ac:	dd9fe0ef          	jal	ffffffffc0200384 <__panic>

ffffffffc02015b0 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02015b0:	1141                	addi	sp,sp,-16
ffffffffc02015b2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015b4:	c9f1                	beqz	a1,ffffffffc0201688 <default_init_memmap+0xd8>
    for (; p != base + n; p ++) {
ffffffffc02015b6:	00259713          	slli	a4,a1,0x2
ffffffffc02015ba:	972e                	add	a4,a4,a1
ffffffffc02015bc:	070e                	slli	a4,a4,0x3
ffffffffc02015be:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02015c2:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc02015c4:	cf11                	beqz	a4,ffffffffc02015e0 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02015c6:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02015c8:	8b05                	andi	a4,a4,1
ffffffffc02015ca:	cf59                	beqz	a4,ffffffffc0201668 <default_init_memmap+0xb8>
        p->flags = p->property = 0;
ffffffffc02015cc:	0007a823          	sw	zero,16(a5)
ffffffffc02015d0:	0007b423          	sd	zero,8(a5)
ffffffffc02015d4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015d8:	02878793          	addi	a5,a5,40
ffffffffc02015dc:	fed795e3          	bne	a5,a3,ffffffffc02015c6 <default_init_memmap+0x16>
    base->property = n;
ffffffffc02015e0:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015e2:	4789                	li	a5,2
ffffffffc02015e4:	00850713          	addi	a4,a0,8
ffffffffc02015e8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02015ec:	00005717          	auipc	a4,0x5
ffffffffc02015f0:	a4c72703          	lw	a4,-1460(a4) # ffffffffc0206038 <free_area+0x10>
ffffffffc02015f4:	00005697          	auipc	a3,0x5
ffffffffc02015f8:	a3468693          	addi	a3,a3,-1484 # ffffffffc0206028 <free_area>
    return list->next == list;
ffffffffc02015fc:	669c                	ld	a5,8(a3)
ffffffffc02015fe:	9f2d                	addw	a4,a4,a1
ffffffffc0201600:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201602:	04d78663          	beq	a5,a3,ffffffffc020164e <default_init_memmap+0x9e>
            struct Page* page = le2page(le, page_link);
ffffffffc0201606:	fe878713          	addi	a4,a5,-24
ffffffffc020160a:	4581                	li	a1,0
ffffffffc020160c:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201610:	00e56a63          	bltu	a0,a4,ffffffffc0201624 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201614:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201616:	02d70263          	beq	a4,a3,ffffffffc020163a <default_init_memmap+0x8a>
    struct Page *p = base;
ffffffffc020161a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020161c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201620:	fee57ae3          	bgeu	a0,a4,ffffffffc0201614 <default_init_memmap+0x64>
ffffffffc0201624:	c199                	beqz	a1,ffffffffc020162a <default_init_memmap+0x7a>
ffffffffc0201626:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020162a:	6398                	ld	a4,0(a5)
}
ffffffffc020162c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020162e:	e390                	sd	a2,0(a5)
ffffffffc0201630:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201632:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201634:	f11c                	sd	a5,32(a0)
ffffffffc0201636:	0141                	addi	sp,sp,16
ffffffffc0201638:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020163a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020163c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020163e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201640:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201642:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201644:	00d70e63          	beq	a4,a3,ffffffffc0201660 <default_init_memmap+0xb0>
ffffffffc0201648:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020164a:	87ba                	mv	a5,a4
ffffffffc020164c:	bfc1                	j	ffffffffc020161c <default_init_memmap+0x6c>
}
ffffffffc020164e:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201650:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201654:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201656:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201658:	e398                	sd	a4,0(a5)
ffffffffc020165a:	e798                	sd	a4,8(a5)
}
ffffffffc020165c:	0141                	addi	sp,sp,16
ffffffffc020165e:	8082                	ret
ffffffffc0201660:	60a2                	ld	ra,8(sp)
ffffffffc0201662:	e290                	sd	a2,0(a3)
ffffffffc0201664:	0141                	addi	sp,sp,16
ffffffffc0201666:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201668:	00001697          	auipc	a3,0x1
ffffffffc020166c:	43068693          	addi	a3,a3,1072 # ffffffffc0202a98 <etext+0xbcc>
ffffffffc0201670:	00001617          	auipc	a2,0x1
ffffffffc0201674:	0a060613          	addi	a2,a2,160 # ffffffffc0202710 <etext+0x844>
ffffffffc0201678:	04900593          	li	a1,73
ffffffffc020167c:	00001517          	auipc	a0,0x1
ffffffffc0201680:	0ac50513          	addi	a0,a0,172 # ffffffffc0202728 <etext+0x85c>
ffffffffc0201684:	d01fe0ef          	jal	ffffffffc0200384 <__panic>
    assert(n > 0);
ffffffffc0201688:	00001697          	auipc	a3,0x1
ffffffffc020168c:	3e068693          	addi	a3,a3,992 # ffffffffc0202a68 <etext+0xb9c>
ffffffffc0201690:	00001617          	auipc	a2,0x1
ffffffffc0201694:	08060613          	addi	a2,a2,128 # ffffffffc0202710 <etext+0x844>
ffffffffc0201698:	04600593          	li	a1,70
ffffffffc020169c:	00001517          	auipc	a0,0x1
ffffffffc02016a0:	08c50513          	addi	a0,a0,140 # ffffffffc0202728 <etext+0x85c>
ffffffffc02016a4:	ce1fe0ef          	jal	ffffffffc0200384 <__panic>

ffffffffc02016a8 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016a8:	100027f3          	csrr	a5,sstatus
ffffffffc02016ac:	8b89                	andi	a5,a5,2
ffffffffc02016ae:	e799                	bnez	a5,ffffffffc02016bc <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02016b0:	00005797          	auipc	a5,0x5
ffffffffc02016b4:	db87b783          	ld	a5,-584(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc02016b8:	6f9c                	ld	a5,24(a5)
ffffffffc02016ba:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02016bc:	1101                	addi	sp,sp,-32
ffffffffc02016be:	ec06                	sd	ra,24(sp)
ffffffffc02016c0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02016c2:	8bcff0ef          	jal	ffffffffc020077e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02016c6:	00005797          	auipc	a5,0x5
ffffffffc02016ca:	da27b783          	ld	a5,-606(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc02016ce:	6522                	ld	a0,8(sp)
ffffffffc02016d0:	6f9c                	ld	a5,24(a5)
ffffffffc02016d2:	9782                	jalr	a5
ffffffffc02016d4:	e42a                	sd	a0,8(sp)
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02016d6:	8a2ff0ef          	jal	ffffffffc0200778 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02016da:	60e2                	ld	ra,24(sp)
ffffffffc02016dc:	6522                	ld	a0,8(sp)
ffffffffc02016de:	6105                	addi	sp,sp,32
ffffffffc02016e0:	8082                	ret

ffffffffc02016e2 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016e2:	100027f3          	csrr	a5,sstatus
ffffffffc02016e6:	8b89                	andi	a5,a5,2
ffffffffc02016e8:	e799                	bnez	a5,ffffffffc02016f6 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02016ea:	00005797          	auipc	a5,0x5
ffffffffc02016ee:	d7e7b783          	ld	a5,-642(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc02016f2:	739c                	ld	a5,32(a5)
ffffffffc02016f4:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02016f6:	1101                	addi	sp,sp,-32
ffffffffc02016f8:	ec06                	sd	ra,24(sp)
ffffffffc02016fa:	e42e                	sd	a1,8(sp)
ffffffffc02016fc:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02016fe:	880ff0ef          	jal	ffffffffc020077e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201702:	00005797          	auipc	a5,0x5
ffffffffc0201706:	d667b783          	ld	a5,-666(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc020170a:	65a2                	ld	a1,8(sp)
ffffffffc020170c:	6502                	ld	a0,0(sp)
ffffffffc020170e:	739c                	ld	a5,32(a5)
ffffffffc0201710:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201712:	60e2                	ld	ra,24(sp)
ffffffffc0201714:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201716:	862ff06f          	j	ffffffffc0200778 <intr_enable>

ffffffffc020171a <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020171a:	100027f3          	csrr	a5,sstatus
ffffffffc020171e:	8b89                	andi	a5,a5,2
ffffffffc0201720:	e799                	bnez	a5,ffffffffc020172e <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201722:	00005797          	auipc	a5,0x5
ffffffffc0201726:	d467b783          	ld	a5,-698(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc020172a:	779c                	ld	a5,40(a5)
ffffffffc020172c:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc020172e:	1101                	addi	sp,sp,-32
ffffffffc0201730:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201732:	84cff0ef          	jal	ffffffffc020077e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201736:	00005797          	auipc	a5,0x5
ffffffffc020173a:	d327b783          	ld	a5,-718(a5) # ffffffffc0206468 <pmm_manager>
ffffffffc020173e:	779c                	ld	a5,40(a5)
ffffffffc0201740:	9782                	jalr	a5
ffffffffc0201742:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201744:	834ff0ef          	jal	ffffffffc0200778 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201748:	60e2                	ld	ra,24(sp)
ffffffffc020174a:	6522                	ld	a0,8(sp)
ffffffffc020174c:	6105                	addi	sp,sp,32
ffffffffc020174e:	8082                	ret

ffffffffc0201750 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201750:	00001797          	auipc	a5,0x1
ffffffffc0201754:	5e878793          	addi	a5,a5,1512 # ffffffffc0202d38 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201758:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020175a:	7139                	addi	sp,sp,-64
ffffffffc020175c:	fc06                	sd	ra,56(sp)
ffffffffc020175e:	f822                	sd	s0,48(sp)
ffffffffc0201760:	f426                	sd	s1,40(sp)
ffffffffc0201762:	ec4e                	sd	s3,24(sp)
ffffffffc0201764:	f04a                	sd	s2,32(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201766:	00005417          	auipc	s0,0x5
ffffffffc020176a:	d0240413          	addi	s0,s0,-766 # ffffffffc0206468 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020176e:	00001517          	auipc	a0,0x1
ffffffffc0201772:	35250513          	addi	a0,a0,850 # ffffffffc0202ac0 <etext+0xbf4>
    pmm_manager = &default_pmm_manager;
ffffffffc0201776:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201778:	95bfe0ef          	jal	ffffffffc02000d2 <cprintf>
    pmm_manager->init();
ffffffffc020177c:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020177e:	00005497          	auipc	s1,0x5
ffffffffc0201782:	d0248493          	addi	s1,s1,-766 # ffffffffc0206480 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201786:	679c                	ld	a5,8(a5)
ffffffffc0201788:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020178a:	57f5                	li	a5,-3
ffffffffc020178c:	07fa                	slli	a5,a5,0x1e
ffffffffc020178e:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201790:	fd5fe0ef          	jal	ffffffffc0200764 <get_memory_base>
ffffffffc0201794:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201796:	fd9fe0ef          	jal	ffffffffc020076e <get_memory_size>
    if (mem_size == 0) {
ffffffffc020179a:	16050063          	beqz	a0,ffffffffc02018fa <pmm_init+0x1aa>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020179e:	00a98933          	add	s2,s3,a0
ffffffffc02017a2:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc02017a4:	00001517          	auipc	a0,0x1
ffffffffc02017a8:	36450513          	addi	a0,a0,868 # ffffffffc0202b08 <etext+0xc3c>
ffffffffc02017ac:	927fe0ef          	jal	ffffffffc02000d2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02017b0:	65a2                	ld	a1,8(sp)
ffffffffc02017b2:	864e                	mv	a2,s3
ffffffffc02017b4:	fff90693          	addi	a3,s2,-1
ffffffffc02017b8:	00001517          	auipc	a0,0x1
ffffffffc02017bc:	36850513          	addi	a0,a0,872 # ffffffffc0202b20 <etext+0xc54>
ffffffffc02017c0:	913fe0ef          	jal	ffffffffc02000d2 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc02017c4:	c80007b7          	lui	a5,0xc8000
ffffffffc02017c8:	864a                	mv	a2,s2
ffffffffc02017ca:	0d27e563          	bltu	a5,s2,ffffffffc0201894 <pmm_init+0x144>
ffffffffc02017ce:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017d0:	00006697          	auipc	a3,0x6
ffffffffc02017d4:	ccf68693          	addi	a3,a3,-817 # ffffffffc020749f <end+0xfff>
ffffffffc02017d8:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc02017da:	8231                	srli	a2,a2,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017dc:	00005817          	auipc	a6,0x5
ffffffffc02017e0:	cb480813          	addi	a6,a6,-844 # ffffffffc0206490 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02017e4:	00005517          	auipc	a0,0x5
ffffffffc02017e8:	ca450513          	addi	a0,a0,-860 # ffffffffc0206488 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017ec:	00d83023          	sd	a3,0(a6)
    npage = maxpa / PGSIZE;
ffffffffc02017f0:	e110                	sd	a2,0(a0)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017f2:	00080737          	lui	a4,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017f6:	87b6                	mv	a5,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017f8:	02e60a63          	beq	a2,a4,ffffffffc020182c <pmm_init+0xdc>
ffffffffc02017fc:	4701                	li	a4,0
ffffffffc02017fe:	4781                	li	a5,0
ffffffffc0201800:	4305                	li	t1,1
ffffffffc0201802:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc0201806:	96ba                	add	a3,a3,a4
ffffffffc0201808:	06a1                	addi	a3,a3,8
ffffffffc020180a:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020180e:	6110                	ld	a2,0(a0)
ffffffffc0201810:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fdf8b61>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201812:	00083683          	ld	a3,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201816:	011605b3          	add	a1,a2,a7
ffffffffc020181a:	02870713          	addi	a4,a4,40 # 80028 <kern_entry-0xffffffffc017ffd8>
ffffffffc020181e:	feb7e4e3          	bltu	a5,a1,ffffffffc0201806 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201822:	00259793          	slli	a5,a1,0x2
ffffffffc0201826:	97ae                	add	a5,a5,a1
ffffffffc0201828:	078e                	slli	a5,a5,0x3
ffffffffc020182a:	97b6                	add	a5,a5,a3
ffffffffc020182c:	c0200737          	lui	a4,0xc0200
ffffffffc0201830:	0ae7e863          	bltu	a5,a4,ffffffffc02018e0 <pmm_init+0x190>
ffffffffc0201834:	608c                	ld	a1,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201836:	777d                	lui	a4,0xfffff
ffffffffc0201838:	00e97933          	and	s2,s2,a4
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020183c:	8f8d                	sub	a5,a5,a1
    if (freemem < mem_end) {
ffffffffc020183e:	0527ed63          	bltu	a5,s2,ffffffffc0201898 <pmm_init+0x148>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201842:	601c                	ld	a5,0(s0)
ffffffffc0201844:	7b9c                	ld	a5,48(a5)
ffffffffc0201846:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201848:	00001517          	auipc	a0,0x1
ffffffffc020184c:	36050513          	addi	a0,a0,864 # ffffffffc0202ba8 <etext+0xcdc>
ffffffffc0201850:	883fe0ef          	jal	ffffffffc02000d2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201854:	00003597          	auipc	a1,0x3
ffffffffc0201858:	7ac58593          	addi	a1,a1,1964 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc020185c:	00005797          	auipc	a5,0x5
ffffffffc0201860:	c0b7be23          	sd	a1,-996(a5) # ffffffffc0206478 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201864:	c02007b7          	lui	a5,0xc0200
ffffffffc0201868:	0af5e563          	bltu	a1,a5,ffffffffc0201912 <pmm_init+0x1c2>
ffffffffc020186c:	609c                	ld	a5,0(s1)
}
ffffffffc020186e:	7442                	ld	s0,48(sp)
ffffffffc0201870:	70e2                	ld	ra,56(sp)
ffffffffc0201872:	74a2                	ld	s1,40(sp)
ffffffffc0201874:	7902                	ld	s2,32(sp)
ffffffffc0201876:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201878:	40f586b3          	sub	a3,a1,a5
ffffffffc020187c:	00005797          	auipc	a5,0x5
ffffffffc0201880:	bed7ba23          	sd	a3,-1036(a5) # ffffffffc0206470 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201884:	00001517          	auipc	a0,0x1
ffffffffc0201888:	34450513          	addi	a0,a0,836 # ffffffffc0202bc8 <etext+0xcfc>
ffffffffc020188c:	8636                	mv	a2,a3
}
ffffffffc020188e:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201890:	843fe06f          	j	ffffffffc02000d2 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201894:	863e                	mv	a2,a5
ffffffffc0201896:	bf25                	j	ffffffffc02017ce <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201898:	6585                	lui	a1,0x1
ffffffffc020189a:	15fd                	addi	a1,a1,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc020189c:	97ae                	add	a5,a5,a1
ffffffffc020189e:	8ff9                	and	a5,a5,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02018a0:	00c7d713          	srli	a4,a5,0xc
ffffffffc02018a4:	02c77263          	bgeu	a4,a2,ffffffffc02018c8 <pmm_init+0x178>
    pmm_manager->init_memmap(base, n);
ffffffffc02018a8:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02018aa:	fff805b7          	lui	a1,0xfff80
ffffffffc02018ae:	972e                	add	a4,a4,a1
ffffffffc02018b0:	00271513          	slli	a0,a4,0x2
ffffffffc02018b4:	953a                	add	a0,a0,a4
ffffffffc02018b6:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02018b8:	40f90933          	sub	s2,s2,a5
ffffffffc02018bc:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02018be:	00c95593          	srli	a1,s2,0xc
ffffffffc02018c2:	9536                	add	a0,a0,a3
ffffffffc02018c4:	9702                	jalr	a4
}
ffffffffc02018c6:	bfb5                	j	ffffffffc0201842 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc02018c8:	00001617          	auipc	a2,0x1
ffffffffc02018cc:	2b060613          	addi	a2,a2,688 # ffffffffc0202b78 <etext+0xcac>
ffffffffc02018d0:	06b00593          	li	a1,107
ffffffffc02018d4:	00001517          	auipc	a0,0x1
ffffffffc02018d8:	2c450513          	addi	a0,a0,708 # ffffffffc0202b98 <etext+0xccc>
ffffffffc02018dc:	aa9fe0ef          	jal	ffffffffc0200384 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018e0:	86be                	mv	a3,a5
ffffffffc02018e2:	00001617          	auipc	a2,0x1
ffffffffc02018e6:	26e60613          	addi	a2,a2,622 # ffffffffc0202b50 <etext+0xc84>
ffffffffc02018ea:	07100593          	li	a1,113
ffffffffc02018ee:	00001517          	auipc	a0,0x1
ffffffffc02018f2:	20a50513          	addi	a0,a0,522 # ffffffffc0202af8 <etext+0xc2c>
ffffffffc02018f6:	a8ffe0ef          	jal	ffffffffc0200384 <__panic>
        panic("DTB memory info not available");
ffffffffc02018fa:	00001617          	auipc	a2,0x1
ffffffffc02018fe:	1de60613          	addi	a2,a2,478 # ffffffffc0202ad8 <etext+0xc0c>
ffffffffc0201902:	05a00593          	li	a1,90
ffffffffc0201906:	00001517          	auipc	a0,0x1
ffffffffc020190a:	1f250513          	addi	a0,a0,498 # ffffffffc0202af8 <etext+0xc2c>
ffffffffc020190e:	a77fe0ef          	jal	ffffffffc0200384 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201912:	86ae                	mv	a3,a1
ffffffffc0201914:	00001617          	auipc	a2,0x1
ffffffffc0201918:	23c60613          	addi	a2,a2,572 # ffffffffc0202b50 <etext+0xc84>
ffffffffc020191c:	08c00593          	li	a1,140
ffffffffc0201920:	00001517          	auipc	a0,0x1
ffffffffc0201924:	1d850513          	addi	a0,a0,472 # ffffffffc0202af8 <etext+0xc2c>
ffffffffc0201928:	a5dfe0ef          	jal	ffffffffc0200384 <__panic>

ffffffffc020192c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020192c:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020192e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201932:	f022                	sd	s0,32(sp)
ffffffffc0201934:	ec26                	sd	s1,24(sp)
ffffffffc0201936:	e84a                	sd	s2,16(sp)
ffffffffc0201938:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020193a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020193e:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201940:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201944:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf8b5f>
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201948:	84aa                	mv	s1,a0
ffffffffc020194a:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc020194c:	03067d63          	bgeu	a2,a6,ffffffffc0201986 <printnum+0x5a>
ffffffffc0201950:	e44e                	sd	s3,8(sp)
ffffffffc0201952:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201954:	4785                	li	a5,1
ffffffffc0201956:	00e7d763          	bge	a5,a4,ffffffffc0201964 <printnum+0x38>
            putch(padc, putdat);
ffffffffc020195a:	85ca                	mv	a1,s2
ffffffffc020195c:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc020195e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201960:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201962:	fc65                	bnez	s0,ffffffffc020195a <printnum+0x2e>
ffffffffc0201964:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201966:	00001797          	auipc	a5,0x1
ffffffffc020196a:	2a278793          	addi	a5,a5,674 # ffffffffc0202c08 <etext+0xd3c>
ffffffffc020196e:	97d2                	add	a5,a5,s4
}
ffffffffc0201970:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201972:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201976:	70a2                	ld	ra,40(sp)
ffffffffc0201978:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020197a:	85ca                	mv	a1,s2
ffffffffc020197c:	87a6                	mv	a5,s1
}
ffffffffc020197e:	6942                	ld	s2,16(sp)
ffffffffc0201980:	64e2                	ld	s1,24(sp)
ffffffffc0201982:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201984:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201986:	03065633          	divu	a2,a2,a6
ffffffffc020198a:	8722                	mv	a4,s0
ffffffffc020198c:	fa1ff0ef          	jal	ffffffffc020192c <printnum>
ffffffffc0201990:	bfd9                	j	ffffffffc0201966 <printnum+0x3a>

ffffffffc0201992 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201992:	7119                	addi	sp,sp,-128
ffffffffc0201994:	f4a6                	sd	s1,104(sp)
ffffffffc0201996:	f0ca                	sd	s2,96(sp)
ffffffffc0201998:	ecce                	sd	s3,88(sp)
ffffffffc020199a:	e8d2                	sd	s4,80(sp)
ffffffffc020199c:	e4d6                	sd	s5,72(sp)
ffffffffc020199e:	e0da                	sd	s6,64(sp)
ffffffffc02019a0:	f862                	sd	s8,48(sp)
ffffffffc02019a2:	fc86                	sd	ra,120(sp)
ffffffffc02019a4:	f8a2                	sd	s0,112(sp)
ffffffffc02019a6:	fc5e                	sd	s7,56(sp)
ffffffffc02019a8:	f466                	sd	s9,40(sp)
ffffffffc02019aa:	f06a                	sd	s10,32(sp)
ffffffffc02019ac:	ec6e                	sd	s11,24(sp)
ffffffffc02019ae:	84aa                	mv	s1,a0
ffffffffc02019b0:	8c32                	mv	s8,a2
ffffffffc02019b2:	8a36                	mv	s4,a3
ffffffffc02019b4:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019b6:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019ba:	05500b13          	li	s6,85
ffffffffc02019be:	00001a97          	auipc	s5,0x1
ffffffffc02019c2:	3b2a8a93          	addi	s5,s5,946 # ffffffffc0202d70 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019c6:	000c4503          	lbu	a0,0(s8)
ffffffffc02019ca:	001c0413          	addi	s0,s8,1
ffffffffc02019ce:	01350a63          	beq	a0,s3,ffffffffc02019e2 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc02019d2:	cd0d                	beqz	a0,ffffffffc0201a0c <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc02019d4:	85ca                	mv	a1,s2
ffffffffc02019d6:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019d8:	00044503          	lbu	a0,0(s0)
ffffffffc02019dc:	0405                	addi	s0,s0,1
ffffffffc02019de:	ff351ae3          	bne	a0,s3,ffffffffc02019d2 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc02019e2:	5cfd                	li	s9,-1
ffffffffc02019e4:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02019e6:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02019ea:	4b81                	li	s7,0
ffffffffc02019ec:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019ee:	00044683          	lbu	a3,0(s0)
ffffffffc02019f2:	00140c13          	addi	s8,s0,1
ffffffffc02019f6:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02019fa:	0ff5f593          	zext.b	a1,a1
ffffffffc02019fe:	02bb6663          	bltu	s6,a1,ffffffffc0201a2a <vprintfmt+0x98>
ffffffffc0201a02:	058a                	slli	a1,a1,0x2
ffffffffc0201a04:	95d6                	add	a1,a1,s5
ffffffffc0201a06:	4198                	lw	a4,0(a1)
ffffffffc0201a08:	9756                	add	a4,a4,s5
ffffffffc0201a0a:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201a0c:	70e6                	ld	ra,120(sp)
ffffffffc0201a0e:	7446                	ld	s0,112(sp)
ffffffffc0201a10:	74a6                	ld	s1,104(sp)
ffffffffc0201a12:	7906                	ld	s2,96(sp)
ffffffffc0201a14:	69e6                	ld	s3,88(sp)
ffffffffc0201a16:	6a46                	ld	s4,80(sp)
ffffffffc0201a18:	6aa6                	ld	s5,72(sp)
ffffffffc0201a1a:	6b06                	ld	s6,64(sp)
ffffffffc0201a1c:	7be2                	ld	s7,56(sp)
ffffffffc0201a1e:	7c42                	ld	s8,48(sp)
ffffffffc0201a20:	7ca2                	ld	s9,40(sp)
ffffffffc0201a22:	7d02                	ld	s10,32(sp)
ffffffffc0201a24:	6de2                	ld	s11,24(sp)
ffffffffc0201a26:	6109                	addi	sp,sp,128
ffffffffc0201a28:	8082                	ret
            putch('%', putdat);
ffffffffc0201a2a:	85ca                	mv	a1,s2
ffffffffc0201a2c:	02500513          	li	a0,37
ffffffffc0201a30:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201a32:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201a36:	02500713          	li	a4,37
ffffffffc0201a3a:	8c22                	mv	s8,s0
ffffffffc0201a3c:	f8e785e3          	beq	a5,a4,ffffffffc02019c6 <vprintfmt+0x34>
ffffffffc0201a40:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201a44:	1c7d                	addi	s8,s8,-1
ffffffffc0201a46:	fee79de3          	bne	a5,a4,ffffffffc0201a40 <vprintfmt+0xae>
ffffffffc0201a4a:	bfb5                	j	ffffffffc02019c6 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201a4c:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201a50:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201a52:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0201a56:	fd06071b          	addiw	a4,a2,-48
ffffffffc0201a5a:	24e56a63          	bltu	a0,a4,ffffffffc0201cae <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201a5e:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a60:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201a62:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0201a66:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201a6a:	0197073b          	addw	a4,a4,s9
ffffffffc0201a6e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201a72:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201a74:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201a78:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201a7a:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201a7e:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201a82:	feb570e3          	bgeu	a0,a1,ffffffffc0201a62 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0201a86:	f60d54e3          	bgez	s10,ffffffffc02019ee <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201a8a:	8d66                	mv	s10,s9
ffffffffc0201a8c:	5cfd                	li	s9,-1
ffffffffc0201a8e:	b785                	j	ffffffffc02019ee <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a90:	8db6                	mv	s11,a3
ffffffffc0201a92:	8462                	mv	s0,s8
ffffffffc0201a94:	bfa9                	j	ffffffffc02019ee <vprintfmt+0x5c>
ffffffffc0201a96:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201a98:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201a9a:	bf91                	j	ffffffffc02019ee <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201a9c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201a9e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201aa2:	00f74463          	blt	a4,a5,ffffffffc0201aaa <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0201aa6:	1a078763          	beqz	a5,ffffffffc0201c54 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201aaa:	000a3603          	ld	a2,0(s4)
ffffffffc0201aae:	46c1                	li	a3,16
ffffffffc0201ab0:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201ab2:	000d879b          	sext.w	a5,s11
ffffffffc0201ab6:	876a                	mv	a4,s10
ffffffffc0201ab8:	85ca                	mv	a1,s2
ffffffffc0201aba:	8526                	mv	a0,s1
ffffffffc0201abc:	e71ff0ef          	jal	ffffffffc020192c <printnum>
            break;
ffffffffc0201ac0:	b719                	j	ffffffffc02019c6 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201ac2:	000a2503          	lw	a0,0(s4)
ffffffffc0201ac6:	85ca                	mv	a1,s2
ffffffffc0201ac8:	0a21                	addi	s4,s4,8
ffffffffc0201aca:	9482                	jalr	s1
            break;
ffffffffc0201acc:	bded                	j	ffffffffc02019c6 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201ace:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201ad0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201ad4:	00f74463          	blt	a4,a5,ffffffffc0201adc <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0201ad8:	16078963          	beqz	a5,ffffffffc0201c4a <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0201adc:	000a3603          	ld	a2,0(s4)
ffffffffc0201ae0:	46a9                	li	a3,10
ffffffffc0201ae2:	8a2e                	mv	s4,a1
ffffffffc0201ae4:	b7f9                	j	ffffffffc0201ab2 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0201ae6:	85ca                	mv	a1,s2
ffffffffc0201ae8:	03000513          	li	a0,48
ffffffffc0201aec:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0201aee:	85ca                	mv	a1,s2
ffffffffc0201af0:	07800513          	li	a0,120
ffffffffc0201af4:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201af6:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201afa:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201afc:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201afe:	bf55                	j	ffffffffc0201ab2 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0201b00:	85ca                	mv	a1,s2
ffffffffc0201b02:	02500513          	li	a0,37
ffffffffc0201b06:	9482                	jalr	s1
            break;
ffffffffc0201b08:	bd7d                	j	ffffffffc02019c6 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201b0a:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b0e:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0201b10:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201b12:	bf95                	j	ffffffffc0201a86 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0201b14:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b16:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b1a:	00f74463          	blt	a4,a5,ffffffffc0201b22 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0201b1e:	12078163          	beqz	a5,ffffffffc0201c40 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0201b22:	000a3603          	ld	a2,0(s4)
ffffffffc0201b26:	46a1                	li	a3,8
ffffffffc0201b28:	8a2e                	mv	s4,a1
ffffffffc0201b2a:	b761                	j	ffffffffc0201ab2 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0201b2c:	876a                	mv	a4,s10
ffffffffc0201b2e:	000d5363          	bgez	s10,ffffffffc0201b34 <vprintfmt+0x1a2>
ffffffffc0201b32:	4701                	li	a4,0
ffffffffc0201b34:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b38:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201b3a:	bd55                	j	ffffffffc02019ee <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201b3c:	000d841b          	sext.w	s0,s11
ffffffffc0201b40:	fd340793          	addi	a5,s0,-45
ffffffffc0201b44:	00f037b3          	snez	a5,a5
ffffffffc0201b48:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b4c:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201b50:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b52:	008a0793          	addi	a5,s4,8
ffffffffc0201b56:	e43e                	sd	a5,8(sp)
ffffffffc0201b58:	100d8c63          	beqz	s11,ffffffffc0201c70 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201b5c:	12071363          	bnez	a4,ffffffffc0201c82 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b60:	000dc783          	lbu	a5,0(s11)
ffffffffc0201b64:	0007851b          	sext.w	a0,a5
ffffffffc0201b68:	c78d                	beqz	a5,ffffffffc0201b92 <vprintfmt+0x200>
ffffffffc0201b6a:	0d85                	addi	s11,s11,1
ffffffffc0201b6c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201b6e:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b72:	000cc563          	bltz	s9,ffffffffc0201b7c <vprintfmt+0x1ea>
ffffffffc0201b76:	3cfd                	addiw	s9,s9,-1
ffffffffc0201b78:	008c8d63          	beq	s9,s0,ffffffffc0201b92 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201b7c:	020b9663          	bnez	s7,ffffffffc0201ba8 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201b80:	85ca                	mv	a1,s2
ffffffffc0201b82:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b84:	000dc783          	lbu	a5,0(s11)
ffffffffc0201b88:	0d85                	addi	s11,s11,1
ffffffffc0201b8a:	3d7d                	addiw	s10,s10,-1
ffffffffc0201b8c:	0007851b          	sext.w	a0,a5
ffffffffc0201b90:	f3ed                	bnez	a5,ffffffffc0201b72 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201b92:	01a05963          	blez	s10,ffffffffc0201ba4 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0201b96:	85ca                	mv	a1,s2
ffffffffc0201b98:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201b9c:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201b9e:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201ba0:	fe0d1be3          	bnez	s10,ffffffffc0201b96 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201ba4:	6a22                	ld	s4,8(sp)
ffffffffc0201ba6:	b505                	j	ffffffffc02019c6 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201ba8:	3781                	addiw	a5,a5,-32
ffffffffc0201baa:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201b80 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201bae:	03f00513          	li	a0,63
ffffffffc0201bb2:	85ca                	mv	a1,s2
ffffffffc0201bb4:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201bb6:	000dc783          	lbu	a5,0(s11)
ffffffffc0201bba:	0d85                	addi	s11,s11,1
ffffffffc0201bbc:	3d7d                	addiw	s10,s10,-1
ffffffffc0201bbe:	0007851b          	sext.w	a0,a5
ffffffffc0201bc2:	dbe1                	beqz	a5,ffffffffc0201b92 <vprintfmt+0x200>
ffffffffc0201bc4:	fa0cd9e3          	bgez	s9,ffffffffc0201b76 <vprintfmt+0x1e4>
ffffffffc0201bc8:	b7c5                	j	ffffffffc0201ba8 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201bca:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201bce:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201bd0:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201bd2:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201bd6:	8fb9                	xor	a5,a5,a4
ffffffffc0201bd8:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201bdc:	02d64563          	blt	a2,a3,ffffffffc0201c06 <vprintfmt+0x274>
ffffffffc0201be0:	00001797          	auipc	a5,0x1
ffffffffc0201be4:	2e878793          	addi	a5,a5,744 # ffffffffc0202ec8 <error_string>
ffffffffc0201be8:	00369713          	slli	a4,a3,0x3
ffffffffc0201bec:	97ba                	add	a5,a5,a4
ffffffffc0201bee:	639c                	ld	a5,0(a5)
ffffffffc0201bf0:	cb99                	beqz	a5,ffffffffc0201c06 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201bf2:	86be                	mv	a3,a5
ffffffffc0201bf4:	00001617          	auipc	a2,0x1
ffffffffc0201bf8:	04460613          	addi	a2,a2,68 # ffffffffc0202c38 <etext+0xd6c>
ffffffffc0201bfc:	85ca                	mv	a1,s2
ffffffffc0201bfe:	8526                	mv	a0,s1
ffffffffc0201c00:	0d8000ef          	jal	ffffffffc0201cd8 <printfmt>
ffffffffc0201c04:	b3c9                	j	ffffffffc02019c6 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201c06:	00001617          	auipc	a2,0x1
ffffffffc0201c0a:	02260613          	addi	a2,a2,34 # ffffffffc0202c28 <etext+0xd5c>
ffffffffc0201c0e:	85ca                	mv	a1,s2
ffffffffc0201c10:	8526                	mv	a0,s1
ffffffffc0201c12:	0c6000ef          	jal	ffffffffc0201cd8 <printfmt>
ffffffffc0201c16:	bb45                	j	ffffffffc02019c6 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201c18:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c1a:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201c1e:	00f74363          	blt	a4,a5,ffffffffc0201c24 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201c22:	cf81                	beqz	a5,ffffffffc0201c3a <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0201c24:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201c28:	02044b63          	bltz	s0,ffffffffc0201c5e <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201c2c:	8622                	mv	a2,s0
ffffffffc0201c2e:	8a5e                	mv	s4,s7
ffffffffc0201c30:	46a9                	li	a3,10
ffffffffc0201c32:	b541                	j	ffffffffc0201ab2 <vprintfmt+0x120>
            lflag ++;
ffffffffc0201c34:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c36:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201c38:	bb5d                	j	ffffffffc02019ee <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201c3a:	000a2403          	lw	s0,0(s4)
ffffffffc0201c3e:	b7ed                	j	ffffffffc0201c28 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201c40:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c44:	46a1                	li	a3,8
ffffffffc0201c46:	8a2e                	mv	s4,a1
ffffffffc0201c48:	b5ad                	j	ffffffffc0201ab2 <vprintfmt+0x120>
ffffffffc0201c4a:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c4e:	46a9                	li	a3,10
ffffffffc0201c50:	8a2e                	mv	s4,a1
ffffffffc0201c52:	b585                	j	ffffffffc0201ab2 <vprintfmt+0x120>
ffffffffc0201c54:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c58:	46c1                	li	a3,16
ffffffffc0201c5a:	8a2e                	mv	s4,a1
ffffffffc0201c5c:	bd99                	j	ffffffffc0201ab2 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201c5e:	85ca                	mv	a1,s2
ffffffffc0201c60:	02d00513          	li	a0,45
ffffffffc0201c64:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0201c66:	40800633          	neg	a2,s0
ffffffffc0201c6a:	8a5e                	mv	s4,s7
ffffffffc0201c6c:	46a9                	li	a3,10
ffffffffc0201c6e:	b591                	j	ffffffffc0201ab2 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201c70:	e329                	bnez	a4,ffffffffc0201cb2 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c72:	02800793          	li	a5,40
ffffffffc0201c76:	853e                	mv	a0,a5
ffffffffc0201c78:	00001d97          	auipc	s11,0x1
ffffffffc0201c7c:	fa9d8d93          	addi	s11,s11,-87 # ffffffffc0202c21 <etext+0xd55>
ffffffffc0201c80:	b5f5                	j	ffffffffc0201b6c <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c82:	85e6                	mv	a1,s9
ffffffffc0201c84:	856e                	mv	a0,s11
ffffffffc0201c86:	1aa000ef          	jal	ffffffffc0201e30 <strnlen>
ffffffffc0201c8a:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201c8e:	01a05863          	blez	s10,ffffffffc0201c9e <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201c92:	85ca                	mv	a1,s2
ffffffffc0201c94:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c96:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201c98:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c9a:	fe0d1ce3          	bnez	s10,ffffffffc0201c92 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c9e:	000dc783          	lbu	a5,0(s11)
ffffffffc0201ca2:	0007851b          	sext.w	a0,a5
ffffffffc0201ca6:	ec0792e3          	bnez	a5,ffffffffc0201b6a <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201caa:	6a22                	ld	s4,8(sp)
ffffffffc0201cac:	bb29                	j	ffffffffc02019c6 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201cae:	8462                	mv	s0,s8
ffffffffc0201cb0:	bbd9                	j	ffffffffc0201a86 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201cb2:	85e6                	mv	a1,s9
ffffffffc0201cb4:	00001517          	auipc	a0,0x1
ffffffffc0201cb8:	f6c50513          	addi	a0,a0,-148 # ffffffffc0202c20 <etext+0xd54>
ffffffffc0201cbc:	174000ef          	jal	ffffffffc0201e30 <strnlen>
ffffffffc0201cc0:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cc4:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201cc8:	00001d97          	auipc	s11,0x1
ffffffffc0201ccc:	f58d8d93          	addi	s11,s11,-168 # ffffffffc0202c20 <etext+0xd54>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cd0:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201cd2:	fda040e3          	bgtz	s10,ffffffffc0201c92 <vprintfmt+0x300>
ffffffffc0201cd6:	bd51                	j	ffffffffc0201b6a <vprintfmt+0x1d8>

ffffffffc0201cd8 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201cd8:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201cda:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201cde:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201ce0:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201ce2:	ec06                	sd	ra,24(sp)
ffffffffc0201ce4:	f83a                	sd	a4,48(sp)
ffffffffc0201ce6:	fc3e                	sd	a5,56(sp)
ffffffffc0201ce8:	e0c2                	sd	a6,64(sp)
ffffffffc0201cea:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201cec:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201cee:	ca5ff0ef          	jal	ffffffffc0201992 <vprintfmt>
}
ffffffffc0201cf2:	60e2                	ld	ra,24(sp)
ffffffffc0201cf4:	6161                	addi	sp,sp,80
ffffffffc0201cf6:	8082                	ret

ffffffffc0201cf8 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201cf8:	7179                	addi	sp,sp,-48
ffffffffc0201cfa:	f406                	sd	ra,40(sp)
ffffffffc0201cfc:	f022                	sd	s0,32(sp)
ffffffffc0201cfe:	ec26                	sd	s1,24(sp)
ffffffffc0201d00:	e84a                	sd	s2,16(sp)
ffffffffc0201d02:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc0201d04:	c901                	beqz	a0,ffffffffc0201d14 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc0201d06:	85aa                	mv	a1,a0
ffffffffc0201d08:	00001517          	auipc	a0,0x1
ffffffffc0201d0c:	f3050513          	addi	a0,a0,-208 # ffffffffc0202c38 <etext+0xd6c>
ffffffffc0201d10:	bc2fe0ef          	jal	ffffffffc02000d2 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc0201d14:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d16:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc0201d18:	00004997          	auipc	s3,0x4
ffffffffc0201d1c:	32898993          	addi	s3,s3,808 # ffffffffc0206040 <buf>
        c = getchar();
ffffffffc0201d20:	c34fe0ef          	jal	ffffffffc0200154 <getchar>
ffffffffc0201d24:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201d26:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d2a:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201d2e:	ff650693          	addi	a3,a0,-10
ffffffffc0201d32:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201d36:	02054963          	bltz	a0,ffffffffc0201d68 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d3a:	02a95f63          	bge	s2,a0,ffffffffc0201d78 <readline+0x80>
ffffffffc0201d3e:	cf0d                	beqz	a4,ffffffffc0201d78 <readline+0x80>
            cputchar(c);
ffffffffc0201d40:	bc6fe0ef          	jal	ffffffffc0200106 <cputchar>
            buf[i ++] = c;
ffffffffc0201d44:	009987b3          	add	a5,s3,s1
ffffffffc0201d48:	00878023          	sb	s0,0(a5)
ffffffffc0201d4c:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc0201d4e:	c06fe0ef          	jal	ffffffffc0200154 <getchar>
ffffffffc0201d52:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0201d54:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d58:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc0201d5c:	ff650693          	addi	a3,a0,-10
ffffffffc0201d60:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201d64:	fc055be3          	bgez	a0,ffffffffc0201d3a <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0201d68:	70a2                	ld	ra,40(sp)
ffffffffc0201d6a:	7402                	ld	s0,32(sp)
ffffffffc0201d6c:	64e2                	ld	s1,24(sp)
ffffffffc0201d6e:	6942                	ld	s2,16(sp)
ffffffffc0201d70:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0201d72:	4501                	li	a0,0
}
ffffffffc0201d74:	6145                	addi	sp,sp,48
ffffffffc0201d76:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0201d78:	eb81                	bnez	a5,ffffffffc0201d88 <readline+0x90>
            cputchar(c);
ffffffffc0201d7a:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc0201d7c:	00905663          	blez	s1,ffffffffc0201d88 <readline+0x90>
            cputchar(c);
ffffffffc0201d80:	b86fe0ef          	jal	ffffffffc0200106 <cputchar>
            i --;
ffffffffc0201d84:	34fd                	addiw	s1,s1,-1
ffffffffc0201d86:	bf69                	j	ffffffffc0201d20 <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0201d88:	c291                	beqz	a3,ffffffffc0201d8c <readline+0x94>
ffffffffc0201d8a:	fa59                	bnez	a2,ffffffffc0201d20 <readline+0x28>
            cputchar(c);
ffffffffc0201d8c:	8522                	mv	a0,s0
ffffffffc0201d8e:	b78fe0ef          	jal	ffffffffc0200106 <cputchar>
            buf[i] = '\0';
ffffffffc0201d92:	00004517          	auipc	a0,0x4
ffffffffc0201d96:	2ae50513          	addi	a0,a0,686 # ffffffffc0206040 <buf>
ffffffffc0201d9a:	94aa                	add	s1,s1,a0
ffffffffc0201d9c:	00048023          	sb	zero,0(s1)
}
ffffffffc0201da0:	70a2                	ld	ra,40(sp)
ffffffffc0201da2:	7402                	ld	s0,32(sp)
ffffffffc0201da4:	64e2                	ld	s1,24(sp)
ffffffffc0201da6:	6942                	ld	s2,16(sp)
ffffffffc0201da8:	69a2                	ld	s3,8(sp)
ffffffffc0201daa:	6145                	addi	sp,sp,48
ffffffffc0201dac:	8082                	ret

ffffffffc0201dae <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201dae:	00004717          	auipc	a4,0x4
ffffffffc0201db2:	27273703          	ld	a4,626(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201db6:	4781                	li	a5,0
ffffffffc0201db8:	88ba                	mv	a7,a4
ffffffffc0201dba:	852a                	mv	a0,a0
ffffffffc0201dbc:	85be                	mv	a1,a5
ffffffffc0201dbe:	863e                	mv	a2,a5
ffffffffc0201dc0:	00000073          	ecall
ffffffffc0201dc4:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201dc6:	8082                	ret

ffffffffc0201dc8 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201dc8:	00004717          	auipc	a4,0x4
ffffffffc0201dcc:	6d073703          	ld	a4,1744(a4) # ffffffffc0206498 <SBI_SET_TIMER>
ffffffffc0201dd0:	4781                	li	a5,0
ffffffffc0201dd2:	88ba                	mv	a7,a4
ffffffffc0201dd4:	852a                	mv	a0,a0
ffffffffc0201dd6:	85be                	mv	a1,a5
ffffffffc0201dd8:	863e                	mv	a2,a5
ffffffffc0201dda:	00000073          	ecall
ffffffffc0201dde:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201de0:	8082                	ret

ffffffffc0201de2 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201de2:	00004797          	auipc	a5,0x4
ffffffffc0201de6:	2367b783          	ld	a5,566(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201dea:	4501                	li	a0,0
ffffffffc0201dec:	88be                	mv	a7,a5
ffffffffc0201dee:	852a                	mv	a0,a0
ffffffffc0201df0:	85aa                	mv	a1,a0
ffffffffc0201df2:	862a                	mv	a2,a0
ffffffffc0201df4:	00000073          	ecall
ffffffffc0201df8:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201dfa:	2501                	sext.w	a0,a0
ffffffffc0201dfc:	8082                	ret

ffffffffc0201dfe <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201dfe:	00004717          	auipc	a4,0x4
ffffffffc0201e02:	21273703          	ld	a4,530(a4) # ffffffffc0206010 <SBI_SHUTDOWN>
ffffffffc0201e06:	4781                	li	a5,0
ffffffffc0201e08:	88ba                	mv	a7,a4
ffffffffc0201e0a:	853e                	mv	a0,a5
ffffffffc0201e0c:	85be                	mv	a1,a5
ffffffffc0201e0e:	863e                	mv	a2,a5
ffffffffc0201e10:	00000073          	ecall
ffffffffc0201e14:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201e16:	8082                	ret

ffffffffc0201e18 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201e18:	00054783          	lbu	a5,0(a0)
ffffffffc0201e1c:	cb81                	beqz	a5,ffffffffc0201e2c <strlen+0x14>
    size_t cnt = 0;
ffffffffc0201e1e:	4781                	li	a5,0
        cnt ++;
ffffffffc0201e20:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201e22:	00f50733          	add	a4,a0,a5
ffffffffc0201e26:	00074703          	lbu	a4,0(a4)
ffffffffc0201e2a:	fb7d                	bnez	a4,ffffffffc0201e20 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0201e2c:	853e                	mv	a0,a5
ffffffffc0201e2e:	8082                	ret

ffffffffc0201e30 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201e30:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e32:	e589                	bnez	a1,ffffffffc0201e3c <strnlen+0xc>
ffffffffc0201e34:	a811                	j	ffffffffc0201e48 <strnlen+0x18>
        cnt ++;
ffffffffc0201e36:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e38:	00f58863          	beq	a1,a5,ffffffffc0201e48 <strnlen+0x18>
ffffffffc0201e3c:	00f50733          	add	a4,a0,a5
ffffffffc0201e40:	00074703          	lbu	a4,0(a4)
ffffffffc0201e44:	fb6d                	bnez	a4,ffffffffc0201e36 <strnlen+0x6>
ffffffffc0201e46:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201e48:	852e                	mv	a0,a1
ffffffffc0201e4a:	8082                	ret

ffffffffc0201e4c <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e4c:	00054783          	lbu	a5,0(a0)
ffffffffc0201e50:	e791                	bnez	a5,ffffffffc0201e5c <strcmp+0x10>
ffffffffc0201e52:	a01d                	j	ffffffffc0201e78 <strcmp+0x2c>
ffffffffc0201e54:	00054783          	lbu	a5,0(a0)
ffffffffc0201e58:	cb99                	beqz	a5,ffffffffc0201e6e <strcmp+0x22>
ffffffffc0201e5a:	0585                	addi	a1,a1,1 # fffffffffff80001 <end+0x3fd79b61>
ffffffffc0201e5c:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201e60:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e62:	fef709e3          	beq	a4,a5,ffffffffc0201e54 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e66:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201e6a:	9d19                	subw	a0,a0,a4
ffffffffc0201e6c:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e6e:	0015c703          	lbu	a4,1(a1)
ffffffffc0201e72:	4501                	li	a0,0
}
ffffffffc0201e74:	9d19                	subw	a0,a0,a4
ffffffffc0201e76:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e78:	0005c703          	lbu	a4,0(a1)
ffffffffc0201e7c:	4501                	li	a0,0
ffffffffc0201e7e:	b7f5                	j	ffffffffc0201e6a <strcmp+0x1e>

ffffffffc0201e80 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e80:	ce01                	beqz	a2,ffffffffc0201e98 <strncmp+0x18>
ffffffffc0201e82:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201e86:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e88:	cb91                	beqz	a5,ffffffffc0201e9c <strncmp+0x1c>
ffffffffc0201e8a:	0005c703          	lbu	a4,0(a1)
ffffffffc0201e8e:	00f71763          	bne	a4,a5,ffffffffc0201e9c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201e92:	0505                	addi	a0,a0,1
ffffffffc0201e94:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e96:	f675                	bnez	a2,ffffffffc0201e82 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e98:	4501                	li	a0,0
ffffffffc0201e9a:	8082                	ret
ffffffffc0201e9c:	00054503          	lbu	a0,0(a0)
ffffffffc0201ea0:	0005c783          	lbu	a5,0(a1)
ffffffffc0201ea4:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201ea6:	8082                	ret

ffffffffc0201ea8 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201ea8:	a021                	j	ffffffffc0201eb0 <strchr+0x8>
        if (*s == c) {
ffffffffc0201eaa:	00f58763          	beq	a1,a5,ffffffffc0201eb8 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0201eae:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201eb0:	00054783          	lbu	a5,0(a0)
ffffffffc0201eb4:	fbfd                	bnez	a5,ffffffffc0201eaa <strchr+0x2>
    }
    return NULL;
ffffffffc0201eb6:	4501                	li	a0,0
}
ffffffffc0201eb8:	8082                	ret

ffffffffc0201eba <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201eba:	ca01                	beqz	a2,ffffffffc0201eca <memset+0x10>
ffffffffc0201ebc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201ebe:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201ec0:	0785                	addi	a5,a5,1
ffffffffc0201ec2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201ec6:	fef61de3          	bne	a2,a5,ffffffffc0201ec0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201eca:	8082                	ret
