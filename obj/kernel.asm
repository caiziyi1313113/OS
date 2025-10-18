
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00005297          	auipc	t0,0x5
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0205000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00005297          	auipc	t0,0x5
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0205008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02042b7          	lui	t0,0xc0204
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
ffffffffc020003c:	c0204137          	lui	sp,0xc0204

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	5bc50513          	addi	a0,a0,1468 # ffffffffc0201608 <etext+0x2>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	5c650513          	addi	a0,a0,1478 # ffffffffc0201628 <etext+0x22>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	59858593          	addi	a1,a1,1432 # ffffffffc0201606 <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	5d250513          	addi	a0,a0,1490 # ffffffffc0201648 <etext+0x42>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00005597          	auipc	a1,0x5
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0205018 <kmalloc_caches>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	5de50513          	addi	a0,a0,1502 # ffffffffc0201668 <etext+0x62>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00005597          	auipc	a1,0x5
ffffffffc020009a:	04a58593          	addi	a1,a1,74 # ffffffffc02050e0 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	5ea50513          	addi	a0,a0,1514 # ffffffffc0201688 <etext+0x82>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00005597          	auipc	a1,0x5
ffffffffc02000ae:	43558593          	addi	a1,a1,1077 # ffffffffc02054df <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00001517          	auipc	a0,0x1
ffffffffc02000d0:	5dc50513          	addi	a0,a0,1500 # ffffffffc02016a8 <etext+0xa2>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00005517          	auipc	a0,0x5
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0205018 <kmalloc_caches>
ffffffffc02000e0:	00005617          	auipc	a2,0x5
ffffffffc02000e4:	00060613          	mv	a2,a2
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	504010ef          	jal	ra,ffffffffc02015f4 <memset>
    dtb_init();
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00001517          	auipc	a0,0x1
ffffffffc0200100:	5dc50513          	addi	a0,a0,1500 # ffffffffc02016d8 <etext+0xd2>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010c:	0df000ef          	jal	ra,ffffffffc02009ea <pmm_init>

    /* do nothing */
    while (1)
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    (*cnt) ++;
ffffffffc020011e:	401c                	lw	a5,0(s0)
}
ffffffffc0200120:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
}
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200140:	03c010ef          	jal	ra,ffffffffc020117c <vprintfmt>
    return cnt;
}
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0204028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200172:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200174:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	006010ef          	jal	ra,ffffffffc020117c <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c2:	00005317          	auipc	t1,0x5
ffffffffc02001c6:	eb630313          	addi	t1,t1,-330 # ffffffffc0205078 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00001517          	auipc	a0,0x1
ffffffffc02001f6:	50650513          	addi	a0,a0,1286 # ffffffffc02016f8 <etext+0xf2>
    va_start(ap, fmt);
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
    cprintf("\n");
ffffffffc0200208:	00001517          	auipc	a0,0x1
ffffffffc020020c:	4c850513          	addi	a0,a0,1224 # ffffffffc02016d0 <etext+0xca>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	3280106f          	j	ffffffffc0201544 <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200220:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200222:	00001517          	auipc	a0,0x1
ffffffffc0200226:	4f650513          	addi	a0,a0,1270 # ffffffffc0201718 <etext+0x112>
void dtb_init(void) {
ffffffffc020022a:	fc86                	sd	ra,120(sp)
ffffffffc020022c:	f8a2                	sd	s0,112(sp)
ffffffffc020022e:	e8d2                	sd	s4,80(sp)
ffffffffc0200230:	f4a6                	sd	s1,104(sp)
ffffffffc0200232:	f0ca                	sd	s2,96(sp)
ffffffffc0200234:	ecce                	sd	s3,88(sp)
ffffffffc0200236:	e4d6                	sd	s5,72(sp)
ffffffffc0200238:	e0da                	sd	s6,64(sp)
ffffffffc020023a:	fc5e                	sd	s7,56(sp)
ffffffffc020023c:	f862                	sd	s8,48(sp)
ffffffffc020023e:	f466                	sd	s9,40(sp)
ffffffffc0200240:	f06a                	sd	s10,32(sp)
ffffffffc0200242:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200248:	00005597          	auipc	a1,0x5
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0205000 <boot_hartid>
ffffffffc0200250:	00001517          	auipc	a0,0x1
ffffffffc0200254:	4d850513          	addi	a0,a0,1240 # ffffffffc0201728 <etext+0x122>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020025c:	00005417          	auipc	s0,0x5
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0205008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	4d250513          	addi	a0,a0,1234 # ffffffffc0201738 <etext+0x132>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200276:	00001517          	auipc	a0,0x1
ffffffffc020027a:	4da50513          	addi	a0,a0,1242 # ffffffffc0201750 <etext+0x14a>
    if (boot_dtb == 0) {
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020028a:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200290:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002bc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfedae0d>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02002ca:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002f4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200302:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020031c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200320:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200326:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200328:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020032e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200330:	00001917          	auipc	s2,0x1
ffffffffc0200334:	47090913          	addi	s2,s2,1136 # ffffffffc02017a0 <etext+0x19a>
ffffffffc0200338:	49bd                	li	s3,15
        switch (token) {
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020033e:	00001497          	auipc	s1,0x1
ffffffffc0200342:	45a48493          	addi	s1,s1,1114 # ffffffffc0201798 <etext+0x192>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200392:	00001517          	auipc	a0,0x1
ffffffffc0200396:	48650513          	addi	a0,a0,1158 # ffffffffc0201818 <etext+0x212>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020039e:	00001517          	auipc	a0,0x1
ffffffffc02003a2:	4b250513          	addi	a0,a0,1202 # ffffffffc0201850 <etext+0x24a>
}
ffffffffc02003a6:	7446                	ld	s0,112(sp)
ffffffffc02003a8:	70e6                	ld	ra,120(sp)
ffffffffc02003aa:	74a6                	ld	s1,104(sp)
ffffffffc02003ac:	7906                	ld	s2,96(sp)
ffffffffc02003ae:	69e6                	ld	s3,88(sp)
ffffffffc02003b0:	6a46                	ld	s4,80(sp)
ffffffffc02003b2:	6aa6                	ld	s5,72(sp)
ffffffffc02003b4:	6b06                	ld	s6,64(sp)
ffffffffc02003b6:	7be2                	ld	s7,56(sp)
ffffffffc02003b8:	7c42                	ld	s8,48(sp)
ffffffffc02003ba:	7ca2                	ld	s9,40(sp)
ffffffffc02003bc:	7d02                	ld	s10,32(sp)
ffffffffc02003be:	6de2                	ld	s11,24(sp)
ffffffffc02003c0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
}
ffffffffc02003c4:	7446                	ld	s0,112(sp)
ffffffffc02003c6:	70e6                	ld	ra,120(sp)
ffffffffc02003c8:	74a6                	ld	s1,104(sp)
ffffffffc02003ca:	7906                	ld	s2,96(sp)
ffffffffc02003cc:	69e6                	ld	s3,88(sp)
ffffffffc02003ce:	6a46                	ld	s4,80(sp)
ffffffffc02003d0:	6aa6                	ld	s5,72(sp)
ffffffffc02003d2:	6b06                	ld	s6,64(sp)
ffffffffc02003d4:	7be2                	ld	s7,56(sp)
ffffffffc02003d6:	7c42                	ld	s8,48(sp)
ffffffffc02003d8:	7ca2                	ld	s9,40(sp)
ffffffffc02003da:	7d02                	ld	s10,32(sp)
ffffffffc02003dc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003de:	00001517          	auipc	a0,0x1
ffffffffc02003e2:	39250513          	addi	a0,a0,914 # ffffffffc0201770 <etext+0x16a>
}
ffffffffc02003e6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
                int name_len = strlen(name);
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	172010ef          	jal	ra,ffffffffc020155e <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02003f8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003fa:	1d4010ef          	jal	ra,ffffffffc02015ce <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200400:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020042e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	120010ef          	jal	ra,ffffffffc02015b0 <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004a4:	00001517          	auipc	a0,0x1
ffffffffc02004a8:	30450513          	addi	a0,a0,772 # ffffffffc02017a8 <etext+0x1a2>
           fdt32_to_cpu(x >> 32);
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200532:	011b78b3          	and	a7,s6,a7
ffffffffc0200536:	005eeeb3          	or	t4,t4,t0
ffffffffc020053a:	00c6e733          	or	a4,a3,a2
ffffffffc020053e:	006c6c33          	or	s8,s8,t1
ffffffffc0200542:	010b76b3          	and	a3,s6,a6
ffffffffc0200546:	00bb7b33          	and	s6,s6,a1
ffffffffc020054a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020054e:	016c6b33          	or	s6,s8,s6
ffffffffc0200552:	01146433          	or	s0,s0,a7
ffffffffc0200556:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020055c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020055e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200560:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00001517          	auipc	a0,0x1
ffffffffc0200576:	25650513          	addi	a0,a0,598 # ffffffffc02017c8 <etext+0x1c2>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00001517          	auipc	a0,0x1
ffffffffc0200588:	25c50513          	addi	a0,a0,604 # ffffffffc02017e0 <etext+0x1da>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00001517          	auipc	a0,0x1
ffffffffc020059a:	26a50513          	addi	a0,a0,618 # ffffffffc0201800 <etext+0x1fa>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005a2:	00001517          	auipc	a0,0x1
ffffffffc02005a6:	2ae50513          	addi	a0,a0,686 # ffffffffc0201850 <etext+0x24a>
        memory_base = mem_base;
ffffffffc02005aa:	00005797          	auipc	a5,0x5
ffffffffc02005ae:	ac87bb23          	sd	s0,-1322(a5) # ffffffffc0205080 <memory_base>
        memory_size = mem_size;
ffffffffc02005b2:	00005797          	auipc	a5,0x5
ffffffffc02005b6:	ad67bb23          	sd	s6,-1322(a5) # ffffffffc0205088 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02005bc:	00005517          	auipc	a0,0x5
ffffffffc02005c0:	ac453503          	ld	a0,-1340(a0) # ffffffffc0205080 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc02005c6:	00005517          	auipc	a0,0x5
ffffffffc02005ca:	ac253503          	ld	a0,-1342(a0) # ffffffffc0205088 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_alloc_pages>:
            base, n, buddy_node_count);
}

// ======== 分配物理页 ========
static struct Page *buddy_alloc_pages(size_t n) {
    if (n == 0) return NULL;
ffffffffc02005d0:	10050763          	beqz	a0,ffffffffc02006de <buddy_alloc_pages+0x10e>
    unsigned size = fixsize(n);
ffffffffc02005d4:	2501                	sext.w	a0,a0
    while (n < size) n <<= 1;
ffffffffc02005d6:	4785                	li	a5,1
    unsigned n = 1;
ffffffffc02005d8:	4685                	li	a3,1
    while (n < size) n <<= 1;
ffffffffc02005da:	00a7f663          	bgeu	a5,a0,ffffffffc02005e6 <buddy_alloc_pages+0x16>
ffffffffc02005de:	0016969b          	slliw	a3,a3,0x1
ffffffffc02005e2:	fea6eee3          	bltu	a3,a0,ffffffffc02005de <buddy_alloc_pages+0xe>
    if (buddy_longest[0] < size) return NULL;
ffffffffc02005e6:	00005597          	auipc	a1,0x5
ffffffffc02005ea:	ab25b583          	ld	a1,-1358(a1) # ffffffffc0205098 <buddy_longest>
ffffffffc02005ee:	419c                	lw	a5,0(a1)
ffffffffc02005f0:	0ed7e763          	bltu	a5,a3,ffffffffc02006de <buddy_alloc_pages+0x10e>

    unsigned index = 0, node_size;
    for (node_size = buddy_size; node_size != size; node_size >>= 1) {
ffffffffc02005f4:	00005e17          	auipc	t3,0x5
ffffffffc02005f8:	aace2e03          	lw	t3,-1364(t3) # ffffffffc02050a0 <buddy_size>
ffffffffc02005fc:	0ede0363          	beq	t3,a3,ffffffffc02006e2 <buddy_alloc_pages+0x112>
ffffffffc0200600:	8672                	mv	a2,t3
    unsigned index = 0, node_size;
ffffffffc0200602:	4781                	li	a5,0
        if (buddy_longest[LEFT_LEAF(index)] >= size)
ffffffffc0200604:	0017951b          	slliw	a0,a5,0x1
ffffffffc0200608:	0015079b          	addiw	a5,a0,1
ffffffffc020060c:	02079813          	slli	a6,a5,0x20
ffffffffc0200610:	01e85713          	srli	a4,a6,0x1e
ffffffffc0200614:	972e                	add	a4,a4,a1
ffffffffc0200616:	4318                	lw	a4,0(a4)
    for (node_size = buddy_size; node_size != size; node_size >>= 1) {
ffffffffc0200618:	0016561b          	srliw	a2,a2,0x1
        if (buddy_longest[LEFT_LEAF(index)] >= size)
ffffffffc020061c:	00d77463          	bgeu	a4,a3,ffffffffc0200624 <buddy_alloc_pages+0x54>
            index = LEFT_LEAF(index);
        else
            index = RIGHT_LEAF(index);
ffffffffc0200620:	0025079b          	addiw	a5,a0,2
    for (node_size = buddy_size; node_size != size; node_size >>= 1) {
ffffffffc0200624:	fed610e3          	bne	a2,a3,ffffffffc0200604 <buddy_alloc_pages+0x34>
    }

    // 分配成功
    buddy_longest[index] = 0;
    unsigned offset = (index + 1) * node_size - buddy_size;
ffffffffc0200628:	0017871b          	addiw	a4,a5,1
ffffffffc020062c:	02d7053b          	mulw	a0,a4,a3
    buddy_longest[index] = 0;
ffffffffc0200630:	02079813          	slli	a6,a5,0x20
ffffffffc0200634:	01e85613          	srli	a2,a6,0x1e
ffffffffc0200638:	962e                	add	a2,a2,a1
ffffffffc020063a:	00062023          	sw	zero,0(a2) # ff0000 <kern_entry-0xffffffffbf210000>
    unsigned offset = (index + 1) * node_size - buddy_size;
ffffffffc020063e:	41c5053b          	subw	a0,a0,t3
        buddy_longest[index] =
            MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
    }

    // 标记 page 状态
    struct Page *page = buddy_base + offset;
ffffffffc0200642:	02051613          	slli	a2,a0,0x20
ffffffffc0200646:	01a65e13          	srli	t3,a2,0x1a
    while (index) {
ffffffffc020064a:	e781                	bnez	a5,ffffffffc0200652 <buddy_alloc_pages+0x82>
ffffffffc020064c:	a0a1                	j	ffffffffc0200694 <buddy_alloc_pages+0xc4>
ffffffffc020064e:	0017871b          	addiw	a4,a5,1
        index = PARENT(index);
ffffffffc0200652:	0017579b          	srliw	a5,a4,0x1
ffffffffc0200656:	37fd                	addiw	a5,a5,-1
            MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
ffffffffc0200658:	9b79                	andi	a4,a4,-2
ffffffffc020065a:	0017961b          	slliw	a2,a5,0x1
ffffffffc020065e:	2605                	addiw	a2,a2,1
ffffffffc0200660:	1702                	slli	a4,a4,0x20
ffffffffc0200662:	02061513          	slli	a0,a2,0x20
ffffffffc0200666:	9301                	srli	a4,a4,0x20
ffffffffc0200668:	01e55613          	srli	a2,a0,0x1e
ffffffffc020066c:	070a                	slli	a4,a4,0x2
ffffffffc020066e:	972e                	add	a4,a4,a1
ffffffffc0200670:	962e                	add	a2,a2,a1
ffffffffc0200672:	00072803          	lw	a6,0(a4)
ffffffffc0200676:	4210                	lw	a2,0(a2)
        buddy_longest[index] =
ffffffffc0200678:	02079513          	slli	a0,a5,0x20
ffffffffc020067c:	01e55713          	srli	a4,a0,0x1e
            MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
ffffffffc0200680:	0008089b          	sext.w	a7,a6
ffffffffc0200684:	0006031b          	sext.w	t1,a2
        buddy_longest[index] =
ffffffffc0200688:	972e                	add	a4,a4,a1
            MAX(buddy_longest[LEFT_LEAF(index)], buddy_longest[RIGHT_LEAF(index)]);
ffffffffc020068a:	01137363          	bgeu	t1,a7,ffffffffc0200690 <buddy_alloc_pages+0xc0>
ffffffffc020068e:	8642                	mv	a2,a6
        buddy_longest[index] =
ffffffffc0200690:	c310                	sw	a2,0(a4)
    while (index) {
ffffffffc0200692:	ffd5                	bnez	a5,ffffffffc020064e <buddy_alloc_pages+0x7e>
    struct Page *page = buddy_base + offset;
ffffffffc0200694:	fff6861b          	addiw	a2,a3,-1
ffffffffc0200698:	02061793          	slli	a5,a2,0x20
ffffffffc020069c:	01a7d613          	srli	a2,a5,0x1a
ffffffffc02006a0:	00005517          	auipc	a0,0x5
ffffffffc02006a4:	9f053503          	ld	a0,-1552(a0) # ffffffffc0205090 <buddy_base>
ffffffffc02006a8:	9572                	add	a0,a0,t3
    for (unsigned i = 0; i < size; i++) {
ffffffffc02006aa:	04860613          	addi	a2,a2,72
ffffffffc02006ae:	00850713          	addi	a4,a0,8
ffffffffc02006b2:	962a                	add	a2,a2,a0
        SetPageReserved(page + i);
        ClearPageProperty(page + i);
ffffffffc02006b4:	631c                	ld	a5,0(a4)
    for (unsigned i = 0; i < size; i++) {
ffffffffc02006b6:	04070713          	addi	a4,a4,64
        ClearPageProperty(page + i);
ffffffffc02006ba:	9bf5                	andi	a5,a5,-3
ffffffffc02006bc:	0017e793          	ori	a5,a5,1
ffffffffc02006c0:	fcf73023          	sd	a5,-64(a4)
    for (unsigned i = 0; i < size; i++) {
ffffffffc02006c4:	fee618e3          	bne	a2,a4,ffffffffc02006b4 <buddy_alloc_pages+0xe4>
    }

    nr_buddy_free_pages -= size;
ffffffffc02006c8:	00005717          	auipc	a4,0x5
ffffffffc02006cc:	9e070713          	addi	a4,a4,-1568 # ffffffffc02050a8 <nr_buddy_free_pages>
ffffffffc02006d0:	631c                	ld	a5,0(a4)
ffffffffc02006d2:	1682                	slli	a3,a3,0x20
ffffffffc02006d4:	9281                	srli	a3,a3,0x20
ffffffffc02006d6:	40d786b3          	sub	a3,a5,a3
ffffffffc02006da:	e314                	sd	a3,0(a4)
    return page;
ffffffffc02006dc:	8082                	ret
    if (n == 0) return NULL;
ffffffffc02006de:	4501                	li	a0,0
}
ffffffffc02006e0:	8082                	ret
    buddy_longest[index] = 0;
ffffffffc02006e2:	0005a023          	sw	zero,0(a1)
ffffffffc02006e6:	4e01                	li	t3,0
ffffffffc02006e8:	b775                	j	ffffffffc0200694 <buddy_alloc_pages+0xc4>

ffffffffc02006ea <buddy_nr_free_pages>:
}

// ======== 空闲页统计 ========
static size_t buddy_nr_free_pages(void) {
    return nr_buddy_free_pages;
}
ffffffffc02006ea:	00005517          	auipc	a0,0x5
ffffffffc02006ee:	9be53503          	ld	a0,-1602(a0) # ffffffffc02050a8 <nr_buddy_free_pages>
ffffffffc02006f2:	8082                	ret

ffffffffc02006f4 <buddy_init>:
static void buddy_init(void) {
ffffffffc02006f4:	1141                	addi	sp,sp,-16
    cprintf("buddy_pmm_manager: initializing...\n");
ffffffffc02006f6:	00001517          	auipc	a0,0x1
ffffffffc02006fa:	17250513          	addi	a0,a0,370 # ffffffffc0201868 <etext+0x262>
static void buddy_init(void) {
ffffffffc02006fe:	e406                	sd	ra,8(sp)
    cprintf("buddy_pmm_manager: initializing...\n");
ffffffffc0200700:	a4dff0ef          	jal	ra,ffffffffc020014c <cprintf>
}
ffffffffc0200704:	60a2                	ld	ra,8(sp)
    buddy_size = 0;
ffffffffc0200706:	00005797          	auipc	a5,0x5
ffffffffc020070a:	9807ad23          	sw	zero,-1638(a5) # ffffffffc02050a0 <buddy_size>
    buddy_longest = NULL;
ffffffffc020070e:	00005797          	auipc	a5,0x5
ffffffffc0200712:	9807b523          	sd	zero,-1654(a5) # ffffffffc0205098 <buddy_longest>
    buddy_base = NULL;
ffffffffc0200716:	00005797          	auipc	a5,0x5
ffffffffc020071a:	9607bd23          	sd	zero,-1670(a5) # ffffffffc0205090 <buddy_base>
    nr_buddy_free_pages = 0;
ffffffffc020071e:	00005797          	auipc	a5,0x5
ffffffffc0200722:	9807b523          	sd	zero,-1654(a5) # ffffffffc02050a8 <nr_buddy_free_pages>
}
ffffffffc0200726:	0141                	addi	sp,sp,16
ffffffffc0200728:	8082                	ret

ffffffffc020072a <buddy_free_pages>:
    assert(n > 0);
ffffffffc020072a:	c9f9                	beqz	a1,ffffffffc0200800 <buddy_free_pages+0xd6>
    unsigned offset = base - buddy_base;
ffffffffc020072c:	00005797          	auipc	a5,0x5
ffffffffc0200730:	9647b783          	ld	a5,-1692(a5) # ffffffffc0205090 <buddy_base>
ffffffffc0200734:	40f507b3          	sub	a5,a0,a5
ffffffffc0200738:	4067d713          	srai	a4,a5,0x6
    unsigned index = offset + buddy_size - 1;
ffffffffc020073c:	00005797          	auipc	a5,0x5
ffffffffc0200740:	9647a783          	lw	a5,-1692(a5) # ffffffffc02050a0 <buddy_size>
ffffffffc0200744:	37fd                	addiw	a5,a5,-1
ffffffffc0200746:	9fb9                	addw	a5,a5,a4
    for (; buddy_longest[index]; index = PARENT(index))
ffffffffc0200748:	02079693          	slli	a3,a5,0x20
ffffffffc020074c:	01e6d713          	srli	a4,a3,0x1e
ffffffffc0200750:	00005897          	auipc	a7,0x5
ffffffffc0200754:	9488b883          	ld	a7,-1720(a7) # ffffffffc0205098 <buddy_longest>
ffffffffc0200758:	9746                	add	a4,a4,a7
ffffffffc020075a:	4314                	lw	a3,0(a4)
    unsigned node_size = 1;
ffffffffc020075c:	4605                	li	a2,1
    for (; buddy_longest[index]; index = PARENT(index))
ffffffffc020075e:	ce91                	beqz	a3,ffffffffc020077a <buddy_free_pages+0x50>
ffffffffc0200760:	2785                	addiw	a5,a5,1
ffffffffc0200762:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200766:	37fd                	addiw	a5,a5,-1
ffffffffc0200768:	02079693          	slli	a3,a5,0x20
ffffffffc020076c:	01e6d713          	srli	a4,a3,0x1e
ffffffffc0200770:	9746                	add	a4,a4,a7
ffffffffc0200772:	4314                	lw	a3,0(a4)
        node_size <<= 1;
ffffffffc0200774:	0016161b          	slliw	a2,a2,0x1
    for (; buddy_longest[index]; index = PARENT(index))
ffffffffc0200778:	f6e5                	bnez	a3,ffffffffc0200760 <buddy_free_pages+0x36>
    buddy_longest[index] = node_size;
ffffffffc020077a:	c310                	sw	a2,0(a4)
    while (index) {
ffffffffc020077c:	cbb1                	beqz	a5,ffffffffc02007d0 <buddy_free_pages+0xa6>
        index = PARENT(index);
ffffffffc020077e:	2785                	addiw	a5,a5,1
ffffffffc0200780:	0017d81b          	srliw	a6,a5,0x1
ffffffffc0200784:	387d                	addiw	a6,a6,-1
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
ffffffffc0200786:	ffe7f713          	andi	a4,a5,-2
        unsigned left = buddy_longest[LEFT_LEAF(index)];
ffffffffc020078a:	0018169b          	slliw	a3,a6,0x1
ffffffffc020078e:	2685                	addiw	a3,a3,1
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
ffffffffc0200790:	1702                	slli	a4,a4,0x20
        unsigned left = buddy_longest[LEFT_LEAF(index)];
ffffffffc0200792:	02069793          	slli	a5,a3,0x20
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
ffffffffc0200796:	9301                	srli	a4,a4,0x20
        unsigned left = buddy_longest[LEFT_LEAF(index)];
ffffffffc0200798:	01e7d693          	srli	a3,a5,0x1e
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
ffffffffc020079c:	070a                	slli	a4,a4,0x2
ffffffffc020079e:	9746                	add	a4,a4,a7
        unsigned left = buddy_longest[LEFT_LEAF(index)];
ffffffffc02007a0:	96c6                	add	a3,a3,a7
        unsigned right = buddy_longest[RIGHT_LEAF(index)];
ffffffffc02007a2:	00072303          	lw	t1,0(a4)
        unsigned left = buddy_longest[LEFT_LEAF(index)];
ffffffffc02007a6:	4294                	lw	a3,0(a3)
            buddy_longest[index] = node_size;
ffffffffc02007a8:	02081793          	slli	a5,a6,0x20
ffffffffc02007ac:	01e7d713          	srli	a4,a5,0x1e
        node_size <<= 1;
ffffffffc02007b0:	0016161b          	slliw	a2,a2,0x1
        if (left + right == node_size)
ffffffffc02007b4:	00668ebb          	addw	t4,a3,t1
        index = PARENT(index);
ffffffffc02007b8:	0008079b          	sext.w	a5,a6
            buddy_longest[index] = node_size;
ffffffffc02007bc:	9746                	add	a4,a4,a7
        if (left + right == node_size)
ffffffffc02007be:	02ce8f63          	beq	t4,a2,ffffffffc02007fc <buddy_free_pages+0xd2>
            buddy_longest[index] = MAX(left, right);
ffffffffc02007c2:	8836                	mv	a6,a3
ffffffffc02007c4:	0066f363          	bgeu	a3,t1,ffffffffc02007ca <buddy_free_pages+0xa0>
ffffffffc02007c8:	881a                	mv	a6,t1
ffffffffc02007ca:	01072023          	sw	a6,0(a4)
    while (index) {
ffffffffc02007ce:	fbc5                	bnez	a5,ffffffffc020077e <buddy_free_pages+0x54>
    for (unsigned i = 0; i < n; i++) {
ffffffffc02007d0:	4701                	li	a4,0
ffffffffc02007d2:	4781                	li	a5,0
        ClearPageReserved(base + i);
ffffffffc02007d4:	079a                	slli	a5,a5,0x6
ffffffffc02007d6:	00f50633          	add	a2,a0,a5
        ClearPageProperty(base + i);
ffffffffc02007da:	6614                	ld	a3,8(a2)
    for (unsigned i = 0; i < n; i++) {
ffffffffc02007dc:	2705                	addiw	a4,a4,1
ffffffffc02007de:	02071793          	slli	a5,a4,0x20
        ClearPageProperty(base + i);
ffffffffc02007e2:	9af1                	andi	a3,a3,-4
    for (unsigned i = 0; i < n; i++) {
ffffffffc02007e4:	9381                	srli	a5,a5,0x20
        ClearPageProperty(base + i);
ffffffffc02007e6:	e614                	sd	a3,8(a2)
    for (unsigned i = 0; i < n; i++) {
ffffffffc02007e8:	feb7e6e3          	bltu	a5,a1,ffffffffc02007d4 <buddy_free_pages+0xaa>
    nr_buddy_free_pages += n;
ffffffffc02007ec:	00005717          	auipc	a4,0x5
ffffffffc02007f0:	8bc70713          	addi	a4,a4,-1860 # ffffffffc02050a8 <nr_buddy_free_pages>
ffffffffc02007f4:	631c                	ld	a5,0(a4)
ffffffffc02007f6:	95be                	add	a1,a1,a5
ffffffffc02007f8:	e30c                	sd	a1,0(a4)
ffffffffc02007fa:	8082                	ret
            buddy_longest[index] = node_size;
ffffffffc02007fc:	c310                	sw	a2,0(a4)
ffffffffc02007fe:	bfbd                	j	ffffffffc020077c <buddy_free_pages+0x52>
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc0200800:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200802:	00001697          	auipc	a3,0x1
ffffffffc0200806:	08e68693          	addi	a3,a3,142 # ffffffffc0201890 <etext+0x28a>
ffffffffc020080a:	00001617          	auipc	a2,0x1
ffffffffc020080e:	08e60613          	addi	a2,a2,142 # ffffffffc0201898 <etext+0x292>
ffffffffc0200812:	06e00593          	li	a1,110
ffffffffc0200816:	00001517          	auipc	a0,0x1
ffffffffc020081a:	09a50513          	addi	a0,a0,154 # ffffffffc02018b0 <etext+0x2aa>
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc020081e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200820:	9a3ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200824 <buddy_check>:

// ======== 自检函数 ========
static void buddy_check(void) {
ffffffffc0200824:	1101                	addi	sp,sp,-32
    cprintf("[buddy_check] total free: %u pages\n", nr_buddy_free_pages);
ffffffffc0200826:	00005597          	auipc	a1,0x5
ffffffffc020082a:	8825b583          	ld	a1,-1918(a1) # ffffffffc02050a8 <nr_buddy_free_pages>
ffffffffc020082e:	00001517          	auipc	a0,0x1
ffffffffc0200832:	09a50513          	addi	a0,a0,154 # ffffffffc02018c8 <etext+0x2c2>
static void buddy_check(void) {
ffffffffc0200836:	ec06                	sd	ra,24(sp)
ffffffffc0200838:	e822                	sd	s0,16(sp)
ffffffffc020083a:	e426                	sd	s1,8(sp)
ffffffffc020083c:	e04a                	sd	s2,0(sp)
    cprintf("[buddy_check] total free: %u pages\n", nr_buddy_free_pages);
ffffffffc020083e:	90fff0ef          	jal	ra,ffffffffc020014c <cprintf>

    struct Page *p0, *p1, *p2;
    p0 = buddy_alloc_pages(1);
ffffffffc0200842:	4505                	li	a0,1
ffffffffc0200844:	d8dff0ef          	jal	ra,ffffffffc02005d0 <buddy_alloc_pages>
    assert(p0 != NULL);
ffffffffc0200848:	c131                	beqz	a0,ffffffffc020088c <buddy_check+0x68>
ffffffffc020084a:	842a                	mv	s0,a0
    p1 = buddy_alloc_pages(2);
ffffffffc020084c:	4509                	li	a0,2
ffffffffc020084e:	d83ff0ef          	jal	ra,ffffffffc02005d0 <buddy_alloc_pages>
ffffffffc0200852:	892a                	mv	s2,a0
    assert(p1 != NULL);
ffffffffc0200854:	cd25                	beqz	a0,ffffffffc02008cc <buddy_check+0xa8>
    p2 = buddy_alloc_pages(4);
ffffffffc0200856:	4511                	li	a0,4
ffffffffc0200858:	d79ff0ef          	jal	ra,ffffffffc02005d0 <buddy_alloc_pages>
ffffffffc020085c:	84aa                	mv	s1,a0
    assert(p2 != NULL);
ffffffffc020085e:	c539                	beqz	a0,ffffffffc02008ac <buddy_check+0x88>
    buddy_free_pages(p0, 1);
ffffffffc0200860:	8522                	mv	a0,s0
ffffffffc0200862:	4585                	li	a1,1
ffffffffc0200864:	ec7ff0ef          	jal	ra,ffffffffc020072a <buddy_free_pages>
    buddy_free_pages(p1, 2);
ffffffffc0200868:	854a                	mv	a0,s2
ffffffffc020086a:	4589                	li	a1,2
ffffffffc020086c:	ebfff0ef          	jal	ra,ffffffffc020072a <buddy_free_pages>
    buddy_free_pages(p2, 4);
ffffffffc0200870:	8526                	mv	a0,s1
ffffffffc0200872:	4591                	li	a1,4
ffffffffc0200874:	eb7ff0ef          	jal	ra,ffffffffc020072a <buddy_free_pages>

    cprintf("[buddy_check] passed!\n");
}
ffffffffc0200878:	6442                	ld	s0,16(sp)
ffffffffc020087a:	60e2                	ld	ra,24(sp)
ffffffffc020087c:	64a2                	ld	s1,8(sp)
ffffffffc020087e:	6902                	ld	s2,0(sp)
    cprintf("[buddy_check] passed!\n");
ffffffffc0200880:	00001517          	auipc	a0,0x1
ffffffffc0200884:	0a050513          	addi	a0,a0,160 # ffffffffc0201920 <etext+0x31a>
}
ffffffffc0200888:	6105                	addi	sp,sp,32
    cprintf("[buddy_check] passed!\n");
ffffffffc020088a:	b0c9                	j	ffffffffc020014c <cprintf>
    assert(p0 != NULL);
ffffffffc020088c:	00001697          	auipc	a3,0x1
ffffffffc0200890:	06468693          	addi	a3,a3,100 # ffffffffc02018f0 <etext+0x2ea>
ffffffffc0200894:	00001617          	auipc	a2,0x1
ffffffffc0200898:	00460613          	addi	a2,a2,4 # ffffffffc0201898 <etext+0x292>
ffffffffc020089c:	09700593          	li	a1,151
ffffffffc02008a0:	00001517          	auipc	a0,0x1
ffffffffc02008a4:	01050513          	addi	a0,a0,16 # ffffffffc02018b0 <etext+0x2aa>
ffffffffc02008a8:	91bff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p2 != NULL);
ffffffffc02008ac:	00001697          	auipc	a3,0x1
ffffffffc02008b0:	06468693          	addi	a3,a3,100 # ffffffffc0201910 <etext+0x30a>
ffffffffc02008b4:	00001617          	auipc	a2,0x1
ffffffffc02008b8:	fe460613          	addi	a2,a2,-28 # ffffffffc0201898 <etext+0x292>
ffffffffc02008bc:	09b00593          	li	a1,155
ffffffffc02008c0:	00001517          	auipc	a0,0x1
ffffffffc02008c4:	ff050513          	addi	a0,a0,-16 # ffffffffc02018b0 <etext+0x2aa>
ffffffffc02008c8:	8fbff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p1 != NULL);
ffffffffc02008cc:	00001697          	auipc	a3,0x1
ffffffffc02008d0:	03468693          	addi	a3,a3,52 # ffffffffc0201900 <etext+0x2fa>
ffffffffc02008d4:	00001617          	auipc	a2,0x1
ffffffffc02008d8:	fc460613          	addi	a2,a2,-60 # ffffffffc0201898 <etext+0x292>
ffffffffc02008dc:	09900593          	li	a1,153
ffffffffc02008e0:	00001517          	auipc	a0,0x1
ffffffffc02008e4:	fd050513          	addi	a0,a0,-48 # ffffffffc02018b0 <etext+0x2aa>
ffffffffc02008e8:	8dbff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02008ec <buddy_init_memmap>:
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc02008ec:	862e                	mv	a2,a1
    assert(n > 0);
ffffffffc02008ee:	c1e1                	beqz	a1,ffffffffc02009ae <buddy_init_memmap+0xc2>
    buddy_longest = (unsigned *)ROUNDUP((void *)(pages + npage - nbase), sizeof(unsigned));
ffffffffc02008f0:	00001797          	auipc	a5,0x1
ffffffffc02008f4:	5c87b783          	ld	a5,1480(a5) # ffffffffc0201eb8 <nbase>
ffffffffc02008f8:	00004817          	auipc	a6,0x4
ffffffffc02008fc:	7b883803          	ld	a6,1976(a6) # ffffffffc02050b0 <npage>
ffffffffc0200900:	40f80833          	sub	a6,a6,a5
ffffffffc0200904:	00681793          	slli	a5,a6,0x6
ffffffffc0200908:	00004817          	auipc	a6,0x4
ffffffffc020090c:	7b083803          	ld	a6,1968(a6) # ffffffffc02050b8 <pages>
ffffffffc0200910:	983e                	add	a6,a6,a5
ffffffffc0200912:	080d                	addi	a6,a6,3
    buddy_size = fixsize(n);
ffffffffc0200914:	0006071b          	sext.w	a4,a2
    while (n < size) n <<= 1;
ffffffffc0200918:	4785                	li	a5,1
ffffffffc020091a:	85aa                	mv	a1,a0
ffffffffc020091c:	ffc87813          	andi	a6,a6,-4
ffffffffc0200920:	06e7fc63          	bgeu	a5,a4,ffffffffc0200998 <buddy_init_memmap+0xac>
ffffffffc0200924:	0017979b          	slliw	a5,a5,0x1
ffffffffc0200928:	fee7eee3          	bltu	a5,a4,ffffffffc0200924 <buddy_init_memmap+0x38>
    buddy_node_count = buddy_size * 2 - 1;
ffffffffc020092c:	0017989b          	slliw	a7,a5,0x1
    buddy_size = fixsize(n);
ffffffffc0200930:	00004717          	auipc	a4,0x4
ffffffffc0200934:	76f72823          	sw	a5,1904(a4) # ffffffffc02050a0 <buddy_size>
    buddy_node_count = buddy_size * 2 - 1;
ffffffffc0200938:	fff8869b          	addiw	a3,a7,-1
    buddy_longest = (unsigned *)ROUNDUP((void *)(pages + npage - nbase), sizeof(unsigned));
ffffffffc020093c:	00004797          	auipc	a5,0x4
ffffffffc0200940:	7507be23          	sd	a6,1884(a5) # ffffffffc0205098 <buddy_longest>
    buddy_node_count = buddy_size * 2 - 1;
ffffffffc0200944:	4781                	li	a5,0
        if ((i + 1) & (i)) {
ffffffffc0200946:	0007871b          	sext.w	a4,a5
ffffffffc020094a:	2785                	addiw	a5,a5,1
ffffffffc020094c:	8f7d                	and	a4,a4,a5
ffffffffc020094e:	2701                	sext.w	a4,a4
ffffffffc0200950:	e319                	bnez	a4,ffffffffc0200956 <buddy_init_memmap+0x6a>
            node_size >>= 1;
ffffffffc0200952:	0018d89b          	srliw	a7,a7,0x1
        buddy_longest[i] = node_size;
ffffffffc0200956:	01182023          	sw	a7,0(a6)
    for (unsigned i = 0; i < buddy_node_count; i++) {
ffffffffc020095a:	0811                	addi	a6,a6,4
ffffffffc020095c:	fed7e5e3          	bltu	a5,a3,ffffffffc0200946 <buddy_init_memmap+0x5a>
    buddy_base = base;
ffffffffc0200960:	00661813          	slli	a6,a2,0x6
ffffffffc0200964:	00004797          	auipc	a5,0x4
ffffffffc0200968:	72b7b623          	sd	a1,1836(a5) # ffffffffc0205090 <buddy_base>
    nr_buddy_free_pages = n;
ffffffffc020096c:	00004797          	auipc	a5,0x4
ffffffffc0200970:	72c7be23          	sd	a2,1852(a5) # ffffffffc02050a8 <nr_buddy_free_pages>
    for (size_t i = 0; i < n; i++) {
ffffffffc0200974:	87ae                	mv	a5,a1
ffffffffc0200976:	982e                	add	a6,a6,a1
        ClearPageProperty(base + i);
ffffffffc0200978:	6798                	ld	a4,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020097a:	0007a023          	sw	zero,0(a5)
    for (size_t i = 0; i < n; i++) {
ffffffffc020097e:	04078793          	addi	a5,a5,64
        ClearPageProperty(base + i);
ffffffffc0200982:	9b71                	andi	a4,a4,-4
ffffffffc0200984:	fce7b423          	sd	a4,-56(a5)
    for (size_t i = 0; i < n; i++) {
ffffffffc0200988:	fef818e3          	bne	a6,a5,ffffffffc0200978 <buddy_init_memmap+0x8c>
    cprintf("buddy_init_memmap: base=%p, n=%d, tree_nodes=%d\n",
ffffffffc020098c:	00001517          	auipc	a0,0x1
ffffffffc0200990:	fac50513          	addi	a0,a0,-84 # ffffffffc0201938 <etext+0x332>
ffffffffc0200994:	fb8ff06f          	j	ffffffffc020014c <cprintf>
    buddy_size = fixsize(n);
ffffffffc0200998:	00004717          	auipc	a4,0x4
ffffffffc020099c:	70f72423          	sw	a5,1800(a4) # ffffffffc02050a0 <buddy_size>
    buddy_node_count = buddy_size * 2 - 1;
ffffffffc02009a0:	4685                	li	a3,1
    buddy_longest = (unsigned *)ROUNDUP((void *)(pages + npage - nbase), sizeof(unsigned));
ffffffffc02009a2:	00004797          	auipc	a5,0x4
ffffffffc02009a6:	6f07bb23          	sd	a6,1782(a5) # ffffffffc0205098 <buddy_longest>
    buddy_node_count = buddy_size * 2 - 1;
ffffffffc02009aa:	4889                	li	a7,2
ffffffffc02009ac:	bf61                	j	ffffffffc0200944 <buddy_init_memmap+0x58>
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc02009ae:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02009b0:	00001697          	auipc	a3,0x1
ffffffffc02009b4:	ee068693          	addi	a3,a3,-288 # ffffffffc0201890 <etext+0x28a>
ffffffffc02009b8:	00001617          	auipc	a2,0x1
ffffffffc02009bc:	ee060613          	addi	a2,a2,-288 # ffffffffc0201898 <etext+0x292>
ffffffffc02009c0:	02600593          	li	a1,38
ffffffffc02009c4:	00001517          	auipc	a0,0x1
ffffffffc02009c8:	eec50513          	addi	a0,a0,-276 # ffffffffc02018b0 <etext+0x2aa>
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc02009cc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02009ce:	ff4ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02009d2 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc02009d2:	00004797          	auipc	a5,0x4
ffffffffc02009d6:	6ee7b783          	ld	a5,1774(a5) # ffffffffc02050c0 <pmm_manager>
ffffffffc02009da:	6f9c                	ld	a5,24(a5)
ffffffffc02009dc:	8782                	jr	a5

ffffffffc02009de <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc02009de:	00004797          	auipc	a5,0x4
ffffffffc02009e2:	6e27b783          	ld	a5,1762(a5) # ffffffffc02050c0 <pmm_manager>
ffffffffc02009e6:	739c                	ld	a5,32(a5)
ffffffffc02009e8:	8782                	jr	a5

ffffffffc02009ea <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc02009ea:	00001797          	auipc	a5,0x1
ffffffffc02009ee:	f9e78793          	addi	a5,a5,-98 # ffffffffc0201988 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02009f2:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02009f4:	7119                	addi	sp,sp,-128
ffffffffc02009f6:	fc86                	sd	ra,120(sp)
ffffffffc02009f8:	f8a2                	sd	s0,112(sp)
ffffffffc02009fa:	f4a6                	sd	s1,104(sp)
ffffffffc02009fc:	e8d2                	sd	s4,80(sp)
ffffffffc02009fe:	f0ca                	sd	s2,96(sp)
ffffffffc0200a00:	ecce                	sd	s3,88(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200a02:	00004417          	auipc	s0,0x4
ffffffffc0200a06:	6be40413          	addi	s0,s0,1726 # ffffffffc02050c0 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200a0a:	00001517          	auipc	a0,0x1
ffffffffc0200a0e:	fb650513          	addi	a0,a0,-74 # ffffffffc02019c0 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200a12:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200a14:	f38ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    pmm_manager->init();
ffffffffc0200a18:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200a1a:	00004497          	auipc	s1,0x4
ffffffffc0200a1e:	6be48493          	addi	s1,s1,1726 # ffffffffc02050d8 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200a22:	679c                	ld	a5,8(a5)
ffffffffc0200a24:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200a26:	57f5                	li	a5,-3
ffffffffc0200a28:	07fa                	slli	a5,a5,0x1e
ffffffffc0200a2a:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0200a2c:	b91ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc0200a30:	8a2a                	mv	s4,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0200a32:	b95ff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0200a36:	2c050c63          	beqz	a0,ffffffffc0200d0e <pmm_init+0x324>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200a3a:	89aa                	mv	s3,a0
    cprintf("physcial memory map:\n");
ffffffffc0200a3c:	00001517          	auipc	a0,0x1
ffffffffc0200a40:	fcc50513          	addi	a0,a0,-52 # ffffffffc0201a08 <buddy_pmm_manager+0x80>
ffffffffc0200a44:	f08ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200a48:	013a0933          	add	s2,s4,s3
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200a4c:	85ce                	mv	a1,s3
ffffffffc0200a4e:	fff90693          	addi	a3,s2,-1
ffffffffc0200a52:	8652                	mv	a2,s4
ffffffffc0200a54:	00001517          	auipc	a0,0x1
ffffffffc0200a58:	fcc50513          	addi	a0,a0,-52 # ffffffffc0201a20 <buddy_pmm_manager+0x98>
ffffffffc0200a5c:	ef0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200a60:	c80007b7          	lui	a5,0xc8000
ffffffffc0200a64:	85ca                	mv	a1,s2
ffffffffc0200a66:	1f27e463          	bltu	a5,s2,ffffffffc0200c4e <pmm_init+0x264>
ffffffffc0200a6a:	77fd                	lui	a5,0xfffff
ffffffffc0200a6c:	00005697          	auipc	a3,0x5
ffffffffc0200a70:	67368693          	addi	a3,a3,1651 # ffffffffc02060df <end+0xfff>
ffffffffc0200a74:	8efd                	and	a3,a3,a5
ffffffffc0200a76:	81b1                	srli	a1,a1,0xc
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a78:	fff80837          	lui	a6,0xfff80
    npage = maxpa / PGSIZE;
ffffffffc0200a7c:	00004797          	auipc	a5,0x4
ffffffffc0200a80:	62b7ba23          	sd	a1,1588(a5) # ffffffffc02050b0 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200a84:	00004797          	auipc	a5,0x4
ffffffffc0200a88:	62d7ba23          	sd	a3,1588(a5) # ffffffffc02050b8 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a8c:	982e                	add	a6,a6,a1
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200a8e:	8536                	mv	a0,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a90:	02080463          	beqz	a6,ffffffffc0200ab8 <pmm_init+0xce>
ffffffffc0200a94:	fe0007b7          	lui	a5,0xfe000
ffffffffc0200a98:	97b6                	add	a5,a5,a3
ffffffffc0200a9a:	00659613          	slli	a2,a1,0x6
ffffffffc0200a9e:	963e                	add	a2,a2,a5
ffffffffc0200aa0:	87b6                	mv	a5,a3
        SetPageReserved(pages + i);
ffffffffc0200aa2:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200aa4:	04078793          	addi	a5,a5,64 # fffffffffe000040 <end+0x3ddfaf60>
        SetPageReserved(pages + i);
ffffffffc0200aa8:	00176713          	ori	a4,a4,1
ffffffffc0200aac:	fce7b423          	sd	a4,-56(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200ab0:	fec799e3          	bne	a5,a2,ffffffffc0200aa2 <pmm_init+0xb8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200ab4:	081a                	slli	a6,a6,0x6
ffffffffc0200ab6:	96c2                	add	a3,a3,a6
ffffffffc0200ab8:	c02007b7          	lui	a5,0xc0200
ffffffffc0200abc:	26f6e563          	bltu	a3,a5,ffffffffc0200d26 <pmm_init+0x33c>
ffffffffc0200ac0:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0200ac2:	77fd                	lui	a5,0xfffff
ffffffffc0200ac4:	00f97933          	and	s2,s2,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200ac8:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200aca:	1926e563          	bltu	a3,s2,ffffffffc0200c54 <pmm_init+0x26a>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200ace:	601c                	ld	a5,0(s0)
ffffffffc0200ad0:	7b9c                	ld	a5,48(a5)
ffffffffc0200ad2:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200ad4:	00001517          	auipc	a0,0x1
ffffffffc0200ad8:	fd450513          	addi	a0,a0,-44 # ffffffffc0201aa8 <buddy_pmm_manager+0x120>
ffffffffc0200adc:	e70ff0ef          	jal	ra,ffffffffc020014c <cprintf>
}

// A simple test for kmalloc and kfree
static void
check_slub(void) {
    cprintf("check_slub() starting.\n");
ffffffffc0200ae0:	00001517          	auipc	a0,0x1
ffffffffc0200ae4:	fe850513          	addi	a0,a0,-24 # ffffffffc0201ac8 <buddy_pmm_manager+0x140>
ffffffffc0200ae8:	e64ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // Initialize the SLUB allocator
    kmalloc_init();
ffffffffc0200aec:	4ae000ef          	jal	ra,ffffffffc0200f9a <kmalloc_init>

    // Test basic allocation and free
    void *p1 = kmalloc(32);
ffffffffc0200af0:	02000513          	li	a0,32
ffffffffc0200af4:	502000ef          	jal	ra,ffffffffc0200ff6 <kmalloc>
ffffffffc0200af8:	842a                	mv	s0,a0
    assert(p1 != NULL);
ffffffffc0200afa:	26050263          	beqz	a0,ffffffffc0200d5e <pmm_init+0x374>
    cprintf("kmalloc(32) returned %p\n", p1);
ffffffffc0200afe:	85aa                	mv	a1,a0
ffffffffc0200b00:	00001517          	auipc	a0,0x1
ffffffffc0200b04:	fe050513          	addi	a0,a0,-32 # ffffffffc0201ae0 <buddy_pmm_manager+0x158>
ffffffffc0200b08:	e44ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    memset(p1, 0xAA, 32);
ffffffffc0200b0c:	02000613          	li	a2,32
ffffffffc0200b10:	0aa00593          	li	a1,170
ffffffffc0200b14:	8522                	mv	a0,s0
ffffffffc0200b16:	2df000ef          	jal	ra,ffffffffc02015f4 <memset>
    kfree(p1);
ffffffffc0200b1a:	8522                	mv	a0,s0
ffffffffc0200b1c:	57e000ef          	jal	ra,ffffffffc020109a <kfree>
    cprintf("kfree(32) passed.\n");
ffffffffc0200b20:	00001517          	auipc	a0,0x1
ffffffffc0200b24:	fe050513          	addi	a0,a0,-32 # ffffffffc0201b00 <buddy_pmm_manager+0x178>
ffffffffc0200b28:	e24ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    void *p2 = kmalloc(100);
ffffffffc0200b2c:	06400513          	li	a0,100
ffffffffc0200b30:	4c6000ef          	jal	ra,ffffffffc0200ff6 <kmalloc>
ffffffffc0200b34:	842a                	mv	s0,a0
    assert(p2 != NULL);
ffffffffc0200b36:	20050463          	beqz	a0,ffffffffc0200d3e <pmm_init+0x354>
    cprintf("kmalloc(100) returned %p\n", p2);
ffffffffc0200b3a:	85aa                	mv	a1,a0
ffffffffc0200b3c:	00001517          	auipc	a0,0x1
ffffffffc0200b40:	fdc50513          	addi	a0,a0,-36 # ffffffffc0201b18 <buddy_pmm_manager+0x190>
ffffffffc0200b44:	e08ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    memset(p2, 0xBB, 100);
ffffffffc0200b48:	06400613          	li	a2,100
ffffffffc0200b4c:	0bb00593          	li	a1,187
ffffffffc0200b50:	8522                	mv	a0,s0
ffffffffc0200b52:	2a3000ef          	jal	ra,ffffffffc02015f4 <memset>
    kfree(p2);
ffffffffc0200b56:	8522                	mv	a0,s0
ffffffffc0200b58:	542000ef          	jal	ra,ffffffffc020109a <kfree>
    cprintf("kfree(100) passed.\n");
ffffffffc0200b5c:	00001517          	auipc	a0,0x1
ffffffffc0200b60:	fdc50513          	addi	a0,a0,-36 # ffffffffc0201b38 <buddy_pmm_manager+0x1b0>
ffffffffc0200b64:	898a                	mv	s3,sp
ffffffffc0200b66:	de6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200b6a:	894e                	mv	s2,s3

    // Test multiple allocations
    void *p_array[10];
    for (int i = 0; i < 10; i++) {
ffffffffc0200b6c:	4401                	li	s0,0
ffffffffc0200b6e:	4a29                	li	s4,10
        p_array[i] = kmalloc(64);
ffffffffc0200b70:	04000513          	li	a0,64
ffffffffc0200b74:	482000ef          	jal	ra,ffffffffc0200ff6 <kmalloc>
ffffffffc0200b78:	00a93023          	sd	a0,0(s2)
        assert(p_array[i] != NULL);
ffffffffc0200b7c:	12050d63          	beqz	a0,ffffffffc0200cb6 <pmm_init+0x2cc>
        memset(p_array[i], i, 64);
ffffffffc0200b80:	0ff47593          	zext.b	a1,s0
ffffffffc0200b84:	04000613          	li	a2,64
    for (int i = 0; i < 10; i++) {
ffffffffc0200b88:	2405                	addiw	s0,s0,1
        memset(p_array[i], i, 64);
ffffffffc0200b8a:	26b000ef          	jal	ra,ffffffffc02015f4 <memset>
    for (int i = 0; i < 10; i++) {
ffffffffc0200b8e:	0921                	addi	s2,s2,8
ffffffffc0200b90:	ff4410e3          	bne	s0,s4,ffffffffc0200b70 <pmm_init+0x186>
    }

    for (int i = 0; i < 10; i++) {
ffffffffc0200b94:	4401                	li	s0,0
ffffffffc0200b96:	4929                	li	s2,10
        for(int j = 0; j < 64; j++) {
            assert(*((char*)p_array[i] + j) == i);
ffffffffc0200b98:	0009b503          	ld	a0,0(s3)
ffffffffc0200b9c:	87aa                	mv	a5,a0
ffffffffc0200b9e:	04050693          	addi	a3,a0,64
ffffffffc0200ba2:	0007c703          	lbu	a4,0(a5) # fffffffffffff000 <end+0x3fdf9f20>
ffffffffc0200ba6:	0c871c63          	bne	a4,s0,ffffffffc0200c7e <pmm_init+0x294>
        for(int j = 0; j < 64; j++) {
ffffffffc0200baa:	0785                	addi	a5,a5,1
ffffffffc0200bac:	fef69be3          	bne	a3,a5,ffffffffc0200ba2 <pmm_init+0x1b8>
    for (int i = 0; i < 10; i++) {
ffffffffc0200bb0:	2405                	addiw	s0,s0,1
        }
        kfree(p_array[i]);
ffffffffc0200bb2:	4e8000ef          	jal	ra,ffffffffc020109a <kfree>
    for (int i = 0; i < 10; i++) {
ffffffffc0200bb6:	09a1                	addi	s3,s3,8
ffffffffc0200bb8:	ff2410e3          	bne	s0,s2,ffffffffc0200b98 <pmm_init+0x1ae>
    }
    cprintf("Multiple allocation/free test passed.\n");
ffffffffc0200bbc:	00001517          	auipc	a0,0x1
ffffffffc0200bc0:	fcc50513          	addi	a0,a0,-52 # ffffffffc0201b88 <buddy_pmm_manager+0x200>
ffffffffc0200bc4:	d88ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // Test large allocation fallback
    void *p_large = kmalloc(PGSIZE * 2);
ffffffffc0200bc8:	6509                	lui	a0,0x2
ffffffffc0200bca:	42c000ef          	jal	ra,ffffffffc0200ff6 <kmalloc>
ffffffffc0200bce:	842a                	mv	s0,a0
    assert(p_large != NULL);
ffffffffc0200bd0:	10050f63          	beqz	a0,ffffffffc0200cee <pmm_init+0x304>
    cprintf("kmalloc(large) returned %p\n", p_large);
ffffffffc0200bd4:	85aa                	mv	a1,a0
ffffffffc0200bd6:	00001517          	auipc	a0,0x1
ffffffffc0200bda:	fea50513          	addi	a0,a0,-22 # ffffffffc0201bc0 <buddy_pmm_manager+0x238>
ffffffffc0200bde:	d6eff0ef          	jal	ra,ffffffffc020014c <cprintf>
    memset(p_large, 0xCC, PGSIZE * 2);
ffffffffc0200be2:	6609                	lui	a2,0x2
ffffffffc0200be4:	0cc00593          	li	a1,204
ffffffffc0200be8:	8522                	mv	a0,s0
ffffffffc0200bea:	20b000ef          	jal	ra,ffffffffc02015f4 <memset>
    kfree(p_large);
ffffffffc0200bee:	8522                	mv	a0,s0
ffffffffc0200bf0:	4aa000ef          	jal	ra,ffffffffc020109a <kfree>
    cprintf("Large allocation fallback test passed.\n");
ffffffffc0200bf4:	00001517          	auipc	a0,0x1
ffffffffc0200bf8:	fec50513          	addi	a0,a0,-20 # ffffffffc0201be0 <buddy_pmm_manager+0x258>
ffffffffc0200bfc:	d50ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    cprintf("check_slub() succeeded!\n");
ffffffffc0200c00:	00001517          	auipc	a0,0x1
ffffffffc0200c04:	00850513          	addi	a0,a0,8 # ffffffffc0201c08 <buddy_pmm_manager+0x280>
ffffffffc0200c08:	d44ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200c0c:	00003697          	auipc	a3,0x3
ffffffffc0200c10:	3f468693          	addi	a3,a3,1012 # ffffffffc0204000 <boot_page_table_sv39>
ffffffffc0200c14:	00004797          	auipc	a5,0x4
ffffffffc0200c18:	4ad7be23          	sd	a3,1212(a5) # ffffffffc02050d0 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200c1c:	c02007b7          	lui	a5,0xc0200
ffffffffc0200c20:	0af6eb63          	bltu	a3,a5,ffffffffc0200cd6 <pmm_init+0x2ec>
ffffffffc0200c24:	609c                	ld	a5,0(s1)
}
ffffffffc0200c26:	7446                	ld	s0,112(sp)
ffffffffc0200c28:	70e6                	ld	ra,120(sp)
ffffffffc0200c2a:	74a6                	ld	s1,104(sp)
ffffffffc0200c2c:	7906                	ld	s2,96(sp)
ffffffffc0200c2e:	69e6                	ld	s3,88(sp)
ffffffffc0200c30:	6a46                	ld	s4,80(sp)
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200c32:	85b6                	mv	a1,a3
    satp_physical = PADDR(satp_virtual);
ffffffffc0200c34:	8e9d                	sub	a3,a3,a5
ffffffffc0200c36:	00004797          	auipc	a5,0x4
ffffffffc0200c3a:	48d7b923          	sd	a3,1170(a5) # ffffffffc02050c8 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200c3e:	00001517          	auipc	a0,0x1
ffffffffc0200c42:	fea50513          	addi	a0,a0,-22 # ffffffffc0201c28 <buddy_pmm_manager+0x2a0>
ffffffffc0200c46:	8636                	mv	a2,a3
}
ffffffffc0200c48:	6109                	addi	sp,sp,128
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200c4a:	d02ff06f          	j	ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200c4e:	c80005b7          	lui	a1,0xc8000
ffffffffc0200c52:	bd21                	j	ffffffffc0200a6a <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200c54:	6705                	lui	a4,0x1
ffffffffc0200c56:	177d                	addi	a4,a4,-1
ffffffffc0200c58:	96ba                	add	a3,a3,a4
ffffffffc0200c5a:	8ff5                	and	a5,a5,a3
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200c5c:	00c7d713          	srli	a4,a5,0xc
ffffffffc0200c60:	02b77f63          	bgeu	a4,a1,ffffffffc0200c9e <pmm_init+0x2b4>
    pmm_manager->init_memmap(base, n);
ffffffffc0200c64:	6014                	ld	a3,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200c66:	fff80637          	lui	a2,0xfff80
ffffffffc0200c6a:	9732                	add	a4,a4,a2
ffffffffc0200c6c:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200c6e:	40f90933          	sub	s2,s2,a5
ffffffffc0200c72:	071a                	slli	a4,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0200c74:	00c95593          	srli	a1,s2,0xc
ffffffffc0200c78:	953a                	add	a0,a0,a4
ffffffffc0200c7a:	9682                	jalr	a3
}
ffffffffc0200c7c:	bd89                	j	ffffffffc0200ace <pmm_init+0xe4>
            assert(*((char*)p_array[i] + j) == i);
ffffffffc0200c7e:	00001697          	auipc	a3,0x1
ffffffffc0200c82:	eea68693          	addi	a3,a3,-278 # ffffffffc0201b68 <buddy_pmm_manager+0x1e0>
ffffffffc0200c86:	00001617          	auipc	a2,0x1
ffffffffc0200c8a:	c1260613          	addi	a2,a2,-1006 # ffffffffc0201898 <etext+0x292>
ffffffffc0200c8e:	0aa00593          	li	a1,170
ffffffffc0200c92:	00001517          	auipc	a0,0x1
ffffffffc0200c96:	d6650513          	addi	a0,a0,-666 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200c9a:	d28ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0200c9e:	00001617          	auipc	a2,0x1
ffffffffc0200ca2:	dda60613          	addi	a2,a2,-550 # ffffffffc0201a78 <buddy_pmm_manager+0xf0>
ffffffffc0200ca6:	06a00593          	li	a1,106
ffffffffc0200caa:	00001517          	auipc	a0,0x1
ffffffffc0200cae:	dee50513          	addi	a0,a0,-530 # ffffffffc0201a98 <buddy_pmm_manager+0x110>
ffffffffc0200cb2:	d10ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        assert(p_array[i] != NULL);
ffffffffc0200cb6:	00001697          	auipc	a3,0x1
ffffffffc0200cba:	e9a68693          	addi	a3,a3,-358 # ffffffffc0201b50 <buddy_pmm_manager+0x1c8>
ffffffffc0200cbe:	00001617          	auipc	a2,0x1
ffffffffc0200cc2:	bda60613          	addi	a2,a2,-1062 # ffffffffc0201898 <etext+0x292>
ffffffffc0200cc6:	0a400593          	li	a1,164
ffffffffc0200cca:	00001517          	auipc	a0,0x1
ffffffffc0200cce:	d2e50513          	addi	a0,a0,-722 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200cd2:	cf0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200cd6:	00001617          	auipc	a2,0x1
ffffffffc0200cda:	d7a60613          	addi	a2,a2,-646 # ffffffffc0201a50 <buddy_pmm_manager+0xc8>
ffffffffc0200cde:	07e00593          	li	a1,126
ffffffffc0200ce2:	00001517          	auipc	a0,0x1
ffffffffc0200ce6:	d1650513          	addi	a0,a0,-746 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200cea:	cd8ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p_large != NULL);
ffffffffc0200cee:	00001697          	auipc	a3,0x1
ffffffffc0200cf2:	ec268693          	addi	a3,a3,-318 # ffffffffc0201bb0 <buddy_pmm_manager+0x228>
ffffffffc0200cf6:	00001617          	auipc	a2,0x1
ffffffffc0200cfa:	ba260613          	addi	a2,a2,-1118 # ffffffffc0201898 <etext+0x292>
ffffffffc0200cfe:	0b200593          	li	a1,178
ffffffffc0200d02:	00001517          	auipc	a0,0x1
ffffffffc0200d06:	cf650513          	addi	a0,a0,-778 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200d0a:	cb8ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("DTB memory info not available");
ffffffffc0200d0e:	00001617          	auipc	a2,0x1
ffffffffc0200d12:	cca60613          	addi	a2,a2,-822 # ffffffffc02019d8 <buddy_pmm_manager+0x50>
ffffffffc0200d16:	04b00593          	li	a1,75
ffffffffc0200d1a:	00001517          	auipc	a0,0x1
ffffffffc0200d1e:	cde50513          	addi	a0,a0,-802 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200d22:	ca0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200d26:	00001617          	auipc	a2,0x1
ffffffffc0200d2a:	d2a60613          	addi	a2,a2,-726 # ffffffffc0201a50 <buddy_pmm_manager+0xc8>
ffffffffc0200d2e:	06300593          	li	a1,99
ffffffffc0200d32:	00001517          	auipc	a0,0x1
ffffffffc0200d36:	cc650513          	addi	a0,a0,-826 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200d3a:	c88ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p2 != NULL);
ffffffffc0200d3e:	00001697          	auipc	a3,0x1
ffffffffc0200d42:	bd268693          	addi	a3,a3,-1070 # ffffffffc0201910 <etext+0x30a>
ffffffffc0200d46:	00001617          	auipc	a2,0x1
ffffffffc0200d4a:	b5260613          	addi	a2,a2,-1198 # ffffffffc0201898 <etext+0x292>
ffffffffc0200d4e:	09a00593          	li	a1,154
ffffffffc0200d52:	00001517          	auipc	a0,0x1
ffffffffc0200d56:	ca650513          	addi	a0,a0,-858 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200d5a:	c68ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p1 != NULL);
ffffffffc0200d5e:	00001697          	auipc	a3,0x1
ffffffffc0200d62:	ba268693          	addi	a3,a3,-1118 # ffffffffc0201900 <etext+0x2fa>
ffffffffc0200d66:	00001617          	auipc	a2,0x1
ffffffffc0200d6a:	b3260613          	addi	a2,a2,-1230 # ffffffffc0201898 <etext+0x292>
ffffffffc0200d6e:	09300593          	li	a1,147
ffffffffc0200d72:	00001517          	auipc	a0,0x1
ffffffffc0200d76:	c8650513          	addi	a0,a0,-890 # ffffffffc02019f8 <buddy_pmm_manager+0x70>
ffffffffc0200d7a:	c48ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200d7e <kmem_cache_free.part.0>:
    if (obj == NULL) {
        return;
    }

    // 从对象的虚拟地址获取页面描述符
    struct Page *page = pa2page((uintptr_t)obj - PHYSICAL_MEMORY_OFFSET);
ffffffffc0200d7e:	478d                	li	a5,3
ffffffffc0200d80:	07fa                	slli	a5,a5,0x1e
ffffffffc0200d82:	97aa                	add	a5,a5,a0
    if (PPN(pa) >= npage) {
ffffffffc0200d84:	83b1                	srli	a5,a5,0xc
ffffffffc0200d86:	00004717          	auipc	a4,0x4
ffffffffc0200d8a:	32a73703          	ld	a4,810(a4) # ffffffffc02050b0 <npage>
ffffffffc0200d8e:	06e7fa63          	bgeu	a5,a4,ffffffffc0200e02 <kmem_cache_free.part.0+0x84>
    return &pages[PPN(pa) - nbase];
ffffffffc0200d92:	00001717          	auipc	a4,0x1
ffffffffc0200d96:	12673703          	ld	a4,294(a4) # ffffffffc0201eb8 <nbase>
ffffffffc0200d9a:	8f99                	sub	a5,a5,a4
ffffffffc0200d9c:	079a                	slli	a5,a5,0x6
ffffffffc0200d9e:	00004717          	auipc	a4,0x4
ffffffffc0200da2:	31a73703          	ld	a4,794(a4) # ffffffffc02050b8 <pages>
ffffffffc0200da6:	97ba                	add	a5,a5,a4
    struct kmem_cache *cache = page->cache;

    // 将对象添加回slab的空闲链表
    *(void **)obj = page->freelist;
ffffffffc0200da8:	7794                	ld	a3,40(a5)
    page->freelist = obj;

    bool was_full = (page->inuse == cache->objects_per_slab);
ffffffffc0200daa:	7b90                	ld	a2,48(a5)
    struct kmem_cache *cache = page->cache;
ffffffffc0200dac:	7f98                	ld	a4,56(a5)
    *(void **)obj = page->freelist;
ffffffffc0200dae:	e114                	sd	a3,0(a0)
    page->inuse--;
ffffffffc0200db0:	fff60693          	addi	a3,a2,-1
    bool was_full = (page->inuse == cache->objects_per_slab);
ffffffffc0200db4:	5b4c                	lw	a1,52(a4)
    page->freelist = obj;
ffffffffc0200db6:	f788                	sd	a0,40(a5)
    page->inuse--;
ffffffffc0200db8:	fb94                	sd	a3,48(a5)

    // 只有当slab状态改变时才移动它
    if (page->inuse == 0) {
ffffffffc0200dba:	e285                	bnez	a3,ffffffffc0200dda <kmem_cache_free.part.0+0x5c>
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
ffffffffc0200dbc:	6f88                	ld	a0,24(a5)
ffffffffc0200dbe:	738c                	ld	a1,32(a5)
        // 从部分空闲转换为完全空闲
        list_del(&(page->page_link));
        list_add(&(cache->slabs_free), &(page->page_link));
ffffffffc0200dc0:	01878613          	addi	a2,a5,24
ffffffffc0200dc4:	02070813          	addi	a6,a4,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200dc8:	e50c                	sd	a1,8(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200dca:	7714                	ld	a3,40(a4)
    next->prev = prev;
ffffffffc0200dcc:	e188                	sd	a0,0(a1)
    prev->next = next->prev = elm;
ffffffffc0200dce:	e290                	sd	a2,0(a3)
ffffffffc0200dd0:	f710                	sd	a2,40(a4)
    elm->next = next;
ffffffffc0200dd2:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200dd4:	0107bc23          	sd	a6,24(a5)
}
ffffffffc0200dd8:	8082                	ret
    bool was_full = (page->inuse == cache->objects_per_slab);
ffffffffc0200dda:	1582                	slli	a1,a1,0x20
ffffffffc0200ddc:	9181                	srli	a1,a1,0x20
    } else if (was_full) {
ffffffffc0200dde:	00b60363          	beq	a2,a1,ffffffffc0200de4 <kmem_cache_free.part.0+0x66>
ffffffffc0200de2:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc0200de4:	6f88                	ld	a0,24(a5)
ffffffffc0200de6:	738c                	ld	a1,32(a5)
        // 从全满转换为部分空闲
        list_del(&(page->page_link));
        list_add(&(cache->slabs_partial), &(page->page_link));
ffffffffc0200de8:	01878613          	addi	a2,a5,24
ffffffffc0200dec:	01070813          	addi	a6,a4,16
    prev->next = next;
ffffffffc0200df0:	e50c                	sd	a1,8(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200df2:	6f14                	ld	a3,24(a4)
    next->prev = prev;
ffffffffc0200df4:	e188                	sd	a0,0(a1)
    prev->next = next->prev = elm;
ffffffffc0200df6:	e290                	sd	a2,0(a3)
ffffffffc0200df8:	ef10                	sd	a2,24(a4)
    elm->next = next;
ffffffffc0200dfa:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200dfc:	0107bc23          	sd	a6,24(a5)
ffffffffc0200e00:	8082                	ret
kmem_cache_free(void *obj) {
ffffffffc0200e02:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0200e04:	00001617          	auipc	a2,0x1
ffffffffc0200e08:	c7460613          	addi	a2,a2,-908 # ffffffffc0201a78 <buddy_pmm_manager+0xf0>
ffffffffc0200e0c:	06a00593          	li	a1,106
ffffffffc0200e10:	00001517          	auipc	a0,0x1
ffffffffc0200e14:	c8850513          	addi	a0,a0,-888 # ffffffffc0201a98 <buddy_pmm_manager+0x110>
ffffffffc0200e18:	e406                	sd	ra,8(sp)
ffffffffc0200e1a:	ba8ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200e1e <kmem_cache_create>:
kmem_cache_create(const char *name, size_t size) {
ffffffffc0200e1e:	1101                	addi	sp,sp,-32
ffffffffc0200e20:	e04a                	sd	s2,0(sp)
ffffffffc0200e22:	892a                	mv	s2,a0
    struct Page* page = alloc_pages(1);
ffffffffc0200e24:	4505                	li	a0,1
kmem_cache_create(const char *name, size_t size) {
ffffffffc0200e26:	e822                	sd	s0,16(sp)
ffffffffc0200e28:	e426                	sd	s1,8(sp)
ffffffffc0200e2a:	ec06                	sd	ra,24(sp)
ffffffffc0200e2c:	84ae                	mv	s1,a1
    struct Page* page = alloc_pages(1);
ffffffffc0200e2e:	ba5ff0ef          	jal	ra,ffffffffc02009d2 <alloc_pages>
ffffffffc0200e32:	842a                	mv	s0,a0
    if (page == NULL) {
ffffffffc0200e34:	c12d                	beqz	a0,ffffffffc0200e96 <kmem_cache_create+0x78>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e36:	00004517          	auipc	a0,0x4
ffffffffc0200e3a:	28253503          	ld	a0,642(a0) # ffffffffc02050b8 <pages>
ffffffffc0200e3e:	8c09                	sub	s0,s0,a0
ffffffffc0200e40:	8419                	srai	s0,s0,0x6
ffffffffc0200e42:	00001517          	auipc	a0,0x1
ffffffffc0200e46:	07653503          	ld	a0,118(a0) # ffffffffc0201eb8 <nbase>
ffffffffc0200e4a:	942a                	add	s0,s0,a0
    struct kmem_cache *cache = (struct kmem_cache *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
ffffffffc0200e4c:	5575                	li	a0,-3
ffffffffc0200e4e:	057a                	slli	a0,a0,0x1e
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e50:	0432                	slli	s0,s0,0xc
ffffffffc0200e52:	942a                	add	s0,s0,a0
    memset(cache, 0, sizeof(struct kmem_cache));
ffffffffc0200e54:	06000613          	li	a2,96
ffffffffc0200e58:	4581                	li	a1,0
ffffffffc0200e5a:	8522                	mv	a0,s0
ffffffffc0200e5c:	798000ef          	jal	ra,ffffffffc02015f4 <memset>
    cache->object_size = size;
ffffffffc0200e60:	0004879b          	sext.w	a5,s1
    cache->objects_per_slab = (cache->slab_pages * PGSIZE) / cache->object_size;
ffffffffc0200e64:	6705                	lui	a4,0x1
ffffffffc0200e66:	02f7573b          	divuw	a4,a4,a5
    list_init(&(cache->slabs_partial));
ffffffffc0200e6a:	01040613          	addi	a2,s0,16
    list_init(&(cache->slabs_free));
ffffffffc0200e6e:	02040693          	addi	a3,s0,32
    cache->object_size = size;
ffffffffc0200e72:	d81c                	sw	a5,48(s0)
    cache->slab_pages = 1; // 为了简单起见，每个slab从1页开始
ffffffffc0200e74:	4785                	li	a5,1
    elm->prev = elm->next = elm;
ffffffffc0200e76:	ec10                	sd	a2,24(s0)
ffffffffc0200e78:	e810                	sd	a2,16(s0)
ffffffffc0200e7a:	e400                	sd	s0,8(s0)
ffffffffc0200e7c:	e000                	sd	s0,0(s0)
ffffffffc0200e7e:	f414                	sd	a3,40(s0)
ffffffffc0200e80:	f014                	sd	a3,32(s0)
ffffffffc0200e82:	dc1c                	sw	a5,56(s0)
    strncpy(cache->name, name, sizeof(cache->name) - 1);
ffffffffc0200e84:	467d                	li	a2,31
ffffffffc0200e86:	85ca                	mv	a1,s2
ffffffffc0200e88:	03c40513          	addi	a0,s0,60
    cache->objects_per_slab = (cache->slab_pages * PGSIZE) / cache->object_size;
ffffffffc0200e8c:	d858                	sw	a4,52(s0)
    strncpy(cache->name, name, sizeof(cache->name) - 1);
ffffffffc0200e8e:	706000ef          	jal	ra,ffffffffc0201594 <strncpy>
    cache->name[sizeof(cache->name) - 1] = '\0';
ffffffffc0200e92:	04040da3          	sb	zero,91(s0)
}
ffffffffc0200e96:	60e2                	ld	ra,24(sp)
ffffffffc0200e98:	8522                	mv	a0,s0
ffffffffc0200e9a:	6442                	ld	s0,16(sp)
ffffffffc0200e9c:	64a2                	ld	s1,8(sp)
ffffffffc0200e9e:	6902                	ld	s2,0(sp)
ffffffffc0200ea0:	6105                	addi	sp,sp,32
ffffffffc0200ea2:	8082                	ret

ffffffffc0200ea4 <kmem_cache_alloc>:
kmem_cache_alloc(struct kmem_cache *cache) {
ffffffffc0200ea4:	1101                	addi	sp,sp,-32
ffffffffc0200ea6:	e822                	sd	s0,16(sp)
    return list->next == list;
ffffffffc0200ea8:	6d00                	ld	s0,24(a0)
ffffffffc0200eaa:	e426                	sd	s1,8(sp)
ffffffffc0200eac:	e04a                	sd	s2,0(sp)
ffffffffc0200eae:	ec06                	sd	ra,24(sp)
    if (!list_empty(&(cache->slabs_partial))) {
ffffffffc0200eb0:	01050913          	addi	s2,a0,16
kmem_cache_alloc(struct kmem_cache *cache) {
ffffffffc0200eb4:	84aa                	mv	s1,a0
    if (!list_empty(&(cache->slabs_partial))) {
ffffffffc0200eb6:	04890c63          	beq	s2,s0,ffffffffc0200f0e <kmem_cache_alloc+0x6a>
    if (page->inuse == cache->objects_per_slab) {
ffffffffc0200eba:	5954                	lw	a3,52(a0)
        page = le2page(le, page_link);
ffffffffc0200ebc:	fe840713          	addi	a4,s0,-24
    void *obj = page->freelist;
ffffffffc0200ec0:	7708                	ld	a0,40(a4)
    page->inuse++;
ffffffffc0200ec2:	7b1c                	ld	a5,48(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ec4:	600c                	ld	a1,0(s0)
    page->freelist = *(void **)obj;
ffffffffc0200ec6:	00053803          	ld	a6,0(a0)
ffffffffc0200eca:	6410                	ld	a2,8(s0)
    page->inuse++;
ffffffffc0200ecc:	0785                	addi	a5,a5,1
    page->freelist = *(void **)obj;
ffffffffc0200ece:	03073423          	sd	a6,40(a4) # 1028 <kern_entry-0xffffffffc01fefd8>
    page->inuse++;
ffffffffc0200ed2:	fb1c                	sd	a5,48(a4)
    prev->next = next;
ffffffffc0200ed4:	e590                	sd	a2,8(a1)
    if (page->inuse == cache->objects_per_slab) {
ffffffffc0200ed6:	1682                	slli	a3,a3,0x20
    next->prev = prev;
ffffffffc0200ed8:	e20c                	sd	a1,0(a2)
ffffffffc0200eda:	9281                	srli	a3,a3,0x20
ffffffffc0200edc:	00d78e63          	beq	a5,a3,ffffffffc0200ef8 <kmem_cache_alloc+0x54>
    __list_add(elm, listelm, listelm->next);
ffffffffc0200ee0:	6c9c                	ld	a5,24(s1)
    prev->next = next->prev = elm;
ffffffffc0200ee2:	e380                	sd	s0,0(a5)
ffffffffc0200ee4:	ec80                	sd	s0,24(s1)
    elm->next = next;
ffffffffc0200ee6:	e41c                	sd	a5,8(s0)
    elm->prev = prev;
ffffffffc0200ee8:	01243023          	sd	s2,0(s0)
}
ffffffffc0200eec:	60e2                	ld	ra,24(sp)
ffffffffc0200eee:	6442                	ld	s0,16(sp)
ffffffffc0200ef0:	64a2                	ld	s1,8(sp)
ffffffffc0200ef2:	6902                	ld	s2,0(sp)
ffffffffc0200ef4:	6105                	addi	sp,sp,32
ffffffffc0200ef6:	8082                	ret
    __list_add(elm, listelm, listelm->next);
ffffffffc0200ef8:	649c                	ld	a5,8(s1)
ffffffffc0200efa:	60e2                	ld	ra,24(sp)
ffffffffc0200efc:	6902                	ld	s2,0(sp)
    prev->next = next->prev = elm;
ffffffffc0200efe:	e380                	sd	s0,0(a5)
ffffffffc0200f00:	e480                	sd	s0,8(s1)
    elm->prev = prev;
ffffffffc0200f02:	e004                	sd	s1,0(s0)
    elm->next = next;
ffffffffc0200f04:	e41c                	sd	a5,8(s0)
ffffffffc0200f06:	6442                	ld	s0,16(sp)
ffffffffc0200f08:	64a2                	ld	s1,8(sp)
ffffffffc0200f0a:	6105                	addi	sp,sp,32
ffffffffc0200f0c:	8082                	ret
    return list->next == list;
ffffffffc0200f0e:	7500                	ld	s0,40(a0)
        if (list_empty(&(cache->slabs_free))) {
ffffffffc0200f10:	02050793          	addi	a5,a0,32
ffffffffc0200f14:	00f40663          	beq	s0,a5,ffffffffc0200f20 <kmem_cache_alloc+0x7c>
    if (page->inuse == cache->objects_per_slab) {
ffffffffc0200f18:	5954                	lw	a3,52(a0)
        page = le2page(le, page_link);
ffffffffc0200f1a:	fe840713          	addi	a4,s0,-24
ffffffffc0200f1e:	b74d                	j	ffffffffc0200ec0 <kmem_cache_alloc+0x1c>
    struct Page *page = alloc_pages(cache->slab_pages);
ffffffffc0200f20:	03856503          	lwu	a0,56(a0)
ffffffffc0200f24:	aafff0ef          	jal	ra,ffffffffc02009d2 <alloc_pages>
    if (page == NULL) {
ffffffffc0200f28:	d171                	beqz	a0,ffffffffc0200eec <kmem_cache_alloc+0x48>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200f2a:	00004597          	auipc	a1,0x4
ffffffffc0200f2e:	18e5b583          	ld	a1,398(a1) # ffffffffc02050b8 <pages>
ffffffffc0200f32:	40b505b3          	sub	a1,a0,a1
    for (int i = 0; i < cache->objects_per_slab; i++) {
ffffffffc0200f36:	58d4                	lw	a3,52(s1)
ffffffffc0200f38:	00001797          	auipc	a5,0x1
ffffffffc0200f3c:	f807b783          	ld	a5,-128(a5) # ffffffffc0201eb8 <nbase>
ffffffffc0200f40:	8599                	srai	a1,a1,0x6
ffffffffc0200f42:	95be                	add	a1,a1,a5
    void *slab_base = (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
ffffffffc0200f44:	57f5                	li	a5,-3
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f46:	05b2                	slli	a1,a1,0xc
ffffffffc0200f48:	07fa                	slli	a5,a5,0x1e
    page->inuse = 0;
ffffffffc0200f4a:	02053823          	sd	zero,48(a0)
    page->cache = cache;
ffffffffc0200f4e:	fd04                	sd	s1,56(a0)
    page->freelist = NULL;
ffffffffc0200f50:	02053423          	sd	zero,40(a0)
    void *slab_base = (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
ffffffffc0200f54:	95be                	add	a1,a1,a5
    for (int i = 0; i < cache->objects_per_slab; i++) {
ffffffffc0200f56:	c69d                	beqz	a3,ffffffffc0200f84 <kmem_cache_alloc+0xe0>
        void *obj = (void *)((char *)slab_base + i * cache->object_size);
ffffffffc0200f58:	0304ae03          	lw	t3,48(s1)
ffffffffc0200f5c:	0006831b          	sext.w	t1,a3
ffffffffc0200f60:	4601                	li	a2,0
ffffffffc0200f62:	4781                	li	a5,0
    for (int i = 0; i < cache->objects_per_slab; i++) {
ffffffffc0200f64:	4701                	li	a4,0
        void *obj = (void *)((char *)slab_base + i * cache->object_size);
ffffffffc0200f66:	02061893          	slli	a7,a2,0x20
ffffffffc0200f6a:	0208d893          	srli	a7,a7,0x20
ffffffffc0200f6e:	883e                	mv	a6,a5
ffffffffc0200f70:	011587b3          	add	a5,a1,a7
        *(void **)obj = page->freelist;
ffffffffc0200f74:	0107b023          	sd	a6,0(a5)
        page->freelist = obj;
ffffffffc0200f78:	f51c                	sd	a5,40(a0)
    for (int i = 0; i < cache->objects_per_slab; i++) {
ffffffffc0200f7a:	2705                	addiw	a4,a4,1
ffffffffc0200f7c:	00ce063b          	addw	a2,t3,a2
ffffffffc0200f80:	fe6713e3          	bne	a4,t1,ffffffffc0200f66 <kmem_cache_alloc+0xc2>
    __list_add(elm, listelm, listelm->next);
ffffffffc0200f84:	749c                	ld	a5,40(s1)
    list_add(&(cache->slabs_free), &(page->page_link));
ffffffffc0200f86:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0200f8a:	e398                	sd	a4,0(a5)
ffffffffc0200f8c:	f498                	sd	a4,40(s1)
    elm->next = next;
ffffffffc0200f8e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200f90:	ed00                	sd	s0,24(a0)
    return listelm->next;
ffffffffc0200f92:	7480                	ld	s0,40(s1)
        page = le2page(le, page_link);
ffffffffc0200f94:	fe840713          	addi	a4,s0,-24
ffffffffc0200f98:	b725                	j	ffffffffc0200ec0 <kmem_cache_alloc+0x1c>

ffffffffc0200f9a <kmalloc_init>:
        current_size <<= 1;
    }
    return shift;
}

void kmalloc_init(void) {
ffffffffc0200f9a:	711d                	addi	sp,sp,-96
ffffffffc0200f9c:	e8a2                	sd	s0,80(sp)
ffffffffc0200f9e:	e4a6                	sd	s1,72(sp)
ffffffffc0200fa0:	fc4e                	sd	s3,56(sp)
ffffffffc0200fa2:	f852                	sd	s4,48(sp)
ffffffffc0200fa4:	f456                	sd	s5,40(sp)
ffffffffc0200fa6:	ec86                	sd	ra,88(sp)
ffffffffc0200fa8:	e0ca                	sd	s2,64(sp)
ffffffffc0200faa:	00004497          	auipc	s1,0x4
ffffffffc0200fae:	06e48493          	addi	s1,s1,110 # ffffffffc0205018 <kmalloc_caches>
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
ffffffffc0200fb2:	440d                	li	s0,3
        size_t size = 1 << i;
ffffffffc0200fb4:	4a85                	li	s5,1
        char name[32];
        snprintf(name, sizeof(name), "size-%d", (int)size);
ffffffffc0200fb6:	00001a17          	auipc	s4,0x1
ffffffffc0200fba:	cb2a0a13          	addi	s4,s4,-846 # ffffffffc0201c68 <buddy_pmm_manager+0x2e0>
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
ffffffffc0200fbe:	49b1                	li	s3,12
        size_t size = 1 << i;
ffffffffc0200fc0:	008a993b          	sllw	s2,s5,s0
        snprintf(name, sizeof(name), "size-%d", (int)size);
ffffffffc0200fc4:	86ca                	mv	a3,s2
ffffffffc0200fc6:	8652                	mv	a2,s4
ffffffffc0200fc8:	02000593          	li	a1,32
ffffffffc0200fcc:	850a                	mv	a0,sp
ffffffffc0200fce:	530000ef          	jal	ra,ffffffffc02014fe <snprintf>
        kmalloc_caches[i] = kmem_cache_create(name, size);
ffffffffc0200fd2:	85ca                	mv	a1,s2
ffffffffc0200fd4:	850a                	mv	a0,sp
ffffffffc0200fd6:	e49ff0ef          	jal	ra,ffffffffc0200e1e <kmem_cache_create>
ffffffffc0200fda:	ec88                	sd	a0,24(s1)
    for (int i = KMALLOC_MIN_SHIFT; i <= KMALLOC_MAX_SHIFT; i++) {
ffffffffc0200fdc:	2405                	addiw	s0,s0,1
ffffffffc0200fde:	04a1                	addi	s1,s1,8
ffffffffc0200fe0:	ff3410e3          	bne	s0,s3,ffffffffc0200fc0 <kmalloc_init+0x26>
        // 在真实系统中，如果失败应该panic
    }
}
ffffffffc0200fe4:	60e6                	ld	ra,88(sp)
ffffffffc0200fe6:	6446                	ld	s0,80(sp)
ffffffffc0200fe8:	64a6                	ld	s1,72(sp)
ffffffffc0200fea:	6906                	ld	s2,64(sp)
ffffffffc0200fec:	79e2                	ld	s3,56(sp)
ffffffffc0200fee:	7a42                	ld	s4,48(sp)
ffffffffc0200ff0:	7aa2                	ld	s5,40(sp)
ffffffffc0200ff2:	6125                	addi	sp,sp,96
ffffffffc0200ff4:	8082                	ret

ffffffffc0200ff6 <kmalloc>:

void *kmalloc(size_t size) {
ffffffffc0200ff6:	1141                	addi	sp,sp,-16
ffffffffc0200ff8:	e022                	sd	s0,0(sp)
    if (size > (1 << KMALLOC_MAX_SHIFT)) {
ffffffffc0200ffa:	6405                	lui	s0,0x1
void *kmalloc(size_t size) {
ffffffffc0200ffc:	e406                	sd	ra,8(sp)
    if (size > (1 << KMALLOC_MAX_SHIFT)) {
ffffffffc0200ffe:	80040793          	addi	a5,s0,-2048 # 800 <kern_entry-0xffffffffc01ff800>
ffffffffc0201002:	02a7ec63          	bltu	a5,a0,ffffffffc020103a <kmalloc+0x44>
    while (current_size < size) {
ffffffffc0201006:	46a1                	li	a3,8
    size_t current_size = 1 << shift;
ffffffffc0201008:	47a1                	li	a5,8
    size_t shift = KMALLOC_MIN_SHIFT;
ffffffffc020100a:	470d                	li	a4,3
    while (current_size < size) {
ffffffffc020100c:	00a6f663          	bgeu	a3,a0,ffffffffc0201018 <kmalloc+0x22>
        current_size <<= 1;
ffffffffc0201010:	0786                	slli	a5,a5,0x1
        shift++;
ffffffffc0201012:	0705                	addi	a4,a4,1
    while (current_size < size) {
ffffffffc0201014:	fea7eee3          	bltu	a5,a0,ffffffffc0201010 <kmalloc+0x1a>
        }
        return (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
    }

    size_t index = size_to_index(size);
    if (kmalloc_caches[index]) {
ffffffffc0201018:	070e                	slli	a4,a4,0x3
ffffffffc020101a:	00004797          	auipc	a5,0x4
ffffffffc020101e:	ffe78793          	addi	a5,a5,-2 # ffffffffc0205018 <kmalloc_caches>
ffffffffc0201022:	973e                	add	a4,a4,a5
ffffffffc0201024:	6308                	ld	a0,0(a4)
ffffffffc0201026:	c509                	beqz	a0,ffffffffc0201030 <kmalloc+0x3a>
        return kmem_cache_alloc(kmalloc_caches[index]);
    }
    return NULL;
}
ffffffffc0201028:	6402                	ld	s0,0(sp)
ffffffffc020102a:	60a2                	ld	ra,8(sp)
ffffffffc020102c:	0141                	addi	sp,sp,16
        return kmem_cache_alloc(kmalloc_caches[index]);
ffffffffc020102e:	bd9d                	j	ffffffffc0200ea4 <kmem_cache_alloc>
}
ffffffffc0201030:	60a2                	ld	ra,8(sp)
ffffffffc0201032:	6402                	ld	s0,0(sp)
            return NULL;
ffffffffc0201034:	4501                	li	a0,0
}
ffffffffc0201036:	0141                	addi	sp,sp,16
ffffffffc0201038:	8082                	ret
        uint32_t num_pages = (size + PGSIZE - 1) / PGSIZE;
ffffffffc020103a:	147d                	addi	s0,s0,-1
ffffffffc020103c:	942a                	add	s0,s0,a0
ffffffffc020103e:	8031                	srli	s0,s0,0xc
        struct Page *page = alloc_pages(num_pages);
ffffffffc0201040:	02041513          	slli	a0,s0,0x20
ffffffffc0201044:	9101                	srli	a0,a0,0x20
        uint32_t num_pages = (size + PGSIZE - 1) / PGSIZE;
ffffffffc0201046:	2401                	sext.w	s0,s0
        struct Page *page = alloc_pages(num_pages);
ffffffffc0201048:	98bff0ef          	jal	ra,ffffffffc02009d2 <alloc_pages>
        if (page == NULL) {
ffffffffc020104c:	d175                	beqz	a0,ffffffffc0201030 <kmalloc+0x3a>
        page->property = num_pages;
ffffffffc020104e:	c900                	sw	s0,16(a0)
        for(int i = 0; i < num_pages; i++) {
ffffffffc0201050:	c015                	beqz	s0,ffffffffc0201074 <kmalloc+0x7e>
ffffffffc0201052:	fff4079b          	addiw	a5,s0,-1
ffffffffc0201056:	02079713          	slli	a4,a5,0x20
ffffffffc020105a:	01a75793          	srli	a5,a4,0x1a
ffffffffc020105e:	07878793          	addi	a5,a5,120
ffffffffc0201062:	03850713          	addi	a4,a0,56
ffffffffc0201066:	97aa                	add	a5,a5,a0
            (page + i)->cache = NULL;
ffffffffc0201068:	00073023          	sd	zero,0(a4)
        for(int i = 0; i < num_pages; i++) {
ffffffffc020106c:	04070713          	addi	a4,a4,64
ffffffffc0201070:	fef71ce3          	bne	a4,a5,ffffffffc0201068 <kmalloc+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201074:	00004797          	auipc	a5,0x4
ffffffffc0201078:	0447b783          	ld	a5,68(a5) # ffffffffc02050b8 <pages>
ffffffffc020107c:	8d1d                	sub	a0,a0,a5
}
ffffffffc020107e:	60a2                	ld	ra,8(sp)
ffffffffc0201080:	00001797          	auipc	a5,0x1
ffffffffc0201084:	e387b783          	ld	a5,-456(a5) # ffffffffc0201eb8 <nbase>
ffffffffc0201088:	6402                	ld	s0,0(sp)
ffffffffc020108a:	8519                	srai	a0,a0,0x6
ffffffffc020108c:	953e                	add	a0,a0,a5
        return (void *)(page2pa(page) + PHYSICAL_MEMORY_OFFSET);
ffffffffc020108e:	57f5                	li	a5,-3
    return page2ppn(page) << PGSHIFT;
ffffffffc0201090:	0532                	slli	a0,a0,0xc
ffffffffc0201092:	07fa                	slli	a5,a5,0x1e
ffffffffc0201094:	953e                	add	a0,a0,a5
}
ffffffffc0201096:	0141                	addi	sp,sp,16
ffffffffc0201098:	8082                	ret

ffffffffc020109a <kfree>:

void kfree(void *ptr) {
    if (ptr == NULL) {
ffffffffc020109a:	cd1d                	beqz	a0,ffffffffc02010d8 <kfree+0x3e>
        return;
    }
    struct Page *page = pa2page((uintptr_t)ptr - PHYSICAL_MEMORY_OFFSET);
ffffffffc020109c:	470d                	li	a4,3
ffffffffc020109e:	077a                	slli	a4,a4,0x1e
ffffffffc02010a0:	00e507b3          	add	a5,a0,a4
    if (PPN(pa) >= npage) {
ffffffffc02010a4:	83b1                	srli	a5,a5,0xc
ffffffffc02010a6:	00004717          	auipc	a4,0x4
ffffffffc02010aa:	00a73703          	ld	a4,10(a4) # ffffffffc02050b0 <npage>
ffffffffc02010ae:	02e7f663          	bgeu	a5,a4,ffffffffc02010da <kfree+0x40>
    return &pages[PPN(pa) - nbase];
ffffffffc02010b2:	00001717          	auipc	a4,0x1
ffffffffc02010b6:	e0673703          	ld	a4,-506(a4) # ffffffffc0201eb8 <nbase>
ffffffffc02010ba:	8f99                	sub	a5,a5,a4
ffffffffc02010bc:	079a                	slli	a5,a5,0x6
ffffffffc02010be:	00004717          	auipc	a4,0x4
ffffffffc02010c2:	ffa73703          	ld	a4,-6(a4) # ffffffffc02050b8 <pages>
ffffffffc02010c6:	97ba                	add	a5,a5,a4
    if (page->cache != NULL) {
ffffffffc02010c8:	7f98                	ld	a4,56(a5)
ffffffffc02010ca:	c311                	beqz	a4,ffffffffc02010ce <kfree+0x34>
    if (obj == NULL) {
ffffffffc02010cc:	b94d                	j	ffffffffc0200d7e <kmem_cache_free.part.0>
        // 这个指针是从slab缓存分配的
        kmem_cache_free(ptr);
    } else {
        // 这个指针是直接从buddy系统分配的
        free_pages(page, page->property);
ffffffffc02010ce:	0107e583          	lwu	a1,16(a5)
ffffffffc02010d2:	853e                	mv	a0,a5
ffffffffc02010d4:	90bff06f          	j	ffffffffc02009de <free_pages>
ffffffffc02010d8:	8082                	ret
void kfree(void *ptr) {
ffffffffc02010da:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02010dc:	00001617          	auipc	a2,0x1
ffffffffc02010e0:	99c60613          	addi	a2,a2,-1636 # ffffffffc0201a78 <buddy_pmm_manager+0xf0>
ffffffffc02010e4:	06a00593          	li	a1,106
ffffffffc02010e8:	00001517          	auipc	a0,0x1
ffffffffc02010ec:	9b050513          	addi	a0,a0,-1616 # ffffffffc0201a98 <buddy_pmm_manager+0x110>
ffffffffc02010f0:	e406                	sd	ra,8(sp)
ffffffffc02010f2:	8d0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02010f6 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02010f6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02010fa:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02010fc:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201100:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201102:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201106:	f022                	sd	s0,32(sp)
ffffffffc0201108:	ec26                	sd	s1,24(sp)
ffffffffc020110a:	e84a                	sd	s2,16(sp)
ffffffffc020110c:	f406                	sd	ra,40(sp)
ffffffffc020110e:	e44e                	sd	s3,8(sp)
ffffffffc0201110:	84aa                	mv	s1,a0
ffffffffc0201112:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201114:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201118:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020111a:	03067e63          	bgeu	a2,a6,ffffffffc0201156 <printnum+0x60>
ffffffffc020111e:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201120:	00805763          	blez	s0,ffffffffc020112e <printnum+0x38>
ffffffffc0201124:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201126:	85ca                	mv	a1,s2
ffffffffc0201128:	854e                	mv	a0,s3
ffffffffc020112a:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020112c:	fc65                	bnez	s0,ffffffffc0201124 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020112e:	1a02                	slli	s4,s4,0x20
ffffffffc0201130:	00001797          	auipc	a5,0x1
ffffffffc0201134:	b4078793          	addi	a5,a5,-1216 # ffffffffc0201c70 <buddy_pmm_manager+0x2e8>
ffffffffc0201138:	020a5a13          	srli	s4,s4,0x20
ffffffffc020113c:	9a3e                	add	s4,s4,a5
}
ffffffffc020113e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201140:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201144:	70a2                	ld	ra,40(sp)
ffffffffc0201146:	69a2                	ld	s3,8(sp)
ffffffffc0201148:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020114a:	85ca                	mv	a1,s2
ffffffffc020114c:	87a6                	mv	a5,s1
}
ffffffffc020114e:	6942                	ld	s2,16(sp)
ffffffffc0201150:	64e2                	ld	s1,24(sp)
ffffffffc0201152:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201154:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201156:	03065633          	divu	a2,a2,a6
ffffffffc020115a:	8722                	mv	a4,s0
ffffffffc020115c:	f9bff0ef          	jal	ra,ffffffffc02010f6 <printnum>
ffffffffc0201160:	b7f9                	j	ffffffffc020112e <printnum+0x38>

ffffffffc0201162 <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
    b->cnt ++;
ffffffffc0201162:	499c                	lw	a5,16(a1)
    if (b->buf < b->ebuf) {
ffffffffc0201164:	6198                	ld	a4,0(a1)
ffffffffc0201166:	6594                	ld	a3,8(a1)
    b->cnt ++;
ffffffffc0201168:	2785                	addiw	a5,a5,1
ffffffffc020116a:	c99c                	sw	a5,16(a1)
    if (b->buf < b->ebuf) {
ffffffffc020116c:	00d77763          	bgeu	a4,a3,ffffffffc020117a <sprintputch+0x18>
        *b->buf ++ = ch;
ffffffffc0201170:	00170793          	addi	a5,a4,1
ffffffffc0201174:	e19c                	sd	a5,0(a1)
ffffffffc0201176:	00a70023          	sb	a0,0(a4)
    }
}
ffffffffc020117a:	8082                	ret

ffffffffc020117c <vprintfmt>:
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020117c:	7119                	addi	sp,sp,-128
ffffffffc020117e:	f4a6                	sd	s1,104(sp)
ffffffffc0201180:	f0ca                	sd	s2,96(sp)
ffffffffc0201182:	ecce                	sd	s3,88(sp)
ffffffffc0201184:	e8d2                	sd	s4,80(sp)
ffffffffc0201186:	e4d6                	sd	s5,72(sp)
ffffffffc0201188:	e0da                	sd	s6,64(sp)
ffffffffc020118a:	fc5e                	sd	s7,56(sp)
ffffffffc020118c:	f06a                	sd	s10,32(sp)
ffffffffc020118e:	fc86                	sd	ra,120(sp)
ffffffffc0201190:	f8a2                	sd	s0,112(sp)
ffffffffc0201192:	f862                	sd	s8,48(sp)
ffffffffc0201194:	f466                	sd	s9,40(sp)
ffffffffc0201196:	ec6e                	sd	s11,24(sp)
ffffffffc0201198:	892a                	mv	s2,a0
ffffffffc020119a:	84ae                	mv	s1,a1
ffffffffc020119c:	8d32                	mv	s10,a2
ffffffffc020119e:	8a36                	mv	s4,a3
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02011a0:	02500993          	li	s3,37
        width = precision = -1;
ffffffffc02011a4:	5b7d                	li	s6,-1
ffffffffc02011a6:	00001a97          	auipc	s5,0x1
ffffffffc02011aa:	afea8a93          	addi	s5,s5,-1282 # ffffffffc0201ca4 <buddy_pmm_manager+0x31c>
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02011ae:	00001b97          	auipc	s7,0x1
ffffffffc02011b2:	cd2b8b93          	addi	s7,s7,-814 # ffffffffc0201e80 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02011b6:	000d4503          	lbu	a0,0(s10)
ffffffffc02011ba:	001d0413          	addi	s0,s10,1
ffffffffc02011be:	01350a63          	beq	a0,s3,ffffffffc02011d2 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02011c2:	c121                	beqz	a0,ffffffffc0201202 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02011c4:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02011c6:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02011c8:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02011ca:	fff44503          	lbu	a0,-1(s0)
ffffffffc02011ce:	ff351ae3          	bne	a0,s3,ffffffffc02011c2 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02011d2:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02011d6:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02011da:	4c81                	li	s9,0
ffffffffc02011dc:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02011de:	5c7d                	li	s8,-1
ffffffffc02011e0:	5dfd                	li	s11,-1
ffffffffc02011e2:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02011e6:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02011e8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02011ec:	0ff5f593          	zext.b	a1,a1
ffffffffc02011f0:	00140d13          	addi	s10,s0,1
ffffffffc02011f4:	04b56263          	bltu	a0,a1,ffffffffc0201238 <vprintfmt+0xbc>
ffffffffc02011f8:	058a                	slli	a1,a1,0x2
ffffffffc02011fa:	95d6                	add	a1,a1,s5
ffffffffc02011fc:	4194                	lw	a3,0(a1)
ffffffffc02011fe:	96d6                	add	a3,a3,s5
ffffffffc0201200:	8682                	jr	a3
}
ffffffffc0201202:	70e6                	ld	ra,120(sp)
ffffffffc0201204:	7446                	ld	s0,112(sp)
ffffffffc0201206:	74a6                	ld	s1,104(sp)
ffffffffc0201208:	7906                	ld	s2,96(sp)
ffffffffc020120a:	69e6                	ld	s3,88(sp)
ffffffffc020120c:	6a46                	ld	s4,80(sp)
ffffffffc020120e:	6aa6                	ld	s5,72(sp)
ffffffffc0201210:	6b06                	ld	s6,64(sp)
ffffffffc0201212:	7be2                	ld	s7,56(sp)
ffffffffc0201214:	7c42                	ld	s8,48(sp)
ffffffffc0201216:	7ca2                	ld	s9,40(sp)
ffffffffc0201218:	7d02                	ld	s10,32(sp)
ffffffffc020121a:	6de2                	ld	s11,24(sp)
ffffffffc020121c:	6109                	addi	sp,sp,128
ffffffffc020121e:	8082                	ret
            padc = '0';
ffffffffc0201220:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201222:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201226:	846a                	mv	s0,s10
ffffffffc0201228:	00140d13          	addi	s10,s0,1
ffffffffc020122c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201230:	0ff5f593          	zext.b	a1,a1
ffffffffc0201234:	fcb572e3          	bgeu	a0,a1,ffffffffc02011f8 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201238:	85a6                	mv	a1,s1
ffffffffc020123a:	02500513          	li	a0,37
ffffffffc020123e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201240:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201244:	8d22                	mv	s10,s0
ffffffffc0201246:	f73788e3          	beq	a5,s3,ffffffffc02011b6 <vprintfmt+0x3a>
ffffffffc020124a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020124e:	1d7d                	addi	s10,s10,-1
ffffffffc0201250:	ff379de3          	bne	a5,s3,ffffffffc020124a <vprintfmt+0xce>
ffffffffc0201254:	b78d                	j	ffffffffc02011b6 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201256:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020125a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020125e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201260:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201264:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201268:	02d86463          	bltu	a6,a3,ffffffffc0201290 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020126c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201270:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201274:	0186873b          	addw	a4,a3,s8
ffffffffc0201278:	0017171b          	slliw	a4,a4,0x1
ffffffffc020127c:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020127e:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201282:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201284:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201288:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020128c:	fed870e3          	bgeu	a6,a3,ffffffffc020126c <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201290:	f40ddce3          	bgez	s11,ffffffffc02011e8 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201294:	8de2                	mv	s11,s8
ffffffffc0201296:	5c7d                	li	s8,-1
ffffffffc0201298:	bf81                	j	ffffffffc02011e8 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020129a:	fffdc693          	not	a3,s11
ffffffffc020129e:	96fd                	srai	a3,a3,0x3f
ffffffffc02012a0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012a4:	00144603          	lbu	a2,1(s0)
ffffffffc02012a8:	2d81                	sext.w	s11,s11
ffffffffc02012aa:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02012ac:	bf35                	j	ffffffffc02011e8 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02012ae:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012b2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02012b6:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012b8:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02012ba:	bfd9                	j	ffffffffc0201290 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02012bc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02012be:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02012c2:	01174463          	blt	a4,a7,ffffffffc02012ca <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02012c6:	1a088e63          	beqz	a7,ffffffffc0201482 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02012ca:	000a3603          	ld	a2,0(s4)
ffffffffc02012ce:	46c1                	li	a3,16
ffffffffc02012d0:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02012d2:	2781                	sext.w	a5,a5
ffffffffc02012d4:	876e                	mv	a4,s11
ffffffffc02012d6:	85a6                	mv	a1,s1
ffffffffc02012d8:	854a                	mv	a0,s2
ffffffffc02012da:	e1dff0ef          	jal	ra,ffffffffc02010f6 <printnum>
            break;
ffffffffc02012de:	bde1                	j	ffffffffc02011b6 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02012e0:	000a2503          	lw	a0,0(s4)
ffffffffc02012e4:	85a6                	mv	a1,s1
ffffffffc02012e6:	0a21                	addi	s4,s4,8
ffffffffc02012e8:	9902                	jalr	s2
            break;
ffffffffc02012ea:	b5f1                	j	ffffffffc02011b6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02012ec:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02012ee:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02012f2:	01174463          	blt	a4,a7,ffffffffc02012fa <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02012f6:	18088163          	beqz	a7,ffffffffc0201478 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02012fa:	000a3603          	ld	a2,0(s4)
ffffffffc02012fe:	46a9                	li	a3,10
ffffffffc0201300:	8a2e                	mv	s4,a1
ffffffffc0201302:	bfc1                	j	ffffffffc02012d2 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201304:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201308:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020130a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020130c:	bdf1                	j	ffffffffc02011e8 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020130e:	85a6                	mv	a1,s1
ffffffffc0201310:	02500513          	li	a0,37
ffffffffc0201314:	9902                	jalr	s2
            break;
ffffffffc0201316:	b545                	j	ffffffffc02011b6 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201318:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020131c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020131e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201320:	b5e1                	j	ffffffffc02011e8 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201322:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201324:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201328:	01174463          	blt	a4,a7,ffffffffc0201330 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020132c:	14088163          	beqz	a7,ffffffffc020146e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201330:	000a3603          	ld	a2,0(s4)
ffffffffc0201334:	46a1                	li	a3,8
ffffffffc0201336:	8a2e                	mv	s4,a1
ffffffffc0201338:	bf69                	j	ffffffffc02012d2 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020133a:	03000513          	li	a0,48
ffffffffc020133e:	85a6                	mv	a1,s1
ffffffffc0201340:	e03e                	sd	a5,0(sp)
ffffffffc0201342:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201344:	85a6                	mv	a1,s1
ffffffffc0201346:	07800513          	li	a0,120
ffffffffc020134a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020134c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020134e:	6782                	ld	a5,0(sp)
ffffffffc0201350:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201352:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201356:	bfb5                	j	ffffffffc02012d2 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201358:	000a3403          	ld	s0,0(s4)
ffffffffc020135c:	008a0713          	addi	a4,s4,8
ffffffffc0201360:	e03a                	sd	a4,0(sp)
ffffffffc0201362:	14040263          	beqz	s0,ffffffffc02014a6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201366:	0fb05763          	blez	s11,ffffffffc0201454 <vprintfmt+0x2d8>
ffffffffc020136a:	02d00693          	li	a3,45
ffffffffc020136e:	0cd79163          	bne	a5,a3,ffffffffc0201430 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201372:	00044783          	lbu	a5,0(s0)
ffffffffc0201376:	0007851b          	sext.w	a0,a5
ffffffffc020137a:	cf85                	beqz	a5,ffffffffc02013b2 <vprintfmt+0x236>
ffffffffc020137c:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201380:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201384:	000c4563          	bltz	s8,ffffffffc020138e <vprintfmt+0x212>
ffffffffc0201388:	3c7d                	addiw	s8,s8,-1
ffffffffc020138a:	036c0263          	beq	s8,s6,ffffffffc02013ae <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc020138e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201390:	0e0c8e63          	beqz	s9,ffffffffc020148c <vprintfmt+0x310>
ffffffffc0201394:	3781                	addiw	a5,a5,-32
ffffffffc0201396:	0ef47b63          	bgeu	s0,a5,ffffffffc020148c <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020139a:	03f00513          	li	a0,63
ffffffffc020139e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02013a0:	000a4783          	lbu	a5,0(s4)
ffffffffc02013a4:	3dfd                	addiw	s11,s11,-1
ffffffffc02013a6:	0a05                	addi	s4,s4,1
ffffffffc02013a8:	0007851b          	sext.w	a0,a5
ffffffffc02013ac:	ffe1                	bnez	a5,ffffffffc0201384 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02013ae:	01b05963          	blez	s11,ffffffffc02013c0 <vprintfmt+0x244>
ffffffffc02013b2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02013b4:	85a6                	mv	a1,s1
ffffffffc02013b6:	02000513          	li	a0,32
ffffffffc02013ba:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02013bc:	fe0d9be3          	bnez	s11,ffffffffc02013b2 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02013c0:	6a02                	ld	s4,0(sp)
ffffffffc02013c2:	bbd5                	j	ffffffffc02011b6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02013c4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02013c6:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02013ca:	01174463          	blt	a4,a7,ffffffffc02013d2 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02013ce:	08088d63          	beqz	a7,ffffffffc0201468 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02013d2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02013d6:	0a044d63          	bltz	s0,ffffffffc0201490 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02013da:	8622                	mv	a2,s0
ffffffffc02013dc:	8a66                	mv	s4,s9
ffffffffc02013de:	46a9                	li	a3,10
ffffffffc02013e0:	bdcd                	j	ffffffffc02012d2 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02013e2:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02013e6:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02013e8:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02013ea:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02013ee:	8fb5                	xor	a5,a5,a3
ffffffffc02013f0:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02013f4:	02d74163          	blt	a4,a3,ffffffffc0201416 <vprintfmt+0x29a>
ffffffffc02013f8:	00369793          	slli	a5,a3,0x3
ffffffffc02013fc:	97de                	add	a5,a5,s7
ffffffffc02013fe:	639c                	ld	a5,0(a5)
ffffffffc0201400:	cb99                	beqz	a5,ffffffffc0201416 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201402:	86be                	mv	a3,a5
ffffffffc0201404:	00001617          	auipc	a2,0x1
ffffffffc0201408:	89c60613          	addi	a2,a2,-1892 # ffffffffc0201ca0 <buddy_pmm_manager+0x318>
ffffffffc020140c:	85a6                	mv	a1,s1
ffffffffc020140e:	854a                	mv	a0,s2
ffffffffc0201410:	0ce000ef          	jal	ra,ffffffffc02014de <printfmt>
ffffffffc0201414:	b34d                	j	ffffffffc02011b6 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201416:	00001617          	auipc	a2,0x1
ffffffffc020141a:	87a60613          	addi	a2,a2,-1926 # ffffffffc0201c90 <buddy_pmm_manager+0x308>
ffffffffc020141e:	85a6                	mv	a1,s1
ffffffffc0201420:	854a                	mv	a0,s2
ffffffffc0201422:	0bc000ef          	jal	ra,ffffffffc02014de <printfmt>
ffffffffc0201426:	bb41                	j	ffffffffc02011b6 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201428:	00001417          	auipc	s0,0x1
ffffffffc020142c:	86040413          	addi	s0,s0,-1952 # ffffffffc0201c88 <buddy_pmm_manager+0x300>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201430:	85e2                	mv	a1,s8
ffffffffc0201432:	8522                	mv	a0,s0
ffffffffc0201434:	e43e                	sd	a5,8(sp)
ffffffffc0201436:	142000ef          	jal	ra,ffffffffc0201578 <strnlen>
ffffffffc020143a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020143e:	01b05b63          	blez	s11,ffffffffc0201454 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201442:	67a2                	ld	a5,8(sp)
ffffffffc0201444:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201448:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020144a:	85a6                	mv	a1,s1
ffffffffc020144c:	8552                	mv	a0,s4
ffffffffc020144e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201450:	fe0d9ce3          	bnez	s11,ffffffffc0201448 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201454:	00044783          	lbu	a5,0(s0)
ffffffffc0201458:	00140a13          	addi	s4,s0,1
ffffffffc020145c:	0007851b          	sext.w	a0,a5
ffffffffc0201460:	d3a5                	beqz	a5,ffffffffc02013c0 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201462:	05e00413          	li	s0,94
ffffffffc0201466:	bf39                	j	ffffffffc0201384 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201468:	000a2403          	lw	s0,0(s4)
ffffffffc020146c:	b7ad                	j	ffffffffc02013d6 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020146e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201472:	46a1                	li	a3,8
ffffffffc0201474:	8a2e                	mv	s4,a1
ffffffffc0201476:	bdb1                	j	ffffffffc02012d2 <vprintfmt+0x156>
ffffffffc0201478:	000a6603          	lwu	a2,0(s4)
ffffffffc020147c:	46a9                	li	a3,10
ffffffffc020147e:	8a2e                	mv	s4,a1
ffffffffc0201480:	bd89                	j	ffffffffc02012d2 <vprintfmt+0x156>
ffffffffc0201482:	000a6603          	lwu	a2,0(s4)
ffffffffc0201486:	46c1                	li	a3,16
ffffffffc0201488:	8a2e                	mv	s4,a1
ffffffffc020148a:	b5a1                	j	ffffffffc02012d2 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020148c:	9902                	jalr	s2
ffffffffc020148e:	bf09                	j	ffffffffc02013a0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201490:	85a6                	mv	a1,s1
ffffffffc0201492:	02d00513          	li	a0,45
ffffffffc0201496:	e03e                	sd	a5,0(sp)
ffffffffc0201498:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020149a:	6782                	ld	a5,0(sp)
ffffffffc020149c:	8a66                	mv	s4,s9
ffffffffc020149e:	40800633          	neg	a2,s0
ffffffffc02014a2:	46a9                	li	a3,10
ffffffffc02014a4:	b53d                	j	ffffffffc02012d2 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02014a6:	03b05163          	blez	s11,ffffffffc02014c8 <vprintfmt+0x34c>
ffffffffc02014aa:	02d00693          	li	a3,45
ffffffffc02014ae:	f6d79de3          	bne	a5,a3,ffffffffc0201428 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02014b2:	00000417          	auipc	s0,0x0
ffffffffc02014b6:	7d640413          	addi	s0,s0,2006 # ffffffffc0201c88 <buddy_pmm_manager+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014ba:	02800793          	li	a5,40
ffffffffc02014be:	02800513          	li	a0,40
ffffffffc02014c2:	00140a13          	addi	s4,s0,1
ffffffffc02014c6:	bd6d                	j	ffffffffc0201380 <vprintfmt+0x204>
ffffffffc02014c8:	00000a17          	auipc	s4,0x0
ffffffffc02014cc:	7c1a0a13          	addi	s4,s4,1985 # ffffffffc0201c89 <buddy_pmm_manager+0x301>
ffffffffc02014d0:	02800513          	li	a0,40
ffffffffc02014d4:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02014d8:	05e00413          	li	s0,94
ffffffffc02014dc:	b565                	j	ffffffffc0201384 <vprintfmt+0x208>

ffffffffc02014de <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02014de:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02014e0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02014e4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02014e6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02014e8:	ec06                	sd	ra,24(sp)
ffffffffc02014ea:	f83a                	sd	a4,48(sp)
ffffffffc02014ec:	fc3e                	sd	a5,56(sp)
ffffffffc02014ee:	e0c2                	sd	a6,64(sp)
ffffffffc02014f0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02014f2:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02014f4:	c89ff0ef          	jal	ra,ffffffffc020117c <vprintfmt>
}
ffffffffc02014f8:	60e2                	ld	ra,24(sp)
ffffffffc02014fa:	6161                	addi	sp,sp,80
ffffffffc02014fc:	8082                	ret

ffffffffc02014fe <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
ffffffffc02014fe:	711d                	addi	sp,sp,-96
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
    struct sprintbuf b = {str, str + size - 1, 0};
ffffffffc0201500:	15fd                	addi	a1,a1,-1
    va_start(ap, fmt);
ffffffffc0201502:	03810313          	addi	t1,sp,56
    struct sprintbuf b = {str, str + size - 1, 0};
ffffffffc0201506:	95aa                	add	a1,a1,a0
snprintf(char *str, size_t size, const char *fmt, ...) {
ffffffffc0201508:	f406                	sd	ra,40(sp)
ffffffffc020150a:	fc36                	sd	a3,56(sp)
ffffffffc020150c:	e0ba                	sd	a4,64(sp)
ffffffffc020150e:	e4be                	sd	a5,72(sp)
ffffffffc0201510:	e8c2                	sd	a6,80(sp)
ffffffffc0201512:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0201514:	e01a                	sd	t1,0(sp)
    struct sprintbuf b = {str, str + size - 1, 0};
ffffffffc0201516:	e42a                	sd	a0,8(sp)
ffffffffc0201518:	e82e                	sd	a1,16(sp)
ffffffffc020151a:	cc02                	sw	zero,24(sp)
    if (str == NULL || b.buf > b.ebuf) {
ffffffffc020151c:	c115                	beqz	a0,ffffffffc0201540 <snprintf+0x42>
ffffffffc020151e:	02a5e163          	bltu	a1,a0,ffffffffc0201540 <snprintf+0x42>
        return -E_INVAL;
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
ffffffffc0201522:	00000517          	auipc	a0,0x0
ffffffffc0201526:	c4050513          	addi	a0,a0,-960 # ffffffffc0201162 <sprintputch>
ffffffffc020152a:	869a                	mv	a3,t1
ffffffffc020152c:	002c                	addi	a1,sp,8
ffffffffc020152e:	c4fff0ef          	jal	ra,ffffffffc020117c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
ffffffffc0201532:	67a2                	ld	a5,8(sp)
ffffffffc0201534:	00078023          	sb	zero,0(a5)
    return b.cnt;
ffffffffc0201538:	4562                	lw	a0,24(sp)
}
ffffffffc020153a:	70a2                	ld	ra,40(sp)
ffffffffc020153c:	6125                	addi	sp,sp,96
ffffffffc020153e:	8082                	ret
        return -E_INVAL;
ffffffffc0201540:	5575                	li	a0,-3
ffffffffc0201542:	bfe5                	j	ffffffffc020153a <snprintf+0x3c>

ffffffffc0201544 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201544:	4781                	li	a5,0
ffffffffc0201546:	00004717          	auipc	a4,0x4
ffffffffc020154a:	aca73703          	ld	a4,-1334(a4) # ffffffffc0205010 <SBI_CONSOLE_PUTCHAR>
ffffffffc020154e:	88ba                	mv	a7,a4
ffffffffc0201550:	852a                	mv	a0,a0
ffffffffc0201552:	85be                	mv	a1,a5
ffffffffc0201554:	863e                	mv	a2,a5
ffffffffc0201556:	00000073          	ecall
ffffffffc020155a:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc020155c:	8082                	ret

ffffffffc020155e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020155e:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201562:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201564:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201566:	cb81                	beqz	a5,ffffffffc0201576 <strlen+0x18>
        cnt ++;
ffffffffc0201568:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020156a:	00a707b3          	add	a5,a4,a0
ffffffffc020156e:	0007c783          	lbu	a5,0(a5)
ffffffffc0201572:	fbfd                	bnez	a5,ffffffffc0201568 <strlen+0xa>
ffffffffc0201574:	8082                	ret
    }
    return cnt;
}
ffffffffc0201576:	8082                	ret

ffffffffc0201578 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201578:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020157a:	e589                	bnez	a1,ffffffffc0201584 <strnlen+0xc>
ffffffffc020157c:	a811                	j	ffffffffc0201590 <strnlen+0x18>
        cnt ++;
ffffffffc020157e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201580:	00f58863          	beq	a1,a5,ffffffffc0201590 <strnlen+0x18>
ffffffffc0201584:	00f50733          	add	a4,a0,a5
ffffffffc0201588:	00074703          	lbu	a4,0(a4)
ffffffffc020158c:	fb6d                	bnez	a4,ffffffffc020157e <strnlen+0x6>
ffffffffc020158e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201590:	852e                	mv	a0,a1
ffffffffc0201592:	8082                	ret

ffffffffc0201594 <strncpy>:
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
ffffffffc0201594:	ce09                	beqz	a2,ffffffffc02015ae <strncpy+0x1a>
ffffffffc0201596:	962a                	add	a2,a2,a0
    char *p = dst;
ffffffffc0201598:	87aa                	mv	a5,a0
        if ((*p = *src) != '\0') {
ffffffffc020159a:	0005c703          	lbu	a4,0(a1)
            src ++;
        }
        p ++, len --;
ffffffffc020159e:	0785                	addi	a5,a5,1
            src ++;
ffffffffc02015a0:	00e036b3          	snez	a3,a4
        if ((*p = *src) != '\0') {
ffffffffc02015a4:	fee78fa3          	sb	a4,-1(a5)
            src ++;
ffffffffc02015a8:	95b6                	add	a1,a1,a3
    while (len > 0) {
ffffffffc02015aa:	fec798e3          	bne	a5,a2,ffffffffc020159a <strncpy+0x6>
    }
    return dst;
}
ffffffffc02015ae:	8082                	ret

ffffffffc02015b0 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02015b0:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02015b4:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02015b8:	cb89                	beqz	a5,ffffffffc02015ca <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02015ba:	0505                	addi	a0,a0,1
ffffffffc02015bc:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02015be:	fee789e3          	beq	a5,a4,ffffffffc02015b0 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02015c2:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02015c6:	9d19                	subw	a0,a0,a4
ffffffffc02015c8:	8082                	ret
ffffffffc02015ca:	4501                	li	a0,0
ffffffffc02015cc:	bfed                	j	ffffffffc02015c6 <strcmp+0x16>

ffffffffc02015ce <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02015ce:	c20d                	beqz	a2,ffffffffc02015f0 <strncmp+0x22>
ffffffffc02015d0:	962e                	add	a2,a2,a1
ffffffffc02015d2:	a031                	j	ffffffffc02015de <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02015d4:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02015d6:	00e79a63          	bne	a5,a4,ffffffffc02015ea <strncmp+0x1c>
ffffffffc02015da:	00b60b63          	beq	a2,a1,ffffffffc02015f0 <strncmp+0x22>
ffffffffc02015de:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02015e2:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02015e4:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02015e8:	f7f5                	bnez	a5,ffffffffc02015d4 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02015ea:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02015ee:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02015f0:	4501                	li	a0,0
ffffffffc02015f2:	8082                	ret

ffffffffc02015f4 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02015f4:	ca01                	beqz	a2,ffffffffc0201604 <memset+0x10>
ffffffffc02015f6:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02015f8:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02015fa:	0785                	addi	a5,a5,1
ffffffffc02015fc:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201600:	fec79de3          	bne	a5,a2,ffffffffc02015fa <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201604:	8082                	ret
