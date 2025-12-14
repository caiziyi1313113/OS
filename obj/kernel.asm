
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	00097517          	auipc	a0,0x97
ffffffffc020004e:	16e50513          	addi	a0,a0,366 # ffffffffc02971b8 <buf>
ffffffffc0200052:	0009b617          	auipc	a2,0x9b
ffffffffc0200056:	61660613          	addi	a2,a2,1558 # ffffffffc029b668 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	18f050ef          	jal	ffffffffc02059f0 <memset>
    dtb_init();
ffffffffc0200066:	552000ef          	jal	ffffffffc02005b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	4dc000ef          	jal	ffffffffc0200546 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	9b258593          	addi	a1,a1,-1614 # ffffffffc0205a20 <etext+0x6>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0205a40 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a4000ef          	jal	ffffffffc0200226 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	774020ef          	jal	ffffffffc02027fa <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	081000ef          	jal	ffffffffc020090a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	07f000ef          	jal	ffffffffc020090c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	445030ef          	jal	ffffffffc0203cd6 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	0a4050ef          	jal	ffffffffc020513a <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	45a000ef          	jal	ffffffffc02004f4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	061000ef          	jal	ffffffffc02008fe <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	238050ef          	jal	ffffffffc02052da <cpu_idle>

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
ffffffffc02000b6:	00006517          	auipc	a0,0x6
ffffffffc02000ba:	99250513          	addi	a0,a0,-1646 # ffffffffc0205a48 <etext+0x2e>
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
ffffffffc02000c6:	00097997          	auipc	s3,0x97
ffffffffc02000ca:	0f298993          	addi	s3,s3,242 # ffffffffc02971b8 <buf>
        c = getchar();
ffffffffc02000ce:	148000ef          	jal	ffffffffc0200216 <getchar>
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
ffffffffc02000fc:	11a000ef          	jal	ffffffffc0200216 <getchar>
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
ffffffffc0200140:	00097517          	auipc	a0,0x97
ffffffffc0200144:	07850513          	addi	a0,a0,120 # ffffffffc02971b8 <buf>
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
ffffffffc0200162:	3e6000ef          	jal	ffffffffc0200548 <cons_putc>
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
ffffffffc0200188:	44e050ef          	jal	ffffffffc02055d6 <vprintfmt>
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
ffffffffc02001bc:	41a050ef          	jal	ffffffffc02055d6 <vprintfmt>
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
ffffffffc02001c8:	a641                	j	ffffffffc0200548 <cons_putc>

ffffffffc02001ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ca:	1101                	addi	sp,sp,-32
ffffffffc02001cc:	e822                	sd	s0,16(sp)
ffffffffc02001ce:	ec06                	sd	ra,24(sp)
ffffffffc02001d0:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d2:	00054503          	lbu	a0,0(a0)
ffffffffc02001d6:	c51d                	beqz	a0,ffffffffc0200204 <cputs+0x3a>
ffffffffc02001d8:	e426                	sd	s1,8(sp)
ffffffffc02001da:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc02001dc:	4481                	li	s1,0
    cons_putc(c);
ffffffffc02001de:	36a000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e2:	00044503          	lbu	a0,0(s0)
ffffffffc02001e6:	0405                	addi	s0,s0,1
ffffffffc02001e8:	87a6                	mv	a5,s1
    (*cnt)++;
ffffffffc02001ea:	2485                	addiw	s1,s1,1
    while ((c = *str++) != '\0')
ffffffffc02001ec:	f96d                	bnez	a0,ffffffffc02001de <cputs+0x14>
    cons_putc(c);
ffffffffc02001ee:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f0:	0027841b          	addiw	s0,a5,2
ffffffffc02001f4:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001f6:	352000ef          	jal	ffffffffc0200548 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fa:	60e2                	ld	ra,24(sp)
ffffffffc02001fc:	8522                	mv	a0,s0
ffffffffc02001fe:	6442                	ld	s0,16(sp)
ffffffffc0200200:	6105                	addi	sp,sp,32
ffffffffc0200202:	8082                	ret
    cons_putc(c);
ffffffffc0200204:	4529                	li	a0,10
ffffffffc0200206:	342000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020a:	4405                	li	s0,1
}
ffffffffc020020c:	60e2                	ld	ra,24(sp)
ffffffffc020020e:	8522                	mv	a0,s0
ffffffffc0200210:	6442                	ld	s0,16(sp)
ffffffffc0200212:	6105                	addi	sp,sp,32
ffffffffc0200214:	8082                	ret

ffffffffc0200216 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200216:	1141                	addi	sp,sp,-16
ffffffffc0200218:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021a:	362000ef          	jal	ffffffffc020057c <cons_getc>
ffffffffc020021e:	dd75                	beqz	a0,ffffffffc020021a <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200220:	60a2                	ld	ra,8(sp)
ffffffffc0200222:	0141                	addi	sp,sp,16
ffffffffc0200224:	8082                	ret

ffffffffc0200226 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc0200226:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	00006517          	auipc	a0,0x6
ffffffffc020022c:	82850513          	addi	a0,a0,-2008 # ffffffffc0205a50 <etext+0x36>
{
ffffffffc0200230:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200232:	f63ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200236:	00000597          	auipc	a1,0x0
ffffffffc020023a:	e1458593          	addi	a1,a1,-492 # ffffffffc020004a <kern_init>
ffffffffc020023e:	00006517          	auipc	a0,0x6
ffffffffc0200242:	83250513          	addi	a0,a0,-1998 # ffffffffc0205a70 <etext+0x56>
ffffffffc0200246:	f4fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024a:	00005597          	auipc	a1,0x5
ffffffffc020024e:	7d058593          	addi	a1,a1,2000 # ffffffffc0205a1a <etext>
ffffffffc0200252:	00006517          	auipc	a0,0x6
ffffffffc0200256:	83e50513          	addi	a0,a0,-1986 # ffffffffc0205a90 <etext+0x76>
ffffffffc020025a:	f3bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020025e:	00097597          	auipc	a1,0x97
ffffffffc0200262:	f5a58593          	addi	a1,a1,-166 # ffffffffc02971b8 <buf>
ffffffffc0200266:	00006517          	auipc	a0,0x6
ffffffffc020026a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0205ab0 <etext+0x96>
ffffffffc020026e:	f27ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200272:	0009b597          	auipc	a1,0x9b
ffffffffc0200276:	3f658593          	addi	a1,a1,1014 # ffffffffc029b668 <end>
ffffffffc020027a:	00006517          	auipc	a0,0x6
ffffffffc020027e:	85650513          	addi	a0,a0,-1962 # ffffffffc0205ad0 <etext+0xb6>
ffffffffc0200282:	f13ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200286:	00000717          	auipc	a4,0x0
ffffffffc020028a:	dc470713          	addi	a4,a4,-572 # ffffffffc020004a <kern_init>
ffffffffc020028e:	0009b797          	auipc	a5,0x9b
ffffffffc0200292:	7d978793          	addi	a5,a5,2009 # ffffffffc029ba67 <end+0x3ff>
ffffffffc0200296:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200298:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029e:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a2:	95be                	add	a1,a1,a5
ffffffffc02002a4:	85a9                	srai	a1,a1,0xa
ffffffffc02002a6:	00006517          	auipc	a0,0x6
ffffffffc02002aa:	84a50513          	addi	a0,a0,-1974 # ffffffffc0205af0 <etext+0xd6>
}
ffffffffc02002ae:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b0:	b5d5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002b2 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002b2:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b4:	00006617          	auipc	a2,0x6
ffffffffc02002b8:	86c60613          	addi	a2,a2,-1940 # ffffffffc0205b20 <etext+0x106>
ffffffffc02002bc:	04f00593          	li	a1,79
ffffffffc02002c0:	00006517          	auipc	a0,0x6
ffffffffc02002c4:	87850513          	addi	a0,a0,-1928 # ffffffffc0205b38 <etext+0x11e>
{
ffffffffc02002c8:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ca:	17c000ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02002ce <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002ce:	1101                	addi	sp,sp,-32
ffffffffc02002d0:	e822                	sd	s0,16(sp)
ffffffffc02002d2:	e426                	sd	s1,8(sp)
ffffffffc02002d4:	ec06                	sd	ra,24(sp)
ffffffffc02002d6:	00007417          	auipc	s0,0x7
ffffffffc02002da:	4aa40413          	addi	s0,s0,1194 # ffffffffc0207780 <commands>
ffffffffc02002de:	00007497          	auipc	s1,0x7
ffffffffc02002e2:	4ea48493          	addi	s1,s1,1258 # ffffffffc02077c8 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	6410                	ld	a2,8(s0)
ffffffffc02002e8:	600c                	ld	a1,0(s0)
ffffffffc02002ea:	00006517          	auipc	a0,0x6
ffffffffc02002ee:	86650513          	addi	a0,a0,-1946 # ffffffffc0205b50 <etext+0x136>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f2:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002f4:	ea1ff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f8:	fe9417e3          	bne	s0,s1,ffffffffc02002e6 <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002fc:	60e2                	ld	ra,24(sp)
ffffffffc02002fe:	6442                	ld	s0,16(sp)
ffffffffc0200300:	64a2                	ld	s1,8(sp)
ffffffffc0200302:	4501                	li	a0,0
ffffffffc0200304:	6105                	addi	sp,sp,32
ffffffffc0200306:	8082                	ret

ffffffffc0200308 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200308:	1141                	addi	sp,sp,-16
ffffffffc020030a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020030c:	f1bff0ef          	jal	ffffffffc0200226 <print_kerninfo>
    return 0;
}
ffffffffc0200310:	60a2                	ld	ra,8(sp)
ffffffffc0200312:	4501                	li	a0,0
ffffffffc0200314:	0141                	addi	sp,sp,16
ffffffffc0200316:	8082                	ret

ffffffffc0200318 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200318:	1141                	addi	sp,sp,-16
ffffffffc020031a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020031c:	f97ff0ef          	jal	ffffffffc02002b2 <print_stackframe>
    return 0;
}
ffffffffc0200320:	60a2                	ld	ra,8(sp)
ffffffffc0200322:	4501                	li	a0,0
ffffffffc0200324:	0141                	addi	sp,sp,16
ffffffffc0200326:	8082                	ret

ffffffffc0200328 <kmonitor>:
{
ffffffffc0200328:	7131                	addi	sp,sp,-192
ffffffffc020032a:	e952                	sd	s4,144(sp)
ffffffffc020032c:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020032e:	00006517          	auipc	a0,0x6
ffffffffc0200332:	83250513          	addi	a0,a0,-1998 # ffffffffc0205b60 <etext+0x146>
{
ffffffffc0200336:	fd06                	sd	ra,184(sp)
ffffffffc0200338:	f922                	sd	s0,176(sp)
ffffffffc020033a:	f526                	sd	s1,168(sp)
ffffffffc020033c:	ed4e                	sd	s3,152(sp)
ffffffffc020033e:	e556                	sd	s5,136(sp)
ffffffffc0200340:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200342:	e53ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200346:	00006517          	auipc	a0,0x6
ffffffffc020034a:	84250513          	addi	a0,a0,-1982 # ffffffffc0205b88 <etext+0x16e>
ffffffffc020034e:	e47ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200352:	000a0563          	beqz	s4,ffffffffc020035c <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200356:	8552                	mv	a0,s4
ffffffffc0200358:	79c000ef          	jal	ffffffffc0200af4 <print_trapframe>
ffffffffc020035c:	00007a97          	auipc	s5,0x7
ffffffffc0200360:	424a8a93          	addi	s5,s5,1060 # ffffffffc0207780 <commands>
        if (argc == MAXARGS - 1)
ffffffffc0200364:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200366:	00006517          	auipc	a0,0x6
ffffffffc020036a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0205bb0 <etext+0x196>
ffffffffc020036e:	d39ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200372:	842a                	mv	s0,a0
ffffffffc0200374:	d96d                	beqz	a0,ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200376:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020037a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020037c:	e99d                	bnez	a1,ffffffffc02003b2 <kmonitor+0x8a>
    int argc = 0;
ffffffffc020037e:	8b26                	mv	s6,s1
    if (argc == 0)
ffffffffc0200380:	fe0b03e3          	beqz	s6,ffffffffc0200366 <kmonitor+0x3e>
ffffffffc0200384:	00007497          	auipc	s1,0x7
ffffffffc0200388:	3fc48493          	addi	s1,s1,1020 # ffffffffc0207780 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020038c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc020038e:	6582                	ld	a1,0(sp)
ffffffffc0200390:	6088                	ld	a0,0(s1)
ffffffffc0200392:	5f0050ef          	jal	ffffffffc0205982 <strcmp>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200396:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200398:	c149                	beqz	a0,ffffffffc020041a <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020039a:	2405                	addiw	s0,s0,1
ffffffffc020039c:	04e1                	addi	s1,s1,24
ffffffffc020039e:	fef418e3          	bne	s0,a5,ffffffffc020038e <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003a2:	6582                	ld	a1,0(sp)
ffffffffc02003a4:	00006517          	auipc	a0,0x6
ffffffffc02003a8:	83c50513          	addi	a0,a0,-1988 # ffffffffc0205be0 <etext+0x1c6>
ffffffffc02003ac:	de9ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003b0:	bf5d                	j	ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003b2:	00006517          	auipc	a0,0x6
ffffffffc02003b6:	80650513          	addi	a0,a0,-2042 # ffffffffc0205bb8 <etext+0x19e>
ffffffffc02003ba:	624050ef          	jal	ffffffffc02059de <strchr>
ffffffffc02003be:	c901                	beqz	a0,ffffffffc02003ce <kmonitor+0xa6>
ffffffffc02003c0:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc02003c4:	00040023          	sb	zero,0(s0)
ffffffffc02003c8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ca:	d9d5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003cc:	b7dd                	j	ffffffffc02003b2 <kmonitor+0x8a>
        if (*buf == '\0')
ffffffffc02003ce:	00044783          	lbu	a5,0(s0)
ffffffffc02003d2:	d7d5                	beqz	a5,ffffffffc020037e <kmonitor+0x56>
        if (argc == MAXARGS - 1)
ffffffffc02003d4:	03348b63          	beq	s1,s3,ffffffffc020040a <kmonitor+0xe2>
        argv[argc++] = buf;
ffffffffc02003d8:	00349793          	slli	a5,s1,0x3
ffffffffc02003dc:	978a                	add	a5,a5,sp
ffffffffc02003de:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e0:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc02003e4:	2485                	addiw	s1,s1,1
ffffffffc02003e6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e8:	e591                	bnez	a1,ffffffffc02003f4 <kmonitor+0xcc>
ffffffffc02003ea:	bf59                	j	ffffffffc0200380 <kmonitor+0x58>
ffffffffc02003ec:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc02003f0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003f2:	d5d1                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003f4:	00005517          	auipc	a0,0x5
ffffffffc02003f8:	7c450513          	addi	a0,a0,1988 # ffffffffc0205bb8 <etext+0x19e>
ffffffffc02003fc:	5e2050ef          	jal	ffffffffc02059de <strchr>
ffffffffc0200400:	d575                	beqz	a0,ffffffffc02003ec <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200402:	00044583          	lbu	a1,0(s0)
ffffffffc0200406:	dda5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc0200408:	b76d                	j	ffffffffc02003b2 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040a:	45c1                	li	a1,16
ffffffffc020040c:	00005517          	auipc	a0,0x5
ffffffffc0200410:	7b450513          	addi	a0,a0,1972 # ffffffffc0205bc0 <etext+0x1a6>
ffffffffc0200414:	d81ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200418:	b7c1                	j	ffffffffc02003d8 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041a:	00141793          	slli	a5,s0,0x1
ffffffffc020041e:	97a2                	add	a5,a5,s0
ffffffffc0200420:	078e                	slli	a5,a5,0x3
ffffffffc0200422:	97d6                	add	a5,a5,s5
ffffffffc0200424:	6b9c                	ld	a5,16(a5)
ffffffffc0200426:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042a:	8652                	mv	a2,s4
ffffffffc020042c:	002c                	addi	a1,sp,8
ffffffffc020042e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200430:	f2055be3          	bgez	a0,ffffffffc0200366 <kmonitor+0x3e>
}
ffffffffc0200434:	70ea                	ld	ra,184(sp)
ffffffffc0200436:	744a                	ld	s0,176(sp)
ffffffffc0200438:	74aa                	ld	s1,168(sp)
ffffffffc020043a:	69ea                	ld	s3,152(sp)
ffffffffc020043c:	6a4a                	ld	s4,144(sp)
ffffffffc020043e:	6aaa                	ld	s5,136(sp)
ffffffffc0200440:	6b0a                	ld	s6,128(sp)
ffffffffc0200442:	6129                	addi	sp,sp,192
ffffffffc0200444:	8082                	ret

ffffffffc0200446 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc0200446:	0009b317          	auipc	t1,0x9b
ffffffffc020044a:	19a33303          	ld	t1,410(t1) # ffffffffc029b5e0 <is_panic>
{
ffffffffc020044e:	715d                	addi	sp,sp,-80
ffffffffc0200450:	ec06                	sd	ra,24(sp)
ffffffffc0200452:	f436                	sd	a3,40(sp)
ffffffffc0200454:	f83a                	sd	a4,48(sp)
ffffffffc0200456:	fc3e                	sd	a5,56(sp)
ffffffffc0200458:	e0c2                	sd	a6,64(sp)
ffffffffc020045a:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc020045c:	02031e63          	bnez	t1,ffffffffc0200498 <__panic+0x52>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200460:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200462:	103c                	addi	a5,sp,40
ffffffffc0200464:	e822                	sd	s0,16(sp)
ffffffffc0200466:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200468:	862e                	mv	a2,a1
ffffffffc020046a:	85aa                	mv	a1,a0
ffffffffc020046c:	00006517          	auipc	a0,0x6
ffffffffc0200470:	81c50513          	addi	a0,a0,-2020 # ffffffffc0205c88 <etext+0x26e>
    is_panic = 1;
ffffffffc0200474:	0009b697          	auipc	a3,0x9b
ffffffffc0200478:	16e6b623          	sd	a4,364(a3) # ffffffffc029b5e0 <is_panic>
    va_start(ap, fmt);
ffffffffc020047c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047e:	d17ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cefff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020048a:	00006517          	auipc	a0,0x6
ffffffffc020048e:	81e50513          	addi	a0,a0,-2018 # ffffffffc0205ca8 <etext+0x28e>
ffffffffc0200492:	d03ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200496:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200498:	4501                	li	a0,0
ffffffffc020049a:	4581                	li	a1,0
ffffffffc020049c:	4601                	li	a2,0
ffffffffc020049e:	48a1                	li	a7,8
ffffffffc02004a0:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004a4:	460000ef          	jal	ffffffffc0200904 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004a8:	4501                	li	a0,0
ffffffffc02004aa:	e7fff0ef          	jal	ffffffffc0200328 <kmonitor>
    while (1)
ffffffffc02004ae:	bfed                	j	ffffffffc02004a8 <__panic+0x62>

ffffffffc02004b0 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004b0:	715d                	addi	sp,sp,-80
ffffffffc02004b2:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	02810313          	addi	t1,sp,40
{
ffffffffc02004b8:	8432                	mv	s0,a2
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ba:	862e                	mv	a2,a1
ffffffffc02004bc:	85aa                	mv	a1,a0
ffffffffc02004be:	00005517          	auipc	a0,0x5
ffffffffc02004c2:	7f250513          	addi	a0,a0,2034 # ffffffffc0205cb0 <etext+0x296>
{
ffffffffc02004c6:	ec06                	sd	ra,24(sp)
ffffffffc02004c8:	f436                	sd	a3,40(sp)
ffffffffc02004ca:	f83a                	sd	a4,48(sp)
ffffffffc02004cc:	fc3e                	sd	a5,56(sp)
ffffffffc02004ce:	e0c2                	sd	a6,64(sp)
ffffffffc02004d0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02004d2:	e41a                	sd	t1,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004d4:	cc1ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004d8:	65a2                	ld	a1,8(sp)
ffffffffc02004da:	8522                	mv	a0,s0
ffffffffc02004dc:	c99ff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004e0:	00005517          	auipc	a0,0x5
ffffffffc02004e4:	7c850513          	addi	a0,a0,1992 # ffffffffc0205ca8 <etext+0x28e>
ffffffffc02004e8:	cadff0ef          	jal	ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc02004ec:	60e2                	ld	ra,24(sp)
ffffffffc02004ee:	6442                	ld	s0,16(sp)
ffffffffc02004f0:	6161                	addi	sp,sp,80
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004f4:	67e1                	lui	a5,0x18
ffffffffc02004f6:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xe4e8>
ffffffffc02004fa:	0009b717          	auipc	a4,0x9b
ffffffffc02004fe:	0ef73723          	sd	a5,238(a4) # ffffffffc029b5e8 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200502:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200506:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200508:	953e                	add	a0,a0,a5
ffffffffc020050a:	4601                	li	a2,0
ffffffffc020050c:	4881                	li	a7,0
ffffffffc020050e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200512:	02000793          	li	a5,32
ffffffffc0200516:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020051a:	00005517          	auipc	a0,0x5
ffffffffc020051e:	7b650513          	addi	a0,a0,1974 # ffffffffc0205cd0 <etext+0x2b6>
    ticks = 0;
ffffffffc0200522:	0009b797          	auipc	a5,0x9b
ffffffffc0200526:	0c07b723          	sd	zero,206(a5) # ffffffffc029b5f0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020052a:	b1ad                	j	ffffffffc0200194 <cprintf>

ffffffffc020052c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	0009b797          	auipc	a5,0x9b
ffffffffc0200534:	0b87b783          	ld	a5,184(a5) # ffffffffc029b5e8 <timebase>
ffffffffc0200538:	4581                	li	a1,0
ffffffffc020053a:	4601                	li	a2,0
ffffffffc020053c:	953e                	add	a0,a0,a5
ffffffffc020053e:	4881                	li	a7,0
ffffffffc0200540:	00000073          	ecall
ffffffffc0200544:	8082                	ret

ffffffffc0200546 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200546:	8082                	ret

ffffffffc0200548 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200548:	100027f3          	csrr	a5,sstatus
ffffffffc020054c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020054e:	0ff57513          	zext.b	a0,a0
ffffffffc0200552:	e799                	bnez	a5,ffffffffc0200560 <cons_putc+0x18>
ffffffffc0200554:	4581                	li	a1,0
ffffffffc0200556:	4601                	li	a2,0
ffffffffc0200558:	4885                	li	a7,1
ffffffffc020055a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020055e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200560:	1101                	addi	sp,sp,-32
ffffffffc0200562:	ec06                	sd	ra,24(sp)
ffffffffc0200564:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200566:	39e000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020056a:	6522                	ld	a0,8(sp)
ffffffffc020056c:	4581                	li	a1,0
ffffffffc020056e:	4601                	li	a2,0
ffffffffc0200570:	4885                	li	a7,1
ffffffffc0200572:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200576:	60e2                	ld	ra,24(sp)
ffffffffc0200578:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc020057a:	a651                	j	ffffffffc02008fe <intr_enable>

ffffffffc020057c <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020057c:	100027f3          	csrr	a5,sstatus
ffffffffc0200580:	8b89                	andi	a5,a5,2
ffffffffc0200582:	eb89                	bnez	a5,ffffffffc0200594 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200584:	4501                	li	a0,0
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4889                	li	a7,2
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200592:	8082                	ret
int cons_getc(void) {
ffffffffc0200594:	1101                	addi	sp,sp,-32
ffffffffc0200596:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200598:	36c000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020059c:	4501                	li	a0,0
ffffffffc020059e:	4581                	li	a1,0
ffffffffc02005a0:	4601                	li	a2,0
ffffffffc02005a2:	4889                	li	a7,2
ffffffffc02005a4:	00000073          	ecall
ffffffffc02005a8:	2501                	sext.w	a0,a0
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ac:	352000ef          	jal	ffffffffc02008fe <intr_enable>
}
ffffffffc02005b0:	60e2                	ld	ra,24(sp)
ffffffffc02005b2:	6522                	ld	a0,8(sp)
ffffffffc02005b4:	6105                	addi	sp,sp,32
ffffffffc02005b6:	8082                	ret

ffffffffc02005b8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005b8:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc02005ba:	00005517          	auipc	a0,0x5
ffffffffc02005be:	73650513          	addi	a0,a0,1846 # ffffffffc0205cf0 <etext+0x2d6>
void dtb_init(void) {
ffffffffc02005c2:	f406                	sd	ra,40(sp)
ffffffffc02005c4:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005c6:	bcfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005ca:	0000b597          	auipc	a1,0xb
ffffffffc02005ce:	a365b583          	ld	a1,-1482(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc02005d2:	00005517          	auipc	a0,0x5
ffffffffc02005d6:	72e50513          	addi	a0,a0,1838 # ffffffffc0205d00 <etext+0x2e6>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005da:	0000b417          	auipc	s0,0xb
ffffffffc02005de:	a2e40413          	addi	s0,s0,-1490 # ffffffffc020b008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e2:	bb3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e6:	600c                	ld	a1,0(s0)
ffffffffc02005e8:	00005517          	auipc	a0,0x5
ffffffffc02005ec:	72850513          	addi	a0,a0,1832 # ffffffffc0205d10 <etext+0x2f6>
ffffffffc02005f0:	ba5ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005f4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005f6:	00005517          	auipc	a0,0x5
ffffffffc02005fa:	73250513          	addi	a0,a0,1842 # ffffffffc0205d28 <etext+0x30e>
    if (boot_dtb == 0) {
ffffffffc02005fe:	10070163          	beqz	a4,ffffffffc0200700 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200602:	57f5                	li	a5,-3
ffffffffc0200604:	07fa                	slli	a5,a5,0x1e
ffffffffc0200606:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200608:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020060a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020060e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe44885>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200612:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200616:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020061e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200622:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200626:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200628:	8e49                	or	a2,a2,a0
ffffffffc020062a:	0ff7f793          	zext.b	a5,a5
ffffffffc020062e:	8dd1                	or	a1,a1,a2
ffffffffc0200630:	07a2                	slli	a5,a5,0x8
ffffffffc0200632:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200634:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc0200638:	0cd59863          	bne	a1,a3,ffffffffc0200708 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020063c:	4710                	lw	a2,8(a4)
ffffffffc020063e:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200640:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200642:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200646:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064a:	01865e1b          	srliw	t3,a2,0x18
ffffffffc020064e:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200652:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200656:	0186959b          	slliw	a1,a3,0x18
ffffffffc020065a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020065e:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200662:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200666:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020066a:	01c56533          	or	a0,a0,t3
ffffffffc020066e:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200672:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200676:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067e:	0ff6f693          	zext.b	a3,a3
ffffffffc0200682:	8c49                	or	s0,s0,a0
ffffffffc0200684:	0622                	slli	a2,a2,0x8
ffffffffc0200686:	8fcd                	or	a5,a5,a1
ffffffffc0200688:	06a2                	slli	a3,a3,0x8
ffffffffc020068a:	8c51                	or	s0,s0,a2
ffffffffc020068c:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020068e:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200690:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200692:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200694:	9381                	srli	a5,a5,0x20
ffffffffc0200696:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200698:	4301                	li	t1,0
        switch (token) {
ffffffffc020069a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020069c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020069e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc02006a2:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a4:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a6:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006aa:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ae:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	8ed1                	or	a3,a3,a2
ffffffffc02006c0:	0ff77713          	zext.b	a4,a4
ffffffffc02006c4:	8fd5                	or	a5,a5,a3
ffffffffc02006c6:	0722                	slli	a4,a4,0x8
ffffffffc02006c8:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc02006ca:	05178763          	beq	a5,a7,ffffffffc0200718 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006ce:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc02006d0:	00f8e963          	bltu	a7,a5,ffffffffc02006e2 <dtb_init+0x12a>
ffffffffc02006d4:	07c78d63          	beq	a5,t3,ffffffffc020074e <dtb_init+0x196>
ffffffffc02006d8:	4709                	li	a4,2
ffffffffc02006da:	00e79763          	bne	a5,a4,ffffffffc02006e8 <dtb_init+0x130>
ffffffffc02006de:	4301                	li	t1,0
ffffffffc02006e0:	b7d1                	j	ffffffffc02006a4 <dtb_init+0xec>
ffffffffc02006e2:	4711                	li	a4,4
ffffffffc02006e4:	fce780e3          	beq	a5,a4,ffffffffc02006a4 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006e8:	00005517          	auipc	a0,0x5
ffffffffc02006ec:	70850513          	addi	a0,a0,1800 # ffffffffc0205df0 <etext+0x3d6>
ffffffffc02006f0:	aa5ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f4:	64e2                	ld	s1,24(sp)
ffffffffc02006f6:	6942                	ld	s2,16(sp)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	73050513          	addi	a0,a0,1840 # ffffffffc0205e28 <etext+0x40e>
}
ffffffffc0200700:	7402                	ld	s0,32(sp)
ffffffffc0200702:	70a2                	ld	ra,40(sp)
ffffffffc0200704:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200706:	b479                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200708:	7402                	ld	s0,32(sp)
ffffffffc020070a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020070c:	00005517          	auipc	a0,0x5
ffffffffc0200710:	63c50513          	addi	a0,a0,1596 # ffffffffc0205d48 <etext+0x32e>
}
ffffffffc0200714:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200716:	bcbd                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200718:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020071e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200722:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200732:	8ed1                	or	a3,a3,a2
ffffffffc0200734:	0ff77713          	zext.b	a4,a4
ffffffffc0200738:	8fd5                	or	a5,a5,a3
ffffffffc020073a:	0722                	slli	a4,a4,0x8
ffffffffc020073c:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020073e:	04031463          	bnez	t1,ffffffffc0200786 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200742:	1782                	slli	a5,a5,0x20
ffffffffc0200744:	9381                	srli	a5,a5,0x20
ffffffffc0200746:	043d                	addi	s0,s0,15
ffffffffc0200748:	943e                	add	s0,s0,a5
ffffffffc020074a:	9871                	andi	s0,s0,-4
                break;
ffffffffc020074c:	bfa1                	j	ffffffffc02006a4 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc020074e:	8522                	mv	a0,s0
ffffffffc0200750:	e01a                	sd	t1,0(sp)
ffffffffc0200752:	1ea050ef          	jal	ffffffffc020593c <strlen>
ffffffffc0200756:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200758:	4619                	li	a2,6
ffffffffc020075a:	8522                	mv	a0,s0
ffffffffc020075c:	00005597          	auipc	a1,0x5
ffffffffc0200760:	61458593          	addi	a1,a1,1556 # ffffffffc0205d70 <etext+0x356>
ffffffffc0200764:	252050ef          	jal	ffffffffc02059b6 <strncmp>
ffffffffc0200768:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020076a:	0411                	addi	s0,s0,4
ffffffffc020076c:	0004879b          	sext.w	a5,s1
ffffffffc0200770:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200772:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200776:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200778:	00a36333          	or	t1,t1,a0
                break;
ffffffffc020077c:	00ff0837          	lui	a6,0xff0
ffffffffc0200780:	488d                	li	a7,3
ffffffffc0200782:	4e05                	li	t3,1
ffffffffc0200784:	b705                	j	ffffffffc02006a4 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200786:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200788:	00005597          	auipc	a1,0x5
ffffffffc020078c:	5f058593          	addi	a1,a1,1520 # ffffffffc0205d78 <etext+0x35e>
ffffffffc0200790:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200792:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200796:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020079e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007a6:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007aa:	8ed1                	or	a3,a3,a2
ffffffffc02007ac:	0ff77713          	zext.b	a4,a4
ffffffffc02007b0:	0722                	slli	a4,a4,0x8
ffffffffc02007b2:	8d55                	or	a0,a0,a3
ffffffffc02007b4:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007b6:	1502                	slli	a0,a0,0x20
ffffffffc02007b8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ba:	954a                	add	a0,a0,s2
ffffffffc02007bc:	e01a                	sd	t1,0(sp)
ffffffffc02007be:	1c4050ef          	jal	ffffffffc0205982 <strcmp>
ffffffffc02007c2:	67a2                	ld	a5,8(sp)
ffffffffc02007c4:	473d                	li	a4,15
ffffffffc02007c6:	6302                	ld	t1,0(sp)
ffffffffc02007c8:	00ff0837          	lui	a6,0xff0
ffffffffc02007cc:	488d                	li	a7,3
ffffffffc02007ce:	4e05                	li	t3,1
ffffffffc02007d0:	f6f779e3          	bgeu	a4,a5,ffffffffc0200742 <dtb_init+0x18a>
ffffffffc02007d4:	f53d                	bnez	a0,ffffffffc0200742 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007d6:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007da:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007de:	00005517          	auipc	a0,0x5
ffffffffc02007e2:	5a250513          	addi	a0,a0,1442 # ffffffffc0205d80 <etext+0x366>
           fdt32_to_cpu(x >> 32);
ffffffffc02007e6:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ea:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007ee:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007f2:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0187959b          	slliw	a1,a5,0x18
ffffffffc02007fe:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200802:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080e:	01037333          	and	t1,t1,a6
ffffffffc0200812:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200816:	01e5e5b3          	or	a1,a1,t5
ffffffffc020081a:	0ff7f793          	zext.b	a5,a5
ffffffffc020081e:	01de6e33          	or	t3,t3,t4
ffffffffc0200822:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200826:	01067633          	and	a2,a2,a6
ffffffffc020082a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020082e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	07a2                	slli	a5,a5,0x8
ffffffffc0200834:	0108d89b          	srliw	a7,a7,0x10
ffffffffc0200838:	0186df1b          	srliw	t5,a3,0x18
ffffffffc020083c:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200840:	8ddd                	or	a1,a1,a5
ffffffffc0200842:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200846:	0186979b          	slliw	a5,a3,0x18
ffffffffc020084a:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084e:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020085a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085e:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200862:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200866:	08a2                	slli	a7,a7,0x8
ffffffffc0200868:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020086c:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200870:	0ff6f693          	zext.b	a3,a3
ffffffffc0200874:	01de6833          	or	a6,t3,t4
ffffffffc0200878:	0ff77713          	zext.b	a4,a4
ffffffffc020087c:	01166633          	or	a2,a2,a7
ffffffffc0200880:	0067e7b3          	or	a5,a5,t1
ffffffffc0200884:	06a2                	slli	a3,a3,0x8
ffffffffc0200886:	01046433          	or	s0,s0,a6
ffffffffc020088a:	0722                	slli	a4,a4,0x8
ffffffffc020088c:	8fd5                	or	a5,a5,a3
ffffffffc020088e:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200890:	1582                	slli	a1,a1,0x20
ffffffffc0200892:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200894:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200896:	9201                	srli	a2,a2,0x20
ffffffffc0200898:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020089a:	1402                	slli	s0,s0,0x20
ffffffffc020089c:	00b7e4b3          	or	s1,a5,a1
ffffffffc02008a0:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008a2:	8f3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008a6:	85a6                	mv	a1,s1
ffffffffc02008a8:	00005517          	auipc	a0,0x5
ffffffffc02008ac:	4f850513          	addi	a0,a0,1272 # ffffffffc0205da0 <etext+0x386>
ffffffffc02008b0:	8e5ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008b4:	01445613          	srli	a2,s0,0x14
ffffffffc02008b8:	85a2                	mv	a1,s0
ffffffffc02008ba:	00005517          	auipc	a0,0x5
ffffffffc02008be:	4fe50513          	addi	a0,a0,1278 # ffffffffc0205db8 <etext+0x39e>
ffffffffc02008c2:	8d3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008c6:	009405b3          	add	a1,s0,s1
ffffffffc02008ca:	15fd                	addi	a1,a1,-1
ffffffffc02008cc:	00005517          	auipc	a0,0x5
ffffffffc02008d0:	50c50513          	addi	a0,a0,1292 # ffffffffc0205dd8 <etext+0x3be>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc02008d8:	0009b797          	auipc	a5,0x9b
ffffffffc02008dc:	d297b423          	sd	s1,-728(a5) # ffffffffc029b600 <memory_base>
        memory_size = mem_size;
ffffffffc02008e0:	0009b797          	auipc	a5,0x9b
ffffffffc02008e4:	d087bc23          	sd	s0,-744(a5) # ffffffffc029b5f8 <memory_size>
ffffffffc02008e8:	b531                	j	ffffffffc02006f4 <dtb_init+0x13c>

ffffffffc02008ea <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008ea:	0009b517          	auipc	a0,0x9b
ffffffffc02008ee:	d1653503          	ld	a0,-746(a0) # ffffffffc029b600 <memory_base>
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008f4:	0009b517          	auipc	a0,0x9b
ffffffffc02008f8:	d0453503          	ld	a0,-764(a0) # ffffffffc029b5f8 <memory_size>
ffffffffc02008fc:	8082                	ret

ffffffffc02008fe <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02008fe:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200902:	8082                	ret

ffffffffc0200904 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200904:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200908:	8082                	ret

ffffffffc020090a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020090a:	8082                	ret

ffffffffc020090c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020090c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200910:	00000797          	auipc	a5,0x0
ffffffffc0200914:	57078793          	addi	a5,a5,1392 # ffffffffc0200e80 <__alltraps>
ffffffffc0200918:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020091c:	000407b7          	lui	a5,0x40
ffffffffc0200920:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200924:	8082                	ret

ffffffffc0200926 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200926:	610c                	ld	a1,0(a0)
{
ffffffffc0200928:	1141                	addi	sp,sp,-16
ffffffffc020092a:	e022                	sd	s0,0(sp)
ffffffffc020092c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020092e:	00005517          	auipc	a0,0x5
ffffffffc0200932:	51250513          	addi	a0,a0,1298 # ffffffffc0205e40 <etext+0x426>
{
ffffffffc0200936:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200938:	85dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020093c:	640c                	ld	a1,8(s0)
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	51a50513          	addi	a0,a0,1306 # ffffffffc0205e58 <etext+0x43e>
ffffffffc0200946:	84fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020094a:	680c                	ld	a1,16(s0)
ffffffffc020094c:	00005517          	auipc	a0,0x5
ffffffffc0200950:	52450513          	addi	a0,a0,1316 # ffffffffc0205e70 <etext+0x456>
ffffffffc0200954:	841ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200958:	6c0c                	ld	a1,24(s0)
ffffffffc020095a:	00005517          	auipc	a0,0x5
ffffffffc020095e:	52e50513          	addi	a0,a0,1326 # ffffffffc0205e88 <etext+0x46e>
ffffffffc0200962:	833ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200966:	700c                	ld	a1,32(s0)
ffffffffc0200968:	00005517          	auipc	a0,0x5
ffffffffc020096c:	53850513          	addi	a0,a0,1336 # ffffffffc0205ea0 <etext+0x486>
ffffffffc0200970:	825ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200974:	740c                	ld	a1,40(s0)
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	54250513          	addi	a0,a0,1346 # ffffffffc0205eb8 <etext+0x49e>
ffffffffc020097e:	817ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200982:	780c                	ld	a1,48(s0)
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	54c50513          	addi	a0,a0,1356 # ffffffffc0205ed0 <etext+0x4b6>
ffffffffc020098c:	809ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200990:	7c0c                	ld	a1,56(s0)
ffffffffc0200992:	00005517          	auipc	a0,0x5
ffffffffc0200996:	55650513          	addi	a0,a0,1366 # ffffffffc0205ee8 <etext+0x4ce>
ffffffffc020099a:	ffaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020099e:	602c                	ld	a1,64(s0)
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	56050513          	addi	a0,a0,1376 # ffffffffc0205f00 <etext+0x4e6>
ffffffffc02009a8:	fecff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009ac:	642c                	ld	a1,72(s0)
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	56a50513          	addi	a0,a0,1386 # ffffffffc0205f18 <etext+0x4fe>
ffffffffc02009b6:	fdeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ba:	682c                	ld	a1,80(s0)
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	57450513          	addi	a0,a0,1396 # ffffffffc0205f30 <etext+0x516>
ffffffffc02009c4:	fd0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009c8:	6c2c                	ld	a1,88(s0)
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	57e50513          	addi	a0,a0,1406 # ffffffffc0205f48 <etext+0x52e>
ffffffffc02009d2:	fc2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009d6:	702c                	ld	a1,96(s0)
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	58850513          	addi	a0,a0,1416 # ffffffffc0205f60 <etext+0x546>
ffffffffc02009e0:	fb4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009e4:	742c                	ld	a1,104(s0)
ffffffffc02009e6:	00005517          	auipc	a0,0x5
ffffffffc02009ea:	59250513          	addi	a0,a0,1426 # ffffffffc0205f78 <etext+0x55e>
ffffffffc02009ee:	fa6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f2:	782c                	ld	a1,112(s0)
ffffffffc02009f4:	00005517          	auipc	a0,0x5
ffffffffc02009f8:	59c50513          	addi	a0,a0,1436 # ffffffffc0205f90 <etext+0x576>
ffffffffc02009fc:	f98ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a00:	7c2c                	ld	a1,120(s0)
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	5a650513          	addi	a0,a0,1446 # ffffffffc0205fa8 <etext+0x58e>
ffffffffc0200a0a:	f8aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a0e:	604c                	ld	a1,128(s0)
ffffffffc0200a10:	00005517          	auipc	a0,0x5
ffffffffc0200a14:	5b050513          	addi	a0,a0,1456 # ffffffffc0205fc0 <etext+0x5a6>
ffffffffc0200a18:	f7cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a1c:	644c                	ld	a1,136(s0)
ffffffffc0200a1e:	00005517          	auipc	a0,0x5
ffffffffc0200a22:	5ba50513          	addi	a0,a0,1466 # ffffffffc0205fd8 <etext+0x5be>
ffffffffc0200a26:	f6eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a2a:	684c                	ld	a1,144(s0)
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	5c450513          	addi	a0,a0,1476 # ffffffffc0205ff0 <etext+0x5d6>
ffffffffc0200a34:	f60ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a38:	6c4c                	ld	a1,152(s0)
ffffffffc0200a3a:	00005517          	auipc	a0,0x5
ffffffffc0200a3e:	5ce50513          	addi	a0,a0,1486 # ffffffffc0206008 <etext+0x5ee>
ffffffffc0200a42:	f52ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a46:	704c                	ld	a1,160(s0)
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	5d850513          	addi	a0,a0,1496 # ffffffffc0206020 <etext+0x606>
ffffffffc0200a50:	f44ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a54:	744c                	ld	a1,168(s0)
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	5e250513          	addi	a0,a0,1506 # ffffffffc0206038 <etext+0x61e>
ffffffffc0200a5e:	f36ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a62:	784c                	ld	a1,176(s0)
ffffffffc0200a64:	00005517          	auipc	a0,0x5
ffffffffc0200a68:	5ec50513          	addi	a0,a0,1516 # ffffffffc0206050 <etext+0x636>
ffffffffc0200a6c:	f28ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a70:	7c4c                	ld	a1,184(s0)
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	5f650513          	addi	a0,a0,1526 # ffffffffc0206068 <etext+0x64e>
ffffffffc0200a7a:	f1aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a7e:	606c                	ld	a1,192(s0)
ffffffffc0200a80:	00005517          	auipc	a0,0x5
ffffffffc0200a84:	60050513          	addi	a0,a0,1536 # ffffffffc0206080 <etext+0x666>
ffffffffc0200a88:	f0cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a8c:	646c                	ld	a1,200(s0)
ffffffffc0200a8e:	00005517          	auipc	a0,0x5
ffffffffc0200a92:	60a50513          	addi	a0,a0,1546 # ffffffffc0206098 <etext+0x67e>
ffffffffc0200a96:	efeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a9a:	686c                	ld	a1,208(s0)
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	61450513          	addi	a0,a0,1556 # ffffffffc02060b0 <etext+0x696>
ffffffffc0200aa4:	ef0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aa8:	6c6c                	ld	a1,216(s0)
ffffffffc0200aaa:	00005517          	auipc	a0,0x5
ffffffffc0200aae:	61e50513          	addi	a0,a0,1566 # ffffffffc02060c8 <etext+0x6ae>
ffffffffc0200ab2:	ee2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ab6:	706c                	ld	a1,224(s0)
ffffffffc0200ab8:	00005517          	auipc	a0,0x5
ffffffffc0200abc:	62850513          	addi	a0,a0,1576 # ffffffffc02060e0 <etext+0x6c6>
ffffffffc0200ac0:	ed4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200ac4:	746c                	ld	a1,232(s0)
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	63250513          	addi	a0,a0,1586 # ffffffffc02060f8 <etext+0x6de>
ffffffffc0200ace:	ec6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad2:	786c                	ld	a1,240(s0)
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	63c50513          	addi	a0,a0,1596 # ffffffffc0206110 <etext+0x6f6>
ffffffffc0200adc:	eb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae0:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae2:	6402                	ld	s0,0(sp)
ffffffffc0200ae4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	64250513          	addi	a0,a0,1602 # ffffffffc0206128 <etext+0x70e>
}
ffffffffc0200aee:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200af0:	ea4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200af4 <print_trapframe>:
{
ffffffffc0200af4:	1141                	addi	sp,sp,-16
ffffffffc0200af6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200af8:	85aa                	mv	a1,a0
{
ffffffffc0200afa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200afc:	00005517          	auipc	a0,0x5
ffffffffc0200b00:	64450513          	addi	a0,a0,1604 # ffffffffc0206140 <etext+0x726>
{
ffffffffc0200b04:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b06:	e8eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b0a:	8522                	mv	a0,s0
ffffffffc0200b0c:	e1bff0ef          	jal	ffffffffc0200926 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b10:	10043583          	ld	a1,256(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	64450513          	addi	a0,a0,1604 # ffffffffc0206158 <etext+0x73e>
ffffffffc0200b1c:	e78ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00005517          	auipc	a0,0x5
ffffffffc0200b28:	64c50513          	addi	a0,a0,1612 # ffffffffc0206170 <etext+0x756>
ffffffffc0200b2c:	e68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b30:	11043583          	ld	a1,272(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	65450513          	addi	a0,a0,1620 # ffffffffc0206188 <etext+0x76e>
ffffffffc0200b3c:	e58ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b40:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b44:	6402                	ld	s0,0(sp)
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	65050513          	addi	a0,a0,1616 # ffffffffc0206198 <etext+0x77e>
}
ffffffffc0200b50:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b52:	e42ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b56 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200b56:	11853783          	ld	a5,280(a0)
ffffffffc0200b5a:	472d                	li	a4,11
ffffffffc0200b5c:	0786                	slli	a5,a5,0x1
ffffffffc0200b5e:	8385                	srli	a5,a5,0x1
ffffffffc0200b60:	0af76a63          	bltu	a4,a5,ffffffffc0200c14 <interrupt_handler+0xbe>
ffffffffc0200b64:	00007717          	auipc	a4,0x7
ffffffffc0200b68:	c6470713          	addi	a4,a4,-924 # ffffffffc02077c8 <commands+0x48>
ffffffffc0200b6c:	078a                	slli	a5,a5,0x2
ffffffffc0200b6e:	97ba                	add	a5,a5,a4
ffffffffc0200b70:	439c                	lw	a5,0(a5)
ffffffffc0200b72:	97ba                	add	a5,a5,a4
ffffffffc0200b74:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	69a50513          	addi	a0,a0,1690 # ffffffffc0206210 <etext+0x7f6>
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	66e50513          	addi	a0,a0,1646 # ffffffffc02061f0 <etext+0x7d6>
ffffffffc0200b8a:	e0aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200b8e:	00005517          	auipc	a0,0x5
ffffffffc0200b92:	62250513          	addi	a0,a0,1570 # ffffffffc02061b0 <etext+0x796>
ffffffffc0200b96:	dfeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	63650513          	addi	a0,a0,1590 # ffffffffc02061d0 <etext+0x7b6>
ffffffffc0200ba2:	df2ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200ba6:	1141                	addi	sp,sp,-16
ffffffffc0200ba8:	e406                	sd	ra,8(sp)
            /* 时间片轮转： 
            *(1) 设置下一次时钟中断（clock_set_next_event）
            *(2) ticks 计数器自增
            *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）
            */
            clock_set_next_event();
ffffffffc0200baa:	983ff0ef          	jal	ffffffffc020052c <clock_set_next_event>

            // 2) 递增全局时钟计数
            ticks++;
ffffffffc0200bae:	0009b797          	auipc	a5,0x9b
ffffffffc0200bb2:	a4278793          	addi	a5,a5,-1470 # ffffffffc029b5f0 <ticks>
ffffffffc0200bb6:	6394                	ld	a3,0(a5)

            // 3) 每到 100 次打印一次
            if (ticks % TICK_NUM == 0) {
ffffffffc0200bb8:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200bbc:	28f70713          	addi	a4,a4,655 # 28f5c28f <_binary_obj___user_exit_out_size+0x28f520d7>
            ticks++;
ffffffffc0200bc0:	0685                	addi	a3,a3,1
ffffffffc0200bc2:	e394                	sd	a3,0(a5)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200bc4:	6390                	ld	a2,0(a5)
ffffffffc0200bc6:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200bca:	1702                	slli	a4,a4,0x20
ffffffffc0200bcc:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <_binary_obj___user_exit_out_size+0x5c28540b>
ffffffffc0200bd0:	00265793          	srli	a5,a2,0x2
ffffffffc0200bd4:	9736                	add	a4,a4,a3
ffffffffc0200bd6:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200bda:	06400593          	li	a1,100
ffffffffc0200bde:	8389                	srli	a5,a5,0x2
ffffffffc0200be0:	02b787b3          	mul	a5,a5,a1
ffffffffc0200be4:	02f60963          	beq	a2,a5,ffffffffc0200c16 <interrupt_handler+0xc0>
                num++;         // 记录打印了几次“100 ticks”
                current->need_resched = 1;      // 触发调度，而不是原来的关闭
            }

            // 4) 打印到第 10 次时关机
            if (num == 10) {
ffffffffc0200be8:	0009b797          	auipc	a5,0x9b
ffffffffc0200bec:	a207b783          	ld	a5,-1504(a5) # ffffffffc029b608 <num>
ffffffffc0200bf0:	4729                	li	a4,10
ffffffffc0200bf2:	00e79863          	bne	a5,a4,ffffffffc0200c02 <interrupt_handler+0xac>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200bf6:	4501                	li	a0,0
ffffffffc0200bf8:	4581                	li	a1,0
ffffffffc0200bfa:	4601                	li	a2,0
ffffffffc0200bfc:	48a1                	li	a7,8
ffffffffc0200bfe:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c02:	60a2                	ld	ra,8(sp)
ffffffffc0200c04:	0141                	addi	sp,sp,16
ffffffffc0200c06:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c08:	00005517          	auipc	a0,0x5
ffffffffc0200c0c:	63850513          	addi	a0,a0,1592 # ffffffffc0206240 <etext+0x826>
ffffffffc0200c10:	d84ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c14:	b5c5                	j	ffffffffc0200af4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c16:	00005517          	auipc	a0,0x5
ffffffffc0200c1a:	61a50513          	addi	a0,a0,1562 # ffffffffc0206230 <etext+0x816>
ffffffffc0200c1e:	d76ff0ef          	jal	ffffffffc0200194 <cprintf>
                num++;         // 记录打印了几次“100 ticks”
ffffffffc0200c22:	0009b797          	auipc	a5,0x9b
ffffffffc0200c26:	9e67b783          	ld	a5,-1562(a5) # ffffffffc029b608 <num>
                current->need_resched = 1;      // 触发调度，而不是原来的关闭
ffffffffc0200c2a:	0009b717          	auipc	a4,0x9b
ffffffffc0200c2e:	a2673703          	ld	a4,-1498(a4) # ffffffffc029b650 <current>
ffffffffc0200c32:	4685                	li	a3,1
                num++;         // 记录打印了几次“100 ticks”
ffffffffc0200c34:	97b6                	add	a5,a5,a3
ffffffffc0200c36:	0009b617          	auipc	a2,0x9b
ffffffffc0200c3a:	9cf63923          	sd	a5,-1582(a2) # ffffffffc029b608 <num>
                current->need_resched = 1;      // 触发调度，而不是原来的关闭
ffffffffc0200c3e:	ef14                	sd	a3,24(a4)
ffffffffc0200c40:	bf45                	j	ffffffffc0200bf0 <interrupt_handler+0x9a>

ffffffffc0200c42 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c42:	11853583          	ld	a1,280(a0)
ffffffffc0200c46:	47bd                	li	a5,15
ffffffffc0200c48:	16b7ee63          	bltu	a5,a1,ffffffffc0200dc4 <exception_handler+0x182>
ffffffffc0200c4c:	00007717          	auipc	a4,0x7
ffffffffc0200c50:	bac70713          	addi	a4,a4,-1108 # ffffffffc02077f8 <commands+0x78>
ffffffffc0200c54:	00259793          	slli	a5,a1,0x2
ffffffffc0200c58:	97ba                	add	a5,a5,a4
ffffffffc0200c5a:	439c                	lw	a5,0(a5)
{
ffffffffc0200c5c:	1101                	addi	sp,sp,-32
ffffffffc0200c5e:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200c60:	97ba                	add	a5,a5,a4
ffffffffc0200c62:	86aa                	mv	a3,a0
ffffffffc0200c64:	8782                	jr	a5
        break;
    case CAUSE_FETCH_PAGE_FAULT:
    case CAUSE_LOAD_PAGE_FAULT:
    case CAUSE_STORE_PAGE_FAULT:
    {
        struct mm_struct *mm = (current == NULL) ? NULL : current->mm;
ffffffffc0200c66:	0009b797          	auipc	a5,0x9b
ffffffffc0200c6a:	9ea7b783          	ld	a5,-1558(a5) # ffffffffc029b650 <current>
ffffffffc0200c6e:	14078c63          	beqz	a5,ffffffffc0200dc6 <exception_handler+0x184>
ffffffffc0200c72:	7788                	ld	a0,40(a5)
        uintptr_t fault_va = tf->tval;
        uint32_t error_code = (tf->cause == CAUSE_STORE_PAGE_FAULT) ? PTE_W : 0;

        if (mm == NULL)
ffffffffc0200c74:	14050963          	beqz	a0,ffffffffc0200dc6 <exception_handler+0x184>
        uintptr_t fault_va = tf->tval;
ffffffffc0200c78:	1106b603          	ld	a2,272(a3)
        uint32_t error_code = (tf->cause == CAUSE_STORE_PAGE_FAULT) ? PTE_W : 0;
ffffffffc0200c7c:	15c5                	addi	a1,a1,-15
ffffffffc0200c7e:	0015b593          	seqz	a1,a1
        {
            print_trapframe(tf);
            panic("page fault with no mm\n");
        }

        ret = do_pgfault(mm, error_code, fault_va);
ffffffffc0200c82:	058a                	slli	a1,a1,0x2
        uintptr_t fault_va = tf->tval;
ffffffffc0200c84:	e436                	sd	a3,8(sp)
        ret = do_pgfault(mm, error_code, fault_va);
ffffffffc0200c86:	e032                	sd	a2,0(sp)
ffffffffc0200c88:	4d9020ef          	jal	ffffffffc0203960 <do_pgfault>
        if (ret != 0)
ffffffffc0200c8c:	66a2                	ld	a3,8(sp)
ffffffffc0200c8e:	10051363          	bnez	a0,ffffffffc0200d94 <exception_handler+0x152>
    }
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c92:	60e2                	ld	ra,24(sp)
ffffffffc0200c94:	6105                	addi	sp,sp,32
ffffffffc0200c96:	8082                	ret
ffffffffc0200c98:	e02a                	sd	a0,0(sp)
        cprintf("Environment call from S-mode\n");
ffffffffc0200c9a:	00005517          	auipc	a0,0x5
ffffffffc0200c9e:	6ae50513          	addi	a0,a0,1710 # ffffffffc0206348 <etext+0x92e>
ffffffffc0200ca2:	cf2ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200ca6:	6682                	ld	a3,0(sp)
ffffffffc0200ca8:	1086b783          	ld	a5,264(a3)
}
ffffffffc0200cac:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200cae:	0791                	addi	a5,a5,4
ffffffffc0200cb0:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200cb4:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200cb6:	0290406f          	j	ffffffffc02054de <syscall>
}
ffffffffc0200cba:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200cbc:	00005517          	auipc	a0,0x5
ffffffffc0200cc0:	5a450513          	addi	a0,a0,1444 # ffffffffc0206260 <etext+0x846>
}
ffffffffc0200cc4:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200cc6:	cceff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cca:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200ccc:	00005517          	auipc	a0,0x5
ffffffffc0200cd0:	5b450513          	addi	a0,a0,1460 # ffffffffc0206280 <etext+0x866>
}
ffffffffc0200cd4:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200cd6:	cbeff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cda:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200cdc:	00005517          	auipc	a0,0x5
ffffffffc0200ce0:	5c450513          	addi	a0,a0,1476 # ffffffffc02062a0 <etext+0x886>
}
ffffffffc0200ce4:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200ce6:	caeff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cea:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200cec:	00005517          	auipc	a0,0x5
ffffffffc0200cf0:	67c50513          	addi	a0,a0,1660 # ffffffffc0206368 <etext+0x94e>
}
ffffffffc0200cf4:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200cf6:	c9eff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cfa:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200cfc:	00005517          	auipc	a0,0x5
ffffffffc0200d00:	68c50513          	addi	a0,a0,1676 # ffffffffc0206388 <etext+0x96e>
}
ffffffffc0200d04:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200d06:	c8eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d0a:	e02a                	sd	a0,0(sp)
        cprintf("Breakpoint\n");
ffffffffc0200d0c:	00005517          	auipc	a0,0x5
ffffffffc0200d10:	5ac50513          	addi	a0,a0,1452 # ffffffffc02062b8 <etext+0x89e>
ffffffffc0200d14:	c80ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d18:	6682                	ld	a3,0(sp)
ffffffffc0200d1a:	47a9                	li	a5,10
ffffffffc0200d1c:	66d8                	ld	a4,136(a3)
ffffffffc0200d1e:	f6f71ae3          	bne	a4,a5,ffffffffc0200c92 <exception_handler+0x50>
            tf->epc += 4;
ffffffffc0200d22:	1086b783          	ld	a5,264(a3)
ffffffffc0200d26:	0791                	addi	a5,a5,4
ffffffffc0200d28:	10f6b423          	sd	a5,264(a3)
            syscall();
ffffffffc0200d2c:	7b2040ef          	jal	ffffffffc02054de <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d30:	0009b717          	auipc	a4,0x9b
ffffffffc0200d34:	92073703          	ld	a4,-1760(a4) # ffffffffc029b650 <current>
ffffffffc0200d38:	6502                	ld	a0,0(sp)
}
ffffffffc0200d3a:	60e2                	ld	ra,24(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d3c:	6b0c                	ld	a1,16(a4)
ffffffffc0200d3e:	6789                	lui	a5,0x2
ffffffffc0200d40:	95be                	add	a1,a1,a5
}
ffffffffc0200d42:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d44:	a429                	j	ffffffffc0200f4e <kernel_execve_ret>
}
ffffffffc0200d46:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200d48:	00005517          	auipc	a0,0x5
ffffffffc0200d4c:	58050513          	addi	a0,a0,1408 # ffffffffc02062c8 <etext+0x8ae>
}
ffffffffc0200d50:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200d52:	c42ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d56:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200d58:	00005517          	auipc	a0,0x5
ffffffffc0200d5c:	59050513          	addi	a0,a0,1424 # ffffffffc02062e8 <etext+0x8ce>
}
ffffffffc0200d60:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200d62:	c32ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d66:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200d68:	00005517          	auipc	a0,0x5
ffffffffc0200d6c:	5c850513          	addi	a0,a0,1480 # ffffffffc0206330 <etext+0x916>
}
ffffffffc0200d70:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200d72:	c22ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d7a:	bbad                	j	ffffffffc0200af4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d7c:	00005617          	auipc	a2,0x5
ffffffffc0200d80:	58460613          	addi	a2,a2,1412 # ffffffffc0206300 <etext+0x8e6>
ffffffffc0200d84:	0c800593          	li	a1,200
ffffffffc0200d88:	00005517          	auipc	a0,0x5
ffffffffc0200d8c:	59050513          	addi	a0,a0,1424 # ffffffffc0206318 <etext+0x8fe>
ffffffffc0200d90:	eb6ff0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("do_pgfault failed for va 0x%08lx, ret=%d\n", (unsigned long)fault_va, ret);
ffffffffc0200d94:	6582                	ld	a1,0(sp)
ffffffffc0200d96:	862a                	mv	a2,a0
ffffffffc0200d98:	e42a                	sd	a0,8(sp)
ffffffffc0200d9a:	00005517          	auipc	a0,0x5
ffffffffc0200d9e:	62650513          	addi	a0,a0,1574 # ffffffffc02063c0 <etext+0x9a6>
ffffffffc0200da2:	e036                	sd	a3,0(sp)
ffffffffc0200da4:	bf0ff0ef          	jal	ffffffffc0200194 <cprintf>
            print_trapframe(tf);
ffffffffc0200da8:	6502                	ld	a0,0(sp)
ffffffffc0200daa:	d4bff0ef          	jal	ffffffffc0200af4 <print_trapframe>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dae:	6682                	ld	a3,0(sp)
ffffffffc0200db0:	1006b703          	ld	a4,256(a3)
ffffffffc0200db4:	10077713          	andi	a4,a4,256
            if (trap_in_kernel(tf))
ffffffffc0200db8:	e715                	bnez	a4,ffffffffc0200de4 <exception_handler+0x1a2>
            do_exit(ret);
ffffffffc0200dba:	6522                	ld	a0,8(sp)
}
ffffffffc0200dbc:	60e2                	ld	ra,24(sp)
ffffffffc0200dbe:	6105                	addi	sp,sp,32
            do_exit(ret);
ffffffffc0200dc0:	0d30306f          	j	ffffffffc0204692 <do_exit>
        print_trapframe(tf);
ffffffffc0200dc4:	bb05                	j	ffffffffc0200af4 <print_trapframe>
            print_trapframe(tf);
ffffffffc0200dc6:	8536                	mv	a0,a3
ffffffffc0200dc8:	d2dff0ef          	jal	ffffffffc0200af4 <print_trapframe>
            panic("page fault with no mm\n");
ffffffffc0200dcc:	00005617          	auipc	a2,0x5
ffffffffc0200dd0:	5dc60613          	addi	a2,a2,1500 # ffffffffc02063a8 <etext+0x98e>
ffffffffc0200dd4:	0e800593          	li	a1,232
ffffffffc0200dd8:	00005517          	auipc	a0,0x5
ffffffffc0200ddc:	54050513          	addi	a0,a0,1344 # ffffffffc0206318 <etext+0x8fe>
ffffffffc0200de0:	e66ff0ef          	jal	ffffffffc0200446 <__panic>
                panic("unhandled page fault in kernel\n");
ffffffffc0200de4:	00005617          	auipc	a2,0x5
ffffffffc0200de8:	60c60613          	addi	a2,a2,1548 # ffffffffc02063f0 <etext+0x9d6>
ffffffffc0200dec:	0f200593          	li	a1,242
ffffffffc0200df0:	00005517          	auipc	a0,0x5
ffffffffc0200df4:	52850513          	addi	a0,a0,1320 # ffffffffc0206318 <etext+0x8fe>
ffffffffc0200df8:	e4eff0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0200dfc <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dfc:	0009b717          	auipc	a4,0x9b
ffffffffc0200e00:	85473703          	ld	a4,-1964(a4) # ffffffffc029b650 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e04:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200e08:	cf21                	beqz	a4,ffffffffc0200e60 <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e0a:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e0e:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200e12:	1101                	addi	sp,sp,-32
ffffffffc0200e14:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e16:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200e1a:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e1c:	e432                	sd	a2,8(sp)
ffffffffc0200e1e:	e042                	sd	a6,0(sp)
ffffffffc0200e20:	0205c763          	bltz	a1,ffffffffc0200e4e <trap+0x52>
        exception_handler(tf);
ffffffffc0200e24:	e1fff0ef          	jal	ffffffffc0200c42 <exception_handler>
ffffffffc0200e28:	6622                	ld	a2,8(sp)
ffffffffc0200e2a:	6802                	ld	a6,0(sp)
ffffffffc0200e2c:	0009b697          	auipc	a3,0x9b
ffffffffc0200e30:	82468693          	addi	a3,a3,-2012 # ffffffffc029b650 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e34:	6298                	ld	a4,0(a3)
ffffffffc0200e36:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200e3a:	e619                	bnez	a2,ffffffffc0200e48 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e3c:	0b072783          	lw	a5,176(a4)
ffffffffc0200e40:	8b85                	andi	a5,a5,1
ffffffffc0200e42:	e79d                	bnez	a5,ffffffffc0200e70 <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e44:	6f1c                	ld	a5,24(a4)
ffffffffc0200e46:	e38d                	bnez	a5,ffffffffc0200e68 <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e48:	60e2                	ld	ra,24(sp)
ffffffffc0200e4a:	6105                	addi	sp,sp,32
ffffffffc0200e4c:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e4e:	d09ff0ef          	jal	ffffffffc0200b56 <interrupt_handler>
ffffffffc0200e52:	6802                	ld	a6,0(sp)
ffffffffc0200e54:	6622                	ld	a2,8(sp)
ffffffffc0200e56:	0009a697          	auipc	a3,0x9a
ffffffffc0200e5a:	7fa68693          	addi	a3,a3,2042 # ffffffffc029b650 <current>
ffffffffc0200e5e:	bfd9                	j	ffffffffc0200e34 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e60:	0005c363          	bltz	a1,ffffffffc0200e66 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200e64:	bbf9                	j	ffffffffc0200c42 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200e66:	b9c5                	j	ffffffffc0200b56 <interrupt_handler>
}
ffffffffc0200e68:	60e2                	ld	ra,24(sp)
ffffffffc0200e6a:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e6c:	5860406f          	j	ffffffffc02053f2 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e70:	555d                	li	a0,-9
ffffffffc0200e72:	021030ef          	jal	ffffffffc0204692 <do_exit>
            if (current->need_resched)
ffffffffc0200e76:	0009a717          	auipc	a4,0x9a
ffffffffc0200e7a:	7da73703          	ld	a4,2010(a4) # ffffffffc029b650 <current>
ffffffffc0200e7e:	b7d9                	j	ffffffffc0200e44 <trap+0x48>

ffffffffc0200e80 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e80:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e84:	00011463          	bnez	sp,ffffffffc0200e8c <__alltraps+0xc>
ffffffffc0200e88:	14002173          	csrr	sp,sscratch
ffffffffc0200e8c:	712d                	addi	sp,sp,-288
ffffffffc0200e8e:	e002                	sd	zero,0(sp)
ffffffffc0200e90:	e406                	sd	ra,8(sp)
ffffffffc0200e92:	ec0e                	sd	gp,24(sp)
ffffffffc0200e94:	f012                	sd	tp,32(sp)
ffffffffc0200e96:	f416                	sd	t0,40(sp)
ffffffffc0200e98:	f81a                	sd	t1,48(sp)
ffffffffc0200e9a:	fc1e                	sd	t2,56(sp)
ffffffffc0200e9c:	e0a2                	sd	s0,64(sp)
ffffffffc0200e9e:	e4a6                	sd	s1,72(sp)
ffffffffc0200ea0:	e8aa                	sd	a0,80(sp)
ffffffffc0200ea2:	ecae                	sd	a1,88(sp)
ffffffffc0200ea4:	f0b2                	sd	a2,96(sp)
ffffffffc0200ea6:	f4b6                	sd	a3,104(sp)
ffffffffc0200ea8:	f8ba                	sd	a4,112(sp)
ffffffffc0200eaa:	fcbe                	sd	a5,120(sp)
ffffffffc0200eac:	e142                	sd	a6,128(sp)
ffffffffc0200eae:	e546                	sd	a7,136(sp)
ffffffffc0200eb0:	e94a                	sd	s2,144(sp)
ffffffffc0200eb2:	ed4e                	sd	s3,152(sp)
ffffffffc0200eb4:	f152                	sd	s4,160(sp)
ffffffffc0200eb6:	f556                	sd	s5,168(sp)
ffffffffc0200eb8:	f95a                	sd	s6,176(sp)
ffffffffc0200eba:	fd5e                	sd	s7,184(sp)
ffffffffc0200ebc:	e1e2                	sd	s8,192(sp)
ffffffffc0200ebe:	e5e6                	sd	s9,200(sp)
ffffffffc0200ec0:	e9ea                	sd	s10,208(sp)
ffffffffc0200ec2:	edee                	sd	s11,216(sp)
ffffffffc0200ec4:	f1f2                	sd	t3,224(sp)
ffffffffc0200ec6:	f5f6                	sd	t4,232(sp)
ffffffffc0200ec8:	f9fa                	sd	t5,240(sp)
ffffffffc0200eca:	fdfe                	sd	t6,248(sp)
ffffffffc0200ecc:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200ed0:	100024f3          	csrr	s1,sstatus
ffffffffc0200ed4:	14102973          	csrr	s2,sepc
ffffffffc0200ed8:	143029f3          	csrr	s3,stval
ffffffffc0200edc:	14202a73          	csrr	s4,scause
ffffffffc0200ee0:	e822                	sd	s0,16(sp)
ffffffffc0200ee2:	e226                	sd	s1,256(sp)
ffffffffc0200ee4:	e64a                	sd	s2,264(sp)
ffffffffc0200ee6:	ea4e                	sd	s3,272(sp)
ffffffffc0200ee8:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200eea:	850a                	mv	a0,sp
    jal trap
ffffffffc0200eec:	f11ff0ef          	jal	ffffffffc0200dfc <trap>

ffffffffc0200ef0 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ef0:	6492                	ld	s1,256(sp)
ffffffffc0200ef2:	6932                	ld	s2,264(sp)
ffffffffc0200ef4:	1004f413          	andi	s0,s1,256
ffffffffc0200ef8:	e401                	bnez	s0,ffffffffc0200f00 <__trapret+0x10>
ffffffffc0200efa:	1200                	addi	s0,sp,288
ffffffffc0200efc:	14041073          	csrw	sscratch,s0
ffffffffc0200f00:	10049073          	csrw	sstatus,s1
ffffffffc0200f04:	14191073          	csrw	sepc,s2
ffffffffc0200f08:	60a2                	ld	ra,8(sp)
ffffffffc0200f0a:	61e2                	ld	gp,24(sp)
ffffffffc0200f0c:	7202                	ld	tp,32(sp)
ffffffffc0200f0e:	72a2                	ld	t0,40(sp)
ffffffffc0200f10:	7342                	ld	t1,48(sp)
ffffffffc0200f12:	73e2                	ld	t2,56(sp)
ffffffffc0200f14:	6406                	ld	s0,64(sp)
ffffffffc0200f16:	64a6                	ld	s1,72(sp)
ffffffffc0200f18:	6546                	ld	a0,80(sp)
ffffffffc0200f1a:	65e6                	ld	a1,88(sp)
ffffffffc0200f1c:	7606                	ld	a2,96(sp)
ffffffffc0200f1e:	76a6                	ld	a3,104(sp)
ffffffffc0200f20:	7746                	ld	a4,112(sp)
ffffffffc0200f22:	77e6                	ld	a5,120(sp)
ffffffffc0200f24:	680a                	ld	a6,128(sp)
ffffffffc0200f26:	68aa                	ld	a7,136(sp)
ffffffffc0200f28:	694a                	ld	s2,144(sp)
ffffffffc0200f2a:	69ea                	ld	s3,152(sp)
ffffffffc0200f2c:	7a0a                	ld	s4,160(sp)
ffffffffc0200f2e:	7aaa                	ld	s5,168(sp)
ffffffffc0200f30:	7b4a                	ld	s6,176(sp)
ffffffffc0200f32:	7bea                	ld	s7,184(sp)
ffffffffc0200f34:	6c0e                	ld	s8,192(sp)
ffffffffc0200f36:	6cae                	ld	s9,200(sp)
ffffffffc0200f38:	6d4e                	ld	s10,208(sp)
ffffffffc0200f3a:	6dee                	ld	s11,216(sp)
ffffffffc0200f3c:	7e0e                	ld	t3,224(sp)
ffffffffc0200f3e:	7eae                	ld	t4,232(sp)
ffffffffc0200f40:	7f4e                	ld	t5,240(sp)
ffffffffc0200f42:	7fee                	ld	t6,248(sp)
ffffffffc0200f44:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f46:	10200073          	sret

ffffffffc0200f4a <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f4a:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f4c:	b755                	j	ffffffffc0200ef0 <__trapret>

ffffffffc0200f4e <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f4e:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f52:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f56:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f5a:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f5e:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f62:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f66:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f6a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f6e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f72:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f74:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f76:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f78:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f7a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f7c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f7e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f80:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f82:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f84:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f86:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f88:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f8a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f8c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f8e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f90:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f92:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f94:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f96:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f98:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f9a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f9c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f9e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200fa0:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200fa2:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200fa4:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200fa6:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200fa8:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200faa:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200fac:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200fae:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200fb0:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200fb2:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200fb4:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200fb6:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200fb8:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200fba:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fbc:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fbe:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fc0:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200fc2:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fc4:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200fc6:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fc8:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200fca:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fcc:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fce:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fd0:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fd2:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fd4:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fd6:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fd8:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fda:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fdc:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fde:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fe0:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fe2:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fe4:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fe6:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fe8:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fea:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fec:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fee:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200ff0:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200ff2:	812e                	mv	sp,a1
ffffffffc0200ff4:	bdf5                	j	ffffffffc0200ef0 <__trapret>

ffffffffc0200ff6 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200ff6:	00096797          	auipc	a5,0x96
ffffffffc0200ffa:	5c278793          	addi	a5,a5,1474 # ffffffffc02975b8 <free_area>
ffffffffc0200ffe:	e79c                	sd	a5,8(a5)
ffffffffc0201000:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201002:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201006:	8082                	ret

ffffffffc0201008 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201008:	00096517          	auipc	a0,0x96
ffffffffc020100c:	5c056503          	lwu	a0,1472(a0) # ffffffffc02975c8 <free_area+0x10>
ffffffffc0201010:	8082                	ret

ffffffffc0201012 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201012:	711d                	addi	sp,sp,-96
ffffffffc0201014:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201016:	00096917          	auipc	s2,0x96
ffffffffc020101a:	5a290913          	addi	s2,s2,1442 # ffffffffc02975b8 <free_area>
ffffffffc020101e:	00893783          	ld	a5,8(s2)
ffffffffc0201022:	ec86                	sd	ra,88(sp)
ffffffffc0201024:	e8a2                	sd	s0,80(sp)
ffffffffc0201026:	e4a6                	sd	s1,72(sp)
ffffffffc0201028:	fc4e                	sd	s3,56(sp)
ffffffffc020102a:	f852                	sd	s4,48(sp)
ffffffffc020102c:	f456                	sd	s5,40(sp)
ffffffffc020102e:	f05a                	sd	s6,32(sp)
ffffffffc0201030:	ec5e                	sd	s7,24(sp)
ffffffffc0201032:	e862                	sd	s8,16(sp)
ffffffffc0201034:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201036:	2f278363          	beq	a5,s2,ffffffffc020131c <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc020103a:	4401                	li	s0,0
ffffffffc020103c:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020103e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201042:	8b09                	andi	a4,a4,2
ffffffffc0201044:	2e070063          	beqz	a4,ffffffffc0201324 <default_check+0x312>
        count++, total += p->property;
ffffffffc0201048:	ff87a703          	lw	a4,-8(a5)
ffffffffc020104c:	679c                	ld	a5,8(a5)
ffffffffc020104e:	2485                	addiw	s1,s1,1
ffffffffc0201050:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201052:	ff2796e3          	bne	a5,s2,ffffffffc020103e <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0201056:	89a2                	mv	s3,s0
ffffffffc0201058:	741000ef          	jal	ffffffffc0201f98 <nr_free_pages>
ffffffffc020105c:	73351463          	bne	a0,s3,ffffffffc0201784 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201060:	4505                	li	a0,1
ffffffffc0201062:	6c5000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201066:	8a2a                	mv	s4,a0
ffffffffc0201068:	44050e63          	beqz	a0,ffffffffc02014c4 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020106c:	4505                	li	a0,1
ffffffffc020106e:	6b9000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201072:	89aa                	mv	s3,a0
ffffffffc0201074:	72050863          	beqz	a0,ffffffffc02017a4 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201078:	4505                	li	a0,1
ffffffffc020107a:	6ad000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020107e:	8aaa                	mv	s5,a0
ffffffffc0201080:	4c050263          	beqz	a0,ffffffffc0201544 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201084:	40a987b3          	sub	a5,s3,a0
ffffffffc0201088:	40aa0733          	sub	a4,s4,a0
ffffffffc020108c:	0017b793          	seqz	a5,a5
ffffffffc0201090:	00173713          	seqz	a4,a4
ffffffffc0201094:	8fd9                	or	a5,a5,a4
ffffffffc0201096:	30079763          	bnez	a5,ffffffffc02013a4 <default_check+0x392>
ffffffffc020109a:	313a0563          	beq	s4,s3,ffffffffc02013a4 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020109e:	000a2783          	lw	a5,0(s4)
ffffffffc02010a2:	2a079163          	bnez	a5,ffffffffc0201344 <default_check+0x332>
ffffffffc02010a6:	0009a783          	lw	a5,0(s3)
ffffffffc02010aa:	28079d63          	bnez	a5,ffffffffc0201344 <default_check+0x332>
ffffffffc02010ae:	411c                	lw	a5,0(a0)
ffffffffc02010b0:	28079a63          	bnez	a5,ffffffffc0201344 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc02010b4:	0009a797          	auipc	a5,0x9a
ffffffffc02010b8:	58c7b783          	ld	a5,1420(a5) # ffffffffc029b640 <pages>
ffffffffc02010bc:	00007617          	auipc	a2,0x7
ffffffffc02010c0:	ad463603          	ld	a2,-1324(a2) # ffffffffc0207b90 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010c4:	0009a697          	auipc	a3,0x9a
ffffffffc02010c8:	5746b683          	ld	a3,1396(a3) # ffffffffc029b638 <npage>
ffffffffc02010cc:	40fa0733          	sub	a4,s4,a5
ffffffffc02010d0:	8719                	srai	a4,a4,0x6
ffffffffc02010d2:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010d4:	0732                	slli	a4,a4,0xc
ffffffffc02010d6:	06b2                	slli	a3,a3,0xc
ffffffffc02010d8:	2ad77663          	bgeu	a4,a3,ffffffffc0201384 <default_check+0x372>
    return page - pages + nbase;
ffffffffc02010dc:	40f98733          	sub	a4,s3,a5
ffffffffc02010e0:	8719                	srai	a4,a4,0x6
ffffffffc02010e2:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010e4:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010e6:	4cd77f63          	bgeu	a4,a3,ffffffffc02015c4 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc02010ea:	40f507b3          	sub	a5,a0,a5
ffffffffc02010ee:	8799                	srai	a5,a5,0x6
ffffffffc02010f0:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010f2:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010f4:	32d7f863          	bgeu	a5,a3,ffffffffc0201424 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc02010f8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010fa:	00093c03          	ld	s8,0(s2)
ffffffffc02010fe:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0201102:	00096b17          	auipc	s6,0x96
ffffffffc0201106:	4c6b2b03          	lw	s6,1222(s6) # ffffffffc02975c8 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc020110a:	01293023          	sd	s2,0(s2)
ffffffffc020110e:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0201112:	00096797          	auipc	a5,0x96
ffffffffc0201116:	4a07ab23          	sw	zero,1206(a5) # ffffffffc02975c8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc020111a:	60d000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020111e:	2e051363          	bnez	a0,ffffffffc0201404 <default_check+0x3f2>
    free_page(p0);
ffffffffc0201122:	8552                	mv	a0,s4
ffffffffc0201124:	4585                	li	a1,1
ffffffffc0201126:	63b000ef          	jal	ffffffffc0201f60 <free_pages>
    free_page(p1);
ffffffffc020112a:	854e                	mv	a0,s3
ffffffffc020112c:	4585                	li	a1,1
ffffffffc020112e:	633000ef          	jal	ffffffffc0201f60 <free_pages>
    free_page(p2);
ffffffffc0201132:	8556                	mv	a0,s5
ffffffffc0201134:	4585                	li	a1,1
ffffffffc0201136:	62b000ef          	jal	ffffffffc0201f60 <free_pages>
    assert(nr_free == 3);
ffffffffc020113a:	00096717          	auipc	a4,0x96
ffffffffc020113e:	48e72703          	lw	a4,1166(a4) # ffffffffc02975c8 <free_area+0x10>
ffffffffc0201142:	478d                	li	a5,3
ffffffffc0201144:	2af71063          	bne	a4,a5,ffffffffc02013e4 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201148:	4505                	li	a0,1
ffffffffc020114a:	5dd000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020114e:	89aa                	mv	s3,a0
ffffffffc0201150:	26050a63          	beqz	a0,ffffffffc02013c4 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201154:	4505                	li	a0,1
ffffffffc0201156:	5d1000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020115a:	8aaa                	mv	s5,a0
ffffffffc020115c:	3c050463          	beqz	a0,ffffffffc0201524 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201160:	4505                	li	a0,1
ffffffffc0201162:	5c5000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201166:	8a2a                	mv	s4,a0
ffffffffc0201168:	38050e63          	beqz	a0,ffffffffc0201504 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc020116c:	4505                	li	a0,1
ffffffffc020116e:	5b9000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201172:	36051963          	bnez	a0,ffffffffc02014e4 <default_check+0x4d2>
    free_page(p0);
ffffffffc0201176:	4585                	li	a1,1
ffffffffc0201178:	854e                	mv	a0,s3
ffffffffc020117a:	5e7000ef          	jal	ffffffffc0201f60 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020117e:	00893783          	ld	a5,8(s2)
ffffffffc0201182:	1f278163          	beq	a5,s2,ffffffffc0201364 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc0201186:	4505                	li	a0,1
ffffffffc0201188:	59f000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020118c:	8caa                	mv	s9,a0
ffffffffc020118e:	30a99b63          	bne	s3,a0,ffffffffc02014a4 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc0201192:	4505                	li	a0,1
ffffffffc0201194:	593000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201198:	2e051663          	bnez	a0,ffffffffc0201484 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc020119c:	00096797          	auipc	a5,0x96
ffffffffc02011a0:	42c7a783          	lw	a5,1068(a5) # ffffffffc02975c8 <free_area+0x10>
ffffffffc02011a4:	2c079063          	bnez	a5,ffffffffc0201464 <default_check+0x452>
    free_page(p);
ffffffffc02011a8:	8566                	mv	a0,s9
ffffffffc02011aa:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02011ac:	01893023          	sd	s8,0(s2)
ffffffffc02011b0:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc02011b4:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc02011b8:	5a9000ef          	jal	ffffffffc0201f60 <free_pages>
    free_page(p1);
ffffffffc02011bc:	8556                	mv	a0,s5
ffffffffc02011be:	4585                	li	a1,1
ffffffffc02011c0:	5a1000ef          	jal	ffffffffc0201f60 <free_pages>
    free_page(p2);
ffffffffc02011c4:	8552                	mv	a0,s4
ffffffffc02011c6:	4585                	li	a1,1
ffffffffc02011c8:	599000ef          	jal	ffffffffc0201f60 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02011cc:	4515                	li	a0,5
ffffffffc02011ce:	559000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc02011d2:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02011d4:	26050863          	beqz	a0,ffffffffc0201444 <default_check+0x432>
ffffffffc02011d8:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc02011da:	8b89                	andi	a5,a5,2
ffffffffc02011dc:	54079463          	bnez	a5,ffffffffc0201724 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011e0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011e2:	00093b83          	ld	s7,0(s2)
ffffffffc02011e6:	00893b03          	ld	s6,8(s2)
ffffffffc02011ea:	01293023          	sd	s2,0(s2)
ffffffffc02011ee:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc02011f2:	535000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc02011f6:	50051763          	bnez	a0,ffffffffc0201704 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011fa:	08098a13          	addi	s4,s3,128
ffffffffc02011fe:	8552                	mv	a0,s4
ffffffffc0201200:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201202:	00096c17          	auipc	s8,0x96
ffffffffc0201206:	3c6c2c03          	lw	s8,966(s8) # ffffffffc02975c8 <free_area+0x10>
    nr_free = 0;
ffffffffc020120a:	00096797          	auipc	a5,0x96
ffffffffc020120e:	3a07af23          	sw	zero,958(a5) # ffffffffc02975c8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201212:	54f000ef          	jal	ffffffffc0201f60 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201216:	4511                	li	a0,4
ffffffffc0201218:	50f000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020121c:	4c051463          	bnez	a0,ffffffffc02016e4 <default_check+0x6d2>
ffffffffc0201220:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201224:	8b89                	andi	a5,a5,2
ffffffffc0201226:	48078f63          	beqz	a5,ffffffffc02016c4 <default_check+0x6b2>
ffffffffc020122a:	0909a503          	lw	a0,144(s3)
ffffffffc020122e:	478d                	li	a5,3
ffffffffc0201230:	48f51a63          	bne	a0,a5,ffffffffc02016c4 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201234:	4f3000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201238:	8aaa                	mv	s5,a0
ffffffffc020123a:	46050563          	beqz	a0,ffffffffc02016a4 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc020123e:	4505                	li	a0,1
ffffffffc0201240:	4e7000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0201244:	44051063          	bnez	a0,ffffffffc0201684 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc0201248:	415a1e63          	bne	s4,s5,ffffffffc0201664 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020124c:	4585                	li	a1,1
ffffffffc020124e:	854e                	mv	a0,s3
ffffffffc0201250:	511000ef          	jal	ffffffffc0201f60 <free_pages>
    free_pages(p1, 3);
ffffffffc0201254:	8552                	mv	a0,s4
ffffffffc0201256:	458d                	li	a1,3
ffffffffc0201258:	509000ef          	jal	ffffffffc0201f60 <free_pages>
ffffffffc020125c:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201260:	8b89                	andi	a5,a5,2
ffffffffc0201262:	3e078163          	beqz	a5,ffffffffc0201644 <default_check+0x632>
ffffffffc0201266:	0109aa83          	lw	s5,16(s3)
ffffffffc020126a:	4785                	li	a5,1
ffffffffc020126c:	3cfa9c63          	bne	s5,a5,ffffffffc0201644 <default_check+0x632>
ffffffffc0201270:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201274:	8b89                	andi	a5,a5,2
ffffffffc0201276:	3a078763          	beqz	a5,ffffffffc0201624 <default_check+0x612>
ffffffffc020127a:	010a2703          	lw	a4,16(s4)
ffffffffc020127e:	478d                	li	a5,3
ffffffffc0201280:	3af71263          	bne	a4,a5,ffffffffc0201624 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201284:	8556                	mv	a0,s5
ffffffffc0201286:	4a1000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020128a:	36a99d63          	bne	s3,a0,ffffffffc0201604 <default_check+0x5f2>
    free_page(p0);
ffffffffc020128e:	85d6                	mv	a1,s5
ffffffffc0201290:	4d1000ef          	jal	ffffffffc0201f60 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201294:	4509                	li	a0,2
ffffffffc0201296:	491000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc020129a:	34aa1563          	bne	s4,a0,ffffffffc02015e4 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc020129e:	4589                	li	a1,2
ffffffffc02012a0:	4c1000ef          	jal	ffffffffc0201f60 <free_pages>
    free_page(p2);
ffffffffc02012a4:	04098513          	addi	a0,s3,64
ffffffffc02012a8:	85d6                	mv	a1,s5
ffffffffc02012aa:	4b7000ef          	jal	ffffffffc0201f60 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012ae:	4515                	li	a0,5
ffffffffc02012b0:	477000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc02012b4:	89aa                	mv	s3,a0
ffffffffc02012b6:	48050763          	beqz	a0,ffffffffc0201744 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc02012ba:	8556                	mv	a0,s5
ffffffffc02012bc:	46b000ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc02012c0:	2e051263          	bnez	a0,ffffffffc02015a4 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc02012c4:	00096797          	auipc	a5,0x96
ffffffffc02012c8:	3047a783          	lw	a5,772(a5) # ffffffffc02975c8 <free_area+0x10>
ffffffffc02012cc:	2a079c63          	bnez	a5,ffffffffc0201584 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02012d0:	854e                	mv	a0,s3
ffffffffc02012d2:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc02012d4:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc02012d8:	01793023          	sd	s7,0(s2)
ffffffffc02012dc:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc02012e0:	481000ef          	jal	ffffffffc0201f60 <free_pages>
    return listelm->next;
ffffffffc02012e4:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012e8:	01278963          	beq	a5,s2,ffffffffc02012fa <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012ec:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012f0:	679c                	ld	a5,8(a5)
ffffffffc02012f2:	34fd                	addiw	s1,s1,-1
ffffffffc02012f4:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012f6:	ff279be3          	bne	a5,s2,ffffffffc02012ec <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc02012fa:	26049563          	bnez	s1,ffffffffc0201564 <default_check+0x552>
    assert(total == 0);
ffffffffc02012fe:	46041363          	bnez	s0,ffffffffc0201764 <default_check+0x752>
}
ffffffffc0201302:	60e6                	ld	ra,88(sp)
ffffffffc0201304:	6446                	ld	s0,80(sp)
ffffffffc0201306:	64a6                	ld	s1,72(sp)
ffffffffc0201308:	6906                	ld	s2,64(sp)
ffffffffc020130a:	79e2                	ld	s3,56(sp)
ffffffffc020130c:	7a42                	ld	s4,48(sp)
ffffffffc020130e:	7aa2                	ld	s5,40(sp)
ffffffffc0201310:	7b02                	ld	s6,32(sp)
ffffffffc0201312:	6be2                	ld	s7,24(sp)
ffffffffc0201314:	6c42                	ld	s8,16(sp)
ffffffffc0201316:	6ca2                	ld	s9,8(sp)
ffffffffc0201318:	6125                	addi	sp,sp,96
ffffffffc020131a:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc020131c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020131e:	4401                	li	s0,0
ffffffffc0201320:	4481                	li	s1,0
ffffffffc0201322:	bb1d                	j	ffffffffc0201058 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201324:	00005697          	auipc	a3,0x5
ffffffffc0201328:	0ec68693          	addi	a3,a3,236 # ffffffffc0206410 <etext+0x9f6>
ffffffffc020132c:	00005617          	auipc	a2,0x5
ffffffffc0201330:	0f460613          	addi	a2,a2,244 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201334:	11000593          	li	a1,272
ffffffffc0201338:	00005517          	auipc	a0,0x5
ffffffffc020133c:	10050513          	addi	a0,a0,256 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201340:	906ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201344:	00005697          	auipc	a3,0x5
ffffffffc0201348:	1b468693          	addi	a3,a3,436 # ffffffffc02064f8 <etext+0xade>
ffffffffc020134c:	00005617          	auipc	a2,0x5
ffffffffc0201350:	0d460613          	addi	a2,a2,212 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201354:	0dc00593          	li	a1,220
ffffffffc0201358:	00005517          	auipc	a0,0x5
ffffffffc020135c:	0e050513          	addi	a0,a0,224 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201360:	8e6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201364:	00005697          	auipc	a3,0x5
ffffffffc0201368:	25c68693          	addi	a3,a3,604 # ffffffffc02065c0 <etext+0xba6>
ffffffffc020136c:	00005617          	auipc	a2,0x5
ffffffffc0201370:	0b460613          	addi	a2,a2,180 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201374:	0f700593          	li	a1,247
ffffffffc0201378:	00005517          	auipc	a0,0x5
ffffffffc020137c:	0c050513          	addi	a0,a0,192 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201380:	8c6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201384:	00005697          	auipc	a3,0x5
ffffffffc0201388:	1b468693          	addi	a3,a3,436 # ffffffffc0206538 <etext+0xb1e>
ffffffffc020138c:	00005617          	auipc	a2,0x5
ffffffffc0201390:	09460613          	addi	a2,a2,148 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201394:	0de00593          	li	a1,222
ffffffffc0201398:	00005517          	auipc	a0,0x5
ffffffffc020139c:	0a050513          	addi	a0,a0,160 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02013a0:	8a6ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02013a4:	00005697          	auipc	a3,0x5
ffffffffc02013a8:	12c68693          	addi	a3,a3,300 # ffffffffc02064d0 <etext+0xab6>
ffffffffc02013ac:	00005617          	auipc	a2,0x5
ffffffffc02013b0:	07460613          	addi	a2,a2,116 # ffffffffc0206420 <etext+0xa06>
ffffffffc02013b4:	0db00593          	li	a1,219
ffffffffc02013b8:	00005517          	auipc	a0,0x5
ffffffffc02013bc:	08050513          	addi	a0,a0,128 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02013c0:	886ff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	0ac68693          	addi	a3,a3,172 # ffffffffc0206470 <etext+0xa56>
ffffffffc02013cc:	00005617          	auipc	a2,0x5
ffffffffc02013d0:	05460613          	addi	a2,a2,84 # ffffffffc0206420 <etext+0xa06>
ffffffffc02013d4:	0f000593          	li	a1,240
ffffffffc02013d8:	00005517          	auipc	a0,0x5
ffffffffc02013dc:	06050513          	addi	a0,a0,96 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02013e0:	866ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc02013e4:	00005697          	auipc	a3,0x5
ffffffffc02013e8:	1cc68693          	addi	a3,a3,460 # ffffffffc02065b0 <etext+0xb96>
ffffffffc02013ec:	00005617          	auipc	a2,0x5
ffffffffc02013f0:	03460613          	addi	a2,a2,52 # ffffffffc0206420 <etext+0xa06>
ffffffffc02013f4:	0ee00593          	li	a1,238
ffffffffc02013f8:	00005517          	auipc	a0,0x5
ffffffffc02013fc:	04050513          	addi	a0,a0,64 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201400:	846ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	19468693          	addi	a3,a3,404 # ffffffffc0206598 <etext+0xb7e>
ffffffffc020140c:	00005617          	auipc	a2,0x5
ffffffffc0201410:	01460613          	addi	a2,a2,20 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201414:	0e900593          	li	a1,233
ffffffffc0201418:	00005517          	auipc	a0,0x5
ffffffffc020141c:	02050513          	addi	a0,a0,32 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201420:	826ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	15468693          	addi	a3,a3,340 # ffffffffc0206578 <etext+0xb5e>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	ff460613          	addi	a2,a2,-12 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201434:	0e000593          	li	a1,224
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	00050513          	mv	a0,a0
ffffffffc0201440:	806ff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc0201444:	00005697          	auipc	a3,0x5
ffffffffc0201448:	1c468693          	addi	a3,a3,452 # ffffffffc0206608 <etext+0xbee>
ffffffffc020144c:	00005617          	auipc	a2,0x5
ffffffffc0201450:	fd460613          	addi	a2,a2,-44 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201454:	11800593          	li	a1,280
ffffffffc0201458:	00005517          	auipc	a0,0x5
ffffffffc020145c:	fe050513          	addi	a0,a0,-32 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201460:	fe7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201464:	00005697          	auipc	a3,0x5
ffffffffc0201468:	19468693          	addi	a3,a3,404 # ffffffffc02065f8 <etext+0xbde>
ffffffffc020146c:	00005617          	auipc	a2,0x5
ffffffffc0201470:	fb460613          	addi	a2,a2,-76 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201474:	0fd00593          	li	a1,253
ffffffffc0201478:	00005517          	auipc	a0,0x5
ffffffffc020147c:	fc050513          	addi	a0,a0,-64 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201480:	fc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201484:	00005697          	auipc	a3,0x5
ffffffffc0201488:	11468693          	addi	a3,a3,276 # ffffffffc0206598 <etext+0xb7e>
ffffffffc020148c:	00005617          	auipc	a2,0x5
ffffffffc0201490:	f9460613          	addi	a2,a2,-108 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201494:	0fb00593          	li	a1,251
ffffffffc0201498:	00005517          	auipc	a0,0x5
ffffffffc020149c:	fa050513          	addi	a0,a0,-96 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02014a0:	fa7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02014a4:	00005697          	auipc	a3,0x5
ffffffffc02014a8:	13468693          	addi	a3,a3,308 # ffffffffc02065d8 <etext+0xbbe>
ffffffffc02014ac:	00005617          	auipc	a2,0x5
ffffffffc02014b0:	f7460613          	addi	a2,a2,-140 # ffffffffc0206420 <etext+0xa06>
ffffffffc02014b4:	0fa00593          	li	a1,250
ffffffffc02014b8:	00005517          	auipc	a0,0x5
ffffffffc02014bc:	f8050513          	addi	a0,a0,-128 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02014c0:	f87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02014c4:	00005697          	auipc	a3,0x5
ffffffffc02014c8:	fac68693          	addi	a3,a3,-84 # ffffffffc0206470 <etext+0xa56>
ffffffffc02014cc:	00005617          	auipc	a2,0x5
ffffffffc02014d0:	f5460613          	addi	a2,a2,-172 # ffffffffc0206420 <etext+0xa06>
ffffffffc02014d4:	0d700593          	li	a1,215
ffffffffc02014d8:	00005517          	auipc	a0,0x5
ffffffffc02014dc:	f6050513          	addi	a0,a0,-160 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02014e0:	f67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	0b468693          	addi	a3,a3,180 # ffffffffc0206598 <etext+0xb7e>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	f3460613          	addi	a2,a2,-204 # ffffffffc0206420 <etext+0xa06>
ffffffffc02014f4:	0f400593          	li	a1,244
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	f4050513          	addi	a0,a0,-192 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201500:	f47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	fac68693          	addi	a3,a3,-84 # ffffffffc02064b0 <etext+0xa96>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	f1460613          	addi	a2,a2,-236 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201514:	0f200593          	li	a1,242
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	f2050513          	addi	a0,a0,-224 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201520:	f27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201524:	00005697          	auipc	a3,0x5
ffffffffc0201528:	f6c68693          	addi	a3,a3,-148 # ffffffffc0206490 <etext+0xa76>
ffffffffc020152c:	00005617          	auipc	a2,0x5
ffffffffc0201530:	ef460613          	addi	a2,a2,-268 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201534:	0f100593          	li	a1,241
ffffffffc0201538:	00005517          	auipc	a0,0x5
ffffffffc020153c:	f0050513          	addi	a0,a0,-256 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201540:	f07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201544:	00005697          	auipc	a3,0x5
ffffffffc0201548:	f6c68693          	addi	a3,a3,-148 # ffffffffc02064b0 <etext+0xa96>
ffffffffc020154c:	00005617          	auipc	a2,0x5
ffffffffc0201550:	ed460613          	addi	a2,a2,-300 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201554:	0d900593          	li	a1,217
ffffffffc0201558:	00005517          	auipc	a0,0x5
ffffffffc020155c:	ee050513          	addi	a0,a0,-288 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201560:	ee7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc0201564:	00005697          	auipc	a3,0x5
ffffffffc0201568:	1f468693          	addi	a3,a3,500 # ffffffffc0206758 <etext+0xd3e>
ffffffffc020156c:	00005617          	auipc	a2,0x5
ffffffffc0201570:	eb460613          	addi	a2,a2,-332 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201574:	14600593          	li	a1,326
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	ec050513          	addi	a0,a0,-320 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201580:	ec7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	07468693          	addi	a3,a3,116 # ffffffffc02065f8 <etext+0xbde>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	e9460613          	addi	a2,a2,-364 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201594:	13a00593          	li	a1,314
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	ea050513          	addi	a0,a0,-352 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02015a0:	ea7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	ff468693          	addi	a3,a3,-12 # ffffffffc0206598 <etext+0xb7e>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	e7460613          	addi	a2,a2,-396 # ffffffffc0206420 <etext+0xa06>
ffffffffc02015b4:	13800593          	li	a1,312
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	e8050513          	addi	a0,a0,-384 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02015c0:	e87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	f9468693          	addi	a3,a3,-108 # ffffffffc0206558 <etext+0xb3e>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	e5460613          	addi	a2,a2,-428 # ffffffffc0206420 <etext+0xa06>
ffffffffc02015d4:	0df00593          	li	a1,223
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	e6050513          	addi	a0,a0,-416 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02015e0:	e67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	13468693          	addi	a3,a3,308 # ffffffffc0206718 <etext+0xcfe>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	e3460613          	addi	a2,a2,-460 # ffffffffc0206420 <etext+0xa06>
ffffffffc02015f4:	13200593          	li	a1,306
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	e4050513          	addi	a0,a0,-448 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201600:	e47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	0f468693          	addi	a3,a3,244 # ffffffffc02066f8 <etext+0xcde>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	e1460613          	addi	a2,a2,-492 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201614:	13000593          	li	a1,304
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	e2050513          	addi	a0,a0,-480 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201620:	e27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	0ac68693          	addi	a3,a3,172 # ffffffffc02066d0 <etext+0xcb6>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	df460613          	addi	a2,a2,-524 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201634:	12e00593          	li	a1,302
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	e0050513          	addi	a0,a0,-512 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201640:	e07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	06468693          	addi	a3,a3,100 # ffffffffc02066a8 <etext+0xc8e>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	dd460613          	addi	a2,a2,-556 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201654:	12d00593          	li	a1,301
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	de050513          	addi	a0,a0,-544 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201660:	de7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	03468693          	addi	a3,a3,52 # ffffffffc0206698 <etext+0xc7e>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	db460613          	addi	a2,a2,-588 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201674:	12800593          	li	a1,296
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	dc050513          	addi	a0,a0,-576 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201680:	dc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	f1468693          	addi	a3,a3,-236 # ffffffffc0206598 <etext+0xb7e>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	d9460613          	addi	a2,a2,-620 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201694:	12700593          	li	a1,295
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	da050513          	addi	a0,a0,-608 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02016a0:	da7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	fd468693          	addi	a3,a3,-44 # ffffffffc0206678 <etext+0xc5e>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	d7460613          	addi	a2,a2,-652 # ffffffffc0206420 <etext+0xa06>
ffffffffc02016b4:	12600593          	li	a1,294
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	d8050513          	addi	a0,a0,-640 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02016c0:	d87fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	f8468693          	addi	a3,a3,-124 # ffffffffc0206648 <etext+0xc2e>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	d5460613          	addi	a2,a2,-684 # ffffffffc0206420 <etext+0xa06>
ffffffffc02016d4:	12500593          	li	a1,293
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	d6050513          	addi	a0,a0,-672 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02016e0:	d67fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	f4c68693          	addi	a3,a3,-180 # ffffffffc0206630 <etext+0xc16>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	d3460613          	addi	a2,a2,-716 # ffffffffc0206420 <etext+0xa06>
ffffffffc02016f4:	12400593          	li	a1,292
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	d4050513          	addi	a0,a0,-704 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201700:	d47fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	e9468693          	addi	a3,a3,-364 # ffffffffc0206598 <etext+0xb7e>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	d1460613          	addi	a2,a2,-748 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201714:	11e00593          	li	a1,286
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	d2050513          	addi	a0,a0,-736 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201720:	d27fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	ef468693          	addi	a3,a3,-268 # ffffffffc0206618 <etext+0xbfe>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	cf460613          	addi	a2,a2,-780 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201734:	11900593          	li	a1,281
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	d0050513          	addi	a0,a0,-768 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201740:	d07fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	ff468693          	addi	a3,a3,-12 # ffffffffc0206738 <etext+0xd1e>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	cd460613          	addi	a2,a2,-812 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201754:	13700593          	li	a1,311
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	ce050513          	addi	a0,a0,-800 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201760:	ce7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc0201764:	00005697          	auipc	a3,0x5
ffffffffc0201768:	00468693          	addi	a3,a3,4 # ffffffffc0206768 <etext+0xd4e>
ffffffffc020176c:	00005617          	auipc	a2,0x5
ffffffffc0201770:	cb460613          	addi	a2,a2,-844 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201774:	14700593          	li	a1,327
ffffffffc0201778:	00005517          	auipc	a0,0x5
ffffffffc020177c:	cc050513          	addi	a0,a0,-832 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201780:	cc7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201784:	00005697          	auipc	a3,0x5
ffffffffc0201788:	ccc68693          	addi	a3,a3,-820 # ffffffffc0206450 <etext+0xa36>
ffffffffc020178c:	00005617          	auipc	a2,0x5
ffffffffc0201790:	c9460613          	addi	a2,a2,-876 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201794:	11300593          	li	a1,275
ffffffffc0201798:	00005517          	auipc	a0,0x5
ffffffffc020179c:	ca050513          	addi	a0,a0,-864 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02017a0:	ca7fe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02017a4:	00005697          	auipc	a3,0x5
ffffffffc02017a8:	cec68693          	addi	a3,a3,-788 # ffffffffc0206490 <etext+0xa76>
ffffffffc02017ac:	00005617          	auipc	a2,0x5
ffffffffc02017b0:	c7460613          	addi	a2,a2,-908 # ffffffffc0206420 <etext+0xa06>
ffffffffc02017b4:	0d800593          	li	a1,216
ffffffffc02017b8:	00005517          	auipc	a0,0x5
ffffffffc02017bc:	c8050513          	addi	a0,a0,-896 # ffffffffc0206438 <etext+0xa1e>
ffffffffc02017c0:	c87fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02017c4 <default_free_pages>:
{
ffffffffc02017c4:	1141                	addi	sp,sp,-16
ffffffffc02017c6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017c8:	14058663          	beqz	a1,ffffffffc0201914 <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc02017cc:	00659713          	slli	a4,a1,0x6
ffffffffc02017d0:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02017d4:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02017d6:	c30d                	beqz	a4,ffffffffc02017f8 <default_free_pages+0x34>
ffffffffc02017d8:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017da:	8b05                	andi	a4,a4,1
ffffffffc02017dc:	10071c63          	bnez	a4,ffffffffc02018f4 <default_free_pages+0x130>
ffffffffc02017e0:	6798                	ld	a4,8(a5)
ffffffffc02017e2:	8b09                	andi	a4,a4,2
ffffffffc02017e4:	10071863          	bnez	a4,ffffffffc02018f4 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc02017e8:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017ec:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017f0:	04078793          	addi	a5,a5,64
ffffffffc02017f4:	fed792e3          	bne	a5,a3,ffffffffc02017d8 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017f8:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017fa:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017fe:	4789                	li	a5,2
ffffffffc0201800:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201804:	00096717          	auipc	a4,0x96
ffffffffc0201808:	dc472703          	lw	a4,-572(a4) # ffffffffc02975c8 <free_area+0x10>
ffffffffc020180c:	00096697          	auipc	a3,0x96
ffffffffc0201810:	dac68693          	addi	a3,a3,-596 # ffffffffc02975b8 <free_area>
    return list->next == list;
ffffffffc0201814:	669c                	ld	a5,8(a3)
ffffffffc0201816:	9f2d                	addw	a4,a4,a1
ffffffffc0201818:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc020181a:	0ad78163          	beq	a5,a3,ffffffffc02018bc <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc020181e:	fe878713          	addi	a4,a5,-24
ffffffffc0201822:	4581                	li	a1,0
ffffffffc0201824:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201828:	00e56a63          	bltu	a0,a4,ffffffffc020183c <default_free_pages+0x78>
    return listelm->next;
ffffffffc020182c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020182e:	04d70c63          	beq	a4,a3,ffffffffc0201886 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc0201832:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201834:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201838:	fee57ae3          	bgeu	a0,a4,ffffffffc020182c <default_free_pages+0x68>
ffffffffc020183c:	c199                	beqz	a1,ffffffffc0201842 <default_free_pages+0x7e>
ffffffffc020183e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201842:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201844:	e390                	sd	a2,0(a5)
ffffffffc0201846:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201848:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc020184a:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc020184c:	00d70d63          	beq	a4,a3,ffffffffc0201866 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201850:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201854:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201858:	02059813          	slli	a6,a1,0x20
ffffffffc020185c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201860:	97b2                	add	a5,a5,a2
ffffffffc0201862:	02f50c63          	beq	a0,a5,ffffffffc020189a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201866:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201868:	00d78c63          	beq	a5,a3,ffffffffc0201880 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020186c:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020186e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201872:	02061593          	slli	a1,a2,0x20
ffffffffc0201876:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020187a:	972a                	add	a4,a4,a0
ffffffffc020187c:	04e68c63          	beq	a3,a4,ffffffffc02018d4 <default_free_pages+0x110>
}
ffffffffc0201880:	60a2                	ld	ra,8(sp)
ffffffffc0201882:	0141                	addi	sp,sp,16
ffffffffc0201884:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201886:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201888:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020188a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020188c:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc020188e:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201890:	02d70f63          	beq	a4,a3,ffffffffc02018ce <default_free_pages+0x10a>
ffffffffc0201894:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201896:	87ba                	mv	a5,a4
ffffffffc0201898:	bf71                	j	ffffffffc0201834 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020189a:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020189c:	5875                	li	a6,-3
ffffffffc020189e:	9fad                	addw	a5,a5,a1
ffffffffc02018a0:	fef72c23          	sw	a5,-8(a4)
ffffffffc02018a4:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018a8:	01853803          	ld	a6,24(a0)
ffffffffc02018ac:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02018ae:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02018b0:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_exit_out_size+0xfe5e50>
    return listelm->next;
ffffffffc02018b4:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02018b6:	0105b023          	sd	a6,0(a1)
ffffffffc02018ba:	b77d                	j	ffffffffc0201868 <default_free_pages+0xa4>
}
ffffffffc02018bc:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02018be:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02018c2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02018c4:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02018c6:	e398                	sd	a4,0(a5)
ffffffffc02018c8:	e798                	sd	a4,8(a5)
}
ffffffffc02018ca:	0141                	addi	sp,sp,16
ffffffffc02018cc:	8082                	ret
ffffffffc02018ce:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02018d0:	873e                	mv	a4,a5
ffffffffc02018d2:	bfad                	j	ffffffffc020184c <default_free_pages+0x88>
            base->property += p->property;
ffffffffc02018d4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02018d8:	56f5                	li	a3,-3
ffffffffc02018da:	9f31                	addw	a4,a4,a2
ffffffffc02018dc:	c918                	sw	a4,16(a0)
ffffffffc02018de:	ff078713          	addi	a4,a5,-16
ffffffffc02018e2:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018e6:	6398                	ld	a4,0(a5)
ffffffffc02018e8:	679c                	ld	a5,8(a5)
}
ffffffffc02018ea:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018ec:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018ee:	e398                	sd	a4,0(a5)
ffffffffc02018f0:	0141                	addi	sp,sp,16
ffffffffc02018f2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018f4:	00005697          	auipc	a3,0x5
ffffffffc02018f8:	e8c68693          	addi	a3,a3,-372 # ffffffffc0206780 <etext+0xd66>
ffffffffc02018fc:	00005617          	auipc	a2,0x5
ffffffffc0201900:	b2460613          	addi	a2,a2,-1244 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201904:	09400593          	li	a1,148
ffffffffc0201908:	00005517          	auipc	a0,0x5
ffffffffc020190c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201910:	b37fe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201914:	00005697          	auipc	a3,0x5
ffffffffc0201918:	e6468693          	addi	a3,a3,-412 # ffffffffc0206778 <etext+0xd5e>
ffffffffc020191c:	00005617          	auipc	a2,0x5
ffffffffc0201920:	b0460613          	addi	a2,a2,-1276 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201924:	09000593          	li	a1,144
ffffffffc0201928:	00005517          	auipc	a0,0x5
ffffffffc020192c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201930:	b17fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201934 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201934:	c951                	beqz	a0,ffffffffc02019c8 <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc0201936:	00096597          	auipc	a1,0x96
ffffffffc020193a:	c925a583          	lw	a1,-878(a1) # ffffffffc02975c8 <free_area+0x10>
ffffffffc020193e:	86aa                	mv	a3,a0
ffffffffc0201940:	02059793          	slli	a5,a1,0x20
ffffffffc0201944:	9381                	srli	a5,a5,0x20
ffffffffc0201946:	00a7ef63          	bltu	a5,a0,ffffffffc0201964 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc020194a:	00096617          	auipc	a2,0x96
ffffffffc020194e:	c6e60613          	addi	a2,a2,-914 # ffffffffc02975b8 <free_area>
ffffffffc0201952:	87b2                	mv	a5,a2
ffffffffc0201954:	a029                	j	ffffffffc020195e <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc0201956:	ff87e703          	lwu	a4,-8(a5)
ffffffffc020195a:	00d77763          	bgeu	a4,a3,ffffffffc0201968 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc020195e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201960:	fec79be3          	bne	a5,a2,ffffffffc0201956 <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201964:	4501                	li	a0,0
}
ffffffffc0201966:	8082                	ret
        if (page->property > n)
ffffffffc0201968:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc020196c:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201970:	6798                	ld	a4,8(a5)
ffffffffc0201972:	02089313          	slli	t1,a7,0x20
ffffffffc0201976:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020197a:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc020197e:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201982:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc0201986:	0266fa63          	bgeu	a3,t1,ffffffffc02019ba <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc020198a:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc020198e:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc0201992:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201994:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201998:	00870313          	addi	t1,a4,8
ffffffffc020199c:	4889                	li	a7,2
ffffffffc020199e:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02019a2:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc02019a6:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc02019aa:	0068b023          	sd	t1,0(a7)
ffffffffc02019ae:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc02019b2:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc02019b6:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc02019ba:	9d95                	subw	a1,a1,a3
ffffffffc02019bc:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02019be:	5775                	li	a4,-3
ffffffffc02019c0:	17c1                	addi	a5,a5,-16
ffffffffc02019c2:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02019c6:	8082                	ret
{
ffffffffc02019c8:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02019ca:	00005697          	auipc	a3,0x5
ffffffffc02019ce:	dae68693          	addi	a3,a3,-594 # ffffffffc0206778 <etext+0xd5e>
ffffffffc02019d2:	00005617          	auipc	a2,0x5
ffffffffc02019d6:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0206420 <etext+0xa06>
ffffffffc02019da:	06c00593          	li	a1,108
ffffffffc02019de:	00005517          	auipc	a0,0x5
ffffffffc02019e2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0206438 <etext+0xa1e>
{
ffffffffc02019e6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019e8:	a5ffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02019ec <default_init_memmap>:
{
ffffffffc02019ec:	1141                	addi	sp,sp,-16
ffffffffc02019ee:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019f0:	c9e1                	beqz	a1,ffffffffc0201ac0 <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc02019f2:	00659713          	slli	a4,a1,0x6
ffffffffc02019f6:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02019fa:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc02019fc:	cf11                	beqz	a4,ffffffffc0201a18 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019fe:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201a00:	8b05                	andi	a4,a4,1
ffffffffc0201a02:	cf59                	beqz	a4,ffffffffc0201aa0 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201a04:	0007a823          	sw	zero,16(a5)
ffffffffc0201a08:	0007b423          	sd	zero,8(a5)
ffffffffc0201a0c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a10:	04078793          	addi	a5,a5,64
ffffffffc0201a14:	fed795e3          	bne	a5,a3,ffffffffc02019fe <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a18:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a1a:	4789                	li	a5,2
ffffffffc0201a1c:	00850713          	addi	a4,a0,8
ffffffffc0201a20:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a24:	00096717          	auipc	a4,0x96
ffffffffc0201a28:	ba472703          	lw	a4,-1116(a4) # ffffffffc02975c8 <free_area+0x10>
ffffffffc0201a2c:	00096697          	auipc	a3,0x96
ffffffffc0201a30:	b8c68693          	addi	a3,a3,-1140 # ffffffffc02975b8 <free_area>
    return list->next == list;
ffffffffc0201a34:	669c                	ld	a5,8(a3)
ffffffffc0201a36:	9f2d                	addw	a4,a4,a1
ffffffffc0201a38:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a3a:	04d78663          	beq	a5,a3,ffffffffc0201a86 <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a3e:	fe878713          	addi	a4,a5,-24
ffffffffc0201a42:	4581                	li	a1,0
ffffffffc0201a44:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201a48:	00e56a63          	bltu	a0,a4,ffffffffc0201a5c <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a4c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a4e:	02d70263          	beq	a4,a3,ffffffffc0201a72 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc0201a52:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a54:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a58:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a4c <default_init_memmap+0x60>
ffffffffc0201a5c:	c199                	beqz	a1,ffffffffc0201a62 <default_init_memmap+0x76>
ffffffffc0201a5e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a62:	6398                	ld	a4,0(a5)
}
ffffffffc0201a64:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a66:	e390                	sd	a2,0(a5)
ffffffffc0201a68:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201a6a:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201a6c:	f11c                	sd	a5,32(a0)
ffffffffc0201a6e:	0141                	addi	sp,sp,16
ffffffffc0201a70:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a72:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a74:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a76:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a78:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201a7a:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a7c:	00d70e63          	beq	a4,a3,ffffffffc0201a98 <default_init_memmap+0xac>
ffffffffc0201a80:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201a82:	87ba                	mv	a5,a4
ffffffffc0201a84:	bfc1                	j	ffffffffc0201a54 <default_init_memmap+0x68>
}
ffffffffc0201a86:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a88:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201a8c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a8e:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201a90:	e398                	sd	a4,0(a5)
ffffffffc0201a92:	e798                	sd	a4,8(a5)
}
ffffffffc0201a94:	0141                	addi	sp,sp,16
ffffffffc0201a96:	8082                	ret
ffffffffc0201a98:	60a2                	ld	ra,8(sp)
ffffffffc0201a9a:	e290                	sd	a2,0(a3)
ffffffffc0201a9c:	0141                	addi	sp,sp,16
ffffffffc0201a9e:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201aa0:	00005697          	auipc	a3,0x5
ffffffffc0201aa4:	d0868693          	addi	a3,a3,-760 # ffffffffc02067a8 <etext+0xd8e>
ffffffffc0201aa8:	00005617          	auipc	a2,0x5
ffffffffc0201aac:	97860613          	addi	a2,a2,-1672 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201ab0:	04b00593          	li	a1,75
ffffffffc0201ab4:	00005517          	auipc	a0,0x5
ffffffffc0201ab8:	98450513          	addi	a0,a0,-1660 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201abc:	98bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201ac0:	00005697          	auipc	a3,0x5
ffffffffc0201ac4:	cb868693          	addi	a3,a3,-840 # ffffffffc0206778 <etext+0xd5e>
ffffffffc0201ac8:	00005617          	auipc	a2,0x5
ffffffffc0201acc:	95860613          	addi	a2,a2,-1704 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201ad0:	04700593          	li	a1,71
ffffffffc0201ad4:	00005517          	auipc	a0,0x5
ffffffffc0201ad8:	96450513          	addi	a0,a0,-1692 # ffffffffc0206438 <etext+0xa1e>
ffffffffc0201adc:	96bfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201ae0 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201ae0:	c531                	beqz	a0,ffffffffc0201b2c <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201ae2:	e9b9                	bnez	a1,ffffffffc0201b38 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ae8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201aea:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aec:	efb1                	bnez	a5,ffffffffc0201b48 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aee:	00095797          	auipc	a5,0x95
ffffffffc0201af2:	6ba7b783          	ld	a5,1722(a5) # ffffffffc02971a8 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201af6:	873e                	mv	a4,a5
ffffffffc0201af8:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201afa:	02a77a63          	bgeu	a4,a0,ffffffffc0201b2e <slob_free+0x4e>
ffffffffc0201afe:	00f56463          	bltu	a0,a5,ffffffffc0201b06 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b02:	fef76ae3          	bltu	a4,a5,ffffffffc0201af6 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b06:	4110                	lw	a2,0(a0)
ffffffffc0201b08:	00461693          	slli	a3,a2,0x4
ffffffffc0201b0c:	96aa                	add	a3,a3,a0
ffffffffc0201b0e:	0ad78463          	beq	a5,a3,ffffffffc0201bb6 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b12:	4310                	lw	a2,0(a4)
ffffffffc0201b14:	e51c                	sd	a5,8(a0)
ffffffffc0201b16:	00461693          	slli	a3,a2,0x4
ffffffffc0201b1a:	96ba                	add	a3,a3,a4
ffffffffc0201b1c:	08d50163          	beq	a0,a3,ffffffffc0201b9e <slob_free+0xbe>
ffffffffc0201b20:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201b22:	00095797          	auipc	a5,0x95
ffffffffc0201b26:	68e7b323          	sd	a4,1670(a5) # ffffffffc02971a8 <slobfree>
    if (flag)
ffffffffc0201b2a:	e9a5                	bnez	a1,ffffffffc0201b9a <slob_free+0xba>
ffffffffc0201b2c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b2e:	fcf574e3          	bgeu	a0,a5,ffffffffc0201af6 <slob_free+0x16>
ffffffffc0201b32:	fcf762e3          	bltu	a4,a5,ffffffffc0201af6 <slob_free+0x16>
ffffffffc0201b36:	bfc1                	j	ffffffffc0201b06 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201b38:	25bd                	addiw	a1,a1,15
ffffffffc0201b3a:	8191                	srli	a1,a1,0x4
ffffffffc0201b3c:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0201b42:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b44:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b46:	d7c5                	beqz	a5,ffffffffc0201aee <slob_free+0xe>
{
ffffffffc0201b48:	1101                	addi	sp,sp,-32
ffffffffc0201b4a:	e42a                	sd	a0,8(sp)
ffffffffc0201b4c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201b4e:	db7fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201b52:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b54:	00095797          	auipc	a5,0x95
ffffffffc0201b58:	6547b783          	ld	a5,1620(a5) # ffffffffc02971a8 <slobfree>
ffffffffc0201b5c:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b5e:	873e                	mv	a4,a5
ffffffffc0201b60:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b62:	06a77663          	bgeu	a4,a0,ffffffffc0201bce <slob_free+0xee>
ffffffffc0201b66:	00f56463          	bltu	a0,a5,ffffffffc0201b6e <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b6a:	fef76ae3          	bltu	a4,a5,ffffffffc0201b5e <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201b6e:	4110                	lw	a2,0(a0)
ffffffffc0201b70:	00461693          	slli	a3,a2,0x4
ffffffffc0201b74:	96aa                	add	a3,a3,a0
ffffffffc0201b76:	06d78363          	beq	a5,a3,ffffffffc0201bdc <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201b7a:	4310                	lw	a2,0(a4)
ffffffffc0201b7c:	e51c                	sd	a5,8(a0)
ffffffffc0201b7e:	00461693          	slli	a3,a2,0x4
ffffffffc0201b82:	96ba                	add	a3,a3,a4
ffffffffc0201b84:	06d50163          	beq	a0,a3,ffffffffc0201be6 <slob_free+0x106>
ffffffffc0201b88:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201b8a:	00095797          	auipc	a5,0x95
ffffffffc0201b8e:	60e7bf23          	sd	a4,1566(a5) # ffffffffc02971a8 <slobfree>
    if (flag)
ffffffffc0201b92:	e1a9                	bnez	a1,ffffffffc0201bd4 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b94:	60e2                	ld	ra,24(sp)
ffffffffc0201b96:	6105                	addi	sp,sp,32
ffffffffc0201b98:	8082                	ret
        intr_enable();
ffffffffc0201b9a:	d65fe06f          	j	ffffffffc02008fe <intr_enable>
		cur->units += b->units;
ffffffffc0201b9e:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201ba0:	853e                	mv	a0,a5
ffffffffc0201ba2:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201ba4:	00c687bb          	addw	a5,a3,a2
ffffffffc0201ba8:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201baa:	00095797          	auipc	a5,0x95
ffffffffc0201bae:	5ee7bf23          	sd	a4,1534(a5) # ffffffffc02971a8 <slobfree>
    if (flag)
ffffffffc0201bb2:	ddad                	beqz	a1,ffffffffc0201b2c <slob_free+0x4c>
ffffffffc0201bb4:	b7dd                	j	ffffffffc0201b9a <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201bb6:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201bb8:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201bba:	9eb1                	addw	a3,a3,a2
ffffffffc0201bbc:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201bbe:	4310                	lw	a2,0(a4)
ffffffffc0201bc0:	e51c                	sd	a5,8(a0)
ffffffffc0201bc2:	00461693          	slli	a3,a2,0x4
ffffffffc0201bc6:	96ba                	add	a3,a3,a4
ffffffffc0201bc8:	f4d51ce3          	bne	a0,a3,ffffffffc0201b20 <slob_free+0x40>
ffffffffc0201bcc:	bfc9                	j	ffffffffc0201b9e <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201bce:	f8f56ee3          	bltu	a0,a5,ffffffffc0201b6a <slob_free+0x8a>
ffffffffc0201bd2:	b771                	j	ffffffffc0201b5e <slob_free+0x7e>
}
ffffffffc0201bd4:	60e2                	ld	ra,24(sp)
ffffffffc0201bd6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201bd8:	d27fe06f          	j	ffffffffc02008fe <intr_enable>
		b->units += cur->next->units;
ffffffffc0201bdc:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201bde:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201be0:	9eb1                	addw	a3,a3,a2
ffffffffc0201be2:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201be4:	bf59                	j	ffffffffc0201b7a <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201be6:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201be8:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201bea:	00c687bb          	addw	a5,a3,a2
ffffffffc0201bee:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201bf0:	bf61                	j	ffffffffc0201b88 <slob_free+0xa8>

ffffffffc0201bf2 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bf2:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bf4:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bf6:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bfa:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bfc:	32a000ef          	jal	ffffffffc0201f26 <alloc_pages>
	if (!page)
ffffffffc0201c00:	c91d                	beqz	a0,ffffffffc0201c36 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201c02:	0009a697          	auipc	a3,0x9a
ffffffffc0201c06:	a3e6b683          	ld	a3,-1474(a3) # ffffffffc029b640 <pages>
ffffffffc0201c0a:	00006797          	auipc	a5,0x6
ffffffffc0201c0e:	f867b783          	ld	a5,-122(a5) # ffffffffc0207b90 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201c12:	0009a717          	auipc	a4,0x9a
ffffffffc0201c16:	a2673703          	ld	a4,-1498(a4) # ffffffffc029b638 <npage>
    return page - pages + nbase;
ffffffffc0201c1a:	8d15                	sub	a0,a0,a3
ffffffffc0201c1c:	8519                	srai	a0,a0,0x6
ffffffffc0201c1e:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201c20:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c24:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c26:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201c28:	00e7fa63          	bgeu	a5,a4,ffffffffc0201c3c <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c2c:	0009a797          	auipc	a5,0x9a
ffffffffc0201c30:	a047b783          	ld	a5,-1532(a5) # ffffffffc029b630 <va_pa_offset>
ffffffffc0201c34:	953e                	add	a0,a0,a5
}
ffffffffc0201c36:	60a2                	ld	ra,8(sp)
ffffffffc0201c38:	0141                	addi	sp,sp,16
ffffffffc0201c3a:	8082                	ret
ffffffffc0201c3c:	86aa                	mv	a3,a0
ffffffffc0201c3e:	00005617          	auipc	a2,0x5
ffffffffc0201c42:	b9260613          	addi	a2,a2,-1134 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0201c46:	07100593          	li	a1,113
ffffffffc0201c4a:	00005517          	auipc	a0,0x5
ffffffffc0201c4e:	bae50513          	addi	a0,a0,-1106 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0201c52:	ff4fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201c56 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201c56:	7179                	addi	sp,sp,-48
ffffffffc0201c58:	f406                	sd	ra,40(sp)
ffffffffc0201c5a:	f022                	sd	s0,32(sp)
ffffffffc0201c5c:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c5e:	01050713          	addi	a4,a0,16
ffffffffc0201c62:	6785                	lui	a5,0x1
ffffffffc0201c64:	0af77e63          	bgeu	a4,a5,ffffffffc0201d20 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c68:	00f50413          	addi	s0,a0,15
ffffffffc0201c6c:	8011                	srli	s0,s0,0x4
ffffffffc0201c6e:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c70:	100025f3          	csrr	a1,sstatus
ffffffffc0201c74:	8989                	andi	a1,a1,2
ffffffffc0201c76:	edd1                	bnez	a1,ffffffffc0201d12 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201c78:	00095497          	auipc	s1,0x95
ffffffffc0201c7c:	53048493          	addi	s1,s1,1328 # ffffffffc02971a8 <slobfree>
ffffffffc0201c80:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c82:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201c84:	4314                	lw	a3,0(a4)
ffffffffc0201c86:	0886da63          	bge	a3,s0,ffffffffc0201d1a <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201c8a:	00e60a63          	beq	a2,a4,ffffffffc0201c9e <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c8e:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201c90:	4394                	lw	a3,0(a5)
ffffffffc0201c92:	0286d863          	bge	a3,s0,ffffffffc0201cc2 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201c96:	6090                	ld	a2,0(s1)
ffffffffc0201c98:	873e                	mv	a4,a5
ffffffffc0201c9a:	fee61ae3          	bne	a2,a4,ffffffffc0201c8e <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201c9e:	e9b1                	bnez	a1,ffffffffc0201cf2 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201ca0:	4501                	li	a0,0
ffffffffc0201ca2:	f51ff0ef          	jal	ffffffffc0201bf2 <__slob_get_free_pages.constprop.0>
ffffffffc0201ca6:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201ca8:	c915                	beqz	a0,ffffffffc0201cdc <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201caa:	6585                	lui	a1,0x1
ffffffffc0201cac:	e35ff0ef          	jal	ffffffffc0201ae0 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cb0:	100025f3          	csrr	a1,sstatus
ffffffffc0201cb4:	8989                	andi	a1,a1,2
ffffffffc0201cb6:	e98d                	bnez	a1,ffffffffc0201ce8 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201cb8:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cba:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201cbc:	4394                	lw	a3,0(a5)
ffffffffc0201cbe:	fc86cce3          	blt	a3,s0,ffffffffc0201c96 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201cc2:	04d40563          	beq	s0,a3,ffffffffc0201d0c <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201cc6:	00441613          	slli	a2,s0,0x4
ffffffffc0201cca:	963e                	add	a2,a2,a5
ffffffffc0201ccc:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201cce:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201cd0:	9e81                	subw	a3,a3,s0
ffffffffc0201cd2:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201cd4:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201cd6:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201cd8:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201cda:	ed99                	bnez	a1,ffffffffc0201cf8 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201cdc:	70a2                	ld	ra,40(sp)
ffffffffc0201cde:	7402                	ld	s0,32(sp)
ffffffffc0201ce0:	64e2                	ld	s1,24(sp)
ffffffffc0201ce2:	853e                	mv	a0,a5
ffffffffc0201ce4:	6145                	addi	sp,sp,48
ffffffffc0201ce6:	8082                	ret
        intr_disable();
ffffffffc0201ce8:	c1dfe0ef          	jal	ffffffffc0200904 <intr_disable>
			cur = slobfree;
ffffffffc0201cec:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201cee:	4585                	li	a1,1
ffffffffc0201cf0:	b7e9                	j	ffffffffc0201cba <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201cf2:	c0dfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201cf6:	b76d                	j	ffffffffc0201ca0 <slob_alloc.constprop.0+0x4a>
ffffffffc0201cf8:	e43e                	sd	a5,8(sp)
ffffffffc0201cfa:	c05fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201cfe:	67a2                	ld	a5,8(sp)
}
ffffffffc0201d00:	70a2                	ld	ra,40(sp)
ffffffffc0201d02:	7402                	ld	s0,32(sp)
ffffffffc0201d04:	64e2                	ld	s1,24(sp)
ffffffffc0201d06:	853e                	mv	a0,a5
ffffffffc0201d08:	6145                	addi	sp,sp,48
ffffffffc0201d0a:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201d0c:	6794                	ld	a3,8(a5)
ffffffffc0201d0e:	e714                	sd	a3,8(a4)
ffffffffc0201d10:	b7e1                	j	ffffffffc0201cd8 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201d12:	bf3fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201d16:	4585                	li	a1,1
ffffffffc0201d18:	b785                	j	ffffffffc0201c78 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201d1a:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201d1c:	8732                	mv	a4,a2
ffffffffc0201d1e:	b755                	j	ffffffffc0201cc2 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d20:	00005697          	auipc	a3,0x5
ffffffffc0201d24:	ae868693          	addi	a3,a3,-1304 # ffffffffc0206808 <etext+0xdee>
ffffffffc0201d28:	00004617          	auipc	a2,0x4
ffffffffc0201d2c:	6f860613          	addi	a2,a2,1784 # ffffffffc0206420 <etext+0xa06>
ffffffffc0201d30:	06300593          	li	a1,99
ffffffffc0201d34:	00005517          	auipc	a0,0x5
ffffffffc0201d38:	af450513          	addi	a0,a0,-1292 # ffffffffc0206828 <etext+0xe0e>
ffffffffc0201d3c:	f0afe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201d40 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201d40:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201d42:	00005517          	auipc	a0,0x5
ffffffffc0201d46:	afe50513          	addi	a0,a0,-1282 # ffffffffc0206840 <etext+0xe26>
{
ffffffffc0201d4a:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201d4c:	c48fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201d50:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d52:	00005517          	auipc	a0,0x5
ffffffffc0201d56:	b0650513          	addi	a0,a0,-1274 # ffffffffc0206858 <etext+0xe3e>
}
ffffffffc0201d5a:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d5c:	c38fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d60 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d60:	4501                	li	a0,0
ffffffffc0201d62:	8082                	ret

ffffffffc0201d64 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d64:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d66:	6685                	lui	a3,0x1
{
ffffffffc0201d68:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d6a:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7bc1>
ffffffffc0201d6c:	04a6f963          	bgeu	a3,a0,ffffffffc0201dbe <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d70:	e42a                	sd	a0,8(sp)
ffffffffc0201d72:	4561                	li	a0,24
ffffffffc0201d74:	e822                	sd	s0,16(sp)
ffffffffc0201d76:	ee1ff0ef          	jal	ffffffffc0201c56 <slob_alloc.constprop.0>
ffffffffc0201d7a:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201d7c:	c541                	beqz	a0,ffffffffc0201e04 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201d7e:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201d80:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201d82:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d84:	00f75763          	bge	a4,a5,ffffffffc0201d92 <kmalloc+0x2e>
ffffffffc0201d88:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201d8c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d8e:	fef74de3          	blt	a4,a5,ffffffffc0201d88 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201d92:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d94:	e5fff0ef          	jal	ffffffffc0201bf2 <__slob_get_free_pages.constprop.0>
ffffffffc0201d98:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201d9a:	cd31                	beqz	a0,ffffffffc0201df6 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201da0:	8b89                	andi	a5,a5,2
ffffffffc0201da2:	eb85                	bnez	a5,ffffffffc0201dd2 <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201da4:	0009a797          	auipc	a5,0x9a
ffffffffc0201da8:	86c7b783          	ld	a5,-1940(a5) # ffffffffc029b610 <bigblocks>
		bigblocks = bb;
ffffffffc0201dac:	0009a717          	auipc	a4,0x9a
ffffffffc0201db0:	86873223          	sd	s0,-1948(a4) # ffffffffc029b610 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201db4:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201db6:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201db8:	60e2                	ld	ra,24(sp)
ffffffffc0201dba:	6105                	addi	sp,sp,32
ffffffffc0201dbc:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201dbe:	0541                	addi	a0,a0,16
ffffffffc0201dc0:	e97ff0ef          	jal	ffffffffc0201c56 <slob_alloc.constprop.0>
ffffffffc0201dc4:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201dc6:	0541                	addi	a0,a0,16
ffffffffc0201dc8:	fbe5                	bnez	a5,ffffffffc0201db8 <kmalloc+0x54>
		return 0;
ffffffffc0201dca:	4501                	li	a0,0
}
ffffffffc0201dcc:	60e2                	ld	ra,24(sp)
ffffffffc0201dce:	6105                	addi	sp,sp,32
ffffffffc0201dd0:	8082                	ret
        intr_disable();
ffffffffc0201dd2:	b33fe0ef          	jal	ffffffffc0200904 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201dd6:	0009a797          	auipc	a5,0x9a
ffffffffc0201dda:	83a7b783          	ld	a5,-1990(a5) # ffffffffc029b610 <bigblocks>
		bigblocks = bb;
ffffffffc0201dde:	0009a717          	auipc	a4,0x9a
ffffffffc0201de2:	82873923          	sd	s0,-1998(a4) # ffffffffc029b610 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201de6:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201de8:	b17fe0ef          	jal	ffffffffc02008fe <intr_enable>
		return bb->pages;
ffffffffc0201dec:	6408                	ld	a0,8(s0)
}
ffffffffc0201dee:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201df0:	6442                	ld	s0,16(sp)
}
ffffffffc0201df2:	6105                	addi	sp,sp,32
ffffffffc0201df4:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201df6:	8522                	mv	a0,s0
ffffffffc0201df8:	45e1                	li	a1,24
ffffffffc0201dfa:	ce7ff0ef          	jal	ffffffffc0201ae0 <slob_free>
		return 0;
ffffffffc0201dfe:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e00:	6442                	ld	s0,16(sp)
ffffffffc0201e02:	b7e9                	j	ffffffffc0201dcc <kmalloc+0x68>
ffffffffc0201e04:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201e06:	4501                	li	a0,0
ffffffffc0201e08:	b7d1                	j	ffffffffc0201dcc <kmalloc+0x68>

ffffffffc0201e0a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201e0a:	c571                	beqz	a0,ffffffffc0201ed6 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201e0c:	03451793          	slli	a5,a0,0x34
ffffffffc0201e10:	e3e1                	bnez	a5,ffffffffc0201ed0 <kfree+0xc6>
{
ffffffffc0201e12:	1101                	addi	sp,sp,-32
ffffffffc0201e14:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e16:	100027f3          	csrr	a5,sstatus
ffffffffc0201e1a:	8b89                	andi	a5,a5,2
ffffffffc0201e1c:	e7c1                	bnez	a5,ffffffffc0201ea4 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e1e:	00099797          	auipc	a5,0x99
ffffffffc0201e22:	7f27b783          	ld	a5,2034(a5) # ffffffffc029b610 <bigblocks>
    return 0;
ffffffffc0201e26:	4581                	li	a1,0
ffffffffc0201e28:	cbad                	beqz	a5,ffffffffc0201e9a <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201e2a:	00099617          	auipc	a2,0x99
ffffffffc0201e2e:	7e660613          	addi	a2,a2,2022 # ffffffffc029b610 <bigblocks>
ffffffffc0201e32:	a021                	j	ffffffffc0201e3a <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e34:	01070613          	addi	a2,a4,16
ffffffffc0201e38:	c3a5                	beqz	a5,ffffffffc0201e98 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201e3a:	6794                	ld	a3,8(a5)
ffffffffc0201e3c:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201e3e:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201e40:	fea69ae3          	bne	a3,a0,ffffffffc0201e34 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201e44:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201e46:	edb5                	bnez	a1,ffffffffc0201ec2 <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201e48:	c02007b7          	lui	a5,0xc0200
ffffffffc0201e4c:	0af56263          	bltu	a0,a5,ffffffffc0201ef0 <kfree+0xe6>
ffffffffc0201e50:	00099797          	auipc	a5,0x99
ffffffffc0201e54:	7e07b783          	ld	a5,2016(a5) # ffffffffc029b630 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201e58:	00099697          	auipc	a3,0x99
ffffffffc0201e5c:	7e06b683          	ld	a3,2016(a3) # ffffffffc029b638 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201e60:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201e62:	00c55793          	srli	a5,a0,0xc
ffffffffc0201e66:	06d7f963          	bgeu	a5,a3,ffffffffc0201ed8 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e6a:	00006617          	auipc	a2,0x6
ffffffffc0201e6e:	d2663603          	ld	a2,-730(a2) # ffffffffc0207b90 <nbase>
ffffffffc0201e72:	00099517          	auipc	a0,0x99
ffffffffc0201e76:	7ce53503          	ld	a0,1998(a0) # ffffffffc029b640 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e7a:	4314                	lw	a3,0(a4)
ffffffffc0201e7c:	8f91                	sub	a5,a5,a2
ffffffffc0201e7e:	079a                	slli	a5,a5,0x6
ffffffffc0201e80:	4585                	li	a1,1
ffffffffc0201e82:	953e                	add	a0,a0,a5
ffffffffc0201e84:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201e88:	e03a                	sd	a4,0(sp)
ffffffffc0201e8a:	0d6000ef          	jal	ffffffffc0201f60 <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e8e:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e90:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e92:	45e1                	li	a1,24
}
ffffffffc0201e94:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e96:	b1a9                	j	ffffffffc0201ae0 <slob_free>
ffffffffc0201e98:	e185                	bnez	a1,ffffffffc0201eb8 <kfree+0xae>
}
ffffffffc0201e9a:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e9c:	1541                	addi	a0,a0,-16
ffffffffc0201e9e:	4581                	li	a1,0
}
ffffffffc0201ea0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ea2:	b93d                	j	ffffffffc0201ae0 <slob_free>
        intr_disable();
ffffffffc0201ea4:	e02a                	sd	a0,0(sp)
ffffffffc0201ea6:	a5ffe0ef          	jal	ffffffffc0200904 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201eaa:	00099797          	auipc	a5,0x99
ffffffffc0201eae:	7667b783          	ld	a5,1894(a5) # ffffffffc029b610 <bigblocks>
ffffffffc0201eb2:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201eb4:	4585                	li	a1,1
ffffffffc0201eb6:	fbb5                	bnez	a5,ffffffffc0201e2a <kfree+0x20>
ffffffffc0201eb8:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201eba:	a45fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201ebe:	6502                	ld	a0,0(sp)
ffffffffc0201ec0:	bfe9                	j	ffffffffc0201e9a <kfree+0x90>
ffffffffc0201ec2:	e42a                	sd	a0,8(sp)
ffffffffc0201ec4:	e03a                	sd	a4,0(sp)
ffffffffc0201ec6:	a39fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201eca:	6522                	ld	a0,8(sp)
ffffffffc0201ecc:	6702                	ld	a4,0(sp)
ffffffffc0201ece:	bfad                	j	ffffffffc0201e48 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ed0:	1541                	addi	a0,a0,-16
ffffffffc0201ed2:	4581                	li	a1,0
ffffffffc0201ed4:	b131                	j	ffffffffc0201ae0 <slob_free>
ffffffffc0201ed6:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201ed8:	00005617          	auipc	a2,0x5
ffffffffc0201edc:	9c860613          	addi	a2,a2,-1592 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0201ee0:	06900593          	li	a1,105
ffffffffc0201ee4:	00005517          	auipc	a0,0x5
ffffffffc0201ee8:	91450513          	addi	a0,a0,-1772 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0201eec:	d5afe0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201ef0:	86aa                	mv	a3,a0
ffffffffc0201ef2:	00005617          	auipc	a2,0x5
ffffffffc0201ef6:	98660613          	addi	a2,a2,-1658 # ffffffffc0206878 <etext+0xe5e>
ffffffffc0201efa:	07700593          	li	a1,119
ffffffffc0201efe:	00005517          	auipc	a0,0x5
ffffffffc0201f02:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0201f06:	d40fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201f0a <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201f0a:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201f0c:	00005617          	auipc	a2,0x5
ffffffffc0201f10:	99460613          	addi	a2,a2,-1644 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0201f14:	06900593          	li	a1,105
ffffffffc0201f18:	00005517          	auipc	a0,0x5
ffffffffc0201f1c:	8e050513          	addi	a0,a0,-1824 # ffffffffc02067f8 <etext+0xdde>
pa2page(uintptr_t pa)
ffffffffc0201f20:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201f22:	d24fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201f26 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f26:	100027f3          	csrr	a5,sstatus
ffffffffc0201f2a:	8b89                	andi	a5,a5,2
ffffffffc0201f2c:	e799                	bnez	a5,ffffffffc0201f3a <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f2e:	00099797          	auipc	a5,0x99
ffffffffc0201f32:	6ea7b783          	ld	a5,1770(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201f36:	6f9c                	ld	a5,24(a5)
ffffffffc0201f38:	8782                	jr	a5
{
ffffffffc0201f3a:	1101                	addi	sp,sp,-32
ffffffffc0201f3c:	ec06                	sd	ra,24(sp)
ffffffffc0201f3e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201f40:	9c5fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f44:	00099797          	auipc	a5,0x99
ffffffffc0201f48:	6d47b783          	ld	a5,1748(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201f4c:	6522                	ld	a0,8(sp)
ffffffffc0201f4e:	6f9c                	ld	a5,24(a5)
ffffffffc0201f50:	9782                	jalr	a5
ffffffffc0201f52:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201f54:	9abfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f58:	60e2                	ld	ra,24(sp)
ffffffffc0201f5a:	6522                	ld	a0,8(sp)
ffffffffc0201f5c:	6105                	addi	sp,sp,32
ffffffffc0201f5e:	8082                	ret

ffffffffc0201f60 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f60:	100027f3          	csrr	a5,sstatus
ffffffffc0201f64:	8b89                	andi	a5,a5,2
ffffffffc0201f66:	e799                	bnez	a5,ffffffffc0201f74 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f68:	00099797          	auipc	a5,0x99
ffffffffc0201f6c:	6b07b783          	ld	a5,1712(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201f70:	739c                	ld	a5,32(a5)
ffffffffc0201f72:	8782                	jr	a5
{
ffffffffc0201f74:	1101                	addi	sp,sp,-32
ffffffffc0201f76:	ec06                	sd	ra,24(sp)
ffffffffc0201f78:	e42e                	sd	a1,8(sp)
ffffffffc0201f7a:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201f7c:	989fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f80:	00099797          	auipc	a5,0x99
ffffffffc0201f84:	6987b783          	ld	a5,1688(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201f88:	65a2                	ld	a1,8(sp)
ffffffffc0201f8a:	6502                	ld	a0,0(sp)
ffffffffc0201f8c:	739c                	ld	a5,32(a5)
ffffffffc0201f8e:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f90:	60e2                	ld	ra,24(sp)
ffffffffc0201f92:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f94:	96bfe06f          	j	ffffffffc02008fe <intr_enable>

ffffffffc0201f98 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f98:	100027f3          	csrr	a5,sstatus
ffffffffc0201f9c:	8b89                	andi	a5,a5,2
ffffffffc0201f9e:	e799                	bnez	a5,ffffffffc0201fac <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fa0:	00099797          	auipc	a5,0x99
ffffffffc0201fa4:	6787b783          	ld	a5,1656(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201fa8:	779c                	ld	a5,40(a5)
ffffffffc0201faa:	8782                	jr	a5
{
ffffffffc0201fac:	1101                	addi	sp,sp,-32
ffffffffc0201fae:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201fb0:	955fe0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fb4:	00099797          	auipc	a5,0x99
ffffffffc0201fb8:	6647b783          	ld	a5,1636(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0201fbc:	779c                	ld	a5,40(a5)
ffffffffc0201fbe:	9782                	jalr	a5
ffffffffc0201fc0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201fc2:	93dfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201fc6:	60e2                	ld	ra,24(sp)
ffffffffc0201fc8:	6522                	ld	a0,8(sp)
ffffffffc0201fca:	6105                	addi	sp,sp,32
ffffffffc0201fcc:	8082                	ret

ffffffffc0201fce <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fce:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201fd2:	1ff7f793          	andi	a5,a5,511
ffffffffc0201fd6:	078e                	slli	a5,a5,0x3
ffffffffc0201fd8:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201fdc:	6314                	ld	a3,0(a4)
{
ffffffffc0201fde:	7139                	addi	sp,sp,-64
ffffffffc0201fe0:	f822                	sd	s0,48(sp)
ffffffffc0201fe2:	f426                	sd	s1,40(sp)
ffffffffc0201fe4:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201fe6:	0016f793          	andi	a5,a3,1
{
ffffffffc0201fea:	842e                	mv	s0,a1
ffffffffc0201fec:	8832                	mv	a6,a2
ffffffffc0201fee:	00099497          	auipc	s1,0x99
ffffffffc0201ff2:	64a48493          	addi	s1,s1,1610 # ffffffffc029b638 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201ff6:	ebd1                	bnez	a5,ffffffffc020208a <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ff8:	16060d63          	beqz	a2,ffffffffc0202172 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ffc:	100027f3          	csrr	a5,sstatus
ffffffffc0202000:	8b89                	andi	a5,a5,2
ffffffffc0202002:	16079e63          	bnez	a5,ffffffffc020217e <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202006:	00099797          	auipc	a5,0x99
ffffffffc020200a:	6127b783          	ld	a5,1554(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc020200e:	4505                	li	a0,1
ffffffffc0202010:	e43a                	sd	a4,8(sp)
ffffffffc0202012:	6f9c                	ld	a5,24(a5)
ffffffffc0202014:	e832                	sd	a2,16(sp)
ffffffffc0202016:	9782                	jalr	a5
ffffffffc0202018:	6722                	ld	a4,8(sp)
ffffffffc020201a:	6842                	ld	a6,16(sp)
ffffffffc020201c:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020201e:	14078a63          	beqz	a5,ffffffffc0202172 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0202022:	00099517          	auipc	a0,0x99
ffffffffc0202026:	61e53503          	ld	a0,1566(a0) # ffffffffc029b640 <pages>
ffffffffc020202a:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020202e:	00099497          	auipc	s1,0x99
ffffffffc0202032:	60a48493          	addi	s1,s1,1546 # ffffffffc029b638 <npage>
ffffffffc0202036:	40a78533          	sub	a0,a5,a0
ffffffffc020203a:	8519                	srai	a0,a0,0x6
ffffffffc020203c:	9546                	add	a0,a0,a7
ffffffffc020203e:	6090                	ld	a2,0(s1)
ffffffffc0202040:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0202044:	4585                	li	a1,1
ffffffffc0202046:	82b1                	srli	a3,a3,0xc
ffffffffc0202048:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc020204a:	0532                	slli	a0,a0,0xc
ffffffffc020204c:	1ac6f763          	bgeu	a3,a2,ffffffffc02021fa <get_pte+0x22c>
ffffffffc0202050:	00099697          	auipc	a3,0x99
ffffffffc0202054:	5e06b683          	ld	a3,1504(a3) # ffffffffc029b630 <va_pa_offset>
ffffffffc0202058:	6605                	lui	a2,0x1
ffffffffc020205a:	4581                	li	a1,0
ffffffffc020205c:	9536                	add	a0,a0,a3
ffffffffc020205e:	ec42                	sd	a6,24(sp)
ffffffffc0202060:	e83e                	sd	a5,16(sp)
ffffffffc0202062:	e43a                	sd	a4,8(sp)
ffffffffc0202064:	18d030ef          	jal	ffffffffc02059f0 <memset>
    return page - pages + nbase;
ffffffffc0202068:	00099697          	auipc	a3,0x99
ffffffffc020206c:	5d86b683          	ld	a3,1496(a3) # ffffffffc029b640 <pages>
ffffffffc0202070:	67c2                	ld	a5,16(sp)
ffffffffc0202072:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202076:	6722                	ld	a4,8(sp)
ffffffffc0202078:	40d786b3          	sub	a3,a5,a3
ffffffffc020207c:	8699                	srai	a3,a3,0x6
ffffffffc020207e:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202080:	06aa                	slli	a3,a3,0xa
ffffffffc0202082:	6862                	ld	a6,24(sp)
ffffffffc0202084:	0116e693          	ori	a3,a3,17
ffffffffc0202088:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020208a:	c006f693          	andi	a3,a3,-1024
ffffffffc020208e:	6098                	ld	a4,0(s1)
ffffffffc0202090:	068a                	slli	a3,a3,0x2
ffffffffc0202092:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202096:	14e7f663          	bgeu	a5,a4,ffffffffc02021e2 <get_pte+0x214>
ffffffffc020209a:	00099897          	auipc	a7,0x99
ffffffffc020209e:	59688893          	addi	a7,a7,1430 # ffffffffc029b630 <va_pa_offset>
ffffffffc02020a2:	0008b603          	ld	a2,0(a7)
ffffffffc02020a6:	01545793          	srli	a5,s0,0x15
ffffffffc02020aa:	1ff7f793          	andi	a5,a5,511
ffffffffc02020ae:	96b2                	add	a3,a3,a2
ffffffffc02020b0:	078e                	slli	a5,a5,0x3
ffffffffc02020b2:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02020b4:	6394                	ld	a3,0(a5)
ffffffffc02020b6:	0016f613          	andi	a2,a3,1
ffffffffc02020ba:	e659                	bnez	a2,ffffffffc0202148 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020bc:	0a080b63          	beqz	a6,ffffffffc0202172 <get_pte+0x1a4>
ffffffffc02020c0:	10002773          	csrr	a4,sstatus
ffffffffc02020c4:	8b09                	andi	a4,a4,2
ffffffffc02020c6:	ef71                	bnez	a4,ffffffffc02021a2 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020c8:	00099717          	auipc	a4,0x99
ffffffffc02020cc:	55073703          	ld	a4,1360(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc02020d0:	4505                	li	a0,1
ffffffffc02020d2:	e43e                	sd	a5,8(sp)
ffffffffc02020d4:	6f18                	ld	a4,24(a4)
ffffffffc02020d6:	9702                	jalr	a4
ffffffffc02020d8:	67a2                	ld	a5,8(sp)
ffffffffc02020da:	872a                	mv	a4,a0
ffffffffc02020dc:	00099897          	auipc	a7,0x99
ffffffffc02020e0:	55488893          	addi	a7,a7,1364 # ffffffffc029b630 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020e4:	c759                	beqz	a4,ffffffffc0202172 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc02020e6:	00099697          	auipc	a3,0x99
ffffffffc02020ea:	55a6b683          	ld	a3,1370(a3) # ffffffffc029b640 <pages>
ffffffffc02020ee:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020f2:	608c                	ld	a1,0(s1)
ffffffffc02020f4:	40d706b3          	sub	a3,a4,a3
ffffffffc02020f8:	8699                	srai	a3,a3,0x6
ffffffffc02020fa:	96c2                	add	a3,a3,a6
ffffffffc02020fc:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0202100:	4505                	li	a0,1
ffffffffc0202102:	8231                	srli	a2,a2,0xc
ffffffffc0202104:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0202106:	06b2                	slli	a3,a3,0xc
ffffffffc0202108:	10b67663          	bgeu	a2,a1,ffffffffc0202214 <get_pte+0x246>
ffffffffc020210c:	0008b503          	ld	a0,0(a7)
ffffffffc0202110:	6605                	lui	a2,0x1
ffffffffc0202112:	4581                	li	a1,0
ffffffffc0202114:	9536                	add	a0,a0,a3
ffffffffc0202116:	e83a                	sd	a4,16(sp)
ffffffffc0202118:	e43e                	sd	a5,8(sp)
ffffffffc020211a:	0d7030ef          	jal	ffffffffc02059f0 <memset>
    return page - pages + nbase;
ffffffffc020211e:	00099697          	auipc	a3,0x99
ffffffffc0202122:	5226b683          	ld	a3,1314(a3) # ffffffffc029b640 <pages>
ffffffffc0202126:	6742                	ld	a4,16(sp)
ffffffffc0202128:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020212c:	67a2                	ld	a5,8(sp)
ffffffffc020212e:	40d706b3          	sub	a3,a4,a3
ffffffffc0202132:	8699                	srai	a3,a3,0x6
ffffffffc0202134:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202136:	06aa                	slli	a3,a3,0xa
ffffffffc0202138:	0116e693          	ori	a3,a3,17
ffffffffc020213c:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020213e:	6098                	ld	a4,0(s1)
ffffffffc0202140:	00099897          	auipc	a7,0x99
ffffffffc0202144:	4f088893          	addi	a7,a7,1264 # ffffffffc029b630 <va_pa_offset>
ffffffffc0202148:	c006f693          	andi	a3,a3,-1024
ffffffffc020214c:	068a                	slli	a3,a3,0x2
ffffffffc020214e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202152:	06e7fc63          	bgeu	a5,a4,ffffffffc02021ca <get_pte+0x1fc>
ffffffffc0202156:	0008b783          	ld	a5,0(a7)
ffffffffc020215a:	8031                	srli	s0,s0,0xc
ffffffffc020215c:	1ff47413          	andi	s0,s0,511
ffffffffc0202160:	040e                	slli	s0,s0,0x3
ffffffffc0202162:	96be                	add	a3,a3,a5
}
ffffffffc0202164:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202166:	00868533          	add	a0,a3,s0
}
ffffffffc020216a:	7442                	ld	s0,48(sp)
ffffffffc020216c:	74a2                	ld	s1,40(sp)
ffffffffc020216e:	6121                	addi	sp,sp,64
ffffffffc0202170:	8082                	ret
ffffffffc0202172:	70e2                	ld	ra,56(sp)
ffffffffc0202174:	7442                	ld	s0,48(sp)
ffffffffc0202176:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0202178:	4501                	li	a0,0
}
ffffffffc020217a:	6121                	addi	sp,sp,64
ffffffffc020217c:	8082                	ret
        intr_disable();
ffffffffc020217e:	e83a                	sd	a4,16(sp)
ffffffffc0202180:	ec32                	sd	a2,24(sp)
ffffffffc0202182:	f82fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202186:	00099797          	auipc	a5,0x99
ffffffffc020218a:	4927b783          	ld	a5,1170(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc020218e:	4505                	li	a0,1
ffffffffc0202190:	6f9c                	ld	a5,24(a5)
ffffffffc0202192:	9782                	jalr	a5
ffffffffc0202194:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202196:	f68fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020219a:	6862                	ld	a6,24(sp)
ffffffffc020219c:	6742                	ld	a4,16(sp)
ffffffffc020219e:	67a2                	ld	a5,8(sp)
ffffffffc02021a0:	bdbd                	j	ffffffffc020201e <get_pte+0x50>
        intr_disable();
ffffffffc02021a2:	e83e                	sd	a5,16(sp)
ffffffffc02021a4:	f60fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc02021a8:	00099717          	auipc	a4,0x99
ffffffffc02021ac:	47073703          	ld	a4,1136(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc02021b0:	4505                	li	a0,1
ffffffffc02021b2:	6f18                	ld	a4,24(a4)
ffffffffc02021b4:	9702                	jalr	a4
ffffffffc02021b6:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02021b8:	f46fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02021bc:	6722                	ld	a4,8(sp)
ffffffffc02021be:	67c2                	ld	a5,16(sp)
ffffffffc02021c0:	00099897          	auipc	a7,0x99
ffffffffc02021c4:	47088893          	addi	a7,a7,1136 # ffffffffc029b630 <va_pa_offset>
ffffffffc02021c8:	bf31                	j	ffffffffc02020e4 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021ca:	00004617          	auipc	a2,0x4
ffffffffc02021ce:	60660613          	addi	a2,a2,1542 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc02021d2:	0fa00593          	li	a1,250
ffffffffc02021d6:	00004517          	auipc	a0,0x4
ffffffffc02021da:	6ea50513          	addi	a0,a0,1770 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02021de:	a68fe0ef          	jal	ffffffffc0200446 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021e2:	00004617          	auipc	a2,0x4
ffffffffc02021e6:	5ee60613          	addi	a2,a2,1518 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc02021ea:	0ed00593          	li	a1,237
ffffffffc02021ee:	00004517          	auipc	a0,0x4
ffffffffc02021f2:	6d250513          	addi	a0,a0,1746 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02021f6:	a50fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021fa:	86aa                	mv	a3,a0
ffffffffc02021fc:	00004617          	auipc	a2,0x4
ffffffffc0202200:	5d460613          	addi	a2,a2,1492 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0202204:	0e900593          	li	a1,233
ffffffffc0202208:	00004517          	auipc	a0,0x4
ffffffffc020220c:	6b850513          	addi	a0,a0,1720 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202210:	a36fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202214:	00004617          	auipc	a2,0x4
ffffffffc0202218:	5bc60613          	addi	a2,a2,1468 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc020221c:	0f700593          	li	a1,247
ffffffffc0202220:	00004517          	auipc	a0,0x4
ffffffffc0202224:	6a050513          	addi	a0,a0,1696 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202228:	a1efe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020222c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020222c:	1141                	addi	sp,sp,-16
ffffffffc020222e:	e022                	sd	s0,0(sp)
ffffffffc0202230:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202232:	4601                	li	a2,0
{
ffffffffc0202234:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202236:	d99ff0ef          	jal	ffffffffc0201fce <get_pte>
    if (ptep_store != NULL)
ffffffffc020223a:	c011                	beqz	s0,ffffffffc020223e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020223c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020223e:	c511                	beqz	a0,ffffffffc020224a <get_page+0x1e>
ffffffffc0202240:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202242:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202244:	0017f713          	andi	a4,a5,1
ffffffffc0202248:	e709                	bnez	a4,ffffffffc0202252 <get_page+0x26>
}
ffffffffc020224a:	60a2                	ld	ra,8(sp)
ffffffffc020224c:	6402                	ld	s0,0(sp)
ffffffffc020224e:	0141                	addi	sp,sp,16
ffffffffc0202250:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202252:	00099717          	auipc	a4,0x99
ffffffffc0202256:	3e673703          	ld	a4,998(a4) # ffffffffc029b638 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020225a:	078a                	slli	a5,a5,0x2
ffffffffc020225c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020225e:	00e7ff63          	bgeu	a5,a4,ffffffffc020227c <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc0202262:	00099517          	auipc	a0,0x99
ffffffffc0202266:	3de53503          	ld	a0,990(a0) # ffffffffc029b640 <pages>
ffffffffc020226a:	60a2                	ld	ra,8(sp)
ffffffffc020226c:	6402                	ld	s0,0(sp)
ffffffffc020226e:	079a                	slli	a5,a5,0x6
ffffffffc0202270:	fe000737          	lui	a4,0xfe000
ffffffffc0202274:	97ba                	add	a5,a5,a4
ffffffffc0202276:	953e                	add	a0,a0,a5
ffffffffc0202278:	0141                	addi	sp,sp,16
ffffffffc020227a:	8082                	ret
ffffffffc020227c:	c8fff0ef          	jal	ffffffffc0201f0a <pa2page.part.0>

ffffffffc0202280 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202280:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202282:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202286:	e486                	sd	ra,72(sp)
ffffffffc0202288:	e0a2                	sd	s0,64(sp)
ffffffffc020228a:	fc26                	sd	s1,56(sp)
ffffffffc020228c:	f84a                	sd	s2,48(sp)
ffffffffc020228e:	f44e                	sd	s3,40(sp)
ffffffffc0202290:	f052                	sd	s4,32(sp)
ffffffffc0202292:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202294:	03479713          	slli	a4,a5,0x34
ffffffffc0202298:	ef61                	bnez	a4,ffffffffc0202370 <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc020229a:	00200a37          	lui	s4,0x200
ffffffffc020229e:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02022a2:	0145b733          	sltu	a4,a1,s4
ffffffffc02022a6:	0017b793          	seqz	a5,a5
ffffffffc02022aa:	8fd9                	or	a5,a5,a4
ffffffffc02022ac:	842e                	mv	s0,a1
ffffffffc02022ae:	84b2                	mv	s1,a2
ffffffffc02022b0:	e3e5                	bnez	a5,ffffffffc0202390 <unmap_range+0x110>
ffffffffc02022b2:	4785                	li	a5,1
ffffffffc02022b4:	07fe                	slli	a5,a5,0x1f
ffffffffc02022b6:	0785                	addi	a5,a5,1
ffffffffc02022b8:	892a                	mv	s2,a0
ffffffffc02022ba:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022bc:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc02022c0:	0cf67863          	bgeu	a2,a5,ffffffffc0202390 <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02022c4:	4601                	li	a2,0
ffffffffc02022c6:	85a2                	mv	a1,s0
ffffffffc02022c8:	854a                	mv	a0,s2
ffffffffc02022ca:	d05ff0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc02022ce:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc02022d0:	cd31                	beqz	a0,ffffffffc020232c <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc02022d2:	6118                	ld	a4,0(a0)
ffffffffc02022d4:	ef11                	bnez	a4,ffffffffc02022f0 <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02022d6:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc02022d8:	c019                	beqz	s0,ffffffffc02022de <unmap_range+0x5e>
ffffffffc02022da:	fe9465e3          	bltu	s0,s1,ffffffffc02022c4 <unmap_range+0x44>
}
ffffffffc02022de:	60a6                	ld	ra,72(sp)
ffffffffc02022e0:	6406                	ld	s0,64(sp)
ffffffffc02022e2:	74e2                	ld	s1,56(sp)
ffffffffc02022e4:	7942                	ld	s2,48(sp)
ffffffffc02022e6:	79a2                	ld	s3,40(sp)
ffffffffc02022e8:	7a02                	ld	s4,32(sp)
ffffffffc02022ea:	6ae2                	ld	s5,24(sp)
ffffffffc02022ec:	6161                	addi	sp,sp,80
ffffffffc02022ee:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02022f0:	00177693          	andi	a3,a4,1
ffffffffc02022f4:	d2ed                	beqz	a3,ffffffffc02022d6 <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc02022f6:	00099697          	auipc	a3,0x99
ffffffffc02022fa:	3426b683          	ld	a3,834(a3) # ffffffffc029b638 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02022fe:	070a                	slli	a4,a4,0x2
ffffffffc0202300:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202302:	0ad77763          	bgeu	a4,a3,ffffffffc02023b0 <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc0202306:	00099517          	auipc	a0,0x99
ffffffffc020230a:	33a53503          	ld	a0,826(a0) # ffffffffc029b640 <pages>
ffffffffc020230e:	071a                	slli	a4,a4,0x6
ffffffffc0202310:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202314:	9736                	add	a4,a4,a3
ffffffffc0202316:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202318:	4118                	lw	a4,0(a0)
ffffffffc020231a:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd64997>
ffffffffc020231c:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020231e:	cb19                	beqz	a4,ffffffffc0202334 <unmap_range+0xb4>
        *ptep = 0;
ffffffffc0202320:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202324:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202328:	944e                	add	s0,s0,s3
ffffffffc020232a:	b77d                	j	ffffffffc02022d8 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020232c:	9452                	add	s0,s0,s4
ffffffffc020232e:	01547433          	and	s0,s0,s5
            continue;
ffffffffc0202332:	b75d                	j	ffffffffc02022d8 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202334:	10002773          	csrr	a4,sstatus
ffffffffc0202338:	8b09                	andi	a4,a4,2
ffffffffc020233a:	eb19                	bnez	a4,ffffffffc0202350 <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc020233c:	00099717          	auipc	a4,0x99
ffffffffc0202340:	2dc73703          	ld	a4,732(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc0202344:	4585                	li	a1,1
ffffffffc0202346:	e03e                	sd	a5,0(sp)
ffffffffc0202348:	7318                	ld	a4,32(a4)
ffffffffc020234a:	9702                	jalr	a4
    if (flag)
ffffffffc020234c:	6782                	ld	a5,0(sp)
ffffffffc020234e:	bfc9                	j	ffffffffc0202320 <unmap_range+0xa0>
        intr_disable();
ffffffffc0202350:	e43e                	sd	a5,8(sp)
ffffffffc0202352:	e02a                	sd	a0,0(sp)
ffffffffc0202354:	db0fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202358:	00099717          	auipc	a4,0x99
ffffffffc020235c:	2c073703          	ld	a4,704(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc0202360:	6502                	ld	a0,0(sp)
ffffffffc0202362:	4585                	li	a1,1
ffffffffc0202364:	7318                	ld	a4,32(a4)
ffffffffc0202366:	9702                	jalr	a4
        intr_enable();
ffffffffc0202368:	d96fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020236c:	67a2                	ld	a5,8(sp)
ffffffffc020236e:	bf4d                	j	ffffffffc0202320 <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202370:	00004697          	auipc	a3,0x4
ffffffffc0202374:	56068693          	addi	a3,a3,1376 # ffffffffc02068d0 <etext+0xeb6>
ffffffffc0202378:	00004617          	auipc	a2,0x4
ffffffffc020237c:	0a860613          	addi	a2,a2,168 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202380:	12000593          	li	a1,288
ffffffffc0202384:	00004517          	auipc	a0,0x4
ffffffffc0202388:	53c50513          	addi	a0,a0,1340 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020238c:	8bafe0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202390:	00004697          	auipc	a3,0x4
ffffffffc0202394:	57068693          	addi	a3,a3,1392 # ffffffffc0206900 <etext+0xee6>
ffffffffc0202398:	00004617          	auipc	a2,0x4
ffffffffc020239c:	08860613          	addi	a2,a2,136 # ffffffffc0206420 <etext+0xa06>
ffffffffc02023a0:	12100593          	li	a1,289
ffffffffc02023a4:	00004517          	auipc	a0,0x4
ffffffffc02023a8:	51c50513          	addi	a0,a0,1308 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02023ac:	89afe0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02023b0:	b5bff0ef          	jal	ffffffffc0201f0a <pa2page.part.0>

ffffffffc02023b4 <exit_range>:
{
ffffffffc02023b4:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023b6:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02023ba:	ed06                	sd	ra,152(sp)
ffffffffc02023bc:	e922                	sd	s0,144(sp)
ffffffffc02023be:	e526                	sd	s1,136(sp)
ffffffffc02023c0:	e14a                	sd	s2,128(sp)
ffffffffc02023c2:	fcce                	sd	s3,120(sp)
ffffffffc02023c4:	f8d2                	sd	s4,112(sp)
ffffffffc02023c6:	f4d6                	sd	s5,104(sp)
ffffffffc02023c8:	f0da                	sd	s6,96(sp)
ffffffffc02023ca:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023cc:	17d2                	slli	a5,a5,0x34
ffffffffc02023ce:	22079263          	bnez	a5,ffffffffc02025f2 <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc02023d2:	00200937          	lui	s2,0x200
ffffffffc02023d6:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02023da:	0125b733          	sltu	a4,a1,s2
ffffffffc02023de:	0017b793          	seqz	a5,a5
ffffffffc02023e2:	8fd9                	or	a5,a5,a4
ffffffffc02023e4:	26079263          	bnez	a5,ffffffffc0202648 <exit_range+0x294>
ffffffffc02023e8:	4785                	li	a5,1
ffffffffc02023ea:	07fe                	slli	a5,a5,0x1f
ffffffffc02023ec:	0785                	addi	a5,a5,1
ffffffffc02023ee:	24f67d63          	bgeu	a2,a5,ffffffffc0202648 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023f2:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023f6:	ffe007b7          	lui	a5,0xffe00
ffffffffc02023fa:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023fc:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023fe:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc0202402:	00099a97          	auipc	s5,0x99
ffffffffc0202406:	236a8a93          	addi	s5,s5,566 # ffffffffc029b638 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020240a:	400009b7          	lui	s3,0x40000
ffffffffc020240e:	a809                	j	ffffffffc0202420 <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc0202410:	013487b3          	add	a5,s1,s3
ffffffffc0202414:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc0202418:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc020241a:	c3f1                	beqz	a5,ffffffffc02024de <exit_range+0x12a>
ffffffffc020241c:	0cc7f163          	bgeu	a5,a2,ffffffffc02024de <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202420:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202424:	1ff47413          	andi	s0,s0,511
ffffffffc0202428:	040e                	slli	s0,s0,0x3
ffffffffc020242a:	9452                	add	s0,s0,s4
ffffffffc020242c:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc0202430:	0018f793          	andi	a5,a7,1
ffffffffc0202434:	dff1                	beqz	a5,ffffffffc0202410 <exit_range+0x5c>
ffffffffc0202436:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020243a:	088a                	slli	a7,a7,0x2
ffffffffc020243c:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc0202440:	20f8f263          	bgeu	a7,a5,ffffffffc0202644 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202444:	fff802b7          	lui	t0,0xfff80
ffffffffc0202448:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc020244c:	000803b7          	lui	t2,0x80
ffffffffc0202450:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202454:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202458:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc020245a:	1cf77863          	bgeu	a4,a5,ffffffffc020262a <exit_range+0x276>
ffffffffc020245e:	00099f97          	auipc	t6,0x99
ffffffffc0202462:	1d2f8f93          	addi	t6,t6,466 # ffffffffc029b630 <va_pa_offset>
ffffffffc0202466:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc020246a:	4e85                	li	t4,1
ffffffffc020246c:	6b05                	lui	s6,0x1
ffffffffc020246e:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202470:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202474:	01585713          	srli	a4,a6,0x15
ffffffffc0202478:	1ff77713          	andi	a4,a4,511
ffffffffc020247c:	070e                	slli	a4,a4,0x3
ffffffffc020247e:	9772                	add	a4,a4,t3
ffffffffc0202480:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc0202482:	0017f693          	andi	a3,a5,1
ffffffffc0202486:	e6bd                	bnez	a3,ffffffffc02024f4 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc0202488:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc020248a:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020248c:	00080863          	beqz	a6,ffffffffc020249c <exit_range+0xe8>
ffffffffc0202490:	879a                	mv	a5,t1
ffffffffc0202492:	00667363          	bgeu	a2,t1,ffffffffc0202498 <exit_range+0xe4>
ffffffffc0202496:	87b2                	mv	a5,a2
ffffffffc0202498:	fcf86ee3          	bltu	a6,a5,ffffffffc0202474 <exit_range+0xc0>
            if (free_pd0)
ffffffffc020249c:	f60e8ae3          	beqz	t4,ffffffffc0202410 <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc02024a0:	000ab783          	ld	a5,0(s5)
ffffffffc02024a4:	1af8f063          	bgeu	a7,a5,ffffffffc0202644 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a8:	00099517          	auipc	a0,0x99
ffffffffc02024ac:	19853503          	ld	a0,408(a0) # ffffffffc029b640 <pages>
ffffffffc02024b0:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024b2:	100027f3          	csrr	a5,sstatus
ffffffffc02024b6:	8b89                	andi	a5,a5,2
ffffffffc02024b8:	10079b63          	bnez	a5,ffffffffc02025ce <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc02024bc:	00099797          	auipc	a5,0x99
ffffffffc02024c0:	15c7b783          	ld	a5,348(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc02024c4:	4585                	li	a1,1
ffffffffc02024c6:	e432                	sd	a2,8(sp)
ffffffffc02024c8:	739c                	ld	a5,32(a5)
ffffffffc02024ca:	9782                	jalr	a5
ffffffffc02024cc:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024ce:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc02024d2:	013487b3          	add	a5,s1,s3
ffffffffc02024d6:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc02024da:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc02024dc:	f3a1                	bnez	a5,ffffffffc020241c <exit_range+0x68>
}
ffffffffc02024de:	60ea                	ld	ra,152(sp)
ffffffffc02024e0:	644a                	ld	s0,144(sp)
ffffffffc02024e2:	64aa                	ld	s1,136(sp)
ffffffffc02024e4:	690a                	ld	s2,128(sp)
ffffffffc02024e6:	79e6                	ld	s3,120(sp)
ffffffffc02024e8:	7a46                	ld	s4,112(sp)
ffffffffc02024ea:	7aa6                	ld	s5,104(sp)
ffffffffc02024ec:	7b06                	ld	s6,96(sp)
ffffffffc02024ee:	6be6                	ld	s7,88(sp)
ffffffffc02024f0:	610d                	addi	sp,sp,160
ffffffffc02024f2:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02024f4:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024f8:	078a                	slli	a5,a5,0x2
ffffffffc02024fa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024fc:	14a7f463          	bgeu	a5,a0,ffffffffc0202644 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202500:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc0202502:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc0202506:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020250a:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc020250e:	10abf263          	bgeu	s7,a0,ffffffffc0202612 <exit_range+0x25e>
ffffffffc0202512:	000fb783          	ld	a5,0(t6)
ffffffffc0202516:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202518:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc020251c:	629c                	ld	a5,0(a3)
ffffffffc020251e:	8b85                	andi	a5,a5,1
ffffffffc0202520:	f7ad                	bnez	a5,ffffffffc020248a <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202522:	06a1                	addi	a3,a3,8
ffffffffc0202524:	fea69ce3          	bne	a3,a0,ffffffffc020251c <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc0202528:	00099517          	auipc	a0,0x99
ffffffffc020252c:	11853503          	ld	a0,280(a0) # ffffffffc029b640 <pages>
ffffffffc0202530:	952e                	add	a0,a0,a1
ffffffffc0202532:	100027f3          	csrr	a5,sstatus
ffffffffc0202536:	8b89                	andi	a5,a5,2
ffffffffc0202538:	e3b9                	bnez	a5,ffffffffc020257e <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc020253a:	00099797          	auipc	a5,0x99
ffffffffc020253e:	0de7b783          	ld	a5,222(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0202542:	4585                	li	a1,1
ffffffffc0202544:	e0b2                	sd	a2,64(sp)
ffffffffc0202546:	739c                	ld	a5,32(a5)
ffffffffc0202548:	fc1a                	sd	t1,56(sp)
ffffffffc020254a:	f846                	sd	a7,48(sp)
ffffffffc020254c:	f47a                	sd	t5,40(sp)
ffffffffc020254e:	f072                	sd	t3,32(sp)
ffffffffc0202550:	ec76                	sd	t4,24(sp)
ffffffffc0202552:	e842                	sd	a6,16(sp)
ffffffffc0202554:	e43a                	sd	a4,8(sp)
ffffffffc0202556:	9782                	jalr	a5
    if (flag)
ffffffffc0202558:	6722                	ld	a4,8(sp)
ffffffffc020255a:	6842                	ld	a6,16(sp)
ffffffffc020255c:	6ee2                	ld	t4,24(sp)
ffffffffc020255e:	7e02                	ld	t3,32(sp)
ffffffffc0202560:	7f22                	ld	t5,40(sp)
ffffffffc0202562:	78c2                	ld	a7,48(sp)
ffffffffc0202564:	7362                	ld	t1,56(sp)
ffffffffc0202566:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202568:	fff802b7          	lui	t0,0xfff80
ffffffffc020256c:	000803b7          	lui	t2,0x80
ffffffffc0202570:	00099f97          	auipc	t6,0x99
ffffffffc0202574:	0c0f8f93          	addi	t6,t6,192 # ffffffffc029b630 <va_pa_offset>
ffffffffc0202578:	00073023          	sd	zero,0(a4)
ffffffffc020257c:	b739                	j	ffffffffc020248a <exit_range+0xd6>
        intr_disable();
ffffffffc020257e:	e4b2                	sd	a2,72(sp)
ffffffffc0202580:	e09a                	sd	t1,64(sp)
ffffffffc0202582:	fc46                	sd	a7,56(sp)
ffffffffc0202584:	f47a                	sd	t5,40(sp)
ffffffffc0202586:	f072                	sd	t3,32(sp)
ffffffffc0202588:	ec76                	sd	t4,24(sp)
ffffffffc020258a:	e842                	sd	a6,16(sp)
ffffffffc020258c:	e43a                	sd	a4,8(sp)
ffffffffc020258e:	f82a                	sd	a0,48(sp)
ffffffffc0202590:	b74fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202594:	00099797          	auipc	a5,0x99
ffffffffc0202598:	0847b783          	ld	a5,132(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc020259c:	7542                	ld	a0,48(sp)
ffffffffc020259e:	4585                	li	a1,1
ffffffffc02025a0:	739c                	ld	a5,32(a5)
ffffffffc02025a2:	9782                	jalr	a5
        intr_enable();
ffffffffc02025a4:	b5afe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02025a8:	6722                	ld	a4,8(sp)
ffffffffc02025aa:	6626                	ld	a2,72(sp)
ffffffffc02025ac:	6306                	ld	t1,64(sp)
ffffffffc02025ae:	78e2                	ld	a7,56(sp)
ffffffffc02025b0:	7f22                	ld	t5,40(sp)
ffffffffc02025b2:	7e02                	ld	t3,32(sp)
ffffffffc02025b4:	6ee2                	ld	t4,24(sp)
ffffffffc02025b6:	6842                	ld	a6,16(sp)
ffffffffc02025b8:	00099f97          	auipc	t6,0x99
ffffffffc02025bc:	078f8f93          	addi	t6,t6,120 # ffffffffc029b630 <va_pa_offset>
ffffffffc02025c0:	000803b7          	lui	t2,0x80
ffffffffc02025c4:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc02025c8:	00073023          	sd	zero,0(a4)
ffffffffc02025cc:	bd7d                	j	ffffffffc020248a <exit_range+0xd6>
        intr_disable();
ffffffffc02025ce:	e832                	sd	a2,16(sp)
ffffffffc02025d0:	e42a                	sd	a0,8(sp)
ffffffffc02025d2:	b32fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025d6:	00099797          	auipc	a5,0x99
ffffffffc02025da:	0427b783          	ld	a5,66(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc02025de:	6522                	ld	a0,8(sp)
ffffffffc02025e0:	4585                	li	a1,1
ffffffffc02025e2:	739c                	ld	a5,32(a5)
ffffffffc02025e4:	9782                	jalr	a5
        intr_enable();
ffffffffc02025e6:	b18fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02025ea:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025ec:	00043023          	sd	zero,0(s0)
ffffffffc02025f0:	b5cd                	j	ffffffffc02024d2 <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025f2:	00004697          	auipc	a3,0x4
ffffffffc02025f6:	2de68693          	addi	a3,a3,734 # ffffffffc02068d0 <etext+0xeb6>
ffffffffc02025fa:	00004617          	auipc	a2,0x4
ffffffffc02025fe:	e2660613          	addi	a2,a2,-474 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202602:	13500593          	li	a1,309
ffffffffc0202606:	00004517          	auipc	a0,0x4
ffffffffc020260a:	2ba50513          	addi	a0,a0,698 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020260e:	e39fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202612:	00004617          	auipc	a2,0x4
ffffffffc0202616:	1be60613          	addi	a2,a2,446 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc020261a:	07100593          	li	a1,113
ffffffffc020261e:	00004517          	auipc	a0,0x4
ffffffffc0202622:	1da50513          	addi	a0,a0,474 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0202626:	e21fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020262a:	86f2                	mv	a3,t3
ffffffffc020262c:	00004617          	auipc	a2,0x4
ffffffffc0202630:	1a460613          	addi	a2,a2,420 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0202634:	07100593          	li	a1,113
ffffffffc0202638:	00004517          	auipc	a0,0x4
ffffffffc020263c:	1c050513          	addi	a0,a0,448 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0202640:	e07fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202644:	8c7ff0ef          	jal	ffffffffc0201f0a <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202648:	00004697          	auipc	a3,0x4
ffffffffc020264c:	2b868693          	addi	a3,a3,696 # ffffffffc0206900 <etext+0xee6>
ffffffffc0202650:	00004617          	auipc	a2,0x4
ffffffffc0202654:	dd060613          	addi	a2,a2,-560 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202658:	13600593          	li	a1,310
ffffffffc020265c:	00004517          	auipc	a0,0x4
ffffffffc0202660:	26450513          	addi	a0,a0,612 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202664:	de3fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0202668 <page_remove>:
{
ffffffffc0202668:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020266a:	4601                	li	a2,0
{
ffffffffc020266c:	e822                	sd	s0,16(sp)
ffffffffc020266e:	ec06                	sd	ra,24(sp)
ffffffffc0202670:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202672:	95dff0ef          	jal	ffffffffc0201fce <get_pte>
    if (ptep != NULL)
ffffffffc0202676:	c511                	beqz	a0,ffffffffc0202682 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc0202678:	6118                	ld	a4,0(a0)
ffffffffc020267a:	87aa                	mv	a5,a0
ffffffffc020267c:	00177693          	andi	a3,a4,1
ffffffffc0202680:	e689                	bnez	a3,ffffffffc020268a <page_remove+0x22>
}
ffffffffc0202682:	60e2                	ld	ra,24(sp)
ffffffffc0202684:	6442                	ld	s0,16(sp)
ffffffffc0202686:	6105                	addi	sp,sp,32
ffffffffc0202688:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020268a:	00099697          	auipc	a3,0x99
ffffffffc020268e:	fae6b683          	ld	a3,-82(a3) # ffffffffc029b638 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202692:	070a                	slli	a4,a4,0x2
ffffffffc0202694:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202696:	06d77563          	bgeu	a4,a3,ffffffffc0202700 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020269a:	00099517          	auipc	a0,0x99
ffffffffc020269e:	fa653503          	ld	a0,-90(a0) # ffffffffc029b640 <pages>
ffffffffc02026a2:	071a                	slli	a4,a4,0x6
ffffffffc02026a4:	fe0006b7          	lui	a3,0xfe000
ffffffffc02026a8:	9736                	add	a4,a4,a3
ffffffffc02026aa:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc02026ac:	4118                	lw	a4,0(a0)
ffffffffc02026ae:	377d                	addiw	a4,a4,-1
ffffffffc02026b0:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02026b2:	cb09                	beqz	a4,ffffffffc02026c4 <page_remove+0x5c>
        *ptep = 0;
ffffffffc02026b4:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026b8:	12040073          	sfence.vma	s0
}
ffffffffc02026bc:	60e2                	ld	ra,24(sp)
ffffffffc02026be:	6442                	ld	s0,16(sp)
ffffffffc02026c0:	6105                	addi	sp,sp,32
ffffffffc02026c2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026c4:	10002773          	csrr	a4,sstatus
ffffffffc02026c8:	8b09                	andi	a4,a4,2
ffffffffc02026ca:	eb19                	bnez	a4,ffffffffc02026e0 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc02026cc:	00099717          	auipc	a4,0x99
ffffffffc02026d0:	f4c73703          	ld	a4,-180(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc02026d4:	4585                	li	a1,1
ffffffffc02026d6:	e03e                	sd	a5,0(sp)
ffffffffc02026d8:	7318                	ld	a4,32(a4)
ffffffffc02026da:	9702                	jalr	a4
    if (flag)
ffffffffc02026dc:	6782                	ld	a5,0(sp)
ffffffffc02026de:	bfd9                	j	ffffffffc02026b4 <page_remove+0x4c>
        intr_disable();
ffffffffc02026e0:	e43e                	sd	a5,8(sp)
ffffffffc02026e2:	e02a                	sd	a0,0(sp)
ffffffffc02026e4:	a20fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc02026e8:	00099717          	auipc	a4,0x99
ffffffffc02026ec:	f3073703          	ld	a4,-208(a4) # ffffffffc029b618 <pmm_manager>
ffffffffc02026f0:	6502                	ld	a0,0(sp)
ffffffffc02026f2:	4585                	li	a1,1
ffffffffc02026f4:	7318                	ld	a4,32(a4)
ffffffffc02026f6:	9702                	jalr	a4
        intr_enable();
ffffffffc02026f8:	a06fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02026fc:	67a2                	ld	a5,8(sp)
ffffffffc02026fe:	bf5d                	j	ffffffffc02026b4 <page_remove+0x4c>
ffffffffc0202700:	80bff0ef          	jal	ffffffffc0201f0a <pa2page.part.0>

ffffffffc0202704 <page_insert>:
{
ffffffffc0202704:	7139                	addi	sp,sp,-64
ffffffffc0202706:	f426                	sd	s1,40(sp)
ffffffffc0202708:	84b2                	mv	s1,a2
ffffffffc020270a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020270c:	4605                	li	a2,1
{
ffffffffc020270e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202710:	85a6                	mv	a1,s1
{
ffffffffc0202712:	fc06                	sd	ra,56(sp)
ffffffffc0202714:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202716:	8b9ff0ef          	jal	ffffffffc0201fce <get_pte>
    if (ptep == NULL)
ffffffffc020271a:	cd61                	beqz	a0,ffffffffc02027f2 <page_insert+0xee>
    page->ref += 1;
ffffffffc020271c:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc020271e:	611c                	ld	a5,0(a0)
ffffffffc0202720:	66a2                	ld	a3,8(sp)
ffffffffc0202722:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7baf>
ffffffffc0202726:	c010                	sw	a2,0(s0)
ffffffffc0202728:	0017f613          	andi	a2,a5,1
ffffffffc020272c:	872a                	mv	a4,a0
ffffffffc020272e:	e61d                	bnez	a2,ffffffffc020275c <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc0202730:	00099617          	auipc	a2,0x99
ffffffffc0202734:	f1063603          	ld	a2,-240(a2) # ffffffffc029b640 <pages>
    return page - pages + nbase;
ffffffffc0202738:	8c11                	sub	s0,s0,a2
ffffffffc020273a:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020273c:	200007b7          	lui	a5,0x20000
ffffffffc0202740:	042a                	slli	s0,s0,0xa
ffffffffc0202742:	943e                	add	s0,s0,a5
ffffffffc0202744:	8ec1                	or	a3,a3,s0
ffffffffc0202746:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020274a:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020274c:	12048073          	sfence.vma	s1
    return 0;
ffffffffc0202750:	4501                	li	a0,0
}
ffffffffc0202752:	70e2                	ld	ra,56(sp)
ffffffffc0202754:	7442                	ld	s0,48(sp)
ffffffffc0202756:	74a2                	ld	s1,40(sp)
ffffffffc0202758:	6121                	addi	sp,sp,64
ffffffffc020275a:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc020275c:	00099617          	auipc	a2,0x99
ffffffffc0202760:	edc63603          	ld	a2,-292(a2) # ffffffffc029b638 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202764:	078a                	slli	a5,a5,0x2
ffffffffc0202766:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202768:	08c7f763          	bgeu	a5,a2,ffffffffc02027f6 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc020276c:	00099617          	auipc	a2,0x99
ffffffffc0202770:	ed463603          	ld	a2,-300(a2) # ffffffffc029b640 <pages>
ffffffffc0202774:	fe000537          	lui	a0,0xfe000
ffffffffc0202778:	079a                	slli	a5,a5,0x6
ffffffffc020277a:	97aa                	add	a5,a5,a0
ffffffffc020277c:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc0202780:	00a40963          	beq	s0,a0,ffffffffc0202792 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc0202784:	411c                	lw	a5,0(a0)
ffffffffc0202786:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_exit_out_size+0x1fff5e47>
ffffffffc0202788:	c11c                	sw	a5,0(a0)
        if (page_ref(page) == 0)
ffffffffc020278a:	c791                	beqz	a5,ffffffffc0202796 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020278c:	12048073          	sfence.vma	s1
}
ffffffffc0202790:	b765                	j	ffffffffc0202738 <page_insert+0x34>
ffffffffc0202792:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202794:	b755                	j	ffffffffc0202738 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202796:	100027f3          	csrr	a5,sstatus
ffffffffc020279a:	8b89                	andi	a5,a5,2
ffffffffc020279c:	e39d                	bnez	a5,ffffffffc02027c2 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc020279e:	00099797          	auipc	a5,0x99
ffffffffc02027a2:	e7a7b783          	ld	a5,-390(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc02027a6:	4585                	li	a1,1
ffffffffc02027a8:	e83a                	sd	a4,16(sp)
ffffffffc02027aa:	739c                	ld	a5,32(a5)
ffffffffc02027ac:	e436                	sd	a3,8(sp)
ffffffffc02027ae:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02027b0:	00099617          	auipc	a2,0x99
ffffffffc02027b4:	e9063603          	ld	a2,-368(a2) # ffffffffc029b640 <pages>
ffffffffc02027b8:	66a2                	ld	a3,8(sp)
ffffffffc02027ba:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027bc:	12048073          	sfence.vma	s1
ffffffffc02027c0:	bfa5                	j	ffffffffc0202738 <page_insert+0x34>
        intr_disable();
ffffffffc02027c2:	ec3a                	sd	a4,24(sp)
ffffffffc02027c4:	e836                	sd	a3,16(sp)
ffffffffc02027c6:	e42a                	sd	a0,8(sp)
ffffffffc02027c8:	93cfe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027cc:	00099797          	auipc	a5,0x99
ffffffffc02027d0:	e4c7b783          	ld	a5,-436(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc02027d4:	6522                	ld	a0,8(sp)
ffffffffc02027d6:	4585                	li	a1,1
ffffffffc02027d8:	739c                	ld	a5,32(a5)
ffffffffc02027da:	9782                	jalr	a5
        intr_enable();
ffffffffc02027dc:	922fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02027e0:	00099617          	auipc	a2,0x99
ffffffffc02027e4:	e6063603          	ld	a2,-416(a2) # ffffffffc029b640 <pages>
ffffffffc02027e8:	6762                	ld	a4,24(sp)
ffffffffc02027ea:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027ec:	12048073          	sfence.vma	s1
ffffffffc02027f0:	b7a1                	j	ffffffffc0202738 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc02027f2:	5571                	li	a0,-4
ffffffffc02027f4:	bfb9                	j	ffffffffc0202752 <page_insert+0x4e>
ffffffffc02027f6:	f14ff0ef          	jal	ffffffffc0201f0a <pa2page.part.0>

ffffffffc02027fa <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02027fa:	00005797          	auipc	a5,0x5
ffffffffc02027fe:	03e78793          	addi	a5,a5,62 # ffffffffc0207838 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202802:	638c                	ld	a1,0(a5)
{
ffffffffc0202804:	7159                	addi	sp,sp,-112
ffffffffc0202806:	f486                	sd	ra,104(sp)
ffffffffc0202808:	e8ca                	sd	s2,80(sp)
ffffffffc020280a:	e4ce                	sd	s3,72(sp)
ffffffffc020280c:	f85a                	sd	s6,48(sp)
ffffffffc020280e:	f0a2                	sd	s0,96(sp)
ffffffffc0202810:	eca6                	sd	s1,88(sp)
ffffffffc0202812:	e0d2                	sd	s4,64(sp)
ffffffffc0202814:	fc56                	sd	s5,56(sp)
ffffffffc0202816:	f45e                	sd	s7,40(sp)
ffffffffc0202818:	f062                	sd	s8,32(sp)
ffffffffc020281a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020281c:	00099b17          	auipc	s6,0x99
ffffffffc0202820:	dfcb0b13          	addi	s6,s6,-516 # ffffffffc029b618 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202824:	00004517          	auipc	a0,0x4
ffffffffc0202828:	0f450513          	addi	a0,a0,244 # ffffffffc0206918 <etext+0xefe>
    pmm_manager = &default_pmm_manager;
ffffffffc020282c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202830:	965fd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202834:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202838:	00099997          	auipc	s3,0x99
ffffffffc020283c:	df898993          	addi	s3,s3,-520 # ffffffffc029b630 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202840:	679c                	ld	a5,8(a5)
ffffffffc0202842:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202844:	57f5                	li	a5,-3
ffffffffc0202846:	07fa                	slli	a5,a5,0x1e
ffffffffc0202848:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020284c:	89efe0ef          	jal	ffffffffc02008ea <get_memory_base>
ffffffffc0202850:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202852:	8a2fe0ef          	jal	ffffffffc02008f4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202856:	70050e63          	beqz	a0,ffffffffc0202f72 <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc020285a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc020285c:	00004517          	auipc	a0,0x4
ffffffffc0202860:	0f450513          	addi	a0,a0,244 # ffffffffc0206950 <etext+0xf36>
ffffffffc0202864:	931fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202868:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020286c:	864a                	mv	a2,s2
ffffffffc020286e:	85a6                	mv	a1,s1
ffffffffc0202870:	fff40693          	addi	a3,s0,-1
ffffffffc0202874:	00004517          	auipc	a0,0x4
ffffffffc0202878:	0f450513          	addi	a0,a0,244 # ffffffffc0206968 <etext+0xf4e>
ffffffffc020287c:	919fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202880:	c80007b7          	lui	a5,0xc8000
ffffffffc0202884:	8522                	mv	a0,s0
ffffffffc0202886:	5287ed63          	bltu	a5,s0,ffffffffc0202dc0 <pmm_init+0x5c6>
ffffffffc020288a:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020288c:	0009a617          	auipc	a2,0x9a
ffffffffc0202890:	ddb60613          	addi	a2,a2,-549 # ffffffffc029c667 <end+0xfff>
ffffffffc0202894:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc0202896:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202898:	00099b97          	auipc	s7,0x99
ffffffffc020289c:	da8b8b93          	addi	s7,s7,-600 # ffffffffc029b640 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02028a0:	00099497          	auipc	s1,0x99
ffffffffc02028a4:	d9848493          	addi	s1,s1,-616 # ffffffffc029b638 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02028a8:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc02028ac:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028ae:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02028b2:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028b4:	02f50763          	beq	a0,a5,ffffffffc02028e2 <pmm_init+0xe8>
ffffffffc02028b8:	4701                	li	a4,0
ffffffffc02028ba:	4585                	li	a1,1
ffffffffc02028bc:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02028c0:	00671793          	slli	a5,a4,0x6
ffffffffc02028c4:	97b2                	add	a5,a5,a2
ffffffffc02028c6:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x75e50>
ffffffffc02028c8:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028cc:	6088                	ld	a0,0(s1)
ffffffffc02028ce:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028d0:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028d4:	00d507b3          	add	a5,a0,a3
ffffffffc02028d8:	fef764e3          	bltu	a4,a5,ffffffffc02028c0 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028dc:	079a                	slli	a5,a5,0x6
ffffffffc02028de:	00f606b3          	add	a3,a2,a5
ffffffffc02028e2:	c02007b7          	lui	a5,0xc0200
ffffffffc02028e6:	16f6eee3          	bltu	a3,a5,ffffffffc0203262 <pmm_init+0xa68>
ffffffffc02028ea:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02028ee:	77fd                	lui	a5,0xfffff
ffffffffc02028f0:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028f2:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02028f4:	4e86ed63          	bltu	a3,s0,ffffffffc0202dee <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02028f8:	00004517          	auipc	a0,0x4
ffffffffc02028fc:	09850513          	addi	a0,a0,152 # ffffffffc0206990 <etext+0xf76>
ffffffffc0202900:	895fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202904:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202908:	00099917          	auipc	s2,0x99
ffffffffc020290c:	d2090913          	addi	s2,s2,-736 # ffffffffc029b628 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202910:	7b9c                	ld	a5,48(a5)
ffffffffc0202912:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202914:	00004517          	auipc	a0,0x4
ffffffffc0202918:	09450513          	addi	a0,a0,148 # ffffffffc02069a8 <etext+0xf8e>
ffffffffc020291c:	879fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202920:	00007697          	auipc	a3,0x7
ffffffffc0202924:	6e068693          	addi	a3,a3,1760 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202928:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020292c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202930:	2af6eee3          	bltu	a3,a5,ffffffffc02033ec <pmm_init+0xbf2>
ffffffffc0202934:	0009b783          	ld	a5,0(s3)
ffffffffc0202938:	8e9d                	sub	a3,a3,a5
ffffffffc020293a:	00099797          	auipc	a5,0x99
ffffffffc020293e:	ced7b323          	sd	a3,-794(a5) # ffffffffc029b620 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202942:	100027f3          	csrr	a5,sstatus
ffffffffc0202946:	8b89                	andi	a5,a5,2
ffffffffc0202948:	48079963          	bnez	a5,ffffffffc0202dda <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc020294c:	000b3783          	ld	a5,0(s6)
ffffffffc0202950:	779c                	ld	a5,40(a5)
ffffffffc0202952:	9782                	jalr	a5
ffffffffc0202954:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202956:	6098                	ld	a4,0(s1)
ffffffffc0202958:	c80007b7          	lui	a5,0xc8000
ffffffffc020295c:	83b1                	srli	a5,a5,0xc
ffffffffc020295e:	66e7e663          	bltu	a5,a4,ffffffffc0202fca <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202962:	00093503          	ld	a0,0(s2)
ffffffffc0202966:	64050263          	beqz	a0,ffffffffc0202faa <pmm_init+0x7b0>
ffffffffc020296a:	03451793          	slli	a5,a0,0x34
ffffffffc020296e:	62079e63          	bnez	a5,ffffffffc0202faa <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202972:	4601                	li	a2,0
ffffffffc0202974:	4581                	li	a1,0
ffffffffc0202976:	8b7ff0ef          	jal	ffffffffc020222c <get_page>
ffffffffc020297a:	240519e3          	bnez	a0,ffffffffc02033cc <pmm_init+0xbd2>
ffffffffc020297e:	100027f3          	csrr	a5,sstatus
ffffffffc0202982:	8b89                	andi	a5,a5,2
ffffffffc0202984:	44079063          	bnez	a5,ffffffffc0202dc4 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202988:	000b3783          	ld	a5,0(s6)
ffffffffc020298c:	4505                	li	a0,1
ffffffffc020298e:	6f9c                	ld	a5,24(a5)
ffffffffc0202990:	9782                	jalr	a5
ffffffffc0202992:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202994:	00093503          	ld	a0,0(s2)
ffffffffc0202998:	4681                	li	a3,0
ffffffffc020299a:	4601                	li	a2,0
ffffffffc020299c:	85d2                	mv	a1,s4
ffffffffc020299e:	d67ff0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc02029a2:	280511e3          	bnez	a0,ffffffffc0203424 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02029a6:	00093503          	ld	a0,0(s2)
ffffffffc02029aa:	4601                	li	a2,0
ffffffffc02029ac:	4581                	li	a1,0
ffffffffc02029ae:	e20ff0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc02029b2:	240509e3          	beqz	a0,ffffffffc0203404 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc02029b6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02029b8:	0017f713          	andi	a4,a5,1
ffffffffc02029bc:	58070f63          	beqz	a4,ffffffffc0202f5a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc02029c0:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02029c2:	078a                	slli	a5,a5,0x2
ffffffffc02029c4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029c6:	58e7f863          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02029ca:	000bb683          	ld	a3,0(s7)
ffffffffc02029ce:	079a                	slli	a5,a5,0x6
ffffffffc02029d0:	fe000637          	lui	a2,0xfe000
ffffffffc02029d4:	97b2                	add	a5,a5,a2
ffffffffc02029d6:	97b6                	add	a5,a5,a3
ffffffffc02029d8:	14fa1ae3          	bne	s4,a5,ffffffffc020332c <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc02029dc:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_exit_out_size+0x1f5e48>
ffffffffc02029e0:	4785                	li	a5,1
ffffffffc02029e2:	12f695e3          	bne	a3,a5,ffffffffc020330c <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02029e6:	00093503          	ld	a0,0(s2)
ffffffffc02029ea:	77fd                	lui	a5,0xfffff
ffffffffc02029ec:	6114                	ld	a3,0(a0)
ffffffffc02029ee:	068a                	slli	a3,a3,0x2
ffffffffc02029f0:	8efd                	and	a3,a3,a5
ffffffffc02029f2:	00c6d613          	srli	a2,a3,0xc
ffffffffc02029f6:	0ee67fe3          	bgeu	a2,a4,ffffffffc02032f4 <pmm_init+0xafa>
ffffffffc02029fa:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029fe:	96e2                	add	a3,a3,s8
ffffffffc0202a00:	0006ba83          	ld	s5,0(a3)
ffffffffc0202a04:	0a8a                	slli	s5,s5,0x2
ffffffffc0202a06:	00fafab3          	and	s5,s5,a5
ffffffffc0202a0a:	00cad793          	srli	a5,s5,0xc
ffffffffc0202a0e:	0ce7f6e3          	bgeu	a5,a4,ffffffffc02032da <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a12:	4601                	li	a2,0
ffffffffc0202a14:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202a16:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a18:	db6ff0ef          	jal	ffffffffc0201fce <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202a1c:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a1e:	05851ee3          	bne	a0,s8,ffffffffc020327a <pmm_init+0xa80>
ffffffffc0202a22:	100027f3          	csrr	a5,sstatus
ffffffffc0202a26:	8b89                	andi	a5,a5,2
ffffffffc0202a28:	3e079b63          	bnez	a5,ffffffffc0202e1e <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202a30:	4505                	li	a0,1
ffffffffc0202a32:	6f9c                	ld	a5,24(a5)
ffffffffc0202a34:	9782                	jalr	a5
ffffffffc0202a36:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202a38:	00093503          	ld	a0,0(s2)
ffffffffc0202a3c:	46d1                	li	a3,20
ffffffffc0202a3e:	6605                	lui	a2,0x1
ffffffffc0202a40:	85e2                	mv	a1,s8
ffffffffc0202a42:	cc3ff0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc0202a46:	06051ae3          	bnez	a0,ffffffffc02032ba <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a4a:	00093503          	ld	a0,0(s2)
ffffffffc0202a4e:	4601                	li	a2,0
ffffffffc0202a50:	6585                	lui	a1,0x1
ffffffffc0202a52:	d7cff0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc0202a56:	040502e3          	beqz	a0,ffffffffc020329a <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202a5a:	611c                	ld	a5,0(a0)
ffffffffc0202a5c:	0107f713          	andi	a4,a5,16
ffffffffc0202a60:	7e070163          	beqz	a4,ffffffffc0203242 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202a64:	8b91                	andi	a5,a5,4
ffffffffc0202a66:	7a078e63          	beqz	a5,ffffffffc0203222 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202a6a:	00093503          	ld	a0,0(s2)
ffffffffc0202a6e:	611c                	ld	a5,0(a0)
ffffffffc0202a70:	8bc1                	andi	a5,a5,16
ffffffffc0202a72:	78078863          	beqz	a5,ffffffffc0203202 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202a76:	000c2703          	lw	a4,0(s8)
ffffffffc0202a7a:	4785                	li	a5,1
ffffffffc0202a7c:	76f71363          	bne	a4,a5,ffffffffc02031e2 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a80:	4681                	li	a3,0
ffffffffc0202a82:	6605                	lui	a2,0x1
ffffffffc0202a84:	85d2                	mv	a1,s4
ffffffffc0202a86:	c7fff0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc0202a8a:	72051c63          	bnez	a0,ffffffffc02031c2 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202a8e:	000a2703          	lw	a4,0(s4)
ffffffffc0202a92:	4789                	li	a5,2
ffffffffc0202a94:	70f71763          	bne	a4,a5,ffffffffc02031a2 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202a98:	000c2783          	lw	a5,0(s8)
ffffffffc0202a9c:	6e079363          	bnez	a5,ffffffffc0203182 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202aa0:	00093503          	ld	a0,0(s2)
ffffffffc0202aa4:	4601                	li	a2,0
ffffffffc0202aa6:	6585                	lui	a1,0x1
ffffffffc0202aa8:	d26ff0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc0202aac:	6a050b63          	beqz	a0,ffffffffc0203162 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202ab0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202ab2:	00177793          	andi	a5,a4,1
ffffffffc0202ab6:	4a078263          	beqz	a5,ffffffffc0202f5a <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202aba:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202abc:	00271793          	slli	a5,a4,0x2
ffffffffc0202ac0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ac2:	48d7fa63          	bgeu	a5,a3,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac6:	000bb683          	ld	a3,0(s7)
ffffffffc0202aca:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202ace:	97d6                	add	a5,a5,s5
ffffffffc0202ad0:	079a                	slli	a5,a5,0x6
ffffffffc0202ad2:	97b6                	add	a5,a5,a3
ffffffffc0202ad4:	66fa1763          	bne	s4,a5,ffffffffc0203142 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202ad8:	8b41                	andi	a4,a4,16
ffffffffc0202ada:	64071463          	bnez	a4,ffffffffc0203122 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202ade:	00093503          	ld	a0,0(s2)
ffffffffc0202ae2:	4581                	li	a1,0
ffffffffc0202ae4:	b85ff0ef          	jal	ffffffffc0202668 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202ae8:	000a2c83          	lw	s9,0(s4)
ffffffffc0202aec:	4785                	li	a5,1
ffffffffc0202aee:	60fc9a63          	bne	s9,a5,ffffffffc0203102 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202af2:	000c2783          	lw	a5,0(s8)
ffffffffc0202af6:	5e079663          	bnez	a5,ffffffffc02030e2 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202afa:	00093503          	ld	a0,0(s2)
ffffffffc0202afe:	6585                	lui	a1,0x1
ffffffffc0202b00:	b69ff0ef          	jal	ffffffffc0202668 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202b04:	000a2783          	lw	a5,0(s4)
ffffffffc0202b08:	52079d63          	bnez	a5,ffffffffc0203042 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202b0c:	000c2783          	lw	a5,0(s8)
ffffffffc0202b10:	50079963          	bnez	a5,ffffffffc0203022 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202b14:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b18:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b1a:	000a3783          	ld	a5,0(s4)
ffffffffc0202b1e:	078a                	slli	a5,a5,0x2
ffffffffc0202b20:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b22:	42e7fa63          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b26:	000bb503          	ld	a0,0(s7)
ffffffffc0202b2a:	97d6                	add	a5,a5,s5
ffffffffc0202b2c:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202b2e:	00f506b3          	add	a3,a0,a5
ffffffffc0202b32:	4294                	lw	a3,0(a3)
ffffffffc0202b34:	4d969763          	bne	a3,s9,ffffffffc0203002 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202b38:	8799                	srai	a5,a5,0x6
ffffffffc0202b3a:	00080637          	lui	a2,0x80
ffffffffc0202b3e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b40:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202b44:	4ae7f363          	bgeu	a5,a4,ffffffffc0202fea <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202b48:	0009b783          	ld	a5,0(s3)
ffffffffc0202b4c:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b4e:	639c                	ld	a5,0(a5)
ffffffffc0202b50:	078a                	slli	a5,a5,0x2
ffffffffc0202b52:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b54:	40e7f163          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b58:	8f91                	sub	a5,a5,a2
ffffffffc0202b5a:	079a                	slli	a5,a5,0x6
ffffffffc0202b5c:	953e                	add	a0,a0,a5
ffffffffc0202b5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b62:	8b89                	andi	a5,a5,2
ffffffffc0202b64:	30079863          	bnez	a5,ffffffffc0202e74 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202b68:	000b3783          	ld	a5,0(s6)
ffffffffc0202b6c:	4585                	li	a1,1
ffffffffc0202b6e:	739c                	ld	a5,32(a5)
ffffffffc0202b70:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b72:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b76:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b78:	078a                	slli	a5,a5,0x2
ffffffffc0202b7a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b7c:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b80:	000bb503          	ld	a0,0(s7)
ffffffffc0202b84:	fe000737          	lui	a4,0xfe000
ffffffffc0202b88:	079a                	slli	a5,a5,0x6
ffffffffc0202b8a:	97ba                	add	a5,a5,a4
ffffffffc0202b8c:	953e                	add	a0,a0,a5
ffffffffc0202b8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b92:	8b89                	andi	a5,a5,2
ffffffffc0202b94:	2c079463          	bnez	a5,ffffffffc0202e5c <pmm_init+0x662>
ffffffffc0202b98:	000b3783          	ld	a5,0(s6)
ffffffffc0202b9c:	4585                	li	a1,1
ffffffffc0202b9e:	739c                	ld	a5,32(a5)
ffffffffc0202ba0:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ba2:	00093783          	ld	a5,0(s2)
ffffffffc0202ba6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd63998>
    asm volatile("sfence.vma");
ffffffffc0202baa:	12000073          	sfence.vma
ffffffffc0202bae:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb2:	8b89                	andi	a5,a5,2
ffffffffc0202bb4:	28079a63          	bnez	a5,ffffffffc0202e48 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bb8:	000b3783          	ld	a5,0(s6)
ffffffffc0202bbc:	779c                	ld	a5,40(a5)
ffffffffc0202bbe:	9782                	jalr	a5
ffffffffc0202bc0:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202bc2:	4d441063          	bne	s0,s4,ffffffffc0203082 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202bc6:	00004517          	auipc	a0,0x4
ffffffffc0202bca:	13250513          	addi	a0,a0,306 # ffffffffc0206cf8 <etext+0x12de>
ffffffffc0202bce:	dc6fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202bd2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bd6:	8b89                	andi	a5,a5,2
ffffffffc0202bd8:	24079e63          	bnez	a5,ffffffffc0202e34 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202be0:	779c                	ld	a5,40(a5)
ffffffffc0202be2:	9782                	jalr	a5
ffffffffc0202be4:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202be6:	609c                	ld	a5,0(s1)
ffffffffc0202be8:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bec:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bee:	00c79713          	slli	a4,a5,0xc
ffffffffc0202bf2:	6a85                	lui	s5,0x1
ffffffffc0202bf4:	02e47c63          	bgeu	s0,a4,ffffffffc0202c2c <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202bf8:	00c45713          	srli	a4,s0,0xc
ffffffffc0202bfc:	30f77063          	bgeu	a4,a5,ffffffffc0202efc <pmm_init+0x702>
ffffffffc0202c00:	0009b583          	ld	a1,0(s3)
ffffffffc0202c04:	00093503          	ld	a0,0(s2)
ffffffffc0202c08:	4601                	li	a2,0
ffffffffc0202c0a:	95a2                	add	a1,a1,s0
ffffffffc0202c0c:	bc2ff0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc0202c10:	32050363          	beqz	a0,ffffffffc0202f36 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202c14:	611c                	ld	a5,0(a0)
ffffffffc0202c16:	078a                	slli	a5,a5,0x2
ffffffffc0202c18:	0147f7b3          	and	a5,a5,s4
ffffffffc0202c1c:	2e879d63          	bne	a5,s0,ffffffffc0202f16 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c20:	609c                	ld	a5,0(s1)
ffffffffc0202c22:	9456                	add	s0,s0,s5
ffffffffc0202c24:	00c79713          	slli	a4,a5,0xc
ffffffffc0202c28:	fce468e3          	bltu	s0,a4,ffffffffc0202bf8 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202c2c:	00093783          	ld	a5,0(s2)
ffffffffc0202c30:	639c                	ld	a5,0(a5)
ffffffffc0202c32:	42079863          	bnez	a5,ffffffffc0203062 <pmm_init+0x868>
ffffffffc0202c36:	100027f3          	csrr	a5,sstatus
ffffffffc0202c3a:	8b89                	andi	a5,a5,2
ffffffffc0202c3c:	24079863          	bnez	a5,ffffffffc0202e8c <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c40:	000b3783          	ld	a5,0(s6)
ffffffffc0202c44:	4505                	li	a0,1
ffffffffc0202c46:	6f9c                	ld	a5,24(a5)
ffffffffc0202c48:	9782                	jalr	a5
ffffffffc0202c4a:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202c4c:	00093503          	ld	a0,0(s2)
ffffffffc0202c50:	4699                	li	a3,6
ffffffffc0202c52:	10000613          	li	a2,256
ffffffffc0202c56:	85a2                	mv	a1,s0
ffffffffc0202c58:	aadff0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc0202c5c:	46051363          	bnez	a0,ffffffffc02030c2 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202c60:	4018                	lw	a4,0(s0)
ffffffffc0202c62:	4785                	li	a5,1
ffffffffc0202c64:	42f71f63          	bne	a4,a5,ffffffffc02030a2 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202c68:	00093503          	ld	a0,0(s2)
ffffffffc0202c6c:	6605                	lui	a2,0x1
ffffffffc0202c6e:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7ab0>
ffffffffc0202c72:	4699                	li	a3,6
ffffffffc0202c74:	85a2                	mv	a1,s0
ffffffffc0202c76:	a8fff0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc0202c7a:	72051963          	bnez	a0,ffffffffc02033ac <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202c7e:	4018                	lw	a4,0(s0)
ffffffffc0202c80:	4789                	li	a5,2
ffffffffc0202c82:	70f71563          	bne	a4,a5,ffffffffc020338c <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c86:	00004597          	auipc	a1,0x4
ffffffffc0202c8a:	1ba58593          	addi	a1,a1,442 # ffffffffc0206e40 <etext+0x1426>
ffffffffc0202c8e:	10000513          	li	a0,256
ffffffffc0202c92:	4df020ef          	jal	ffffffffc0205970 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c96:	6585                	lui	a1,0x1
ffffffffc0202c98:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7ab0>
ffffffffc0202c9c:	10000513          	li	a0,256
ffffffffc0202ca0:	4e3020ef          	jal	ffffffffc0205982 <strcmp>
ffffffffc0202ca4:	6c051463          	bnez	a0,ffffffffc020336c <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202ca8:	000bb683          	ld	a3,0(s7)
ffffffffc0202cac:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202cb0:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202cb2:	40d406b3          	sub	a3,s0,a3
ffffffffc0202cb6:	8699                	srai	a3,a3,0x6
ffffffffc0202cb8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202cba:	00c69793          	slli	a5,a3,0xc
ffffffffc0202cbe:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cc0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202cc2:	32e7f463          	bgeu	a5,a4,ffffffffc0202fea <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202cc6:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cca:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202cce:	97b6                	add	a5,a5,a3
ffffffffc0202cd0:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x75f48>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cd4:	469020ef          	jal	ffffffffc020593c <strlen>
ffffffffc0202cd8:	66051a63          	bnez	a0,ffffffffc020334c <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202cdc:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202ce0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ce2:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd63998>
ffffffffc0202ce6:	078a                	slli	a5,a5,0x2
ffffffffc0202ce8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cea:	26e7f663          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cee:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202cf2:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202fea <pmm_init+0x7f0>
ffffffffc0202cf6:	0009b783          	ld	a5,0(s3)
ffffffffc0202cfa:	00f689b3          	add	s3,a3,a5
ffffffffc0202cfe:	100027f3          	csrr	a5,sstatus
ffffffffc0202d02:	8b89                	andi	a5,a5,2
ffffffffc0202d04:	1e079163          	bnez	a5,ffffffffc0202ee6 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202d08:	000b3783          	ld	a5,0(s6)
ffffffffc0202d0c:	8522                	mv	a0,s0
ffffffffc0202d0e:	4585                	li	a1,1
ffffffffc0202d10:	739c                	ld	a5,32(a5)
ffffffffc0202d12:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d14:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202d18:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d1a:	078a                	slli	a5,a5,0x2
ffffffffc0202d1c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d1e:	22e7fc63          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d22:	000bb503          	ld	a0,0(s7)
ffffffffc0202d26:	fe000737          	lui	a4,0xfe000
ffffffffc0202d2a:	079a                	slli	a5,a5,0x6
ffffffffc0202d2c:	97ba                	add	a5,a5,a4
ffffffffc0202d2e:	953e                	add	a0,a0,a5
ffffffffc0202d30:	100027f3          	csrr	a5,sstatus
ffffffffc0202d34:	8b89                	andi	a5,a5,2
ffffffffc0202d36:	18079c63          	bnez	a5,ffffffffc0202ece <pmm_init+0x6d4>
ffffffffc0202d3a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d3e:	4585                	li	a1,1
ffffffffc0202d40:	739c                	ld	a5,32(a5)
ffffffffc0202d42:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d44:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202d48:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d4a:	078a                	slli	a5,a5,0x2
ffffffffc0202d4c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d4e:	20e7f463          	bgeu	a5,a4,ffffffffc0202f56 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d52:	000bb503          	ld	a0,0(s7)
ffffffffc0202d56:	fe000737          	lui	a4,0xfe000
ffffffffc0202d5a:	079a                	slli	a5,a5,0x6
ffffffffc0202d5c:	97ba                	add	a5,a5,a4
ffffffffc0202d5e:	953e                	add	a0,a0,a5
ffffffffc0202d60:	100027f3          	csrr	a5,sstatus
ffffffffc0202d64:	8b89                	andi	a5,a5,2
ffffffffc0202d66:	14079863          	bnez	a5,ffffffffc0202eb6 <pmm_init+0x6bc>
ffffffffc0202d6a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6e:	4585                	li	a1,1
ffffffffc0202d70:	739c                	ld	a5,32(a5)
ffffffffc0202d72:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d74:	00093783          	ld	a5,0(s2)
ffffffffc0202d78:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d7c:	12000073          	sfence.vma
ffffffffc0202d80:	100027f3          	csrr	a5,sstatus
ffffffffc0202d84:	8b89                	andi	a5,a5,2
ffffffffc0202d86:	10079e63          	bnez	a5,ffffffffc0202ea2 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8e:	779c                	ld	a5,40(a5)
ffffffffc0202d90:	9782                	jalr	a5
ffffffffc0202d92:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d94:	1e8c1b63          	bne	s8,s0,ffffffffc0202f8a <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d98:	00004517          	auipc	a0,0x4
ffffffffc0202d9c:	12050513          	addi	a0,a0,288 # ffffffffc0206eb8 <etext+0x149e>
ffffffffc0202da0:	bf4fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202da4:	7406                	ld	s0,96(sp)
ffffffffc0202da6:	70a6                	ld	ra,104(sp)
ffffffffc0202da8:	64e6                	ld	s1,88(sp)
ffffffffc0202daa:	6946                	ld	s2,80(sp)
ffffffffc0202dac:	69a6                	ld	s3,72(sp)
ffffffffc0202dae:	6a06                	ld	s4,64(sp)
ffffffffc0202db0:	7ae2                	ld	s5,56(sp)
ffffffffc0202db2:	7b42                	ld	s6,48(sp)
ffffffffc0202db4:	7ba2                	ld	s7,40(sp)
ffffffffc0202db6:	7c02                	ld	s8,32(sp)
ffffffffc0202db8:	6ce2                	ld	s9,24(sp)
ffffffffc0202dba:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202dbc:	f85fe06f          	j	ffffffffc0201d40 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202dc0:	853e                	mv	a0,a5
ffffffffc0202dc2:	b4e1                	j	ffffffffc020288a <pmm_init+0x90>
        intr_disable();
ffffffffc0202dc4:	b41fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dc8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dcc:	4505                	li	a0,1
ffffffffc0202dce:	6f9c                	ld	a5,24(a5)
ffffffffc0202dd0:	9782                	jalr	a5
ffffffffc0202dd2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dd4:	b2bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dd8:	be75                	j	ffffffffc0202994 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202dda:	b2bfd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dde:	000b3783          	ld	a5,0(s6)
ffffffffc0202de2:	779c                	ld	a5,40(a5)
ffffffffc0202de4:	9782                	jalr	a5
ffffffffc0202de6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202de8:	b17fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202dec:	b6ad                	j	ffffffffc0202956 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202dee:	6705                	lui	a4,0x1
ffffffffc0202df0:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7bb1>
ffffffffc0202df2:	96ba                	add	a3,a3,a4
ffffffffc0202df4:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202df6:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202dfa:	14a77e63          	bgeu	a4,a0,ffffffffc0202f56 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202dfe:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202e02:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202e04:	071a                	slli	a4,a4,0x6
ffffffffc0202e06:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202e0a:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202e0c:	6a9c                	ld	a5,16(a3)
ffffffffc0202e0e:	00c45593          	srli	a1,s0,0xc
ffffffffc0202e12:	00e60533          	add	a0,a2,a4
ffffffffc0202e16:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202e18:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202e1c:	bcf1                	j	ffffffffc02028f8 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202e1e:	ae7fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e22:	000b3783          	ld	a5,0(s6)
ffffffffc0202e26:	4505                	li	a0,1
ffffffffc0202e28:	6f9c                	ld	a5,24(a5)
ffffffffc0202e2a:	9782                	jalr	a5
ffffffffc0202e2c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e2e:	ad1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e32:	b119                	j	ffffffffc0202a38 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202e34:	ad1fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e38:	000b3783          	ld	a5,0(s6)
ffffffffc0202e3c:	779c                	ld	a5,40(a5)
ffffffffc0202e3e:	9782                	jalr	a5
ffffffffc0202e40:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e42:	abdfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e46:	b345                	j	ffffffffc0202be6 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202e48:	abdfd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e4c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e50:	779c                	ld	a5,40(a5)
ffffffffc0202e52:	9782                	jalr	a5
ffffffffc0202e54:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e56:	aa9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e5a:	b3a5                	j	ffffffffc0202bc2 <pmm_init+0x3c8>
ffffffffc0202e5c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e5e:	aa7fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e62:	000b3783          	ld	a5,0(s6)
ffffffffc0202e66:	6522                	ld	a0,8(sp)
ffffffffc0202e68:	4585                	li	a1,1
ffffffffc0202e6a:	739c                	ld	a5,32(a5)
ffffffffc0202e6c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e6e:	a91fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e72:	bb05                	j	ffffffffc0202ba2 <pmm_init+0x3a8>
ffffffffc0202e74:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e76:	a8ffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202e7a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e7e:	6522                	ld	a0,8(sp)
ffffffffc0202e80:	4585                	li	a1,1
ffffffffc0202e82:	739c                	ld	a5,32(a5)
ffffffffc0202e84:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e86:	a79fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e8a:	b1e5                	j	ffffffffc0202b72 <pmm_init+0x378>
        intr_disable();
ffffffffc0202e8c:	a79fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e90:	000b3783          	ld	a5,0(s6)
ffffffffc0202e94:	4505                	li	a0,1
ffffffffc0202e96:	6f9c                	ld	a5,24(a5)
ffffffffc0202e98:	9782                	jalr	a5
ffffffffc0202e9a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e9c:	a63fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ea0:	b375                	j	ffffffffc0202c4c <pmm_init+0x452>
        intr_disable();
ffffffffc0202ea2:	a63fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ea6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eaa:	779c                	ld	a5,40(a5)
ffffffffc0202eac:	9782                	jalr	a5
ffffffffc0202eae:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202eb0:	a4ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202eb4:	b5c5                	j	ffffffffc0202d94 <pmm_init+0x59a>
ffffffffc0202eb6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202eb8:	a4dfd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202ebc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ec0:	6522                	ld	a0,8(sp)
ffffffffc0202ec2:	4585                	li	a1,1
ffffffffc0202ec4:	739c                	ld	a5,32(a5)
ffffffffc0202ec6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ec8:	a37fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ecc:	b565                	j	ffffffffc0202d74 <pmm_init+0x57a>
ffffffffc0202ece:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ed0:	a35fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202ed4:	000b3783          	ld	a5,0(s6)
ffffffffc0202ed8:	6522                	ld	a0,8(sp)
ffffffffc0202eda:	4585                	li	a1,1
ffffffffc0202edc:	739c                	ld	a5,32(a5)
ffffffffc0202ede:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ee0:	a1ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ee4:	b585                	j	ffffffffc0202d44 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202ee6:	a1ffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202eea:	000b3783          	ld	a5,0(s6)
ffffffffc0202eee:	8522                	mv	a0,s0
ffffffffc0202ef0:	4585                	li	a1,1
ffffffffc0202ef2:	739c                	ld	a5,32(a5)
ffffffffc0202ef4:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ef6:	a09fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202efa:	bd29                	j	ffffffffc0202d14 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202efc:	86a2                	mv	a3,s0
ffffffffc0202efe:	00004617          	auipc	a2,0x4
ffffffffc0202f02:	8d260613          	addi	a2,a2,-1838 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0202f06:	24400593          	li	a1,580
ffffffffc0202f0a:	00004517          	auipc	a0,0x4
ffffffffc0202f0e:	9b650513          	addi	a0,a0,-1610 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202f12:	d34fd0ef          	jal	ffffffffc0200446 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202f16:	00004697          	auipc	a3,0x4
ffffffffc0202f1a:	e4268693          	addi	a3,a3,-446 # ffffffffc0206d58 <etext+0x133e>
ffffffffc0202f1e:	00003617          	auipc	a2,0x3
ffffffffc0202f22:	50260613          	addi	a2,a2,1282 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202f26:	24500593          	li	a1,581
ffffffffc0202f2a:	00004517          	auipc	a0,0x4
ffffffffc0202f2e:	99650513          	addi	a0,a0,-1642 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202f32:	d14fd0ef          	jal	ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f36:	00004697          	auipc	a3,0x4
ffffffffc0202f3a:	de268693          	addi	a3,a3,-542 # ffffffffc0206d18 <etext+0x12fe>
ffffffffc0202f3e:	00003617          	auipc	a2,0x3
ffffffffc0202f42:	4e260613          	addi	a2,a2,1250 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202f46:	24400593          	li	a1,580
ffffffffc0202f4a:	00004517          	auipc	a0,0x4
ffffffffc0202f4e:	97650513          	addi	a0,a0,-1674 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202f52:	cf4fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202f56:	fb5fe0ef          	jal	ffffffffc0201f0a <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202f5a:	00004617          	auipc	a2,0x4
ffffffffc0202f5e:	b5e60613          	addi	a2,a2,-1186 # ffffffffc0206ab8 <etext+0x109e>
ffffffffc0202f62:	07f00593          	li	a1,127
ffffffffc0202f66:	00004517          	auipc	a0,0x4
ffffffffc0202f6a:	89250513          	addi	a0,a0,-1902 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0202f6e:	cd8fd0ef          	jal	ffffffffc0200446 <__panic>
        panic("DTB memory info not available");
ffffffffc0202f72:	00004617          	auipc	a2,0x4
ffffffffc0202f76:	9be60613          	addi	a2,a2,-1602 # ffffffffc0206930 <etext+0xf16>
ffffffffc0202f7a:	06500593          	li	a1,101
ffffffffc0202f7e:	00004517          	auipc	a0,0x4
ffffffffc0202f82:	94250513          	addi	a0,a0,-1726 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202f86:	cc0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202f8a:	00004697          	auipc	a3,0x4
ffffffffc0202f8e:	d4668693          	addi	a3,a3,-698 # ffffffffc0206cd0 <etext+0x12b6>
ffffffffc0202f92:	00003617          	auipc	a2,0x3
ffffffffc0202f96:	48e60613          	addi	a2,a2,1166 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202f9a:	25f00593          	li	a1,607
ffffffffc0202f9e:	00004517          	auipc	a0,0x4
ffffffffc0202fa2:	92250513          	addi	a0,a0,-1758 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202fa6:	ca0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202faa:	00004697          	auipc	a3,0x4
ffffffffc0202fae:	a3e68693          	addi	a3,a3,-1474 # ffffffffc02069e8 <etext+0xfce>
ffffffffc0202fb2:	00003617          	auipc	a2,0x3
ffffffffc0202fb6:	46e60613          	addi	a2,a2,1134 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202fba:	20600593          	li	a1,518
ffffffffc0202fbe:	00004517          	auipc	a0,0x4
ffffffffc0202fc2:	90250513          	addi	a0,a0,-1790 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202fc6:	c80fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202fca:	00004697          	auipc	a3,0x4
ffffffffc0202fce:	9fe68693          	addi	a3,a3,-1538 # ffffffffc02069c8 <etext+0xfae>
ffffffffc0202fd2:	00003617          	auipc	a2,0x3
ffffffffc0202fd6:	44e60613          	addi	a2,a2,1102 # ffffffffc0206420 <etext+0xa06>
ffffffffc0202fda:	20500593          	li	a1,517
ffffffffc0202fde:	00004517          	auipc	a0,0x4
ffffffffc0202fe2:	8e250513          	addi	a0,a0,-1822 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0202fe6:	c60fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202fea:	00003617          	auipc	a2,0x3
ffffffffc0202fee:	7e660613          	addi	a2,a2,2022 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0202ff2:	07100593          	li	a1,113
ffffffffc0202ff6:	00004517          	auipc	a0,0x4
ffffffffc0202ffa:	80250513          	addi	a0,a0,-2046 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0202ffe:	c48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203002:	00004697          	auipc	a3,0x4
ffffffffc0203006:	c9e68693          	addi	a3,a3,-866 # ffffffffc0206ca0 <etext+0x1286>
ffffffffc020300a:	00003617          	auipc	a2,0x3
ffffffffc020300e:	41660613          	addi	a2,a2,1046 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203012:	22d00593          	li	a1,557
ffffffffc0203016:	00004517          	auipc	a0,0x4
ffffffffc020301a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020301e:	c28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203022:	00004697          	auipc	a3,0x4
ffffffffc0203026:	c3668693          	addi	a3,a3,-970 # ffffffffc0206c58 <etext+0x123e>
ffffffffc020302a:	00003617          	auipc	a2,0x3
ffffffffc020302e:	3f660613          	addi	a2,a2,1014 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203032:	22b00593          	li	a1,555
ffffffffc0203036:	00004517          	auipc	a0,0x4
ffffffffc020303a:	88a50513          	addi	a0,a0,-1910 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020303e:	c08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203042:	00004697          	auipc	a3,0x4
ffffffffc0203046:	c4668693          	addi	a3,a3,-954 # ffffffffc0206c88 <etext+0x126e>
ffffffffc020304a:	00003617          	auipc	a2,0x3
ffffffffc020304e:	3d660613          	addi	a2,a2,982 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203052:	22a00593          	li	a1,554
ffffffffc0203056:	00004517          	auipc	a0,0x4
ffffffffc020305a:	86a50513          	addi	a0,a0,-1942 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020305e:	be8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203062:	00004697          	auipc	a3,0x4
ffffffffc0203066:	d0e68693          	addi	a3,a3,-754 # ffffffffc0206d70 <etext+0x1356>
ffffffffc020306a:	00003617          	auipc	a2,0x3
ffffffffc020306e:	3b660613          	addi	a2,a2,950 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203072:	24800593          	li	a1,584
ffffffffc0203076:	00004517          	auipc	a0,0x4
ffffffffc020307a:	84a50513          	addi	a0,a0,-1974 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020307e:	bc8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203082:	00004697          	auipc	a3,0x4
ffffffffc0203086:	c4e68693          	addi	a3,a3,-946 # ffffffffc0206cd0 <etext+0x12b6>
ffffffffc020308a:	00003617          	auipc	a2,0x3
ffffffffc020308e:	39660613          	addi	a2,a2,918 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203092:	23500593          	li	a1,565
ffffffffc0203096:	00004517          	auipc	a0,0x4
ffffffffc020309a:	82a50513          	addi	a0,a0,-2006 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020309e:	ba8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02030a2:	00004697          	auipc	a3,0x4
ffffffffc02030a6:	d2668693          	addi	a3,a3,-730 # ffffffffc0206dc8 <etext+0x13ae>
ffffffffc02030aa:	00003617          	auipc	a2,0x3
ffffffffc02030ae:	37660613          	addi	a2,a2,886 # ffffffffc0206420 <etext+0xa06>
ffffffffc02030b2:	24d00593          	li	a1,589
ffffffffc02030b6:	00004517          	auipc	a0,0x4
ffffffffc02030ba:	80a50513          	addi	a0,a0,-2038 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02030be:	b88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02030c2:	00004697          	auipc	a3,0x4
ffffffffc02030c6:	cc668693          	addi	a3,a3,-826 # ffffffffc0206d88 <etext+0x136e>
ffffffffc02030ca:	00003617          	auipc	a2,0x3
ffffffffc02030ce:	35660613          	addi	a2,a2,854 # ffffffffc0206420 <etext+0xa06>
ffffffffc02030d2:	24c00593          	li	a1,588
ffffffffc02030d6:	00003517          	auipc	a0,0x3
ffffffffc02030da:	7ea50513          	addi	a0,a0,2026 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02030de:	b68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030e2:	00004697          	auipc	a3,0x4
ffffffffc02030e6:	b7668693          	addi	a3,a3,-1162 # ffffffffc0206c58 <etext+0x123e>
ffffffffc02030ea:	00003617          	auipc	a2,0x3
ffffffffc02030ee:	33660613          	addi	a2,a2,822 # ffffffffc0206420 <etext+0xa06>
ffffffffc02030f2:	22700593          	li	a1,551
ffffffffc02030f6:	00003517          	auipc	a0,0x3
ffffffffc02030fa:	7ca50513          	addi	a0,a0,1994 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02030fe:	b48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203102:	00004697          	auipc	a3,0x4
ffffffffc0203106:	9f668693          	addi	a3,a3,-1546 # ffffffffc0206af8 <etext+0x10de>
ffffffffc020310a:	00003617          	auipc	a2,0x3
ffffffffc020310e:	31660613          	addi	a2,a2,790 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203112:	22600593          	li	a1,550
ffffffffc0203116:	00003517          	auipc	a0,0x3
ffffffffc020311a:	7aa50513          	addi	a0,a0,1962 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020311e:	b28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203122:	00004697          	auipc	a3,0x4
ffffffffc0203126:	b4e68693          	addi	a3,a3,-1202 # ffffffffc0206c70 <etext+0x1256>
ffffffffc020312a:	00003617          	auipc	a2,0x3
ffffffffc020312e:	2f660613          	addi	a2,a2,758 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203132:	22300593          	li	a1,547
ffffffffc0203136:	00003517          	auipc	a0,0x3
ffffffffc020313a:	78a50513          	addi	a0,a0,1930 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020313e:	b08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203142:	00004697          	auipc	a3,0x4
ffffffffc0203146:	99e68693          	addi	a3,a3,-1634 # ffffffffc0206ae0 <etext+0x10c6>
ffffffffc020314a:	00003617          	auipc	a2,0x3
ffffffffc020314e:	2d660613          	addi	a2,a2,726 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203152:	22200593          	li	a1,546
ffffffffc0203156:	00003517          	auipc	a0,0x3
ffffffffc020315a:	76a50513          	addi	a0,a0,1898 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020315e:	ae8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203162:	00004697          	auipc	a3,0x4
ffffffffc0203166:	a1e68693          	addi	a3,a3,-1506 # ffffffffc0206b80 <etext+0x1166>
ffffffffc020316a:	00003617          	auipc	a2,0x3
ffffffffc020316e:	2b660613          	addi	a2,a2,694 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203172:	22100593          	li	a1,545
ffffffffc0203176:	00003517          	auipc	a0,0x3
ffffffffc020317a:	74a50513          	addi	a0,a0,1866 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020317e:	ac8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203182:	00004697          	auipc	a3,0x4
ffffffffc0203186:	ad668693          	addi	a3,a3,-1322 # ffffffffc0206c58 <etext+0x123e>
ffffffffc020318a:	00003617          	auipc	a2,0x3
ffffffffc020318e:	29660613          	addi	a2,a2,662 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203192:	22000593          	li	a1,544
ffffffffc0203196:	00003517          	auipc	a0,0x3
ffffffffc020319a:	72a50513          	addi	a0,a0,1834 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020319e:	aa8fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02031a2:	00004697          	auipc	a3,0x4
ffffffffc02031a6:	a9e68693          	addi	a3,a3,-1378 # ffffffffc0206c40 <etext+0x1226>
ffffffffc02031aa:	00003617          	auipc	a2,0x3
ffffffffc02031ae:	27660613          	addi	a2,a2,630 # ffffffffc0206420 <etext+0xa06>
ffffffffc02031b2:	21f00593          	li	a1,543
ffffffffc02031b6:	00003517          	auipc	a0,0x3
ffffffffc02031ba:	70a50513          	addi	a0,a0,1802 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02031be:	a88fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02031c2:	00004697          	auipc	a3,0x4
ffffffffc02031c6:	a4e68693          	addi	a3,a3,-1458 # ffffffffc0206c10 <etext+0x11f6>
ffffffffc02031ca:	00003617          	auipc	a2,0x3
ffffffffc02031ce:	25660613          	addi	a2,a2,598 # ffffffffc0206420 <etext+0xa06>
ffffffffc02031d2:	21e00593          	li	a1,542
ffffffffc02031d6:	00003517          	auipc	a0,0x3
ffffffffc02031da:	6ea50513          	addi	a0,a0,1770 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02031de:	a68fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02031e2:	00004697          	auipc	a3,0x4
ffffffffc02031e6:	a1668693          	addi	a3,a3,-1514 # ffffffffc0206bf8 <etext+0x11de>
ffffffffc02031ea:	00003617          	auipc	a2,0x3
ffffffffc02031ee:	23660613          	addi	a2,a2,566 # ffffffffc0206420 <etext+0xa06>
ffffffffc02031f2:	21c00593          	li	a1,540
ffffffffc02031f6:	00003517          	auipc	a0,0x3
ffffffffc02031fa:	6ca50513          	addi	a0,a0,1738 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02031fe:	a48fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203202:	00004697          	auipc	a3,0x4
ffffffffc0203206:	9d668693          	addi	a3,a3,-1578 # ffffffffc0206bd8 <etext+0x11be>
ffffffffc020320a:	00003617          	auipc	a2,0x3
ffffffffc020320e:	21660613          	addi	a2,a2,534 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203212:	21b00593          	li	a1,539
ffffffffc0203216:	00003517          	auipc	a0,0x3
ffffffffc020321a:	6aa50513          	addi	a0,a0,1706 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020321e:	a28fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203222:	00004697          	auipc	a3,0x4
ffffffffc0203226:	9a668693          	addi	a3,a3,-1626 # ffffffffc0206bc8 <etext+0x11ae>
ffffffffc020322a:	00003617          	auipc	a2,0x3
ffffffffc020322e:	1f660613          	addi	a2,a2,502 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203232:	21a00593          	li	a1,538
ffffffffc0203236:	00003517          	auipc	a0,0x3
ffffffffc020323a:	68a50513          	addi	a0,a0,1674 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020323e:	a08fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203242:	00004697          	auipc	a3,0x4
ffffffffc0203246:	97668693          	addi	a3,a3,-1674 # ffffffffc0206bb8 <etext+0x119e>
ffffffffc020324a:	00003617          	auipc	a2,0x3
ffffffffc020324e:	1d660613          	addi	a2,a2,470 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203252:	21900593          	li	a1,537
ffffffffc0203256:	00003517          	auipc	a0,0x3
ffffffffc020325a:	66a50513          	addi	a0,a0,1642 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020325e:	9e8fd0ef          	jal	ffffffffc0200446 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203262:	00003617          	auipc	a2,0x3
ffffffffc0203266:	61660613          	addi	a2,a2,1558 # ffffffffc0206878 <etext+0xe5e>
ffffffffc020326a:	08100593          	li	a1,129
ffffffffc020326e:	00003517          	auipc	a0,0x3
ffffffffc0203272:	65250513          	addi	a0,a0,1618 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203276:	9d0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020327a:	00004697          	auipc	a3,0x4
ffffffffc020327e:	89668693          	addi	a3,a3,-1898 # ffffffffc0206b10 <etext+0x10f6>
ffffffffc0203282:	00003617          	auipc	a2,0x3
ffffffffc0203286:	19e60613          	addi	a2,a2,414 # ffffffffc0206420 <etext+0xa06>
ffffffffc020328a:	21400593          	li	a1,532
ffffffffc020328e:	00003517          	auipc	a0,0x3
ffffffffc0203292:	63250513          	addi	a0,a0,1586 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203296:	9b0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020329a:	00004697          	auipc	a3,0x4
ffffffffc020329e:	8e668693          	addi	a3,a3,-1818 # ffffffffc0206b80 <etext+0x1166>
ffffffffc02032a2:	00003617          	auipc	a2,0x3
ffffffffc02032a6:	17e60613          	addi	a2,a2,382 # ffffffffc0206420 <etext+0xa06>
ffffffffc02032aa:	21800593          	li	a1,536
ffffffffc02032ae:	00003517          	auipc	a0,0x3
ffffffffc02032b2:	61250513          	addi	a0,a0,1554 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02032b6:	990fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02032ba:	00004697          	auipc	a3,0x4
ffffffffc02032be:	88668693          	addi	a3,a3,-1914 # ffffffffc0206b40 <etext+0x1126>
ffffffffc02032c2:	00003617          	auipc	a2,0x3
ffffffffc02032c6:	15e60613          	addi	a2,a2,350 # ffffffffc0206420 <etext+0xa06>
ffffffffc02032ca:	21700593          	li	a1,535
ffffffffc02032ce:	00003517          	auipc	a0,0x3
ffffffffc02032d2:	5f250513          	addi	a0,a0,1522 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02032d6:	970fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02032da:	86d6                	mv	a3,s5
ffffffffc02032dc:	00003617          	auipc	a2,0x3
ffffffffc02032e0:	4f460613          	addi	a2,a2,1268 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc02032e4:	21300593          	li	a1,531
ffffffffc02032e8:	00003517          	auipc	a0,0x3
ffffffffc02032ec:	5d850513          	addi	a0,a0,1496 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02032f0:	956fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02032f4:	00003617          	auipc	a2,0x3
ffffffffc02032f8:	4dc60613          	addi	a2,a2,1244 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc02032fc:	21200593          	li	a1,530
ffffffffc0203300:	00003517          	auipc	a0,0x3
ffffffffc0203304:	5c050513          	addi	a0,a0,1472 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203308:	93efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020330c:	00003697          	auipc	a3,0x3
ffffffffc0203310:	7ec68693          	addi	a3,a3,2028 # ffffffffc0206af8 <etext+0x10de>
ffffffffc0203314:	00003617          	auipc	a2,0x3
ffffffffc0203318:	10c60613          	addi	a2,a2,268 # ffffffffc0206420 <etext+0xa06>
ffffffffc020331c:	21000593          	li	a1,528
ffffffffc0203320:	00003517          	auipc	a0,0x3
ffffffffc0203324:	5a050513          	addi	a0,a0,1440 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203328:	91efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020332c:	00003697          	auipc	a3,0x3
ffffffffc0203330:	7b468693          	addi	a3,a3,1972 # ffffffffc0206ae0 <etext+0x10c6>
ffffffffc0203334:	00003617          	auipc	a2,0x3
ffffffffc0203338:	0ec60613          	addi	a2,a2,236 # ffffffffc0206420 <etext+0xa06>
ffffffffc020333c:	20f00593          	li	a1,527
ffffffffc0203340:	00003517          	auipc	a0,0x3
ffffffffc0203344:	58050513          	addi	a0,a0,1408 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203348:	8fefd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020334c:	00004697          	auipc	a3,0x4
ffffffffc0203350:	b4468693          	addi	a3,a3,-1212 # ffffffffc0206e90 <etext+0x1476>
ffffffffc0203354:	00003617          	auipc	a2,0x3
ffffffffc0203358:	0cc60613          	addi	a2,a2,204 # ffffffffc0206420 <etext+0xa06>
ffffffffc020335c:	25600593          	li	a1,598
ffffffffc0203360:	00003517          	auipc	a0,0x3
ffffffffc0203364:	56050513          	addi	a0,a0,1376 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203368:	8defd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020336c:	00004697          	auipc	a3,0x4
ffffffffc0203370:	aec68693          	addi	a3,a3,-1300 # ffffffffc0206e58 <etext+0x143e>
ffffffffc0203374:	00003617          	auipc	a2,0x3
ffffffffc0203378:	0ac60613          	addi	a2,a2,172 # ffffffffc0206420 <etext+0xa06>
ffffffffc020337c:	25300593          	li	a1,595
ffffffffc0203380:	00003517          	auipc	a0,0x3
ffffffffc0203384:	54050513          	addi	a0,a0,1344 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203388:	8befd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020338c:	00004697          	auipc	a3,0x4
ffffffffc0203390:	a9c68693          	addi	a3,a3,-1380 # ffffffffc0206e28 <etext+0x140e>
ffffffffc0203394:	00003617          	auipc	a2,0x3
ffffffffc0203398:	08c60613          	addi	a2,a2,140 # ffffffffc0206420 <etext+0xa06>
ffffffffc020339c:	24f00593          	li	a1,591
ffffffffc02033a0:	00003517          	auipc	a0,0x3
ffffffffc02033a4:	52050513          	addi	a0,a0,1312 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02033a8:	89efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02033ac:	00004697          	auipc	a3,0x4
ffffffffc02033b0:	a3468693          	addi	a3,a3,-1484 # ffffffffc0206de0 <etext+0x13c6>
ffffffffc02033b4:	00003617          	auipc	a2,0x3
ffffffffc02033b8:	06c60613          	addi	a2,a2,108 # ffffffffc0206420 <etext+0xa06>
ffffffffc02033bc:	24e00593          	li	a1,590
ffffffffc02033c0:	00003517          	auipc	a0,0x3
ffffffffc02033c4:	50050513          	addi	a0,a0,1280 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02033c8:	87efd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02033cc:	00003697          	auipc	a3,0x3
ffffffffc02033d0:	65c68693          	addi	a3,a3,1628 # ffffffffc0206a28 <etext+0x100e>
ffffffffc02033d4:	00003617          	auipc	a2,0x3
ffffffffc02033d8:	04c60613          	addi	a2,a2,76 # ffffffffc0206420 <etext+0xa06>
ffffffffc02033dc:	20700593          	li	a1,519
ffffffffc02033e0:	00003517          	auipc	a0,0x3
ffffffffc02033e4:	4e050513          	addi	a0,a0,1248 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02033e8:	85efd0ef          	jal	ffffffffc0200446 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02033ec:	00003617          	auipc	a2,0x3
ffffffffc02033f0:	48c60613          	addi	a2,a2,1164 # ffffffffc0206878 <etext+0xe5e>
ffffffffc02033f4:	0c900593          	li	a1,201
ffffffffc02033f8:	00003517          	auipc	a0,0x3
ffffffffc02033fc:	4c850513          	addi	a0,a0,1224 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203400:	846fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203404:	00003697          	auipc	a3,0x3
ffffffffc0203408:	68468693          	addi	a3,a3,1668 # ffffffffc0206a88 <etext+0x106e>
ffffffffc020340c:	00003617          	auipc	a2,0x3
ffffffffc0203410:	01460613          	addi	a2,a2,20 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203414:	20e00593          	li	a1,526
ffffffffc0203418:	00003517          	auipc	a0,0x3
ffffffffc020341c:	4a850513          	addi	a0,a0,1192 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203420:	826fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203424:	00003697          	auipc	a3,0x3
ffffffffc0203428:	63468693          	addi	a3,a3,1588 # ffffffffc0206a58 <etext+0x103e>
ffffffffc020342c:	00003617          	auipc	a2,0x3
ffffffffc0203430:	ff460613          	addi	a2,a2,-12 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203434:	20b00593          	li	a1,523
ffffffffc0203438:	00003517          	auipc	a0,0x3
ffffffffc020343c:	48850513          	addi	a0,a0,1160 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203440:	806fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203444 <copy_range>:
{
ffffffffc0203444:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203446:	00d667b3          	or	a5,a2,a3
{
ffffffffc020344a:	e43a                	sd	a4,8(sp)
ffffffffc020344c:	fc86                	sd	ra,120(sp)
ffffffffc020344e:	f8a2                	sd	s0,112(sp)
ffffffffc0203450:	f4a6                	sd	s1,104(sp)
ffffffffc0203452:	f0ca                	sd	s2,96(sp)
ffffffffc0203454:	ecce                	sd	s3,88(sp)
ffffffffc0203456:	e8d2                	sd	s4,80(sp)
ffffffffc0203458:	e4d6                	sd	s5,72(sp)
ffffffffc020345a:	e0da                	sd	s6,64(sp)
ffffffffc020345c:	fc5e                	sd	s7,56(sp)
ffffffffc020345e:	f862                	sd	s8,48(sp)
ffffffffc0203460:	f466                	sd	s9,40(sp)
ffffffffc0203462:	f06a                	sd	s10,32(sp)
ffffffffc0203464:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203466:	03479713          	slli	a4,a5,0x34
ffffffffc020346a:	26071263          	bnez	a4,ffffffffc02036ce <copy_range+0x28a>
    assert(USER_ACCESS(start, end));
ffffffffc020346e:	002007b7          	lui	a5,0x200
ffffffffc0203472:	00d63733          	sltu	a4,a2,a3
ffffffffc0203476:	00f637b3          	sltu	a5,a2,a5
ffffffffc020347a:	00173713          	seqz	a4,a4
ffffffffc020347e:	8fd9                	or	a5,a5,a4
ffffffffc0203480:	8432                	mv	s0,a2
ffffffffc0203482:	8936                	mv	s2,a3
ffffffffc0203484:	22079563          	bnez	a5,ffffffffc02036ae <copy_range+0x26a>
ffffffffc0203488:	4785                	li	a5,1
ffffffffc020348a:	07fe                	slli	a5,a5,0x1f
ffffffffc020348c:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc020348e:	22f6f063          	bgeu	a3,a5,ffffffffc02036ae <copy_range+0x26a>
ffffffffc0203492:	5bfd                	li	s7,-1
ffffffffc0203494:	8a2a                	mv	s4,a0
ffffffffc0203496:	84ae                	mv	s1,a1
ffffffffc0203498:	6985                	lui	s3,0x1
ffffffffc020349a:	00cbdb93          	srli	s7,s7,0xc
    if (PPN(pa) >= npage)
ffffffffc020349e:	00098b17          	auipc	s6,0x98
ffffffffc02034a2:	19ab0b13          	addi	s6,s6,410 # ffffffffc029b638 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02034a6:	00098a97          	auipc	s5,0x98
ffffffffc02034aa:	19aa8a93          	addi	s5,s5,410 # ffffffffc029b640 <pages>
ffffffffc02034ae:	fff80c37          	lui	s8,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02034b2:	4601                	li	a2,0
ffffffffc02034b4:	85a2                	mv	a1,s0
ffffffffc02034b6:	8526                	mv	a0,s1
ffffffffc02034b8:	b17fe0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc02034bc:	8d2a                	mv	s10,a0
        if (ptep == NULL)
ffffffffc02034be:	c15d                	beqz	a0,ffffffffc0203564 <copy_range+0x120>
        if (*ptep & PTE_V)
ffffffffc02034c0:	611c                	ld	a5,0(a0)
ffffffffc02034c2:	8b85                	andi	a5,a5,1
ffffffffc02034c4:	e78d                	bnez	a5,ffffffffc02034ee <copy_range+0xaa>
        start += PGSIZE;
ffffffffc02034c6:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc02034c8:	c019                	beqz	s0,ffffffffc02034ce <copy_range+0x8a>
ffffffffc02034ca:	ff2464e3          	bltu	s0,s2,ffffffffc02034b2 <copy_range+0x6e>
    return 0;
ffffffffc02034ce:	4501                	li	a0,0
}
ffffffffc02034d0:	70e6                	ld	ra,120(sp)
ffffffffc02034d2:	7446                	ld	s0,112(sp)
ffffffffc02034d4:	74a6                	ld	s1,104(sp)
ffffffffc02034d6:	7906                	ld	s2,96(sp)
ffffffffc02034d8:	69e6                	ld	s3,88(sp)
ffffffffc02034da:	6a46                	ld	s4,80(sp)
ffffffffc02034dc:	6aa6                	ld	s5,72(sp)
ffffffffc02034de:	6b06                	ld	s6,64(sp)
ffffffffc02034e0:	7be2                	ld	s7,56(sp)
ffffffffc02034e2:	7c42                	ld	s8,48(sp)
ffffffffc02034e4:	7ca2                	ld	s9,40(sp)
ffffffffc02034e6:	7d02                	ld	s10,32(sp)
ffffffffc02034e8:	6de2                	ld	s11,24(sp)
ffffffffc02034ea:	6109                	addi	sp,sp,128
ffffffffc02034ec:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02034ee:	4605                	li	a2,1
ffffffffc02034f0:	85a2                	mv	a1,s0
ffffffffc02034f2:	8552                	mv	a0,s4
ffffffffc02034f4:	adbfe0ef          	jal	ffffffffc0201fce <get_pte>
ffffffffc02034f8:	10050763          	beqz	a0,ffffffffc0203606 <copy_range+0x1c2>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02034fc:	000d3d83          	ld	s11,0(s10)
    if (!(pte & PTE_V))
ffffffffc0203500:	001df793          	andi	a5,s11,1
ffffffffc0203504:	10078f63          	beqz	a5,ffffffffc0203622 <copy_range+0x1de>
    if (PPN(pa) >= npage)
ffffffffc0203508:	000b3703          	ld	a4,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc020350c:	002d9793          	slli	a5,s11,0x2
ffffffffc0203510:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203512:	0ee7fc63          	bgeu	a5,a4,ffffffffc020360a <copy_range+0x1c6>
    return &pages[PPN(pa) - nbase];
ffffffffc0203516:	000abd03          	ld	s10,0(s5)
ffffffffc020351a:	97e2                	add	a5,a5,s8
ffffffffc020351c:	079a                	slli	a5,a5,0x6
ffffffffc020351e:	9d3e                	add	s10,s10,a5
            if (share)
ffffffffc0203520:	67a2                	ld	a5,8(sp)
ffffffffc0203522:	cba1                	beqz	a5,ffffffffc0203572 <copy_range+0x12e>
                ret = page_insert(from, page, start, perm);
ffffffffc0203524:	01bdf693          	andi	a3,s11,27
ffffffffc0203528:	8622                	mv	a2,s0
ffffffffc020352a:	85ea                	mv	a1,s10
ffffffffc020352c:	8526                	mv	a0,s1
ffffffffc020352e:	9d6ff0ef          	jal	ffffffffc0202704 <page_insert>
                if (ret == 0)
ffffffffc0203532:	e909                	bnez	a0,ffffffffc0203544 <copy_range+0x100>
                    ret = page_insert(to, page, start, perm);
ffffffffc0203534:	01bdf693          	andi	a3,s11,27
ffffffffc0203538:	85ea                	mv	a1,s10
ffffffffc020353a:	8622                	mv	a2,s0
ffffffffc020353c:	8552                	mv	a0,s4
ffffffffc020353e:	9c6ff0ef          	jal	ffffffffc0202704 <page_insert>
            assert(ret == 0);
ffffffffc0203542:	d151                	beqz	a0,ffffffffc02034c6 <copy_range+0x82>
ffffffffc0203544:	00004697          	auipc	a3,0x4
ffffffffc0203548:	99468693          	addi	a3,a3,-1644 # ffffffffc0206ed8 <etext+0x14be>
ffffffffc020354c:	00003617          	auipc	a2,0x3
ffffffffc0203550:	ed460613          	addi	a2,a2,-300 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203554:	1a300593          	li	a1,419
ffffffffc0203558:	00003517          	auipc	a0,0x3
ffffffffc020355c:	36850513          	addi	a0,a0,872 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203560:	ee7fc0ef          	jal	ffffffffc0200446 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203564:	002007b7          	lui	a5,0x200
ffffffffc0203568:	97a2                	add	a5,a5,s0
ffffffffc020356a:	ffe00437          	lui	s0,0xffe00
ffffffffc020356e:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc0203570:	bfa1                	j	ffffffffc02034c8 <copy_range+0x84>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203572:	100027f3          	csrr	a5,sstatus
ffffffffc0203576:	8b89                	andi	a5,a5,2
ffffffffc0203578:	ebb5                	bnez	a5,ffffffffc02035ec <copy_range+0x1a8>
        page = pmm_manager->alloc_pages(n);
ffffffffc020357a:	00098797          	auipc	a5,0x98
ffffffffc020357e:	09e7b783          	ld	a5,158(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc0203582:	4505                	li	a0,1
ffffffffc0203584:	6f9c                	ld	a5,24(a5)
ffffffffc0203586:	9782                	jalr	a5
ffffffffc0203588:	8caa                	mv	s9,a0
                assert(page != NULL);
ffffffffc020358a:	100d0263          	beqz	s10,ffffffffc020368e <copy_range+0x24a>
                assert(npage != NULL);
ffffffffc020358e:	0e0c8063          	beqz	s9,ffffffffc020366e <copy_range+0x22a>
    return page - pages + nbase;
ffffffffc0203592:	000ab783          	ld	a5,0(s5)
ffffffffc0203596:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc020359a:	000b3683          	ld	a3,0(s6)
    return page - pages + nbase;
ffffffffc020359e:	40fd0d33          	sub	s10,s10,a5
ffffffffc02035a2:	406d5d13          	srai	s10,s10,0x6
ffffffffc02035a6:	9d32                	add	s10,s10,a2
    return KADDR(page2pa(page));
ffffffffc02035a8:	017d75b3          	and	a1,s10,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc02035ac:	0d32                	slli	s10,s10,0xc
    return KADDR(page2pa(page));
ffffffffc02035ae:	0ad5f363          	bgeu	a1,a3,ffffffffc0203654 <copy_range+0x210>
    return page - pages + nbase;
ffffffffc02035b2:	40fc87b3          	sub	a5,s9,a5
ffffffffc02035b6:	8799                	srai	a5,a5,0x6
ffffffffc02035b8:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc02035ba:	0177f633          	and	a2,a5,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc02035be:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02035c0:	06d67d63          	bgeu	a2,a3,ffffffffc020363a <copy_range+0x1f6>
ffffffffc02035c4:	00098517          	auipc	a0,0x98
ffffffffc02035c8:	06c53503          	ld	a0,108(a0) # ffffffffc029b630 <va_pa_offset>
                memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02035cc:	6605                	lui	a2,0x1
ffffffffc02035ce:	00ad05b3          	add	a1,s10,a0
ffffffffc02035d2:	953e                	add	a0,a0,a5
ffffffffc02035d4:	42e020ef          	jal	ffffffffc0205a02 <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc02035d8:	01fdf693          	andi	a3,s11,31
ffffffffc02035dc:	85e6                	mv	a1,s9
ffffffffc02035de:	8622                	mv	a2,s0
ffffffffc02035e0:	8552                	mv	a0,s4
ffffffffc02035e2:	922ff0ef          	jal	ffffffffc0202704 <page_insert>
            assert(ret == 0);
ffffffffc02035e6:	ee0500e3          	beqz	a0,ffffffffc02034c6 <copy_range+0x82>
ffffffffc02035ea:	bfa9                	j	ffffffffc0203544 <copy_range+0x100>
        intr_disable();
ffffffffc02035ec:	b18fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035f0:	00098797          	auipc	a5,0x98
ffffffffc02035f4:	0287b783          	ld	a5,40(a5) # ffffffffc029b618 <pmm_manager>
ffffffffc02035f8:	4505                	li	a0,1
ffffffffc02035fa:	6f9c                	ld	a5,24(a5)
ffffffffc02035fc:	9782                	jalr	a5
ffffffffc02035fe:	8caa                	mv	s9,a0
        intr_enable();
ffffffffc0203600:	afefd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203604:	b759                	j	ffffffffc020358a <copy_range+0x146>
                return -E_NO_MEM;
ffffffffc0203606:	5571                	li	a0,-4
ffffffffc0203608:	b5e1                	j	ffffffffc02034d0 <copy_range+0x8c>
        panic("pa2page called with invalid pa");
ffffffffc020360a:	00003617          	auipc	a2,0x3
ffffffffc020360e:	29660613          	addi	a2,a2,662 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0203612:	06900593          	li	a1,105
ffffffffc0203616:	00003517          	auipc	a0,0x3
ffffffffc020361a:	1e250513          	addi	a0,a0,482 # ffffffffc02067f8 <etext+0xdde>
ffffffffc020361e:	e29fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203622:	00003617          	auipc	a2,0x3
ffffffffc0203626:	49660613          	addi	a2,a2,1174 # ffffffffc0206ab8 <etext+0x109e>
ffffffffc020362a:	07f00593          	li	a1,127
ffffffffc020362e:	00003517          	auipc	a0,0x3
ffffffffc0203632:	1ca50513          	addi	a0,a0,458 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0203636:	e11fc0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc020363a:	86be                	mv	a3,a5
ffffffffc020363c:	00003617          	auipc	a2,0x3
ffffffffc0203640:	19460613          	addi	a2,a2,404 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0203644:	07100593          	li	a1,113
ffffffffc0203648:	00003517          	auipc	a0,0x3
ffffffffc020364c:	1b050513          	addi	a0,a0,432 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0203650:	df7fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0203654:	86ea                	mv	a3,s10
ffffffffc0203656:	00003617          	auipc	a2,0x3
ffffffffc020365a:	17a60613          	addi	a2,a2,378 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc020365e:	07100593          	li	a1,113
ffffffffc0203662:	00003517          	auipc	a0,0x3
ffffffffc0203666:	19650513          	addi	a0,a0,406 # ffffffffc02067f8 <etext+0xdde>
ffffffffc020366a:	dddfc0ef          	jal	ffffffffc0200446 <__panic>
                assert(npage != NULL);
ffffffffc020366e:	00004697          	auipc	a3,0x4
ffffffffc0203672:	88a68693          	addi	a3,a3,-1910 # ffffffffc0206ef8 <etext+0x14de>
ffffffffc0203676:	00003617          	auipc	a2,0x3
ffffffffc020367a:	daa60613          	addi	a2,a2,-598 # ffffffffc0206420 <etext+0xa06>
ffffffffc020367e:	19d00593          	li	a1,413
ffffffffc0203682:	00003517          	auipc	a0,0x3
ffffffffc0203686:	23e50513          	addi	a0,a0,574 # ffffffffc02068c0 <etext+0xea6>
ffffffffc020368a:	dbdfc0ef          	jal	ffffffffc0200446 <__panic>
                assert(page != NULL);
ffffffffc020368e:	00004697          	auipc	a3,0x4
ffffffffc0203692:	85a68693          	addi	a3,a3,-1958 # ffffffffc0206ee8 <etext+0x14ce>
ffffffffc0203696:	00003617          	auipc	a2,0x3
ffffffffc020369a:	d8a60613          	addi	a2,a2,-630 # ffffffffc0206420 <etext+0xa06>
ffffffffc020369e:	19c00593          	li	a1,412
ffffffffc02036a2:	00003517          	auipc	a0,0x3
ffffffffc02036a6:	21e50513          	addi	a0,a0,542 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02036aa:	d9dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02036ae:	00003697          	auipc	a3,0x3
ffffffffc02036b2:	25268693          	addi	a3,a3,594 # ffffffffc0206900 <etext+0xee6>
ffffffffc02036b6:	00003617          	auipc	a2,0x3
ffffffffc02036ba:	d6a60613          	addi	a2,a2,-662 # ffffffffc0206420 <etext+0xa06>
ffffffffc02036be:	17b00593          	li	a1,379
ffffffffc02036c2:	00003517          	auipc	a0,0x3
ffffffffc02036c6:	1fe50513          	addi	a0,a0,510 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02036ca:	d7dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02036ce:	00003697          	auipc	a3,0x3
ffffffffc02036d2:	20268693          	addi	a3,a3,514 # ffffffffc02068d0 <etext+0xeb6>
ffffffffc02036d6:	00003617          	auipc	a2,0x3
ffffffffc02036da:	d4a60613          	addi	a2,a2,-694 # ffffffffc0206420 <etext+0xa06>
ffffffffc02036de:	17a00593          	li	a1,378
ffffffffc02036e2:	00003517          	auipc	a0,0x3
ffffffffc02036e6:	1de50513          	addi	a0,a0,478 # ffffffffc02068c0 <etext+0xea6>
ffffffffc02036ea:	d5dfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02036ee <pgdir_alloc_page>:
{
ffffffffc02036ee:	7139                	addi	sp,sp,-64
ffffffffc02036f0:	f426                	sd	s1,40(sp)
ffffffffc02036f2:	f04a                	sd	s2,32(sp)
ffffffffc02036f4:	ec4e                	sd	s3,24(sp)
ffffffffc02036f6:	fc06                	sd	ra,56(sp)
ffffffffc02036f8:	f822                	sd	s0,48(sp)
ffffffffc02036fa:	892a                	mv	s2,a0
ffffffffc02036fc:	84ae                	mv	s1,a1
ffffffffc02036fe:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203700:	100027f3          	csrr	a5,sstatus
ffffffffc0203704:	8b89                	andi	a5,a5,2
ffffffffc0203706:	ebb5                	bnez	a5,ffffffffc020377a <pgdir_alloc_page+0x8c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203708:	00098417          	auipc	s0,0x98
ffffffffc020370c:	f1040413          	addi	s0,s0,-240 # ffffffffc029b618 <pmm_manager>
ffffffffc0203710:	601c                	ld	a5,0(s0)
ffffffffc0203712:	4505                	li	a0,1
ffffffffc0203714:	6f9c                	ld	a5,24(a5)
ffffffffc0203716:	9782                	jalr	a5
ffffffffc0203718:	85aa                	mv	a1,a0
    if (page != NULL)
ffffffffc020371a:	c5b9                	beqz	a1,ffffffffc0203768 <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020371c:	86ce                	mv	a3,s3
ffffffffc020371e:	854a                	mv	a0,s2
ffffffffc0203720:	8626                	mv	a2,s1
ffffffffc0203722:	e42e                	sd	a1,8(sp)
ffffffffc0203724:	fe1fe0ef          	jal	ffffffffc0202704 <page_insert>
ffffffffc0203728:	65a2                	ld	a1,8(sp)
ffffffffc020372a:	e515                	bnez	a0,ffffffffc0203756 <pgdir_alloc_page+0x68>
        assert(page_ref(page) == 1);
ffffffffc020372c:	4198                	lw	a4,0(a1)
        page->pra_vaddr = la;
ffffffffc020372e:	fd84                	sd	s1,56(a1)
        assert(page_ref(page) == 1);
ffffffffc0203730:	4785                	li	a5,1
ffffffffc0203732:	02f70c63          	beq	a4,a5,ffffffffc020376a <pgdir_alloc_page+0x7c>
ffffffffc0203736:	00003697          	auipc	a3,0x3
ffffffffc020373a:	7d268693          	addi	a3,a3,2002 # ffffffffc0206f08 <etext+0x14ee>
ffffffffc020373e:	00003617          	auipc	a2,0x3
ffffffffc0203742:	ce260613          	addi	a2,a2,-798 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203746:	1ec00593          	li	a1,492
ffffffffc020374a:	00003517          	auipc	a0,0x3
ffffffffc020374e:	17650513          	addi	a0,a0,374 # ffffffffc02068c0 <etext+0xea6>
ffffffffc0203752:	cf5fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0203756:	100027f3          	csrr	a5,sstatus
ffffffffc020375a:	8b89                	andi	a5,a5,2
ffffffffc020375c:	ef95                	bnez	a5,ffffffffc0203798 <pgdir_alloc_page+0xaa>
        pmm_manager->free_pages(base, n);
ffffffffc020375e:	601c                	ld	a5,0(s0)
ffffffffc0203760:	852e                	mv	a0,a1
ffffffffc0203762:	4585                	li	a1,1
ffffffffc0203764:	739c                	ld	a5,32(a5)
ffffffffc0203766:	9782                	jalr	a5
            return NULL;
ffffffffc0203768:	4581                	li	a1,0
}
ffffffffc020376a:	70e2                	ld	ra,56(sp)
ffffffffc020376c:	7442                	ld	s0,48(sp)
ffffffffc020376e:	74a2                	ld	s1,40(sp)
ffffffffc0203770:	7902                	ld	s2,32(sp)
ffffffffc0203772:	69e2                	ld	s3,24(sp)
ffffffffc0203774:	852e                	mv	a0,a1
ffffffffc0203776:	6121                	addi	sp,sp,64
ffffffffc0203778:	8082                	ret
        intr_disable();
ffffffffc020377a:	98afd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020377e:	00098417          	auipc	s0,0x98
ffffffffc0203782:	e9a40413          	addi	s0,s0,-358 # ffffffffc029b618 <pmm_manager>
ffffffffc0203786:	601c                	ld	a5,0(s0)
ffffffffc0203788:	4505                	li	a0,1
ffffffffc020378a:	6f9c                	ld	a5,24(a5)
ffffffffc020378c:	9782                	jalr	a5
ffffffffc020378e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0203790:	96efd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203794:	65a2                	ld	a1,8(sp)
ffffffffc0203796:	b751                	j	ffffffffc020371a <pgdir_alloc_page+0x2c>
        intr_disable();
ffffffffc0203798:	96cfd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020379c:	601c                	ld	a5,0(s0)
ffffffffc020379e:	6522                	ld	a0,8(sp)
ffffffffc02037a0:	4585                	li	a1,1
ffffffffc02037a2:	739c                	ld	a5,32(a5)
ffffffffc02037a4:	9782                	jalr	a5
        intr_enable();
ffffffffc02037a6:	958fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02037aa:	bf7d                	j	ffffffffc0203768 <pgdir_alloc_page+0x7a>

ffffffffc02037ac <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02037ac:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02037ae:	00003697          	auipc	a3,0x3
ffffffffc02037b2:	77268693          	addi	a3,a3,1906 # ffffffffc0206f20 <etext+0x1506>
ffffffffc02037b6:	00003617          	auipc	a2,0x3
ffffffffc02037ba:	c6a60613          	addi	a2,a2,-918 # ffffffffc0206420 <etext+0xa06>
ffffffffc02037be:	07700593          	li	a1,119
ffffffffc02037c2:	00003517          	auipc	a0,0x3
ffffffffc02037c6:	77e50513          	addi	a0,a0,1918 # ffffffffc0206f40 <etext+0x1526>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02037ca:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02037cc:	c7bfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02037d0 <mm_create>:
{
ffffffffc02037d0:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02037d2:	04000513          	li	a0,64
{
ffffffffc02037d6:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02037d8:	d8cfe0ef          	jal	ffffffffc0201d64 <kmalloc>
    if (mm != NULL)
ffffffffc02037dc:	cd19                	beqz	a0,ffffffffc02037fa <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02037de:	e508                	sd	a0,8(a0)
ffffffffc02037e0:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02037e2:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02037e6:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02037ea:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02037ee:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02037f2:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02037f6:	02053c23          	sd	zero,56(a0)
}
ffffffffc02037fa:	60a2                	ld	ra,8(sp)
ffffffffc02037fc:	0141                	addi	sp,sp,16
ffffffffc02037fe:	8082                	ret

ffffffffc0203800 <find_vma>:
    if (mm != NULL)
ffffffffc0203800:	c505                	beqz	a0,ffffffffc0203828 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc0203802:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203804:	c781                	beqz	a5,ffffffffc020380c <find_vma+0xc>
ffffffffc0203806:	6798                	ld	a4,8(a5)
ffffffffc0203808:	02e5f363          	bgeu	a1,a4,ffffffffc020382e <find_vma+0x2e>
    return listelm->next;
ffffffffc020380c:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc020380e:	00f50d63          	beq	a0,a5,ffffffffc0203828 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203812:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203816:	00e5e663          	bltu	a1,a4,ffffffffc0203822 <find_vma+0x22>
ffffffffc020381a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020381e:	00e5ee63          	bltu	a1,a4,ffffffffc020383a <find_vma+0x3a>
ffffffffc0203822:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203824:	fef517e3          	bne	a0,a5,ffffffffc0203812 <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc0203828:	4781                	li	a5,0
}
ffffffffc020382a:	853e                	mv	a0,a5
ffffffffc020382c:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020382e:	6b98                	ld	a4,16(a5)
ffffffffc0203830:	fce5fee3          	bgeu	a1,a4,ffffffffc020380c <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0203834:	e91c                	sd	a5,16(a0)
}
ffffffffc0203836:	853e                	mv	a0,a5
ffffffffc0203838:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020383a:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc020383c:	e91c                	sd	a5,16(a0)
ffffffffc020383e:	bfe5                	j	ffffffffc0203836 <find_vma+0x36>

ffffffffc0203840 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203840:	6590                	ld	a2,8(a1)
ffffffffc0203842:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203846:	1141                	addi	sp,sp,-16
ffffffffc0203848:	e406                	sd	ra,8(sp)
ffffffffc020384a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020384c:	01066763          	bltu	a2,a6,ffffffffc020385a <insert_vma_struct+0x1a>
ffffffffc0203850:	a8b9                	j	ffffffffc02038ae <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203852:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203856:	04e66763          	bltu	a2,a4,ffffffffc02038a4 <insert_vma_struct+0x64>
ffffffffc020385a:	86be                	mv	a3,a5
ffffffffc020385c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020385e:	fef51ae3          	bne	a0,a5,ffffffffc0203852 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203862:	02a68463          	beq	a3,a0,ffffffffc020388a <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203866:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020386a:	fe86b883          	ld	a7,-24(a3)
ffffffffc020386e:	08e8f063          	bgeu	a7,a4,ffffffffc02038ee <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203872:	04e66e63          	bltu	a2,a4,ffffffffc02038ce <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0203876:	00f50a63          	beq	a0,a5,ffffffffc020388a <insert_vma_struct+0x4a>
ffffffffc020387a:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020387e:	05076863          	bltu	a4,a6,ffffffffc02038ce <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0203882:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203886:	02c77263          	bgeu	a4,a2,ffffffffc02038aa <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020388a:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020388c:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020388e:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203892:	e390                	sd	a2,0(a5)
ffffffffc0203894:	e690                	sd	a2,8(a3)
}
ffffffffc0203896:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203898:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020389a:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020389c:	2705                	addiw	a4,a4,1
ffffffffc020389e:	d118                	sw	a4,32(a0)
}
ffffffffc02038a0:	0141                	addi	sp,sp,16
ffffffffc02038a2:	8082                	ret
    if (le_prev != list)
ffffffffc02038a4:	fca691e3          	bne	a3,a0,ffffffffc0203866 <insert_vma_struct+0x26>
ffffffffc02038a8:	bfd9                	j	ffffffffc020387e <insert_vma_struct+0x3e>
ffffffffc02038aa:	f03ff0ef          	jal	ffffffffc02037ac <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02038ae:	00003697          	auipc	a3,0x3
ffffffffc02038b2:	6a268693          	addi	a3,a3,1698 # ffffffffc0206f50 <etext+0x1536>
ffffffffc02038b6:	00003617          	auipc	a2,0x3
ffffffffc02038ba:	b6a60613          	addi	a2,a2,-1174 # ffffffffc0206420 <etext+0xa06>
ffffffffc02038be:	07d00593          	li	a1,125
ffffffffc02038c2:	00003517          	auipc	a0,0x3
ffffffffc02038c6:	67e50513          	addi	a0,a0,1662 # ffffffffc0206f40 <etext+0x1526>
ffffffffc02038ca:	b7dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02038ce:	00003697          	auipc	a3,0x3
ffffffffc02038d2:	6c268693          	addi	a3,a3,1730 # ffffffffc0206f90 <etext+0x1576>
ffffffffc02038d6:	00003617          	auipc	a2,0x3
ffffffffc02038da:	b4a60613          	addi	a2,a2,-1206 # ffffffffc0206420 <etext+0xa06>
ffffffffc02038de:	07600593          	li	a1,118
ffffffffc02038e2:	00003517          	auipc	a0,0x3
ffffffffc02038e6:	65e50513          	addi	a0,a0,1630 # ffffffffc0206f40 <etext+0x1526>
ffffffffc02038ea:	b5dfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02038ee:	00003697          	auipc	a3,0x3
ffffffffc02038f2:	68268693          	addi	a3,a3,1666 # ffffffffc0206f70 <etext+0x1556>
ffffffffc02038f6:	00003617          	auipc	a2,0x3
ffffffffc02038fa:	b2a60613          	addi	a2,a2,-1238 # ffffffffc0206420 <etext+0xa06>
ffffffffc02038fe:	07500593          	li	a1,117
ffffffffc0203902:	00003517          	auipc	a0,0x3
ffffffffc0203906:	63e50513          	addi	a0,a0,1598 # ffffffffc0206f40 <etext+0x1526>
ffffffffc020390a:	b3dfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020390e <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc020390e:	591c                	lw	a5,48(a0)
{
ffffffffc0203910:	1141                	addi	sp,sp,-16
ffffffffc0203912:	e406                	sd	ra,8(sp)
ffffffffc0203914:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203916:	e78d                	bnez	a5,ffffffffc0203940 <mm_destroy+0x32>
ffffffffc0203918:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020391a:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020391c:	00a40c63          	beq	s0,a0,ffffffffc0203934 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203920:	6118                	ld	a4,0(a0)
ffffffffc0203922:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203924:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203926:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203928:	e398                	sd	a4,0(a5)
ffffffffc020392a:	ce0fe0ef          	jal	ffffffffc0201e0a <kfree>
    return listelm->next;
ffffffffc020392e:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203930:	fea418e3          	bne	s0,a0,ffffffffc0203920 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203934:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203936:	6402                	ld	s0,0(sp)
ffffffffc0203938:	60a2                	ld	ra,8(sp)
ffffffffc020393a:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020393c:	ccefe06f          	j	ffffffffc0201e0a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203940:	00003697          	auipc	a3,0x3
ffffffffc0203944:	67068693          	addi	a3,a3,1648 # ffffffffc0206fb0 <etext+0x1596>
ffffffffc0203948:	00003617          	auipc	a2,0x3
ffffffffc020394c:	ad860613          	addi	a2,a2,-1320 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203950:	0a100593          	li	a1,161
ffffffffc0203954:	00003517          	auipc	a0,0x3
ffffffffc0203958:	5ec50513          	addi	a0,a0,1516 # ffffffffc0206f40 <etext+0x1526>
ffffffffc020395c:	aebfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203960 <do_pgfault>:
{
    int ret = -E_INVAL;
    struct vma_struct *vma;
    uintptr_t la = ROUNDDOWN(addr, PGSIZE);

    pgfault_num++;
ffffffffc0203960:	00098797          	auipc	a5,0x98
ffffffffc0203964:	ce87a783          	lw	a5,-792(a5) # ffffffffc029b648 <pgfault_num>
ffffffffc0203968:	2785                	addiw	a5,a5,1
ffffffffc020396a:	00098717          	auipc	a4,0x98
ffffffffc020396e:	ccf72f23          	sw	a5,-802(a4) # ffffffffc029b648 <pgfault_num>
    if (mm == NULL)
ffffffffc0203972:	12050e63          	beqz	a0,ffffffffc0203aae <do_pgfault+0x14e>
{
ffffffffc0203976:	7139                	addi	sp,sp,-64
    uintptr_t la = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203978:	77fd                	lui	a5,0xfffff
{
ffffffffc020397a:	f822                	sd	s0,48(sp)
    uintptr_t la = ROUNDDOWN(addr, PGSIZE);
ffffffffc020397c:	00f67433          	and	s0,a2,a5
{
ffffffffc0203980:	f426                	sd	s1,40(sp)
ffffffffc0203982:	84ae                	mv	s1,a1
    {
        return ret;
    }

    vma = find_vma(mm, la);
ffffffffc0203984:	85a2                	mv	a1,s0
{
ffffffffc0203986:	f04a                	sd	s2,32(sp)
ffffffffc0203988:	fc06                	sd	ra,56(sp)
ffffffffc020398a:	892a                	mv	s2,a0
    vma = find_vma(mm, la);
ffffffffc020398c:	e75ff0ef          	jal	ffffffffc0203800 <find_vma>
    if (vma == NULL || vma->vm_start > la)
ffffffffc0203990:	c56d                	beqz	a0,ffffffffc0203a7a <do_pgfault+0x11a>
ffffffffc0203992:	651c                	ld	a5,8(a0)
ffffffffc0203994:	0ef46363          	bltu	s0,a5,ffffffffc0203a7a <do_pgfault+0x11a>
    {
        return ret;
    }

    if ((error_code & PTE_W) && !(vma->vm_flags & VM_WRITE))
ffffffffc0203998:	4d1c                	lw	a5,24(a0)
ffffffffc020399a:	ec4e                	sd	s3,24(sp)
ffffffffc020399c:	8891                	andi	s1,s1,4
ffffffffc020399e:	0027f713          	andi	a4,a5,2
ffffffffc02039a2:	e8f1                	bnez	s1,ffffffffc0203a76 <do_pgfault+0x116>
    {
        return ret;
    }

    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_READ)
ffffffffc02039a4:	0017f693          	andi	a3,a5,1
    {
        perm |= PTE_R;
ffffffffc02039a8:	49c9                	li	s3,18
    if (vma->vm_flags & VM_READ)
ffffffffc02039aa:	e291                	bnez	a3,ffffffffc02039ae <do_pgfault+0x4e>
    uint32_t perm = PTE_U;
ffffffffc02039ac:	49c1                	li	s3,16
    }
    if (vma->vm_flags & VM_WRITE)
ffffffffc02039ae:	c311                	beqz	a4,ffffffffc02039b2 <do_pgfault+0x52>
    {
        perm |= (PTE_W | PTE_R);
ffffffffc02039b0:	49d9                	li	s3,22
    }
    if (vma->vm_flags & VM_EXEC)
ffffffffc02039b2:	8b91                	andi	a5,a5,4
ffffffffc02039b4:	c399                	beqz	a5,ffffffffc02039ba <do_pgfault+0x5a>
    {
        perm |= PTE_X;
ffffffffc02039b6:	0089e993          	ori	s3,s3,8
    }

    pte_t *ptep = get_pte(mm->pgdir, la, 1);
ffffffffc02039ba:	01893503          	ld	a0,24(s2)
ffffffffc02039be:	4605                	li	a2,1
ffffffffc02039c0:	85a2                	mv	a1,s0
ffffffffc02039c2:	e0cfe0ef          	jal	ffffffffc0201fce <get_pte>
    if (ptep == NULL)
ffffffffc02039c6:	c16d                	beqz	a0,ffffffffc0203aa8 <do_pgfault+0x148>
    {
        return -E_NO_MEM;
    }

    if (!(*ptep & PTE_V))
ffffffffc02039c8:	611c                	ld	a5,0(a0)
ffffffffc02039ca:	0017f713          	andi	a4,a5,1
ffffffffc02039ce:	cb45                	beqz	a4,ffffffffc0203a7e <do_pgfault+0x11e>
        if (pgdir_alloc_page(mm->pgdir, la, perm) == NULL)
        {
            return -E_NO_MEM;
        }
    }
    else if ((error_code & PTE_W) && !(*ptep & PTE_W))
ffffffffc02039d0:	ccd5                	beqz	s1,ffffffffc0203a8c <do_pgfault+0x12c>
ffffffffc02039d2:	0047f713          	andi	a4,a5,4
ffffffffc02039d6:	eb5d                	bnez	a4,ffffffffc0203a8c <do_pgfault+0x12c>
    if (PPN(pa) >= npage)
ffffffffc02039d8:	00098717          	auipc	a4,0x98
ffffffffc02039dc:	c6073703          	ld	a4,-928(a4) # ffffffffc029b638 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02039e0:	078a                	slli	a5,a5,0x2
ffffffffc02039e2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02039e4:	0ce7f763          	bgeu	a5,a4,ffffffffc0203ab2 <do_pgfault+0x152>
    return &pages[PPN(pa) - nbase];
ffffffffc02039e8:	00004717          	auipc	a4,0x4
ffffffffc02039ec:	1a873703          	ld	a4,424(a4) # ffffffffc0207b90 <nbase>
ffffffffc02039f0:	00098497          	auipc	s1,0x98
ffffffffc02039f4:	c504b483          	ld	s1,-944(s1) # ffffffffc029b640 <pages>
    {
        struct Page *page = pte2page(*ptep);
        if (page_ref(page) > 1)
ffffffffc02039f8:	4505                	li	a0,1
ffffffffc02039fa:	8f99                	sub	a5,a5,a4
ffffffffc02039fc:	079a                	slli	a5,a5,0x6
ffffffffc02039fe:	94be                	add	s1,s1,a5
ffffffffc0203a00:	409c                	lw	a5,0(s1)
ffffffffc0203a02:	08f55d63          	bge	a0,a5,ffffffffc0203a9c <do_pgfault+0x13c>
        {
            struct Page *newpage = alloc_page();
ffffffffc0203a06:	e43a                	sd	a4,8(sp)
ffffffffc0203a08:	d1efe0ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0203a0c:	882a                	mv	a6,a0
            if (newpage == NULL)
ffffffffc0203a0e:	cd49                	beqz	a0,ffffffffc0203aa8 <do_pgfault+0x148>
    return page - pages + nbase;
ffffffffc0203a10:	00098597          	auipc	a1,0x98
ffffffffc0203a14:	c305b583          	ld	a1,-976(a1) # ffffffffc029b640 <pages>
ffffffffc0203a18:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc0203a1a:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0203a1c:	40b506b3          	sub	a3,a0,a1
ffffffffc0203a20:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203a22:	00098617          	auipc	a2,0x98
ffffffffc0203a26:	c1663603          	ld	a2,-1002(a2) # ffffffffc029b638 <npage>
    return page - pages + nbase;
ffffffffc0203a2a:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0203a2c:	83b1                	srli	a5,a5,0xc
ffffffffc0203a2e:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0203a32:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203a34:	0ac57863          	bgeu	a0,a2,ffffffffc0203ae4 <do_pgfault+0x184>
    return page - pages + nbase;
ffffffffc0203a38:	40b485b3          	sub	a1,s1,a1
ffffffffc0203a3c:	8599                	srai	a1,a1,0x6
ffffffffc0203a3e:	95ba                	add	a1,a1,a4
    return KADDR(page2pa(page));
ffffffffc0203a40:	8fed                	and	a5,a5,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0203a42:	05b2                	slli	a1,a1,0xc
    return KADDR(page2pa(page));
ffffffffc0203a44:	08c7f363          	bgeu	a5,a2,ffffffffc0203aca <do_pgfault+0x16a>
ffffffffc0203a48:	00098517          	auipc	a0,0x98
ffffffffc0203a4c:	be853503          	ld	a0,-1048(a0) # ffffffffc029b630 <va_pa_offset>
            {
                return -E_NO_MEM;
            }
            memcpy(page2kva(newpage), page2kva(page), PGSIZE);
ffffffffc0203a50:	6605                	lui	a2,0x1
ffffffffc0203a52:	e442                	sd	a6,8(sp)
ffffffffc0203a54:	95aa                	add	a1,a1,a0
ffffffffc0203a56:	9536                	add	a0,a0,a3
ffffffffc0203a58:	7ab010ef          	jal	ffffffffc0205a02 <memcpy>
            ret = page_insert(mm->pgdir, newpage, la, perm);
ffffffffc0203a5c:	65a2                	ld	a1,8(sp)
ffffffffc0203a5e:	01893503          	ld	a0,24(s2)
ffffffffc0203a62:	86ce                	mv	a3,s3
ffffffffc0203a64:	8622                	mv	a2,s0
        // Already mapped with sufficient permission; nothing to fix.
        return 0;
    }

    return 0;
}
ffffffffc0203a66:	7442                	ld	s0,48(sp)
            ret = page_insert(mm->pgdir, page, la, perm);
ffffffffc0203a68:	69e2                	ld	s3,24(sp)
}
ffffffffc0203a6a:	70e2                	ld	ra,56(sp)
ffffffffc0203a6c:	74a2                	ld	s1,40(sp)
ffffffffc0203a6e:	7902                	ld	s2,32(sp)
ffffffffc0203a70:	6121                	addi	sp,sp,64
            ret = page_insert(mm->pgdir, page, la, perm);
ffffffffc0203a72:	c93fe06f          	j	ffffffffc0202704 <page_insert>
    if ((error_code & PTE_W) && !(vma->vm_flags & VM_WRITE))
ffffffffc0203a76:	ff0d                	bnez	a4,ffffffffc02039b0 <do_pgfault+0x50>
ffffffffc0203a78:	69e2                	ld	s3,24(sp)
        return ret;
ffffffffc0203a7a:	5575                	li	a0,-3
ffffffffc0203a7c:	a811                	j	ffffffffc0203a90 <do_pgfault+0x130>
        if (pgdir_alloc_page(mm->pgdir, la, perm) == NULL)
ffffffffc0203a7e:	01893503          	ld	a0,24(s2)
ffffffffc0203a82:	864e                	mv	a2,s3
ffffffffc0203a84:	85a2                	mv	a1,s0
ffffffffc0203a86:	c69ff0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0203a8a:	cd19                	beqz	a0,ffffffffc0203aa8 <do_pgfault+0x148>
ffffffffc0203a8c:	69e2                	ld	s3,24(sp)
        return 0;
ffffffffc0203a8e:	4501                	li	a0,0
}
ffffffffc0203a90:	70e2                	ld	ra,56(sp)
ffffffffc0203a92:	7442                	ld	s0,48(sp)
ffffffffc0203a94:	74a2                	ld	s1,40(sp)
ffffffffc0203a96:	7902                	ld	s2,32(sp)
ffffffffc0203a98:	6121                	addi	sp,sp,64
ffffffffc0203a9a:	8082                	ret
            ret = page_insert(mm->pgdir, page, la, perm);
ffffffffc0203a9c:	01893503          	ld	a0,24(s2)
ffffffffc0203aa0:	86ce                	mv	a3,s3
ffffffffc0203aa2:	8622                	mv	a2,s0
ffffffffc0203aa4:	85a6                	mv	a1,s1
ffffffffc0203aa6:	b7c1                	j	ffffffffc0203a66 <do_pgfault+0x106>
ffffffffc0203aa8:	69e2                	ld	s3,24(sp)
        return -E_NO_MEM;
ffffffffc0203aaa:	5571                	li	a0,-4
ffffffffc0203aac:	b7d5                	j	ffffffffc0203a90 <do_pgfault+0x130>
        return ret;
ffffffffc0203aae:	5575                	li	a0,-3
}
ffffffffc0203ab0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0203ab2:	00003617          	auipc	a2,0x3
ffffffffc0203ab6:	dee60613          	addi	a2,a2,-530 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0203aba:	06900593          	li	a1,105
ffffffffc0203abe:	00003517          	auipc	a0,0x3
ffffffffc0203ac2:	d3a50513          	addi	a0,a0,-710 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0203ac6:	981fc0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203aca:	86ae                	mv	a3,a1
ffffffffc0203acc:	00003617          	auipc	a2,0x3
ffffffffc0203ad0:	d0460613          	addi	a2,a2,-764 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0203ad4:	07100593          	li	a1,113
ffffffffc0203ad8:	00003517          	auipc	a0,0x3
ffffffffc0203adc:	d2050513          	addi	a0,a0,-736 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0203ae0:	967fc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0203ae4:	00003617          	auipc	a2,0x3
ffffffffc0203ae8:	cec60613          	addi	a2,a2,-788 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0203aec:	07100593          	li	a1,113
ffffffffc0203af0:	00003517          	auipc	a0,0x3
ffffffffc0203af4:	d0850513          	addi	a0,a0,-760 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0203af8:	94ffc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203afc <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203afc:	6785                	lui	a5,0x1
ffffffffc0203afe:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7bb1>
ffffffffc0203b00:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc0203b02:	4785                	li	a5,1
{
ffffffffc0203b04:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203b06:	962e                	add	a2,a2,a1
ffffffffc0203b08:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc0203b0a:	07fe                	slli	a5,a5,0x1f
{
ffffffffc0203b0c:	f822                	sd	s0,48(sp)
ffffffffc0203b0e:	f426                	sd	s1,40(sp)
ffffffffc0203b10:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203b14:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc0203b18:	0785                	addi	a5,a5,1
ffffffffc0203b1a:	0084b633          	sltu	a2,s1,s0
ffffffffc0203b1e:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203b22:	00163613          	seqz	a2,a2
ffffffffc0203b26:	0017b793          	seqz	a5,a5
{
ffffffffc0203b2a:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203b2c:	8fd1                	or	a5,a5,a2
ffffffffc0203b2e:	ebbd                	bnez	a5,ffffffffc0203ba4 <mm_map+0xa8>
ffffffffc0203b30:	002007b7          	lui	a5,0x200
ffffffffc0203b34:	06f4e863          	bltu	s1,a5,ffffffffc0203ba4 <mm_map+0xa8>
ffffffffc0203b38:	f04a                	sd	s2,32(sp)
ffffffffc0203b3a:	ec4e                	sd	s3,24(sp)
ffffffffc0203b3c:	e852                	sd	s4,16(sp)
ffffffffc0203b3e:	892a                	mv	s2,a0
ffffffffc0203b40:	89ba                	mv	s3,a4
ffffffffc0203b42:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203b44:	c135                	beqz	a0,ffffffffc0203ba8 <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203b46:	85a6                	mv	a1,s1
ffffffffc0203b48:	cb9ff0ef          	jal	ffffffffc0203800 <find_vma>
ffffffffc0203b4c:	c501                	beqz	a0,ffffffffc0203b54 <mm_map+0x58>
ffffffffc0203b4e:	651c                	ld	a5,8(a0)
ffffffffc0203b50:	0487e763          	bltu	a5,s0,ffffffffc0203b9e <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b54:	03000513          	li	a0,48
ffffffffc0203b58:	a0cfe0ef          	jal	ffffffffc0201d64 <kmalloc>
ffffffffc0203b5c:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203b5e:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203b60:	c59d                	beqz	a1,ffffffffc0203b8e <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc0203b62:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc0203b64:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203b66:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203b6a:	854a                	mv	a0,s2
ffffffffc0203b6c:	e42e                	sd	a1,8(sp)
ffffffffc0203b6e:	cd3ff0ef          	jal	ffffffffc0203840 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc0203b72:	65a2                	ld	a1,8(sp)
ffffffffc0203b74:	00098463          	beqz	s3,ffffffffc0203b7c <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc0203b78:	00b9b023          	sd	a1,0(s3) # 1000 <_binary_obj___user_softint_out_size-0x7bb0>
ffffffffc0203b7c:	7902                	ld	s2,32(sp)
ffffffffc0203b7e:	69e2                	ld	s3,24(sp)
ffffffffc0203b80:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc0203b82:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203b84:	70e2                	ld	ra,56(sp)
ffffffffc0203b86:	7442                	ld	s0,48(sp)
ffffffffc0203b88:	74a2                	ld	s1,40(sp)
ffffffffc0203b8a:	6121                	addi	sp,sp,64
ffffffffc0203b8c:	8082                	ret
ffffffffc0203b8e:	70e2                	ld	ra,56(sp)
ffffffffc0203b90:	7442                	ld	s0,48(sp)
ffffffffc0203b92:	7902                	ld	s2,32(sp)
ffffffffc0203b94:	69e2                	ld	s3,24(sp)
ffffffffc0203b96:	6a42                	ld	s4,16(sp)
ffffffffc0203b98:	74a2                	ld	s1,40(sp)
ffffffffc0203b9a:	6121                	addi	sp,sp,64
ffffffffc0203b9c:	8082                	ret
ffffffffc0203b9e:	7902                	ld	s2,32(sp)
ffffffffc0203ba0:	69e2                	ld	s3,24(sp)
ffffffffc0203ba2:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc0203ba4:	5575                	li	a0,-3
ffffffffc0203ba6:	bff9                	j	ffffffffc0203b84 <mm_map+0x88>
    assert(mm != NULL);
ffffffffc0203ba8:	00003697          	auipc	a3,0x3
ffffffffc0203bac:	42068693          	addi	a3,a3,1056 # ffffffffc0206fc8 <etext+0x15ae>
ffffffffc0203bb0:	00003617          	auipc	a2,0x3
ffffffffc0203bb4:	87060613          	addi	a2,a2,-1936 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203bb8:	10700593          	li	a1,263
ffffffffc0203bbc:	00003517          	auipc	a0,0x3
ffffffffc0203bc0:	38450513          	addi	a0,a0,900 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203bc4:	883fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203bc8 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203bc8:	7139                	addi	sp,sp,-64
ffffffffc0203bca:	fc06                	sd	ra,56(sp)
ffffffffc0203bcc:	f822                	sd	s0,48(sp)
ffffffffc0203bce:	f426                	sd	s1,40(sp)
ffffffffc0203bd0:	f04a                	sd	s2,32(sp)
ffffffffc0203bd2:	ec4e                	sd	s3,24(sp)
ffffffffc0203bd4:	e852                	sd	s4,16(sp)
ffffffffc0203bd6:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203bd8:	c525                	beqz	a0,ffffffffc0203c40 <dup_mmap+0x78>
ffffffffc0203bda:	892a                	mv	s2,a0
ffffffffc0203bdc:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203bde:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203be0:	c1a5                	beqz	a1,ffffffffc0203c40 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0203be2:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203be4:	04848c63          	beq	s1,s0,ffffffffc0203c3c <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203be8:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203bec:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203bf0:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203bf4:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203bf8:	96cfe0ef          	jal	ffffffffc0201d64 <kmalloc>
    if (vma != NULL)
ffffffffc0203bfc:	c515                	beqz	a0,ffffffffc0203c28 <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203bfe:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0203c00:	01553423          	sd	s5,8(a0)
ffffffffc0203c04:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203c08:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203c0c:	854a                	mv	a0,s2
ffffffffc0203c0e:	c33ff0ef          	jal	ffffffffc0203840 <insert_vma_struct>

        bool share = 1;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203c12:	ff043683          	ld	a3,-16(s0)
ffffffffc0203c16:	fe843603          	ld	a2,-24(s0)
ffffffffc0203c1a:	6c8c                	ld	a1,24(s1)
ffffffffc0203c1c:	01893503          	ld	a0,24(s2)
ffffffffc0203c20:	4705                	li	a4,1
ffffffffc0203c22:	823ff0ef          	jal	ffffffffc0203444 <copy_range>
ffffffffc0203c26:	dd55                	beqz	a0,ffffffffc0203be2 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203c28:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203c2a:	70e2                	ld	ra,56(sp)
ffffffffc0203c2c:	7442                	ld	s0,48(sp)
ffffffffc0203c2e:	74a2                	ld	s1,40(sp)
ffffffffc0203c30:	7902                	ld	s2,32(sp)
ffffffffc0203c32:	69e2                	ld	s3,24(sp)
ffffffffc0203c34:	6a42                	ld	s4,16(sp)
ffffffffc0203c36:	6aa2                	ld	s5,8(sp)
ffffffffc0203c38:	6121                	addi	sp,sp,64
ffffffffc0203c3a:	8082                	ret
    return 0;
ffffffffc0203c3c:	4501                	li	a0,0
ffffffffc0203c3e:	b7f5                	j	ffffffffc0203c2a <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203c40:	00003697          	auipc	a3,0x3
ffffffffc0203c44:	39868693          	addi	a3,a3,920 # ffffffffc0206fd8 <etext+0x15be>
ffffffffc0203c48:	00002617          	auipc	a2,0x2
ffffffffc0203c4c:	7d860613          	addi	a2,a2,2008 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203c50:	12300593          	li	a1,291
ffffffffc0203c54:	00003517          	auipc	a0,0x3
ffffffffc0203c58:	2ec50513          	addi	a0,a0,748 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203c5c:	feafc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203c60 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203c60:	1101                	addi	sp,sp,-32
ffffffffc0203c62:	ec06                	sd	ra,24(sp)
ffffffffc0203c64:	e822                	sd	s0,16(sp)
ffffffffc0203c66:	e426                	sd	s1,8(sp)
ffffffffc0203c68:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203c6a:	c531                	beqz	a0,ffffffffc0203cb6 <exit_mmap+0x56>
ffffffffc0203c6c:	591c                	lw	a5,48(a0)
ffffffffc0203c6e:	84aa                	mv	s1,a0
ffffffffc0203c70:	e3b9                	bnez	a5,ffffffffc0203cb6 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203c72:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203c74:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203c78:	02850663          	beq	a0,s0,ffffffffc0203ca4 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203c7c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203c80:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c84:	854a                	mv	a0,s2
ffffffffc0203c86:	dfafe0ef          	jal	ffffffffc0202280 <unmap_range>
ffffffffc0203c8a:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203c8c:	fe8498e3          	bne	s1,s0,ffffffffc0203c7c <exit_mmap+0x1c>
ffffffffc0203c90:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203c92:	00848c63          	beq	s1,s0,ffffffffc0203caa <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203c96:	ff043603          	ld	a2,-16(s0)
ffffffffc0203c9a:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c9e:	854a                	mv	a0,s2
ffffffffc0203ca0:	f14fe0ef          	jal	ffffffffc02023b4 <exit_range>
ffffffffc0203ca4:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203ca6:	fe8498e3          	bne	s1,s0,ffffffffc0203c96 <exit_mmap+0x36>
    }
}
ffffffffc0203caa:	60e2                	ld	ra,24(sp)
ffffffffc0203cac:	6442                	ld	s0,16(sp)
ffffffffc0203cae:	64a2                	ld	s1,8(sp)
ffffffffc0203cb0:	6902                	ld	s2,0(sp)
ffffffffc0203cb2:	6105                	addi	sp,sp,32
ffffffffc0203cb4:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203cb6:	00003697          	auipc	a3,0x3
ffffffffc0203cba:	34268693          	addi	a3,a3,834 # ffffffffc0206ff8 <etext+0x15de>
ffffffffc0203cbe:	00002617          	auipc	a2,0x2
ffffffffc0203cc2:	76260613          	addi	a2,a2,1890 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203cc6:	13c00593          	li	a1,316
ffffffffc0203cca:	00003517          	auipc	a0,0x3
ffffffffc0203cce:	27650513          	addi	a0,a0,630 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203cd2:	f74fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203cd6 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203cd6:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203cd8:	04000513          	li	a0,64
{
ffffffffc0203cdc:	f406                	sd	ra,40(sp)
ffffffffc0203cde:	f022                	sd	s0,32(sp)
ffffffffc0203ce0:	ec26                	sd	s1,24(sp)
ffffffffc0203ce2:	e84a                	sd	s2,16(sp)
ffffffffc0203ce4:	e44e                	sd	s3,8(sp)
ffffffffc0203ce6:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203ce8:	87cfe0ef          	jal	ffffffffc0201d64 <kmalloc>
    if (mm != NULL)
ffffffffc0203cec:	16050c63          	beqz	a0,ffffffffc0203e64 <vmm_init+0x18e>
ffffffffc0203cf0:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203cf2:	e508                	sd	a0,8(a0)
ffffffffc0203cf4:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203cf6:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203cfa:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203cfe:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203d02:	02053423          	sd	zero,40(a0)
ffffffffc0203d06:	02052823          	sw	zero,48(a0)
ffffffffc0203d0a:	02053c23          	sd	zero,56(a0)
ffffffffc0203d0e:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203d12:	03000513          	li	a0,48
ffffffffc0203d16:	84efe0ef          	jal	ffffffffc0201d64 <kmalloc>
    if (vma != NULL)
ffffffffc0203d1a:	12050563          	beqz	a0,ffffffffc0203e44 <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc0203d1e:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203d22:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203d24:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203d28:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203d2a:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203d2c:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0203d2e:	8522                	mv	a0,s0
ffffffffc0203d30:	b11ff0ef          	jal	ffffffffc0203840 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203d34:	fcf9                	bnez	s1,ffffffffc0203d12 <vmm_init+0x3c>
ffffffffc0203d36:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d3a:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203d3e:	03000513          	li	a0,48
ffffffffc0203d42:	822fe0ef          	jal	ffffffffc0201d64 <kmalloc>
    if (vma != NULL)
ffffffffc0203d46:	12050f63          	beqz	a0,ffffffffc0203e84 <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203d4a:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203d4e:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203d50:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203d54:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203d56:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d58:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203d5a:	8522                	mv	a0,s0
ffffffffc0203d5c:	ae5ff0ef          	jal	ffffffffc0203840 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d60:	fd249fe3          	bne	s1,s2,ffffffffc0203d3e <vmm_init+0x68>
    return listelm->next;
ffffffffc0203d64:	641c                	ld	a5,8(s0)
ffffffffc0203d66:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203d68:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203d6c:	1ef40c63          	beq	s0,a5,ffffffffc0203f64 <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203d70:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f5e30>
ffffffffc0203d74:	ffe70693          	addi	a3,a4,-2
ffffffffc0203d78:	12d61663          	bne	a2,a3,ffffffffc0203ea4 <vmm_init+0x1ce>
ffffffffc0203d7c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203d80:	12e69263          	bne	a3,a4,ffffffffc0203ea4 <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203d84:	0715                	addi	a4,a4,5
ffffffffc0203d86:	679c                	ld	a5,8(a5)
ffffffffc0203d88:	feb712e3          	bne	a4,a1,ffffffffc0203d6c <vmm_init+0x96>
ffffffffc0203d8c:	491d                	li	s2,7
ffffffffc0203d8e:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203d90:	85a6                	mv	a1,s1
ffffffffc0203d92:	8522                	mv	a0,s0
ffffffffc0203d94:	a6dff0ef          	jal	ffffffffc0203800 <find_vma>
ffffffffc0203d98:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203d9a:	20050563          	beqz	a0,ffffffffc0203fa4 <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203d9e:	00148593          	addi	a1,s1,1
ffffffffc0203da2:	8522                	mv	a0,s0
ffffffffc0203da4:	a5dff0ef          	jal	ffffffffc0203800 <find_vma>
ffffffffc0203da8:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203daa:	1c050d63          	beqz	a0,ffffffffc0203f84 <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203dae:	85ca                	mv	a1,s2
ffffffffc0203db0:	8522                	mv	a0,s0
ffffffffc0203db2:	a4fff0ef          	jal	ffffffffc0203800 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203db6:	18051763          	bnez	a0,ffffffffc0203f44 <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203dba:	00348593          	addi	a1,s1,3
ffffffffc0203dbe:	8522                	mv	a0,s0
ffffffffc0203dc0:	a41ff0ef          	jal	ffffffffc0203800 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203dc4:	16051063          	bnez	a0,ffffffffc0203f24 <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203dc8:	00448593          	addi	a1,s1,4
ffffffffc0203dcc:	8522                	mv	a0,s0
ffffffffc0203dce:	a33ff0ef          	jal	ffffffffc0203800 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203dd2:	12051963          	bnez	a0,ffffffffc0203f04 <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203dd6:	008a3783          	ld	a5,8(s4)
ffffffffc0203dda:	10979563          	bne	a5,s1,ffffffffc0203ee4 <vmm_init+0x20e>
ffffffffc0203dde:	010a3783          	ld	a5,16(s4)
ffffffffc0203de2:	11279163          	bne	a5,s2,ffffffffc0203ee4 <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203de6:	0089b783          	ld	a5,8(s3)
ffffffffc0203dea:	0c979d63          	bne	a5,s1,ffffffffc0203ec4 <vmm_init+0x1ee>
ffffffffc0203dee:	0109b783          	ld	a5,16(s3)
ffffffffc0203df2:	0d279963          	bne	a5,s2,ffffffffc0203ec4 <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203df6:	0495                	addi	s1,s1,5
ffffffffc0203df8:	1f900793          	li	a5,505
ffffffffc0203dfc:	0915                	addi	s2,s2,5
ffffffffc0203dfe:	f8f499e3          	bne	s1,a5,ffffffffc0203d90 <vmm_init+0xba>
ffffffffc0203e02:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203e04:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203e06:	85a6                	mv	a1,s1
ffffffffc0203e08:	8522                	mv	a0,s0
ffffffffc0203e0a:	9f7ff0ef          	jal	ffffffffc0203800 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203e0e:	1a051b63          	bnez	a0,ffffffffc0203fc4 <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203e12:	14fd                	addi	s1,s1,-1
ffffffffc0203e14:	ff2499e3          	bne	s1,s2,ffffffffc0203e06 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203e18:	8522                	mv	a0,s0
ffffffffc0203e1a:	af5ff0ef          	jal	ffffffffc020390e <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203e1e:	00003517          	auipc	a0,0x3
ffffffffc0203e22:	34a50513          	addi	a0,a0,842 # ffffffffc0207168 <etext+0x174e>
ffffffffc0203e26:	b6efc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203e2a:	7402                	ld	s0,32(sp)
ffffffffc0203e2c:	70a2                	ld	ra,40(sp)
ffffffffc0203e2e:	64e2                	ld	s1,24(sp)
ffffffffc0203e30:	6942                	ld	s2,16(sp)
ffffffffc0203e32:	69a2                	ld	s3,8(sp)
ffffffffc0203e34:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e36:	00003517          	auipc	a0,0x3
ffffffffc0203e3a:	35250513          	addi	a0,a0,850 # ffffffffc0207188 <etext+0x176e>
}
ffffffffc0203e3e:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e40:	b54fc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203e44:	00003697          	auipc	a3,0x3
ffffffffc0203e48:	1d468693          	addi	a3,a3,468 # ffffffffc0207018 <etext+0x15fe>
ffffffffc0203e4c:	00002617          	auipc	a2,0x2
ffffffffc0203e50:	5d460613          	addi	a2,a2,1492 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203e54:	18000593          	li	a1,384
ffffffffc0203e58:	00003517          	auipc	a0,0x3
ffffffffc0203e5c:	0e850513          	addi	a0,a0,232 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203e60:	de6fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc0203e64:	00003697          	auipc	a3,0x3
ffffffffc0203e68:	16468693          	addi	a3,a3,356 # ffffffffc0206fc8 <etext+0x15ae>
ffffffffc0203e6c:	00002617          	auipc	a2,0x2
ffffffffc0203e70:	5b460613          	addi	a2,a2,1460 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203e74:	17800593          	li	a1,376
ffffffffc0203e78:	00003517          	auipc	a0,0x3
ffffffffc0203e7c:	0c850513          	addi	a0,a0,200 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203e80:	dc6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma != NULL);
ffffffffc0203e84:	00003697          	auipc	a3,0x3
ffffffffc0203e88:	19468693          	addi	a3,a3,404 # ffffffffc0207018 <etext+0x15fe>
ffffffffc0203e8c:	00002617          	auipc	a2,0x2
ffffffffc0203e90:	59460613          	addi	a2,a2,1428 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203e94:	18700593          	li	a1,391
ffffffffc0203e98:	00003517          	auipc	a0,0x3
ffffffffc0203e9c:	0a850513          	addi	a0,a0,168 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203ea0:	da6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ea4:	00003697          	auipc	a3,0x3
ffffffffc0203ea8:	19c68693          	addi	a3,a3,412 # ffffffffc0207040 <etext+0x1626>
ffffffffc0203eac:	00002617          	auipc	a2,0x2
ffffffffc0203eb0:	57460613          	addi	a2,a2,1396 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203eb4:	19100593          	li	a1,401
ffffffffc0203eb8:	00003517          	auipc	a0,0x3
ffffffffc0203ebc:	08850513          	addi	a0,a0,136 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203ec0:	d86fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203ec4:	00003697          	auipc	a3,0x3
ffffffffc0203ec8:	23468693          	addi	a3,a3,564 # ffffffffc02070f8 <etext+0x16de>
ffffffffc0203ecc:	00002617          	auipc	a2,0x2
ffffffffc0203ed0:	55460613          	addi	a2,a2,1364 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203ed4:	1a300593          	li	a1,419
ffffffffc0203ed8:	00003517          	auipc	a0,0x3
ffffffffc0203edc:	06850513          	addi	a0,a0,104 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203ee0:	d66fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203ee4:	00003697          	auipc	a3,0x3
ffffffffc0203ee8:	1e468693          	addi	a3,a3,484 # ffffffffc02070c8 <etext+0x16ae>
ffffffffc0203eec:	00002617          	auipc	a2,0x2
ffffffffc0203ef0:	53460613          	addi	a2,a2,1332 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203ef4:	1a200593          	li	a1,418
ffffffffc0203ef8:	00003517          	auipc	a0,0x3
ffffffffc0203efc:	04850513          	addi	a0,a0,72 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203f00:	d46fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203f04:	00003697          	auipc	a3,0x3
ffffffffc0203f08:	1b468693          	addi	a3,a3,436 # ffffffffc02070b8 <etext+0x169e>
ffffffffc0203f0c:	00002617          	auipc	a2,0x2
ffffffffc0203f10:	51460613          	addi	a2,a2,1300 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203f14:	1a000593          	li	a1,416
ffffffffc0203f18:	00003517          	auipc	a0,0x3
ffffffffc0203f1c:	02850513          	addi	a0,a0,40 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203f20:	d26fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203f24:	00003697          	auipc	a3,0x3
ffffffffc0203f28:	18468693          	addi	a3,a3,388 # ffffffffc02070a8 <etext+0x168e>
ffffffffc0203f2c:	00002617          	auipc	a2,0x2
ffffffffc0203f30:	4f460613          	addi	a2,a2,1268 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203f34:	19e00593          	li	a1,414
ffffffffc0203f38:	00003517          	auipc	a0,0x3
ffffffffc0203f3c:	00850513          	addi	a0,a0,8 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203f40:	d06fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203f44:	00003697          	auipc	a3,0x3
ffffffffc0203f48:	15468693          	addi	a3,a3,340 # ffffffffc0207098 <etext+0x167e>
ffffffffc0203f4c:	00002617          	auipc	a2,0x2
ffffffffc0203f50:	4d460613          	addi	a2,a2,1236 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203f54:	19c00593          	li	a1,412
ffffffffc0203f58:	00003517          	auipc	a0,0x3
ffffffffc0203f5c:	fe850513          	addi	a0,a0,-24 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203f60:	ce6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203f64:	00003697          	auipc	a3,0x3
ffffffffc0203f68:	0c468693          	addi	a3,a3,196 # ffffffffc0207028 <etext+0x160e>
ffffffffc0203f6c:	00002617          	auipc	a2,0x2
ffffffffc0203f70:	4b460613          	addi	a2,a2,1204 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203f74:	18f00593          	li	a1,399
ffffffffc0203f78:	00003517          	auipc	a0,0x3
ffffffffc0203f7c:	fc850513          	addi	a0,a0,-56 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203f80:	cc6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203f84:	00003697          	auipc	a3,0x3
ffffffffc0203f88:	10468693          	addi	a3,a3,260 # ffffffffc0207088 <etext+0x166e>
ffffffffc0203f8c:	00002617          	auipc	a2,0x2
ffffffffc0203f90:	49460613          	addi	a2,a2,1172 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203f94:	19a00593          	li	a1,410
ffffffffc0203f98:	00003517          	auipc	a0,0x3
ffffffffc0203f9c:	fa850513          	addi	a0,a0,-88 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203fa0:	ca6fc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203fa4:	00003697          	auipc	a3,0x3
ffffffffc0203fa8:	0d468693          	addi	a3,a3,212 # ffffffffc0207078 <etext+0x165e>
ffffffffc0203fac:	00002617          	auipc	a2,0x2
ffffffffc0203fb0:	47460613          	addi	a2,a2,1140 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203fb4:	19800593          	li	a1,408
ffffffffc0203fb8:	00003517          	auipc	a0,0x3
ffffffffc0203fbc:	f8850513          	addi	a0,a0,-120 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203fc0:	c86fc0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203fc4:	6914                	ld	a3,16(a0)
ffffffffc0203fc6:	6510                	ld	a2,8(a0)
ffffffffc0203fc8:	0004859b          	sext.w	a1,s1
ffffffffc0203fcc:	00003517          	auipc	a0,0x3
ffffffffc0203fd0:	15c50513          	addi	a0,a0,348 # ffffffffc0207128 <etext+0x170e>
ffffffffc0203fd4:	9c0fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203fd8:	00003697          	auipc	a3,0x3
ffffffffc0203fdc:	17868693          	addi	a3,a3,376 # ffffffffc0207150 <etext+0x1736>
ffffffffc0203fe0:	00002617          	auipc	a2,0x2
ffffffffc0203fe4:	44060613          	addi	a2,a2,1088 # ffffffffc0206420 <etext+0xa06>
ffffffffc0203fe8:	1ad00593          	li	a1,429
ffffffffc0203fec:	00003517          	auipc	a0,0x3
ffffffffc0203ff0:	f5450513          	addi	a0,a0,-172 # ffffffffc0206f40 <etext+0x1526>
ffffffffc0203ff4:	c52fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203ff8 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203ff8:	7179                	addi	sp,sp,-48
ffffffffc0203ffa:	f022                	sd	s0,32(sp)
ffffffffc0203ffc:	f406                	sd	ra,40(sp)
ffffffffc0203ffe:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0204000:	c52d                	beqz	a0,ffffffffc020406a <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0204002:	002007b7          	lui	a5,0x200
ffffffffc0204006:	04f5ed63          	bltu	a1,a5,ffffffffc0204060 <user_mem_check+0x68>
ffffffffc020400a:	ec26                	sd	s1,24(sp)
ffffffffc020400c:	00c584b3          	add	s1,a1,a2
ffffffffc0204010:	0695ff63          	bgeu	a1,s1,ffffffffc020408e <user_mem_check+0x96>
ffffffffc0204014:	4785                	li	a5,1
ffffffffc0204016:	07fe                	slli	a5,a5,0x1f
ffffffffc0204018:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc020401a:	06f4fa63          	bgeu	s1,a5,ffffffffc020408e <user_mem_check+0x96>
ffffffffc020401e:	e84a                	sd	s2,16(sp)
ffffffffc0204020:	e44e                	sd	s3,8(sp)
ffffffffc0204022:	8936                	mv	s2,a3
ffffffffc0204024:	89aa                	mv	s3,a0
ffffffffc0204026:	a829                	j	ffffffffc0204040 <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0204028:	6685                	lui	a3,0x1
ffffffffc020402a:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc020402c:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0204030:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0204032:	c685                	beqz	a3,ffffffffc020405a <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0204034:	c399                	beqz	a5,ffffffffc020403a <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0204036:	02e46263          	bltu	s0,a4,ffffffffc020405a <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc020403a:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc020403c:	04947b63          	bgeu	s0,s1,ffffffffc0204092 <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0204040:	85a2                	mv	a1,s0
ffffffffc0204042:	854e                	mv	a0,s3
ffffffffc0204044:	fbcff0ef          	jal	ffffffffc0203800 <find_vma>
ffffffffc0204048:	c909                	beqz	a0,ffffffffc020405a <user_mem_check+0x62>
ffffffffc020404a:	6518                	ld	a4,8(a0)
ffffffffc020404c:	00e46763          	bltu	s0,a4,ffffffffc020405a <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0204050:	4d1c                	lw	a5,24(a0)
ffffffffc0204052:	fc091be3          	bnez	s2,ffffffffc0204028 <user_mem_check+0x30>
ffffffffc0204056:	8b85                	andi	a5,a5,1
ffffffffc0204058:	f3ed                	bnez	a5,ffffffffc020403a <user_mem_check+0x42>
ffffffffc020405a:	64e2                	ld	s1,24(sp)
ffffffffc020405c:	6942                	ld	s2,16(sp)
ffffffffc020405e:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0204060:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0204062:	70a2                	ld	ra,40(sp)
ffffffffc0204064:	7402                	ld	s0,32(sp)
ffffffffc0204066:	6145                	addi	sp,sp,48
ffffffffc0204068:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc020406a:	c02007b7          	lui	a5,0xc0200
ffffffffc020406e:	fef5eae3          	bltu	a1,a5,ffffffffc0204062 <user_mem_check+0x6a>
ffffffffc0204072:	c80007b7          	lui	a5,0xc8000
ffffffffc0204076:	962e                	add	a2,a2,a1
ffffffffc0204078:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d64999>
ffffffffc020407a:	00c5b433          	sltu	s0,a1,a2
ffffffffc020407e:	00f63633          	sltu	a2,a2,a5
}
ffffffffc0204082:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0204084:	00867533          	and	a0,a2,s0
}
ffffffffc0204088:	7402                	ld	s0,32(sp)
ffffffffc020408a:	6145                	addi	sp,sp,48
ffffffffc020408c:	8082                	ret
ffffffffc020408e:	64e2                	ld	s1,24(sp)
ffffffffc0204090:	bfc1                	j	ffffffffc0204060 <user_mem_check+0x68>
ffffffffc0204092:	64e2                	ld	s1,24(sp)
ffffffffc0204094:	6942                	ld	s2,16(sp)
ffffffffc0204096:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0204098:	4505                	li	a0,1
ffffffffc020409a:	b7e1                	j	ffffffffc0204062 <user_mem_check+0x6a>

ffffffffc020409c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020409c:	8526                	mv	a0,s1
	jalr s0
ffffffffc020409e:	9402                	jalr	s0

	jal do_exit
ffffffffc02040a0:	5f2000ef          	jal	ffffffffc0204692 <do_exit>

ffffffffc02040a4 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc02040a4:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040a6:	10800513          	li	a0,264
{
ffffffffc02040aa:	e022                	sd	s0,0(sp)
ffffffffc02040ac:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040ae:	cb7fd0ef          	jal	ffffffffc0201d64 <kmalloc>
ffffffffc02040b2:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02040b4:	c525                	beqz	a0,ffffffffc020411c <alloc_proc+0x78>
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         * 
         */
        // 基本状态字段
        proc->state = PROC_UNINIT;//未初始化
ffffffffc02040b6:	57fd                	li	a5,-1
ffffffffc02040b8:	1782                	slli	a5,a5,0x20
ffffffffc02040ba:	e11c                	sd	a5,0(a0)
        proc->pid = -1;//设置进程pid的未初始化值
        proc->runs = 0;
ffffffffc02040bc:	00052423          	sw	zero,8(a0)

        // 栈与调度标志
        proc->kstack = 0;
ffffffffc02040c0:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02040c4:	00053c23          	sd	zero,24(a0)

        // 亲缘关系与地址空间
        proc->parent = NULL;
ffffffffc02040c8:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02040cc:	02053423          	sd	zero,40(a0)

        // 上下文/中断帧初始化
        // struct context context
        // 用0初始化上下文结构体
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02040d0:	07000613          	li	a2,112
ffffffffc02040d4:	4581                	li	a1,0
ffffffffc02040d6:	03050513          	addi	a0,a0,48
ffffffffc02040da:	117010ef          	jal	ffffffffc02059f0 <memset>
        proc->tf = NULL;

        // 页表根 初始化为内核的页表根，来自pmm.c
        // 内核启动时使用的根页表（boot_pgdir_pa）的物理地址
        proc->pgdir = boot_pgdir_pa;
ffffffffc02040de:	00097797          	auipc	a5,0x97
ffffffffc02040e2:	5427b783          	ld	a5,1346(a5) # ffffffffc029b620 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc02040e6:	0a043023          	sd	zero,160(s0)

        // 其他
        proc->flags = 0;
ffffffffc02040ea:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc02040ee:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc02040f0:	0b440513          	addi	a0,s0,180
ffffffffc02040f4:	4641                	li	a2,16
ffffffffc02040f6:	4581                	li	a1,0
ffffffffc02040f8:	0f9010ef          	jal	ffffffffc02059f0 <memset>

        // 链表结点清零（可选，便于调试）
        list_init(&(proc->list_link));
ffffffffc02040fc:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0204100:	0d840793          	addi	a5,s0,216
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes，这个数据到底在干什么
         */
        proc->wait_state = 0;//进程等待状态设置为0
ffffffffc0204104:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;//关系全部设置为null
ffffffffc0204108:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc020410c:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0204110:	0e043c23          	sd	zero,248(s0)
    elm->prev = elm->next = elm;
ffffffffc0204114:	e878                	sd	a4,208(s0)
ffffffffc0204116:	e478                	sd	a4,200(s0)
ffffffffc0204118:	f07c                	sd	a5,224(s0)
ffffffffc020411a:	ec7c                	sd	a5,216(s0)
    }
    return proc;
}
ffffffffc020411c:	60a2                	ld	ra,8(sp)
ffffffffc020411e:	8522                	mv	a0,s0
ffffffffc0204120:	6402                	ld	s0,0(sp)
ffffffffc0204122:	0141                	addi	sp,sp,16
ffffffffc0204124:	8082                	ret

ffffffffc0204126 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204126:	00097797          	auipc	a5,0x97
ffffffffc020412a:	52a7b783          	ld	a5,1322(a5) # ffffffffc029b650 <current>
ffffffffc020412e:	73c8                	ld	a0,160(a5)
ffffffffc0204130:	e1bfc06f          	j	ffffffffc0200f4a <forkrets>

ffffffffc0204134 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204134:	00097797          	auipc	a5,0x97
ffffffffc0204138:	51c7b783          	ld	a5,1308(a5) # ffffffffc029b650 <current>
{
ffffffffc020413c:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020413e:	00003617          	auipc	a2,0x3
ffffffffc0204142:	06260613          	addi	a2,a2,98 # ffffffffc02071a0 <etext+0x1786>
ffffffffc0204146:	43cc                	lw	a1,4(a5)
ffffffffc0204148:	00003517          	auipc	a0,0x3
ffffffffc020414c:	06850513          	addi	a0,a0,104 # ffffffffc02071b0 <etext+0x1796>
{
ffffffffc0204150:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204152:	842fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0204156:	3fe05797          	auipc	a5,0x3fe05
ffffffffc020415a:	77a78793          	addi	a5,a5,1914 # 98d0 <_binary_obj___user_forktest_out_size>
ffffffffc020415e:	e43e                	sd	a5,8(sp)
kernel_execve(const char *name, unsigned char *binary, size_t size)
ffffffffc0204160:	00003517          	auipc	a0,0x3
ffffffffc0204164:	04050513          	addi	a0,a0,64 # ffffffffc02071a0 <etext+0x1786>
ffffffffc0204168:	0003f797          	auipc	a5,0x3f
ffffffffc020416c:	4f078793          	addi	a5,a5,1264 # ffffffffc0243658 <_binary_obj___user_forktest_out_start>
ffffffffc0204170:	f03e                	sd	a5,32(sp)
ffffffffc0204172:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0204174:	e802                	sd	zero,16(sp)
ffffffffc0204176:	7c6010ef          	jal	ffffffffc020593c <strlen>
ffffffffc020417a:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc020417c:	4511                	li	a0,4
ffffffffc020417e:	55a2                	lw	a1,40(sp)
ffffffffc0204180:	4662                	lw	a2,24(sp)
ffffffffc0204182:	5682                	lw	a3,32(sp)
ffffffffc0204184:	4722                	lw	a4,8(sp)
ffffffffc0204186:	48a9                	li	a7,10
ffffffffc0204188:	9002                	ebreak
ffffffffc020418a:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc020418c:	65c2                	ld	a1,16(sp)
ffffffffc020418e:	00003517          	auipc	a0,0x3
ffffffffc0204192:	04a50513          	addi	a0,a0,74 # ffffffffc02071d8 <etext+0x17be>
ffffffffc0204196:	ffffb0ef          	jal	ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc020419a:	00003617          	auipc	a2,0x3
ffffffffc020419e:	04e60613          	addi	a2,a2,78 # ffffffffc02071e8 <etext+0x17ce>
ffffffffc02041a2:	40800593          	li	a1,1032
ffffffffc02041a6:	00003517          	auipc	a0,0x3
ffffffffc02041aa:	06250513          	addi	a0,a0,98 # ffffffffc0207208 <etext+0x17ee>
ffffffffc02041ae:	a98fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02041b2 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02041b2:	6d14                	ld	a3,24(a0)
{
ffffffffc02041b4:	1141                	addi	sp,sp,-16
ffffffffc02041b6:	e406                	sd	ra,8(sp)
ffffffffc02041b8:	c02007b7          	lui	a5,0xc0200
ffffffffc02041bc:	02f6ee63          	bltu	a3,a5,ffffffffc02041f8 <put_pgdir+0x46>
ffffffffc02041c0:	00097717          	auipc	a4,0x97
ffffffffc02041c4:	47073703          	ld	a4,1136(a4) # ffffffffc029b630 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc02041c8:	00097797          	auipc	a5,0x97
ffffffffc02041cc:	4707b783          	ld	a5,1136(a5) # ffffffffc029b638 <npage>
    return pa2page(PADDR(kva));
ffffffffc02041d0:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc02041d2:	82b1                	srli	a3,a3,0xc
ffffffffc02041d4:	02f6fe63          	bgeu	a3,a5,ffffffffc0204210 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02041d8:	00004797          	auipc	a5,0x4
ffffffffc02041dc:	9b87b783          	ld	a5,-1608(a5) # ffffffffc0207b90 <nbase>
ffffffffc02041e0:	00097517          	auipc	a0,0x97
ffffffffc02041e4:	46053503          	ld	a0,1120(a0) # ffffffffc029b640 <pages>
}
ffffffffc02041e8:	60a2                	ld	ra,8(sp)
ffffffffc02041ea:	8e9d                	sub	a3,a3,a5
ffffffffc02041ec:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc02041ee:	4585                	li	a1,1
ffffffffc02041f0:	9536                	add	a0,a0,a3
}
ffffffffc02041f2:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc02041f4:	d6dfd06f          	j	ffffffffc0201f60 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc02041f8:	00002617          	auipc	a2,0x2
ffffffffc02041fc:	68060613          	addi	a2,a2,1664 # ffffffffc0206878 <etext+0xe5e>
ffffffffc0204200:	07700593          	li	a1,119
ffffffffc0204204:	00002517          	auipc	a0,0x2
ffffffffc0204208:	5f450513          	addi	a0,a0,1524 # ffffffffc02067f8 <etext+0xdde>
ffffffffc020420c:	a3afc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204210:	00002617          	auipc	a2,0x2
ffffffffc0204214:	69060613          	addi	a2,a2,1680 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0204218:	06900593          	li	a1,105
ffffffffc020421c:	00002517          	auipc	a0,0x2
ffffffffc0204220:	5dc50513          	addi	a0,a0,1500 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0204224:	a22fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204228 <proc_run>:
    if (proc != current)
ffffffffc0204228:	00097797          	auipc	a5,0x97
ffffffffc020422c:	42878793          	addi	a5,a5,1064 # ffffffffc029b650 <current>
ffffffffc0204230:	6398                	ld	a4,0(a5)
ffffffffc0204232:	04a70163          	beq	a4,a0,ffffffffc0204274 <proc_run+0x4c>
{
ffffffffc0204236:	1101                	addi	sp,sp,-32
ffffffffc0204238:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020423a:	100026f3          	csrr	a3,sstatus
ffffffffc020423e:	8a89                	andi	a3,a3,2
    return 0;
ffffffffc0204240:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204242:	ea95                	bnez	a3,ffffffffc0204276 <proc_run+0x4e>
        current = proc;
ffffffffc0204244:	e388                	sd	a0,0(a5)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204246:	755c                	ld	a5,168(a0)
ffffffffc0204248:	56fd                	li	a3,-1
ffffffffc020424a:	16fe                	slli	a3,a3,0x3f
ffffffffc020424c:	83b1                	srli	a5,a5,0xc
ffffffffc020424e:	e432                	sd	a2,8(sp)
ffffffffc0204250:	8fd5                	or	a5,a5,a3
ffffffffc0204252:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc0204256:	03050593          	addi	a1,a0,48
ffffffffc020425a:	03070513          	addi	a0,a4,48
ffffffffc020425e:	096010ef          	jal	ffffffffc02052f4 <switch_to>
    if (flag)
ffffffffc0204262:	6622                	ld	a2,8(sp)
ffffffffc0204264:	e601                	bnez	a2,ffffffffc020426c <proc_run+0x44>
}
ffffffffc0204266:	60e2                	ld	ra,24(sp)
ffffffffc0204268:	6105                	addi	sp,sp,32
ffffffffc020426a:	8082                	ret
ffffffffc020426c:	60e2                	ld	ra,24(sp)
ffffffffc020426e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0204270:	e8efc06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc0204274:	8082                	ret
        intr_disable();
ffffffffc0204276:	e42a                	sd	a0,8(sp)
ffffffffc0204278:	e8cfc0ef          	jal	ffffffffc0200904 <intr_disable>
        struct proc_struct *prev = current;
ffffffffc020427c:	00097797          	auipc	a5,0x97
ffffffffc0204280:	3d478793          	addi	a5,a5,980 # ffffffffc029b650 <current>
ffffffffc0204284:	6398                	ld	a4,0(a5)
        return 1;
ffffffffc0204286:	6522                	ld	a0,8(sp)
ffffffffc0204288:	4605                	li	a2,1
ffffffffc020428a:	bf6d                	j	ffffffffc0204244 <proc_run+0x1c>

ffffffffc020428c <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc020428c:	00097797          	auipc	a5,0x97
ffffffffc0204290:	3c07a783          	lw	a5,960(a5) # ffffffffc029b64c <nr_process>
{
ffffffffc0204294:	7159                	addi	sp,sp,-112
ffffffffc0204296:	e4ce                	sd	s3,72(sp)
ffffffffc0204298:	f486                	sd	ra,104(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020429a:	6985                	lui	s3,0x1
ffffffffc020429c:	3337d463          	bge	a5,s3,ffffffffc02045c4 <do_fork+0x338>
ffffffffc02042a0:	f0a2                	sd	s0,96(sp)
ffffffffc02042a2:	eca6                	sd	s1,88(sp)
ffffffffc02042a4:	e8ca                	sd	s2,80(sp)
ffffffffc02042a6:	e86a                	sd	s10,16(sp)
ffffffffc02042a8:	892e                	mv	s2,a1
ffffffffc02042aa:	84b2                	mv	s1,a2
ffffffffc02042ac:	8d2a                	mv	s10,a0
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02042ae:	df7ff0ef          	jal	ffffffffc02040a4 <alloc_proc>
ffffffffc02042b2:	842a                	mv	s0,a0
ffffffffc02042b4:	2e050463          	beqz	a0,ffffffffc020459c <do_fork+0x310>
ffffffffc02042b8:	f45e                	sd	s7,40(sp)
    proc->parent = current;
ffffffffc02042ba:	00097b97          	auipc	s7,0x97
ffffffffc02042be:	396b8b93          	addi	s7,s7,918 # ffffffffc029b650 <current>
ffffffffc02042c2:	000bb783          	ld	a5,0(s7)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042c6:	4509                	li	a0,2
    proc->parent = current;
ffffffffc02042c8:	f01c                	sd	a5,32(s0)
    current->wait_state = 0;   // 确保父进程 wait_state 清零
ffffffffc02042ca:	0e07a623          	sw	zero,236(a5)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042ce:	c59fd0ef          	jal	ffffffffc0201f26 <alloc_pages>
    if (page != NULL)
ffffffffc02042d2:	2c050163          	beqz	a0,ffffffffc0204594 <do_fork+0x308>
ffffffffc02042d6:	e0d2                	sd	s4,64(sp)
    return page - pages + nbase;
ffffffffc02042d8:	00097a17          	auipc	s4,0x97
ffffffffc02042dc:	368a0a13          	addi	s4,s4,872 # ffffffffc029b640 <pages>
ffffffffc02042e0:	000a3783          	ld	a5,0(s4)
ffffffffc02042e4:	fc56                	sd	s5,56(sp)
ffffffffc02042e6:	00004a97          	auipc	s5,0x4
ffffffffc02042ea:	8aaa8a93          	addi	s5,s5,-1878 # ffffffffc0207b90 <nbase>
ffffffffc02042ee:	000ab703          	ld	a4,0(s5)
ffffffffc02042f2:	40f506b3          	sub	a3,a0,a5
ffffffffc02042f6:	f85a                	sd	s6,48(sp)
    return KADDR(page2pa(page));
ffffffffc02042f8:	00097b17          	auipc	s6,0x97
ffffffffc02042fc:	340b0b13          	addi	s6,s6,832 # ffffffffc029b638 <npage>
ffffffffc0204300:	ec66                	sd	s9,24(sp)
    return page - pages + nbase;
ffffffffc0204302:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204304:	5cfd                	li	s9,-1
ffffffffc0204306:	000b3783          	ld	a5,0(s6)
    return page - pages + nbase;
ffffffffc020430a:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc020430c:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0204310:	0196f633          	and	a2,a3,s9
ffffffffc0204314:	f062                	sd	s8,32(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0204316:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204318:	2cf67463          	bgeu	a2,a5,ffffffffc02045e0 <do_fork+0x354>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020431c:	000bb603          	ld	a2,0(s7)
ffffffffc0204320:	00097b97          	auipc	s7,0x97
ffffffffc0204324:	310b8b93          	addi	s7,s7,784 # ffffffffc029b630 <va_pa_offset>
ffffffffc0204328:	000bb783          	ld	a5,0(s7)
ffffffffc020432c:	02863c03          	ld	s8,40(a2)
ffffffffc0204330:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204332:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc0204334:	020c0863          	beqz	s8,ffffffffc0204364 <do_fork+0xd8>
    if (clone_flags & CLONE_VM)
ffffffffc0204338:	100d7793          	andi	a5,s10,256
ffffffffc020433c:	18078063          	beqz	a5,ffffffffc02044bc <do_fork+0x230>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204340:	030c2703          	lw	a4,48(s8) # fffffffffff80030 <end+0x3fce49c8>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204344:	018c3783          	ld	a5,24(s8)
ffffffffc0204348:	c02006b7          	lui	a3,0xc0200
ffffffffc020434c:	2705                	addiw	a4,a4,1
ffffffffc020434e:	02ec2823          	sw	a4,48(s8)
    proc->mm = mm;
ffffffffc0204352:	03843423          	sd	s8,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204356:	2ad7ed63          	bltu	a5,a3,ffffffffc0204610 <do_fork+0x384>
ffffffffc020435a:	000bb703          	ld	a4,0(s7)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020435e:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204360:	8f99                	sub	a5,a5,a4
ffffffffc0204362:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204364:	6789                	lui	a5,0x2
ffffffffc0204366:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6cd0>
ffffffffc020436a:	96be                	add	a3,a3,a5
ffffffffc020436c:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc020436e:	87b6                	mv	a5,a3
ffffffffc0204370:	12048713          	addi	a4,s1,288
ffffffffc0204374:	6890                	ld	a2,16(s1)
ffffffffc0204376:	6088                	ld	a0,0(s1)
ffffffffc0204378:	648c                	ld	a1,8(s1)
ffffffffc020437a:	eb90                	sd	a2,16(a5)
ffffffffc020437c:	e388                	sd	a0,0(a5)
ffffffffc020437e:	e78c                	sd	a1,8(a5)
ffffffffc0204380:	6c90                	ld	a2,24(s1)
ffffffffc0204382:	02048493          	addi	s1,s1,32
ffffffffc0204386:	02078793          	addi	a5,a5,32
ffffffffc020438a:	fec7bc23          	sd	a2,-8(a5)
ffffffffc020438e:	fee493e3          	bne	s1,a4,ffffffffc0204374 <do_fork+0xe8>
    proc->tf->gpr.a0 = 0;
ffffffffc0204392:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204396:	20090963          	beqz	s2,ffffffffc02045a8 <do_fork+0x31c>
    if (++last_pid >= MAX_PID)
ffffffffc020439a:	00093517          	auipc	a0,0x93
ffffffffc020439e:	e1a52503          	lw	a0,-486(a0) # ffffffffc02971b4 <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02043a2:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043a6:	00000797          	auipc	a5,0x0
ffffffffc02043aa:	d8078793          	addi	a5,a5,-640 # ffffffffc0204126 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02043ae:	2505                	addiw	a0,a0,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043b0:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02043b2:	fc14                	sd	a3,56(s0)
    if (++last_pid >= MAX_PID)
ffffffffc02043b4:	00093717          	auipc	a4,0x93
ffffffffc02043b8:	e0a72023          	sw	a0,-512(a4) # ffffffffc02971b4 <last_pid.1>
ffffffffc02043bc:	6789                	lui	a5,0x2
ffffffffc02043be:	1ef55763          	bge	a0,a5,ffffffffc02045ac <do_fork+0x320>
    if (last_pid >= next_safe)
ffffffffc02043c2:	00093797          	auipc	a5,0x93
ffffffffc02043c6:	dee7a783          	lw	a5,-530(a5) # ffffffffc02971b0 <next_safe.0>
ffffffffc02043ca:	00097497          	auipc	s1,0x97
ffffffffc02043ce:	20648493          	addi	s1,s1,518 # ffffffffc029b5d0 <proc_list>
ffffffffc02043d2:	06f54563          	blt	a0,a5,ffffffffc020443c <do_fork+0x1b0>
    return listelm->next;
ffffffffc02043d6:	00097497          	auipc	s1,0x97
ffffffffc02043da:	1fa48493          	addi	s1,s1,506 # ffffffffc029b5d0 <proc_list>
ffffffffc02043de:	0084b883          	ld	a7,8(s1)
        next_safe = MAX_PID;
ffffffffc02043e2:	6789                	lui	a5,0x2
ffffffffc02043e4:	00093717          	auipc	a4,0x93
ffffffffc02043e8:	dcf72623          	sw	a5,-564(a4) # ffffffffc02971b0 <next_safe.0>
ffffffffc02043ec:	86aa                	mv	a3,a0
ffffffffc02043ee:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02043f0:	04988063          	beq	a7,s1,ffffffffc0204430 <do_fork+0x1a4>
ffffffffc02043f4:	882e                	mv	a6,a1
ffffffffc02043f6:	87c6                	mv	a5,a7
ffffffffc02043f8:	6609                	lui	a2,0x2
ffffffffc02043fa:	a811                	j	ffffffffc020440e <do_fork+0x182>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02043fc:	00e6d663          	bge	a3,a4,ffffffffc0204408 <do_fork+0x17c>
ffffffffc0204400:	00c75463          	bge	a4,a2,ffffffffc0204408 <do_fork+0x17c>
                next_safe = proc->pid;
ffffffffc0204404:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204406:	4805                	li	a6,1
ffffffffc0204408:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020440a:	00978d63          	beq	a5,s1,ffffffffc0204424 <do_fork+0x198>
            if (proc->pid == last_pid)
ffffffffc020440e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6c74>
ffffffffc0204412:	fed715e3          	bne	a4,a3,ffffffffc02043fc <do_fork+0x170>
                if (++last_pid >= next_safe)
ffffffffc0204416:	2685                	addiw	a3,a3,1
ffffffffc0204418:	1ac6d063          	bge	a3,a2,ffffffffc02045b8 <do_fork+0x32c>
ffffffffc020441c:	679c                	ld	a5,8(a5)
ffffffffc020441e:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204420:	fe9797e3          	bne	a5,s1,ffffffffc020440e <do_fork+0x182>
ffffffffc0204424:	00080663          	beqz	a6,ffffffffc0204430 <do_fork+0x1a4>
ffffffffc0204428:	00093797          	auipc	a5,0x93
ffffffffc020442c:	d8c7a423          	sw	a2,-632(a5) # ffffffffc02971b0 <next_safe.0>
ffffffffc0204430:	c591                	beqz	a1,ffffffffc020443c <do_fork+0x1b0>
ffffffffc0204432:	00093797          	auipc	a5,0x93
ffffffffc0204436:	d8d7a123          	sw	a3,-638(a5) # ffffffffc02971b4 <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020443a:	8536                	mv	a0,a3
    proc->pid = get_pid();// 返回独特pid
ffffffffc020443c:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020443e:	45a9                	li	a1,10
ffffffffc0204440:	11a010ef          	jal	ffffffffc020555a <hash32>
ffffffffc0204444:	02051793          	slli	a5,a0,0x20
ffffffffc0204448:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020444c:	00093797          	auipc	a5,0x93
ffffffffc0204450:	18478793          	addi	a5,a5,388 # ffffffffc02975d0 <hash_list>
ffffffffc0204454:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204456:	6518                	ld	a4,8(a0)
ffffffffc0204458:	0d840793          	addi	a5,s0,216
ffffffffc020445c:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc020445e:	e31c                	sd	a5,0(a4)
ffffffffc0204460:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc0204462:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204464:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204468:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc020446a:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc020446c:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc020446e:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204472:	7b74                	ld	a3,240(a4)
ffffffffc0204474:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc0204476:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204478:	e464                	sd	s1,200(s0)
ffffffffc020447a:	10d43023          	sd	a3,256(s0)
ffffffffc020447e:	c299                	beqz	a3,ffffffffc0204484 <do_fork+0x1f8>
        proc->optr->yptr = proc;
ffffffffc0204480:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc0204482:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc0204484:	00097797          	auipc	a5,0x97
ffffffffc0204488:	1c87a783          	lw	a5,456(a5) # ffffffffc029b64c <nr_process>
    proc->parent->cptr = proc;
ffffffffc020448c:	fb60                	sd	s0,240(a4)
    wakeup_proc(proc);                        // 内部会把 state 置为 PROC_RUNNABLE
ffffffffc020448e:	8522                	mv	a0,s0
    nr_process++;
ffffffffc0204490:	2785                	addiw	a5,a5,1
ffffffffc0204492:	00097717          	auipc	a4,0x97
ffffffffc0204496:	1af72d23          	sw	a5,442(a4) # ffffffffc029b64c <nr_process>
    wakeup_proc(proc);                        // 内部会把 state 置为 PROC_RUNNABLE
ffffffffc020449a:	6c5000ef          	jal	ffffffffc020535e <wakeup_proc>
    ret = proc->pid;
ffffffffc020449e:	4048                	lw	a0,4(s0)
    goto fork_out;
ffffffffc02044a0:	64e6                	ld	s1,88(sp)
ffffffffc02044a2:	7406                	ld	s0,96(sp)
ffffffffc02044a4:	6946                	ld	s2,80(sp)
ffffffffc02044a6:	6a06                	ld	s4,64(sp)
ffffffffc02044a8:	7ae2                	ld	s5,56(sp)
ffffffffc02044aa:	7b42                	ld	s6,48(sp)
ffffffffc02044ac:	7ba2                	ld	s7,40(sp)
ffffffffc02044ae:	7c02                	ld	s8,32(sp)
ffffffffc02044b0:	6ce2                	ld	s9,24(sp)
ffffffffc02044b2:	6d42                	ld	s10,16(sp)
}
ffffffffc02044b4:	70a6                	ld	ra,104(sp)
ffffffffc02044b6:	69a6                	ld	s3,72(sp)
ffffffffc02044b8:	6165                	addi	sp,sp,112
ffffffffc02044ba:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc02044bc:	e43a                	sd	a4,8(sp)
ffffffffc02044be:	b12ff0ef          	jal	ffffffffc02037d0 <mm_create>
ffffffffc02044c2:	8d2a                	mv	s10,a0
ffffffffc02044c4:	c959                	beqz	a0,ffffffffc020455a <do_fork+0x2ce>
    if ((page = alloc_page()) == NULL)
ffffffffc02044c6:	4505                	li	a0,1
ffffffffc02044c8:	a5ffd0ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc02044cc:	c541                	beqz	a0,ffffffffc0204554 <do_fork+0x2c8>
    return page - pages + nbase;
ffffffffc02044ce:	000a3683          	ld	a3,0(s4)
ffffffffc02044d2:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc02044d4:	000b3783          	ld	a5,0(s6)
    return page - pages + nbase;
ffffffffc02044d8:	40d506b3          	sub	a3,a0,a3
ffffffffc02044dc:	8699                	srai	a3,a3,0x6
ffffffffc02044de:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc02044e0:	0196fcb3          	and	s9,a3,s9
    return page2ppn(page) << PGSHIFT;
ffffffffc02044e4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02044e6:	0efcfd63          	bgeu	s9,a5,ffffffffc02045e0 <do_fork+0x354>
ffffffffc02044ea:	000bb783          	ld	a5,0(s7)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02044ee:	00097597          	auipc	a1,0x97
ffffffffc02044f2:	13a5b583          	ld	a1,314(a1) # ffffffffc029b628 <boot_pgdir_va>
ffffffffc02044f6:	864e                	mv	a2,s3
ffffffffc02044f8:	00f689b3          	add	s3,a3,a5
ffffffffc02044fc:	854e                	mv	a0,s3
ffffffffc02044fe:	504010ef          	jal	ffffffffc0205a02 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204502:	038c0c93          	addi	s9,s8,56
    mm->pgdir = pgdir;
ffffffffc0204506:	013d3c23          	sd	s3,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020450a:	4785                	li	a5,1
ffffffffc020450c:	40fcb7af          	amoor.d	a5,a5,(s9)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204510:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204514:	03f75793          	srli	a5,a4,0x3f
ffffffffc0204518:	4985                	li	s3,1
ffffffffc020451a:	cb91                	beqz	a5,ffffffffc020452e <do_fork+0x2a2>
    {
        schedule();
ffffffffc020451c:	6d7000ef          	jal	ffffffffc02053f2 <schedule>
ffffffffc0204520:	413cb7af          	amoor.d	a5,s3,(s9)
    while (!try_lock(lock))
ffffffffc0204524:	03f79713          	slli	a4,a5,0x3f
ffffffffc0204528:	03f75793          	srli	a5,a4,0x3f
ffffffffc020452c:	fbe5                	bnez	a5,ffffffffc020451c <do_fork+0x290>
        ret = dup_mmap(mm, oldmm);
ffffffffc020452e:	85e2                	mv	a1,s8
ffffffffc0204530:	856a                	mv	a0,s10
ffffffffc0204532:	e96ff0ef          	jal	ffffffffc0203bc8 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204536:	57f9                	li	a5,-2
ffffffffc0204538:	60fcb7af          	amoand.d	a5,a5,(s9)
ffffffffc020453c:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc020453e:	0e078663          	beqz	a5,ffffffffc020462a <do_fork+0x39e>
    if ((mm = mm_create()) == NULL)
ffffffffc0204542:	8c6a                	mv	s8,s10
    if (ret != 0)
ffffffffc0204544:	de050ee3          	beqz	a0,ffffffffc0204340 <do_fork+0xb4>
    exit_mmap(mm);
ffffffffc0204548:	856a                	mv	a0,s10
ffffffffc020454a:	f16ff0ef          	jal	ffffffffc0203c60 <exit_mmap>
    put_pgdir(mm);
ffffffffc020454e:	856a                	mv	a0,s10
ffffffffc0204550:	c63ff0ef          	jal	ffffffffc02041b2 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204554:	856a                	mv	a0,s10
ffffffffc0204556:	bb8ff0ef          	jal	ffffffffc020390e <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020455a:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc020455c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204560:	08f6ec63          	bltu	a3,a5,ffffffffc02045f8 <do_fork+0x36c>
ffffffffc0204564:	000bb783          	ld	a5,0(s7)
    if (PPN(pa) >= npage)
ffffffffc0204568:	000b3703          	ld	a4,0(s6)
    return pa2page(PADDR(kva));
ffffffffc020456c:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204570:	83b1                	srli	a5,a5,0xc
ffffffffc0204572:	04e7fb63          	bgeu	a5,a4,ffffffffc02045c8 <do_fork+0x33c>
    return &pages[PPN(pa) - nbase];
ffffffffc0204576:	000ab703          	ld	a4,0(s5)
ffffffffc020457a:	000a3503          	ld	a0,0(s4)
ffffffffc020457e:	4589                	li	a1,2
ffffffffc0204580:	8f99                	sub	a5,a5,a4
ffffffffc0204582:	079a                	slli	a5,a5,0x6
ffffffffc0204584:	953e                	add	a0,a0,a5
ffffffffc0204586:	9dbfd0ef          	jal	ffffffffc0201f60 <free_pages>
}
ffffffffc020458a:	6a06                	ld	s4,64(sp)
ffffffffc020458c:	7ae2                	ld	s5,56(sp)
ffffffffc020458e:	7b42                	ld	s6,48(sp)
ffffffffc0204590:	7c02                	ld	s8,32(sp)
ffffffffc0204592:	6ce2                	ld	s9,24(sp)
    kfree(proc);
ffffffffc0204594:	8522                	mv	a0,s0
ffffffffc0204596:	875fd0ef          	jal	ffffffffc0201e0a <kfree>
ffffffffc020459a:	7ba2                	ld	s7,40(sp)
ffffffffc020459c:	7406                	ld	s0,96(sp)
ffffffffc020459e:	64e6                	ld	s1,88(sp)
ffffffffc02045a0:	6946                	ld	s2,80(sp)
ffffffffc02045a2:	6d42                	ld	s10,16(sp)
    ret = -E_NO_MEM;
ffffffffc02045a4:	5571                	li	a0,-4
    return ret;
ffffffffc02045a6:	b739                	j	ffffffffc02044b4 <do_fork+0x228>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02045a8:	8936                	mv	s2,a3
ffffffffc02045aa:	bbc5                	j	ffffffffc020439a <do_fork+0x10e>
        last_pid = 1;
ffffffffc02045ac:	4505                	li	a0,1
ffffffffc02045ae:	00093797          	auipc	a5,0x93
ffffffffc02045b2:	c0a7a323          	sw	a0,-1018(a5) # ffffffffc02971b4 <last_pid.1>
        goto inside;
ffffffffc02045b6:	b505                	j	ffffffffc02043d6 <do_fork+0x14a>
                    if (last_pid >= MAX_PID)
ffffffffc02045b8:	6789                	lui	a5,0x2
ffffffffc02045ba:	00f6c363          	blt	a3,a5,ffffffffc02045c0 <do_fork+0x334>
                        last_pid = 1;
ffffffffc02045be:	4685                	li	a3,1
                    goto repeat;
ffffffffc02045c0:	4585                	li	a1,1
ffffffffc02045c2:	b53d                	j	ffffffffc02043f0 <do_fork+0x164>
    int ret = -E_NO_FREE_PROC;
ffffffffc02045c4:	556d                	li	a0,-5
ffffffffc02045c6:	b5fd                	j	ffffffffc02044b4 <do_fork+0x228>
        panic("pa2page called with invalid pa");
ffffffffc02045c8:	00002617          	auipc	a2,0x2
ffffffffc02045cc:	2d860613          	addi	a2,a2,728 # ffffffffc02068a0 <etext+0xe86>
ffffffffc02045d0:	06900593          	li	a1,105
ffffffffc02045d4:	00002517          	auipc	a0,0x2
ffffffffc02045d8:	22450513          	addi	a0,a0,548 # ffffffffc02067f8 <etext+0xdde>
ffffffffc02045dc:	e6bfb0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02045e0:	00002617          	auipc	a2,0x2
ffffffffc02045e4:	1f060613          	addi	a2,a2,496 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc02045e8:	07100593          	li	a1,113
ffffffffc02045ec:	00002517          	auipc	a0,0x2
ffffffffc02045f0:	20c50513          	addi	a0,a0,524 # ffffffffc02067f8 <etext+0xdde>
ffffffffc02045f4:	e53fb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02045f8:	00002617          	auipc	a2,0x2
ffffffffc02045fc:	28060613          	addi	a2,a2,640 # ffffffffc0206878 <etext+0xe5e>
ffffffffc0204600:	07700593          	li	a1,119
ffffffffc0204604:	00002517          	auipc	a0,0x2
ffffffffc0204608:	1f450513          	addi	a0,a0,500 # ffffffffc02067f8 <etext+0xdde>
ffffffffc020460c:	e3bfb0ef          	jal	ffffffffc0200446 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204610:	86be                	mv	a3,a5
ffffffffc0204612:	00002617          	auipc	a2,0x2
ffffffffc0204616:	26660613          	addi	a2,a2,614 # ffffffffc0206878 <etext+0xe5e>
ffffffffc020461a:	1a500593          	li	a1,421
ffffffffc020461e:	00003517          	auipc	a0,0x3
ffffffffc0204622:	bea50513          	addi	a0,a0,-1046 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204626:	e21fb0ef          	jal	ffffffffc0200446 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020462a:	00003617          	auipc	a2,0x3
ffffffffc020462e:	bf660613          	addi	a2,a2,-1034 # ffffffffc0207220 <etext+0x1806>
ffffffffc0204632:	03f00593          	li	a1,63
ffffffffc0204636:	00003517          	auipc	a0,0x3
ffffffffc020463a:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0207230 <etext+0x1816>
ffffffffc020463e:	e09fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204642 <kernel_thread>:
{
ffffffffc0204642:	7129                	addi	sp,sp,-320
ffffffffc0204644:	fa22                	sd	s0,304(sp)
ffffffffc0204646:	f626                	sd	s1,296(sp)
ffffffffc0204648:	f24a                	sd	s2,288(sp)
ffffffffc020464a:	842a                	mv	s0,a0
ffffffffc020464c:	84ae                	mv	s1,a1
ffffffffc020464e:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204650:	850a                	mv	a0,sp
ffffffffc0204652:	12000613          	li	a2,288
ffffffffc0204656:	4581                	li	a1,0
{
ffffffffc0204658:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020465a:	396010ef          	jal	ffffffffc02059f0 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020465e:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204660:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204662:	100027f3          	csrr	a5,sstatus
ffffffffc0204666:	edd7f793          	andi	a5,a5,-291
ffffffffc020466a:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020466e:	860a                	mv	a2,sp
ffffffffc0204670:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204674:	00000717          	auipc	a4,0x0
ffffffffc0204678:	a2870713          	addi	a4,a4,-1496 # ffffffffc020409c <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020467c:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020467e:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204680:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204682:	c0bff0ef          	jal	ffffffffc020428c <do_fork>
}
ffffffffc0204686:	70f2                	ld	ra,312(sp)
ffffffffc0204688:	7452                	ld	s0,304(sp)
ffffffffc020468a:	74b2                	ld	s1,296(sp)
ffffffffc020468c:	7912                	ld	s2,288(sp)
ffffffffc020468e:	6131                	addi	sp,sp,320
ffffffffc0204690:	8082                	ret

ffffffffc0204692 <do_exit>:
{
ffffffffc0204692:	7179                	addi	sp,sp,-48
ffffffffc0204694:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204696:	00097417          	auipc	s0,0x97
ffffffffc020469a:	fba40413          	addi	s0,s0,-70 # ffffffffc029b650 <current>
ffffffffc020469e:	601c                	ld	a5,0(s0)
ffffffffc02046a0:	00097717          	auipc	a4,0x97
ffffffffc02046a4:	fc073703          	ld	a4,-64(a4) # ffffffffc029b660 <idleproc>
{
ffffffffc02046a8:	f406                	sd	ra,40(sp)
ffffffffc02046aa:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc02046ac:	0ce78b63          	beq	a5,a4,ffffffffc0204782 <do_exit+0xf0>
    if (current == initproc)
ffffffffc02046b0:	00097497          	auipc	s1,0x97
ffffffffc02046b4:	fa848493          	addi	s1,s1,-88 # ffffffffc029b658 <initproc>
ffffffffc02046b8:	6098                	ld	a4,0(s1)
ffffffffc02046ba:	e84a                	sd	s2,16(sp)
ffffffffc02046bc:	0ee78a63          	beq	a5,a4,ffffffffc02047b0 <do_exit+0x11e>
ffffffffc02046c0:	892a                	mv	s2,a0
    struct mm_struct *mm = current->mm;
ffffffffc02046c2:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc02046c4:	c115                	beqz	a0,ffffffffc02046e8 <do_exit+0x56>
ffffffffc02046c6:	00097797          	auipc	a5,0x97
ffffffffc02046ca:	f5a7b783          	ld	a5,-166(a5) # ffffffffc029b620 <boot_pgdir_pa>
ffffffffc02046ce:	577d                	li	a4,-1
ffffffffc02046d0:	177e                	slli	a4,a4,0x3f
ffffffffc02046d2:	83b1                	srli	a5,a5,0xc
ffffffffc02046d4:	8fd9                	or	a5,a5,a4
ffffffffc02046d6:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02046da:	591c                	lw	a5,48(a0)
ffffffffc02046dc:	37fd                	addiw	a5,a5,-1
ffffffffc02046de:	d91c                	sw	a5,48(a0)
        if (mm_count_dec(mm) == 0)
ffffffffc02046e0:	cfd5                	beqz	a5,ffffffffc020479c <do_exit+0x10a>
        current->mm = NULL;
ffffffffc02046e2:	601c                	ld	a5,0(s0)
ffffffffc02046e4:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02046e8:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc02046ea:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02046ee:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046f0:	100027f3          	csrr	a5,sstatus
ffffffffc02046f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046f6:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046f8:	ebe1                	bnez	a5,ffffffffc02047c8 <do_exit+0x136>
        proc = current->parent;
ffffffffc02046fa:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02046fc:	800007b7          	lui	a5,0x80000
ffffffffc0204700:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        proc = current->parent;
ffffffffc0204702:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204704:	0ec52703          	lw	a4,236(a0)
ffffffffc0204708:	0cf70463          	beq	a4,a5,ffffffffc02047d0 <do_exit+0x13e>
        while (current->cptr != NULL)
ffffffffc020470c:	6018                	ld	a4,0(s0)
                if (initproc->wait_state == WT_CHILD)
ffffffffc020470e:	800005b7          	lui	a1,0x80000
ffffffffc0204712:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        while (current->cptr != NULL)
ffffffffc0204714:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204716:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc0204718:	e789                	bnez	a5,ffffffffc0204722 <do_exit+0x90>
ffffffffc020471a:	a83d                	j	ffffffffc0204758 <do_exit+0xc6>
ffffffffc020471c:	6018                	ld	a4,0(s0)
ffffffffc020471e:	7b7c                	ld	a5,240(a4)
ffffffffc0204720:	cf85                	beqz	a5,ffffffffc0204758 <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc0204722:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204726:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204728:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc020472a:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020472e:	7978                	ld	a4,240(a0)
ffffffffc0204730:	10e7b023          	sd	a4,256(a5)
ffffffffc0204734:	c311                	beqz	a4,ffffffffc0204738 <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc0204736:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204738:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc020473a:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc020473c:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020473e:	fcc71fe3          	bne	a4,a2,ffffffffc020471c <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204742:	0ec52783          	lw	a5,236(a0)
ffffffffc0204746:	fcb79be3          	bne	a5,a1,ffffffffc020471c <do_exit+0x8a>
                    wakeup_proc(initproc);
ffffffffc020474a:	415000ef          	jal	ffffffffc020535e <wakeup_proc>
ffffffffc020474e:	800005b7          	lui	a1,0x80000
ffffffffc0204752:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
ffffffffc0204754:	460d                	li	a2,3
ffffffffc0204756:	b7d9                	j	ffffffffc020471c <do_exit+0x8a>
    if (flag)
ffffffffc0204758:	02091263          	bnez	s2,ffffffffc020477c <do_exit+0xea>
    schedule();
ffffffffc020475c:	497000ef          	jal	ffffffffc02053f2 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204760:	601c                	ld	a5,0(s0)
ffffffffc0204762:	00003617          	auipc	a2,0x3
ffffffffc0204766:	b0660613          	addi	a2,a2,-1274 # ffffffffc0207268 <etext+0x184e>
ffffffffc020476a:	26e00593          	li	a1,622
ffffffffc020476e:	43d4                	lw	a3,4(a5)
ffffffffc0204770:	00003517          	auipc	a0,0x3
ffffffffc0204774:	a9850513          	addi	a0,a0,-1384 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204778:	ccffb0ef          	jal	ffffffffc0200446 <__panic>
        intr_enable();
ffffffffc020477c:	982fc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204780:	bff1                	j	ffffffffc020475c <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc0204782:	00003617          	auipc	a2,0x3
ffffffffc0204786:	ac660613          	addi	a2,a2,-1338 # ffffffffc0207248 <etext+0x182e>
ffffffffc020478a:	23a00593          	li	a1,570
ffffffffc020478e:	00003517          	auipc	a0,0x3
ffffffffc0204792:	a7a50513          	addi	a0,a0,-1414 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204796:	e84a                	sd	s2,16(sp)
ffffffffc0204798:	caffb0ef          	jal	ffffffffc0200446 <__panic>
            exit_mmap(mm);
ffffffffc020479c:	e42a                	sd	a0,8(sp)
ffffffffc020479e:	cc2ff0ef          	jal	ffffffffc0203c60 <exit_mmap>
            put_pgdir(mm);
ffffffffc02047a2:	6522                	ld	a0,8(sp)
ffffffffc02047a4:	a0fff0ef          	jal	ffffffffc02041b2 <put_pgdir>
            mm_destroy(mm);
ffffffffc02047a8:	6522                	ld	a0,8(sp)
ffffffffc02047aa:	964ff0ef          	jal	ffffffffc020390e <mm_destroy>
ffffffffc02047ae:	bf15                	j	ffffffffc02046e2 <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc02047b0:	00003617          	auipc	a2,0x3
ffffffffc02047b4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0207258 <etext+0x183e>
ffffffffc02047b8:	23e00593          	li	a1,574
ffffffffc02047bc:	00003517          	auipc	a0,0x3
ffffffffc02047c0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0207208 <etext+0x17ee>
ffffffffc02047c4:	c83fb0ef          	jal	ffffffffc0200446 <__panic>
        intr_disable();
ffffffffc02047c8:	93cfc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02047cc:	4905                	li	s2,1
ffffffffc02047ce:	b735                	j	ffffffffc02046fa <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc02047d0:	38f000ef          	jal	ffffffffc020535e <wakeup_proc>
ffffffffc02047d4:	bf25                	j	ffffffffc020470c <do_exit+0x7a>

ffffffffc02047d6 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc02047d6:	7179                	addi	sp,sp,-48
ffffffffc02047d8:	ec26                	sd	s1,24(sp)
ffffffffc02047da:	e84a                	sd	s2,16(sp)
ffffffffc02047dc:	e44e                	sd	s3,8(sp)
ffffffffc02047de:	f406                	sd	ra,40(sp)
ffffffffc02047e0:	f022                	sd	s0,32(sp)
ffffffffc02047e2:	84aa                	mv	s1,a0
ffffffffc02047e4:	892e                	mv	s2,a1
ffffffffc02047e6:	00097997          	auipc	s3,0x97
ffffffffc02047ea:	e6a98993          	addi	s3,s3,-406 # ffffffffc029b650 <current>
    if (pid != 0)
ffffffffc02047ee:	cd19                	beqz	a0,ffffffffc020480c <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc02047f0:	6789                	lui	a5,0x2
ffffffffc02047f2:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc02047f4:	fff5071b          	addiw	a4,a0,-1
ffffffffc02047f8:	12e7f563          	bgeu	a5,a4,ffffffffc0204922 <do_wait.part.0+0x14c>
}
ffffffffc02047fc:	70a2                	ld	ra,40(sp)
ffffffffc02047fe:	7402                	ld	s0,32(sp)
ffffffffc0204800:	64e2                	ld	s1,24(sp)
ffffffffc0204802:	6942                	ld	s2,16(sp)
ffffffffc0204804:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc0204806:	5579                	li	a0,-2
}
ffffffffc0204808:	6145                	addi	sp,sp,48
ffffffffc020480a:	8082                	ret
        proc = current->cptr;
ffffffffc020480c:	0009b703          	ld	a4,0(s3)
ffffffffc0204810:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204812:	d46d                	beqz	s0,ffffffffc02047fc <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204814:	468d                	li	a3,3
ffffffffc0204816:	a021                	j	ffffffffc020481e <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204818:	10043403          	ld	s0,256(s0)
ffffffffc020481c:	c075                	beqz	s0,ffffffffc0204900 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020481e:	401c                	lw	a5,0(s0)
ffffffffc0204820:	fed79ce3          	bne	a5,a3,ffffffffc0204818 <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc0204824:	00097797          	auipc	a5,0x97
ffffffffc0204828:	e3c7b783          	ld	a5,-452(a5) # ffffffffc029b660 <idleproc>
ffffffffc020482c:	14878263          	beq	a5,s0,ffffffffc0204970 <do_wait.part.0+0x19a>
ffffffffc0204830:	00097797          	auipc	a5,0x97
ffffffffc0204834:	e287b783          	ld	a5,-472(a5) # ffffffffc029b658 <initproc>
ffffffffc0204838:	12f40c63          	beq	s0,a5,ffffffffc0204970 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc020483c:	00090663          	beqz	s2,ffffffffc0204848 <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc0204840:	0e842783          	lw	a5,232(s0)
ffffffffc0204844:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204848:	100027f3          	csrr	a5,sstatus
ffffffffc020484c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020484e:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204850:	10079963          	bnez	a5,ffffffffc0204962 <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204854:	6c74                	ld	a3,216(s0)
ffffffffc0204856:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc0204858:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc020485c:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc020485e:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204860:	6474                	ld	a3,200(s0)
ffffffffc0204862:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc0204864:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204866:	e314                	sd	a3,0(a4)
ffffffffc0204868:	c789                	beqz	a5,ffffffffc0204872 <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc020486a:	7c78                	ld	a4,248(s0)
ffffffffc020486c:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc020486e:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc0204872:	7c78                	ld	a4,248(s0)
ffffffffc0204874:	c36d                	beqz	a4,ffffffffc0204956 <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc0204876:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc020487a:	00097797          	auipc	a5,0x97
ffffffffc020487e:	dd27a783          	lw	a5,-558(a5) # ffffffffc029b64c <nr_process>
ffffffffc0204882:	37fd                	addiw	a5,a5,-1
ffffffffc0204884:	00097717          	auipc	a4,0x97
ffffffffc0204888:	dcf72423          	sw	a5,-568(a4) # ffffffffc029b64c <nr_process>
    if (flag)
ffffffffc020488c:	e271                	bnez	a2,ffffffffc0204950 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020488e:	6814                	ld	a3,16(s0)
ffffffffc0204890:	c02007b7          	lui	a5,0xc0200
ffffffffc0204894:	10f6e663          	bltu	a3,a5,ffffffffc02049a0 <do_wait.part.0+0x1ca>
ffffffffc0204898:	00097717          	auipc	a4,0x97
ffffffffc020489c:	d9873703          	ld	a4,-616(a4) # ffffffffc029b630 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc02048a0:	00097797          	auipc	a5,0x97
ffffffffc02048a4:	d987b783          	ld	a5,-616(a5) # ffffffffc029b638 <npage>
    return pa2page(PADDR(kva));
ffffffffc02048a8:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc02048aa:	82b1                	srli	a3,a3,0xc
ffffffffc02048ac:	0cf6fe63          	bgeu	a3,a5,ffffffffc0204988 <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc02048b0:	00003797          	auipc	a5,0x3
ffffffffc02048b4:	2e07b783          	ld	a5,736(a5) # ffffffffc0207b90 <nbase>
ffffffffc02048b8:	00097517          	auipc	a0,0x97
ffffffffc02048bc:	d8853503          	ld	a0,-632(a0) # ffffffffc029b640 <pages>
ffffffffc02048c0:	4589                	li	a1,2
ffffffffc02048c2:	8e9d                	sub	a3,a3,a5
ffffffffc02048c4:	069a                	slli	a3,a3,0x6
ffffffffc02048c6:	9536                	add	a0,a0,a3
ffffffffc02048c8:	e98fd0ef          	jal	ffffffffc0201f60 <free_pages>
    kfree(proc);
ffffffffc02048cc:	8522                	mv	a0,s0
ffffffffc02048ce:	d3cfd0ef          	jal	ffffffffc0201e0a <kfree>
}
ffffffffc02048d2:	70a2                	ld	ra,40(sp)
ffffffffc02048d4:	7402                	ld	s0,32(sp)
ffffffffc02048d6:	64e2                	ld	s1,24(sp)
ffffffffc02048d8:	6942                	ld	s2,16(sp)
ffffffffc02048da:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc02048dc:	4501                	li	a0,0
}
ffffffffc02048de:	6145                	addi	sp,sp,48
ffffffffc02048e0:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02048e2:	00097997          	auipc	s3,0x97
ffffffffc02048e6:	d6e98993          	addi	s3,s3,-658 # ffffffffc029b650 <current>
ffffffffc02048ea:	0009b703          	ld	a4,0(s3)
ffffffffc02048ee:	f487b683          	ld	a3,-184(a5)
ffffffffc02048f2:	f0e695e3          	bne	a3,a4,ffffffffc02047fc <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02048f6:	f287a603          	lw	a2,-216(a5)
ffffffffc02048fa:	468d                	li	a3,3
ffffffffc02048fc:	06d60063          	beq	a2,a3,ffffffffc020495c <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc0204900:	800007b7          	lui	a5,0x80000
ffffffffc0204904:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        current->state = PROC_SLEEPING;
ffffffffc0204906:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc0204908:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc020490c:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc020490e:	2e5000ef          	jal	ffffffffc02053f2 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204912:	0009b783          	ld	a5,0(s3)
ffffffffc0204916:	0b07a783          	lw	a5,176(a5)
ffffffffc020491a:	8b85                	andi	a5,a5,1
ffffffffc020491c:	e7b9                	bnez	a5,ffffffffc020496a <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc020491e:	ee0487e3          	beqz	s1,ffffffffc020480c <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204922:	45a9                	li	a1,10
ffffffffc0204924:	8526                	mv	a0,s1
ffffffffc0204926:	435000ef          	jal	ffffffffc020555a <hash32>
ffffffffc020492a:	02051793          	slli	a5,a0,0x20
ffffffffc020492e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204932:	00093797          	auipc	a5,0x93
ffffffffc0204936:	c9e78793          	addi	a5,a5,-866 # ffffffffc02975d0 <hash_list>
ffffffffc020493a:	953e                	add	a0,a0,a5
ffffffffc020493c:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc020493e:	a029                	j	ffffffffc0204948 <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc0204940:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204944:	f8970fe3          	beq	a4,s1,ffffffffc02048e2 <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc0204948:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020494a:	fef51be3          	bne	a0,a5,ffffffffc0204940 <do_wait.part.0+0x16a>
ffffffffc020494e:	b57d                	j	ffffffffc02047fc <do_wait.part.0+0x26>
        intr_enable();
ffffffffc0204950:	faffb0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204954:	bf2d                	j	ffffffffc020488e <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc0204956:	7018                	ld	a4,32(s0)
ffffffffc0204958:	fb7c                	sd	a5,240(a4)
ffffffffc020495a:	b705                	j	ffffffffc020487a <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020495c:	f2878413          	addi	s0,a5,-216
ffffffffc0204960:	b5d1                	j	ffffffffc0204824 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc0204962:	fa3fb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204966:	4605                	li	a2,1
ffffffffc0204968:	b5f5                	j	ffffffffc0204854 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc020496a:	555d                	li	a0,-9
ffffffffc020496c:	d27ff0ef          	jal	ffffffffc0204692 <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc0204970:	00003617          	auipc	a2,0x3
ffffffffc0204974:	91860613          	addi	a2,a2,-1768 # ffffffffc0207288 <etext+0x186e>
ffffffffc0204978:	3b000593          	li	a1,944
ffffffffc020497c:	00003517          	auipc	a0,0x3
ffffffffc0204980:	88c50513          	addi	a0,a0,-1908 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204984:	ac3fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204988:	00002617          	auipc	a2,0x2
ffffffffc020498c:	f1860613          	addi	a2,a2,-232 # ffffffffc02068a0 <etext+0xe86>
ffffffffc0204990:	06900593          	li	a1,105
ffffffffc0204994:	00002517          	auipc	a0,0x2
ffffffffc0204998:	e6450513          	addi	a0,a0,-412 # ffffffffc02067f8 <etext+0xdde>
ffffffffc020499c:	aabfb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02049a0:	00002617          	auipc	a2,0x2
ffffffffc02049a4:	ed860613          	addi	a2,a2,-296 # ffffffffc0206878 <etext+0xe5e>
ffffffffc02049a8:	07700593          	li	a1,119
ffffffffc02049ac:	00002517          	auipc	a0,0x2
ffffffffc02049b0:	e4c50513          	addi	a0,a0,-436 # ffffffffc02067f8 <etext+0xdde>
ffffffffc02049b4:	a93fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02049b8 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02049b8:	1141                	addi	sp,sp,-16
ffffffffc02049ba:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02049bc:	ddcfd0ef          	jal	ffffffffc0201f98 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02049c0:	ba0fd0ef          	jal	ffffffffc0201d60 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc02049c4:	4601                	li	a2,0
ffffffffc02049c6:	4581                	li	a1,0
ffffffffc02049c8:	fffff517          	auipc	a0,0xfffff
ffffffffc02049cc:	76c50513          	addi	a0,a0,1900 # ffffffffc0204134 <user_main>
ffffffffc02049d0:	c73ff0ef          	jal	ffffffffc0204642 <kernel_thread>
    if (pid <= 0)
ffffffffc02049d4:	00a04563          	bgtz	a0,ffffffffc02049de <init_main+0x26>
ffffffffc02049d8:	a071                	j	ffffffffc0204a64 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02049da:	219000ef          	jal	ffffffffc02053f2 <schedule>
    if (code_store != NULL)
ffffffffc02049de:	4581                	li	a1,0
ffffffffc02049e0:	4501                	li	a0,0
ffffffffc02049e2:	df5ff0ef          	jal	ffffffffc02047d6 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02049e6:	d975                	beqz	a0,ffffffffc02049da <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02049e8:	00003517          	auipc	a0,0x3
ffffffffc02049ec:	8e050513          	addi	a0,a0,-1824 # ffffffffc02072c8 <etext+0x18ae>
ffffffffc02049f0:	fa4fb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02049f4:	00097797          	auipc	a5,0x97
ffffffffc02049f8:	c647b783          	ld	a5,-924(a5) # ffffffffc029b658 <initproc>
ffffffffc02049fc:	7bf8                	ld	a4,240(a5)
ffffffffc02049fe:	e339                	bnez	a4,ffffffffc0204a44 <init_main+0x8c>
ffffffffc0204a00:	7ff8                	ld	a4,248(a5)
ffffffffc0204a02:	e329                	bnez	a4,ffffffffc0204a44 <init_main+0x8c>
ffffffffc0204a04:	1007b703          	ld	a4,256(a5)
ffffffffc0204a08:	ef15                	bnez	a4,ffffffffc0204a44 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204a0a:	00097697          	auipc	a3,0x97
ffffffffc0204a0e:	c426a683          	lw	a3,-958(a3) # ffffffffc029b64c <nr_process>
ffffffffc0204a12:	4709                	li	a4,2
ffffffffc0204a14:	0ae69463          	bne	a3,a4,ffffffffc0204abc <init_main+0x104>
ffffffffc0204a18:	00097697          	auipc	a3,0x97
ffffffffc0204a1c:	bb868693          	addi	a3,a3,-1096 # ffffffffc029b5d0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a20:	6698                	ld	a4,8(a3)
ffffffffc0204a22:	0c878793          	addi	a5,a5,200
ffffffffc0204a26:	06f71b63          	bne	a4,a5,ffffffffc0204a9c <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a2a:	629c                	ld	a5,0(a3)
ffffffffc0204a2c:	04f71863          	bne	a4,a5,ffffffffc0204a7c <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204a30:	00003517          	auipc	a0,0x3
ffffffffc0204a34:	98050513          	addi	a0,a0,-1664 # ffffffffc02073b0 <etext+0x1996>
ffffffffc0204a38:	f5cfb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204a3c:	60a2                	ld	ra,8(sp)
ffffffffc0204a3e:	4501                	li	a0,0
ffffffffc0204a40:	0141                	addi	sp,sp,16
ffffffffc0204a42:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a44:	00003697          	auipc	a3,0x3
ffffffffc0204a48:	8ac68693          	addi	a3,a3,-1876 # ffffffffc02072f0 <etext+0x18d6>
ffffffffc0204a4c:	00002617          	auipc	a2,0x2
ffffffffc0204a50:	9d460613          	addi	a2,a2,-1580 # ffffffffc0206420 <etext+0xa06>
ffffffffc0204a54:	41e00593          	li	a1,1054
ffffffffc0204a58:	00002517          	auipc	a0,0x2
ffffffffc0204a5c:	7b050513          	addi	a0,a0,1968 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204a60:	9e7fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204a64:	00003617          	auipc	a2,0x3
ffffffffc0204a68:	84460613          	addi	a2,a2,-1980 # ffffffffc02072a8 <etext+0x188e>
ffffffffc0204a6c:	41500593          	li	a1,1045
ffffffffc0204a70:	00002517          	auipc	a0,0x2
ffffffffc0204a74:	79850513          	addi	a0,a0,1944 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204a78:	9cffb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a7c:	00003697          	auipc	a3,0x3
ffffffffc0204a80:	90468693          	addi	a3,a3,-1788 # ffffffffc0207380 <etext+0x1966>
ffffffffc0204a84:	00002617          	auipc	a2,0x2
ffffffffc0204a88:	99c60613          	addi	a2,a2,-1636 # ffffffffc0206420 <etext+0xa06>
ffffffffc0204a8c:	42100593          	li	a1,1057
ffffffffc0204a90:	00002517          	auipc	a0,0x2
ffffffffc0204a94:	77850513          	addi	a0,a0,1912 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204a98:	9affb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a9c:	00003697          	auipc	a3,0x3
ffffffffc0204aa0:	8b468693          	addi	a3,a3,-1868 # ffffffffc0207350 <etext+0x1936>
ffffffffc0204aa4:	00002617          	auipc	a2,0x2
ffffffffc0204aa8:	97c60613          	addi	a2,a2,-1668 # ffffffffc0206420 <etext+0xa06>
ffffffffc0204aac:	42000593          	li	a1,1056
ffffffffc0204ab0:	00002517          	auipc	a0,0x2
ffffffffc0204ab4:	75850513          	addi	a0,a0,1880 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204ab8:	98ffb0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_process == 2);
ffffffffc0204abc:	00003697          	auipc	a3,0x3
ffffffffc0204ac0:	88468693          	addi	a3,a3,-1916 # ffffffffc0207340 <etext+0x1926>
ffffffffc0204ac4:	00002617          	auipc	a2,0x2
ffffffffc0204ac8:	95c60613          	addi	a2,a2,-1700 # ffffffffc0206420 <etext+0xa06>
ffffffffc0204acc:	41f00593          	li	a1,1055
ffffffffc0204ad0:	00002517          	auipc	a0,0x2
ffffffffc0204ad4:	73850513          	addi	a0,a0,1848 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204ad8:	96ffb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204adc <do_execve>:
{
ffffffffc0204adc:	7171                	addi	sp,sp,-176
ffffffffc0204ade:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204ae0:	00097d17          	auipc	s10,0x97
ffffffffc0204ae4:	b70d0d13          	addi	s10,s10,-1168 # ffffffffc029b650 <current>
ffffffffc0204ae8:	000d3783          	ld	a5,0(s10)
{
ffffffffc0204aec:	e94a                	sd	s2,144(sp)
ffffffffc0204aee:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204af0:	0287b903          	ld	s2,40(a5)
{
ffffffffc0204af4:	84ae                	mv	s1,a1
ffffffffc0204af6:	e54e                	sd	s3,136(sp)
ffffffffc0204af8:	ec32                	sd	a2,24(sp)
ffffffffc0204afa:	89aa                	mv	s3,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204afc:	85aa                	mv	a1,a0
ffffffffc0204afe:	8626                	mv	a2,s1
ffffffffc0204b00:	854a                	mv	a0,s2
ffffffffc0204b02:	4681                	li	a3,0
{
ffffffffc0204b04:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b06:	cf2ff0ef          	jal	ffffffffc0203ff8 <user_mem_check>
ffffffffc0204b0a:	46050f63          	beqz	a0,ffffffffc0204f88 <do_execve+0x4ac>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b0e:	4641                	li	a2,16
ffffffffc0204b10:	1808                	addi	a0,sp,48
ffffffffc0204b12:	4581                	li	a1,0
ffffffffc0204b14:	6dd000ef          	jal	ffffffffc02059f0 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204b18:	47bd                	li	a5,15
ffffffffc0204b1a:	8626                	mv	a2,s1
ffffffffc0204b1c:	0e97ef63          	bltu	a5,s1,ffffffffc0204c1a <do_execve+0x13e>
    memcpy(local_name, name, len);
ffffffffc0204b20:	85ce                	mv	a1,s3
ffffffffc0204b22:	1808                	addi	a0,sp,48
ffffffffc0204b24:	6df000ef          	jal	ffffffffc0205a02 <memcpy>
    if (mm != NULL)
ffffffffc0204b28:	10090063          	beqz	s2,ffffffffc0204c28 <do_execve+0x14c>
        cputs("mm != NULL");
ffffffffc0204b2c:	00002517          	auipc	a0,0x2
ffffffffc0204b30:	49c50513          	addi	a0,a0,1180 # ffffffffc0206fc8 <etext+0x15ae>
ffffffffc0204b34:	e96fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc0204b38:	00097797          	auipc	a5,0x97
ffffffffc0204b3c:	ae87b783          	ld	a5,-1304(a5) # ffffffffc029b620 <boot_pgdir_pa>
ffffffffc0204b40:	577d                	li	a4,-1
ffffffffc0204b42:	177e                	slli	a4,a4,0x3f
ffffffffc0204b44:	83b1                	srli	a5,a5,0xc
ffffffffc0204b46:	8fd9                	or	a5,a5,a4
ffffffffc0204b48:	18079073          	csrw	satp,a5
ffffffffc0204b4c:	03092783          	lw	a5,48(s2)
ffffffffc0204b50:	37fd                	addiw	a5,a5,-1
ffffffffc0204b52:	02f92823          	sw	a5,48(s2)
        if (mm_count_dec(mm) == 0)
ffffffffc0204b56:	30078563          	beqz	a5,ffffffffc0204e60 <do_execve+0x384>
        current->mm = NULL;
ffffffffc0204b5a:	000d3783          	ld	a5,0(s10)
ffffffffc0204b5e:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204b62:	c6ffe0ef          	jal	ffffffffc02037d0 <mm_create>
ffffffffc0204b66:	892a                	mv	s2,a0
ffffffffc0204b68:	22050063          	beqz	a0,ffffffffc0204d88 <do_execve+0x2ac>
    if ((page = alloc_page()) == NULL)
ffffffffc0204b6c:	4505                	li	a0,1
ffffffffc0204b6e:	bb8fd0ef          	jal	ffffffffc0201f26 <alloc_pages>
ffffffffc0204b72:	42050063          	beqz	a0,ffffffffc0204f92 <do_execve+0x4b6>
    return page - pages + nbase;
ffffffffc0204b76:	f0e2                	sd	s8,96(sp)
ffffffffc0204b78:	00097c17          	auipc	s8,0x97
ffffffffc0204b7c:	ac8c0c13          	addi	s8,s8,-1336 # ffffffffc029b640 <pages>
ffffffffc0204b80:	000c3783          	ld	a5,0(s8)
ffffffffc0204b84:	f4de                	sd	s7,104(sp)
ffffffffc0204b86:	00003b97          	auipc	s7,0x3
ffffffffc0204b8a:	00abbb83          	ld	s7,10(s7) # ffffffffc0207b90 <nbase>
ffffffffc0204b8e:	40f506b3          	sub	a3,a0,a5
ffffffffc0204b92:	ece6                	sd	s9,88(sp)
    return KADDR(page2pa(page));
ffffffffc0204b94:	00097c97          	auipc	s9,0x97
ffffffffc0204b98:	aa4c8c93          	addi	s9,s9,-1372 # ffffffffc029b638 <npage>
ffffffffc0204b9c:	f8da                	sd	s6,112(sp)
    return page - pages + nbase;
ffffffffc0204b9e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204ba0:	5b7d                	li	s6,-1
ffffffffc0204ba2:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc0204ba6:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204ba8:	00cb5713          	srli	a4,s6,0xc
ffffffffc0204bac:	e83a                	sd	a4,16(sp)
ffffffffc0204bae:	fcd6                	sd	s5,120(sp)
ffffffffc0204bb0:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bb2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bb4:	40f77263          	bgeu	a4,a5,ffffffffc0204fb8 <do_execve+0x4dc>
ffffffffc0204bb8:	00097a97          	auipc	s5,0x97
ffffffffc0204bbc:	a78a8a93          	addi	s5,s5,-1416 # ffffffffc029b630 <va_pa_offset>
ffffffffc0204bc0:	000ab783          	ld	a5,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204bc4:	00097597          	auipc	a1,0x97
ffffffffc0204bc8:	a645b583          	ld	a1,-1436(a1) # ffffffffc029b628 <boot_pgdir_va>
ffffffffc0204bcc:	6605                	lui	a2,0x1
ffffffffc0204bce:	00f684b3          	add	s1,a3,a5
ffffffffc0204bd2:	8526                	mv	a0,s1
ffffffffc0204bd4:	62f000ef          	jal	ffffffffc0205a02 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204bd8:	66e2                	ld	a3,24(sp)
ffffffffc0204bda:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204bde:	00993c23          	sd	s1,24(s2)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204be2:	4298                	lw	a4,0(a3)
ffffffffc0204be4:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464ba3c7>
ffffffffc0204be8:	06f70863          	beq	a4,a5,ffffffffc0204c58 <do_execve+0x17c>
        ret = -E_INVAL_ELF;
ffffffffc0204bec:	54e1                	li	s1,-8
    put_pgdir(mm);
ffffffffc0204bee:	854a                	mv	a0,s2
ffffffffc0204bf0:	dc2ff0ef          	jal	ffffffffc02041b2 <put_pgdir>
ffffffffc0204bf4:	7ae6                	ld	s5,120(sp)
ffffffffc0204bf6:	7b46                	ld	s6,112(sp)
ffffffffc0204bf8:	7ba6                	ld	s7,104(sp)
ffffffffc0204bfa:	7c06                	ld	s8,96(sp)
ffffffffc0204bfc:	6ce6                	ld	s9,88(sp)
    mm_destroy(mm);
ffffffffc0204bfe:	854a                	mv	a0,s2
ffffffffc0204c00:	d0ffe0ef          	jal	ffffffffc020390e <mm_destroy>
    do_exit(ret);
ffffffffc0204c04:	8526                	mv	a0,s1
ffffffffc0204c06:	f122                	sd	s0,160(sp)
ffffffffc0204c08:	e152                	sd	s4,128(sp)
ffffffffc0204c0a:	fcd6                	sd	s5,120(sp)
ffffffffc0204c0c:	f8da                	sd	s6,112(sp)
ffffffffc0204c0e:	f4de                	sd	s7,104(sp)
ffffffffc0204c10:	f0e2                	sd	s8,96(sp)
ffffffffc0204c12:	ece6                	sd	s9,88(sp)
ffffffffc0204c14:	e4ee                	sd	s11,72(sp)
ffffffffc0204c16:	a7dff0ef          	jal	ffffffffc0204692 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204c1a:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204c1c:	85ce                	mv	a1,s3
ffffffffc0204c1e:	1808                	addi	a0,sp,48
ffffffffc0204c20:	5e3000ef          	jal	ffffffffc0205a02 <memcpy>
    if (mm != NULL)
ffffffffc0204c24:	f00914e3          	bnez	s2,ffffffffc0204b2c <do_execve+0x50>
    if (current->mm != NULL)
ffffffffc0204c28:	000d3783          	ld	a5,0(s10)
ffffffffc0204c2c:	779c                	ld	a5,40(a5)
ffffffffc0204c2e:	db95                	beqz	a5,ffffffffc0204b62 <do_execve+0x86>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c30:	00002617          	auipc	a2,0x2
ffffffffc0204c34:	7a060613          	addi	a2,a2,1952 # ffffffffc02073d0 <etext+0x19b6>
ffffffffc0204c38:	27d00593          	li	a1,637
ffffffffc0204c3c:	00002517          	auipc	a0,0x2
ffffffffc0204c40:	5cc50513          	addi	a0,a0,1484 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204c44:	f122                	sd	s0,160(sp)
ffffffffc0204c46:	e152                	sd	s4,128(sp)
ffffffffc0204c48:	fcd6                	sd	s5,120(sp)
ffffffffc0204c4a:	f8da                	sd	s6,112(sp)
ffffffffc0204c4c:	f4de                	sd	s7,104(sp)
ffffffffc0204c4e:	f0e2                	sd	s8,96(sp)
ffffffffc0204c50:	ece6                	sd	s9,88(sp)
ffffffffc0204c52:	e4ee                	sd	s11,72(sp)
ffffffffc0204c54:	ff2fb0ef          	jal	ffffffffc0200446 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c58:	0386d703          	lhu	a4,56(a3)
ffffffffc0204c5c:	e152                	sd	s4,128(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c5e:	0206ba03          	ld	s4,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c62:	00371793          	slli	a5,a4,0x3
ffffffffc0204c66:	8f99                	sub	a5,a5,a4
ffffffffc0204c68:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c6a:	9a36                	add	s4,s4,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c6c:	97d2                	add	a5,a5,s4
ffffffffc0204c6e:	f122                	sd	s0,160(sp)
ffffffffc0204c70:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204c72:	00fa7e63          	bgeu	s4,a5,ffffffffc0204c8e <do_execve+0x1b2>
ffffffffc0204c76:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204c78:	000a2783          	lw	a5,0(s4)
ffffffffc0204c7c:	4705                	li	a4,1
ffffffffc0204c7e:	10e78763          	beq	a5,a4,ffffffffc0204d8c <do_execve+0x2b0>
    for (; ph < ph_end; ph++)
ffffffffc0204c82:	77a2                	ld	a5,40(sp)
ffffffffc0204c84:	038a0a13          	addi	s4,s4,56
ffffffffc0204c88:	fefa68e3          	bltu	s4,a5,ffffffffc0204c78 <do_execve+0x19c>
ffffffffc0204c8c:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204c8e:	4701                	li	a4,0
ffffffffc0204c90:	46ad                	li	a3,11
ffffffffc0204c92:	00100637          	lui	a2,0x100
ffffffffc0204c96:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204c9a:	854a                	mv	a0,s2
ffffffffc0204c9c:	e61fe0ef          	jal	ffffffffc0203afc <mm_map>
ffffffffc0204ca0:	84aa                	mv	s1,a0
ffffffffc0204ca2:	1a051963          	bnez	a0,ffffffffc0204e54 <do_execve+0x378>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204ca6:	01893503          	ld	a0,24(s2)
ffffffffc0204caa:	467d                	li	a2,31
ffffffffc0204cac:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204cb0:	a3ffe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204cb4:	3a050163          	beqz	a0,ffffffffc0205056 <do_execve+0x57a>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cb8:	01893503          	ld	a0,24(s2)
ffffffffc0204cbc:	467d                	li	a2,31
ffffffffc0204cbe:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204cc2:	a2dfe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204cc6:	36050763          	beqz	a0,ffffffffc0205034 <do_execve+0x558>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cca:	01893503          	ld	a0,24(s2)
ffffffffc0204cce:	467d                	li	a2,31
ffffffffc0204cd0:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204cd4:	a1bfe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204cd8:	32050d63          	beqz	a0,ffffffffc0205012 <do_execve+0x536>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cdc:	01893503          	ld	a0,24(s2)
ffffffffc0204ce0:	467d                	li	a2,31
ffffffffc0204ce2:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204ce6:	a09fe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204cea:	30050363          	beqz	a0,ffffffffc0204ff0 <do_execve+0x514>
    mm->mm_count += 1;
ffffffffc0204cee:	03092783          	lw	a5,48(s2)
    current->mm = mm;
ffffffffc0204cf2:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cf6:	01893683          	ld	a3,24(s2)
ffffffffc0204cfa:	2785                	addiw	a5,a5,1
ffffffffc0204cfc:	02f92823          	sw	a5,48(s2)
    current->mm = mm;
ffffffffc0204d00:	03263423          	sd	s2,40(a2) # 100028 <_binary_obj___user_exit_out_size+0xf5e70>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204d04:	c02007b7          	lui	a5,0xc0200
ffffffffc0204d08:	2cf6e763          	bltu	a3,a5,ffffffffc0204fd6 <do_execve+0x4fa>
ffffffffc0204d0c:	000ab783          	ld	a5,0(s5)
ffffffffc0204d10:	577d                	li	a4,-1
ffffffffc0204d12:	177e                	slli	a4,a4,0x3f
ffffffffc0204d14:	8e9d                	sub	a3,a3,a5
ffffffffc0204d16:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204d1a:	f654                	sd	a3,168(a2)
ffffffffc0204d1c:	8fd9                	or	a5,a5,a4
ffffffffc0204d1e:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204d22:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d24:	4581                	li	a1,0
ffffffffc0204d26:	12000613          	li	a2,288
ffffffffc0204d2a:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204d2c:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d30:	4c1000ef          	jal	ffffffffc02059f0 <memset>
    tf->epc = elf->e_entry;      // ELF 程序入口，sret 会跳转到这里执行指令
ffffffffc0204d34:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d36:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d3a:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;      // ELF 程序入口，sret 会跳转到这里执行指令
ffffffffc0204d3e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;      // 设置用户栈顶
ffffffffc0204d40:	4785                	li	a5,1
ffffffffc0204d42:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d44:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry;      // ELF 程序入口，sret 会跳转到这里执行指令
ffffffffc0204d48:	10e43423          	sd	a4,264(s0)
    tf->gpr.sp = USTACKTOP;      // 设置用户栈顶
ffffffffc0204d4c:	e81c                	sd	a5,16(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d4e:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d52:	4641                	li	a2,16
ffffffffc0204d54:	4581                	li	a1,0
ffffffffc0204d56:	0b498513          	addi	a0,s3,180
ffffffffc0204d5a:	497000ef          	jal	ffffffffc02059f0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d5e:	180c                	addi	a1,sp,48
ffffffffc0204d60:	0b498513          	addi	a0,s3,180
ffffffffc0204d64:	463d                	li	a2,15
ffffffffc0204d66:	49d000ef          	jal	ffffffffc0205a02 <memcpy>
ffffffffc0204d6a:	740a                	ld	s0,160(sp)
ffffffffc0204d6c:	6a0a                	ld	s4,128(sp)
ffffffffc0204d6e:	7ae6                	ld	s5,120(sp)
ffffffffc0204d70:	7b46                	ld	s6,112(sp)
ffffffffc0204d72:	7ba6                	ld	s7,104(sp)
ffffffffc0204d74:	7c06                	ld	s8,96(sp)
ffffffffc0204d76:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204d78:	70aa                	ld	ra,168(sp)
ffffffffc0204d7a:	694a                	ld	s2,144(sp)
ffffffffc0204d7c:	69aa                	ld	s3,136(sp)
ffffffffc0204d7e:	6d46                	ld	s10,80(sp)
ffffffffc0204d80:	8526                	mv	a0,s1
ffffffffc0204d82:	64ea                	ld	s1,152(sp)
ffffffffc0204d84:	614d                	addi	sp,sp,176
ffffffffc0204d86:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204d88:	54f1                	li	s1,-4
ffffffffc0204d8a:	bdad                	j	ffffffffc0204c04 <do_execve+0x128>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204d8c:	028a3603          	ld	a2,40(s4)
ffffffffc0204d90:	020a3783          	ld	a5,32(s4)
ffffffffc0204d94:	20f66363          	bltu	a2,a5,ffffffffc0204f9a <do_execve+0x4be>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204d98:	004a2783          	lw	a5,4(s4)
ffffffffc0204d9c:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204da0:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204da4:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204da6:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204da8:	c6f1                	beqz	a3,ffffffffc0204e74 <do_execve+0x398>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204daa:	1c079763          	bnez	a5,ffffffffc0204f78 <do_execve+0x49c>
            perm |= (PTE_W | PTE_R);
ffffffffc0204dae:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204db0:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204db4:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204db6:	c709                	beqz	a4,ffffffffc0204dc0 <do_execve+0x2e4>
            perm |= PTE_X;
ffffffffc0204db8:	67a2                	ld	a5,8(sp)
ffffffffc0204dba:	0087e793          	ori	a5,a5,8
ffffffffc0204dbe:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204dc0:	010a3583          	ld	a1,16(s4)
ffffffffc0204dc4:	4701                	li	a4,0
ffffffffc0204dc6:	854a                	mv	a0,s2
ffffffffc0204dc8:	d35fe0ef          	jal	ffffffffc0203afc <mm_map>
ffffffffc0204dcc:	84aa                	mv	s1,a0
ffffffffc0204dce:	1c051463          	bnez	a0,ffffffffc0204f96 <do_execve+0x4ba>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204dd2:	010a3b03          	ld	s6,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204dd6:	020a3483          	ld	s1,32(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204dda:	77fd                	lui	a5,0xfffff
ffffffffc0204ddc:	00fb75b3          	and	a1,s6,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204de0:	94da                	add	s1,s1,s6
        while (start < end)
ffffffffc0204de2:	1a9b7563          	bgeu	s6,s1,ffffffffc0204f8c <do_execve+0x4b0>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204de6:	008a3983          	ld	s3,8(s4)
ffffffffc0204dea:	67e2                	ld	a5,24(sp)
ffffffffc0204dec:	99be                	add	s3,s3,a5
ffffffffc0204dee:	a881                	j	ffffffffc0204e3e <do_execve+0x362>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204df0:	6785                	lui	a5,0x1
ffffffffc0204df2:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204df6:	41648633          	sub	a2,s1,s6
            if (end < la)
ffffffffc0204dfa:	01b4e463          	bltu	s1,s11,ffffffffc0204e02 <do_execve+0x326>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204dfe:	416d8633          	sub	a2,s11,s6
    return page - pages + nbase;
ffffffffc0204e02:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204e06:	67c2                	ld	a5,16(sp)
ffffffffc0204e08:	000cb503          	ld	a0,0(s9)
    return page - pages + nbase;
ffffffffc0204e0c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e10:	8699                	srai	a3,a3,0x6
ffffffffc0204e12:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204e14:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e18:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e1a:	18a87363          	bgeu	a6,a0,ffffffffc0204fa0 <do_execve+0x4c4>
ffffffffc0204e1e:	000ab503          	ld	a0,0(s5)
ffffffffc0204e22:	40bb05b3          	sub	a1,s6,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e26:	e032                	sd	a2,0(sp)
ffffffffc0204e28:	9536                	add	a0,a0,a3
ffffffffc0204e2a:	952e                	add	a0,a0,a1
ffffffffc0204e2c:	85ce                	mv	a1,s3
ffffffffc0204e2e:	3d5000ef          	jal	ffffffffc0205a02 <memcpy>
            start += size, from += size;
ffffffffc0204e32:	6602                	ld	a2,0(sp)
ffffffffc0204e34:	9b32                	add	s6,s6,a2
ffffffffc0204e36:	99b2                	add	s3,s3,a2
        while (start < end)
ffffffffc0204e38:	049b7563          	bgeu	s6,s1,ffffffffc0204e82 <do_execve+0x3a6>
ffffffffc0204e3c:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e3e:	01893503          	ld	a0,24(s2)
ffffffffc0204e42:	6622                	ld	a2,8(sp)
ffffffffc0204e44:	e02e                	sd	a1,0(sp)
ffffffffc0204e46:	8a9fe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204e4a:	6582                	ld	a1,0(sp)
ffffffffc0204e4c:	842a                	mv	s0,a0
ffffffffc0204e4e:	f14d                	bnez	a0,ffffffffc0204df0 <do_execve+0x314>
ffffffffc0204e50:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204e52:	54f1                	li	s1,-4
    exit_mmap(mm);
ffffffffc0204e54:	854a                	mv	a0,s2
ffffffffc0204e56:	e0bfe0ef          	jal	ffffffffc0203c60 <exit_mmap>
ffffffffc0204e5a:	740a                	ld	s0,160(sp)
ffffffffc0204e5c:	6a0a                	ld	s4,128(sp)
ffffffffc0204e5e:	bb41                	j	ffffffffc0204bee <do_execve+0x112>
            exit_mmap(mm);
ffffffffc0204e60:	854a                	mv	a0,s2
ffffffffc0204e62:	dfffe0ef          	jal	ffffffffc0203c60 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e66:	854a                	mv	a0,s2
ffffffffc0204e68:	b4aff0ef          	jal	ffffffffc02041b2 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204e6c:	854a                	mv	a0,s2
ffffffffc0204e6e:	aa1fe0ef          	jal	ffffffffc020390e <mm_destroy>
ffffffffc0204e72:	b1e5                	j	ffffffffc0204b5a <do_execve+0x7e>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e74:	0e078e63          	beqz	a5,ffffffffc0204f70 <do_execve+0x494>
            perm |= PTE_R;
ffffffffc0204e78:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204e7a:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204e7e:	e43e                	sd	a5,8(sp)
ffffffffc0204e80:	bf1d                	j	ffffffffc0204db6 <do_execve+0x2da>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204e82:	010a3483          	ld	s1,16(s4)
ffffffffc0204e86:	028a3683          	ld	a3,40(s4)
ffffffffc0204e8a:	94b6                	add	s1,s1,a3
        if (start < la)
ffffffffc0204e8c:	07bb7c63          	bgeu	s6,s11,ffffffffc0204f04 <do_execve+0x428>
            if (start == end)
ffffffffc0204e90:	df6489e3          	beq	s1,s6,ffffffffc0204c82 <do_execve+0x1a6>
                size -= la - end;
ffffffffc0204e94:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204e98:	0fb4f563          	bgeu	s1,s11,ffffffffc0204f82 <do_execve+0x4a6>
    return page - pages + nbase;
ffffffffc0204e9c:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204ea0:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0204ea4:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ea8:	8699                	srai	a3,a3,0x6
ffffffffc0204eaa:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204eac:	00c69593          	slli	a1,a3,0xc
ffffffffc0204eb0:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204eb2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204eb4:	0ec5f663          	bgeu	a1,a2,ffffffffc0204fa0 <do_execve+0x4c4>
ffffffffc0204eb8:	000ab603          	ld	a2,0(s5)
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204ebc:	6505                	lui	a0,0x1
ffffffffc0204ebe:	955a                	add	a0,a0,s6
ffffffffc0204ec0:	96b2                	add	a3,a3,a2
ffffffffc0204ec2:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ec6:	9536                	add	a0,a0,a3
ffffffffc0204ec8:	864e                	mv	a2,s3
ffffffffc0204eca:	4581                	li	a1,0
ffffffffc0204ecc:	325000ef          	jal	ffffffffc02059f0 <memset>
            start += size;
ffffffffc0204ed0:	9b4e                	add	s6,s6,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204ed2:	01b4b6b3          	sltu	a3,s1,s11
ffffffffc0204ed6:	01b4f463          	bgeu	s1,s11,ffffffffc0204ede <do_execve+0x402>
ffffffffc0204eda:	db6484e3          	beq	s1,s6,ffffffffc0204c82 <do_execve+0x1a6>
ffffffffc0204ede:	e299                	bnez	a3,ffffffffc0204ee4 <do_execve+0x408>
ffffffffc0204ee0:	03bb0263          	beq	s6,s11,ffffffffc0204f04 <do_execve+0x428>
ffffffffc0204ee4:	00002697          	auipc	a3,0x2
ffffffffc0204ee8:	51468693          	addi	a3,a3,1300 # ffffffffc02073f8 <etext+0x19de>
ffffffffc0204eec:	00001617          	auipc	a2,0x1
ffffffffc0204ef0:	53460613          	addi	a2,a2,1332 # ffffffffc0206420 <etext+0xa06>
ffffffffc0204ef4:	2f500593          	li	a1,757
ffffffffc0204ef8:	00002517          	auipc	a0,0x2
ffffffffc0204efc:	31050513          	addi	a0,a0,784 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204f00:	d46fb0ef          	jal	ffffffffc0200446 <__panic>
        while (start < end)
ffffffffc0204f04:	d69b7fe3          	bgeu	s6,s1,ffffffffc0204c82 <do_execve+0x1a6>
ffffffffc0204f08:	56fd                	li	a3,-1
ffffffffc0204f0a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204f0e:	f03e                	sd	a5,32(sp)
ffffffffc0204f10:	a0b9                	j	ffffffffc0204f5e <do_execve+0x482>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f12:	6785                	lui	a5,0x1
ffffffffc0204f14:	00fd8833          	add	a6,s11,a5
                size -= la - end;
ffffffffc0204f18:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204f1c:	0104e463          	bltu	s1,a6,ffffffffc0204f24 <do_execve+0x448>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f20:	416809b3          	sub	s3,a6,s6
    return page - pages + nbase;
ffffffffc0204f24:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204f28:	7782                	ld	a5,32(sp)
ffffffffc0204f2a:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204f2e:	40d406b3          	sub	a3,s0,a3
ffffffffc0204f32:	8699                	srai	a3,a3,0x6
ffffffffc0204f34:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204f36:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f3a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f3c:	06b57263          	bgeu	a0,a1,ffffffffc0204fa0 <do_execve+0x4c4>
ffffffffc0204f40:	000ab583          	ld	a1,0(s5)
ffffffffc0204f44:	41bb0533          	sub	a0,s6,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f48:	864e                	mv	a2,s3
ffffffffc0204f4a:	96ae                	add	a3,a3,a1
ffffffffc0204f4c:	9536                	add	a0,a0,a3
ffffffffc0204f4e:	4581                	li	a1,0
            start += size;
ffffffffc0204f50:	9b4e                	add	s6,s6,s3
ffffffffc0204f52:	e042                	sd	a6,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f54:	29d000ef          	jal	ffffffffc02059f0 <memset>
        while (start < end)
ffffffffc0204f58:	d29b75e3          	bgeu	s6,s1,ffffffffc0204c82 <do_execve+0x1a6>
ffffffffc0204f5c:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204f5e:	01893503          	ld	a0,24(s2)
ffffffffc0204f62:	6622                	ld	a2,8(sp)
ffffffffc0204f64:	85ee                	mv	a1,s11
ffffffffc0204f66:	f88fe0ef          	jal	ffffffffc02036ee <pgdir_alloc_page>
ffffffffc0204f6a:	842a                	mv	s0,a0
ffffffffc0204f6c:	f15d                	bnez	a0,ffffffffc0204f12 <do_execve+0x436>
ffffffffc0204f6e:	b5cd                	j	ffffffffc0204e50 <do_execve+0x374>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204f70:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204f72:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204f74:	e43e                	sd	a5,8(sp)
ffffffffc0204f76:	b581                	j	ffffffffc0204db6 <do_execve+0x2da>
            perm |= (PTE_W | PTE_R);
ffffffffc0204f78:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204f7a:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204f7e:	e43e                	sd	a5,8(sp)
ffffffffc0204f80:	bd1d                	j	ffffffffc0204db6 <do_execve+0x2da>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204f82:	416d89b3          	sub	s3,s11,s6
ffffffffc0204f86:	bf19                	j	ffffffffc0204e9c <do_execve+0x3c0>
        return -E_INVAL;
ffffffffc0204f88:	54f5                	li	s1,-3
ffffffffc0204f8a:	b3fd                	j	ffffffffc0204d78 <do_execve+0x29c>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204f8c:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204f8e:	84da                	mv	s1,s6
ffffffffc0204f90:	bddd                	j	ffffffffc0204e86 <do_execve+0x3aa>
    int ret = -E_NO_MEM;
ffffffffc0204f92:	54f1                	li	s1,-4
ffffffffc0204f94:	b1ad                	j	ffffffffc0204bfe <do_execve+0x122>
ffffffffc0204f96:	6da6                	ld	s11,72(sp)
ffffffffc0204f98:	bd75                	j	ffffffffc0204e54 <do_execve+0x378>
            ret = -E_INVAL_ELF;
ffffffffc0204f9a:	6da6                	ld	s11,72(sp)
ffffffffc0204f9c:	54e1                	li	s1,-8
ffffffffc0204f9e:	bd5d                	j	ffffffffc0204e54 <do_execve+0x378>
ffffffffc0204fa0:	00002617          	auipc	a2,0x2
ffffffffc0204fa4:	83060613          	addi	a2,a2,-2000 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0204fa8:	07100593          	li	a1,113
ffffffffc0204fac:	00002517          	auipc	a0,0x2
ffffffffc0204fb0:	84c50513          	addi	a0,a0,-1972 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0204fb4:	c92fb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0204fb8:	00002617          	auipc	a2,0x2
ffffffffc0204fbc:	81860613          	addi	a2,a2,-2024 # ffffffffc02067d0 <etext+0xdb6>
ffffffffc0204fc0:	07100593          	li	a1,113
ffffffffc0204fc4:	00002517          	auipc	a0,0x2
ffffffffc0204fc8:	83450513          	addi	a0,a0,-1996 # ffffffffc02067f8 <etext+0xdde>
ffffffffc0204fcc:	f122                	sd	s0,160(sp)
ffffffffc0204fce:	e152                	sd	s4,128(sp)
ffffffffc0204fd0:	e4ee                	sd	s11,72(sp)
ffffffffc0204fd2:	c74fb0ef          	jal	ffffffffc0200446 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204fd6:	00002617          	auipc	a2,0x2
ffffffffc0204fda:	8a260613          	addi	a2,a2,-1886 # ffffffffc0206878 <etext+0xe5e>
ffffffffc0204fde:	31800593          	li	a1,792
ffffffffc0204fe2:	00002517          	auipc	a0,0x2
ffffffffc0204fe6:	22650513          	addi	a0,a0,550 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0204fea:	e4ee                	sd	s11,72(sp)
ffffffffc0204fec:	c5afb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ff0:	00002697          	auipc	a3,0x2
ffffffffc0204ff4:	52068693          	addi	a3,a3,1312 # ffffffffc0207510 <etext+0x1af6>
ffffffffc0204ff8:	00001617          	auipc	a2,0x1
ffffffffc0204ffc:	42860613          	addi	a2,a2,1064 # ffffffffc0206420 <etext+0xa06>
ffffffffc0205000:	31200593          	li	a1,786
ffffffffc0205004:	00002517          	auipc	a0,0x2
ffffffffc0205008:	20450513          	addi	a0,a0,516 # ffffffffc0207208 <etext+0x17ee>
ffffffffc020500c:	e4ee                	sd	s11,72(sp)
ffffffffc020500e:	c38fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205012:	00002697          	auipc	a3,0x2
ffffffffc0205016:	4b668693          	addi	a3,a3,1206 # ffffffffc02074c8 <etext+0x1aae>
ffffffffc020501a:	00001617          	auipc	a2,0x1
ffffffffc020501e:	40660613          	addi	a2,a2,1030 # ffffffffc0206420 <etext+0xa06>
ffffffffc0205022:	31100593          	li	a1,785
ffffffffc0205026:	00002517          	auipc	a0,0x2
ffffffffc020502a:	1e250513          	addi	a0,a0,482 # ffffffffc0207208 <etext+0x17ee>
ffffffffc020502e:	e4ee                	sd	s11,72(sp)
ffffffffc0205030:	c16fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205034:	00002697          	auipc	a3,0x2
ffffffffc0205038:	44c68693          	addi	a3,a3,1100 # ffffffffc0207480 <etext+0x1a66>
ffffffffc020503c:	00001617          	auipc	a2,0x1
ffffffffc0205040:	3e460613          	addi	a2,a2,996 # ffffffffc0206420 <etext+0xa06>
ffffffffc0205044:	31000593          	li	a1,784
ffffffffc0205048:	00002517          	auipc	a0,0x2
ffffffffc020504c:	1c050513          	addi	a0,a0,448 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0205050:	e4ee                	sd	s11,72(sp)
ffffffffc0205052:	bf4fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0205056:	00002697          	auipc	a3,0x2
ffffffffc020505a:	3e268693          	addi	a3,a3,994 # ffffffffc0207438 <etext+0x1a1e>
ffffffffc020505e:	00001617          	auipc	a2,0x1
ffffffffc0205062:	3c260613          	addi	a2,a2,962 # ffffffffc0206420 <etext+0xa06>
ffffffffc0205066:	30f00593          	li	a1,783
ffffffffc020506a:	00002517          	auipc	a0,0x2
ffffffffc020506e:	19e50513          	addi	a0,a0,414 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0205072:	e4ee                	sd	s11,72(sp)
ffffffffc0205074:	bd2fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205078 <do_yield>:
    current->need_resched = 1;
ffffffffc0205078:	00096797          	auipc	a5,0x96
ffffffffc020507c:	5d87b783          	ld	a5,1496(a5) # ffffffffc029b650 <current>
ffffffffc0205080:	4705                	li	a4,1
}
ffffffffc0205082:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0205084:	ef98                	sd	a4,24(a5)
}
ffffffffc0205086:	8082                	ret

ffffffffc0205088 <do_wait>:
    if (code_store != NULL)
ffffffffc0205088:	c59d                	beqz	a1,ffffffffc02050b6 <do_wait+0x2e>
{
ffffffffc020508a:	1101                	addi	sp,sp,-32
ffffffffc020508c:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc020508e:	00096517          	auipc	a0,0x96
ffffffffc0205092:	5c253503          	ld	a0,1474(a0) # ffffffffc029b650 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0205096:	4685                	li	a3,1
ffffffffc0205098:	4611                	li	a2,4
ffffffffc020509a:	7508                	ld	a0,40(a0)
{
ffffffffc020509c:	ec06                	sd	ra,24(sp)
ffffffffc020509e:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02050a0:	f59fe0ef          	jal	ffffffffc0203ff8 <user_mem_check>
ffffffffc02050a4:	6702                	ld	a4,0(sp)
ffffffffc02050a6:	67a2                	ld	a5,8(sp)
ffffffffc02050a8:	c909                	beqz	a0,ffffffffc02050ba <do_wait+0x32>
}
ffffffffc02050aa:	60e2                	ld	ra,24(sp)
ffffffffc02050ac:	85be                	mv	a1,a5
ffffffffc02050ae:	853a                	mv	a0,a4
ffffffffc02050b0:	6105                	addi	sp,sp,32
ffffffffc02050b2:	f24ff06f          	j	ffffffffc02047d6 <do_wait.part.0>
ffffffffc02050b6:	f20ff06f          	j	ffffffffc02047d6 <do_wait.part.0>
ffffffffc02050ba:	60e2                	ld	ra,24(sp)
ffffffffc02050bc:	5575                	li	a0,-3
ffffffffc02050be:	6105                	addi	sp,sp,32
ffffffffc02050c0:	8082                	ret

ffffffffc02050c2 <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc02050c2:	6789                	lui	a5,0x2
ffffffffc02050c4:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050c8:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc02050ca:	06e7e463          	bltu	a5,a4,ffffffffc0205132 <do_kill+0x70>
{
ffffffffc02050ce:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050d0:	45a9                	li	a1,10
{
ffffffffc02050d2:	ec06                	sd	ra,24(sp)
ffffffffc02050d4:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050d6:	484000ef          	jal	ffffffffc020555a <hash32>
ffffffffc02050da:	02051793          	slli	a5,a0,0x20
ffffffffc02050de:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02050e2:	00092797          	auipc	a5,0x92
ffffffffc02050e6:	4ee78793          	addi	a5,a5,1262 # ffffffffc02975d0 <hash_list>
ffffffffc02050ea:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc02050ec:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050ee:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc02050f0:	a029                	j	ffffffffc02050fa <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc02050f2:	f2c52703          	lw	a4,-212(a0)
ffffffffc02050f6:	00c70963          	beq	a4,a2,ffffffffc0205108 <do_kill+0x46>
ffffffffc02050fa:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc02050fc:	fea69be3          	bne	a3,a0,ffffffffc02050f2 <do_kill+0x30>
}
ffffffffc0205100:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc0205102:	5575                	li	a0,-3
}
ffffffffc0205104:	6105                	addi	sp,sp,32
ffffffffc0205106:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0205108:	fd852703          	lw	a4,-40(a0)
ffffffffc020510c:	00177693          	andi	a3,a4,1
ffffffffc0205110:	e29d                	bnez	a3,ffffffffc0205136 <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205112:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0205114:	00176713          	ori	a4,a4,1
ffffffffc0205118:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020511c:	0006c663          	bltz	a3,ffffffffc0205128 <do_kill+0x66>
            return 0;
ffffffffc0205120:	4501                	li	a0,0
}
ffffffffc0205122:	60e2                	ld	ra,24(sp)
ffffffffc0205124:	6105                	addi	sp,sp,32
ffffffffc0205126:	8082                	ret
                wakeup_proc(proc);
ffffffffc0205128:	f2850513          	addi	a0,a0,-216
ffffffffc020512c:	232000ef          	jal	ffffffffc020535e <wakeup_proc>
ffffffffc0205130:	bfc5                	j	ffffffffc0205120 <do_kill+0x5e>
    return -E_INVAL;
ffffffffc0205132:	5575                	li	a0,-3
}
ffffffffc0205134:	8082                	ret
        return -E_KILLED;
ffffffffc0205136:	555d                	li	a0,-9
ffffffffc0205138:	b7ed                	j	ffffffffc0205122 <do_kill+0x60>

ffffffffc020513a <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc020513a:	1101                	addi	sp,sp,-32
ffffffffc020513c:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020513e:	00096797          	auipc	a5,0x96
ffffffffc0205142:	49278793          	addi	a5,a5,1170 # ffffffffc029b5d0 <proc_list>
ffffffffc0205146:	ec06                	sd	ra,24(sp)
ffffffffc0205148:	e822                	sd	s0,16(sp)
ffffffffc020514a:	e04a                	sd	s2,0(sp)
ffffffffc020514c:	00092497          	auipc	s1,0x92
ffffffffc0205150:	48448493          	addi	s1,s1,1156 # ffffffffc02975d0 <hash_list>
ffffffffc0205154:	e79c                	sd	a5,8(a5)
ffffffffc0205156:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205158:	00096717          	auipc	a4,0x96
ffffffffc020515c:	47870713          	addi	a4,a4,1144 # ffffffffc029b5d0 <proc_list>
ffffffffc0205160:	87a6                	mv	a5,s1
ffffffffc0205162:	e79c                	sd	a5,8(a5)
ffffffffc0205164:	e39c                	sd	a5,0(a5)
ffffffffc0205166:	07c1                	addi	a5,a5,16
ffffffffc0205168:	fee79de3          	bne	a5,a4,ffffffffc0205162 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020516c:	f39fe0ef          	jal	ffffffffc02040a4 <alloc_proc>
ffffffffc0205170:	00096917          	auipc	s2,0x96
ffffffffc0205174:	4f090913          	addi	s2,s2,1264 # ffffffffc029b660 <idleproc>
ffffffffc0205178:	00a93023          	sd	a0,0(s2)
ffffffffc020517c:	10050363          	beqz	a0,ffffffffc0205282 <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205180:	4789                	li	a5,2
ffffffffc0205182:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205184:	00003797          	auipc	a5,0x3
ffffffffc0205188:	e7c78793          	addi	a5,a5,-388 # ffffffffc0208000 <bootstack>
ffffffffc020518c:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020518e:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc0205192:	4785                	li	a5,1
ffffffffc0205194:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205196:	4641                	li	a2,16
ffffffffc0205198:	8522                	mv	a0,s0
ffffffffc020519a:	4581                	li	a1,0
ffffffffc020519c:	055000ef          	jal	ffffffffc02059f0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02051a0:	8522                	mv	a0,s0
ffffffffc02051a2:	463d                	li	a2,15
ffffffffc02051a4:	00002597          	auipc	a1,0x2
ffffffffc02051a8:	3cc58593          	addi	a1,a1,972 # ffffffffc0207570 <etext+0x1b56>
ffffffffc02051ac:	057000ef          	jal	ffffffffc0205a02 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02051b0:	00096797          	auipc	a5,0x96
ffffffffc02051b4:	49c7a783          	lw	a5,1180(a5) # ffffffffc029b64c <nr_process>

    current = idleproc;
ffffffffc02051b8:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051bc:	4601                	li	a2,0
    nr_process++;
ffffffffc02051be:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051c0:	4581                	li	a1,0
ffffffffc02051c2:	fffff517          	auipc	a0,0xfffff
ffffffffc02051c6:	7f650513          	addi	a0,a0,2038 # ffffffffc02049b8 <init_main>
    current = idleproc;
ffffffffc02051ca:	00096697          	auipc	a3,0x96
ffffffffc02051ce:	48e6b323          	sd	a4,1158(a3) # ffffffffc029b650 <current>
    nr_process++;
ffffffffc02051d2:	00096717          	auipc	a4,0x96
ffffffffc02051d6:	46f72d23          	sw	a5,1146(a4) # ffffffffc029b64c <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051da:	c68ff0ef          	jal	ffffffffc0204642 <kernel_thread>
ffffffffc02051de:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02051e0:	08a05563          	blez	a0,ffffffffc020526a <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc02051e4:	6789                	lui	a5,0x2
ffffffffc02051e6:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc02051e8:	fff5071b          	addiw	a4,a0,-1
ffffffffc02051ec:	02e7e463          	bltu	a5,a4,ffffffffc0205214 <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02051f0:	45a9                	li	a1,10
ffffffffc02051f2:	368000ef          	jal	ffffffffc020555a <hash32>
ffffffffc02051f6:	02051713          	slli	a4,a0,0x20
ffffffffc02051fa:	01c75793          	srli	a5,a4,0x1c
ffffffffc02051fe:	00f486b3          	add	a3,s1,a5
ffffffffc0205202:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205204:	a029                	j	ffffffffc020520e <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc0205206:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020520a:	04870d63          	beq	a4,s0,ffffffffc0205264 <proc_init+0x12a>
    return listelm->next;
ffffffffc020520e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205210:	fef69be3          	bne	a3,a5,ffffffffc0205206 <proc_init+0xcc>
    return NULL;
ffffffffc0205214:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205216:	0b478413          	addi	s0,a5,180
ffffffffc020521a:	4641                	li	a2,16
ffffffffc020521c:	4581                	li	a1,0
ffffffffc020521e:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205220:	00096717          	auipc	a4,0x96
ffffffffc0205224:	42f73c23          	sd	a5,1080(a4) # ffffffffc029b658 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205228:	7c8000ef          	jal	ffffffffc02059f0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020522c:	8522                	mv	a0,s0
ffffffffc020522e:	463d                	li	a2,15
ffffffffc0205230:	00002597          	auipc	a1,0x2
ffffffffc0205234:	36858593          	addi	a1,a1,872 # ffffffffc0207598 <etext+0x1b7e>
ffffffffc0205238:	7ca000ef          	jal	ffffffffc0205a02 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020523c:	00093783          	ld	a5,0(s2)
ffffffffc0205240:	cfad                	beqz	a5,ffffffffc02052ba <proc_init+0x180>
ffffffffc0205242:	43dc                	lw	a5,4(a5)
ffffffffc0205244:	ebbd                	bnez	a5,ffffffffc02052ba <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205246:	00096797          	auipc	a5,0x96
ffffffffc020524a:	4127b783          	ld	a5,1042(a5) # ffffffffc029b658 <initproc>
ffffffffc020524e:	c7b1                	beqz	a5,ffffffffc020529a <proc_init+0x160>
ffffffffc0205250:	43d8                	lw	a4,4(a5)
ffffffffc0205252:	4785                	li	a5,1
ffffffffc0205254:	04f71363          	bne	a4,a5,ffffffffc020529a <proc_init+0x160>
}
ffffffffc0205258:	60e2                	ld	ra,24(sp)
ffffffffc020525a:	6442                	ld	s0,16(sp)
ffffffffc020525c:	64a2                	ld	s1,8(sp)
ffffffffc020525e:	6902                	ld	s2,0(sp)
ffffffffc0205260:	6105                	addi	sp,sp,32
ffffffffc0205262:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205264:	f2878793          	addi	a5,a5,-216
ffffffffc0205268:	b77d                	j	ffffffffc0205216 <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc020526a:	00002617          	auipc	a2,0x2
ffffffffc020526e:	30e60613          	addi	a2,a2,782 # ffffffffc0207578 <etext+0x1b5e>
ffffffffc0205272:	44400593          	li	a1,1092
ffffffffc0205276:	00002517          	auipc	a0,0x2
ffffffffc020527a:	f9250513          	addi	a0,a0,-110 # ffffffffc0207208 <etext+0x17ee>
ffffffffc020527e:	9c8fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205282:	00002617          	auipc	a2,0x2
ffffffffc0205286:	2d660613          	addi	a2,a2,726 # ffffffffc0207558 <etext+0x1b3e>
ffffffffc020528a:	43500593          	li	a1,1077
ffffffffc020528e:	00002517          	auipc	a0,0x2
ffffffffc0205292:	f7a50513          	addi	a0,a0,-134 # ffffffffc0207208 <etext+0x17ee>
ffffffffc0205296:	9b0fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020529a:	00002697          	auipc	a3,0x2
ffffffffc020529e:	32e68693          	addi	a3,a3,814 # ffffffffc02075c8 <etext+0x1bae>
ffffffffc02052a2:	00001617          	auipc	a2,0x1
ffffffffc02052a6:	17e60613          	addi	a2,a2,382 # ffffffffc0206420 <etext+0xa06>
ffffffffc02052aa:	44b00593          	li	a1,1099
ffffffffc02052ae:	00002517          	auipc	a0,0x2
ffffffffc02052b2:	f5a50513          	addi	a0,a0,-166 # ffffffffc0207208 <etext+0x17ee>
ffffffffc02052b6:	990fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02052ba:	00002697          	auipc	a3,0x2
ffffffffc02052be:	2e668693          	addi	a3,a3,742 # ffffffffc02075a0 <etext+0x1b86>
ffffffffc02052c2:	00001617          	auipc	a2,0x1
ffffffffc02052c6:	15e60613          	addi	a2,a2,350 # ffffffffc0206420 <etext+0xa06>
ffffffffc02052ca:	44a00593          	li	a1,1098
ffffffffc02052ce:	00002517          	auipc	a0,0x2
ffffffffc02052d2:	f3a50513          	addi	a0,a0,-198 # ffffffffc0207208 <etext+0x17ee>
ffffffffc02052d6:	970fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02052da <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02052da:	1141                	addi	sp,sp,-16
ffffffffc02052dc:	e022                	sd	s0,0(sp)
ffffffffc02052de:	e406                	sd	ra,8(sp)
ffffffffc02052e0:	00096417          	auipc	s0,0x96
ffffffffc02052e4:	37040413          	addi	s0,s0,880 # ffffffffc029b650 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02052e8:	6018                	ld	a4,0(s0)
ffffffffc02052ea:	6f1c                	ld	a5,24(a4)
ffffffffc02052ec:	dffd                	beqz	a5,ffffffffc02052ea <cpu_idle+0x10>
        {
            schedule();
ffffffffc02052ee:	104000ef          	jal	ffffffffc02053f2 <schedule>
ffffffffc02052f2:	bfdd                	j	ffffffffc02052e8 <cpu_idle+0xe>

ffffffffc02052f4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02052f4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02052f8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02052fc:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02052fe:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205300:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205304:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205308:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020530c:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0205310:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205314:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205318:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020531c:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205320:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205324:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205328:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020532c:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205330:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205332:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205334:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205338:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020533c:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205340:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205344:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205348:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020534c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205350:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205354:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205358:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020535c:	8082                	ret

ffffffffc020535e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020535e:	4118                	lw	a4,0(a0)
{
ffffffffc0205360:	1101                	addi	sp,sp,-32
ffffffffc0205362:	ec06                	sd	ra,24(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205364:	478d                	li	a5,3
ffffffffc0205366:	06f70763          	beq	a4,a5,ffffffffc02053d4 <wakeup_proc+0x76>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020536a:	100027f3          	csrr	a5,sstatus
ffffffffc020536e:	8b89                	andi	a5,a5,2
ffffffffc0205370:	eb91                	bnez	a5,ffffffffc0205384 <wakeup_proc+0x26>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205372:	4789                	li	a5,2
ffffffffc0205374:	02f70763          	beq	a4,a5,ffffffffc02053a2 <wakeup_proc+0x44>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205378:	60e2                	ld	ra,24(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc020537a:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc020537c:	0e052623          	sw	zero,236(a0)
}
ffffffffc0205380:	6105                	addi	sp,sp,32
ffffffffc0205382:	8082                	ret
        intr_disable();
ffffffffc0205384:	e42a                	sd	a0,8(sp)
ffffffffc0205386:	d7efb0ef          	jal	ffffffffc0200904 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020538a:	6522                	ld	a0,8(sp)
ffffffffc020538c:	4789                	li	a5,2
ffffffffc020538e:	4118                	lw	a4,0(a0)
ffffffffc0205390:	02f70663          	beq	a4,a5,ffffffffc02053bc <wakeup_proc+0x5e>
            proc->state = PROC_RUNNABLE;
ffffffffc0205394:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc0205396:	0e052623          	sw	zero,236(a0)
}
ffffffffc020539a:	60e2                	ld	ra,24(sp)
ffffffffc020539c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020539e:	d60fb06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc02053a2:	60e2                	ld	ra,24(sp)
            warn("wakeup runnable process.\n");
ffffffffc02053a4:	00002617          	auipc	a2,0x2
ffffffffc02053a8:	28460613          	addi	a2,a2,644 # ffffffffc0207628 <etext+0x1c0e>
ffffffffc02053ac:	45d1                	li	a1,20
ffffffffc02053ae:	00002517          	auipc	a0,0x2
ffffffffc02053b2:	26250513          	addi	a0,a0,610 # ffffffffc0207610 <etext+0x1bf6>
}
ffffffffc02053b6:	6105                	addi	sp,sp,32
            warn("wakeup runnable process.\n");
ffffffffc02053b8:	8f8fb06f          	j	ffffffffc02004b0 <__warn>
ffffffffc02053bc:	00002617          	auipc	a2,0x2
ffffffffc02053c0:	26c60613          	addi	a2,a2,620 # ffffffffc0207628 <etext+0x1c0e>
ffffffffc02053c4:	45d1                	li	a1,20
ffffffffc02053c6:	00002517          	auipc	a0,0x2
ffffffffc02053ca:	24a50513          	addi	a0,a0,586 # ffffffffc0207610 <etext+0x1bf6>
ffffffffc02053ce:	8e2fb0ef          	jal	ffffffffc02004b0 <__warn>
    if (flag)
ffffffffc02053d2:	b7e1                	j	ffffffffc020539a <wakeup_proc+0x3c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02053d4:	00002697          	auipc	a3,0x2
ffffffffc02053d8:	21c68693          	addi	a3,a3,540 # ffffffffc02075f0 <etext+0x1bd6>
ffffffffc02053dc:	00001617          	auipc	a2,0x1
ffffffffc02053e0:	04460613          	addi	a2,a2,68 # ffffffffc0206420 <etext+0xa06>
ffffffffc02053e4:	45a5                	li	a1,9
ffffffffc02053e6:	00002517          	auipc	a0,0x2
ffffffffc02053ea:	22a50513          	addi	a0,a0,554 # ffffffffc0207610 <etext+0x1bf6>
ffffffffc02053ee:	858fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02053f2 <schedule>:

void schedule(void)
{
ffffffffc02053f2:	1101                	addi	sp,sp,-32
ffffffffc02053f4:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02053f6:	100027f3          	csrr	a5,sstatus
ffffffffc02053fa:	8b89                	andi	a5,a5,2
ffffffffc02053fc:	4301                	li	t1,0
ffffffffc02053fe:	e3c1                	bnez	a5,ffffffffc020547e <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205400:	00096897          	auipc	a7,0x96
ffffffffc0205404:	2508b883          	ld	a7,592(a7) # ffffffffc029b650 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205408:	00096517          	auipc	a0,0x96
ffffffffc020540c:	25853503          	ld	a0,600(a0) # ffffffffc029b660 <idleproc>
        current->need_resched = 0;
ffffffffc0205410:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205414:	04a88f63          	beq	a7,a0,ffffffffc0205472 <schedule+0x80>
ffffffffc0205418:	0c888693          	addi	a3,a7,200
ffffffffc020541c:	00096617          	auipc	a2,0x96
ffffffffc0205420:	1b460613          	addi	a2,a2,436 # ffffffffc029b5d0 <proc_list>
        le = last;
ffffffffc0205424:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205426:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205428:	4809                	li	a6,2
ffffffffc020542a:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc020542c:	00c78863          	beq	a5,a2,ffffffffc020543c <schedule+0x4a>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205430:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205434:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205438:	03070363          	beq	a4,a6,ffffffffc020545e <schedule+0x6c>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc020543c:	fef697e3          	bne	a3,a5,ffffffffc020542a <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205440:	ed99                	bnez	a1,ffffffffc020545e <schedule+0x6c>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205442:	451c                	lw	a5,8(a0)
ffffffffc0205444:	2785                	addiw	a5,a5,1
ffffffffc0205446:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205448:	00a88663          	beq	a7,a0,ffffffffc0205454 <schedule+0x62>
ffffffffc020544c:	e41a                	sd	t1,8(sp)
        {
            proc_run(next);
ffffffffc020544e:	ddbfe0ef          	jal	ffffffffc0204228 <proc_run>
ffffffffc0205452:	6322                	ld	t1,8(sp)
    if (flag)
ffffffffc0205454:	00031b63          	bnez	t1,ffffffffc020546a <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205458:	60e2                	ld	ra,24(sp)
ffffffffc020545a:	6105                	addi	sp,sp,32
ffffffffc020545c:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020545e:	4198                	lw	a4,0(a1)
ffffffffc0205460:	4789                	li	a5,2
ffffffffc0205462:	fef710e3          	bne	a4,a5,ffffffffc0205442 <schedule+0x50>
ffffffffc0205466:	852e                	mv	a0,a1
ffffffffc0205468:	bfe9                	j	ffffffffc0205442 <schedule+0x50>
}
ffffffffc020546a:	60e2                	ld	ra,24(sp)
ffffffffc020546c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020546e:	c90fb06f          	j	ffffffffc02008fe <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205472:	00096617          	auipc	a2,0x96
ffffffffc0205476:	15e60613          	addi	a2,a2,350 # ffffffffc029b5d0 <proc_list>
ffffffffc020547a:	86b2                	mv	a3,a2
ffffffffc020547c:	b765                	j	ffffffffc0205424 <schedule+0x32>
        intr_disable();
ffffffffc020547e:	c86fb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0205482:	4305                	li	t1,1
ffffffffc0205484:	bfb5                	j	ffffffffc0205400 <schedule+0xe>

ffffffffc0205486 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205486:	00096797          	auipc	a5,0x96
ffffffffc020548a:	1ca7b783          	ld	a5,458(a5) # ffffffffc029b650 <current>
}
ffffffffc020548e:	43c8                	lw	a0,4(a5)
ffffffffc0205490:	8082                	ret

ffffffffc0205492 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205492:	4501                	li	a0,0
ffffffffc0205494:	8082                	ret

ffffffffc0205496 <sys_putc>:
    cputchar(c);
ffffffffc0205496:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205498:	1141                	addi	sp,sp,-16
ffffffffc020549a:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020549c:	d2dfa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc02054a0:	60a2                	ld	ra,8(sp)
ffffffffc02054a2:	4501                	li	a0,0
ffffffffc02054a4:	0141                	addi	sp,sp,16
ffffffffc02054a6:	8082                	ret

ffffffffc02054a8 <sys_kill>:
    return do_kill(pid);
ffffffffc02054a8:	4108                	lw	a0,0(a0)
ffffffffc02054aa:	c19ff06f          	j	ffffffffc02050c2 <do_kill>

ffffffffc02054ae <sys_yield>:
    return do_yield();
ffffffffc02054ae:	bcbff06f          	j	ffffffffc0205078 <do_yield>

ffffffffc02054b2 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02054b2:	6d14                	ld	a3,24(a0)
ffffffffc02054b4:	6910                	ld	a2,16(a0)
ffffffffc02054b6:	650c                	ld	a1,8(a0)
ffffffffc02054b8:	6108                	ld	a0,0(a0)
ffffffffc02054ba:	e22ff06f          	j	ffffffffc0204adc <do_execve>

ffffffffc02054be <sys_wait>:
    return do_wait(pid, store);
ffffffffc02054be:	650c                	ld	a1,8(a0)
ffffffffc02054c0:	4108                	lw	a0,0(a0)
ffffffffc02054c2:	bc7ff06f          	j	ffffffffc0205088 <do_wait>

ffffffffc02054c6 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02054c6:	00096797          	auipc	a5,0x96
ffffffffc02054ca:	18a7b783          	ld	a5,394(a5) # ffffffffc029b650 <current>
    return do_fork(0, stack, tf);
ffffffffc02054ce:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc02054d0:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02054d2:	6a0c                	ld	a1,16(a2)
ffffffffc02054d4:	db9fe06f          	j	ffffffffc020428c <do_fork>

ffffffffc02054d8 <sys_exit>:
    return do_exit(error_code);
ffffffffc02054d8:	4108                	lw	a0,0(a0)
ffffffffc02054da:	9b8ff06f          	j	ffffffffc0204692 <do_exit>

ffffffffc02054de <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc02054de:	00096697          	auipc	a3,0x96
ffffffffc02054e2:	1726b683          	ld	a3,370(a3) # ffffffffc029b650 <current>
syscall(void) {
ffffffffc02054e6:	715d                	addi	sp,sp,-80
ffffffffc02054e8:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc02054ea:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc02054ec:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054ee:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02054f0:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054f2:	02d7ec63          	bltu	a5,a3,ffffffffc020552a <syscall+0x4c>
        if (syscalls[num] != NULL) {
ffffffffc02054f6:	00002797          	auipc	a5,0x2
ffffffffc02054fa:	37a78793          	addi	a5,a5,890 # ffffffffc0207870 <syscalls>
ffffffffc02054fe:	00369613          	slli	a2,a3,0x3
ffffffffc0205502:	97b2                	add	a5,a5,a2
ffffffffc0205504:	639c                	ld	a5,0(a5)
ffffffffc0205506:	c395                	beqz	a5,ffffffffc020552a <syscall+0x4c>
            arg[0] = tf->gpr.a1;
ffffffffc0205508:	7028                	ld	a0,96(s0)
ffffffffc020550a:	742c                	ld	a1,104(s0)
ffffffffc020550c:	7830                	ld	a2,112(s0)
ffffffffc020550e:	7c34                	ld	a3,120(s0)
ffffffffc0205510:	6c38                	ld	a4,88(s0)
ffffffffc0205512:	f02a                	sd	a0,32(sp)
ffffffffc0205514:	f42e                	sd	a1,40(sp)
ffffffffc0205516:	f832                	sd	a2,48(sp)
ffffffffc0205518:	fc36                	sd	a3,56(sp)
ffffffffc020551a:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020551c:	0828                	addi	a0,sp,24
ffffffffc020551e:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205520:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205522:	e828                	sd	a0,80(s0)
}
ffffffffc0205524:	6406                	ld	s0,64(sp)
ffffffffc0205526:	6161                	addi	sp,sp,80
ffffffffc0205528:	8082                	ret
    print_trapframe(tf);
ffffffffc020552a:	8522                	mv	a0,s0
ffffffffc020552c:	e436                	sd	a3,8(sp)
ffffffffc020552e:	dc6fb0ef          	jal	ffffffffc0200af4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205532:	00096797          	auipc	a5,0x96
ffffffffc0205536:	11e7b783          	ld	a5,286(a5) # ffffffffc029b650 <current>
ffffffffc020553a:	66a2                	ld	a3,8(sp)
ffffffffc020553c:	00002617          	auipc	a2,0x2
ffffffffc0205540:	10c60613          	addi	a2,a2,268 # ffffffffc0207648 <etext+0x1c2e>
ffffffffc0205544:	43d8                	lw	a4,4(a5)
ffffffffc0205546:	06200593          	li	a1,98
ffffffffc020554a:	0b478793          	addi	a5,a5,180
ffffffffc020554e:	00002517          	auipc	a0,0x2
ffffffffc0205552:	12a50513          	addi	a0,a0,298 # ffffffffc0207678 <etext+0x1c5e>
ffffffffc0205556:	ef1fa0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020555a <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020555a:	9e3707b7          	lui	a5,0x9e370
ffffffffc020555e:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e365e49>
ffffffffc0205560:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205564:	02000513          	li	a0,32
ffffffffc0205568:	9d0d                	subw	a0,a0,a1
}
ffffffffc020556a:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020556e:	8082                	ret

ffffffffc0205570 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205570:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205572:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205576:	f022                	sd	s0,32(sp)
ffffffffc0205578:	ec26                	sd	s1,24(sp)
ffffffffc020557a:	e84a                	sd	s2,16(sp)
ffffffffc020557c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020557e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205582:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205584:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205588:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020558c:	84aa                	mv	s1,a0
ffffffffc020558e:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0205590:	03067d63          	bgeu	a2,a6,ffffffffc02055ca <printnum+0x5a>
ffffffffc0205594:	e44e                	sd	s3,8(sp)
ffffffffc0205596:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205598:	4785                	li	a5,1
ffffffffc020559a:	00e7d763          	bge	a5,a4,ffffffffc02055a8 <printnum+0x38>
            putch(padc, putdat);
ffffffffc020559e:	85ca                	mv	a1,s2
ffffffffc02055a0:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02055a2:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02055a4:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02055a6:	fc65                	bnez	s0,ffffffffc020559e <printnum+0x2e>
ffffffffc02055a8:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055aa:	00002797          	auipc	a5,0x2
ffffffffc02055ae:	0e678793          	addi	a5,a5,230 # ffffffffc0207690 <etext+0x1c76>
ffffffffc02055b2:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02055b4:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055b6:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02055ba:	70a2                	ld	ra,40(sp)
ffffffffc02055bc:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055be:	85ca                	mv	a1,s2
ffffffffc02055c0:	87a6                	mv	a5,s1
}
ffffffffc02055c2:	6942                	ld	s2,16(sp)
ffffffffc02055c4:	64e2                	ld	s1,24(sp)
ffffffffc02055c6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055c8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02055ca:	03065633          	divu	a2,a2,a6
ffffffffc02055ce:	8722                	mv	a4,s0
ffffffffc02055d0:	fa1ff0ef          	jal	ffffffffc0205570 <printnum>
ffffffffc02055d4:	bfd9                	j	ffffffffc02055aa <printnum+0x3a>

ffffffffc02055d6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02055d6:	7119                	addi	sp,sp,-128
ffffffffc02055d8:	f4a6                	sd	s1,104(sp)
ffffffffc02055da:	f0ca                	sd	s2,96(sp)
ffffffffc02055dc:	ecce                	sd	s3,88(sp)
ffffffffc02055de:	e8d2                	sd	s4,80(sp)
ffffffffc02055e0:	e4d6                	sd	s5,72(sp)
ffffffffc02055e2:	e0da                	sd	s6,64(sp)
ffffffffc02055e4:	f862                	sd	s8,48(sp)
ffffffffc02055e6:	fc86                	sd	ra,120(sp)
ffffffffc02055e8:	f8a2                	sd	s0,112(sp)
ffffffffc02055ea:	fc5e                	sd	s7,56(sp)
ffffffffc02055ec:	f466                	sd	s9,40(sp)
ffffffffc02055ee:	f06a                	sd	s10,32(sp)
ffffffffc02055f0:	ec6e                	sd	s11,24(sp)
ffffffffc02055f2:	84aa                	mv	s1,a0
ffffffffc02055f4:	8c32                	mv	s8,a2
ffffffffc02055f6:	8a36                	mv	s4,a3
ffffffffc02055f8:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055fa:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055fe:	05500b13          	li	s6,85
ffffffffc0205602:	00002a97          	auipc	s5,0x2
ffffffffc0205606:	36ea8a93          	addi	s5,s5,878 # ffffffffc0207970 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020560a:	000c4503          	lbu	a0,0(s8)
ffffffffc020560e:	001c0413          	addi	s0,s8,1
ffffffffc0205612:	01350a63          	beq	a0,s3,ffffffffc0205626 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0205616:	cd0d                	beqz	a0,ffffffffc0205650 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205618:	85ca                	mv	a1,s2
ffffffffc020561a:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020561c:	00044503          	lbu	a0,0(s0)
ffffffffc0205620:	0405                	addi	s0,s0,1
ffffffffc0205622:	ff351ae3          	bne	a0,s3,ffffffffc0205616 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0205626:	5cfd                	li	s9,-1
ffffffffc0205628:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc020562a:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc020562e:	4b81                	li	s7,0
ffffffffc0205630:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205632:	00044683          	lbu	a3,0(s0)
ffffffffc0205636:	00140c13          	addi	s8,s0,1
ffffffffc020563a:	fdd6859b          	addiw	a1,a3,-35
ffffffffc020563e:	0ff5f593          	zext.b	a1,a1
ffffffffc0205642:	02bb6663          	bltu	s6,a1,ffffffffc020566e <vprintfmt+0x98>
ffffffffc0205646:	058a                	slli	a1,a1,0x2
ffffffffc0205648:	95d6                	add	a1,a1,s5
ffffffffc020564a:	4198                	lw	a4,0(a1)
ffffffffc020564c:	9756                	add	a4,a4,s5
ffffffffc020564e:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205650:	70e6                	ld	ra,120(sp)
ffffffffc0205652:	7446                	ld	s0,112(sp)
ffffffffc0205654:	74a6                	ld	s1,104(sp)
ffffffffc0205656:	7906                	ld	s2,96(sp)
ffffffffc0205658:	69e6                	ld	s3,88(sp)
ffffffffc020565a:	6a46                	ld	s4,80(sp)
ffffffffc020565c:	6aa6                	ld	s5,72(sp)
ffffffffc020565e:	6b06                	ld	s6,64(sp)
ffffffffc0205660:	7be2                	ld	s7,56(sp)
ffffffffc0205662:	7c42                	ld	s8,48(sp)
ffffffffc0205664:	7ca2                	ld	s9,40(sp)
ffffffffc0205666:	7d02                	ld	s10,32(sp)
ffffffffc0205668:	6de2                	ld	s11,24(sp)
ffffffffc020566a:	6109                	addi	sp,sp,128
ffffffffc020566c:	8082                	ret
            putch('%', putdat);
ffffffffc020566e:	85ca                	mv	a1,s2
ffffffffc0205670:	02500513          	li	a0,37
ffffffffc0205674:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205676:	fff44783          	lbu	a5,-1(s0)
ffffffffc020567a:	02500713          	li	a4,37
ffffffffc020567e:	8c22                	mv	s8,s0
ffffffffc0205680:	f8e785e3          	beq	a5,a4,ffffffffc020560a <vprintfmt+0x34>
ffffffffc0205684:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0205688:	1c7d                	addi	s8,s8,-1
ffffffffc020568a:	fee79de3          	bne	a5,a4,ffffffffc0205684 <vprintfmt+0xae>
ffffffffc020568e:	bfb5                	j	ffffffffc020560a <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0205690:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0205694:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0205696:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc020569a:	fd06071b          	addiw	a4,a2,-48
ffffffffc020569e:	24e56a63          	bltu	a0,a4,ffffffffc02058f2 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc02056a2:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056a4:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc02056a6:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc02056aa:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02056ae:	0197073b          	addw	a4,a4,s9
ffffffffc02056b2:	0017171b          	slliw	a4,a4,0x1
ffffffffc02056b6:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc02056b8:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02056bc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02056be:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc02056c2:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc02056c6:	feb570e3          	bgeu	a0,a1,ffffffffc02056a6 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc02056ca:	f60d54e3          	bgez	s10,ffffffffc0205632 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc02056ce:	8d66                	mv	s10,s9
ffffffffc02056d0:	5cfd                	li	s9,-1
ffffffffc02056d2:	b785                	j	ffffffffc0205632 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056d4:	8db6                	mv	s11,a3
ffffffffc02056d6:	8462                	mv	s0,s8
ffffffffc02056d8:	bfa9                	j	ffffffffc0205632 <vprintfmt+0x5c>
ffffffffc02056da:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc02056dc:	4b85                	li	s7,1
            goto reswitch;
ffffffffc02056de:	bf91                	j	ffffffffc0205632 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc02056e0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056e2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056e6:	00f74463          	blt	a4,a5,ffffffffc02056ee <vprintfmt+0x118>
    else if (lflag) {
ffffffffc02056ea:	1a078763          	beqz	a5,ffffffffc0205898 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc02056ee:	000a3603          	ld	a2,0(s4)
ffffffffc02056f2:	46c1                	li	a3,16
ffffffffc02056f4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02056f6:	000d879b          	sext.w	a5,s11
ffffffffc02056fa:	876a                	mv	a4,s10
ffffffffc02056fc:	85ca                	mv	a1,s2
ffffffffc02056fe:	8526                	mv	a0,s1
ffffffffc0205700:	e71ff0ef          	jal	ffffffffc0205570 <printnum>
            break;
ffffffffc0205704:	b719                	j	ffffffffc020560a <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205706:	000a2503          	lw	a0,0(s4)
ffffffffc020570a:	85ca                	mv	a1,s2
ffffffffc020570c:	0a21                	addi	s4,s4,8
ffffffffc020570e:	9482                	jalr	s1
            break;
ffffffffc0205710:	bded                	j	ffffffffc020560a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205712:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205714:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205718:	00f74463          	blt	a4,a5,ffffffffc0205720 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc020571c:	16078963          	beqz	a5,ffffffffc020588e <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0205720:	000a3603          	ld	a2,0(s4)
ffffffffc0205724:	46a9                	li	a3,10
ffffffffc0205726:	8a2e                	mv	s4,a1
ffffffffc0205728:	b7f9                	j	ffffffffc02056f6 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc020572a:	85ca                	mv	a1,s2
ffffffffc020572c:	03000513          	li	a0,48
ffffffffc0205730:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0205732:	85ca                	mv	a1,s2
ffffffffc0205734:	07800513          	li	a0,120
ffffffffc0205738:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020573a:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc020573e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205740:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205742:	bf55                	j	ffffffffc02056f6 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0205744:	85ca                	mv	a1,s2
ffffffffc0205746:	02500513          	li	a0,37
ffffffffc020574a:	9482                	jalr	s1
            break;
ffffffffc020574c:	bd7d                	j	ffffffffc020560a <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc020574e:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205752:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0205754:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0205756:	bf95                	j	ffffffffc02056ca <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0205758:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020575a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020575e:	00f74463          	blt	a4,a5,ffffffffc0205766 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0205762:	12078163          	beqz	a5,ffffffffc0205884 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0205766:	000a3603          	ld	a2,0(s4)
ffffffffc020576a:	46a1                	li	a3,8
ffffffffc020576c:	8a2e                	mv	s4,a1
ffffffffc020576e:	b761                	j	ffffffffc02056f6 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0205770:	876a                	mv	a4,s10
ffffffffc0205772:	000d5363          	bgez	s10,ffffffffc0205778 <vprintfmt+0x1a2>
ffffffffc0205776:	4701                	li	a4,0
ffffffffc0205778:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020577c:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020577e:	bd55                	j	ffffffffc0205632 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0205780:	000d841b          	sext.w	s0,s11
ffffffffc0205784:	fd340793          	addi	a5,s0,-45
ffffffffc0205788:	00f037b3          	snez	a5,a5
ffffffffc020578c:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205790:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0205794:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205796:	008a0793          	addi	a5,s4,8
ffffffffc020579a:	e43e                	sd	a5,8(sp)
ffffffffc020579c:	100d8c63          	beqz	s11,ffffffffc02058b4 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02057a0:	12071363          	bnez	a4,ffffffffc02058c6 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057a4:	000dc783          	lbu	a5,0(s11)
ffffffffc02057a8:	0007851b          	sext.w	a0,a5
ffffffffc02057ac:	c78d                	beqz	a5,ffffffffc02057d6 <vprintfmt+0x200>
ffffffffc02057ae:	0d85                	addi	s11,s11,1
ffffffffc02057b0:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057b2:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057b6:	000cc563          	bltz	s9,ffffffffc02057c0 <vprintfmt+0x1ea>
ffffffffc02057ba:	3cfd                	addiw	s9,s9,-1
ffffffffc02057bc:	008c8d63          	beq	s9,s0,ffffffffc02057d6 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057c0:	020b9663          	bnez	s7,ffffffffc02057ec <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc02057c4:	85ca                	mv	a1,s2
ffffffffc02057c6:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057c8:	000dc783          	lbu	a5,0(s11)
ffffffffc02057cc:	0d85                	addi	s11,s11,1
ffffffffc02057ce:	3d7d                	addiw	s10,s10,-1
ffffffffc02057d0:	0007851b          	sext.w	a0,a5
ffffffffc02057d4:	f3ed                	bnez	a5,ffffffffc02057b6 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc02057d6:	01a05963          	blez	s10,ffffffffc02057e8 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc02057da:	85ca                	mv	a1,s2
ffffffffc02057dc:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc02057e0:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc02057e2:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc02057e4:	fe0d1be3          	bnez	s10,ffffffffc02057da <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057e8:	6a22                	ld	s4,8(sp)
ffffffffc02057ea:	b505                	j	ffffffffc020560a <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057ec:	3781                	addiw	a5,a5,-32
ffffffffc02057ee:	fcfa7be3          	bgeu	s4,a5,ffffffffc02057c4 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc02057f2:	03f00513          	li	a0,63
ffffffffc02057f6:	85ca                	mv	a1,s2
ffffffffc02057f8:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057fa:	000dc783          	lbu	a5,0(s11)
ffffffffc02057fe:	0d85                	addi	s11,s11,1
ffffffffc0205800:	3d7d                	addiw	s10,s10,-1
ffffffffc0205802:	0007851b          	sext.w	a0,a5
ffffffffc0205806:	dbe1                	beqz	a5,ffffffffc02057d6 <vprintfmt+0x200>
ffffffffc0205808:	fa0cd9e3          	bgez	s9,ffffffffc02057ba <vprintfmt+0x1e4>
ffffffffc020580c:	b7c5                	j	ffffffffc02057ec <vprintfmt+0x216>
            if (err < 0) {
ffffffffc020580e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205812:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc0205814:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205816:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020581a:	8fb9                	xor	a5,a5,a4
ffffffffc020581c:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205820:	02d64563          	blt	a2,a3,ffffffffc020584a <vprintfmt+0x274>
ffffffffc0205824:	00002797          	auipc	a5,0x2
ffffffffc0205828:	2a478793          	addi	a5,a5,676 # ffffffffc0207ac8 <error_string>
ffffffffc020582c:	00369713          	slli	a4,a3,0x3
ffffffffc0205830:	97ba                	add	a5,a5,a4
ffffffffc0205832:	639c                	ld	a5,0(a5)
ffffffffc0205834:	cb99                	beqz	a5,ffffffffc020584a <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205836:	86be                	mv	a3,a5
ffffffffc0205838:	00000617          	auipc	a2,0x0
ffffffffc020583c:	21060613          	addi	a2,a2,528 # ffffffffc0205a48 <etext+0x2e>
ffffffffc0205840:	85ca                	mv	a1,s2
ffffffffc0205842:	8526                	mv	a0,s1
ffffffffc0205844:	0d8000ef          	jal	ffffffffc020591c <printfmt>
ffffffffc0205848:	b3c9                	j	ffffffffc020560a <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020584a:	00002617          	auipc	a2,0x2
ffffffffc020584e:	e6660613          	addi	a2,a2,-410 # ffffffffc02076b0 <etext+0x1c96>
ffffffffc0205852:	85ca                	mv	a1,s2
ffffffffc0205854:	8526                	mv	a0,s1
ffffffffc0205856:	0c6000ef          	jal	ffffffffc020591c <printfmt>
ffffffffc020585a:	bb45                	j	ffffffffc020560a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020585c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020585e:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0205862:	00f74363          	blt	a4,a5,ffffffffc0205868 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0205866:	cf81                	beqz	a5,ffffffffc020587e <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0205868:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020586c:	02044b63          	bltz	s0,ffffffffc02058a2 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0205870:	8622                	mv	a2,s0
ffffffffc0205872:	8a5e                	mv	s4,s7
ffffffffc0205874:	46a9                	li	a3,10
ffffffffc0205876:	b541                	j	ffffffffc02056f6 <vprintfmt+0x120>
            lflag ++;
ffffffffc0205878:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020587a:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020587c:	bb5d                	j	ffffffffc0205632 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc020587e:	000a2403          	lw	s0,0(s4)
ffffffffc0205882:	b7ed                	j	ffffffffc020586c <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0205884:	000a6603          	lwu	a2,0(s4)
ffffffffc0205888:	46a1                	li	a3,8
ffffffffc020588a:	8a2e                	mv	s4,a1
ffffffffc020588c:	b5ad                	j	ffffffffc02056f6 <vprintfmt+0x120>
ffffffffc020588e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205892:	46a9                	li	a3,10
ffffffffc0205894:	8a2e                	mv	s4,a1
ffffffffc0205896:	b585                	j	ffffffffc02056f6 <vprintfmt+0x120>
ffffffffc0205898:	000a6603          	lwu	a2,0(s4)
ffffffffc020589c:	46c1                	li	a3,16
ffffffffc020589e:	8a2e                	mv	s4,a1
ffffffffc02058a0:	bd99                	j	ffffffffc02056f6 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc02058a2:	85ca                	mv	a1,s2
ffffffffc02058a4:	02d00513          	li	a0,45
ffffffffc02058a8:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc02058aa:	40800633          	neg	a2,s0
ffffffffc02058ae:	8a5e                	mv	s4,s7
ffffffffc02058b0:	46a9                	li	a3,10
ffffffffc02058b2:	b591                	j	ffffffffc02056f6 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc02058b4:	e329                	bnez	a4,ffffffffc02058f6 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058b6:	02800793          	li	a5,40
ffffffffc02058ba:	853e                	mv	a0,a5
ffffffffc02058bc:	00002d97          	auipc	s11,0x2
ffffffffc02058c0:	dedd8d93          	addi	s11,s11,-531 # ffffffffc02076a9 <etext+0x1c8f>
ffffffffc02058c4:	b5f5                	j	ffffffffc02057b0 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058c6:	85e6                	mv	a1,s9
ffffffffc02058c8:	856e                	mv	a0,s11
ffffffffc02058ca:	08a000ef          	jal	ffffffffc0205954 <strnlen>
ffffffffc02058ce:	40ad0d3b          	subw	s10,s10,a0
ffffffffc02058d2:	01a05863          	blez	s10,ffffffffc02058e2 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc02058d6:	85ca                	mv	a1,s2
ffffffffc02058d8:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058da:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc02058dc:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058de:	fe0d1ce3          	bnez	s10,ffffffffc02058d6 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058e2:	000dc783          	lbu	a5,0(s11)
ffffffffc02058e6:	0007851b          	sext.w	a0,a5
ffffffffc02058ea:	ec0792e3          	bnez	a5,ffffffffc02057ae <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02058ee:	6a22                	ld	s4,8(sp)
ffffffffc02058f0:	bb29                	j	ffffffffc020560a <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02058f2:	8462                	mv	s0,s8
ffffffffc02058f4:	bbd9                	j	ffffffffc02056ca <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058f6:	85e6                	mv	a1,s9
ffffffffc02058f8:	00002517          	auipc	a0,0x2
ffffffffc02058fc:	db050513          	addi	a0,a0,-592 # ffffffffc02076a8 <etext+0x1c8e>
ffffffffc0205900:	054000ef          	jal	ffffffffc0205954 <strnlen>
ffffffffc0205904:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205908:	02800793          	li	a5,40
                p = "(null)";
ffffffffc020590c:	00002d97          	auipc	s11,0x2
ffffffffc0205910:	d9cd8d93          	addi	s11,s11,-612 # ffffffffc02076a8 <etext+0x1c8e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205914:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205916:	fda040e3          	bgtz	s10,ffffffffc02058d6 <vprintfmt+0x300>
ffffffffc020591a:	bd51                	j	ffffffffc02057ae <vprintfmt+0x1d8>

ffffffffc020591c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020591c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020591e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205922:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205924:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205926:	ec06                	sd	ra,24(sp)
ffffffffc0205928:	f83a                	sd	a4,48(sp)
ffffffffc020592a:	fc3e                	sd	a5,56(sp)
ffffffffc020592c:	e0c2                	sd	a6,64(sp)
ffffffffc020592e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205930:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205932:	ca5ff0ef          	jal	ffffffffc02055d6 <vprintfmt>
}
ffffffffc0205936:	60e2                	ld	ra,24(sp)
ffffffffc0205938:	6161                	addi	sp,sp,80
ffffffffc020593a:	8082                	ret

ffffffffc020593c <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020593c:	00054783          	lbu	a5,0(a0)
ffffffffc0205940:	cb81                	beqz	a5,ffffffffc0205950 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0205942:	4781                	li	a5,0
        cnt ++;
ffffffffc0205944:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0205946:	00f50733          	add	a4,a0,a5
ffffffffc020594a:	00074703          	lbu	a4,0(a4)
ffffffffc020594e:	fb7d                	bnez	a4,ffffffffc0205944 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0205950:	853e                	mv	a0,a5
ffffffffc0205952:	8082                	ret

ffffffffc0205954 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205954:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205956:	e589                	bnez	a1,ffffffffc0205960 <strnlen+0xc>
ffffffffc0205958:	a811                	j	ffffffffc020596c <strnlen+0x18>
        cnt ++;
ffffffffc020595a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020595c:	00f58863          	beq	a1,a5,ffffffffc020596c <strnlen+0x18>
ffffffffc0205960:	00f50733          	add	a4,a0,a5
ffffffffc0205964:	00074703          	lbu	a4,0(a4)
ffffffffc0205968:	fb6d                	bnez	a4,ffffffffc020595a <strnlen+0x6>
ffffffffc020596a:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020596c:	852e                	mv	a0,a1
ffffffffc020596e:	8082                	ret

ffffffffc0205970 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205970:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205972:	0005c703          	lbu	a4,0(a1)
ffffffffc0205976:	0585                	addi	a1,a1,1
ffffffffc0205978:	0785                	addi	a5,a5,1
ffffffffc020597a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020597e:	fb75                	bnez	a4,ffffffffc0205972 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205980:	8082                	ret

ffffffffc0205982 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205982:	00054783          	lbu	a5,0(a0)
ffffffffc0205986:	e791                	bnez	a5,ffffffffc0205992 <strcmp+0x10>
ffffffffc0205988:	a01d                	j	ffffffffc02059ae <strcmp+0x2c>
ffffffffc020598a:	00054783          	lbu	a5,0(a0)
ffffffffc020598e:	cb99                	beqz	a5,ffffffffc02059a4 <strcmp+0x22>
ffffffffc0205990:	0585                	addi	a1,a1,1
ffffffffc0205992:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0205996:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205998:	fef709e3          	beq	a4,a5,ffffffffc020598a <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020599c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02059a0:	9d19                	subw	a0,a0,a4
ffffffffc02059a2:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059a4:	0015c703          	lbu	a4,1(a1)
ffffffffc02059a8:	4501                	li	a0,0
}
ffffffffc02059aa:	9d19                	subw	a0,a0,a4
ffffffffc02059ac:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059ae:	0005c703          	lbu	a4,0(a1)
ffffffffc02059b2:	4501                	li	a0,0
ffffffffc02059b4:	b7f5                	j	ffffffffc02059a0 <strcmp+0x1e>

ffffffffc02059b6 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02059b6:	ce01                	beqz	a2,ffffffffc02059ce <strncmp+0x18>
ffffffffc02059b8:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02059bc:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02059be:	cb91                	beqz	a5,ffffffffc02059d2 <strncmp+0x1c>
ffffffffc02059c0:	0005c703          	lbu	a4,0(a1)
ffffffffc02059c4:	00f71763          	bne	a4,a5,ffffffffc02059d2 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc02059c8:	0505                	addi	a0,a0,1
ffffffffc02059ca:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02059cc:	f675                	bnez	a2,ffffffffc02059b8 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059ce:	4501                	li	a0,0
ffffffffc02059d0:	8082                	ret
ffffffffc02059d2:	00054503          	lbu	a0,0(a0)
ffffffffc02059d6:	0005c783          	lbu	a5,0(a1)
ffffffffc02059da:	9d1d                	subw	a0,a0,a5
}
ffffffffc02059dc:	8082                	ret

ffffffffc02059de <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02059de:	a021                	j	ffffffffc02059e6 <strchr+0x8>
        if (*s == c) {
ffffffffc02059e0:	00f58763          	beq	a1,a5,ffffffffc02059ee <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc02059e4:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02059e6:	00054783          	lbu	a5,0(a0)
ffffffffc02059ea:	fbfd                	bnez	a5,ffffffffc02059e0 <strchr+0x2>
    }
    return NULL;
ffffffffc02059ec:	4501                	li	a0,0
}
ffffffffc02059ee:	8082                	ret

ffffffffc02059f0 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02059f0:	ca01                	beqz	a2,ffffffffc0205a00 <memset+0x10>
ffffffffc02059f2:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02059f4:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02059f6:	0785                	addi	a5,a5,1
ffffffffc02059f8:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02059fc:	fef61de3          	bne	a2,a5,ffffffffc02059f6 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205a00:	8082                	ret

ffffffffc0205a02 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205a02:	ca19                	beqz	a2,ffffffffc0205a18 <memcpy+0x16>
ffffffffc0205a04:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205a06:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205a08:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a0c:	0585                	addi	a1,a1,1
ffffffffc0205a0e:	0785                	addi	a5,a5,1
ffffffffc0205a10:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205a14:	feb61ae3          	bne	a2,a1,ffffffffc0205a08 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205a18:	8082                	ret
