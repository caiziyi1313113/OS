
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
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
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
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
ffffffffc0200054:	00007517          	auipc	a0,0x7
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0207028 <free_area>
ffffffffc020005c:	00007617          	auipc	a2,0x7
ffffffffc0200060:	44460613          	addi	a2,a2,1092 # ffffffffc02074a0 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	6ef010ef          	jal	ffffffffc0201f5a <memset>
    dtb_init();
ffffffffc0200070:	3e4000ef          	jal	ffffffffc0200454 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	3d2000ef          	jal	ffffffffc0200446 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00003517          	auipc	a0,0x3
ffffffffc020007c:	db850513          	addi	a0,a0,-584 # ffffffffc0202e30 <etext+0xec4>
ffffffffc0200080:	0aa000ef          	jal	ffffffffc020012a <cputs>

    print_kerninfo();
ffffffffc0200084:	102000ef          	jal	ffffffffc0200186 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200088:	71e000ef          	jal	ffffffffc02007a6 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc020008c:	764010ef          	jal	ffffffffc02017f0 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc0200090:	716000ef          	jal	ffffffffc02007a6 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200094:	370000ef          	jal	ffffffffc0200404 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200098:	702000ef          	jal	ffffffffc020079a <intr_enable>

    cprintf("=== Test 1: Illegal Instruction Exception ===\n");
ffffffffc020009c:	00002517          	auipc	a0,0x2
ffffffffc02000a0:	ed450513          	addi	a0,a0,-300 # ffffffffc0201f70 <etext+0x4>
ffffffffc02000a4:	050000ef          	jal	ffffffffc02000f4 <cprintf>
    asm volatile(".word 0x00000000");  // 插入一条非法指令
ffffffffc02000a8:	00000000          	.word	0x00000000

    cprintf("=== Test 2: Breakpoint Exception ===\n");
ffffffffc02000ac:	00002517          	auipc	a0,0x2
ffffffffc02000b0:	efc50513          	addi	a0,a0,-260 # ffffffffc0201fa8 <etext+0x3c>
ffffffffc02000b4:	040000ef          	jal	ffffffffc02000f4 <cprintf>
    asm volatile("ebreak");  // 执行断点指令
ffffffffc02000b8:	9002                	ebreak
    /* do nothing */
    while (1)
ffffffffc02000ba:	a001                	j	ffffffffc02000ba <kern_init+0x66>

ffffffffc02000bc <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc02000bc:	1101                	addi	sp,sp,-32
ffffffffc02000be:	ec06                	sd	ra,24(sp)
ffffffffc02000c0:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc02000c2:	386000ef          	jal	ffffffffc0200448 <cons_putc>
    (*cnt) ++;
ffffffffc02000c6:	65a2                	ld	a1,8(sp)
}
ffffffffc02000c8:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc02000ca:	419c                	lw	a5,0(a1)
ffffffffc02000cc:	2785                	addiw	a5,a5,1
ffffffffc02000ce:	c19c                	sw	a5,0(a1)
}
ffffffffc02000d0:	6105                	addi	sp,sp,32
ffffffffc02000d2:	8082                	ret

ffffffffc02000d4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000d4:	1101                	addi	sp,sp,-32
ffffffffc02000d6:	862a                	mv	a2,a0
ffffffffc02000d8:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000da:	00000517          	auipc	a0,0x0
ffffffffc02000de:	fe250513          	addi	a0,a0,-30 # ffffffffc02000bc <cputch>
ffffffffc02000e2:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000e4:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000e6:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e8:	14b010ef          	jal	ffffffffc0201a32 <vprintfmt>
    return cnt;
}
ffffffffc02000ec:	60e2                	ld	ra,24(sp)
ffffffffc02000ee:	4532                	lw	a0,12(sp)
ffffffffc02000f0:	6105                	addi	sp,sp,32
ffffffffc02000f2:	8082                	ret

ffffffffc02000f4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000f4:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000f6:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc02000fa:	f42e                	sd	a1,40(sp)
ffffffffc02000fc:	f832                	sd	a2,48(sp)
ffffffffc02000fe:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200100:	862a                	mv	a2,a0
ffffffffc0200102:	004c                	addi	a1,sp,4
ffffffffc0200104:	00000517          	auipc	a0,0x0
ffffffffc0200108:	fb850513          	addi	a0,a0,-72 # ffffffffc02000bc <cputch>
ffffffffc020010c:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc020010e:	ec06                	sd	ra,24(sp)
ffffffffc0200110:	e0ba                	sd	a4,64(sp)
ffffffffc0200112:	e4be                	sd	a5,72(sp)
ffffffffc0200114:	e8c2                	sd	a6,80(sp)
ffffffffc0200116:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc0200118:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc020011a:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020011c:	117010ef          	jal	ffffffffc0201a32 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200120:	60e2                	ld	ra,24(sp)
ffffffffc0200122:	4512                	lw	a0,4(sp)
ffffffffc0200124:	6125                	addi	sp,sp,96
ffffffffc0200126:	8082                	ret

ffffffffc0200128 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200128:	a605                	j	ffffffffc0200448 <cons_putc>

ffffffffc020012a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020012a:	1101                	addi	sp,sp,-32
ffffffffc020012c:	e822                	sd	s0,16(sp)
ffffffffc020012e:	ec06                	sd	ra,24(sp)
ffffffffc0200130:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200132:	00054503          	lbu	a0,0(a0)
ffffffffc0200136:	c51d                	beqz	a0,ffffffffc0200164 <cputs+0x3a>
ffffffffc0200138:	e426                	sd	s1,8(sp)
ffffffffc020013a:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020013c:	4481                	li	s1,0
    cons_putc(c);
ffffffffc020013e:	30a000ef          	jal	ffffffffc0200448 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200142:	00044503          	lbu	a0,0(s0)
ffffffffc0200146:	0405                	addi	s0,s0,1
ffffffffc0200148:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc020014a:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020014c:	f96d                	bnez	a0,ffffffffc020013e <cputs+0x14>
    cons_putc(c);
ffffffffc020014e:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc0200150:	0027841b          	addiw	s0,a5,2
ffffffffc0200154:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc0200156:	2f2000ef          	jal	ffffffffc0200448 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020015a:	60e2                	ld	ra,24(sp)
ffffffffc020015c:	8522                	mv	a0,s0
ffffffffc020015e:	6442                	ld	s0,16(sp)
ffffffffc0200160:	6105                	addi	sp,sp,32
ffffffffc0200162:	8082                	ret
    cons_putc(c);
ffffffffc0200164:	4529                	li	a0,10
ffffffffc0200166:	2e2000ef          	jal	ffffffffc0200448 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020016a:	4405                	li	s0,1
}
ffffffffc020016c:	60e2                	ld	ra,24(sp)
ffffffffc020016e:	8522                	mv	a0,s0
ffffffffc0200170:	6442                	ld	s0,16(sp)
ffffffffc0200172:	6105                	addi	sp,sp,32
ffffffffc0200174:	8082                	ret

ffffffffc0200176 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200176:	1141                	addi	sp,sp,-16
ffffffffc0200178:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020017a:	2d6000ef          	jal	ffffffffc0200450 <cons_getc>
ffffffffc020017e:	dd75                	beqz	a0,ffffffffc020017a <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200180:	60a2                	ld	ra,8(sp)
ffffffffc0200182:	0141                	addi	sp,sp,16
ffffffffc0200184:	8082                	ret

ffffffffc0200186 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200186:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200188:	00002517          	auipc	a0,0x2
ffffffffc020018c:	e4850513          	addi	a0,a0,-440 # ffffffffc0201fd0 <etext+0x64>
void print_kerninfo(void) {
ffffffffc0200190:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200192:	f63ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc0200196:	00000597          	auipc	a1,0x0
ffffffffc020019a:	ebe58593          	addi	a1,a1,-322 # ffffffffc0200054 <kern_init>
ffffffffc020019e:	00002517          	auipc	a0,0x2
ffffffffc02001a2:	e5250513          	addi	a0,a0,-430 # ffffffffc0201ff0 <etext+0x84>
ffffffffc02001a6:	f4fff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001aa:	00002597          	auipc	a1,0x2
ffffffffc02001ae:	dc258593          	addi	a1,a1,-574 # ffffffffc0201f6c <etext>
ffffffffc02001b2:	00002517          	auipc	a0,0x2
ffffffffc02001b6:	e5e50513          	addi	a0,a0,-418 # ffffffffc0202010 <etext+0xa4>
ffffffffc02001ba:	f3bff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001be:	00007597          	auipc	a1,0x7
ffffffffc02001c2:	e6a58593          	addi	a1,a1,-406 # ffffffffc0207028 <free_area>
ffffffffc02001c6:	00002517          	auipc	a0,0x2
ffffffffc02001ca:	e6a50513          	addi	a0,a0,-406 # ffffffffc0202030 <etext+0xc4>
ffffffffc02001ce:	f27ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001d2:	00007597          	auipc	a1,0x7
ffffffffc02001d6:	2ce58593          	addi	a1,a1,718 # ffffffffc02074a0 <end>
ffffffffc02001da:	00002517          	auipc	a0,0x2
ffffffffc02001de:	e7650513          	addi	a0,a0,-394 # ffffffffc0202050 <etext+0xe4>
ffffffffc02001e2:	f13ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001e6:	00000717          	auipc	a4,0x0
ffffffffc02001ea:	e6e70713          	addi	a4,a4,-402 # ffffffffc0200054 <kern_init>
ffffffffc02001ee:	00007797          	auipc	a5,0x7
ffffffffc02001f2:	6b178793          	addi	a5,a5,1713 # ffffffffc020789f <end+0x3ff>
ffffffffc02001f6:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001f8:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001fc:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001fe:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200202:	95be                	add	a1,a1,a5
ffffffffc0200204:	85a9                	srai	a1,a1,0xa
ffffffffc0200206:	00002517          	auipc	a0,0x2
ffffffffc020020a:	e6a50513          	addi	a0,a0,-406 # ffffffffc0202070 <etext+0x104>
}
ffffffffc020020e:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200210:	b5d5                	j	ffffffffc02000f4 <cprintf>

ffffffffc0200212 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200212:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200214:	00002617          	auipc	a2,0x2
ffffffffc0200218:	e8c60613          	addi	a2,a2,-372 # ffffffffc02020a0 <etext+0x134>
ffffffffc020021c:	04d00593          	li	a1,77
ffffffffc0200220:	00002517          	auipc	a0,0x2
ffffffffc0200224:	e9850513          	addi	a0,a0,-360 # ffffffffc02020b8 <etext+0x14c>
void print_stackframe(void) {
ffffffffc0200228:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020022a:	17c000ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc020022e <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020022e:	1101                	addi	sp,sp,-32
ffffffffc0200230:	e822                	sd	s0,16(sp)
ffffffffc0200232:	e426                	sd	s1,8(sp)
ffffffffc0200234:	ec06                	sd	ra,24(sp)
ffffffffc0200236:	00003417          	auipc	s0,0x3
ffffffffc020023a:	c1a40413          	addi	s0,s0,-998 # ffffffffc0202e50 <commands>
ffffffffc020023e:	00003497          	auipc	s1,0x3
ffffffffc0200242:	c5a48493          	addi	s1,s1,-934 # ffffffffc0202e98 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200246:	6410                	ld	a2,8(s0)
ffffffffc0200248:	600c                	ld	a1,0(s0)
ffffffffc020024a:	00002517          	auipc	a0,0x2
ffffffffc020024e:	e8650513          	addi	a0,a0,-378 # ffffffffc02020d0 <etext+0x164>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200252:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200254:	ea1ff0ef          	jal	ffffffffc02000f4 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200258:	fe9417e3          	bne	s0,s1,ffffffffc0200246 <mon_help+0x18>
    }
    return 0;
}
ffffffffc020025c:	60e2                	ld	ra,24(sp)
ffffffffc020025e:	6442                	ld	s0,16(sp)
ffffffffc0200260:	64a2                	ld	s1,8(sp)
ffffffffc0200262:	4501                	li	a0,0
ffffffffc0200264:	6105                	addi	sp,sp,32
ffffffffc0200266:	8082                	ret

ffffffffc0200268 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200268:	1141                	addi	sp,sp,-16
ffffffffc020026a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020026c:	f1bff0ef          	jal	ffffffffc0200186 <print_kerninfo>
    return 0;
}
ffffffffc0200270:	60a2                	ld	ra,8(sp)
ffffffffc0200272:	4501                	li	a0,0
ffffffffc0200274:	0141                	addi	sp,sp,16
ffffffffc0200276:	8082                	ret

ffffffffc0200278 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200278:	1141                	addi	sp,sp,-16
ffffffffc020027a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020027c:	f97ff0ef          	jal	ffffffffc0200212 <print_stackframe>
    return 0;
}
ffffffffc0200280:	60a2                	ld	ra,8(sp)
ffffffffc0200282:	4501                	li	a0,0
ffffffffc0200284:	0141                	addi	sp,sp,16
ffffffffc0200286:	8082                	ret

ffffffffc0200288 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200288:	7131                	addi	sp,sp,-192
ffffffffc020028a:	e952                	sd	s4,144(sp)
ffffffffc020028c:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020028e:	00002517          	auipc	a0,0x2
ffffffffc0200292:	e5250513          	addi	a0,a0,-430 # ffffffffc02020e0 <etext+0x174>
kmonitor(struct trapframe *tf) {
ffffffffc0200296:	fd06                	sd	ra,184(sp)
ffffffffc0200298:	f922                	sd	s0,176(sp)
ffffffffc020029a:	f526                	sd	s1,168(sp)
ffffffffc020029c:	ed4e                	sd	s3,152(sp)
ffffffffc020029e:	e556                	sd	s5,136(sp)
ffffffffc02002a0:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002a2:	e53ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002a6:	00002517          	auipc	a0,0x2
ffffffffc02002aa:	e6250513          	addi	a0,a0,-414 # ffffffffc0202108 <etext+0x19c>
ffffffffc02002ae:	e47ff0ef          	jal	ffffffffc02000f4 <cprintf>
    if (tf != NULL) {
ffffffffc02002b2:	000a0563          	beqz	s4,ffffffffc02002bc <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc02002b6:	8552                	mv	a0,s4
ffffffffc02002b8:	6ce000ef          	jal	ffffffffc0200986 <print_trapframe>
ffffffffc02002bc:	00003a97          	auipc	s5,0x3
ffffffffc02002c0:	b94a8a93          	addi	s5,s5,-1132 # ffffffffc0202e50 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc02002c4:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002c6:	00002517          	auipc	a0,0x2
ffffffffc02002ca:	e6a50513          	addi	a0,a0,-406 # ffffffffc0202130 <etext+0x1c4>
ffffffffc02002ce:	2cb010ef          	jal	ffffffffc0201d98 <readline>
ffffffffc02002d2:	842a                	mv	s0,a0
ffffffffc02002d4:	d96d                	beqz	a0,ffffffffc02002c6 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d6:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002da:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002dc:	e99d                	bnez	a1,ffffffffc0200312 <kmonitor+0x8a>
    int argc = 0;
ffffffffc02002de:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc02002e0:	fe0b03e3          	beqz	s6,ffffffffc02002c6 <kmonitor+0x3e>
ffffffffc02002e4:	00003497          	auipc	s1,0x3
ffffffffc02002e8:	b6c48493          	addi	s1,s1,-1172 # ffffffffc0202e50 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ec:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002ee:	6582                	ld	a1,0(sp)
ffffffffc02002f0:	6088                	ld	a0,0(s1)
ffffffffc02002f2:	3fb010ef          	jal	ffffffffc0201eec <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f6:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002f8:	c149                	beqz	a0,ffffffffc020037a <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002fa:	2405                	addiw	s0,s0,1
ffffffffc02002fc:	04e1                	addi	s1,s1,24
ffffffffc02002fe:	fef418e3          	bne	s0,a5,ffffffffc02002ee <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200302:	6582                	ld	a1,0(sp)
ffffffffc0200304:	00002517          	auipc	a0,0x2
ffffffffc0200308:	e5c50513          	addi	a0,a0,-420 # ffffffffc0202160 <etext+0x1f4>
ffffffffc020030c:	de9ff0ef          	jal	ffffffffc02000f4 <cprintf>
    return 0;
ffffffffc0200310:	bf5d                	j	ffffffffc02002c6 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200312:	00002517          	auipc	a0,0x2
ffffffffc0200316:	e2650513          	addi	a0,a0,-474 # ffffffffc0202138 <etext+0x1cc>
ffffffffc020031a:	42f010ef          	jal	ffffffffc0201f48 <strchr>
ffffffffc020031e:	c901                	beqz	a0,ffffffffc020032e <kmonitor+0xa6>
ffffffffc0200320:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200324:	00040023          	sb	zero,0(s0)
ffffffffc0200328:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020032a:	d9d5                	beqz	a1,ffffffffc02002de <kmonitor+0x56>
ffffffffc020032c:	b7dd                	j	ffffffffc0200312 <kmonitor+0x8a>
        if (*buf == '\0') {
ffffffffc020032e:	00044783          	lbu	a5,0(s0)
ffffffffc0200332:	d7d5                	beqz	a5,ffffffffc02002de <kmonitor+0x56>
        if (argc == MAXARGS - 1) {
ffffffffc0200334:	03348b63          	beq	s1,s3,ffffffffc020036a <kmonitor+0xe2>
        argv[argc ++] = buf;
ffffffffc0200338:	00349793          	slli	a5,s1,0x3
ffffffffc020033c:	978a                	add	a5,a5,sp
ffffffffc020033e:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200340:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200344:	2485                	addiw	s1,s1,1
ffffffffc0200346:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200348:	e591                	bnez	a1,ffffffffc0200354 <kmonitor+0xcc>
ffffffffc020034a:	bf59                	j	ffffffffc02002e0 <kmonitor+0x58>
ffffffffc020034c:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200350:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200352:	d5d1                	beqz	a1,ffffffffc02002de <kmonitor+0x56>
ffffffffc0200354:	00002517          	auipc	a0,0x2
ffffffffc0200358:	de450513          	addi	a0,a0,-540 # ffffffffc0202138 <etext+0x1cc>
ffffffffc020035c:	3ed010ef          	jal	ffffffffc0201f48 <strchr>
ffffffffc0200360:	d575                	beqz	a0,ffffffffc020034c <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200362:	00044583          	lbu	a1,0(s0)
ffffffffc0200366:	dda5                	beqz	a1,ffffffffc02002de <kmonitor+0x56>
ffffffffc0200368:	b76d                	j	ffffffffc0200312 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020036a:	45c1                	li	a1,16
ffffffffc020036c:	00002517          	auipc	a0,0x2
ffffffffc0200370:	dd450513          	addi	a0,a0,-556 # ffffffffc0202140 <etext+0x1d4>
ffffffffc0200374:	d81ff0ef          	jal	ffffffffc02000f4 <cprintf>
ffffffffc0200378:	b7c1                	j	ffffffffc0200338 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020037a:	00141793          	slli	a5,s0,0x1
ffffffffc020037e:	97a2                	add	a5,a5,s0
ffffffffc0200380:	078e                	slli	a5,a5,0x3
ffffffffc0200382:	97d6                	add	a5,a5,s5
ffffffffc0200384:	6b9c                	ld	a5,16(a5)
ffffffffc0200386:	fffb051b          	addiw	a0,s6,-1
ffffffffc020038a:	8652                	mv	a2,s4
ffffffffc020038c:	002c                	addi	a1,sp,8
ffffffffc020038e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200390:	f2055be3          	bgez	a0,ffffffffc02002c6 <kmonitor+0x3e>
}
ffffffffc0200394:	70ea                	ld	ra,184(sp)
ffffffffc0200396:	744a                	ld	s0,176(sp)
ffffffffc0200398:	74aa                	ld	s1,168(sp)
ffffffffc020039a:	69ea                	ld	s3,152(sp)
ffffffffc020039c:	6a4a                	ld	s4,144(sp)
ffffffffc020039e:	6aaa                	ld	s5,136(sp)
ffffffffc02003a0:	6b0a                	ld	s6,128(sp)
ffffffffc02003a2:	6129                	addi	sp,sp,192
ffffffffc02003a4:	8082                	ret

ffffffffc02003a6 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003a6:	00007317          	auipc	t1,0x7
ffffffffc02003aa:	09a32303          	lw	t1,154(t1) # ffffffffc0207440 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003ae:	715d                	addi	sp,sp,-80
ffffffffc02003b0:	ec06                	sd	ra,24(sp)
ffffffffc02003b2:	f436                	sd	a3,40(sp)
ffffffffc02003b4:	f83a                	sd	a4,48(sp)
ffffffffc02003b6:	fc3e                	sd	a5,56(sp)
ffffffffc02003b8:	e0c2                	sd	a6,64(sp)
ffffffffc02003ba:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003bc:	02031e63          	bnez	t1,ffffffffc02003f8 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003c0:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003c2:	103c                	addi	a5,sp,40
ffffffffc02003c4:	e822                	sd	s0,16(sp)
ffffffffc02003c6:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003c8:	862e                	mv	a2,a1
ffffffffc02003ca:	85aa                	mv	a1,a0
ffffffffc02003cc:	00002517          	auipc	a0,0x2
ffffffffc02003d0:	e3c50513          	addi	a0,a0,-452 # ffffffffc0202208 <etext+0x29c>
    is_panic = 1;
ffffffffc02003d4:	00007697          	auipc	a3,0x7
ffffffffc02003d8:	06e6a623          	sw	a4,108(a3) # ffffffffc0207440 <is_panic>
    va_start(ap, fmt);
ffffffffc02003dc:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003de:	d17ff0ef          	jal	ffffffffc02000f4 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003e2:	65a2                	ld	a1,8(sp)
ffffffffc02003e4:	8522                	mv	a0,s0
ffffffffc02003e6:	cefff0ef          	jal	ffffffffc02000d4 <vcprintf>
    cprintf("\n");
ffffffffc02003ea:	00002517          	auipc	a0,0x2
ffffffffc02003ee:	e3e50513          	addi	a0,a0,-450 # ffffffffc0202228 <etext+0x2bc>
ffffffffc02003f2:	d03ff0ef          	jal	ffffffffc02000f4 <cprintf>
ffffffffc02003f6:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02003f8:	3a8000ef          	jal	ffffffffc02007a0 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02003fc:	4501                	li	a0,0
ffffffffc02003fe:	e8bff0ef          	jal	ffffffffc0200288 <kmonitor>
    while (1) {
ffffffffc0200402:	bfed                	j	ffffffffc02003fc <__panic+0x56>

ffffffffc0200404 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200404:	1141                	addi	sp,sp,-16
ffffffffc0200406:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc0200408:	02000793          	li	a5,32
ffffffffc020040c:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200410:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200414:	67e1                	lui	a5,0x18
ffffffffc0200416:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041a:	953e                	add	a0,a0,a5
ffffffffc020041c:	24d010ef          	jal	ffffffffc0201e68 <sbi_set_timer>
}
ffffffffc0200420:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200422:	00007797          	auipc	a5,0x7
ffffffffc0200426:	0207b323          	sd	zero,38(a5) # ffffffffc0207448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020042a:	00002517          	auipc	a0,0x2
ffffffffc020042e:	e0650513          	addi	a0,a0,-506 # ffffffffc0202230 <etext+0x2c4>
}
ffffffffc0200432:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200434:	b1c1                	j	ffffffffc02000f4 <cprintf>

ffffffffc0200436 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200436:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043a:	67e1                	lui	a5,0x18
ffffffffc020043c:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200440:	953e                	add	a0,a0,a5
ffffffffc0200442:	2270106f          	j	ffffffffc0201e68 <sbi_set_timer>

ffffffffc0200446 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200446:	8082                	ret

ffffffffc0200448 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200448:	0ff57513          	zext.b	a0,a0
ffffffffc020044c:	2030106f          	j	ffffffffc0201e4e <sbi_console_putchar>

ffffffffc0200450 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200450:	2330106f          	j	ffffffffc0201e82 <sbi_console_getchar>

ffffffffc0200454 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200454:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc0200456:	00002517          	auipc	a0,0x2
ffffffffc020045a:	dfa50513          	addi	a0,a0,-518 # ffffffffc0202250 <etext+0x2e4>
void dtb_init(void) {
ffffffffc020045e:	f406                	sd	ra,40(sp)
ffffffffc0200460:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200462:	c93ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200466:	00007597          	auipc	a1,0x7
ffffffffc020046a:	b9a5b583          	ld	a1,-1126(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc020046e:	00002517          	auipc	a0,0x2
ffffffffc0200472:	df250513          	addi	a0,a0,-526 # ffffffffc0202260 <etext+0x2f4>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200476:	00007417          	auipc	s0,0x7
ffffffffc020047a:	b9240413          	addi	s0,s0,-1134 # ffffffffc0207008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020047e:	c77ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200482:	600c                	ld	a1,0(s0)
ffffffffc0200484:	00002517          	auipc	a0,0x2
ffffffffc0200488:	dec50513          	addi	a0,a0,-532 # ffffffffc0202270 <etext+0x304>
ffffffffc020048c:	c69ff0ef          	jal	ffffffffc02000f4 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200490:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200492:	00002517          	auipc	a0,0x2
ffffffffc0200496:	df650513          	addi	a0,a0,-522 # ffffffffc0202288 <etext+0x31c>
    if (boot_dtb == 0) {
ffffffffc020049a:	10070163          	beqz	a4,ffffffffc020059c <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020049e:	57f5                	li	a5,-3
ffffffffc02004a0:	07fa                	slli	a5,a5,0x1e
ffffffffc02004a2:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02004a4:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc02004a6:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02004aa:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed8a4d>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ae:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004b2:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b6:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ba:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004be:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c2:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	8e49                	or	a2,a2,a0
ffffffffc02004c6:	0ff7f793          	zext.b	a5,a5
ffffffffc02004ca:	8dd1                	or	a1,a1,a2
ffffffffc02004cc:	07a2                	slli	a5,a5,0x8
ffffffffc02004ce:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d0:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02004d4:	0cd59863          	bne	a1,a3,ffffffffc02005a4 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02004d8:	4710                	lw	a2,8(a4)
ffffffffc02004da:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02004dc:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004de:	0086541b          	srliw	s0,a2,0x8
ffffffffc02004e2:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e6:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02004ea:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ee:	0186151b          	slliw	a0,a2,0x18
ffffffffc02004f2:	0186959b          	slliw	a1,a3,0x18
ffffffffc02004f6:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fa:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004fe:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200502:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200506:	01c56533          	or	a0,a0,t3
ffffffffc020050a:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020050e:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200512:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200516:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020051a:	0ff6f693          	zext.b	a3,a3
ffffffffc020051e:	8c49                	or	s0,s0,a0
ffffffffc0200520:	0622                	slli	a2,a2,0x8
ffffffffc0200522:	8fcd                	or	a5,a5,a1
ffffffffc0200524:	06a2                	slli	a3,a3,0x8
ffffffffc0200526:	8c51                	or	s0,s0,a2
ffffffffc0200528:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020052a:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020052c:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020052e:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200530:	9381                	srli	a5,a5,0x20
ffffffffc0200532:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200534:	4301                	li	t1,0
        switch (token) {
ffffffffc0200536:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200538:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020053a:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc020053e:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200540:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200542:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200546:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020054a:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020054e:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200552:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200556:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020055a:	8ed1                	or	a3,a3,a2
ffffffffc020055c:	0ff77713          	zext.b	a4,a4
ffffffffc0200560:	8fd5                	or	a5,a5,a3
ffffffffc0200562:	0722                	slli	a4,a4,0x8
ffffffffc0200564:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc0200566:	05178763          	beq	a5,a7,ffffffffc02005b4 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020056a:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc020056c:	00f8e963          	bltu	a7,a5,ffffffffc020057e <dtb_init+0x12a>
ffffffffc0200570:	07c78d63          	beq	a5,t3,ffffffffc02005ea <dtb_init+0x196>
ffffffffc0200574:	4709                	li	a4,2
ffffffffc0200576:	00e79763          	bne	a5,a4,ffffffffc0200584 <dtb_init+0x130>
ffffffffc020057a:	4301                	li	t1,0
ffffffffc020057c:	b7d1                	j	ffffffffc0200540 <dtb_init+0xec>
ffffffffc020057e:	4711                	li	a4,4
ffffffffc0200580:	fce780e3          	beq	a5,a4,ffffffffc0200540 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	dcc50513          	addi	a0,a0,-564 # ffffffffc0202350 <etext+0x3e4>
ffffffffc020058c:	b69ff0ef          	jal	ffffffffc02000f4 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200590:	64e2                	ld	s1,24(sp)
ffffffffc0200592:	6942                	ld	s2,16(sp)
ffffffffc0200594:	00002517          	auipc	a0,0x2
ffffffffc0200598:	df450513          	addi	a0,a0,-524 # ffffffffc0202388 <etext+0x41c>
}
ffffffffc020059c:	7402                	ld	s0,32(sp)
ffffffffc020059e:	70a2                	ld	ra,40(sp)
ffffffffc02005a0:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc02005a2:	be89                	j	ffffffffc02000f4 <cprintf>
}
ffffffffc02005a4:	7402                	ld	s0,32(sp)
ffffffffc02005a6:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005a8:	00002517          	auipc	a0,0x2
ffffffffc02005ac:	d0050513          	addi	a0,a0,-768 # ffffffffc02022a8 <etext+0x33c>
}
ffffffffc02005b0:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005b2:	b689                	j	ffffffffc02000f4 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005b4:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b6:	0087579b          	srliw	a5,a4,0x8
ffffffffc02005ba:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005be:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c6:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ca:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ce:	8ed1                	or	a3,a3,a2
ffffffffc02005d0:	0ff77713          	zext.b	a4,a4
ffffffffc02005d4:	8fd5                	or	a5,a5,a3
ffffffffc02005d6:	0722                	slli	a4,a4,0x8
ffffffffc02005d8:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02005da:	04031463          	bnez	t1,ffffffffc0200622 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02005de:	1782                	slli	a5,a5,0x20
ffffffffc02005e0:	9381                	srli	a5,a5,0x20
ffffffffc02005e2:	043d                	addi	s0,s0,15
ffffffffc02005e4:	943e                	add	s0,s0,a5
ffffffffc02005e6:	9871                	andi	s0,s0,-4
                break;
ffffffffc02005e8:	bfa1                	j	ffffffffc0200540 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02005ea:	8522                	mv	a0,s0
ffffffffc02005ec:	e01a                	sd	t1,0(sp)
ffffffffc02005ee:	0cb010ef          	jal	ffffffffc0201eb8 <strlen>
ffffffffc02005f2:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005f4:	4619                	li	a2,6
ffffffffc02005f6:	8522                	mv	a0,s0
ffffffffc02005f8:	00002597          	auipc	a1,0x2
ffffffffc02005fc:	cd858593          	addi	a1,a1,-808 # ffffffffc02022d0 <etext+0x364>
ffffffffc0200600:	121010ef          	jal	ffffffffc0201f20 <strncmp>
ffffffffc0200604:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200606:	0411                	addi	s0,s0,4
ffffffffc0200608:	0004879b          	sext.w	a5,s1
ffffffffc020060c:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020060e:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200612:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200614:	00a36333          	or	t1,t1,a0
                break;
ffffffffc0200618:	00ff0837          	lui	a6,0xff0
ffffffffc020061c:	488d                	li	a7,3
ffffffffc020061e:	4e05                	li	t3,1
ffffffffc0200620:	b705                	j	ffffffffc0200540 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200622:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200624:	00002597          	auipc	a1,0x2
ffffffffc0200628:	cb458593          	addi	a1,a1,-844 # ffffffffc02022d8 <etext+0x36c>
ffffffffc020062c:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062e:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200632:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200636:	0187169b          	slliw	a3,a4,0x18
ffffffffc020063a:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020063e:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200642:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200646:	8ed1                	or	a3,a3,a2
ffffffffc0200648:	0ff77713          	zext.b	a4,a4
ffffffffc020064c:	0722                	slli	a4,a4,0x8
ffffffffc020064e:	8d55                	or	a0,a0,a3
ffffffffc0200650:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200652:	1502                	slli	a0,a0,0x20
ffffffffc0200654:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200656:	954a                	add	a0,a0,s2
ffffffffc0200658:	e01a                	sd	t1,0(sp)
ffffffffc020065a:	093010ef          	jal	ffffffffc0201eec <strcmp>
ffffffffc020065e:	67a2                	ld	a5,8(sp)
ffffffffc0200660:	473d                	li	a4,15
ffffffffc0200662:	6302                	ld	t1,0(sp)
ffffffffc0200664:	00ff0837          	lui	a6,0xff0
ffffffffc0200668:	488d                	li	a7,3
ffffffffc020066a:	4e05                	li	t3,1
ffffffffc020066c:	f6f779e3          	bgeu	a4,a5,ffffffffc02005de <dtb_init+0x18a>
ffffffffc0200670:	f53d                	bnez	a0,ffffffffc02005de <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200672:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200676:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	c6650513          	addi	a0,a0,-922 # ffffffffc02022e0 <etext+0x374>
           fdt32_to_cpu(x >> 32);
ffffffffc0200682:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200686:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020068a:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020068e:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200696:	0187959b          	slliw	a1,a5,0x18
ffffffffc020069a:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069e:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a2:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a6:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	01037333          	and	t1,t1,a6
ffffffffc02006ae:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b2:	01e5e5b3          	or	a1,a1,t5
ffffffffc02006b6:	0ff7f793          	zext.b	a5,a5
ffffffffc02006ba:	01de6e33          	or	t3,t3,t4
ffffffffc02006be:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	01067633          	and	a2,a2,a6
ffffffffc02006c6:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02006ca:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	07a2                	slli	a5,a5,0x8
ffffffffc02006d0:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02006d4:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02006d8:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02006dc:	8ddd                	or	a1,a1,a5
ffffffffc02006de:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e2:	0186979b          	slliw	a5,a3,0x18
ffffffffc02006e6:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ea:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ee:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006f2:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006f6:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006fa:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fe:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200702:	08a2                	slli	a7,a7,0x8
ffffffffc0200704:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020070c:	0ff6f693          	zext.b	a3,a3
ffffffffc0200710:	01de6833          	or	a6,t3,t4
ffffffffc0200714:	0ff77713          	zext.b	a4,a4
ffffffffc0200718:	01166633          	or	a2,a2,a7
ffffffffc020071c:	0067e7b3          	or	a5,a5,t1
ffffffffc0200720:	06a2                	slli	a3,a3,0x8
ffffffffc0200722:	01046433          	or	s0,s0,a6
ffffffffc0200726:	0722                	slli	a4,a4,0x8
ffffffffc0200728:	8fd5                	or	a5,a5,a3
ffffffffc020072a:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc020072c:	1582                	slli	a1,a1,0x20
ffffffffc020072e:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200730:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200732:	9201                	srli	a2,a2,0x20
ffffffffc0200734:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200736:	1402                	slli	s0,s0,0x20
ffffffffc0200738:	00b7e4b3          	or	s1,a5,a1
ffffffffc020073c:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc020073e:	9b7ff0ef          	jal	ffffffffc02000f4 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200742:	85a6                	mv	a1,s1
ffffffffc0200744:	00002517          	auipc	a0,0x2
ffffffffc0200748:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0202300 <etext+0x394>
ffffffffc020074c:	9a9ff0ef          	jal	ffffffffc02000f4 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200750:	01445613          	srli	a2,s0,0x14
ffffffffc0200754:	85a2                	mv	a1,s0
ffffffffc0200756:	00002517          	auipc	a0,0x2
ffffffffc020075a:	bc250513          	addi	a0,a0,-1086 # ffffffffc0202318 <etext+0x3ac>
ffffffffc020075e:	997ff0ef          	jal	ffffffffc02000f4 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200762:	009405b3          	add	a1,s0,s1
ffffffffc0200766:	15fd                	addi	a1,a1,-1
ffffffffc0200768:	00002517          	auipc	a0,0x2
ffffffffc020076c:	bd050513          	addi	a0,a0,-1072 # ffffffffc0202338 <etext+0x3cc>
ffffffffc0200770:	985ff0ef          	jal	ffffffffc02000f4 <cprintf>
        memory_base = mem_base;
ffffffffc0200774:	00007797          	auipc	a5,0x7
ffffffffc0200778:	ce97b223          	sd	s1,-796(a5) # ffffffffc0207458 <memory_base>
        memory_size = mem_size;
ffffffffc020077c:	00007797          	auipc	a5,0x7
ffffffffc0200780:	cc87ba23          	sd	s0,-812(a5) # ffffffffc0207450 <memory_size>
ffffffffc0200784:	b531                	j	ffffffffc0200590 <dtb_init+0x13c>

ffffffffc0200786 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200786:	00007517          	auipc	a0,0x7
ffffffffc020078a:	cd253503          	ld	a0,-814(a0) # ffffffffc0207458 <memory_base>
ffffffffc020078e:	8082                	ret

ffffffffc0200790 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc0200790:	00007517          	auipc	a0,0x7
ffffffffc0200794:	cc053503          	ld	a0,-832(a0) # ffffffffc0207450 <memory_size>
ffffffffc0200798:	8082                	ret

ffffffffc020079a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020079a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020079e:	8082                	ret

ffffffffc02007a0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02007a0:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02007a4:	8082                	ret

ffffffffc02007a6 <idt_init>:

    //它会保存通用寄存器，然后跳转到 C 函数 trap()。
    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02007a6:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02007aa:	00000797          	auipc	a5,0x0
ffffffffc02007ae:	3ba78793          	addi	a5,a5,954 # ffffffffc0200b64 <__alltraps>
ffffffffc02007b2:	10579073          	csrw	stvec,a5
}
ffffffffc02007b6:	8082                	ret

ffffffffc02007b8 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007b8:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc02007ba:	1141                	addi	sp,sp,-16
ffffffffc02007bc:	e022                	sd	s0,0(sp)
ffffffffc02007be:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007c0:	00002517          	auipc	a0,0x2
ffffffffc02007c4:	be050513          	addi	a0,a0,-1056 # ffffffffc02023a0 <etext+0x434>
void print_regs(struct pushregs *gpr) {
ffffffffc02007c8:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007ca:	92bff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02007ce:	640c                	ld	a1,8(s0)
ffffffffc02007d0:	00002517          	auipc	a0,0x2
ffffffffc02007d4:	be850513          	addi	a0,a0,-1048 # ffffffffc02023b8 <etext+0x44c>
ffffffffc02007d8:	91dff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02007dc:	680c                	ld	a1,16(s0)
ffffffffc02007de:	00002517          	auipc	a0,0x2
ffffffffc02007e2:	bf250513          	addi	a0,a0,-1038 # ffffffffc02023d0 <etext+0x464>
ffffffffc02007e6:	90fff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02007ea:	6c0c                	ld	a1,24(s0)
ffffffffc02007ec:	00002517          	auipc	a0,0x2
ffffffffc02007f0:	bfc50513          	addi	a0,a0,-1028 # ffffffffc02023e8 <etext+0x47c>
ffffffffc02007f4:	901ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02007f8:	700c                	ld	a1,32(s0)
ffffffffc02007fa:	00002517          	auipc	a0,0x2
ffffffffc02007fe:	c0650513          	addi	a0,a0,-1018 # ffffffffc0202400 <etext+0x494>
ffffffffc0200802:	8f3ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200806:	740c                	ld	a1,40(s0)
ffffffffc0200808:	00002517          	auipc	a0,0x2
ffffffffc020080c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0202418 <etext+0x4ac>
ffffffffc0200810:	8e5ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200814:	780c                	ld	a1,48(s0)
ffffffffc0200816:	00002517          	auipc	a0,0x2
ffffffffc020081a:	c1a50513          	addi	a0,a0,-998 # ffffffffc0202430 <etext+0x4c4>
ffffffffc020081e:	8d7ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200822:	7c0c                	ld	a1,56(s0)
ffffffffc0200824:	00002517          	auipc	a0,0x2
ffffffffc0200828:	c2450513          	addi	a0,a0,-988 # ffffffffc0202448 <etext+0x4dc>
ffffffffc020082c:	8c9ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200830:	602c                	ld	a1,64(s0)
ffffffffc0200832:	00002517          	auipc	a0,0x2
ffffffffc0200836:	c2e50513          	addi	a0,a0,-978 # ffffffffc0202460 <etext+0x4f4>
ffffffffc020083a:	8bbff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020083e:	642c                	ld	a1,72(s0)
ffffffffc0200840:	00002517          	auipc	a0,0x2
ffffffffc0200844:	c3850513          	addi	a0,a0,-968 # ffffffffc0202478 <etext+0x50c>
ffffffffc0200848:	8adff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020084c:	682c                	ld	a1,80(s0)
ffffffffc020084e:	00002517          	auipc	a0,0x2
ffffffffc0200852:	c4250513          	addi	a0,a0,-958 # ffffffffc0202490 <etext+0x524>
ffffffffc0200856:	89fff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020085a:	6c2c                	ld	a1,88(s0)
ffffffffc020085c:	00002517          	auipc	a0,0x2
ffffffffc0200860:	c4c50513          	addi	a0,a0,-948 # ffffffffc02024a8 <etext+0x53c>
ffffffffc0200864:	891ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200868:	702c                	ld	a1,96(s0)
ffffffffc020086a:	00002517          	auipc	a0,0x2
ffffffffc020086e:	c5650513          	addi	a0,a0,-938 # ffffffffc02024c0 <etext+0x554>
ffffffffc0200872:	883ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200876:	742c                	ld	a1,104(s0)
ffffffffc0200878:	00002517          	auipc	a0,0x2
ffffffffc020087c:	c6050513          	addi	a0,a0,-928 # ffffffffc02024d8 <etext+0x56c>
ffffffffc0200880:	875ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200884:	782c                	ld	a1,112(s0)
ffffffffc0200886:	00002517          	auipc	a0,0x2
ffffffffc020088a:	c6a50513          	addi	a0,a0,-918 # ffffffffc02024f0 <etext+0x584>
ffffffffc020088e:	867ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200892:	7c2c                	ld	a1,120(s0)
ffffffffc0200894:	00002517          	auipc	a0,0x2
ffffffffc0200898:	c7450513          	addi	a0,a0,-908 # ffffffffc0202508 <etext+0x59c>
ffffffffc020089c:	859ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc02008a0:	604c                	ld	a1,128(s0)
ffffffffc02008a2:	00002517          	auipc	a0,0x2
ffffffffc02008a6:	c7e50513          	addi	a0,a0,-898 # ffffffffc0202520 <etext+0x5b4>
ffffffffc02008aa:	84bff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc02008ae:	644c                	ld	a1,136(s0)
ffffffffc02008b0:	00002517          	auipc	a0,0x2
ffffffffc02008b4:	c8850513          	addi	a0,a0,-888 # ffffffffc0202538 <etext+0x5cc>
ffffffffc02008b8:	83dff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc02008bc:	684c                	ld	a1,144(s0)
ffffffffc02008be:	00002517          	auipc	a0,0x2
ffffffffc02008c2:	c9250513          	addi	a0,a0,-878 # ffffffffc0202550 <etext+0x5e4>
ffffffffc02008c6:	82fff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02008ca:	6c4c                	ld	a1,152(s0)
ffffffffc02008cc:	00002517          	auipc	a0,0x2
ffffffffc02008d0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0202568 <etext+0x5fc>
ffffffffc02008d4:	821ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02008d8:	704c                	ld	a1,160(s0)
ffffffffc02008da:	00002517          	auipc	a0,0x2
ffffffffc02008de:	ca650513          	addi	a0,a0,-858 # ffffffffc0202580 <etext+0x614>
ffffffffc02008e2:	813ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02008e6:	744c                	ld	a1,168(s0)
ffffffffc02008e8:	00002517          	auipc	a0,0x2
ffffffffc02008ec:	cb050513          	addi	a0,a0,-848 # ffffffffc0202598 <etext+0x62c>
ffffffffc02008f0:	805ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02008f4:	784c                	ld	a1,176(s0)
ffffffffc02008f6:	00002517          	auipc	a0,0x2
ffffffffc02008fa:	cba50513          	addi	a0,a0,-838 # ffffffffc02025b0 <etext+0x644>
ffffffffc02008fe:	ff6ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200902:	7c4c                	ld	a1,184(s0)
ffffffffc0200904:	00002517          	auipc	a0,0x2
ffffffffc0200908:	cc450513          	addi	a0,a0,-828 # ffffffffc02025c8 <etext+0x65c>
ffffffffc020090c:	fe8ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200910:	606c                	ld	a1,192(s0)
ffffffffc0200912:	00002517          	auipc	a0,0x2
ffffffffc0200916:	cce50513          	addi	a0,a0,-818 # ffffffffc02025e0 <etext+0x674>
ffffffffc020091a:	fdaff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc020091e:	646c                	ld	a1,200(s0)
ffffffffc0200920:	00002517          	auipc	a0,0x2
ffffffffc0200924:	cd850513          	addi	a0,a0,-808 # ffffffffc02025f8 <etext+0x68c>
ffffffffc0200928:	fccff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc020092c:	686c                	ld	a1,208(s0)
ffffffffc020092e:	00002517          	auipc	a0,0x2
ffffffffc0200932:	ce250513          	addi	a0,a0,-798 # ffffffffc0202610 <etext+0x6a4>
ffffffffc0200936:	fbeff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc020093a:	6c6c                	ld	a1,216(s0)
ffffffffc020093c:	00002517          	auipc	a0,0x2
ffffffffc0200940:	cec50513          	addi	a0,a0,-788 # ffffffffc0202628 <etext+0x6bc>
ffffffffc0200944:	fb0ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200948:	706c                	ld	a1,224(s0)
ffffffffc020094a:	00002517          	auipc	a0,0x2
ffffffffc020094e:	cf650513          	addi	a0,a0,-778 # ffffffffc0202640 <etext+0x6d4>
ffffffffc0200952:	fa2ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200956:	746c                	ld	a1,232(s0)
ffffffffc0200958:	00002517          	auipc	a0,0x2
ffffffffc020095c:	d0050513          	addi	a0,a0,-768 # ffffffffc0202658 <etext+0x6ec>
ffffffffc0200960:	f94ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200964:	786c                	ld	a1,240(s0)
ffffffffc0200966:	00002517          	auipc	a0,0x2
ffffffffc020096a:	d0a50513          	addi	a0,a0,-758 # ffffffffc0202670 <etext+0x704>
ffffffffc020096e:	f86ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200972:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200974:	6402                	ld	s0,0(sp)
ffffffffc0200976:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200978:	00002517          	auipc	a0,0x2
ffffffffc020097c:	d1050513          	addi	a0,a0,-752 # ffffffffc0202688 <etext+0x71c>
}
ffffffffc0200980:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200982:	f72ff06f          	j	ffffffffc02000f4 <cprintf>

ffffffffc0200986 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200986:	1141                	addi	sp,sp,-16
ffffffffc0200988:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020098a:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc020098c:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020098e:	00002517          	auipc	a0,0x2
ffffffffc0200992:	d1250513          	addi	a0,a0,-750 # ffffffffc02026a0 <etext+0x734>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200996:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200998:	f5cff0ef          	jal	ffffffffc02000f4 <cprintf>
    print_regs(&tf->gpr);
ffffffffc020099c:	8522                	mv	a0,s0
ffffffffc020099e:	e1bff0ef          	jal	ffffffffc02007b8 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc02009a2:	10043583          	ld	a1,256(s0)
ffffffffc02009a6:	00002517          	auipc	a0,0x2
ffffffffc02009aa:	d1250513          	addi	a0,a0,-750 # ffffffffc02026b8 <etext+0x74c>
ffffffffc02009ae:	f46ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc02009b2:	10843583          	ld	a1,264(s0)
ffffffffc02009b6:	00002517          	auipc	a0,0x2
ffffffffc02009ba:	d1a50513          	addi	a0,a0,-742 # ffffffffc02026d0 <etext+0x764>
ffffffffc02009be:	f36ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc02009c2:	11043583          	ld	a1,272(s0)
ffffffffc02009c6:	00002517          	auipc	a0,0x2
ffffffffc02009ca:	d2250513          	addi	a0,a0,-734 # ffffffffc02026e8 <etext+0x77c>
ffffffffc02009ce:	f26ff0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009d2:	11843583          	ld	a1,280(s0)
}
ffffffffc02009d6:	6402                	ld	s0,0(sp)
ffffffffc02009d8:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009da:	00002517          	auipc	a0,0x2
ffffffffc02009de:	d2650513          	addi	a0,a0,-730 # ffffffffc0202700 <etext+0x794>
}
ffffffffc02009e2:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02009e4:	f10ff06f          	j	ffffffffc02000f4 <cprintf>

ffffffffc02009e8 <interrupt_handler>:

//处理中断
void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc02009e8:	11853783          	ld	a5,280(a0)
ffffffffc02009ec:	472d                	li	a4,11
ffffffffc02009ee:	0786                	slli	a5,a5,0x1
ffffffffc02009f0:	8385                	srli	a5,a5,0x1
ffffffffc02009f2:	0af76a63          	bltu	a4,a5,ffffffffc0200aa6 <interrupt_handler+0xbe>
ffffffffc02009f6:	00002717          	auipc	a4,0x2
ffffffffc02009fa:	4a270713          	addi	a4,a4,1186 # ffffffffc0202e98 <commands+0x48>
ffffffffc02009fe:	078a                	slli	a5,a5,0x2
ffffffffc0200a00:	97ba                	add	a5,a5,a4
ffffffffc0200a02:	439c                	lw	a5,0(a5)
ffffffffc0200a04:	97ba                	add	a5,a5,a4
ffffffffc0200a06:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a08:	00002517          	auipc	a0,0x2
ffffffffc0200a0c:	d7050513          	addi	a0,a0,-656 # ffffffffc0202778 <etext+0x80c>
ffffffffc0200a10:	ee4ff06f          	j	ffffffffc02000f4 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200a14:	00002517          	auipc	a0,0x2
ffffffffc0200a18:	d4450513          	addi	a0,a0,-700 # ffffffffc0202758 <etext+0x7ec>
ffffffffc0200a1c:	ed8ff06f          	j	ffffffffc02000f4 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200a20:	00002517          	auipc	a0,0x2
ffffffffc0200a24:	cf850513          	addi	a0,a0,-776 # ffffffffc0202718 <etext+0x7ac>
ffffffffc0200a28:	eccff06f          	j	ffffffffc02000f4 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200a2c:	00002517          	auipc	a0,0x2
ffffffffc0200a30:	d6c50513          	addi	a0,a0,-660 # ffffffffc0202798 <etext+0x82c>
ffffffffc0200a34:	ec0ff06f          	j	ffffffffc02000f4 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a38:	1141                	addi	sp,sp,-16
ffffffffc0200a3a:	e406                	sd	ra,8(sp)
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            // 1) 预约下次时钟中断
            clock_set_next_event();
ffffffffc0200a3c:	9fbff0ef          	jal	ffffffffc0200436 <clock_set_next_event>

            // 2) 递增全局时钟计数
            ticks++;
ffffffffc0200a40:	00007797          	auipc	a5,0x7
ffffffffc0200a44:	a0878793          	addi	a5,a5,-1528 # ffffffffc0207448 <ticks>
ffffffffc0200a48:	6394                	ld	a3,0(a5)

            // 3) 每到 100 次打印一次
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a4a:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200a4e:	28f70713          	addi	a4,a4,655 # 28f5c28f <kern_entry-0xffffffff972a3d71>
            ticks++;
ffffffffc0200a52:	0685                	addi	a3,a3,1
ffffffffc0200a54:	e394                	sd	a3,0(a5)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a56:	6390                	ld	a2,0(a5)
ffffffffc0200a58:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200a5c:	1702                	slli	a4,a4,0x20
ffffffffc0200a5e:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <kern_entry-0xffffffff63f70a3d>
ffffffffc0200a62:	00265793          	srli	a5,a2,0x2
ffffffffc0200a66:	9736                	add	a4,a4,a3
ffffffffc0200a68:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200a6c:	06400593          	li	a1,100
ffffffffc0200a70:	8389                	srli	a5,a5,0x2
ffffffffc0200a72:	02b787b3          	mul	a5,a5,a1
ffffffffc0200a76:	02f60963          	beq	a2,a5,ffffffffc0200aa8 <interrupt_handler+0xc0>
                print_ticks(); // 输出 "100 ticks"（由 print_ticks() 完成）
                num++;         // 记录打印了几次“100 ticks”
            }

            // 4) 打印到第 10 次时关机
            if (num == 10) {
ffffffffc0200a7a:	00007797          	auipc	a5,0x7
ffffffffc0200a7e:	9e67b783          	ld	a5,-1562(a5) # ffffffffc0207460 <num>
ffffffffc0200a82:	4729                	li	a4,10
ffffffffc0200a84:	04e78263          	beq	a5,a4,ffffffffc0200ac8 <interrupt_handler+0xe0>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a88:	60a2                	ld	ra,8(sp)
ffffffffc0200a8a:	0141                	addi	sp,sp,16
ffffffffc0200a8c:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a8e:	00002517          	auipc	a0,0x2
ffffffffc0200a92:	d3250513          	addi	a0,a0,-718 # ffffffffc02027c0 <etext+0x854>
ffffffffc0200a96:	e5eff06f          	j	ffffffffc02000f4 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200a9a:	00002517          	auipc	a0,0x2
ffffffffc0200a9e:	c9e50513          	addi	a0,a0,-866 # ffffffffc0202738 <etext+0x7cc>
ffffffffc0200aa2:	e52ff06f          	j	ffffffffc02000f4 <cprintf>
            print_trapframe(tf);
ffffffffc0200aa6:	b5c5                	j	ffffffffc0200986 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200aa8:	00002517          	auipc	a0,0x2
ffffffffc0200aac:	d0850513          	addi	a0,a0,-760 # ffffffffc02027b0 <etext+0x844>
ffffffffc0200ab0:	e44ff0ef          	jal	ffffffffc02000f4 <cprintf>
                num++;         // 记录打印了几次“100 ticks”
ffffffffc0200ab4:	00007797          	auipc	a5,0x7
ffffffffc0200ab8:	9ac7b783          	ld	a5,-1620(a5) # ffffffffc0207460 <num>
ffffffffc0200abc:	0785                	addi	a5,a5,1
ffffffffc0200abe:	00007717          	auipc	a4,0x7
ffffffffc0200ac2:	9af73123          	sd	a5,-1630(a4) # ffffffffc0207460 <num>
ffffffffc0200ac6:	bf75                	j	ffffffffc0200a82 <interrupt_handler+0x9a>
}
ffffffffc0200ac8:	60a2                	ld	ra,8(sp)
ffffffffc0200aca:	0141                	addi	sp,sp,16
                sbi_shutdown();
ffffffffc0200acc:	3d20106f          	j	ffffffffc0201e9e <sbi_shutdown>

ffffffffc0200ad0 <exception_handler>:

//处理异常
void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200ad0:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200ad4:	1101                	addi	sp,sp,-32
ffffffffc0200ad6:	ec06                	sd	ra,24(sp)
    switch (tf->cause) {
ffffffffc0200ad8:	468d                	li	a3,3
ffffffffc0200ada:	04d78663          	beq	a5,a3,ffffffffc0200b26 <exception_handler+0x56>
ffffffffc0200ade:	02f6ed63          	bltu	a3,a5,ffffffffc0200b18 <exception_handler+0x48>
ffffffffc0200ae2:	4689                	li	a3,2
ffffffffc0200ae4:	02d79763          	bne	a5,a3,ffffffffc0200b12 <exception_handler+0x42>
             /* LAB3 CHALLENGE3   YOUR CODE :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Illegal instruction caught at 0x%016lx\n", (unsigned long)tf->epc);
ffffffffc0200ae8:	10853583          	ld	a1,264(a0)
ffffffffc0200aec:	e42a                	sd	a0,8(sp)
ffffffffc0200aee:	00002517          	auipc	a0,0x2
ffffffffc0200af2:	cf250513          	addi	a0,a0,-782 # ffffffffc02027e0 <etext+0x874>
ffffffffc0200af6:	dfeff0ef          	jal	ffffffffc02000f4 <cprintf>
            cprintf("Exception type: Illegal instruction\n");
ffffffffc0200afa:	00002517          	auipc	a0,0x2
ffffffffc0200afe:	d0e50513          	addi	a0,a0,-754 # ffffffffc0202808 <etext+0x89c>
ffffffffc0200b02:	df2ff0ef          	jal	ffffffffc02000f4 <cprintf>
            tf->epc += 4;  // 跳过非法指令（RISC-V 32-bit 指令）
ffffffffc0200b06:	6722                	ld	a4,8(sp)
ffffffffc0200b08:	10873783          	ld	a5,264(a4)
ffffffffc0200b0c:	0791                	addi	a5,a5,4
ffffffffc0200b0e:	10f73423          	sd	a5,264(a4)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b12:	60e2                	ld	ra,24(sp)
ffffffffc0200b14:	6105                	addi	sp,sp,32
ffffffffc0200b16:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b18:	17f1                	addi	a5,a5,-4
ffffffffc0200b1a:	471d                	li	a4,7
ffffffffc0200b1c:	fef77be3          	bgeu	a4,a5,ffffffffc0200b12 <exception_handler+0x42>
}
ffffffffc0200b20:	60e2                	ld	ra,24(sp)
ffffffffc0200b22:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200b24:	b58d                	j	ffffffffc0200986 <print_trapframe>
            cprintf("ebreak caught at 0x%016lx\n", (unsigned long)tf->epc);
ffffffffc0200b26:	10853583          	ld	a1,264(a0)
ffffffffc0200b2a:	e42a                	sd	a0,8(sp)
ffffffffc0200b2c:	00002517          	auipc	a0,0x2
ffffffffc0200b30:	d0450513          	addi	a0,a0,-764 # ffffffffc0202830 <etext+0x8c4>
ffffffffc0200b34:	dc0ff0ef          	jal	ffffffffc02000f4 <cprintf>
            cprintf("Exception type: breakpoint\n");
ffffffffc0200b38:	00002517          	auipc	a0,0x2
ffffffffc0200b3c:	d1850513          	addi	a0,a0,-744 # ffffffffc0202850 <etext+0x8e4>
ffffffffc0200b40:	db4ff0ef          	jal	ffffffffc02000f4 <cprintf>
            tf->epc += 2;  // 跳过 ebreak 指令
ffffffffc0200b44:	6722                	ld	a4,8(sp)
}
ffffffffc0200b46:	60e2                	ld	ra,24(sp)
            tf->epc += 2;  // 跳过 ebreak 指令
ffffffffc0200b48:	10873783          	ld	a5,264(a4)
ffffffffc0200b4c:	0789                	addi	a5,a5,2
ffffffffc0200b4e:	10f73423          	sd	a5,264(a4)
}
ffffffffc0200b52:	6105                	addi	sp,sp,32
ffffffffc0200b54:	8082                	ret

ffffffffc0200b56 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    ////scause的最高位是1，说明trap是由中断引起的
    //在 64 位机器上，tf->cause 是一个无符号数。
    //如果最高位为 1，则转成有符号整数 (intptr_t) 后变成负数。
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200b56:	11853783          	ld	a5,280(a0)
ffffffffc0200b5a:	0007c363          	bltz	a5,ffffffffc0200b60 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200b5e:	bf8d                	j	ffffffffc0200ad0 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200b60:	b561                	j	ffffffffc02009e8 <interrupt_handler>
	...

ffffffffc0200b64 <__alltraps>:

    .globl __alltraps
    .align(2)
__alltraps:
    #保存上下文
    SAVE_ALL
ffffffffc0200b64:	14011073          	csrw	sscratch,sp
ffffffffc0200b68:	712d                	addi	sp,sp,-288
ffffffffc0200b6a:	e002                	sd	zero,0(sp)
ffffffffc0200b6c:	e406                	sd	ra,8(sp)
ffffffffc0200b6e:	ec0e                	sd	gp,24(sp)
ffffffffc0200b70:	f012                	sd	tp,32(sp)
ffffffffc0200b72:	f416                	sd	t0,40(sp)
ffffffffc0200b74:	f81a                	sd	t1,48(sp)
ffffffffc0200b76:	fc1e                	sd	t2,56(sp)
ffffffffc0200b78:	e0a2                	sd	s0,64(sp)
ffffffffc0200b7a:	e4a6                	sd	s1,72(sp)
ffffffffc0200b7c:	e8aa                	sd	a0,80(sp)
ffffffffc0200b7e:	ecae                	sd	a1,88(sp)
ffffffffc0200b80:	f0b2                	sd	a2,96(sp)
ffffffffc0200b82:	f4b6                	sd	a3,104(sp)
ffffffffc0200b84:	f8ba                	sd	a4,112(sp)
ffffffffc0200b86:	fcbe                	sd	a5,120(sp)
ffffffffc0200b88:	e142                	sd	a6,128(sp)
ffffffffc0200b8a:	e546                	sd	a7,136(sp)
ffffffffc0200b8c:	e94a                	sd	s2,144(sp)
ffffffffc0200b8e:	ed4e                	sd	s3,152(sp)
ffffffffc0200b90:	f152                	sd	s4,160(sp)
ffffffffc0200b92:	f556                	sd	s5,168(sp)
ffffffffc0200b94:	f95a                	sd	s6,176(sp)
ffffffffc0200b96:	fd5e                	sd	s7,184(sp)
ffffffffc0200b98:	e1e2                	sd	s8,192(sp)
ffffffffc0200b9a:	e5e6                	sd	s9,200(sp)
ffffffffc0200b9c:	e9ea                	sd	s10,208(sp)
ffffffffc0200b9e:	edee                	sd	s11,216(sp)
ffffffffc0200ba0:	f1f2                	sd	t3,224(sp)
ffffffffc0200ba2:	f5f6                	sd	t4,232(sp)
ffffffffc0200ba4:	f9fa                	sd	t5,240(sp)
ffffffffc0200ba6:	fdfe                	sd	t6,248(sp)
ffffffffc0200ba8:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200bac:	100024f3          	csrr	s1,sstatus
ffffffffc0200bb0:	14102973          	csrr	s2,sepc
ffffffffc0200bb4:	143029f3          	csrr	s3,stval
ffffffffc0200bb8:	14202a73          	csrr	s4,scause
ffffffffc0200bbc:	e822                	sd	s0,16(sp)
ffffffffc0200bbe:	e226                	sd	s1,256(sp)
ffffffffc0200bc0:	e64a                	sd	s2,264(sp)
ffffffffc0200bc2:	ea4e                	sd	s3,272(sp)
ffffffffc0200bc4:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200bc6:	850a                	mv	a0,sp

    ##trap是trap.c里面的一个C语言函数，也就是我们的中断处理程序
    jal trap
ffffffffc0200bc8:	f8fff0ef          	jal	ffffffffc0200b56 <trap>

ffffffffc0200bcc <__trapret>:
    #对于系统调用，这通常是 ecall指令的下一条指令地址（即sepc + 4）；
    #对于中断，这是被中断打断的指令地址（即sepc）；
    #对于进程切换，这是新进程的起始地址。
    #3、将sstatus.SPP设置为 0，表示要返回到 U 模式。
    
    RESTORE_ALL
ffffffffc0200bcc:	6492                	ld	s1,256(sp)
ffffffffc0200bce:	6932                	ld	s2,264(sp)
ffffffffc0200bd0:	10049073          	csrw	sstatus,s1
ffffffffc0200bd4:	14191073          	csrw	sepc,s2
ffffffffc0200bd8:	60a2                	ld	ra,8(sp)
ffffffffc0200bda:	61e2                	ld	gp,24(sp)
ffffffffc0200bdc:	7202                	ld	tp,32(sp)
ffffffffc0200bde:	72a2                	ld	t0,40(sp)
ffffffffc0200be0:	7342                	ld	t1,48(sp)
ffffffffc0200be2:	73e2                	ld	t2,56(sp)
ffffffffc0200be4:	6406                	ld	s0,64(sp)
ffffffffc0200be6:	64a6                	ld	s1,72(sp)
ffffffffc0200be8:	6546                	ld	a0,80(sp)
ffffffffc0200bea:	65e6                	ld	a1,88(sp)
ffffffffc0200bec:	7606                	ld	a2,96(sp)
ffffffffc0200bee:	76a6                	ld	a3,104(sp)
ffffffffc0200bf0:	7746                	ld	a4,112(sp)
ffffffffc0200bf2:	77e6                	ld	a5,120(sp)
ffffffffc0200bf4:	680a                	ld	a6,128(sp)
ffffffffc0200bf6:	68aa                	ld	a7,136(sp)
ffffffffc0200bf8:	694a                	ld	s2,144(sp)
ffffffffc0200bfa:	69ea                	ld	s3,152(sp)
ffffffffc0200bfc:	7a0a                	ld	s4,160(sp)
ffffffffc0200bfe:	7aaa                	ld	s5,168(sp)
ffffffffc0200c00:	7b4a                	ld	s6,176(sp)
ffffffffc0200c02:	7bea                	ld	s7,184(sp)
ffffffffc0200c04:	6c0e                	ld	s8,192(sp)
ffffffffc0200c06:	6cae                	ld	s9,200(sp)
ffffffffc0200c08:	6d4e                	ld	s10,208(sp)
ffffffffc0200c0a:	6dee                	ld	s11,216(sp)
ffffffffc0200c0c:	7e0e                	ld	t3,224(sp)
ffffffffc0200c0e:	7eae                	ld	t4,232(sp)
ffffffffc0200c10:	7f4e                	ld	t5,240(sp)
ffffffffc0200c12:	7fee                	ld	t6,248(sp)
ffffffffc0200c14:	6142                	ld	sp,16(sp)
    #特权指令，用于从S返回（完成从内核态到用户态的切换）
    #1、根据sstatus.SPP的值（此时为 0）切换回 U 模式。
    #2、恢复中断使能状态，将sstatus.SIE恢复为sstatus.SPIE的值。
    #3、更新sstatus，将sstatus.SPIE设置为 1,sstatus.SPP设置为 0，为下一次中断做准备。
    
    sret
ffffffffc0200c16:	10200073          	sret

ffffffffc0200c1a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200c1a:	00006797          	auipc	a5,0x6
ffffffffc0200c1e:	40e78793          	addi	a5,a5,1038 # ffffffffc0207028 <free_area>
ffffffffc0200c22:	e79c                	sd	a5,8(a5)
ffffffffc0200c24:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200c26:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200c2a:	8082                	ret

ffffffffc0200c2c <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200c2c:	00006517          	auipc	a0,0x6
ffffffffc0200c30:	40c56503          	lwu	a0,1036(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200c34:	8082                	ret

ffffffffc0200c36 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200c36:	711d                	addi	sp,sp,-96
ffffffffc0200c38:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200c3a:	00006917          	auipc	s2,0x6
ffffffffc0200c3e:	3ee90913          	addi	s2,s2,1006 # ffffffffc0207028 <free_area>
ffffffffc0200c42:	00893783          	ld	a5,8(s2)
ffffffffc0200c46:	ec86                	sd	ra,88(sp)
ffffffffc0200c48:	e8a2                	sd	s0,80(sp)
ffffffffc0200c4a:	e4a6                	sd	s1,72(sp)
ffffffffc0200c4c:	fc4e                	sd	s3,56(sp)
ffffffffc0200c4e:	f852                	sd	s4,48(sp)
ffffffffc0200c50:	f456                	sd	s5,40(sp)
ffffffffc0200c52:	f05a                	sd	s6,32(sp)
ffffffffc0200c54:	ec5e                	sd	s7,24(sp)
ffffffffc0200c56:	e862                	sd	s8,16(sp)
ffffffffc0200c58:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c5a:	31278b63          	beq	a5,s2,ffffffffc0200f70 <default_check+0x33a>
    int count = 0, total = 0;
ffffffffc0200c5e:	4401                	li	s0,0
ffffffffc0200c60:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c62:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200c66:	8b09                	andi	a4,a4,2
ffffffffc0200c68:	30070863          	beqz	a4,ffffffffc0200f78 <default_check+0x342>
        count ++, total += p->property;
ffffffffc0200c6c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200c70:	679c                	ld	a5,8(a5)
ffffffffc0200c72:	2485                	addiw	s1,s1,1
ffffffffc0200c74:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c76:	ff2796e3          	bne	a5,s2,ffffffffc0200c62 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200c7a:	89a2                	mv	s3,s0
ffffffffc0200c7c:	33f000ef          	jal	ffffffffc02017ba <nr_free_pages>
ffffffffc0200c80:	75351c63          	bne	a0,s3,ffffffffc02013d8 <default_check+0x7a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c84:	4505                	li	a0,1
ffffffffc0200c86:	2c3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200c8a:	8aaa                	mv	s5,a0
ffffffffc0200c8c:	48050663          	beqz	a0,ffffffffc0201118 <default_check+0x4e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c90:	4505                	li	a0,1
ffffffffc0200c92:	2b7000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200c96:	89aa                	mv	s3,a0
ffffffffc0200c98:	76050063          	beqz	a0,ffffffffc02013f8 <default_check+0x7c2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c9c:	4505                	li	a0,1
ffffffffc0200c9e:	2ab000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200ca2:	8a2a                	mv	s4,a0
ffffffffc0200ca4:	4e050a63          	beqz	a0,ffffffffc0201198 <default_check+0x562>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ca8:	40aa87b3          	sub	a5,s5,a0
ffffffffc0200cac:	40a98733          	sub	a4,s3,a0
ffffffffc0200cb0:	0017b793          	seqz	a5,a5
ffffffffc0200cb4:	00173713          	seqz	a4,a4
ffffffffc0200cb8:	8fd9                	or	a5,a5,a4
ffffffffc0200cba:	32079f63          	bnez	a5,ffffffffc0200ff8 <default_check+0x3c2>
ffffffffc0200cbe:	333a8d63          	beq	s5,s3,ffffffffc0200ff8 <default_check+0x3c2>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200cc2:	000aa783          	lw	a5,0(s5)
ffffffffc0200cc6:	2c079963          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
ffffffffc0200cca:	0009a783          	lw	a5,0(s3)
ffffffffc0200cce:	2c079563          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
ffffffffc0200cd2:	411c                	lw	a5,0(a0)
ffffffffc0200cd4:	2c079263          	bnez	a5,ffffffffc0200f98 <default_check+0x362>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cd8:	00006797          	auipc	a5,0x6
ffffffffc0200cdc:	7b87b783          	ld	a5,1976(a5) # ffffffffc0207490 <pages>
ffffffffc0200ce0:	ccccd737          	lui	a4,0xccccd
ffffffffc0200ce4:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac582d>
ffffffffc0200ce8:	02071693          	slli	a3,a4,0x20
ffffffffc0200cec:	96ba                	add	a3,a3,a4
ffffffffc0200cee:	40fa8733          	sub	a4,s5,a5
ffffffffc0200cf2:	870d                	srai	a4,a4,0x3
ffffffffc0200cf4:	02d70733          	mul	a4,a4,a3
ffffffffc0200cf8:	00002517          	auipc	a0,0x2
ffffffffc0200cfc:	39853503          	ld	a0,920(a0) # ffffffffc0203090 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200d00:	00006697          	auipc	a3,0x6
ffffffffc0200d04:	7886b683          	ld	a3,1928(a3) # ffffffffc0207488 <npage>
ffffffffc0200d08:	06b2                	slli	a3,a3,0xc
ffffffffc0200d0a:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d0c:	0732                	slli	a4,a4,0xc
ffffffffc0200d0e:	2cd77563          	bgeu	a4,a3,ffffffffc0200fd8 <default_check+0x3a2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d12:	ccccd5b7          	lui	a1,0xccccd
ffffffffc0200d16:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac582d>
ffffffffc0200d1a:	02059613          	slli	a2,a1,0x20
ffffffffc0200d1e:	40f98733          	sub	a4,s3,a5
ffffffffc0200d22:	962e                	add	a2,a2,a1
ffffffffc0200d24:	870d                	srai	a4,a4,0x3
ffffffffc0200d26:	02c70733          	mul	a4,a4,a2
ffffffffc0200d2a:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d2c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200d2e:	4ed77563          	bgeu	a4,a3,ffffffffc0201218 <default_check+0x5e2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d32:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200d36:	878d                	srai	a5,a5,0x3
ffffffffc0200d38:	02c787b3          	mul	a5,a5,a2
ffffffffc0200d3c:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d3e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200d40:	32d7fc63          	bgeu	a5,a3,ffffffffc0201078 <default_check+0x442>
    assert(alloc_page() == NULL);
ffffffffc0200d44:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d46:	00093c03          	ld	s8,0(s2)
ffffffffc0200d4a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200d4e:	00006b17          	auipc	s6,0x6
ffffffffc0200d52:	2eab2b03          	lw	s6,746(s6) # ffffffffc0207038 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200d56:	01293023          	sd	s2,0(s2)
ffffffffc0200d5a:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200d5e:	00006797          	auipc	a5,0x6
ffffffffc0200d62:	2c07ad23          	sw	zero,730(a5) # ffffffffc0207038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200d66:	1e3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200d6a:	2e051763          	bnez	a0,ffffffffc0201058 <default_check+0x422>
    free_page(p0);
ffffffffc0200d6e:	8556                	mv	a0,s5
ffffffffc0200d70:	4585                	li	a1,1
ffffffffc0200d72:	211000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p1);
ffffffffc0200d76:	854e                	mv	a0,s3
ffffffffc0200d78:	4585                	li	a1,1
ffffffffc0200d7a:	209000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200d7e:	8552                	mv	a0,s4
ffffffffc0200d80:	4585                	li	a1,1
ffffffffc0200d82:	201000ef          	jal	ffffffffc0201782 <free_pages>
    assert(nr_free == 3);
ffffffffc0200d86:	00006717          	auipc	a4,0x6
ffffffffc0200d8a:	2b272703          	lw	a4,690(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200d8e:	478d                	li	a5,3
ffffffffc0200d90:	2af71463          	bne	a4,a5,ffffffffc0201038 <default_check+0x402>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d94:	4505                	li	a0,1
ffffffffc0200d96:	1b3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200d9a:	89aa                	mv	s3,a0
ffffffffc0200d9c:	26050e63          	beqz	a0,ffffffffc0201018 <default_check+0x3e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200da0:	4505                	li	a0,1
ffffffffc0200da2:	1a7000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200da6:	8aaa                	mv	s5,a0
ffffffffc0200da8:	3c050863          	beqz	a0,ffffffffc0201178 <default_check+0x542>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200dac:	4505                	li	a0,1
ffffffffc0200dae:	19b000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200db2:	8a2a                	mv	s4,a0
ffffffffc0200db4:	3a050263          	beqz	a0,ffffffffc0201158 <default_check+0x522>
    assert(alloc_page() == NULL);
ffffffffc0200db8:	4505                	li	a0,1
ffffffffc0200dba:	18f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200dbe:	36051d63          	bnez	a0,ffffffffc0201138 <default_check+0x502>
    free_page(p0);
ffffffffc0200dc2:	4585                	li	a1,1
ffffffffc0200dc4:	854e                	mv	a0,s3
ffffffffc0200dc6:	1bd000ef          	jal	ffffffffc0201782 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200dca:	00893783          	ld	a5,8(s2)
ffffffffc0200dce:	1f278563          	beq	a5,s2,ffffffffc0200fb8 <default_check+0x382>
    assert((p = alloc_page()) == p0);
ffffffffc0200dd2:	4505                	li	a0,1
ffffffffc0200dd4:	175000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200dd8:	8caa                	mv	s9,a0
ffffffffc0200dda:	30a99f63          	bne	s3,a0,ffffffffc02010f8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200dde:	4505                	li	a0,1
ffffffffc0200de0:	169000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200de4:	2e051a63          	bnez	a0,ffffffffc02010d8 <default_check+0x4a2>
    assert(nr_free == 0);
ffffffffc0200de8:	00006797          	auipc	a5,0x6
ffffffffc0200dec:	2507a783          	lw	a5,592(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200df0:	2c079463          	bnez	a5,ffffffffc02010b8 <default_check+0x482>
    free_page(p);
ffffffffc0200df4:	8566                	mv	a0,s9
ffffffffc0200df6:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200df8:	01893023          	sd	s8,0(s2)
ffffffffc0200dfc:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200e00:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200e04:	17f000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p1);
ffffffffc0200e08:	8556                	mv	a0,s5
ffffffffc0200e0a:	4585                	li	a1,1
ffffffffc0200e0c:	177000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200e10:	8552                	mv	a0,s4
ffffffffc0200e12:	4585                	li	a1,1
ffffffffc0200e14:	16f000ef          	jal	ffffffffc0201782 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200e18:	4515                	li	a0,5
ffffffffc0200e1a:	12f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e1e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200e20:	26050c63          	beqz	a0,ffffffffc0201098 <default_check+0x462>
ffffffffc0200e24:	651c                	ld	a5,8(a0)
ffffffffc0200e26:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200e28:	8b85                	andi	a5,a5,1
ffffffffc0200e2a:	54079763          	bnez	a5,ffffffffc0201378 <default_check+0x742>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200e2e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e30:	00093b83          	ld	s7,0(s2)
ffffffffc0200e34:	00893b03          	ld	s6,8(s2)
ffffffffc0200e38:	01293023          	sd	s2,0(s2)
ffffffffc0200e3c:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200e40:	109000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e44:	50051a63          	bnez	a0,ffffffffc0201358 <default_check+0x722>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200e48:	05098a13          	addi	s4,s3,80
ffffffffc0200e4c:	8552                	mv	a0,s4
ffffffffc0200e4e:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200e50:	00006c17          	auipc	s8,0x6
ffffffffc0200e54:	1e8c2c03          	lw	s8,488(s8) # ffffffffc0207038 <free_area+0x10>
    nr_free = 0;
ffffffffc0200e58:	00006797          	auipc	a5,0x6
ffffffffc0200e5c:	1e07a023          	sw	zero,480(a5) # ffffffffc0207038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200e60:	123000ef          	jal	ffffffffc0201782 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200e64:	4511                	li	a0,4
ffffffffc0200e66:	0e3000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e6a:	4c051763          	bnez	a0,ffffffffc0201338 <default_check+0x702>
ffffffffc0200e6e:	0589b783          	ld	a5,88(s3)
ffffffffc0200e72:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200e74:	8b85                	andi	a5,a5,1
ffffffffc0200e76:	4a078163          	beqz	a5,ffffffffc0201318 <default_check+0x6e2>
ffffffffc0200e7a:	0609a503          	lw	a0,96(s3)
ffffffffc0200e7e:	478d                	li	a5,3
ffffffffc0200e80:	48f51c63          	bne	a0,a5,ffffffffc0201318 <default_check+0x6e2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200e84:	0c5000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e88:	8aaa                	mv	s5,a0
ffffffffc0200e8a:	46050763          	beqz	a0,ffffffffc02012f8 <default_check+0x6c2>
    assert(alloc_page() == NULL);
ffffffffc0200e8e:	4505                	li	a0,1
ffffffffc0200e90:	0b9000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200e94:	44051263          	bnez	a0,ffffffffc02012d8 <default_check+0x6a2>
    assert(p0 + 2 == p1);
ffffffffc0200e98:	435a1063          	bne	s4,s5,ffffffffc02012b8 <default_check+0x682>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200e9c:	4585                	li	a1,1
ffffffffc0200e9e:	854e                	mv	a0,s3
ffffffffc0200ea0:	0e3000ef          	jal	ffffffffc0201782 <free_pages>
    free_pages(p1, 3);
ffffffffc0200ea4:	8552                	mv	a0,s4
ffffffffc0200ea6:	458d                	li	a1,3
ffffffffc0200ea8:	0db000ef          	jal	ffffffffc0201782 <free_pages>
ffffffffc0200eac:	0089b783          	ld	a5,8(s3)
ffffffffc0200eb0:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200eb2:	8b85                	andi	a5,a5,1
ffffffffc0200eb4:	3e078263          	beqz	a5,ffffffffc0201298 <default_check+0x662>
ffffffffc0200eb8:	0109aa83          	lw	s5,16(s3)
ffffffffc0200ebc:	4785                	li	a5,1
ffffffffc0200ebe:	3cfa9d63          	bne	s5,a5,ffffffffc0201298 <default_check+0x662>
ffffffffc0200ec2:	008a3783          	ld	a5,8(s4)
ffffffffc0200ec6:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200ec8:	8b85                	andi	a5,a5,1
ffffffffc0200eca:	3a078763          	beqz	a5,ffffffffc0201278 <default_check+0x642>
ffffffffc0200ece:	010a2703          	lw	a4,16(s4)
ffffffffc0200ed2:	478d                	li	a5,3
ffffffffc0200ed4:	3af71263          	bne	a4,a5,ffffffffc0201278 <default_check+0x642>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200ed8:	8556                	mv	a0,s5
ffffffffc0200eda:	06f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200ede:	36a99d63          	bne	s3,a0,ffffffffc0201258 <default_check+0x622>
    free_page(p0);
ffffffffc0200ee2:	85d6                	mv	a1,s5
ffffffffc0200ee4:	09f000ef          	jal	ffffffffc0201782 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200ee8:	4509                	li	a0,2
ffffffffc0200eea:	05f000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200eee:	34aa1563          	bne	s4,a0,ffffffffc0201238 <default_check+0x602>

    free_pages(p0, 2);
ffffffffc0200ef2:	4589                	li	a1,2
ffffffffc0200ef4:	08f000ef          	jal	ffffffffc0201782 <free_pages>
    free_page(p2);
ffffffffc0200ef8:	02898513          	addi	a0,s3,40
ffffffffc0200efc:	85d6                	mv	a1,s5
ffffffffc0200efe:	085000ef          	jal	ffffffffc0201782 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200f02:	4515                	li	a0,5
ffffffffc0200f04:	045000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200f08:	89aa                	mv	s3,a0
ffffffffc0200f0a:	48050763          	beqz	a0,ffffffffc0201398 <default_check+0x762>
    assert(alloc_page() == NULL);
ffffffffc0200f0e:	8556                	mv	a0,s5
ffffffffc0200f10:	039000ef          	jal	ffffffffc0201748 <alloc_pages>
ffffffffc0200f14:	2e051263          	bnez	a0,ffffffffc02011f8 <default_check+0x5c2>

    assert(nr_free == 0);
ffffffffc0200f18:	00006797          	auipc	a5,0x6
ffffffffc0200f1c:	1207a783          	lw	a5,288(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200f20:	2a079c63          	bnez	a5,ffffffffc02011d8 <default_check+0x5a2>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200f24:	854e                	mv	a0,s3
ffffffffc0200f26:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0200f28:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0200f2c:	01793023          	sd	s7,0(s2)
ffffffffc0200f30:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0200f34:	04f000ef          	jal	ffffffffc0201782 <free_pages>
    return listelm->next;
ffffffffc0200f38:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f3c:	01278963          	beq	a5,s2,ffffffffc0200f4e <default_check+0x318>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200f40:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f44:	679c                	ld	a5,8(a5)
ffffffffc0200f46:	34fd                	addiw	s1,s1,-1
ffffffffc0200f48:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f4a:	ff279be3          	bne	a5,s2,ffffffffc0200f40 <default_check+0x30a>
    }
    assert(count == 0);
ffffffffc0200f4e:	26049563          	bnez	s1,ffffffffc02011b8 <default_check+0x582>
    assert(total == 0);
ffffffffc0200f52:	46041363          	bnez	s0,ffffffffc02013b8 <default_check+0x782>
}
ffffffffc0200f56:	60e6                	ld	ra,88(sp)
ffffffffc0200f58:	6446                	ld	s0,80(sp)
ffffffffc0200f5a:	64a6                	ld	s1,72(sp)
ffffffffc0200f5c:	6906                	ld	s2,64(sp)
ffffffffc0200f5e:	79e2                	ld	s3,56(sp)
ffffffffc0200f60:	7a42                	ld	s4,48(sp)
ffffffffc0200f62:	7aa2                	ld	s5,40(sp)
ffffffffc0200f64:	7b02                	ld	s6,32(sp)
ffffffffc0200f66:	6be2                	ld	s7,24(sp)
ffffffffc0200f68:	6c42                	ld	s8,16(sp)
ffffffffc0200f6a:	6ca2                	ld	s9,8(sp)
ffffffffc0200f6c:	6125                	addi	sp,sp,96
ffffffffc0200f6e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f70:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200f72:	4401                	li	s0,0
ffffffffc0200f74:	4481                	li	s1,0
ffffffffc0200f76:	b319                	j	ffffffffc0200c7c <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0200f78:	00002697          	auipc	a3,0x2
ffffffffc0200f7c:	8f868693          	addi	a3,a3,-1800 # ffffffffc0202870 <etext+0x904>
ffffffffc0200f80:	00002617          	auipc	a2,0x2
ffffffffc0200f84:	90060613          	addi	a2,a2,-1792 # ffffffffc0202880 <etext+0x914>
ffffffffc0200f88:	0f000593          	li	a1,240
ffffffffc0200f8c:	00002517          	auipc	a0,0x2
ffffffffc0200f90:	90c50513          	addi	a0,a0,-1780 # ffffffffc0202898 <etext+0x92c>
ffffffffc0200f94:	c12ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f98:	00002697          	auipc	a3,0x2
ffffffffc0200f9c:	9c068693          	addi	a3,a3,-1600 # ffffffffc0202958 <etext+0x9ec>
ffffffffc0200fa0:	00002617          	auipc	a2,0x2
ffffffffc0200fa4:	8e060613          	addi	a2,a2,-1824 # ffffffffc0202880 <etext+0x914>
ffffffffc0200fa8:	0be00593          	li	a1,190
ffffffffc0200fac:	00002517          	auipc	a0,0x2
ffffffffc0200fb0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0202898 <etext+0x92c>
ffffffffc0200fb4:	bf2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200fb8:	00002697          	auipc	a3,0x2
ffffffffc0200fbc:	a6868693          	addi	a3,a3,-1432 # ffffffffc0202a20 <etext+0xab4>
ffffffffc0200fc0:	00002617          	auipc	a2,0x2
ffffffffc0200fc4:	8c060613          	addi	a2,a2,-1856 # ffffffffc0202880 <etext+0x914>
ffffffffc0200fc8:	0d900593          	li	a1,217
ffffffffc0200fcc:	00002517          	auipc	a0,0x2
ffffffffc0200fd0:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0202898 <etext+0x92c>
ffffffffc0200fd4:	bd2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200fd8:	00002697          	auipc	a3,0x2
ffffffffc0200fdc:	9c068693          	addi	a3,a3,-1600 # ffffffffc0202998 <etext+0xa2c>
ffffffffc0200fe0:	00002617          	auipc	a2,0x2
ffffffffc0200fe4:	8a060613          	addi	a2,a2,-1888 # ffffffffc0202880 <etext+0x914>
ffffffffc0200fe8:	0c000593          	li	a1,192
ffffffffc0200fec:	00002517          	auipc	a0,0x2
ffffffffc0200ff0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0202898 <etext+0x92c>
ffffffffc0200ff4:	bb2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ff8:	00002697          	auipc	a3,0x2
ffffffffc0200ffc:	93868693          	addi	a3,a3,-1736 # ffffffffc0202930 <etext+0x9c4>
ffffffffc0201000:	00002617          	auipc	a2,0x2
ffffffffc0201004:	88060613          	addi	a2,a2,-1920 # ffffffffc0202880 <etext+0x914>
ffffffffc0201008:	0bd00593          	li	a1,189
ffffffffc020100c:	00002517          	auipc	a0,0x2
ffffffffc0201010:	88c50513          	addi	a0,a0,-1908 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201014:	b92ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201018:	00002697          	auipc	a3,0x2
ffffffffc020101c:	8b868693          	addi	a3,a3,-1864 # ffffffffc02028d0 <etext+0x964>
ffffffffc0201020:	00002617          	auipc	a2,0x2
ffffffffc0201024:	86060613          	addi	a2,a2,-1952 # ffffffffc0202880 <etext+0x914>
ffffffffc0201028:	0d200593          	li	a1,210
ffffffffc020102c:	00002517          	auipc	a0,0x2
ffffffffc0201030:	86c50513          	addi	a0,a0,-1940 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201034:	b72ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(nr_free == 3);
ffffffffc0201038:	00002697          	auipc	a3,0x2
ffffffffc020103c:	9d868693          	addi	a3,a3,-1576 # ffffffffc0202a10 <etext+0xaa4>
ffffffffc0201040:	00002617          	auipc	a2,0x2
ffffffffc0201044:	84060613          	addi	a2,a2,-1984 # ffffffffc0202880 <etext+0x914>
ffffffffc0201048:	0d000593          	li	a1,208
ffffffffc020104c:	00002517          	auipc	a0,0x2
ffffffffc0201050:	84c50513          	addi	a0,a0,-1972 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201054:	b52ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201058:	00002697          	auipc	a3,0x2
ffffffffc020105c:	9a068693          	addi	a3,a3,-1632 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc0201060:	00002617          	auipc	a2,0x2
ffffffffc0201064:	82060613          	addi	a2,a2,-2016 # ffffffffc0202880 <etext+0x914>
ffffffffc0201068:	0cb00593          	li	a1,203
ffffffffc020106c:	00002517          	auipc	a0,0x2
ffffffffc0201070:	82c50513          	addi	a0,a0,-2004 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201074:	b32ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201078:	00002697          	auipc	a3,0x2
ffffffffc020107c:	96068693          	addi	a3,a3,-1696 # ffffffffc02029d8 <etext+0xa6c>
ffffffffc0201080:	00002617          	auipc	a2,0x2
ffffffffc0201084:	80060613          	addi	a2,a2,-2048 # ffffffffc0202880 <etext+0x914>
ffffffffc0201088:	0c200593          	li	a1,194
ffffffffc020108c:	00002517          	auipc	a0,0x2
ffffffffc0201090:	80c50513          	addi	a0,a0,-2036 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201094:	b12ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(p0 != NULL);
ffffffffc0201098:	00002697          	auipc	a3,0x2
ffffffffc020109c:	9d068693          	addi	a3,a3,-1584 # ffffffffc0202a68 <etext+0xafc>
ffffffffc02010a0:	00001617          	auipc	a2,0x1
ffffffffc02010a4:	7e060613          	addi	a2,a2,2016 # ffffffffc0202880 <etext+0x914>
ffffffffc02010a8:	0f800593          	li	a1,248
ffffffffc02010ac:	00001517          	auipc	a0,0x1
ffffffffc02010b0:	7ec50513          	addi	a0,a0,2028 # ffffffffc0202898 <etext+0x92c>
ffffffffc02010b4:	af2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(nr_free == 0);
ffffffffc02010b8:	00002697          	auipc	a3,0x2
ffffffffc02010bc:	9a068693          	addi	a3,a3,-1632 # ffffffffc0202a58 <etext+0xaec>
ffffffffc02010c0:	00001617          	auipc	a2,0x1
ffffffffc02010c4:	7c060613          	addi	a2,a2,1984 # ffffffffc0202880 <etext+0x914>
ffffffffc02010c8:	0df00593          	li	a1,223
ffffffffc02010cc:	00001517          	auipc	a0,0x1
ffffffffc02010d0:	7cc50513          	addi	a0,a0,1996 # ffffffffc0202898 <etext+0x92c>
ffffffffc02010d4:	ad2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010d8:	00002697          	auipc	a3,0x2
ffffffffc02010dc:	92068693          	addi	a3,a3,-1760 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc02010e0:	00001617          	auipc	a2,0x1
ffffffffc02010e4:	7a060613          	addi	a2,a2,1952 # ffffffffc0202880 <etext+0x914>
ffffffffc02010e8:	0dd00593          	li	a1,221
ffffffffc02010ec:	00001517          	auipc	a0,0x1
ffffffffc02010f0:	7ac50513          	addi	a0,a0,1964 # ffffffffc0202898 <etext+0x92c>
ffffffffc02010f4:	ab2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02010f8:	00002697          	auipc	a3,0x2
ffffffffc02010fc:	94068693          	addi	a3,a3,-1728 # ffffffffc0202a38 <etext+0xacc>
ffffffffc0201100:	00001617          	auipc	a2,0x1
ffffffffc0201104:	78060613          	addi	a2,a2,1920 # ffffffffc0202880 <etext+0x914>
ffffffffc0201108:	0dc00593          	li	a1,220
ffffffffc020110c:	00001517          	auipc	a0,0x1
ffffffffc0201110:	78c50513          	addi	a0,a0,1932 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201114:	a92ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201118:	00001697          	auipc	a3,0x1
ffffffffc020111c:	7b868693          	addi	a3,a3,1976 # ffffffffc02028d0 <etext+0x964>
ffffffffc0201120:	00001617          	auipc	a2,0x1
ffffffffc0201124:	76060613          	addi	a2,a2,1888 # ffffffffc0202880 <etext+0x914>
ffffffffc0201128:	0b900593          	li	a1,185
ffffffffc020112c:	00001517          	auipc	a0,0x1
ffffffffc0201130:	76c50513          	addi	a0,a0,1900 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201134:	a72ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201138:	00002697          	auipc	a3,0x2
ffffffffc020113c:	8c068693          	addi	a3,a3,-1856 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc0201140:	00001617          	auipc	a2,0x1
ffffffffc0201144:	74060613          	addi	a2,a2,1856 # ffffffffc0202880 <etext+0x914>
ffffffffc0201148:	0d600593          	li	a1,214
ffffffffc020114c:	00001517          	auipc	a0,0x1
ffffffffc0201150:	74c50513          	addi	a0,a0,1868 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201154:	a52ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201158:	00001697          	auipc	a3,0x1
ffffffffc020115c:	7b868693          	addi	a3,a3,1976 # ffffffffc0202910 <etext+0x9a4>
ffffffffc0201160:	00001617          	auipc	a2,0x1
ffffffffc0201164:	72060613          	addi	a2,a2,1824 # ffffffffc0202880 <etext+0x914>
ffffffffc0201168:	0d400593          	li	a1,212
ffffffffc020116c:	00001517          	auipc	a0,0x1
ffffffffc0201170:	72c50513          	addi	a0,a0,1836 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201174:	a32ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201178:	00001697          	auipc	a3,0x1
ffffffffc020117c:	77868693          	addi	a3,a3,1912 # ffffffffc02028f0 <etext+0x984>
ffffffffc0201180:	00001617          	auipc	a2,0x1
ffffffffc0201184:	70060613          	addi	a2,a2,1792 # ffffffffc0202880 <etext+0x914>
ffffffffc0201188:	0d300593          	li	a1,211
ffffffffc020118c:	00001517          	auipc	a0,0x1
ffffffffc0201190:	70c50513          	addi	a0,a0,1804 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201194:	a12ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201198:	00001697          	auipc	a3,0x1
ffffffffc020119c:	77868693          	addi	a3,a3,1912 # ffffffffc0202910 <etext+0x9a4>
ffffffffc02011a0:	00001617          	auipc	a2,0x1
ffffffffc02011a4:	6e060613          	addi	a2,a2,1760 # ffffffffc0202880 <etext+0x914>
ffffffffc02011a8:	0bb00593          	li	a1,187
ffffffffc02011ac:	00001517          	auipc	a0,0x1
ffffffffc02011b0:	6ec50513          	addi	a0,a0,1772 # ffffffffc0202898 <etext+0x92c>
ffffffffc02011b4:	9f2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(count == 0);
ffffffffc02011b8:	00002697          	auipc	a3,0x2
ffffffffc02011bc:	a0068693          	addi	a3,a3,-1536 # ffffffffc0202bb8 <etext+0xc4c>
ffffffffc02011c0:	00001617          	auipc	a2,0x1
ffffffffc02011c4:	6c060613          	addi	a2,a2,1728 # ffffffffc0202880 <etext+0x914>
ffffffffc02011c8:	12500593          	li	a1,293
ffffffffc02011cc:	00001517          	auipc	a0,0x1
ffffffffc02011d0:	6cc50513          	addi	a0,a0,1740 # ffffffffc0202898 <etext+0x92c>
ffffffffc02011d4:	9d2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(nr_free == 0);
ffffffffc02011d8:	00002697          	auipc	a3,0x2
ffffffffc02011dc:	88068693          	addi	a3,a3,-1920 # ffffffffc0202a58 <etext+0xaec>
ffffffffc02011e0:	00001617          	auipc	a2,0x1
ffffffffc02011e4:	6a060613          	addi	a2,a2,1696 # ffffffffc0202880 <etext+0x914>
ffffffffc02011e8:	11a00593          	li	a1,282
ffffffffc02011ec:	00001517          	auipc	a0,0x1
ffffffffc02011f0:	6ac50513          	addi	a0,a0,1708 # ffffffffc0202898 <etext+0x92c>
ffffffffc02011f4:	9b2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011f8:	00002697          	auipc	a3,0x2
ffffffffc02011fc:	80068693          	addi	a3,a3,-2048 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc0201200:	00001617          	auipc	a2,0x1
ffffffffc0201204:	68060613          	addi	a2,a2,1664 # ffffffffc0202880 <etext+0x914>
ffffffffc0201208:	11800593          	li	a1,280
ffffffffc020120c:	00001517          	auipc	a0,0x1
ffffffffc0201210:	68c50513          	addi	a0,a0,1676 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201214:	992ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201218:	00001697          	auipc	a3,0x1
ffffffffc020121c:	7a068693          	addi	a3,a3,1952 # ffffffffc02029b8 <etext+0xa4c>
ffffffffc0201220:	00001617          	auipc	a2,0x1
ffffffffc0201224:	66060613          	addi	a2,a2,1632 # ffffffffc0202880 <etext+0x914>
ffffffffc0201228:	0c100593          	li	a1,193
ffffffffc020122c:	00001517          	auipc	a0,0x1
ffffffffc0201230:	66c50513          	addi	a0,a0,1644 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201234:	972ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201238:	00002697          	auipc	a3,0x2
ffffffffc020123c:	94068693          	addi	a3,a3,-1728 # ffffffffc0202b78 <etext+0xc0c>
ffffffffc0201240:	00001617          	auipc	a2,0x1
ffffffffc0201244:	64060613          	addi	a2,a2,1600 # ffffffffc0202880 <etext+0x914>
ffffffffc0201248:	11200593          	li	a1,274
ffffffffc020124c:	00001517          	auipc	a0,0x1
ffffffffc0201250:	64c50513          	addi	a0,a0,1612 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201254:	952ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201258:	00002697          	auipc	a3,0x2
ffffffffc020125c:	90068693          	addi	a3,a3,-1792 # ffffffffc0202b58 <etext+0xbec>
ffffffffc0201260:	00001617          	auipc	a2,0x1
ffffffffc0201264:	62060613          	addi	a2,a2,1568 # ffffffffc0202880 <etext+0x914>
ffffffffc0201268:	11000593          	li	a1,272
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	62c50513          	addi	a0,a0,1580 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201274:	932ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201278:	00002697          	auipc	a3,0x2
ffffffffc020127c:	8b868693          	addi	a3,a3,-1864 # ffffffffc0202b30 <etext+0xbc4>
ffffffffc0201280:	00001617          	auipc	a2,0x1
ffffffffc0201284:	60060613          	addi	a2,a2,1536 # ffffffffc0202880 <etext+0x914>
ffffffffc0201288:	10e00593          	li	a1,270
ffffffffc020128c:	00001517          	auipc	a0,0x1
ffffffffc0201290:	60c50513          	addi	a0,a0,1548 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201294:	912ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201298:	00002697          	auipc	a3,0x2
ffffffffc020129c:	87068693          	addi	a3,a3,-1936 # ffffffffc0202b08 <etext+0xb9c>
ffffffffc02012a0:	00001617          	auipc	a2,0x1
ffffffffc02012a4:	5e060613          	addi	a2,a2,1504 # ffffffffc0202880 <etext+0x914>
ffffffffc02012a8:	10d00593          	li	a1,269
ffffffffc02012ac:	00001517          	auipc	a0,0x1
ffffffffc02012b0:	5ec50513          	addi	a0,a0,1516 # ffffffffc0202898 <etext+0x92c>
ffffffffc02012b4:	8f2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02012b8:	00002697          	auipc	a3,0x2
ffffffffc02012bc:	84068693          	addi	a3,a3,-1984 # ffffffffc0202af8 <etext+0xb8c>
ffffffffc02012c0:	00001617          	auipc	a2,0x1
ffffffffc02012c4:	5c060613          	addi	a2,a2,1472 # ffffffffc0202880 <etext+0x914>
ffffffffc02012c8:	10800593          	li	a1,264
ffffffffc02012cc:	00001517          	auipc	a0,0x1
ffffffffc02012d0:	5cc50513          	addi	a0,a0,1484 # ffffffffc0202898 <etext+0x92c>
ffffffffc02012d4:	8d2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012d8:	00001697          	auipc	a3,0x1
ffffffffc02012dc:	72068693          	addi	a3,a3,1824 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc02012e0:	00001617          	auipc	a2,0x1
ffffffffc02012e4:	5a060613          	addi	a2,a2,1440 # ffffffffc0202880 <etext+0x914>
ffffffffc02012e8:	10700593          	li	a1,263
ffffffffc02012ec:	00001517          	auipc	a0,0x1
ffffffffc02012f0:	5ac50513          	addi	a0,a0,1452 # ffffffffc0202898 <etext+0x92c>
ffffffffc02012f4:	8b2ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02012f8:	00001697          	auipc	a3,0x1
ffffffffc02012fc:	7e068693          	addi	a3,a3,2016 # ffffffffc0202ad8 <etext+0xb6c>
ffffffffc0201300:	00001617          	auipc	a2,0x1
ffffffffc0201304:	58060613          	addi	a2,a2,1408 # ffffffffc0202880 <etext+0x914>
ffffffffc0201308:	10600593          	li	a1,262
ffffffffc020130c:	00001517          	auipc	a0,0x1
ffffffffc0201310:	58c50513          	addi	a0,a0,1420 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201314:	892ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201318:	00001697          	auipc	a3,0x1
ffffffffc020131c:	79068693          	addi	a3,a3,1936 # ffffffffc0202aa8 <etext+0xb3c>
ffffffffc0201320:	00001617          	auipc	a2,0x1
ffffffffc0201324:	56060613          	addi	a2,a2,1376 # ffffffffc0202880 <etext+0x914>
ffffffffc0201328:	10500593          	li	a1,261
ffffffffc020132c:	00001517          	auipc	a0,0x1
ffffffffc0201330:	56c50513          	addi	a0,a0,1388 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201334:	872ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201338:	00001697          	auipc	a3,0x1
ffffffffc020133c:	75868693          	addi	a3,a3,1880 # ffffffffc0202a90 <etext+0xb24>
ffffffffc0201340:	00001617          	auipc	a2,0x1
ffffffffc0201344:	54060613          	addi	a2,a2,1344 # ffffffffc0202880 <etext+0x914>
ffffffffc0201348:	10400593          	li	a1,260
ffffffffc020134c:	00001517          	auipc	a0,0x1
ffffffffc0201350:	54c50513          	addi	a0,a0,1356 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201354:	852ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201358:	00001697          	auipc	a3,0x1
ffffffffc020135c:	6a068693          	addi	a3,a3,1696 # ffffffffc02029f8 <etext+0xa8c>
ffffffffc0201360:	00001617          	auipc	a2,0x1
ffffffffc0201364:	52060613          	addi	a2,a2,1312 # ffffffffc0202880 <etext+0x914>
ffffffffc0201368:	0fe00593          	li	a1,254
ffffffffc020136c:	00001517          	auipc	a0,0x1
ffffffffc0201370:	52c50513          	addi	a0,a0,1324 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201374:	832ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201378:	00001697          	auipc	a3,0x1
ffffffffc020137c:	70068693          	addi	a3,a3,1792 # ffffffffc0202a78 <etext+0xb0c>
ffffffffc0201380:	00001617          	auipc	a2,0x1
ffffffffc0201384:	50060613          	addi	a2,a2,1280 # ffffffffc0202880 <etext+0x914>
ffffffffc0201388:	0f900593          	li	a1,249
ffffffffc020138c:	00001517          	auipc	a0,0x1
ffffffffc0201390:	50c50513          	addi	a0,a0,1292 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201394:	812ff0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201398:	00002697          	auipc	a3,0x2
ffffffffc020139c:	80068693          	addi	a3,a3,-2048 # ffffffffc0202b98 <etext+0xc2c>
ffffffffc02013a0:	00001617          	auipc	a2,0x1
ffffffffc02013a4:	4e060613          	addi	a2,a2,1248 # ffffffffc0202880 <etext+0x914>
ffffffffc02013a8:	11700593          	li	a1,279
ffffffffc02013ac:	00001517          	auipc	a0,0x1
ffffffffc02013b0:	4ec50513          	addi	a0,a0,1260 # ffffffffc0202898 <etext+0x92c>
ffffffffc02013b4:	ff3fe0ef          	jal	ffffffffc02003a6 <__panic>
    assert(total == 0);
ffffffffc02013b8:	00002697          	auipc	a3,0x2
ffffffffc02013bc:	81068693          	addi	a3,a3,-2032 # ffffffffc0202bc8 <etext+0xc5c>
ffffffffc02013c0:	00001617          	auipc	a2,0x1
ffffffffc02013c4:	4c060613          	addi	a2,a2,1216 # ffffffffc0202880 <etext+0x914>
ffffffffc02013c8:	12600593          	li	a1,294
ffffffffc02013cc:	00001517          	auipc	a0,0x1
ffffffffc02013d0:	4cc50513          	addi	a0,a0,1228 # ffffffffc0202898 <etext+0x92c>
ffffffffc02013d4:	fd3fe0ef          	jal	ffffffffc02003a6 <__panic>
    assert(total == nr_free_pages());
ffffffffc02013d8:	00001697          	auipc	a3,0x1
ffffffffc02013dc:	4d868693          	addi	a3,a3,1240 # ffffffffc02028b0 <etext+0x944>
ffffffffc02013e0:	00001617          	auipc	a2,0x1
ffffffffc02013e4:	4a060613          	addi	a2,a2,1184 # ffffffffc0202880 <etext+0x914>
ffffffffc02013e8:	0f300593          	li	a1,243
ffffffffc02013ec:	00001517          	auipc	a0,0x1
ffffffffc02013f0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0202898 <etext+0x92c>
ffffffffc02013f4:	fb3fe0ef          	jal	ffffffffc02003a6 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013f8:	00001697          	auipc	a3,0x1
ffffffffc02013fc:	4f868693          	addi	a3,a3,1272 # ffffffffc02028f0 <etext+0x984>
ffffffffc0201400:	00001617          	auipc	a2,0x1
ffffffffc0201404:	48060613          	addi	a2,a2,1152 # ffffffffc0202880 <etext+0x914>
ffffffffc0201408:	0ba00593          	li	a1,186
ffffffffc020140c:	00001517          	auipc	a0,0x1
ffffffffc0201410:	48c50513          	addi	a0,a0,1164 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201414:	f93fe0ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc0201418 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201418:	1141                	addi	sp,sp,-16
ffffffffc020141a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020141c:	14058c63          	beqz	a1,ffffffffc0201574 <default_free_pages+0x15c>
    for (; p != base + n; p ++) {
ffffffffc0201420:	00259713          	slli	a4,a1,0x2
ffffffffc0201424:	972e                	add	a4,a4,a1
ffffffffc0201426:	070e                	slli	a4,a4,0x3
ffffffffc0201428:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020142c:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc020142e:	c30d                	beqz	a4,ffffffffc0201450 <default_free_pages+0x38>
ffffffffc0201430:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201432:	8b05                	andi	a4,a4,1
ffffffffc0201434:	12071063          	bnez	a4,ffffffffc0201554 <default_free_pages+0x13c>
ffffffffc0201438:	6798                	ld	a4,8(a5)
ffffffffc020143a:	8b09                	andi	a4,a4,2
ffffffffc020143c:	10071c63          	bnez	a4,ffffffffc0201554 <default_free_pages+0x13c>
        p->flags = 0;
ffffffffc0201440:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201444:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201448:	02878793          	addi	a5,a5,40
ffffffffc020144c:	fed792e3          	bne	a5,a3,ffffffffc0201430 <default_free_pages+0x18>
    base->property = n;
ffffffffc0201450:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201452:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201456:	4789                	li	a5,2
ffffffffc0201458:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020145c:	00006717          	auipc	a4,0x6
ffffffffc0201460:	bdc72703          	lw	a4,-1060(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201464:	00006697          	auipc	a3,0x6
ffffffffc0201468:	bc468693          	addi	a3,a3,-1084 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc020146c:	669c                	ld	a5,8(a3)
ffffffffc020146e:	9f2d                	addw	a4,a4,a1
ffffffffc0201470:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201472:	0ad78563          	beq	a5,a3,ffffffffc020151c <default_free_pages+0x104>
            struct Page* page = le2page(le, page_link);
ffffffffc0201476:	fe878713          	addi	a4,a5,-24
ffffffffc020147a:	4581                	li	a1,0
ffffffffc020147c:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201480:	00e56a63          	bltu	a0,a4,ffffffffc0201494 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc0201484:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201486:	06d70263          	beq	a4,a3,ffffffffc02014ea <default_free_pages+0xd2>
    struct Page *p = base;
ffffffffc020148a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020148c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201490:	fee57ae3          	bgeu	a0,a4,ffffffffc0201484 <default_free_pages+0x6c>
ffffffffc0201494:	c199                	beqz	a1,ffffffffc020149a <default_free_pages+0x82>
ffffffffc0201496:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020149a:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020149c:	e390                	sd	a2,0(a5)
ffffffffc020149e:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02014a0:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02014a2:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc02014a4:	02d70063          	beq	a4,a3,ffffffffc02014c4 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc02014a8:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02014ac:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc02014b0:	02081613          	slli	a2,a6,0x20
ffffffffc02014b4:	9201                	srli	a2,a2,0x20
ffffffffc02014b6:	00261793          	slli	a5,a2,0x2
ffffffffc02014ba:	97b2                	add	a5,a5,a2
ffffffffc02014bc:	078e                	slli	a5,a5,0x3
ffffffffc02014be:	97ae                	add	a5,a5,a1
ffffffffc02014c0:	02f50f63          	beq	a0,a5,ffffffffc02014fe <default_free_pages+0xe6>
    return listelm->next;
ffffffffc02014c4:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02014c6:	00d70f63          	beq	a4,a3,ffffffffc02014e4 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02014ca:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02014cc:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02014d0:	02059613          	slli	a2,a1,0x20
ffffffffc02014d4:	9201                	srli	a2,a2,0x20
ffffffffc02014d6:	00261793          	slli	a5,a2,0x2
ffffffffc02014da:	97b2                	add	a5,a5,a2
ffffffffc02014dc:	078e                	slli	a5,a5,0x3
ffffffffc02014de:	97aa                	add	a5,a5,a0
ffffffffc02014e0:	04f68a63          	beq	a3,a5,ffffffffc0201534 <default_free_pages+0x11c>
}
ffffffffc02014e4:	60a2                	ld	ra,8(sp)
ffffffffc02014e6:	0141                	addi	sp,sp,16
ffffffffc02014e8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02014ea:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02014ec:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02014ee:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02014f0:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02014f2:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02014f4:	02d70d63          	beq	a4,a3,ffffffffc020152e <default_free_pages+0x116>
ffffffffc02014f8:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02014fa:	87ba                	mv	a5,a4
ffffffffc02014fc:	bf41                	j	ffffffffc020148c <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02014fe:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201500:	5675                	li	a2,-3
ffffffffc0201502:	010787bb          	addw	a5,a5,a6
ffffffffc0201506:	fef72c23          	sw	a5,-8(a4)
ffffffffc020150a:	60c8b02f          	amoand.d	zero,a2,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020150e:	6d10                	ld	a2,24(a0)
ffffffffc0201510:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201512:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201514:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201516:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201518:	e390                	sd	a2,0(a5)
ffffffffc020151a:	b775                	j	ffffffffc02014c6 <default_free_pages+0xae>
}
ffffffffc020151c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020151e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201522:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201524:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201526:	e398                	sd	a4,0(a5)
ffffffffc0201528:	e798                	sd	a4,8(a5)
}
ffffffffc020152a:	0141                	addi	sp,sp,16
ffffffffc020152c:	8082                	ret
ffffffffc020152e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201530:	873e                	mv	a4,a5
ffffffffc0201532:	bf8d                	j	ffffffffc02014a4 <default_free_pages+0x8c>
            base->property += p->property;
ffffffffc0201534:	ff872783          	lw	a5,-8(a4)
ffffffffc0201538:	56f5                	li	a3,-3
ffffffffc020153a:	9fad                	addw	a5,a5,a1
ffffffffc020153c:	c91c                	sw	a5,16(a0)
ffffffffc020153e:	ff070793          	addi	a5,a4,-16
ffffffffc0201542:	60d7b02f          	amoand.d	zero,a3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201546:	6314                	ld	a3,0(a4)
ffffffffc0201548:	671c                	ld	a5,8(a4)
}
ffffffffc020154a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020154c:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc020154e:	e394                	sd	a3,0(a5)
ffffffffc0201550:	0141                	addi	sp,sp,16
ffffffffc0201552:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201554:	00001697          	auipc	a3,0x1
ffffffffc0201558:	68c68693          	addi	a3,a3,1676 # ffffffffc0202be0 <etext+0xc74>
ffffffffc020155c:	00001617          	auipc	a2,0x1
ffffffffc0201560:	32460613          	addi	a2,a2,804 # ffffffffc0202880 <etext+0x914>
ffffffffc0201564:	08300593          	li	a1,131
ffffffffc0201568:	00001517          	auipc	a0,0x1
ffffffffc020156c:	33050513          	addi	a0,a0,816 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201570:	e37fe0ef          	jal	ffffffffc02003a6 <__panic>
    assert(n > 0);
ffffffffc0201574:	00001697          	auipc	a3,0x1
ffffffffc0201578:	66468693          	addi	a3,a3,1636 # ffffffffc0202bd8 <etext+0xc6c>
ffffffffc020157c:	00001617          	auipc	a2,0x1
ffffffffc0201580:	30460613          	addi	a2,a2,772 # ffffffffc0202880 <etext+0x914>
ffffffffc0201584:	08000593          	li	a1,128
ffffffffc0201588:	00001517          	auipc	a0,0x1
ffffffffc020158c:	31050513          	addi	a0,a0,784 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201590:	e17fe0ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc0201594 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201594:	cd41                	beqz	a0,ffffffffc020162c <default_alloc_pages+0x98>
    if (n > nr_free) {
ffffffffc0201596:	00006597          	auipc	a1,0x6
ffffffffc020159a:	aa25a583          	lw	a1,-1374(a1) # ffffffffc0207038 <free_area+0x10>
ffffffffc020159e:	86aa                	mv	a3,a0
ffffffffc02015a0:	02059793          	slli	a5,a1,0x20
ffffffffc02015a4:	9381                	srli	a5,a5,0x20
ffffffffc02015a6:	00a7ef63          	bltu	a5,a0,ffffffffc02015c4 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02015aa:	00006617          	auipc	a2,0x6
ffffffffc02015ae:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0207028 <free_area>
ffffffffc02015b2:	87b2                	mv	a5,a2
ffffffffc02015b4:	a029                	j	ffffffffc02015be <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc02015b6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02015ba:	00d77763          	bgeu	a4,a3,ffffffffc02015c8 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc02015be:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02015c0:	fec79be3          	bne	a5,a2,ffffffffc02015b6 <default_alloc_pages+0x22>
        return NULL;
ffffffffc02015c4:	4501                	li	a0,0
}
ffffffffc02015c6:	8082                	ret
        if (page->property > n) {
ffffffffc02015c8:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc02015cc:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015d0:	6798                	ld	a4,8(a5)
ffffffffc02015d2:	02089313          	slli	t1,a7,0x20
ffffffffc02015d6:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc02015da:	00e83423          	sd	a4,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    next->prev = prev;
ffffffffc02015de:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc02015e2:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc02015e6:	0266fc63          	bgeu	a3,t1,ffffffffc020161e <default_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc02015ea:	00269713          	slli	a4,a3,0x2
ffffffffc02015ee:	9736                	add	a4,a4,a3
ffffffffc02015f0:	070e                	slli	a4,a4,0x3
            p->property = page->property - n;
ffffffffc02015f2:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc02015f6:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02015f8:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015fc:	00870313          	addi	t1,a4,8
ffffffffc0201600:	4889                	li	a7,2
ffffffffc0201602:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201606:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020160a:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020160e:	0068b023          	sd	t1,0(a7)
ffffffffc0201612:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201616:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020161a:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020161e:	9d95                	subw	a1,a1,a3
ffffffffc0201620:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201622:	5775                	li	a4,-3
ffffffffc0201624:	17c1                	addi	a5,a5,-16
ffffffffc0201626:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020162a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020162c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020162e:	00001697          	auipc	a3,0x1
ffffffffc0201632:	5aa68693          	addi	a3,a3,1450 # ffffffffc0202bd8 <etext+0xc6c>
ffffffffc0201636:	00001617          	auipc	a2,0x1
ffffffffc020163a:	24a60613          	addi	a2,a2,586 # ffffffffc0202880 <etext+0x914>
ffffffffc020163e:	06200593          	li	a1,98
ffffffffc0201642:	00001517          	auipc	a0,0x1
ffffffffc0201646:	25650513          	addi	a0,a0,598 # ffffffffc0202898 <etext+0x92c>
default_alloc_pages(size_t n) {
ffffffffc020164a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020164c:	d5bfe0ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc0201650 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201650:	1141                	addi	sp,sp,-16
ffffffffc0201652:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201654:	c9f1                	beqz	a1,ffffffffc0201728 <default_init_memmap+0xd8>
    for (; p != base + n; p ++) {
ffffffffc0201656:	00259713          	slli	a4,a1,0x2
ffffffffc020165a:	972e                	add	a4,a4,a1
ffffffffc020165c:	070e                	slli	a4,a4,0x3
ffffffffc020165e:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201662:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201664:	cf11                	beqz	a4,ffffffffc0201680 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201666:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201668:	8b05                	andi	a4,a4,1
ffffffffc020166a:	cf59                	beqz	a4,ffffffffc0201708 <default_init_memmap+0xb8>
        p->flags = p->property = 0;
ffffffffc020166c:	0007a823          	sw	zero,16(a5)
ffffffffc0201670:	0007b423          	sd	zero,8(a5)
ffffffffc0201674:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201678:	02878793          	addi	a5,a5,40
ffffffffc020167c:	fed795e3          	bne	a5,a3,ffffffffc0201666 <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201680:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201682:	4789                	li	a5,2
ffffffffc0201684:	00850713          	addi	a4,a0,8
ffffffffc0201688:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020168c:	00006717          	auipc	a4,0x6
ffffffffc0201690:	9ac72703          	lw	a4,-1620(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201694:	00006697          	auipc	a3,0x6
ffffffffc0201698:	99468693          	addi	a3,a3,-1644 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc020169c:	669c                	ld	a5,8(a3)
ffffffffc020169e:	9f2d                	addw	a4,a4,a1
ffffffffc02016a0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02016a2:	04d78663          	beq	a5,a3,ffffffffc02016ee <default_init_memmap+0x9e>
            struct Page* page = le2page(le, page_link);
ffffffffc02016a6:	fe878713          	addi	a4,a5,-24
ffffffffc02016aa:	4581                	li	a1,0
ffffffffc02016ac:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02016b0:	00e56a63          	bltu	a0,a4,ffffffffc02016c4 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc02016b4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02016b6:	02d70263          	beq	a4,a3,ffffffffc02016da <default_init_memmap+0x8a>
    struct Page *p = base;
ffffffffc02016ba:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02016bc:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02016c0:	fee57ae3          	bgeu	a0,a4,ffffffffc02016b4 <default_init_memmap+0x64>
ffffffffc02016c4:	c199                	beqz	a1,ffffffffc02016ca <default_init_memmap+0x7a>
ffffffffc02016c6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016ca:	6398                	ld	a4,0(a5)
}
ffffffffc02016cc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02016ce:	e390                	sd	a2,0(a5)
ffffffffc02016d0:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc02016d2:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02016d4:	f11c                	sd	a5,32(a0)
ffffffffc02016d6:	0141                	addi	sp,sp,16
ffffffffc02016d8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02016da:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02016dc:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02016de:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02016e0:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02016e2:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02016e4:	00d70e63          	beq	a4,a3,ffffffffc0201700 <default_init_memmap+0xb0>
ffffffffc02016e8:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02016ea:	87ba                	mv	a5,a4
ffffffffc02016ec:	bfc1                	j	ffffffffc02016bc <default_init_memmap+0x6c>
}
ffffffffc02016ee:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02016f0:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02016f4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016f6:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02016f8:	e398                	sd	a4,0(a5)
ffffffffc02016fa:	e798                	sd	a4,8(a5)
}
ffffffffc02016fc:	0141                	addi	sp,sp,16
ffffffffc02016fe:	8082                	ret
ffffffffc0201700:	60a2                	ld	ra,8(sp)
ffffffffc0201702:	e290                	sd	a2,0(a3)
ffffffffc0201704:	0141                	addi	sp,sp,16
ffffffffc0201706:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201708:	00001697          	auipc	a3,0x1
ffffffffc020170c:	50068693          	addi	a3,a3,1280 # ffffffffc0202c08 <etext+0xc9c>
ffffffffc0201710:	00001617          	auipc	a2,0x1
ffffffffc0201714:	17060613          	addi	a2,a2,368 # ffffffffc0202880 <etext+0x914>
ffffffffc0201718:	04900593          	li	a1,73
ffffffffc020171c:	00001517          	auipc	a0,0x1
ffffffffc0201720:	17c50513          	addi	a0,a0,380 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201724:	c83fe0ef          	jal	ffffffffc02003a6 <__panic>
    assert(n > 0);
ffffffffc0201728:	00001697          	auipc	a3,0x1
ffffffffc020172c:	4b068693          	addi	a3,a3,1200 # ffffffffc0202bd8 <etext+0xc6c>
ffffffffc0201730:	00001617          	auipc	a2,0x1
ffffffffc0201734:	15060613          	addi	a2,a2,336 # ffffffffc0202880 <etext+0x914>
ffffffffc0201738:	04600593          	li	a1,70
ffffffffc020173c:	00001517          	auipc	a0,0x1
ffffffffc0201740:	15c50513          	addi	a0,a0,348 # ffffffffc0202898 <etext+0x92c>
ffffffffc0201744:	c63fe0ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc0201748 <alloc_pages>:
//调用intr_disable()函数禁用中断
//返回1，表示之前中断是启用的
//如果SIE没有被设置，表示中断已经是禁用的
//直接返回0，表示之前中断是禁用的
static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201748:	100027f3          	csrr	a5,sstatus
ffffffffc020174c:	8b89                	andi	a5,a5,2
ffffffffc020174e:	e799                	bnez	a5,ffffffffc020175c <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201750:	00006797          	auipc	a5,0x6
ffffffffc0201754:	d187b783          	ld	a5,-744(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201758:	6f9c                	ld	a5,24(a5)
ffffffffc020175a:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc020175c:	1101                	addi	sp,sp,-32
ffffffffc020175e:	ec06                	sd	ra,24(sp)
ffffffffc0201760:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201762:	83eff0ef          	jal	ffffffffc02007a0 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201766:	00006797          	auipc	a5,0x6
ffffffffc020176a:	d027b783          	ld	a5,-766(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc020176e:	6522                	ld	a0,8(sp)
ffffffffc0201770:	6f9c                	ld	a5,24(a5)
ffffffffc0201772:	9782                	jalr	a5
ffffffffc0201774:	e42a                	sd	a0,8(sp)
//根据传入的标志flag决定是否启用中断
//如果flag为真（非零），调用intr_enable()函数启用中断
//如果flag为假（零），不做任何操作，保持中断禁用状态
static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0201776:	824ff0ef          	jal	ffffffffc020079a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020177a:	60e2                	ld	ra,24(sp)
ffffffffc020177c:	6522                	ld	a0,8(sp)
ffffffffc020177e:	6105                	addi	sp,sp,32
ffffffffc0201780:	8082                	ret

ffffffffc0201782 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201782:	100027f3          	csrr	a5,sstatus
ffffffffc0201786:	8b89                	andi	a5,a5,2
ffffffffc0201788:	e799                	bnez	a5,ffffffffc0201796 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020178a:	00006797          	auipc	a5,0x6
ffffffffc020178e:	cde7b783          	ld	a5,-802(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201792:	739c                	ld	a5,32(a5)
ffffffffc0201794:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201796:	1101                	addi	sp,sp,-32
ffffffffc0201798:	ec06                	sd	ra,24(sp)
ffffffffc020179a:	e42e                	sd	a1,8(sp)
ffffffffc020179c:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc020179e:	802ff0ef          	jal	ffffffffc02007a0 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02017a2:	00006797          	auipc	a5,0x6
ffffffffc02017a6:	cc67b783          	ld	a5,-826(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017aa:	65a2                	ld	a1,8(sp)
ffffffffc02017ac:	6502                	ld	a0,0(sp)
ffffffffc02017ae:	739c                	ld	a5,32(a5)
ffffffffc02017b0:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02017b2:	60e2                	ld	ra,24(sp)
ffffffffc02017b4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02017b6:	fe5fe06f          	j	ffffffffc020079a <intr_enable>

ffffffffc02017ba <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017ba:	100027f3          	csrr	a5,sstatus
ffffffffc02017be:	8b89                	andi	a5,a5,2
ffffffffc02017c0:	e799                	bnez	a5,ffffffffc02017ce <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02017c2:	00006797          	auipc	a5,0x6
ffffffffc02017c6:	ca67b783          	ld	a5,-858(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017ca:	779c                	ld	a5,40(a5)
ffffffffc02017cc:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02017ce:	1101                	addi	sp,sp,-32
ffffffffc02017d0:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02017d2:	fcffe0ef          	jal	ffffffffc02007a0 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02017d6:	00006797          	auipc	a5,0x6
ffffffffc02017da:	c927b783          	ld	a5,-878(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017de:	779c                	ld	a5,40(a5)
ffffffffc02017e0:	9782                	jalr	a5
ffffffffc02017e2:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02017e4:	fb7fe0ef          	jal	ffffffffc020079a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02017e8:	60e2                	ld	ra,24(sp)
ffffffffc02017ea:	6522                	ld	a0,8(sp)
ffffffffc02017ec:	6105                	addi	sp,sp,32
ffffffffc02017ee:	8082                	ret

ffffffffc02017f0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02017f0:	00001797          	auipc	a5,0x1
ffffffffc02017f4:	6d878793          	addi	a5,a5,1752 # ffffffffc0202ec8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02017f8:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02017fa:	7139                	addi	sp,sp,-64
ffffffffc02017fc:	fc06                	sd	ra,56(sp)
ffffffffc02017fe:	f822                	sd	s0,48(sp)
ffffffffc0201800:	f426                	sd	s1,40(sp)
ffffffffc0201802:	ec4e                	sd	s3,24(sp)
ffffffffc0201804:	f04a                	sd	s2,32(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201806:	00006417          	auipc	s0,0x6
ffffffffc020180a:	c6240413          	addi	s0,s0,-926 # ffffffffc0207468 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020180e:	00001517          	auipc	a0,0x1
ffffffffc0201812:	42250513          	addi	a0,a0,1058 # ffffffffc0202c30 <etext+0xcc4>
    pmm_manager = &default_pmm_manager;
ffffffffc0201816:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201818:	8ddfe0ef          	jal	ffffffffc02000f4 <cprintf>
    pmm_manager->init();
ffffffffc020181c:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020181e:	00006497          	auipc	s1,0x6
ffffffffc0201822:	c6248493          	addi	s1,s1,-926 # ffffffffc0207480 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201826:	679c                	ld	a5,8(a5)
ffffffffc0201828:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020182a:	57f5                	li	a5,-3
ffffffffc020182c:	07fa                	slli	a5,a5,0x1e
ffffffffc020182e:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201830:	f57fe0ef          	jal	ffffffffc0200786 <get_memory_base>
ffffffffc0201834:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201836:	f5bfe0ef          	jal	ffffffffc0200790 <get_memory_size>
    if (mem_size == 0) {
ffffffffc020183a:	16050063          	beqz	a0,ffffffffc020199a <pmm_init+0x1aa>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020183e:	00a98933          	add	s2,s3,a0
ffffffffc0201842:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0201844:	00001517          	auipc	a0,0x1
ffffffffc0201848:	43450513          	addi	a0,a0,1076 # ffffffffc0202c78 <etext+0xd0c>
ffffffffc020184c:	8a9fe0ef          	jal	ffffffffc02000f4 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201850:	65a2                	ld	a1,8(sp)
ffffffffc0201852:	864e                	mv	a2,s3
ffffffffc0201854:	fff90693          	addi	a3,s2,-1
ffffffffc0201858:	00001517          	auipc	a0,0x1
ffffffffc020185c:	43850513          	addi	a0,a0,1080 # ffffffffc0202c90 <etext+0xd24>
ffffffffc0201860:	895fe0ef          	jal	ffffffffc02000f4 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201864:	c80007b7          	lui	a5,0xc8000
ffffffffc0201868:	864a                	mv	a2,s2
ffffffffc020186a:	0d27e563          	bltu	a5,s2,ffffffffc0201934 <pmm_init+0x144>
ffffffffc020186e:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201870:	00007697          	auipc	a3,0x7
ffffffffc0201874:	c2f68693          	addi	a3,a3,-977 # ffffffffc020849f <end+0xfff>
ffffffffc0201878:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc020187a:	8231                	srli	a2,a2,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020187c:	00006817          	auipc	a6,0x6
ffffffffc0201880:	c1480813          	addi	a6,a6,-1004 # ffffffffc0207490 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201884:	00006517          	auipc	a0,0x6
ffffffffc0201888:	c0450513          	addi	a0,a0,-1020 # ffffffffc0207488 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020188c:	00d83023          	sd	a3,0(a6)
    npage = maxpa / PGSIZE;
ffffffffc0201890:	e110                	sd	a2,0(a0)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201892:	00080737          	lui	a4,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201896:	87b6                	mv	a5,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201898:	02e60a63          	beq	a2,a4,ffffffffc02018cc <pmm_init+0xdc>
ffffffffc020189c:	4701                	li	a4,0
ffffffffc020189e:	4781                	li	a5,0
ffffffffc02018a0:	4305                	li	t1,1
ffffffffc02018a2:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc02018a6:	96ba                	add	a3,a3,a4
ffffffffc02018a8:	06a1                	addi	a3,a3,8
ffffffffc02018aa:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018ae:	6110                	ld	a2,0(a0)
ffffffffc02018b0:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fdf7b61>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018b2:	00083683          	ld	a3,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018b6:	011605b3          	add	a1,a2,a7
ffffffffc02018ba:	02870713          	addi	a4,a4,40 # 80028 <kern_entry-0xffffffffc017ffd8>
ffffffffc02018be:	feb7e4e3          	bltu	a5,a1,ffffffffc02018a6 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018c2:	00259793          	slli	a5,a1,0x2
ffffffffc02018c6:	97ae                	add	a5,a5,a1
ffffffffc02018c8:	078e                	slli	a5,a5,0x3
ffffffffc02018ca:	97b6                	add	a5,a5,a3
ffffffffc02018cc:	c0200737          	lui	a4,0xc0200
ffffffffc02018d0:	0ae7e863          	bltu	a5,a4,ffffffffc0201980 <pmm_init+0x190>
ffffffffc02018d4:	608c                	ld	a1,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02018d6:	777d                	lui	a4,0xfffff
ffffffffc02018d8:	00e97933          	and	s2,s2,a4
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018dc:	8f8d                	sub	a5,a5,a1
    if (freemem < mem_end) {
ffffffffc02018de:	0527ed63          	bltu	a5,s2,ffffffffc0201938 <pmm_init+0x148>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02018e2:	601c                	ld	a5,0(s0)
ffffffffc02018e4:	7b9c                	ld	a5,48(a5)
ffffffffc02018e6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02018e8:	00001517          	auipc	a0,0x1
ffffffffc02018ec:	43050513          	addi	a0,a0,1072 # ffffffffc0202d18 <etext+0xdac>
ffffffffc02018f0:	805fe0ef          	jal	ffffffffc02000f4 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02018f4:	00004597          	auipc	a1,0x4
ffffffffc02018f8:	70c58593          	addi	a1,a1,1804 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc02018fc:	00006797          	auipc	a5,0x6
ffffffffc0201900:	b6b7be23          	sd	a1,-1156(a5) # ffffffffc0207478 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201904:	c02007b7          	lui	a5,0xc0200
ffffffffc0201908:	0af5e563          	bltu	a1,a5,ffffffffc02019b2 <pmm_init+0x1c2>
ffffffffc020190c:	609c                	ld	a5,0(s1)
}
ffffffffc020190e:	7442                	ld	s0,48(sp)
ffffffffc0201910:	70e2                	ld	ra,56(sp)
ffffffffc0201912:	74a2                	ld	s1,40(sp)
ffffffffc0201914:	7902                	ld	s2,32(sp)
ffffffffc0201916:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201918:	40f586b3          	sub	a3,a1,a5
ffffffffc020191c:	00006797          	auipc	a5,0x6
ffffffffc0201920:	b4d7ba23          	sd	a3,-1196(a5) # ffffffffc0207470 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201924:	00001517          	auipc	a0,0x1
ffffffffc0201928:	41450513          	addi	a0,a0,1044 # ffffffffc0202d38 <etext+0xdcc>
ffffffffc020192c:	8636                	mv	a2,a3
}
ffffffffc020192e:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201930:	fc4fe06f          	j	ffffffffc02000f4 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201934:	863e                	mv	a2,a5
ffffffffc0201936:	bf25                	j	ffffffffc020186e <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201938:	6585                	lui	a1,0x1
ffffffffc020193a:	15fd                	addi	a1,a1,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc020193c:	97ae                	add	a5,a5,a1
ffffffffc020193e:	8ff9                	and	a5,a5,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201940:	00c7d713          	srli	a4,a5,0xc
ffffffffc0201944:	02c77263          	bgeu	a4,a2,ffffffffc0201968 <pmm_init+0x178>
    pmm_manager->init_memmap(base, n);
ffffffffc0201948:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc020194a:	fff805b7          	lui	a1,0xfff80
ffffffffc020194e:	972e                	add	a4,a4,a1
ffffffffc0201950:	00271513          	slli	a0,a4,0x2
ffffffffc0201954:	953a                	add	a0,a0,a4
ffffffffc0201956:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201958:	40f90933          	sub	s2,s2,a5
ffffffffc020195c:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc020195e:	00c95593          	srli	a1,s2,0xc
ffffffffc0201962:	9536                	add	a0,a0,a3
ffffffffc0201964:	9702                	jalr	a4
}
ffffffffc0201966:	bfb5                	j	ffffffffc02018e2 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0201968:	00001617          	auipc	a2,0x1
ffffffffc020196c:	38060613          	addi	a2,a2,896 # ffffffffc0202ce8 <etext+0xd7c>
ffffffffc0201970:	06b00593          	li	a1,107
ffffffffc0201974:	00001517          	auipc	a0,0x1
ffffffffc0201978:	39450513          	addi	a0,a0,916 # ffffffffc0202d08 <etext+0xd9c>
ffffffffc020197c:	a2bfe0ef          	jal	ffffffffc02003a6 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201980:	86be                	mv	a3,a5
ffffffffc0201982:	00001617          	auipc	a2,0x1
ffffffffc0201986:	33e60613          	addi	a2,a2,830 # ffffffffc0202cc0 <etext+0xd54>
ffffffffc020198a:	07100593          	li	a1,113
ffffffffc020198e:	00001517          	auipc	a0,0x1
ffffffffc0201992:	2da50513          	addi	a0,a0,730 # ffffffffc0202c68 <etext+0xcfc>
ffffffffc0201996:	a11fe0ef          	jal	ffffffffc02003a6 <__panic>
        panic("DTB memory info not available");
ffffffffc020199a:	00001617          	auipc	a2,0x1
ffffffffc020199e:	2ae60613          	addi	a2,a2,686 # ffffffffc0202c48 <etext+0xcdc>
ffffffffc02019a2:	05a00593          	li	a1,90
ffffffffc02019a6:	00001517          	auipc	a0,0x1
ffffffffc02019aa:	2c250513          	addi	a0,a0,706 # ffffffffc0202c68 <etext+0xcfc>
ffffffffc02019ae:	9f9fe0ef          	jal	ffffffffc02003a6 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02019b2:	86ae                	mv	a3,a1
ffffffffc02019b4:	00001617          	auipc	a2,0x1
ffffffffc02019b8:	30c60613          	addi	a2,a2,780 # ffffffffc0202cc0 <etext+0xd54>
ffffffffc02019bc:	08c00593          	li	a1,140
ffffffffc02019c0:	00001517          	auipc	a0,0x1
ffffffffc02019c4:	2a850513          	addi	a0,a0,680 # ffffffffc0202c68 <etext+0xcfc>
ffffffffc02019c8:	9dffe0ef          	jal	ffffffffc02003a6 <__panic>

ffffffffc02019cc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019cc:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02019ce:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019d2:	f022                	sd	s0,32(sp)
ffffffffc02019d4:	ec26                	sd	s1,24(sp)
ffffffffc02019d6:	e84a                	sd	s2,16(sp)
ffffffffc02019d8:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02019da:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019de:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc02019e0:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02019e4:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf7b5f>
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02019e8:	84aa                	mv	s1,a0
ffffffffc02019ea:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc02019ec:	03067d63          	bgeu	a2,a6,ffffffffc0201a26 <printnum+0x5a>
ffffffffc02019f0:	e44e                	sd	s3,8(sp)
ffffffffc02019f2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02019f4:	4785                	li	a5,1
ffffffffc02019f6:	00e7d763          	bge	a5,a4,ffffffffc0201a04 <printnum+0x38>
            putch(padc, putdat);
ffffffffc02019fa:	85ca                	mv	a1,s2
ffffffffc02019fc:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02019fe:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201a00:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201a02:	fc65                	bnez	s0,ffffffffc02019fa <printnum+0x2e>
ffffffffc0201a04:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a06:	00001797          	auipc	a5,0x1
ffffffffc0201a0a:	37278793          	addi	a5,a5,882 # ffffffffc0202d78 <etext+0xe0c>
ffffffffc0201a0e:	97d2                	add	a5,a5,s4
}
ffffffffc0201a10:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a12:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201a16:	70a2                	ld	ra,40(sp)
ffffffffc0201a18:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a1a:	85ca                	mv	a1,s2
ffffffffc0201a1c:	87a6                	mv	a5,s1
}
ffffffffc0201a1e:	6942                	ld	s2,16(sp)
ffffffffc0201a20:	64e2                	ld	s1,24(sp)
ffffffffc0201a22:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a24:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201a26:	03065633          	divu	a2,a2,a6
ffffffffc0201a2a:	8722                	mv	a4,s0
ffffffffc0201a2c:	fa1ff0ef          	jal	ffffffffc02019cc <printnum>
ffffffffc0201a30:	bfd9                	j	ffffffffc0201a06 <printnum+0x3a>

ffffffffc0201a32 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201a32:	7119                	addi	sp,sp,-128
ffffffffc0201a34:	f4a6                	sd	s1,104(sp)
ffffffffc0201a36:	f0ca                	sd	s2,96(sp)
ffffffffc0201a38:	ecce                	sd	s3,88(sp)
ffffffffc0201a3a:	e8d2                	sd	s4,80(sp)
ffffffffc0201a3c:	e4d6                	sd	s5,72(sp)
ffffffffc0201a3e:	e0da                	sd	s6,64(sp)
ffffffffc0201a40:	f862                	sd	s8,48(sp)
ffffffffc0201a42:	fc86                	sd	ra,120(sp)
ffffffffc0201a44:	f8a2                	sd	s0,112(sp)
ffffffffc0201a46:	fc5e                	sd	s7,56(sp)
ffffffffc0201a48:	f466                	sd	s9,40(sp)
ffffffffc0201a4a:	f06a                	sd	s10,32(sp)
ffffffffc0201a4c:	ec6e                	sd	s11,24(sp)
ffffffffc0201a4e:	84aa                	mv	s1,a0
ffffffffc0201a50:	8c32                	mv	s8,a2
ffffffffc0201a52:	8a36                	mv	s4,a3
ffffffffc0201a54:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a56:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a5a:	05500b13          	li	s6,85
ffffffffc0201a5e:	00001a97          	auipc	s5,0x1
ffffffffc0201a62:	4a2a8a93          	addi	s5,s5,1186 # ffffffffc0202f00 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a66:	000c4503          	lbu	a0,0(s8)
ffffffffc0201a6a:	001c0413          	addi	s0,s8,1
ffffffffc0201a6e:	01350a63          	beq	a0,s3,ffffffffc0201a82 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201a72:	cd0d                	beqz	a0,ffffffffc0201aac <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201a74:	85ca                	mv	a1,s2
ffffffffc0201a76:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201a78:	00044503          	lbu	a0,0(s0)
ffffffffc0201a7c:	0405                	addi	s0,s0,1
ffffffffc0201a7e:	ff351ae3          	bne	a0,s3,ffffffffc0201a72 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0201a82:	5cfd                	li	s9,-1
ffffffffc0201a84:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0201a86:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0201a8a:	4b81                	li	s7,0
ffffffffc0201a8c:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a8e:	00044683          	lbu	a3,0(s0)
ffffffffc0201a92:	00140c13          	addi	s8,s0,1
ffffffffc0201a96:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201a9a:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a9e:	02bb6663          	bltu	s6,a1,ffffffffc0201aca <vprintfmt+0x98>
ffffffffc0201aa2:	058a                	slli	a1,a1,0x2
ffffffffc0201aa4:	95d6                	add	a1,a1,s5
ffffffffc0201aa6:	4198                	lw	a4,0(a1)
ffffffffc0201aa8:	9756                	add	a4,a4,s5
ffffffffc0201aaa:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201aac:	70e6                	ld	ra,120(sp)
ffffffffc0201aae:	7446                	ld	s0,112(sp)
ffffffffc0201ab0:	74a6                	ld	s1,104(sp)
ffffffffc0201ab2:	7906                	ld	s2,96(sp)
ffffffffc0201ab4:	69e6                	ld	s3,88(sp)
ffffffffc0201ab6:	6a46                	ld	s4,80(sp)
ffffffffc0201ab8:	6aa6                	ld	s5,72(sp)
ffffffffc0201aba:	6b06                	ld	s6,64(sp)
ffffffffc0201abc:	7be2                	ld	s7,56(sp)
ffffffffc0201abe:	7c42                	ld	s8,48(sp)
ffffffffc0201ac0:	7ca2                	ld	s9,40(sp)
ffffffffc0201ac2:	7d02                	ld	s10,32(sp)
ffffffffc0201ac4:	6de2                	ld	s11,24(sp)
ffffffffc0201ac6:	6109                	addi	sp,sp,128
ffffffffc0201ac8:	8082                	ret
            putch('%', putdat);
ffffffffc0201aca:	85ca                	mv	a1,s2
ffffffffc0201acc:	02500513          	li	a0,37
ffffffffc0201ad0:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201ad2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201ad6:	02500713          	li	a4,37
ffffffffc0201ada:	8c22                	mv	s8,s0
ffffffffc0201adc:	f8e785e3          	beq	a5,a4,ffffffffc0201a66 <vprintfmt+0x34>
ffffffffc0201ae0:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201ae4:	1c7d                	addi	s8,s8,-1
ffffffffc0201ae6:	fee79de3          	bne	a5,a4,ffffffffc0201ae0 <vprintfmt+0xae>
ffffffffc0201aea:	bfb5                	j	ffffffffc0201a66 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201aec:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201af0:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201af2:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0201af6:	fd06071b          	addiw	a4,a2,-48
ffffffffc0201afa:	24e56a63          	bltu	a0,a4,ffffffffc0201d4e <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201afe:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b00:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201b02:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0201b06:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201b0a:	0197073b          	addw	a4,a4,s9
ffffffffc0201b0e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201b12:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201b14:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201b18:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201b1a:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201b1e:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201b22:	feb570e3          	bgeu	a0,a1,ffffffffc0201b02 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0201b26:	f60d54e3          	bgez	s10,ffffffffc0201a8e <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201b2a:	8d66                	mv	s10,s9
ffffffffc0201b2c:	5cfd                	li	s9,-1
ffffffffc0201b2e:	b785                	j	ffffffffc0201a8e <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b30:	8db6                	mv	s11,a3
ffffffffc0201b32:	8462                	mv	s0,s8
ffffffffc0201b34:	bfa9                	j	ffffffffc0201a8e <vprintfmt+0x5c>
ffffffffc0201b36:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201b38:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201b3a:	bf91                	j	ffffffffc0201a8e <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201b3c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b3e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b42:	00f74463          	blt	a4,a5,ffffffffc0201b4a <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0201b46:	1a078763          	beqz	a5,ffffffffc0201cf4 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201b4a:	000a3603          	ld	a2,0(s4)
ffffffffc0201b4e:	46c1                	li	a3,16
ffffffffc0201b50:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201b52:	000d879b          	sext.w	a5,s11
ffffffffc0201b56:	876a                	mv	a4,s10
ffffffffc0201b58:	85ca                	mv	a1,s2
ffffffffc0201b5a:	8526                	mv	a0,s1
ffffffffc0201b5c:	e71ff0ef          	jal	ffffffffc02019cc <printnum>
            break;
ffffffffc0201b60:	b719                	j	ffffffffc0201a66 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201b62:	000a2503          	lw	a0,0(s4)
ffffffffc0201b66:	85ca                	mv	a1,s2
ffffffffc0201b68:	0a21                	addi	s4,s4,8
ffffffffc0201b6a:	9482                	jalr	s1
            break;
ffffffffc0201b6c:	bded                	j	ffffffffc0201a66 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201b6e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b70:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b74:	00f74463          	blt	a4,a5,ffffffffc0201b7c <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0201b78:	16078963          	beqz	a5,ffffffffc0201cea <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0201b7c:	000a3603          	ld	a2,0(s4)
ffffffffc0201b80:	46a9                	li	a3,10
ffffffffc0201b82:	8a2e                	mv	s4,a1
ffffffffc0201b84:	b7f9                	j	ffffffffc0201b52 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0201b86:	85ca                	mv	a1,s2
ffffffffc0201b88:	03000513          	li	a0,48
ffffffffc0201b8c:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0201b8e:	85ca                	mv	a1,s2
ffffffffc0201b90:	07800513          	li	a0,120
ffffffffc0201b94:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b96:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201b9a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b9c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201b9e:	bf55                	j	ffffffffc0201b52 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0201ba0:	85ca                	mv	a1,s2
ffffffffc0201ba2:	02500513          	li	a0,37
ffffffffc0201ba6:	9482                	jalr	s1
            break;
ffffffffc0201ba8:	bd7d                	j	ffffffffc0201a66 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201baa:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bae:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0201bb0:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201bb2:	bf95                	j	ffffffffc0201b26 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0201bb4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201bb6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201bba:	00f74463          	blt	a4,a5,ffffffffc0201bc2 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0201bbe:	12078163          	beqz	a5,ffffffffc0201ce0 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0201bc2:	000a3603          	ld	a2,0(s4)
ffffffffc0201bc6:	46a1                	li	a3,8
ffffffffc0201bc8:	8a2e                	mv	s4,a1
ffffffffc0201bca:	b761                	j	ffffffffc0201b52 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0201bcc:	876a                	mv	a4,s10
ffffffffc0201bce:	000d5363          	bgez	s10,ffffffffc0201bd4 <vprintfmt+0x1a2>
ffffffffc0201bd2:	4701                	li	a4,0
ffffffffc0201bd4:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bd8:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201bda:	bd55                	j	ffffffffc0201a8e <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201bdc:	000d841b          	sext.w	s0,s11
ffffffffc0201be0:	fd340793          	addi	a5,s0,-45
ffffffffc0201be4:	00f037b3          	snez	a5,a5
ffffffffc0201be8:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201bec:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201bf0:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201bf2:	008a0793          	addi	a5,s4,8
ffffffffc0201bf6:	e43e                	sd	a5,8(sp)
ffffffffc0201bf8:	100d8c63          	beqz	s11,ffffffffc0201d10 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201bfc:	12071363          	bnez	a4,ffffffffc0201d22 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c00:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c04:	0007851b          	sext.w	a0,a5
ffffffffc0201c08:	c78d                	beqz	a5,ffffffffc0201c32 <vprintfmt+0x200>
ffffffffc0201c0a:	0d85                	addi	s11,s11,1
ffffffffc0201c0c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c0e:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c12:	000cc563          	bltz	s9,ffffffffc0201c1c <vprintfmt+0x1ea>
ffffffffc0201c16:	3cfd                	addiw	s9,s9,-1
ffffffffc0201c18:	008c8d63          	beq	s9,s0,ffffffffc0201c32 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c1c:	020b9663          	bnez	s7,ffffffffc0201c48 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201c20:	85ca                	mv	a1,s2
ffffffffc0201c22:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c24:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c28:	0d85                	addi	s11,s11,1
ffffffffc0201c2a:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c2c:	0007851b          	sext.w	a0,a5
ffffffffc0201c30:	f3ed                	bnez	a5,ffffffffc0201c12 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201c32:	01a05963          	blez	s10,ffffffffc0201c44 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0201c36:	85ca                	mv	a1,s2
ffffffffc0201c38:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201c3c:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201c3e:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201c40:	fe0d1be3          	bnez	s10,ffffffffc0201c36 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c44:	6a22                	ld	s4,8(sp)
ffffffffc0201c46:	b505                	j	ffffffffc0201a66 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c48:	3781                	addiw	a5,a5,-32
ffffffffc0201c4a:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201c20 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201c4e:	03f00513          	li	a0,63
ffffffffc0201c52:	85ca                	mv	a1,s2
ffffffffc0201c54:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c56:	000dc783          	lbu	a5,0(s11)
ffffffffc0201c5a:	0d85                	addi	s11,s11,1
ffffffffc0201c5c:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c5e:	0007851b          	sext.w	a0,a5
ffffffffc0201c62:	dbe1                	beqz	a5,ffffffffc0201c32 <vprintfmt+0x200>
ffffffffc0201c64:	fa0cd9e3          	bgez	s9,ffffffffc0201c16 <vprintfmt+0x1e4>
ffffffffc0201c68:	b7c5                	j	ffffffffc0201c48 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201c6a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c6e:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201c70:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201c72:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201c76:	8fb9                	xor	a5,a5,a4
ffffffffc0201c78:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c7c:	02d64563          	blt	a2,a3,ffffffffc0201ca6 <vprintfmt+0x274>
ffffffffc0201c80:	00001797          	auipc	a5,0x1
ffffffffc0201c84:	3d878793          	addi	a5,a5,984 # ffffffffc0203058 <error_string>
ffffffffc0201c88:	00369713          	slli	a4,a3,0x3
ffffffffc0201c8c:	97ba                	add	a5,a5,a4
ffffffffc0201c8e:	639c                	ld	a5,0(a5)
ffffffffc0201c90:	cb99                	beqz	a5,ffffffffc0201ca6 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201c92:	86be                	mv	a3,a5
ffffffffc0201c94:	00001617          	auipc	a2,0x1
ffffffffc0201c98:	11460613          	addi	a2,a2,276 # ffffffffc0202da8 <etext+0xe3c>
ffffffffc0201c9c:	85ca                	mv	a1,s2
ffffffffc0201c9e:	8526                	mv	a0,s1
ffffffffc0201ca0:	0d8000ef          	jal	ffffffffc0201d78 <printfmt>
ffffffffc0201ca4:	b3c9                	j	ffffffffc0201a66 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201ca6:	00001617          	auipc	a2,0x1
ffffffffc0201caa:	0f260613          	addi	a2,a2,242 # ffffffffc0202d98 <etext+0xe2c>
ffffffffc0201cae:	85ca                	mv	a1,s2
ffffffffc0201cb0:	8526                	mv	a0,s1
ffffffffc0201cb2:	0c6000ef          	jal	ffffffffc0201d78 <printfmt>
ffffffffc0201cb6:	bb45                	j	ffffffffc0201a66 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201cb8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201cba:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201cbe:	00f74363          	blt	a4,a5,ffffffffc0201cc4 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201cc2:	cf81                	beqz	a5,ffffffffc0201cda <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0201cc4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201cc8:	02044b63          	bltz	s0,ffffffffc0201cfe <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201ccc:	8622                	mv	a2,s0
ffffffffc0201cce:	8a5e                	mv	s4,s7
ffffffffc0201cd0:	46a9                	li	a3,10
ffffffffc0201cd2:	b541                	j	ffffffffc0201b52 <vprintfmt+0x120>
            lflag ++;
ffffffffc0201cd4:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201cd6:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201cd8:	bb5d                	j	ffffffffc0201a8e <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201cda:	000a2403          	lw	s0,0(s4)
ffffffffc0201cde:	b7ed                	j	ffffffffc0201cc8 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201ce0:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ce4:	46a1                	li	a3,8
ffffffffc0201ce6:	8a2e                	mv	s4,a1
ffffffffc0201ce8:	b5ad                	j	ffffffffc0201b52 <vprintfmt+0x120>
ffffffffc0201cea:	000a6603          	lwu	a2,0(s4)
ffffffffc0201cee:	46a9                	li	a3,10
ffffffffc0201cf0:	8a2e                	mv	s4,a1
ffffffffc0201cf2:	b585                	j	ffffffffc0201b52 <vprintfmt+0x120>
ffffffffc0201cf4:	000a6603          	lwu	a2,0(s4)
ffffffffc0201cf8:	46c1                	li	a3,16
ffffffffc0201cfa:	8a2e                	mv	s4,a1
ffffffffc0201cfc:	bd99                	j	ffffffffc0201b52 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201cfe:	85ca                	mv	a1,s2
ffffffffc0201d00:	02d00513          	li	a0,45
ffffffffc0201d04:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0201d06:	40800633          	neg	a2,s0
ffffffffc0201d0a:	8a5e                	mv	s4,s7
ffffffffc0201d0c:	46a9                	li	a3,10
ffffffffc0201d0e:	b591                	j	ffffffffc0201b52 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201d10:	e329                	bnez	a4,ffffffffc0201d52 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d12:	02800793          	li	a5,40
ffffffffc0201d16:	853e                	mv	a0,a5
ffffffffc0201d18:	00001d97          	auipc	s11,0x1
ffffffffc0201d1c:	079d8d93          	addi	s11,s11,121 # ffffffffc0202d91 <etext+0xe25>
ffffffffc0201d20:	b5f5                	j	ffffffffc0201c0c <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d22:	85e6                	mv	a1,s9
ffffffffc0201d24:	856e                	mv	a0,s11
ffffffffc0201d26:	1aa000ef          	jal	ffffffffc0201ed0 <strnlen>
ffffffffc0201d2a:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201d2e:	01a05863          	blez	s10,ffffffffc0201d3e <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201d32:	85ca                	mv	a1,s2
ffffffffc0201d34:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d36:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201d38:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d3a:	fe0d1ce3          	bnez	s10,ffffffffc0201d32 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d3e:	000dc783          	lbu	a5,0(s11)
ffffffffc0201d42:	0007851b          	sext.w	a0,a5
ffffffffc0201d46:	ec0792e3          	bnez	a5,ffffffffc0201c0a <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201d4a:	6a22                	ld	s4,8(sp)
ffffffffc0201d4c:	bb29                	j	ffffffffc0201a66 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201d4e:	8462                	mv	s0,s8
ffffffffc0201d50:	bbd9                	j	ffffffffc0201b26 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d52:	85e6                	mv	a1,s9
ffffffffc0201d54:	00001517          	auipc	a0,0x1
ffffffffc0201d58:	03c50513          	addi	a0,a0,60 # ffffffffc0202d90 <etext+0xe24>
ffffffffc0201d5c:	174000ef          	jal	ffffffffc0201ed0 <strnlen>
ffffffffc0201d60:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d64:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201d68:	00001d97          	auipc	s11,0x1
ffffffffc0201d6c:	028d8d93          	addi	s11,s11,40 # ffffffffc0202d90 <etext+0xe24>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d70:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d72:	fda040e3          	bgtz	s10,ffffffffc0201d32 <vprintfmt+0x300>
ffffffffc0201d76:	bd51                	j	ffffffffc0201c0a <vprintfmt+0x1d8>

ffffffffc0201d78 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d78:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201d7a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d7e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d80:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d82:	ec06                	sd	ra,24(sp)
ffffffffc0201d84:	f83a                	sd	a4,48(sp)
ffffffffc0201d86:	fc3e                	sd	a5,56(sp)
ffffffffc0201d88:	e0c2                	sd	a6,64(sp)
ffffffffc0201d8a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201d8c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d8e:	ca5ff0ef          	jal	ffffffffc0201a32 <vprintfmt>
}
ffffffffc0201d92:	60e2                	ld	ra,24(sp)
ffffffffc0201d94:	6161                	addi	sp,sp,80
ffffffffc0201d96:	8082                	ret

ffffffffc0201d98 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201d98:	7179                	addi	sp,sp,-48
ffffffffc0201d9a:	f406                	sd	ra,40(sp)
ffffffffc0201d9c:	f022                	sd	s0,32(sp)
ffffffffc0201d9e:	ec26                	sd	s1,24(sp)
ffffffffc0201da0:	e84a                	sd	s2,16(sp)
ffffffffc0201da2:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc0201da4:	c901                	beqz	a0,ffffffffc0201db4 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc0201da6:	85aa                	mv	a1,a0
ffffffffc0201da8:	00001517          	auipc	a0,0x1
ffffffffc0201dac:	00050513          	mv	a0,a0
ffffffffc0201db0:	b44fe0ef          	jal	ffffffffc02000f4 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc0201db4:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201db6:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc0201db8:	00005997          	auipc	s3,0x5
ffffffffc0201dbc:	28898993          	addi	s3,s3,648 # ffffffffc0207040 <buf>
        c = getchar();
ffffffffc0201dc0:	bb6fe0ef          	jal	ffffffffc0200176 <getchar>
ffffffffc0201dc4:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201dc6:	ff850793          	addi	a5,a0,-8 # ffffffffc0202da0 <etext+0xe34>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201dca:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201dce:	ff650693          	addi	a3,a0,-10
ffffffffc0201dd2:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201dd6:	02054963          	bltz	a0,ffffffffc0201e08 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201dda:	02a95f63          	bge	s2,a0,ffffffffc0201e18 <readline+0x80>
ffffffffc0201dde:	cf0d                	beqz	a4,ffffffffc0201e18 <readline+0x80>
            cputchar(c);
ffffffffc0201de0:	b48fe0ef          	jal	ffffffffc0200128 <cputchar>
            buf[i ++] = c;
ffffffffc0201de4:	009987b3          	add	a5,s3,s1
ffffffffc0201de8:	00878023          	sb	s0,0(a5)
ffffffffc0201dec:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc0201dee:	b88fe0ef          	jal	ffffffffc0200176 <getchar>
ffffffffc0201df2:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0201df4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201df8:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc0201dfc:	ff650693          	addi	a3,a0,-10
ffffffffc0201e00:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201e04:	fc055be3          	bgez	a0,ffffffffc0201dda <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0201e08:	70a2                	ld	ra,40(sp)
ffffffffc0201e0a:	7402                	ld	s0,32(sp)
ffffffffc0201e0c:	64e2                	ld	s1,24(sp)
ffffffffc0201e0e:	6942                	ld	s2,16(sp)
ffffffffc0201e10:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0201e12:	4501                	li	a0,0
}
ffffffffc0201e14:	6145                	addi	sp,sp,48
ffffffffc0201e16:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0201e18:	eb81                	bnez	a5,ffffffffc0201e28 <readline+0x90>
            cputchar(c);
ffffffffc0201e1a:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc0201e1c:	00905663          	blez	s1,ffffffffc0201e28 <readline+0x90>
            cputchar(c);
ffffffffc0201e20:	b08fe0ef          	jal	ffffffffc0200128 <cputchar>
            i --;
ffffffffc0201e24:	34fd                	addiw	s1,s1,-1
ffffffffc0201e26:	bf69                	j	ffffffffc0201dc0 <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0201e28:	c291                	beqz	a3,ffffffffc0201e2c <readline+0x94>
ffffffffc0201e2a:	fa59                	bnez	a2,ffffffffc0201dc0 <readline+0x28>
            cputchar(c);
ffffffffc0201e2c:	8522                	mv	a0,s0
ffffffffc0201e2e:	afafe0ef          	jal	ffffffffc0200128 <cputchar>
            buf[i] = '\0';
ffffffffc0201e32:	00005517          	auipc	a0,0x5
ffffffffc0201e36:	20e50513          	addi	a0,a0,526 # ffffffffc0207040 <buf>
ffffffffc0201e3a:	94aa                	add	s1,s1,a0
ffffffffc0201e3c:	00048023          	sb	zero,0(s1)
}
ffffffffc0201e40:	70a2                	ld	ra,40(sp)
ffffffffc0201e42:	7402                	ld	s0,32(sp)
ffffffffc0201e44:	64e2                	ld	s1,24(sp)
ffffffffc0201e46:	6942                	ld	s2,16(sp)
ffffffffc0201e48:	69a2                	ld	s3,8(sp)
ffffffffc0201e4a:	6145                	addi	sp,sp,48
ffffffffc0201e4c:	8082                	ret

ffffffffc0201e4e <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201e4e:	00005717          	auipc	a4,0x5
ffffffffc0201e52:	1d273703          	ld	a4,466(a4) # ffffffffc0207020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201e56:	4781                	li	a5,0
ffffffffc0201e58:	88ba                	mv	a7,a4
ffffffffc0201e5a:	852a                	mv	a0,a0
ffffffffc0201e5c:	85be                	mv	a1,a5
ffffffffc0201e5e:	863e                	mv	a2,a5
ffffffffc0201e60:	00000073          	ecall
ffffffffc0201e64:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201e66:	8082                	ret

ffffffffc0201e68 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201e68:	00005717          	auipc	a4,0x5
ffffffffc0201e6c:	63073703          	ld	a4,1584(a4) # ffffffffc0207498 <SBI_SET_TIMER>
ffffffffc0201e70:	4781                	li	a5,0
ffffffffc0201e72:	88ba                	mv	a7,a4
ffffffffc0201e74:	852a                	mv	a0,a0
ffffffffc0201e76:	85be                	mv	a1,a5
ffffffffc0201e78:	863e                	mv	a2,a5
ffffffffc0201e7a:	00000073          	ecall
ffffffffc0201e7e:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201e80:	8082                	ret

ffffffffc0201e82 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201e82:	00005797          	auipc	a5,0x5
ffffffffc0201e86:	1967b783          	ld	a5,406(a5) # ffffffffc0207018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201e8a:	4501                	li	a0,0
ffffffffc0201e8c:	88be                	mv	a7,a5
ffffffffc0201e8e:	852a                	mv	a0,a0
ffffffffc0201e90:	85aa                	mv	a1,a0
ffffffffc0201e92:	862a                	mv	a2,a0
ffffffffc0201e94:	00000073          	ecall
ffffffffc0201e98:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201e9a:	2501                	sext.w	a0,a0
ffffffffc0201e9c:	8082                	ret

ffffffffc0201e9e <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201e9e:	00005717          	auipc	a4,0x5
ffffffffc0201ea2:	17273703          	ld	a4,370(a4) # ffffffffc0207010 <SBI_SHUTDOWN>
ffffffffc0201ea6:	4781                	li	a5,0
ffffffffc0201ea8:	88ba                	mv	a7,a4
ffffffffc0201eaa:	853e                	mv	a0,a5
ffffffffc0201eac:	85be                	mv	a1,a5
ffffffffc0201eae:	863e                	mv	a2,a5
ffffffffc0201eb0:	00000073          	ecall
ffffffffc0201eb4:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201eb6:	8082                	ret

ffffffffc0201eb8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201eb8:	00054783          	lbu	a5,0(a0)
ffffffffc0201ebc:	cb81                	beqz	a5,ffffffffc0201ecc <strlen+0x14>
    size_t cnt = 0;
ffffffffc0201ebe:	4781                	li	a5,0
        cnt ++;
ffffffffc0201ec0:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201ec2:	00f50733          	add	a4,a0,a5
ffffffffc0201ec6:	00074703          	lbu	a4,0(a4)
ffffffffc0201eca:	fb7d                	bnez	a4,ffffffffc0201ec0 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0201ecc:	853e                	mv	a0,a5
ffffffffc0201ece:	8082                	ret

ffffffffc0201ed0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201ed0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201ed2:	e589                	bnez	a1,ffffffffc0201edc <strnlen+0xc>
ffffffffc0201ed4:	a811                	j	ffffffffc0201ee8 <strnlen+0x18>
        cnt ++;
ffffffffc0201ed6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201ed8:	00f58863          	beq	a1,a5,ffffffffc0201ee8 <strnlen+0x18>
ffffffffc0201edc:	00f50733          	add	a4,a0,a5
ffffffffc0201ee0:	00074703          	lbu	a4,0(a4)
ffffffffc0201ee4:	fb6d                	bnez	a4,ffffffffc0201ed6 <strnlen+0x6>
ffffffffc0201ee6:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201ee8:	852e                	mv	a0,a1
ffffffffc0201eea:	8082                	ret

ffffffffc0201eec <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201eec:	00054783          	lbu	a5,0(a0)
ffffffffc0201ef0:	e791                	bnez	a5,ffffffffc0201efc <strcmp+0x10>
ffffffffc0201ef2:	a01d                	j	ffffffffc0201f18 <strcmp+0x2c>
ffffffffc0201ef4:	00054783          	lbu	a5,0(a0)
ffffffffc0201ef8:	cb99                	beqz	a5,ffffffffc0201f0e <strcmp+0x22>
ffffffffc0201efa:	0585                	addi	a1,a1,1 # fffffffffff80001 <end+0x3fd78b61>
ffffffffc0201efc:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201f00:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201f02:	fef709e3          	beq	a4,a5,ffffffffc0201ef4 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f06:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201f0a:	9d19                	subw	a0,a0,a4
ffffffffc0201f0c:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f0e:	0015c703          	lbu	a4,1(a1)
ffffffffc0201f12:	4501                	li	a0,0
}
ffffffffc0201f14:	9d19                	subw	a0,a0,a4
ffffffffc0201f16:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f18:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f1c:	4501                	li	a0,0
ffffffffc0201f1e:	b7f5                	j	ffffffffc0201f0a <strcmp+0x1e>

ffffffffc0201f20 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f20:	ce01                	beqz	a2,ffffffffc0201f38 <strncmp+0x18>
ffffffffc0201f22:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201f26:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f28:	cb91                	beqz	a5,ffffffffc0201f3c <strncmp+0x1c>
ffffffffc0201f2a:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f2e:	00f71763          	bne	a4,a5,ffffffffc0201f3c <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201f32:	0505                	addi	a0,a0,1
ffffffffc0201f34:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f36:	f675                	bnez	a2,ffffffffc0201f22 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f38:	4501                	li	a0,0
ffffffffc0201f3a:	8082                	ret
ffffffffc0201f3c:	00054503          	lbu	a0,0(a0)
ffffffffc0201f40:	0005c783          	lbu	a5,0(a1)
ffffffffc0201f44:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201f46:	8082                	ret

ffffffffc0201f48 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201f48:	a021                	j	ffffffffc0201f50 <strchr+0x8>
        if (*s == c) {
ffffffffc0201f4a:	00f58763          	beq	a1,a5,ffffffffc0201f58 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0201f4e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201f50:	00054783          	lbu	a5,0(a0)
ffffffffc0201f54:	fbfd                	bnez	a5,ffffffffc0201f4a <strchr+0x2>
    }
    return NULL;
ffffffffc0201f56:	4501                	li	a0,0
}
ffffffffc0201f58:	8082                	ret

ffffffffc0201f5a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201f5a:	ca01                	beqz	a2,ffffffffc0201f6a <memset+0x10>
ffffffffc0201f5c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201f5e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201f60:	0785                	addi	a5,a5,1
ffffffffc0201f62:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201f66:	fef61de3          	bne	a2,a5,ffffffffc0201f60 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201f6a:	8082                	ret
