
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49e60613          	addi	a2,a2,1182 # ffffffffc020d4f0 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0207ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	657030ef          	jal	ffffffffc0203eb8 <memset>
    dtb_init();
ffffffffc0200066:	4c2000ef          	jal	ffffffffc0200528 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	44c000ef          	jal	ffffffffc02004b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e9a58593          	addi	a1,a1,-358 # ffffffffc0203f08 <etext+0x2>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	eb250513          	addi	a0,a0,-334 # ffffffffc0203f28 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	158000ef          	jal	ffffffffc02001da <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	15c020ef          	jal	ffffffffc02021e2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	7f0000ef          	jal	ffffffffc020087a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	7ee000ef          	jal	ffffffffc020087c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	6cd020ef          	jal	ffffffffc0202f5e <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	5ea030ef          	jal	ffffffffc0203680 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	3ca000ef          	jal	ffffffffc0200464 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	7d0000ef          	jal	ffffffffc020086e <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	037030ef          	jal	ffffffffc02038d8 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	7179                	addi	sp,sp,-48
ffffffffc02000a8:	f406                	sd	ra,40(sp)
ffffffffc02000aa:	f022                	sd	s0,32(sp)
ffffffffc02000ac:	ec26                	sd	s1,24(sp)
ffffffffc02000ae:	e84a                	sd	s2,16(sp)
ffffffffc02000b0:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc02000b2:	c901                	beqz	a0,ffffffffc02000c2 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc02000b4:	85aa                	mv	a1,a0
ffffffffc02000b6:	00004517          	auipc	a0,0x4
ffffffffc02000ba:	e7a50513          	addi	a0,a0,-390 # ffffffffc0203f30 <etext+0x2a>
ffffffffc02000be:	0d6000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c2:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c4:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc02000c6:	00009997          	auipc	s3,0x9
ffffffffc02000ca:	f6a98993          	addi	s3,s3,-150 # ffffffffc0209030 <buf>
        c = getchar();
ffffffffc02000ce:	0fc000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc02000d2:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d8:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000dc:	ff650693          	addi	a3,a0,-10
ffffffffc02000e0:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc02000e4:	02054963          	bltz	a0,ffffffffc0200116 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e8:	02a95f63          	bge	s2,a0,ffffffffc0200126 <readline+0x80>
ffffffffc02000ec:	cf0d                	beqz	a4,ffffffffc0200126 <readline+0x80>
            cputchar(c);
ffffffffc02000ee:	0da000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc02000f2:	009987b3          	add	a5,s3,s1
ffffffffc02000f6:	00878023          	sb	s0,0(a5)
ffffffffc02000fa:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc02000fc:	0ce000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc0200100:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200102:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200106:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	ff650693          	addi	a3,a0,-10
ffffffffc020010e:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0200112:	fc055be3          	bgez	a0,ffffffffc02000e8 <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0200116:	70a2                	ld	ra,40(sp)
ffffffffc0200118:	7402                	ld	s0,32(sp)
ffffffffc020011a:	64e2                	ld	s1,24(sp)
ffffffffc020011c:	6942                	ld	s2,16(sp)
ffffffffc020011e:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0200120:	4501                	li	a0,0
}
ffffffffc0200122:	6145                	addi	sp,sp,48
ffffffffc0200124:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0200126:	eb81                	bnez	a5,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc0200128:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc020012a:	00905663          	blez	s1,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc020012e:	09a000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200132:	34fd                	addiw	s1,s1,-1
ffffffffc0200134:	bf69                	j	ffffffffc02000ce <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0200136:	c291                	beqz	a3,ffffffffc020013a <readline+0x94>
ffffffffc0200138:	fa59                	bnez	a2,ffffffffc02000ce <readline+0x28>
            cputchar(c);
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	08c000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc0200140:	00009517          	auipc	a0,0x9
ffffffffc0200144:	ef050513          	addi	a0,a0,-272 # ffffffffc0209030 <buf>
ffffffffc0200148:	94aa                	add	s1,s1,a0
ffffffffc020014a:	00048023          	sb	zero,0(s1)
}
ffffffffc020014e:	70a2                	ld	ra,40(sp)
ffffffffc0200150:	7402                	ld	s0,32(sp)
ffffffffc0200152:	64e2                	ld	s1,24(sp)
ffffffffc0200154:	6942                	ld	s2,16(sp)
ffffffffc0200156:	69a2                	ld	s3,8(sp)
ffffffffc0200158:	6145                	addi	sp,sp,48
ffffffffc020015a:	8082                	ret

ffffffffc020015c <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	ec06                	sd	ra,24(sp)
ffffffffc0200160:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200162:	356000ef          	jal	ffffffffc02004b8 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	65a2                	ld	a1,8(sp)
}
ffffffffc0200168:	60e2                	ld	ra,24(sp)
    (*cnt)++;
ffffffffc020016a:	419c                	lw	a5,0(a1)
ffffffffc020016c:	2785                	addiw	a5,a5,1
ffffffffc020016e:	c19c                	sw	a5,0(a1)
}
ffffffffc0200170:	6105                	addi	sp,sp,32
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe250513          	addi	a0,a0,-30 # ffffffffc020015c <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	117030ef          	jal	ffffffffc0203a9e <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40
{
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb850513          	addi	a0,a0,-72 # ffffffffc020015c <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02001b8:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	0e3030ef          	jal	ffffffffc0203a9e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001c8:	acc5                	j	ffffffffc02004b8 <cons_putc>

ffffffffc02001ca <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc02001ca:	1141                	addi	sp,sp,-16
ffffffffc02001cc:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001ce:	31e000ef          	jal	ffffffffc02004ec <cons_getc>
ffffffffc02001d2:	dd75                	beqz	a0,ffffffffc02001ce <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001d4:	60a2                	ld	ra,8(sp)
ffffffffc02001d6:	0141                	addi	sp,sp,16
ffffffffc02001d8:	8082                	ret

ffffffffc02001da <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02001da:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	d5c50513          	addi	a0,a0,-676 # ffffffffc0203f38 <etext+0x32>
{
ffffffffc02001e4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001e6:	fafff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001ea:	00000597          	auipc	a1,0x0
ffffffffc02001ee:	e6058593          	addi	a1,a1,-416 # ffffffffc020004a <kern_init>
ffffffffc02001f2:	00004517          	auipc	a0,0x4
ffffffffc02001f6:	d6650513          	addi	a0,a0,-666 # ffffffffc0203f58 <etext+0x52>
ffffffffc02001fa:	f9bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02001fe:	00004597          	auipc	a1,0x4
ffffffffc0200202:	d0858593          	addi	a1,a1,-760 # ffffffffc0203f06 <etext>
ffffffffc0200206:	00004517          	auipc	a0,0x4
ffffffffc020020a:	d7250513          	addi	a0,a0,-654 # ffffffffc0203f78 <etext+0x72>
ffffffffc020020e:	f87ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200212:	00009597          	auipc	a1,0x9
ffffffffc0200216:	e1e58593          	addi	a1,a1,-482 # ffffffffc0209030 <buf>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	d7e50513          	addi	a0,a0,-642 # ffffffffc0203f98 <etext+0x92>
ffffffffc0200222:	f73ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200226:	0000d597          	auipc	a1,0xd
ffffffffc020022a:	2ca58593          	addi	a1,a1,714 # ffffffffc020d4f0 <end>
ffffffffc020022e:	00004517          	auipc	a0,0x4
ffffffffc0200232:	d8a50513          	addi	a0,a0,-630 # ffffffffc0203fb8 <etext+0xb2>
ffffffffc0200236:	f5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020023a:	00000717          	auipc	a4,0x0
ffffffffc020023e:	e1070713          	addi	a4,a4,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000d797          	auipc	a5,0xd
ffffffffc0200246:	6ad78793          	addi	a5,a5,1709 # ffffffffc020d8ef <end+0x3ff>
ffffffffc020024a:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020024c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200250:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200252:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200256:	95be                	add	a1,a1,a5
ffffffffc0200258:	85a9                	srai	a1,a1,0xa
ffffffffc020025a:	00004517          	auipc	a0,0x4
ffffffffc020025e:	d7e50513          	addi	a0,a0,-642 # ffffffffc0203fd8 <etext+0xd2>
}
ffffffffc0200262:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200264:	bf05                	j	ffffffffc0200194 <cprintf>

ffffffffc0200266 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc0200266:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200268:	00004617          	auipc	a2,0x4
ffffffffc020026c:	da060613          	addi	a2,a2,-608 # ffffffffc0204008 <etext+0x102>
ffffffffc0200270:	04900593          	li	a1,73
ffffffffc0200274:	00004517          	auipc	a0,0x4
ffffffffc0200278:	dac50513          	addi	a0,a0,-596 # ffffffffc0204020 <etext+0x11a>
{
ffffffffc020027c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020027e:	188000ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0200282 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200282:	1101                	addi	sp,sp,-32
ffffffffc0200284:	e822                	sd	s0,16(sp)
ffffffffc0200286:	e426                	sd	s1,8(sp)
ffffffffc0200288:	ec06                	sd	ra,24(sp)
ffffffffc020028a:	00005417          	auipc	s0,0x5
ffffffffc020028e:	5b640413          	addi	s0,s0,1462 # ffffffffc0205840 <commands>
ffffffffc0200292:	00005497          	auipc	s1,0x5
ffffffffc0200296:	5f648493          	addi	s1,s1,1526 # ffffffffc0205888 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020029a:	6410                	ld	a2,8(s0)
ffffffffc020029c:	600c                	ld	a1,0(s0)
ffffffffc020029e:	00004517          	auipc	a0,0x4
ffffffffc02002a2:	d9a50513          	addi	a0,a0,-614 # ffffffffc0204038 <etext+0x132>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002a6:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002a8:	eedff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ac:	fe9417e3          	bne	s0,s1,ffffffffc020029a <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002b0:	60e2                	ld	ra,24(sp)
ffffffffc02002b2:	6442                	ld	s0,16(sp)
ffffffffc02002b4:	64a2                	ld	s1,8(sp)
ffffffffc02002b6:	4501                	li	a0,0
ffffffffc02002b8:	6105                	addi	sp,sp,32
ffffffffc02002ba:	8082                	ret

ffffffffc02002bc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002bc:	1141                	addi	sp,sp,-16
ffffffffc02002be:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002c0:	f1bff0ef          	jal	ffffffffc02001da <print_kerninfo>
    return 0;
}
ffffffffc02002c4:	60a2                	ld	ra,8(sp)
ffffffffc02002c6:	4501                	li	a0,0
ffffffffc02002c8:	0141                	addi	sp,sp,16
ffffffffc02002ca:	8082                	ret

ffffffffc02002cc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	1141                	addi	sp,sp,-16
ffffffffc02002ce:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002d0:	f97ff0ef          	jal	ffffffffc0200266 <print_stackframe>
    return 0;
}
ffffffffc02002d4:	60a2                	ld	ra,8(sp)
ffffffffc02002d6:	4501                	li	a0,0
ffffffffc02002d8:	0141                	addi	sp,sp,16
ffffffffc02002da:	8082                	ret

ffffffffc02002dc <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002dc:	7131                	addi	sp,sp,-192
ffffffffc02002de:	e952                	sd	s4,144(sp)
ffffffffc02002e0:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002e2:	00004517          	auipc	a0,0x4
ffffffffc02002e6:	d6650513          	addi	a0,a0,-666 # ffffffffc0204048 <etext+0x142>
kmonitor(struct trapframe *tf) {
ffffffffc02002ea:	fd06                	sd	ra,184(sp)
ffffffffc02002ec:	f922                	sd	s0,176(sp)
ffffffffc02002ee:	f526                	sd	s1,168(sp)
ffffffffc02002f0:	f14a                	sd	s2,160(sp)
ffffffffc02002f2:	e556                	sd	s5,136(sp)
ffffffffc02002f4:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f6:	e9fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002fa:	00004517          	auipc	a0,0x4
ffffffffc02002fe:	d7650513          	addi	a0,a0,-650 # ffffffffc0204070 <etext+0x16a>
ffffffffc0200302:	e93ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL) {
ffffffffc0200306:	000a0563          	beqz	s4,ffffffffc0200310 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020030a:	8552                	mv	a0,s4
ffffffffc020030c:	758000ef          	jal	ffffffffc0200a64 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200310:	4501                	li	a0,0
ffffffffc0200312:	4581                	li	a1,0
ffffffffc0200314:	4601                	li	a2,0
ffffffffc0200316:	48a1                	li	a7,8
ffffffffc0200318:	00000073          	ecall
ffffffffc020031c:	00005a97          	auipc	s5,0x5
ffffffffc0200320:	524a8a93          	addi	s5,s5,1316 # ffffffffc0205840 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200324:	493d                	li	s2,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200326:	00004517          	auipc	a0,0x4
ffffffffc020032a:	d7250513          	addi	a0,a0,-654 # ffffffffc0204098 <etext+0x192>
ffffffffc020032e:	d79ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200332:	842a                	mv	s0,a0
ffffffffc0200334:	d96d                	beqz	a0,ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200336:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020033a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033c:	e99d                	bnez	a1,ffffffffc0200372 <kmonitor+0x96>
    int argc = 0;
ffffffffc020033e:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc0200340:	fe0b03e3          	beqz	s6,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200344:	00005497          	auipc	s1,0x5
ffffffffc0200348:	4fc48493          	addi	s1,s1,1276 # ffffffffc0205840 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020034e:	6582                	ld	a1,0(sp)
ffffffffc0200350:	6088                	ld	a0,0(s1)
ffffffffc0200352:	2f9030ef          	jal	ffffffffc0203e4a <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200356:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200358:	c149                	beqz	a0,ffffffffc02003da <kmonitor+0xfe>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020035a:	2405                	addiw	s0,s0,1
ffffffffc020035c:	04e1                	addi	s1,s1,24
ffffffffc020035e:	fef418e3          	bne	s0,a5,ffffffffc020034e <kmonitor+0x72>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200362:	6582                	ld	a1,0(sp)
ffffffffc0200364:	00004517          	auipc	a0,0x4
ffffffffc0200368:	d6450513          	addi	a0,a0,-668 # ffffffffc02040c8 <etext+0x1c2>
ffffffffc020036c:	e29ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc0200370:	bf5d                	j	ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200372:	00004517          	auipc	a0,0x4
ffffffffc0200376:	d2e50513          	addi	a0,a0,-722 # ffffffffc02040a0 <etext+0x19a>
ffffffffc020037a:	32d030ef          	jal	ffffffffc0203ea6 <strchr>
ffffffffc020037e:	c901                	beqz	a0,ffffffffc020038e <kmonitor+0xb2>
ffffffffc0200380:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200384:	00040023          	sb	zero,0(s0)
ffffffffc0200388:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038a:	d9d5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc020038c:	b7dd                	j	ffffffffc0200372 <kmonitor+0x96>
        if (*buf == '\0') {
ffffffffc020038e:	00044783          	lbu	a5,0(s0)
ffffffffc0200392:	d7d5                	beqz	a5,ffffffffc020033e <kmonitor+0x62>
        if (argc == MAXARGS - 1) {
ffffffffc0200394:	03248b63          	beq	s1,s2,ffffffffc02003ca <kmonitor+0xee>
        argv[argc ++] = buf;
ffffffffc0200398:	00349793          	slli	a5,s1,0x3
ffffffffc020039c:	978a                	add	a5,a5,sp
ffffffffc020039e:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a0:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003a4:	2485                	addiw	s1,s1,1
ffffffffc02003a6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a8:	e591                	bnez	a1,ffffffffc02003b4 <kmonitor+0xd8>
ffffffffc02003aa:	bf59                	j	ffffffffc0200340 <kmonitor+0x64>
ffffffffc02003ac:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003b0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003b2:	d5d1                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003b4:	00004517          	auipc	a0,0x4
ffffffffc02003b8:	cec50513          	addi	a0,a0,-788 # ffffffffc02040a0 <etext+0x19a>
ffffffffc02003bc:	2eb030ef          	jal	ffffffffc0203ea6 <strchr>
ffffffffc02003c0:	d575                	beqz	a0,ffffffffc02003ac <kmonitor+0xd0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c2:	00044583          	lbu	a1,0(s0)
ffffffffc02003c6:	dda5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003c8:	b76d                	j	ffffffffc0200372 <kmonitor+0x96>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ca:	45c1                	li	a1,16
ffffffffc02003cc:	00004517          	auipc	a0,0x4
ffffffffc02003d0:	cdc50513          	addi	a0,a0,-804 # ffffffffc02040a8 <etext+0x1a2>
ffffffffc02003d4:	dc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02003d8:	b7c1                	j	ffffffffc0200398 <kmonitor+0xbc>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003da:	00141793          	slli	a5,s0,0x1
ffffffffc02003de:	97a2                	add	a5,a5,s0
ffffffffc02003e0:	078e                	slli	a5,a5,0x3
ffffffffc02003e2:	97d6                	add	a5,a5,s5
ffffffffc02003e4:	6b9c                	ld	a5,16(a5)
ffffffffc02003e6:	fffb051b          	addiw	a0,s6,-1
ffffffffc02003ea:	8652                	mv	a2,s4
ffffffffc02003ec:	002c                	addi	a1,sp,8
ffffffffc02003ee:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003f0:	f2055be3          	bgez	a0,ffffffffc0200326 <kmonitor+0x4a>
}
ffffffffc02003f4:	70ea                	ld	ra,184(sp)
ffffffffc02003f6:	744a                	ld	s0,176(sp)
ffffffffc02003f8:	74aa                	ld	s1,168(sp)
ffffffffc02003fa:	790a                	ld	s2,160(sp)
ffffffffc02003fc:	6a4a                	ld	s4,144(sp)
ffffffffc02003fe:	6aaa                	ld	s5,136(sp)
ffffffffc0200400:	6b0a                	ld	s6,128(sp)
ffffffffc0200402:	6129                	addi	sp,sp,192
ffffffffc0200404:	8082                	ret

ffffffffc0200406 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200406:	0000d317          	auipc	t1,0xd
ffffffffc020040a:	06232303          	lw	t1,98(t1) # ffffffffc020d468 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020040e:	715d                	addi	sp,sp,-80
ffffffffc0200410:	ec06                	sd	ra,24(sp)
ffffffffc0200412:	f436                	sd	a3,40(sp)
ffffffffc0200414:	f83a                	sd	a4,48(sp)
ffffffffc0200416:	fc3e                	sd	a5,56(sp)
ffffffffc0200418:	e0c2                	sd	a6,64(sp)
ffffffffc020041a:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020041c:	02031e63          	bnez	t1,ffffffffc0200458 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200420:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200422:	103c                	addi	a5,sp,40
ffffffffc0200424:	e822                	sd	s0,16(sp)
ffffffffc0200426:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200428:	862e                	mv	a2,a1
ffffffffc020042a:	85aa                	mv	a1,a0
ffffffffc020042c:	00004517          	auipc	a0,0x4
ffffffffc0200430:	d4450513          	addi	a0,a0,-700 # ffffffffc0204170 <etext+0x26a>
    is_panic = 1;
ffffffffc0200434:	0000d697          	auipc	a3,0xd
ffffffffc0200438:	02e6aa23          	sw	a4,52(a3) # ffffffffc020d468 <is_panic>
    va_start(ap, fmt);
ffffffffc020043c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020043e:	d57ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200442:	65a2                	ld	a1,8(sp)
ffffffffc0200444:	8522                	mv	a0,s0
ffffffffc0200446:	d2fff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020044a:	00004517          	auipc	a0,0x4
ffffffffc020044e:	d4650513          	addi	a0,a0,-698 # ffffffffc0204190 <etext+0x28a>
ffffffffc0200452:	d43ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200456:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200458:	41c000ef          	jal	ffffffffc0200874 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020045c:	4501                	li	a0,0
ffffffffc020045e:	e7fff0ef          	jal	ffffffffc02002dc <kmonitor>
    while (1) {
ffffffffc0200462:	bfed                	j	ffffffffc020045c <__panic+0x56>

ffffffffc0200464 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200464:	67e1                	lui	a5,0x18
ffffffffc0200466:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046a:	0000d717          	auipc	a4,0xd
ffffffffc020046e:	00f73323          	sd	a5,6(a4) # ffffffffc020d470 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200472:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200476:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200478:	953e                	add	a0,a0,a5
ffffffffc020047a:	4601                	li	a2,0
ffffffffc020047c:	4881                	li	a7,0
ffffffffc020047e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200482:	02000793          	li	a5,32
ffffffffc0200486:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020048a:	00004517          	auipc	a0,0x4
ffffffffc020048e:	d0e50513          	addi	a0,a0,-754 # ffffffffc0204198 <etext+0x292>
    ticks = 0;
ffffffffc0200492:	0000d797          	auipc	a5,0xd
ffffffffc0200496:	fe07b323          	sd	zero,-26(a5) # ffffffffc020d478 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020049a:	b9ed                	j	ffffffffc0200194 <cprintf>

ffffffffc020049c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020049c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004a0:	0000d797          	auipc	a5,0xd
ffffffffc02004a4:	fd07b783          	ld	a5,-48(a5) # ffffffffc020d470 <timebase>
ffffffffc02004a8:	4581                	li	a1,0
ffffffffc02004aa:	4601                	li	a2,0
ffffffffc02004ac:	953e                	add	a0,a0,a5
ffffffffc02004ae:	4881                	li	a7,0
ffffffffc02004b0:	00000073          	ecall
ffffffffc02004b4:	8082                	ret

ffffffffc02004b6 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004b8:	100027f3          	csrr	a5,sstatus
ffffffffc02004bc:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02004be:	0ff57513          	zext.b	a0,a0
ffffffffc02004c2:	e799                	bnez	a5,ffffffffc02004d0 <cons_putc+0x18>
ffffffffc02004c4:	4581                	li	a1,0
ffffffffc02004c6:	4601                	li	a2,0
ffffffffc02004c8:	4885                	li	a7,1
ffffffffc02004ca:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02004ce:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02004d0:	1101                	addi	sp,sp,-32
ffffffffc02004d2:	ec06                	sd	ra,24(sp)
ffffffffc02004d4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02004d6:	39e000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02004da:	6522                	ld	a0,8(sp)
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	4885                	li	a7,1
ffffffffc02004e2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004e6:	60e2                	ld	ra,24(sp)
ffffffffc02004e8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004ea:	a651                	j	ffffffffc020086e <intr_enable>

ffffffffc02004ec <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004ec:	100027f3          	csrr	a5,sstatus
ffffffffc02004f0:	8b89                	andi	a5,a5,2
ffffffffc02004f2:	eb89                	bnez	a5,ffffffffc0200504 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004f4:	4501                	li	a0,0
ffffffffc02004f6:	4581                	li	a1,0
ffffffffc02004f8:	4601                	li	a2,0
ffffffffc02004fa:	4889                	li	a7,2
ffffffffc02004fc:	00000073          	ecall
ffffffffc0200500:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200502:	8082                	ret
int cons_getc(void) {
ffffffffc0200504:	1101                	addi	sp,sp,-32
ffffffffc0200506:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200508:	36c000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020050c:	4501                	li	a0,0
ffffffffc020050e:	4581                	li	a1,0
ffffffffc0200510:	4601                	li	a2,0
ffffffffc0200512:	4889                	li	a7,2
ffffffffc0200514:	00000073          	ecall
ffffffffc0200518:	2501                	sext.w	a0,a0
ffffffffc020051a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020051c:	352000ef          	jal	ffffffffc020086e <intr_enable>
}
ffffffffc0200520:	60e2                	ld	ra,24(sp)
ffffffffc0200522:	6522                	ld	a0,8(sp)
ffffffffc0200524:	6105                	addi	sp,sp,32
ffffffffc0200526:	8082                	ret

ffffffffc0200528 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200528:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020052a:	00004517          	auipc	a0,0x4
ffffffffc020052e:	c8e50513          	addi	a0,a0,-882 # ffffffffc02041b8 <etext+0x2b2>
void dtb_init(void) {
ffffffffc0200532:	f406                	sd	ra,40(sp)
ffffffffc0200534:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200536:	c5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020053a:	00009597          	auipc	a1,0x9
ffffffffc020053e:	ac65b583          	ld	a1,-1338(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc0200542:	00004517          	auipc	a0,0x4
ffffffffc0200546:	c8650513          	addi	a0,a0,-890 # ffffffffc02041c8 <etext+0x2c2>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020054a:	00009417          	auipc	s0,0x9
ffffffffc020054e:	abe40413          	addi	s0,s0,-1346 # ffffffffc0209008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200552:	c43ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200556:	600c                	ld	a1,0(s0)
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	c8050513          	addi	a0,a0,-896 # ffffffffc02041d8 <etext+0x2d2>
ffffffffc0200560:	c35ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200564:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200566:	00004517          	auipc	a0,0x4
ffffffffc020056a:	c8a50513          	addi	a0,a0,-886 # ffffffffc02041f0 <etext+0x2ea>
    if (boot_dtb == 0) {
ffffffffc020056e:	10070163          	beqz	a4,ffffffffc0200670 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200572:	57f5                	li	a5,-3
ffffffffc0200574:	07fa                	slli	a5,a5,0x1e
ffffffffc0200576:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200578:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020057a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020057e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed29fd>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200582:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200586:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020058a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200592:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200596:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200598:	8e49                	or	a2,a2,a0
ffffffffc020059a:	0ff7f793          	zext.b	a5,a5
ffffffffc020059e:	8dd1                	or	a1,a1,a2
ffffffffc02005a0:	07a2                	slli	a5,a5,0x8
ffffffffc02005a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02005a8:	0cd59863          	bne	a1,a3,ffffffffc0200678 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005ac:	4710                	lw	a2,8(a4)
ffffffffc02005ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02005b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02005be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02005c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02005ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02005da:	01c56533          	or	a0,a0,t3
ffffffffc02005de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02005f2:	8c49                	or	s0,s0,a0
ffffffffc02005f4:	0622                	slli	a2,a2,0x8
ffffffffc02005f6:	8fcd                	or	a5,a5,a1
ffffffffc02005f8:	06a2                	slli	a3,a3,0x8
ffffffffc02005fa:	8c51                	or	s0,s0,a2
ffffffffc02005fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200600:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200602:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200604:	9381                	srli	a5,a5,0x20
ffffffffc0200606:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200608:	4301                	li	t1,0
        switch (token) {
ffffffffc020060a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020060c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020060e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200612:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200614:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200616:	0087579b          	srliw	a5,a4,0x8
ffffffffc020061a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200622:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200626:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020062e:	8ed1                	or	a3,a3,a2
ffffffffc0200630:	0ff77713          	zext.b	a4,a4
ffffffffc0200634:	8fd5                	or	a5,a5,a3
ffffffffc0200636:	0722                	slli	a4,a4,0x8
ffffffffc0200638:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020063a:	05178763          	beq	a5,a7,ffffffffc0200688 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020063e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200640:	00f8e963          	bltu	a7,a5,ffffffffc0200652 <dtb_init+0x12a>
ffffffffc0200644:	07c78d63          	beq	a5,t3,ffffffffc02006be <dtb_init+0x196>
ffffffffc0200648:	4709                	li	a4,2
ffffffffc020064a:	00e79763          	bne	a5,a4,ffffffffc0200658 <dtb_init+0x130>
ffffffffc020064e:	4301                	li	t1,0
ffffffffc0200650:	b7d1                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc0200652:	4711                	li	a4,4
ffffffffc0200654:	fce780e3          	beq	a5,a4,ffffffffc0200614 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200658:	00004517          	auipc	a0,0x4
ffffffffc020065c:	c6050513          	addi	a0,a0,-928 # ffffffffc02042b8 <etext+0x3b2>
ffffffffc0200660:	b35ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200664:	64e2                	ld	s1,24(sp)
ffffffffc0200666:	6942                	ld	s2,16(sp)
ffffffffc0200668:	00004517          	auipc	a0,0x4
ffffffffc020066c:	c8850513          	addi	a0,a0,-888 # ffffffffc02042f0 <etext+0x3ea>
}
ffffffffc0200670:	7402                	ld	s0,32(sp)
ffffffffc0200672:	70a2                	ld	ra,40(sp)
ffffffffc0200674:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200676:	be39                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200678:	7402                	ld	s0,32(sp)
ffffffffc020067a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020067c:	00004517          	auipc	a0,0x4
ffffffffc0200680:	b9450513          	addi	a0,a0,-1132 # ffffffffc0204210 <etext+0x30a>
}
ffffffffc0200684:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200686:	b639                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200688:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020068e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200696:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a2:	8ed1                	or	a3,a3,a2
ffffffffc02006a4:	0ff77713          	zext.b	a4,a4
ffffffffc02006a8:	8fd5                	or	a5,a5,a3
ffffffffc02006aa:	0722                	slli	a4,a4,0x8
ffffffffc02006ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006ae:	04031463          	bnez	t1,ffffffffc02006f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006b2:	1782                	slli	a5,a5,0x20
ffffffffc02006b4:	9381                	srli	a5,a5,0x20
ffffffffc02006b6:	043d                	addi	s0,s0,15
ffffffffc02006b8:	943e                	add	s0,s0,a5
ffffffffc02006ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02006bc:	bfa1                	j	ffffffffc0200614 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02006be:	8522                	mv	a0,s0
ffffffffc02006c0:	e01a                	sd	t1,0(sp)
ffffffffc02006c2:	742030ef          	jal	ffffffffc0203e04 <strlen>
ffffffffc02006c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006c8:	4619                	li	a2,6
ffffffffc02006ca:	8522                	mv	a0,s0
ffffffffc02006cc:	00004597          	auipc	a1,0x4
ffffffffc02006d0:	b6c58593          	addi	a1,a1,-1172 # ffffffffc0204238 <etext+0x332>
ffffffffc02006d4:	7aa030ef          	jal	ffffffffc0203e7e <strncmp>
ffffffffc02006d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006da:	0411                	addi	s0,s0,4
ffffffffc02006dc:	0004879b          	sext.w	a5,s1
ffffffffc02006e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02006ec:	00ff0837          	lui	a6,0xff0
ffffffffc02006f0:	488d                	li	a7,3
ffffffffc02006f2:	4e05                	li	t3,1
ffffffffc02006f4:	b705                	j	ffffffffc0200614 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f8:	00004597          	auipc	a1,0x4
ffffffffc02006fc:	b4858593          	addi	a1,a1,-1208 # ffffffffc0204240 <etext+0x33a>
ffffffffc0200700:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200706:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020070a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020070e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200712:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200716:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071a:	8ed1                	or	a3,a3,a2
ffffffffc020071c:	0ff77713          	zext.b	a4,a4
ffffffffc0200720:	0722                	slli	a4,a4,0x8
ffffffffc0200722:	8d55                	or	a0,a0,a3
ffffffffc0200724:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200726:	1502                	slli	a0,a0,0x20
ffffffffc0200728:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020072a:	954a                	add	a0,a0,s2
ffffffffc020072c:	e01a                	sd	t1,0(sp)
ffffffffc020072e:	71c030ef          	jal	ffffffffc0203e4a <strcmp>
ffffffffc0200732:	67a2                	ld	a5,8(sp)
ffffffffc0200734:	473d                	li	a4,15
ffffffffc0200736:	6302                	ld	t1,0(sp)
ffffffffc0200738:	00ff0837          	lui	a6,0xff0
ffffffffc020073c:	488d                	li	a7,3
ffffffffc020073e:	4e05                	li	t3,1
ffffffffc0200740:	f6f779e3          	bgeu	a4,a5,ffffffffc02006b2 <dtb_init+0x18a>
ffffffffc0200744:	f53d                	bnez	a0,ffffffffc02006b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200746:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020074a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020074e:	00004517          	auipc	a0,0x4
ffffffffc0200752:	afa50513          	addi	a0,a0,-1286 # ffffffffc0204248 <etext+0x342>
           fdt32_to_cpu(x >> 32);
ffffffffc0200756:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020075e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200762:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200766:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020076a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020076e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200772:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200776:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020077a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077e:	01037333          	and	t1,t1,a6
ffffffffc0200782:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200786:	01e5e5b3          	or	a1,a1,t5
ffffffffc020078a:	0ff7f793          	zext.b	a5,a5
ffffffffc020078e:	01de6e33          	or	t3,t3,t4
ffffffffc0200792:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200796:	01067633          	and	a2,a2,a6
ffffffffc020079a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020079e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	07a2                	slli	a5,a5,0x8
ffffffffc02007a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02007a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02007ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02007b0:	8ddd                	or	a1,a1,a5
ffffffffc02007b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02007ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d6:	08a2                	slli	a7,a7,0x8
ffffffffc02007d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02007e4:	01de6833          	or	a6,t3,t4
ffffffffc02007e8:	0ff77713          	zext.b	a4,a4
ffffffffc02007ec:	01166633          	or	a2,a2,a7
ffffffffc02007f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02007f4:	06a2                	slli	a3,a3,0x8
ffffffffc02007f6:	01046433          	or	s0,s0,a6
ffffffffc02007fa:	0722                	slli	a4,a4,0x8
ffffffffc02007fc:	8fd5                	or	a5,a5,a3
ffffffffc02007fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200800:	1582                	slli	a1,a1,0x20
ffffffffc0200802:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200804:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200806:	9201                	srli	a2,a2,0x20
ffffffffc0200808:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020080a:	1402                	slli	s0,s0,0x20
ffffffffc020080c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200810:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200812:	983ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200816:	85a6                	mv	a1,s1
ffffffffc0200818:	00004517          	auipc	a0,0x4
ffffffffc020081c:	a5050513          	addi	a0,a0,-1456 # ffffffffc0204268 <etext+0x362>
ffffffffc0200820:	975ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200824:	01445613          	srli	a2,s0,0x14
ffffffffc0200828:	85a2                	mv	a1,s0
ffffffffc020082a:	00004517          	auipc	a0,0x4
ffffffffc020082e:	a5650513          	addi	a0,a0,-1450 # ffffffffc0204280 <etext+0x37a>
ffffffffc0200832:	963ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200836:	009405b3          	add	a1,s0,s1
ffffffffc020083a:	15fd                	addi	a1,a1,-1
ffffffffc020083c:	00004517          	auipc	a0,0x4
ffffffffc0200840:	a6450513          	addi	a0,a0,-1436 # ffffffffc02042a0 <etext+0x39a>
ffffffffc0200844:	951ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc0200848:	0000d797          	auipc	a5,0xd
ffffffffc020084c:	c497b023          	sd	s1,-960(a5) # ffffffffc020d488 <memory_base>
        memory_size = mem_size;
ffffffffc0200850:	0000d797          	auipc	a5,0xd
ffffffffc0200854:	c287b823          	sd	s0,-976(a5) # ffffffffc020d480 <memory_size>
ffffffffc0200858:	b531                	j	ffffffffc0200664 <dtb_init+0x13c>

ffffffffc020085a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020085a:	0000d517          	auipc	a0,0xd
ffffffffc020085e:	c2e53503          	ld	a0,-978(a0) # ffffffffc020d488 <memory_base>
ffffffffc0200862:	8082                	ret

ffffffffc0200864 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200864:	0000d517          	auipc	a0,0xd
ffffffffc0200868:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d480 <memory_size>
ffffffffc020086c:	8082                	ret

ffffffffc020086e <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020086e:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200872:	8082                	ret

ffffffffc0200874 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200874:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200878:	8082                	ret

ffffffffc020087a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020087a:	8082                	ret

ffffffffc020087c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020087c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200880:	00000797          	auipc	a5,0x0
ffffffffc0200884:	48878793          	addi	a5,a5,1160 # ffffffffc0200d08 <__alltraps>
ffffffffc0200888:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020088c:	000407b7          	lui	a5,0x40
ffffffffc0200890:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200894:	8082                	ret

ffffffffc0200896 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200896:	610c                	ld	a1,0(a0)
{
ffffffffc0200898:	1141                	addi	sp,sp,-16
ffffffffc020089a:	e022                	sd	s0,0(sp)
ffffffffc020089c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020089e:	00004517          	auipc	a0,0x4
ffffffffc02008a2:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0204308 <etext+0x402>
{
ffffffffc02008a6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008a8:	8edff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02008ac:	640c                	ld	a1,8(s0)
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	a7250513          	addi	a0,a0,-1422 # ffffffffc0204320 <etext+0x41a>
ffffffffc02008b6:	8dfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02008ba:	680c                	ld	a1,16(s0)
ffffffffc02008bc:	00004517          	auipc	a0,0x4
ffffffffc02008c0:	a7c50513          	addi	a0,a0,-1412 # ffffffffc0204338 <etext+0x432>
ffffffffc02008c4:	8d1ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02008c8:	6c0c                	ld	a1,24(s0)
ffffffffc02008ca:	00004517          	auipc	a0,0x4
ffffffffc02008ce:	a8650513          	addi	a0,a0,-1402 # ffffffffc0204350 <etext+0x44a>
ffffffffc02008d2:	8c3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02008d6:	700c                	ld	a1,32(s0)
ffffffffc02008d8:	00004517          	auipc	a0,0x4
ffffffffc02008dc:	a9050513          	addi	a0,a0,-1392 # ffffffffc0204368 <etext+0x462>
ffffffffc02008e0:	8b5ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02008e4:	740c                	ld	a1,40(s0)
ffffffffc02008e6:	00004517          	auipc	a0,0x4
ffffffffc02008ea:	a9a50513          	addi	a0,a0,-1382 # ffffffffc0204380 <etext+0x47a>
ffffffffc02008ee:	8a7ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02008f2:	780c                	ld	a1,48(s0)
ffffffffc02008f4:	00004517          	auipc	a0,0x4
ffffffffc02008f8:	aa450513          	addi	a0,a0,-1372 # ffffffffc0204398 <etext+0x492>
ffffffffc02008fc:	899ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200900:	7c0c                	ld	a1,56(s0)
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	aae50513          	addi	a0,a0,-1362 # ffffffffc02043b0 <etext+0x4aa>
ffffffffc020090a:	88bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020090e:	602c                	ld	a1,64(s0)
ffffffffc0200910:	00004517          	auipc	a0,0x4
ffffffffc0200914:	ab850513          	addi	a0,a0,-1352 # ffffffffc02043c8 <etext+0x4c2>
ffffffffc0200918:	87dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020091c:	642c                	ld	a1,72(s0)
ffffffffc020091e:	00004517          	auipc	a0,0x4
ffffffffc0200922:	ac250513          	addi	a0,a0,-1342 # ffffffffc02043e0 <etext+0x4da>
ffffffffc0200926:	86fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020092a:	682c                	ld	a1,80(s0)
ffffffffc020092c:	00004517          	auipc	a0,0x4
ffffffffc0200930:	acc50513          	addi	a0,a0,-1332 # ffffffffc02043f8 <etext+0x4f2>
ffffffffc0200934:	861ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200938:	6c2c                	ld	a1,88(s0)
ffffffffc020093a:	00004517          	auipc	a0,0x4
ffffffffc020093e:	ad650513          	addi	a0,a0,-1322 # ffffffffc0204410 <etext+0x50a>
ffffffffc0200942:	853ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200946:	702c                	ld	a1,96(s0)
ffffffffc0200948:	00004517          	auipc	a0,0x4
ffffffffc020094c:	ae050513          	addi	a0,a0,-1312 # ffffffffc0204428 <etext+0x522>
ffffffffc0200950:	845ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200954:	742c                	ld	a1,104(s0)
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	aea50513          	addi	a0,a0,-1302 # ffffffffc0204440 <etext+0x53a>
ffffffffc020095e:	837ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200962:	782c                	ld	a1,112(s0)
ffffffffc0200964:	00004517          	auipc	a0,0x4
ffffffffc0200968:	af450513          	addi	a0,a0,-1292 # ffffffffc0204458 <etext+0x552>
ffffffffc020096c:	829ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200970:	7c2c                	ld	a1,120(s0)
ffffffffc0200972:	00004517          	auipc	a0,0x4
ffffffffc0200976:	afe50513          	addi	a0,a0,-1282 # ffffffffc0204470 <etext+0x56a>
ffffffffc020097a:	81bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020097e:	604c                	ld	a1,128(s0)
ffffffffc0200980:	00004517          	auipc	a0,0x4
ffffffffc0200984:	b0850513          	addi	a0,a0,-1272 # ffffffffc0204488 <etext+0x582>
ffffffffc0200988:	80dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020098c:	644c                	ld	a1,136(s0)
ffffffffc020098e:	00004517          	auipc	a0,0x4
ffffffffc0200992:	b1250513          	addi	a0,a0,-1262 # ffffffffc02044a0 <etext+0x59a>
ffffffffc0200996:	ffeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020099a:	684c                	ld	a1,144(s0)
ffffffffc020099c:	00004517          	auipc	a0,0x4
ffffffffc02009a0:	b1c50513          	addi	a0,a0,-1252 # ffffffffc02044b8 <etext+0x5b2>
ffffffffc02009a4:	ff0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02009a8:	6c4c                	ld	a1,152(s0)
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	b2650513          	addi	a0,a0,-1242 # ffffffffc02044d0 <etext+0x5ca>
ffffffffc02009b2:	fe2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02009b6:	704c                	ld	a1,160(s0)
ffffffffc02009b8:	00004517          	auipc	a0,0x4
ffffffffc02009bc:	b3050513          	addi	a0,a0,-1232 # ffffffffc02044e8 <etext+0x5e2>
ffffffffc02009c0:	fd4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02009c4:	744c                	ld	a1,168(s0)
ffffffffc02009c6:	00004517          	auipc	a0,0x4
ffffffffc02009ca:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0204500 <etext+0x5fa>
ffffffffc02009ce:	fc6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02009d2:	784c                	ld	a1,176(s0)
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	b4450513          	addi	a0,a0,-1212 # ffffffffc0204518 <etext+0x612>
ffffffffc02009dc:	fb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02009e0:	7c4c                	ld	a1,184(s0)
ffffffffc02009e2:	00004517          	auipc	a0,0x4
ffffffffc02009e6:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0204530 <etext+0x62a>
ffffffffc02009ea:	faaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009ee:	606c                	ld	a1,192(s0)
ffffffffc02009f0:	00004517          	auipc	a0,0x4
ffffffffc02009f4:	b5850513          	addi	a0,a0,-1192 # ffffffffc0204548 <etext+0x642>
ffffffffc02009f8:	f9cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02009fc:	646c                	ld	a1,200(s0)
ffffffffc02009fe:	00004517          	auipc	a0,0x4
ffffffffc0200a02:	b6250513          	addi	a0,a0,-1182 # ffffffffc0204560 <etext+0x65a>
ffffffffc0200a06:	f8eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a0a:	686c                	ld	a1,208(s0)
ffffffffc0200a0c:	00004517          	auipc	a0,0x4
ffffffffc0200a10:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0204578 <etext+0x672>
ffffffffc0200a14:	f80ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200a18:	6c6c                	ld	a1,216(s0)
ffffffffc0200a1a:	00004517          	auipc	a0,0x4
ffffffffc0200a1e:	b7650513          	addi	a0,a0,-1162 # ffffffffc0204590 <etext+0x68a>
ffffffffc0200a22:	f72ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200a26:	706c                	ld	a1,224(s0)
ffffffffc0200a28:	00004517          	auipc	a0,0x4
ffffffffc0200a2c:	b8050513          	addi	a0,a0,-1152 # ffffffffc02045a8 <etext+0x6a2>
ffffffffc0200a30:	f64ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200a34:	746c                	ld	a1,232(s0)
ffffffffc0200a36:	00004517          	auipc	a0,0x4
ffffffffc0200a3a:	b8a50513          	addi	a0,a0,-1142 # ffffffffc02045c0 <etext+0x6ba>
ffffffffc0200a3e:	f56ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200a42:	786c                	ld	a1,240(s0)
ffffffffc0200a44:	00004517          	auipc	a0,0x4
ffffffffc0200a48:	b9450513          	addi	a0,a0,-1132 # ffffffffc02045d8 <etext+0x6d2>
ffffffffc0200a4c:	f48ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a50:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a52:	6402                	ld	s0,0(sp)
ffffffffc0200a54:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a56:	00004517          	auipc	a0,0x4
ffffffffc0200a5a:	b9a50513          	addi	a0,a0,-1126 # ffffffffc02045f0 <etext+0x6ea>
}
ffffffffc0200a5e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a60:	f34ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200a64 <print_trapframe>:
{
ffffffffc0200a64:	1141                	addi	sp,sp,-16
ffffffffc0200a66:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a68:	85aa                	mv	a1,a0
{
ffffffffc0200a6a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a6c:	00004517          	auipc	a0,0x4
ffffffffc0200a70:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204608 <etext+0x702>
{
ffffffffc0200a74:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a76:	f1eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a7a:	8522                	mv	a0,s0
ffffffffc0200a7c:	e1bff0ef          	jal	ffffffffc0200896 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a80:	10043583          	ld	a1,256(s0)
ffffffffc0200a84:	00004517          	auipc	a0,0x4
ffffffffc0200a88:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204620 <etext+0x71a>
ffffffffc0200a8c:	f08ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a90:	10843583          	ld	a1,264(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	ba450513          	addi	a0,a0,-1116 # ffffffffc0204638 <etext+0x732>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200aa0:	11043583          	ld	a1,272(s0)
ffffffffc0200aa4:	00004517          	auipc	a0,0x4
ffffffffc0200aa8:	bac50513          	addi	a0,a0,-1108 # ffffffffc0204650 <etext+0x74a>
ffffffffc0200aac:	ee8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ab0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200ab4:	6402                	ld	s0,0(sp)
ffffffffc0200ab6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ab8:	00004517          	auipc	a0,0x4
ffffffffc0200abc:	bb050513          	addi	a0,a0,-1104 # ffffffffc0204668 <etext+0x762>
}
ffffffffc0200ac0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ac2:	ed2ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ac6 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200ac6:	11853783          	ld	a5,280(a0)
ffffffffc0200aca:	472d                	li	a4,11
ffffffffc0200acc:	0786                	slli	a5,a5,0x1
ffffffffc0200ace:	8385                	srli	a5,a5,0x1
ffffffffc0200ad0:	0af76a63          	bltu	a4,a5,ffffffffc0200b84 <interrupt_handler+0xbe>
ffffffffc0200ad4:	00005717          	auipc	a4,0x5
ffffffffc0200ad8:	db470713          	addi	a4,a4,-588 # ffffffffc0205888 <commands+0x48>
ffffffffc0200adc:	078a                	slli	a5,a5,0x2
ffffffffc0200ade:	97ba                	add	a5,a5,a4
ffffffffc0200ae0:	439c                	lw	a5,0(a5)
ffffffffc0200ae2:	97ba                	add	a5,a5,a4
ffffffffc0200ae4:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ae6:	00004517          	auipc	a0,0x4
ffffffffc0200aea:	bfa50513          	addi	a0,a0,-1030 # ffffffffc02046e0 <etext+0x7da>
ffffffffc0200aee:	ea6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	bce50513          	addi	a0,a0,-1074 # ffffffffc02046c0 <etext+0x7ba>
ffffffffc0200afa:	e9aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200afe:	00004517          	auipc	a0,0x4
ffffffffc0200b02:	b8250513          	addi	a0,a0,-1150 # ffffffffc0204680 <etext+0x77a>
ffffffffc0200b06:	e8eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b0a:	00004517          	auipc	a0,0x4
ffffffffc0200b0e:	b9650513          	addi	a0,a0,-1130 # ffffffffc02046a0 <etext+0x79a>
ffffffffc0200b12:	e82ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200b16:	1141                	addi	sp,sp,-16
ffffffffc0200b18:	e406                	sd	ra,8(sp)
            *(2)计数器（ticks）加一
            *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
        * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
        */
        // 1) 预约下次时钟中断
        clock_set_next_event();
ffffffffc0200b1a:	983ff0ef          	jal	ffffffffc020049c <clock_set_next_event>

        // 2) 递增全局时钟计数
        ticks++;
ffffffffc0200b1e:	0000d797          	auipc	a5,0xd
ffffffffc0200b22:	95a78793          	addi	a5,a5,-1702 # ffffffffc020d478 <ticks>
ffffffffc0200b26:	6394                	ld	a3,0(a5)

        // 3) 每到 100 次打印一次
        if (ticks % TICK_NUM == 0) {
ffffffffc0200b28:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200b2c:	28f70713          	addi	a4,a4,655 # 28f5c28f <kern_entry-0xffffffff972a3d71>
        ticks++;
ffffffffc0200b30:	0685                	addi	a3,a3,1
ffffffffc0200b32:	e394                	sd	a3,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200b34:	6390                	ld	a2,0(a5)
ffffffffc0200b36:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200b3a:	1702                	slli	a4,a4,0x20
ffffffffc0200b3c:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <kern_entry-0xffffffff63f70a3d>
ffffffffc0200b40:	00265793          	srli	a5,a2,0x2
ffffffffc0200b44:	9736                	add	a4,a4,a3
ffffffffc0200b46:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200b4a:	06400593          	li	a1,100
ffffffffc0200b4e:	8389                	srli	a5,a5,0x2
ffffffffc0200b50:	02b787b3          	mul	a5,a5,a1
ffffffffc0200b54:	02f60963          	beq	a2,a5,ffffffffc0200b86 <interrupt_handler+0xc0>
            print_ticks(); // 输出 "100 ticks"（由 print_ticks() 完成）
            num++;         // 记录打印了几次“100 ticks”
        }

        // 4) 打印到第 10 次时关机
        if (num == 10) {
ffffffffc0200b58:	0000d797          	auipc	a5,0xd
ffffffffc0200b5c:	9387b783          	ld	a5,-1736(a5) # ffffffffc020d490 <num>
ffffffffc0200b60:	4729                	li	a4,10
ffffffffc0200b62:	00e79863          	bne	a5,a4,ffffffffc0200b72 <interrupt_handler+0xac>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200b66:	4501                	li	a0,0
ffffffffc0200b68:	4581                	li	a1,0
ffffffffc0200b6a:	4601                	li	a2,0
ffffffffc0200b6c:	48a1                	li	a7,8
ffffffffc0200b6e:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
ffffffffc0200b74:	0141                	addi	sp,sp,16
ffffffffc0200b76:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200b78:	00004517          	auipc	a0,0x4
ffffffffc0200b7c:	b9850513          	addi	a0,a0,-1128 # ffffffffc0204710 <etext+0x80a>
ffffffffc0200b80:	e14ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200b84:	b5c5                	j	ffffffffc0200a64 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b86:	00004517          	auipc	a0,0x4
ffffffffc0200b8a:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0204700 <etext+0x7fa>
ffffffffc0200b8e:	e06ff0ef          	jal	ffffffffc0200194 <cprintf>
            num++;         // 记录打印了几次“100 ticks”
ffffffffc0200b92:	0000d797          	auipc	a5,0xd
ffffffffc0200b96:	8fe7b783          	ld	a5,-1794(a5) # ffffffffc020d490 <num>
ffffffffc0200b9a:	0785                	addi	a5,a5,1
ffffffffc0200b9c:	0000d717          	auipc	a4,0xd
ffffffffc0200ba0:	8ef73a23          	sd	a5,-1804(a4) # ffffffffc020d490 <num>
ffffffffc0200ba4:	bf75                	j	ffffffffc0200b60 <interrupt_handler+0x9a>

ffffffffc0200ba6 <exception_handler>:

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200ba6:	11853783          	ld	a5,280(a0)
ffffffffc0200baa:	473d                	li	a4,15
ffffffffc0200bac:	14f76663          	bltu	a4,a5,ffffffffc0200cf8 <exception_handler+0x152>
ffffffffc0200bb0:	00005717          	auipc	a4,0x5
ffffffffc0200bb4:	d0870713          	addi	a4,a4,-760 # ffffffffc02058b8 <commands+0x78>
ffffffffc0200bb8:	078a                	slli	a5,a5,0x2
ffffffffc0200bba:	97ba                	add	a5,a5,a4
ffffffffc0200bbc:	439c                	lw	a5,0(a5)
{
ffffffffc0200bbe:	1101                	addi	sp,sp,-32
ffffffffc0200bc0:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200bc2:	97ba                	add	a5,a5,a4
ffffffffc0200bc4:	8782                	jr	a5
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bc6:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200bc8:	00004517          	auipc	a0,0x4
ffffffffc0200bcc:	d5050513          	addi	a0,a0,-688 # ffffffffc0204918 <etext+0xa12>
}
ffffffffc0200bd0:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200bd2:	dc2ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200bd6:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200bd8:	00004517          	auipc	a0,0x4
ffffffffc0200bdc:	b5850513          	addi	a0,a0,-1192 # ffffffffc0204730 <etext+0x82a>
}
ffffffffc0200be0:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200be2:	db2ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200be6:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200be8:	00004517          	auipc	a0,0x4
ffffffffc0200bec:	b6850513          	addi	a0,a0,-1176 # ffffffffc0204750 <etext+0x84a>
}
ffffffffc0200bf0:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200bf2:	da2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Illegal instruction caught at 0x%016lx\n", (unsigned long)tf->epc);
ffffffffc0200bf6:	10853583          	ld	a1,264(a0)
ffffffffc0200bfa:	e42a                	sd	a0,8(sp)
ffffffffc0200bfc:	00004517          	auipc	a0,0x4
ffffffffc0200c00:	b7450513          	addi	a0,a0,-1164 # ffffffffc0204770 <etext+0x86a>
ffffffffc0200c04:	d90ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Exception type: Illegal instruction\n");
ffffffffc0200c08:	00004517          	auipc	a0,0x4
ffffffffc0200c0c:	b9050513          	addi	a0,a0,-1136 # ffffffffc0204798 <etext+0x892>
ffffffffc0200c10:	d84ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;  // 跳过非法指令（RISC-V 32-bit 指令）
ffffffffc0200c14:	66a2                	ld	a3,8(sp)
ffffffffc0200c16:	1086b783          	ld	a5,264(a3)
ffffffffc0200c1a:	0791                	addi	a5,a5,4
ffffffffc0200c1c:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200c20:	60e2                	ld	ra,24(sp)
ffffffffc0200c22:	6105                	addi	sp,sp,32
ffffffffc0200c24:	8082                	ret
        cprintf("ebreak caught at 0x%016lx\n", (unsigned long)tf->epc);
ffffffffc0200c26:	10853583          	ld	a1,264(a0)
ffffffffc0200c2a:	e42a                	sd	a0,8(sp)
ffffffffc0200c2c:	00004517          	auipc	a0,0x4
ffffffffc0200c30:	b9450513          	addi	a0,a0,-1132 # ffffffffc02047c0 <etext+0x8ba>
ffffffffc0200c34:	d60ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Exception type: breakpoint\n");
ffffffffc0200c38:	00004517          	auipc	a0,0x4
ffffffffc0200c3c:	ba850513          	addi	a0,a0,-1112 # ffffffffc02047e0 <etext+0x8da>
ffffffffc0200c40:	d54ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 2;  // 跳过 ebreak 指令
ffffffffc0200c44:	66a2                	ld	a3,8(sp)
ffffffffc0200c46:	1086b783          	ld	a5,264(a3)
ffffffffc0200c4a:	0789                	addi	a5,a5,2
ffffffffc0200c4c:	10f6b423          	sd	a5,264(a3)
        break;
ffffffffc0200c50:	bfc1                	j	ffffffffc0200c20 <exception_handler+0x7a>
}
ffffffffc0200c52:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200c54:	00004517          	auipc	a0,0x4
ffffffffc0200c58:	bac50513          	addi	a0,a0,-1108 # ffffffffc0204800 <etext+0x8fa>
}
ffffffffc0200c5c:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200c5e:	d36ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200c62:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200c64:	00004517          	auipc	a0,0x4
ffffffffc0200c68:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0204820 <etext+0x91a>
}
ffffffffc0200c6c:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200c6e:	d26ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200c72:	60e2                	ld	ra,24(sp)
        cprintf("AMO address misaligned\n");
ffffffffc0200c74:	00004517          	auipc	a0,0x4
ffffffffc0200c78:	bc450513          	addi	a0,a0,-1084 # ffffffffc0204838 <etext+0x932>
}
ffffffffc0200c7c:	6105                	addi	sp,sp,32
        cprintf("AMO address misaligned\n");
ffffffffc0200c7e:	d16ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200c82:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200c84:	00004517          	auipc	a0,0x4
ffffffffc0200c88:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0204850 <etext+0x94a>
}
ffffffffc0200c8c:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200c8e:	d06ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200c92:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from U-mode\n");
ffffffffc0200c94:	00004517          	auipc	a0,0x4
ffffffffc0200c98:	bd450513          	addi	a0,a0,-1068 # ffffffffc0204868 <etext+0x962>
}
ffffffffc0200c9c:	6105                	addi	sp,sp,32
        cprintf("Environment call from U-mode\n");
ffffffffc0200c9e:	cf6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200ca2:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from S-mode\n");
ffffffffc0200ca4:	00004517          	auipc	a0,0x4
ffffffffc0200ca8:	be450513          	addi	a0,a0,-1052 # ffffffffc0204888 <etext+0x982>
}
ffffffffc0200cac:	6105                	addi	sp,sp,32
        cprintf("Environment call from S-mode\n");
ffffffffc0200cae:	ce6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cb2:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200cb4:	00004517          	auipc	a0,0x4
ffffffffc0200cb8:	bf450513          	addi	a0,a0,-1036 # ffffffffc02048a8 <etext+0x9a2>
}
ffffffffc0200cbc:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200cbe:	cd6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cc2:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200cc4:	00004517          	auipc	a0,0x4
ffffffffc0200cc8:	c0450513          	addi	a0,a0,-1020 # ffffffffc02048c8 <etext+0x9c2>
}
ffffffffc0200ccc:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200cce:	cc6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cd2:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200cd4:	00004517          	auipc	a0,0x4
ffffffffc0200cd8:	c1450513          	addi	a0,a0,-1004 # ffffffffc02048e8 <etext+0x9e2>
}
ffffffffc0200cdc:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200cde:	cb6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200ce2:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200ce4:	00004517          	auipc	a0,0x4
ffffffffc0200ce8:	c1c50513          	addi	a0,a0,-996 # ffffffffc0204900 <etext+0x9fa>
}
ffffffffc0200cec:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200cee:	ca6ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cf2:	60e2                	ld	ra,24(sp)
ffffffffc0200cf4:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200cf6:	b3bd                	j	ffffffffc0200a64 <print_trapframe>
ffffffffc0200cf8:	b3b5                	j	ffffffffc0200a64 <print_trapframe>

ffffffffc0200cfa <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200cfa:	11853783          	ld	a5,280(a0)
ffffffffc0200cfe:	0007c363          	bltz	a5,ffffffffc0200d04 <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d02:	b555                	j	ffffffffc0200ba6 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d04:	b3c9                	j	ffffffffc0200ac6 <interrupt_handler>
	...

ffffffffc0200d08 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d08:	14011073          	csrw	sscratch,sp
ffffffffc0200d0c:	712d                	addi	sp,sp,-288
ffffffffc0200d0e:	e406                	sd	ra,8(sp)
ffffffffc0200d10:	ec0e                	sd	gp,24(sp)
ffffffffc0200d12:	f012                	sd	tp,32(sp)
ffffffffc0200d14:	f416                	sd	t0,40(sp)
ffffffffc0200d16:	f81a                	sd	t1,48(sp)
ffffffffc0200d18:	fc1e                	sd	t2,56(sp)
ffffffffc0200d1a:	e0a2                	sd	s0,64(sp)
ffffffffc0200d1c:	e4a6                	sd	s1,72(sp)
ffffffffc0200d1e:	e8aa                	sd	a0,80(sp)
ffffffffc0200d20:	ecae                	sd	a1,88(sp)
ffffffffc0200d22:	f0b2                	sd	a2,96(sp)
ffffffffc0200d24:	f4b6                	sd	a3,104(sp)
ffffffffc0200d26:	f8ba                	sd	a4,112(sp)
ffffffffc0200d28:	fcbe                	sd	a5,120(sp)
ffffffffc0200d2a:	e142                	sd	a6,128(sp)
ffffffffc0200d2c:	e546                	sd	a7,136(sp)
ffffffffc0200d2e:	e94a                	sd	s2,144(sp)
ffffffffc0200d30:	ed4e                	sd	s3,152(sp)
ffffffffc0200d32:	f152                	sd	s4,160(sp)
ffffffffc0200d34:	f556                	sd	s5,168(sp)
ffffffffc0200d36:	f95a                	sd	s6,176(sp)
ffffffffc0200d38:	fd5e                	sd	s7,184(sp)
ffffffffc0200d3a:	e1e2                	sd	s8,192(sp)
ffffffffc0200d3c:	e5e6                	sd	s9,200(sp)
ffffffffc0200d3e:	e9ea                	sd	s10,208(sp)
ffffffffc0200d40:	edee                	sd	s11,216(sp)
ffffffffc0200d42:	f1f2                	sd	t3,224(sp)
ffffffffc0200d44:	f5f6                	sd	t4,232(sp)
ffffffffc0200d46:	f9fa                	sd	t5,240(sp)
ffffffffc0200d48:	fdfe                	sd	t6,248(sp)
ffffffffc0200d4a:	14002473          	csrr	s0,sscratch
ffffffffc0200d4e:	100024f3          	csrr	s1,sstatus
ffffffffc0200d52:	14102973          	csrr	s2,sepc
ffffffffc0200d56:	143029f3          	csrr	s3,stval
ffffffffc0200d5a:	14202a73          	csrr	s4,scause
ffffffffc0200d5e:	e822                	sd	s0,16(sp)
ffffffffc0200d60:	e226                	sd	s1,256(sp)
ffffffffc0200d62:	e64a                	sd	s2,264(sp)
ffffffffc0200d64:	ea4e                	sd	s3,272(sp)
ffffffffc0200d66:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d68:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d6a:	f91ff0ef          	jal	ffffffffc0200cfa <trap>

ffffffffc0200d6e <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d6e:	6492                	ld	s1,256(sp)
ffffffffc0200d70:	6932                	ld	s2,264(sp)
ffffffffc0200d72:	10049073          	csrw	sstatus,s1
ffffffffc0200d76:	14191073          	csrw	sepc,s2
ffffffffc0200d7a:	60a2                	ld	ra,8(sp)
ffffffffc0200d7c:	61e2                	ld	gp,24(sp)
ffffffffc0200d7e:	7202                	ld	tp,32(sp)
ffffffffc0200d80:	72a2                	ld	t0,40(sp)
ffffffffc0200d82:	7342                	ld	t1,48(sp)
ffffffffc0200d84:	73e2                	ld	t2,56(sp)
ffffffffc0200d86:	6406                	ld	s0,64(sp)
ffffffffc0200d88:	64a6                	ld	s1,72(sp)
ffffffffc0200d8a:	6546                	ld	a0,80(sp)
ffffffffc0200d8c:	65e6                	ld	a1,88(sp)
ffffffffc0200d8e:	7606                	ld	a2,96(sp)
ffffffffc0200d90:	76a6                	ld	a3,104(sp)
ffffffffc0200d92:	7746                	ld	a4,112(sp)
ffffffffc0200d94:	77e6                	ld	a5,120(sp)
ffffffffc0200d96:	680a                	ld	a6,128(sp)
ffffffffc0200d98:	68aa                	ld	a7,136(sp)
ffffffffc0200d9a:	694a                	ld	s2,144(sp)
ffffffffc0200d9c:	69ea                	ld	s3,152(sp)
ffffffffc0200d9e:	7a0a                	ld	s4,160(sp)
ffffffffc0200da0:	7aaa                	ld	s5,168(sp)
ffffffffc0200da2:	7b4a                	ld	s6,176(sp)
ffffffffc0200da4:	7bea                	ld	s7,184(sp)
ffffffffc0200da6:	6c0e                	ld	s8,192(sp)
ffffffffc0200da8:	6cae                	ld	s9,200(sp)
ffffffffc0200daa:	6d4e                	ld	s10,208(sp)
ffffffffc0200dac:	6dee                	ld	s11,216(sp)
ffffffffc0200dae:	7e0e                	ld	t3,224(sp)
ffffffffc0200db0:	7eae                	ld	t4,232(sp)
ffffffffc0200db2:	7f4e                	ld	t5,240(sp)
ffffffffc0200db4:	7fee                	ld	t6,248(sp)
ffffffffc0200db6:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200db8:	10200073          	sret

ffffffffc0200dbc <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200dbc:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200dbe:	bf45                	j	ffffffffc0200d6e <__trapret>
ffffffffc0200dc0:	0001                	nop

ffffffffc0200dc2 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200dc2:	00008797          	auipc	a5,0x8
ffffffffc0200dc6:	66e78793          	addi	a5,a5,1646 # ffffffffc0209430 <free_area>
ffffffffc0200dca:	e79c                	sd	a5,8(a5)
ffffffffc0200dcc:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200dce:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200dd2:	8082                	ret

ffffffffc0200dd4 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200dd4:	00008517          	auipc	a0,0x8
ffffffffc0200dd8:	66c56503          	lwu	a0,1644(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ddc:	8082                	ret

ffffffffc0200dde <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200dde:	711d                	addi	sp,sp,-96
ffffffffc0200de0:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200de2:	00008917          	auipc	s2,0x8
ffffffffc0200de6:	64e90913          	addi	s2,s2,1614 # ffffffffc0209430 <free_area>
ffffffffc0200dea:	00893783          	ld	a5,8(s2)
ffffffffc0200dee:	ec86                	sd	ra,88(sp)
ffffffffc0200df0:	e8a2                	sd	s0,80(sp)
ffffffffc0200df2:	e4a6                	sd	s1,72(sp)
ffffffffc0200df4:	fc4e                	sd	s3,56(sp)
ffffffffc0200df6:	f852                	sd	s4,48(sp)
ffffffffc0200df8:	f456                	sd	s5,40(sp)
ffffffffc0200dfa:	f05a                	sd	s6,32(sp)
ffffffffc0200dfc:	ec5e                	sd	s7,24(sp)
ffffffffc0200dfe:	e862                	sd	s8,16(sp)
ffffffffc0200e00:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e02:	2f278763          	beq	a5,s2,ffffffffc02010f0 <default_check+0x312>
    int count = 0, total = 0;
ffffffffc0200e06:	4401                	li	s0,0
ffffffffc0200e08:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e0a:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e0e:	8b09                	andi	a4,a4,2
ffffffffc0200e10:	2e070463          	beqz	a4,ffffffffc02010f8 <default_check+0x31a>
        count ++, total += p->property;
ffffffffc0200e14:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e18:	679c                	ld	a5,8(a5)
ffffffffc0200e1a:	2485                	addiw	s1,s1,1
ffffffffc0200e1c:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e1e:	ff2796e3          	bne	a5,s2,ffffffffc0200e0a <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200e22:	89a2                	mv	s3,s0
ffffffffc0200e24:	745000ef          	jal	ffffffffc0201d68 <nr_free_pages>
ffffffffc0200e28:	73351863          	bne	a0,s3,ffffffffc0201558 <default_check+0x77a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e2c:	4505                	li	a0,1
ffffffffc0200e2e:	6c9000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200e32:	8a2a                	mv	s4,a0
ffffffffc0200e34:	46050263          	beqz	a0,ffffffffc0201298 <default_check+0x4ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e38:	4505                	li	a0,1
ffffffffc0200e3a:	6bd000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200e3e:	89aa                	mv	s3,a0
ffffffffc0200e40:	72050c63          	beqz	a0,ffffffffc0201578 <default_check+0x79a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e44:	4505                	li	a0,1
ffffffffc0200e46:	6b1000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200e4a:	8aaa                	mv	s5,a0
ffffffffc0200e4c:	4c050663          	beqz	a0,ffffffffc0201318 <default_check+0x53a>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e50:	40aa07b3          	sub	a5,s4,a0
ffffffffc0200e54:	40a98733          	sub	a4,s3,a0
ffffffffc0200e58:	0017b793          	seqz	a5,a5
ffffffffc0200e5c:	00173713          	seqz	a4,a4
ffffffffc0200e60:	8fd9                	or	a5,a5,a4
ffffffffc0200e62:	30079b63          	bnez	a5,ffffffffc0201178 <default_check+0x39a>
ffffffffc0200e66:	313a0963          	beq	s4,s3,ffffffffc0201178 <default_check+0x39a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e6a:	000a2783          	lw	a5,0(s4)
ffffffffc0200e6e:	2a079563          	bnez	a5,ffffffffc0201118 <default_check+0x33a>
ffffffffc0200e72:	0009a783          	lw	a5,0(s3)
ffffffffc0200e76:	2a079163          	bnez	a5,ffffffffc0201118 <default_check+0x33a>
ffffffffc0200e7a:	411c                	lw	a5,0(a0)
ffffffffc0200e7c:	28079e63          	bnez	a5,ffffffffc0201118 <default_check+0x33a>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200e80:	0000c797          	auipc	a5,0xc
ffffffffc0200e84:	6487b783          	ld	a5,1608(a5) # ffffffffc020d4c8 <pages>
ffffffffc0200e88:	00005617          	auipc	a2,0x5
ffffffffc0200e8c:	c3863603          	ld	a2,-968(a2) # ffffffffc0205ac0 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e90:	0000c697          	auipc	a3,0xc
ffffffffc0200e94:	6306b683          	ld	a3,1584(a3) # ffffffffc020d4c0 <npage>
ffffffffc0200e98:	40fa0733          	sub	a4,s4,a5
ffffffffc0200e9c:	8719                	srai	a4,a4,0x6
ffffffffc0200e9e:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ea0:	0732                	slli	a4,a4,0xc
ffffffffc0200ea2:	06b2                	slli	a3,a3,0xc
ffffffffc0200ea4:	2ad77a63          	bgeu	a4,a3,ffffffffc0201158 <default_check+0x37a>
    return page - pages + nbase;
ffffffffc0200ea8:	40f98733          	sub	a4,s3,a5
ffffffffc0200eac:	8719                	srai	a4,a4,0x6
ffffffffc0200eae:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200eb0:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200eb2:	4ed77363          	bgeu	a4,a3,ffffffffc0201398 <default_check+0x5ba>
    return page - pages + nbase;
ffffffffc0200eb6:	40f507b3          	sub	a5,a0,a5
ffffffffc0200eba:	8799                	srai	a5,a5,0x6
ffffffffc0200ebc:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ebe:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200ec0:	32d7fc63          	bgeu	a5,a3,ffffffffc02011f8 <default_check+0x41a>
    assert(alloc_page() == NULL);
ffffffffc0200ec4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200ec6:	00093c03          	ld	s8,0(s2)
ffffffffc0200eca:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200ece:	00008b17          	auipc	s6,0x8
ffffffffc0200ed2:	572b2b03          	lw	s6,1394(s6) # ffffffffc0209440 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200ed6:	01293023          	sd	s2,0(s2)
ffffffffc0200eda:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200ede:	00008797          	auipc	a5,0x8
ffffffffc0200ee2:	5607a123          	sw	zero,1378(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200ee6:	611000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200eea:	2e051763          	bnez	a0,ffffffffc02011d8 <default_check+0x3fa>
    free_page(p0);
ffffffffc0200eee:	8552                	mv	a0,s4
ffffffffc0200ef0:	4585                	li	a1,1
ffffffffc0200ef2:	63f000ef          	jal	ffffffffc0201d30 <free_pages>
    free_page(p1);
ffffffffc0200ef6:	854e                	mv	a0,s3
ffffffffc0200ef8:	4585                	li	a1,1
ffffffffc0200efa:	637000ef          	jal	ffffffffc0201d30 <free_pages>
    free_page(p2);
ffffffffc0200efe:	8556                	mv	a0,s5
ffffffffc0200f00:	4585                	li	a1,1
ffffffffc0200f02:	62f000ef          	jal	ffffffffc0201d30 <free_pages>
    assert(nr_free == 3);
ffffffffc0200f06:	00008717          	auipc	a4,0x8
ffffffffc0200f0a:	53a72703          	lw	a4,1338(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200f0e:	478d                	li	a5,3
ffffffffc0200f10:	2af71463          	bne	a4,a5,ffffffffc02011b8 <default_check+0x3da>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f14:	4505                	li	a0,1
ffffffffc0200f16:	5e1000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f1a:	89aa                	mv	s3,a0
ffffffffc0200f1c:	26050e63          	beqz	a0,ffffffffc0201198 <default_check+0x3ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f20:	4505                	li	a0,1
ffffffffc0200f22:	5d5000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f26:	8aaa                	mv	s5,a0
ffffffffc0200f28:	3c050863          	beqz	a0,ffffffffc02012f8 <default_check+0x51a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f2c:	4505                	li	a0,1
ffffffffc0200f2e:	5c9000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f32:	8a2a                	mv	s4,a0
ffffffffc0200f34:	3a050263          	beqz	a0,ffffffffc02012d8 <default_check+0x4fa>
    assert(alloc_page() == NULL);
ffffffffc0200f38:	4505                	li	a0,1
ffffffffc0200f3a:	5bd000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f3e:	36051d63          	bnez	a0,ffffffffc02012b8 <default_check+0x4da>
    free_page(p0);
ffffffffc0200f42:	4585                	li	a1,1
ffffffffc0200f44:	854e                	mv	a0,s3
ffffffffc0200f46:	5eb000ef          	jal	ffffffffc0201d30 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200f4a:	00893783          	ld	a5,8(s2)
ffffffffc0200f4e:	1f278563          	beq	a5,s2,ffffffffc0201138 <default_check+0x35a>
    assert((p = alloc_page()) == p0);
ffffffffc0200f52:	4505                	li	a0,1
ffffffffc0200f54:	5a3000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f58:	8caa                	mv	s9,a0
ffffffffc0200f5a:	30a99f63          	bne	s3,a0,ffffffffc0201278 <default_check+0x49a>
    assert(alloc_page() == NULL);
ffffffffc0200f5e:	4505                	li	a0,1
ffffffffc0200f60:	597000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f64:	2e051a63          	bnez	a0,ffffffffc0201258 <default_check+0x47a>
    assert(nr_free == 0);
ffffffffc0200f68:	00008797          	auipc	a5,0x8
ffffffffc0200f6c:	4d87a783          	lw	a5,1240(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200f70:	2c079463          	bnez	a5,ffffffffc0201238 <default_check+0x45a>
    free_page(p);
ffffffffc0200f74:	8566                	mv	a0,s9
ffffffffc0200f76:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200f78:	01893023          	sd	s8,0(s2)
ffffffffc0200f7c:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200f80:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200f84:	5ad000ef          	jal	ffffffffc0201d30 <free_pages>
    free_page(p1);
ffffffffc0200f88:	8556                	mv	a0,s5
ffffffffc0200f8a:	4585                	li	a1,1
ffffffffc0200f8c:	5a5000ef          	jal	ffffffffc0201d30 <free_pages>
    free_page(p2);
ffffffffc0200f90:	8552                	mv	a0,s4
ffffffffc0200f92:	4585                	li	a1,1
ffffffffc0200f94:	59d000ef          	jal	ffffffffc0201d30 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200f98:	4515                	li	a0,5
ffffffffc0200f9a:	55d000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200f9e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200fa0:	26050c63          	beqz	a0,ffffffffc0201218 <default_check+0x43a>
ffffffffc0200fa4:	651c                	ld	a5,8(a0)
ffffffffc0200fa6:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200fa8:	8b85                	andi	a5,a5,1
ffffffffc0200faa:	54079763          	bnez	a5,ffffffffc02014f8 <default_check+0x71a>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200fae:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fb0:	00093b83          	ld	s7,0(s2)
ffffffffc0200fb4:	00893b03          	ld	s6,8(s2)
ffffffffc0200fb8:	01293023          	sd	s2,0(s2)
ffffffffc0200fbc:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200fc0:	537000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200fc4:	50051a63          	bnez	a0,ffffffffc02014d8 <default_check+0x6fa>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200fc8:	08098a13          	addi	s4,s3,128
ffffffffc0200fcc:	8552                	mv	a0,s4
ffffffffc0200fce:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200fd0:	00008c17          	auipc	s8,0x8
ffffffffc0200fd4:	470c2c03          	lw	s8,1136(s8) # ffffffffc0209440 <free_area+0x10>
    nr_free = 0;
ffffffffc0200fd8:	00008797          	auipc	a5,0x8
ffffffffc0200fdc:	4607a423          	sw	zero,1128(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200fe0:	551000ef          	jal	ffffffffc0201d30 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200fe4:	4511                	li	a0,4
ffffffffc0200fe6:	511000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0200fea:	4c051763          	bnez	a0,ffffffffc02014b8 <default_check+0x6da>
ffffffffc0200fee:	0889b783          	ld	a5,136(s3)
ffffffffc0200ff2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200ff4:	8b85                	andi	a5,a5,1
ffffffffc0200ff6:	4a078163          	beqz	a5,ffffffffc0201498 <default_check+0x6ba>
ffffffffc0200ffa:	0909a503          	lw	a0,144(s3)
ffffffffc0200ffe:	478d                	li	a5,3
ffffffffc0201000:	48f51c63          	bne	a0,a5,ffffffffc0201498 <default_check+0x6ba>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201004:	4f3000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0201008:	8aaa                	mv	s5,a0
ffffffffc020100a:	46050763          	beqz	a0,ffffffffc0201478 <default_check+0x69a>
    assert(alloc_page() == NULL);
ffffffffc020100e:	4505                	li	a0,1
ffffffffc0201010:	4e7000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0201014:	44051263          	bnez	a0,ffffffffc0201458 <default_check+0x67a>
    assert(p0 + 2 == p1);
ffffffffc0201018:	435a1063          	bne	s4,s5,ffffffffc0201438 <default_check+0x65a>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020101c:	4585                	li	a1,1
ffffffffc020101e:	854e                	mv	a0,s3
ffffffffc0201020:	511000ef          	jal	ffffffffc0201d30 <free_pages>
    free_pages(p1, 3);
ffffffffc0201024:	8552                	mv	a0,s4
ffffffffc0201026:	458d                	li	a1,3
ffffffffc0201028:	509000ef          	jal	ffffffffc0201d30 <free_pages>
ffffffffc020102c:	0089b783          	ld	a5,8(s3)
ffffffffc0201030:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201032:	8b85                	andi	a5,a5,1
ffffffffc0201034:	3e078263          	beqz	a5,ffffffffc0201418 <default_check+0x63a>
ffffffffc0201038:	0109aa83          	lw	s5,16(s3)
ffffffffc020103c:	4785                	li	a5,1
ffffffffc020103e:	3cfa9d63          	bne	s5,a5,ffffffffc0201418 <default_check+0x63a>
ffffffffc0201042:	008a3783          	ld	a5,8(s4)
ffffffffc0201046:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201048:	8b85                	andi	a5,a5,1
ffffffffc020104a:	3a078763          	beqz	a5,ffffffffc02013f8 <default_check+0x61a>
ffffffffc020104e:	010a2703          	lw	a4,16(s4)
ffffffffc0201052:	478d                	li	a5,3
ffffffffc0201054:	3af71263          	bne	a4,a5,ffffffffc02013f8 <default_check+0x61a>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201058:	8556                	mv	a0,s5
ffffffffc020105a:	49d000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc020105e:	36a99d63          	bne	s3,a0,ffffffffc02013d8 <default_check+0x5fa>
    free_page(p0);
ffffffffc0201062:	85d6                	mv	a1,s5
ffffffffc0201064:	4cd000ef          	jal	ffffffffc0201d30 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201068:	4509                	li	a0,2
ffffffffc020106a:	48d000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc020106e:	34aa1563          	bne	s4,a0,ffffffffc02013b8 <default_check+0x5da>

    free_pages(p0, 2);
ffffffffc0201072:	4589                	li	a1,2
ffffffffc0201074:	4bd000ef          	jal	ffffffffc0201d30 <free_pages>
    free_page(p2);
ffffffffc0201078:	04098513          	addi	a0,s3,64
ffffffffc020107c:	85d6                	mv	a1,s5
ffffffffc020107e:	4b3000ef          	jal	ffffffffc0201d30 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201082:	4515                	li	a0,5
ffffffffc0201084:	473000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0201088:	89aa                	mv	s3,a0
ffffffffc020108a:	48050763          	beqz	a0,ffffffffc0201518 <default_check+0x73a>
    assert(alloc_page() == NULL);
ffffffffc020108e:	8556                	mv	a0,s5
ffffffffc0201090:	467000ef          	jal	ffffffffc0201cf6 <alloc_pages>
ffffffffc0201094:	2e051263          	bnez	a0,ffffffffc0201378 <default_check+0x59a>

    assert(nr_free == 0);
ffffffffc0201098:	00008797          	auipc	a5,0x8
ffffffffc020109c:	3a87a783          	lw	a5,936(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc02010a0:	2a079c63          	bnez	a5,ffffffffc0201358 <default_check+0x57a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02010a4:	854e                	mv	a0,s3
ffffffffc02010a6:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc02010a8:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc02010ac:	01793023          	sd	s7,0(s2)
ffffffffc02010b0:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc02010b4:	47d000ef          	jal	ffffffffc0201d30 <free_pages>
    return listelm->next;
ffffffffc02010b8:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010bc:	01278963          	beq	a5,s2,ffffffffc02010ce <default_check+0x2f0>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02010c0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010c4:	679c                	ld	a5,8(a5)
ffffffffc02010c6:	34fd                	addiw	s1,s1,-1
ffffffffc02010c8:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010ca:	ff279be3          	bne	a5,s2,ffffffffc02010c0 <default_check+0x2e2>
    }
    assert(count == 0);
ffffffffc02010ce:	26049563          	bnez	s1,ffffffffc0201338 <default_check+0x55a>
    assert(total == 0);
ffffffffc02010d2:	46041363          	bnez	s0,ffffffffc0201538 <default_check+0x75a>
}
ffffffffc02010d6:	60e6                	ld	ra,88(sp)
ffffffffc02010d8:	6446                	ld	s0,80(sp)
ffffffffc02010da:	64a6                	ld	s1,72(sp)
ffffffffc02010dc:	6906                	ld	s2,64(sp)
ffffffffc02010de:	79e2                	ld	s3,56(sp)
ffffffffc02010e0:	7a42                	ld	s4,48(sp)
ffffffffc02010e2:	7aa2                	ld	s5,40(sp)
ffffffffc02010e4:	7b02                	ld	s6,32(sp)
ffffffffc02010e6:	6be2                	ld	s7,24(sp)
ffffffffc02010e8:	6c42                	ld	s8,16(sp)
ffffffffc02010ea:	6ca2                	ld	s9,8(sp)
ffffffffc02010ec:	6125                	addi	sp,sp,96
ffffffffc02010ee:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010f0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02010f2:	4401                	li	s0,0
ffffffffc02010f4:	4481                	li	s1,0
ffffffffc02010f6:	b33d                	j	ffffffffc0200e24 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc02010f8:	00004697          	auipc	a3,0x4
ffffffffc02010fc:	83868693          	addi	a3,a3,-1992 # ffffffffc0204930 <etext+0xa2a>
ffffffffc0201100:	00004617          	auipc	a2,0x4
ffffffffc0201104:	84060613          	addi	a2,a2,-1984 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201108:	0f000593          	li	a1,240
ffffffffc020110c:	00004517          	auipc	a0,0x4
ffffffffc0201110:	84c50513          	addi	a0,a0,-1972 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201114:	af2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201118:	00004697          	auipc	a3,0x4
ffffffffc020111c:	90068693          	addi	a3,a3,-1792 # ffffffffc0204a18 <etext+0xb12>
ffffffffc0201120:	00004617          	auipc	a2,0x4
ffffffffc0201124:	82060613          	addi	a2,a2,-2016 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201128:	0be00593          	li	a1,190
ffffffffc020112c:	00004517          	auipc	a0,0x4
ffffffffc0201130:	82c50513          	addi	a0,a0,-2004 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201134:	ad2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201138:	00004697          	auipc	a3,0x4
ffffffffc020113c:	9a868693          	addi	a3,a3,-1624 # ffffffffc0204ae0 <etext+0xbda>
ffffffffc0201140:	00004617          	auipc	a2,0x4
ffffffffc0201144:	80060613          	addi	a2,a2,-2048 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201148:	0d900593          	li	a1,217
ffffffffc020114c:	00004517          	auipc	a0,0x4
ffffffffc0201150:	80c50513          	addi	a0,a0,-2036 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201154:	ab2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201158:	00004697          	auipc	a3,0x4
ffffffffc020115c:	90068693          	addi	a3,a3,-1792 # ffffffffc0204a58 <etext+0xb52>
ffffffffc0201160:	00003617          	auipc	a2,0x3
ffffffffc0201164:	7e060613          	addi	a2,a2,2016 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201168:	0c000593          	li	a1,192
ffffffffc020116c:	00003517          	auipc	a0,0x3
ffffffffc0201170:	7ec50513          	addi	a0,a0,2028 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201174:	a92ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201178:	00004697          	auipc	a3,0x4
ffffffffc020117c:	87868693          	addi	a3,a3,-1928 # ffffffffc02049f0 <etext+0xaea>
ffffffffc0201180:	00003617          	auipc	a2,0x3
ffffffffc0201184:	7c060613          	addi	a2,a2,1984 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201188:	0bd00593          	li	a1,189
ffffffffc020118c:	00003517          	auipc	a0,0x3
ffffffffc0201190:	7cc50513          	addi	a0,a0,1996 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201194:	a72ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201198:	00003697          	auipc	a3,0x3
ffffffffc020119c:	7f868693          	addi	a3,a3,2040 # ffffffffc0204990 <etext+0xa8a>
ffffffffc02011a0:	00003617          	auipc	a2,0x3
ffffffffc02011a4:	7a060613          	addi	a2,a2,1952 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02011a8:	0d200593          	li	a1,210
ffffffffc02011ac:	00003517          	auipc	a0,0x3
ffffffffc02011b0:	7ac50513          	addi	a0,a0,1964 # ffffffffc0204958 <etext+0xa52>
ffffffffc02011b4:	a52ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 3);
ffffffffc02011b8:	00004697          	auipc	a3,0x4
ffffffffc02011bc:	91868693          	addi	a3,a3,-1768 # ffffffffc0204ad0 <etext+0xbca>
ffffffffc02011c0:	00003617          	auipc	a2,0x3
ffffffffc02011c4:	78060613          	addi	a2,a2,1920 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02011c8:	0d000593          	li	a1,208
ffffffffc02011cc:	00003517          	auipc	a0,0x3
ffffffffc02011d0:	78c50513          	addi	a0,a0,1932 # ffffffffc0204958 <etext+0xa52>
ffffffffc02011d4:	a32ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011d8:	00004697          	auipc	a3,0x4
ffffffffc02011dc:	8e068693          	addi	a3,a3,-1824 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc02011e0:	00003617          	auipc	a2,0x3
ffffffffc02011e4:	76060613          	addi	a2,a2,1888 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02011e8:	0cb00593          	li	a1,203
ffffffffc02011ec:	00003517          	auipc	a0,0x3
ffffffffc02011f0:	76c50513          	addi	a0,a0,1900 # ffffffffc0204958 <etext+0xa52>
ffffffffc02011f4:	a12ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02011f8:	00004697          	auipc	a3,0x4
ffffffffc02011fc:	8a068693          	addi	a3,a3,-1888 # ffffffffc0204a98 <etext+0xb92>
ffffffffc0201200:	00003617          	auipc	a2,0x3
ffffffffc0201204:	74060613          	addi	a2,a2,1856 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201208:	0c200593          	li	a1,194
ffffffffc020120c:	00003517          	auipc	a0,0x3
ffffffffc0201210:	74c50513          	addi	a0,a0,1868 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201214:	9f2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != NULL);
ffffffffc0201218:	00004697          	auipc	a3,0x4
ffffffffc020121c:	91068693          	addi	a3,a3,-1776 # ffffffffc0204b28 <etext+0xc22>
ffffffffc0201220:	00003617          	auipc	a2,0x3
ffffffffc0201224:	72060613          	addi	a2,a2,1824 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201228:	0f800593          	li	a1,248
ffffffffc020122c:	00003517          	auipc	a0,0x3
ffffffffc0201230:	72c50513          	addi	a0,a0,1836 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201234:	9d2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc0201238:	00004697          	auipc	a3,0x4
ffffffffc020123c:	8e068693          	addi	a3,a3,-1824 # ffffffffc0204b18 <etext+0xc12>
ffffffffc0201240:	00003617          	auipc	a2,0x3
ffffffffc0201244:	70060613          	addi	a2,a2,1792 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201248:	0df00593          	li	a1,223
ffffffffc020124c:	00003517          	auipc	a0,0x3
ffffffffc0201250:	70c50513          	addi	a0,a0,1804 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201254:	9b2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201258:	00004697          	auipc	a3,0x4
ffffffffc020125c:	86068693          	addi	a3,a3,-1952 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc0201260:	00003617          	auipc	a2,0x3
ffffffffc0201264:	6e060613          	addi	a2,a2,1760 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201268:	0dd00593          	li	a1,221
ffffffffc020126c:	00003517          	auipc	a0,0x3
ffffffffc0201270:	6ec50513          	addi	a0,a0,1772 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201274:	992ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201278:	00004697          	auipc	a3,0x4
ffffffffc020127c:	88068693          	addi	a3,a3,-1920 # ffffffffc0204af8 <etext+0xbf2>
ffffffffc0201280:	00003617          	auipc	a2,0x3
ffffffffc0201284:	6c060613          	addi	a2,a2,1728 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201288:	0dc00593          	li	a1,220
ffffffffc020128c:	00003517          	auipc	a0,0x3
ffffffffc0201290:	6cc50513          	addi	a0,a0,1740 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201294:	972ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201298:	00003697          	auipc	a3,0x3
ffffffffc020129c:	6f868693          	addi	a3,a3,1784 # ffffffffc0204990 <etext+0xa8a>
ffffffffc02012a0:	00003617          	auipc	a2,0x3
ffffffffc02012a4:	6a060613          	addi	a2,a2,1696 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02012a8:	0b900593          	li	a1,185
ffffffffc02012ac:	00003517          	auipc	a0,0x3
ffffffffc02012b0:	6ac50513          	addi	a0,a0,1708 # ffffffffc0204958 <etext+0xa52>
ffffffffc02012b4:	952ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012b8:	00004697          	auipc	a3,0x4
ffffffffc02012bc:	80068693          	addi	a3,a3,-2048 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc02012c0:	00003617          	auipc	a2,0x3
ffffffffc02012c4:	68060613          	addi	a2,a2,1664 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02012c8:	0d600593          	li	a1,214
ffffffffc02012cc:	00003517          	auipc	a0,0x3
ffffffffc02012d0:	68c50513          	addi	a0,a0,1676 # ffffffffc0204958 <etext+0xa52>
ffffffffc02012d4:	932ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012d8:	00003697          	auipc	a3,0x3
ffffffffc02012dc:	6f868693          	addi	a3,a3,1784 # ffffffffc02049d0 <etext+0xaca>
ffffffffc02012e0:	00003617          	auipc	a2,0x3
ffffffffc02012e4:	66060613          	addi	a2,a2,1632 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02012e8:	0d400593          	li	a1,212
ffffffffc02012ec:	00003517          	auipc	a0,0x3
ffffffffc02012f0:	66c50513          	addi	a0,a0,1644 # ffffffffc0204958 <etext+0xa52>
ffffffffc02012f4:	912ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012f8:	00003697          	auipc	a3,0x3
ffffffffc02012fc:	6b868693          	addi	a3,a3,1720 # ffffffffc02049b0 <etext+0xaaa>
ffffffffc0201300:	00003617          	auipc	a2,0x3
ffffffffc0201304:	64060613          	addi	a2,a2,1600 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201308:	0d300593          	li	a1,211
ffffffffc020130c:	00003517          	auipc	a0,0x3
ffffffffc0201310:	64c50513          	addi	a0,a0,1612 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201314:	8f2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201318:	00003697          	auipc	a3,0x3
ffffffffc020131c:	6b868693          	addi	a3,a3,1720 # ffffffffc02049d0 <etext+0xaca>
ffffffffc0201320:	00003617          	auipc	a2,0x3
ffffffffc0201324:	62060613          	addi	a2,a2,1568 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201328:	0bb00593          	li	a1,187
ffffffffc020132c:	00003517          	auipc	a0,0x3
ffffffffc0201330:	62c50513          	addi	a0,a0,1580 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201334:	8d2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(count == 0);
ffffffffc0201338:	00004697          	auipc	a3,0x4
ffffffffc020133c:	94068693          	addi	a3,a3,-1728 # ffffffffc0204c78 <etext+0xd72>
ffffffffc0201340:	00003617          	auipc	a2,0x3
ffffffffc0201344:	60060613          	addi	a2,a2,1536 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201348:	12500593          	li	a1,293
ffffffffc020134c:	00003517          	auipc	a0,0x3
ffffffffc0201350:	60c50513          	addi	a0,a0,1548 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201354:	8b2ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc0201358:	00003697          	auipc	a3,0x3
ffffffffc020135c:	7c068693          	addi	a3,a3,1984 # ffffffffc0204b18 <etext+0xc12>
ffffffffc0201360:	00003617          	auipc	a2,0x3
ffffffffc0201364:	5e060613          	addi	a2,a2,1504 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201368:	11a00593          	li	a1,282
ffffffffc020136c:	00003517          	auipc	a0,0x3
ffffffffc0201370:	5ec50513          	addi	a0,a0,1516 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201374:	892ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201378:	00003697          	auipc	a3,0x3
ffffffffc020137c:	74068693          	addi	a3,a3,1856 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc0201380:	00003617          	auipc	a2,0x3
ffffffffc0201384:	5c060613          	addi	a2,a2,1472 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201388:	11800593          	li	a1,280
ffffffffc020138c:	00003517          	auipc	a0,0x3
ffffffffc0201390:	5cc50513          	addi	a0,a0,1484 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201394:	872ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201398:	00003697          	auipc	a3,0x3
ffffffffc020139c:	6e068693          	addi	a3,a3,1760 # ffffffffc0204a78 <etext+0xb72>
ffffffffc02013a0:	00003617          	auipc	a2,0x3
ffffffffc02013a4:	5a060613          	addi	a2,a2,1440 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02013a8:	0c100593          	li	a1,193
ffffffffc02013ac:	00003517          	auipc	a0,0x3
ffffffffc02013b0:	5ac50513          	addi	a0,a0,1452 # ffffffffc0204958 <etext+0xa52>
ffffffffc02013b4:	852ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02013b8:	00004697          	auipc	a3,0x4
ffffffffc02013bc:	88068693          	addi	a3,a3,-1920 # ffffffffc0204c38 <etext+0xd32>
ffffffffc02013c0:	00003617          	auipc	a2,0x3
ffffffffc02013c4:	58060613          	addi	a2,a2,1408 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02013c8:	11200593          	li	a1,274
ffffffffc02013cc:	00003517          	auipc	a0,0x3
ffffffffc02013d0:	58c50513          	addi	a0,a0,1420 # ffffffffc0204958 <etext+0xa52>
ffffffffc02013d4:	832ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02013d8:	00004697          	auipc	a3,0x4
ffffffffc02013dc:	84068693          	addi	a3,a3,-1984 # ffffffffc0204c18 <etext+0xd12>
ffffffffc02013e0:	00003617          	auipc	a2,0x3
ffffffffc02013e4:	56060613          	addi	a2,a2,1376 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02013e8:	11000593          	li	a1,272
ffffffffc02013ec:	00003517          	auipc	a0,0x3
ffffffffc02013f0:	56c50513          	addi	a0,a0,1388 # ffffffffc0204958 <etext+0xa52>
ffffffffc02013f4:	812ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02013f8:	00003697          	auipc	a3,0x3
ffffffffc02013fc:	7f868693          	addi	a3,a3,2040 # ffffffffc0204bf0 <etext+0xcea>
ffffffffc0201400:	00003617          	auipc	a2,0x3
ffffffffc0201404:	54060613          	addi	a2,a2,1344 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201408:	10e00593          	li	a1,270
ffffffffc020140c:	00003517          	auipc	a0,0x3
ffffffffc0201410:	54c50513          	addi	a0,a0,1356 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201414:	ff3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201418:	00003697          	auipc	a3,0x3
ffffffffc020141c:	7b068693          	addi	a3,a3,1968 # ffffffffc0204bc8 <etext+0xcc2>
ffffffffc0201420:	00003617          	auipc	a2,0x3
ffffffffc0201424:	52060613          	addi	a2,a2,1312 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201428:	10d00593          	li	a1,269
ffffffffc020142c:	00003517          	auipc	a0,0x3
ffffffffc0201430:	52c50513          	addi	a0,a0,1324 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201434:	fd3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201438:	00003697          	auipc	a3,0x3
ffffffffc020143c:	78068693          	addi	a3,a3,1920 # ffffffffc0204bb8 <etext+0xcb2>
ffffffffc0201440:	00003617          	auipc	a2,0x3
ffffffffc0201444:	50060613          	addi	a2,a2,1280 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201448:	10800593          	li	a1,264
ffffffffc020144c:	00003517          	auipc	a0,0x3
ffffffffc0201450:	50c50513          	addi	a0,a0,1292 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201454:	fb3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201458:	00003697          	auipc	a3,0x3
ffffffffc020145c:	66068693          	addi	a3,a3,1632 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc0201460:	00003617          	auipc	a2,0x3
ffffffffc0201464:	4e060613          	addi	a2,a2,1248 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201468:	10700593          	li	a1,263
ffffffffc020146c:	00003517          	auipc	a0,0x3
ffffffffc0201470:	4ec50513          	addi	a0,a0,1260 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201474:	f93fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201478:	00003697          	auipc	a3,0x3
ffffffffc020147c:	72068693          	addi	a3,a3,1824 # ffffffffc0204b98 <etext+0xc92>
ffffffffc0201480:	00003617          	auipc	a2,0x3
ffffffffc0201484:	4c060613          	addi	a2,a2,1216 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201488:	10600593          	li	a1,262
ffffffffc020148c:	00003517          	auipc	a0,0x3
ffffffffc0201490:	4cc50513          	addi	a0,a0,1228 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201494:	f73fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201498:	00003697          	auipc	a3,0x3
ffffffffc020149c:	6d068693          	addi	a3,a3,1744 # ffffffffc0204b68 <etext+0xc62>
ffffffffc02014a0:	00003617          	auipc	a2,0x3
ffffffffc02014a4:	4a060613          	addi	a2,a2,1184 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02014a8:	10500593          	li	a1,261
ffffffffc02014ac:	00003517          	auipc	a0,0x3
ffffffffc02014b0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0204958 <etext+0xa52>
ffffffffc02014b4:	f53fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02014b8:	00003697          	auipc	a3,0x3
ffffffffc02014bc:	69868693          	addi	a3,a3,1688 # ffffffffc0204b50 <etext+0xc4a>
ffffffffc02014c0:	00003617          	auipc	a2,0x3
ffffffffc02014c4:	48060613          	addi	a2,a2,1152 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02014c8:	10400593          	li	a1,260
ffffffffc02014cc:	00003517          	auipc	a0,0x3
ffffffffc02014d0:	48c50513          	addi	a0,a0,1164 # ffffffffc0204958 <etext+0xa52>
ffffffffc02014d4:	f33fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014d8:	00003697          	auipc	a3,0x3
ffffffffc02014dc:	5e068693          	addi	a3,a3,1504 # ffffffffc0204ab8 <etext+0xbb2>
ffffffffc02014e0:	00003617          	auipc	a2,0x3
ffffffffc02014e4:	46060613          	addi	a2,a2,1120 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02014e8:	0fe00593          	li	a1,254
ffffffffc02014ec:	00003517          	auipc	a0,0x3
ffffffffc02014f0:	46c50513          	addi	a0,a0,1132 # ffffffffc0204958 <etext+0xa52>
ffffffffc02014f4:	f13fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(!PageProperty(p0));
ffffffffc02014f8:	00003697          	auipc	a3,0x3
ffffffffc02014fc:	64068693          	addi	a3,a3,1600 # ffffffffc0204b38 <etext+0xc32>
ffffffffc0201500:	00003617          	auipc	a2,0x3
ffffffffc0201504:	44060613          	addi	a2,a2,1088 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201508:	0f900593          	li	a1,249
ffffffffc020150c:	00003517          	auipc	a0,0x3
ffffffffc0201510:	44c50513          	addi	a0,a0,1100 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201514:	ef3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201518:	00003697          	auipc	a3,0x3
ffffffffc020151c:	74068693          	addi	a3,a3,1856 # ffffffffc0204c58 <etext+0xd52>
ffffffffc0201520:	00003617          	auipc	a2,0x3
ffffffffc0201524:	42060613          	addi	a2,a2,1056 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201528:	11700593          	li	a1,279
ffffffffc020152c:	00003517          	auipc	a0,0x3
ffffffffc0201530:	42c50513          	addi	a0,a0,1068 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201534:	ed3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == 0);
ffffffffc0201538:	00003697          	auipc	a3,0x3
ffffffffc020153c:	75068693          	addi	a3,a3,1872 # ffffffffc0204c88 <etext+0xd82>
ffffffffc0201540:	00003617          	auipc	a2,0x3
ffffffffc0201544:	40060613          	addi	a2,a2,1024 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201548:	12600593          	li	a1,294
ffffffffc020154c:	00003517          	auipc	a0,0x3
ffffffffc0201550:	40c50513          	addi	a0,a0,1036 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201554:	eb3fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201558:	00003697          	auipc	a3,0x3
ffffffffc020155c:	41868693          	addi	a3,a3,1048 # ffffffffc0204970 <etext+0xa6a>
ffffffffc0201560:	00003617          	auipc	a2,0x3
ffffffffc0201564:	3e060613          	addi	a2,a2,992 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201568:	0f300593          	li	a1,243
ffffffffc020156c:	00003517          	auipc	a0,0x3
ffffffffc0201570:	3ec50513          	addi	a0,a0,1004 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201574:	e93fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201578:	00003697          	auipc	a3,0x3
ffffffffc020157c:	43868693          	addi	a3,a3,1080 # ffffffffc02049b0 <etext+0xaaa>
ffffffffc0201580:	00003617          	auipc	a2,0x3
ffffffffc0201584:	3c060613          	addi	a2,a2,960 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201588:	0ba00593          	li	a1,186
ffffffffc020158c:	00003517          	auipc	a0,0x3
ffffffffc0201590:	3cc50513          	addi	a0,a0,972 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201594:	e73fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201598 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201598:	1141                	addi	sp,sp,-16
ffffffffc020159a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020159c:	14058663          	beqz	a1,ffffffffc02016e8 <default_free_pages+0x150>
    for (; p != base + n; p ++) {
ffffffffc02015a0:	00659713          	slli	a4,a1,0x6
ffffffffc02015a4:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02015a8:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc02015aa:	c30d                	beqz	a4,ffffffffc02015cc <default_free_pages+0x34>
ffffffffc02015ac:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015ae:	8b05                	andi	a4,a4,1
ffffffffc02015b0:	10071c63          	bnez	a4,ffffffffc02016c8 <default_free_pages+0x130>
ffffffffc02015b4:	6798                	ld	a4,8(a5)
ffffffffc02015b6:	8b09                	andi	a4,a4,2
ffffffffc02015b8:	10071863          	bnez	a4,ffffffffc02016c8 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc02015bc:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02015c0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015c4:	04078793          	addi	a5,a5,64
ffffffffc02015c8:	fed792e3          	bne	a5,a3,ffffffffc02015ac <default_free_pages+0x14>
    base->property = n;
ffffffffc02015cc:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02015ce:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015d2:	4789                	li	a5,2
ffffffffc02015d4:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02015d8:	00008717          	auipc	a4,0x8
ffffffffc02015dc:	e6872703          	lw	a4,-408(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc02015e0:	00008697          	auipc	a3,0x8
ffffffffc02015e4:	e5068693          	addi	a3,a3,-432 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc02015e8:	669c                	ld	a5,8(a3)
ffffffffc02015ea:	9f2d                	addw	a4,a4,a1
ffffffffc02015ec:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02015ee:	0ad78163          	beq	a5,a3,ffffffffc0201690 <default_free_pages+0xf8>
            struct Page* page = le2page(le, page_link);
ffffffffc02015f2:	fe878713          	addi	a4,a5,-24
ffffffffc02015f6:	4581                	li	a1,0
ffffffffc02015f8:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02015fc:	00e56a63          	bltu	a0,a4,ffffffffc0201610 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201600:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201602:	04d70c63          	beq	a4,a3,ffffffffc020165a <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc0201606:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201608:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020160c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201600 <default_free_pages+0x68>
ffffffffc0201610:	c199                	beqz	a1,ffffffffc0201616 <default_free_pages+0x7e>
ffffffffc0201612:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201616:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201618:	e390                	sd	a2,0(a5)
ffffffffc020161a:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc020161c:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc020161e:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201620:	00d70d63          	beq	a4,a3,ffffffffc020163a <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc0201624:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201628:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc020162c:	02059813          	slli	a6,a1,0x20
ffffffffc0201630:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201634:	97b2                	add	a5,a5,a2
ffffffffc0201636:	02f50c63          	beq	a0,a5,ffffffffc020166e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020163a:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc020163c:	00d78c63          	beq	a5,a3,ffffffffc0201654 <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201640:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201642:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0201646:	02061593          	slli	a1,a2,0x20
ffffffffc020164a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020164e:	972a                	add	a4,a4,a0
ffffffffc0201650:	04e68c63          	beq	a3,a4,ffffffffc02016a8 <default_free_pages+0x110>
}
ffffffffc0201654:	60a2                	ld	ra,8(sp)
ffffffffc0201656:	0141                	addi	sp,sp,16
ffffffffc0201658:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020165a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020165c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020165e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201660:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201662:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201664:	02d70f63          	beq	a4,a3,ffffffffc02016a2 <default_free_pages+0x10a>
ffffffffc0201668:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020166a:	87ba                	mv	a5,a4
ffffffffc020166c:	bf71                	j	ffffffffc0201608 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020166e:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201670:	5875                	li	a6,-3
ffffffffc0201672:	9fad                	addw	a5,a5,a1
ffffffffc0201674:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201678:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020167c:	01853803          	ld	a6,24(a0)
ffffffffc0201680:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201682:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201684:	00b83423          	sd	a1,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    return listelm->next;
ffffffffc0201688:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020168a:	0105b023          	sd	a6,0(a1)
ffffffffc020168e:	b77d                	j	ffffffffc020163c <default_free_pages+0xa4>
}
ffffffffc0201690:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201692:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201696:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201698:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020169a:	e398                	sd	a4,0(a5)
ffffffffc020169c:	e798                	sd	a4,8(a5)
}
ffffffffc020169e:	0141                	addi	sp,sp,16
ffffffffc02016a0:	8082                	ret
ffffffffc02016a2:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02016a4:	873e                	mv	a4,a5
ffffffffc02016a6:	bfad                	j	ffffffffc0201620 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc02016a8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02016ac:	56f5                	li	a3,-3
ffffffffc02016ae:	9f31                	addw	a4,a4,a2
ffffffffc02016b0:	c918                	sw	a4,16(a0)
ffffffffc02016b2:	ff078713          	addi	a4,a5,-16
ffffffffc02016b6:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02016ba:	6398                	ld	a4,0(a5)
ffffffffc02016bc:	679c                	ld	a5,8(a5)
}
ffffffffc02016be:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02016c0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02016c2:	e398                	sd	a4,0(a5)
ffffffffc02016c4:	0141                	addi	sp,sp,16
ffffffffc02016c6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016c8:	00003697          	auipc	a3,0x3
ffffffffc02016cc:	5d868693          	addi	a3,a3,1496 # ffffffffc0204ca0 <etext+0xd9a>
ffffffffc02016d0:	00003617          	auipc	a2,0x3
ffffffffc02016d4:	27060613          	addi	a2,a2,624 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02016d8:	08300593          	li	a1,131
ffffffffc02016dc:	00003517          	auipc	a0,0x3
ffffffffc02016e0:	27c50513          	addi	a0,a0,636 # ffffffffc0204958 <etext+0xa52>
ffffffffc02016e4:	d23fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc02016e8:	00003697          	auipc	a3,0x3
ffffffffc02016ec:	5b068693          	addi	a3,a3,1456 # ffffffffc0204c98 <etext+0xd92>
ffffffffc02016f0:	00003617          	auipc	a2,0x3
ffffffffc02016f4:	25060613          	addi	a2,a2,592 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02016f8:	08000593          	li	a1,128
ffffffffc02016fc:	00003517          	auipc	a0,0x3
ffffffffc0201700:	25c50513          	addi	a0,a0,604 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201704:	d03fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201708 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201708:	c951                	beqz	a0,ffffffffc020179c <default_alloc_pages+0x94>
    if (n > nr_free) {
ffffffffc020170a:	00008597          	auipc	a1,0x8
ffffffffc020170e:	d365a583          	lw	a1,-714(a1) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201712:	86aa                	mv	a3,a0
ffffffffc0201714:	02059793          	slli	a5,a1,0x20
ffffffffc0201718:	9381                	srli	a5,a5,0x20
ffffffffc020171a:	00a7ef63          	bltu	a5,a0,ffffffffc0201738 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc020171e:	00008617          	auipc	a2,0x8
ffffffffc0201722:	d1260613          	addi	a2,a2,-750 # ffffffffc0209430 <free_area>
ffffffffc0201726:	87b2                	mv	a5,a2
ffffffffc0201728:	a029                	j	ffffffffc0201732 <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc020172a:	ff87e703          	lwu	a4,-8(a5)
ffffffffc020172e:	00d77763          	bgeu	a4,a3,ffffffffc020173c <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc0201732:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201734:	fec79be3          	bne	a5,a2,ffffffffc020172a <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201738:	4501                	li	a0,0
}
ffffffffc020173a:	8082                	ret
        if (page->property > n) {
ffffffffc020173c:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201740:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201744:	6798                	ld	a4,8(a5)
ffffffffc0201746:	02089313          	slli	t1,a7,0x20
ffffffffc020174a:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020174e:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc0201752:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201756:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc020175a:	0266fa63          	bgeu	a3,t1,ffffffffc020178e <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc020175e:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc0201762:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201766:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201768:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020176c:	00870313          	addi	t1,a4,8
ffffffffc0201770:	4889                	li	a7,2
ffffffffc0201772:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201776:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020177a:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020177e:	0068b023          	sd	t1,0(a7)
ffffffffc0201782:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201786:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc020178a:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020178e:	9d95                	subw	a1,a1,a3
ffffffffc0201790:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201792:	5775                	li	a4,-3
ffffffffc0201794:	17c1                	addi	a5,a5,-16
ffffffffc0201796:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020179a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020179c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020179e:	00003697          	auipc	a3,0x3
ffffffffc02017a2:	4fa68693          	addi	a3,a3,1274 # ffffffffc0204c98 <etext+0xd92>
ffffffffc02017a6:	00003617          	auipc	a2,0x3
ffffffffc02017aa:	19a60613          	addi	a2,a2,410 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02017ae:	06200593          	li	a1,98
ffffffffc02017b2:	00003517          	auipc	a0,0x3
ffffffffc02017b6:	1a650513          	addi	a0,a0,422 # ffffffffc0204958 <etext+0xa52>
default_alloc_pages(size_t n) {
ffffffffc02017ba:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017bc:	c4bfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02017c0 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02017c0:	1141                	addi	sp,sp,-16
ffffffffc02017c2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017c4:	c9e1                	beqz	a1,ffffffffc0201894 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02017c6:	00659713          	slli	a4,a1,0x6
ffffffffc02017ca:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02017ce:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc02017d0:	cf11                	beqz	a4,ffffffffc02017ec <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02017d2:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02017d4:	8b05                	andi	a4,a4,1
ffffffffc02017d6:	cf59                	beqz	a4,ffffffffc0201874 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02017d8:	0007a823          	sw	zero,16(a5)
ffffffffc02017dc:	0007b423          	sd	zero,8(a5)
ffffffffc02017e0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02017e4:	04078793          	addi	a5,a5,64
ffffffffc02017e8:	fed795e3          	bne	a5,a3,ffffffffc02017d2 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02017ec:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017ee:	4789                	li	a5,2
ffffffffc02017f0:	00850713          	addi	a4,a0,8
ffffffffc02017f4:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02017f8:	00008717          	auipc	a4,0x8
ffffffffc02017fc:	c4872703          	lw	a4,-952(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201800:	00008697          	auipc	a3,0x8
ffffffffc0201804:	c3068693          	addi	a3,a3,-976 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc0201808:	669c                	ld	a5,8(a3)
ffffffffc020180a:	9f2d                	addw	a4,a4,a1
ffffffffc020180c:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020180e:	04d78663          	beq	a5,a3,ffffffffc020185a <default_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
ffffffffc0201812:	fe878713          	addi	a4,a5,-24
ffffffffc0201816:	4581                	li	a1,0
ffffffffc0201818:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc020181c:	00e56a63          	bltu	a0,a4,ffffffffc0201830 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201820:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201822:	02d70263          	beq	a4,a3,ffffffffc0201846 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc0201826:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201828:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020182c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201820 <default_init_memmap+0x60>
ffffffffc0201830:	c199                	beqz	a1,ffffffffc0201836 <default_init_memmap+0x76>
ffffffffc0201832:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201836:	6398                	ld	a4,0(a5)
}
ffffffffc0201838:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020183a:	e390                	sd	a2,0(a5)
ffffffffc020183c:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc020183e:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201840:	f11c                	sd	a5,32(a0)
ffffffffc0201842:	0141                	addi	sp,sp,16
ffffffffc0201844:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201846:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201848:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020184a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020184c:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020184e:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201850:	00d70e63          	beq	a4,a3,ffffffffc020186c <default_init_memmap+0xac>
ffffffffc0201854:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201856:	87ba                	mv	a5,a4
ffffffffc0201858:	bfc1                	j	ffffffffc0201828 <default_init_memmap+0x68>
}
ffffffffc020185a:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020185c:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201860:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201862:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201864:	e398                	sd	a4,0(a5)
ffffffffc0201866:	e798                	sd	a4,8(a5)
}
ffffffffc0201868:	0141                	addi	sp,sp,16
ffffffffc020186a:	8082                	ret
ffffffffc020186c:	60a2                	ld	ra,8(sp)
ffffffffc020186e:	e290                	sd	a2,0(a3)
ffffffffc0201870:	0141                	addi	sp,sp,16
ffffffffc0201872:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201874:	00003697          	auipc	a3,0x3
ffffffffc0201878:	45468693          	addi	a3,a3,1108 # ffffffffc0204cc8 <etext+0xdc2>
ffffffffc020187c:	00003617          	auipc	a2,0x3
ffffffffc0201880:	0c460613          	addi	a2,a2,196 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201884:	04900593          	li	a1,73
ffffffffc0201888:	00003517          	auipc	a0,0x3
ffffffffc020188c:	0d050513          	addi	a0,a0,208 # ffffffffc0204958 <etext+0xa52>
ffffffffc0201890:	b77fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc0201894:	00003697          	auipc	a3,0x3
ffffffffc0201898:	40468693          	addi	a3,a3,1028 # ffffffffc0204c98 <etext+0xd92>
ffffffffc020189c:	00003617          	auipc	a2,0x3
ffffffffc02018a0:	0a460613          	addi	a2,a2,164 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02018a4:	04600593          	li	a1,70
ffffffffc02018a8:	00003517          	auipc	a0,0x3
ffffffffc02018ac:	0b050513          	addi	a0,a0,176 # ffffffffc0204958 <etext+0xa52>
ffffffffc02018b0:	b57fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02018b4 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02018b4:	c531                	beqz	a0,ffffffffc0201900 <slob_free+0x4c>
		return;

	if (size)
ffffffffc02018b6:	e9b9                	bnez	a1,ffffffffc020190c <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018b8:	100027f3          	csrr	a5,sstatus
ffffffffc02018bc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02018be:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018c0:	efb1                	bnez	a5,ffffffffc020191c <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018c2:	00007797          	auipc	a5,0x7
ffffffffc02018c6:	75e7b783          	ld	a5,1886(a5) # ffffffffc0209020 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018ca:	873e                	mv	a4,a5
ffffffffc02018cc:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018ce:	02a77a63          	bgeu	a4,a0,ffffffffc0201902 <slob_free+0x4e>
ffffffffc02018d2:	00f56463          	bltu	a0,a5,ffffffffc02018da <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018d6:	fef76ae3          	bltu	a4,a5,ffffffffc02018ca <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc02018da:	4110                	lw	a2,0(a0)
ffffffffc02018dc:	00461693          	slli	a3,a2,0x4
ffffffffc02018e0:	96aa                	add	a3,a3,a0
ffffffffc02018e2:	0ad78463          	beq	a5,a3,ffffffffc020198a <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02018e6:	4310                	lw	a2,0(a4)
ffffffffc02018e8:	e51c                	sd	a5,8(a0)
ffffffffc02018ea:	00461693          	slli	a3,a2,0x4
ffffffffc02018ee:	96ba                	add	a3,a3,a4
ffffffffc02018f0:	08d50163          	beq	a0,a3,ffffffffc0201972 <slob_free+0xbe>
ffffffffc02018f4:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc02018f6:	00007797          	auipc	a5,0x7
ffffffffc02018fa:	72e7b523          	sd	a4,1834(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc02018fe:	e9a5                	bnez	a1,ffffffffc020196e <slob_free+0xba>
ffffffffc0201900:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201902:	fcf574e3          	bgeu	a0,a5,ffffffffc02018ca <slob_free+0x16>
ffffffffc0201906:	fcf762e3          	bltu	a4,a5,ffffffffc02018ca <slob_free+0x16>
ffffffffc020190a:	bfc1                	j	ffffffffc02018da <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc020190c:	25bd                	addiw	a1,a1,15
ffffffffc020190e:	8191                	srli	a1,a1,0x4
ffffffffc0201910:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201912:	100027f3          	csrr	a5,sstatus
ffffffffc0201916:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201918:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020191a:	d7c5                	beqz	a5,ffffffffc02018c2 <slob_free+0xe>
{
ffffffffc020191c:	1101                	addi	sp,sp,-32
ffffffffc020191e:	e42a                	sd	a0,8(sp)
ffffffffc0201920:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201922:	f53fe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0201926:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201928:	00007797          	auipc	a5,0x7
ffffffffc020192c:	6f87b783          	ld	a5,1784(a5) # ffffffffc0209020 <slobfree>
ffffffffc0201930:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201932:	873e                	mv	a4,a5
ffffffffc0201934:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201936:	06a77663          	bgeu	a4,a0,ffffffffc02019a2 <slob_free+0xee>
ffffffffc020193a:	00f56463          	bltu	a0,a5,ffffffffc0201942 <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020193e:	fef76ae3          	bltu	a4,a5,ffffffffc0201932 <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201942:	4110                	lw	a2,0(a0)
ffffffffc0201944:	00461693          	slli	a3,a2,0x4
ffffffffc0201948:	96aa                	add	a3,a3,a0
ffffffffc020194a:	06d78363          	beq	a5,a3,ffffffffc02019b0 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc020194e:	4310                	lw	a2,0(a4)
ffffffffc0201950:	e51c                	sd	a5,8(a0)
ffffffffc0201952:	00461693          	slli	a3,a2,0x4
ffffffffc0201956:	96ba                	add	a3,a3,a4
ffffffffc0201958:	06d50163          	beq	a0,a3,ffffffffc02019ba <slob_free+0x106>
ffffffffc020195c:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc020195e:	00007797          	auipc	a5,0x7
ffffffffc0201962:	6ce7b123          	sd	a4,1730(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc0201966:	e1a9                	bnez	a1,ffffffffc02019a8 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201968:	60e2                	ld	ra,24(sp)
ffffffffc020196a:	6105                	addi	sp,sp,32
ffffffffc020196c:	8082                	ret
        intr_enable();
ffffffffc020196e:	f01fe06f          	j	ffffffffc020086e <intr_enable>
		cur->units += b->units;
ffffffffc0201972:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201974:	853e                	mv	a0,a5
ffffffffc0201976:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201978:	00c687bb          	addw	a5,a3,a2
ffffffffc020197c:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc020197e:	00007797          	auipc	a5,0x7
ffffffffc0201982:	6ae7b123          	sd	a4,1698(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc0201986:	ddad                	beqz	a1,ffffffffc0201900 <slob_free+0x4c>
ffffffffc0201988:	b7dd                	j	ffffffffc020196e <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc020198a:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020198c:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020198e:	9eb1                	addw	a3,a3,a2
ffffffffc0201990:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201992:	4310                	lw	a2,0(a4)
ffffffffc0201994:	e51c                	sd	a5,8(a0)
ffffffffc0201996:	00461693          	slli	a3,a2,0x4
ffffffffc020199a:	96ba                	add	a3,a3,a4
ffffffffc020199c:	f4d51ce3          	bne	a0,a3,ffffffffc02018f4 <slob_free+0x40>
ffffffffc02019a0:	bfc9                	j	ffffffffc0201972 <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019a2:	f8f56ee3          	bltu	a0,a5,ffffffffc020193e <slob_free+0x8a>
ffffffffc02019a6:	b771                	j	ffffffffc0201932 <slob_free+0x7e>
}
ffffffffc02019a8:	60e2                	ld	ra,24(sp)
ffffffffc02019aa:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02019ac:	ec3fe06f          	j	ffffffffc020086e <intr_enable>
		b->units += cur->next->units;
ffffffffc02019b0:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02019b2:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02019b4:	9eb1                	addw	a3,a3,a2
ffffffffc02019b6:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc02019b8:	bf59                	j	ffffffffc020194e <slob_free+0x9a>
		cur->units += b->units;
ffffffffc02019ba:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc02019bc:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc02019be:	00c687bb          	addw	a5,a3,a2
ffffffffc02019c2:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc02019c4:	bf61                	j	ffffffffc020195c <slob_free+0xa8>

ffffffffc02019c6 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc02019c6:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02019c8:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc02019ca:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02019ce:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc02019d0:	326000ef          	jal	ffffffffc0201cf6 <alloc_pages>
	if (!page)
ffffffffc02019d4:	c91d                	beqz	a0,ffffffffc0201a0a <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc02019d6:	0000c697          	auipc	a3,0xc
ffffffffc02019da:	af26b683          	ld	a3,-1294(a3) # ffffffffc020d4c8 <pages>
ffffffffc02019de:	00004797          	auipc	a5,0x4
ffffffffc02019e2:	0e27b783          	ld	a5,226(a5) # ffffffffc0205ac0 <nbase>
    return KADDR(page2pa(page));
ffffffffc02019e6:	0000c717          	auipc	a4,0xc
ffffffffc02019ea:	ada73703          	ld	a4,-1318(a4) # ffffffffc020d4c0 <npage>
    return page - pages + nbase;
ffffffffc02019ee:	8d15                	sub	a0,a0,a3
ffffffffc02019f0:	8519                	srai	a0,a0,0x6
ffffffffc02019f2:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc02019f4:	00c51793          	slli	a5,a0,0xc
ffffffffc02019f8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02019fa:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02019fc:	00e7fa63          	bgeu	a5,a4,ffffffffc0201a10 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201a00:	0000c797          	auipc	a5,0xc
ffffffffc0201a04:	ab87b783          	ld	a5,-1352(a5) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201a08:	953e                	add	a0,a0,a5
}
ffffffffc0201a0a:	60a2                	ld	ra,8(sp)
ffffffffc0201a0c:	0141                	addi	sp,sp,16
ffffffffc0201a0e:	8082                	ret
ffffffffc0201a10:	86aa                	mv	a3,a0
ffffffffc0201a12:	00003617          	auipc	a2,0x3
ffffffffc0201a16:	2de60613          	addi	a2,a2,734 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0201a1a:	07100593          	li	a1,113
ffffffffc0201a1e:	00003517          	auipc	a0,0x3
ffffffffc0201a22:	2fa50513          	addi	a0,a0,762 # ffffffffc0204d18 <etext+0xe12>
ffffffffc0201a26:	9e1fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201a2a <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201a2a:	7179                	addi	sp,sp,-48
ffffffffc0201a2c:	f406                	sd	ra,40(sp)
ffffffffc0201a2e:	f022                	sd	s0,32(sp)
ffffffffc0201a30:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a32:	01050713          	addi	a4,a0,16
ffffffffc0201a36:	6785                	lui	a5,0x1
ffffffffc0201a38:	0af77e63          	bgeu	a4,a5,ffffffffc0201af4 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201a3c:	00f50413          	addi	s0,a0,15
ffffffffc0201a40:	8011                	srli	s0,s0,0x4
ffffffffc0201a42:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a44:	100025f3          	csrr	a1,sstatus
ffffffffc0201a48:	8989                	andi	a1,a1,2
ffffffffc0201a4a:	edd1                	bnez	a1,ffffffffc0201ae6 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201a4c:	00007497          	auipc	s1,0x7
ffffffffc0201a50:	5d448493          	addi	s1,s1,1492 # ffffffffc0209020 <slobfree>
ffffffffc0201a54:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a56:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201a58:	4314                	lw	a3,0(a4)
ffffffffc0201a5a:	0886da63          	bge	a3,s0,ffffffffc0201aee <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201a5e:	00e60a63          	beq	a2,a4,ffffffffc0201a72 <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a62:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201a64:	4394                	lw	a3,0(a5)
ffffffffc0201a66:	0286d863          	bge	a3,s0,ffffffffc0201a96 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201a6a:	6090                	ld	a2,0(s1)
ffffffffc0201a6c:	873e                	mv	a4,a5
ffffffffc0201a6e:	fee61ae3          	bne	a2,a4,ffffffffc0201a62 <slob_alloc.constprop.0+0x38>
    if (flag) {
ffffffffc0201a72:	e9b1                	bnez	a1,ffffffffc0201ac6 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201a74:	4501                	li	a0,0
ffffffffc0201a76:	f51ff0ef          	jal	ffffffffc02019c6 <__slob_get_free_pages.constprop.0>
ffffffffc0201a7a:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201a7c:	c915                	beqz	a0,ffffffffc0201ab0 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201a7e:	6585                	lui	a1,0x1
ffffffffc0201a80:	e35ff0ef          	jal	ffffffffc02018b4 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a84:	100025f3          	csrr	a1,sstatus
ffffffffc0201a88:	8989                	andi	a1,a1,2
ffffffffc0201a8a:	e98d                	bnez	a1,ffffffffc0201abc <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201a8c:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a8e:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201a90:	4394                	lw	a3,0(a5)
ffffffffc0201a92:	fc86cce3          	blt	a3,s0,ffffffffc0201a6a <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201a96:	04d40563          	beq	s0,a3,ffffffffc0201ae0 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201a9a:	00441613          	slli	a2,s0,0x4
ffffffffc0201a9e:	963e                	add	a2,a2,a5
ffffffffc0201aa0:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201aa2:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201aa4:	9e81                	subw	a3,a3,s0
ffffffffc0201aa6:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201aa8:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201aaa:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201aac:	e098                	sd	a4,0(s1)
    if (flag) {
ffffffffc0201aae:	ed99                	bnez	a1,ffffffffc0201acc <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201ab0:	70a2                	ld	ra,40(sp)
ffffffffc0201ab2:	7402                	ld	s0,32(sp)
ffffffffc0201ab4:	64e2                	ld	s1,24(sp)
ffffffffc0201ab6:	853e                	mv	a0,a5
ffffffffc0201ab8:	6145                	addi	sp,sp,48
ffffffffc0201aba:	8082                	ret
        intr_disable();
ffffffffc0201abc:	db9fe0ef          	jal	ffffffffc0200874 <intr_disable>
			cur = slobfree;
ffffffffc0201ac0:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201ac2:	4585                	li	a1,1
ffffffffc0201ac4:	b7e9                	j	ffffffffc0201a8e <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201ac6:	da9fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201aca:	b76d                	j	ffffffffc0201a74 <slob_alloc.constprop.0+0x4a>
ffffffffc0201acc:	e43e                	sd	a5,8(sp)
ffffffffc0201ace:	da1fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201ad2:	67a2                	ld	a5,8(sp)
}
ffffffffc0201ad4:	70a2                	ld	ra,40(sp)
ffffffffc0201ad6:	7402                	ld	s0,32(sp)
ffffffffc0201ad8:	64e2                	ld	s1,24(sp)
ffffffffc0201ada:	853e                	mv	a0,a5
ffffffffc0201adc:	6145                	addi	sp,sp,48
ffffffffc0201ade:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201ae0:	6794                	ld	a3,8(a5)
ffffffffc0201ae2:	e714                	sd	a3,8(a4)
ffffffffc0201ae4:	b7e1                	j	ffffffffc0201aac <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201ae6:	d8ffe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0201aea:	4585                	li	a1,1
ffffffffc0201aec:	b785                	j	ffffffffc0201a4c <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201aee:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201af0:	8732                	mv	a4,a2
ffffffffc0201af2:	b755                	j	ffffffffc0201a96 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201af4:	00003697          	auipc	a3,0x3
ffffffffc0201af8:	23468693          	addi	a3,a3,564 # ffffffffc0204d28 <etext+0xe22>
ffffffffc0201afc:	00003617          	auipc	a2,0x3
ffffffffc0201b00:	e4460613          	addi	a2,a2,-444 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0201b04:	06300593          	li	a1,99
ffffffffc0201b08:	00003517          	auipc	a0,0x3
ffffffffc0201b0c:	24050513          	addi	a0,a0,576 # ffffffffc0204d48 <etext+0xe42>
ffffffffc0201b10:	8f7fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201b14 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201b14:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201b16:	00003517          	auipc	a0,0x3
ffffffffc0201b1a:	24a50513          	addi	a0,a0,586 # ffffffffc0204d60 <etext+0xe5a>
{
ffffffffc0201b1e:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201b20:	e74fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201b24:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201b26:	00003517          	auipc	a0,0x3
ffffffffc0201b2a:	25250513          	addi	a0,a0,594 # ffffffffc0204d78 <etext+0xe72>
}
ffffffffc0201b2e:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201b30:	e64fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201b34 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201b34:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201b36:	6685                	lui	a3,0x1
{
ffffffffc0201b38:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201b3a:	16bd                	addi	a3,a3,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201b3c:	04a6f963          	bgeu	a3,a0,ffffffffc0201b8e <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201b40:	e42a                	sd	a0,8(sp)
ffffffffc0201b42:	4561                	li	a0,24
ffffffffc0201b44:	e822                	sd	s0,16(sp)
ffffffffc0201b46:	ee5ff0ef          	jal	ffffffffc0201a2a <slob_alloc.constprop.0>
ffffffffc0201b4a:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201b4c:	c541                	beqz	a0,ffffffffc0201bd4 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201b4e:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201b50:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201b52:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201b54:	00f75763          	bge	a4,a5,ffffffffc0201b62 <kmalloc+0x2e>
ffffffffc0201b58:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201b5c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201b5e:	fef74de3          	blt	a4,a5,ffffffffc0201b58 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201b62:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201b64:	e63ff0ef          	jal	ffffffffc02019c6 <__slob_get_free_pages.constprop.0>
ffffffffc0201b68:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201b6a:	cd31                	beqz	a0,ffffffffc0201bc6 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b6c:	100027f3          	csrr	a5,sstatus
ffffffffc0201b70:	8b89                	andi	a5,a5,2
ffffffffc0201b72:	eb85                	bnez	a5,ffffffffc0201ba2 <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201b74:	0000c797          	auipc	a5,0xc
ffffffffc0201b78:	9247b783          	ld	a5,-1756(a5) # ffffffffc020d498 <bigblocks>
		bigblocks = bb;
ffffffffc0201b7c:	0000c717          	auipc	a4,0xc
ffffffffc0201b80:	90873e23          	sd	s0,-1764(a4) # ffffffffc020d498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201b84:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0201b86:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201b88:	60e2                	ld	ra,24(sp)
ffffffffc0201b8a:	6105                	addi	sp,sp,32
ffffffffc0201b8c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201b8e:	0541                	addi	a0,a0,16
ffffffffc0201b90:	e9bff0ef          	jal	ffffffffc0201a2a <slob_alloc.constprop.0>
ffffffffc0201b94:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201b96:	0541                	addi	a0,a0,16
ffffffffc0201b98:	fbe5                	bnez	a5,ffffffffc0201b88 <kmalloc+0x54>
		return 0;
ffffffffc0201b9a:	4501                	li	a0,0
}
ffffffffc0201b9c:	60e2                	ld	ra,24(sp)
ffffffffc0201b9e:	6105                	addi	sp,sp,32
ffffffffc0201ba0:	8082                	ret
        intr_disable();
ffffffffc0201ba2:	cd3fe0ef          	jal	ffffffffc0200874 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201ba6:	0000c797          	auipc	a5,0xc
ffffffffc0201baa:	8f27b783          	ld	a5,-1806(a5) # ffffffffc020d498 <bigblocks>
		bigblocks = bb;
ffffffffc0201bae:	0000c717          	auipc	a4,0xc
ffffffffc0201bb2:	8e873523          	sd	s0,-1814(a4) # ffffffffc020d498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201bb6:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201bb8:	cb7fe0ef          	jal	ffffffffc020086e <intr_enable>
		return bb->pages;
ffffffffc0201bbc:	6408                	ld	a0,8(s0)
}
ffffffffc0201bbe:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201bc0:	6442                	ld	s0,16(sp)
}
ffffffffc0201bc2:	6105                	addi	sp,sp,32
ffffffffc0201bc4:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bc6:	8522                	mv	a0,s0
ffffffffc0201bc8:	45e1                	li	a1,24
ffffffffc0201bca:	cebff0ef          	jal	ffffffffc02018b4 <slob_free>
		return 0;
ffffffffc0201bce:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bd0:	6442                	ld	s0,16(sp)
ffffffffc0201bd2:	b7e9                	j	ffffffffc0201b9c <kmalloc+0x68>
ffffffffc0201bd4:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201bd6:	4501                	li	a0,0
ffffffffc0201bd8:	b7d1                	j	ffffffffc0201b9c <kmalloc+0x68>

ffffffffc0201bda <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201bda:	c571                	beqz	a0,ffffffffc0201ca6 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201bdc:	03451793          	slli	a5,a0,0x34
ffffffffc0201be0:	e3e1                	bnez	a5,ffffffffc0201ca0 <kfree+0xc6>
{
ffffffffc0201be2:	1101                	addi	sp,sp,-32
ffffffffc0201be4:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201be6:	100027f3          	csrr	a5,sstatus
ffffffffc0201bea:	8b89                	andi	a5,a5,2
ffffffffc0201bec:	e7c1                	bnez	a5,ffffffffc0201c74 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201bee:	0000c797          	auipc	a5,0xc
ffffffffc0201bf2:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc020d498 <bigblocks>
    return 0;
ffffffffc0201bf6:	4581                	li	a1,0
ffffffffc0201bf8:	cbad                	beqz	a5,ffffffffc0201c6a <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201bfa:	0000c617          	auipc	a2,0xc
ffffffffc0201bfe:	89e60613          	addi	a2,a2,-1890 # ffffffffc020d498 <bigblocks>
ffffffffc0201c02:	a021                	j	ffffffffc0201c0a <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c04:	01070613          	addi	a2,a4,16
ffffffffc0201c08:	c3a5                	beqz	a5,ffffffffc0201c68 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201c0a:	6794                	ld	a3,8(a5)
ffffffffc0201c0c:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201c0e:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201c10:	fea69ae3          	bne	a3,a0,ffffffffc0201c04 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201c14:	e21c                	sd	a5,0(a2)
    if (flag) {
ffffffffc0201c16:	edb5                	bnez	a1,ffffffffc0201c92 <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201c18:	c02007b7          	lui	a5,0xc0200
ffffffffc0201c1c:	0af56263          	bltu	a0,a5,ffffffffc0201cc0 <kfree+0xe6>
ffffffffc0201c20:	0000c797          	auipc	a5,0xc
ffffffffc0201c24:	8987b783          	ld	a5,-1896(a5) # ffffffffc020d4b8 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201c28:	0000c697          	auipc	a3,0xc
ffffffffc0201c2c:	8986b683          	ld	a3,-1896(a3) # ffffffffc020d4c0 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201c30:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201c32:	00c55793          	srli	a5,a0,0xc
ffffffffc0201c36:	06d7f963          	bgeu	a5,a3,ffffffffc0201ca8 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201c3a:	00004617          	auipc	a2,0x4
ffffffffc0201c3e:	e8663603          	ld	a2,-378(a2) # ffffffffc0205ac0 <nbase>
ffffffffc0201c42:	0000c517          	auipc	a0,0xc
ffffffffc0201c46:	88653503          	ld	a0,-1914(a0) # ffffffffc020d4c8 <pages>
	free_pages(kva2page((void*)kva), 1 << order);//增加一个强制转换不知道会不会有问题！！！
ffffffffc0201c4a:	4314                	lw	a3,0(a4)
ffffffffc0201c4c:	8f91                	sub	a5,a5,a2
ffffffffc0201c4e:	079a                	slli	a5,a5,0x6
ffffffffc0201c50:	4585                	li	a1,1
ffffffffc0201c52:	953e                	add	a0,a0,a5
ffffffffc0201c54:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201c58:	e03a                	sd	a4,0(sp)
ffffffffc0201c5a:	0d6000ef          	jal	ffffffffc0201d30 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c5e:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201c60:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c62:	45e1                	li	a1,24
}
ffffffffc0201c64:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c66:	b1b9                	j	ffffffffc02018b4 <slob_free>
ffffffffc0201c68:	e185                	bnez	a1,ffffffffc0201c88 <kfree+0xae>
}
ffffffffc0201c6a:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c6c:	1541                	addi	a0,a0,-16
ffffffffc0201c6e:	4581                	li	a1,0
}
ffffffffc0201c70:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c72:	b189                	j	ffffffffc02018b4 <slob_free>
        intr_disable();
ffffffffc0201c74:	e02a                	sd	a0,0(sp)
ffffffffc0201c76:	bfffe0ef          	jal	ffffffffc0200874 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c7a:	0000c797          	auipc	a5,0xc
ffffffffc0201c7e:	81e7b783          	ld	a5,-2018(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201c82:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201c84:	4585                	li	a1,1
ffffffffc0201c86:	fbb5                	bnez	a5,ffffffffc0201bfa <kfree+0x20>
ffffffffc0201c88:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201c8a:	be5fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201c8e:	6502                	ld	a0,0(sp)
ffffffffc0201c90:	bfe9                	j	ffffffffc0201c6a <kfree+0x90>
ffffffffc0201c92:	e42a                	sd	a0,8(sp)
ffffffffc0201c94:	e03a                	sd	a4,0(sp)
ffffffffc0201c96:	bd9fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201c9a:	6522                	ld	a0,8(sp)
ffffffffc0201c9c:	6702                	ld	a4,0(sp)
ffffffffc0201c9e:	bfad                	j	ffffffffc0201c18 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ca0:	1541                	addi	a0,a0,-16
ffffffffc0201ca2:	4581                	li	a1,0
ffffffffc0201ca4:	b901                	j	ffffffffc02018b4 <slob_free>
ffffffffc0201ca6:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201ca8:	00003617          	auipc	a2,0x3
ffffffffc0201cac:	11860613          	addi	a2,a2,280 # ffffffffc0204dc0 <etext+0xeba>
ffffffffc0201cb0:	06900593          	li	a1,105
ffffffffc0201cb4:	00003517          	auipc	a0,0x3
ffffffffc0201cb8:	06450513          	addi	a0,a0,100 # ffffffffc0204d18 <etext+0xe12>
ffffffffc0201cbc:	f4afe0ef          	jal	ffffffffc0200406 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201cc0:	86aa                	mv	a3,a0
ffffffffc0201cc2:	00003617          	auipc	a2,0x3
ffffffffc0201cc6:	0d660613          	addi	a2,a2,214 # ffffffffc0204d98 <etext+0xe92>
ffffffffc0201cca:	07700593          	li	a1,119
ffffffffc0201cce:	00003517          	auipc	a0,0x3
ffffffffc0201cd2:	04a50513          	addi	a0,a0,74 # ffffffffc0204d18 <etext+0xe12>
ffffffffc0201cd6:	f30fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201cda <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201cda:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201cdc:	00003617          	auipc	a2,0x3
ffffffffc0201ce0:	0e460613          	addi	a2,a2,228 # ffffffffc0204dc0 <etext+0xeba>
ffffffffc0201ce4:	06900593          	li	a1,105
ffffffffc0201ce8:	00003517          	auipc	a0,0x3
ffffffffc0201cec:	03050513          	addi	a0,a0,48 # ffffffffc0204d18 <etext+0xe12>
pa2page(uintptr_t pa)
ffffffffc0201cf0:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201cf2:	f14fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201cf6 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201cf6:	100027f3          	csrr	a5,sstatus
ffffffffc0201cfa:	8b89                	andi	a5,a5,2
ffffffffc0201cfc:	e799                	bnez	a5,ffffffffc0201d0a <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201cfe:	0000b797          	auipc	a5,0xb
ffffffffc0201d02:	7a27b783          	ld	a5,1954(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d06:	6f9c                	ld	a5,24(a5)
ffffffffc0201d08:	8782                	jr	a5
{
ffffffffc0201d0a:	1101                	addi	sp,sp,-32
ffffffffc0201d0c:	ec06                	sd	ra,24(sp)
ffffffffc0201d0e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201d10:	b65fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d14:	0000b797          	auipc	a5,0xb
ffffffffc0201d18:	78c7b783          	ld	a5,1932(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d1c:	6522                	ld	a0,8(sp)
ffffffffc0201d1e:	6f9c                	ld	a5,24(a5)
ffffffffc0201d20:	9782                	jalr	a5
ffffffffc0201d22:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201d24:	b4bfe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201d28:	60e2                	ld	ra,24(sp)
ffffffffc0201d2a:	6522                	ld	a0,8(sp)
ffffffffc0201d2c:	6105                	addi	sp,sp,32
ffffffffc0201d2e:	8082                	ret

ffffffffc0201d30 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d30:	100027f3          	csrr	a5,sstatus
ffffffffc0201d34:	8b89                	andi	a5,a5,2
ffffffffc0201d36:	e799                	bnez	a5,ffffffffc0201d44 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201d38:	0000b797          	auipc	a5,0xb
ffffffffc0201d3c:	7687b783          	ld	a5,1896(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d40:	739c                	ld	a5,32(a5)
ffffffffc0201d42:	8782                	jr	a5
{
ffffffffc0201d44:	1101                	addi	sp,sp,-32
ffffffffc0201d46:	ec06                	sd	ra,24(sp)
ffffffffc0201d48:	e42e                	sd	a1,8(sp)
ffffffffc0201d4a:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201d4c:	b29fe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201d50:	0000b797          	auipc	a5,0xb
ffffffffc0201d54:	7507b783          	ld	a5,1872(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d58:	65a2                	ld	a1,8(sp)
ffffffffc0201d5a:	6502                	ld	a0,0(sp)
ffffffffc0201d5c:	739c                	ld	a5,32(a5)
ffffffffc0201d5e:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201d60:	60e2                	ld	ra,24(sp)
ffffffffc0201d62:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201d64:	b0bfe06f          	j	ffffffffc020086e <intr_enable>

ffffffffc0201d68 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d68:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6c:	8b89                	andi	a5,a5,2
ffffffffc0201d6e:	e799                	bnez	a5,ffffffffc0201d7c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d70:	0000b797          	auipc	a5,0xb
ffffffffc0201d74:	7307b783          	ld	a5,1840(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d78:	779c                	ld	a5,40(a5)
ffffffffc0201d7a:	8782                	jr	a5
{
ffffffffc0201d7c:	1101                	addi	sp,sp,-32
ffffffffc0201d7e:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201d80:	af5fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d84:	0000b797          	auipc	a5,0xb
ffffffffc0201d88:	71c7b783          	ld	a5,1820(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d8c:	779c                	ld	a5,40(a5)
ffffffffc0201d8e:	9782                	jalr	a5
ffffffffc0201d90:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201d92:	addfe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201d96:	60e2                	ld	ra,24(sp)
ffffffffc0201d98:	6522                	ld	a0,8(sp)
ffffffffc0201d9a:	6105                	addi	sp,sp,32
ffffffffc0201d9c:	8082                	ret

ffffffffc0201d9e <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d9e:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201da2:	1ff7f793          	andi	a5,a5,511
ffffffffc0201da6:	078e                	slli	a5,a5,0x3
ffffffffc0201da8:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201dac:	6314                	ld	a3,0(a4)
{
ffffffffc0201dae:	7139                	addi	sp,sp,-64
ffffffffc0201db0:	f822                	sd	s0,48(sp)
ffffffffc0201db2:	f426                	sd	s1,40(sp)
ffffffffc0201db4:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201db6:	0016f793          	andi	a5,a3,1
{
ffffffffc0201dba:	842e                	mv	s0,a1
ffffffffc0201dbc:	8832                	mv	a6,a2
ffffffffc0201dbe:	0000b497          	auipc	s1,0xb
ffffffffc0201dc2:	70248493          	addi	s1,s1,1794 # ffffffffc020d4c0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201dc6:	ebd1                	bnez	a5,ffffffffc0201e5a <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201dc8:	16060d63          	beqz	a2,ffffffffc0201f42 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201dcc:	100027f3          	csrr	a5,sstatus
ffffffffc0201dd0:	8b89                	andi	a5,a5,2
ffffffffc0201dd2:	16079e63          	bnez	a5,ffffffffc0201f4e <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201dd6:	0000b797          	auipc	a5,0xb
ffffffffc0201dda:	6ca7b783          	ld	a5,1738(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201dde:	4505                	li	a0,1
ffffffffc0201de0:	e43a                	sd	a4,8(sp)
ffffffffc0201de2:	6f9c                	ld	a5,24(a5)
ffffffffc0201de4:	e832                	sd	a2,16(sp)
ffffffffc0201de6:	9782                	jalr	a5
ffffffffc0201de8:	6722                	ld	a4,8(sp)
ffffffffc0201dea:	6842                	ld	a6,16(sp)
ffffffffc0201dec:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201dee:	14078a63          	beqz	a5,ffffffffc0201f42 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201df2:	0000b517          	auipc	a0,0xb
ffffffffc0201df6:	6d653503          	ld	a0,1750(a0) # ffffffffc020d4c8 <pages>
ffffffffc0201dfa:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201dfe:	0000b497          	auipc	s1,0xb
ffffffffc0201e02:	6c248493          	addi	s1,s1,1730 # ffffffffc020d4c0 <npage>
ffffffffc0201e06:	40a78533          	sub	a0,a5,a0
ffffffffc0201e0a:	8519                	srai	a0,a0,0x6
ffffffffc0201e0c:	9546                	add	a0,a0,a7
ffffffffc0201e0e:	6090                	ld	a2,0(s1)
ffffffffc0201e10:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201e14:	4585                	li	a1,1
ffffffffc0201e16:	82b1                	srli	a3,a3,0xc
ffffffffc0201e18:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e1a:	0532                	slli	a0,a0,0xc
ffffffffc0201e1c:	1ac6f763          	bgeu	a3,a2,ffffffffc0201fca <get_pte+0x22c>
ffffffffc0201e20:	0000b697          	auipc	a3,0xb
ffffffffc0201e24:	6986b683          	ld	a3,1688(a3) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201e28:	6605                	lui	a2,0x1
ffffffffc0201e2a:	4581                	li	a1,0
ffffffffc0201e2c:	9536                	add	a0,a0,a3
ffffffffc0201e2e:	ec42                	sd	a6,24(sp)
ffffffffc0201e30:	e83e                	sd	a5,16(sp)
ffffffffc0201e32:	e43a                	sd	a4,8(sp)
ffffffffc0201e34:	084020ef          	jal	ffffffffc0203eb8 <memset>
    return page - pages + nbase;
ffffffffc0201e38:	0000b697          	auipc	a3,0xb
ffffffffc0201e3c:	6906b683          	ld	a3,1680(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201e40:	67c2                	ld	a5,16(sp)
ffffffffc0201e42:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e46:	6722                	ld	a4,8(sp)
ffffffffc0201e48:	40d786b3          	sub	a3,a5,a3
ffffffffc0201e4c:	8699                	srai	a3,a3,0x6
ffffffffc0201e4e:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e50:	06aa                	slli	a3,a3,0xa
ffffffffc0201e52:	6862                	ld	a6,24(sp)
ffffffffc0201e54:	0116e693          	ori	a3,a3,17
ffffffffc0201e58:	e314                	sd	a3,0(a4)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201e5a:	c006f693          	andi	a3,a3,-1024
ffffffffc0201e5e:	6098                	ld	a4,0(s1)
ffffffffc0201e60:	068a                	slli	a3,a3,0x2
ffffffffc0201e62:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e66:	14e7f663          	bgeu	a5,a4,ffffffffc0201fb2 <get_pte+0x214>
ffffffffc0201e6a:	0000b897          	auipc	a7,0xb
ffffffffc0201e6e:	64e88893          	addi	a7,a7,1614 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201e72:	0008b603          	ld	a2,0(a7)
ffffffffc0201e76:	01545793          	srli	a5,s0,0x15
ffffffffc0201e7a:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e7e:	96b2                	add	a3,a3,a2
ffffffffc0201e80:	078e                	slli	a5,a5,0x3
ffffffffc0201e82:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201e84:	6394                	ld	a3,0(a5)
ffffffffc0201e86:	0016f613          	andi	a2,a3,1
ffffffffc0201e8a:	e659                	bnez	a2,ffffffffc0201f18 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e8c:	0a080b63          	beqz	a6,ffffffffc0201f42 <get_pte+0x1a4>
ffffffffc0201e90:	10002773          	csrr	a4,sstatus
ffffffffc0201e94:	8b09                	andi	a4,a4,2
ffffffffc0201e96:	ef71                	bnez	a4,ffffffffc0201f72 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e98:	0000b717          	auipc	a4,0xb
ffffffffc0201e9c:	60873703          	ld	a4,1544(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201ea0:	4505                	li	a0,1
ffffffffc0201ea2:	e43e                	sd	a5,8(sp)
ffffffffc0201ea4:	6f18                	ld	a4,24(a4)
ffffffffc0201ea6:	9702                	jalr	a4
ffffffffc0201ea8:	67a2                	ld	a5,8(sp)
ffffffffc0201eaa:	872a                	mv	a4,a0
ffffffffc0201eac:	0000b897          	auipc	a7,0xb
ffffffffc0201eb0:	60c88893          	addi	a7,a7,1548 # ffffffffc020d4b8 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201eb4:	c759                	beqz	a4,ffffffffc0201f42 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201eb6:	0000b697          	auipc	a3,0xb
ffffffffc0201eba:	6126b683          	ld	a3,1554(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201ebe:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ec2:	608c                	ld	a1,0(s1)
ffffffffc0201ec4:	40d706b3          	sub	a3,a4,a3
ffffffffc0201ec8:	8699                	srai	a3,a3,0x6
ffffffffc0201eca:	96c2                	add	a3,a3,a6
ffffffffc0201ecc:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0201ed0:	4505                	li	a0,1
ffffffffc0201ed2:	8231                	srli	a2,a2,0xc
ffffffffc0201ed4:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ed6:	06b2                	slli	a3,a3,0xc
ffffffffc0201ed8:	10b67663          	bgeu	a2,a1,ffffffffc0201fe4 <get_pte+0x246>
ffffffffc0201edc:	0008b503          	ld	a0,0(a7)
ffffffffc0201ee0:	6605                	lui	a2,0x1
ffffffffc0201ee2:	4581                	li	a1,0
ffffffffc0201ee4:	9536                	add	a0,a0,a3
ffffffffc0201ee6:	e83a                	sd	a4,16(sp)
ffffffffc0201ee8:	e43e                	sd	a5,8(sp)
ffffffffc0201eea:	7cf010ef          	jal	ffffffffc0203eb8 <memset>
    return page - pages + nbase;
ffffffffc0201eee:	0000b697          	auipc	a3,0xb
ffffffffc0201ef2:	5da6b683          	ld	a3,1498(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201ef6:	6742                	ld	a4,16(sp)
ffffffffc0201ef8:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201efc:	67a2                	ld	a5,8(sp)
ffffffffc0201efe:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f02:	8699                	srai	a3,a3,0x6
ffffffffc0201f04:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f06:	06aa                	slli	a3,a3,0xa
ffffffffc0201f08:	0116e693          	ori	a3,a3,17
ffffffffc0201f0c:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f0e:	6098                	ld	a4,0(s1)
ffffffffc0201f10:	0000b897          	auipc	a7,0xb
ffffffffc0201f14:	5a888893          	addi	a7,a7,1448 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201f18:	c006f693          	andi	a3,a3,-1024
ffffffffc0201f1c:	068a                	slli	a3,a3,0x2
ffffffffc0201f1e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f22:	06e7fc63          	bgeu	a5,a4,ffffffffc0201f9a <get_pte+0x1fc>
ffffffffc0201f26:	0008b783          	ld	a5,0(a7)
ffffffffc0201f2a:	8031                	srli	s0,s0,0xc
ffffffffc0201f2c:	1ff47413          	andi	s0,s0,511
ffffffffc0201f30:	040e                	slli	s0,s0,0x3
ffffffffc0201f32:	96be                	add	a3,a3,a5
}
ffffffffc0201f34:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f36:	00868533          	add	a0,a3,s0
}
ffffffffc0201f3a:	7442                	ld	s0,48(sp)
ffffffffc0201f3c:	74a2                	ld	s1,40(sp)
ffffffffc0201f3e:	6121                	addi	sp,sp,64
ffffffffc0201f40:	8082                	ret
ffffffffc0201f42:	70e2                	ld	ra,56(sp)
ffffffffc0201f44:	7442                	ld	s0,48(sp)
ffffffffc0201f46:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0201f48:	4501                	li	a0,0
}
ffffffffc0201f4a:	6121                	addi	sp,sp,64
ffffffffc0201f4c:	8082                	ret
        intr_disable();
ffffffffc0201f4e:	e83a                	sd	a4,16(sp)
ffffffffc0201f50:	ec32                	sd	a2,24(sp)
ffffffffc0201f52:	923fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f56:	0000b797          	auipc	a5,0xb
ffffffffc0201f5a:	54a7b783          	ld	a5,1354(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201f5e:	4505                	li	a0,1
ffffffffc0201f60:	6f9c                	ld	a5,24(a5)
ffffffffc0201f62:	9782                	jalr	a5
ffffffffc0201f64:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f66:	909fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201f6a:	6862                	ld	a6,24(sp)
ffffffffc0201f6c:	6742                	ld	a4,16(sp)
ffffffffc0201f6e:	67a2                	ld	a5,8(sp)
ffffffffc0201f70:	bdbd                	j	ffffffffc0201dee <get_pte+0x50>
        intr_disable();
ffffffffc0201f72:	e83e                	sd	a5,16(sp)
ffffffffc0201f74:	901fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201f78:	0000b717          	auipc	a4,0xb
ffffffffc0201f7c:	52873703          	ld	a4,1320(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201f80:	4505                	li	a0,1
ffffffffc0201f82:	6f18                	ld	a4,24(a4)
ffffffffc0201f84:	9702                	jalr	a4
ffffffffc0201f86:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f88:	8e7fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201f8c:	6722                	ld	a4,8(sp)
ffffffffc0201f8e:	67c2                	ld	a5,16(sp)
ffffffffc0201f90:	0000b897          	auipc	a7,0xb
ffffffffc0201f94:	52888893          	addi	a7,a7,1320 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201f98:	bf31                	j	ffffffffc0201eb4 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f9a:	00003617          	auipc	a2,0x3
ffffffffc0201f9e:	d5660613          	addi	a2,a2,-682 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0201fa2:	0fb00593          	li	a1,251
ffffffffc0201fa6:	00003517          	auipc	a0,0x3
ffffffffc0201faa:	e3a50513          	addi	a0,a0,-454 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0201fae:	c58fe0ef          	jal	ffffffffc0200406 <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201fb2:	00003617          	auipc	a2,0x3
ffffffffc0201fb6:	d3e60613          	addi	a2,a2,-706 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0201fba:	0ee00593          	li	a1,238
ffffffffc0201fbe:	00003517          	auipc	a0,0x3
ffffffffc0201fc2:	e2250513          	addi	a0,a0,-478 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0201fc6:	c40fe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fca:	86aa                	mv	a3,a0
ffffffffc0201fcc:	00003617          	auipc	a2,0x3
ffffffffc0201fd0:	d2460613          	addi	a2,a2,-732 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0201fd4:	0eb00593          	li	a1,235
ffffffffc0201fd8:	00003517          	auipc	a0,0x3
ffffffffc0201fdc:	e0850513          	addi	a0,a0,-504 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0201fe0:	c26fe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fe4:	00003617          	auipc	a2,0x3
ffffffffc0201fe8:	d0c60613          	addi	a2,a2,-756 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0201fec:	0f800593          	li	a1,248
ffffffffc0201ff0:	00003517          	auipc	a0,0x3
ffffffffc0201ff4:	df050513          	addi	a0,a0,-528 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0201ff8:	c0efe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201ffc <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0201ffc:	1141                	addi	sp,sp,-16
ffffffffc0201ffe:	e022                	sd	s0,0(sp)
ffffffffc0202000:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202002:	4601                	li	a2,0
{
ffffffffc0202004:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202006:	d99ff0ef          	jal	ffffffffc0201d9e <get_pte>
    if (ptep_store != NULL)
ffffffffc020200a:	c011                	beqz	s0,ffffffffc020200e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020200c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020200e:	c511                	beqz	a0,ffffffffc020201a <get_page+0x1e>
ffffffffc0202010:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202012:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202014:	0017f713          	andi	a4,a5,1
ffffffffc0202018:	e709                	bnez	a4,ffffffffc0202022 <get_page+0x26>
}
ffffffffc020201a:	60a2                	ld	ra,8(sp)
ffffffffc020201c:	6402                	ld	s0,0(sp)
ffffffffc020201e:	0141                	addi	sp,sp,16
ffffffffc0202020:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202022:	0000b717          	auipc	a4,0xb
ffffffffc0202026:	49e73703          	ld	a4,1182(a4) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020202a:	078a                	slli	a5,a5,0x2
ffffffffc020202c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020202e:	00e7ff63          	bgeu	a5,a4,ffffffffc020204c <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0202032:	0000b517          	auipc	a0,0xb
ffffffffc0202036:	49653503          	ld	a0,1174(a0) # ffffffffc020d4c8 <pages>
ffffffffc020203a:	60a2                	ld	ra,8(sp)
ffffffffc020203c:	6402                	ld	s0,0(sp)
ffffffffc020203e:	079a                	slli	a5,a5,0x6
ffffffffc0202040:	fe000737          	lui	a4,0xfe000
ffffffffc0202044:	97ba                	add	a5,a5,a4
ffffffffc0202046:	953e                	add	a0,a0,a5
ffffffffc0202048:	0141                	addi	sp,sp,16
ffffffffc020204a:	8082                	ret
ffffffffc020204c:	c8fff0ef          	jal	ffffffffc0201cda <pa2page.part.0>

ffffffffc0202050 <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc0202050:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202052:	4601                	li	a2,0
{
ffffffffc0202054:	e822                	sd	s0,16(sp)
ffffffffc0202056:	ec06                	sd	ra,24(sp)
ffffffffc0202058:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020205a:	d45ff0ef          	jal	ffffffffc0201d9e <get_pte>
    if (ptep != NULL)
ffffffffc020205e:	c511                	beqz	a0,ffffffffc020206a <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202060:	6118                	ld	a4,0(a0)
ffffffffc0202062:	87aa                	mv	a5,a0
ffffffffc0202064:	00177693          	andi	a3,a4,1
ffffffffc0202068:	e689                	bnez	a3,ffffffffc0202072 <page_remove+0x22>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc020206a:	60e2                	ld	ra,24(sp)
ffffffffc020206c:	6442                	ld	s0,16(sp)
ffffffffc020206e:	6105                	addi	sp,sp,32
ffffffffc0202070:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202072:	0000b697          	auipc	a3,0xb
ffffffffc0202076:	44e6b683          	ld	a3,1102(a3) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020207a:	070a                	slli	a4,a4,0x2
ffffffffc020207c:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc020207e:	06d77563          	bgeu	a4,a3,ffffffffc02020e8 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202082:	0000b517          	auipc	a0,0xb
ffffffffc0202086:	44653503          	ld	a0,1094(a0) # ffffffffc020d4c8 <pages>
ffffffffc020208a:	071a                	slli	a4,a4,0x6
ffffffffc020208c:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202090:	9736                	add	a4,a4,a3
ffffffffc0202092:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202094:	4118                	lw	a4,0(a0)
ffffffffc0202096:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3ddf2b0f>
ffffffffc0202098:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020209a:	cb09                	beqz	a4,ffffffffc02020ac <page_remove+0x5c>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020209c:	0007b023          	sd	zero,0(a5)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020a0:	12040073          	sfence.vma	s0
}
ffffffffc02020a4:	60e2                	ld	ra,24(sp)
ffffffffc02020a6:	6442                	ld	s0,16(sp)
ffffffffc02020a8:	6105                	addi	sp,sp,32
ffffffffc02020aa:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02020ac:	10002773          	csrr	a4,sstatus
ffffffffc02020b0:	8b09                	andi	a4,a4,2
ffffffffc02020b2:	eb19                	bnez	a4,ffffffffc02020c8 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc02020b4:	0000b717          	auipc	a4,0xb
ffffffffc02020b8:	3ec73703          	ld	a4,1004(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc02020bc:	4585                	li	a1,1
ffffffffc02020be:	e03e                	sd	a5,0(sp)
ffffffffc02020c0:	7318                	ld	a4,32(a4)
ffffffffc02020c2:	9702                	jalr	a4
    if (flag) {
ffffffffc02020c4:	6782                	ld	a5,0(sp)
ffffffffc02020c6:	bfd9                	j	ffffffffc020209c <page_remove+0x4c>
        intr_disable();
ffffffffc02020c8:	e43e                	sd	a5,8(sp)
ffffffffc02020ca:	e02a                	sd	a0,0(sp)
ffffffffc02020cc:	fa8fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02020d0:	0000b717          	auipc	a4,0xb
ffffffffc02020d4:	3d073703          	ld	a4,976(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc02020d8:	6502                	ld	a0,0(sp)
ffffffffc02020da:	4585                	li	a1,1
ffffffffc02020dc:	7318                	ld	a4,32(a4)
ffffffffc02020de:	9702                	jalr	a4
        intr_enable();
ffffffffc02020e0:	f8efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02020e4:	67a2                	ld	a5,8(sp)
ffffffffc02020e6:	bf5d                	j	ffffffffc020209c <page_remove+0x4c>
ffffffffc02020e8:	bf3ff0ef          	jal	ffffffffc0201cda <pa2page.part.0>

ffffffffc02020ec <page_insert>:
{
ffffffffc02020ec:	7139                	addi	sp,sp,-64
ffffffffc02020ee:	f426                	sd	s1,40(sp)
ffffffffc02020f0:	84b2                	mv	s1,a2
ffffffffc02020f2:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02020f4:	4605                	li	a2,1
{
ffffffffc02020f6:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02020f8:	85a6                	mv	a1,s1
{
ffffffffc02020fa:	fc06                	sd	ra,56(sp)
ffffffffc02020fc:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02020fe:	ca1ff0ef          	jal	ffffffffc0201d9e <get_pte>
    if (ptep == NULL)
ffffffffc0202102:	cd61                	beqz	a0,ffffffffc02021da <page_insert+0xee>
    page->ref += 1;
ffffffffc0202104:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202106:	611c                	ld	a5,0(a0)
ffffffffc0202108:	66a2                	ld	a3,8(sp)
ffffffffc020210a:	0015861b          	addiw	a2,a1,1 # 1001 <kern_entry-0xffffffffc01fefff>
ffffffffc020210e:	c010                	sw	a2,0(s0)
ffffffffc0202110:	0017f613          	andi	a2,a5,1
ffffffffc0202114:	872a                	mv	a4,a0
ffffffffc0202116:	e61d                	bnez	a2,ffffffffc0202144 <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc0202118:	0000b617          	auipc	a2,0xb
ffffffffc020211c:	3b063603          	ld	a2,944(a2) # ffffffffc020d4c8 <pages>
    return page - pages + nbase;
ffffffffc0202120:	8c11                	sub	s0,s0,a2
ffffffffc0202122:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202124:	200007b7          	lui	a5,0x20000
ffffffffc0202128:	042a                	slli	s0,s0,0xa
ffffffffc020212a:	943e                	add	s0,s0,a5
ffffffffc020212c:	8ec1                	or	a3,a3,s0
ffffffffc020212e:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202132:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202134:	12048073          	sfence.vma	s1
    return 0;
ffffffffc0202138:	4501                	li	a0,0
}
ffffffffc020213a:	70e2                	ld	ra,56(sp)
ffffffffc020213c:	7442                	ld	s0,48(sp)
ffffffffc020213e:	74a2                	ld	s1,40(sp)
ffffffffc0202140:	6121                	addi	sp,sp,64
ffffffffc0202142:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202144:	0000b617          	auipc	a2,0xb
ffffffffc0202148:	37c63603          	ld	a2,892(a2) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020214c:	078a                	slli	a5,a5,0x2
ffffffffc020214e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202150:	08c7f763          	bgeu	a5,a2,ffffffffc02021de <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202154:	0000b617          	auipc	a2,0xb
ffffffffc0202158:	37463603          	ld	a2,884(a2) # ffffffffc020d4c8 <pages>
ffffffffc020215c:	fe000537          	lui	a0,0xfe000
ffffffffc0202160:	079a                	slli	a5,a5,0x6
ffffffffc0202162:	97aa                	add	a5,a5,a0
ffffffffc0202164:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202168:	00a40963          	beq	s0,a0,ffffffffc020217a <page_insert+0x8e>
    page->ref -= 1;
ffffffffc020216c:	411c                	lw	a5,0(a0)
ffffffffc020216e:	37fd                	addiw	a5,a5,-1 # 1fffffff <kern_entry-0xffffffffa0200001>
ffffffffc0202170:	c11c                	sw	a5,0(a0)
        if (page_ref(page) ==
ffffffffc0202172:	c791                	beqz	a5,ffffffffc020217e <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202174:	12048073          	sfence.vma	s1
}
ffffffffc0202178:	b765                	j	ffffffffc0202120 <page_insert+0x34>
ffffffffc020217a:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc020217c:	b755                	j	ffffffffc0202120 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020217e:	100027f3          	csrr	a5,sstatus
ffffffffc0202182:	8b89                	andi	a5,a5,2
ffffffffc0202184:	e39d                	bnez	a5,ffffffffc02021aa <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc0202186:	0000b797          	auipc	a5,0xb
ffffffffc020218a:	31a7b783          	ld	a5,794(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc020218e:	4585                	li	a1,1
ffffffffc0202190:	e83a                	sd	a4,16(sp)
ffffffffc0202192:	739c                	ld	a5,32(a5)
ffffffffc0202194:	e436                	sd	a3,8(sp)
ffffffffc0202196:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202198:	0000b617          	auipc	a2,0xb
ffffffffc020219c:	33063603          	ld	a2,816(a2) # ffffffffc020d4c8 <pages>
ffffffffc02021a0:	66a2                	ld	a3,8(sp)
ffffffffc02021a2:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021a4:	12048073          	sfence.vma	s1
ffffffffc02021a8:	bfa5                	j	ffffffffc0202120 <page_insert+0x34>
        intr_disable();
ffffffffc02021aa:	ec3a                	sd	a4,24(sp)
ffffffffc02021ac:	e836                	sd	a3,16(sp)
ffffffffc02021ae:	e42a                	sd	a0,8(sp)
ffffffffc02021b0:	ec4fe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02021b4:	0000b797          	auipc	a5,0xb
ffffffffc02021b8:	2ec7b783          	ld	a5,748(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc02021bc:	6522                	ld	a0,8(sp)
ffffffffc02021be:	4585                	li	a1,1
ffffffffc02021c0:	739c                	ld	a5,32(a5)
ffffffffc02021c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02021c4:	eaafe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02021c8:	0000b617          	auipc	a2,0xb
ffffffffc02021cc:	30063603          	ld	a2,768(a2) # ffffffffc020d4c8 <pages>
ffffffffc02021d0:	6762                	ld	a4,24(sp)
ffffffffc02021d2:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021d4:	12048073          	sfence.vma	s1
ffffffffc02021d8:	b7a1                	j	ffffffffc0202120 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc02021da:	5571                	li	a0,-4
ffffffffc02021dc:	bfb9                	j	ffffffffc020213a <page_insert+0x4e>
ffffffffc02021de:	afdff0ef          	jal	ffffffffc0201cda <pa2page.part.0>

ffffffffc02021e2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02021e2:	00003797          	auipc	a5,0x3
ffffffffc02021e6:	71678793          	addi	a5,a5,1814 # ffffffffc02058f8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02021ea:	638c                	ld	a1,0(a5)
{
ffffffffc02021ec:	7159                	addi	sp,sp,-112
ffffffffc02021ee:	f486                	sd	ra,104(sp)
ffffffffc02021f0:	e8ca                	sd	s2,80(sp)
ffffffffc02021f2:	e4ce                	sd	s3,72(sp)
ffffffffc02021f4:	f85a                	sd	s6,48(sp)
ffffffffc02021f6:	f0a2                	sd	s0,96(sp)
ffffffffc02021f8:	eca6                	sd	s1,88(sp)
ffffffffc02021fa:	e0d2                	sd	s4,64(sp)
ffffffffc02021fc:	fc56                	sd	s5,56(sp)
ffffffffc02021fe:	f45e                	sd	s7,40(sp)
ffffffffc0202200:	f062                	sd	s8,32(sp)
ffffffffc0202202:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202204:	0000bb17          	auipc	s6,0xb
ffffffffc0202208:	29cb0b13          	addi	s6,s6,668 # ffffffffc020d4a0 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020220c:	00003517          	auipc	a0,0x3
ffffffffc0202210:	be450513          	addi	a0,a0,-1052 # ffffffffc0204df0 <etext+0xeea>
    pmm_manager = &default_pmm_manager;
ffffffffc0202214:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202218:	f7dfd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc020221c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202220:	0000b997          	auipc	s3,0xb
ffffffffc0202224:	29898993          	addi	s3,s3,664 # ffffffffc020d4b8 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202228:	679c                	ld	a5,8(a5)
ffffffffc020222a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020222c:	57f5                	li	a5,-3
ffffffffc020222e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202230:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202234:	e26fe0ef          	jal	ffffffffc020085a <get_memory_base>
ffffffffc0202238:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc020223a:	e2afe0ef          	jal	ffffffffc0200864 <get_memory_size>
    if (mem_size == 0) {
ffffffffc020223e:	70050e63          	beqz	a0,ffffffffc020295a <pmm_init+0x778>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202242:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202244:	00003517          	auipc	a0,0x3
ffffffffc0202248:	be450513          	addi	a0,a0,-1052 # ffffffffc0204e28 <etext+0xf22>
ffffffffc020224c:	f49fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202250:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202254:	864a                	mv	a2,s2
ffffffffc0202256:	85a6                	mv	a1,s1
ffffffffc0202258:	fff40693          	addi	a3,s0,-1
ffffffffc020225c:	00003517          	auipc	a0,0x3
ffffffffc0202260:	be450513          	addi	a0,a0,-1052 # ffffffffc0204e40 <etext+0xf3a>
ffffffffc0202264:	f31fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202268:	c80007b7          	lui	a5,0xc8000
ffffffffc020226c:	8522                	mv	a0,s0
ffffffffc020226e:	5287ed63          	bltu	a5,s0,ffffffffc02027a8 <pmm_init+0x5c6>
ffffffffc0202272:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202274:	0000c617          	auipc	a2,0xc
ffffffffc0202278:	27b60613          	addi	a2,a2,635 # ffffffffc020e4ef <end+0xfff>
ffffffffc020227c:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc020227e:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202280:	0000bb97          	auipc	s7,0xb
ffffffffc0202284:	248b8b93          	addi	s7,s7,584 # ffffffffc020d4c8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202288:	0000b497          	auipc	s1,0xb
ffffffffc020228c:	23848493          	addi	s1,s1,568 # ffffffffc020d4c0 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202290:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc0202294:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202296:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020229a:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020229c:	02f50763          	beq	a0,a5,ffffffffc02022ca <pmm_init+0xe8>
ffffffffc02022a0:	4701                	li	a4,0
ffffffffc02022a2:	4585                	li	a1,1
ffffffffc02022a4:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02022a8:	00671793          	slli	a5,a4,0x6
ffffffffc02022ac:	97b2                	add	a5,a5,a2
ffffffffc02022ae:	07a1                	addi	a5,a5,8 # 80008 <kern_entry-0xffffffffc017fff8>
ffffffffc02022b0:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02022b4:	6088                	ld	a0,0(s1)
ffffffffc02022b6:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02022b8:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02022bc:	00d507b3          	add	a5,a0,a3
ffffffffc02022c0:	fef764e3          	bltu	a4,a5,ffffffffc02022a8 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02022c4:	079a                	slli	a5,a5,0x6
ffffffffc02022c6:	00f606b3          	add	a3,a2,a5
ffffffffc02022ca:	c02007b7          	lui	a5,0xc0200
ffffffffc02022ce:	16f6eee3          	bltu	a3,a5,ffffffffc0202c4a <pmm_init+0xa68>
ffffffffc02022d2:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02022d6:	77fd                	lui	a5,0xfffff
ffffffffc02022d8:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02022da:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02022dc:	4e86ed63          	bltu	a3,s0,ffffffffc02027d6 <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02022e0:	00003517          	auipc	a0,0x3
ffffffffc02022e4:	b8850513          	addi	a0,a0,-1144 # ffffffffc0204e68 <etext+0xf62>
ffffffffc02022e8:	eadfd0ef          	jal	ffffffffc0200194 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02022ec:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02022f0:	0000b917          	auipc	s2,0xb
ffffffffc02022f4:	1c090913          	addi	s2,s2,448 # ffffffffc020d4b0 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02022f8:	7b9c                	ld	a5,48(a5)
ffffffffc02022fa:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02022fc:	00003517          	auipc	a0,0x3
ffffffffc0202300:	b8450513          	addi	a0,a0,-1148 # ffffffffc0204e80 <etext+0xf7a>
ffffffffc0202304:	e91fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202308:	00006697          	auipc	a3,0x6
ffffffffc020230c:	cf868693          	addi	a3,a3,-776 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202310:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202314:	c02007b7          	lui	a5,0xc0200
ffffffffc0202318:	2af6eee3          	bltu	a3,a5,ffffffffc0202dd4 <pmm_init+0xbf2>
ffffffffc020231c:	0009b783          	ld	a5,0(s3)
ffffffffc0202320:	8e9d                	sub	a3,a3,a5
ffffffffc0202322:	0000b797          	auipc	a5,0xb
ffffffffc0202326:	18d7b323          	sd	a3,390(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020232a:	100027f3          	csrr	a5,sstatus
ffffffffc020232e:	8b89                	andi	a5,a5,2
ffffffffc0202330:	48079963          	bnez	a5,ffffffffc02027c2 <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202334:	000b3783          	ld	a5,0(s6)
ffffffffc0202338:	779c                	ld	a5,40(a5)
ffffffffc020233a:	9782                	jalr	a5
ffffffffc020233c:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020233e:	6098                	ld	a4,0(s1)
ffffffffc0202340:	c80007b7          	lui	a5,0xc8000
ffffffffc0202344:	83b1                	srli	a5,a5,0xc
ffffffffc0202346:	66e7e663          	bltu	a5,a4,ffffffffc02029b2 <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020234a:	00093503          	ld	a0,0(s2)
ffffffffc020234e:	64050263          	beqz	a0,ffffffffc0202992 <pmm_init+0x7b0>
ffffffffc0202352:	03451793          	slli	a5,a0,0x34
ffffffffc0202356:	62079e63          	bnez	a5,ffffffffc0202992 <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020235a:	4601                	li	a2,0
ffffffffc020235c:	4581                	li	a1,0
ffffffffc020235e:	c9fff0ef          	jal	ffffffffc0201ffc <get_page>
ffffffffc0202362:	240519e3          	bnez	a0,ffffffffc0202db4 <pmm_init+0xbd2>
ffffffffc0202366:	100027f3          	csrr	a5,sstatus
ffffffffc020236a:	8b89                	andi	a5,a5,2
ffffffffc020236c:	44079063          	bnez	a5,ffffffffc02027ac <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202370:	000b3783          	ld	a5,0(s6)
ffffffffc0202374:	4505                	li	a0,1
ffffffffc0202376:	6f9c                	ld	a5,24(a5)
ffffffffc0202378:	9782                	jalr	a5
ffffffffc020237a:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020237c:	00093503          	ld	a0,0(s2)
ffffffffc0202380:	4681                	li	a3,0
ffffffffc0202382:	4601                	li	a2,0
ffffffffc0202384:	85d2                	mv	a1,s4
ffffffffc0202386:	d67ff0ef          	jal	ffffffffc02020ec <page_insert>
ffffffffc020238a:	280511e3          	bnez	a0,ffffffffc0202e0c <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020238e:	00093503          	ld	a0,0(s2)
ffffffffc0202392:	4601                	li	a2,0
ffffffffc0202394:	4581                	li	a1,0
ffffffffc0202396:	a09ff0ef          	jal	ffffffffc0201d9e <get_pte>
ffffffffc020239a:	240509e3          	beqz	a0,ffffffffc0202dec <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc020239e:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02023a0:	0017f713          	andi	a4,a5,1
ffffffffc02023a4:	58070f63          	beqz	a4,ffffffffc0202942 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02023a8:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02023aa:	078a                	slli	a5,a5,0x2
ffffffffc02023ac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02023ae:	58e7f863          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02023b2:	000bb683          	ld	a3,0(s7)
ffffffffc02023b6:	079a                	slli	a5,a5,0x6
ffffffffc02023b8:	fe000637          	lui	a2,0xfe000
ffffffffc02023bc:	97b2                	add	a5,a5,a2
ffffffffc02023be:	97b6                	add	a5,a5,a3
ffffffffc02023c0:	14fa1ae3          	bne	s4,a5,ffffffffc0202d14 <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc02023c4:	000a2683          	lw	a3,0(s4)
ffffffffc02023c8:	4785                	li	a5,1
ffffffffc02023ca:	12f695e3          	bne	a3,a5,ffffffffc0202cf4 <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02023ce:	00093503          	ld	a0,0(s2)
ffffffffc02023d2:	77fd                	lui	a5,0xfffff
ffffffffc02023d4:	6114                	ld	a3,0(a0)
ffffffffc02023d6:	068a                	slli	a3,a3,0x2
ffffffffc02023d8:	8efd                	and	a3,a3,a5
ffffffffc02023da:	00c6d613          	srli	a2,a3,0xc
ffffffffc02023de:	0ee67fe3          	bgeu	a2,a4,ffffffffc0202cdc <pmm_init+0xafa>
ffffffffc02023e2:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02023e6:	96e2                	add	a3,a3,s8
ffffffffc02023e8:	0006ba83          	ld	s5,0(a3)
ffffffffc02023ec:	0a8a                	slli	s5,s5,0x2
ffffffffc02023ee:	00fafab3          	and	s5,s5,a5
ffffffffc02023f2:	00cad793          	srli	a5,s5,0xc
ffffffffc02023f6:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0202cc2 <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02023fa:	4601                	li	a2,0
ffffffffc02023fc:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02023fe:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202400:	99fff0ef          	jal	ffffffffc0201d9e <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202404:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202406:	05851ee3          	bne	a0,s8,ffffffffc0202c62 <pmm_init+0xa80>
ffffffffc020240a:	100027f3          	csrr	a5,sstatus
ffffffffc020240e:	8b89                	andi	a5,a5,2
ffffffffc0202410:	3e079b63          	bnez	a5,ffffffffc0202806 <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202414:	000b3783          	ld	a5,0(s6)
ffffffffc0202418:	4505                	li	a0,1
ffffffffc020241a:	6f9c                	ld	a5,24(a5)
ffffffffc020241c:	9782                	jalr	a5
ffffffffc020241e:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202420:	00093503          	ld	a0,0(s2)
ffffffffc0202424:	46d1                	li	a3,20
ffffffffc0202426:	6605                	lui	a2,0x1
ffffffffc0202428:	85e2                	mv	a1,s8
ffffffffc020242a:	cc3ff0ef          	jal	ffffffffc02020ec <page_insert>
ffffffffc020242e:	06051ae3          	bnez	a0,ffffffffc0202ca2 <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202432:	00093503          	ld	a0,0(s2)
ffffffffc0202436:	4601                	li	a2,0
ffffffffc0202438:	6585                	lui	a1,0x1
ffffffffc020243a:	965ff0ef          	jal	ffffffffc0201d9e <get_pte>
ffffffffc020243e:	040502e3          	beqz	a0,ffffffffc0202c82 <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202442:	611c                	ld	a5,0(a0)
ffffffffc0202444:	0107f713          	andi	a4,a5,16
ffffffffc0202448:	7e070163          	beqz	a4,ffffffffc0202c2a <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc020244c:	8b91                	andi	a5,a5,4
ffffffffc020244e:	7a078e63          	beqz	a5,ffffffffc0202c0a <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202452:	00093503          	ld	a0,0(s2)
ffffffffc0202456:	611c                	ld	a5,0(a0)
ffffffffc0202458:	8bc1                	andi	a5,a5,16
ffffffffc020245a:	78078863          	beqz	a5,ffffffffc0202bea <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc020245e:	000c2703          	lw	a4,0(s8)
ffffffffc0202462:	4785                	li	a5,1
ffffffffc0202464:	76f71363          	bne	a4,a5,ffffffffc0202bca <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202468:	4681                	li	a3,0
ffffffffc020246a:	6605                	lui	a2,0x1
ffffffffc020246c:	85d2                	mv	a1,s4
ffffffffc020246e:	c7fff0ef          	jal	ffffffffc02020ec <page_insert>
ffffffffc0202472:	72051c63          	bnez	a0,ffffffffc0202baa <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202476:	000a2703          	lw	a4,0(s4)
ffffffffc020247a:	4789                	li	a5,2
ffffffffc020247c:	70f71763          	bne	a4,a5,ffffffffc0202b8a <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202480:	000c2783          	lw	a5,0(s8)
ffffffffc0202484:	6e079363          	bnez	a5,ffffffffc0202b6a <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202488:	00093503          	ld	a0,0(s2)
ffffffffc020248c:	4601                	li	a2,0
ffffffffc020248e:	6585                	lui	a1,0x1
ffffffffc0202490:	90fff0ef          	jal	ffffffffc0201d9e <get_pte>
ffffffffc0202494:	6a050b63          	beqz	a0,ffffffffc0202b4a <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202498:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc020249a:	00177793          	andi	a5,a4,1
ffffffffc020249e:	4a078263          	beqz	a5,ffffffffc0202942 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02024a2:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02024a4:	00271793          	slli	a5,a4,0x2
ffffffffc02024a8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024aa:	48d7fa63          	bgeu	a5,a3,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ae:	000bb683          	ld	a3,0(s7)
ffffffffc02024b2:	fff80ab7          	lui	s5,0xfff80
ffffffffc02024b6:	97d6                	add	a5,a5,s5
ffffffffc02024b8:	079a                	slli	a5,a5,0x6
ffffffffc02024ba:	97b6                	add	a5,a5,a3
ffffffffc02024bc:	66fa1763          	bne	s4,a5,ffffffffc0202b2a <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc02024c0:	8b41                	andi	a4,a4,16
ffffffffc02024c2:	64071463          	bnez	a4,ffffffffc0202b0a <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc02024c6:	00093503          	ld	a0,0(s2)
ffffffffc02024ca:	4581                	li	a1,0
ffffffffc02024cc:	b85ff0ef          	jal	ffffffffc0202050 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02024d0:	000a2c83          	lw	s9,0(s4)
ffffffffc02024d4:	4785                	li	a5,1
ffffffffc02024d6:	60fc9a63          	bne	s9,a5,ffffffffc0202aea <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc02024da:	000c2783          	lw	a5,0(s8)
ffffffffc02024de:	5e079663          	bnez	a5,ffffffffc0202aca <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc02024e2:	00093503          	ld	a0,0(s2)
ffffffffc02024e6:	6585                	lui	a1,0x1
ffffffffc02024e8:	b69ff0ef          	jal	ffffffffc0202050 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02024ec:	000a2783          	lw	a5,0(s4)
ffffffffc02024f0:	52079d63          	bnez	a5,ffffffffc0202a2a <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc02024f4:	000c2783          	lw	a5,0(s8)
ffffffffc02024f8:	50079963          	bnez	a5,ffffffffc0202a0a <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02024fc:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202500:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202502:	000a3783          	ld	a5,0(s4)
ffffffffc0202506:	078a                	slli	a5,a5,0x2
ffffffffc0202508:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020250a:	42e7fa63          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020250e:	000bb503          	ld	a0,0(s7)
ffffffffc0202512:	97d6                	add	a5,a5,s5
ffffffffc0202514:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202516:	00f506b3          	add	a3,a0,a5
ffffffffc020251a:	4294                	lw	a3,0(a3)
ffffffffc020251c:	4d969763          	bne	a3,s9,ffffffffc02029ea <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202520:	8799                	srai	a5,a5,0x6
ffffffffc0202522:	00080637          	lui	a2,0x80
ffffffffc0202526:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202528:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020252c:	4ae7f363          	bgeu	a5,a4,ffffffffc02029d2 <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202530:	0009b783          	ld	a5,0(s3)
ffffffffc0202534:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202536:	639c                	ld	a5,0(a5)
ffffffffc0202538:	078a                	slli	a5,a5,0x2
ffffffffc020253a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020253c:	40e7f163          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202540:	8f91                	sub	a5,a5,a2
ffffffffc0202542:	079a                	slli	a5,a5,0x6
ffffffffc0202544:	953e                	add	a0,a0,a5
ffffffffc0202546:	100027f3          	csrr	a5,sstatus
ffffffffc020254a:	8b89                	andi	a5,a5,2
ffffffffc020254c:	30079863          	bnez	a5,ffffffffc020285c <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202550:	000b3783          	ld	a5,0(s6)
ffffffffc0202554:	4585                	li	a1,1
ffffffffc0202556:	739c                	ld	a5,32(a5)
ffffffffc0202558:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020255a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc020255e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202560:	078a                	slli	a5,a5,0x2
ffffffffc0202562:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202564:	3ce7fd63          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202568:	000bb503          	ld	a0,0(s7)
ffffffffc020256c:	fe000737          	lui	a4,0xfe000
ffffffffc0202570:	079a                	slli	a5,a5,0x6
ffffffffc0202572:	97ba                	add	a5,a5,a4
ffffffffc0202574:	953e                	add	a0,a0,a5
ffffffffc0202576:	100027f3          	csrr	a5,sstatus
ffffffffc020257a:	8b89                	andi	a5,a5,2
ffffffffc020257c:	2c079463          	bnez	a5,ffffffffc0202844 <pmm_init+0x662>
ffffffffc0202580:	000b3783          	ld	a5,0(s6)
ffffffffc0202584:	4585                	li	a1,1
ffffffffc0202586:	739c                	ld	a5,32(a5)
ffffffffc0202588:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020258a:	00093783          	ld	a5,0(s2)
ffffffffc020258e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b10>
    asm volatile("sfence.vma");
ffffffffc0202592:	12000073          	sfence.vma
ffffffffc0202596:	100027f3          	csrr	a5,sstatus
ffffffffc020259a:	8b89                	andi	a5,a5,2
ffffffffc020259c:	28079a63          	bnez	a5,ffffffffc0202830 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc02025a0:	000b3783          	ld	a5,0(s6)
ffffffffc02025a4:	779c                	ld	a5,40(a5)
ffffffffc02025a6:	9782                	jalr	a5
ffffffffc02025a8:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02025aa:	4d441063          	bne	s0,s4,ffffffffc0202a6a <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02025ae:	00003517          	auipc	a0,0x3
ffffffffc02025b2:	c2250513          	addi	a0,a0,-990 # ffffffffc02051d0 <etext+0x12ca>
ffffffffc02025b6:	bdffd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02025ba:	100027f3          	csrr	a5,sstatus
ffffffffc02025be:	8b89                	andi	a5,a5,2
ffffffffc02025c0:	24079e63          	bnez	a5,ffffffffc020281c <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc02025c4:	000b3783          	ld	a5,0(s6)
ffffffffc02025c8:	779c                	ld	a5,40(a5)
ffffffffc02025ca:	9782                	jalr	a5
ffffffffc02025cc:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02025ce:	609c                	ld	a5,0(s1)
ffffffffc02025d0:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02025d4:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02025d6:	00c79713          	slli	a4,a5,0xc
ffffffffc02025da:	6a85                	lui	s5,0x1
ffffffffc02025dc:	02e47c63          	bgeu	s0,a4,ffffffffc0202614 <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02025e0:	00c45713          	srli	a4,s0,0xc
ffffffffc02025e4:	30f77063          	bgeu	a4,a5,ffffffffc02028e4 <pmm_init+0x702>
ffffffffc02025e8:	0009b583          	ld	a1,0(s3)
ffffffffc02025ec:	00093503          	ld	a0,0(s2)
ffffffffc02025f0:	4601                	li	a2,0
ffffffffc02025f2:	95a2                	add	a1,a1,s0
ffffffffc02025f4:	faaff0ef          	jal	ffffffffc0201d9e <get_pte>
ffffffffc02025f8:	32050363          	beqz	a0,ffffffffc020291e <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02025fc:	611c                	ld	a5,0(a0)
ffffffffc02025fe:	078a                	slli	a5,a5,0x2
ffffffffc0202600:	0147f7b3          	and	a5,a5,s4
ffffffffc0202604:	2e879d63          	bne	a5,s0,ffffffffc02028fe <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202608:	609c                	ld	a5,0(s1)
ffffffffc020260a:	9456                	add	s0,s0,s5
ffffffffc020260c:	00c79713          	slli	a4,a5,0xc
ffffffffc0202610:	fce468e3          	bltu	s0,a4,ffffffffc02025e0 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202614:	00093783          	ld	a5,0(s2)
ffffffffc0202618:	639c                	ld	a5,0(a5)
ffffffffc020261a:	42079863          	bnez	a5,ffffffffc0202a4a <pmm_init+0x868>
ffffffffc020261e:	100027f3          	csrr	a5,sstatus
ffffffffc0202622:	8b89                	andi	a5,a5,2
ffffffffc0202624:	24079863          	bnez	a5,ffffffffc0202874 <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202628:	000b3783          	ld	a5,0(s6)
ffffffffc020262c:	4505                	li	a0,1
ffffffffc020262e:	6f9c                	ld	a5,24(a5)
ffffffffc0202630:	9782                	jalr	a5
ffffffffc0202632:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202634:	00093503          	ld	a0,0(s2)
ffffffffc0202638:	4699                	li	a3,6
ffffffffc020263a:	10000613          	li	a2,256
ffffffffc020263e:	85a2                	mv	a1,s0
ffffffffc0202640:	aadff0ef          	jal	ffffffffc02020ec <page_insert>
ffffffffc0202644:	46051363          	bnez	a0,ffffffffc0202aaa <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202648:	4018                	lw	a4,0(s0)
ffffffffc020264a:	4785                	li	a5,1
ffffffffc020264c:	42f71f63          	bne	a4,a5,ffffffffc0202a8a <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202650:	00093503          	ld	a0,0(s2)
ffffffffc0202654:	6605                	lui	a2,0x1
ffffffffc0202656:	10060613          	addi	a2,a2,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc020265a:	4699                	li	a3,6
ffffffffc020265c:	85a2                	mv	a1,s0
ffffffffc020265e:	a8fff0ef          	jal	ffffffffc02020ec <page_insert>
ffffffffc0202662:	72051963          	bnez	a0,ffffffffc0202d94 <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202666:	4018                	lw	a4,0(s0)
ffffffffc0202668:	4789                	li	a5,2
ffffffffc020266a:	70f71563          	bne	a4,a5,ffffffffc0202d74 <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc020266e:	00003597          	auipc	a1,0x3
ffffffffc0202672:	caa58593          	addi	a1,a1,-854 # ffffffffc0205318 <etext+0x1412>
ffffffffc0202676:	10000513          	li	a0,256
ffffffffc020267a:	7be010ef          	jal	ffffffffc0203e38 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020267e:	6585                	lui	a1,0x1
ffffffffc0202680:	10058593          	addi	a1,a1,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0202684:	10000513          	li	a0,256
ffffffffc0202688:	7c2010ef          	jal	ffffffffc0203e4a <strcmp>
ffffffffc020268c:	6c051463          	bnez	a0,ffffffffc0202d54 <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202690:	000bb683          	ld	a3,0(s7)
ffffffffc0202694:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202698:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc020269a:	40d406b3          	sub	a3,s0,a3
ffffffffc020269e:	8699                	srai	a3,a3,0x6
ffffffffc02026a0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02026a2:	00c69793          	slli	a5,a3,0xc
ffffffffc02026a6:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02026a8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02026aa:	32e7f463          	bgeu	a5,a4,ffffffffc02029d2 <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02026ae:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02026b2:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02026b6:	97b6                	add	a5,a5,a3
ffffffffc02026b8:	10078023          	sb	zero,256(a5) # 80100 <kern_entry-0xffffffffc017ff00>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02026bc:	748010ef          	jal	ffffffffc0203e04 <strlen>
ffffffffc02026c0:	66051a63          	bnez	a0,ffffffffc0202d34 <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc02026c4:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02026c8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02026ca:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fdf1b10>
ffffffffc02026ce:	078a                	slli	a5,a5,0x2
ffffffffc02026d0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026d2:	26e7f663          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc02026d6:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02026da:	2ee7fc63          	bgeu	a5,a4,ffffffffc02029d2 <pmm_init+0x7f0>
ffffffffc02026de:	0009b783          	ld	a5,0(s3)
ffffffffc02026e2:	00f689b3          	add	s3,a3,a5
ffffffffc02026e6:	100027f3          	csrr	a5,sstatus
ffffffffc02026ea:	8b89                	andi	a5,a5,2
ffffffffc02026ec:	1e079163          	bnez	a5,ffffffffc02028ce <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc02026f0:	000b3783          	ld	a5,0(s6)
ffffffffc02026f4:	8522                	mv	a0,s0
ffffffffc02026f6:	4585                	li	a1,1
ffffffffc02026f8:	739c                	ld	a5,32(a5)
ffffffffc02026fa:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02026fc:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202700:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202702:	078a                	slli	a5,a5,0x2
ffffffffc0202704:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202706:	22e7fc63          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020270a:	000bb503          	ld	a0,0(s7)
ffffffffc020270e:	fe000737          	lui	a4,0xfe000
ffffffffc0202712:	079a                	slli	a5,a5,0x6
ffffffffc0202714:	97ba                	add	a5,a5,a4
ffffffffc0202716:	953e                	add	a0,a0,a5
ffffffffc0202718:	100027f3          	csrr	a5,sstatus
ffffffffc020271c:	8b89                	andi	a5,a5,2
ffffffffc020271e:	18079c63          	bnez	a5,ffffffffc02028b6 <pmm_init+0x6d4>
ffffffffc0202722:	000b3783          	ld	a5,0(s6)
ffffffffc0202726:	4585                	li	a1,1
ffffffffc0202728:	739c                	ld	a5,32(a5)
ffffffffc020272a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020272c:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202730:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202732:	078a                	slli	a5,a5,0x2
ffffffffc0202734:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202736:	20e7f463          	bgeu	a5,a4,ffffffffc020293e <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020273a:	000bb503          	ld	a0,0(s7)
ffffffffc020273e:	fe000737          	lui	a4,0xfe000
ffffffffc0202742:	079a                	slli	a5,a5,0x6
ffffffffc0202744:	97ba                	add	a5,a5,a4
ffffffffc0202746:	953e                	add	a0,a0,a5
ffffffffc0202748:	100027f3          	csrr	a5,sstatus
ffffffffc020274c:	8b89                	andi	a5,a5,2
ffffffffc020274e:	14079863          	bnez	a5,ffffffffc020289e <pmm_init+0x6bc>
ffffffffc0202752:	000b3783          	ld	a5,0(s6)
ffffffffc0202756:	4585                	li	a1,1
ffffffffc0202758:	739c                	ld	a5,32(a5)
ffffffffc020275a:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020275c:	00093783          	ld	a5,0(s2)
ffffffffc0202760:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202764:	12000073          	sfence.vma
ffffffffc0202768:	100027f3          	csrr	a5,sstatus
ffffffffc020276c:	8b89                	andi	a5,a5,2
ffffffffc020276e:	10079e63          	bnez	a5,ffffffffc020288a <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202772:	000b3783          	ld	a5,0(s6)
ffffffffc0202776:	779c                	ld	a5,40(a5)
ffffffffc0202778:	9782                	jalr	a5
ffffffffc020277a:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020277c:	1e8c1b63          	bne	s8,s0,ffffffffc0202972 <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202780:	00003517          	auipc	a0,0x3
ffffffffc0202784:	c1050513          	addi	a0,a0,-1008 # ffffffffc0205390 <etext+0x148a>
ffffffffc0202788:	a0dfd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc020278c:	7406                	ld	s0,96(sp)
ffffffffc020278e:	70a6                	ld	ra,104(sp)
ffffffffc0202790:	64e6                	ld	s1,88(sp)
ffffffffc0202792:	6946                	ld	s2,80(sp)
ffffffffc0202794:	69a6                	ld	s3,72(sp)
ffffffffc0202796:	6a06                	ld	s4,64(sp)
ffffffffc0202798:	7ae2                	ld	s5,56(sp)
ffffffffc020279a:	7b42                	ld	s6,48(sp)
ffffffffc020279c:	7ba2                	ld	s7,40(sp)
ffffffffc020279e:	7c02                	ld	s8,32(sp)
ffffffffc02027a0:	6ce2                	ld	s9,24(sp)
ffffffffc02027a2:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc02027a4:	b70ff06f          	j	ffffffffc0201b14 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc02027a8:	853e                	mv	a0,a5
ffffffffc02027aa:	b4e1                	j	ffffffffc0202272 <pmm_init+0x90>
        intr_disable();
ffffffffc02027ac:	8c8fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027b0:	000b3783          	ld	a5,0(s6)
ffffffffc02027b4:	4505                	li	a0,1
ffffffffc02027b6:	6f9c                	ld	a5,24(a5)
ffffffffc02027b8:	9782                	jalr	a5
ffffffffc02027ba:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02027bc:	8b2fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027c0:	be75                	j	ffffffffc020237c <pmm_init+0x19a>
        intr_disable();
ffffffffc02027c2:	8b2fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027c6:	000b3783          	ld	a5,0(s6)
ffffffffc02027ca:	779c                	ld	a5,40(a5)
ffffffffc02027cc:	9782                	jalr	a5
ffffffffc02027ce:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02027d0:	89efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027d4:	b6ad                	j	ffffffffc020233e <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02027d6:	6705                	lui	a4,0x1
ffffffffc02027d8:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc02027da:	96ba                	add	a3,a3,a4
ffffffffc02027dc:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc02027de:	00c7d713          	srli	a4,a5,0xc
ffffffffc02027e2:	14a77e63          	bgeu	a4,a0,ffffffffc020293e <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc02027e6:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02027ea:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc02027ec:	071a                	slli	a4,a4,0x6
ffffffffc02027ee:	fe0007b7          	lui	a5,0xfe000
ffffffffc02027f2:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc02027f4:	6a9c                	ld	a5,16(a3)
ffffffffc02027f6:	00c45593          	srli	a1,s0,0xc
ffffffffc02027fa:	00e60533          	add	a0,a2,a4
ffffffffc02027fe:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202800:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202804:	bcf1                	j	ffffffffc02022e0 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202806:	86efe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020280a:	000b3783          	ld	a5,0(s6)
ffffffffc020280e:	4505                	li	a0,1
ffffffffc0202810:	6f9c                	ld	a5,24(a5)
ffffffffc0202812:	9782                	jalr	a5
ffffffffc0202814:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202816:	858fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020281a:	b119                	j	ffffffffc0202420 <pmm_init+0x23e>
        intr_disable();
ffffffffc020281c:	858fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202820:	000b3783          	ld	a5,0(s6)
ffffffffc0202824:	779c                	ld	a5,40(a5)
ffffffffc0202826:	9782                	jalr	a5
ffffffffc0202828:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020282a:	844fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020282e:	b345                	j	ffffffffc02025ce <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202830:	844fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202834:	000b3783          	ld	a5,0(s6)
ffffffffc0202838:	779c                	ld	a5,40(a5)
ffffffffc020283a:	9782                	jalr	a5
ffffffffc020283c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020283e:	830fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202842:	b3a5                	j	ffffffffc02025aa <pmm_init+0x3c8>
ffffffffc0202844:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202846:	82efe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020284a:	000b3783          	ld	a5,0(s6)
ffffffffc020284e:	6522                	ld	a0,8(sp)
ffffffffc0202850:	4585                	li	a1,1
ffffffffc0202852:	739c                	ld	a5,32(a5)
ffffffffc0202854:	9782                	jalr	a5
        intr_enable();
ffffffffc0202856:	818fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020285a:	bb05                	j	ffffffffc020258a <pmm_init+0x3a8>
ffffffffc020285c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020285e:	816fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202862:	000b3783          	ld	a5,0(s6)
ffffffffc0202866:	6522                	ld	a0,8(sp)
ffffffffc0202868:	4585                	li	a1,1
ffffffffc020286a:	739c                	ld	a5,32(a5)
ffffffffc020286c:	9782                	jalr	a5
        intr_enable();
ffffffffc020286e:	800fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202872:	b1e5                	j	ffffffffc020255a <pmm_init+0x378>
        intr_disable();
ffffffffc0202874:	800fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202878:	000b3783          	ld	a5,0(s6)
ffffffffc020287c:	4505                	li	a0,1
ffffffffc020287e:	6f9c                	ld	a5,24(a5)
ffffffffc0202880:	9782                	jalr	a5
ffffffffc0202882:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202884:	febfd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202888:	b375                	j	ffffffffc0202634 <pmm_init+0x452>
        intr_disable();
ffffffffc020288a:	febfd0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020288e:	000b3783          	ld	a5,0(s6)
ffffffffc0202892:	779c                	ld	a5,40(a5)
ffffffffc0202894:	9782                	jalr	a5
ffffffffc0202896:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202898:	fd7fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020289c:	b5c5                	j	ffffffffc020277c <pmm_init+0x59a>
ffffffffc020289e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02028a0:	fd5fd0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028a4:	000b3783          	ld	a5,0(s6)
ffffffffc02028a8:	6522                	ld	a0,8(sp)
ffffffffc02028aa:	4585                	li	a1,1
ffffffffc02028ac:	739c                	ld	a5,32(a5)
ffffffffc02028ae:	9782                	jalr	a5
        intr_enable();
ffffffffc02028b0:	fbffd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028b4:	b565                	j	ffffffffc020275c <pmm_init+0x57a>
ffffffffc02028b6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02028b8:	fbdfd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02028bc:	000b3783          	ld	a5,0(s6)
ffffffffc02028c0:	6522                	ld	a0,8(sp)
ffffffffc02028c2:	4585                	li	a1,1
ffffffffc02028c4:	739c                	ld	a5,32(a5)
ffffffffc02028c6:	9782                	jalr	a5
        intr_enable();
ffffffffc02028c8:	fa7fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028cc:	b585                	j	ffffffffc020272c <pmm_init+0x54a>
        intr_disable();
ffffffffc02028ce:	fa7fd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02028d2:	000b3783          	ld	a5,0(s6)
ffffffffc02028d6:	8522                	mv	a0,s0
ffffffffc02028d8:	4585                	li	a1,1
ffffffffc02028da:	739c                	ld	a5,32(a5)
ffffffffc02028dc:	9782                	jalr	a5
        intr_enable();
ffffffffc02028de:	f91fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028e2:	bd29                	j	ffffffffc02026fc <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02028e4:	86a2                	mv	a3,s0
ffffffffc02028e6:	00002617          	auipc	a2,0x2
ffffffffc02028ea:	40a60613          	addi	a2,a2,1034 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc02028ee:	1a400593          	li	a1,420
ffffffffc02028f2:	00002517          	auipc	a0,0x2
ffffffffc02028f6:	4ee50513          	addi	a0,a0,1262 # ffffffffc0204de0 <etext+0xeda>
ffffffffc02028fa:	b0dfd0ef          	jal	ffffffffc0200406 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02028fe:	00003697          	auipc	a3,0x3
ffffffffc0202902:	93268693          	addi	a3,a3,-1742 # ffffffffc0205230 <etext+0x132a>
ffffffffc0202906:	00002617          	auipc	a2,0x2
ffffffffc020290a:	03a60613          	addi	a2,a2,58 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020290e:	1a500593          	li	a1,421
ffffffffc0202912:	00002517          	auipc	a0,0x2
ffffffffc0202916:	4ce50513          	addi	a0,a0,1230 # ffffffffc0204de0 <etext+0xeda>
ffffffffc020291a:	aedfd0ef          	jal	ffffffffc0200406 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020291e:	00003697          	auipc	a3,0x3
ffffffffc0202922:	8d268693          	addi	a3,a3,-1838 # ffffffffc02051f0 <etext+0x12ea>
ffffffffc0202926:	00002617          	auipc	a2,0x2
ffffffffc020292a:	01a60613          	addi	a2,a2,26 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020292e:	1a400593          	li	a1,420
ffffffffc0202932:	00002517          	auipc	a0,0x2
ffffffffc0202936:	4ae50513          	addi	a0,a0,1198 # ffffffffc0204de0 <etext+0xeda>
ffffffffc020293a:	acdfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020293e:	b9cff0ef          	jal	ffffffffc0201cda <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202942:	00002617          	auipc	a2,0x2
ffffffffc0202946:	64e60613          	addi	a2,a2,1614 # ffffffffc0204f90 <etext+0x108a>
ffffffffc020294a:	07f00593          	li	a1,127
ffffffffc020294e:	00002517          	auipc	a0,0x2
ffffffffc0202952:	3ca50513          	addi	a0,a0,970 # ffffffffc0204d18 <etext+0xe12>
ffffffffc0202956:	ab1fd0ef          	jal	ffffffffc0200406 <__panic>
        panic("DTB memory info not available");
ffffffffc020295a:	00002617          	auipc	a2,0x2
ffffffffc020295e:	4ae60613          	addi	a2,a2,1198 # ffffffffc0204e08 <etext+0xf02>
ffffffffc0202962:	06400593          	li	a1,100
ffffffffc0202966:	00002517          	auipc	a0,0x2
ffffffffc020296a:	47a50513          	addi	a0,a0,1146 # ffffffffc0204de0 <etext+0xeda>
ffffffffc020296e:	a99fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202972:	00003697          	auipc	a3,0x3
ffffffffc0202976:	83668693          	addi	a3,a3,-1994 # ffffffffc02051a8 <etext+0x12a2>
ffffffffc020297a:	00002617          	auipc	a2,0x2
ffffffffc020297e:	fc660613          	addi	a2,a2,-58 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202982:	1bf00593          	li	a1,447
ffffffffc0202986:	00002517          	auipc	a0,0x2
ffffffffc020298a:	45a50513          	addi	a0,a0,1114 # ffffffffc0204de0 <etext+0xeda>
ffffffffc020298e:	a79fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202992:	00002697          	auipc	a3,0x2
ffffffffc0202996:	52e68693          	addi	a3,a3,1326 # ffffffffc0204ec0 <etext+0xfba>
ffffffffc020299a:	00002617          	auipc	a2,0x2
ffffffffc020299e:	fa660613          	addi	a2,a2,-90 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02029a2:	16600593          	li	a1,358
ffffffffc02029a6:	00002517          	auipc	a0,0x2
ffffffffc02029aa:	43a50513          	addi	a0,a0,1082 # ffffffffc0204de0 <etext+0xeda>
ffffffffc02029ae:	a59fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02029b2:	00002697          	auipc	a3,0x2
ffffffffc02029b6:	4ee68693          	addi	a3,a3,1262 # ffffffffc0204ea0 <etext+0xf9a>
ffffffffc02029ba:	00002617          	auipc	a2,0x2
ffffffffc02029be:	f8660613          	addi	a2,a2,-122 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02029c2:	16500593          	li	a1,357
ffffffffc02029c6:	00002517          	auipc	a0,0x2
ffffffffc02029ca:	41a50513          	addi	a0,a0,1050 # ffffffffc0204de0 <etext+0xeda>
ffffffffc02029ce:	a39fd0ef          	jal	ffffffffc0200406 <__panic>
    return KADDR(page2pa(page));
ffffffffc02029d2:	00002617          	auipc	a2,0x2
ffffffffc02029d6:	31e60613          	addi	a2,a2,798 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc02029da:	07100593          	li	a1,113
ffffffffc02029de:	00002517          	auipc	a0,0x2
ffffffffc02029e2:	33a50513          	addi	a0,a0,826 # ffffffffc0204d18 <etext+0xe12>
ffffffffc02029e6:	a21fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02029ea:	00002697          	auipc	a3,0x2
ffffffffc02029ee:	78e68693          	addi	a3,a3,1934 # ffffffffc0205178 <etext+0x1272>
ffffffffc02029f2:	00002617          	auipc	a2,0x2
ffffffffc02029f6:	f4e60613          	addi	a2,a2,-178 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02029fa:	18d00593          	li	a1,397
ffffffffc02029fe:	00002517          	auipc	a0,0x2
ffffffffc0202a02:	3e250513          	addi	a0,a0,994 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202a06:	a01fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202a0a:	00002697          	auipc	a3,0x2
ffffffffc0202a0e:	72668693          	addi	a3,a3,1830 # ffffffffc0205130 <etext+0x122a>
ffffffffc0202a12:	00002617          	auipc	a2,0x2
ffffffffc0202a16:	f2e60613          	addi	a2,a2,-210 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202a1a:	18b00593          	li	a1,395
ffffffffc0202a1e:	00002517          	auipc	a0,0x2
ffffffffc0202a22:	3c250513          	addi	a0,a0,962 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202a26:	9e1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202a2a:	00002697          	auipc	a3,0x2
ffffffffc0202a2e:	73668693          	addi	a3,a3,1846 # ffffffffc0205160 <etext+0x125a>
ffffffffc0202a32:	00002617          	auipc	a2,0x2
ffffffffc0202a36:	f0e60613          	addi	a2,a2,-242 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202a3a:	18a00593          	li	a1,394
ffffffffc0202a3e:	00002517          	auipc	a0,0x2
ffffffffc0202a42:	3a250513          	addi	a0,a0,930 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202a46:	9c1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202a4a:	00002697          	auipc	a3,0x2
ffffffffc0202a4e:	7fe68693          	addi	a3,a3,2046 # ffffffffc0205248 <etext+0x1342>
ffffffffc0202a52:	00002617          	auipc	a2,0x2
ffffffffc0202a56:	eee60613          	addi	a2,a2,-274 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202a5a:	1a800593          	li	a1,424
ffffffffc0202a5e:	00002517          	auipc	a0,0x2
ffffffffc0202a62:	38250513          	addi	a0,a0,898 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202a66:	9a1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202a6a:	00002697          	auipc	a3,0x2
ffffffffc0202a6e:	73e68693          	addi	a3,a3,1854 # ffffffffc02051a8 <etext+0x12a2>
ffffffffc0202a72:	00002617          	auipc	a2,0x2
ffffffffc0202a76:	ece60613          	addi	a2,a2,-306 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202a7a:	19500593          	li	a1,405
ffffffffc0202a7e:	00002517          	auipc	a0,0x2
ffffffffc0202a82:	36250513          	addi	a0,a0,866 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202a86:	981fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202a8a:	00003697          	auipc	a3,0x3
ffffffffc0202a8e:	81668693          	addi	a3,a3,-2026 # ffffffffc02052a0 <etext+0x139a>
ffffffffc0202a92:	00002617          	auipc	a2,0x2
ffffffffc0202a96:	eae60613          	addi	a2,a2,-338 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202a9a:	1ad00593          	li	a1,429
ffffffffc0202a9e:	00002517          	auipc	a0,0x2
ffffffffc0202aa2:	34250513          	addi	a0,a0,834 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202aa6:	961fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202aaa:	00002697          	auipc	a3,0x2
ffffffffc0202aae:	7b668693          	addi	a3,a3,1974 # ffffffffc0205260 <etext+0x135a>
ffffffffc0202ab2:	00002617          	auipc	a2,0x2
ffffffffc0202ab6:	e8e60613          	addi	a2,a2,-370 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202aba:	1ac00593          	li	a1,428
ffffffffc0202abe:	00002517          	auipc	a0,0x2
ffffffffc0202ac2:	32250513          	addi	a0,a0,802 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202ac6:	941fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202aca:	00002697          	auipc	a3,0x2
ffffffffc0202ace:	66668693          	addi	a3,a3,1638 # ffffffffc0205130 <etext+0x122a>
ffffffffc0202ad2:	00002617          	auipc	a2,0x2
ffffffffc0202ad6:	e6e60613          	addi	a2,a2,-402 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202ada:	18700593          	li	a1,391
ffffffffc0202ade:	00002517          	auipc	a0,0x2
ffffffffc0202ae2:	30250513          	addi	a0,a0,770 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202ae6:	921fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202aea:	00002697          	auipc	a3,0x2
ffffffffc0202aee:	4e668693          	addi	a3,a3,1254 # ffffffffc0204fd0 <etext+0x10ca>
ffffffffc0202af2:	00002617          	auipc	a2,0x2
ffffffffc0202af6:	e4e60613          	addi	a2,a2,-434 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202afa:	18600593          	li	a1,390
ffffffffc0202afe:	00002517          	auipc	a0,0x2
ffffffffc0202b02:	2e250513          	addi	a0,a0,738 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202b06:	901fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202b0a:	00002697          	auipc	a3,0x2
ffffffffc0202b0e:	63e68693          	addi	a3,a3,1598 # ffffffffc0205148 <etext+0x1242>
ffffffffc0202b12:	00002617          	auipc	a2,0x2
ffffffffc0202b16:	e2e60613          	addi	a2,a2,-466 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202b1a:	18300593          	li	a1,387
ffffffffc0202b1e:	00002517          	auipc	a0,0x2
ffffffffc0202b22:	2c250513          	addi	a0,a0,706 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202b26:	8e1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202b2a:	00002697          	auipc	a3,0x2
ffffffffc0202b2e:	48e68693          	addi	a3,a3,1166 # ffffffffc0204fb8 <etext+0x10b2>
ffffffffc0202b32:	00002617          	auipc	a2,0x2
ffffffffc0202b36:	e0e60613          	addi	a2,a2,-498 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202b3a:	18200593          	li	a1,386
ffffffffc0202b3e:	00002517          	auipc	a0,0x2
ffffffffc0202b42:	2a250513          	addi	a0,a0,674 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202b46:	8c1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b4a:	00002697          	auipc	a3,0x2
ffffffffc0202b4e:	50e68693          	addi	a3,a3,1294 # ffffffffc0205058 <etext+0x1152>
ffffffffc0202b52:	00002617          	auipc	a2,0x2
ffffffffc0202b56:	dee60613          	addi	a2,a2,-530 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202b5a:	18100593          	li	a1,385
ffffffffc0202b5e:	00002517          	auipc	a0,0x2
ffffffffc0202b62:	28250513          	addi	a0,a0,642 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202b66:	8a1fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202b6a:	00002697          	auipc	a3,0x2
ffffffffc0202b6e:	5c668693          	addi	a3,a3,1478 # ffffffffc0205130 <etext+0x122a>
ffffffffc0202b72:	00002617          	auipc	a2,0x2
ffffffffc0202b76:	dce60613          	addi	a2,a2,-562 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202b7a:	18000593          	li	a1,384
ffffffffc0202b7e:	00002517          	auipc	a0,0x2
ffffffffc0202b82:	26250513          	addi	a0,a0,610 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202b86:	881fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202b8a:	00002697          	auipc	a3,0x2
ffffffffc0202b8e:	58e68693          	addi	a3,a3,1422 # ffffffffc0205118 <etext+0x1212>
ffffffffc0202b92:	00002617          	auipc	a2,0x2
ffffffffc0202b96:	dae60613          	addi	a2,a2,-594 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202b9a:	17f00593          	li	a1,383
ffffffffc0202b9e:	00002517          	auipc	a0,0x2
ffffffffc0202ba2:	24250513          	addi	a0,a0,578 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202ba6:	861fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202baa:	00002697          	auipc	a3,0x2
ffffffffc0202bae:	53e68693          	addi	a3,a3,1342 # ffffffffc02050e8 <etext+0x11e2>
ffffffffc0202bb2:	00002617          	auipc	a2,0x2
ffffffffc0202bb6:	d8e60613          	addi	a2,a2,-626 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202bba:	17e00593          	li	a1,382
ffffffffc0202bbe:	00002517          	auipc	a0,0x2
ffffffffc0202bc2:	22250513          	addi	a0,a0,546 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202bc6:	841fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202bca:	00002697          	auipc	a3,0x2
ffffffffc0202bce:	50668693          	addi	a3,a3,1286 # ffffffffc02050d0 <etext+0x11ca>
ffffffffc0202bd2:	00002617          	auipc	a2,0x2
ffffffffc0202bd6:	d6e60613          	addi	a2,a2,-658 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202bda:	17c00593          	li	a1,380
ffffffffc0202bde:	00002517          	auipc	a0,0x2
ffffffffc0202be2:	20250513          	addi	a0,a0,514 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202be6:	821fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202bea:	00002697          	auipc	a3,0x2
ffffffffc0202bee:	4c668693          	addi	a3,a3,1222 # ffffffffc02050b0 <etext+0x11aa>
ffffffffc0202bf2:	00002617          	auipc	a2,0x2
ffffffffc0202bf6:	d4e60613          	addi	a2,a2,-690 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202bfa:	17b00593          	li	a1,379
ffffffffc0202bfe:	00002517          	auipc	a0,0x2
ffffffffc0202c02:	1e250513          	addi	a0,a0,482 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c06:	801fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202c0a:	00002697          	auipc	a3,0x2
ffffffffc0202c0e:	49668693          	addi	a3,a3,1174 # ffffffffc02050a0 <etext+0x119a>
ffffffffc0202c12:	00002617          	auipc	a2,0x2
ffffffffc0202c16:	d2e60613          	addi	a2,a2,-722 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202c1a:	17a00593          	li	a1,378
ffffffffc0202c1e:	00002517          	auipc	a0,0x2
ffffffffc0202c22:	1c250513          	addi	a0,a0,450 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c26:	fe0fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202c2a:	00002697          	auipc	a3,0x2
ffffffffc0202c2e:	46668693          	addi	a3,a3,1126 # ffffffffc0205090 <etext+0x118a>
ffffffffc0202c32:	00002617          	auipc	a2,0x2
ffffffffc0202c36:	d0e60613          	addi	a2,a2,-754 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202c3a:	17900593          	li	a1,377
ffffffffc0202c3e:	00002517          	auipc	a0,0x2
ffffffffc0202c42:	1a250513          	addi	a0,a0,418 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c46:	fc0fd0ef          	jal	ffffffffc0200406 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202c4a:	00002617          	auipc	a2,0x2
ffffffffc0202c4e:	14e60613          	addi	a2,a2,334 # ffffffffc0204d98 <etext+0xe92>
ffffffffc0202c52:	08000593          	li	a1,128
ffffffffc0202c56:	00002517          	auipc	a0,0x2
ffffffffc0202c5a:	18a50513          	addi	a0,a0,394 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c5e:	fa8fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202c62:	00002697          	auipc	a3,0x2
ffffffffc0202c66:	38668693          	addi	a3,a3,902 # ffffffffc0204fe8 <etext+0x10e2>
ffffffffc0202c6a:	00002617          	auipc	a2,0x2
ffffffffc0202c6e:	cd660613          	addi	a2,a2,-810 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202c72:	17400593          	li	a1,372
ffffffffc0202c76:	00002517          	auipc	a0,0x2
ffffffffc0202c7a:	16a50513          	addi	a0,a0,362 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c7e:	f88fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202c82:	00002697          	auipc	a3,0x2
ffffffffc0202c86:	3d668693          	addi	a3,a3,982 # ffffffffc0205058 <etext+0x1152>
ffffffffc0202c8a:	00002617          	auipc	a2,0x2
ffffffffc0202c8e:	cb660613          	addi	a2,a2,-842 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202c92:	17800593          	li	a1,376
ffffffffc0202c96:	00002517          	auipc	a0,0x2
ffffffffc0202c9a:	14a50513          	addi	a0,a0,330 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202c9e:	f68fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202ca2:	00002697          	auipc	a3,0x2
ffffffffc0202ca6:	37668693          	addi	a3,a3,886 # ffffffffc0205018 <etext+0x1112>
ffffffffc0202caa:	00002617          	auipc	a2,0x2
ffffffffc0202cae:	c9660613          	addi	a2,a2,-874 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202cb2:	17700593          	li	a1,375
ffffffffc0202cb6:	00002517          	auipc	a0,0x2
ffffffffc0202cba:	12a50513          	addi	a0,a0,298 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202cbe:	f48fd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202cc2:	86d6                	mv	a3,s5
ffffffffc0202cc4:	00002617          	auipc	a2,0x2
ffffffffc0202cc8:	02c60613          	addi	a2,a2,44 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0202ccc:	17300593          	li	a1,371
ffffffffc0202cd0:	00002517          	auipc	a0,0x2
ffffffffc0202cd4:	11050513          	addi	a0,a0,272 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202cd8:	f2efd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202cdc:	00002617          	auipc	a2,0x2
ffffffffc0202ce0:	01460613          	addi	a2,a2,20 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0202ce4:	17200593          	li	a1,370
ffffffffc0202ce8:	00002517          	auipc	a0,0x2
ffffffffc0202cec:	0f850513          	addi	a0,a0,248 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202cf0:	f16fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202cf4:	00002697          	auipc	a3,0x2
ffffffffc0202cf8:	2dc68693          	addi	a3,a3,732 # ffffffffc0204fd0 <etext+0x10ca>
ffffffffc0202cfc:	00002617          	auipc	a2,0x2
ffffffffc0202d00:	c4460613          	addi	a2,a2,-956 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202d04:	17000593          	li	a1,368
ffffffffc0202d08:	00002517          	auipc	a0,0x2
ffffffffc0202d0c:	0d850513          	addi	a0,a0,216 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202d10:	ef6fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202d14:	00002697          	auipc	a3,0x2
ffffffffc0202d18:	2a468693          	addi	a3,a3,676 # ffffffffc0204fb8 <etext+0x10b2>
ffffffffc0202d1c:	00002617          	auipc	a2,0x2
ffffffffc0202d20:	c2460613          	addi	a2,a2,-988 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202d24:	16f00593          	li	a1,367
ffffffffc0202d28:	00002517          	auipc	a0,0x2
ffffffffc0202d2c:	0b850513          	addi	a0,a0,184 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202d30:	ed6fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202d34:	00002697          	auipc	a3,0x2
ffffffffc0202d38:	63468693          	addi	a3,a3,1588 # ffffffffc0205368 <etext+0x1462>
ffffffffc0202d3c:	00002617          	auipc	a2,0x2
ffffffffc0202d40:	c0460613          	addi	a2,a2,-1020 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202d44:	1b600593          	li	a1,438
ffffffffc0202d48:	00002517          	auipc	a0,0x2
ffffffffc0202d4c:	09850513          	addi	a0,a0,152 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202d50:	eb6fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202d54:	00002697          	auipc	a3,0x2
ffffffffc0202d58:	5dc68693          	addi	a3,a3,1500 # ffffffffc0205330 <etext+0x142a>
ffffffffc0202d5c:	00002617          	auipc	a2,0x2
ffffffffc0202d60:	be460613          	addi	a2,a2,-1052 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202d64:	1b300593          	li	a1,435
ffffffffc0202d68:	00002517          	auipc	a0,0x2
ffffffffc0202d6c:	07850513          	addi	a0,a0,120 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202d70:	e96fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202d74:	00002697          	auipc	a3,0x2
ffffffffc0202d78:	58c68693          	addi	a3,a3,1420 # ffffffffc0205300 <etext+0x13fa>
ffffffffc0202d7c:	00002617          	auipc	a2,0x2
ffffffffc0202d80:	bc460613          	addi	a2,a2,-1084 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202d84:	1af00593          	li	a1,431
ffffffffc0202d88:	00002517          	auipc	a0,0x2
ffffffffc0202d8c:	05850513          	addi	a0,a0,88 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202d90:	e76fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d94:	00002697          	auipc	a3,0x2
ffffffffc0202d98:	52468693          	addi	a3,a3,1316 # ffffffffc02052b8 <etext+0x13b2>
ffffffffc0202d9c:	00002617          	auipc	a2,0x2
ffffffffc0202da0:	ba460613          	addi	a2,a2,-1116 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202da4:	1ae00593          	li	a1,430
ffffffffc0202da8:	00002517          	auipc	a0,0x2
ffffffffc0202dac:	03850513          	addi	a0,a0,56 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202db0:	e56fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202db4:	00002697          	auipc	a3,0x2
ffffffffc0202db8:	14c68693          	addi	a3,a3,332 # ffffffffc0204f00 <etext+0xffa>
ffffffffc0202dbc:	00002617          	auipc	a2,0x2
ffffffffc0202dc0:	b8460613          	addi	a2,a2,-1148 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202dc4:	16700593          	li	a1,359
ffffffffc0202dc8:	00002517          	auipc	a0,0x2
ffffffffc0202dcc:	01850513          	addi	a0,a0,24 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202dd0:	e36fd0ef          	jal	ffffffffc0200406 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202dd4:	00002617          	auipc	a2,0x2
ffffffffc0202dd8:	fc460613          	addi	a2,a2,-60 # ffffffffc0204d98 <etext+0xe92>
ffffffffc0202ddc:	0cb00593          	li	a1,203
ffffffffc0202de0:	00002517          	auipc	a0,0x2
ffffffffc0202de4:	00050513          	mv	a0,a0
ffffffffc0202de8:	e1efd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202dec:	00002697          	auipc	a3,0x2
ffffffffc0202df0:	17468693          	addi	a3,a3,372 # ffffffffc0204f60 <etext+0x105a>
ffffffffc0202df4:	00002617          	auipc	a2,0x2
ffffffffc0202df8:	b4c60613          	addi	a2,a2,-1204 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202dfc:	16e00593          	li	a1,366
ffffffffc0202e00:	00002517          	auipc	a0,0x2
ffffffffc0202e04:	fe050513          	addi	a0,a0,-32 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202e08:	dfefd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202e0c:	00002697          	auipc	a3,0x2
ffffffffc0202e10:	12468693          	addi	a3,a3,292 # ffffffffc0204f30 <etext+0x102a>
ffffffffc0202e14:	00002617          	auipc	a2,0x2
ffffffffc0202e18:	b2c60613          	addi	a2,a2,-1236 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202e1c:	16b00593          	li	a1,363
ffffffffc0202e20:	00002517          	auipc	a0,0x2
ffffffffc0202e24:	fc050513          	addi	a0,a0,-64 # ffffffffc0204de0 <etext+0xeda>
ffffffffc0202e28:	ddefd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202e2c <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202e2c:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202e2e:	00002697          	auipc	a3,0x2
ffffffffc0202e32:	58268693          	addi	a3,a3,1410 # ffffffffc02053b0 <etext+0x14aa>
ffffffffc0202e36:	00002617          	auipc	a2,0x2
ffffffffc0202e3a:	b0a60613          	addi	a2,a2,-1270 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202e3e:	08800593          	li	a1,136
ffffffffc0202e42:	00002517          	auipc	a0,0x2
ffffffffc0202e46:	58e50513          	addi	a0,a0,1422 # ffffffffc02053d0 <etext+0x14ca>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202e4a:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202e4c:	dbafd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202e50 <find_vma>:
    if (mm != NULL)
ffffffffc0202e50:	c505                	beqz	a0,ffffffffc0202e78 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc0202e52:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202e54:	c781                	beqz	a5,ffffffffc0202e5c <find_vma+0xc>
ffffffffc0202e56:	6798                	ld	a4,8(a5)
ffffffffc0202e58:	02e5f363          	bgeu	a1,a4,ffffffffc0202e7e <find_vma+0x2e>
    return listelm->next;
ffffffffc0202e5c:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc0202e5e:	00f50d63          	beq	a0,a5,ffffffffc0202e78 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0202e62:	fe87b703          	ld	a4,-24(a5) # fffffffffdffffe8 <end+0x3ddf2af8>
ffffffffc0202e66:	00e5e663          	bltu	a1,a4,ffffffffc0202e72 <find_vma+0x22>
ffffffffc0202e6a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202e6e:	00e5ee63          	bltu	a1,a4,ffffffffc0202e8a <find_vma+0x3a>
ffffffffc0202e72:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0202e74:	fef517e3          	bne	a0,a5,ffffffffc0202e62 <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc0202e78:	4781                	li	a5,0
}
ffffffffc0202e7a:	853e                	mv	a0,a5
ffffffffc0202e7c:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202e7e:	6b98                	ld	a4,16(a5)
ffffffffc0202e80:	fce5fee3          	bgeu	a1,a4,ffffffffc0202e5c <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0202e84:	e91c                	sd	a5,16(a0)
}
ffffffffc0202e86:	853e                	mv	a0,a5
ffffffffc0202e88:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0202e8a:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202e8c:	e91c                	sd	a5,16(a0)
ffffffffc0202e8e:	bfe5                	j	ffffffffc0202e86 <find_vma+0x36>

ffffffffc0202e90 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e90:	6590                	ld	a2,8(a1)
ffffffffc0202e92:	0105b803          	ld	a6,16(a1)
{
ffffffffc0202e96:	1141                	addi	sp,sp,-16
ffffffffc0202e98:	e406                	sd	ra,8(sp)
ffffffffc0202e9a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e9c:	01066763          	bltu	a2,a6,ffffffffc0202eaa <insert_vma_struct+0x1a>
ffffffffc0202ea0:	a8b9                	j	ffffffffc0202efe <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202ea2:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202ea6:	04e66763          	bltu	a2,a4,ffffffffc0202ef4 <insert_vma_struct+0x64>
ffffffffc0202eaa:	86be                	mv	a3,a5
ffffffffc0202eac:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0202eae:	fef51ae3          	bne	a0,a5,ffffffffc0202ea2 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0202eb2:	02a68463          	beq	a3,a0,ffffffffc0202eda <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202eb6:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202eba:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202ebe:	08e8f063          	bgeu	a7,a4,ffffffffc0202f3e <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202ec2:	04e66e63          	bltu	a2,a4,ffffffffc0202f1e <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0202ec6:	00f50a63          	beq	a0,a5,ffffffffc0202eda <insert_vma_struct+0x4a>
ffffffffc0202eca:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202ece:	05076863          	bltu	a4,a6,ffffffffc0202f1e <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0202ed2:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202ed6:	02c77263          	bgeu	a4,a2,ffffffffc0202efa <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0202eda:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202edc:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202ede:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202ee2:	e390                	sd	a2,0(a5)
ffffffffc0202ee4:	e690                	sd	a2,8(a3)
}
ffffffffc0202ee6:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202ee8:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202eea:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0202eec:	2705                	addiw	a4,a4,1
ffffffffc0202eee:	d118                	sw	a4,32(a0)
}
ffffffffc0202ef0:	0141                	addi	sp,sp,16
ffffffffc0202ef2:	8082                	ret
    if (le_prev != list)
ffffffffc0202ef4:	fca691e3          	bne	a3,a0,ffffffffc0202eb6 <insert_vma_struct+0x26>
ffffffffc0202ef8:	bfd9                	j	ffffffffc0202ece <insert_vma_struct+0x3e>
ffffffffc0202efa:	f33ff0ef          	jal	ffffffffc0202e2c <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202efe:	00002697          	auipc	a3,0x2
ffffffffc0202f02:	4e268693          	addi	a3,a3,1250 # ffffffffc02053e0 <etext+0x14da>
ffffffffc0202f06:	00002617          	auipc	a2,0x2
ffffffffc0202f0a:	a3a60613          	addi	a2,a2,-1478 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202f0e:	08e00593          	li	a1,142
ffffffffc0202f12:	00002517          	auipc	a0,0x2
ffffffffc0202f16:	4be50513          	addi	a0,a0,1214 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0202f1a:	cecfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202f1e:	00002697          	auipc	a3,0x2
ffffffffc0202f22:	50268693          	addi	a3,a3,1282 # ffffffffc0205420 <etext+0x151a>
ffffffffc0202f26:	00002617          	auipc	a2,0x2
ffffffffc0202f2a:	a1a60613          	addi	a2,a2,-1510 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202f2e:	08700593          	li	a1,135
ffffffffc0202f32:	00002517          	auipc	a0,0x2
ffffffffc0202f36:	49e50513          	addi	a0,a0,1182 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0202f3a:	cccfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202f3e:	00002697          	auipc	a3,0x2
ffffffffc0202f42:	4c268693          	addi	a3,a3,1218 # ffffffffc0205400 <etext+0x14fa>
ffffffffc0202f46:	00002617          	auipc	a2,0x2
ffffffffc0202f4a:	9fa60613          	addi	a2,a2,-1542 # ffffffffc0204940 <etext+0xa3a>
ffffffffc0202f4e:	08600593          	li	a1,134
ffffffffc0202f52:	00002517          	auipc	a0,0x2
ffffffffc0202f56:	47e50513          	addi	a0,a0,1150 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0202f5a:	cacfd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202f5e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202f5e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202f60:	03000513          	li	a0,48
{
ffffffffc0202f64:	fc06                	sd	ra,56(sp)
ffffffffc0202f66:	f822                	sd	s0,48(sp)
ffffffffc0202f68:	f426                	sd	s1,40(sp)
ffffffffc0202f6a:	f04a                	sd	s2,32(sp)
ffffffffc0202f6c:	ec4e                	sd	s3,24(sp)
ffffffffc0202f6e:	e852                	sd	s4,16(sp)
ffffffffc0202f70:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202f72:	bc3fe0ef          	jal	ffffffffc0201b34 <kmalloc>
    if (mm != NULL)
ffffffffc0202f76:	18050a63          	beqz	a0,ffffffffc020310a <vmm_init+0x1ac>
ffffffffc0202f7a:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0202f7c:	e508                	sd	a0,8(a0)
ffffffffc0202f7e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202f80:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202f84:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202f88:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202f8c:	02053423          	sd	zero,40(a0)
ffffffffc0202f90:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f94:	03000513          	li	a0,48
ffffffffc0202f98:	b9dfe0ef          	jal	ffffffffc0201b34 <kmalloc>
    if (vma != NULL)
ffffffffc0202f9c:	14050763          	beqz	a0,ffffffffc02030ea <vmm_init+0x18c>
        vma->vm_end = vm_end;
ffffffffc0202fa0:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0202fa4:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202fa6:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0202faa:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202fac:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0202fae:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0202fb0:	8522                	mv	a0,s0
ffffffffc0202fb2:	edfff0ef          	jal	ffffffffc0202e90 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202fb6:	fcf9                	bnez	s1,ffffffffc0202f94 <vmm_init+0x36>
ffffffffc0202fb8:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202fbc:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202fc0:	03000513          	li	a0,48
ffffffffc0202fc4:	b71fe0ef          	jal	ffffffffc0201b34 <kmalloc>
    if (vma != NULL)
ffffffffc0202fc8:	16050163          	beqz	a0,ffffffffc020312a <vmm_init+0x1cc>
        vma->vm_end = vm_end;
ffffffffc0202fcc:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0202fd0:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202fd2:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0202fd6:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202fd8:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202fda:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0202fdc:	8522                	mv	a0,s0
ffffffffc0202fde:	eb3ff0ef          	jal	ffffffffc0202e90 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202fe2:	fd249fe3          	bne	s1,s2,ffffffffc0202fc0 <vmm_init+0x62>
    return listelm->next;
ffffffffc0202fe6:	641c                	ld	a5,8(s0)
ffffffffc0202fe8:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0202fea:	1fb00593          	li	a1,507
ffffffffc0202fee:	8abe                	mv	s5,a5
    {
        assert(le != &(mm->mmap_list));
ffffffffc0202ff0:	20f40d63          	beq	s0,a5,ffffffffc020320a <vmm_init+0x2ac>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202ff4:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202ff8:	ffe70693          	addi	a3,a4,-2
ffffffffc0202ffc:	14d61763          	bne	a2,a3,ffffffffc020314a <vmm_init+0x1ec>
ffffffffc0203000:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203004:	14e69363          	bne	a3,a4,ffffffffc020314a <vmm_init+0x1ec>
    for (i = 1; i <= step2; i++)
ffffffffc0203008:	0715                	addi	a4,a4,5
ffffffffc020300a:	679c                	ld	a5,8(a5)
ffffffffc020300c:	feb712e3          	bne	a4,a1,ffffffffc0202ff0 <vmm_init+0x92>
ffffffffc0203010:	491d                	li	s2,7
ffffffffc0203012:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203014:	85a6                	mv	a1,s1
ffffffffc0203016:	8522                	mv	a0,s0
ffffffffc0203018:	e39ff0ef          	jal	ffffffffc0202e50 <find_vma>
ffffffffc020301c:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc020301e:	22050663          	beqz	a0,ffffffffc020324a <vmm_init+0x2ec>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203022:	00148593          	addi	a1,s1,1
ffffffffc0203026:	8522                	mv	a0,s0
ffffffffc0203028:	e29ff0ef          	jal	ffffffffc0202e50 <find_vma>
ffffffffc020302c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc020302e:	1e050e63          	beqz	a0,ffffffffc020322a <vmm_init+0x2cc>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203032:	85ca                	mv	a1,s2
ffffffffc0203034:	8522                	mv	a0,s0
ffffffffc0203036:	e1bff0ef          	jal	ffffffffc0202e50 <find_vma>
        assert(vma3 == NULL);
ffffffffc020303a:	1a051863          	bnez	a0,ffffffffc02031ea <vmm_init+0x28c>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc020303e:	00348593          	addi	a1,s1,3
ffffffffc0203042:	8522                	mv	a0,s0
ffffffffc0203044:	e0dff0ef          	jal	ffffffffc0202e50 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203048:	18051163          	bnez	a0,ffffffffc02031ca <vmm_init+0x26c>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc020304c:	00448593          	addi	a1,s1,4
ffffffffc0203050:	8522                	mv	a0,s0
ffffffffc0203052:	dffff0ef          	jal	ffffffffc0202e50 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203056:	14051a63          	bnez	a0,ffffffffc02031aa <vmm_init+0x24c>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020305a:	008a3783          	ld	a5,8(s4)
ffffffffc020305e:	12979663          	bne	a5,s1,ffffffffc020318a <vmm_init+0x22c>
ffffffffc0203062:	010a3783          	ld	a5,16(s4)
ffffffffc0203066:	13279263          	bne	a5,s2,ffffffffc020318a <vmm_init+0x22c>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020306a:	0089b783          	ld	a5,8(s3)
ffffffffc020306e:	0e979e63          	bne	a5,s1,ffffffffc020316a <vmm_init+0x20c>
ffffffffc0203072:	0109b783          	ld	a5,16(s3)
ffffffffc0203076:	0f279a63          	bne	a5,s2,ffffffffc020316a <vmm_init+0x20c>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc020307a:	0495                	addi	s1,s1,5
ffffffffc020307c:	1f900793          	li	a5,505
ffffffffc0203080:	0915                	addi	s2,s2,5
ffffffffc0203082:	f8f499e3          	bne	s1,a5,ffffffffc0203014 <vmm_init+0xb6>
ffffffffc0203086:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203088:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc020308a:	85a6                	mv	a1,s1
ffffffffc020308c:	8522                	mv	a0,s0
ffffffffc020308e:	dc3ff0ef          	jal	ffffffffc0202e50 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203092:	1c051c63          	bnez	a0,ffffffffc020326a <vmm_init+0x30c>
    for (i = 4; i >= 0; i--)
ffffffffc0203096:	14fd                	addi	s1,s1,-1
ffffffffc0203098:	ff2499e3          	bne	s1,s2,ffffffffc020308a <vmm_init+0x12c>
    while ((le = list_next(list)) != list)
ffffffffc020309c:	028a8063          	beq	s5,s0,ffffffffc02030bc <vmm_init+0x15e>
    __list_del(listelm->prev, listelm->next);
ffffffffc02030a0:	008ab783          	ld	a5,8(s5) # 1008 <kern_entry-0xffffffffc01feff8>
ffffffffc02030a4:	000ab703          	ld	a4,0(s5)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02030a8:	fe0a8513          	addi	a0,s5,-32
    prev->next = next;
ffffffffc02030ac:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02030ae:	e398                	sd	a4,0(a5)
ffffffffc02030b0:	b2bfe0ef          	jal	ffffffffc0201bda <kfree>
    return listelm->next;
ffffffffc02030b4:	641c                	ld	a5,8(s0)
ffffffffc02030b6:	8abe                	mv	s5,a5
    while ((le = list_next(list)) != list)
ffffffffc02030b8:	fef414e3          	bne	s0,a5,ffffffffc02030a0 <vmm_init+0x142>
    kfree(mm); // kfree mm
ffffffffc02030bc:	8522                	mv	a0,s0
ffffffffc02030be:	b1dfe0ef          	jal	ffffffffc0201bda <kfree>
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02030c2:	00002517          	auipc	a0,0x2
ffffffffc02030c6:	4de50513          	addi	a0,a0,1246 # ffffffffc02055a0 <etext+0x169a>
ffffffffc02030ca:	8cafd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc02030ce:	7442                	ld	s0,48(sp)
ffffffffc02030d0:	70e2                	ld	ra,56(sp)
ffffffffc02030d2:	74a2                	ld	s1,40(sp)
ffffffffc02030d4:	7902                	ld	s2,32(sp)
ffffffffc02030d6:	69e2                	ld	s3,24(sp)
ffffffffc02030d8:	6a42                	ld	s4,16(sp)
ffffffffc02030da:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030dc:	00002517          	auipc	a0,0x2
ffffffffc02030e0:	4e450513          	addi	a0,a0,1252 # ffffffffc02055c0 <etext+0x16ba>
}
ffffffffc02030e4:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030e6:	8aefd06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc02030ea:	00002697          	auipc	a3,0x2
ffffffffc02030ee:	36668693          	addi	a3,a3,870 # ffffffffc0205450 <etext+0x154a>
ffffffffc02030f2:	00002617          	auipc	a2,0x2
ffffffffc02030f6:	84e60613          	addi	a2,a2,-1970 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02030fa:	0da00593          	li	a1,218
ffffffffc02030fe:	00002517          	auipc	a0,0x2
ffffffffc0203102:	2d250513          	addi	a0,a0,722 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203106:	b00fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(mm != NULL);
ffffffffc020310a:	00002697          	auipc	a3,0x2
ffffffffc020310e:	33668693          	addi	a3,a3,822 # ffffffffc0205440 <etext+0x153a>
ffffffffc0203112:	00002617          	auipc	a2,0x2
ffffffffc0203116:	82e60613          	addi	a2,a2,-2002 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020311a:	0d200593          	li	a1,210
ffffffffc020311e:	00002517          	auipc	a0,0x2
ffffffffc0203122:	2b250513          	addi	a0,a0,690 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203126:	ae0fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma != NULL);
ffffffffc020312a:	00002697          	auipc	a3,0x2
ffffffffc020312e:	32668693          	addi	a3,a3,806 # ffffffffc0205450 <etext+0x154a>
ffffffffc0203132:	00002617          	auipc	a2,0x2
ffffffffc0203136:	80e60613          	addi	a2,a2,-2034 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020313a:	0e100593          	li	a1,225
ffffffffc020313e:	00002517          	auipc	a0,0x2
ffffffffc0203142:	29250513          	addi	a0,a0,658 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203146:	ac0fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc020314a:	00002697          	auipc	a3,0x2
ffffffffc020314e:	32e68693          	addi	a3,a3,814 # ffffffffc0205478 <etext+0x1572>
ffffffffc0203152:	00001617          	auipc	a2,0x1
ffffffffc0203156:	7ee60613          	addi	a2,a2,2030 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020315a:	0eb00593          	li	a1,235
ffffffffc020315e:	00002517          	auipc	a0,0x2
ffffffffc0203162:	27250513          	addi	a0,a0,626 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203166:	aa0fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020316a:	00002697          	auipc	a3,0x2
ffffffffc020316e:	3c668693          	addi	a3,a3,966 # ffffffffc0205530 <etext+0x162a>
ffffffffc0203172:	00001617          	auipc	a2,0x1
ffffffffc0203176:	7ce60613          	addi	a2,a2,1998 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020317a:	0fd00593          	li	a1,253
ffffffffc020317e:	00002517          	auipc	a0,0x2
ffffffffc0203182:	25250513          	addi	a0,a0,594 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203186:	a80fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020318a:	00002697          	auipc	a3,0x2
ffffffffc020318e:	37668693          	addi	a3,a3,886 # ffffffffc0205500 <etext+0x15fa>
ffffffffc0203192:	00001617          	auipc	a2,0x1
ffffffffc0203196:	7ae60613          	addi	a2,a2,1966 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020319a:	0fc00593          	li	a1,252
ffffffffc020319e:	00002517          	auipc	a0,0x2
ffffffffc02031a2:	23250513          	addi	a0,a0,562 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc02031a6:	a60fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma5 == NULL);
ffffffffc02031aa:	00002697          	auipc	a3,0x2
ffffffffc02031ae:	34668693          	addi	a3,a3,838 # ffffffffc02054f0 <etext+0x15ea>
ffffffffc02031b2:	00001617          	auipc	a2,0x1
ffffffffc02031b6:	78e60613          	addi	a2,a2,1934 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02031ba:	0fa00593          	li	a1,250
ffffffffc02031be:	00002517          	auipc	a0,0x2
ffffffffc02031c2:	21250513          	addi	a0,a0,530 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc02031c6:	a40fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma4 == NULL);
ffffffffc02031ca:	00002697          	auipc	a3,0x2
ffffffffc02031ce:	31668693          	addi	a3,a3,790 # ffffffffc02054e0 <etext+0x15da>
ffffffffc02031d2:	00001617          	auipc	a2,0x1
ffffffffc02031d6:	76e60613          	addi	a2,a2,1902 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02031da:	0f800593          	li	a1,248
ffffffffc02031de:	00002517          	auipc	a0,0x2
ffffffffc02031e2:	1f250513          	addi	a0,a0,498 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc02031e6:	a20fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma3 == NULL);
ffffffffc02031ea:	00002697          	auipc	a3,0x2
ffffffffc02031ee:	2e668693          	addi	a3,a3,742 # ffffffffc02054d0 <etext+0x15ca>
ffffffffc02031f2:	00001617          	auipc	a2,0x1
ffffffffc02031f6:	74e60613          	addi	a2,a2,1870 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02031fa:	0f600593          	li	a1,246
ffffffffc02031fe:	00002517          	auipc	a0,0x2
ffffffffc0203202:	1d250513          	addi	a0,a0,466 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203206:	a00fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc020320a:	00002697          	auipc	a3,0x2
ffffffffc020320e:	25668693          	addi	a3,a3,598 # ffffffffc0205460 <etext+0x155a>
ffffffffc0203212:	00001617          	auipc	a2,0x1
ffffffffc0203216:	72e60613          	addi	a2,a2,1838 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020321a:	0e900593          	li	a1,233
ffffffffc020321e:	00002517          	auipc	a0,0x2
ffffffffc0203222:	1b250513          	addi	a0,a0,434 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203226:	9e0fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2 != NULL);
ffffffffc020322a:	00002697          	auipc	a3,0x2
ffffffffc020322e:	29668693          	addi	a3,a3,662 # ffffffffc02054c0 <etext+0x15ba>
ffffffffc0203232:	00001617          	auipc	a2,0x1
ffffffffc0203236:	70e60613          	addi	a2,a2,1806 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020323a:	0f400593          	li	a1,244
ffffffffc020323e:	00002517          	auipc	a0,0x2
ffffffffc0203242:	19250513          	addi	a0,a0,402 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203246:	9c0fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1 != NULL);
ffffffffc020324a:	00002697          	auipc	a3,0x2
ffffffffc020324e:	26668693          	addi	a3,a3,614 # ffffffffc02054b0 <etext+0x15aa>
ffffffffc0203252:	00001617          	auipc	a2,0x1
ffffffffc0203256:	6ee60613          	addi	a2,a2,1774 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020325a:	0f200593          	li	a1,242
ffffffffc020325e:	00002517          	auipc	a0,0x2
ffffffffc0203262:	17250513          	addi	a0,a0,370 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc0203266:	9a0fd0ef          	jal	ffffffffc0200406 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc020326a:	6914                	ld	a3,16(a0)
ffffffffc020326c:	6510                	ld	a2,8(a0)
ffffffffc020326e:	0004859b          	sext.w	a1,s1
ffffffffc0203272:	00002517          	auipc	a0,0x2
ffffffffc0203276:	2ee50513          	addi	a0,a0,750 # ffffffffc0205560 <etext+0x165a>
ffffffffc020327a:	f1bfc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc020327e:	00002697          	auipc	a3,0x2
ffffffffc0203282:	30a68693          	addi	a3,a3,778 # ffffffffc0205588 <etext+0x1682>
ffffffffc0203286:	00001617          	auipc	a2,0x1
ffffffffc020328a:	6ba60613          	addi	a2,a2,1722 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020328e:	10700593          	li	a1,263
ffffffffc0203292:	00002517          	auipc	a0,0x2
ffffffffc0203296:	13e50513          	addi	a0,a0,318 # ffffffffc02053d0 <etext+0x14ca>
ffffffffc020329a:	96cfd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020329e <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020329e:	8526                	mv	a0,s1
	jalr s0
ffffffffc02032a0:	9402                	jalr	s0

	jal do_exit
ffffffffc02032a2:	3c2000ef          	jal	ffffffffc0203664 <do_exit>

ffffffffc02032a6 <alloc_proc>:

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
/**/
static struct proc_struct *
alloc_proc(void)
{
ffffffffc02032a6:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02032a8:	0e800513          	li	a0,232
{
ffffffffc02032ac:	e022                	sd	s0,0(sp)
ffffffffc02032ae:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02032b0:	885fe0ef          	jal	ffffffffc0201b34 <kmalloc>
ffffffffc02032b4:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02032b6:	cd21                	beqz	a0,ffffffffc020330e <alloc_proc+0x68>
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
                // 基本状态字段
        proc->state = PROC_UNINIT;
ffffffffc02032b8:	57fd                	li	a5,-1
ffffffffc02032ba:	1782                	slli	a5,a5,0x20
ffffffffc02032bc:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc02032be:	00052423          	sw	zero,8(a0)

        // 栈与调度标志
        proc->kstack = 0;
ffffffffc02032c2:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02032c6:	00052c23          	sw	zero,24(a0)

        // 亲缘关系与地址空间
        proc->parent = NULL;
ffffffffc02032ca:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02032ce:	02053423          	sd	zero,40(a0)

        // 上下文/中断帧初始化
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02032d2:	07000613          	li	a2,112
ffffffffc02032d6:	4581                	li	a1,0
ffffffffc02032d8:	03050513          	addi	a0,a0,48
ffffffffc02032dc:	3dd000ef          	jal	ffffffffc0203eb8 <memset>
        proc->tf = NULL;

        // 页表根（riscv 版本自检需要与 boot_pgdir_pa 相等）
        proc->pgdir = boot_pgdir_pa;
ffffffffc02032e0:	0000a797          	auipc	a5,0xa
ffffffffc02032e4:	1c87b783          	ld	a5,456(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc02032e8:	0a043023          	sd	zero,160(s0) # ffffffffc02000a0 <kern_init+0x56>

        // 其他
        proc->flags = 0;
ffffffffc02032ec:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc02032f0:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc02032f2:	0b440513          	addi	a0,s0,180
ffffffffc02032f6:	4641                	li	a2,16
ffffffffc02032f8:	4581                	li	a1,0
ffffffffc02032fa:	3bf000ef          	jal	ffffffffc0203eb8 <memset>

        // 链表结点清零（可选，便于调试）
        list_init(&(proc->list_link));
ffffffffc02032fe:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203302:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc0203306:	e878                	sd	a4,208(s0)
ffffffffc0203308:	e478                	sd	a4,200(s0)
ffffffffc020330a:	f07c                	sd	a5,224(s0)
ffffffffc020330c:	ec7c                	sd	a5,216(s0)
        
    }
    return proc;
}
ffffffffc020330e:	60a2                	ld	ra,8(sp)
ffffffffc0203310:	8522                	mv	a0,s0
ffffffffc0203312:	6402                	ld	s0,0(sp)
ffffffffc0203314:	0141                	addi	sp,sp,16
ffffffffc0203316:	8082                	ret

ffffffffc0203318 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203318:	0000a797          	auipc	a5,0xa
ffffffffc020331c:	1c07b783          	ld	a5,448(a5) # ffffffffc020d4d8 <current>
ffffffffc0203320:	73c8                	ld	a0,160(a5)
ffffffffc0203322:	a9bfd06f          	j	ffffffffc0200dbc <forkrets>

ffffffffc0203326 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0203326:	1101                	addi	sp,sp,-32
ffffffffc0203328:	e822                	sd	s0,16(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020332a:	0000a417          	auipc	s0,0xa
ffffffffc020332e:	1ae43403          	ld	s0,430(s0) # ffffffffc020d4d8 <current>
{
ffffffffc0203332:	e04a                	sd	s2,0(sp)
    memset(name, 0, sizeof(name));
ffffffffc0203334:	4641                	li	a2,16
{
ffffffffc0203336:	892a                	mv	s2,a0
    memset(name, 0, sizeof(name));
ffffffffc0203338:	4581                	li	a1,0
ffffffffc020333a:	00006517          	auipc	a0,0x6
ffffffffc020333e:	10e50513          	addi	a0,a0,270 # ffffffffc0209448 <name.2>
{
ffffffffc0203342:	ec06                	sd	ra,24(sp)
ffffffffc0203344:	e426                	sd	s1,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203346:	4044                	lw	s1,4(s0)
    memset(name, 0, sizeof(name));
ffffffffc0203348:	371000ef          	jal	ffffffffc0203eb8 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc020334c:	0b440593          	addi	a1,s0,180
ffffffffc0203350:	463d                	li	a2,15
ffffffffc0203352:	00006517          	auipc	a0,0x6
ffffffffc0203356:	0f650513          	addi	a0,a0,246 # ffffffffc0209448 <name.2>
ffffffffc020335a:	371000ef          	jal	ffffffffc0203eca <memcpy>
ffffffffc020335e:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203360:	85a6                	mv	a1,s1
ffffffffc0203362:	00002517          	auipc	a0,0x2
ffffffffc0203366:	27650513          	addi	a0,a0,630 # ffffffffc02055d8 <etext+0x16d2>
ffffffffc020336a:	e2bfc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc020336e:	85ca                	mv	a1,s2
ffffffffc0203370:	00002517          	auipc	a0,0x2
ffffffffc0203374:	29050513          	addi	a0,a0,656 # ffffffffc0205600 <etext+0x16fa>
ffffffffc0203378:	e1dfc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc020337c:	00002517          	auipc	a0,0x2
ffffffffc0203380:	29450513          	addi	a0,a0,660 # ffffffffc0205610 <etext+0x170a>
ffffffffc0203384:	e11fc0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0203388:	60e2                	ld	ra,24(sp)
ffffffffc020338a:	6442                	ld	s0,16(sp)
ffffffffc020338c:	64a2                	ld	s1,8(sp)
ffffffffc020338e:	6902                	ld	s2,0(sp)
ffffffffc0203390:	4501                	li	a0,0
ffffffffc0203392:	6105                	addi	sp,sp,32
ffffffffc0203394:	8082                	ret

ffffffffc0203396 <proc_run>:
    if (proc != current)
ffffffffc0203396:	0000a797          	auipc	a5,0xa
ffffffffc020339a:	14278793          	addi	a5,a5,322 # ffffffffc020d4d8 <current>
ffffffffc020339e:	6398                	ld	a4,0(a5)
ffffffffc02033a0:	04a70263          	beq	a4,a0,ffffffffc02033e4 <proc_run+0x4e>
{
ffffffffc02033a4:	1101                	addi	sp,sp,-32
ffffffffc02033a6:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02033a8:	100026f3          	csrr	a3,sstatus
ffffffffc02033ac:	8a89                	andi	a3,a3,2
    return 0;
ffffffffc02033ae:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02033b0:	ea9d                	bnez	a3,ffffffffc02033e6 <proc_run+0x50>
        current = proc;
ffffffffc02033b2:	e388                	sd	a0,0(a5)
        lsatp(proc->pgdir);                   // 如果你的平台需要 MAKE_SATP，可改成 lsatp(MAKE_SATP(proc->pgdir))
ffffffffc02033b4:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc02033b6:	800006b7          	lui	a3,0x80000
ffffffffc02033ba:	e432                	sd	a2,8(sp)
ffffffffc02033bc:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc02033c0:	8fd5                	or	a5,a5,a3
ffffffffc02033c2:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc02033c6:	03050593          	addi	a1,a0,48
ffffffffc02033ca:	03070513          	addi	a0,a4,48
ffffffffc02033ce:	524000ef          	jal	ffffffffc02038f2 <switch_to>
    if (flag) {
ffffffffc02033d2:	6622                	ld	a2,8(sp)
ffffffffc02033d4:	e601                	bnez	a2,ffffffffc02033dc <proc_run+0x46>
}
ffffffffc02033d6:	60e2                	ld	ra,24(sp)
ffffffffc02033d8:	6105                	addi	sp,sp,32
ffffffffc02033da:	8082                	ret
ffffffffc02033dc:	60e2                	ld	ra,24(sp)
ffffffffc02033de:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02033e0:	c8efd06f          	j	ffffffffc020086e <intr_enable>
ffffffffc02033e4:	8082                	ret
        intr_disable();
ffffffffc02033e6:	e42a                	sd	a0,8(sp)
ffffffffc02033e8:	c8cfd0ef          	jal	ffffffffc0200874 <intr_disable>
        struct proc_struct *prev = current;
ffffffffc02033ec:	0000a797          	auipc	a5,0xa
ffffffffc02033f0:	0ec78793          	addi	a5,a5,236 # ffffffffc020d4d8 <current>
ffffffffc02033f4:	6398                	ld	a4,0(a5)
        return 1;
ffffffffc02033f6:	6522                	ld	a0,8(sp)
ffffffffc02033f8:	4605                	li	a2,1
ffffffffc02033fa:	bf65                	j	ffffffffc02033b2 <proc_run+0x1c>

ffffffffc02033fc <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc02033fc:	0000a717          	auipc	a4,0xa
ffffffffc0203400:	0d472703          	lw	a4,212(a4) # ffffffffc020d4d0 <nr_process>
ffffffffc0203404:	6785                	lui	a5,0x1
ffffffffc0203406:	1cf75963          	bge	a4,a5,ffffffffc02035d8 <do_fork+0x1dc>
{
ffffffffc020340a:	1101                	addi	sp,sp,-32
ffffffffc020340c:	e822                	sd	s0,16(sp)
ffffffffc020340e:	e426                	sd	s1,8(sp)
ffffffffc0203410:	e04a                	sd	s2,0(sp)
ffffffffc0203412:	ec06                	sd	ra,24(sp)
ffffffffc0203414:	892e                	mv	s2,a1
ffffffffc0203416:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203418:	e8fff0ef          	jal	ffffffffc02032a6 <alloc_proc>
ffffffffc020341c:	84aa                	mv	s1,a0
ffffffffc020341e:	1a050b63          	beqz	a0,ffffffffc02035d4 <do_fork+0x1d8>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203422:	4509                	li	a0,2
ffffffffc0203424:	8d3fe0ef          	jal	ffffffffc0201cf6 <alloc_pages>
    if (page != NULL)
ffffffffc0203428:	1a050363          	beqz	a0,ffffffffc02035ce <do_fork+0x1d2>
    return page - pages + nbase;
ffffffffc020342c:	0000a697          	auipc	a3,0xa
ffffffffc0203430:	09c6b683          	ld	a3,156(a3) # ffffffffc020d4c8 <pages>
ffffffffc0203434:	00002797          	auipc	a5,0x2
ffffffffc0203438:	68c7b783          	ld	a5,1676(a5) # ffffffffc0205ac0 <nbase>
    return KADDR(page2pa(page));
ffffffffc020343c:	0000a717          	auipc	a4,0xa
ffffffffc0203440:	08473703          	ld	a4,132(a4) # ffffffffc020d4c0 <npage>
    return page - pages + nbase;
ffffffffc0203444:	40d506b3          	sub	a3,a0,a3
ffffffffc0203448:	8699                	srai	a3,a3,0x6
ffffffffc020344a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020344c:	00c69793          	slli	a5,a3,0xc
ffffffffc0203450:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203452:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203454:	1ae7f463          	bgeu	a5,a4,ffffffffc02035fc <do_fork+0x200>
    assert(current->mm == NULL);
ffffffffc0203458:	0000a717          	auipc	a4,0xa
ffffffffc020345c:	08073703          	ld	a4,128(a4) # ffffffffc020d4d8 <current>
ffffffffc0203460:	0000a617          	auipc	a2,0xa
ffffffffc0203464:	05863603          	ld	a2,88(a2) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0203468:	771c                	ld	a5,40(a4)
ffffffffc020346a:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020346c:	e894                	sd	a3,16(s1)
    assert(current->mm == NULL);
ffffffffc020346e:	16079763          	bnez	a5,ffffffffc02035dc <do_fork+0x1e0>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0203472:	6789                	lui	a5,0x2
ffffffffc0203474:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc0203478:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020347a:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020347c:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc020347e:	87b6                	mv	a5,a3
ffffffffc0203480:	12040593          	addi	a1,s0,288
ffffffffc0203484:	6a08                	ld	a0,16(a2)
ffffffffc0203486:	00063883          	ld	a7,0(a2)
ffffffffc020348a:	00863803          	ld	a6,8(a2)
ffffffffc020348e:	eb88                	sd	a0,16(a5)
ffffffffc0203490:	0117b023          	sd	a7,0(a5)
ffffffffc0203494:	0107b423          	sd	a6,8(a5)
ffffffffc0203498:	6e08                	ld	a0,24(a2)
ffffffffc020349a:	02060613          	addi	a2,a2,32
ffffffffc020349e:	02078793          	addi	a5,a5,32
ffffffffc02034a2:	fea7bc23          	sd	a0,-8(a5)
ffffffffc02034a6:	fcb61fe3          	bne	a2,a1,ffffffffc0203484 <do_fork+0x88>
    proc->tf->gpr.a0 = 0;
ffffffffc02034aa:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02034ae:	10090263          	beqz	s2,ffffffffc02035b2 <do_fork+0x1b6>
    if (++last_pid >= MAX_PID)
ffffffffc02034b2:	00006517          	auipc	a0,0x6
ffffffffc02034b6:	b7a52503          	lw	a0,-1158(a0) # ffffffffc020902c <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02034ba:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02034be:	00000797          	auipc	a5,0x0
ffffffffc02034c2:	e5a78793          	addi	a5,a5,-422 # ffffffffc0203318 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02034c6:	2505                	addiw	a0,a0,1
    proc->parent = current;
ffffffffc02034c8:	f098                	sd	a4,32(s1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02034ca:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02034cc:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc02034ce:	00006717          	auipc	a4,0x6
ffffffffc02034d2:	b4a72f23          	sw	a0,-1186(a4) # ffffffffc020902c <last_pid.1>
ffffffffc02034d6:	6789                	lui	a5,0x2
ffffffffc02034d8:	0cf55f63          	bge	a0,a5,ffffffffc02035b6 <do_fork+0x1ba>
    if (last_pid >= next_safe)
ffffffffc02034dc:	00006797          	auipc	a5,0x6
ffffffffc02034e0:	b4c7a783          	lw	a5,-1204(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc02034e4:	0000a417          	auipc	s0,0xa
ffffffffc02034e8:	f7440413          	addi	s0,s0,-140 # ffffffffc020d458 <proc_list>
ffffffffc02034ec:	06f54563          	blt	a0,a5,ffffffffc0203556 <do_fork+0x15a>
    return listelm->next;
ffffffffc02034f0:	0000a417          	auipc	s0,0xa
ffffffffc02034f4:	f6840413          	addi	s0,s0,-152 # ffffffffc020d458 <proc_list>
ffffffffc02034f8:	00843883          	ld	a7,8(s0)
        next_safe = MAX_PID;
ffffffffc02034fc:	6789                	lui	a5,0x2
ffffffffc02034fe:	00006717          	auipc	a4,0x6
ffffffffc0203502:	b2f72523          	sw	a5,-1238(a4) # ffffffffc0209028 <next_safe.0>
ffffffffc0203506:	86aa                	mv	a3,a0
ffffffffc0203508:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020350a:	04888063          	beq	a7,s0,ffffffffc020354a <do_fork+0x14e>
ffffffffc020350e:	882e                	mv	a6,a1
ffffffffc0203510:	87c6                	mv	a5,a7
ffffffffc0203512:	6609                	lui	a2,0x2
ffffffffc0203514:	a811                	j	ffffffffc0203528 <do_fork+0x12c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203516:	00e6d663          	bge	a3,a4,ffffffffc0203522 <do_fork+0x126>
ffffffffc020351a:	00c75463          	bge	a4,a2,ffffffffc0203522 <do_fork+0x126>
                next_safe = proc->pid;
ffffffffc020351e:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203520:	4805                	li	a6,1
ffffffffc0203522:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0203524:	00878d63          	beq	a5,s0,ffffffffc020353e <do_fork+0x142>
            if (proc->pid == last_pid)
ffffffffc0203528:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc020352c:	fed715e3          	bne	a4,a3,ffffffffc0203516 <do_fork+0x11a>
                if (++last_pid >= next_safe)
ffffffffc0203530:	2685                	addiw	a3,a3,1
ffffffffc0203532:	08c6d863          	bge	a3,a2,ffffffffc02035c2 <do_fork+0x1c6>
ffffffffc0203536:	679c                	ld	a5,8(a5)
ffffffffc0203538:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020353a:	fe8797e3          	bne	a5,s0,ffffffffc0203528 <do_fork+0x12c>
ffffffffc020353e:	00080663          	beqz	a6,ffffffffc020354a <do_fork+0x14e>
ffffffffc0203542:	00006797          	auipc	a5,0x6
ffffffffc0203546:	aec7a323          	sw	a2,-1306(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc020354a:	c591                	beqz	a1,ffffffffc0203556 <do_fork+0x15a>
ffffffffc020354c:	00006797          	auipc	a5,0x6
ffffffffc0203550:	aed7a023          	sw	a3,-1312(a5) # ffffffffc020902c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203554:	8536                	mv	a0,a3
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203556:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc0203558:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020355a:	4c8000ef          	jal	ffffffffc0203a22 <hash32>
ffffffffc020355e:	02051793          	slli	a5,a0,0x20
ffffffffc0203562:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0203566:	00006797          	auipc	a5,0x6
ffffffffc020356a:	ef278793          	addi	a5,a5,-270 # ffffffffc0209458 <hash_list>
ffffffffc020356e:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0203570:	651c                	ld	a5,8(a0)
ffffffffc0203572:	0d848693          	addi	a3,s1,216
ffffffffc0203576:	6418                	ld	a4,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203578:	e394                	sd	a3,0(a5)
ffffffffc020357a:	e514                	sd	a3,8(a0)
    elm->next = next;
ffffffffc020357c:	f0fc                	sd	a5,224(s1)
    elm->prev = prev;
ffffffffc020357e:	ece8                	sd	a0,216(s1)
    list_add(&proc_list, &(proc->list_link)); // 放入全局进程链表（头插/尾插均可，保持一致即可）
ffffffffc0203580:	0c848793          	addi	a5,s1,200
    prev->next = next->prev = elm;
ffffffffc0203584:	e31c                	sd	a5,0(a4)
    elm->next = next;
ffffffffc0203586:	e8f8                	sd	a4,208(s1)
    wakeup_proc(proc);                        // 内部会把 state 置为 PROC_RUNNABLE
ffffffffc0203588:	8526                	mv	a0,s1
    elm->prev = prev;
ffffffffc020358a:	e4e0                	sd	s0,200(s1)
    prev->next = next->prev = elm;
ffffffffc020358c:	e41c                	sd	a5,8(s0)
ffffffffc020358e:	3ce000ef          	jal	ffffffffc020395c <wakeup_proc>
    nr_process++;
ffffffffc0203592:	0000a797          	auipc	a5,0xa
ffffffffc0203596:	f3e7a783          	lw	a5,-194(a5) # ffffffffc020d4d0 <nr_process>
    ret = proc->pid;
ffffffffc020359a:	40c8                	lw	a0,4(s1)
    nr_process++;
ffffffffc020359c:	2785                	addiw	a5,a5,1
ffffffffc020359e:	0000a717          	auipc	a4,0xa
ffffffffc02035a2:	f2f72923          	sw	a5,-206(a4) # ffffffffc020d4d0 <nr_process>
}
ffffffffc02035a6:	60e2                	ld	ra,24(sp)
ffffffffc02035a8:	6442                	ld	s0,16(sp)
ffffffffc02035aa:	64a2                	ld	s1,8(sp)
ffffffffc02035ac:	6902                	ld	s2,0(sp)
ffffffffc02035ae:	6105                	addi	sp,sp,32
ffffffffc02035b0:	8082                	ret
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02035b2:	8936                	mv	s2,a3
ffffffffc02035b4:	bdfd                	j	ffffffffc02034b2 <do_fork+0xb6>
        last_pid = 1;
ffffffffc02035b6:	4505                	li	a0,1
ffffffffc02035b8:	00006797          	auipc	a5,0x6
ffffffffc02035bc:	a6a7aa23          	sw	a0,-1420(a5) # ffffffffc020902c <last_pid.1>
        goto inside;
ffffffffc02035c0:	bf05                	j	ffffffffc02034f0 <do_fork+0xf4>
                    if (last_pid >= MAX_PID)
ffffffffc02035c2:	6789                	lui	a5,0x2
ffffffffc02035c4:	00f6c363          	blt	a3,a5,ffffffffc02035ca <do_fork+0x1ce>
                        last_pid = 1;
ffffffffc02035c8:	4685                	li	a3,1
                    goto repeat;
ffffffffc02035ca:	4585                	li	a1,1
ffffffffc02035cc:	bf3d                	j	ffffffffc020350a <do_fork+0x10e>
    kfree(proc);
ffffffffc02035ce:	8526                	mv	a0,s1
ffffffffc02035d0:	e0afe0ef          	jal	ffffffffc0201bda <kfree>
    ret = -E_NO_MEM;
ffffffffc02035d4:	5571                	li	a0,-4
ffffffffc02035d6:	bfc1                	j	ffffffffc02035a6 <do_fork+0x1aa>
    int ret = -E_NO_FREE_PROC;
ffffffffc02035d8:	556d                	li	a0,-5
}
ffffffffc02035da:	8082                	ret
    assert(current->mm == NULL);
ffffffffc02035dc:	00002697          	auipc	a3,0x2
ffffffffc02035e0:	05468693          	addi	a3,a3,84 # ffffffffc0205630 <etext+0x172a>
ffffffffc02035e4:	00001617          	auipc	a2,0x1
ffffffffc02035e8:	35c60613          	addi	a2,a2,860 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02035ec:	13200593          	li	a1,306
ffffffffc02035f0:	00002517          	auipc	a0,0x2
ffffffffc02035f4:	05850513          	addi	a0,a0,88 # ffffffffc0205648 <etext+0x1742>
ffffffffc02035f8:	e0ffc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02035fc:	00001617          	auipc	a2,0x1
ffffffffc0203600:	6f460613          	addi	a2,a2,1780 # ffffffffc0204cf0 <etext+0xdea>
ffffffffc0203604:	07100593          	li	a1,113
ffffffffc0203608:	00001517          	auipc	a0,0x1
ffffffffc020360c:	71050513          	addi	a0,a0,1808 # ffffffffc0204d18 <etext+0xe12>
ffffffffc0203610:	df7fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203614 <kernel_thread>:
{
ffffffffc0203614:	7129                	addi	sp,sp,-320
ffffffffc0203616:	fa22                	sd	s0,304(sp)
ffffffffc0203618:	f626                	sd	s1,296(sp)
ffffffffc020361a:	f24a                	sd	s2,288(sp)
ffffffffc020361c:	842a                	mv	s0,a0
ffffffffc020361e:	84ae                	mv	s1,a1
ffffffffc0203620:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203622:	850a                	mv	a0,sp
ffffffffc0203624:	12000613          	li	a2,288
ffffffffc0203628:	4581                	li	a1,0
{
ffffffffc020362a:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020362c:	08d000ef          	jal	ffffffffc0203eb8 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0203630:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0203632:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203634:	100027f3          	csrr	a5,sstatus
ffffffffc0203638:	edd7f793          	andi	a5,a5,-291
ffffffffc020363c:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203640:	860a                	mv	a2,sp
ffffffffc0203642:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203646:	00000717          	auipc	a4,0x0
ffffffffc020364a:	c5870713          	addi	a4,a4,-936 # ffffffffc020329e <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020364e:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203650:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203652:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203654:	da9ff0ef          	jal	ffffffffc02033fc <do_fork>
}
ffffffffc0203658:	70f2                	ld	ra,312(sp)
ffffffffc020365a:	7452                	ld	s0,304(sp)
ffffffffc020365c:	74b2                	ld	s1,296(sp)
ffffffffc020365e:	7912                	ld	s2,288(sp)
ffffffffc0203660:	6131                	addi	sp,sp,320
ffffffffc0203662:	8082                	ret

ffffffffc0203664 <do_exit>:
{
ffffffffc0203664:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc0203666:	00002617          	auipc	a2,0x2
ffffffffc020366a:	ffa60613          	addi	a2,a2,-6 # ffffffffc0205660 <etext+0x175a>
ffffffffc020366e:	1a000593          	li	a1,416
ffffffffc0203672:	00002517          	auipc	a0,0x2
ffffffffc0203676:	fd650513          	addi	a0,a0,-42 # ffffffffc0205648 <etext+0x1742>
{
ffffffffc020367a:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc020367c:	d8bfc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203680 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0203680:	7179                	addi	sp,sp,-48
ffffffffc0203682:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0203684:	0000a797          	auipc	a5,0xa
ffffffffc0203688:	dd478793          	addi	a5,a5,-556 # ffffffffc020d458 <proc_list>
ffffffffc020368c:	f406                	sd	ra,40(sp)
ffffffffc020368e:	f022                	sd	s0,32(sp)
ffffffffc0203690:	e84a                	sd	s2,16(sp)
ffffffffc0203692:	e44e                	sd	s3,8(sp)
ffffffffc0203694:	00006497          	auipc	s1,0x6
ffffffffc0203698:	dc448493          	addi	s1,s1,-572 # ffffffffc0209458 <hash_list>
ffffffffc020369c:	e79c                	sd	a5,8(a5)
ffffffffc020369e:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc02036a0:	0000a717          	auipc	a4,0xa
ffffffffc02036a4:	db870713          	addi	a4,a4,-584 # ffffffffc020d458 <proc_list>
ffffffffc02036a8:	87a6                	mv	a5,s1
ffffffffc02036aa:	e79c                	sd	a5,8(a5)
ffffffffc02036ac:	e39c                	sd	a5,0(a5)
ffffffffc02036ae:	07c1                	addi	a5,a5,16
ffffffffc02036b0:	fee79de3          	bne	a5,a4,ffffffffc02036aa <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc02036b4:	bf3ff0ef          	jal	ffffffffc02032a6 <alloc_proc>
ffffffffc02036b8:	0000a917          	auipc	s2,0xa
ffffffffc02036bc:	e3090913          	addi	s2,s2,-464 # ffffffffc020d4e8 <idleproc>
ffffffffc02036c0:	00a93023          	sd	a0,0(s2)
ffffffffc02036c4:	1a050263          	beqz	a0,ffffffffc0203868 <proc_init+0x1e8>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036c8:	07000513          	li	a0,112
ffffffffc02036cc:	c68fe0ef          	jal	ffffffffc0201b34 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036d0:	07000613          	li	a2,112
ffffffffc02036d4:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036d6:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036d8:	7e0000ef          	jal	ffffffffc0203eb8 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc02036dc:	00093503          	ld	a0,0(s2)
ffffffffc02036e0:	85a2                	mv	a1,s0
ffffffffc02036e2:	07000613          	li	a2,112
ffffffffc02036e6:	03050513          	addi	a0,a0,48
ffffffffc02036ea:	7f8000ef          	jal	ffffffffc0203ee2 <memcmp>
ffffffffc02036ee:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036f0:	453d                	li	a0,15
ffffffffc02036f2:	c42fe0ef          	jal	ffffffffc0201b34 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036f6:	463d                	li	a2,15
ffffffffc02036f8:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036fa:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036fc:	7bc000ef          	jal	ffffffffc0203eb8 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc0203700:	00093503          	ld	a0,0(s2)
ffffffffc0203704:	85a2                	mv	a1,s0
ffffffffc0203706:	463d                	li	a2,15
ffffffffc0203708:	0b450513          	addi	a0,a0,180
ffffffffc020370c:	7d6000ef          	jal	ffffffffc0203ee2 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203710:	00093783          	ld	a5,0(s2)
ffffffffc0203714:	0000a717          	auipc	a4,0xa
ffffffffc0203718:	d9473703          	ld	a4,-620(a4) # ffffffffc020d4a8 <boot_pgdir_pa>
ffffffffc020371c:	77d4                	ld	a3,168(a5)
ffffffffc020371e:	0ee68863          	beq	a3,a4,ffffffffc020380e <proc_init+0x18e>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0203722:	4709                	li	a4,2
ffffffffc0203724:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203726:	00003717          	auipc	a4,0x3
ffffffffc020372a:	8da70713          	addi	a4,a4,-1830 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020372e:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203732:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc0203734:	4705                	li	a4,1
ffffffffc0203736:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203738:	8522                	mv	a0,s0
ffffffffc020373a:	4641                	li	a2,16
ffffffffc020373c:	4581                	li	a1,0
ffffffffc020373e:	77a000ef          	jal	ffffffffc0203eb8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203742:	8522                	mv	a0,s0
ffffffffc0203744:	463d                	li	a2,15
ffffffffc0203746:	00002597          	auipc	a1,0x2
ffffffffc020374a:	f6258593          	addi	a1,a1,-158 # ffffffffc02056a8 <etext+0x17a2>
ffffffffc020374e:	77c000ef          	jal	ffffffffc0203eca <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0203752:	0000a797          	auipc	a5,0xa
ffffffffc0203756:	d7e7a783          	lw	a5,-642(a5) # ffffffffc020d4d0 <nr_process>

    current = idleproc;
ffffffffc020375a:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020375e:	4601                	li	a2,0
    nr_process++;
ffffffffc0203760:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203762:	00002597          	auipc	a1,0x2
ffffffffc0203766:	f4e58593          	addi	a1,a1,-178 # ffffffffc02056b0 <etext+0x17aa>
ffffffffc020376a:	00000517          	auipc	a0,0x0
ffffffffc020376e:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0203326 <init_main>
    current = idleproc;
ffffffffc0203772:	0000a697          	auipc	a3,0xa
ffffffffc0203776:	d6e6b323          	sd	a4,-666(a3) # ffffffffc020d4d8 <current>
    nr_process++;
ffffffffc020377a:	0000a717          	auipc	a4,0xa
ffffffffc020377e:	d4f72b23          	sw	a5,-682(a4) # ffffffffc020d4d0 <nr_process>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203782:	e93ff0ef          	jal	ffffffffc0203614 <kernel_thread>
ffffffffc0203786:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0203788:	0ea05c63          	blez	a0,ffffffffc0203880 <proc_init+0x200>
    if (0 < pid && pid < MAX_PID)
ffffffffc020378c:	6789                	lui	a5,0x2
ffffffffc020378e:	17f9                	addi	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc0203790:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203794:	02e7e463          	bltu	a5,a4,ffffffffc02037bc <proc_init+0x13c>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203798:	45a9                	li	a1,10
ffffffffc020379a:	288000ef          	jal	ffffffffc0203a22 <hash32>
ffffffffc020379e:	02051713          	slli	a4,a0,0x20
ffffffffc02037a2:	01c75793          	srli	a5,a4,0x1c
ffffffffc02037a6:	00f486b3          	add	a3,s1,a5
ffffffffc02037aa:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02037ac:	a029                	j	ffffffffc02037b6 <proc_init+0x136>
            if (proc->pid == pid)
ffffffffc02037ae:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02037b2:	0a870863          	beq	a4,s0,ffffffffc0203862 <proc_init+0x1e2>
    return listelm->next;
ffffffffc02037b6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02037b8:	fef69be3          	bne	a3,a5,ffffffffc02037ae <proc_init+0x12e>
    return NULL;
ffffffffc02037bc:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037be:	0b478413          	addi	s0,a5,180
ffffffffc02037c2:	4641                	li	a2,16
ffffffffc02037c4:	4581                	li	a1,0
ffffffffc02037c6:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02037c8:	0000a717          	auipc	a4,0xa
ffffffffc02037cc:	d0f73c23          	sd	a5,-744(a4) # ffffffffc020d4e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037d0:	6e8000ef          	jal	ffffffffc0203eb8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02037d4:	8522                	mv	a0,s0
ffffffffc02037d6:	463d                	li	a2,15
ffffffffc02037d8:	00002597          	auipc	a1,0x2
ffffffffc02037dc:	f0858593          	addi	a1,a1,-248 # ffffffffc02056e0 <etext+0x17da>
ffffffffc02037e0:	6ea000ef          	jal	ffffffffc0203eca <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02037e4:	00093783          	ld	a5,0(s2)
ffffffffc02037e8:	cbe1                	beqz	a5,ffffffffc02038b8 <proc_init+0x238>
ffffffffc02037ea:	43dc                	lw	a5,4(a5)
ffffffffc02037ec:	e7f1                	bnez	a5,ffffffffc02038b8 <proc_init+0x238>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02037ee:	0000a797          	auipc	a5,0xa
ffffffffc02037f2:	cf27b783          	ld	a5,-782(a5) # ffffffffc020d4e0 <initproc>
ffffffffc02037f6:	c3cd                	beqz	a5,ffffffffc0203898 <proc_init+0x218>
ffffffffc02037f8:	43d8                	lw	a4,4(a5)
ffffffffc02037fa:	4785                	li	a5,1
ffffffffc02037fc:	08f71e63          	bne	a4,a5,ffffffffc0203898 <proc_init+0x218>
}
ffffffffc0203800:	70a2                	ld	ra,40(sp)
ffffffffc0203802:	7402                	ld	s0,32(sp)
ffffffffc0203804:	64e2                	ld	s1,24(sp)
ffffffffc0203806:	6942                	ld	s2,16(sp)
ffffffffc0203808:	69a2                	ld	s3,8(sp)
ffffffffc020380a:	6145                	addi	sp,sp,48
ffffffffc020380c:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc020380e:	73d8                	ld	a4,160(a5)
ffffffffc0203810:	f00719e3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203814:	f00997e3          	bnez	s3,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203818:	4398                	lw	a4,0(a5)
ffffffffc020381a:	f00714e3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc020381e:	43d4                	lw	a3,4(a5)
ffffffffc0203820:	577d                	li	a4,-1
ffffffffc0203822:	f0e690e3          	bne	a3,a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203826:	4798                	lw	a4,8(a5)
ffffffffc0203828:	ee071de3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc020382c:	6b98                	ld	a4,16(a5)
ffffffffc020382e:	ee071ae3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203832:	4f98                	lw	a4,24(a5)
ffffffffc0203834:	ee0717e3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203838:	7398                	ld	a4,32(a5)
ffffffffc020383a:	ee0714e3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc020383e:	7798                	ld	a4,40(a5)
ffffffffc0203840:	ee0711e3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
ffffffffc0203844:	0b07a703          	lw	a4,176(a5)
ffffffffc0203848:	8f49                	or	a4,a4,a0
ffffffffc020384a:	2701                	sext.w	a4,a4
ffffffffc020384c:	ec071be3          	bnez	a4,ffffffffc0203722 <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0203850:	00002517          	auipc	a0,0x2
ffffffffc0203854:	e4050513          	addi	a0,a0,-448 # ffffffffc0205690 <etext+0x178a>
ffffffffc0203858:	93dfc0ef          	jal	ffffffffc0200194 <cprintf>
    idleproc->pid = 0;
ffffffffc020385c:	00093783          	ld	a5,0(s2)
ffffffffc0203860:	b5c9                	j	ffffffffc0203722 <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203862:	f2878793          	addi	a5,a5,-216
ffffffffc0203866:	bfa1                	j	ffffffffc02037be <proc_init+0x13e>
        panic("cannot alloc idleproc.\n");
ffffffffc0203868:	00002617          	auipc	a2,0x2
ffffffffc020386c:	e1060613          	addi	a2,a2,-496 # ffffffffc0205678 <etext+0x1772>
ffffffffc0203870:	1bb00593          	li	a1,443
ffffffffc0203874:	00002517          	auipc	a0,0x2
ffffffffc0203878:	dd450513          	addi	a0,a0,-556 # ffffffffc0205648 <etext+0x1742>
ffffffffc020387c:	b8bfc0ef          	jal	ffffffffc0200406 <__panic>
        panic("create init_main failed.\n");
ffffffffc0203880:	00002617          	auipc	a2,0x2
ffffffffc0203884:	e4060613          	addi	a2,a2,-448 # ffffffffc02056c0 <etext+0x17ba>
ffffffffc0203888:	1d800593          	li	a1,472
ffffffffc020388c:	00002517          	auipc	a0,0x2
ffffffffc0203890:	dbc50513          	addi	a0,a0,-580 # ffffffffc0205648 <etext+0x1742>
ffffffffc0203894:	b73fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203898:	00002697          	auipc	a3,0x2
ffffffffc020389c:	e7868693          	addi	a3,a3,-392 # ffffffffc0205710 <etext+0x180a>
ffffffffc02038a0:	00001617          	auipc	a2,0x1
ffffffffc02038a4:	0a060613          	addi	a2,a2,160 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02038a8:	1df00593          	li	a1,479
ffffffffc02038ac:	00002517          	auipc	a0,0x2
ffffffffc02038b0:	d9c50513          	addi	a0,a0,-612 # ffffffffc0205648 <etext+0x1742>
ffffffffc02038b4:	b53fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02038b8:	00002697          	auipc	a3,0x2
ffffffffc02038bc:	e3068693          	addi	a3,a3,-464 # ffffffffc02056e8 <etext+0x17e2>
ffffffffc02038c0:	00001617          	auipc	a2,0x1
ffffffffc02038c4:	08060613          	addi	a2,a2,128 # ffffffffc0204940 <etext+0xa3a>
ffffffffc02038c8:	1de00593          	li	a1,478
ffffffffc02038cc:	00002517          	auipc	a0,0x2
ffffffffc02038d0:	d7c50513          	addi	a0,a0,-644 # ffffffffc0205648 <etext+0x1742>
ffffffffc02038d4:	b33fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02038d8 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02038d8:	1141                	addi	sp,sp,-16
ffffffffc02038da:	e022                	sd	s0,0(sp)
ffffffffc02038dc:	e406                	sd	ra,8(sp)
ffffffffc02038de:	0000a417          	auipc	s0,0xa
ffffffffc02038e2:	bfa40413          	addi	s0,s0,-1030 # ffffffffc020d4d8 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02038e6:	6018                	ld	a4,0(s0)
ffffffffc02038e8:	4f1c                	lw	a5,24(a4)
ffffffffc02038ea:	dffd                	beqz	a5,ffffffffc02038e8 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02038ec:	0a2000ef          	jal	ffffffffc020398e <schedule>
ffffffffc02038f0:	bfdd                	j	ffffffffc02038e6 <cpu_idle+0xe>

ffffffffc02038f2 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02038f2:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02038f6:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02038fa:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02038fc:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02038fe:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203902:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203906:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020390a:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020390e:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203912:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203916:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020391a:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020391e:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203922:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203926:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020392a:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020392e:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203930:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203932:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203936:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020393a:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020393e:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203942:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203946:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020394a:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020394e:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203952:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203956:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020395a:	8082                	ret

ffffffffc020395c <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc020395c:	411c                	lw	a5,0(a0)
ffffffffc020395e:	4705                	li	a4,1
ffffffffc0203960:	37f9                	addiw	a5,a5,-2
ffffffffc0203962:	00f77563          	bgeu	a4,a5,ffffffffc020396c <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc0203966:	4789                	li	a5,2
ffffffffc0203968:	c11c                	sw	a5,0(a0)
ffffffffc020396a:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc020396c:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc020396e:	00002697          	auipc	a3,0x2
ffffffffc0203972:	dca68693          	addi	a3,a3,-566 # ffffffffc0205738 <etext+0x1832>
ffffffffc0203976:	00001617          	auipc	a2,0x1
ffffffffc020397a:	fca60613          	addi	a2,a2,-54 # ffffffffc0204940 <etext+0xa3a>
ffffffffc020397e:	45a5                	li	a1,9
ffffffffc0203980:	00002517          	auipc	a0,0x2
ffffffffc0203984:	df850513          	addi	a0,a0,-520 # ffffffffc0205778 <etext+0x1872>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0203988:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc020398a:	a7dfc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020398e <schedule>:
}

void
schedule(void) {
ffffffffc020398e:	1101                	addi	sp,sp,-32
ffffffffc0203990:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203992:	100027f3          	csrr	a5,sstatus
ffffffffc0203996:	8b89                	andi	a5,a5,2
ffffffffc0203998:	4301                	li	t1,0
ffffffffc020399a:	e3c1                	bnez	a5,ffffffffc0203a1a <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020399c:	0000a897          	auipc	a7,0xa
ffffffffc02039a0:	b3c8b883          	ld	a7,-1220(a7) # ffffffffc020d4d8 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02039a4:	0000a517          	auipc	a0,0xa
ffffffffc02039a8:	b4453503          	ld	a0,-1212(a0) # ffffffffc020d4e8 <idleproc>
        current->need_resched = 0;
ffffffffc02039ac:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02039b0:	04a88f63          	beq	a7,a0,ffffffffc0203a0e <schedule+0x80>
ffffffffc02039b4:	0c888693          	addi	a3,a7,200
ffffffffc02039b8:	0000a617          	auipc	a2,0xa
ffffffffc02039bc:	aa060613          	addi	a2,a2,-1376 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc02039c0:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02039c2:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc02039c4:	4809                	li	a6,2
ffffffffc02039c6:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc02039c8:	00c78863          	beq	a5,a2,ffffffffc02039d8 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE) {
ffffffffc02039cc:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02039d0:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc02039d4:	03070363          	beq	a4,a6,ffffffffc02039fa <schedule+0x6c>
                    break;
                }
            }
        } while (le != last);
ffffffffc02039d8:	fef697e3          	bne	a3,a5,ffffffffc02039c6 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02039dc:	ed99                	bnez	a1,ffffffffc02039fa <schedule+0x6c>
            next = idleproc;
        }
        next->runs ++;
ffffffffc02039de:	451c                	lw	a5,8(a0)
ffffffffc02039e0:	2785                	addiw	a5,a5,1
ffffffffc02039e2:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc02039e4:	00a88663          	beq	a7,a0,ffffffffc02039f0 <schedule+0x62>
ffffffffc02039e8:	e41a                	sd	t1,8(sp)
            proc_run(next);
ffffffffc02039ea:	9adff0ef          	jal	ffffffffc0203396 <proc_run>
ffffffffc02039ee:	6322                	ld	t1,8(sp)
    if (flag) {
ffffffffc02039f0:	00031b63          	bnez	t1,ffffffffc0203a06 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02039f4:	60e2                	ld	ra,24(sp)
ffffffffc02039f6:	6105                	addi	sp,sp,32
ffffffffc02039f8:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02039fa:	4198                	lw	a4,0(a1)
ffffffffc02039fc:	4789                	li	a5,2
ffffffffc02039fe:	fef710e3          	bne	a4,a5,ffffffffc02039de <schedule+0x50>
ffffffffc0203a02:	852e                	mv	a0,a1
ffffffffc0203a04:	bfe9                	j	ffffffffc02039de <schedule+0x50>
}
ffffffffc0203a06:	60e2                	ld	ra,24(sp)
ffffffffc0203a08:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203a0a:	e65fc06f          	j	ffffffffc020086e <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203a0e:	0000a617          	auipc	a2,0xa
ffffffffc0203a12:	a4a60613          	addi	a2,a2,-1462 # ffffffffc020d458 <proc_list>
ffffffffc0203a16:	86b2                	mv	a3,a2
ffffffffc0203a18:	b765                	j	ffffffffc02039c0 <schedule+0x32>
        intr_disable();
ffffffffc0203a1a:	e5bfc0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0203a1e:	4305                	li	t1,1
ffffffffc0203a20:	bfb5                	j	ffffffffc020399c <schedule+0xe>

ffffffffc0203a22 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203a22:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203a26:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc0203a28:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0203a2c:	02000513          	li	a0,32
ffffffffc0203a30:	9d0d                	subw	a0,a0,a1
}
ffffffffc0203a32:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0203a36:	8082                	ret

ffffffffc0203a38 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a38:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203a3a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a3e:	f022                	sd	s0,32(sp)
ffffffffc0203a40:	ec26                	sd	s1,24(sp)
ffffffffc0203a42:	e84a                	sd	s2,16(sp)
ffffffffc0203a44:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203a46:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a4a:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203a4c:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203a50:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a54:	84aa                	mv	s1,a0
ffffffffc0203a56:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0203a58:	03067d63          	bgeu	a2,a6,ffffffffc0203a92 <printnum+0x5a>
ffffffffc0203a5c:	e44e                	sd	s3,8(sp)
ffffffffc0203a5e:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203a60:	4785                	li	a5,1
ffffffffc0203a62:	00e7d763          	bge	a5,a4,ffffffffc0203a70 <printnum+0x38>
            putch(padc, putdat);
ffffffffc0203a66:	85ca                	mv	a1,s2
ffffffffc0203a68:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0203a6a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203a6c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203a6e:	fc65                	bnez	s0,ffffffffc0203a66 <printnum+0x2e>
ffffffffc0203a70:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a72:	00002797          	auipc	a5,0x2
ffffffffc0203a76:	d1e78793          	addi	a5,a5,-738 # ffffffffc0205790 <etext+0x188a>
ffffffffc0203a7a:	97d2                	add	a5,a5,s4
}
ffffffffc0203a7c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a7e:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0203a82:	70a2                	ld	ra,40(sp)
ffffffffc0203a84:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a86:	85ca                	mv	a1,s2
ffffffffc0203a88:	87a6                	mv	a5,s1
}
ffffffffc0203a8a:	6942                	ld	s2,16(sp)
ffffffffc0203a8c:	64e2                	ld	s1,24(sp)
ffffffffc0203a8e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a90:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203a92:	03065633          	divu	a2,a2,a6
ffffffffc0203a96:	8722                	mv	a4,s0
ffffffffc0203a98:	fa1ff0ef          	jal	ffffffffc0203a38 <printnum>
ffffffffc0203a9c:	bfd9                	j	ffffffffc0203a72 <printnum+0x3a>

ffffffffc0203a9e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203a9e:	7119                	addi	sp,sp,-128
ffffffffc0203aa0:	f4a6                	sd	s1,104(sp)
ffffffffc0203aa2:	f0ca                	sd	s2,96(sp)
ffffffffc0203aa4:	ecce                	sd	s3,88(sp)
ffffffffc0203aa6:	e8d2                	sd	s4,80(sp)
ffffffffc0203aa8:	e4d6                	sd	s5,72(sp)
ffffffffc0203aaa:	e0da                	sd	s6,64(sp)
ffffffffc0203aac:	f862                	sd	s8,48(sp)
ffffffffc0203aae:	fc86                	sd	ra,120(sp)
ffffffffc0203ab0:	f8a2                	sd	s0,112(sp)
ffffffffc0203ab2:	fc5e                	sd	s7,56(sp)
ffffffffc0203ab4:	f466                	sd	s9,40(sp)
ffffffffc0203ab6:	f06a                	sd	s10,32(sp)
ffffffffc0203ab8:	ec6e                	sd	s11,24(sp)
ffffffffc0203aba:	84aa                	mv	s1,a0
ffffffffc0203abc:	8c32                	mv	s8,a2
ffffffffc0203abe:	8a36                	mv	s4,a3
ffffffffc0203ac0:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203ac2:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ac6:	05500b13          	li	s6,85
ffffffffc0203aca:	00002a97          	auipc	s5,0x2
ffffffffc0203ace:	e66a8a93          	addi	s5,s5,-410 # ffffffffc0205930 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203ad2:	000c4503          	lbu	a0,0(s8)
ffffffffc0203ad6:	001c0413          	addi	s0,s8,1
ffffffffc0203ada:	01350a63          	beq	a0,s3,ffffffffc0203aee <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0203ade:	cd0d                	beqz	a0,ffffffffc0203b18 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0203ae0:	85ca                	mv	a1,s2
ffffffffc0203ae2:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203ae4:	00044503          	lbu	a0,0(s0)
ffffffffc0203ae8:	0405                	addi	s0,s0,1
ffffffffc0203aea:	ff351ae3          	bne	a0,s3,ffffffffc0203ade <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0203aee:	5cfd                	li	s9,-1
ffffffffc0203af0:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0203af2:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0203af6:	4b81                	li	s7,0
ffffffffc0203af8:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203afa:	00044683          	lbu	a3,0(s0)
ffffffffc0203afe:	00140c13          	addi	s8,s0,1
ffffffffc0203b02:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0203b06:	0ff5f593          	zext.b	a1,a1
ffffffffc0203b0a:	02bb6663          	bltu	s6,a1,ffffffffc0203b36 <vprintfmt+0x98>
ffffffffc0203b0e:	058a                	slli	a1,a1,0x2
ffffffffc0203b10:	95d6                	add	a1,a1,s5
ffffffffc0203b12:	4198                	lw	a4,0(a1)
ffffffffc0203b14:	9756                	add	a4,a4,s5
ffffffffc0203b16:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203b18:	70e6                	ld	ra,120(sp)
ffffffffc0203b1a:	7446                	ld	s0,112(sp)
ffffffffc0203b1c:	74a6                	ld	s1,104(sp)
ffffffffc0203b1e:	7906                	ld	s2,96(sp)
ffffffffc0203b20:	69e6                	ld	s3,88(sp)
ffffffffc0203b22:	6a46                	ld	s4,80(sp)
ffffffffc0203b24:	6aa6                	ld	s5,72(sp)
ffffffffc0203b26:	6b06                	ld	s6,64(sp)
ffffffffc0203b28:	7be2                	ld	s7,56(sp)
ffffffffc0203b2a:	7c42                	ld	s8,48(sp)
ffffffffc0203b2c:	7ca2                	ld	s9,40(sp)
ffffffffc0203b2e:	7d02                	ld	s10,32(sp)
ffffffffc0203b30:	6de2                	ld	s11,24(sp)
ffffffffc0203b32:	6109                	addi	sp,sp,128
ffffffffc0203b34:	8082                	ret
            putch('%', putdat);
ffffffffc0203b36:	85ca                	mv	a1,s2
ffffffffc0203b38:	02500513          	li	a0,37
ffffffffc0203b3c:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203b3e:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203b42:	02500713          	li	a4,37
ffffffffc0203b46:	8c22                	mv	s8,s0
ffffffffc0203b48:	f8e785e3          	beq	a5,a4,ffffffffc0203ad2 <vprintfmt+0x34>
ffffffffc0203b4c:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0203b50:	1c7d                	addi	s8,s8,-1
ffffffffc0203b52:	fee79de3          	bne	a5,a4,ffffffffc0203b4c <vprintfmt+0xae>
ffffffffc0203b56:	bfb5                	j	ffffffffc0203ad2 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0203b58:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0203b5c:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0203b5e:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0203b62:	fd06071b          	addiw	a4,a2,-48
ffffffffc0203b66:	24e56a63          	bltu	a0,a4,ffffffffc0203dba <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0203b6a:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b6c:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0203b6e:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0203b72:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203b76:	0197073b          	addw	a4,a4,s9
ffffffffc0203b7a:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203b7e:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203b80:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203b84:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203b86:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0203b8a:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0203b8e:	feb570e3          	bgeu	a0,a1,ffffffffc0203b6e <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0203b92:	f60d54e3          	bgez	s10,ffffffffc0203afa <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0203b96:	8d66                	mv	s10,s9
ffffffffc0203b98:	5cfd                	li	s9,-1
ffffffffc0203b9a:	b785                	j	ffffffffc0203afa <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b9c:	8db6                	mv	s11,a3
ffffffffc0203b9e:	8462                	mv	s0,s8
ffffffffc0203ba0:	bfa9                	j	ffffffffc0203afa <vprintfmt+0x5c>
ffffffffc0203ba2:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0203ba4:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0203ba6:	bf91                	j	ffffffffc0203afa <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0203ba8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203baa:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203bae:	00f74463          	blt	a4,a5,ffffffffc0203bb6 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0203bb2:	1a078763          	beqz	a5,ffffffffc0203d60 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0203bb6:	000a3603          	ld	a2,0(s4)
ffffffffc0203bba:	46c1                	li	a3,16
ffffffffc0203bbc:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203bbe:	000d879b          	sext.w	a5,s11
ffffffffc0203bc2:	876a                	mv	a4,s10
ffffffffc0203bc4:	85ca                	mv	a1,s2
ffffffffc0203bc6:	8526                	mv	a0,s1
ffffffffc0203bc8:	e71ff0ef          	jal	ffffffffc0203a38 <printnum>
            break;
ffffffffc0203bcc:	b719                	j	ffffffffc0203ad2 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0203bce:	000a2503          	lw	a0,0(s4)
ffffffffc0203bd2:	85ca                	mv	a1,s2
ffffffffc0203bd4:	0a21                	addi	s4,s4,8
ffffffffc0203bd6:	9482                	jalr	s1
            break;
ffffffffc0203bd8:	bded                	j	ffffffffc0203ad2 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203bda:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203bdc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203be0:	00f74463          	blt	a4,a5,ffffffffc0203be8 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0203be4:	16078963          	beqz	a5,ffffffffc0203d56 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0203be8:	000a3603          	ld	a2,0(s4)
ffffffffc0203bec:	46a9                	li	a3,10
ffffffffc0203bee:	8a2e                	mv	s4,a1
ffffffffc0203bf0:	b7f9                	j	ffffffffc0203bbe <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0203bf2:	85ca                	mv	a1,s2
ffffffffc0203bf4:	03000513          	li	a0,48
ffffffffc0203bf8:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0203bfa:	85ca                	mv	a1,s2
ffffffffc0203bfc:	07800513          	li	a0,120
ffffffffc0203c00:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203c02:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0203c06:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203c08:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203c0a:	bf55                	j	ffffffffc0203bbe <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0203c0c:	85ca                	mv	a1,s2
ffffffffc0203c0e:	02500513          	li	a0,37
ffffffffc0203c12:	9482                	jalr	s1
            break;
ffffffffc0203c14:	bd7d                	j	ffffffffc0203ad2 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0203c16:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c1a:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0203c1c:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0203c1e:	bf95                	j	ffffffffc0203b92 <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0203c20:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c22:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c26:	00f74463          	blt	a4,a5,ffffffffc0203c2e <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0203c2a:	12078163          	beqz	a5,ffffffffc0203d4c <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0203c2e:	000a3603          	ld	a2,0(s4)
ffffffffc0203c32:	46a1                	li	a3,8
ffffffffc0203c34:	8a2e                	mv	s4,a1
ffffffffc0203c36:	b761                	j	ffffffffc0203bbe <vprintfmt+0x120>
            if (width < 0)
ffffffffc0203c38:	876a                	mv	a4,s10
ffffffffc0203c3a:	000d5363          	bgez	s10,ffffffffc0203c40 <vprintfmt+0x1a2>
ffffffffc0203c3e:	4701                	li	a4,0
ffffffffc0203c40:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c44:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203c46:	bd55                	j	ffffffffc0203afa <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0203c48:	000d841b          	sext.w	s0,s11
ffffffffc0203c4c:	fd340793          	addi	a5,s0,-45
ffffffffc0203c50:	00f037b3          	snez	a5,a5
ffffffffc0203c54:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203c58:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0203c5c:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203c5e:	008a0793          	addi	a5,s4,8
ffffffffc0203c62:	e43e                	sd	a5,8(sp)
ffffffffc0203c64:	100d8c63          	beqz	s11,ffffffffc0203d7c <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0203c68:	12071363          	bnez	a4,ffffffffc0203d8e <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c6c:	000dc783          	lbu	a5,0(s11)
ffffffffc0203c70:	0007851b          	sext.w	a0,a5
ffffffffc0203c74:	c78d                	beqz	a5,ffffffffc0203c9e <vprintfmt+0x200>
ffffffffc0203c76:	0d85                	addi	s11,s11,1
ffffffffc0203c78:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c7a:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c7e:	000cc563          	bltz	s9,ffffffffc0203c88 <vprintfmt+0x1ea>
ffffffffc0203c82:	3cfd                	addiw	s9,s9,-1
ffffffffc0203c84:	008c8d63          	beq	s9,s0,ffffffffc0203c9e <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c88:	020b9663          	bnez	s7,ffffffffc0203cb4 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0203c8c:	85ca                	mv	a1,s2
ffffffffc0203c8e:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c90:	000dc783          	lbu	a5,0(s11)
ffffffffc0203c94:	0d85                	addi	s11,s11,1
ffffffffc0203c96:	3d7d                	addiw	s10,s10,-1
ffffffffc0203c98:	0007851b          	sext.w	a0,a5
ffffffffc0203c9c:	f3ed                	bnez	a5,ffffffffc0203c7e <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0203c9e:	01a05963          	blez	s10,ffffffffc0203cb0 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0203ca2:	85ca                	mv	a1,s2
ffffffffc0203ca4:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0203ca8:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0203caa:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0203cac:	fe0d1be3          	bnez	s10,ffffffffc0203ca2 <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203cb0:	6a22                	ld	s4,8(sp)
ffffffffc0203cb2:	b505                	j	ffffffffc0203ad2 <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203cb4:	3781                	addiw	a5,a5,-32
ffffffffc0203cb6:	fcfa7be3          	bgeu	s4,a5,ffffffffc0203c8c <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0203cba:	03f00513          	li	a0,63
ffffffffc0203cbe:	85ca                	mv	a1,s2
ffffffffc0203cc0:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cc2:	000dc783          	lbu	a5,0(s11)
ffffffffc0203cc6:	0d85                	addi	s11,s11,1
ffffffffc0203cc8:	3d7d                	addiw	s10,s10,-1
ffffffffc0203cca:	0007851b          	sext.w	a0,a5
ffffffffc0203cce:	dbe1                	beqz	a5,ffffffffc0203c9e <vprintfmt+0x200>
ffffffffc0203cd0:	fa0cd9e3          	bgez	s9,ffffffffc0203c82 <vprintfmt+0x1e4>
ffffffffc0203cd4:	b7c5                	j	ffffffffc0203cb4 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0203cd6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203cda:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0203cdc:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203cde:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0203ce2:	8fb9                	xor	a5,a5,a4
ffffffffc0203ce4:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203ce8:	02d64563          	blt	a2,a3,ffffffffc0203d12 <vprintfmt+0x274>
ffffffffc0203cec:	00002797          	auipc	a5,0x2
ffffffffc0203cf0:	d9c78793          	addi	a5,a5,-612 # ffffffffc0205a88 <error_string>
ffffffffc0203cf4:	00369713          	slli	a4,a3,0x3
ffffffffc0203cf8:	97ba                	add	a5,a5,a4
ffffffffc0203cfa:	639c                	ld	a5,0(a5)
ffffffffc0203cfc:	cb99                	beqz	a5,ffffffffc0203d12 <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203cfe:	86be                	mv	a3,a5
ffffffffc0203d00:	00000617          	auipc	a2,0x0
ffffffffc0203d04:	23060613          	addi	a2,a2,560 # ffffffffc0203f30 <etext+0x2a>
ffffffffc0203d08:	85ca                	mv	a1,s2
ffffffffc0203d0a:	8526                	mv	a0,s1
ffffffffc0203d0c:	0d8000ef          	jal	ffffffffc0203de4 <printfmt>
ffffffffc0203d10:	b3c9                	j	ffffffffc0203ad2 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203d12:	00002617          	auipc	a2,0x2
ffffffffc0203d16:	a9e60613          	addi	a2,a2,-1378 # ffffffffc02057b0 <etext+0x18aa>
ffffffffc0203d1a:	85ca                	mv	a1,s2
ffffffffc0203d1c:	8526                	mv	a0,s1
ffffffffc0203d1e:	0c6000ef          	jal	ffffffffc0203de4 <printfmt>
ffffffffc0203d22:	bb45                	j	ffffffffc0203ad2 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203d24:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203d26:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0203d2a:	00f74363          	blt	a4,a5,ffffffffc0203d30 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0203d2e:	cf81                	beqz	a5,ffffffffc0203d46 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0203d30:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203d34:	02044b63          	bltz	s0,ffffffffc0203d6a <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0203d38:	8622                	mv	a2,s0
ffffffffc0203d3a:	8a5e                	mv	s4,s7
ffffffffc0203d3c:	46a9                	li	a3,10
ffffffffc0203d3e:	b541                	j	ffffffffc0203bbe <vprintfmt+0x120>
            lflag ++;
ffffffffc0203d40:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203d42:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203d44:	bb5d                	j	ffffffffc0203afa <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0203d46:	000a2403          	lw	s0,0(s4)
ffffffffc0203d4a:	b7ed                	j	ffffffffc0203d34 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0203d4c:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d50:	46a1                	li	a3,8
ffffffffc0203d52:	8a2e                	mv	s4,a1
ffffffffc0203d54:	b5ad                	j	ffffffffc0203bbe <vprintfmt+0x120>
ffffffffc0203d56:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d5a:	46a9                	li	a3,10
ffffffffc0203d5c:	8a2e                	mv	s4,a1
ffffffffc0203d5e:	b585                	j	ffffffffc0203bbe <vprintfmt+0x120>
ffffffffc0203d60:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d64:	46c1                	li	a3,16
ffffffffc0203d66:	8a2e                	mv	s4,a1
ffffffffc0203d68:	bd99                	j	ffffffffc0203bbe <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0203d6a:	85ca                	mv	a1,s2
ffffffffc0203d6c:	02d00513          	li	a0,45
ffffffffc0203d70:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0203d72:	40800633          	neg	a2,s0
ffffffffc0203d76:	8a5e                	mv	s4,s7
ffffffffc0203d78:	46a9                	li	a3,10
ffffffffc0203d7a:	b591                	j	ffffffffc0203bbe <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0203d7c:	e329                	bnez	a4,ffffffffc0203dbe <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d7e:	02800793          	li	a5,40
ffffffffc0203d82:	853e                	mv	a0,a5
ffffffffc0203d84:	00002d97          	auipc	s11,0x2
ffffffffc0203d88:	a25d8d93          	addi	s11,s11,-1499 # ffffffffc02057a9 <etext+0x18a3>
ffffffffc0203d8c:	b5f5                	j	ffffffffc0203c78 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203d8e:	85e6                	mv	a1,s9
ffffffffc0203d90:	856e                	mv	a0,s11
ffffffffc0203d92:	08a000ef          	jal	ffffffffc0203e1c <strnlen>
ffffffffc0203d96:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0203d9a:	01a05863          	blez	s10,ffffffffc0203daa <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0203d9e:	85ca                	mv	a1,s2
ffffffffc0203da0:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203da2:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0203da4:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203da6:	fe0d1ce3          	bnez	s10,ffffffffc0203d9e <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203daa:	000dc783          	lbu	a5,0(s11)
ffffffffc0203dae:	0007851b          	sext.w	a0,a5
ffffffffc0203db2:	ec0792e3          	bnez	a5,ffffffffc0203c76 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203db6:	6a22                	ld	s4,8(sp)
ffffffffc0203db8:	bb29                	j	ffffffffc0203ad2 <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203dba:	8462                	mv	s0,s8
ffffffffc0203dbc:	bbd9                	j	ffffffffc0203b92 <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dbe:	85e6                	mv	a1,s9
ffffffffc0203dc0:	00002517          	auipc	a0,0x2
ffffffffc0203dc4:	9e850513          	addi	a0,a0,-1560 # ffffffffc02057a8 <etext+0x18a2>
ffffffffc0203dc8:	054000ef          	jal	ffffffffc0203e1c <strnlen>
ffffffffc0203dcc:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203dd0:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0203dd4:	00002d97          	auipc	s11,0x2
ffffffffc0203dd8:	9d4d8d93          	addi	s11,s11,-1580 # ffffffffc02057a8 <etext+0x18a2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203ddc:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dde:	fda040e3          	bgtz	s10,ffffffffc0203d9e <vprintfmt+0x300>
ffffffffc0203de2:	bd51                	j	ffffffffc0203c76 <vprintfmt+0x1d8>

ffffffffc0203de4 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203de4:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203de6:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203dea:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203dec:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203dee:	ec06                	sd	ra,24(sp)
ffffffffc0203df0:	f83a                	sd	a4,48(sp)
ffffffffc0203df2:	fc3e                	sd	a5,56(sp)
ffffffffc0203df4:	e0c2                	sd	a6,64(sp)
ffffffffc0203df6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203df8:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203dfa:	ca5ff0ef          	jal	ffffffffc0203a9e <vprintfmt>
}
ffffffffc0203dfe:	60e2                	ld	ra,24(sp)
ffffffffc0203e00:	6161                	addi	sp,sp,80
ffffffffc0203e02:	8082                	ret

ffffffffc0203e04 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203e04:	00054783          	lbu	a5,0(a0)
ffffffffc0203e08:	cb81                	beqz	a5,ffffffffc0203e18 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0203e0a:	4781                	li	a5,0
        cnt ++;
ffffffffc0203e0c:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0203e0e:	00f50733          	add	a4,a0,a5
ffffffffc0203e12:	00074703          	lbu	a4,0(a4)
ffffffffc0203e16:	fb7d                	bnez	a4,ffffffffc0203e0c <strlen+0x8>
    }
    return cnt;
}
ffffffffc0203e18:	853e                	mv	a0,a5
ffffffffc0203e1a:	8082                	ret

ffffffffc0203e1c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203e1c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203e1e:	e589                	bnez	a1,ffffffffc0203e28 <strnlen+0xc>
ffffffffc0203e20:	a811                	j	ffffffffc0203e34 <strnlen+0x18>
        cnt ++;
ffffffffc0203e22:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203e24:	00f58863          	beq	a1,a5,ffffffffc0203e34 <strnlen+0x18>
ffffffffc0203e28:	00f50733          	add	a4,a0,a5
ffffffffc0203e2c:	00074703          	lbu	a4,0(a4)
ffffffffc0203e30:	fb6d                	bnez	a4,ffffffffc0203e22 <strnlen+0x6>
ffffffffc0203e32:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203e34:	852e                	mv	a0,a1
ffffffffc0203e36:	8082                	ret

ffffffffc0203e38 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203e38:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203e3a:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e3e:	0585                	addi	a1,a1,1
ffffffffc0203e40:	0785                	addi	a5,a5,1
ffffffffc0203e42:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203e46:	fb75                	bnez	a4,ffffffffc0203e3a <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203e48:	8082                	ret

ffffffffc0203e4a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203e4a:	00054783          	lbu	a5,0(a0)
ffffffffc0203e4e:	e791                	bnez	a5,ffffffffc0203e5a <strcmp+0x10>
ffffffffc0203e50:	a01d                	j	ffffffffc0203e76 <strcmp+0x2c>
ffffffffc0203e52:	00054783          	lbu	a5,0(a0)
ffffffffc0203e56:	cb99                	beqz	a5,ffffffffc0203e6c <strcmp+0x22>
ffffffffc0203e58:	0585                	addi	a1,a1,1
ffffffffc0203e5a:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0203e5e:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203e60:	fef709e3          	beq	a4,a5,ffffffffc0203e52 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e64:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203e68:	9d19                	subw	a0,a0,a4
ffffffffc0203e6a:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e6c:	0015c703          	lbu	a4,1(a1)
ffffffffc0203e70:	4501                	li	a0,0
}
ffffffffc0203e72:	9d19                	subw	a0,a0,a4
ffffffffc0203e74:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e76:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e7a:	4501                	li	a0,0
ffffffffc0203e7c:	b7f5                	j	ffffffffc0203e68 <strcmp+0x1e>

ffffffffc0203e7e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e7e:	ce01                	beqz	a2,ffffffffc0203e96 <strncmp+0x18>
ffffffffc0203e80:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203e84:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e86:	cb91                	beqz	a5,ffffffffc0203e9a <strncmp+0x1c>
ffffffffc0203e88:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e8c:	00f71763          	bne	a4,a5,ffffffffc0203e9a <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0203e90:	0505                	addi	a0,a0,1
ffffffffc0203e92:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e94:	f675                	bnez	a2,ffffffffc0203e80 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e96:	4501                	li	a0,0
ffffffffc0203e98:	8082                	ret
ffffffffc0203e9a:	00054503          	lbu	a0,0(a0)
ffffffffc0203e9e:	0005c783          	lbu	a5,0(a1)
ffffffffc0203ea2:	9d1d                	subw	a0,a0,a5
}
ffffffffc0203ea4:	8082                	ret

ffffffffc0203ea6 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203ea6:	a021                	j	ffffffffc0203eae <strchr+0x8>
        if (*s == c) {
ffffffffc0203ea8:	00f58763          	beq	a1,a5,ffffffffc0203eb6 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0203eac:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203eae:	00054783          	lbu	a5,0(a0)
ffffffffc0203eb2:	fbfd                	bnez	a5,ffffffffc0203ea8 <strchr+0x2>
    }
    return NULL;
ffffffffc0203eb4:	4501                	li	a0,0
}
ffffffffc0203eb6:	8082                	ret

ffffffffc0203eb8 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203eb8:	ca01                	beqz	a2,ffffffffc0203ec8 <memset+0x10>
ffffffffc0203eba:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203ebc:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203ebe:	0785                	addi	a5,a5,1
ffffffffc0203ec0:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203ec4:	fef61de3          	bne	a2,a5,ffffffffc0203ebe <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203ec8:	8082                	ret

ffffffffc0203eca <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203eca:	ca19                	beqz	a2,ffffffffc0203ee0 <memcpy+0x16>
ffffffffc0203ecc:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203ece:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203ed0:	0005c703          	lbu	a4,0(a1)
ffffffffc0203ed4:	0585                	addi	a1,a1,1
ffffffffc0203ed6:	0785                	addi	a5,a5,1
ffffffffc0203ed8:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203edc:	feb61ae3          	bne	a2,a1,ffffffffc0203ed0 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203ee0:	8082                	ret

ffffffffc0203ee2 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203ee2:	c205                	beqz	a2,ffffffffc0203f02 <memcmp+0x20>
ffffffffc0203ee4:	962a                	add	a2,a2,a0
ffffffffc0203ee6:	a019                	j	ffffffffc0203eec <memcmp+0xa>
ffffffffc0203ee8:	00c50d63          	beq	a0,a2,ffffffffc0203f02 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203eec:	00054783          	lbu	a5,0(a0)
ffffffffc0203ef0:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203ef4:	0505                	addi	a0,a0,1
ffffffffc0203ef6:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203ef8:	fee788e3          	beq	a5,a4,ffffffffc0203ee8 <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203efc:	40e7853b          	subw	a0,a5,a4
ffffffffc0203f00:	8082                	ret
    }
    return 0;
ffffffffc0203f02:	4501                	li	a0,0
}
ffffffffc0203f04:	8082                	ret
