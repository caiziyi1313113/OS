
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	6320b0ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0200066:	52c000ef          	jal	ra,ffffffffc0200592 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	69658593          	addi	a1,a1,1686 # ffffffffc020b700 <etext+0x2>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	6ae50513          	addi	a0,a0,1710 # ffffffffc020b720 <etext+0x22>
ffffffffc020007a:	12c000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ae000ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc0200082:	62a000ef          	jal	ra,ffffffffc02006ac <dtb_init>
ffffffffc0200086:	2d3020ef          	jal	ra,ffffffffc0202b58 <pmm_init>
ffffffffc020008a:	3ef000ef          	jal	ra,ffffffffc0200c78 <pic_init>
ffffffffc020008e:	515000ef          	jal	ra,ffffffffc0200da2 <idt_init>
ffffffffc0200092:	75f030ef          	jal	ra,ffffffffc0203ff0 <vmm_init>
ffffffffc0200096:	386070ef          	jal	ra,ffffffffc020741c <sched_init>
ffffffffc020009a:	78d060ef          	jal	ra,ffffffffc0207026 <proc_init>
ffffffffc020009e:	1bf000ef          	jal	ra,ffffffffc0200a5c <ide_init>
ffffffffc02000a2:	4a8000ef          	jal	ra,ffffffffc020054a <clock_init>
ffffffffc02000a6:	204050ef          	jal	ra,ffffffffc02052aa <fs_init>
ffffffffc02000aa:	3c3000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02000ae:	144070ef          	jal	ra,ffffffffc02071f2 <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	715d                	addi	sp,sp,-80
ffffffffc02000b4:	e486                	sd	ra,72(sp)
ffffffffc02000b6:	e0a6                	sd	s1,64(sp)
ffffffffc02000b8:	fc4a                	sd	s2,56(sp)
ffffffffc02000ba:	f84e                	sd	s3,48(sp)
ffffffffc02000bc:	f452                	sd	s4,40(sp)
ffffffffc02000be:	f056                	sd	s5,32(sp)
ffffffffc02000c0:	ec5a                	sd	s6,24(sp)
ffffffffc02000c2:	e85e                	sd	s7,16(sp)
ffffffffc02000c4:	c901                	beqz	a0,ffffffffc02000d4 <readline+0x22>
ffffffffc02000c6:	85aa                	mv	a1,a0
ffffffffc02000c8:	0000b517          	auipc	a0,0xb
ffffffffc02000cc:	66050513          	addi	a0,a0,1632 # ffffffffc020b728 <etext+0x2a>
ffffffffc02000d0:	0d6000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02000d4:	4481                	li	s1,0
ffffffffc02000d6:	497d                	li	s2,31
ffffffffc02000d8:	49a1                	li	s3,8
ffffffffc02000da:	4aa9                	li	s5,10
ffffffffc02000dc:	4b35                	li	s6,13
ffffffffc02000de:	00091b97          	auipc	s7,0x91
ffffffffc02000e2:	f82b8b93          	addi	s7,s7,-126 # ffffffffc0291060 <buf>
ffffffffc02000e6:	3fe00a13          	li	s4,1022
ffffffffc02000ea:	0fa000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000ee:	00054a63          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc02000f2:	00a95a63          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc02000f6:	029a5263          	bge	s4,s1,ffffffffc020011a <readline+0x68>
ffffffffc02000fa:	0ea000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000fe:	fe055ae3          	bgez	a0,ffffffffc02000f2 <readline+0x40>
ffffffffc0200102:	4501                	li	a0,0
ffffffffc0200104:	a091                	j	ffffffffc0200148 <readline+0x96>
ffffffffc0200106:	03351463          	bne	a0,s3,ffffffffc020012e <readline+0x7c>
ffffffffc020010a:	e8a9                	bnez	s1,ffffffffc020015c <readline+0xaa>
ffffffffc020010c:	0d8000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc0200110:	fe0549e3          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc0200114:	fea959e3          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc0200118:	4481                	li	s1,0
ffffffffc020011a:	e42a                	sd	a0,8(sp)
ffffffffc020011c:	0c6000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200120:	6522                	ld	a0,8(sp)
ffffffffc0200122:	009b87b3          	add	a5,s7,s1
ffffffffc0200126:	2485                	addiw	s1,s1,1
ffffffffc0200128:	00a78023          	sb	a0,0(a5)
ffffffffc020012c:	bf7d                	j	ffffffffc02000ea <readline+0x38>
ffffffffc020012e:	01550463          	beq	a0,s5,ffffffffc0200136 <readline+0x84>
ffffffffc0200132:	fb651ce3          	bne	a0,s6,ffffffffc02000ea <readline+0x38>
ffffffffc0200136:	0ac000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020013a:	00091517          	auipc	a0,0x91
ffffffffc020013e:	f2650513          	addi	a0,a0,-218 # ffffffffc0291060 <buf>
ffffffffc0200142:	94aa                	add	s1,s1,a0
ffffffffc0200144:	00048023          	sb	zero,0(s1)
ffffffffc0200148:	60a6                	ld	ra,72(sp)
ffffffffc020014a:	6486                	ld	s1,64(sp)
ffffffffc020014c:	7962                	ld	s2,56(sp)
ffffffffc020014e:	79c2                	ld	s3,48(sp)
ffffffffc0200150:	7a22                	ld	s4,40(sp)
ffffffffc0200152:	7a82                	ld	s5,32(sp)
ffffffffc0200154:	6b62                	ld	s6,24(sp)
ffffffffc0200156:	6bc2                	ld	s7,16(sp)
ffffffffc0200158:	6161                	addi	sp,sp,80
ffffffffc020015a:	8082                	ret
ffffffffc020015c:	4521                	li	a0,8
ffffffffc020015e:	084000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200162:	34fd                	addiw	s1,s1,-1
ffffffffc0200164:	b759                	j	ffffffffc02000ea <readline+0x38>

ffffffffc0200166 <cputch>:
ffffffffc0200166:	1141                	addi	sp,sp,-16
ffffffffc0200168:	e022                	sd	s0,0(sp)
ffffffffc020016a:	e406                	sd	ra,8(sp)
ffffffffc020016c:	842e                	mv	s0,a1
ffffffffc020016e:	432000ef          	jal	ra,ffffffffc02005a0 <cons_putc>
ffffffffc0200172:	401c                	lw	a5,0(s0)
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	2785                	addiw	a5,a5,1
ffffffffc0200178:	c01c                	sw	a5,0(s0)
ffffffffc020017a:	6402                	ld	s0,0(sp)
ffffffffc020017c:	0141                	addi	sp,sp,16
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fdc50513          	addi	a0,a0,-36 # ffffffffc0200166 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	06c0b0ef          	jal	ra,ffffffffc020b206 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc02001ac:	8e2a                	mv	t3,a0
ffffffffc02001ae:	f42e                	sd	a1,40(sp)
ffffffffc02001b0:	75dd                	lui	a1,0xffff7
ffffffffc02001b2:	f832                	sd	a2,48(sp)
ffffffffc02001b4:	fc36                	sd	a3,56(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	00000517          	auipc	a0,0x0
ffffffffc02001bc:	fae50513          	addi	a0,a0,-82 # ffffffffc0200166 <cputch>
ffffffffc02001c0:	0050                	addi	a2,sp,4
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	86f2                	mv	a3,t3
ffffffffc02001c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001ca:	ec06                	sd	ra,24(sp)
ffffffffc02001cc:	e4be                	sd	a5,72(sp)
ffffffffc02001ce:	e8c2                	sd	a6,80(sp)
ffffffffc02001d0:	ecc6                	sd	a7,88(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	c202                	sw	zero,4(sp)
ffffffffc02001d6:	0300b0ef          	jal	ra,ffffffffc020b206 <vprintfmt>
ffffffffc02001da:	60e2                	ld	ra,24(sp)
ffffffffc02001dc:	4512                	lw	a0,4(sp)
ffffffffc02001de:	6125                	addi	sp,sp,96
ffffffffc02001e0:	8082                	ret

ffffffffc02001e2 <cputchar>:
ffffffffc02001e2:	ae7d                	j	ffffffffc02005a0 <cons_putc>

ffffffffc02001e4 <getchar>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	40c000ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc02001ec:	dd75                	beqz	a0,ffffffffc02001e8 <getchar+0x4>
ffffffffc02001ee:	60a2                	ld	ra,8(sp)
ffffffffc02001f0:	0141                	addi	sp,sp,16
ffffffffc02001f2:	8082                	ret

ffffffffc02001f4 <strdup>:
ffffffffc02001f4:	1101                	addi	sp,sp,-32
ffffffffc02001f6:	ec06                	sd	ra,24(sp)
ffffffffc02001f8:	e822                	sd	s0,16(sp)
ffffffffc02001fa:	e426                	sd	s1,8(sp)
ffffffffc02001fc:	e04a                	sd	s2,0(sp)
ffffffffc02001fe:	892a                	mv	s2,a0
ffffffffc0200200:	3f20b0ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc0200204:	842a                	mv	s0,a0
ffffffffc0200206:	0505                	addi	a0,a0,1
ffffffffc0200208:	60f010ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020020c:	84aa                	mv	s1,a0
ffffffffc020020e:	c901                	beqz	a0,ffffffffc020021e <strdup+0x2a>
ffffffffc0200210:	8622                	mv	a2,s0
ffffffffc0200212:	85ca                	mv	a1,s2
ffffffffc0200214:	9426                	add	s0,s0,s1
ffffffffc0200216:	4d00b0ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	60e2                	ld	ra,24(sp)
ffffffffc0200220:	6442                	ld	s0,16(sp)
ffffffffc0200222:	6902                	ld	s2,0(sp)
ffffffffc0200224:	8526                	mv	a0,s1
ffffffffc0200226:	64a2                	ld	s1,8(sp)
ffffffffc0200228:	6105                	addi	sp,sp,32
ffffffffc020022a:	8082                	ret

ffffffffc020022c <print_kerninfo>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	0000b517          	auipc	a0,0xb
ffffffffc0200232:	50250513          	addi	a0,a0,1282 # ffffffffc020b730 <etext+0x32>
ffffffffc0200236:	e406                	sd	ra,8(sp)
ffffffffc0200238:	f6fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020023c:	00000597          	auipc	a1,0x0
ffffffffc0200240:	e0e58593          	addi	a1,a1,-498 # ffffffffc020004a <kern_init>
ffffffffc0200244:	0000b517          	auipc	a0,0xb
ffffffffc0200248:	50c50513          	addi	a0,a0,1292 # ffffffffc020b750 <etext+0x52>
ffffffffc020024c:	f5bff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200250:	0000b597          	auipc	a1,0xb
ffffffffc0200254:	4ae58593          	addi	a1,a1,1198 # ffffffffc020b6fe <etext>
ffffffffc0200258:	0000b517          	auipc	a0,0xb
ffffffffc020025c:	51850513          	addi	a0,a0,1304 # ffffffffc020b770 <etext+0x72>
ffffffffc0200260:	f47ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200264:	00091597          	auipc	a1,0x91
ffffffffc0200268:	dfc58593          	addi	a1,a1,-516 # ffffffffc0291060 <buf>
ffffffffc020026c:	0000b517          	auipc	a0,0xb
ffffffffc0200270:	52450513          	addi	a0,a0,1316 # ffffffffc020b790 <etext+0x92>
ffffffffc0200274:	f33ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200278:	00096597          	auipc	a1,0x96
ffffffffc020027c:	69858593          	addi	a1,a1,1688 # ffffffffc0296910 <end>
ffffffffc0200280:	0000b517          	auipc	a0,0xb
ffffffffc0200284:	53050513          	addi	a0,a0,1328 # ffffffffc020b7b0 <etext+0xb2>
ffffffffc0200288:	f1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020028c:	00097597          	auipc	a1,0x97
ffffffffc0200290:	a8358593          	addi	a1,a1,-1405 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200294:	00000797          	auipc	a5,0x0
ffffffffc0200298:	db678793          	addi	a5,a5,-586 # ffffffffc020004a <kern_init>
ffffffffc020029c:	40f587b3          	sub	a5,a1,a5
ffffffffc02002a0:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a4:	60a2                	ld	ra,8(sp)
ffffffffc02002a6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002aa:	95be                	add	a1,a1,a5
ffffffffc02002ac:	85a9                	srai	a1,a1,0xa
ffffffffc02002ae:	0000b517          	auipc	a0,0xb
ffffffffc02002b2:	52250513          	addi	a0,a0,1314 # ffffffffc020b7d0 <etext+0xd2>
ffffffffc02002b6:	0141                	addi	sp,sp,16
ffffffffc02002b8:	b5fd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002ba <print_stackframe>:
ffffffffc02002ba:	1141                	addi	sp,sp,-16
ffffffffc02002bc:	0000b617          	auipc	a2,0xb
ffffffffc02002c0:	54460613          	addi	a2,a2,1348 # ffffffffc020b800 <etext+0x102>
ffffffffc02002c4:	04e00593          	li	a1,78
ffffffffc02002c8:	0000b517          	auipc	a0,0xb
ffffffffc02002cc:	55050513          	addi	a0,a0,1360 # ffffffffc020b818 <etext+0x11a>
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	1cc000ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02002d6 <mon_help>:
ffffffffc02002d6:	1141                	addi	sp,sp,-16
ffffffffc02002d8:	0000b617          	auipc	a2,0xb
ffffffffc02002dc:	55860613          	addi	a2,a2,1368 # ffffffffc020b830 <etext+0x132>
ffffffffc02002e0:	0000b597          	auipc	a1,0xb
ffffffffc02002e4:	57058593          	addi	a1,a1,1392 # ffffffffc020b850 <etext+0x152>
ffffffffc02002e8:	0000b517          	auipc	a0,0xb
ffffffffc02002ec:	57050513          	addi	a0,a0,1392 # ffffffffc020b858 <etext+0x15a>
ffffffffc02002f0:	e406                	sd	ra,8(sp)
ffffffffc02002f2:	eb5ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02002f6:	0000b617          	auipc	a2,0xb
ffffffffc02002fa:	57260613          	addi	a2,a2,1394 # ffffffffc020b868 <etext+0x16a>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	59258593          	addi	a1,a1,1426 # ffffffffc020b890 <etext+0x192>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	55250513          	addi	a0,a0,1362 # ffffffffc020b858 <etext+0x15a>
ffffffffc020030e:	e99ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200312:	0000b617          	auipc	a2,0xb
ffffffffc0200316:	58e60613          	addi	a2,a2,1422 # ffffffffc020b8a0 <etext+0x1a2>
ffffffffc020031a:	0000b597          	auipc	a1,0xb
ffffffffc020031e:	5a658593          	addi	a1,a1,1446 # ffffffffc020b8c0 <etext+0x1c2>
ffffffffc0200322:	0000b517          	auipc	a0,0xb
ffffffffc0200326:	53650513          	addi	a0,a0,1334 # ffffffffc020b858 <etext+0x15a>
ffffffffc020032a:	e7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_kerninfo>:
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
ffffffffc020033a:	ef3ff0ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <mon_backtrace>:
ffffffffc0200346:	1141                	addi	sp,sp,-16
ffffffffc0200348:	e406                	sd	ra,8(sp)
ffffffffc020034a:	f71ff0ef          	jal	ra,ffffffffc02002ba <print_stackframe>
ffffffffc020034e:	60a2                	ld	ra,8(sp)
ffffffffc0200350:	4501                	li	a0,0
ffffffffc0200352:	0141                	addi	sp,sp,16
ffffffffc0200354:	8082                	ret

ffffffffc0200356 <kmonitor>:
ffffffffc0200356:	7115                	addi	sp,sp,-224
ffffffffc0200358:	ed5e                	sd	s7,152(sp)
ffffffffc020035a:	8baa                	mv	s7,a0
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	57450513          	addi	a0,a0,1396 # ffffffffc020b8d0 <etext+0x1d2>
ffffffffc0200364:	ed86                	sd	ra,216(sp)
ffffffffc0200366:	e9a2                	sd	s0,208(sp)
ffffffffc0200368:	e5a6                	sd	s1,200(sp)
ffffffffc020036a:	e1ca                	sd	s2,192(sp)
ffffffffc020036c:	fd4e                	sd	s3,184(sp)
ffffffffc020036e:	f952                	sd	s4,176(sp)
ffffffffc0200370:	f556                	sd	s5,168(sp)
ffffffffc0200372:	f15a                	sd	s6,160(sp)
ffffffffc0200374:	e962                	sd	s8,144(sp)
ffffffffc0200376:	e566                	sd	s9,136(sp)
ffffffffc0200378:	e16a                	sd	s10,128(sp)
ffffffffc020037a:	e2dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020037e:	0000b517          	auipc	a0,0xb
ffffffffc0200382:	57a50513          	addi	a0,a0,1402 # ffffffffc020b8f8 <etext+0x1fa>
ffffffffc0200386:	e21ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020038a:	000b8563          	beqz	s7,ffffffffc0200394 <kmonitor+0x3e>
ffffffffc020038e:	855e                	mv	a0,s7
ffffffffc0200390:	3fb000ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0200394:	0000bc17          	auipc	s8,0xb
ffffffffc0200398:	5d4c0c13          	addi	s8,s8,1492 # ffffffffc020b968 <commands>
ffffffffc020039c:	0000b917          	auipc	s2,0xb
ffffffffc02003a0:	58490913          	addi	s2,s2,1412 # ffffffffc020b920 <etext+0x222>
ffffffffc02003a4:	0000b497          	auipc	s1,0xb
ffffffffc02003a8:	58448493          	addi	s1,s1,1412 # ffffffffc020b928 <etext+0x22a>
ffffffffc02003ac:	49bd                	li	s3,15
ffffffffc02003ae:	0000bb17          	auipc	s6,0xb
ffffffffc02003b2:	582b0b13          	addi	s6,s6,1410 # ffffffffc020b930 <etext+0x232>
ffffffffc02003b6:	0000ba17          	auipc	s4,0xb
ffffffffc02003ba:	49aa0a13          	addi	s4,s4,1178 # ffffffffc020b850 <etext+0x152>
ffffffffc02003be:	4a8d                	li	s5,3
ffffffffc02003c0:	854a                	mv	a0,s2
ffffffffc02003c2:	cf1ff0ef          	jal	ra,ffffffffc02000b2 <readline>
ffffffffc02003c6:	842a                	mv	s0,a0
ffffffffc02003c8:	dd65                	beqz	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003ca:	00054583          	lbu	a1,0(a0)
ffffffffc02003ce:	4c81                	li	s9,0
ffffffffc02003d0:	e1bd                	bnez	a1,ffffffffc0200436 <kmonitor+0xe0>
ffffffffc02003d2:	fe0c87e3          	beqz	s9,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003d6:	6582                	ld	a1,0(sp)
ffffffffc02003d8:	0000bd17          	auipc	s10,0xb
ffffffffc02003dc:	590d0d13          	addi	s10,s10,1424 # ffffffffc020b968 <commands>
ffffffffc02003e0:	8552                	mv	a0,s4
ffffffffc02003e2:	4401                	li	s0,0
ffffffffc02003e4:	0d61                	addi	s10,s10,24
ffffffffc02003e6:	2540b0ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc02003ea:	c919                	beqz	a0,ffffffffc0200400 <kmonitor+0xaa>
ffffffffc02003ec:	2405                	addiw	s0,s0,1
ffffffffc02003ee:	0b540063          	beq	s0,s5,ffffffffc020048e <kmonitor+0x138>
ffffffffc02003f2:	000d3503          	ld	a0,0(s10)
ffffffffc02003f6:	6582                	ld	a1,0(sp)
ffffffffc02003f8:	0d61                	addi	s10,s10,24
ffffffffc02003fa:	2400b0ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc02003fe:	f57d                	bnez	a0,ffffffffc02003ec <kmonitor+0x96>
ffffffffc0200400:	00141793          	slli	a5,s0,0x1
ffffffffc0200404:	97a2                	add	a5,a5,s0
ffffffffc0200406:	078e                	slli	a5,a5,0x3
ffffffffc0200408:	97e2                	add	a5,a5,s8
ffffffffc020040a:	6b9c                	ld	a5,16(a5)
ffffffffc020040c:	865e                	mv	a2,s7
ffffffffc020040e:	002c                	addi	a1,sp,8
ffffffffc0200410:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200414:	9782                	jalr	a5
ffffffffc0200416:	fa0555e3          	bgez	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc020041a:	60ee                	ld	ra,216(sp)
ffffffffc020041c:	644e                	ld	s0,208(sp)
ffffffffc020041e:	64ae                	ld	s1,200(sp)
ffffffffc0200420:	690e                	ld	s2,192(sp)
ffffffffc0200422:	79ea                	ld	s3,184(sp)
ffffffffc0200424:	7a4a                	ld	s4,176(sp)
ffffffffc0200426:	7aaa                	ld	s5,168(sp)
ffffffffc0200428:	7b0a                	ld	s6,160(sp)
ffffffffc020042a:	6bea                	ld	s7,152(sp)
ffffffffc020042c:	6c4a                	ld	s8,144(sp)
ffffffffc020042e:	6caa                	ld	s9,136(sp)
ffffffffc0200430:	6d0a                	ld	s10,128(sp)
ffffffffc0200432:	612d                	addi	sp,sp,224
ffffffffc0200434:	8082                	ret
ffffffffc0200436:	8526                	mv	a0,s1
ffffffffc0200438:	2460b0ef          	jal	ra,ffffffffc020b67e <strchr>
ffffffffc020043c:	c901                	beqz	a0,ffffffffc020044c <kmonitor+0xf6>
ffffffffc020043e:	00144583          	lbu	a1,1(s0)
ffffffffc0200442:	00040023          	sb	zero,0(s0)
ffffffffc0200446:	0405                	addi	s0,s0,1
ffffffffc0200448:	d5c9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc020044a:	b7f5                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc020044c:	00044783          	lbu	a5,0(s0)
ffffffffc0200450:	d3c9                	beqz	a5,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200452:	033c8963          	beq	s9,s3,ffffffffc0200484 <kmonitor+0x12e>
ffffffffc0200456:	003c9793          	slli	a5,s9,0x3
ffffffffc020045a:	0118                	addi	a4,sp,128
ffffffffc020045c:	97ba                	add	a5,a5,a4
ffffffffc020045e:	f887b023          	sd	s0,-128(a5)
ffffffffc0200462:	00044583          	lbu	a1,0(s0)
ffffffffc0200466:	2c85                	addiw	s9,s9,1
ffffffffc0200468:	e591                	bnez	a1,ffffffffc0200474 <kmonitor+0x11e>
ffffffffc020046a:	b7b5                	j	ffffffffc02003d6 <kmonitor+0x80>
ffffffffc020046c:	00144583          	lbu	a1,1(s0)
ffffffffc0200470:	0405                	addi	s0,s0,1
ffffffffc0200472:	d1a5                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200474:	8526                	mv	a0,s1
ffffffffc0200476:	2080b0ef          	jal	ra,ffffffffc020b67e <strchr>
ffffffffc020047a:	d96d                	beqz	a0,ffffffffc020046c <kmonitor+0x116>
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
ffffffffc0200480:	d9a9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200482:	bf55                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc0200484:	45c1                	li	a1,16
ffffffffc0200486:	855a                	mv	a0,s6
ffffffffc0200488:	d1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020048c:	b7e9                	j	ffffffffc0200456 <kmonitor+0x100>
ffffffffc020048e:	6582                	ld	a1,0(sp)
ffffffffc0200490:	0000b517          	auipc	a0,0xb
ffffffffc0200494:	4c050513          	addi	a0,a0,1216 # ffffffffc020b950 <etext+0x252>
ffffffffc0200498:	d0fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020049c:	b715                	j	ffffffffc02003c0 <kmonitor+0x6a>

ffffffffc020049e <__panic>:
ffffffffc020049e:	00096317          	auipc	t1,0x96
ffffffffc02004a2:	3ca30313          	addi	t1,t1,970 # ffffffffc0296868 <is_panic>
ffffffffc02004a6:	00033e03          	ld	t3,0(t1)
ffffffffc02004aa:	715d                	addi	sp,sp,-80
ffffffffc02004ac:	ec06                	sd	ra,24(sp)
ffffffffc02004ae:	e822                	sd	s0,16(sp)
ffffffffc02004b0:	f436                	sd	a3,40(sp)
ffffffffc02004b2:	f83a                	sd	a4,48(sp)
ffffffffc02004b4:	fc3e                	sd	a5,56(sp)
ffffffffc02004b6:	e0c2                	sd	a6,64(sp)
ffffffffc02004b8:	e4c6                	sd	a7,72(sp)
ffffffffc02004ba:	020e1a63          	bnez	t3,ffffffffc02004ee <__panic+0x50>
ffffffffc02004be:	4785                	li	a5,1
ffffffffc02004c0:	00f33023          	sd	a5,0(t1)
ffffffffc02004c4:	8432                	mv	s0,a2
ffffffffc02004c6:	103c                	addi	a5,sp,40
ffffffffc02004c8:	862e                	mv	a2,a1
ffffffffc02004ca:	85aa                	mv	a1,a0
ffffffffc02004cc:	0000b517          	auipc	a0,0xb
ffffffffc02004d0:	4e450513          	addi	a0,a0,1252 # ffffffffc020b9b0 <commands+0x48>
ffffffffc02004d4:	e43e                	sd	a5,8(sp)
ffffffffc02004d6:	cd1ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004da:	65a2                	ld	a1,8(sp)
ffffffffc02004dc:	8522                	mv	a0,s0
ffffffffc02004de:	ca3ff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc02004e2:	0000c517          	auipc	a0,0xc
ffffffffc02004e6:	78650513          	addi	a0,a0,1926 # ffffffffc020cc68 <default_pmm_manager+0x610>
ffffffffc02004ea:	cbdff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	48a1                	li	a7,8
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	778000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02004fe:	4501                	li	a0,0
ffffffffc0200500:	e57ff0ef          	jal	ra,ffffffffc0200356 <kmonitor>
ffffffffc0200504:	bfed                	j	ffffffffc02004fe <__panic+0x60>

ffffffffc0200506 <__warn>:
ffffffffc0200506:	715d                	addi	sp,sp,-80
ffffffffc0200508:	832e                	mv	t1,a1
ffffffffc020050a:	e822                	sd	s0,16(sp)
ffffffffc020050c:	85aa                	mv	a1,a0
ffffffffc020050e:	8432                	mv	s0,a2
ffffffffc0200510:	fc3e                	sd	a5,56(sp)
ffffffffc0200512:	861a                	mv	a2,t1
ffffffffc0200514:	103c                	addi	a5,sp,40
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	4ba50513          	addi	a0,a0,1210 # ffffffffc020b9d0 <commands+0x68>
ffffffffc020051e:	ec06                	sd	ra,24(sp)
ffffffffc0200520:	f436                	sd	a3,40(sp)
ffffffffc0200522:	f83a                	sd	a4,48(sp)
ffffffffc0200524:	e0c2                	sd	a6,64(sp)
ffffffffc0200526:	e4c6                	sd	a7,72(sp)
ffffffffc0200528:	e43e                	sd	a5,8(sp)
ffffffffc020052a:	c7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020052e:	65a2                	ld	a1,8(sp)
ffffffffc0200530:	8522                	mv	a0,s0
ffffffffc0200532:	c4fff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc0200536:	0000c517          	auipc	a0,0xc
ffffffffc020053a:	73250513          	addi	a0,a0,1842 # ffffffffc020cc68 <default_pmm_manager+0x610>
ffffffffc020053e:	c69ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200542:	60e2                	ld	ra,24(sp)
ffffffffc0200544:	6442                	ld	s0,16(sp)
ffffffffc0200546:	6161                	addi	sp,sp,80
ffffffffc0200548:	8082                	ret

ffffffffc020054a <clock_init>:
ffffffffc020054a:	02000793          	li	a5,32
ffffffffc020054e:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200552:	c0102573          	rdtime	a0
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	0000b517          	auipc	a0,0xb
ffffffffc020056c:	48850513          	addi	a0,a0,1160 # ffffffffc020b9f0 <commands+0x88>
ffffffffc0200570:	00096797          	auipc	a5,0x96
ffffffffc0200574:	3007b023          	sd	zero,768(a5) # ffffffffc0296870 <ticks>
ffffffffc0200578:	b13d                	j	ffffffffc02001a6 <cprintf>

ffffffffc020057a <clock_set_next_event>:
ffffffffc020057a:	c0102573          	rdtime	a0
ffffffffc020057e:	67e1                	lui	a5,0x18
ffffffffc0200580:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4881                	li	a7,0
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <cons_init>:
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4889                	li	a7,2
ffffffffc020059a:	00000073          	ecall
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <cons_putc>:
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	100027f3          	csrr	a5,sstatus
ffffffffc02005a8:	8b89                	andi	a5,a5,2
ffffffffc02005aa:	4701                	li	a4,0
ffffffffc02005ac:	ef95                	bnez	a5,ffffffffc02005e8 <cons_putc+0x48>
ffffffffc02005ae:	47a1                	li	a5,8
ffffffffc02005b0:	00f50b63          	beq	a0,a5,ffffffffc02005c6 <cons_putc+0x26>
ffffffffc02005b4:	4581                	li	a1,0
ffffffffc02005b6:	4601                	li	a2,0
ffffffffc02005b8:	4885                	li	a7,1
ffffffffc02005ba:	00000073          	ecall
ffffffffc02005be:	e315                	bnez	a4,ffffffffc02005e2 <cons_putc+0x42>
ffffffffc02005c0:	60e2                	ld	ra,24(sp)
ffffffffc02005c2:	6105                	addi	sp,sp,32
ffffffffc02005c4:	8082                	ret
ffffffffc02005c6:	4521                	li	a0,8
ffffffffc02005c8:	4581                	li	a1,0
ffffffffc02005ca:	4601                	li	a2,0
ffffffffc02005cc:	4885                	li	a7,1
ffffffffc02005ce:	00000073          	ecall
ffffffffc02005d2:	02000513          	li	a0,32
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	4521                	li	a0,8
ffffffffc02005dc:	00000073          	ecall
ffffffffc02005e0:	d365                	beqz	a4,ffffffffc02005c0 <cons_putc+0x20>
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6105                	addi	sp,sp,32
ffffffffc02005e6:	a559                	j	ffffffffc0200c6c <intr_enable>
ffffffffc02005e8:	e42a                	sd	a0,8(sp)
ffffffffc02005ea:	688000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02005ee:	6522                	ld	a0,8(sp)
ffffffffc02005f0:	4705                	li	a4,1
ffffffffc02005f2:	bf75                	j	ffffffffc02005ae <cons_putc+0xe>

ffffffffc02005f4 <cons_getc>:
ffffffffc02005f4:	1101                	addi	sp,sp,-32
ffffffffc02005f6:	ec06                	sd	ra,24(sp)
ffffffffc02005f8:	100027f3          	csrr	a5,sstatus
ffffffffc02005fc:	8b89                	andi	a5,a5,2
ffffffffc02005fe:	4801                	li	a6,0
ffffffffc0200600:	e3d5                	bnez	a5,ffffffffc02006a4 <cons_getc+0xb0>
ffffffffc0200602:	00091697          	auipc	a3,0x91
ffffffffc0200606:	e5e68693          	addi	a3,a3,-418 # ffffffffc0291460 <cons>
ffffffffc020060a:	07f00713          	li	a4,127
ffffffffc020060e:	20000313          	li	t1,512
ffffffffc0200612:	a021                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200614:	0ff57513          	zext.b	a0,a0
ffffffffc0200618:	ef91                	bnez	a5,ffffffffc0200634 <cons_getc+0x40>
ffffffffc020061a:	4501                	li	a0,0
ffffffffc020061c:	4581                	li	a1,0
ffffffffc020061e:	4601                	li	a2,0
ffffffffc0200620:	4889                	li	a7,2
ffffffffc0200622:	00000073          	ecall
ffffffffc0200626:	0005079b          	sext.w	a5,a0
ffffffffc020062a:	0207c763          	bltz	a5,ffffffffc0200658 <cons_getc+0x64>
ffffffffc020062e:	fee793e3          	bne	a5,a4,ffffffffc0200614 <cons_getc+0x20>
ffffffffc0200632:	4521                	li	a0,8
ffffffffc0200634:	2046a783          	lw	a5,516(a3)
ffffffffc0200638:	02079613          	slli	a2,a5,0x20
ffffffffc020063c:	9201                	srli	a2,a2,0x20
ffffffffc020063e:	2785                	addiw	a5,a5,1
ffffffffc0200640:	9636                	add	a2,a2,a3
ffffffffc0200642:	20f6a223          	sw	a5,516(a3)
ffffffffc0200646:	00a60023          	sb	a0,0(a2)
ffffffffc020064a:	fc6798e3          	bne	a5,t1,ffffffffc020061a <cons_getc+0x26>
ffffffffc020064e:	00091797          	auipc	a5,0x91
ffffffffc0200652:	0007ab23          	sw	zero,22(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200656:	b7d1                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200658:	2006a783          	lw	a5,512(a3)
ffffffffc020065c:	2046a703          	lw	a4,516(a3)
ffffffffc0200660:	4501                	li	a0,0
ffffffffc0200662:	00f70f63          	beq	a4,a5,ffffffffc0200680 <cons_getc+0x8c>
ffffffffc0200666:	0017861b          	addiw	a2,a5,1
ffffffffc020066a:	1782                	slli	a5,a5,0x20
ffffffffc020066c:	9381                	srli	a5,a5,0x20
ffffffffc020066e:	97b6                	add	a5,a5,a3
ffffffffc0200670:	20c6a023          	sw	a2,512(a3)
ffffffffc0200674:	20000713          	li	a4,512
ffffffffc0200678:	0007c503          	lbu	a0,0(a5)
ffffffffc020067c:	00e60763          	beq	a2,a4,ffffffffc020068a <cons_getc+0x96>
ffffffffc0200680:	00081b63          	bnez	a6,ffffffffc0200696 <cons_getc+0xa2>
ffffffffc0200684:	60e2                	ld	ra,24(sp)
ffffffffc0200686:	6105                	addi	sp,sp,32
ffffffffc0200688:	8082                	ret
ffffffffc020068a:	00091797          	auipc	a5,0x91
ffffffffc020068e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200692:	fe0809e3          	beqz	a6,ffffffffc0200684 <cons_getc+0x90>
ffffffffc0200696:	e42a                	sd	a0,8(sp)
ffffffffc0200698:	5d4000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020069c:	60e2                	ld	ra,24(sp)
ffffffffc020069e:	6522                	ld	a0,8(sp)
ffffffffc02006a0:	6105                	addi	sp,sp,32
ffffffffc02006a2:	8082                	ret
ffffffffc02006a4:	5ce000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02006a8:	4805                	li	a6,1
ffffffffc02006aa:	bfa1                	j	ffffffffc0200602 <cons_getc+0xe>

ffffffffc02006ac <dtb_init>:
ffffffffc02006ac:	7119                	addi	sp,sp,-128
ffffffffc02006ae:	0000b517          	auipc	a0,0xb
ffffffffc02006b2:	36250513          	addi	a0,a0,866 # ffffffffc020ba10 <commands+0xa8>
ffffffffc02006b6:	fc86                	sd	ra,120(sp)
ffffffffc02006b8:	f8a2                	sd	s0,112(sp)
ffffffffc02006ba:	e8d2                	sd	s4,80(sp)
ffffffffc02006bc:	f4a6                	sd	s1,104(sp)
ffffffffc02006be:	f0ca                	sd	s2,96(sp)
ffffffffc02006c0:	ecce                	sd	s3,88(sp)
ffffffffc02006c2:	e4d6                	sd	s5,72(sp)
ffffffffc02006c4:	e0da                	sd	s6,64(sp)
ffffffffc02006c6:	fc5e                	sd	s7,56(sp)
ffffffffc02006c8:	f862                	sd	s8,48(sp)
ffffffffc02006ca:	f466                	sd	s9,40(sp)
ffffffffc02006cc:	f06a                	sd	s10,32(sp)
ffffffffc02006ce:	ec6e                	sd	s11,24(sp)
ffffffffc02006d0:	ad7ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006d4:	00014597          	auipc	a1,0x14
ffffffffc02006d8:	92c5b583          	ld	a1,-1748(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006dc:	0000b517          	auipc	a0,0xb
ffffffffc02006e0:	34450513          	addi	a0,a0,836 # ffffffffc020ba20 <commands+0xb8>
ffffffffc02006e4:	ac3ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006e8:	00014417          	auipc	s0,0x14
ffffffffc02006ec:	92040413          	addi	s0,s0,-1760 # ffffffffc0214008 <boot_dtb>
ffffffffc02006f0:	600c                	ld	a1,0(s0)
ffffffffc02006f2:	0000b517          	auipc	a0,0xb
ffffffffc02006f6:	33e50513          	addi	a0,a0,830 # ffffffffc020ba30 <commands+0xc8>
ffffffffc02006fa:	aadff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006fe:	00043a03          	ld	s4,0(s0)
ffffffffc0200702:	0000b517          	auipc	a0,0xb
ffffffffc0200706:	34650513          	addi	a0,a0,838 # ffffffffc020ba48 <commands+0xe0>
ffffffffc020070a:	120a0463          	beqz	s4,ffffffffc0200832 <dtb_init+0x186>
ffffffffc020070e:	57f5                	li	a5,-3
ffffffffc0200710:	07fa                	slli	a5,a5,0x1e
ffffffffc0200712:	00fa0733          	add	a4,s4,a5
ffffffffc0200716:	431c                	lw	a5,0(a4)
ffffffffc0200718:	00ff0637          	lui	a2,0xff0
ffffffffc020071c:	6b41                	lui	s6,0x10
ffffffffc020071e:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200722:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200726:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020072a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020072e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200732:	8df1                	and	a1,a1,a2
ffffffffc0200734:	8ec9                	or	a3,a3,a0
ffffffffc0200736:	0087979b          	slliw	a5,a5,0x8
ffffffffc020073a:	1b7d                	addi	s6,s6,-1
ffffffffc020073c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200740:	8dd5                	or	a1,a1,a3
ffffffffc0200742:	8ddd                	or	a1,a1,a5
ffffffffc0200744:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200748:	2581                	sext.w	a1,a1
ffffffffc020074a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc020074e:	10f59163          	bne	a1,a5,ffffffffc0200850 <dtb_init+0x1a4>
ffffffffc0200752:	471c                	lw	a5,8(a4)
ffffffffc0200754:	4754                	lw	a3,12(a4)
ffffffffc0200756:	4c81                	li	s9,0
ffffffffc0200758:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020075c:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200760:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200764:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200768:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020076c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200770:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200774:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200778:	0105959b          	slliw	a1,a1,0x10
ffffffffc020077c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200780:	8d71                	and	a0,a0,a2
ffffffffc0200782:	01146433          	or	s0,s0,a7
ffffffffc0200786:	0086969b          	slliw	a3,a3,0x8
ffffffffc020078a:	010a6a33          	or	s4,s4,a6
ffffffffc020078e:	8e6d                	and	a2,a2,a1
ffffffffc0200790:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200794:	8c49                	or	s0,s0,a0
ffffffffc0200796:	0166f6b3          	and	a3,a3,s6
ffffffffc020079a:	00ca6a33          	or	s4,s4,a2
ffffffffc020079e:	0167f7b3          	and	a5,a5,s6
ffffffffc02007a2:	8c55                	or	s0,s0,a3
ffffffffc02007a4:	00fa6a33          	or	s4,s4,a5
ffffffffc02007a8:	1402                	slli	s0,s0,0x20
ffffffffc02007aa:	1a02                	slli	s4,s4,0x20
ffffffffc02007ac:	9001                	srli	s0,s0,0x20
ffffffffc02007ae:	020a5a13          	srli	s4,s4,0x20
ffffffffc02007b2:	943a                	add	s0,s0,a4
ffffffffc02007b4:	9a3a                	add	s4,s4,a4
ffffffffc02007b6:	00ff0c37          	lui	s8,0xff0
ffffffffc02007ba:	4b8d                	li	s7,3
ffffffffc02007bc:	0000b917          	auipc	s2,0xb
ffffffffc02007c0:	2dc90913          	addi	s2,s2,732 # ffffffffc020ba98 <commands+0x130>
ffffffffc02007c4:	49bd                	li	s3,15
ffffffffc02007c6:	4d91                	li	s11,4
ffffffffc02007c8:	4d05                	li	s10,1
ffffffffc02007ca:	0000b497          	auipc	s1,0xb
ffffffffc02007ce:	2c648493          	addi	s1,s1,710 # ffffffffc020ba90 <commands+0x128>
ffffffffc02007d2:	000a2703          	lw	a4,0(s4)
ffffffffc02007d6:	004a0a93          	addi	s5,s4,4
ffffffffc02007da:	0087569b          	srliw	a3,a4,0x8
ffffffffc02007de:	0187179b          	slliw	a5,a4,0x18
ffffffffc02007e2:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e6:	0106969b          	slliw	a3,a3,0x10
ffffffffc02007ea:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ee:	8fd1                	or	a5,a5,a2
ffffffffc02007f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02007f4:	0087171b          	slliw	a4,a4,0x8
ffffffffc02007f8:	8fd5                	or	a5,a5,a3
ffffffffc02007fa:	00eb7733          	and	a4,s6,a4
ffffffffc02007fe:	8fd9                	or	a5,a5,a4
ffffffffc0200800:	2781                	sext.w	a5,a5
ffffffffc0200802:	09778c63          	beq	a5,s7,ffffffffc020089a <dtb_init+0x1ee>
ffffffffc0200806:	00fbea63          	bltu	s7,a5,ffffffffc020081a <dtb_init+0x16e>
ffffffffc020080a:	07a78663          	beq	a5,s10,ffffffffc0200876 <dtb_init+0x1ca>
ffffffffc020080e:	4709                	li	a4,2
ffffffffc0200810:	00e79763          	bne	a5,a4,ffffffffc020081e <dtb_init+0x172>
ffffffffc0200814:	4c81                	li	s9,0
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	bf6d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020081a:	ffb78ee3          	beq	a5,s11,ffffffffc0200816 <dtb_init+0x16a>
ffffffffc020081e:	0000b517          	auipc	a0,0xb
ffffffffc0200822:	2f250513          	addi	a0,a0,754 # ffffffffc020bb10 <commands+0x1a8>
ffffffffc0200826:	981ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020082a:	0000b517          	auipc	a0,0xb
ffffffffc020082e:	31e50513          	addi	a0,a0,798 # ffffffffc020bb48 <commands+0x1e0>
ffffffffc0200832:	7446                	ld	s0,112(sp)
ffffffffc0200834:	70e6                	ld	ra,120(sp)
ffffffffc0200836:	74a6                	ld	s1,104(sp)
ffffffffc0200838:	7906                	ld	s2,96(sp)
ffffffffc020083a:	69e6                	ld	s3,88(sp)
ffffffffc020083c:	6a46                	ld	s4,80(sp)
ffffffffc020083e:	6aa6                	ld	s5,72(sp)
ffffffffc0200840:	6b06                	ld	s6,64(sp)
ffffffffc0200842:	7be2                	ld	s7,56(sp)
ffffffffc0200844:	7c42                	ld	s8,48(sp)
ffffffffc0200846:	7ca2                	ld	s9,40(sp)
ffffffffc0200848:	7d02                	ld	s10,32(sp)
ffffffffc020084a:	6de2                	ld	s11,24(sp)
ffffffffc020084c:	6109                	addi	sp,sp,128
ffffffffc020084e:	baa1                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200850:	7446                	ld	s0,112(sp)
ffffffffc0200852:	70e6                	ld	ra,120(sp)
ffffffffc0200854:	74a6                	ld	s1,104(sp)
ffffffffc0200856:	7906                	ld	s2,96(sp)
ffffffffc0200858:	69e6                	ld	s3,88(sp)
ffffffffc020085a:	6a46                	ld	s4,80(sp)
ffffffffc020085c:	6aa6                	ld	s5,72(sp)
ffffffffc020085e:	6b06                	ld	s6,64(sp)
ffffffffc0200860:	7be2                	ld	s7,56(sp)
ffffffffc0200862:	7c42                	ld	s8,48(sp)
ffffffffc0200864:	7ca2                	ld	s9,40(sp)
ffffffffc0200866:	7d02                	ld	s10,32(sp)
ffffffffc0200868:	6de2                	ld	s11,24(sp)
ffffffffc020086a:	0000b517          	auipc	a0,0xb
ffffffffc020086e:	1fe50513          	addi	a0,a0,510 # ffffffffc020ba68 <commands+0x100>
ffffffffc0200872:	6109                	addi	sp,sp,128
ffffffffc0200874:	ba0d                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200876:	8556                	mv	a0,s5
ffffffffc0200878:	57b0a0ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc020087c:	8a2a                	mv	s4,a0
ffffffffc020087e:	4619                	li	a2,6
ffffffffc0200880:	85a6                	mv	a1,s1
ffffffffc0200882:	8556                	mv	a0,s5
ffffffffc0200884:	2a01                	sext.w	s4,s4
ffffffffc0200886:	5d30a0ef          	jal	ra,ffffffffc020b658 <strncmp>
ffffffffc020088a:	e111                	bnez	a0,ffffffffc020088e <dtb_init+0x1e2>
ffffffffc020088c:	4c85                	li	s9,1
ffffffffc020088e:	0a91                	addi	s5,s5,4
ffffffffc0200890:	9ad2                	add	s5,s5,s4
ffffffffc0200892:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200896:	8a56                	mv	s4,s5
ffffffffc0200898:	bf2d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020089a:	004a2783          	lw	a5,4(s4)
ffffffffc020089e:	00ca0693          	addi	a3,s4,12
ffffffffc02008a2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02008a6:	01879a9b          	slliw	s5,a5,0x18
ffffffffc02008aa:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008ae:	0107171b          	slliw	a4,a4,0x10
ffffffffc02008b2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008b6:	00caeab3          	or	s5,s5,a2
ffffffffc02008ba:	01877733          	and	a4,a4,s8
ffffffffc02008be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02008c2:	00eaeab3          	or	s5,s5,a4
ffffffffc02008c6:	00fb77b3          	and	a5,s6,a5
ffffffffc02008ca:	00faeab3          	or	s5,s5,a5
ffffffffc02008ce:	2a81                	sext.w	s5,s5
ffffffffc02008d0:	000c9c63          	bnez	s9,ffffffffc02008e8 <dtb_init+0x23c>
ffffffffc02008d4:	1a82                	slli	s5,s5,0x20
ffffffffc02008d6:	00368793          	addi	a5,a3,3
ffffffffc02008da:	020ada93          	srli	s5,s5,0x20
ffffffffc02008de:	9abe                	add	s5,s5,a5
ffffffffc02008e0:	ffcafa93          	andi	s5,s5,-4
ffffffffc02008e4:	8a56                	mv	s4,s5
ffffffffc02008e6:	b5f5                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc02008e8:	008a2783          	lw	a5,8(s4)
ffffffffc02008ec:	85ca                	mv	a1,s2
ffffffffc02008ee:	e436                	sd	a3,8(sp)
ffffffffc02008f0:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02008f4:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008f8:	0187971b          	slliw	a4,a5,0x18
ffffffffc02008fc:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200900:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200904:	8f51                	or	a4,a4,a2
ffffffffc0200906:	01857533          	and	a0,a0,s8
ffffffffc020090a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020090e:	8d59                	or	a0,a0,a4
ffffffffc0200910:	00fb77b3          	and	a5,s6,a5
ffffffffc0200914:	8d5d                	or	a0,a0,a5
ffffffffc0200916:	1502                	slli	a0,a0,0x20
ffffffffc0200918:	9101                	srli	a0,a0,0x20
ffffffffc020091a:	9522                	add	a0,a0,s0
ffffffffc020091c:	51f0a0ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc0200920:	66a2                	ld	a3,8(sp)
ffffffffc0200922:	f94d                	bnez	a0,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200924:	fb59f8e3          	bgeu	s3,s5,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200928:	00ca3783          	ld	a5,12(s4)
ffffffffc020092c:	014a3703          	ld	a4,20(s4)
ffffffffc0200930:	0000b517          	auipc	a0,0xb
ffffffffc0200934:	17050513          	addi	a0,a0,368 # ffffffffc020baa0 <commands+0x138>
ffffffffc0200938:	4207d613          	srai	a2,a5,0x20
ffffffffc020093c:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200940:	42075593          	srai	a1,a4,0x20
ffffffffc0200944:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200948:	0186581b          	srliw	a6,a2,0x18
ffffffffc020094c:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200950:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200954:	0187d693          	srli	a3,a5,0x18
ffffffffc0200958:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020095c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200960:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200964:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200968:	010f6f33          	or	t5,t5,a6
ffffffffc020096c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200970:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200974:	01837333          	and	t1,t1,s8
ffffffffc0200978:	01c46433          	or	s0,s0,t3
ffffffffc020097c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200980:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200984:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200988:	0107581b          	srliw	a6,a4,0x10
ffffffffc020098c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200990:	8361                	srli	a4,a4,0x18
ffffffffc0200992:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200996:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020099a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020099e:	00cb7633          	and	a2,s6,a2
ffffffffc02009a2:	0088181b          	slliw	a6,a6,0x8
ffffffffc02009a6:	0085959b          	slliw	a1,a1,0x8
ffffffffc02009aa:	00646433          	or	s0,s0,t1
ffffffffc02009ae:	0187f7b3          	and	a5,a5,s8
ffffffffc02009b2:	01fe6333          	or	t1,t3,t6
ffffffffc02009b6:	01877c33          	and	s8,a4,s8
ffffffffc02009ba:	0088989b          	slliw	a7,a7,0x8
ffffffffc02009be:	011b78b3          	and	a7,s6,a7
ffffffffc02009c2:	005eeeb3          	or	t4,t4,t0
ffffffffc02009c6:	00c6e733          	or	a4,a3,a2
ffffffffc02009ca:	006c6c33          	or	s8,s8,t1
ffffffffc02009ce:	010b76b3          	and	a3,s6,a6
ffffffffc02009d2:	00bb7b33          	and	s6,s6,a1
ffffffffc02009d6:	01d7e7b3          	or	a5,a5,t4
ffffffffc02009da:	016c6b33          	or	s6,s8,s6
ffffffffc02009de:	01146433          	or	s0,s0,a7
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	1702                	slli	a4,a4,0x20
ffffffffc02009e6:	1b02                	slli	s6,s6,0x20
ffffffffc02009e8:	1782                	slli	a5,a5,0x20
ffffffffc02009ea:	9301                	srli	a4,a4,0x20
ffffffffc02009ec:	1402                	slli	s0,s0,0x20
ffffffffc02009ee:	020b5b13          	srli	s6,s6,0x20
ffffffffc02009f2:	0167eb33          	or	s6,a5,s6
ffffffffc02009f6:	8c59                	or	s0,s0,a4
ffffffffc02009f8:	faeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a2                	mv	a1,s0
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	0c250513          	addi	a0,a0,194 # ffffffffc020bac0 <commands+0x158>
ffffffffc0200a06:	fa0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	014b5613          	srli	a2,s6,0x14
ffffffffc0200a0e:	85da                	mv	a1,s6
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	0c850513          	addi	a0,a0,200 # ffffffffc020bad8 <commands+0x170>
ffffffffc0200a18:	f8eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	008b05b3          	add	a1,s6,s0
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	0d650513          	addi	a0,a0,214 # ffffffffc020baf8 <commands+0x190>
ffffffffc0200a2a:	f7cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	0000b517          	auipc	a0,0xb
ffffffffc0200a32:	11a50513          	addi	a0,a0,282 # ffffffffc020bb48 <commands+0x1e0>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200a3e:	00096797          	auipc	a5,0x96
ffffffffc0200a42:	e567b123          	sd	s6,-446(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200a46:	b3f5                	j	ffffffffc0200832 <dtb_init+0x186>

ffffffffc0200a48 <get_memory_base>:
ffffffffc0200a48:	00096517          	auipc	a0,0x96
ffffffffc0200a4c:	e3053503          	ld	a0,-464(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200a50:	8082                	ret

ffffffffc0200a52 <get_memory_size>:
ffffffffc0200a52:	00096517          	auipc	a0,0x96
ffffffffc0200a56:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200a5a:	8082                	ret

ffffffffc0200a5c <ide_init>:
ffffffffc0200a5c:	1141                	addi	sp,sp,-16
ffffffffc0200a5e:	00091597          	auipc	a1,0x91
ffffffffc0200a62:	c5a58593          	addi	a1,a1,-934 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a66:	4505                	li	a0,1
ffffffffc0200a68:	e022                	sd	s0,0(sp)
ffffffffc0200a6a:	00091797          	auipc	a5,0x91
ffffffffc0200a6e:	be07af23          	sw	zero,-1026(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a72:	00091797          	auipc	a5,0x91
ffffffffc0200a76:	c407a323          	sw	zero,-954(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a7a:	00091797          	auipc	a5,0x91
ffffffffc0200a7e:	c807a723          	sw	zero,-882(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a82:	00091797          	auipc	a5,0x91
ffffffffc0200a86:	cc07ab23          	sw	zero,-810(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	00091417          	auipc	s0,0x91
ffffffffc0200a90:	bdc40413          	addi	s0,s0,-1060 # ffffffffc0291668 <ide_devices>
ffffffffc0200a94:	23a000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200a98:	483c                	lw	a5,80(s0)
ffffffffc0200a9a:	cf99                	beqz	a5,ffffffffc0200ab8 <ide_init+0x5c>
ffffffffc0200a9c:	00091597          	auipc	a1,0x91
ffffffffc0200aa0:	c6c58593          	addi	a1,a1,-916 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa4:	4509                	li	a0,2
ffffffffc0200aa6:	228000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200aaa:	0a042783          	lw	a5,160(s0)
ffffffffc0200aae:	c785                	beqz	a5,ffffffffc0200ad6 <ide_init+0x7a>
ffffffffc0200ab0:	60a2                	ld	ra,8(sp)
ffffffffc0200ab2:	6402                	ld	s0,0(sp)
ffffffffc0200ab4:	0141                	addi	sp,sp,16
ffffffffc0200ab6:	8082                	ret
ffffffffc0200ab8:	0000b697          	auipc	a3,0xb
ffffffffc0200abc:	0a868693          	addi	a3,a3,168 # ffffffffc020bb60 <commands+0x1f8>
ffffffffc0200ac0:	0000b617          	auipc	a2,0xb
ffffffffc0200ac4:	0b860613          	addi	a2,a2,184 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200ac8:	45c5                	li	a1,17
ffffffffc0200aca:	0000b517          	auipc	a0,0xb
ffffffffc0200ace:	0c650513          	addi	a0,a0,198 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200ad2:	9cdff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200ad6:	0000b697          	auipc	a3,0xb
ffffffffc0200ada:	0d268693          	addi	a3,a3,210 # ffffffffc020bba8 <commands+0x240>
ffffffffc0200ade:	0000b617          	auipc	a2,0xb
ffffffffc0200ae2:	09a60613          	addi	a2,a2,154 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200ae6:	45d1                	li	a1,20
ffffffffc0200ae8:	0000b517          	auipc	a0,0xb
ffffffffc0200aec:	0a850513          	addi	a0,a0,168 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200af0:	9afff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200af4 <ide_device_valid>:
ffffffffc0200af4:	478d                	li	a5,3
ffffffffc0200af6:	00a7ef63          	bltu	a5,a0,ffffffffc0200b14 <ide_device_valid+0x20>
ffffffffc0200afa:	00251793          	slli	a5,a0,0x2
ffffffffc0200afe:	953e                	add	a0,a0,a5
ffffffffc0200b00:	0512                	slli	a0,a0,0x4
ffffffffc0200b02:	00091797          	auipc	a5,0x91
ffffffffc0200b06:	b6678793          	addi	a5,a5,-1178 # ffffffffc0291668 <ide_devices>
ffffffffc0200b0a:	953e                	add	a0,a0,a5
ffffffffc0200b0c:	4108                	lw	a0,0(a0)
ffffffffc0200b0e:	00a03533          	snez	a0,a0
ffffffffc0200b12:	8082                	ret
ffffffffc0200b14:	4501                	li	a0,0
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <ide_device_size>:
ffffffffc0200b18:	478d                	li	a5,3
ffffffffc0200b1a:	02a7e163          	bltu	a5,a0,ffffffffc0200b3c <ide_device_size+0x24>
ffffffffc0200b1e:	00251793          	slli	a5,a0,0x2
ffffffffc0200b22:	953e                	add	a0,a0,a5
ffffffffc0200b24:	0512                	slli	a0,a0,0x4
ffffffffc0200b26:	00091797          	auipc	a5,0x91
ffffffffc0200b2a:	b4278793          	addi	a5,a5,-1214 # ffffffffc0291668 <ide_devices>
ffffffffc0200b2e:	97aa                	add	a5,a5,a0
ffffffffc0200b30:	4398                	lw	a4,0(a5)
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	c709                	beqz	a4,ffffffffc0200b3e <ide_device_size+0x26>
ffffffffc0200b36:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b3a:	8082                	ret
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	8082                	ret

ffffffffc0200b40 <ide_read_secs>:
ffffffffc0200b40:	1141                	addi	sp,sp,-16
ffffffffc0200b42:	e406                	sd	ra,8(sp)
ffffffffc0200b44:	08000793          	li	a5,128
ffffffffc0200b48:	04d7e763          	bltu	a5,a3,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b4c:	478d                	li	a5,3
ffffffffc0200b4e:	0005081b          	sext.w	a6,a0
ffffffffc0200b52:	04a7e263          	bltu	a5,a0,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b56:	00281793          	slli	a5,a6,0x2
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0792                	slli	a5,a5,0x4
ffffffffc0200b5e:	00091817          	auipc	a6,0x91
ffffffffc0200b62:	b0a80813          	addi	a6,a6,-1270 # ffffffffc0291668 <ide_devices>
ffffffffc0200b66:	97c2                	add	a5,a5,a6
ffffffffc0200b68:	0007a883          	lw	a7,0(a5)
ffffffffc0200b6c:	02088563          	beqz	a7,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b70:	100008b7          	lui	a7,0x10000
ffffffffc0200b74:	0515f163          	bgeu	a1,a7,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
ffffffffc0200b7c:	00d58733          	add	a4,a1,a3
ffffffffc0200b80:	02e8eb63          	bltu	a7,a4,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b84:	00251713          	slli	a4,a0,0x2
ffffffffc0200b88:	60a2                	ld	ra,8(sp)
ffffffffc0200b8a:	63bc                	ld	a5,64(a5)
ffffffffc0200b8c:	953a                	add	a0,a0,a4
ffffffffc0200b8e:	0512                	slli	a0,a0,0x4
ffffffffc0200b90:	9542                	add	a0,a0,a6
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8782                	jr	a5
ffffffffc0200b96:	0000b697          	auipc	a3,0xb
ffffffffc0200b9a:	02a68693          	addi	a3,a3,42 # ffffffffc020bbc0 <commands+0x258>
ffffffffc0200b9e:	0000b617          	auipc	a2,0xb
ffffffffc0200ba2:	fda60613          	addi	a2,a2,-38 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200ba6:	02200593          	li	a1,34
ffffffffc0200baa:	0000b517          	auipc	a0,0xb
ffffffffc0200bae:	fe650513          	addi	a0,a0,-26 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200bb2:	8edff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	03268693          	addi	a3,a3,50 # ffffffffc020bbe8 <commands+0x280>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	fba60613          	addi	a2,a2,-70 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200bc6:	02300593          	li	a1,35
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	fc650513          	addi	a0,a0,-58 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200bd2:	8cdff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200bd6 <ide_write_secs>:
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
ffffffffc0200bda:	08000793          	li	a5,128
ffffffffc0200bde:	04d7e763          	bltu	a5,a3,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200be2:	478d                	li	a5,3
ffffffffc0200be4:	0005081b          	sext.w	a6,a0
ffffffffc0200be8:	04a7e263          	bltu	a5,a0,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200bec:	00281793          	slli	a5,a6,0x2
ffffffffc0200bf0:	97c2                	add	a5,a5,a6
ffffffffc0200bf2:	0792                	slli	a5,a5,0x4
ffffffffc0200bf4:	00091817          	auipc	a6,0x91
ffffffffc0200bf8:	a7480813          	addi	a6,a6,-1420 # ffffffffc0291668 <ide_devices>
ffffffffc0200bfc:	97c2                	add	a5,a5,a6
ffffffffc0200bfe:	0007a883          	lw	a7,0(a5)
ffffffffc0200c02:	02088563          	beqz	a7,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200c06:	100008b7          	lui	a7,0x10000
ffffffffc0200c0a:	0515f163          	bgeu	a1,a7,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c0e:	1582                	slli	a1,a1,0x20
ffffffffc0200c10:	9181                	srli	a1,a1,0x20
ffffffffc0200c12:	00d58733          	add	a4,a1,a3
ffffffffc0200c16:	02e8eb63          	bltu	a7,a4,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c1a:	00251713          	slli	a4,a0,0x2
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
ffffffffc0200c20:	67bc                	ld	a5,72(a5)
ffffffffc0200c22:	953a                	add	a0,a0,a4
ffffffffc0200c24:	0512                	slli	a0,a0,0x4
ffffffffc0200c26:	9542                	add	a0,a0,a6
ffffffffc0200c28:	0141                	addi	sp,sp,16
ffffffffc0200c2a:	8782                	jr	a5
ffffffffc0200c2c:	0000b697          	auipc	a3,0xb
ffffffffc0200c30:	f9468693          	addi	a3,a3,-108 # ffffffffc020bbc0 <commands+0x258>
ffffffffc0200c34:	0000b617          	auipc	a2,0xb
ffffffffc0200c38:	f4460613          	addi	a2,a2,-188 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200c3c:	02900593          	li	a1,41
ffffffffc0200c40:	0000b517          	auipc	a0,0xb
ffffffffc0200c44:	f5050513          	addi	a0,a0,-176 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200c48:	857ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200c4c:	0000b697          	auipc	a3,0xb
ffffffffc0200c50:	f9c68693          	addi	a3,a3,-100 # ffffffffc020bbe8 <commands+0x280>
ffffffffc0200c54:	0000b617          	auipc	a2,0xb
ffffffffc0200c58:	f2460613          	addi	a2,a2,-220 # ffffffffc020bb78 <commands+0x210>
ffffffffc0200c5c:	02a00593          	li	a1,42
ffffffffc0200c60:	0000b517          	auipc	a0,0xb
ffffffffc0200c64:	f3050513          	addi	a0,a0,-208 # ffffffffc020bb90 <commands+0x228>
ffffffffc0200c68:	837ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200c6c <intr_enable>:
ffffffffc0200c6c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c70:	8082                	ret

ffffffffc0200c72 <intr_disable>:
ffffffffc0200c72:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <pic_init>:
ffffffffc0200c78:	8082                	ret

ffffffffc0200c7a <ramdisk_write>:
ffffffffc0200c7a:	00856703          	lwu	a4,8(a0)
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
ffffffffc0200c82:	8f0d                	sub	a4,a4,a1
ffffffffc0200c84:	87ae                	mv	a5,a1
ffffffffc0200c86:	85b2                	mv	a1,a2
ffffffffc0200c88:	00e6f363          	bgeu	a3,a4,ffffffffc0200c8e <ramdisk_write+0x14>
ffffffffc0200c8c:	8736                	mv	a4,a3
ffffffffc0200c8e:	6908                	ld	a0,16(a0)
ffffffffc0200c90:	07a6                	slli	a5,a5,0x9
ffffffffc0200c92:	00971613          	slli	a2,a4,0x9
ffffffffc0200c96:	953e                	add	a0,a0,a5
ffffffffc0200c98:	24f0a0ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	2250a0ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	1101                	addi	sp,sp,-32
ffffffffc0200cd0:	e822                	sd	s0,16(sp)
ffffffffc0200cd2:	842e                	mv	s0,a1
ffffffffc0200cd4:	e426                	sd	s1,8(sp)
ffffffffc0200cd6:	05000613          	li	a2,80
ffffffffc0200cda:	84aa                	mv	s1,a0
ffffffffc0200cdc:	4581                	li	a1,0
ffffffffc0200cde:	8522                	mv	a0,s0
ffffffffc0200ce0:	ec06                	sd	ra,24(sp)
ffffffffc0200ce2:	e04a                	sd	s2,0(sp)
ffffffffc0200ce4:	1b10a0ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0200ce8:	4785                	li	a5,1
ffffffffc0200cea:	06f48b63          	beq	s1,a5,ffffffffc0200d60 <ramdisk_init+0x92>
ffffffffc0200cee:	4789                	li	a5,2
ffffffffc0200cf0:	00090617          	auipc	a2,0x90
ffffffffc0200cf4:	32060613          	addi	a2,a2,800 # ffffffffc0291010 <arena>
ffffffffc0200cf8:	0001b917          	auipc	s2,0x1b
ffffffffc0200cfc:	01890913          	addi	s2,s2,24 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d00:	08f49563          	bne	s1,a5,ffffffffc0200d8a <ramdisk_init+0xbc>
ffffffffc0200d04:	06c90863          	beq	s2,a2,ffffffffc0200d74 <ramdisk_init+0xa6>
ffffffffc0200d08:	412604b3          	sub	s1,a2,s2
ffffffffc0200d0c:	86a6                	mv	a3,s1
ffffffffc0200d0e:	85ca                	mv	a1,s2
ffffffffc0200d10:	167d                	addi	a2,a2,-1
ffffffffc0200d12:	0000b517          	auipc	a0,0xb
ffffffffc0200d16:	f2e50513          	addi	a0,a0,-210 # ffffffffc020bc40 <commands+0x2d8>
ffffffffc0200d1a:	c8cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0785                	addi	a5,a5,1
ffffffffc0200d24:	0094d49b          	srliw	s1,s1,0x9
ffffffffc0200d28:	e01c                	sd	a5,0(s0)
ffffffffc0200d2a:	c404                	sw	s1,8(s0)
ffffffffc0200d2c:	01243823          	sd	s2,16(s0)
ffffffffc0200d30:	02040513          	addi	a0,s0,32
ffffffffc0200d34:	0000b597          	auipc	a1,0xb
ffffffffc0200d38:	f6458593          	addi	a1,a1,-156 # ffffffffc020bc98 <commands+0x330>
ffffffffc0200d3c:	0ed0a0ef          	jal	ra,ffffffffc020b628 <strcpy>
ffffffffc0200d40:	00000797          	auipc	a5,0x0
ffffffffc0200d44:	f6478793          	addi	a5,a5,-156 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d48:	e03c                	sd	a5,64(s0)
ffffffffc0200d4a:	00000797          	auipc	a5,0x0
ffffffffc0200d4e:	f3078793          	addi	a5,a5,-208 # ffffffffc0200c7a <ramdisk_write>
ffffffffc0200d52:	60e2                	ld	ra,24(sp)
ffffffffc0200d54:	e43c                	sd	a5,72(s0)
ffffffffc0200d56:	6442                	ld	s0,16(sp)
ffffffffc0200d58:	64a2                	ld	s1,8(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
ffffffffc0200d5e:	8082                	ret
ffffffffc0200d60:	0001b617          	auipc	a2,0x1b
ffffffffc0200d64:	fb060613          	addi	a2,a2,-80 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d68:	00013917          	auipc	s2,0x13
ffffffffc0200d6c:	2a890913          	addi	s2,s2,680 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d70:	f8c91ce3          	bne	s2,a2,ffffffffc0200d08 <ramdisk_init+0x3a>
ffffffffc0200d74:	6442                	ld	s0,16(sp)
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	64a2                	ld	s1,8(sp)
ffffffffc0200d7a:	6902                	ld	s2,0(sp)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	eac50513          	addi	a0,a0,-340 # ffffffffc020bc28 <commands+0x2c0>
ffffffffc0200d84:	6105                	addi	sp,sp,32
ffffffffc0200d86:	c20ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d8a:	0000b617          	auipc	a2,0xb
ffffffffc0200d8e:	ede60613          	addi	a2,a2,-290 # ffffffffc020bc68 <commands+0x300>
ffffffffc0200d92:	03200593          	li	a1,50
ffffffffc0200d96:	0000b517          	auipc	a0,0xb
ffffffffc0200d9a:	eea50513          	addi	a0,a0,-278 # ffffffffc020bc80 <commands+0x318>
ffffffffc0200d9e:	f00ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200da2 <idt_init>:
ffffffffc0200da2:	14005073          	csrwi	sscratch,0
ffffffffc0200da6:	00000797          	auipc	a5,0x0
ffffffffc0200daa:	4c278793          	addi	a5,a5,1218 # ffffffffc0201268 <__alltraps>
ffffffffc0200dae:	10579073          	csrw	stvec,a5
ffffffffc0200db2:	000407b7          	lui	a5,0x40
ffffffffc0200db6:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dba:	8082                	ret

ffffffffc0200dbc <print_regs>:
ffffffffc0200dbc:	610c                	ld	a1,0(a0)
ffffffffc0200dbe:	1141                	addi	sp,sp,-16
ffffffffc0200dc0:	e022                	sd	s0,0(sp)
ffffffffc0200dc2:	842a                	mv	s0,a0
ffffffffc0200dc4:	0000b517          	auipc	a0,0xb
ffffffffc0200dc8:	ee450513          	addi	a0,a0,-284 # ffffffffc020bca8 <commands+0x340>
ffffffffc0200dcc:	e406                	sd	ra,8(sp)
ffffffffc0200dce:	bd8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dd2:	640c                	ld	a1,8(s0)
ffffffffc0200dd4:	0000b517          	auipc	a0,0xb
ffffffffc0200dd8:	eec50513          	addi	a0,a0,-276 # ffffffffc020bcc0 <commands+0x358>
ffffffffc0200ddc:	bcaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200de0:	680c                	ld	a1,16(s0)
ffffffffc0200de2:	0000b517          	auipc	a0,0xb
ffffffffc0200de6:	ef650513          	addi	a0,a0,-266 # ffffffffc020bcd8 <commands+0x370>
ffffffffc0200dea:	bbcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dee:	6c0c                	ld	a1,24(s0)
ffffffffc0200df0:	0000b517          	auipc	a0,0xb
ffffffffc0200df4:	f0050513          	addi	a0,a0,-256 # ffffffffc020bcf0 <commands+0x388>
ffffffffc0200df8:	baeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dfc:	700c                	ld	a1,32(s0)
ffffffffc0200dfe:	0000b517          	auipc	a0,0xb
ffffffffc0200e02:	f0a50513          	addi	a0,a0,-246 # ffffffffc020bd08 <commands+0x3a0>
ffffffffc0200e06:	ba0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e0a:	740c                	ld	a1,40(s0)
ffffffffc0200e0c:	0000b517          	auipc	a0,0xb
ffffffffc0200e10:	f1450513          	addi	a0,a0,-236 # ffffffffc020bd20 <commands+0x3b8>
ffffffffc0200e14:	b92ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e18:	780c                	ld	a1,48(s0)
ffffffffc0200e1a:	0000b517          	auipc	a0,0xb
ffffffffc0200e1e:	f1e50513          	addi	a0,a0,-226 # ffffffffc020bd38 <commands+0x3d0>
ffffffffc0200e22:	b84ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e26:	7c0c                	ld	a1,56(s0)
ffffffffc0200e28:	0000b517          	auipc	a0,0xb
ffffffffc0200e2c:	f2850513          	addi	a0,a0,-216 # ffffffffc020bd50 <commands+0x3e8>
ffffffffc0200e30:	b76ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e34:	602c                	ld	a1,64(s0)
ffffffffc0200e36:	0000b517          	auipc	a0,0xb
ffffffffc0200e3a:	f3250513          	addi	a0,a0,-206 # ffffffffc020bd68 <commands+0x400>
ffffffffc0200e3e:	b68ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e42:	642c                	ld	a1,72(s0)
ffffffffc0200e44:	0000b517          	auipc	a0,0xb
ffffffffc0200e48:	f3c50513          	addi	a0,a0,-196 # ffffffffc020bd80 <commands+0x418>
ffffffffc0200e4c:	b5aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e50:	682c                	ld	a1,80(s0)
ffffffffc0200e52:	0000b517          	auipc	a0,0xb
ffffffffc0200e56:	f4650513          	addi	a0,a0,-186 # ffffffffc020bd98 <commands+0x430>
ffffffffc0200e5a:	b4cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e5e:	6c2c                	ld	a1,88(s0)
ffffffffc0200e60:	0000b517          	auipc	a0,0xb
ffffffffc0200e64:	f5050513          	addi	a0,a0,-176 # ffffffffc020bdb0 <commands+0x448>
ffffffffc0200e68:	b3eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e6c:	702c                	ld	a1,96(s0)
ffffffffc0200e6e:	0000b517          	auipc	a0,0xb
ffffffffc0200e72:	f5a50513          	addi	a0,a0,-166 # ffffffffc020bdc8 <commands+0x460>
ffffffffc0200e76:	b30ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e7a:	742c                	ld	a1,104(s0)
ffffffffc0200e7c:	0000b517          	auipc	a0,0xb
ffffffffc0200e80:	f6450513          	addi	a0,a0,-156 # ffffffffc020bde0 <commands+0x478>
ffffffffc0200e84:	b22ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e88:	782c                	ld	a1,112(s0)
ffffffffc0200e8a:	0000b517          	auipc	a0,0xb
ffffffffc0200e8e:	f6e50513          	addi	a0,a0,-146 # ffffffffc020bdf8 <commands+0x490>
ffffffffc0200e92:	b14ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e96:	7c2c                	ld	a1,120(s0)
ffffffffc0200e98:	0000b517          	auipc	a0,0xb
ffffffffc0200e9c:	f7850513          	addi	a0,a0,-136 # ffffffffc020be10 <commands+0x4a8>
ffffffffc0200ea0:	b06ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ea4:	604c                	ld	a1,128(s0)
ffffffffc0200ea6:	0000b517          	auipc	a0,0xb
ffffffffc0200eaa:	f8250513          	addi	a0,a0,-126 # ffffffffc020be28 <commands+0x4c0>
ffffffffc0200eae:	af8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eb2:	644c                	ld	a1,136(s0)
ffffffffc0200eb4:	0000b517          	auipc	a0,0xb
ffffffffc0200eb8:	f8c50513          	addi	a0,a0,-116 # ffffffffc020be40 <commands+0x4d8>
ffffffffc0200ebc:	aeaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ec0:	684c                	ld	a1,144(s0)
ffffffffc0200ec2:	0000b517          	auipc	a0,0xb
ffffffffc0200ec6:	f9650513          	addi	a0,a0,-106 # ffffffffc020be58 <commands+0x4f0>
ffffffffc0200eca:	adcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ece:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed0:	0000b517          	auipc	a0,0xb
ffffffffc0200ed4:	fa050513          	addi	a0,a0,-96 # ffffffffc020be70 <commands+0x508>
ffffffffc0200ed8:	aceff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200edc:	704c                	ld	a1,160(s0)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	faa50513          	addi	a0,a0,-86 # ffffffffc020be88 <commands+0x520>
ffffffffc0200ee6:	ac0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eea:	744c                	ld	a1,168(s0)
ffffffffc0200eec:	0000b517          	auipc	a0,0xb
ffffffffc0200ef0:	fb450513          	addi	a0,a0,-76 # ffffffffc020bea0 <commands+0x538>
ffffffffc0200ef4:	ab2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ef8:	784c                	ld	a1,176(s0)
ffffffffc0200efa:	0000b517          	auipc	a0,0xb
ffffffffc0200efe:	fbe50513          	addi	a0,a0,-66 # ffffffffc020beb8 <commands+0x550>
ffffffffc0200f02:	aa4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f06:	7c4c                	ld	a1,184(s0)
ffffffffc0200f08:	0000b517          	auipc	a0,0xb
ffffffffc0200f0c:	fc850513          	addi	a0,a0,-56 # ffffffffc020bed0 <commands+0x568>
ffffffffc0200f10:	a96ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f14:	606c                	ld	a1,192(s0)
ffffffffc0200f16:	0000b517          	auipc	a0,0xb
ffffffffc0200f1a:	fd250513          	addi	a0,a0,-46 # ffffffffc020bee8 <commands+0x580>
ffffffffc0200f1e:	a88ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f22:	646c                	ld	a1,200(s0)
ffffffffc0200f24:	0000b517          	auipc	a0,0xb
ffffffffc0200f28:	fdc50513          	addi	a0,a0,-36 # ffffffffc020bf00 <commands+0x598>
ffffffffc0200f2c:	a7aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f30:	686c                	ld	a1,208(s0)
ffffffffc0200f32:	0000b517          	auipc	a0,0xb
ffffffffc0200f36:	fe650513          	addi	a0,a0,-26 # ffffffffc020bf18 <commands+0x5b0>
ffffffffc0200f3a:	a6cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f3e:	6c6c                	ld	a1,216(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	ff050513          	addi	a0,a0,-16 # ffffffffc020bf30 <commands+0x5c8>
ffffffffc0200f48:	a5eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	706c                	ld	a1,224(s0)
ffffffffc0200f4e:	0000b517          	auipc	a0,0xb
ffffffffc0200f52:	ffa50513          	addi	a0,a0,-6 # ffffffffc020bf48 <commands+0x5e0>
ffffffffc0200f56:	a50ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f5a:	746c                	ld	a1,232(s0)
ffffffffc0200f5c:	0000b517          	auipc	a0,0xb
ffffffffc0200f60:	00450513          	addi	a0,a0,4 # ffffffffc020bf60 <commands+0x5f8>
ffffffffc0200f64:	a42ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f68:	786c                	ld	a1,240(s0)
ffffffffc0200f6a:	0000b517          	auipc	a0,0xb
ffffffffc0200f6e:	00e50513          	addi	a0,a0,14 # ffffffffc020bf78 <commands+0x610>
ffffffffc0200f72:	a34ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f76:	7c6c                	ld	a1,248(s0)
ffffffffc0200f78:	6402                	ld	s0,0(sp)
ffffffffc0200f7a:	60a2                	ld	ra,8(sp)
ffffffffc0200f7c:	0000b517          	auipc	a0,0xb
ffffffffc0200f80:	01450513          	addi	a0,a0,20 # ffffffffc020bf90 <commands+0x628>
ffffffffc0200f84:	0141                	addi	sp,sp,16
ffffffffc0200f86:	a20ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f8a <print_trapframe>:
ffffffffc0200f8a:	1141                	addi	sp,sp,-16
ffffffffc0200f8c:	e022                	sd	s0,0(sp)
ffffffffc0200f8e:	85aa                	mv	a1,a0
ffffffffc0200f90:	842a                	mv	s0,a0
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	01650513          	addi	a0,a0,22 # ffffffffc020bfa8 <commands+0x640>
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
ffffffffc0200f9c:	a0aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fa0:	8522                	mv	a0,s0
ffffffffc0200fa2:	e1bff0ef          	jal	ra,ffffffffc0200dbc <print_regs>
ffffffffc0200fa6:	10043583          	ld	a1,256(s0)
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	01650513          	addi	a0,a0,22 # ffffffffc020bfc0 <commands+0x658>
ffffffffc0200fb2:	9f4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	10843583          	ld	a1,264(s0)
ffffffffc0200fba:	0000b517          	auipc	a0,0xb
ffffffffc0200fbe:	01e50513          	addi	a0,a0,30 # ffffffffc020bfd8 <commands+0x670>
ffffffffc0200fc2:	9e4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fc6:	11043583          	ld	a1,272(s0)
ffffffffc0200fca:	0000b517          	auipc	a0,0xb
ffffffffc0200fce:	02650513          	addi	a0,a0,38 # ffffffffc020bff0 <commands+0x688>
ffffffffc0200fd2:	9d4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fd6:	11843583          	ld	a1,280(s0)
ffffffffc0200fda:	6402                	ld	s0,0(sp)
ffffffffc0200fdc:	60a2                	ld	ra,8(sp)
ffffffffc0200fde:	0000b517          	auipc	a0,0xb
ffffffffc0200fe2:	02250513          	addi	a0,a0,34 # ffffffffc020c000 <commands+0x698>
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	9beff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fec <interrupt_handler>:
ffffffffc0200fec:	11853783          	ld	a5,280(a0)
ffffffffc0200ff0:	472d                	li	a4,11
ffffffffc0200ff2:	0786                	slli	a5,a5,0x1
ffffffffc0200ff4:	8385                	srli	a5,a5,0x1
ffffffffc0200ff6:	06f76e63          	bltu	a4,a5,ffffffffc0201072 <interrupt_handler+0x86>
ffffffffc0200ffa:	0000b717          	auipc	a4,0xb
ffffffffc0200ffe:	0be70713          	addi	a4,a4,190 # ffffffffc020c0b8 <commands+0x750>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	8782                	jr	a5
ffffffffc020100c:	0000b517          	auipc	a0,0xb
ffffffffc0201010:	06c50513          	addi	a0,a0,108 # ffffffffc020c078 <commands+0x710>
ffffffffc0201014:	992ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201018:	0000b517          	auipc	a0,0xb
ffffffffc020101c:	04050513          	addi	a0,a0,64 # ffffffffc020c058 <commands+0x6f0>
ffffffffc0201020:	986ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201024:	0000b517          	auipc	a0,0xb
ffffffffc0201028:	ff450513          	addi	a0,a0,-12 # ffffffffc020c018 <commands+0x6b0>
ffffffffc020102c:	97aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	00850513          	addi	a0,a0,8 # ffffffffc020c038 <commands+0x6d0>
ffffffffc0201038:	96eff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103c:	1141                	addi	sp,sp,-16
ffffffffc020103e:	e406                	sd	ra,8(sp)
ffffffffc0201040:	d3aff0ef          	jal	ra,ffffffffc020057a <clock_set_next_event>
ffffffffc0201044:	00096717          	auipc	a4,0x96
ffffffffc0201048:	82c70713          	addi	a4,a4,-2004 # ffffffffc0296870 <ticks>
ffffffffc020104c:	631c                	ld	a5,0(a4)
ffffffffc020104e:	0785                	addi	a5,a5,1
ffffffffc0201050:	e31c                	sd	a5,0(a4)
ffffffffc0201052:	6da060ef          	jal	ra,ffffffffc020772c <run_timer_list>
ffffffffc0201056:	d9eff0ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc020105a:	60a2                	ld	ra,8(sp)
ffffffffc020105c:	0ff57513          	zext.b	a0,a0
ffffffffc0201060:	0141                	addi	sp,sp,16
ffffffffc0201062:	59b0706f          	j	ffffffffc0208dfc <dev_stdin_write>
ffffffffc0201066:	0000b517          	auipc	a0,0xb
ffffffffc020106a:	03250513          	addi	a0,a0,50 # ffffffffc020c098 <commands+0x730>
ffffffffc020106e:	938ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201072:	bf21                	j	ffffffffc0200f8a <print_trapframe>

ffffffffc0201074 <exception_handler>:
ffffffffc0201074:	10053783          	ld	a5,256(a0)
ffffffffc0201078:	11853583          	ld	a1,280(a0)
ffffffffc020107c:	1101                	addi	sp,sp,-32
ffffffffc020107e:	e822                	sd	s0,16(sp)
ffffffffc0201080:	e426                	sd	s1,8(sp)
ffffffffc0201082:	ec06                	sd	ra,24(sp)
ffffffffc0201084:	473d                	li	a4,15
ffffffffc0201086:	842a                	mv	s0,a0
ffffffffc0201088:	1007f493          	andi	s1,a5,256
ffffffffc020108c:	10b76963          	bltu	a4,a1,ffffffffc020119e <exception_handler+0x12a>
ffffffffc0201090:	0000b697          	auipc	a3,0xb
ffffffffc0201094:	1dc68693          	addi	a3,a3,476 # ffffffffc020c26c <commands+0x904>
ffffffffc0201098:	00259713          	slli	a4,a1,0x2
ffffffffc020109c:	9736                	add	a4,a4,a3
ffffffffc020109e:	431c                	lw	a5,0(a4)
ffffffffc02010a0:	97b6                	add	a5,a5,a3
ffffffffc02010a2:	8782                	jr	a5
ffffffffc02010a4:	10049163          	bnez	s1,ffffffffc02011a6 <exception_handler+0x132>
ffffffffc02010a8:	00096797          	auipc	a5,0x96
ffffffffc02010ac:	8187b783          	ld	a5,-2024(a5) # ffffffffc02968c0 <current>
ffffffffc02010b0:	0e078b63          	beqz	a5,ffffffffc02011a6 <exception_handler+0x132>
ffffffffc02010b4:	7788                	ld	a0,40(a5)
ffffffffc02010b6:	0e050863          	beqz	a0,ffffffffc02011a6 <exception_handler+0x132>
ffffffffc02010ba:	11043603          	ld	a2,272(s0)
ffffffffc02010be:	15c5                	addi	a1,a1,-15
ffffffffc02010c0:	0015b593          	seqz	a1,a1
ffffffffc02010c4:	3d6030ef          	jal	ra,ffffffffc020449a <do_pgfault>
ffffffffc02010c8:	85aa                	mv	a1,a0
ffffffffc02010ca:	10050563          	beqz	a0,ffffffffc02011d4 <exception_handler+0x160>
ffffffffc02010ce:	0000b517          	auipc	a0,0xb
ffffffffc02010d2:	14a50513          	addi	a0,a0,330 # ffffffffc020c218 <commands+0x8b0>
ffffffffc02010d6:	8d0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010da:	a80d                	j	ffffffffc020110c <exception_handler+0x98>
ffffffffc02010dc:	0000b517          	auipc	a0,0xb
ffffffffc02010e0:	0dc50513          	addi	a0,a0,220 # ffffffffc020c1b8 <commands+0x850>
ffffffffc02010e4:	8c2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010e8:	10843783          	ld	a5,264(s0)
ffffffffc02010ec:	60e2                	ld	ra,24(sp)
ffffffffc02010ee:	64a2                	ld	s1,8(sp)
ffffffffc02010f0:	0791                	addi	a5,a5,4
ffffffffc02010f2:	10f43423          	sd	a5,264(s0)
ffffffffc02010f6:	6442                	ld	s0,16(sp)
ffffffffc02010f8:	6105                	addi	sp,sp,32
ffffffffc02010fa:	0490606f          	j	ffffffffc0207942 <syscall>
ffffffffc02010fe:	0000b517          	auipc	a0,0xb
ffffffffc0201102:	fea50513          	addi	a0,a0,-22 # ffffffffc020c0e8 <commands+0x780>
ffffffffc0201106:	8a0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020110a:	e8cd                	bnez	s1,ffffffffc02011bc <exception_handler+0x148>
ffffffffc020110c:	8522                	mv	a0,s0
ffffffffc020110e:	e7dff0ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0201112:	6442                	ld	s0,16(sp)
ffffffffc0201114:	60e2                	ld	ra,24(sp)
ffffffffc0201116:	64a2                	ld	s1,8(sp)
ffffffffc0201118:	555d                	li	a0,-9
ffffffffc020111a:	6105                	addi	sp,sp,32
ffffffffc020111c:	7a30406f          	j	ffffffffc02060be <do_exit>
ffffffffc0201120:	0000b517          	auipc	a0,0xb
ffffffffc0201124:	fe850513          	addi	a0,a0,-24 # ffffffffc020c108 <commands+0x7a0>
ffffffffc0201128:	87eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020112c:	bff9                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc020112e:	0000b517          	auipc	a0,0xb
ffffffffc0201132:	ffa50513          	addi	a0,a0,-6 # ffffffffc020c128 <commands+0x7c0>
ffffffffc0201136:	870ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020113a:	bfc1                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc020113c:	0000b517          	auipc	a0,0xb
ffffffffc0201140:	00450513          	addi	a0,a0,4 # ffffffffc020c140 <commands+0x7d8>
ffffffffc0201144:	862ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201148:	b7c9                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc020114a:	0000b517          	auipc	a0,0xb
ffffffffc020114e:	00650513          	addi	a0,a0,6 # ffffffffc020c150 <commands+0x7e8>
ffffffffc0201152:	854ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201156:	bf55                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc0201158:	0000b517          	auipc	a0,0xb
ffffffffc020115c:	01850513          	addi	a0,a0,24 # ffffffffc020c170 <commands+0x808>
ffffffffc0201160:	846ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201164:	b75d                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc0201166:	0000b517          	auipc	a0,0xb
ffffffffc020116a:	02250513          	addi	a0,a0,34 # ffffffffc020c188 <commands+0x820>
ffffffffc020116e:	838ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201172:	bf61                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc0201174:	0000b517          	auipc	a0,0xb
ffffffffc0201178:	06450513          	addi	a0,a0,100 # ffffffffc020c1d8 <commands+0x870>
ffffffffc020117c:	82aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201180:	b769                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc0201182:	0000b517          	auipc	a0,0xb
ffffffffc0201186:	01e50513          	addi	a0,a0,30 # ffffffffc020c1a0 <commands+0x838>
ffffffffc020118a:	81cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020118e:	bfb5                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc0201190:	0000b517          	auipc	a0,0xb
ffffffffc0201194:	06850513          	addi	a0,a0,104 # ffffffffc020c1f8 <commands+0x890>
ffffffffc0201198:	80eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020119c:	b7bd                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc020119e:	8522                	mv	a0,s0
ffffffffc02011a0:	debff0ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc02011a4:	b79d                	j	ffffffffc020110a <exception_handler+0x96>
ffffffffc02011a6:	6442                	ld	s0,16(sp)
ffffffffc02011a8:	60e2                	ld	ra,24(sp)
ffffffffc02011aa:	64a2                	ld	s1,8(sp)
ffffffffc02011ac:	4581                	li	a1,0
ffffffffc02011ae:	0000b517          	auipc	a0,0xb
ffffffffc02011b2:	06a50513          	addi	a0,a0,106 # ffffffffc020c218 <commands+0x8b0>
ffffffffc02011b6:	6105                	addi	sp,sp,32
ffffffffc02011b8:	feffe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02011bc:	0000b617          	auipc	a2,0xb
ffffffffc02011c0:	07c60613          	addi	a2,a2,124 # ffffffffc020c238 <commands+0x8d0>
ffffffffc02011c4:	0ec00593          	li	a1,236
ffffffffc02011c8:	0000b517          	auipc	a0,0xb
ffffffffc02011cc:	09050513          	addi	a0,a0,144 # ffffffffc020c258 <commands+0x8f0>
ffffffffc02011d0:	aceff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02011d4:	60e2                	ld	ra,24(sp)
ffffffffc02011d6:	6442                	ld	s0,16(sp)
ffffffffc02011d8:	64a2                	ld	s1,8(sp)
ffffffffc02011da:	6105                	addi	sp,sp,32
ffffffffc02011dc:	8082                	ret

ffffffffc02011de <trap>:
ffffffffc02011de:	1101                	addi	sp,sp,-32
ffffffffc02011e0:	e822                	sd	s0,16(sp)
ffffffffc02011e2:	00095417          	auipc	s0,0x95
ffffffffc02011e6:	6de40413          	addi	s0,s0,1758 # ffffffffc02968c0 <current>
ffffffffc02011ea:	6018                	ld	a4,0(s0)
ffffffffc02011ec:	ec06                	sd	ra,24(sp)
ffffffffc02011ee:	e426                	sd	s1,8(sp)
ffffffffc02011f0:	e04a                	sd	s2,0(sp)
ffffffffc02011f2:	11853683          	ld	a3,280(a0)
ffffffffc02011f6:	cf1d                	beqz	a4,ffffffffc0201234 <trap+0x56>
ffffffffc02011f8:	10053483          	ld	s1,256(a0)
ffffffffc02011fc:	0a073903          	ld	s2,160(a4)
ffffffffc0201200:	f348                	sd	a0,160(a4)
ffffffffc0201202:	1004f493          	andi	s1,s1,256
ffffffffc0201206:	0206c463          	bltz	a3,ffffffffc020122e <trap+0x50>
ffffffffc020120a:	e6bff0ef          	jal	ra,ffffffffc0201074 <exception_handler>
ffffffffc020120e:	601c                	ld	a5,0(s0)
ffffffffc0201210:	0b27b023          	sd	s2,160(a5)
ffffffffc0201214:	e499                	bnez	s1,ffffffffc0201222 <trap+0x44>
ffffffffc0201216:	0b07a703          	lw	a4,176(a5)
ffffffffc020121a:	8b05                	andi	a4,a4,1
ffffffffc020121c:	e329                	bnez	a4,ffffffffc020125e <trap+0x80>
ffffffffc020121e:	6f9c                	ld	a5,24(a5)
ffffffffc0201220:	eb85                	bnez	a5,ffffffffc0201250 <trap+0x72>
ffffffffc0201222:	60e2                	ld	ra,24(sp)
ffffffffc0201224:	6442                	ld	s0,16(sp)
ffffffffc0201226:	64a2                	ld	s1,8(sp)
ffffffffc0201228:	6902                	ld	s2,0(sp)
ffffffffc020122a:	6105                	addi	sp,sp,32
ffffffffc020122c:	8082                	ret
ffffffffc020122e:	dbfff0ef          	jal	ra,ffffffffc0200fec <interrupt_handler>
ffffffffc0201232:	bff1                	j	ffffffffc020120e <trap+0x30>
ffffffffc0201234:	0006c863          	bltz	a3,ffffffffc0201244 <trap+0x66>
ffffffffc0201238:	6442                	ld	s0,16(sp)
ffffffffc020123a:	60e2                	ld	ra,24(sp)
ffffffffc020123c:	64a2                	ld	s1,8(sp)
ffffffffc020123e:	6902                	ld	s2,0(sp)
ffffffffc0201240:	6105                	addi	sp,sp,32
ffffffffc0201242:	bd0d                	j	ffffffffc0201074 <exception_handler>
ffffffffc0201244:	6442                	ld	s0,16(sp)
ffffffffc0201246:	60e2                	ld	ra,24(sp)
ffffffffc0201248:	64a2                	ld	s1,8(sp)
ffffffffc020124a:	6902                	ld	s2,0(sp)
ffffffffc020124c:	6105                	addi	sp,sp,32
ffffffffc020124e:	bb79                	j	ffffffffc0200fec <interrupt_handler>
ffffffffc0201250:	6442                	ld	s0,16(sp)
ffffffffc0201252:	60e2                	ld	ra,24(sp)
ffffffffc0201254:	64a2                	ld	s1,8(sp)
ffffffffc0201256:	6902                	ld	s2,0(sp)
ffffffffc0201258:	6105                	addi	sp,sp,32
ffffffffc020125a:	2c60606f          	j	ffffffffc0207520 <schedule>
ffffffffc020125e:	555d                	li	a0,-9
ffffffffc0201260:	65f040ef          	jal	ra,ffffffffc02060be <do_exit>
ffffffffc0201264:	601c                	ld	a5,0(s0)
ffffffffc0201266:	bf65                	j	ffffffffc020121e <trap+0x40>

ffffffffc0201268 <__alltraps>:
ffffffffc0201268:	14011173          	csrrw	sp,sscratch,sp
ffffffffc020126c:	00011463          	bnez	sp,ffffffffc0201274 <__alltraps+0xc>
ffffffffc0201270:	14002173          	csrr	sp,sscratch
ffffffffc0201274:	712d                	addi	sp,sp,-288
ffffffffc0201276:	e002                	sd	zero,0(sp)
ffffffffc0201278:	e406                	sd	ra,8(sp)
ffffffffc020127a:	ec0e                	sd	gp,24(sp)
ffffffffc020127c:	f012                	sd	tp,32(sp)
ffffffffc020127e:	f416                	sd	t0,40(sp)
ffffffffc0201280:	f81a                	sd	t1,48(sp)
ffffffffc0201282:	fc1e                	sd	t2,56(sp)
ffffffffc0201284:	e0a2                	sd	s0,64(sp)
ffffffffc0201286:	e4a6                	sd	s1,72(sp)
ffffffffc0201288:	e8aa                	sd	a0,80(sp)
ffffffffc020128a:	ecae                	sd	a1,88(sp)
ffffffffc020128c:	f0b2                	sd	a2,96(sp)
ffffffffc020128e:	f4b6                	sd	a3,104(sp)
ffffffffc0201290:	f8ba                	sd	a4,112(sp)
ffffffffc0201292:	fcbe                	sd	a5,120(sp)
ffffffffc0201294:	e142                	sd	a6,128(sp)
ffffffffc0201296:	e546                	sd	a7,136(sp)
ffffffffc0201298:	e94a                	sd	s2,144(sp)
ffffffffc020129a:	ed4e                	sd	s3,152(sp)
ffffffffc020129c:	f152                	sd	s4,160(sp)
ffffffffc020129e:	f556                	sd	s5,168(sp)
ffffffffc02012a0:	f95a                	sd	s6,176(sp)
ffffffffc02012a2:	fd5e                	sd	s7,184(sp)
ffffffffc02012a4:	e1e2                	sd	s8,192(sp)
ffffffffc02012a6:	e5e6                	sd	s9,200(sp)
ffffffffc02012a8:	e9ea                	sd	s10,208(sp)
ffffffffc02012aa:	edee                	sd	s11,216(sp)
ffffffffc02012ac:	f1f2                	sd	t3,224(sp)
ffffffffc02012ae:	f5f6                	sd	t4,232(sp)
ffffffffc02012b0:	f9fa                	sd	t5,240(sp)
ffffffffc02012b2:	fdfe                	sd	t6,248(sp)
ffffffffc02012b4:	14001473          	csrrw	s0,sscratch,zero
ffffffffc02012b8:	100024f3          	csrr	s1,sstatus
ffffffffc02012bc:	14102973          	csrr	s2,sepc
ffffffffc02012c0:	143029f3          	csrr	s3,stval
ffffffffc02012c4:	14202a73          	csrr	s4,scause
ffffffffc02012c8:	e822                	sd	s0,16(sp)
ffffffffc02012ca:	e226                	sd	s1,256(sp)
ffffffffc02012cc:	e64a                	sd	s2,264(sp)
ffffffffc02012ce:	ea4e                	sd	s3,272(sp)
ffffffffc02012d0:	ee52                	sd	s4,280(sp)
ffffffffc02012d2:	850a                	mv	a0,sp
ffffffffc02012d4:	f0bff0ef          	jal	ra,ffffffffc02011de <trap>

ffffffffc02012d8 <__trapret>:
ffffffffc02012d8:	6492                	ld	s1,256(sp)
ffffffffc02012da:	6932                	ld	s2,264(sp)
ffffffffc02012dc:	1004f413          	andi	s0,s1,256
ffffffffc02012e0:	e401                	bnez	s0,ffffffffc02012e8 <__trapret+0x10>
ffffffffc02012e2:	1200                	addi	s0,sp,288
ffffffffc02012e4:	14041073          	csrw	sscratch,s0
ffffffffc02012e8:	10049073          	csrw	sstatus,s1
ffffffffc02012ec:	14191073          	csrw	sepc,s2
ffffffffc02012f0:	60a2                	ld	ra,8(sp)
ffffffffc02012f2:	61e2                	ld	gp,24(sp)
ffffffffc02012f4:	7202                	ld	tp,32(sp)
ffffffffc02012f6:	72a2                	ld	t0,40(sp)
ffffffffc02012f8:	7342                	ld	t1,48(sp)
ffffffffc02012fa:	73e2                	ld	t2,56(sp)
ffffffffc02012fc:	6406                	ld	s0,64(sp)
ffffffffc02012fe:	64a6                	ld	s1,72(sp)
ffffffffc0201300:	6546                	ld	a0,80(sp)
ffffffffc0201302:	65e6                	ld	a1,88(sp)
ffffffffc0201304:	7606                	ld	a2,96(sp)
ffffffffc0201306:	76a6                	ld	a3,104(sp)
ffffffffc0201308:	7746                	ld	a4,112(sp)
ffffffffc020130a:	77e6                	ld	a5,120(sp)
ffffffffc020130c:	680a                	ld	a6,128(sp)
ffffffffc020130e:	68aa                	ld	a7,136(sp)
ffffffffc0201310:	694a                	ld	s2,144(sp)
ffffffffc0201312:	69ea                	ld	s3,152(sp)
ffffffffc0201314:	7a0a                	ld	s4,160(sp)
ffffffffc0201316:	7aaa                	ld	s5,168(sp)
ffffffffc0201318:	7b4a                	ld	s6,176(sp)
ffffffffc020131a:	7bea                	ld	s7,184(sp)
ffffffffc020131c:	6c0e                	ld	s8,192(sp)
ffffffffc020131e:	6cae                	ld	s9,200(sp)
ffffffffc0201320:	6d4e                	ld	s10,208(sp)
ffffffffc0201322:	6dee                	ld	s11,216(sp)
ffffffffc0201324:	7e0e                	ld	t3,224(sp)
ffffffffc0201326:	7eae                	ld	t4,232(sp)
ffffffffc0201328:	7f4e                	ld	t5,240(sp)
ffffffffc020132a:	7fee                	ld	t6,248(sp)
ffffffffc020132c:	6142                	ld	sp,16(sp)
ffffffffc020132e:	10200073          	sret

ffffffffc0201332 <forkrets>:
ffffffffc0201332:	812a                	mv	sp,a0
ffffffffc0201334:	b755                	j	ffffffffc02012d8 <__trapret>

ffffffffc0201336 <default_init>:
ffffffffc0201336:	00090797          	auipc	a5,0x90
ffffffffc020133a:	47278793          	addi	a5,a5,1138 # ffffffffc02917a8 <free_area>
ffffffffc020133e:	e79c                	sd	a5,8(a5)
ffffffffc0201340:	e39c                	sd	a5,0(a5)
ffffffffc0201342:	0007a823          	sw	zero,16(a5)
ffffffffc0201346:	8082                	ret

ffffffffc0201348 <default_nr_free_pages>:
ffffffffc0201348:	00090517          	auipc	a0,0x90
ffffffffc020134c:	47056503          	lwu	a0,1136(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201350:	8082                	ret

ffffffffc0201352 <default_check>:
ffffffffc0201352:	715d                	addi	sp,sp,-80
ffffffffc0201354:	e0a2                	sd	s0,64(sp)
ffffffffc0201356:	00090417          	auipc	s0,0x90
ffffffffc020135a:	45240413          	addi	s0,s0,1106 # ffffffffc02917a8 <free_area>
ffffffffc020135e:	641c                	ld	a5,8(s0)
ffffffffc0201360:	e486                	sd	ra,72(sp)
ffffffffc0201362:	fc26                	sd	s1,56(sp)
ffffffffc0201364:	f84a                	sd	s2,48(sp)
ffffffffc0201366:	f44e                	sd	s3,40(sp)
ffffffffc0201368:	f052                	sd	s4,32(sp)
ffffffffc020136a:	ec56                	sd	s5,24(sp)
ffffffffc020136c:	e85a                	sd	s6,16(sp)
ffffffffc020136e:	e45e                	sd	s7,8(sp)
ffffffffc0201370:	e062                	sd	s8,0(sp)
ffffffffc0201372:	2a878d63          	beq	a5,s0,ffffffffc020162c <default_check+0x2da>
ffffffffc0201376:	4481                	li	s1,0
ffffffffc0201378:	4901                	li	s2,0
ffffffffc020137a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020137e:	8b09                	andi	a4,a4,2
ffffffffc0201380:	2a070a63          	beqz	a4,ffffffffc0201634 <default_check+0x2e2>
ffffffffc0201384:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201388:	679c                	ld	a5,8(a5)
ffffffffc020138a:	2905                	addiw	s2,s2,1
ffffffffc020138c:	9cb9                	addw	s1,s1,a4
ffffffffc020138e:	fe8796e3          	bne	a5,s0,ffffffffc020137a <default_check+0x28>
ffffffffc0201392:	89a6                	mv	s3,s1
ffffffffc0201394:	6df000ef          	jal	ra,ffffffffc0202272 <nr_free_pages>
ffffffffc0201398:	6f351e63          	bne	a0,s3,ffffffffc0201a94 <default_check+0x742>
ffffffffc020139c:	4505                	li	a0,1
ffffffffc020139e:	657000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02013a2:	8aaa                	mv	s5,a0
ffffffffc02013a4:	42050863          	beqz	a0,ffffffffc02017d4 <default_check+0x482>
ffffffffc02013a8:	4505                	li	a0,1
ffffffffc02013aa:	64b000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02013ae:	89aa                	mv	s3,a0
ffffffffc02013b0:	70050263          	beqz	a0,ffffffffc0201ab4 <default_check+0x762>
ffffffffc02013b4:	4505                	li	a0,1
ffffffffc02013b6:	63f000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02013ba:	8a2a                	mv	s4,a0
ffffffffc02013bc:	48050c63          	beqz	a0,ffffffffc0201854 <default_check+0x502>
ffffffffc02013c0:	293a8a63          	beq	s5,s3,ffffffffc0201654 <default_check+0x302>
ffffffffc02013c4:	28aa8863          	beq	s5,a0,ffffffffc0201654 <default_check+0x302>
ffffffffc02013c8:	28a98663          	beq	s3,a0,ffffffffc0201654 <default_check+0x302>
ffffffffc02013cc:	000aa783          	lw	a5,0(s5)
ffffffffc02013d0:	2a079263          	bnez	a5,ffffffffc0201674 <default_check+0x322>
ffffffffc02013d4:	0009a783          	lw	a5,0(s3)
ffffffffc02013d8:	28079e63          	bnez	a5,ffffffffc0201674 <default_check+0x322>
ffffffffc02013dc:	411c                	lw	a5,0(a0)
ffffffffc02013de:	28079b63          	bnez	a5,ffffffffc0201674 <default_check+0x322>
ffffffffc02013e2:	00095797          	auipc	a5,0x95
ffffffffc02013e6:	4c67b783          	ld	a5,1222(a5) # ffffffffc02968a8 <pages>
ffffffffc02013ea:	40fa8733          	sub	a4,s5,a5
ffffffffc02013ee:	0000e617          	auipc	a2,0xe
ffffffffc02013f2:	4b263603          	ld	a2,1202(a2) # ffffffffc020f8a0 <nbase>
ffffffffc02013f6:	8719                	srai	a4,a4,0x6
ffffffffc02013f8:	9732                	add	a4,a4,a2
ffffffffc02013fa:	00095697          	auipc	a3,0x95
ffffffffc02013fe:	4a66b683          	ld	a3,1190(a3) # ffffffffc02968a0 <npage>
ffffffffc0201402:	06b2                	slli	a3,a3,0xc
ffffffffc0201404:	0732                	slli	a4,a4,0xc
ffffffffc0201406:	28d77763          	bgeu	a4,a3,ffffffffc0201694 <default_check+0x342>
ffffffffc020140a:	40f98733          	sub	a4,s3,a5
ffffffffc020140e:	8719                	srai	a4,a4,0x6
ffffffffc0201410:	9732                	add	a4,a4,a2
ffffffffc0201412:	0732                	slli	a4,a4,0xc
ffffffffc0201414:	4cd77063          	bgeu	a4,a3,ffffffffc02018d4 <default_check+0x582>
ffffffffc0201418:	40f507b3          	sub	a5,a0,a5
ffffffffc020141c:	8799                	srai	a5,a5,0x6
ffffffffc020141e:	97b2                	add	a5,a5,a2
ffffffffc0201420:	07b2                	slli	a5,a5,0xc
ffffffffc0201422:	30d7f963          	bgeu	a5,a3,ffffffffc0201734 <default_check+0x3e2>
ffffffffc0201426:	4505                	li	a0,1
ffffffffc0201428:	00043c03          	ld	s8,0(s0)
ffffffffc020142c:	00843b83          	ld	s7,8(s0)
ffffffffc0201430:	01042b03          	lw	s6,16(s0)
ffffffffc0201434:	e400                	sd	s0,8(s0)
ffffffffc0201436:	e000                	sd	s0,0(s0)
ffffffffc0201438:	00090797          	auipc	a5,0x90
ffffffffc020143c:	3807a023          	sw	zero,896(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201440:	5b5000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0201444:	2c051863          	bnez	a0,ffffffffc0201714 <default_check+0x3c2>
ffffffffc0201448:	4585                	li	a1,1
ffffffffc020144a:	8556                	mv	a0,s5
ffffffffc020144c:	5e7000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201450:	4585                	li	a1,1
ffffffffc0201452:	854e                	mv	a0,s3
ffffffffc0201454:	5df000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201458:	4585                	li	a1,1
ffffffffc020145a:	8552                	mv	a0,s4
ffffffffc020145c:	5d7000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201460:	4818                	lw	a4,16(s0)
ffffffffc0201462:	478d                	li	a5,3
ffffffffc0201464:	28f71863          	bne	a4,a5,ffffffffc02016f4 <default_check+0x3a2>
ffffffffc0201468:	4505                	li	a0,1
ffffffffc020146a:	58b000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020146e:	89aa                	mv	s3,a0
ffffffffc0201470:	26050263          	beqz	a0,ffffffffc02016d4 <default_check+0x382>
ffffffffc0201474:	4505                	li	a0,1
ffffffffc0201476:	57f000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020147a:	8aaa                	mv	s5,a0
ffffffffc020147c:	3a050c63          	beqz	a0,ffffffffc0201834 <default_check+0x4e2>
ffffffffc0201480:	4505                	li	a0,1
ffffffffc0201482:	573000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0201486:	8a2a                	mv	s4,a0
ffffffffc0201488:	38050663          	beqz	a0,ffffffffc0201814 <default_check+0x4c2>
ffffffffc020148c:	4505                	li	a0,1
ffffffffc020148e:	567000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0201492:	36051163          	bnez	a0,ffffffffc02017f4 <default_check+0x4a2>
ffffffffc0201496:	4585                	li	a1,1
ffffffffc0201498:	854e                	mv	a0,s3
ffffffffc020149a:	599000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc020149e:	641c                	ld	a5,8(s0)
ffffffffc02014a0:	20878a63          	beq	a5,s0,ffffffffc02016b4 <default_check+0x362>
ffffffffc02014a4:	4505                	li	a0,1
ffffffffc02014a6:	54f000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02014aa:	30a99563          	bne	s3,a0,ffffffffc02017b4 <default_check+0x462>
ffffffffc02014ae:	4505                	li	a0,1
ffffffffc02014b0:	545000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02014b4:	2e051063          	bnez	a0,ffffffffc0201794 <default_check+0x442>
ffffffffc02014b8:	481c                	lw	a5,16(s0)
ffffffffc02014ba:	2a079d63          	bnez	a5,ffffffffc0201774 <default_check+0x422>
ffffffffc02014be:	854e                	mv	a0,s3
ffffffffc02014c0:	4585                	li	a1,1
ffffffffc02014c2:	01843023          	sd	s8,0(s0)
ffffffffc02014c6:	01743423          	sd	s7,8(s0)
ffffffffc02014ca:	01642823          	sw	s6,16(s0)
ffffffffc02014ce:	565000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02014d2:	4585                	li	a1,1
ffffffffc02014d4:	8556                	mv	a0,s5
ffffffffc02014d6:	55d000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02014da:	4585                	li	a1,1
ffffffffc02014dc:	8552                	mv	a0,s4
ffffffffc02014de:	555000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02014e2:	4515                	li	a0,5
ffffffffc02014e4:	511000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02014e8:	89aa                	mv	s3,a0
ffffffffc02014ea:	26050563          	beqz	a0,ffffffffc0201754 <default_check+0x402>
ffffffffc02014ee:	651c                	ld	a5,8(a0)
ffffffffc02014f0:	8385                	srli	a5,a5,0x1
ffffffffc02014f2:	8b85                	andi	a5,a5,1
ffffffffc02014f4:	54079063          	bnez	a5,ffffffffc0201a34 <default_check+0x6e2>
ffffffffc02014f8:	4505                	li	a0,1
ffffffffc02014fa:	00043b03          	ld	s6,0(s0)
ffffffffc02014fe:	00843a83          	ld	s5,8(s0)
ffffffffc0201502:	e000                	sd	s0,0(s0)
ffffffffc0201504:	e400                	sd	s0,8(s0)
ffffffffc0201506:	4ef000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020150a:	50051563          	bnez	a0,ffffffffc0201a14 <default_check+0x6c2>
ffffffffc020150e:	08098a13          	addi	s4,s3,128
ffffffffc0201512:	8552                	mv	a0,s4
ffffffffc0201514:	458d                	li	a1,3
ffffffffc0201516:	01042b83          	lw	s7,16(s0)
ffffffffc020151a:	00090797          	auipc	a5,0x90
ffffffffc020151e:	2807af23          	sw	zero,670(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201522:	511000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201526:	4511                	li	a0,4
ffffffffc0201528:	4cd000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020152c:	4c051463          	bnez	a0,ffffffffc02019f4 <default_check+0x6a2>
ffffffffc0201530:	0889b783          	ld	a5,136(s3)
ffffffffc0201534:	8385                	srli	a5,a5,0x1
ffffffffc0201536:	8b85                	andi	a5,a5,1
ffffffffc0201538:	48078e63          	beqz	a5,ffffffffc02019d4 <default_check+0x682>
ffffffffc020153c:	0909a703          	lw	a4,144(s3)
ffffffffc0201540:	478d                	li	a5,3
ffffffffc0201542:	48f71963          	bne	a4,a5,ffffffffc02019d4 <default_check+0x682>
ffffffffc0201546:	450d                	li	a0,3
ffffffffc0201548:	4ad000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020154c:	8c2a                	mv	s8,a0
ffffffffc020154e:	46050363          	beqz	a0,ffffffffc02019b4 <default_check+0x662>
ffffffffc0201552:	4505                	li	a0,1
ffffffffc0201554:	4a1000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0201558:	42051e63          	bnez	a0,ffffffffc0201994 <default_check+0x642>
ffffffffc020155c:	418a1c63          	bne	s4,s8,ffffffffc0201974 <default_check+0x622>
ffffffffc0201560:	4585                	li	a1,1
ffffffffc0201562:	854e                	mv	a0,s3
ffffffffc0201564:	4cf000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201568:	458d                	li	a1,3
ffffffffc020156a:	8552                	mv	a0,s4
ffffffffc020156c:	4c7000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0201570:	0089b783          	ld	a5,8(s3)
ffffffffc0201574:	04098c13          	addi	s8,s3,64
ffffffffc0201578:	8385                	srli	a5,a5,0x1
ffffffffc020157a:	8b85                	andi	a5,a5,1
ffffffffc020157c:	3c078c63          	beqz	a5,ffffffffc0201954 <default_check+0x602>
ffffffffc0201580:	0109a703          	lw	a4,16(s3)
ffffffffc0201584:	4785                	li	a5,1
ffffffffc0201586:	3cf71763          	bne	a4,a5,ffffffffc0201954 <default_check+0x602>
ffffffffc020158a:	008a3783          	ld	a5,8(s4)
ffffffffc020158e:	8385                	srli	a5,a5,0x1
ffffffffc0201590:	8b85                	andi	a5,a5,1
ffffffffc0201592:	3a078163          	beqz	a5,ffffffffc0201934 <default_check+0x5e2>
ffffffffc0201596:	010a2703          	lw	a4,16(s4)
ffffffffc020159a:	478d                	li	a5,3
ffffffffc020159c:	38f71c63          	bne	a4,a5,ffffffffc0201934 <default_check+0x5e2>
ffffffffc02015a0:	4505                	li	a0,1
ffffffffc02015a2:	453000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02015a6:	36a99763          	bne	s3,a0,ffffffffc0201914 <default_check+0x5c2>
ffffffffc02015aa:	4585                	li	a1,1
ffffffffc02015ac:	487000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02015b0:	4509                	li	a0,2
ffffffffc02015b2:	443000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02015b6:	32aa1f63          	bne	s4,a0,ffffffffc02018f4 <default_check+0x5a2>
ffffffffc02015ba:	4589                	li	a1,2
ffffffffc02015bc:	477000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02015c0:	4585                	li	a1,1
ffffffffc02015c2:	8562                	mv	a0,s8
ffffffffc02015c4:	46f000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02015c8:	4515                	li	a0,5
ffffffffc02015ca:	42b000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02015ce:	89aa                	mv	s3,a0
ffffffffc02015d0:	48050263          	beqz	a0,ffffffffc0201a54 <default_check+0x702>
ffffffffc02015d4:	4505                	li	a0,1
ffffffffc02015d6:	41f000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc02015da:	2c051d63          	bnez	a0,ffffffffc02018b4 <default_check+0x562>
ffffffffc02015de:	481c                	lw	a5,16(s0)
ffffffffc02015e0:	2a079a63          	bnez	a5,ffffffffc0201894 <default_check+0x542>
ffffffffc02015e4:	4595                	li	a1,5
ffffffffc02015e6:	854e                	mv	a0,s3
ffffffffc02015e8:	01742823          	sw	s7,16(s0)
ffffffffc02015ec:	01643023          	sd	s6,0(s0)
ffffffffc02015f0:	01543423          	sd	s5,8(s0)
ffffffffc02015f4:	43f000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc02015f8:	641c                	ld	a5,8(s0)
ffffffffc02015fa:	00878963          	beq	a5,s0,ffffffffc020160c <default_check+0x2ba>
ffffffffc02015fe:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201602:	679c                	ld	a5,8(a5)
ffffffffc0201604:	397d                	addiw	s2,s2,-1
ffffffffc0201606:	9c99                	subw	s1,s1,a4
ffffffffc0201608:	fe879be3          	bne	a5,s0,ffffffffc02015fe <default_check+0x2ac>
ffffffffc020160c:	26091463          	bnez	s2,ffffffffc0201874 <default_check+0x522>
ffffffffc0201610:	46049263          	bnez	s1,ffffffffc0201a74 <default_check+0x722>
ffffffffc0201614:	60a6                	ld	ra,72(sp)
ffffffffc0201616:	6406                	ld	s0,64(sp)
ffffffffc0201618:	74e2                	ld	s1,56(sp)
ffffffffc020161a:	7942                	ld	s2,48(sp)
ffffffffc020161c:	79a2                	ld	s3,40(sp)
ffffffffc020161e:	7a02                	ld	s4,32(sp)
ffffffffc0201620:	6ae2                	ld	s5,24(sp)
ffffffffc0201622:	6b42                	ld	s6,16(sp)
ffffffffc0201624:	6ba2                	ld	s7,8(sp)
ffffffffc0201626:	6c02                	ld	s8,0(sp)
ffffffffc0201628:	6161                	addi	sp,sp,80
ffffffffc020162a:	8082                	ret
ffffffffc020162c:	4981                	li	s3,0
ffffffffc020162e:	4481                	li	s1,0
ffffffffc0201630:	4901                	li	s2,0
ffffffffc0201632:	b38d                	j	ffffffffc0201394 <default_check+0x42>
ffffffffc0201634:	0000b697          	auipc	a3,0xb
ffffffffc0201638:	c7c68693          	addi	a3,a3,-900 # ffffffffc020c2b0 <commands+0x948>
ffffffffc020163c:	0000a617          	auipc	a2,0xa
ffffffffc0201640:	53c60613          	addi	a2,a2,1340 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201644:	0ef00593          	li	a1,239
ffffffffc0201648:	0000b517          	auipc	a0,0xb
ffffffffc020164c:	c7850513          	addi	a0,a0,-904 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201650:	e4ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201654:	0000b697          	auipc	a3,0xb
ffffffffc0201658:	d0468693          	addi	a3,a3,-764 # ffffffffc020c358 <commands+0x9f0>
ffffffffc020165c:	0000a617          	auipc	a2,0xa
ffffffffc0201660:	51c60613          	addi	a2,a2,1308 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201664:	0bc00593          	li	a1,188
ffffffffc0201668:	0000b517          	auipc	a0,0xb
ffffffffc020166c:	c5850513          	addi	a0,a0,-936 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201670:	e2ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201674:	0000b697          	auipc	a3,0xb
ffffffffc0201678:	d0c68693          	addi	a3,a3,-756 # ffffffffc020c380 <commands+0xa18>
ffffffffc020167c:	0000a617          	auipc	a2,0xa
ffffffffc0201680:	4fc60613          	addi	a2,a2,1276 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201684:	0bd00593          	li	a1,189
ffffffffc0201688:	0000b517          	auipc	a0,0xb
ffffffffc020168c:	c3850513          	addi	a0,a0,-968 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201690:	e0ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201694:	0000b697          	auipc	a3,0xb
ffffffffc0201698:	d2c68693          	addi	a3,a3,-724 # ffffffffc020c3c0 <commands+0xa58>
ffffffffc020169c:	0000a617          	auipc	a2,0xa
ffffffffc02016a0:	4dc60613          	addi	a2,a2,1244 # ffffffffc020bb78 <commands+0x210>
ffffffffc02016a4:	0bf00593          	li	a1,191
ffffffffc02016a8:	0000b517          	auipc	a0,0xb
ffffffffc02016ac:	c1850513          	addi	a0,a0,-1000 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02016b0:	deffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016b4:	0000b697          	auipc	a3,0xb
ffffffffc02016b8:	d9468693          	addi	a3,a3,-620 # ffffffffc020c448 <commands+0xae0>
ffffffffc02016bc:	0000a617          	auipc	a2,0xa
ffffffffc02016c0:	4bc60613          	addi	a2,a2,1212 # ffffffffc020bb78 <commands+0x210>
ffffffffc02016c4:	0d800593          	li	a1,216
ffffffffc02016c8:	0000b517          	auipc	a0,0xb
ffffffffc02016cc:	bf850513          	addi	a0,a0,-1032 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02016d0:	dcffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016d4:	0000b697          	auipc	a3,0xb
ffffffffc02016d8:	c2468693          	addi	a3,a3,-988 # ffffffffc020c2f8 <commands+0x990>
ffffffffc02016dc:	0000a617          	auipc	a2,0xa
ffffffffc02016e0:	49c60613          	addi	a2,a2,1180 # ffffffffc020bb78 <commands+0x210>
ffffffffc02016e4:	0d100593          	li	a1,209
ffffffffc02016e8:	0000b517          	auipc	a0,0xb
ffffffffc02016ec:	bd850513          	addi	a0,a0,-1064 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02016f0:	daffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016f4:	0000b697          	auipc	a3,0xb
ffffffffc02016f8:	d4468693          	addi	a3,a3,-700 # ffffffffc020c438 <commands+0xad0>
ffffffffc02016fc:	0000a617          	auipc	a2,0xa
ffffffffc0201700:	47c60613          	addi	a2,a2,1148 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201704:	0cf00593          	li	a1,207
ffffffffc0201708:	0000b517          	auipc	a0,0xb
ffffffffc020170c:	bb850513          	addi	a0,a0,-1096 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201710:	d8ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201714:	0000b697          	auipc	a3,0xb
ffffffffc0201718:	d0c68693          	addi	a3,a3,-756 # ffffffffc020c420 <commands+0xab8>
ffffffffc020171c:	0000a617          	auipc	a2,0xa
ffffffffc0201720:	45c60613          	addi	a2,a2,1116 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201724:	0ca00593          	li	a1,202
ffffffffc0201728:	0000b517          	auipc	a0,0xb
ffffffffc020172c:	b9850513          	addi	a0,a0,-1128 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201730:	d6ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201734:	0000b697          	auipc	a3,0xb
ffffffffc0201738:	ccc68693          	addi	a3,a3,-820 # ffffffffc020c400 <commands+0xa98>
ffffffffc020173c:	0000a617          	auipc	a2,0xa
ffffffffc0201740:	43c60613          	addi	a2,a2,1084 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201744:	0c100593          	li	a1,193
ffffffffc0201748:	0000b517          	auipc	a0,0xb
ffffffffc020174c:	b7850513          	addi	a0,a0,-1160 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201750:	d4ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201754:	0000b697          	auipc	a3,0xb
ffffffffc0201758:	d3c68693          	addi	a3,a3,-708 # ffffffffc020c490 <commands+0xb28>
ffffffffc020175c:	0000a617          	auipc	a2,0xa
ffffffffc0201760:	41c60613          	addi	a2,a2,1052 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201764:	0f700593          	li	a1,247
ffffffffc0201768:	0000b517          	auipc	a0,0xb
ffffffffc020176c:	b5850513          	addi	a0,a0,-1192 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201770:	d2ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201774:	0000b697          	auipc	a3,0xb
ffffffffc0201778:	d0c68693          	addi	a3,a3,-756 # ffffffffc020c480 <commands+0xb18>
ffffffffc020177c:	0000a617          	auipc	a2,0xa
ffffffffc0201780:	3fc60613          	addi	a2,a2,1020 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201784:	0de00593          	li	a1,222
ffffffffc0201788:	0000b517          	auipc	a0,0xb
ffffffffc020178c:	b3850513          	addi	a0,a0,-1224 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201790:	d0ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201794:	0000b697          	auipc	a3,0xb
ffffffffc0201798:	c8c68693          	addi	a3,a3,-884 # ffffffffc020c420 <commands+0xab8>
ffffffffc020179c:	0000a617          	auipc	a2,0xa
ffffffffc02017a0:	3dc60613          	addi	a2,a2,988 # ffffffffc020bb78 <commands+0x210>
ffffffffc02017a4:	0dc00593          	li	a1,220
ffffffffc02017a8:	0000b517          	auipc	a0,0xb
ffffffffc02017ac:	b1850513          	addi	a0,a0,-1256 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02017b0:	ceffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017b4:	0000b697          	auipc	a3,0xb
ffffffffc02017b8:	cac68693          	addi	a3,a3,-852 # ffffffffc020c460 <commands+0xaf8>
ffffffffc02017bc:	0000a617          	auipc	a2,0xa
ffffffffc02017c0:	3bc60613          	addi	a2,a2,956 # ffffffffc020bb78 <commands+0x210>
ffffffffc02017c4:	0db00593          	li	a1,219
ffffffffc02017c8:	0000b517          	auipc	a0,0xb
ffffffffc02017cc:	af850513          	addi	a0,a0,-1288 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02017d0:	ccffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017d4:	0000b697          	auipc	a3,0xb
ffffffffc02017d8:	b2468693          	addi	a3,a3,-1244 # ffffffffc020c2f8 <commands+0x990>
ffffffffc02017dc:	0000a617          	auipc	a2,0xa
ffffffffc02017e0:	39c60613          	addi	a2,a2,924 # ffffffffc020bb78 <commands+0x210>
ffffffffc02017e4:	0b800593          	li	a1,184
ffffffffc02017e8:	0000b517          	auipc	a0,0xb
ffffffffc02017ec:	ad850513          	addi	a0,a0,-1320 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02017f0:	caffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017f4:	0000b697          	auipc	a3,0xb
ffffffffc02017f8:	c2c68693          	addi	a3,a3,-980 # ffffffffc020c420 <commands+0xab8>
ffffffffc02017fc:	0000a617          	auipc	a2,0xa
ffffffffc0201800:	37c60613          	addi	a2,a2,892 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201804:	0d500593          	li	a1,213
ffffffffc0201808:	0000b517          	auipc	a0,0xb
ffffffffc020180c:	ab850513          	addi	a0,a0,-1352 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201810:	c8ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201814:	0000b697          	auipc	a3,0xb
ffffffffc0201818:	b2468693          	addi	a3,a3,-1244 # ffffffffc020c338 <commands+0x9d0>
ffffffffc020181c:	0000a617          	auipc	a2,0xa
ffffffffc0201820:	35c60613          	addi	a2,a2,860 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201824:	0d300593          	li	a1,211
ffffffffc0201828:	0000b517          	auipc	a0,0xb
ffffffffc020182c:	a9850513          	addi	a0,a0,-1384 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201830:	c6ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201834:	0000b697          	auipc	a3,0xb
ffffffffc0201838:	ae468693          	addi	a3,a3,-1308 # ffffffffc020c318 <commands+0x9b0>
ffffffffc020183c:	0000a617          	auipc	a2,0xa
ffffffffc0201840:	33c60613          	addi	a2,a2,828 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201844:	0d200593          	li	a1,210
ffffffffc0201848:	0000b517          	auipc	a0,0xb
ffffffffc020184c:	a7850513          	addi	a0,a0,-1416 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201850:	c4ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201854:	0000b697          	auipc	a3,0xb
ffffffffc0201858:	ae468693          	addi	a3,a3,-1308 # ffffffffc020c338 <commands+0x9d0>
ffffffffc020185c:	0000a617          	auipc	a2,0xa
ffffffffc0201860:	31c60613          	addi	a2,a2,796 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201864:	0ba00593          	li	a1,186
ffffffffc0201868:	0000b517          	auipc	a0,0xb
ffffffffc020186c:	a5850513          	addi	a0,a0,-1448 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201870:	c2ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201874:	0000b697          	auipc	a3,0xb
ffffffffc0201878:	d6c68693          	addi	a3,a3,-660 # ffffffffc020c5e0 <commands+0xc78>
ffffffffc020187c:	0000a617          	auipc	a2,0xa
ffffffffc0201880:	2fc60613          	addi	a2,a2,764 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201884:	12400593          	li	a1,292
ffffffffc0201888:	0000b517          	auipc	a0,0xb
ffffffffc020188c:	a3850513          	addi	a0,a0,-1480 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201890:	c0ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201894:	0000b697          	auipc	a3,0xb
ffffffffc0201898:	bec68693          	addi	a3,a3,-1044 # ffffffffc020c480 <commands+0xb18>
ffffffffc020189c:	0000a617          	auipc	a2,0xa
ffffffffc02018a0:	2dc60613          	addi	a2,a2,732 # ffffffffc020bb78 <commands+0x210>
ffffffffc02018a4:	11900593          	li	a1,281
ffffffffc02018a8:	0000b517          	auipc	a0,0xb
ffffffffc02018ac:	a1850513          	addi	a0,a0,-1512 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02018b0:	beffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018b4:	0000b697          	auipc	a3,0xb
ffffffffc02018b8:	b6c68693          	addi	a3,a3,-1172 # ffffffffc020c420 <commands+0xab8>
ffffffffc02018bc:	0000a617          	auipc	a2,0xa
ffffffffc02018c0:	2bc60613          	addi	a2,a2,700 # ffffffffc020bb78 <commands+0x210>
ffffffffc02018c4:	11700593          	li	a1,279
ffffffffc02018c8:	0000b517          	auipc	a0,0xb
ffffffffc02018cc:	9f850513          	addi	a0,a0,-1544 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02018d0:	bcffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018d4:	0000b697          	auipc	a3,0xb
ffffffffc02018d8:	b0c68693          	addi	a3,a3,-1268 # ffffffffc020c3e0 <commands+0xa78>
ffffffffc02018dc:	0000a617          	auipc	a2,0xa
ffffffffc02018e0:	29c60613          	addi	a2,a2,668 # ffffffffc020bb78 <commands+0x210>
ffffffffc02018e4:	0c000593          	li	a1,192
ffffffffc02018e8:	0000b517          	auipc	a0,0xb
ffffffffc02018ec:	9d850513          	addi	a0,a0,-1576 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02018f0:	baffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018f4:	0000b697          	auipc	a3,0xb
ffffffffc02018f8:	cac68693          	addi	a3,a3,-852 # ffffffffc020c5a0 <commands+0xc38>
ffffffffc02018fc:	0000a617          	auipc	a2,0xa
ffffffffc0201900:	27c60613          	addi	a2,a2,636 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201904:	11100593          	li	a1,273
ffffffffc0201908:	0000b517          	auipc	a0,0xb
ffffffffc020190c:	9b850513          	addi	a0,a0,-1608 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201910:	b8ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201914:	0000b697          	auipc	a3,0xb
ffffffffc0201918:	c6c68693          	addi	a3,a3,-916 # ffffffffc020c580 <commands+0xc18>
ffffffffc020191c:	0000a617          	auipc	a2,0xa
ffffffffc0201920:	25c60613          	addi	a2,a2,604 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201924:	10f00593          	li	a1,271
ffffffffc0201928:	0000b517          	auipc	a0,0xb
ffffffffc020192c:	99850513          	addi	a0,a0,-1640 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201930:	b6ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201934:	0000b697          	auipc	a3,0xb
ffffffffc0201938:	c2468693          	addi	a3,a3,-988 # ffffffffc020c558 <commands+0xbf0>
ffffffffc020193c:	0000a617          	auipc	a2,0xa
ffffffffc0201940:	23c60613          	addi	a2,a2,572 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201944:	10d00593          	li	a1,269
ffffffffc0201948:	0000b517          	auipc	a0,0xb
ffffffffc020194c:	97850513          	addi	a0,a0,-1672 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201950:	b4ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201954:	0000b697          	auipc	a3,0xb
ffffffffc0201958:	bdc68693          	addi	a3,a3,-1060 # ffffffffc020c530 <commands+0xbc8>
ffffffffc020195c:	0000a617          	auipc	a2,0xa
ffffffffc0201960:	21c60613          	addi	a2,a2,540 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201964:	10c00593          	li	a1,268
ffffffffc0201968:	0000b517          	auipc	a0,0xb
ffffffffc020196c:	95850513          	addi	a0,a0,-1704 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201970:	b2ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201974:	0000b697          	auipc	a3,0xb
ffffffffc0201978:	bac68693          	addi	a3,a3,-1108 # ffffffffc020c520 <commands+0xbb8>
ffffffffc020197c:	0000a617          	auipc	a2,0xa
ffffffffc0201980:	1fc60613          	addi	a2,a2,508 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201984:	10700593          	li	a1,263
ffffffffc0201988:	0000b517          	auipc	a0,0xb
ffffffffc020198c:	93850513          	addi	a0,a0,-1736 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201990:	b0ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201994:	0000b697          	auipc	a3,0xb
ffffffffc0201998:	a8c68693          	addi	a3,a3,-1396 # ffffffffc020c420 <commands+0xab8>
ffffffffc020199c:	0000a617          	auipc	a2,0xa
ffffffffc02019a0:	1dc60613          	addi	a2,a2,476 # ffffffffc020bb78 <commands+0x210>
ffffffffc02019a4:	10600593          	li	a1,262
ffffffffc02019a8:	0000b517          	auipc	a0,0xb
ffffffffc02019ac:	91850513          	addi	a0,a0,-1768 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02019b0:	aeffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019b4:	0000b697          	auipc	a3,0xb
ffffffffc02019b8:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020c500 <commands+0xb98>
ffffffffc02019bc:	0000a617          	auipc	a2,0xa
ffffffffc02019c0:	1bc60613          	addi	a2,a2,444 # ffffffffc020bb78 <commands+0x210>
ffffffffc02019c4:	10500593          	li	a1,261
ffffffffc02019c8:	0000b517          	auipc	a0,0xb
ffffffffc02019cc:	8f850513          	addi	a0,a0,-1800 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02019d0:	acffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019d4:	0000b697          	auipc	a3,0xb
ffffffffc02019d8:	afc68693          	addi	a3,a3,-1284 # ffffffffc020c4d0 <commands+0xb68>
ffffffffc02019dc:	0000a617          	auipc	a2,0xa
ffffffffc02019e0:	19c60613          	addi	a2,a2,412 # ffffffffc020bb78 <commands+0x210>
ffffffffc02019e4:	10400593          	li	a1,260
ffffffffc02019e8:	0000b517          	auipc	a0,0xb
ffffffffc02019ec:	8d850513          	addi	a0,a0,-1832 # ffffffffc020c2c0 <commands+0x958>
ffffffffc02019f0:	aaffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019f4:	0000b697          	auipc	a3,0xb
ffffffffc02019f8:	ac468693          	addi	a3,a3,-1340 # ffffffffc020c4b8 <commands+0xb50>
ffffffffc02019fc:	0000a617          	auipc	a2,0xa
ffffffffc0201a00:	17c60613          	addi	a2,a2,380 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201a04:	10300593          	li	a1,259
ffffffffc0201a08:	0000b517          	auipc	a0,0xb
ffffffffc0201a0c:	8b850513          	addi	a0,a0,-1864 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201a10:	a8ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a14:	0000b697          	auipc	a3,0xb
ffffffffc0201a18:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c420 <commands+0xab8>
ffffffffc0201a1c:	0000a617          	auipc	a2,0xa
ffffffffc0201a20:	15c60613          	addi	a2,a2,348 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201a24:	0fd00593          	li	a1,253
ffffffffc0201a28:	0000b517          	auipc	a0,0xb
ffffffffc0201a2c:	89850513          	addi	a0,a0,-1896 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201a30:	a6ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a34:	0000b697          	auipc	a3,0xb
ffffffffc0201a38:	a6c68693          	addi	a3,a3,-1428 # ffffffffc020c4a0 <commands+0xb38>
ffffffffc0201a3c:	0000a617          	auipc	a2,0xa
ffffffffc0201a40:	13c60613          	addi	a2,a2,316 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201a44:	0f800593          	li	a1,248
ffffffffc0201a48:	0000b517          	auipc	a0,0xb
ffffffffc0201a4c:	87850513          	addi	a0,a0,-1928 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201a50:	a4ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a54:	0000b697          	auipc	a3,0xb
ffffffffc0201a58:	b6c68693          	addi	a3,a3,-1172 # ffffffffc020c5c0 <commands+0xc58>
ffffffffc0201a5c:	0000a617          	auipc	a2,0xa
ffffffffc0201a60:	11c60613          	addi	a2,a2,284 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201a64:	11600593          	li	a1,278
ffffffffc0201a68:	0000b517          	auipc	a0,0xb
ffffffffc0201a6c:	85850513          	addi	a0,a0,-1960 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201a70:	a2ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a74:	0000b697          	auipc	a3,0xb
ffffffffc0201a78:	b7c68693          	addi	a3,a3,-1156 # ffffffffc020c5f0 <commands+0xc88>
ffffffffc0201a7c:	0000a617          	auipc	a2,0xa
ffffffffc0201a80:	0fc60613          	addi	a2,a2,252 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201a84:	12500593          	li	a1,293
ffffffffc0201a88:	0000b517          	auipc	a0,0xb
ffffffffc0201a8c:	83850513          	addi	a0,a0,-1992 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201a90:	a0ffe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a94:	0000b697          	auipc	a3,0xb
ffffffffc0201a98:	84468693          	addi	a3,a3,-1980 # ffffffffc020c2d8 <commands+0x970>
ffffffffc0201a9c:	0000a617          	auipc	a2,0xa
ffffffffc0201aa0:	0dc60613          	addi	a2,a2,220 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201aa4:	0f200593          	li	a1,242
ffffffffc0201aa8:	0000b517          	auipc	a0,0xb
ffffffffc0201aac:	81850513          	addi	a0,a0,-2024 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201ab0:	9effe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201ab4:	0000b697          	auipc	a3,0xb
ffffffffc0201ab8:	86468693          	addi	a3,a3,-1948 # ffffffffc020c318 <commands+0x9b0>
ffffffffc0201abc:	0000a617          	auipc	a2,0xa
ffffffffc0201ac0:	0bc60613          	addi	a2,a2,188 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201ac4:	0b900593          	li	a1,185
ffffffffc0201ac8:	0000a517          	auipc	a0,0xa
ffffffffc0201acc:	7f850513          	addi	a0,a0,2040 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201ad0:	9cffe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201ad4 <default_free_pages>:
ffffffffc0201ad4:	1141                	addi	sp,sp,-16
ffffffffc0201ad6:	e406                	sd	ra,8(sp)
ffffffffc0201ad8:	14058463          	beqz	a1,ffffffffc0201c20 <default_free_pages+0x14c>
ffffffffc0201adc:	00659693          	slli	a3,a1,0x6
ffffffffc0201ae0:	96aa                	add	a3,a3,a0
ffffffffc0201ae2:	87aa                	mv	a5,a0
ffffffffc0201ae4:	02d50263          	beq	a0,a3,ffffffffc0201b08 <default_free_pages+0x34>
ffffffffc0201ae8:	6798                	ld	a4,8(a5)
ffffffffc0201aea:	8b05                	andi	a4,a4,1
ffffffffc0201aec:	10071a63          	bnez	a4,ffffffffc0201c00 <default_free_pages+0x12c>
ffffffffc0201af0:	6798                	ld	a4,8(a5)
ffffffffc0201af2:	8b09                	andi	a4,a4,2
ffffffffc0201af4:	10071663          	bnez	a4,ffffffffc0201c00 <default_free_pages+0x12c>
ffffffffc0201af8:	0007b423          	sd	zero,8(a5)
ffffffffc0201afc:	0007a023          	sw	zero,0(a5)
ffffffffc0201b00:	04078793          	addi	a5,a5,64
ffffffffc0201b04:	fed792e3          	bne	a5,a3,ffffffffc0201ae8 <default_free_pages+0x14>
ffffffffc0201b08:	2581                	sext.w	a1,a1
ffffffffc0201b0a:	c90c                	sw	a1,16(a0)
ffffffffc0201b0c:	00850893          	addi	a7,a0,8
ffffffffc0201b10:	4789                	li	a5,2
ffffffffc0201b12:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201b16:	00090697          	auipc	a3,0x90
ffffffffc0201b1a:	c9268693          	addi	a3,a3,-878 # ffffffffc02917a8 <free_area>
ffffffffc0201b1e:	4a98                	lw	a4,16(a3)
ffffffffc0201b20:	669c                	ld	a5,8(a3)
ffffffffc0201b22:	01850613          	addi	a2,a0,24
ffffffffc0201b26:	9db9                	addw	a1,a1,a4
ffffffffc0201b28:	ca8c                	sw	a1,16(a3)
ffffffffc0201b2a:	0ad78463          	beq	a5,a3,ffffffffc0201bd2 <default_free_pages+0xfe>
ffffffffc0201b2e:	fe878713          	addi	a4,a5,-24
ffffffffc0201b32:	0006b803          	ld	a6,0(a3)
ffffffffc0201b36:	4581                	li	a1,0
ffffffffc0201b38:	00e56a63          	bltu	a0,a4,ffffffffc0201b4c <default_free_pages+0x78>
ffffffffc0201b3c:	6798                	ld	a4,8(a5)
ffffffffc0201b3e:	04d70c63          	beq	a4,a3,ffffffffc0201b96 <default_free_pages+0xc2>
ffffffffc0201b42:	87ba                	mv	a5,a4
ffffffffc0201b44:	fe878713          	addi	a4,a5,-24
ffffffffc0201b48:	fee57ae3          	bgeu	a0,a4,ffffffffc0201b3c <default_free_pages+0x68>
ffffffffc0201b4c:	c199                	beqz	a1,ffffffffc0201b52 <default_free_pages+0x7e>
ffffffffc0201b4e:	0106b023          	sd	a6,0(a3)
ffffffffc0201b52:	6398                	ld	a4,0(a5)
ffffffffc0201b54:	e390                	sd	a2,0(a5)
ffffffffc0201b56:	e710                	sd	a2,8(a4)
ffffffffc0201b58:	f11c                	sd	a5,32(a0)
ffffffffc0201b5a:	ed18                	sd	a4,24(a0)
ffffffffc0201b5c:	00d70d63          	beq	a4,a3,ffffffffc0201b76 <default_free_pages+0xa2>
ffffffffc0201b60:	ff872583          	lw	a1,-8(a4)
ffffffffc0201b64:	fe870613          	addi	a2,a4,-24
ffffffffc0201b68:	02059813          	slli	a6,a1,0x20
ffffffffc0201b6c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201b70:	97b2                	add	a5,a5,a2
ffffffffc0201b72:	02f50c63          	beq	a0,a5,ffffffffc0201baa <default_free_pages+0xd6>
ffffffffc0201b76:	711c                	ld	a5,32(a0)
ffffffffc0201b78:	00d78c63          	beq	a5,a3,ffffffffc0201b90 <default_free_pages+0xbc>
ffffffffc0201b7c:	4910                	lw	a2,16(a0)
ffffffffc0201b7e:	fe878693          	addi	a3,a5,-24
ffffffffc0201b82:	02061593          	slli	a1,a2,0x20
ffffffffc0201b86:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b8a:	972a                	add	a4,a4,a0
ffffffffc0201b8c:	04e68a63          	beq	a3,a4,ffffffffc0201be0 <default_free_pages+0x10c>
ffffffffc0201b90:	60a2                	ld	ra,8(sp)
ffffffffc0201b92:	0141                	addi	sp,sp,16
ffffffffc0201b94:	8082                	ret
ffffffffc0201b96:	e790                	sd	a2,8(a5)
ffffffffc0201b98:	f114                	sd	a3,32(a0)
ffffffffc0201b9a:	6798                	ld	a4,8(a5)
ffffffffc0201b9c:	ed1c                	sd	a5,24(a0)
ffffffffc0201b9e:	02d70763          	beq	a4,a3,ffffffffc0201bcc <default_free_pages+0xf8>
ffffffffc0201ba2:	8832                	mv	a6,a2
ffffffffc0201ba4:	4585                	li	a1,1
ffffffffc0201ba6:	87ba                	mv	a5,a4
ffffffffc0201ba8:	bf71                	j	ffffffffc0201b44 <default_free_pages+0x70>
ffffffffc0201baa:	491c                	lw	a5,16(a0)
ffffffffc0201bac:	9dbd                	addw	a1,a1,a5
ffffffffc0201bae:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201bb2:	57f5                	li	a5,-3
ffffffffc0201bb4:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201bb8:	01853803          	ld	a6,24(a0)
ffffffffc0201bbc:	710c                	ld	a1,32(a0)
ffffffffc0201bbe:	8532                	mv	a0,a2
ffffffffc0201bc0:	00b83423          	sd	a1,8(a6)
ffffffffc0201bc4:	671c                	ld	a5,8(a4)
ffffffffc0201bc6:	0105b023          	sd	a6,0(a1)
ffffffffc0201bca:	b77d                	j	ffffffffc0201b78 <default_free_pages+0xa4>
ffffffffc0201bcc:	e290                	sd	a2,0(a3)
ffffffffc0201bce:	873e                	mv	a4,a5
ffffffffc0201bd0:	bf41                	j	ffffffffc0201b60 <default_free_pages+0x8c>
ffffffffc0201bd2:	60a2                	ld	ra,8(sp)
ffffffffc0201bd4:	e390                	sd	a2,0(a5)
ffffffffc0201bd6:	e790                	sd	a2,8(a5)
ffffffffc0201bd8:	f11c                	sd	a5,32(a0)
ffffffffc0201bda:	ed1c                	sd	a5,24(a0)
ffffffffc0201bdc:	0141                	addi	sp,sp,16
ffffffffc0201bde:	8082                	ret
ffffffffc0201be0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201be4:	ff078693          	addi	a3,a5,-16
ffffffffc0201be8:	9e39                	addw	a2,a2,a4
ffffffffc0201bea:	c910                	sw	a2,16(a0)
ffffffffc0201bec:	5775                	li	a4,-3
ffffffffc0201bee:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201bf2:	6398                	ld	a4,0(a5)
ffffffffc0201bf4:	679c                	ld	a5,8(a5)
ffffffffc0201bf6:	60a2                	ld	ra,8(sp)
ffffffffc0201bf8:	e71c                	sd	a5,8(a4)
ffffffffc0201bfa:	e398                	sd	a4,0(a5)
ffffffffc0201bfc:	0141                	addi	sp,sp,16
ffffffffc0201bfe:	8082                	ret
ffffffffc0201c00:	0000b697          	auipc	a3,0xb
ffffffffc0201c04:	a0868693          	addi	a3,a3,-1528 # ffffffffc020c608 <commands+0xca0>
ffffffffc0201c08:	0000a617          	auipc	a2,0xa
ffffffffc0201c0c:	f7060613          	addi	a2,a2,-144 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201c10:	08200593          	li	a1,130
ffffffffc0201c14:	0000a517          	auipc	a0,0xa
ffffffffc0201c18:	6ac50513          	addi	a0,a0,1708 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201c1c:	883fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201c20:	0000b697          	auipc	a3,0xb
ffffffffc0201c24:	9e068693          	addi	a3,a3,-1568 # ffffffffc020c600 <commands+0xc98>
ffffffffc0201c28:	0000a617          	auipc	a2,0xa
ffffffffc0201c2c:	f5060613          	addi	a2,a2,-176 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201c30:	07f00593          	li	a1,127
ffffffffc0201c34:	0000a517          	auipc	a0,0xa
ffffffffc0201c38:	68c50513          	addi	a0,a0,1676 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201c3c:	863fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201c40 <default_alloc_pages>:
ffffffffc0201c40:	c941                	beqz	a0,ffffffffc0201cd0 <default_alloc_pages+0x90>
ffffffffc0201c42:	00090597          	auipc	a1,0x90
ffffffffc0201c46:	b6658593          	addi	a1,a1,-1178 # ffffffffc02917a8 <free_area>
ffffffffc0201c4a:	0105a803          	lw	a6,16(a1)
ffffffffc0201c4e:	872a                	mv	a4,a0
ffffffffc0201c50:	02081793          	slli	a5,a6,0x20
ffffffffc0201c54:	9381                	srli	a5,a5,0x20
ffffffffc0201c56:	00a7ee63          	bltu	a5,a0,ffffffffc0201c72 <default_alloc_pages+0x32>
ffffffffc0201c5a:	87ae                	mv	a5,a1
ffffffffc0201c5c:	a801                	j	ffffffffc0201c6c <default_alloc_pages+0x2c>
ffffffffc0201c5e:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201c62:	02069613          	slli	a2,a3,0x20
ffffffffc0201c66:	9201                	srli	a2,a2,0x20
ffffffffc0201c68:	00e67763          	bgeu	a2,a4,ffffffffc0201c76 <default_alloc_pages+0x36>
ffffffffc0201c6c:	679c                	ld	a5,8(a5)
ffffffffc0201c6e:	feb798e3          	bne	a5,a1,ffffffffc0201c5e <default_alloc_pages+0x1e>
ffffffffc0201c72:	4501                	li	a0,0
ffffffffc0201c74:	8082                	ret
ffffffffc0201c76:	0007b883          	ld	a7,0(a5)
ffffffffc0201c7a:	0087b303          	ld	t1,8(a5)
ffffffffc0201c7e:	fe878513          	addi	a0,a5,-24
ffffffffc0201c82:	00070e1b          	sext.w	t3,a4
ffffffffc0201c86:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc0201c8a:	01133023          	sd	a7,0(t1)
ffffffffc0201c8e:	02c77863          	bgeu	a4,a2,ffffffffc0201cbe <default_alloc_pages+0x7e>
ffffffffc0201c92:	071a                	slli	a4,a4,0x6
ffffffffc0201c94:	972a                	add	a4,a4,a0
ffffffffc0201c96:	41c686bb          	subw	a3,a3,t3
ffffffffc0201c9a:	cb14                	sw	a3,16(a4)
ffffffffc0201c9c:	00870613          	addi	a2,a4,8
ffffffffc0201ca0:	4689                	li	a3,2
ffffffffc0201ca2:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201ca6:	0088b683          	ld	a3,8(a7)
ffffffffc0201caa:	01870613          	addi	a2,a4,24
ffffffffc0201cae:	0105a803          	lw	a6,16(a1)
ffffffffc0201cb2:	e290                	sd	a2,0(a3)
ffffffffc0201cb4:	00c8b423          	sd	a2,8(a7)
ffffffffc0201cb8:	f314                	sd	a3,32(a4)
ffffffffc0201cba:	01173c23          	sd	a7,24(a4)
ffffffffc0201cbe:	41c8083b          	subw	a6,a6,t3
ffffffffc0201cc2:	0105a823          	sw	a6,16(a1)
ffffffffc0201cc6:	5775                	li	a4,-3
ffffffffc0201cc8:	17c1                	addi	a5,a5,-16
ffffffffc0201cca:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201cce:	8082                	ret
ffffffffc0201cd0:	1141                	addi	sp,sp,-16
ffffffffc0201cd2:	0000b697          	auipc	a3,0xb
ffffffffc0201cd6:	92e68693          	addi	a3,a3,-1746 # ffffffffc020c600 <commands+0xc98>
ffffffffc0201cda:	0000a617          	auipc	a2,0xa
ffffffffc0201cde:	e9e60613          	addi	a2,a2,-354 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201ce2:	06100593          	li	a1,97
ffffffffc0201ce6:	0000a517          	auipc	a0,0xa
ffffffffc0201cea:	5da50513          	addi	a0,a0,1498 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201cee:	e406                	sd	ra,8(sp)
ffffffffc0201cf0:	faefe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201cf4 <default_init_memmap>:
ffffffffc0201cf4:	1141                	addi	sp,sp,-16
ffffffffc0201cf6:	e406                	sd	ra,8(sp)
ffffffffc0201cf8:	c5f1                	beqz	a1,ffffffffc0201dc4 <default_init_memmap+0xd0>
ffffffffc0201cfa:	00659693          	slli	a3,a1,0x6
ffffffffc0201cfe:	96aa                	add	a3,a3,a0
ffffffffc0201d00:	87aa                	mv	a5,a0
ffffffffc0201d02:	00d50f63          	beq	a0,a3,ffffffffc0201d20 <default_init_memmap+0x2c>
ffffffffc0201d06:	6798                	ld	a4,8(a5)
ffffffffc0201d08:	8b05                	andi	a4,a4,1
ffffffffc0201d0a:	cf49                	beqz	a4,ffffffffc0201da4 <default_init_memmap+0xb0>
ffffffffc0201d0c:	0007a823          	sw	zero,16(a5)
ffffffffc0201d10:	0007b423          	sd	zero,8(a5)
ffffffffc0201d14:	0007a023          	sw	zero,0(a5)
ffffffffc0201d18:	04078793          	addi	a5,a5,64
ffffffffc0201d1c:	fed795e3          	bne	a5,a3,ffffffffc0201d06 <default_init_memmap+0x12>
ffffffffc0201d20:	2581                	sext.w	a1,a1
ffffffffc0201d22:	c90c                	sw	a1,16(a0)
ffffffffc0201d24:	4789                	li	a5,2
ffffffffc0201d26:	00850713          	addi	a4,a0,8
ffffffffc0201d2a:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201d2e:	00090697          	auipc	a3,0x90
ffffffffc0201d32:	a7a68693          	addi	a3,a3,-1414 # ffffffffc02917a8 <free_area>
ffffffffc0201d36:	4a98                	lw	a4,16(a3)
ffffffffc0201d38:	669c                	ld	a5,8(a3)
ffffffffc0201d3a:	01850613          	addi	a2,a0,24
ffffffffc0201d3e:	9db9                	addw	a1,a1,a4
ffffffffc0201d40:	ca8c                	sw	a1,16(a3)
ffffffffc0201d42:	04d78a63          	beq	a5,a3,ffffffffc0201d96 <default_init_memmap+0xa2>
ffffffffc0201d46:	fe878713          	addi	a4,a5,-24
ffffffffc0201d4a:	0006b803          	ld	a6,0(a3)
ffffffffc0201d4e:	4581                	li	a1,0
ffffffffc0201d50:	00e56a63          	bltu	a0,a4,ffffffffc0201d64 <default_init_memmap+0x70>
ffffffffc0201d54:	6798                	ld	a4,8(a5)
ffffffffc0201d56:	02d70263          	beq	a4,a3,ffffffffc0201d7a <default_init_memmap+0x86>
ffffffffc0201d5a:	87ba                	mv	a5,a4
ffffffffc0201d5c:	fe878713          	addi	a4,a5,-24
ffffffffc0201d60:	fee57ae3          	bgeu	a0,a4,ffffffffc0201d54 <default_init_memmap+0x60>
ffffffffc0201d64:	c199                	beqz	a1,ffffffffc0201d6a <default_init_memmap+0x76>
ffffffffc0201d66:	0106b023          	sd	a6,0(a3)
ffffffffc0201d6a:	6398                	ld	a4,0(a5)
ffffffffc0201d6c:	60a2                	ld	ra,8(sp)
ffffffffc0201d6e:	e390                	sd	a2,0(a5)
ffffffffc0201d70:	e710                	sd	a2,8(a4)
ffffffffc0201d72:	f11c                	sd	a5,32(a0)
ffffffffc0201d74:	ed18                	sd	a4,24(a0)
ffffffffc0201d76:	0141                	addi	sp,sp,16
ffffffffc0201d78:	8082                	ret
ffffffffc0201d7a:	e790                	sd	a2,8(a5)
ffffffffc0201d7c:	f114                	sd	a3,32(a0)
ffffffffc0201d7e:	6798                	ld	a4,8(a5)
ffffffffc0201d80:	ed1c                	sd	a5,24(a0)
ffffffffc0201d82:	00d70663          	beq	a4,a3,ffffffffc0201d8e <default_init_memmap+0x9a>
ffffffffc0201d86:	8832                	mv	a6,a2
ffffffffc0201d88:	4585                	li	a1,1
ffffffffc0201d8a:	87ba                	mv	a5,a4
ffffffffc0201d8c:	bfc1                	j	ffffffffc0201d5c <default_init_memmap+0x68>
ffffffffc0201d8e:	60a2                	ld	ra,8(sp)
ffffffffc0201d90:	e290                	sd	a2,0(a3)
ffffffffc0201d92:	0141                	addi	sp,sp,16
ffffffffc0201d94:	8082                	ret
ffffffffc0201d96:	60a2                	ld	ra,8(sp)
ffffffffc0201d98:	e390                	sd	a2,0(a5)
ffffffffc0201d9a:	e790                	sd	a2,8(a5)
ffffffffc0201d9c:	f11c                	sd	a5,32(a0)
ffffffffc0201d9e:	ed1c                	sd	a5,24(a0)
ffffffffc0201da0:	0141                	addi	sp,sp,16
ffffffffc0201da2:	8082                	ret
ffffffffc0201da4:	0000b697          	auipc	a3,0xb
ffffffffc0201da8:	88c68693          	addi	a3,a3,-1908 # ffffffffc020c630 <commands+0xcc8>
ffffffffc0201dac:	0000a617          	auipc	a2,0xa
ffffffffc0201db0:	dcc60613          	addi	a2,a2,-564 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201db4:	04800593          	li	a1,72
ffffffffc0201db8:	0000a517          	auipc	a0,0xa
ffffffffc0201dbc:	50850513          	addi	a0,a0,1288 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201dc0:	edefe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201dc4:	0000b697          	auipc	a3,0xb
ffffffffc0201dc8:	83c68693          	addi	a3,a3,-1988 # ffffffffc020c600 <commands+0xc98>
ffffffffc0201dcc:	0000a617          	auipc	a2,0xa
ffffffffc0201dd0:	dac60613          	addi	a2,a2,-596 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201dd4:	04500593          	li	a1,69
ffffffffc0201dd8:	0000a517          	auipc	a0,0xa
ffffffffc0201ddc:	4e850513          	addi	a0,a0,1256 # ffffffffc020c2c0 <commands+0x958>
ffffffffc0201de0:	ebefe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201de4 <slob_free>:
ffffffffc0201de4:	c94d                	beqz	a0,ffffffffc0201e96 <slob_free+0xb2>
ffffffffc0201de6:	1141                	addi	sp,sp,-16
ffffffffc0201de8:	e022                	sd	s0,0(sp)
ffffffffc0201dea:	e406                	sd	ra,8(sp)
ffffffffc0201dec:	842a                	mv	s0,a0
ffffffffc0201dee:	e9c1                	bnez	a1,ffffffffc0201e7e <slob_free+0x9a>
ffffffffc0201df0:	100027f3          	csrr	a5,sstatus
ffffffffc0201df4:	8b89                	andi	a5,a5,2
ffffffffc0201df6:	4501                	li	a0,0
ffffffffc0201df8:	ebd9                	bnez	a5,ffffffffc0201e8e <slob_free+0xaa>
ffffffffc0201dfa:	0008f617          	auipc	a2,0x8f
ffffffffc0201dfe:	25660613          	addi	a2,a2,598 # ffffffffc0291050 <slobfree>
ffffffffc0201e02:	621c                	ld	a5,0(a2)
ffffffffc0201e04:	873e                	mv	a4,a5
ffffffffc0201e06:	679c                	ld	a5,8(a5)
ffffffffc0201e08:	02877a63          	bgeu	a4,s0,ffffffffc0201e3c <slob_free+0x58>
ffffffffc0201e0c:	00f46463          	bltu	s0,a5,ffffffffc0201e14 <slob_free+0x30>
ffffffffc0201e10:	fef76ae3          	bltu	a4,a5,ffffffffc0201e04 <slob_free+0x20>
ffffffffc0201e14:	400c                	lw	a1,0(s0)
ffffffffc0201e16:	00459693          	slli	a3,a1,0x4
ffffffffc0201e1a:	96a2                	add	a3,a3,s0
ffffffffc0201e1c:	02d78a63          	beq	a5,a3,ffffffffc0201e50 <slob_free+0x6c>
ffffffffc0201e20:	4314                	lw	a3,0(a4)
ffffffffc0201e22:	e41c                	sd	a5,8(s0)
ffffffffc0201e24:	00469793          	slli	a5,a3,0x4
ffffffffc0201e28:	97ba                	add	a5,a5,a4
ffffffffc0201e2a:	02f40e63          	beq	s0,a5,ffffffffc0201e66 <slob_free+0x82>
ffffffffc0201e2e:	e700                	sd	s0,8(a4)
ffffffffc0201e30:	e218                	sd	a4,0(a2)
ffffffffc0201e32:	e129                	bnez	a0,ffffffffc0201e74 <slob_free+0x90>
ffffffffc0201e34:	60a2                	ld	ra,8(sp)
ffffffffc0201e36:	6402                	ld	s0,0(sp)
ffffffffc0201e38:	0141                	addi	sp,sp,16
ffffffffc0201e3a:	8082                	ret
ffffffffc0201e3c:	fcf764e3          	bltu	a4,a5,ffffffffc0201e04 <slob_free+0x20>
ffffffffc0201e40:	fcf472e3          	bgeu	s0,a5,ffffffffc0201e04 <slob_free+0x20>
ffffffffc0201e44:	400c                	lw	a1,0(s0)
ffffffffc0201e46:	00459693          	slli	a3,a1,0x4
ffffffffc0201e4a:	96a2                	add	a3,a3,s0
ffffffffc0201e4c:	fcd79ae3          	bne	a5,a3,ffffffffc0201e20 <slob_free+0x3c>
ffffffffc0201e50:	4394                	lw	a3,0(a5)
ffffffffc0201e52:	679c                	ld	a5,8(a5)
ffffffffc0201e54:	9db5                	addw	a1,a1,a3
ffffffffc0201e56:	c00c                	sw	a1,0(s0)
ffffffffc0201e58:	4314                	lw	a3,0(a4)
ffffffffc0201e5a:	e41c                	sd	a5,8(s0)
ffffffffc0201e5c:	00469793          	slli	a5,a3,0x4
ffffffffc0201e60:	97ba                	add	a5,a5,a4
ffffffffc0201e62:	fcf416e3          	bne	s0,a5,ffffffffc0201e2e <slob_free+0x4a>
ffffffffc0201e66:	401c                	lw	a5,0(s0)
ffffffffc0201e68:	640c                	ld	a1,8(s0)
ffffffffc0201e6a:	e218                	sd	a4,0(a2)
ffffffffc0201e6c:	9ebd                	addw	a3,a3,a5
ffffffffc0201e6e:	c314                	sw	a3,0(a4)
ffffffffc0201e70:	e70c                	sd	a1,8(a4)
ffffffffc0201e72:	d169                	beqz	a0,ffffffffc0201e34 <slob_free+0x50>
ffffffffc0201e74:	6402                	ld	s0,0(sp)
ffffffffc0201e76:	60a2                	ld	ra,8(sp)
ffffffffc0201e78:	0141                	addi	sp,sp,16
ffffffffc0201e7a:	df3fe06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0201e7e:	25bd                	addiw	a1,a1,15
ffffffffc0201e80:	8191                	srli	a1,a1,0x4
ffffffffc0201e82:	c10c                	sw	a1,0(a0)
ffffffffc0201e84:	100027f3          	csrr	a5,sstatus
ffffffffc0201e88:	8b89                	andi	a5,a5,2
ffffffffc0201e8a:	4501                	li	a0,0
ffffffffc0201e8c:	d7bd                	beqz	a5,ffffffffc0201dfa <slob_free+0x16>
ffffffffc0201e8e:	de5fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201e92:	4505                	li	a0,1
ffffffffc0201e94:	b79d                	j	ffffffffc0201dfa <slob_free+0x16>
ffffffffc0201e96:	8082                	ret

ffffffffc0201e98 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e98:	4785                	li	a5,1
ffffffffc0201e9a:	1141                	addi	sp,sp,-16
ffffffffc0201e9c:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201ea0:	e406                	sd	ra,8(sp)
ffffffffc0201ea2:	352000ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0201ea6:	c91d                	beqz	a0,ffffffffc0201edc <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201ea8:	00095697          	auipc	a3,0x95
ffffffffc0201eac:	a006b683          	ld	a3,-1536(a3) # ffffffffc02968a8 <pages>
ffffffffc0201eb0:	8d15                	sub	a0,a0,a3
ffffffffc0201eb2:	8519                	srai	a0,a0,0x6
ffffffffc0201eb4:	0000e697          	auipc	a3,0xe
ffffffffc0201eb8:	9ec6b683          	ld	a3,-1556(a3) # ffffffffc020f8a0 <nbase>
ffffffffc0201ebc:	9536                	add	a0,a0,a3
ffffffffc0201ebe:	00c51793          	slli	a5,a0,0xc
ffffffffc0201ec2:	83b1                	srli	a5,a5,0xc
ffffffffc0201ec4:	00095717          	auipc	a4,0x95
ffffffffc0201ec8:	9dc73703          	ld	a4,-1572(a4) # ffffffffc02968a0 <npage>
ffffffffc0201ecc:	0532                	slli	a0,a0,0xc
ffffffffc0201ece:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ee2 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201ed2:	00095697          	auipc	a3,0x95
ffffffffc0201ed6:	9e66b683          	ld	a3,-1562(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201eda:	9536                	add	a0,a0,a3
ffffffffc0201edc:	60a2                	ld	ra,8(sp)
ffffffffc0201ede:	0141                	addi	sp,sp,16
ffffffffc0201ee0:	8082                	ret
ffffffffc0201ee2:	86aa                	mv	a3,a0
ffffffffc0201ee4:	0000a617          	auipc	a2,0xa
ffffffffc0201ee8:	7ac60613          	addi	a2,a2,1964 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0201eec:	07100593          	li	a1,113
ffffffffc0201ef0:	0000a517          	auipc	a0,0xa
ffffffffc0201ef4:	7c850513          	addi	a0,a0,1992 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0201ef8:	da6fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201efc <slob_alloc.constprop.0>:
ffffffffc0201efc:	1101                	addi	sp,sp,-32
ffffffffc0201efe:	ec06                	sd	ra,24(sp)
ffffffffc0201f00:	e822                	sd	s0,16(sp)
ffffffffc0201f02:	e426                	sd	s1,8(sp)
ffffffffc0201f04:	e04a                	sd	s2,0(sp)
ffffffffc0201f06:	01050713          	addi	a4,a0,16
ffffffffc0201f0a:	6785                	lui	a5,0x1
ffffffffc0201f0c:	0cf77363          	bgeu	a4,a5,ffffffffc0201fd2 <slob_alloc.constprop.0+0xd6>
ffffffffc0201f10:	00f50493          	addi	s1,a0,15
ffffffffc0201f14:	8091                	srli	s1,s1,0x4
ffffffffc0201f16:	2481                	sext.w	s1,s1
ffffffffc0201f18:	10002673          	csrr	a2,sstatus
ffffffffc0201f1c:	8a09                	andi	a2,a2,2
ffffffffc0201f1e:	e25d                	bnez	a2,ffffffffc0201fc4 <slob_alloc.constprop.0+0xc8>
ffffffffc0201f20:	0008f917          	auipc	s2,0x8f
ffffffffc0201f24:	13090913          	addi	s2,s2,304 # ffffffffc0291050 <slobfree>
ffffffffc0201f28:	00093683          	ld	a3,0(s2)
ffffffffc0201f2c:	669c                	ld	a5,8(a3)
ffffffffc0201f2e:	4398                	lw	a4,0(a5)
ffffffffc0201f30:	08975e63          	bge	a4,s1,ffffffffc0201fcc <slob_alloc.constprop.0+0xd0>
ffffffffc0201f34:	00f68b63          	beq	a3,a5,ffffffffc0201f4a <slob_alloc.constprop.0+0x4e>
ffffffffc0201f38:	6780                	ld	s0,8(a5)
ffffffffc0201f3a:	4018                	lw	a4,0(s0)
ffffffffc0201f3c:	02975a63          	bge	a4,s1,ffffffffc0201f70 <slob_alloc.constprop.0+0x74>
ffffffffc0201f40:	00093683          	ld	a3,0(s2)
ffffffffc0201f44:	87a2                	mv	a5,s0
ffffffffc0201f46:	fef699e3          	bne	a3,a5,ffffffffc0201f38 <slob_alloc.constprop.0+0x3c>
ffffffffc0201f4a:	ee31                	bnez	a2,ffffffffc0201fa6 <slob_alloc.constprop.0+0xaa>
ffffffffc0201f4c:	4501                	li	a0,0
ffffffffc0201f4e:	f4bff0ef          	jal	ra,ffffffffc0201e98 <__slob_get_free_pages.constprop.0>
ffffffffc0201f52:	842a                	mv	s0,a0
ffffffffc0201f54:	cd05                	beqz	a0,ffffffffc0201f8c <slob_alloc.constprop.0+0x90>
ffffffffc0201f56:	6585                	lui	a1,0x1
ffffffffc0201f58:	e8dff0ef          	jal	ra,ffffffffc0201de4 <slob_free>
ffffffffc0201f5c:	10002673          	csrr	a2,sstatus
ffffffffc0201f60:	8a09                	andi	a2,a2,2
ffffffffc0201f62:	ee05                	bnez	a2,ffffffffc0201f9a <slob_alloc.constprop.0+0x9e>
ffffffffc0201f64:	00093783          	ld	a5,0(s2)
ffffffffc0201f68:	6780                	ld	s0,8(a5)
ffffffffc0201f6a:	4018                	lw	a4,0(s0)
ffffffffc0201f6c:	fc974ae3          	blt	a4,s1,ffffffffc0201f40 <slob_alloc.constprop.0+0x44>
ffffffffc0201f70:	04e48763          	beq	s1,a4,ffffffffc0201fbe <slob_alloc.constprop.0+0xc2>
ffffffffc0201f74:	00449693          	slli	a3,s1,0x4
ffffffffc0201f78:	96a2                	add	a3,a3,s0
ffffffffc0201f7a:	e794                	sd	a3,8(a5)
ffffffffc0201f7c:	640c                	ld	a1,8(s0)
ffffffffc0201f7e:	9f05                	subw	a4,a4,s1
ffffffffc0201f80:	c298                	sw	a4,0(a3)
ffffffffc0201f82:	e68c                	sd	a1,8(a3)
ffffffffc0201f84:	c004                	sw	s1,0(s0)
ffffffffc0201f86:	00f93023          	sd	a5,0(s2)
ffffffffc0201f8a:	e20d                	bnez	a2,ffffffffc0201fac <slob_alloc.constprop.0+0xb0>
ffffffffc0201f8c:	60e2                	ld	ra,24(sp)
ffffffffc0201f8e:	8522                	mv	a0,s0
ffffffffc0201f90:	6442                	ld	s0,16(sp)
ffffffffc0201f92:	64a2                	ld	s1,8(sp)
ffffffffc0201f94:	6902                	ld	s2,0(sp)
ffffffffc0201f96:	6105                	addi	sp,sp,32
ffffffffc0201f98:	8082                	ret
ffffffffc0201f9a:	cd9fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f9e:	00093783          	ld	a5,0(s2)
ffffffffc0201fa2:	4605                	li	a2,1
ffffffffc0201fa4:	b7d1                	j	ffffffffc0201f68 <slob_alloc.constprop.0+0x6c>
ffffffffc0201fa6:	cc7fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201faa:	b74d                	j	ffffffffc0201f4c <slob_alloc.constprop.0+0x50>
ffffffffc0201fac:	cc1fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201fb0:	60e2                	ld	ra,24(sp)
ffffffffc0201fb2:	8522                	mv	a0,s0
ffffffffc0201fb4:	6442                	ld	s0,16(sp)
ffffffffc0201fb6:	64a2                	ld	s1,8(sp)
ffffffffc0201fb8:	6902                	ld	s2,0(sp)
ffffffffc0201fba:	6105                	addi	sp,sp,32
ffffffffc0201fbc:	8082                	ret
ffffffffc0201fbe:	6418                	ld	a4,8(s0)
ffffffffc0201fc0:	e798                	sd	a4,8(a5)
ffffffffc0201fc2:	b7d1                	j	ffffffffc0201f86 <slob_alloc.constprop.0+0x8a>
ffffffffc0201fc4:	caffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201fc8:	4605                	li	a2,1
ffffffffc0201fca:	bf99                	j	ffffffffc0201f20 <slob_alloc.constprop.0+0x24>
ffffffffc0201fcc:	843e                	mv	s0,a5
ffffffffc0201fce:	87b6                	mv	a5,a3
ffffffffc0201fd0:	b745                	j	ffffffffc0201f70 <slob_alloc.constprop.0+0x74>
ffffffffc0201fd2:	0000a697          	auipc	a3,0xa
ffffffffc0201fd6:	6f668693          	addi	a3,a3,1782 # ffffffffc020c6c8 <default_pmm_manager+0x70>
ffffffffc0201fda:	0000a617          	auipc	a2,0xa
ffffffffc0201fde:	b9e60613          	addi	a2,a2,-1122 # ffffffffc020bb78 <commands+0x210>
ffffffffc0201fe2:	06300593          	li	a1,99
ffffffffc0201fe6:	0000a517          	auipc	a0,0xa
ffffffffc0201fea:	70250513          	addi	a0,a0,1794 # ffffffffc020c6e8 <default_pmm_manager+0x90>
ffffffffc0201fee:	cb0fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201ff2 <kmalloc_init>:
ffffffffc0201ff2:	1141                	addi	sp,sp,-16
ffffffffc0201ff4:	0000a517          	auipc	a0,0xa
ffffffffc0201ff8:	70c50513          	addi	a0,a0,1804 # ffffffffc020c700 <default_pmm_manager+0xa8>
ffffffffc0201ffc:	e406                	sd	ra,8(sp)
ffffffffc0201ffe:	9a8fe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202002:	60a2                	ld	ra,8(sp)
ffffffffc0202004:	0000a517          	auipc	a0,0xa
ffffffffc0202008:	71450513          	addi	a0,a0,1812 # ffffffffc020c718 <default_pmm_manager+0xc0>
ffffffffc020200c:	0141                	addi	sp,sp,16
ffffffffc020200e:	998fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0202012 <kallocated>:
ffffffffc0202012:	4501                	li	a0,0
ffffffffc0202014:	8082                	ret

ffffffffc0202016 <kmalloc>:
ffffffffc0202016:	1101                	addi	sp,sp,-32
ffffffffc0202018:	e04a                	sd	s2,0(sp)
ffffffffc020201a:	6905                	lui	s2,0x1
ffffffffc020201c:	e822                	sd	s0,16(sp)
ffffffffc020201e:	ec06                	sd	ra,24(sp)
ffffffffc0202020:	e426                	sd	s1,8(sp)
ffffffffc0202022:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0202026:	842a                	mv	s0,a0
ffffffffc0202028:	04a7f963          	bgeu	a5,a0,ffffffffc020207a <kmalloc+0x64>
ffffffffc020202c:	4561                	li	a0,24
ffffffffc020202e:	ecfff0ef          	jal	ra,ffffffffc0201efc <slob_alloc.constprop.0>
ffffffffc0202032:	84aa                	mv	s1,a0
ffffffffc0202034:	c929                	beqz	a0,ffffffffc0202086 <kmalloc+0x70>
ffffffffc0202036:	0004079b          	sext.w	a5,s0
ffffffffc020203a:	4501                	li	a0,0
ffffffffc020203c:	00f95763          	bge	s2,a5,ffffffffc020204a <kmalloc+0x34>
ffffffffc0202040:	6705                	lui	a4,0x1
ffffffffc0202042:	8785                	srai	a5,a5,0x1
ffffffffc0202044:	2505                	addiw	a0,a0,1
ffffffffc0202046:	fef74ee3          	blt	a4,a5,ffffffffc0202042 <kmalloc+0x2c>
ffffffffc020204a:	c088                	sw	a0,0(s1)
ffffffffc020204c:	e4dff0ef          	jal	ra,ffffffffc0201e98 <__slob_get_free_pages.constprop.0>
ffffffffc0202050:	e488                	sd	a0,8(s1)
ffffffffc0202052:	842a                	mv	s0,a0
ffffffffc0202054:	c525                	beqz	a0,ffffffffc02020bc <kmalloc+0xa6>
ffffffffc0202056:	100027f3          	csrr	a5,sstatus
ffffffffc020205a:	8b89                	andi	a5,a5,2
ffffffffc020205c:	ef8d                	bnez	a5,ffffffffc0202096 <kmalloc+0x80>
ffffffffc020205e:	00095797          	auipc	a5,0x95
ffffffffc0202062:	82a78793          	addi	a5,a5,-2006 # ffffffffc0296888 <bigblocks>
ffffffffc0202066:	6398                	ld	a4,0(a5)
ffffffffc0202068:	e384                	sd	s1,0(a5)
ffffffffc020206a:	e898                	sd	a4,16(s1)
ffffffffc020206c:	60e2                	ld	ra,24(sp)
ffffffffc020206e:	8522                	mv	a0,s0
ffffffffc0202070:	6442                	ld	s0,16(sp)
ffffffffc0202072:	64a2                	ld	s1,8(sp)
ffffffffc0202074:	6902                	ld	s2,0(sp)
ffffffffc0202076:	6105                	addi	sp,sp,32
ffffffffc0202078:	8082                	ret
ffffffffc020207a:	0541                	addi	a0,a0,16
ffffffffc020207c:	e81ff0ef          	jal	ra,ffffffffc0201efc <slob_alloc.constprop.0>
ffffffffc0202080:	01050413          	addi	s0,a0,16
ffffffffc0202084:	f565                	bnez	a0,ffffffffc020206c <kmalloc+0x56>
ffffffffc0202086:	4401                	li	s0,0
ffffffffc0202088:	60e2                	ld	ra,24(sp)
ffffffffc020208a:	8522                	mv	a0,s0
ffffffffc020208c:	6442                	ld	s0,16(sp)
ffffffffc020208e:	64a2                	ld	s1,8(sp)
ffffffffc0202090:	6902                	ld	s2,0(sp)
ffffffffc0202092:	6105                	addi	sp,sp,32
ffffffffc0202094:	8082                	ret
ffffffffc0202096:	bddfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020209a:	00094797          	auipc	a5,0x94
ffffffffc020209e:	7ee78793          	addi	a5,a5,2030 # ffffffffc0296888 <bigblocks>
ffffffffc02020a2:	6398                	ld	a4,0(a5)
ffffffffc02020a4:	e384                	sd	s1,0(a5)
ffffffffc02020a6:	e898                	sd	a4,16(s1)
ffffffffc02020a8:	bc5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020ac:	6480                	ld	s0,8(s1)
ffffffffc02020ae:	60e2                	ld	ra,24(sp)
ffffffffc02020b0:	64a2                	ld	s1,8(sp)
ffffffffc02020b2:	8522                	mv	a0,s0
ffffffffc02020b4:	6442                	ld	s0,16(sp)
ffffffffc02020b6:	6902                	ld	s2,0(sp)
ffffffffc02020b8:	6105                	addi	sp,sp,32
ffffffffc02020ba:	8082                	ret
ffffffffc02020bc:	45e1                	li	a1,24
ffffffffc02020be:	8526                	mv	a0,s1
ffffffffc02020c0:	d25ff0ef          	jal	ra,ffffffffc0201de4 <slob_free>
ffffffffc02020c4:	b765                	j	ffffffffc020206c <kmalloc+0x56>

ffffffffc02020c6 <kfree>:
ffffffffc02020c6:	c169                	beqz	a0,ffffffffc0202188 <kfree+0xc2>
ffffffffc02020c8:	1101                	addi	sp,sp,-32
ffffffffc02020ca:	e822                	sd	s0,16(sp)
ffffffffc02020cc:	ec06                	sd	ra,24(sp)
ffffffffc02020ce:	e426                	sd	s1,8(sp)
ffffffffc02020d0:	03451793          	slli	a5,a0,0x34
ffffffffc02020d4:	842a                	mv	s0,a0
ffffffffc02020d6:	e3d9                	bnez	a5,ffffffffc020215c <kfree+0x96>
ffffffffc02020d8:	100027f3          	csrr	a5,sstatus
ffffffffc02020dc:	8b89                	andi	a5,a5,2
ffffffffc02020de:	e7d9                	bnez	a5,ffffffffc020216c <kfree+0xa6>
ffffffffc02020e0:	00094797          	auipc	a5,0x94
ffffffffc02020e4:	7a87b783          	ld	a5,1960(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020e8:	4601                	li	a2,0
ffffffffc02020ea:	cbad                	beqz	a5,ffffffffc020215c <kfree+0x96>
ffffffffc02020ec:	00094697          	auipc	a3,0x94
ffffffffc02020f0:	79c68693          	addi	a3,a3,1948 # ffffffffc0296888 <bigblocks>
ffffffffc02020f4:	a021                	j	ffffffffc02020fc <kfree+0x36>
ffffffffc02020f6:	01048693          	addi	a3,s1,16
ffffffffc02020fa:	c3a5                	beqz	a5,ffffffffc020215a <kfree+0x94>
ffffffffc02020fc:	6798                	ld	a4,8(a5)
ffffffffc02020fe:	84be                	mv	s1,a5
ffffffffc0202100:	6b9c                	ld	a5,16(a5)
ffffffffc0202102:	fe871ae3          	bne	a4,s0,ffffffffc02020f6 <kfree+0x30>
ffffffffc0202106:	e29c                	sd	a5,0(a3)
ffffffffc0202108:	ee2d                	bnez	a2,ffffffffc0202182 <kfree+0xbc>
ffffffffc020210a:	c02007b7          	lui	a5,0xc0200
ffffffffc020210e:	4098                	lw	a4,0(s1)
ffffffffc0202110:	08f46963          	bltu	s0,a5,ffffffffc02021a2 <kfree+0xdc>
ffffffffc0202114:	00094697          	auipc	a3,0x94
ffffffffc0202118:	7a46b683          	ld	a3,1956(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc020211c:	8c15                	sub	s0,s0,a3
ffffffffc020211e:	8031                	srli	s0,s0,0xc
ffffffffc0202120:	00094797          	auipc	a5,0x94
ffffffffc0202124:	7807b783          	ld	a5,1920(a5) # ffffffffc02968a0 <npage>
ffffffffc0202128:	06f47163          	bgeu	s0,a5,ffffffffc020218a <kfree+0xc4>
ffffffffc020212c:	0000d517          	auipc	a0,0xd
ffffffffc0202130:	77453503          	ld	a0,1908(a0) # ffffffffc020f8a0 <nbase>
ffffffffc0202134:	8c09                	sub	s0,s0,a0
ffffffffc0202136:	041a                	slli	s0,s0,0x6
ffffffffc0202138:	00094517          	auipc	a0,0x94
ffffffffc020213c:	77053503          	ld	a0,1904(a0) # ffffffffc02968a8 <pages>
ffffffffc0202140:	4585                	li	a1,1
ffffffffc0202142:	9522                	add	a0,a0,s0
ffffffffc0202144:	00e595bb          	sllw	a1,a1,a4
ffffffffc0202148:	0ea000ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc020214c:	6442                	ld	s0,16(sp)
ffffffffc020214e:	60e2                	ld	ra,24(sp)
ffffffffc0202150:	8526                	mv	a0,s1
ffffffffc0202152:	64a2                	ld	s1,8(sp)
ffffffffc0202154:	45e1                	li	a1,24
ffffffffc0202156:	6105                	addi	sp,sp,32
ffffffffc0202158:	b171                	j	ffffffffc0201de4 <slob_free>
ffffffffc020215a:	e20d                	bnez	a2,ffffffffc020217c <kfree+0xb6>
ffffffffc020215c:	ff040513          	addi	a0,s0,-16
ffffffffc0202160:	6442                	ld	s0,16(sp)
ffffffffc0202162:	60e2                	ld	ra,24(sp)
ffffffffc0202164:	64a2                	ld	s1,8(sp)
ffffffffc0202166:	4581                	li	a1,0
ffffffffc0202168:	6105                	addi	sp,sp,32
ffffffffc020216a:	b9ad                	j	ffffffffc0201de4 <slob_free>
ffffffffc020216c:	b07fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202170:	00094797          	auipc	a5,0x94
ffffffffc0202174:	7187b783          	ld	a5,1816(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202178:	4605                	li	a2,1
ffffffffc020217a:	fbad                	bnez	a5,ffffffffc02020ec <kfree+0x26>
ffffffffc020217c:	af1fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202180:	bff1                	j	ffffffffc020215c <kfree+0x96>
ffffffffc0202182:	aebfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202186:	b751                	j	ffffffffc020210a <kfree+0x44>
ffffffffc0202188:	8082                	ret
ffffffffc020218a:	0000a617          	auipc	a2,0xa
ffffffffc020218e:	5d660613          	addi	a2,a2,1494 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc0202192:	06900593          	li	a1,105
ffffffffc0202196:	0000a517          	auipc	a0,0xa
ffffffffc020219a:	52250513          	addi	a0,a0,1314 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc020219e:	b00fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02021a2:	86a2                	mv	a3,s0
ffffffffc02021a4:	0000a617          	auipc	a2,0xa
ffffffffc02021a8:	59460613          	addi	a2,a2,1428 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02021ac:	07700593          	li	a1,119
ffffffffc02021b0:	0000a517          	auipc	a0,0xa
ffffffffc02021b4:	50850513          	addi	a0,a0,1288 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02021b8:	ae6fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021bc <pa2page.part.0>:
ffffffffc02021bc:	1141                	addi	sp,sp,-16
ffffffffc02021be:	0000a617          	auipc	a2,0xa
ffffffffc02021c2:	5a260613          	addi	a2,a2,1442 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc02021c6:	06900593          	li	a1,105
ffffffffc02021ca:	0000a517          	auipc	a0,0xa
ffffffffc02021ce:	4ee50513          	addi	a0,a0,1262 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02021d2:	e406                	sd	ra,8(sp)
ffffffffc02021d4:	acafe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021d8 <pte2page.part.0>:
ffffffffc02021d8:	1141                	addi	sp,sp,-16
ffffffffc02021da:	0000a617          	auipc	a2,0xa
ffffffffc02021de:	5a660613          	addi	a2,a2,1446 # ffffffffc020c780 <default_pmm_manager+0x128>
ffffffffc02021e2:	07f00593          	li	a1,127
ffffffffc02021e6:	0000a517          	auipc	a0,0xa
ffffffffc02021ea:	4d250513          	addi	a0,a0,1234 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02021ee:	e406                	sd	ra,8(sp)
ffffffffc02021f0:	aaefe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02021f4 <alloc_pages>:
ffffffffc02021f4:	100027f3          	csrr	a5,sstatus
ffffffffc02021f8:	8b89                	andi	a5,a5,2
ffffffffc02021fa:	e799                	bnez	a5,ffffffffc0202208 <alloc_pages+0x14>
ffffffffc02021fc:	00094797          	auipc	a5,0x94
ffffffffc0202200:	6b47b783          	ld	a5,1716(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202204:	6f9c                	ld	a5,24(a5)
ffffffffc0202206:	8782                	jr	a5
ffffffffc0202208:	1141                	addi	sp,sp,-16
ffffffffc020220a:	e406                	sd	ra,8(sp)
ffffffffc020220c:	e022                	sd	s0,0(sp)
ffffffffc020220e:	842a                	mv	s0,a0
ffffffffc0202210:	a63fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202214:	00094797          	auipc	a5,0x94
ffffffffc0202218:	69c7b783          	ld	a5,1692(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020221c:	6f9c                	ld	a5,24(a5)
ffffffffc020221e:	8522                	mv	a0,s0
ffffffffc0202220:	9782                	jalr	a5
ffffffffc0202222:	842a                	mv	s0,a0
ffffffffc0202224:	a49fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202228:	60a2                	ld	ra,8(sp)
ffffffffc020222a:	8522                	mv	a0,s0
ffffffffc020222c:	6402                	ld	s0,0(sp)
ffffffffc020222e:	0141                	addi	sp,sp,16
ffffffffc0202230:	8082                	ret

ffffffffc0202232 <free_pages>:
ffffffffc0202232:	100027f3          	csrr	a5,sstatus
ffffffffc0202236:	8b89                	andi	a5,a5,2
ffffffffc0202238:	e799                	bnez	a5,ffffffffc0202246 <free_pages+0x14>
ffffffffc020223a:	00094797          	auipc	a5,0x94
ffffffffc020223e:	6767b783          	ld	a5,1654(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202242:	739c                	ld	a5,32(a5)
ffffffffc0202244:	8782                	jr	a5
ffffffffc0202246:	1101                	addi	sp,sp,-32
ffffffffc0202248:	ec06                	sd	ra,24(sp)
ffffffffc020224a:	e822                	sd	s0,16(sp)
ffffffffc020224c:	e426                	sd	s1,8(sp)
ffffffffc020224e:	842a                	mv	s0,a0
ffffffffc0202250:	84ae                	mv	s1,a1
ffffffffc0202252:	a21fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202256:	00094797          	auipc	a5,0x94
ffffffffc020225a:	65a7b783          	ld	a5,1626(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020225e:	739c                	ld	a5,32(a5)
ffffffffc0202260:	85a6                	mv	a1,s1
ffffffffc0202262:	8522                	mv	a0,s0
ffffffffc0202264:	9782                	jalr	a5
ffffffffc0202266:	6442                	ld	s0,16(sp)
ffffffffc0202268:	60e2                	ld	ra,24(sp)
ffffffffc020226a:	64a2                	ld	s1,8(sp)
ffffffffc020226c:	6105                	addi	sp,sp,32
ffffffffc020226e:	9fffe06f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc0202272 <nr_free_pages>:
ffffffffc0202272:	100027f3          	csrr	a5,sstatus
ffffffffc0202276:	8b89                	andi	a5,a5,2
ffffffffc0202278:	e799                	bnez	a5,ffffffffc0202286 <nr_free_pages+0x14>
ffffffffc020227a:	00094797          	auipc	a5,0x94
ffffffffc020227e:	6367b783          	ld	a5,1590(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202282:	779c                	ld	a5,40(a5)
ffffffffc0202284:	8782                	jr	a5
ffffffffc0202286:	1141                	addi	sp,sp,-16
ffffffffc0202288:	e406                	sd	ra,8(sp)
ffffffffc020228a:	e022                	sd	s0,0(sp)
ffffffffc020228c:	9e7fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202290:	00094797          	auipc	a5,0x94
ffffffffc0202294:	6207b783          	ld	a5,1568(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202298:	779c                	ld	a5,40(a5)
ffffffffc020229a:	9782                	jalr	a5
ffffffffc020229c:	842a                	mv	s0,a0
ffffffffc020229e:	9cffe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02022a2:	60a2                	ld	ra,8(sp)
ffffffffc02022a4:	8522                	mv	a0,s0
ffffffffc02022a6:	6402                	ld	s0,0(sp)
ffffffffc02022a8:	0141                	addi	sp,sp,16
ffffffffc02022aa:	8082                	ret

ffffffffc02022ac <get_pte>:
ffffffffc02022ac:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02022b0:	1ff7f793          	andi	a5,a5,511
ffffffffc02022b4:	7139                	addi	sp,sp,-64
ffffffffc02022b6:	078e                	slli	a5,a5,0x3
ffffffffc02022b8:	f426                	sd	s1,40(sp)
ffffffffc02022ba:	00f504b3          	add	s1,a0,a5
ffffffffc02022be:	6094                	ld	a3,0(s1)
ffffffffc02022c0:	f04a                	sd	s2,32(sp)
ffffffffc02022c2:	ec4e                	sd	s3,24(sp)
ffffffffc02022c4:	e852                	sd	s4,16(sp)
ffffffffc02022c6:	fc06                	sd	ra,56(sp)
ffffffffc02022c8:	f822                	sd	s0,48(sp)
ffffffffc02022ca:	e456                	sd	s5,8(sp)
ffffffffc02022cc:	e05a                	sd	s6,0(sp)
ffffffffc02022ce:	0016f793          	andi	a5,a3,1
ffffffffc02022d2:	892e                	mv	s2,a1
ffffffffc02022d4:	8a32                	mv	s4,a2
ffffffffc02022d6:	00094997          	auipc	s3,0x94
ffffffffc02022da:	5ca98993          	addi	s3,s3,1482 # ffffffffc02968a0 <npage>
ffffffffc02022de:	efbd                	bnez	a5,ffffffffc020235c <get_pte+0xb0>
ffffffffc02022e0:	14060c63          	beqz	a2,ffffffffc0202438 <get_pte+0x18c>
ffffffffc02022e4:	100027f3          	csrr	a5,sstatus
ffffffffc02022e8:	8b89                	andi	a5,a5,2
ffffffffc02022ea:	14079963          	bnez	a5,ffffffffc020243c <get_pte+0x190>
ffffffffc02022ee:	00094797          	auipc	a5,0x94
ffffffffc02022f2:	5c27b783          	ld	a5,1474(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02022f6:	6f9c                	ld	a5,24(a5)
ffffffffc02022f8:	4505                	li	a0,1
ffffffffc02022fa:	9782                	jalr	a5
ffffffffc02022fc:	842a                	mv	s0,a0
ffffffffc02022fe:	12040d63          	beqz	s0,ffffffffc0202438 <get_pte+0x18c>
ffffffffc0202302:	00094b17          	auipc	s6,0x94
ffffffffc0202306:	5a6b0b13          	addi	s6,s6,1446 # ffffffffc02968a8 <pages>
ffffffffc020230a:	000b3503          	ld	a0,0(s6)
ffffffffc020230e:	00080ab7          	lui	s5,0x80
ffffffffc0202312:	00094997          	auipc	s3,0x94
ffffffffc0202316:	58e98993          	addi	s3,s3,1422 # ffffffffc02968a0 <npage>
ffffffffc020231a:	40a40533          	sub	a0,s0,a0
ffffffffc020231e:	8519                	srai	a0,a0,0x6
ffffffffc0202320:	9556                	add	a0,a0,s5
ffffffffc0202322:	0009b703          	ld	a4,0(s3)
ffffffffc0202326:	00c51793          	slli	a5,a0,0xc
ffffffffc020232a:	4685                	li	a3,1
ffffffffc020232c:	c014                	sw	a3,0(s0)
ffffffffc020232e:	83b1                	srli	a5,a5,0xc
ffffffffc0202330:	0532                	slli	a0,a0,0xc
ffffffffc0202332:	16e7f763          	bgeu	a5,a4,ffffffffc02024a0 <get_pte+0x1f4>
ffffffffc0202336:	00094797          	auipc	a5,0x94
ffffffffc020233a:	5827b783          	ld	a5,1410(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc020233e:	6605                	lui	a2,0x1
ffffffffc0202340:	4581                	li	a1,0
ffffffffc0202342:	953e                	add	a0,a0,a5
ffffffffc0202344:	350090ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0202348:	000b3683          	ld	a3,0(s6)
ffffffffc020234c:	40d406b3          	sub	a3,s0,a3
ffffffffc0202350:	8699                	srai	a3,a3,0x6
ffffffffc0202352:	96d6                	add	a3,a3,s5
ffffffffc0202354:	06aa                	slli	a3,a3,0xa
ffffffffc0202356:	0116e693          	ori	a3,a3,17
ffffffffc020235a:	e094                	sd	a3,0(s1)
ffffffffc020235c:	77fd                	lui	a5,0xfffff
ffffffffc020235e:	068a                	slli	a3,a3,0x2
ffffffffc0202360:	0009b703          	ld	a4,0(s3)
ffffffffc0202364:	8efd                	and	a3,a3,a5
ffffffffc0202366:	00c6d793          	srli	a5,a3,0xc
ffffffffc020236a:	10e7ff63          	bgeu	a5,a4,ffffffffc0202488 <get_pte+0x1dc>
ffffffffc020236e:	00094a97          	auipc	s5,0x94
ffffffffc0202372:	54aa8a93          	addi	s5,s5,1354 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202376:	000ab403          	ld	s0,0(s5)
ffffffffc020237a:	01595793          	srli	a5,s2,0x15
ffffffffc020237e:	1ff7f793          	andi	a5,a5,511
ffffffffc0202382:	96a2                	add	a3,a3,s0
ffffffffc0202384:	00379413          	slli	s0,a5,0x3
ffffffffc0202388:	9436                	add	s0,s0,a3
ffffffffc020238a:	6014                	ld	a3,0(s0)
ffffffffc020238c:	0016f793          	andi	a5,a3,1
ffffffffc0202390:	ebad                	bnez	a5,ffffffffc0202402 <get_pte+0x156>
ffffffffc0202392:	0a0a0363          	beqz	s4,ffffffffc0202438 <get_pte+0x18c>
ffffffffc0202396:	100027f3          	csrr	a5,sstatus
ffffffffc020239a:	8b89                	andi	a5,a5,2
ffffffffc020239c:	efcd                	bnez	a5,ffffffffc0202456 <get_pte+0x1aa>
ffffffffc020239e:	00094797          	auipc	a5,0x94
ffffffffc02023a2:	5127b783          	ld	a5,1298(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023a6:	6f9c                	ld	a5,24(a5)
ffffffffc02023a8:	4505                	li	a0,1
ffffffffc02023aa:	9782                	jalr	a5
ffffffffc02023ac:	84aa                	mv	s1,a0
ffffffffc02023ae:	c4c9                	beqz	s1,ffffffffc0202438 <get_pte+0x18c>
ffffffffc02023b0:	00094b17          	auipc	s6,0x94
ffffffffc02023b4:	4f8b0b13          	addi	s6,s6,1272 # ffffffffc02968a8 <pages>
ffffffffc02023b8:	000b3503          	ld	a0,0(s6)
ffffffffc02023bc:	00080a37          	lui	s4,0x80
ffffffffc02023c0:	0009b703          	ld	a4,0(s3)
ffffffffc02023c4:	40a48533          	sub	a0,s1,a0
ffffffffc02023c8:	8519                	srai	a0,a0,0x6
ffffffffc02023ca:	9552                	add	a0,a0,s4
ffffffffc02023cc:	00c51793          	slli	a5,a0,0xc
ffffffffc02023d0:	4685                	li	a3,1
ffffffffc02023d2:	c094                	sw	a3,0(s1)
ffffffffc02023d4:	83b1                	srli	a5,a5,0xc
ffffffffc02023d6:	0532                	slli	a0,a0,0xc
ffffffffc02023d8:	0ee7f163          	bgeu	a5,a4,ffffffffc02024ba <get_pte+0x20e>
ffffffffc02023dc:	000ab783          	ld	a5,0(s5)
ffffffffc02023e0:	6605                	lui	a2,0x1
ffffffffc02023e2:	4581                	li	a1,0
ffffffffc02023e4:	953e                	add	a0,a0,a5
ffffffffc02023e6:	2ae090ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc02023ea:	000b3683          	ld	a3,0(s6)
ffffffffc02023ee:	40d486b3          	sub	a3,s1,a3
ffffffffc02023f2:	8699                	srai	a3,a3,0x6
ffffffffc02023f4:	96d2                	add	a3,a3,s4
ffffffffc02023f6:	06aa                	slli	a3,a3,0xa
ffffffffc02023f8:	0116e693          	ori	a3,a3,17
ffffffffc02023fc:	e014                	sd	a3,0(s0)
ffffffffc02023fe:	0009b703          	ld	a4,0(s3)
ffffffffc0202402:	068a                	slli	a3,a3,0x2
ffffffffc0202404:	757d                	lui	a0,0xfffff
ffffffffc0202406:	8ee9                	and	a3,a3,a0
ffffffffc0202408:	00c6d793          	srli	a5,a3,0xc
ffffffffc020240c:	06e7f263          	bgeu	a5,a4,ffffffffc0202470 <get_pte+0x1c4>
ffffffffc0202410:	000ab503          	ld	a0,0(s5)
ffffffffc0202414:	00c95913          	srli	s2,s2,0xc
ffffffffc0202418:	1ff97913          	andi	s2,s2,511
ffffffffc020241c:	96aa                	add	a3,a3,a0
ffffffffc020241e:	00391513          	slli	a0,s2,0x3
ffffffffc0202422:	9536                	add	a0,a0,a3
ffffffffc0202424:	70e2                	ld	ra,56(sp)
ffffffffc0202426:	7442                	ld	s0,48(sp)
ffffffffc0202428:	74a2                	ld	s1,40(sp)
ffffffffc020242a:	7902                	ld	s2,32(sp)
ffffffffc020242c:	69e2                	ld	s3,24(sp)
ffffffffc020242e:	6a42                	ld	s4,16(sp)
ffffffffc0202430:	6aa2                	ld	s5,8(sp)
ffffffffc0202432:	6b02                	ld	s6,0(sp)
ffffffffc0202434:	6121                	addi	sp,sp,64
ffffffffc0202436:	8082                	ret
ffffffffc0202438:	4501                	li	a0,0
ffffffffc020243a:	b7ed                	j	ffffffffc0202424 <get_pte+0x178>
ffffffffc020243c:	837fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202440:	00094797          	auipc	a5,0x94
ffffffffc0202444:	4707b783          	ld	a5,1136(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202448:	6f9c                	ld	a5,24(a5)
ffffffffc020244a:	4505                	li	a0,1
ffffffffc020244c:	9782                	jalr	a5
ffffffffc020244e:	842a                	mv	s0,a0
ffffffffc0202450:	81dfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202454:	b56d                	j	ffffffffc02022fe <get_pte+0x52>
ffffffffc0202456:	81dfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020245a:	00094797          	auipc	a5,0x94
ffffffffc020245e:	4567b783          	ld	a5,1110(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202462:	6f9c                	ld	a5,24(a5)
ffffffffc0202464:	4505                	li	a0,1
ffffffffc0202466:	9782                	jalr	a5
ffffffffc0202468:	84aa                	mv	s1,a0
ffffffffc020246a:	803fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020246e:	b781                	j	ffffffffc02023ae <get_pte+0x102>
ffffffffc0202470:	0000a617          	auipc	a2,0xa
ffffffffc0202474:	22060613          	addi	a2,a2,544 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0202478:	13200593          	li	a1,306
ffffffffc020247c:	0000a517          	auipc	a0,0xa
ffffffffc0202480:	32c50513          	addi	a0,a0,812 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0202484:	81afe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202488:	0000a617          	auipc	a2,0xa
ffffffffc020248c:	20860613          	addi	a2,a2,520 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0202490:	12500593          	li	a1,293
ffffffffc0202494:	0000a517          	auipc	a0,0xa
ffffffffc0202498:	31450513          	addi	a0,a0,788 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020249c:	802fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024a0:	86aa                	mv	a3,a0
ffffffffc02024a2:	0000a617          	auipc	a2,0xa
ffffffffc02024a6:	1ee60613          	addi	a2,a2,494 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc02024aa:	12100593          	li	a1,289
ffffffffc02024ae:	0000a517          	auipc	a0,0xa
ffffffffc02024b2:	2fa50513          	addi	a0,a0,762 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02024b6:	fe9fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024ba:	86aa                	mv	a3,a0
ffffffffc02024bc:	0000a617          	auipc	a2,0xa
ffffffffc02024c0:	1d460613          	addi	a2,a2,468 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc02024c4:	12f00593          	li	a1,303
ffffffffc02024c8:	0000a517          	auipc	a0,0xa
ffffffffc02024cc:	2e050513          	addi	a0,a0,736 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02024d0:	fcffd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02024d4 <boot_map_segment>:
ffffffffc02024d4:	6785                	lui	a5,0x1
ffffffffc02024d6:	7139                	addi	sp,sp,-64
ffffffffc02024d8:	00d5c833          	xor	a6,a1,a3
ffffffffc02024dc:	17fd                	addi	a5,a5,-1
ffffffffc02024de:	fc06                	sd	ra,56(sp)
ffffffffc02024e0:	f822                	sd	s0,48(sp)
ffffffffc02024e2:	f426                	sd	s1,40(sp)
ffffffffc02024e4:	f04a                	sd	s2,32(sp)
ffffffffc02024e6:	ec4e                	sd	s3,24(sp)
ffffffffc02024e8:	e852                	sd	s4,16(sp)
ffffffffc02024ea:	e456                	sd	s5,8(sp)
ffffffffc02024ec:	00f87833          	and	a6,a6,a5
ffffffffc02024f0:	08081563          	bnez	a6,ffffffffc020257a <boot_map_segment+0xa6>
ffffffffc02024f4:	00f5f4b3          	and	s1,a1,a5
ffffffffc02024f8:	963e                	add	a2,a2,a5
ffffffffc02024fa:	94b2                	add	s1,s1,a2
ffffffffc02024fc:	797d                	lui	s2,0xfffff
ffffffffc02024fe:	80b1                	srli	s1,s1,0xc
ffffffffc0202500:	0125f5b3          	and	a1,a1,s2
ffffffffc0202504:	0126f6b3          	and	a3,a3,s2
ffffffffc0202508:	c0a1                	beqz	s1,ffffffffc0202548 <boot_map_segment+0x74>
ffffffffc020250a:	00176713          	ori	a4,a4,1
ffffffffc020250e:	04b2                	slli	s1,s1,0xc
ffffffffc0202510:	02071993          	slli	s3,a4,0x20
ffffffffc0202514:	8a2a                	mv	s4,a0
ffffffffc0202516:	842e                	mv	s0,a1
ffffffffc0202518:	94ae                	add	s1,s1,a1
ffffffffc020251a:	40b68933          	sub	s2,a3,a1
ffffffffc020251e:	0209d993          	srli	s3,s3,0x20
ffffffffc0202522:	6a85                	lui	s5,0x1
ffffffffc0202524:	4605                	li	a2,1
ffffffffc0202526:	85a2                	mv	a1,s0
ffffffffc0202528:	8552                	mv	a0,s4
ffffffffc020252a:	d83ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc020252e:	008907b3          	add	a5,s2,s0
ffffffffc0202532:	c505                	beqz	a0,ffffffffc020255a <boot_map_segment+0x86>
ffffffffc0202534:	83b1                	srli	a5,a5,0xc
ffffffffc0202536:	07aa                	slli	a5,a5,0xa
ffffffffc0202538:	0137e7b3          	or	a5,a5,s3
ffffffffc020253c:	0017e793          	ori	a5,a5,1
ffffffffc0202540:	e11c                	sd	a5,0(a0)
ffffffffc0202542:	9456                	add	s0,s0,s5
ffffffffc0202544:	fe8490e3          	bne	s1,s0,ffffffffc0202524 <boot_map_segment+0x50>
ffffffffc0202548:	70e2                	ld	ra,56(sp)
ffffffffc020254a:	7442                	ld	s0,48(sp)
ffffffffc020254c:	74a2                	ld	s1,40(sp)
ffffffffc020254e:	7902                	ld	s2,32(sp)
ffffffffc0202550:	69e2                	ld	s3,24(sp)
ffffffffc0202552:	6a42                	ld	s4,16(sp)
ffffffffc0202554:	6aa2                	ld	s5,8(sp)
ffffffffc0202556:	6121                	addi	sp,sp,64
ffffffffc0202558:	8082                	ret
ffffffffc020255a:	0000a697          	auipc	a3,0xa
ffffffffc020255e:	27668693          	addi	a3,a3,630 # ffffffffc020c7d0 <default_pmm_manager+0x178>
ffffffffc0202562:	00009617          	auipc	a2,0x9
ffffffffc0202566:	61660613          	addi	a2,a2,1558 # ffffffffc020bb78 <commands+0x210>
ffffffffc020256a:	09c00593          	li	a1,156
ffffffffc020256e:	0000a517          	auipc	a0,0xa
ffffffffc0202572:	23a50513          	addi	a0,a0,570 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0202576:	f29fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020257a:	0000a697          	auipc	a3,0xa
ffffffffc020257e:	23e68693          	addi	a3,a3,574 # ffffffffc020c7b8 <default_pmm_manager+0x160>
ffffffffc0202582:	00009617          	auipc	a2,0x9
ffffffffc0202586:	5f660613          	addi	a2,a2,1526 # ffffffffc020bb78 <commands+0x210>
ffffffffc020258a:	09500593          	li	a1,149
ffffffffc020258e:	0000a517          	auipc	a0,0xa
ffffffffc0202592:	21a50513          	addi	a0,a0,538 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0202596:	f09fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020259a <get_page>:
ffffffffc020259a:	1141                	addi	sp,sp,-16
ffffffffc020259c:	e022                	sd	s0,0(sp)
ffffffffc020259e:	8432                	mv	s0,a2
ffffffffc02025a0:	4601                	li	a2,0
ffffffffc02025a2:	e406                	sd	ra,8(sp)
ffffffffc02025a4:	d09ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc02025a8:	c011                	beqz	s0,ffffffffc02025ac <get_page+0x12>
ffffffffc02025aa:	e008                	sd	a0,0(s0)
ffffffffc02025ac:	c511                	beqz	a0,ffffffffc02025b8 <get_page+0x1e>
ffffffffc02025ae:	611c                	ld	a5,0(a0)
ffffffffc02025b0:	4501                	li	a0,0
ffffffffc02025b2:	0017f713          	andi	a4,a5,1
ffffffffc02025b6:	e709                	bnez	a4,ffffffffc02025c0 <get_page+0x26>
ffffffffc02025b8:	60a2                	ld	ra,8(sp)
ffffffffc02025ba:	6402                	ld	s0,0(sp)
ffffffffc02025bc:	0141                	addi	sp,sp,16
ffffffffc02025be:	8082                	ret
ffffffffc02025c0:	078a                	slli	a5,a5,0x2
ffffffffc02025c2:	83b1                	srli	a5,a5,0xc
ffffffffc02025c4:	00094717          	auipc	a4,0x94
ffffffffc02025c8:	2dc73703          	ld	a4,732(a4) # ffffffffc02968a0 <npage>
ffffffffc02025cc:	00e7ff63          	bgeu	a5,a4,ffffffffc02025ea <get_page+0x50>
ffffffffc02025d0:	60a2                	ld	ra,8(sp)
ffffffffc02025d2:	6402                	ld	s0,0(sp)
ffffffffc02025d4:	fff80537          	lui	a0,0xfff80
ffffffffc02025d8:	97aa                	add	a5,a5,a0
ffffffffc02025da:	079a                	slli	a5,a5,0x6
ffffffffc02025dc:	00094517          	auipc	a0,0x94
ffffffffc02025e0:	2cc53503          	ld	a0,716(a0) # ffffffffc02968a8 <pages>
ffffffffc02025e4:	953e                	add	a0,a0,a5
ffffffffc02025e6:	0141                	addi	sp,sp,16
ffffffffc02025e8:	8082                	ret
ffffffffc02025ea:	bd3ff0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>

ffffffffc02025ee <unmap_range>:
ffffffffc02025ee:	7159                	addi	sp,sp,-112
ffffffffc02025f0:	00c5e7b3          	or	a5,a1,a2
ffffffffc02025f4:	f486                	sd	ra,104(sp)
ffffffffc02025f6:	f0a2                	sd	s0,96(sp)
ffffffffc02025f8:	eca6                	sd	s1,88(sp)
ffffffffc02025fa:	e8ca                	sd	s2,80(sp)
ffffffffc02025fc:	e4ce                	sd	s3,72(sp)
ffffffffc02025fe:	e0d2                	sd	s4,64(sp)
ffffffffc0202600:	fc56                	sd	s5,56(sp)
ffffffffc0202602:	f85a                	sd	s6,48(sp)
ffffffffc0202604:	f45e                	sd	s7,40(sp)
ffffffffc0202606:	f062                	sd	s8,32(sp)
ffffffffc0202608:	ec66                	sd	s9,24(sp)
ffffffffc020260a:	e86a                	sd	s10,16(sp)
ffffffffc020260c:	17d2                	slli	a5,a5,0x34
ffffffffc020260e:	e3ed                	bnez	a5,ffffffffc02026f0 <unmap_range+0x102>
ffffffffc0202610:	002007b7          	lui	a5,0x200
ffffffffc0202614:	842e                	mv	s0,a1
ffffffffc0202616:	0ef5ed63          	bltu	a1,a5,ffffffffc0202710 <unmap_range+0x122>
ffffffffc020261a:	8932                	mv	s2,a2
ffffffffc020261c:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202710 <unmap_range+0x122>
ffffffffc0202620:	4785                	li	a5,1
ffffffffc0202622:	07fe                	slli	a5,a5,0x1f
ffffffffc0202624:	0ec7e663          	bltu	a5,a2,ffffffffc0202710 <unmap_range+0x122>
ffffffffc0202628:	89aa                	mv	s3,a0
ffffffffc020262a:	6a05                	lui	s4,0x1
ffffffffc020262c:	00094c97          	auipc	s9,0x94
ffffffffc0202630:	274c8c93          	addi	s9,s9,628 # ffffffffc02968a0 <npage>
ffffffffc0202634:	00094c17          	auipc	s8,0x94
ffffffffc0202638:	274c0c13          	addi	s8,s8,628 # ffffffffc02968a8 <pages>
ffffffffc020263c:	fff80bb7          	lui	s7,0xfff80
ffffffffc0202640:	00094d17          	auipc	s10,0x94
ffffffffc0202644:	270d0d13          	addi	s10,s10,624 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202648:	00200b37          	lui	s6,0x200
ffffffffc020264c:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0202650:	4601                	li	a2,0
ffffffffc0202652:	85a2                	mv	a1,s0
ffffffffc0202654:	854e                	mv	a0,s3
ffffffffc0202656:	c57ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc020265a:	84aa                	mv	s1,a0
ffffffffc020265c:	cd29                	beqz	a0,ffffffffc02026b6 <unmap_range+0xc8>
ffffffffc020265e:	611c                	ld	a5,0(a0)
ffffffffc0202660:	e395                	bnez	a5,ffffffffc0202684 <unmap_range+0x96>
ffffffffc0202662:	9452                	add	s0,s0,s4
ffffffffc0202664:	ff2466e3          	bltu	s0,s2,ffffffffc0202650 <unmap_range+0x62>
ffffffffc0202668:	70a6                	ld	ra,104(sp)
ffffffffc020266a:	7406                	ld	s0,96(sp)
ffffffffc020266c:	64e6                	ld	s1,88(sp)
ffffffffc020266e:	6946                	ld	s2,80(sp)
ffffffffc0202670:	69a6                	ld	s3,72(sp)
ffffffffc0202672:	6a06                	ld	s4,64(sp)
ffffffffc0202674:	7ae2                	ld	s5,56(sp)
ffffffffc0202676:	7b42                	ld	s6,48(sp)
ffffffffc0202678:	7ba2                	ld	s7,40(sp)
ffffffffc020267a:	7c02                	ld	s8,32(sp)
ffffffffc020267c:	6ce2                	ld	s9,24(sp)
ffffffffc020267e:	6d42                	ld	s10,16(sp)
ffffffffc0202680:	6165                	addi	sp,sp,112
ffffffffc0202682:	8082                	ret
ffffffffc0202684:	0017f713          	andi	a4,a5,1
ffffffffc0202688:	df69                	beqz	a4,ffffffffc0202662 <unmap_range+0x74>
ffffffffc020268a:	000cb703          	ld	a4,0(s9)
ffffffffc020268e:	078a                	slli	a5,a5,0x2
ffffffffc0202690:	83b1                	srli	a5,a5,0xc
ffffffffc0202692:	08e7ff63          	bgeu	a5,a4,ffffffffc0202730 <unmap_range+0x142>
ffffffffc0202696:	000c3503          	ld	a0,0(s8)
ffffffffc020269a:	97de                	add	a5,a5,s7
ffffffffc020269c:	079a                	slli	a5,a5,0x6
ffffffffc020269e:	953e                	add	a0,a0,a5
ffffffffc02026a0:	411c                	lw	a5,0(a0)
ffffffffc02026a2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02026a6:	c118                	sw	a4,0(a0)
ffffffffc02026a8:	cf11                	beqz	a4,ffffffffc02026c4 <unmap_range+0xd6>
ffffffffc02026aa:	0004b023          	sd	zero,0(s1)
ffffffffc02026ae:	12040073          	sfence.vma	s0
ffffffffc02026b2:	9452                	add	s0,s0,s4
ffffffffc02026b4:	bf45                	j	ffffffffc0202664 <unmap_range+0x76>
ffffffffc02026b6:	945a                	add	s0,s0,s6
ffffffffc02026b8:	01547433          	and	s0,s0,s5
ffffffffc02026bc:	d455                	beqz	s0,ffffffffc0202668 <unmap_range+0x7a>
ffffffffc02026be:	f92469e3          	bltu	s0,s2,ffffffffc0202650 <unmap_range+0x62>
ffffffffc02026c2:	b75d                	j	ffffffffc0202668 <unmap_range+0x7a>
ffffffffc02026c4:	100027f3          	csrr	a5,sstatus
ffffffffc02026c8:	8b89                	andi	a5,a5,2
ffffffffc02026ca:	e799                	bnez	a5,ffffffffc02026d8 <unmap_range+0xea>
ffffffffc02026cc:	000d3783          	ld	a5,0(s10)
ffffffffc02026d0:	4585                	li	a1,1
ffffffffc02026d2:	739c                	ld	a5,32(a5)
ffffffffc02026d4:	9782                	jalr	a5
ffffffffc02026d6:	bfd1                	j	ffffffffc02026aa <unmap_range+0xbc>
ffffffffc02026d8:	e42a                	sd	a0,8(sp)
ffffffffc02026da:	d98fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02026de:	000d3783          	ld	a5,0(s10)
ffffffffc02026e2:	6522                	ld	a0,8(sp)
ffffffffc02026e4:	4585                	li	a1,1
ffffffffc02026e6:	739c                	ld	a5,32(a5)
ffffffffc02026e8:	9782                	jalr	a5
ffffffffc02026ea:	d82fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02026ee:	bf75                	j	ffffffffc02026aa <unmap_range+0xbc>
ffffffffc02026f0:	0000a697          	auipc	a3,0xa
ffffffffc02026f4:	0f068693          	addi	a3,a3,240 # ffffffffc020c7e0 <default_pmm_manager+0x188>
ffffffffc02026f8:	00009617          	auipc	a2,0x9
ffffffffc02026fc:	48060613          	addi	a2,a2,1152 # ffffffffc020bb78 <commands+0x210>
ffffffffc0202700:	15a00593          	li	a1,346
ffffffffc0202704:	0000a517          	auipc	a0,0xa
ffffffffc0202708:	0a450513          	addi	a0,a0,164 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020270c:	d93fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202710:	0000a697          	auipc	a3,0xa
ffffffffc0202714:	10068693          	addi	a3,a3,256 # ffffffffc020c810 <default_pmm_manager+0x1b8>
ffffffffc0202718:	00009617          	auipc	a2,0x9
ffffffffc020271c:	46060613          	addi	a2,a2,1120 # ffffffffc020bb78 <commands+0x210>
ffffffffc0202720:	15b00593          	li	a1,347
ffffffffc0202724:	0000a517          	auipc	a0,0xa
ffffffffc0202728:	08450513          	addi	a0,a0,132 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020272c:	d73fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202730:	a8dff0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>

ffffffffc0202734 <exit_range>:
ffffffffc0202734:	7119                	addi	sp,sp,-128
ffffffffc0202736:	00c5e7b3          	or	a5,a1,a2
ffffffffc020273a:	fc86                	sd	ra,120(sp)
ffffffffc020273c:	f8a2                	sd	s0,112(sp)
ffffffffc020273e:	f4a6                	sd	s1,104(sp)
ffffffffc0202740:	f0ca                	sd	s2,96(sp)
ffffffffc0202742:	ecce                	sd	s3,88(sp)
ffffffffc0202744:	e8d2                	sd	s4,80(sp)
ffffffffc0202746:	e4d6                	sd	s5,72(sp)
ffffffffc0202748:	e0da                	sd	s6,64(sp)
ffffffffc020274a:	fc5e                	sd	s7,56(sp)
ffffffffc020274c:	f862                	sd	s8,48(sp)
ffffffffc020274e:	f466                	sd	s9,40(sp)
ffffffffc0202750:	f06a                	sd	s10,32(sp)
ffffffffc0202752:	ec6e                	sd	s11,24(sp)
ffffffffc0202754:	17d2                	slli	a5,a5,0x34
ffffffffc0202756:	20079a63          	bnez	a5,ffffffffc020296a <exit_range+0x236>
ffffffffc020275a:	002007b7          	lui	a5,0x200
ffffffffc020275e:	24f5e463          	bltu	a1,a5,ffffffffc02029a6 <exit_range+0x272>
ffffffffc0202762:	8ab2                	mv	s5,a2
ffffffffc0202764:	24c5f163          	bgeu	a1,a2,ffffffffc02029a6 <exit_range+0x272>
ffffffffc0202768:	4785                	li	a5,1
ffffffffc020276a:	07fe                	slli	a5,a5,0x1f
ffffffffc020276c:	22c7ed63          	bltu	a5,a2,ffffffffc02029a6 <exit_range+0x272>
ffffffffc0202770:	c00009b7          	lui	s3,0xc0000
ffffffffc0202774:	0135f9b3          	and	s3,a1,s3
ffffffffc0202778:	ffe00937          	lui	s2,0xffe00
ffffffffc020277c:	400007b7          	lui	a5,0x40000
ffffffffc0202780:	5cfd                	li	s9,-1
ffffffffc0202782:	8c2a                	mv	s8,a0
ffffffffc0202784:	0125f933          	and	s2,a1,s2
ffffffffc0202788:	99be                	add	s3,s3,a5
ffffffffc020278a:	00094d17          	auipc	s10,0x94
ffffffffc020278e:	116d0d13          	addi	s10,s10,278 # ffffffffc02968a0 <npage>
ffffffffc0202792:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0202796:	00094717          	auipc	a4,0x94
ffffffffc020279a:	11270713          	addi	a4,a4,274 # ffffffffc02968a8 <pages>
ffffffffc020279e:	00094d97          	auipc	s11,0x94
ffffffffc02027a2:	112d8d93          	addi	s11,s11,274 # ffffffffc02968b0 <pmm_manager>
ffffffffc02027a6:	c0000437          	lui	s0,0xc0000
ffffffffc02027aa:	944e                	add	s0,s0,s3
ffffffffc02027ac:	8079                	srli	s0,s0,0x1e
ffffffffc02027ae:	1ff47413          	andi	s0,s0,511
ffffffffc02027b2:	040e                	slli	s0,s0,0x3
ffffffffc02027b4:	9462                	add	s0,s0,s8
ffffffffc02027b6:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc02027ba:	001a7793          	andi	a5,s4,1
ffffffffc02027be:	eb99                	bnez	a5,ffffffffc02027d4 <exit_range+0xa0>
ffffffffc02027c0:	12098463          	beqz	s3,ffffffffc02028e8 <exit_range+0x1b4>
ffffffffc02027c4:	400007b7          	lui	a5,0x40000
ffffffffc02027c8:	97ce                	add	a5,a5,s3
ffffffffc02027ca:	894e                	mv	s2,s3
ffffffffc02027cc:	1159fe63          	bgeu	s3,s5,ffffffffc02028e8 <exit_range+0x1b4>
ffffffffc02027d0:	89be                	mv	s3,a5
ffffffffc02027d2:	bfd1                	j	ffffffffc02027a6 <exit_range+0x72>
ffffffffc02027d4:	000d3783          	ld	a5,0(s10)
ffffffffc02027d8:	0a0a                	slli	s4,s4,0x2
ffffffffc02027da:	00ca5a13          	srli	s4,s4,0xc
ffffffffc02027de:	1cfa7263          	bgeu	s4,a5,ffffffffc02029a2 <exit_range+0x26e>
ffffffffc02027e2:	fff80637          	lui	a2,0xfff80
ffffffffc02027e6:	9652                	add	a2,a2,s4
ffffffffc02027e8:	000806b7          	lui	a3,0x80
ffffffffc02027ec:	96b2                	add	a3,a3,a2
ffffffffc02027ee:	0196f5b3          	and	a1,a3,s9
ffffffffc02027f2:	061a                	slli	a2,a2,0x6
ffffffffc02027f4:	06b2                	slli	a3,a3,0xc
ffffffffc02027f6:	18f5fa63          	bgeu	a1,a5,ffffffffc020298a <exit_range+0x256>
ffffffffc02027fa:	00094817          	auipc	a6,0x94
ffffffffc02027fe:	0be80813          	addi	a6,a6,190 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202802:	00083b03          	ld	s6,0(a6)
ffffffffc0202806:	4b85                	li	s7,1
ffffffffc0202808:	fff80e37          	lui	t3,0xfff80
ffffffffc020280c:	9b36                	add	s6,s6,a3
ffffffffc020280e:	00080337          	lui	t1,0x80
ffffffffc0202812:	6885                	lui	a7,0x1
ffffffffc0202814:	a819                	j	ffffffffc020282a <exit_range+0xf6>
ffffffffc0202816:	4b81                	li	s7,0
ffffffffc0202818:	002007b7          	lui	a5,0x200
ffffffffc020281c:	993e                	add	s2,s2,a5
ffffffffc020281e:	08090c63          	beqz	s2,ffffffffc02028b6 <exit_range+0x182>
ffffffffc0202822:	09397a63          	bgeu	s2,s3,ffffffffc02028b6 <exit_range+0x182>
ffffffffc0202826:	0f597063          	bgeu	s2,s5,ffffffffc0202906 <exit_range+0x1d2>
ffffffffc020282a:	01595493          	srli	s1,s2,0x15
ffffffffc020282e:	1ff4f493          	andi	s1,s1,511
ffffffffc0202832:	048e                	slli	s1,s1,0x3
ffffffffc0202834:	94da                	add	s1,s1,s6
ffffffffc0202836:	609c                	ld	a5,0(s1)
ffffffffc0202838:	0017f693          	andi	a3,a5,1
ffffffffc020283c:	dee9                	beqz	a3,ffffffffc0202816 <exit_range+0xe2>
ffffffffc020283e:	000d3583          	ld	a1,0(s10)
ffffffffc0202842:	078a                	slli	a5,a5,0x2
ffffffffc0202844:	83b1                	srli	a5,a5,0xc
ffffffffc0202846:	14b7fe63          	bgeu	a5,a1,ffffffffc02029a2 <exit_range+0x26e>
ffffffffc020284a:	97f2                	add	a5,a5,t3
ffffffffc020284c:	006786b3          	add	a3,a5,t1
ffffffffc0202850:	0196feb3          	and	t4,a3,s9
ffffffffc0202854:	00679513          	slli	a0,a5,0x6
ffffffffc0202858:	06b2                	slli	a3,a3,0xc
ffffffffc020285a:	12bef863          	bgeu	t4,a1,ffffffffc020298a <exit_range+0x256>
ffffffffc020285e:	00083783          	ld	a5,0(a6)
ffffffffc0202862:	96be                	add	a3,a3,a5
ffffffffc0202864:	011685b3          	add	a1,a3,a7
ffffffffc0202868:	629c                	ld	a5,0(a3)
ffffffffc020286a:	8b85                	andi	a5,a5,1
ffffffffc020286c:	f7d5                	bnez	a5,ffffffffc0202818 <exit_range+0xe4>
ffffffffc020286e:	06a1                	addi	a3,a3,8
ffffffffc0202870:	fed59ce3          	bne	a1,a3,ffffffffc0202868 <exit_range+0x134>
ffffffffc0202874:	631c                	ld	a5,0(a4)
ffffffffc0202876:	953e                	add	a0,a0,a5
ffffffffc0202878:	100027f3          	csrr	a5,sstatus
ffffffffc020287c:	8b89                	andi	a5,a5,2
ffffffffc020287e:	e7d9                	bnez	a5,ffffffffc020290c <exit_range+0x1d8>
ffffffffc0202880:	000db783          	ld	a5,0(s11)
ffffffffc0202884:	4585                	li	a1,1
ffffffffc0202886:	e032                	sd	a2,0(sp)
ffffffffc0202888:	739c                	ld	a5,32(a5)
ffffffffc020288a:	9782                	jalr	a5
ffffffffc020288c:	6602                	ld	a2,0(sp)
ffffffffc020288e:	00094817          	auipc	a6,0x94
ffffffffc0202892:	02a80813          	addi	a6,a6,42 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202896:	fff80e37          	lui	t3,0xfff80
ffffffffc020289a:	00080337          	lui	t1,0x80
ffffffffc020289e:	6885                	lui	a7,0x1
ffffffffc02028a0:	00094717          	auipc	a4,0x94
ffffffffc02028a4:	00870713          	addi	a4,a4,8 # ffffffffc02968a8 <pages>
ffffffffc02028a8:	0004b023          	sd	zero,0(s1)
ffffffffc02028ac:	002007b7          	lui	a5,0x200
ffffffffc02028b0:	993e                	add	s2,s2,a5
ffffffffc02028b2:	f60918e3          	bnez	s2,ffffffffc0202822 <exit_range+0xee>
ffffffffc02028b6:	f00b85e3          	beqz	s7,ffffffffc02027c0 <exit_range+0x8c>
ffffffffc02028ba:	000d3783          	ld	a5,0(s10)
ffffffffc02028be:	0efa7263          	bgeu	s4,a5,ffffffffc02029a2 <exit_range+0x26e>
ffffffffc02028c2:	6308                	ld	a0,0(a4)
ffffffffc02028c4:	9532                	add	a0,a0,a2
ffffffffc02028c6:	100027f3          	csrr	a5,sstatus
ffffffffc02028ca:	8b89                	andi	a5,a5,2
ffffffffc02028cc:	efad                	bnez	a5,ffffffffc0202946 <exit_range+0x212>
ffffffffc02028ce:	000db783          	ld	a5,0(s11)
ffffffffc02028d2:	4585                	li	a1,1
ffffffffc02028d4:	739c                	ld	a5,32(a5)
ffffffffc02028d6:	9782                	jalr	a5
ffffffffc02028d8:	00094717          	auipc	a4,0x94
ffffffffc02028dc:	fd070713          	addi	a4,a4,-48 # ffffffffc02968a8 <pages>
ffffffffc02028e0:	00043023          	sd	zero,0(s0)
ffffffffc02028e4:	ee0990e3          	bnez	s3,ffffffffc02027c4 <exit_range+0x90>
ffffffffc02028e8:	70e6                	ld	ra,120(sp)
ffffffffc02028ea:	7446                	ld	s0,112(sp)
ffffffffc02028ec:	74a6                	ld	s1,104(sp)
ffffffffc02028ee:	7906                	ld	s2,96(sp)
ffffffffc02028f0:	69e6                	ld	s3,88(sp)
ffffffffc02028f2:	6a46                	ld	s4,80(sp)
ffffffffc02028f4:	6aa6                	ld	s5,72(sp)
ffffffffc02028f6:	6b06                	ld	s6,64(sp)
ffffffffc02028f8:	7be2                	ld	s7,56(sp)
ffffffffc02028fa:	7c42                	ld	s8,48(sp)
ffffffffc02028fc:	7ca2                	ld	s9,40(sp)
ffffffffc02028fe:	7d02                	ld	s10,32(sp)
ffffffffc0202900:	6de2                	ld	s11,24(sp)
ffffffffc0202902:	6109                	addi	sp,sp,128
ffffffffc0202904:	8082                	ret
ffffffffc0202906:	ea0b8fe3          	beqz	s7,ffffffffc02027c4 <exit_range+0x90>
ffffffffc020290a:	bf45                	j	ffffffffc02028ba <exit_range+0x186>
ffffffffc020290c:	e032                	sd	a2,0(sp)
ffffffffc020290e:	e42a                	sd	a0,8(sp)
ffffffffc0202910:	b62fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202914:	000db783          	ld	a5,0(s11)
ffffffffc0202918:	6522                	ld	a0,8(sp)
ffffffffc020291a:	4585                	li	a1,1
ffffffffc020291c:	739c                	ld	a5,32(a5)
ffffffffc020291e:	9782                	jalr	a5
ffffffffc0202920:	b4cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202924:	6602                	ld	a2,0(sp)
ffffffffc0202926:	00094717          	auipc	a4,0x94
ffffffffc020292a:	f8270713          	addi	a4,a4,-126 # ffffffffc02968a8 <pages>
ffffffffc020292e:	6885                	lui	a7,0x1
ffffffffc0202930:	00080337          	lui	t1,0x80
ffffffffc0202934:	fff80e37          	lui	t3,0xfff80
ffffffffc0202938:	00094817          	auipc	a6,0x94
ffffffffc020293c:	f8080813          	addi	a6,a6,-128 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202940:	0004b023          	sd	zero,0(s1)
ffffffffc0202944:	b7a5                	j	ffffffffc02028ac <exit_range+0x178>
ffffffffc0202946:	e02a                	sd	a0,0(sp)
ffffffffc0202948:	b2afe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020294c:	000db783          	ld	a5,0(s11)
ffffffffc0202950:	6502                	ld	a0,0(sp)
ffffffffc0202952:	4585                	li	a1,1
ffffffffc0202954:	739c                	ld	a5,32(a5)
ffffffffc0202956:	9782                	jalr	a5
ffffffffc0202958:	b14fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020295c:	00094717          	auipc	a4,0x94
ffffffffc0202960:	f4c70713          	addi	a4,a4,-180 # ffffffffc02968a8 <pages>
ffffffffc0202964:	00043023          	sd	zero,0(s0)
ffffffffc0202968:	bfb5                	j	ffffffffc02028e4 <exit_range+0x1b0>
ffffffffc020296a:	0000a697          	auipc	a3,0xa
ffffffffc020296e:	e7668693          	addi	a3,a3,-394 # ffffffffc020c7e0 <default_pmm_manager+0x188>
ffffffffc0202972:	00009617          	auipc	a2,0x9
ffffffffc0202976:	20660613          	addi	a2,a2,518 # ffffffffc020bb78 <commands+0x210>
ffffffffc020297a:	16f00593          	li	a1,367
ffffffffc020297e:	0000a517          	auipc	a0,0xa
ffffffffc0202982:	e2a50513          	addi	a0,a0,-470 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0202986:	b19fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020298a:	0000a617          	auipc	a2,0xa
ffffffffc020298e:	d0660613          	addi	a2,a2,-762 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0202992:	07100593          	li	a1,113
ffffffffc0202996:	0000a517          	auipc	a0,0xa
ffffffffc020299a:	d2250513          	addi	a0,a0,-734 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc020299e:	b01fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02029a2:	81bff0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>
ffffffffc02029a6:	0000a697          	auipc	a3,0xa
ffffffffc02029aa:	e6a68693          	addi	a3,a3,-406 # ffffffffc020c810 <default_pmm_manager+0x1b8>
ffffffffc02029ae:	00009617          	auipc	a2,0x9
ffffffffc02029b2:	1ca60613          	addi	a2,a2,458 # ffffffffc020bb78 <commands+0x210>
ffffffffc02029b6:	17000593          	li	a1,368
ffffffffc02029ba:	0000a517          	auipc	a0,0xa
ffffffffc02029be:	dee50513          	addi	a0,a0,-530 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02029c2:	addfd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02029c6 <page_remove>:
ffffffffc02029c6:	7179                	addi	sp,sp,-48
ffffffffc02029c8:	4601                	li	a2,0
ffffffffc02029ca:	ec26                	sd	s1,24(sp)
ffffffffc02029cc:	f406                	sd	ra,40(sp)
ffffffffc02029ce:	f022                	sd	s0,32(sp)
ffffffffc02029d0:	84ae                	mv	s1,a1
ffffffffc02029d2:	8dbff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc02029d6:	c511                	beqz	a0,ffffffffc02029e2 <page_remove+0x1c>
ffffffffc02029d8:	611c                	ld	a5,0(a0)
ffffffffc02029da:	842a                	mv	s0,a0
ffffffffc02029dc:	0017f713          	andi	a4,a5,1
ffffffffc02029e0:	e711                	bnez	a4,ffffffffc02029ec <page_remove+0x26>
ffffffffc02029e2:	70a2                	ld	ra,40(sp)
ffffffffc02029e4:	7402                	ld	s0,32(sp)
ffffffffc02029e6:	64e2                	ld	s1,24(sp)
ffffffffc02029e8:	6145                	addi	sp,sp,48
ffffffffc02029ea:	8082                	ret
ffffffffc02029ec:	078a                	slli	a5,a5,0x2
ffffffffc02029ee:	83b1                	srli	a5,a5,0xc
ffffffffc02029f0:	00094717          	auipc	a4,0x94
ffffffffc02029f4:	eb073703          	ld	a4,-336(a4) # ffffffffc02968a0 <npage>
ffffffffc02029f8:	06e7f363          	bgeu	a5,a4,ffffffffc0202a5e <page_remove+0x98>
ffffffffc02029fc:	fff80537          	lui	a0,0xfff80
ffffffffc0202a00:	97aa                	add	a5,a5,a0
ffffffffc0202a02:	079a                	slli	a5,a5,0x6
ffffffffc0202a04:	00094517          	auipc	a0,0x94
ffffffffc0202a08:	ea453503          	ld	a0,-348(a0) # ffffffffc02968a8 <pages>
ffffffffc0202a0c:	953e                	add	a0,a0,a5
ffffffffc0202a0e:	411c                	lw	a5,0(a0)
ffffffffc0202a10:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202a14:	c118                	sw	a4,0(a0)
ffffffffc0202a16:	cb11                	beqz	a4,ffffffffc0202a2a <page_remove+0x64>
ffffffffc0202a18:	00043023          	sd	zero,0(s0)
ffffffffc0202a1c:	12048073          	sfence.vma	s1
ffffffffc0202a20:	70a2                	ld	ra,40(sp)
ffffffffc0202a22:	7402                	ld	s0,32(sp)
ffffffffc0202a24:	64e2                	ld	s1,24(sp)
ffffffffc0202a26:	6145                	addi	sp,sp,48
ffffffffc0202a28:	8082                	ret
ffffffffc0202a2a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a2e:	8b89                	andi	a5,a5,2
ffffffffc0202a30:	eb89                	bnez	a5,ffffffffc0202a42 <page_remove+0x7c>
ffffffffc0202a32:	00094797          	auipc	a5,0x94
ffffffffc0202a36:	e7e7b783          	ld	a5,-386(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a3a:	739c                	ld	a5,32(a5)
ffffffffc0202a3c:	4585                	li	a1,1
ffffffffc0202a3e:	9782                	jalr	a5
ffffffffc0202a40:	bfe1                	j	ffffffffc0202a18 <page_remove+0x52>
ffffffffc0202a42:	e42a                	sd	a0,8(sp)
ffffffffc0202a44:	a2efe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202a48:	00094797          	auipc	a5,0x94
ffffffffc0202a4c:	e687b783          	ld	a5,-408(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a50:	739c                	ld	a5,32(a5)
ffffffffc0202a52:	6522                	ld	a0,8(sp)
ffffffffc0202a54:	4585                	li	a1,1
ffffffffc0202a56:	9782                	jalr	a5
ffffffffc0202a58:	a14fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202a5c:	bf75                	j	ffffffffc0202a18 <page_remove+0x52>
ffffffffc0202a5e:	f5eff0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>

ffffffffc0202a62 <page_insert>:
ffffffffc0202a62:	7139                	addi	sp,sp,-64
ffffffffc0202a64:	e852                	sd	s4,16(sp)
ffffffffc0202a66:	8a32                	mv	s4,a2
ffffffffc0202a68:	f822                	sd	s0,48(sp)
ffffffffc0202a6a:	4605                	li	a2,1
ffffffffc0202a6c:	842e                	mv	s0,a1
ffffffffc0202a6e:	85d2                	mv	a1,s4
ffffffffc0202a70:	f426                	sd	s1,40(sp)
ffffffffc0202a72:	fc06                	sd	ra,56(sp)
ffffffffc0202a74:	f04a                	sd	s2,32(sp)
ffffffffc0202a76:	ec4e                	sd	s3,24(sp)
ffffffffc0202a78:	e456                	sd	s5,8(sp)
ffffffffc0202a7a:	84b6                	mv	s1,a3
ffffffffc0202a7c:	831ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0202a80:	c961                	beqz	a0,ffffffffc0202b50 <page_insert+0xee>
ffffffffc0202a82:	4014                	lw	a3,0(s0)
ffffffffc0202a84:	611c                	ld	a5,0(a0)
ffffffffc0202a86:	89aa                	mv	s3,a0
ffffffffc0202a88:	0016871b          	addiw	a4,a3,1
ffffffffc0202a8c:	c018                	sw	a4,0(s0)
ffffffffc0202a8e:	0017f713          	andi	a4,a5,1
ffffffffc0202a92:	ef05                	bnez	a4,ffffffffc0202aca <page_insert+0x68>
ffffffffc0202a94:	00094717          	auipc	a4,0x94
ffffffffc0202a98:	e1473703          	ld	a4,-492(a4) # ffffffffc02968a8 <pages>
ffffffffc0202a9c:	8c19                	sub	s0,s0,a4
ffffffffc0202a9e:	000807b7          	lui	a5,0x80
ffffffffc0202aa2:	8419                	srai	s0,s0,0x6
ffffffffc0202aa4:	943e                	add	s0,s0,a5
ffffffffc0202aa6:	042a                	slli	s0,s0,0xa
ffffffffc0202aa8:	8cc1                	or	s1,s1,s0
ffffffffc0202aaa:	0014e493          	ori	s1,s1,1
ffffffffc0202aae:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202ab2:	120a0073          	sfence.vma	s4
ffffffffc0202ab6:	4501                	li	a0,0
ffffffffc0202ab8:	70e2                	ld	ra,56(sp)
ffffffffc0202aba:	7442                	ld	s0,48(sp)
ffffffffc0202abc:	74a2                	ld	s1,40(sp)
ffffffffc0202abe:	7902                	ld	s2,32(sp)
ffffffffc0202ac0:	69e2                	ld	s3,24(sp)
ffffffffc0202ac2:	6a42                	ld	s4,16(sp)
ffffffffc0202ac4:	6aa2                	ld	s5,8(sp)
ffffffffc0202ac6:	6121                	addi	sp,sp,64
ffffffffc0202ac8:	8082                	ret
ffffffffc0202aca:	078a                	slli	a5,a5,0x2
ffffffffc0202acc:	83b1                	srli	a5,a5,0xc
ffffffffc0202ace:	00094717          	auipc	a4,0x94
ffffffffc0202ad2:	dd273703          	ld	a4,-558(a4) # ffffffffc02968a0 <npage>
ffffffffc0202ad6:	06e7ff63          	bgeu	a5,a4,ffffffffc0202b54 <page_insert+0xf2>
ffffffffc0202ada:	00094a97          	auipc	s5,0x94
ffffffffc0202ade:	dcea8a93          	addi	s5,s5,-562 # ffffffffc02968a8 <pages>
ffffffffc0202ae2:	000ab703          	ld	a4,0(s5)
ffffffffc0202ae6:	fff80937          	lui	s2,0xfff80
ffffffffc0202aea:	993e                	add	s2,s2,a5
ffffffffc0202aec:	091a                	slli	s2,s2,0x6
ffffffffc0202aee:	993a                	add	s2,s2,a4
ffffffffc0202af0:	01240c63          	beq	s0,s2,ffffffffc0202b08 <page_insert+0xa6>
ffffffffc0202af4:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202af8:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202afc:	00d92023          	sw	a3,0(s2)
ffffffffc0202b00:	c691                	beqz	a3,ffffffffc0202b0c <page_insert+0xaa>
ffffffffc0202b02:	120a0073          	sfence.vma	s4
ffffffffc0202b06:	bf59                	j	ffffffffc0202a9c <page_insert+0x3a>
ffffffffc0202b08:	c014                	sw	a3,0(s0)
ffffffffc0202b0a:	bf49                	j	ffffffffc0202a9c <page_insert+0x3a>
ffffffffc0202b0c:	100027f3          	csrr	a5,sstatus
ffffffffc0202b10:	8b89                	andi	a5,a5,2
ffffffffc0202b12:	ef91                	bnez	a5,ffffffffc0202b2e <page_insert+0xcc>
ffffffffc0202b14:	00094797          	auipc	a5,0x94
ffffffffc0202b18:	d9c7b783          	ld	a5,-612(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202b1c:	739c                	ld	a5,32(a5)
ffffffffc0202b1e:	4585                	li	a1,1
ffffffffc0202b20:	854a                	mv	a0,s2
ffffffffc0202b22:	9782                	jalr	a5
ffffffffc0202b24:	000ab703          	ld	a4,0(s5)
ffffffffc0202b28:	120a0073          	sfence.vma	s4
ffffffffc0202b2c:	bf85                	j	ffffffffc0202a9c <page_insert+0x3a>
ffffffffc0202b2e:	944fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202b32:	00094797          	auipc	a5,0x94
ffffffffc0202b36:	d7e7b783          	ld	a5,-642(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202b3a:	739c                	ld	a5,32(a5)
ffffffffc0202b3c:	4585                	li	a1,1
ffffffffc0202b3e:	854a                	mv	a0,s2
ffffffffc0202b40:	9782                	jalr	a5
ffffffffc0202b42:	92afe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202b46:	000ab703          	ld	a4,0(s5)
ffffffffc0202b4a:	120a0073          	sfence.vma	s4
ffffffffc0202b4e:	b7b9                	j	ffffffffc0202a9c <page_insert+0x3a>
ffffffffc0202b50:	5571                	li	a0,-4
ffffffffc0202b52:	b79d                	j	ffffffffc0202ab8 <page_insert+0x56>
ffffffffc0202b54:	e68ff0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>

ffffffffc0202b58 <pmm_init>:
ffffffffc0202b58:	0000a797          	auipc	a5,0xa
ffffffffc0202b5c:	b0078793          	addi	a5,a5,-1280 # ffffffffc020c658 <default_pmm_manager>
ffffffffc0202b60:	638c                	ld	a1,0(a5)
ffffffffc0202b62:	7159                	addi	sp,sp,-112
ffffffffc0202b64:	f85a                	sd	s6,48(sp)
ffffffffc0202b66:	0000a517          	auipc	a0,0xa
ffffffffc0202b6a:	cc250513          	addi	a0,a0,-830 # ffffffffc020c828 <default_pmm_manager+0x1d0>
ffffffffc0202b6e:	00094b17          	auipc	s6,0x94
ffffffffc0202b72:	d42b0b13          	addi	s6,s6,-702 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202b76:	f486                	sd	ra,104(sp)
ffffffffc0202b78:	e8ca                	sd	s2,80(sp)
ffffffffc0202b7a:	e4ce                	sd	s3,72(sp)
ffffffffc0202b7c:	f0a2                	sd	s0,96(sp)
ffffffffc0202b7e:	eca6                	sd	s1,88(sp)
ffffffffc0202b80:	e0d2                	sd	s4,64(sp)
ffffffffc0202b82:	fc56                	sd	s5,56(sp)
ffffffffc0202b84:	f45e                	sd	s7,40(sp)
ffffffffc0202b86:	f062                	sd	s8,32(sp)
ffffffffc0202b88:	ec66                	sd	s9,24(sp)
ffffffffc0202b8a:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b8e:	e18fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b92:	000b3783          	ld	a5,0(s6)
ffffffffc0202b96:	00094997          	auipc	s3,0x94
ffffffffc0202b9a:	d2298993          	addi	s3,s3,-734 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202b9e:	679c                	ld	a5,8(a5)
ffffffffc0202ba0:	9782                	jalr	a5
ffffffffc0202ba2:	57f5                	li	a5,-3
ffffffffc0202ba4:	07fa                	slli	a5,a5,0x1e
ffffffffc0202ba6:	00f9b023          	sd	a5,0(s3)
ffffffffc0202baa:	e9ffd0ef          	jal	ra,ffffffffc0200a48 <get_memory_base>
ffffffffc0202bae:	892a                	mv	s2,a0
ffffffffc0202bb0:	ea3fd0ef          	jal	ra,ffffffffc0200a52 <get_memory_size>
ffffffffc0202bb4:	280502e3          	beqz	a0,ffffffffc0203638 <pmm_init+0xae0>
ffffffffc0202bb8:	84aa                	mv	s1,a0
ffffffffc0202bba:	0000a517          	auipc	a0,0xa
ffffffffc0202bbe:	ca650513          	addi	a0,a0,-858 # ffffffffc020c860 <default_pmm_manager+0x208>
ffffffffc0202bc2:	de4fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bc6:	00990433          	add	s0,s2,s1
ffffffffc0202bca:	fff40693          	addi	a3,s0,-1
ffffffffc0202bce:	864a                	mv	a2,s2
ffffffffc0202bd0:	85a6                	mv	a1,s1
ffffffffc0202bd2:	0000a517          	auipc	a0,0xa
ffffffffc0202bd6:	ca650513          	addi	a0,a0,-858 # ffffffffc020c878 <default_pmm_manager+0x220>
ffffffffc0202bda:	dccfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bde:	c8000737          	lui	a4,0xc8000
ffffffffc0202be2:	87a2                	mv	a5,s0
ffffffffc0202be4:	5e876e63          	bltu	a4,s0,ffffffffc02031e0 <pmm_init+0x688>
ffffffffc0202be8:	757d                	lui	a0,0xfffff
ffffffffc0202bea:	00095617          	auipc	a2,0x95
ffffffffc0202bee:	d2560613          	addi	a2,a2,-731 # ffffffffc029790f <end+0xfff>
ffffffffc0202bf2:	8e69                	and	a2,a2,a0
ffffffffc0202bf4:	00094497          	auipc	s1,0x94
ffffffffc0202bf8:	cac48493          	addi	s1,s1,-852 # ffffffffc02968a0 <npage>
ffffffffc0202bfc:	00c7d513          	srli	a0,a5,0xc
ffffffffc0202c00:	00094b97          	auipc	s7,0x94
ffffffffc0202c04:	ca8b8b93          	addi	s7,s7,-856 # ffffffffc02968a8 <pages>
ffffffffc0202c08:	e088                	sd	a0,0(s1)
ffffffffc0202c0a:	00cbb023          	sd	a2,0(s7)
ffffffffc0202c0e:	000807b7          	lui	a5,0x80
ffffffffc0202c12:	86b2                	mv	a3,a2
ffffffffc0202c14:	02f50863          	beq	a0,a5,ffffffffc0202c44 <pmm_init+0xec>
ffffffffc0202c18:	4781                	li	a5,0
ffffffffc0202c1a:	4585                	li	a1,1
ffffffffc0202c1c:	fff806b7          	lui	a3,0xfff80
ffffffffc0202c20:	00679513          	slli	a0,a5,0x6
ffffffffc0202c24:	9532                	add	a0,a0,a2
ffffffffc0202c26:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0202c2a:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0202c2e:	6088                	ld	a0,0(s1)
ffffffffc0202c30:	0785                	addi	a5,a5,1
ffffffffc0202c32:	000bb603          	ld	a2,0(s7)
ffffffffc0202c36:	00d50733          	add	a4,a0,a3
ffffffffc0202c3a:	fee7e3e3          	bltu	a5,a4,ffffffffc0202c20 <pmm_init+0xc8>
ffffffffc0202c3e:	071a                	slli	a4,a4,0x6
ffffffffc0202c40:	00e606b3          	add	a3,a2,a4
ffffffffc0202c44:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c48:	3af6eae3          	bltu	a3,a5,ffffffffc02037fc <pmm_init+0xca4>
ffffffffc0202c4c:	0009b583          	ld	a1,0(s3)
ffffffffc0202c50:	77fd                	lui	a5,0xfffff
ffffffffc0202c52:	8c7d                	and	s0,s0,a5
ffffffffc0202c54:	8e8d                	sub	a3,a3,a1
ffffffffc0202c56:	5e86e363          	bltu	a3,s0,ffffffffc020323c <pmm_init+0x6e4>
ffffffffc0202c5a:	0000a517          	auipc	a0,0xa
ffffffffc0202c5e:	c4650513          	addi	a0,a0,-954 # ffffffffc020c8a0 <default_pmm_manager+0x248>
ffffffffc0202c62:	d44fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202c66:	000b3783          	ld	a5,0(s6)
ffffffffc0202c6a:	7b9c                	ld	a5,48(a5)
ffffffffc0202c6c:	9782                	jalr	a5
ffffffffc0202c6e:	0000a517          	auipc	a0,0xa
ffffffffc0202c72:	c4a50513          	addi	a0,a0,-950 # ffffffffc020c8b8 <default_pmm_manager+0x260>
ffffffffc0202c76:	d30fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202c7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202c7e:	8b89                	andi	a5,a5,2
ffffffffc0202c80:	5a079363          	bnez	a5,ffffffffc0203226 <pmm_init+0x6ce>
ffffffffc0202c84:	000b3783          	ld	a5,0(s6)
ffffffffc0202c88:	4505                	li	a0,1
ffffffffc0202c8a:	6f9c                	ld	a5,24(a5)
ffffffffc0202c8c:	9782                	jalr	a5
ffffffffc0202c8e:	842a                	mv	s0,a0
ffffffffc0202c90:	180408e3          	beqz	s0,ffffffffc0203620 <pmm_init+0xac8>
ffffffffc0202c94:	000bb683          	ld	a3,0(s7)
ffffffffc0202c98:	5a7d                	li	s4,-1
ffffffffc0202c9a:	6098                	ld	a4,0(s1)
ffffffffc0202c9c:	40d406b3          	sub	a3,s0,a3
ffffffffc0202ca0:	8699                	srai	a3,a3,0x6
ffffffffc0202ca2:	00080437          	lui	s0,0x80
ffffffffc0202ca6:	96a2                	add	a3,a3,s0
ffffffffc0202ca8:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202cac:	8ff5                	and	a5,a5,a3
ffffffffc0202cae:	06b2                	slli	a3,a3,0xc
ffffffffc0202cb0:	30e7fde3          	bgeu	a5,a4,ffffffffc02037ca <pmm_init+0xc72>
ffffffffc0202cb4:	0009b403          	ld	s0,0(s3)
ffffffffc0202cb8:	6605                	lui	a2,0x1
ffffffffc0202cba:	4581                	li	a1,0
ffffffffc0202cbc:	9436                	add	s0,s0,a3
ffffffffc0202cbe:	8522                	mv	a0,s0
ffffffffc0202cc0:	1d5080ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0202cc4:	0009b683          	ld	a3,0(s3)
ffffffffc0202cc8:	77fd                	lui	a5,0xfffff
ffffffffc0202cca:	0000a917          	auipc	s2,0xa
ffffffffc0202cce:	a3390913          	addi	s2,s2,-1485 # ffffffffc020c6fd <default_pmm_manager+0xa5>
ffffffffc0202cd2:	00f97933          	and	s2,s2,a5
ffffffffc0202cd6:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202cda:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202cde:	964a                	add	a2,a2,s2
ffffffffc0202ce0:	4729                	li	a4,10
ffffffffc0202ce2:	40da86b3          	sub	a3,s5,a3
ffffffffc0202ce6:	c02005b7          	lui	a1,0xc0200
ffffffffc0202cea:	8522                	mv	a0,s0
ffffffffc0202cec:	fe8ff0ef          	jal	ra,ffffffffc02024d4 <boot_map_segment>
ffffffffc0202cf0:	c8000637          	lui	a2,0xc8000
ffffffffc0202cf4:	41260633          	sub	a2,a2,s2
ffffffffc0202cf8:	3f596ce3          	bltu	s2,s5,ffffffffc02038f0 <pmm_init+0xd98>
ffffffffc0202cfc:	0009b683          	ld	a3,0(s3)
ffffffffc0202d00:	85ca                	mv	a1,s2
ffffffffc0202d02:	4719                	li	a4,6
ffffffffc0202d04:	40d906b3          	sub	a3,s2,a3
ffffffffc0202d08:	8522                	mv	a0,s0
ffffffffc0202d0a:	00094917          	auipc	s2,0x94
ffffffffc0202d0e:	b8e90913          	addi	s2,s2,-1138 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0202d12:	fc2ff0ef          	jal	ra,ffffffffc02024d4 <boot_map_segment>
ffffffffc0202d16:	00893023          	sd	s0,0(s2)
ffffffffc0202d1a:	2d5464e3          	bltu	s0,s5,ffffffffc02037e2 <pmm_init+0xc8a>
ffffffffc0202d1e:	0009b783          	ld	a5,0(s3)
ffffffffc0202d22:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202d24:	8c1d                	sub	s0,s0,a5
ffffffffc0202d26:	00c45793          	srli	a5,s0,0xc
ffffffffc0202d2a:	00094717          	auipc	a4,0x94
ffffffffc0202d2e:	b6873323          	sd	s0,-1178(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0202d32:	0147ea33          	or	s4,a5,s4
ffffffffc0202d36:	180a1073          	csrw	satp,s4
ffffffffc0202d3a:	12000073          	sfence.vma
ffffffffc0202d3e:	0000a517          	auipc	a0,0xa
ffffffffc0202d42:	bba50513          	addi	a0,a0,-1094 # ffffffffc020c8f8 <default_pmm_manager+0x2a0>
ffffffffc0202d46:	c60fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202d4a:	0000e717          	auipc	a4,0xe
ffffffffc0202d4e:	2b670713          	addi	a4,a4,694 # ffffffffc0211000 <bootstack>
ffffffffc0202d52:	0000e797          	auipc	a5,0xe
ffffffffc0202d56:	2ae78793          	addi	a5,a5,686 # ffffffffc0211000 <bootstack>
ffffffffc0202d5a:	5cf70d63          	beq	a4,a5,ffffffffc0203334 <pmm_init+0x7dc>
ffffffffc0202d5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d62:	8b89                	andi	a5,a5,2
ffffffffc0202d64:	4a079763          	bnez	a5,ffffffffc0203212 <pmm_init+0x6ba>
ffffffffc0202d68:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6c:	779c                	ld	a5,40(a5)
ffffffffc0202d6e:	9782                	jalr	a5
ffffffffc0202d70:	842a                	mv	s0,a0
ffffffffc0202d72:	6098                	ld	a4,0(s1)
ffffffffc0202d74:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d78:	83b1                	srli	a5,a5,0xc
ffffffffc0202d7a:	08e7e3e3          	bltu	a5,a4,ffffffffc0203600 <pmm_init+0xaa8>
ffffffffc0202d7e:	00093503          	ld	a0,0(s2)
ffffffffc0202d82:	04050fe3          	beqz	a0,ffffffffc02035e0 <pmm_init+0xa88>
ffffffffc0202d86:	03451793          	slli	a5,a0,0x34
ffffffffc0202d8a:	04079be3          	bnez	a5,ffffffffc02035e0 <pmm_init+0xa88>
ffffffffc0202d8e:	4601                	li	a2,0
ffffffffc0202d90:	4581                	li	a1,0
ffffffffc0202d92:	809ff0ef          	jal	ra,ffffffffc020259a <get_page>
ffffffffc0202d96:	2e0511e3          	bnez	a0,ffffffffc0203878 <pmm_init+0xd20>
ffffffffc0202d9a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d9e:	8b89                	andi	a5,a5,2
ffffffffc0202da0:	44079e63          	bnez	a5,ffffffffc02031fc <pmm_init+0x6a4>
ffffffffc0202da4:	000b3783          	ld	a5,0(s6)
ffffffffc0202da8:	4505                	li	a0,1
ffffffffc0202daa:	6f9c                	ld	a5,24(a5)
ffffffffc0202dac:	9782                	jalr	a5
ffffffffc0202dae:	8a2a                	mv	s4,a0
ffffffffc0202db0:	00093503          	ld	a0,0(s2)
ffffffffc0202db4:	4681                	li	a3,0
ffffffffc0202db6:	4601                	li	a2,0
ffffffffc0202db8:	85d2                	mv	a1,s4
ffffffffc0202dba:	ca9ff0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc0202dbe:	26051be3          	bnez	a0,ffffffffc0203834 <pmm_init+0xcdc>
ffffffffc0202dc2:	00093503          	ld	a0,0(s2)
ffffffffc0202dc6:	4601                	li	a2,0
ffffffffc0202dc8:	4581                	li	a1,0
ffffffffc0202dca:	ce2ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0202dce:	280505e3          	beqz	a0,ffffffffc0203858 <pmm_init+0xd00>
ffffffffc0202dd2:	611c                	ld	a5,0(a0)
ffffffffc0202dd4:	0017f713          	andi	a4,a5,1
ffffffffc0202dd8:	26070ee3          	beqz	a4,ffffffffc0203854 <pmm_init+0xcfc>
ffffffffc0202ddc:	6098                	ld	a4,0(s1)
ffffffffc0202dde:	078a                	slli	a5,a5,0x2
ffffffffc0202de0:	83b1                	srli	a5,a5,0xc
ffffffffc0202de2:	62e7f363          	bgeu	a5,a4,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0202de6:	000bb683          	ld	a3,0(s7)
ffffffffc0202dea:	fff80637          	lui	a2,0xfff80
ffffffffc0202dee:	97b2                	add	a5,a5,a2
ffffffffc0202df0:	079a                	slli	a5,a5,0x6
ffffffffc0202df2:	97b6                	add	a5,a5,a3
ffffffffc0202df4:	2afa12e3          	bne	s4,a5,ffffffffc0203898 <pmm_init+0xd40>
ffffffffc0202df8:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202dfc:	4785                	li	a5,1
ffffffffc0202dfe:	2cf699e3          	bne	a3,a5,ffffffffc02038d0 <pmm_init+0xd78>
ffffffffc0202e02:	00093503          	ld	a0,0(s2)
ffffffffc0202e06:	77fd                	lui	a5,0xfffff
ffffffffc0202e08:	6114                	ld	a3,0(a0)
ffffffffc0202e0a:	068a                	slli	a3,a3,0x2
ffffffffc0202e0c:	8efd                	and	a3,a3,a5
ffffffffc0202e0e:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202e12:	2ae673e3          	bgeu	a2,a4,ffffffffc02038b8 <pmm_init+0xd60>
ffffffffc0202e16:	0009bc03          	ld	s8,0(s3)
ffffffffc0202e1a:	96e2                	add	a3,a3,s8
ffffffffc0202e1c:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202e20:	0a8a                	slli	s5,s5,0x2
ffffffffc0202e22:	00fafab3          	and	s5,s5,a5
ffffffffc0202e26:	00cad793          	srli	a5,s5,0xc
ffffffffc0202e2a:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203690 <pmm_init+0xb38>
ffffffffc0202e2e:	4601                	li	a2,0
ffffffffc0202e30:	6585                	lui	a1,0x1
ffffffffc0202e32:	9ae2                	add	s5,s5,s8
ffffffffc0202e34:	c78ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0202e38:	0aa1                	addi	s5,s5,8
ffffffffc0202e3a:	03551be3          	bne	a0,s5,ffffffffc0203670 <pmm_init+0xb18>
ffffffffc0202e3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202e42:	8b89                	andi	a5,a5,2
ffffffffc0202e44:	3a079163          	bnez	a5,ffffffffc02031e6 <pmm_init+0x68e>
ffffffffc0202e48:	000b3783          	ld	a5,0(s6)
ffffffffc0202e4c:	4505                	li	a0,1
ffffffffc0202e4e:	6f9c                	ld	a5,24(a5)
ffffffffc0202e50:	9782                	jalr	a5
ffffffffc0202e52:	8c2a                	mv	s8,a0
ffffffffc0202e54:	00093503          	ld	a0,0(s2)
ffffffffc0202e58:	46d1                	li	a3,20
ffffffffc0202e5a:	6605                	lui	a2,0x1
ffffffffc0202e5c:	85e2                	mv	a1,s8
ffffffffc0202e5e:	c05ff0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc0202e62:	1a0519e3          	bnez	a0,ffffffffc0203814 <pmm_init+0xcbc>
ffffffffc0202e66:	00093503          	ld	a0,0(s2)
ffffffffc0202e6a:	4601                	li	a2,0
ffffffffc0202e6c:	6585                	lui	a1,0x1
ffffffffc0202e6e:	c3eff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0202e72:	10050ce3          	beqz	a0,ffffffffc020378a <pmm_init+0xc32>
ffffffffc0202e76:	611c                	ld	a5,0(a0)
ffffffffc0202e78:	0107f713          	andi	a4,a5,16
ffffffffc0202e7c:	0e0707e3          	beqz	a4,ffffffffc020376a <pmm_init+0xc12>
ffffffffc0202e80:	8b91                	andi	a5,a5,4
ffffffffc0202e82:	0c0784e3          	beqz	a5,ffffffffc020374a <pmm_init+0xbf2>
ffffffffc0202e86:	00093503          	ld	a0,0(s2)
ffffffffc0202e8a:	611c                	ld	a5,0(a0)
ffffffffc0202e8c:	8bc1                	andi	a5,a5,16
ffffffffc0202e8e:	08078ee3          	beqz	a5,ffffffffc020372a <pmm_init+0xbd2>
ffffffffc0202e92:	000c2703          	lw	a4,0(s8)
ffffffffc0202e96:	4785                	li	a5,1
ffffffffc0202e98:	06f719e3          	bne	a4,a5,ffffffffc020370a <pmm_init+0xbb2>
ffffffffc0202e9c:	4681                	li	a3,0
ffffffffc0202e9e:	6605                	lui	a2,0x1
ffffffffc0202ea0:	85d2                	mv	a1,s4
ffffffffc0202ea2:	bc1ff0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc0202ea6:	040512e3          	bnez	a0,ffffffffc02036ea <pmm_init+0xb92>
ffffffffc0202eaa:	000a2703          	lw	a4,0(s4)
ffffffffc0202eae:	4789                	li	a5,2
ffffffffc0202eb0:	00f71de3          	bne	a4,a5,ffffffffc02036ca <pmm_init+0xb72>
ffffffffc0202eb4:	000c2783          	lw	a5,0(s8)
ffffffffc0202eb8:	7e079963          	bnez	a5,ffffffffc02036aa <pmm_init+0xb52>
ffffffffc0202ebc:	00093503          	ld	a0,0(s2)
ffffffffc0202ec0:	4601                	li	a2,0
ffffffffc0202ec2:	6585                	lui	a1,0x1
ffffffffc0202ec4:	be8ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0202ec8:	54050263          	beqz	a0,ffffffffc020340c <pmm_init+0x8b4>
ffffffffc0202ecc:	6118                	ld	a4,0(a0)
ffffffffc0202ece:	00177793          	andi	a5,a4,1
ffffffffc0202ed2:	180781e3          	beqz	a5,ffffffffc0203854 <pmm_init+0xcfc>
ffffffffc0202ed6:	6094                	ld	a3,0(s1)
ffffffffc0202ed8:	00271793          	slli	a5,a4,0x2
ffffffffc0202edc:	83b1                	srli	a5,a5,0xc
ffffffffc0202ede:	52d7f563          	bgeu	a5,a3,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0202ee2:	000bb683          	ld	a3,0(s7)
ffffffffc0202ee6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202eea:	97d6                	add	a5,a5,s5
ffffffffc0202eec:	079a                	slli	a5,a5,0x6
ffffffffc0202eee:	97b6                	add	a5,a5,a3
ffffffffc0202ef0:	58fa1e63          	bne	s4,a5,ffffffffc020348c <pmm_init+0x934>
ffffffffc0202ef4:	8b41                	andi	a4,a4,16
ffffffffc0202ef6:	56071b63          	bnez	a4,ffffffffc020346c <pmm_init+0x914>
ffffffffc0202efa:	00093503          	ld	a0,0(s2)
ffffffffc0202efe:	4581                	li	a1,0
ffffffffc0202f00:	ac7ff0ef          	jal	ra,ffffffffc02029c6 <page_remove>
ffffffffc0202f04:	000a2c83          	lw	s9,0(s4)
ffffffffc0202f08:	4785                	li	a5,1
ffffffffc0202f0a:	5cfc9163          	bne	s9,a5,ffffffffc02034cc <pmm_init+0x974>
ffffffffc0202f0e:	000c2783          	lw	a5,0(s8)
ffffffffc0202f12:	58079d63          	bnez	a5,ffffffffc02034ac <pmm_init+0x954>
ffffffffc0202f16:	00093503          	ld	a0,0(s2)
ffffffffc0202f1a:	6585                	lui	a1,0x1
ffffffffc0202f1c:	aabff0ef          	jal	ra,ffffffffc02029c6 <page_remove>
ffffffffc0202f20:	000a2783          	lw	a5,0(s4)
ffffffffc0202f24:	200793e3          	bnez	a5,ffffffffc020392a <pmm_init+0xdd2>
ffffffffc0202f28:	000c2783          	lw	a5,0(s8)
ffffffffc0202f2c:	1c079fe3          	bnez	a5,ffffffffc020390a <pmm_init+0xdb2>
ffffffffc0202f30:	00093a03          	ld	s4,0(s2)
ffffffffc0202f34:	608c                	ld	a1,0(s1)
ffffffffc0202f36:	000a3683          	ld	a3,0(s4)
ffffffffc0202f3a:	068a                	slli	a3,a3,0x2
ffffffffc0202f3c:	82b1                	srli	a3,a3,0xc
ffffffffc0202f3e:	4cb6f563          	bgeu	a3,a1,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0202f42:	000bb503          	ld	a0,0(s7)
ffffffffc0202f46:	96d6                	add	a3,a3,s5
ffffffffc0202f48:	069a                	slli	a3,a3,0x6
ffffffffc0202f4a:	00d507b3          	add	a5,a0,a3
ffffffffc0202f4e:	439c                	lw	a5,0(a5)
ffffffffc0202f50:	4f979e63          	bne	a5,s9,ffffffffc020344c <pmm_init+0x8f4>
ffffffffc0202f54:	8699                	srai	a3,a3,0x6
ffffffffc0202f56:	00080637          	lui	a2,0x80
ffffffffc0202f5a:	96b2                	add	a3,a3,a2
ffffffffc0202f5c:	00c69713          	slli	a4,a3,0xc
ffffffffc0202f60:	8331                	srli	a4,a4,0xc
ffffffffc0202f62:	06b2                	slli	a3,a3,0xc
ffffffffc0202f64:	06b773e3          	bgeu	a4,a1,ffffffffc02037ca <pmm_init+0xc72>
ffffffffc0202f68:	0009b703          	ld	a4,0(s3)
ffffffffc0202f6c:	96ba                	add	a3,a3,a4
ffffffffc0202f6e:	629c                	ld	a5,0(a3)
ffffffffc0202f70:	078a                	slli	a5,a5,0x2
ffffffffc0202f72:	83b1                	srli	a5,a5,0xc
ffffffffc0202f74:	48b7fa63          	bgeu	a5,a1,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0202f78:	8f91                	sub	a5,a5,a2
ffffffffc0202f7a:	079a                	slli	a5,a5,0x6
ffffffffc0202f7c:	953e                	add	a0,a0,a5
ffffffffc0202f7e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f82:	8b89                	andi	a5,a5,2
ffffffffc0202f84:	32079463          	bnez	a5,ffffffffc02032ac <pmm_init+0x754>
ffffffffc0202f88:	000b3783          	ld	a5,0(s6)
ffffffffc0202f8c:	4585                	li	a1,1
ffffffffc0202f8e:	739c                	ld	a5,32(a5)
ffffffffc0202f90:	9782                	jalr	a5
ffffffffc0202f92:	000a3783          	ld	a5,0(s4)
ffffffffc0202f96:	6098                	ld	a4,0(s1)
ffffffffc0202f98:	078a                	slli	a5,a5,0x2
ffffffffc0202f9a:	83b1                	srli	a5,a5,0xc
ffffffffc0202f9c:	46e7f663          	bgeu	a5,a4,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0202fa0:	000bb503          	ld	a0,0(s7)
ffffffffc0202fa4:	fff80737          	lui	a4,0xfff80
ffffffffc0202fa8:	97ba                	add	a5,a5,a4
ffffffffc0202faa:	079a                	slli	a5,a5,0x6
ffffffffc0202fac:	953e                	add	a0,a0,a5
ffffffffc0202fae:	100027f3          	csrr	a5,sstatus
ffffffffc0202fb2:	8b89                	andi	a5,a5,2
ffffffffc0202fb4:	2e079063          	bnez	a5,ffffffffc0203294 <pmm_init+0x73c>
ffffffffc0202fb8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fbc:	4585                	li	a1,1
ffffffffc0202fbe:	739c                	ld	a5,32(a5)
ffffffffc0202fc0:	9782                	jalr	a5
ffffffffc0202fc2:	00093783          	ld	a5,0(s2)
ffffffffc0202fc6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202fca:	12000073          	sfence.vma
ffffffffc0202fce:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd2:	8b89                	andi	a5,a5,2
ffffffffc0202fd4:	2a079663          	bnez	a5,ffffffffc0203280 <pmm_init+0x728>
ffffffffc0202fd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fdc:	779c                	ld	a5,40(a5)
ffffffffc0202fde:	9782                	jalr	a5
ffffffffc0202fe0:	8a2a                	mv	s4,a0
ffffffffc0202fe2:	7d441463          	bne	s0,s4,ffffffffc02037aa <pmm_init+0xc52>
ffffffffc0202fe6:	0000a517          	auipc	a0,0xa
ffffffffc0202fea:	c6a50513          	addi	a0,a0,-918 # ffffffffc020cc50 <default_pmm_manager+0x5f8>
ffffffffc0202fee:	9b8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202ff2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ff6:	8b89                	andi	a5,a5,2
ffffffffc0202ff8:	26079a63          	bnez	a5,ffffffffc020326c <pmm_init+0x714>
ffffffffc0202ffc:	000b3783          	ld	a5,0(s6)
ffffffffc0203000:	779c                	ld	a5,40(a5)
ffffffffc0203002:	9782                	jalr	a5
ffffffffc0203004:	8c2a                	mv	s8,a0
ffffffffc0203006:	6098                	ld	a4,0(s1)
ffffffffc0203008:	c0200437          	lui	s0,0xc0200
ffffffffc020300c:	7afd                	lui	s5,0xfffff
ffffffffc020300e:	00c71793          	slli	a5,a4,0xc
ffffffffc0203012:	6a05                	lui	s4,0x1
ffffffffc0203014:	02f47c63          	bgeu	s0,a5,ffffffffc020304c <pmm_init+0x4f4>
ffffffffc0203018:	00c45793          	srli	a5,s0,0xc
ffffffffc020301c:	00093503          	ld	a0,0(s2)
ffffffffc0203020:	3ae7f763          	bgeu	a5,a4,ffffffffc02033ce <pmm_init+0x876>
ffffffffc0203024:	0009b583          	ld	a1,0(s3)
ffffffffc0203028:	4601                	li	a2,0
ffffffffc020302a:	95a2                	add	a1,a1,s0
ffffffffc020302c:	a80ff0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc0203030:	36050f63          	beqz	a0,ffffffffc02033ae <pmm_init+0x856>
ffffffffc0203034:	611c                	ld	a5,0(a0)
ffffffffc0203036:	078a                	slli	a5,a5,0x2
ffffffffc0203038:	0157f7b3          	and	a5,a5,s5
ffffffffc020303c:	3a879663          	bne	a5,s0,ffffffffc02033e8 <pmm_init+0x890>
ffffffffc0203040:	6098                	ld	a4,0(s1)
ffffffffc0203042:	9452                	add	s0,s0,s4
ffffffffc0203044:	00c71793          	slli	a5,a4,0xc
ffffffffc0203048:	fcf468e3          	bltu	s0,a5,ffffffffc0203018 <pmm_init+0x4c0>
ffffffffc020304c:	00093783          	ld	a5,0(s2)
ffffffffc0203050:	639c                	ld	a5,0(a5)
ffffffffc0203052:	48079d63          	bnez	a5,ffffffffc02034ec <pmm_init+0x994>
ffffffffc0203056:	100027f3          	csrr	a5,sstatus
ffffffffc020305a:	8b89                	andi	a5,a5,2
ffffffffc020305c:	26079463          	bnez	a5,ffffffffc02032c4 <pmm_init+0x76c>
ffffffffc0203060:	000b3783          	ld	a5,0(s6)
ffffffffc0203064:	4505                	li	a0,1
ffffffffc0203066:	6f9c                	ld	a5,24(a5)
ffffffffc0203068:	9782                	jalr	a5
ffffffffc020306a:	8a2a                	mv	s4,a0
ffffffffc020306c:	00093503          	ld	a0,0(s2)
ffffffffc0203070:	4699                	li	a3,6
ffffffffc0203072:	10000613          	li	a2,256
ffffffffc0203076:	85d2                	mv	a1,s4
ffffffffc0203078:	9ebff0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc020307c:	4a051863          	bnez	a0,ffffffffc020352c <pmm_init+0x9d4>
ffffffffc0203080:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203084:	4785                	li	a5,1
ffffffffc0203086:	48f71363          	bne	a4,a5,ffffffffc020350c <pmm_init+0x9b4>
ffffffffc020308a:	00093503          	ld	a0,0(s2)
ffffffffc020308e:	6405                	lui	s0,0x1
ffffffffc0203090:	4699                	li	a3,6
ffffffffc0203092:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0203096:	85d2                	mv	a1,s4
ffffffffc0203098:	9cbff0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc020309c:	38051863          	bnez	a0,ffffffffc020342c <pmm_init+0x8d4>
ffffffffc02030a0:	000a2703          	lw	a4,0(s4)
ffffffffc02030a4:	4789                	li	a5,2
ffffffffc02030a6:	4ef71363          	bne	a4,a5,ffffffffc020358c <pmm_init+0xa34>
ffffffffc02030aa:	0000a597          	auipc	a1,0xa
ffffffffc02030ae:	cee58593          	addi	a1,a1,-786 # ffffffffc020cd98 <default_pmm_manager+0x740>
ffffffffc02030b2:	10000513          	li	a0,256
ffffffffc02030b6:	572080ef          	jal	ra,ffffffffc020b628 <strcpy>
ffffffffc02030ba:	10040593          	addi	a1,s0,256
ffffffffc02030be:	10000513          	li	a0,256
ffffffffc02030c2:	578080ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc02030c6:	4a051363          	bnez	a0,ffffffffc020356c <pmm_init+0xa14>
ffffffffc02030ca:	000bb683          	ld	a3,0(s7)
ffffffffc02030ce:	00080737          	lui	a4,0x80
ffffffffc02030d2:	547d                	li	s0,-1
ffffffffc02030d4:	40da06b3          	sub	a3,s4,a3
ffffffffc02030d8:	8699                	srai	a3,a3,0x6
ffffffffc02030da:	609c                	ld	a5,0(s1)
ffffffffc02030dc:	96ba                	add	a3,a3,a4
ffffffffc02030de:	8031                	srli	s0,s0,0xc
ffffffffc02030e0:	0086f733          	and	a4,a3,s0
ffffffffc02030e4:	06b2                	slli	a3,a3,0xc
ffffffffc02030e6:	6ef77263          	bgeu	a4,a5,ffffffffc02037ca <pmm_init+0xc72>
ffffffffc02030ea:	0009b783          	ld	a5,0(s3)
ffffffffc02030ee:	10000513          	li	a0,256
ffffffffc02030f2:	96be                	add	a3,a3,a5
ffffffffc02030f4:	10068023          	sb	zero,256(a3)
ffffffffc02030f8:	4fa080ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc02030fc:	44051863          	bnez	a0,ffffffffc020354c <pmm_init+0x9f4>
ffffffffc0203100:	00093a83          	ld	s5,0(s2)
ffffffffc0203104:	609c                	ld	a5,0(s1)
ffffffffc0203106:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc020310a:	068a                	slli	a3,a3,0x2
ffffffffc020310c:	82b1                	srli	a3,a3,0xc
ffffffffc020310e:	2ef6fd63          	bgeu	a3,a5,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0203112:	8c75                	and	s0,s0,a3
ffffffffc0203114:	06b2                	slli	a3,a3,0xc
ffffffffc0203116:	6af47a63          	bgeu	s0,a5,ffffffffc02037ca <pmm_init+0xc72>
ffffffffc020311a:	0009b403          	ld	s0,0(s3)
ffffffffc020311e:	9436                	add	s0,s0,a3
ffffffffc0203120:	100027f3          	csrr	a5,sstatus
ffffffffc0203124:	8b89                	andi	a5,a5,2
ffffffffc0203126:	1e079c63          	bnez	a5,ffffffffc020331e <pmm_init+0x7c6>
ffffffffc020312a:	000b3783          	ld	a5,0(s6)
ffffffffc020312e:	4585                	li	a1,1
ffffffffc0203130:	8552                	mv	a0,s4
ffffffffc0203132:	739c                	ld	a5,32(a5)
ffffffffc0203134:	9782                	jalr	a5
ffffffffc0203136:	601c                	ld	a5,0(s0)
ffffffffc0203138:	6098                	ld	a4,0(s1)
ffffffffc020313a:	078a                	slli	a5,a5,0x2
ffffffffc020313c:	83b1                	srli	a5,a5,0xc
ffffffffc020313e:	2ce7f563          	bgeu	a5,a4,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0203142:	000bb503          	ld	a0,0(s7)
ffffffffc0203146:	fff80737          	lui	a4,0xfff80
ffffffffc020314a:	97ba                	add	a5,a5,a4
ffffffffc020314c:	079a                	slli	a5,a5,0x6
ffffffffc020314e:	953e                	add	a0,a0,a5
ffffffffc0203150:	100027f3          	csrr	a5,sstatus
ffffffffc0203154:	8b89                	andi	a5,a5,2
ffffffffc0203156:	1a079863          	bnez	a5,ffffffffc0203306 <pmm_init+0x7ae>
ffffffffc020315a:	000b3783          	ld	a5,0(s6)
ffffffffc020315e:	4585                	li	a1,1
ffffffffc0203160:	739c                	ld	a5,32(a5)
ffffffffc0203162:	9782                	jalr	a5
ffffffffc0203164:	000ab783          	ld	a5,0(s5)
ffffffffc0203168:	6098                	ld	a4,0(s1)
ffffffffc020316a:	078a                	slli	a5,a5,0x2
ffffffffc020316c:	83b1                	srli	a5,a5,0xc
ffffffffc020316e:	28e7fd63          	bgeu	a5,a4,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc0203172:	000bb503          	ld	a0,0(s7)
ffffffffc0203176:	fff80737          	lui	a4,0xfff80
ffffffffc020317a:	97ba                	add	a5,a5,a4
ffffffffc020317c:	079a                	slli	a5,a5,0x6
ffffffffc020317e:	953e                	add	a0,a0,a5
ffffffffc0203180:	100027f3          	csrr	a5,sstatus
ffffffffc0203184:	8b89                	andi	a5,a5,2
ffffffffc0203186:	16079463          	bnez	a5,ffffffffc02032ee <pmm_init+0x796>
ffffffffc020318a:	000b3783          	ld	a5,0(s6)
ffffffffc020318e:	4585                	li	a1,1
ffffffffc0203190:	739c                	ld	a5,32(a5)
ffffffffc0203192:	9782                	jalr	a5
ffffffffc0203194:	00093783          	ld	a5,0(s2)
ffffffffc0203198:	0007b023          	sd	zero,0(a5)
ffffffffc020319c:	12000073          	sfence.vma
ffffffffc02031a0:	100027f3          	csrr	a5,sstatus
ffffffffc02031a4:	8b89                	andi	a5,a5,2
ffffffffc02031a6:	12079a63          	bnez	a5,ffffffffc02032da <pmm_init+0x782>
ffffffffc02031aa:	000b3783          	ld	a5,0(s6)
ffffffffc02031ae:	779c                	ld	a5,40(a5)
ffffffffc02031b0:	9782                	jalr	a5
ffffffffc02031b2:	842a                	mv	s0,a0
ffffffffc02031b4:	488c1e63          	bne	s8,s0,ffffffffc0203650 <pmm_init+0xaf8>
ffffffffc02031b8:	0000a517          	auipc	a0,0xa
ffffffffc02031bc:	c5850513          	addi	a0,a0,-936 # ffffffffc020ce10 <default_pmm_manager+0x7b8>
ffffffffc02031c0:	fe7fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02031c4:	7406                	ld	s0,96(sp)
ffffffffc02031c6:	70a6                	ld	ra,104(sp)
ffffffffc02031c8:	64e6                	ld	s1,88(sp)
ffffffffc02031ca:	6946                	ld	s2,80(sp)
ffffffffc02031cc:	69a6                	ld	s3,72(sp)
ffffffffc02031ce:	6a06                	ld	s4,64(sp)
ffffffffc02031d0:	7ae2                	ld	s5,56(sp)
ffffffffc02031d2:	7b42                	ld	s6,48(sp)
ffffffffc02031d4:	7ba2                	ld	s7,40(sp)
ffffffffc02031d6:	7c02                	ld	s8,32(sp)
ffffffffc02031d8:	6ce2                	ld	s9,24(sp)
ffffffffc02031da:	6165                	addi	sp,sp,112
ffffffffc02031dc:	e17fe06f          	j	ffffffffc0201ff2 <kmalloc_init>
ffffffffc02031e0:	c80007b7          	lui	a5,0xc8000
ffffffffc02031e4:	b411                	j	ffffffffc0202be8 <pmm_init+0x90>
ffffffffc02031e6:	a8dfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031ea:	000b3783          	ld	a5,0(s6)
ffffffffc02031ee:	4505                	li	a0,1
ffffffffc02031f0:	6f9c                	ld	a5,24(a5)
ffffffffc02031f2:	9782                	jalr	a5
ffffffffc02031f4:	8c2a                	mv	s8,a0
ffffffffc02031f6:	a77fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031fa:	b9a9                	j	ffffffffc0202e54 <pmm_init+0x2fc>
ffffffffc02031fc:	a77fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203200:	000b3783          	ld	a5,0(s6)
ffffffffc0203204:	4505                	li	a0,1
ffffffffc0203206:	6f9c                	ld	a5,24(a5)
ffffffffc0203208:	9782                	jalr	a5
ffffffffc020320a:	8a2a                	mv	s4,a0
ffffffffc020320c:	a61fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203210:	b645                	j	ffffffffc0202db0 <pmm_init+0x258>
ffffffffc0203212:	a61fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203216:	000b3783          	ld	a5,0(s6)
ffffffffc020321a:	779c                	ld	a5,40(a5)
ffffffffc020321c:	9782                	jalr	a5
ffffffffc020321e:	842a                	mv	s0,a0
ffffffffc0203220:	a4dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203224:	b6b9                	j	ffffffffc0202d72 <pmm_init+0x21a>
ffffffffc0203226:	a4dfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020322a:	000b3783          	ld	a5,0(s6)
ffffffffc020322e:	4505                	li	a0,1
ffffffffc0203230:	6f9c                	ld	a5,24(a5)
ffffffffc0203232:	9782                	jalr	a5
ffffffffc0203234:	842a                	mv	s0,a0
ffffffffc0203236:	a37fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020323a:	bc99                	j	ffffffffc0202c90 <pmm_init+0x138>
ffffffffc020323c:	6705                	lui	a4,0x1
ffffffffc020323e:	177d                	addi	a4,a4,-1
ffffffffc0203240:	96ba                	add	a3,a3,a4
ffffffffc0203242:	8ff5                	and	a5,a5,a3
ffffffffc0203244:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203248:	1ca77063          	bgeu	a4,a0,ffffffffc0203408 <pmm_init+0x8b0>
ffffffffc020324c:	000b3683          	ld	a3,0(s6)
ffffffffc0203250:	fff80537          	lui	a0,0xfff80
ffffffffc0203254:	972a                	add	a4,a4,a0
ffffffffc0203256:	6a94                	ld	a3,16(a3)
ffffffffc0203258:	8c1d                	sub	s0,s0,a5
ffffffffc020325a:	00671513          	slli	a0,a4,0x6
ffffffffc020325e:	00c45593          	srli	a1,s0,0xc
ffffffffc0203262:	9532                	add	a0,a0,a2
ffffffffc0203264:	9682                	jalr	a3
ffffffffc0203266:	0009b583          	ld	a1,0(s3)
ffffffffc020326a:	bac5                	j	ffffffffc0202c5a <pmm_init+0x102>
ffffffffc020326c:	a07fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203270:	000b3783          	ld	a5,0(s6)
ffffffffc0203274:	779c                	ld	a5,40(a5)
ffffffffc0203276:	9782                	jalr	a5
ffffffffc0203278:	8c2a                	mv	s8,a0
ffffffffc020327a:	9f3fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020327e:	b361                	j	ffffffffc0203006 <pmm_init+0x4ae>
ffffffffc0203280:	9f3fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203284:	000b3783          	ld	a5,0(s6)
ffffffffc0203288:	779c                	ld	a5,40(a5)
ffffffffc020328a:	9782                	jalr	a5
ffffffffc020328c:	8a2a                	mv	s4,a0
ffffffffc020328e:	9dffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203292:	bb81                	j	ffffffffc0202fe2 <pmm_init+0x48a>
ffffffffc0203294:	e42a                	sd	a0,8(sp)
ffffffffc0203296:	9ddfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020329a:	000b3783          	ld	a5,0(s6)
ffffffffc020329e:	6522                	ld	a0,8(sp)
ffffffffc02032a0:	4585                	li	a1,1
ffffffffc02032a2:	739c                	ld	a5,32(a5)
ffffffffc02032a4:	9782                	jalr	a5
ffffffffc02032a6:	9c7fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032aa:	bb21                	j	ffffffffc0202fc2 <pmm_init+0x46a>
ffffffffc02032ac:	e42a                	sd	a0,8(sp)
ffffffffc02032ae:	9c5fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02032b2:	000b3783          	ld	a5,0(s6)
ffffffffc02032b6:	6522                	ld	a0,8(sp)
ffffffffc02032b8:	4585                	li	a1,1
ffffffffc02032ba:	739c                	ld	a5,32(a5)
ffffffffc02032bc:	9782                	jalr	a5
ffffffffc02032be:	9affd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032c2:	b9c1                	j	ffffffffc0202f92 <pmm_init+0x43a>
ffffffffc02032c4:	9affd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02032c8:	000b3783          	ld	a5,0(s6)
ffffffffc02032cc:	4505                	li	a0,1
ffffffffc02032ce:	6f9c                	ld	a5,24(a5)
ffffffffc02032d0:	9782                	jalr	a5
ffffffffc02032d2:	8a2a                	mv	s4,a0
ffffffffc02032d4:	999fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032d8:	bb51                	j	ffffffffc020306c <pmm_init+0x514>
ffffffffc02032da:	999fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02032de:	000b3783          	ld	a5,0(s6)
ffffffffc02032e2:	779c                	ld	a5,40(a5)
ffffffffc02032e4:	9782                	jalr	a5
ffffffffc02032e6:	842a                	mv	s0,a0
ffffffffc02032e8:	985fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032ec:	b5e1                	j	ffffffffc02031b4 <pmm_init+0x65c>
ffffffffc02032ee:	e42a                	sd	a0,8(sp)
ffffffffc02032f0:	983fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02032f4:	000b3783          	ld	a5,0(s6)
ffffffffc02032f8:	6522                	ld	a0,8(sp)
ffffffffc02032fa:	4585                	li	a1,1
ffffffffc02032fc:	739c                	ld	a5,32(a5)
ffffffffc02032fe:	9782                	jalr	a5
ffffffffc0203300:	96dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203304:	bd41                	j	ffffffffc0203194 <pmm_init+0x63c>
ffffffffc0203306:	e42a                	sd	a0,8(sp)
ffffffffc0203308:	96bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020330c:	000b3783          	ld	a5,0(s6)
ffffffffc0203310:	6522                	ld	a0,8(sp)
ffffffffc0203312:	4585                	li	a1,1
ffffffffc0203314:	739c                	ld	a5,32(a5)
ffffffffc0203316:	9782                	jalr	a5
ffffffffc0203318:	955fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020331c:	b5a1                	j	ffffffffc0203164 <pmm_init+0x60c>
ffffffffc020331e:	955fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203322:	000b3783          	ld	a5,0(s6)
ffffffffc0203326:	4585                	li	a1,1
ffffffffc0203328:	8552                	mv	a0,s4
ffffffffc020332a:	739c                	ld	a5,32(a5)
ffffffffc020332c:	9782                	jalr	a5
ffffffffc020332e:	93ffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203332:	b511                	j	ffffffffc0203136 <pmm_init+0x5de>
ffffffffc0203334:	00010417          	auipc	s0,0x10
ffffffffc0203338:	ccc40413          	addi	s0,s0,-820 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc020333c:	00010797          	auipc	a5,0x10
ffffffffc0203340:	cc478793          	addi	a5,a5,-828 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0203344:	a0f41de3          	bne	s0,a5,ffffffffc0202d5e <pmm_init+0x206>
ffffffffc0203348:	4581                	li	a1,0
ffffffffc020334a:	6605                	lui	a2,0x1
ffffffffc020334c:	8522                	mv	a0,s0
ffffffffc020334e:	346080ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0203352:	0000d597          	auipc	a1,0xd
ffffffffc0203356:	cae58593          	addi	a1,a1,-850 # ffffffffc0210000 <bootstackguard>
ffffffffc020335a:	0000e797          	auipc	a5,0xe
ffffffffc020335e:	ca0782a3          	sb	zero,-859(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc0203362:	0000d797          	auipc	a5,0xd
ffffffffc0203366:	c8078f23          	sb	zero,-866(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc020336a:	00093503          	ld	a0,0(s2)
ffffffffc020336e:	2555ec63          	bltu	a1,s5,ffffffffc02035c6 <pmm_init+0xa6e>
ffffffffc0203372:	0009b683          	ld	a3,0(s3)
ffffffffc0203376:	4701                	li	a4,0
ffffffffc0203378:	6605                	lui	a2,0x1
ffffffffc020337a:	40d586b3          	sub	a3,a1,a3
ffffffffc020337e:	956ff0ef          	jal	ra,ffffffffc02024d4 <boot_map_segment>
ffffffffc0203382:	00093503          	ld	a0,0(s2)
ffffffffc0203386:	23546363          	bltu	s0,s5,ffffffffc02035ac <pmm_init+0xa54>
ffffffffc020338a:	0009b683          	ld	a3,0(s3)
ffffffffc020338e:	4701                	li	a4,0
ffffffffc0203390:	6605                	lui	a2,0x1
ffffffffc0203392:	40d406b3          	sub	a3,s0,a3
ffffffffc0203396:	85a2                	mv	a1,s0
ffffffffc0203398:	93cff0ef          	jal	ra,ffffffffc02024d4 <boot_map_segment>
ffffffffc020339c:	12000073          	sfence.vma
ffffffffc02033a0:	00009517          	auipc	a0,0x9
ffffffffc02033a4:	58050513          	addi	a0,a0,1408 # ffffffffc020c920 <default_pmm_manager+0x2c8>
ffffffffc02033a8:	dfffc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02033ac:	ba4d                	j	ffffffffc0202d5e <pmm_init+0x206>
ffffffffc02033ae:	0000a697          	auipc	a3,0xa
ffffffffc02033b2:	8c268693          	addi	a3,a3,-1854 # ffffffffc020cc70 <default_pmm_manager+0x618>
ffffffffc02033b6:	00008617          	auipc	a2,0x8
ffffffffc02033ba:	7c260613          	addi	a2,a2,1986 # ffffffffc020bb78 <commands+0x210>
ffffffffc02033be:	29000593          	li	a1,656
ffffffffc02033c2:	00009517          	auipc	a0,0x9
ffffffffc02033c6:	3e650513          	addi	a0,a0,998 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02033ca:	8d4fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033ce:	86a2                	mv	a3,s0
ffffffffc02033d0:	00009617          	auipc	a2,0x9
ffffffffc02033d4:	2c060613          	addi	a2,a2,704 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc02033d8:	29000593          	li	a1,656
ffffffffc02033dc:	00009517          	auipc	a0,0x9
ffffffffc02033e0:	3cc50513          	addi	a0,a0,972 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02033e4:	8bafd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033e8:	0000a697          	auipc	a3,0xa
ffffffffc02033ec:	8c868693          	addi	a3,a3,-1848 # ffffffffc020ccb0 <default_pmm_manager+0x658>
ffffffffc02033f0:	00008617          	auipc	a2,0x8
ffffffffc02033f4:	78860613          	addi	a2,a2,1928 # ffffffffc020bb78 <commands+0x210>
ffffffffc02033f8:	29100593          	li	a1,657
ffffffffc02033fc:	00009517          	auipc	a0,0x9
ffffffffc0203400:	3ac50513          	addi	a0,a0,940 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203404:	89afd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203408:	db5fe0ef          	jal	ra,ffffffffc02021bc <pa2page.part.0>
ffffffffc020340c:	00009697          	auipc	a3,0x9
ffffffffc0203410:	6cc68693          	addi	a3,a3,1740 # ffffffffc020cad8 <default_pmm_manager+0x480>
ffffffffc0203414:	00008617          	auipc	a2,0x8
ffffffffc0203418:	76460613          	addi	a2,a2,1892 # ffffffffc020bb78 <commands+0x210>
ffffffffc020341c:	26d00593          	li	a1,621
ffffffffc0203420:	00009517          	auipc	a0,0x9
ffffffffc0203424:	38850513          	addi	a0,a0,904 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203428:	876fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020342c:	0000a697          	auipc	a3,0xa
ffffffffc0203430:	90c68693          	addi	a3,a3,-1780 # ffffffffc020cd38 <default_pmm_manager+0x6e0>
ffffffffc0203434:	00008617          	auipc	a2,0x8
ffffffffc0203438:	74460613          	addi	a2,a2,1860 # ffffffffc020bb78 <commands+0x210>
ffffffffc020343c:	29a00593          	li	a1,666
ffffffffc0203440:	00009517          	auipc	a0,0x9
ffffffffc0203444:	36850513          	addi	a0,a0,872 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203448:	856fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020344c:	00009697          	auipc	a3,0x9
ffffffffc0203450:	7ac68693          	addi	a3,a3,1964 # ffffffffc020cbf8 <default_pmm_manager+0x5a0>
ffffffffc0203454:	00008617          	auipc	a2,0x8
ffffffffc0203458:	72460613          	addi	a2,a2,1828 # ffffffffc020bb78 <commands+0x210>
ffffffffc020345c:	27900593          	li	a1,633
ffffffffc0203460:	00009517          	auipc	a0,0x9
ffffffffc0203464:	34850513          	addi	a0,a0,840 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203468:	836fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020346c:	00009697          	auipc	a3,0x9
ffffffffc0203470:	75c68693          	addi	a3,a3,1884 # ffffffffc020cbc8 <default_pmm_manager+0x570>
ffffffffc0203474:	00008617          	auipc	a2,0x8
ffffffffc0203478:	70460613          	addi	a2,a2,1796 # ffffffffc020bb78 <commands+0x210>
ffffffffc020347c:	26f00593          	li	a1,623
ffffffffc0203480:	00009517          	auipc	a0,0x9
ffffffffc0203484:	32850513          	addi	a0,a0,808 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203488:	816fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020348c:	00009697          	auipc	a3,0x9
ffffffffc0203490:	5ac68693          	addi	a3,a3,1452 # ffffffffc020ca38 <default_pmm_manager+0x3e0>
ffffffffc0203494:	00008617          	auipc	a2,0x8
ffffffffc0203498:	6e460613          	addi	a2,a2,1764 # ffffffffc020bb78 <commands+0x210>
ffffffffc020349c:	26e00593          	li	a1,622
ffffffffc02034a0:	00009517          	auipc	a0,0x9
ffffffffc02034a4:	30850513          	addi	a0,a0,776 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02034a8:	ff7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034ac:	00009697          	auipc	a3,0x9
ffffffffc02034b0:	70468693          	addi	a3,a3,1796 # ffffffffc020cbb0 <default_pmm_manager+0x558>
ffffffffc02034b4:	00008617          	auipc	a2,0x8
ffffffffc02034b8:	6c460613          	addi	a2,a2,1732 # ffffffffc020bb78 <commands+0x210>
ffffffffc02034bc:	27300593          	li	a1,627
ffffffffc02034c0:	00009517          	auipc	a0,0x9
ffffffffc02034c4:	2e850513          	addi	a0,a0,744 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02034c8:	fd7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034cc:	00009697          	auipc	a3,0x9
ffffffffc02034d0:	58468693          	addi	a3,a3,1412 # ffffffffc020ca50 <default_pmm_manager+0x3f8>
ffffffffc02034d4:	00008617          	auipc	a2,0x8
ffffffffc02034d8:	6a460613          	addi	a2,a2,1700 # ffffffffc020bb78 <commands+0x210>
ffffffffc02034dc:	27200593          	li	a1,626
ffffffffc02034e0:	00009517          	auipc	a0,0x9
ffffffffc02034e4:	2c850513          	addi	a0,a0,712 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02034e8:	fb7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034ec:	00009697          	auipc	a3,0x9
ffffffffc02034f0:	7dc68693          	addi	a3,a3,2012 # ffffffffc020ccc8 <default_pmm_manager+0x670>
ffffffffc02034f4:	00008617          	auipc	a2,0x8
ffffffffc02034f8:	68460613          	addi	a2,a2,1668 # ffffffffc020bb78 <commands+0x210>
ffffffffc02034fc:	29400593          	li	a1,660
ffffffffc0203500:	00009517          	auipc	a0,0x9
ffffffffc0203504:	2a850513          	addi	a0,a0,680 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203508:	f97fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020350c:	0000a697          	auipc	a3,0xa
ffffffffc0203510:	81468693          	addi	a3,a3,-2028 # ffffffffc020cd20 <default_pmm_manager+0x6c8>
ffffffffc0203514:	00008617          	auipc	a2,0x8
ffffffffc0203518:	66460613          	addi	a2,a2,1636 # ffffffffc020bb78 <commands+0x210>
ffffffffc020351c:	29900593          	li	a1,665
ffffffffc0203520:	00009517          	auipc	a0,0x9
ffffffffc0203524:	28850513          	addi	a0,a0,648 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203528:	f77fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020352c:	00009697          	auipc	a3,0x9
ffffffffc0203530:	7b468693          	addi	a3,a3,1972 # ffffffffc020cce0 <default_pmm_manager+0x688>
ffffffffc0203534:	00008617          	auipc	a2,0x8
ffffffffc0203538:	64460613          	addi	a2,a2,1604 # ffffffffc020bb78 <commands+0x210>
ffffffffc020353c:	29800593          	li	a1,664
ffffffffc0203540:	00009517          	auipc	a0,0x9
ffffffffc0203544:	26850513          	addi	a0,a0,616 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203548:	f57fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020354c:	0000a697          	auipc	a3,0xa
ffffffffc0203550:	89c68693          	addi	a3,a3,-1892 # ffffffffc020cde8 <default_pmm_manager+0x790>
ffffffffc0203554:	00008617          	auipc	a2,0x8
ffffffffc0203558:	62460613          	addi	a2,a2,1572 # ffffffffc020bb78 <commands+0x210>
ffffffffc020355c:	2a200593          	li	a1,674
ffffffffc0203560:	00009517          	auipc	a0,0x9
ffffffffc0203564:	24850513          	addi	a0,a0,584 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203568:	f37fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020356c:	0000a697          	auipc	a3,0xa
ffffffffc0203570:	84468693          	addi	a3,a3,-1980 # ffffffffc020cdb0 <default_pmm_manager+0x758>
ffffffffc0203574:	00008617          	auipc	a2,0x8
ffffffffc0203578:	60460613          	addi	a2,a2,1540 # ffffffffc020bb78 <commands+0x210>
ffffffffc020357c:	29f00593          	li	a1,671
ffffffffc0203580:	00009517          	auipc	a0,0x9
ffffffffc0203584:	22850513          	addi	a0,a0,552 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203588:	f17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020358c:	00009697          	auipc	a3,0x9
ffffffffc0203590:	7f468693          	addi	a3,a3,2036 # ffffffffc020cd80 <default_pmm_manager+0x728>
ffffffffc0203594:	00008617          	auipc	a2,0x8
ffffffffc0203598:	5e460613          	addi	a2,a2,1508 # ffffffffc020bb78 <commands+0x210>
ffffffffc020359c:	29b00593          	li	a1,667
ffffffffc02035a0:	00009517          	auipc	a0,0x9
ffffffffc02035a4:	20850513          	addi	a0,a0,520 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02035a8:	ef7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035ac:	86a2                	mv	a3,s0
ffffffffc02035ae:	00009617          	auipc	a2,0x9
ffffffffc02035b2:	18a60613          	addi	a2,a2,394 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02035b6:	0dc00593          	li	a1,220
ffffffffc02035ba:	00009517          	auipc	a0,0x9
ffffffffc02035be:	1ee50513          	addi	a0,a0,494 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02035c2:	eddfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035c6:	86ae                	mv	a3,a1
ffffffffc02035c8:	00009617          	auipc	a2,0x9
ffffffffc02035cc:	17060613          	addi	a2,a2,368 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02035d0:	0db00593          	li	a1,219
ffffffffc02035d4:	00009517          	auipc	a0,0x9
ffffffffc02035d8:	1d450513          	addi	a0,a0,468 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02035dc:	ec3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035e0:	00009697          	auipc	a3,0x9
ffffffffc02035e4:	38868693          	addi	a3,a3,904 # ffffffffc020c968 <default_pmm_manager+0x310>
ffffffffc02035e8:	00008617          	auipc	a2,0x8
ffffffffc02035ec:	59060613          	addi	a2,a2,1424 # ffffffffc020bb78 <commands+0x210>
ffffffffc02035f0:	25200593          	li	a1,594
ffffffffc02035f4:	00009517          	auipc	a0,0x9
ffffffffc02035f8:	1b450513          	addi	a0,a0,436 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02035fc:	ea3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203600:	00009697          	auipc	a3,0x9
ffffffffc0203604:	34868693          	addi	a3,a3,840 # ffffffffc020c948 <default_pmm_manager+0x2f0>
ffffffffc0203608:	00008617          	auipc	a2,0x8
ffffffffc020360c:	57060613          	addi	a2,a2,1392 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203610:	25100593          	li	a1,593
ffffffffc0203614:	00009517          	auipc	a0,0x9
ffffffffc0203618:	19450513          	addi	a0,a0,404 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020361c:	e83fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203620:	00009617          	auipc	a2,0x9
ffffffffc0203624:	2b860613          	addi	a2,a2,696 # ffffffffc020c8d8 <default_pmm_manager+0x280>
ffffffffc0203628:	0aa00593          	li	a1,170
ffffffffc020362c:	00009517          	auipc	a0,0x9
ffffffffc0203630:	17c50513          	addi	a0,a0,380 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203634:	e6bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203638:	00009617          	auipc	a2,0x9
ffffffffc020363c:	20860613          	addi	a2,a2,520 # ffffffffc020c840 <default_pmm_manager+0x1e8>
ffffffffc0203640:	06500593          	li	a1,101
ffffffffc0203644:	00009517          	auipc	a0,0x9
ffffffffc0203648:	16450513          	addi	a0,a0,356 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020364c:	e53fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203650:	00009697          	auipc	a3,0x9
ffffffffc0203654:	5d868693          	addi	a3,a3,1496 # ffffffffc020cc28 <default_pmm_manager+0x5d0>
ffffffffc0203658:	00008617          	auipc	a2,0x8
ffffffffc020365c:	52060613          	addi	a2,a2,1312 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203660:	2ab00593          	li	a1,683
ffffffffc0203664:	00009517          	auipc	a0,0x9
ffffffffc0203668:	14450513          	addi	a0,a0,324 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020366c:	e33fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203670:	00009697          	auipc	a3,0x9
ffffffffc0203674:	3f868693          	addi	a3,a3,1016 # ffffffffc020ca68 <default_pmm_manager+0x410>
ffffffffc0203678:	00008617          	auipc	a2,0x8
ffffffffc020367c:	50060613          	addi	a2,a2,1280 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203680:	26000593          	li	a1,608
ffffffffc0203684:	00009517          	auipc	a0,0x9
ffffffffc0203688:	12450513          	addi	a0,a0,292 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc020368c:	e13fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203690:	86d6                	mv	a3,s5
ffffffffc0203692:	00009617          	auipc	a2,0x9
ffffffffc0203696:	ffe60613          	addi	a2,a2,-2 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc020369a:	25f00593          	li	a1,607
ffffffffc020369e:	00009517          	auipc	a0,0x9
ffffffffc02036a2:	10a50513          	addi	a0,a0,266 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02036a6:	df9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036aa:	00009697          	auipc	a3,0x9
ffffffffc02036ae:	50668693          	addi	a3,a3,1286 # ffffffffc020cbb0 <default_pmm_manager+0x558>
ffffffffc02036b2:	00008617          	auipc	a2,0x8
ffffffffc02036b6:	4c660613          	addi	a2,a2,1222 # ffffffffc020bb78 <commands+0x210>
ffffffffc02036ba:	26c00593          	li	a1,620
ffffffffc02036be:	00009517          	auipc	a0,0x9
ffffffffc02036c2:	0ea50513          	addi	a0,a0,234 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02036c6:	dd9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036ca:	00009697          	auipc	a3,0x9
ffffffffc02036ce:	4ce68693          	addi	a3,a3,1230 # ffffffffc020cb98 <default_pmm_manager+0x540>
ffffffffc02036d2:	00008617          	auipc	a2,0x8
ffffffffc02036d6:	4a660613          	addi	a2,a2,1190 # ffffffffc020bb78 <commands+0x210>
ffffffffc02036da:	26b00593          	li	a1,619
ffffffffc02036de:	00009517          	auipc	a0,0x9
ffffffffc02036e2:	0ca50513          	addi	a0,a0,202 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02036e6:	db9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036ea:	00009697          	auipc	a3,0x9
ffffffffc02036ee:	47e68693          	addi	a3,a3,1150 # ffffffffc020cb68 <default_pmm_manager+0x510>
ffffffffc02036f2:	00008617          	auipc	a2,0x8
ffffffffc02036f6:	48660613          	addi	a2,a2,1158 # ffffffffc020bb78 <commands+0x210>
ffffffffc02036fa:	26a00593          	li	a1,618
ffffffffc02036fe:	00009517          	auipc	a0,0x9
ffffffffc0203702:	0aa50513          	addi	a0,a0,170 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203706:	d99fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020370a:	00009697          	auipc	a3,0x9
ffffffffc020370e:	44668693          	addi	a3,a3,1094 # ffffffffc020cb50 <default_pmm_manager+0x4f8>
ffffffffc0203712:	00008617          	auipc	a2,0x8
ffffffffc0203716:	46660613          	addi	a2,a2,1126 # ffffffffc020bb78 <commands+0x210>
ffffffffc020371a:	26800593          	li	a1,616
ffffffffc020371e:	00009517          	auipc	a0,0x9
ffffffffc0203722:	08a50513          	addi	a0,a0,138 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203726:	d79fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020372a:	00009697          	auipc	a3,0x9
ffffffffc020372e:	40668693          	addi	a3,a3,1030 # ffffffffc020cb30 <default_pmm_manager+0x4d8>
ffffffffc0203732:	00008617          	auipc	a2,0x8
ffffffffc0203736:	44660613          	addi	a2,a2,1094 # ffffffffc020bb78 <commands+0x210>
ffffffffc020373a:	26700593          	li	a1,615
ffffffffc020373e:	00009517          	auipc	a0,0x9
ffffffffc0203742:	06a50513          	addi	a0,a0,106 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203746:	d59fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020374a:	00009697          	auipc	a3,0x9
ffffffffc020374e:	3d668693          	addi	a3,a3,982 # ffffffffc020cb20 <default_pmm_manager+0x4c8>
ffffffffc0203752:	00008617          	auipc	a2,0x8
ffffffffc0203756:	42660613          	addi	a2,a2,1062 # ffffffffc020bb78 <commands+0x210>
ffffffffc020375a:	26600593          	li	a1,614
ffffffffc020375e:	00009517          	auipc	a0,0x9
ffffffffc0203762:	04a50513          	addi	a0,a0,74 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203766:	d39fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020376a:	00009697          	auipc	a3,0x9
ffffffffc020376e:	3a668693          	addi	a3,a3,934 # ffffffffc020cb10 <default_pmm_manager+0x4b8>
ffffffffc0203772:	00008617          	auipc	a2,0x8
ffffffffc0203776:	40660613          	addi	a2,a2,1030 # ffffffffc020bb78 <commands+0x210>
ffffffffc020377a:	26500593          	li	a1,613
ffffffffc020377e:	00009517          	auipc	a0,0x9
ffffffffc0203782:	02a50513          	addi	a0,a0,42 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203786:	d19fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020378a:	00009697          	auipc	a3,0x9
ffffffffc020378e:	34e68693          	addi	a3,a3,846 # ffffffffc020cad8 <default_pmm_manager+0x480>
ffffffffc0203792:	00008617          	auipc	a2,0x8
ffffffffc0203796:	3e660613          	addi	a2,a2,998 # ffffffffc020bb78 <commands+0x210>
ffffffffc020379a:	26400593          	li	a1,612
ffffffffc020379e:	00009517          	auipc	a0,0x9
ffffffffc02037a2:	00a50513          	addi	a0,a0,10 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02037a6:	cf9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037aa:	00009697          	auipc	a3,0x9
ffffffffc02037ae:	47e68693          	addi	a3,a3,1150 # ffffffffc020cc28 <default_pmm_manager+0x5d0>
ffffffffc02037b2:	00008617          	auipc	a2,0x8
ffffffffc02037b6:	3c660613          	addi	a2,a2,966 # ffffffffc020bb78 <commands+0x210>
ffffffffc02037ba:	28100593          	li	a1,641
ffffffffc02037be:	00009517          	auipc	a0,0x9
ffffffffc02037c2:	fea50513          	addi	a0,a0,-22 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02037c6:	cd9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037ca:	00009617          	auipc	a2,0x9
ffffffffc02037ce:	ec660613          	addi	a2,a2,-314 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc02037d2:	07100593          	li	a1,113
ffffffffc02037d6:	00009517          	auipc	a0,0x9
ffffffffc02037da:	ee250513          	addi	a0,a0,-286 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02037de:	cc1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037e2:	86a2                	mv	a3,s0
ffffffffc02037e4:	00009617          	auipc	a2,0x9
ffffffffc02037e8:	f5460613          	addi	a2,a2,-172 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02037ec:	0ca00593          	li	a1,202
ffffffffc02037f0:	00009517          	auipc	a0,0x9
ffffffffc02037f4:	fb850513          	addi	a0,a0,-72 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02037f8:	ca7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037fc:	00009617          	auipc	a2,0x9
ffffffffc0203800:	f3c60613          	addi	a2,a2,-196 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc0203804:	08100593          	li	a1,129
ffffffffc0203808:	00009517          	auipc	a0,0x9
ffffffffc020380c:	fa050513          	addi	a0,a0,-96 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203810:	c8ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203814:	00009697          	auipc	a3,0x9
ffffffffc0203818:	28468693          	addi	a3,a3,644 # ffffffffc020ca98 <default_pmm_manager+0x440>
ffffffffc020381c:	00008617          	auipc	a2,0x8
ffffffffc0203820:	35c60613          	addi	a2,a2,860 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203824:	26300593          	li	a1,611
ffffffffc0203828:	00009517          	auipc	a0,0x9
ffffffffc020382c:	f8050513          	addi	a0,a0,-128 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203830:	c6ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203834:	00009697          	auipc	a3,0x9
ffffffffc0203838:	1a468693          	addi	a3,a3,420 # ffffffffc020c9d8 <default_pmm_manager+0x380>
ffffffffc020383c:	00008617          	auipc	a2,0x8
ffffffffc0203840:	33c60613          	addi	a2,a2,828 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203844:	25700593          	li	a1,599
ffffffffc0203848:	00009517          	auipc	a0,0x9
ffffffffc020384c:	f6050513          	addi	a0,a0,-160 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203850:	c4ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203854:	985fe0ef          	jal	ra,ffffffffc02021d8 <pte2page.part.0>
ffffffffc0203858:	00009697          	auipc	a3,0x9
ffffffffc020385c:	1b068693          	addi	a3,a3,432 # ffffffffc020ca08 <default_pmm_manager+0x3b0>
ffffffffc0203860:	00008617          	auipc	a2,0x8
ffffffffc0203864:	31860613          	addi	a2,a2,792 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203868:	25a00593          	li	a1,602
ffffffffc020386c:	00009517          	auipc	a0,0x9
ffffffffc0203870:	f3c50513          	addi	a0,a0,-196 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203874:	c2bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203878:	00009697          	auipc	a3,0x9
ffffffffc020387c:	13068693          	addi	a3,a3,304 # ffffffffc020c9a8 <default_pmm_manager+0x350>
ffffffffc0203880:	00008617          	auipc	a2,0x8
ffffffffc0203884:	2f860613          	addi	a2,a2,760 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203888:	25300593          	li	a1,595
ffffffffc020388c:	00009517          	auipc	a0,0x9
ffffffffc0203890:	f1c50513          	addi	a0,a0,-228 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203894:	c0bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203898:	00009697          	auipc	a3,0x9
ffffffffc020389c:	1a068693          	addi	a3,a3,416 # ffffffffc020ca38 <default_pmm_manager+0x3e0>
ffffffffc02038a0:	00008617          	auipc	a2,0x8
ffffffffc02038a4:	2d860613          	addi	a2,a2,728 # ffffffffc020bb78 <commands+0x210>
ffffffffc02038a8:	25b00593          	li	a1,603
ffffffffc02038ac:	00009517          	auipc	a0,0x9
ffffffffc02038b0:	efc50513          	addi	a0,a0,-260 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02038b4:	bebfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038b8:	00009617          	auipc	a2,0x9
ffffffffc02038bc:	dd860613          	addi	a2,a2,-552 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc02038c0:	25e00593          	li	a1,606
ffffffffc02038c4:	00009517          	auipc	a0,0x9
ffffffffc02038c8:	ee450513          	addi	a0,a0,-284 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02038cc:	bd3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038d0:	00009697          	auipc	a3,0x9
ffffffffc02038d4:	18068693          	addi	a3,a3,384 # ffffffffc020ca50 <default_pmm_manager+0x3f8>
ffffffffc02038d8:	00008617          	auipc	a2,0x8
ffffffffc02038dc:	2a060613          	addi	a2,a2,672 # ffffffffc020bb78 <commands+0x210>
ffffffffc02038e0:	25c00593          	li	a1,604
ffffffffc02038e4:	00009517          	auipc	a0,0x9
ffffffffc02038e8:	ec450513          	addi	a0,a0,-316 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc02038ec:	bb3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038f0:	86ca                	mv	a3,s2
ffffffffc02038f2:	00009617          	auipc	a2,0x9
ffffffffc02038f6:	e4660613          	addi	a2,a2,-442 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02038fa:	0c600593          	li	a1,198
ffffffffc02038fe:	00009517          	auipc	a0,0x9
ffffffffc0203902:	eaa50513          	addi	a0,a0,-342 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203906:	b99fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020390a:	00009697          	auipc	a3,0x9
ffffffffc020390e:	2a668693          	addi	a3,a3,678 # ffffffffc020cbb0 <default_pmm_manager+0x558>
ffffffffc0203912:	00008617          	auipc	a2,0x8
ffffffffc0203916:	26660613          	addi	a2,a2,614 # ffffffffc020bb78 <commands+0x210>
ffffffffc020391a:	27700593          	li	a1,631
ffffffffc020391e:	00009517          	auipc	a0,0x9
ffffffffc0203922:	e8a50513          	addi	a0,a0,-374 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203926:	b79fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020392a:	00009697          	auipc	a3,0x9
ffffffffc020392e:	2b668693          	addi	a3,a3,694 # ffffffffc020cbe0 <default_pmm_manager+0x588>
ffffffffc0203932:	00008617          	auipc	a2,0x8
ffffffffc0203936:	24660613          	addi	a2,a2,582 # ffffffffc020bb78 <commands+0x210>
ffffffffc020393a:	27600593          	li	a1,630
ffffffffc020393e:	00009517          	auipc	a0,0x9
ffffffffc0203942:	e6a50513          	addi	a0,a0,-406 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203946:	b59fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020394a <copy_range>:
ffffffffc020394a:	7159                	addi	sp,sp,-112
ffffffffc020394c:	00d667b3          	or	a5,a2,a3
ffffffffc0203950:	f486                	sd	ra,104(sp)
ffffffffc0203952:	f0a2                	sd	s0,96(sp)
ffffffffc0203954:	eca6                	sd	s1,88(sp)
ffffffffc0203956:	e8ca                	sd	s2,80(sp)
ffffffffc0203958:	e4ce                	sd	s3,72(sp)
ffffffffc020395a:	e0d2                	sd	s4,64(sp)
ffffffffc020395c:	fc56                	sd	s5,56(sp)
ffffffffc020395e:	f85a                	sd	s6,48(sp)
ffffffffc0203960:	f45e                	sd	s7,40(sp)
ffffffffc0203962:	f062                	sd	s8,32(sp)
ffffffffc0203964:	ec66                	sd	s9,24(sp)
ffffffffc0203966:	e86a                	sd	s10,16(sp)
ffffffffc0203968:	e46e                	sd	s11,8(sp)
ffffffffc020396a:	17d2                	slli	a5,a5,0x34
ffffffffc020396c:	20079f63          	bnez	a5,ffffffffc0203b8a <copy_range+0x240>
ffffffffc0203970:	002007b7          	lui	a5,0x200
ffffffffc0203974:	8432                	mv	s0,a2
ffffffffc0203976:	1af66263          	bltu	a2,a5,ffffffffc0203b1a <copy_range+0x1d0>
ffffffffc020397a:	8936                	mv	s2,a3
ffffffffc020397c:	18d67f63          	bgeu	a2,a3,ffffffffc0203b1a <copy_range+0x1d0>
ffffffffc0203980:	4785                	li	a5,1
ffffffffc0203982:	07fe                	slli	a5,a5,0x1f
ffffffffc0203984:	18d7eb63          	bltu	a5,a3,ffffffffc0203b1a <copy_range+0x1d0>
ffffffffc0203988:	5b7d                	li	s6,-1
ffffffffc020398a:	8aaa                	mv	s5,a0
ffffffffc020398c:	89ae                	mv	s3,a1
ffffffffc020398e:	6a05                	lui	s4,0x1
ffffffffc0203990:	00093c17          	auipc	s8,0x93
ffffffffc0203994:	f10c0c13          	addi	s8,s8,-240 # ffffffffc02968a0 <npage>
ffffffffc0203998:	00093b97          	auipc	s7,0x93
ffffffffc020399c:	f10b8b93          	addi	s7,s7,-240 # ffffffffc02968a8 <pages>
ffffffffc02039a0:	00cb5b13          	srli	s6,s6,0xc
ffffffffc02039a4:	00093c97          	auipc	s9,0x93
ffffffffc02039a8:	f0cc8c93          	addi	s9,s9,-244 # ffffffffc02968b0 <pmm_manager>
ffffffffc02039ac:	4601                	li	a2,0
ffffffffc02039ae:	85a2                	mv	a1,s0
ffffffffc02039b0:	854e                	mv	a0,s3
ffffffffc02039b2:	8fbfe0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc02039b6:	84aa                	mv	s1,a0
ffffffffc02039b8:	0e050c63          	beqz	a0,ffffffffc0203ab0 <copy_range+0x166>
ffffffffc02039bc:	611c                	ld	a5,0(a0)
ffffffffc02039be:	8b85                	andi	a5,a5,1
ffffffffc02039c0:	e785                	bnez	a5,ffffffffc02039e8 <copy_range+0x9e>
ffffffffc02039c2:	9452                	add	s0,s0,s4
ffffffffc02039c4:	ff2464e3          	bltu	s0,s2,ffffffffc02039ac <copy_range+0x62>
ffffffffc02039c8:	4501                	li	a0,0
ffffffffc02039ca:	70a6                	ld	ra,104(sp)
ffffffffc02039cc:	7406                	ld	s0,96(sp)
ffffffffc02039ce:	64e6                	ld	s1,88(sp)
ffffffffc02039d0:	6946                	ld	s2,80(sp)
ffffffffc02039d2:	69a6                	ld	s3,72(sp)
ffffffffc02039d4:	6a06                	ld	s4,64(sp)
ffffffffc02039d6:	7ae2                	ld	s5,56(sp)
ffffffffc02039d8:	7b42                	ld	s6,48(sp)
ffffffffc02039da:	7ba2                	ld	s7,40(sp)
ffffffffc02039dc:	7c02                	ld	s8,32(sp)
ffffffffc02039de:	6ce2                	ld	s9,24(sp)
ffffffffc02039e0:	6d42                	ld	s10,16(sp)
ffffffffc02039e2:	6da2                	ld	s11,8(sp)
ffffffffc02039e4:	6165                	addi	sp,sp,112
ffffffffc02039e6:	8082                	ret
ffffffffc02039e8:	4605                	li	a2,1
ffffffffc02039ea:	85a2                	mv	a1,s0
ffffffffc02039ec:	8556                	mv	a0,s5
ffffffffc02039ee:	8bffe0ef          	jal	ra,ffffffffc02022ac <get_pte>
ffffffffc02039f2:	c56d                	beqz	a0,ffffffffc0203adc <copy_range+0x192>
ffffffffc02039f4:	609c                	ld	a5,0(s1)
ffffffffc02039f6:	0017f713          	andi	a4,a5,1
ffffffffc02039fa:	01f7f493          	andi	s1,a5,31
ffffffffc02039fe:	16070a63          	beqz	a4,ffffffffc0203b72 <copy_range+0x228>
ffffffffc0203a02:	000c3683          	ld	a3,0(s8)
ffffffffc0203a06:	078a                	slli	a5,a5,0x2
ffffffffc0203a08:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203a0c:	14d77763          	bgeu	a4,a3,ffffffffc0203b5a <copy_range+0x210>
ffffffffc0203a10:	000bb783          	ld	a5,0(s7)
ffffffffc0203a14:	fff806b7          	lui	a3,0xfff80
ffffffffc0203a18:	9736                	add	a4,a4,a3
ffffffffc0203a1a:	071a                	slli	a4,a4,0x6
ffffffffc0203a1c:	00e78db3          	add	s11,a5,a4
ffffffffc0203a20:	10002773          	csrr	a4,sstatus
ffffffffc0203a24:	8b09                	andi	a4,a4,2
ffffffffc0203a26:	e345                	bnez	a4,ffffffffc0203ac6 <copy_range+0x17c>
ffffffffc0203a28:	000cb703          	ld	a4,0(s9)
ffffffffc0203a2c:	4505                	li	a0,1
ffffffffc0203a2e:	6f18                	ld	a4,24(a4)
ffffffffc0203a30:	9702                	jalr	a4
ffffffffc0203a32:	8d2a                	mv	s10,a0
ffffffffc0203a34:	0c0d8363          	beqz	s11,ffffffffc0203afa <copy_range+0x1b0>
ffffffffc0203a38:	100d0163          	beqz	s10,ffffffffc0203b3a <copy_range+0x1f0>
ffffffffc0203a3c:	000bb703          	ld	a4,0(s7)
ffffffffc0203a40:	000805b7          	lui	a1,0x80
ffffffffc0203a44:	000c3603          	ld	a2,0(s8)
ffffffffc0203a48:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203a4c:	8699                	srai	a3,a3,0x6
ffffffffc0203a4e:	96ae                	add	a3,a3,a1
ffffffffc0203a50:	0166f7b3          	and	a5,a3,s6
ffffffffc0203a54:	06b2                	slli	a3,a3,0xc
ffffffffc0203a56:	08c7f663          	bgeu	a5,a2,ffffffffc0203ae2 <copy_range+0x198>
ffffffffc0203a5a:	40ed07b3          	sub	a5,s10,a4
ffffffffc0203a5e:	00093717          	auipc	a4,0x93
ffffffffc0203a62:	e5a70713          	addi	a4,a4,-422 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0203a66:	6308                	ld	a0,0(a4)
ffffffffc0203a68:	8799                	srai	a5,a5,0x6
ffffffffc0203a6a:	97ae                	add	a5,a5,a1
ffffffffc0203a6c:	0167f733          	and	a4,a5,s6
ffffffffc0203a70:	00a685b3          	add	a1,a3,a0
ffffffffc0203a74:	07b2                	slli	a5,a5,0xc
ffffffffc0203a76:	06c77563          	bgeu	a4,a2,ffffffffc0203ae0 <copy_range+0x196>
ffffffffc0203a7a:	6605                	lui	a2,0x1
ffffffffc0203a7c:	953e                	add	a0,a0,a5
ffffffffc0203a7e:	469070ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0203a82:	86a6                	mv	a3,s1
ffffffffc0203a84:	8622                	mv	a2,s0
ffffffffc0203a86:	85ea                	mv	a1,s10
ffffffffc0203a88:	8556                	mv	a0,s5
ffffffffc0203a8a:	fd9fe0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc0203a8e:	d915                	beqz	a0,ffffffffc02039c2 <copy_range+0x78>
ffffffffc0203a90:	00009697          	auipc	a3,0x9
ffffffffc0203a94:	3c068693          	addi	a3,a3,960 # ffffffffc020ce50 <default_pmm_manager+0x7f8>
ffffffffc0203a98:	00008617          	auipc	a2,0x8
ffffffffc0203a9c:	0e060613          	addi	a2,a2,224 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203aa0:	1ef00593          	li	a1,495
ffffffffc0203aa4:	00009517          	auipc	a0,0x9
ffffffffc0203aa8:	d0450513          	addi	a0,a0,-764 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203aac:	9f3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ab0:	00200637          	lui	a2,0x200
ffffffffc0203ab4:	9432                	add	s0,s0,a2
ffffffffc0203ab6:	ffe00637          	lui	a2,0xffe00
ffffffffc0203aba:	8c71                	and	s0,s0,a2
ffffffffc0203abc:	f00406e3          	beqz	s0,ffffffffc02039c8 <copy_range+0x7e>
ffffffffc0203ac0:	ef2466e3          	bltu	s0,s2,ffffffffc02039ac <copy_range+0x62>
ffffffffc0203ac4:	b711                	j	ffffffffc02039c8 <copy_range+0x7e>
ffffffffc0203ac6:	9acfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203aca:	000cb703          	ld	a4,0(s9)
ffffffffc0203ace:	4505                	li	a0,1
ffffffffc0203ad0:	6f18                	ld	a4,24(a4)
ffffffffc0203ad2:	9702                	jalr	a4
ffffffffc0203ad4:	8d2a                	mv	s10,a0
ffffffffc0203ad6:	996fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203ada:	bfa9                	j	ffffffffc0203a34 <copy_range+0xea>
ffffffffc0203adc:	5571                	li	a0,-4
ffffffffc0203ade:	b5f5                	j	ffffffffc02039ca <copy_range+0x80>
ffffffffc0203ae0:	86be                	mv	a3,a5
ffffffffc0203ae2:	00009617          	auipc	a2,0x9
ffffffffc0203ae6:	bae60613          	addi	a2,a2,-1106 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0203aea:	07100593          	li	a1,113
ffffffffc0203aee:	00009517          	auipc	a0,0x9
ffffffffc0203af2:	bca50513          	addi	a0,a0,-1078 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0203af6:	9a9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203afa:	00009697          	auipc	a3,0x9
ffffffffc0203afe:	33668693          	addi	a3,a3,822 # ffffffffc020ce30 <default_pmm_manager+0x7d8>
ffffffffc0203b02:	00008617          	auipc	a2,0x8
ffffffffc0203b06:	07660613          	addi	a2,a2,118 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203b0a:	1ce00593          	li	a1,462
ffffffffc0203b0e:	00009517          	auipc	a0,0x9
ffffffffc0203b12:	c9a50513          	addi	a0,a0,-870 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203b16:	989fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b1a:	00009697          	auipc	a3,0x9
ffffffffc0203b1e:	cf668693          	addi	a3,a3,-778 # ffffffffc020c810 <default_pmm_manager+0x1b8>
ffffffffc0203b22:	00008617          	auipc	a2,0x8
ffffffffc0203b26:	05660613          	addi	a2,a2,86 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203b2a:	1b600593          	li	a1,438
ffffffffc0203b2e:	00009517          	auipc	a0,0x9
ffffffffc0203b32:	c7a50513          	addi	a0,a0,-902 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203b36:	969fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b3a:	00009697          	auipc	a3,0x9
ffffffffc0203b3e:	30668693          	addi	a3,a3,774 # ffffffffc020ce40 <default_pmm_manager+0x7e8>
ffffffffc0203b42:	00008617          	auipc	a2,0x8
ffffffffc0203b46:	03660613          	addi	a2,a2,54 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203b4a:	1cf00593          	li	a1,463
ffffffffc0203b4e:	00009517          	auipc	a0,0x9
ffffffffc0203b52:	c5a50513          	addi	a0,a0,-934 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203b56:	949fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b5a:	00009617          	auipc	a2,0x9
ffffffffc0203b5e:	c0660613          	addi	a2,a2,-1018 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc0203b62:	06900593          	li	a1,105
ffffffffc0203b66:	00009517          	auipc	a0,0x9
ffffffffc0203b6a:	b5250513          	addi	a0,a0,-1198 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0203b6e:	931fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b72:	00009617          	auipc	a2,0x9
ffffffffc0203b76:	c0e60613          	addi	a2,a2,-1010 # ffffffffc020c780 <default_pmm_manager+0x128>
ffffffffc0203b7a:	07f00593          	li	a1,127
ffffffffc0203b7e:	00009517          	auipc	a0,0x9
ffffffffc0203b82:	b3a50513          	addi	a0,a0,-1222 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0203b86:	919fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b8a:	00009697          	auipc	a3,0x9
ffffffffc0203b8e:	c5668693          	addi	a3,a3,-938 # ffffffffc020c7e0 <default_pmm_manager+0x188>
ffffffffc0203b92:	00008617          	auipc	a2,0x8
ffffffffc0203b96:	fe660613          	addi	a2,a2,-26 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203b9a:	1b500593          	li	a1,437
ffffffffc0203b9e:	00009517          	auipc	a0,0x9
ffffffffc0203ba2:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203ba6:	8f9fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203baa <pgdir_alloc_page>:
ffffffffc0203baa:	7179                	addi	sp,sp,-48
ffffffffc0203bac:	ec26                	sd	s1,24(sp)
ffffffffc0203bae:	e84a                	sd	s2,16(sp)
ffffffffc0203bb0:	e052                	sd	s4,0(sp)
ffffffffc0203bb2:	f406                	sd	ra,40(sp)
ffffffffc0203bb4:	f022                	sd	s0,32(sp)
ffffffffc0203bb6:	e44e                	sd	s3,8(sp)
ffffffffc0203bb8:	8a2a                	mv	s4,a0
ffffffffc0203bba:	84ae                	mv	s1,a1
ffffffffc0203bbc:	8932                	mv	s2,a2
ffffffffc0203bbe:	100027f3          	csrr	a5,sstatus
ffffffffc0203bc2:	8b89                	andi	a5,a5,2
ffffffffc0203bc4:	00093997          	auipc	s3,0x93
ffffffffc0203bc8:	cec98993          	addi	s3,s3,-788 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203bcc:	ef8d                	bnez	a5,ffffffffc0203c06 <pgdir_alloc_page+0x5c>
ffffffffc0203bce:	0009b783          	ld	a5,0(s3)
ffffffffc0203bd2:	4505                	li	a0,1
ffffffffc0203bd4:	6f9c                	ld	a5,24(a5)
ffffffffc0203bd6:	9782                	jalr	a5
ffffffffc0203bd8:	842a                	mv	s0,a0
ffffffffc0203bda:	cc09                	beqz	s0,ffffffffc0203bf4 <pgdir_alloc_page+0x4a>
ffffffffc0203bdc:	86ca                	mv	a3,s2
ffffffffc0203bde:	8626                	mv	a2,s1
ffffffffc0203be0:	85a2                	mv	a1,s0
ffffffffc0203be2:	8552                	mv	a0,s4
ffffffffc0203be4:	e7ffe0ef          	jal	ra,ffffffffc0202a62 <page_insert>
ffffffffc0203be8:	e915                	bnez	a0,ffffffffc0203c1c <pgdir_alloc_page+0x72>
ffffffffc0203bea:	4018                	lw	a4,0(s0)
ffffffffc0203bec:	fc04                	sd	s1,56(s0)
ffffffffc0203bee:	4785                	li	a5,1
ffffffffc0203bf0:	04f71e63          	bne	a4,a5,ffffffffc0203c4c <pgdir_alloc_page+0xa2>
ffffffffc0203bf4:	70a2                	ld	ra,40(sp)
ffffffffc0203bf6:	8522                	mv	a0,s0
ffffffffc0203bf8:	7402                	ld	s0,32(sp)
ffffffffc0203bfa:	64e2                	ld	s1,24(sp)
ffffffffc0203bfc:	6942                	ld	s2,16(sp)
ffffffffc0203bfe:	69a2                	ld	s3,8(sp)
ffffffffc0203c00:	6a02                	ld	s4,0(sp)
ffffffffc0203c02:	6145                	addi	sp,sp,48
ffffffffc0203c04:	8082                	ret
ffffffffc0203c06:	86cfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203c0a:	0009b783          	ld	a5,0(s3)
ffffffffc0203c0e:	4505                	li	a0,1
ffffffffc0203c10:	6f9c                	ld	a5,24(a5)
ffffffffc0203c12:	9782                	jalr	a5
ffffffffc0203c14:	842a                	mv	s0,a0
ffffffffc0203c16:	856fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203c1a:	b7c1                	j	ffffffffc0203bda <pgdir_alloc_page+0x30>
ffffffffc0203c1c:	100027f3          	csrr	a5,sstatus
ffffffffc0203c20:	8b89                	andi	a5,a5,2
ffffffffc0203c22:	eb89                	bnez	a5,ffffffffc0203c34 <pgdir_alloc_page+0x8a>
ffffffffc0203c24:	0009b783          	ld	a5,0(s3)
ffffffffc0203c28:	8522                	mv	a0,s0
ffffffffc0203c2a:	4585                	li	a1,1
ffffffffc0203c2c:	739c                	ld	a5,32(a5)
ffffffffc0203c2e:	4401                	li	s0,0
ffffffffc0203c30:	9782                	jalr	a5
ffffffffc0203c32:	b7c9                	j	ffffffffc0203bf4 <pgdir_alloc_page+0x4a>
ffffffffc0203c34:	83efd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203c38:	0009b783          	ld	a5,0(s3)
ffffffffc0203c3c:	8522                	mv	a0,s0
ffffffffc0203c3e:	4585                	li	a1,1
ffffffffc0203c40:	739c                	ld	a5,32(a5)
ffffffffc0203c42:	4401                	li	s0,0
ffffffffc0203c44:	9782                	jalr	a5
ffffffffc0203c46:	826fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203c4a:	b76d                	j	ffffffffc0203bf4 <pgdir_alloc_page+0x4a>
ffffffffc0203c4c:	00009697          	auipc	a3,0x9
ffffffffc0203c50:	21468693          	addi	a3,a3,532 # ffffffffc020ce60 <default_pmm_manager+0x808>
ffffffffc0203c54:	00008617          	auipc	a2,0x8
ffffffffc0203c58:	f2460613          	addi	a2,a2,-220 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203c5c:	23800593          	li	a1,568
ffffffffc0203c60:	00009517          	auipc	a0,0x9
ffffffffc0203c64:	b4850513          	addi	a0,a0,-1208 # ffffffffc020c7a8 <default_pmm_manager+0x150>
ffffffffc0203c68:	837fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c6c <check_vma_overlap.part.0>:
ffffffffc0203c6c:	1141                	addi	sp,sp,-16
ffffffffc0203c6e:	00009697          	auipc	a3,0x9
ffffffffc0203c72:	20a68693          	addi	a3,a3,522 # ffffffffc020ce78 <default_pmm_manager+0x820>
ffffffffc0203c76:	00008617          	auipc	a2,0x8
ffffffffc0203c7a:	f0260613          	addi	a2,a2,-254 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203c7e:	07400593          	li	a1,116
ffffffffc0203c82:	00009517          	auipc	a0,0x9
ffffffffc0203c86:	21650513          	addi	a0,a0,534 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203c8a:	e406                	sd	ra,8(sp)
ffffffffc0203c8c:	813fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c90 <mm_create>:
ffffffffc0203c90:	1141                	addi	sp,sp,-16
ffffffffc0203c92:	05800513          	li	a0,88
ffffffffc0203c96:	e022                	sd	s0,0(sp)
ffffffffc0203c98:	e406                	sd	ra,8(sp)
ffffffffc0203c9a:	b7cfe0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0203c9e:	842a                	mv	s0,a0
ffffffffc0203ca0:	c115                	beqz	a0,ffffffffc0203cc4 <mm_create+0x34>
ffffffffc0203ca2:	e408                	sd	a0,8(s0)
ffffffffc0203ca4:	e008                	sd	a0,0(s0)
ffffffffc0203ca6:	00053823          	sd	zero,16(a0)
ffffffffc0203caa:	00053c23          	sd	zero,24(a0)
ffffffffc0203cae:	02052023          	sw	zero,32(a0)
ffffffffc0203cb2:	02053423          	sd	zero,40(a0)
ffffffffc0203cb6:	02052823          	sw	zero,48(a0)
ffffffffc0203cba:	4585                	li	a1,1
ffffffffc0203cbc:	03850513          	addi	a0,a0,56
ffffffffc0203cc0:	19b000ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0203cc4:	60a2                	ld	ra,8(sp)
ffffffffc0203cc6:	8522                	mv	a0,s0
ffffffffc0203cc8:	6402                	ld	s0,0(sp)
ffffffffc0203cca:	0141                	addi	sp,sp,16
ffffffffc0203ccc:	8082                	ret

ffffffffc0203cce <find_vma>:
ffffffffc0203cce:	86aa                	mv	a3,a0
ffffffffc0203cd0:	c505                	beqz	a0,ffffffffc0203cf8 <find_vma+0x2a>
ffffffffc0203cd2:	6908                	ld	a0,16(a0)
ffffffffc0203cd4:	c501                	beqz	a0,ffffffffc0203cdc <find_vma+0xe>
ffffffffc0203cd6:	651c                	ld	a5,8(a0)
ffffffffc0203cd8:	02f5f263          	bgeu	a1,a5,ffffffffc0203cfc <find_vma+0x2e>
ffffffffc0203cdc:	669c                	ld	a5,8(a3)
ffffffffc0203cde:	00f68d63          	beq	a3,a5,ffffffffc0203cf8 <find_vma+0x2a>
ffffffffc0203ce2:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203ce6:	00e5e663          	bltu	a1,a4,ffffffffc0203cf2 <find_vma+0x24>
ffffffffc0203cea:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203cee:	00e5ec63          	bltu	a1,a4,ffffffffc0203d06 <find_vma+0x38>
ffffffffc0203cf2:	679c                	ld	a5,8(a5)
ffffffffc0203cf4:	fef697e3          	bne	a3,a5,ffffffffc0203ce2 <find_vma+0x14>
ffffffffc0203cf8:	4501                	li	a0,0
ffffffffc0203cfa:	8082                	ret
ffffffffc0203cfc:	691c                	ld	a5,16(a0)
ffffffffc0203cfe:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203cdc <find_vma+0xe>
ffffffffc0203d02:	ea88                	sd	a0,16(a3)
ffffffffc0203d04:	8082                	ret
ffffffffc0203d06:	fe078513          	addi	a0,a5,-32
ffffffffc0203d0a:	ea88                	sd	a0,16(a3)
ffffffffc0203d0c:	8082                	ret

ffffffffc0203d0e <insert_vma_struct>:
ffffffffc0203d0e:	6590                	ld	a2,8(a1)
ffffffffc0203d10:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0203d14:	1141                	addi	sp,sp,-16
ffffffffc0203d16:	e406                	sd	ra,8(sp)
ffffffffc0203d18:	87aa                	mv	a5,a0
ffffffffc0203d1a:	01066763          	bltu	a2,a6,ffffffffc0203d28 <insert_vma_struct+0x1a>
ffffffffc0203d1e:	a085                	j	ffffffffc0203d7e <insert_vma_struct+0x70>
ffffffffc0203d20:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d24:	04e66863          	bltu	a2,a4,ffffffffc0203d74 <insert_vma_struct+0x66>
ffffffffc0203d28:	86be                	mv	a3,a5
ffffffffc0203d2a:	679c                	ld	a5,8(a5)
ffffffffc0203d2c:	fef51ae3          	bne	a0,a5,ffffffffc0203d20 <insert_vma_struct+0x12>
ffffffffc0203d30:	02a68463          	beq	a3,a0,ffffffffc0203d58 <insert_vma_struct+0x4a>
ffffffffc0203d34:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203d38:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203d3c:	08e8f163          	bgeu	a7,a4,ffffffffc0203dbe <insert_vma_struct+0xb0>
ffffffffc0203d40:	04e66f63          	bltu	a2,a4,ffffffffc0203d9e <insert_vma_struct+0x90>
ffffffffc0203d44:	00f50a63          	beq	a0,a5,ffffffffc0203d58 <insert_vma_struct+0x4a>
ffffffffc0203d48:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d4c:	05076963          	bltu	a4,a6,ffffffffc0203d9e <insert_vma_struct+0x90>
ffffffffc0203d50:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203d54:	02c77363          	bgeu	a4,a2,ffffffffc0203d7a <insert_vma_struct+0x6c>
ffffffffc0203d58:	5118                	lw	a4,32(a0)
ffffffffc0203d5a:	e188                	sd	a0,0(a1)
ffffffffc0203d5c:	02058613          	addi	a2,a1,32
ffffffffc0203d60:	e390                	sd	a2,0(a5)
ffffffffc0203d62:	e690                	sd	a2,8(a3)
ffffffffc0203d64:	60a2                	ld	ra,8(sp)
ffffffffc0203d66:	f59c                	sd	a5,40(a1)
ffffffffc0203d68:	f194                	sd	a3,32(a1)
ffffffffc0203d6a:	0017079b          	addiw	a5,a4,1
ffffffffc0203d6e:	d11c                	sw	a5,32(a0)
ffffffffc0203d70:	0141                	addi	sp,sp,16
ffffffffc0203d72:	8082                	ret
ffffffffc0203d74:	fca690e3          	bne	a3,a0,ffffffffc0203d34 <insert_vma_struct+0x26>
ffffffffc0203d78:	bfd1                	j	ffffffffc0203d4c <insert_vma_struct+0x3e>
ffffffffc0203d7a:	ef3ff0ef          	jal	ra,ffffffffc0203c6c <check_vma_overlap.part.0>
ffffffffc0203d7e:	00009697          	auipc	a3,0x9
ffffffffc0203d82:	12a68693          	addi	a3,a3,298 # ffffffffc020cea8 <default_pmm_manager+0x850>
ffffffffc0203d86:	00008617          	auipc	a2,0x8
ffffffffc0203d8a:	df260613          	addi	a2,a2,-526 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203d8e:	07a00593          	li	a1,122
ffffffffc0203d92:	00009517          	auipc	a0,0x9
ffffffffc0203d96:	10650513          	addi	a0,a0,262 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203d9a:	f04fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d9e:	00009697          	auipc	a3,0x9
ffffffffc0203da2:	14a68693          	addi	a3,a3,330 # ffffffffc020cee8 <default_pmm_manager+0x890>
ffffffffc0203da6:	00008617          	auipc	a2,0x8
ffffffffc0203daa:	dd260613          	addi	a2,a2,-558 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203dae:	07300593          	li	a1,115
ffffffffc0203db2:	00009517          	auipc	a0,0x9
ffffffffc0203db6:	0e650513          	addi	a0,a0,230 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203dba:	ee4fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203dbe:	00009697          	auipc	a3,0x9
ffffffffc0203dc2:	10a68693          	addi	a3,a3,266 # ffffffffc020cec8 <default_pmm_manager+0x870>
ffffffffc0203dc6:	00008617          	auipc	a2,0x8
ffffffffc0203dca:	db260613          	addi	a2,a2,-590 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203dce:	07200593          	li	a1,114
ffffffffc0203dd2:	00009517          	auipc	a0,0x9
ffffffffc0203dd6:	0c650513          	addi	a0,a0,198 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203dda:	ec4fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203dde <mm_destroy>:
ffffffffc0203dde:	591c                	lw	a5,48(a0)
ffffffffc0203de0:	1141                	addi	sp,sp,-16
ffffffffc0203de2:	e406                	sd	ra,8(sp)
ffffffffc0203de4:	e022                	sd	s0,0(sp)
ffffffffc0203de6:	e78d                	bnez	a5,ffffffffc0203e10 <mm_destroy+0x32>
ffffffffc0203de8:	842a                	mv	s0,a0
ffffffffc0203dea:	6508                	ld	a0,8(a0)
ffffffffc0203dec:	00a40c63          	beq	s0,a0,ffffffffc0203e04 <mm_destroy+0x26>
ffffffffc0203df0:	6118                	ld	a4,0(a0)
ffffffffc0203df2:	651c                	ld	a5,8(a0)
ffffffffc0203df4:	1501                	addi	a0,a0,-32
ffffffffc0203df6:	e71c                	sd	a5,8(a4)
ffffffffc0203df8:	e398                	sd	a4,0(a5)
ffffffffc0203dfa:	accfe0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0203dfe:	6408                	ld	a0,8(s0)
ffffffffc0203e00:	fea418e3          	bne	s0,a0,ffffffffc0203df0 <mm_destroy+0x12>
ffffffffc0203e04:	8522                	mv	a0,s0
ffffffffc0203e06:	6402                	ld	s0,0(sp)
ffffffffc0203e08:	60a2                	ld	ra,8(sp)
ffffffffc0203e0a:	0141                	addi	sp,sp,16
ffffffffc0203e0c:	abafe06f          	j	ffffffffc02020c6 <kfree>
ffffffffc0203e10:	00009697          	auipc	a3,0x9
ffffffffc0203e14:	0f868693          	addi	a3,a3,248 # ffffffffc020cf08 <default_pmm_manager+0x8b0>
ffffffffc0203e18:	00008617          	auipc	a2,0x8
ffffffffc0203e1c:	d6060613          	addi	a2,a2,-672 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203e20:	09e00593          	li	a1,158
ffffffffc0203e24:	00009517          	auipc	a0,0x9
ffffffffc0203e28:	07450513          	addi	a0,a0,116 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203e2c:	e72fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203e30 <mm_map>:
ffffffffc0203e30:	7139                	addi	sp,sp,-64
ffffffffc0203e32:	f822                	sd	s0,48(sp)
ffffffffc0203e34:	6405                	lui	s0,0x1
ffffffffc0203e36:	147d                	addi	s0,s0,-1
ffffffffc0203e38:	77fd                	lui	a5,0xfffff
ffffffffc0203e3a:	9622                	add	a2,a2,s0
ffffffffc0203e3c:	962e                	add	a2,a2,a1
ffffffffc0203e3e:	f426                	sd	s1,40(sp)
ffffffffc0203e40:	fc06                	sd	ra,56(sp)
ffffffffc0203e42:	00f5f4b3          	and	s1,a1,a5
ffffffffc0203e46:	f04a                	sd	s2,32(sp)
ffffffffc0203e48:	ec4e                	sd	s3,24(sp)
ffffffffc0203e4a:	e852                	sd	s4,16(sp)
ffffffffc0203e4c:	e456                	sd	s5,8(sp)
ffffffffc0203e4e:	002005b7          	lui	a1,0x200
ffffffffc0203e52:	00f67433          	and	s0,a2,a5
ffffffffc0203e56:	06b4e363          	bltu	s1,a1,ffffffffc0203ebc <mm_map+0x8c>
ffffffffc0203e5a:	0684f163          	bgeu	s1,s0,ffffffffc0203ebc <mm_map+0x8c>
ffffffffc0203e5e:	4785                	li	a5,1
ffffffffc0203e60:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e62:	0487ed63          	bltu	a5,s0,ffffffffc0203ebc <mm_map+0x8c>
ffffffffc0203e66:	89aa                	mv	s3,a0
ffffffffc0203e68:	cd21                	beqz	a0,ffffffffc0203ec0 <mm_map+0x90>
ffffffffc0203e6a:	85a6                	mv	a1,s1
ffffffffc0203e6c:	8ab6                	mv	s5,a3
ffffffffc0203e6e:	8a3a                	mv	s4,a4
ffffffffc0203e70:	e5fff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc0203e74:	c501                	beqz	a0,ffffffffc0203e7c <mm_map+0x4c>
ffffffffc0203e76:	651c                	ld	a5,8(a0)
ffffffffc0203e78:	0487e263          	bltu	a5,s0,ffffffffc0203ebc <mm_map+0x8c>
ffffffffc0203e7c:	03000513          	li	a0,48
ffffffffc0203e80:	996fe0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0203e84:	892a                	mv	s2,a0
ffffffffc0203e86:	5571                	li	a0,-4
ffffffffc0203e88:	02090163          	beqz	s2,ffffffffc0203eaa <mm_map+0x7a>
ffffffffc0203e8c:	854e                	mv	a0,s3
ffffffffc0203e8e:	00993423          	sd	s1,8(s2)
ffffffffc0203e92:	00893823          	sd	s0,16(s2)
ffffffffc0203e96:	01592c23          	sw	s5,24(s2)
ffffffffc0203e9a:	85ca                	mv	a1,s2
ffffffffc0203e9c:	e73ff0ef          	jal	ra,ffffffffc0203d0e <insert_vma_struct>
ffffffffc0203ea0:	4501                	li	a0,0
ffffffffc0203ea2:	000a0463          	beqz	s4,ffffffffc0203eaa <mm_map+0x7a>
ffffffffc0203ea6:	012a3023          	sd	s2,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203eaa:	70e2                	ld	ra,56(sp)
ffffffffc0203eac:	7442                	ld	s0,48(sp)
ffffffffc0203eae:	74a2                	ld	s1,40(sp)
ffffffffc0203eb0:	7902                	ld	s2,32(sp)
ffffffffc0203eb2:	69e2                	ld	s3,24(sp)
ffffffffc0203eb4:	6a42                	ld	s4,16(sp)
ffffffffc0203eb6:	6aa2                	ld	s5,8(sp)
ffffffffc0203eb8:	6121                	addi	sp,sp,64
ffffffffc0203eba:	8082                	ret
ffffffffc0203ebc:	5575                	li	a0,-3
ffffffffc0203ebe:	b7f5                	j	ffffffffc0203eaa <mm_map+0x7a>
ffffffffc0203ec0:	00009697          	auipc	a3,0x9
ffffffffc0203ec4:	06068693          	addi	a3,a3,96 # ffffffffc020cf20 <default_pmm_manager+0x8c8>
ffffffffc0203ec8:	00008617          	auipc	a2,0x8
ffffffffc0203ecc:	cb060613          	addi	a2,a2,-848 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203ed0:	0b300593          	li	a1,179
ffffffffc0203ed4:	00009517          	auipc	a0,0x9
ffffffffc0203ed8:	fc450513          	addi	a0,a0,-60 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203edc:	dc2fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ee0 <dup_mmap>:
ffffffffc0203ee0:	7139                	addi	sp,sp,-64
ffffffffc0203ee2:	fc06                	sd	ra,56(sp)
ffffffffc0203ee4:	f822                	sd	s0,48(sp)
ffffffffc0203ee6:	f426                	sd	s1,40(sp)
ffffffffc0203ee8:	f04a                	sd	s2,32(sp)
ffffffffc0203eea:	ec4e                	sd	s3,24(sp)
ffffffffc0203eec:	e852                	sd	s4,16(sp)
ffffffffc0203eee:	e456                	sd	s5,8(sp)
ffffffffc0203ef0:	c52d                	beqz	a0,ffffffffc0203f5a <dup_mmap+0x7a>
ffffffffc0203ef2:	892a                	mv	s2,a0
ffffffffc0203ef4:	84ae                	mv	s1,a1
ffffffffc0203ef6:	842e                	mv	s0,a1
ffffffffc0203ef8:	e595                	bnez	a1,ffffffffc0203f24 <dup_mmap+0x44>
ffffffffc0203efa:	a085                	j	ffffffffc0203f5a <dup_mmap+0x7a>
ffffffffc0203efc:	854a                	mv	a0,s2
ffffffffc0203efe:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0203f02:	0145b823          	sd	s4,16(a1)
ffffffffc0203f06:	0135ac23          	sw	s3,24(a1)
ffffffffc0203f0a:	e05ff0ef          	jal	ra,ffffffffc0203d0e <insert_vma_struct>
ffffffffc0203f0e:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0203f12:	fe843603          	ld	a2,-24(s0)
ffffffffc0203f16:	6c8c                	ld	a1,24(s1)
ffffffffc0203f18:	01893503          	ld	a0,24(s2)
ffffffffc0203f1c:	4701                	li	a4,0
ffffffffc0203f1e:	a2dff0ef          	jal	ra,ffffffffc020394a <copy_range>
ffffffffc0203f22:	e105                	bnez	a0,ffffffffc0203f42 <dup_mmap+0x62>
ffffffffc0203f24:	6000                	ld	s0,0(s0)
ffffffffc0203f26:	02848863          	beq	s1,s0,ffffffffc0203f56 <dup_mmap+0x76>
ffffffffc0203f2a:	03000513          	li	a0,48
ffffffffc0203f2e:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203f32:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203f36:	ff842983          	lw	s3,-8(s0)
ffffffffc0203f3a:	8dcfe0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0203f3e:	85aa                	mv	a1,a0
ffffffffc0203f40:	fd55                	bnez	a0,ffffffffc0203efc <dup_mmap+0x1c>
ffffffffc0203f42:	5571                	li	a0,-4
ffffffffc0203f44:	70e2                	ld	ra,56(sp)
ffffffffc0203f46:	7442                	ld	s0,48(sp)
ffffffffc0203f48:	74a2                	ld	s1,40(sp)
ffffffffc0203f4a:	7902                	ld	s2,32(sp)
ffffffffc0203f4c:	69e2                	ld	s3,24(sp)
ffffffffc0203f4e:	6a42                	ld	s4,16(sp)
ffffffffc0203f50:	6aa2                	ld	s5,8(sp)
ffffffffc0203f52:	6121                	addi	sp,sp,64
ffffffffc0203f54:	8082                	ret
ffffffffc0203f56:	4501                	li	a0,0
ffffffffc0203f58:	b7f5                	j	ffffffffc0203f44 <dup_mmap+0x64>
ffffffffc0203f5a:	00009697          	auipc	a3,0x9
ffffffffc0203f5e:	fd668693          	addi	a3,a3,-42 # ffffffffc020cf30 <default_pmm_manager+0x8d8>
ffffffffc0203f62:	00008617          	auipc	a2,0x8
ffffffffc0203f66:	c1660613          	addi	a2,a2,-1002 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203f6a:	0cf00593          	li	a1,207
ffffffffc0203f6e:	00009517          	auipc	a0,0x9
ffffffffc0203f72:	f2a50513          	addi	a0,a0,-214 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203f76:	d28fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203f7a <exit_mmap>:
ffffffffc0203f7a:	1101                	addi	sp,sp,-32
ffffffffc0203f7c:	ec06                	sd	ra,24(sp)
ffffffffc0203f7e:	e822                	sd	s0,16(sp)
ffffffffc0203f80:	e426                	sd	s1,8(sp)
ffffffffc0203f82:	e04a                	sd	s2,0(sp)
ffffffffc0203f84:	c531                	beqz	a0,ffffffffc0203fd0 <exit_mmap+0x56>
ffffffffc0203f86:	591c                	lw	a5,48(a0)
ffffffffc0203f88:	84aa                	mv	s1,a0
ffffffffc0203f8a:	e3b9                	bnez	a5,ffffffffc0203fd0 <exit_mmap+0x56>
ffffffffc0203f8c:	6500                	ld	s0,8(a0)
ffffffffc0203f8e:	01853903          	ld	s2,24(a0)
ffffffffc0203f92:	02850663          	beq	a0,s0,ffffffffc0203fbe <exit_mmap+0x44>
ffffffffc0203f96:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f9a:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f9e:	854a                	mv	a0,s2
ffffffffc0203fa0:	e4efe0ef          	jal	ra,ffffffffc02025ee <unmap_range>
ffffffffc0203fa4:	6400                	ld	s0,8(s0)
ffffffffc0203fa6:	fe8498e3          	bne	s1,s0,ffffffffc0203f96 <exit_mmap+0x1c>
ffffffffc0203faa:	6400                	ld	s0,8(s0)
ffffffffc0203fac:	00848c63          	beq	s1,s0,ffffffffc0203fc4 <exit_mmap+0x4a>
ffffffffc0203fb0:	ff043603          	ld	a2,-16(s0)
ffffffffc0203fb4:	fe843583          	ld	a1,-24(s0)
ffffffffc0203fb8:	854a                	mv	a0,s2
ffffffffc0203fba:	f7afe0ef          	jal	ra,ffffffffc0202734 <exit_range>
ffffffffc0203fbe:	6400                	ld	s0,8(s0)
ffffffffc0203fc0:	fe8498e3          	bne	s1,s0,ffffffffc0203fb0 <exit_mmap+0x36>
ffffffffc0203fc4:	60e2                	ld	ra,24(sp)
ffffffffc0203fc6:	6442                	ld	s0,16(sp)
ffffffffc0203fc8:	64a2                	ld	s1,8(sp)
ffffffffc0203fca:	6902                	ld	s2,0(sp)
ffffffffc0203fcc:	6105                	addi	sp,sp,32
ffffffffc0203fce:	8082                	ret
ffffffffc0203fd0:	00009697          	auipc	a3,0x9
ffffffffc0203fd4:	f8068693          	addi	a3,a3,-128 # ffffffffc020cf50 <default_pmm_manager+0x8f8>
ffffffffc0203fd8:	00008617          	auipc	a2,0x8
ffffffffc0203fdc:	ba060613          	addi	a2,a2,-1120 # ffffffffc020bb78 <commands+0x210>
ffffffffc0203fe0:	0e800593          	li	a1,232
ffffffffc0203fe4:	00009517          	auipc	a0,0x9
ffffffffc0203fe8:	eb450513          	addi	a0,a0,-332 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0203fec:	cb2fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ff0 <vmm_init>:
ffffffffc0203ff0:	7139                	addi	sp,sp,-64
ffffffffc0203ff2:	05800513          	li	a0,88
ffffffffc0203ff6:	fc06                	sd	ra,56(sp)
ffffffffc0203ff8:	f822                	sd	s0,48(sp)
ffffffffc0203ffa:	f426                	sd	s1,40(sp)
ffffffffc0203ffc:	f04a                	sd	s2,32(sp)
ffffffffc0203ffe:	ec4e                	sd	s3,24(sp)
ffffffffc0204000:	e852                	sd	s4,16(sp)
ffffffffc0204002:	e456                	sd	s5,8(sp)
ffffffffc0204004:	812fe0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0204008:	2e050963          	beqz	a0,ffffffffc02042fa <vmm_init+0x30a>
ffffffffc020400c:	e508                	sd	a0,8(a0)
ffffffffc020400e:	e108                	sd	a0,0(a0)
ffffffffc0204010:	00053823          	sd	zero,16(a0)
ffffffffc0204014:	00053c23          	sd	zero,24(a0)
ffffffffc0204018:	02052023          	sw	zero,32(a0)
ffffffffc020401c:	02053423          	sd	zero,40(a0)
ffffffffc0204020:	02052823          	sw	zero,48(a0)
ffffffffc0204024:	84aa                	mv	s1,a0
ffffffffc0204026:	4585                	li	a1,1
ffffffffc0204028:	03850513          	addi	a0,a0,56
ffffffffc020402c:	62e000ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0204030:	03200413          	li	s0,50
ffffffffc0204034:	a811                	j	ffffffffc0204048 <vmm_init+0x58>
ffffffffc0204036:	e500                	sd	s0,8(a0)
ffffffffc0204038:	e91c                	sd	a5,16(a0)
ffffffffc020403a:	00052c23          	sw	zero,24(a0)
ffffffffc020403e:	146d                	addi	s0,s0,-5
ffffffffc0204040:	8526                	mv	a0,s1
ffffffffc0204042:	ccdff0ef          	jal	ra,ffffffffc0203d0e <insert_vma_struct>
ffffffffc0204046:	c80d                	beqz	s0,ffffffffc0204078 <vmm_init+0x88>
ffffffffc0204048:	03000513          	li	a0,48
ffffffffc020404c:	fcbfd0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0204050:	85aa                	mv	a1,a0
ffffffffc0204052:	00240793          	addi	a5,s0,2
ffffffffc0204056:	f165                	bnez	a0,ffffffffc0204036 <vmm_init+0x46>
ffffffffc0204058:	00009697          	auipc	a3,0x9
ffffffffc020405c:	09068693          	addi	a3,a3,144 # ffffffffc020d0e8 <default_pmm_manager+0xa90>
ffffffffc0204060:	00008617          	auipc	a2,0x8
ffffffffc0204064:	b1860613          	addi	a2,a2,-1256 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204068:	12c00593          	li	a1,300
ffffffffc020406c:	00009517          	auipc	a0,0x9
ffffffffc0204070:	e2c50513          	addi	a0,a0,-468 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204074:	c2afc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204078:	03700413          	li	s0,55
ffffffffc020407c:	1f900913          	li	s2,505
ffffffffc0204080:	a819                	j	ffffffffc0204096 <vmm_init+0xa6>
ffffffffc0204082:	e500                	sd	s0,8(a0)
ffffffffc0204084:	e91c                	sd	a5,16(a0)
ffffffffc0204086:	00052c23          	sw	zero,24(a0)
ffffffffc020408a:	0415                	addi	s0,s0,5
ffffffffc020408c:	8526                	mv	a0,s1
ffffffffc020408e:	c81ff0ef          	jal	ra,ffffffffc0203d0e <insert_vma_struct>
ffffffffc0204092:	03240a63          	beq	s0,s2,ffffffffc02040c6 <vmm_init+0xd6>
ffffffffc0204096:	03000513          	li	a0,48
ffffffffc020409a:	f7dfd0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020409e:	85aa                	mv	a1,a0
ffffffffc02040a0:	00240793          	addi	a5,s0,2
ffffffffc02040a4:	fd79                	bnez	a0,ffffffffc0204082 <vmm_init+0x92>
ffffffffc02040a6:	00009697          	auipc	a3,0x9
ffffffffc02040aa:	04268693          	addi	a3,a3,66 # ffffffffc020d0e8 <default_pmm_manager+0xa90>
ffffffffc02040ae:	00008617          	auipc	a2,0x8
ffffffffc02040b2:	aca60613          	addi	a2,a2,-1334 # ffffffffc020bb78 <commands+0x210>
ffffffffc02040b6:	13300593          	li	a1,307
ffffffffc02040ba:	00009517          	auipc	a0,0x9
ffffffffc02040be:	dde50513          	addi	a0,a0,-546 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02040c2:	bdcfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02040c6:	649c                	ld	a5,8(s1)
ffffffffc02040c8:	471d                	li	a4,7
ffffffffc02040ca:	1fb00593          	li	a1,507
ffffffffc02040ce:	16f48663          	beq	s1,a5,ffffffffc020423a <vmm_init+0x24a>
ffffffffc02040d2:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc02040d6:	ffe70693          	addi	a3,a4,-2
ffffffffc02040da:	10d61063          	bne	a2,a3,ffffffffc02041da <vmm_init+0x1ea>
ffffffffc02040de:	ff07b683          	ld	a3,-16(a5)
ffffffffc02040e2:	0ed71c63          	bne	a4,a3,ffffffffc02041da <vmm_init+0x1ea>
ffffffffc02040e6:	0715                	addi	a4,a4,5
ffffffffc02040e8:	679c                	ld	a5,8(a5)
ffffffffc02040ea:	feb712e3          	bne	a4,a1,ffffffffc02040ce <vmm_init+0xde>
ffffffffc02040ee:	4a1d                	li	s4,7
ffffffffc02040f0:	4415                	li	s0,5
ffffffffc02040f2:	1f900a93          	li	s5,505
ffffffffc02040f6:	85a2                	mv	a1,s0
ffffffffc02040f8:	8526                	mv	a0,s1
ffffffffc02040fa:	bd5ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc02040fe:	892a                	mv	s2,a0
ffffffffc0204100:	16050d63          	beqz	a0,ffffffffc020427a <vmm_init+0x28a>
ffffffffc0204104:	00140593          	addi	a1,s0,1
ffffffffc0204108:	8526                	mv	a0,s1
ffffffffc020410a:	bc5ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc020410e:	89aa                	mv	s3,a0
ffffffffc0204110:	14050563          	beqz	a0,ffffffffc020425a <vmm_init+0x26a>
ffffffffc0204114:	85d2                	mv	a1,s4
ffffffffc0204116:	8526                	mv	a0,s1
ffffffffc0204118:	bb7ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc020411c:	16051f63          	bnez	a0,ffffffffc020429a <vmm_init+0x2aa>
ffffffffc0204120:	00340593          	addi	a1,s0,3
ffffffffc0204124:	8526                	mv	a0,s1
ffffffffc0204126:	ba9ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc020412a:	1a051863          	bnez	a0,ffffffffc02042da <vmm_init+0x2ea>
ffffffffc020412e:	00440593          	addi	a1,s0,4
ffffffffc0204132:	8526                	mv	a0,s1
ffffffffc0204134:	b9bff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc0204138:	18051163          	bnez	a0,ffffffffc02042ba <vmm_init+0x2ca>
ffffffffc020413c:	00893783          	ld	a5,8(s2)
ffffffffc0204140:	0a879d63          	bne	a5,s0,ffffffffc02041fa <vmm_init+0x20a>
ffffffffc0204144:	01093783          	ld	a5,16(s2)
ffffffffc0204148:	0b479963          	bne	a5,s4,ffffffffc02041fa <vmm_init+0x20a>
ffffffffc020414c:	0089b783          	ld	a5,8(s3)
ffffffffc0204150:	0c879563          	bne	a5,s0,ffffffffc020421a <vmm_init+0x22a>
ffffffffc0204154:	0109b783          	ld	a5,16(s3)
ffffffffc0204158:	0d479163          	bne	a5,s4,ffffffffc020421a <vmm_init+0x22a>
ffffffffc020415c:	0415                	addi	s0,s0,5
ffffffffc020415e:	0a15                	addi	s4,s4,5
ffffffffc0204160:	f9541be3          	bne	s0,s5,ffffffffc02040f6 <vmm_init+0x106>
ffffffffc0204164:	4411                	li	s0,4
ffffffffc0204166:	597d                	li	s2,-1
ffffffffc0204168:	85a2                	mv	a1,s0
ffffffffc020416a:	8526                	mv	a0,s1
ffffffffc020416c:	b63ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc0204170:	0004059b          	sext.w	a1,s0
ffffffffc0204174:	c90d                	beqz	a0,ffffffffc02041a6 <vmm_init+0x1b6>
ffffffffc0204176:	6914                	ld	a3,16(a0)
ffffffffc0204178:	6510                	ld	a2,8(a0)
ffffffffc020417a:	00009517          	auipc	a0,0x9
ffffffffc020417e:	ef650513          	addi	a0,a0,-266 # ffffffffc020d070 <default_pmm_manager+0xa18>
ffffffffc0204182:	824fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0204186:	00009697          	auipc	a3,0x9
ffffffffc020418a:	f1268693          	addi	a3,a3,-238 # ffffffffc020d098 <default_pmm_manager+0xa40>
ffffffffc020418e:	00008617          	auipc	a2,0x8
ffffffffc0204192:	9ea60613          	addi	a2,a2,-1558 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204196:	15900593          	li	a1,345
ffffffffc020419a:	00009517          	auipc	a0,0x9
ffffffffc020419e:	cfe50513          	addi	a0,a0,-770 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02041a2:	afcfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041a6:	147d                	addi	s0,s0,-1
ffffffffc02041a8:	fd2410e3          	bne	s0,s2,ffffffffc0204168 <vmm_init+0x178>
ffffffffc02041ac:	8526                	mv	a0,s1
ffffffffc02041ae:	c31ff0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc02041b2:	00009517          	auipc	a0,0x9
ffffffffc02041b6:	efe50513          	addi	a0,a0,-258 # ffffffffc020d0b0 <default_pmm_manager+0xa58>
ffffffffc02041ba:	fedfb0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02041be:	7442                	ld	s0,48(sp)
ffffffffc02041c0:	70e2                	ld	ra,56(sp)
ffffffffc02041c2:	74a2                	ld	s1,40(sp)
ffffffffc02041c4:	7902                	ld	s2,32(sp)
ffffffffc02041c6:	69e2                	ld	s3,24(sp)
ffffffffc02041c8:	6a42                	ld	s4,16(sp)
ffffffffc02041ca:	6aa2                	ld	s5,8(sp)
ffffffffc02041cc:	00009517          	auipc	a0,0x9
ffffffffc02041d0:	f0450513          	addi	a0,a0,-252 # ffffffffc020d0d0 <default_pmm_manager+0xa78>
ffffffffc02041d4:	6121                	addi	sp,sp,64
ffffffffc02041d6:	fd1fb06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02041da:	00009697          	auipc	a3,0x9
ffffffffc02041de:	dae68693          	addi	a3,a3,-594 # ffffffffc020cf88 <default_pmm_manager+0x930>
ffffffffc02041e2:	00008617          	auipc	a2,0x8
ffffffffc02041e6:	99660613          	addi	a2,a2,-1642 # ffffffffc020bb78 <commands+0x210>
ffffffffc02041ea:	13d00593          	li	a1,317
ffffffffc02041ee:	00009517          	auipc	a0,0x9
ffffffffc02041f2:	caa50513          	addi	a0,a0,-854 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02041f6:	aa8fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041fa:	00009697          	auipc	a3,0x9
ffffffffc02041fe:	e1668693          	addi	a3,a3,-490 # ffffffffc020d010 <default_pmm_manager+0x9b8>
ffffffffc0204202:	00008617          	auipc	a2,0x8
ffffffffc0204206:	97660613          	addi	a2,a2,-1674 # ffffffffc020bb78 <commands+0x210>
ffffffffc020420a:	14e00593          	li	a1,334
ffffffffc020420e:	00009517          	auipc	a0,0x9
ffffffffc0204212:	c8a50513          	addi	a0,a0,-886 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204216:	a88fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020421a:	00009697          	auipc	a3,0x9
ffffffffc020421e:	e2668693          	addi	a3,a3,-474 # ffffffffc020d040 <default_pmm_manager+0x9e8>
ffffffffc0204222:	00008617          	auipc	a2,0x8
ffffffffc0204226:	95660613          	addi	a2,a2,-1706 # ffffffffc020bb78 <commands+0x210>
ffffffffc020422a:	14f00593          	li	a1,335
ffffffffc020422e:	00009517          	auipc	a0,0x9
ffffffffc0204232:	c6a50513          	addi	a0,a0,-918 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204236:	a68fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020423a:	00009697          	auipc	a3,0x9
ffffffffc020423e:	d3668693          	addi	a3,a3,-714 # ffffffffc020cf70 <default_pmm_manager+0x918>
ffffffffc0204242:	00008617          	auipc	a2,0x8
ffffffffc0204246:	93660613          	addi	a2,a2,-1738 # ffffffffc020bb78 <commands+0x210>
ffffffffc020424a:	13b00593          	li	a1,315
ffffffffc020424e:	00009517          	auipc	a0,0x9
ffffffffc0204252:	c4a50513          	addi	a0,a0,-950 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204256:	a48fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020425a:	00009697          	auipc	a3,0x9
ffffffffc020425e:	d7668693          	addi	a3,a3,-650 # ffffffffc020cfd0 <default_pmm_manager+0x978>
ffffffffc0204262:	00008617          	auipc	a2,0x8
ffffffffc0204266:	91660613          	addi	a2,a2,-1770 # ffffffffc020bb78 <commands+0x210>
ffffffffc020426a:	14600593          	li	a1,326
ffffffffc020426e:	00009517          	auipc	a0,0x9
ffffffffc0204272:	c2a50513          	addi	a0,a0,-982 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204276:	a28fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020427a:	00009697          	auipc	a3,0x9
ffffffffc020427e:	d4668693          	addi	a3,a3,-698 # ffffffffc020cfc0 <default_pmm_manager+0x968>
ffffffffc0204282:	00008617          	auipc	a2,0x8
ffffffffc0204286:	8f660613          	addi	a2,a2,-1802 # ffffffffc020bb78 <commands+0x210>
ffffffffc020428a:	14400593          	li	a1,324
ffffffffc020428e:	00009517          	auipc	a0,0x9
ffffffffc0204292:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204296:	a08fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020429a:	00009697          	auipc	a3,0x9
ffffffffc020429e:	d4668693          	addi	a3,a3,-698 # ffffffffc020cfe0 <default_pmm_manager+0x988>
ffffffffc02042a2:	00008617          	auipc	a2,0x8
ffffffffc02042a6:	8d660613          	addi	a2,a2,-1834 # ffffffffc020bb78 <commands+0x210>
ffffffffc02042aa:	14800593          	li	a1,328
ffffffffc02042ae:	00009517          	auipc	a0,0x9
ffffffffc02042b2:	bea50513          	addi	a0,a0,-1046 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02042b6:	9e8fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042ba:	00009697          	auipc	a3,0x9
ffffffffc02042be:	d4668693          	addi	a3,a3,-698 # ffffffffc020d000 <default_pmm_manager+0x9a8>
ffffffffc02042c2:	00008617          	auipc	a2,0x8
ffffffffc02042c6:	8b660613          	addi	a2,a2,-1866 # ffffffffc020bb78 <commands+0x210>
ffffffffc02042ca:	14c00593          	li	a1,332
ffffffffc02042ce:	00009517          	auipc	a0,0x9
ffffffffc02042d2:	bca50513          	addi	a0,a0,-1078 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02042d6:	9c8fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042da:	00009697          	auipc	a3,0x9
ffffffffc02042de:	d1668693          	addi	a3,a3,-746 # ffffffffc020cff0 <default_pmm_manager+0x998>
ffffffffc02042e2:	00008617          	auipc	a2,0x8
ffffffffc02042e6:	89660613          	addi	a2,a2,-1898 # ffffffffc020bb78 <commands+0x210>
ffffffffc02042ea:	14a00593          	li	a1,330
ffffffffc02042ee:	00009517          	auipc	a0,0x9
ffffffffc02042f2:	baa50513          	addi	a0,a0,-1110 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc02042f6:	9a8fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042fa:	00009697          	auipc	a3,0x9
ffffffffc02042fe:	c2668693          	addi	a3,a3,-986 # ffffffffc020cf20 <default_pmm_manager+0x8c8>
ffffffffc0204302:	00008617          	auipc	a2,0x8
ffffffffc0204306:	87660613          	addi	a2,a2,-1930 # ffffffffc020bb78 <commands+0x210>
ffffffffc020430a:	12400593          	li	a1,292
ffffffffc020430e:	00009517          	auipc	a0,0x9
ffffffffc0204312:	b8a50513          	addi	a0,a0,-1142 # ffffffffc020ce98 <default_pmm_manager+0x840>
ffffffffc0204316:	988fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020431a <user_mem_check>:
ffffffffc020431a:	7179                	addi	sp,sp,-48
ffffffffc020431c:	f022                	sd	s0,32(sp)
ffffffffc020431e:	f406                	sd	ra,40(sp)
ffffffffc0204320:	ec26                	sd	s1,24(sp)
ffffffffc0204322:	e84a                	sd	s2,16(sp)
ffffffffc0204324:	e44e                	sd	s3,8(sp)
ffffffffc0204326:	e052                	sd	s4,0(sp)
ffffffffc0204328:	842e                	mv	s0,a1
ffffffffc020432a:	c135                	beqz	a0,ffffffffc020438e <user_mem_check+0x74>
ffffffffc020432c:	002007b7          	lui	a5,0x200
ffffffffc0204330:	04f5e663          	bltu	a1,a5,ffffffffc020437c <user_mem_check+0x62>
ffffffffc0204334:	00c584b3          	add	s1,a1,a2
ffffffffc0204338:	0495f263          	bgeu	a1,s1,ffffffffc020437c <user_mem_check+0x62>
ffffffffc020433c:	4785                	li	a5,1
ffffffffc020433e:	07fe                	slli	a5,a5,0x1f
ffffffffc0204340:	0297ee63          	bltu	a5,s1,ffffffffc020437c <user_mem_check+0x62>
ffffffffc0204344:	892a                	mv	s2,a0
ffffffffc0204346:	89b6                	mv	s3,a3
ffffffffc0204348:	6a05                	lui	s4,0x1
ffffffffc020434a:	a821                	j	ffffffffc0204362 <user_mem_check+0x48>
ffffffffc020434c:	0027f693          	andi	a3,a5,2
ffffffffc0204350:	9752                	add	a4,a4,s4
ffffffffc0204352:	8ba1                	andi	a5,a5,8
ffffffffc0204354:	c685                	beqz	a3,ffffffffc020437c <user_mem_check+0x62>
ffffffffc0204356:	c399                	beqz	a5,ffffffffc020435c <user_mem_check+0x42>
ffffffffc0204358:	02e46263          	bltu	s0,a4,ffffffffc020437c <user_mem_check+0x62>
ffffffffc020435c:	6900                	ld	s0,16(a0)
ffffffffc020435e:	04947663          	bgeu	s0,s1,ffffffffc02043aa <user_mem_check+0x90>
ffffffffc0204362:	85a2                	mv	a1,s0
ffffffffc0204364:	854a                	mv	a0,s2
ffffffffc0204366:	969ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc020436a:	c909                	beqz	a0,ffffffffc020437c <user_mem_check+0x62>
ffffffffc020436c:	6518                	ld	a4,8(a0)
ffffffffc020436e:	00e46763          	bltu	s0,a4,ffffffffc020437c <user_mem_check+0x62>
ffffffffc0204372:	4d1c                	lw	a5,24(a0)
ffffffffc0204374:	fc099ce3          	bnez	s3,ffffffffc020434c <user_mem_check+0x32>
ffffffffc0204378:	8b85                	andi	a5,a5,1
ffffffffc020437a:	f3ed                	bnez	a5,ffffffffc020435c <user_mem_check+0x42>
ffffffffc020437c:	4501                	li	a0,0
ffffffffc020437e:	70a2                	ld	ra,40(sp)
ffffffffc0204380:	7402                	ld	s0,32(sp)
ffffffffc0204382:	64e2                	ld	s1,24(sp)
ffffffffc0204384:	6942                	ld	s2,16(sp)
ffffffffc0204386:	69a2                	ld	s3,8(sp)
ffffffffc0204388:	6a02                	ld	s4,0(sp)
ffffffffc020438a:	6145                	addi	sp,sp,48
ffffffffc020438c:	8082                	ret
ffffffffc020438e:	c02007b7          	lui	a5,0xc0200
ffffffffc0204392:	4501                	li	a0,0
ffffffffc0204394:	fef5e5e3          	bltu	a1,a5,ffffffffc020437e <user_mem_check+0x64>
ffffffffc0204398:	962e                	add	a2,a2,a1
ffffffffc020439a:	fec5f2e3          	bgeu	a1,a2,ffffffffc020437e <user_mem_check+0x64>
ffffffffc020439e:	c8000537          	lui	a0,0xc8000
ffffffffc02043a2:	0505                	addi	a0,a0,1
ffffffffc02043a4:	00a63533          	sltu	a0,a2,a0
ffffffffc02043a8:	bfd9                	j	ffffffffc020437e <user_mem_check+0x64>
ffffffffc02043aa:	4505                	li	a0,1
ffffffffc02043ac:	bfc9                	j	ffffffffc020437e <user_mem_check+0x64>

ffffffffc02043ae <copy_from_user>:
ffffffffc02043ae:	1101                	addi	sp,sp,-32
ffffffffc02043b0:	e822                	sd	s0,16(sp)
ffffffffc02043b2:	e426                	sd	s1,8(sp)
ffffffffc02043b4:	8432                	mv	s0,a2
ffffffffc02043b6:	84b6                	mv	s1,a3
ffffffffc02043b8:	e04a                	sd	s2,0(sp)
ffffffffc02043ba:	86ba                	mv	a3,a4
ffffffffc02043bc:	892e                	mv	s2,a1
ffffffffc02043be:	8626                	mv	a2,s1
ffffffffc02043c0:	85a2                	mv	a1,s0
ffffffffc02043c2:	ec06                	sd	ra,24(sp)
ffffffffc02043c4:	f57ff0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc02043c8:	c519                	beqz	a0,ffffffffc02043d6 <copy_from_user+0x28>
ffffffffc02043ca:	8626                	mv	a2,s1
ffffffffc02043cc:	85a2                	mv	a1,s0
ffffffffc02043ce:	854a                	mv	a0,s2
ffffffffc02043d0:	316070ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc02043d4:	4505                	li	a0,1
ffffffffc02043d6:	60e2                	ld	ra,24(sp)
ffffffffc02043d8:	6442                	ld	s0,16(sp)
ffffffffc02043da:	64a2                	ld	s1,8(sp)
ffffffffc02043dc:	6902                	ld	s2,0(sp)
ffffffffc02043de:	6105                	addi	sp,sp,32
ffffffffc02043e0:	8082                	ret

ffffffffc02043e2 <copy_to_user>:
ffffffffc02043e2:	1101                	addi	sp,sp,-32
ffffffffc02043e4:	e822                	sd	s0,16(sp)
ffffffffc02043e6:	8436                	mv	s0,a3
ffffffffc02043e8:	e04a                	sd	s2,0(sp)
ffffffffc02043ea:	4685                	li	a3,1
ffffffffc02043ec:	8932                	mv	s2,a2
ffffffffc02043ee:	8622                	mv	a2,s0
ffffffffc02043f0:	e426                	sd	s1,8(sp)
ffffffffc02043f2:	ec06                	sd	ra,24(sp)
ffffffffc02043f4:	84ae                	mv	s1,a1
ffffffffc02043f6:	f25ff0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc02043fa:	c519                	beqz	a0,ffffffffc0204408 <copy_to_user+0x26>
ffffffffc02043fc:	8622                	mv	a2,s0
ffffffffc02043fe:	85ca                	mv	a1,s2
ffffffffc0204400:	8526                	mv	a0,s1
ffffffffc0204402:	2e4070ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0204406:	4505                	li	a0,1
ffffffffc0204408:	60e2                	ld	ra,24(sp)
ffffffffc020440a:	6442                	ld	s0,16(sp)
ffffffffc020440c:	64a2                	ld	s1,8(sp)
ffffffffc020440e:	6902                	ld	s2,0(sp)
ffffffffc0204410:	6105                	addi	sp,sp,32
ffffffffc0204412:	8082                	ret

ffffffffc0204414 <copy_string>:
ffffffffc0204414:	7139                	addi	sp,sp,-64
ffffffffc0204416:	ec4e                	sd	s3,24(sp)
ffffffffc0204418:	6985                	lui	s3,0x1
ffffffffc020441a:	99b2                	add	s3,s3,a2
ffffffffc020441c:	77fd                	lui	a5,0xfffff
ffffffffc020441e:	00f9f9b3          	and	s3,s3,a5
ffffffffc0204422:	f426                	sd	s1,40(sp)
ffffffffc0204424:	f04a                	sd	s2,32(sp)
ffffffffc0204426:	e852                	sd	s4,16(sp)
ffffffffc0204428:	e456                	sd	s5,8(sp)
ffffffffc020442a:	fc06                	sd	ra,56(sp)
ffffffffc020442c:	f822                	sd	s0,48(sp)
ffffffffc020442e:	84b2                	mv	s1,a2
ffffffffc0204430:	8aaa                	mv	s5,a0
ffffffffc0204432:	8a2e                	mv	s4,a1
ffffffffc0204434:	8936                	mv	s2,a3
ffffffffc0204436:	40c989b3          	sub	s3,s3,a2
ffffffffc020443a:	a015                	j	ffffffffc020445e <copy_string+0x4a>
ffffffffc020443c:	1d0070ef          	jal	ra,ffffffffc020b60c <strnlen>
ffffffffc0204440:	87aa                	mv	a5,a0
ffffffffc0204442:	85a6                	mv	a1,s1
ffffffffc0204444:	8552                	mv	a0,s4
ffffffffc0204446:	8622                	mv	a2,s0
ffffffffc0204448:	0487e363          	bltu	a5,s0,ffffffffc020448e <copy_string+0x7a>
ffffffffc020444c:	0329f763          	bgeu	s3,s2,ffffffffc020447a <copy_string+0x66>
ffffffffc0204450:	296070ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0204454:	9a22                	add	s4,s4,s0
ffffffffc0204456:	94a2                	add	s1,s1,s0
ffffffffc0204458:	40890933          	sub	s2,s2,s0
ffffffffc020445c:	6985                	lui	s3,0x1
ffffffffc020445e:	4681                	li	a3,0
ffffffffc0204460:	85a6                	mv	a1,s1
ffffffffc0204462:	8556                	mv	a0,s5
ffffffffc0204464:	844a                	mv	s0,s2
ffffffffc0204466:	0129f363          	bgeu	s3,s2,ffffffffc020446c <copy_string+0x58>
ffffffffc020446a:	844e                	mv	s0,s3
ffffffffc020446c:	8622                	mv	a2,s0
ffffffffc020446e:	eadff0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc0204472:	87aa                	mv	a5,a0
ffffffffc0204474:	85a2                	mv	a1,s0
ffffffffc0204476:	8526                	mv	a0,s1
ffffffffc0204478:	f3f1                	bnez	a5,ffffffffc020443c <copy_string+0x28>
ffffffffc020447a:	4501                	li	a0,0
ffffffffc020447c:	70e2                	ld	ra,56(sp)
ffffffffc020447e:	7442                	ld	s0,48(sp)
ffffffffc0204480:	74a2                	ld	s1,40(sp)
ffffffffc0204482:	7902                	ld	s2,32(sp)
ffffffffc0204484:	69e2                	ld	s3,24(sp)
ffffffffc0204486:	6a42                	ld	s4,16(sp)
ffffffffc0204488:	6aa2                	ld	s5,8(sp)
ffffffffc020448a:	6121                	addi	sp,sp,64
ffffffffc020448c:	8082                	ret
ffffffffc020448e:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0204492:	254070ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0204496:	4505                	li	a0,1
ffffffffc0204498:	b7d5                	j	ffffffffc020447c <copy_string+0x68>

ffffffffc020449a <do_pgfault>:
ffffffffc020449a:	1101                	addi	sp,sp,-32
ffffffffc020449c:	e426                	sd	s1,8(sp)
ffffffffc020449e:	84ae                	mv	s1,a1
ffffffffc02044a0:	85b2                	mv	a1,a2
ffffffffc02044a2:	e822                	sd	s0,16(sp)
ffffffffc02044a4:	e04a                	sd	s2,0(sp)
ffffffffc02044a6:	ec06                	sd	ra,24(sp)
ffffffffc02044a8:	8432                	mv	s0,a2
ffffffffc02044aa:	892a                	mv	s2,a0
ffffffffc02044ac:	823ff0ef          	jal	ra,ffffffffc0203cce <find_vma>
ffffffffc02044b0:	cd29                	beqz	a0,ffffffffc020450a <do_pgfault+0x70>
ffffffffc02044b2:	651c                	ld	a5,8(a0)
ffffffffc02044b4:	04f46b63          	bltu	s0,a5,ffffffffc020450a <do_pgfault+0x70>
ffffffffc02044b8:	4d18                	lw	a4,24(a0)
ffffffffc02044ba:	0014f793          	andi	a5,s1,1
ffffffffc02044be:	00277693          	andi	a3,a4,2
ffffffffc02044c2:	c79d                	beqz	a5,ffffffffc02044f0 <do_pgfault+0x56>
ffffffffc02044c4:	c2b9                	beqz	a3,ffffffffc020450a <do_pgfault+0x70>
ffffffffc02044c6:	75fd                	lui	a1,0xfffff
ffffffffc02044c8:	8de1                	and	a1,a1,s0
ffffffffc02044ca:	0d700613          	li	a2,215
ffffffffc02044ce:	8b11                	andi	a4,a4,4
ffffffffc02044d0:	c319                	beqz	a4,ffffffffc02044d6 <do_pgfault+0x3c>
ffffffffc02044d2:	00866613          	ori	a2,a2,8
ffffffffc02044d6:	01893503          	ld	a0,24(s2)
ffffffffc02044da:	ed0ff0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc02044de:	87aa                	mv	a5,a0
ffffffffc02044e0:	4501                	li	a0,0
ffffffffc02044e2:	c795                	beqz	a5,ffffffffc020450e <do_pgfault+0x74>
ffffffffc02044e4:	60e2                	ld	ra,24(sp)
ffffffffc02044e6:	6442                	ld	s0,16(sp)
ffffffffc02044e8:	64a2                	ld	s1,8(sp)
ffffffffc02044ea:	6902                	ld	s2,0(sp)
ffffffffc02044ec:	6105                	addi	sp,sp,32
ffffffffc02044ee:	8082                	ret
ffffffffc02044f0:	75fd                	lui	a1,0xfffff
ffffffffc02044f2:	00177793          	andi	a5,a4,1
ffffffffc02044f6:	8de1                	and	a1,a1,s0
ffffffffc02044f8:	05100613          	li	a2,81
ffffffffc02044fc:	c399                	beqz	a5,ffffffffc0204502 <do_pgfault+0x68>
ffffffffc02044fe:	05300613          	li	a2,83
ffffffffc0204502:	d6f1                	beqz	a3,ffffffffc02044ce <do_pgfault+0x34>
ffffffffc0204504:	0d700613          	li	a2,215
ffffffffc0204508:	b7d9                	j	ffffffffc02044ce <do_pgfault+0x34>
ffffffffc020450a:	5575                	li	a0,-3
ffffffffc020450c:	bfe1                	j	ffffffffc02044e4 <do_pgfault+0x4a>
ffffffffc020450e:	5571                	li	a0,-4
ffffffffc0204510:	bfd1                	j	ffffffffc02044e4 <do_pgfault+0x4a>

ffffffffc0204512 <__down.constprop.0>:
ffffffffc0204512:	715d                	addi	sp,sp,-80
ffffffffc0204514:	e0a2                	sd	s0,64(sp)
ffffffffc0204516:	e486                	sd	ra,72(sp)
ffffffffc0204518:	fc26                	sd	s1,56(sp)
ffffffffc020451a:	842a                	mv	s0,a0
ffffffffc020451c:	100027f3          	csrr	a5,sstatus
ffffffffc0204520:	8b89                	andi	a5,a5,2
ffffffffc0204522:	ebb1                	bnez	a5,ffffffffc0204576 <__down.constprop.0+0x64>
ffffffffc0204524:	411c                	lw	a5,0(a0)
ffffffffc0204526:	00f05a63          	blez	a5,ffffffffc020453a <__down.constprop.0+0x28>
ffffffffc020452a:	37fd                	addiw	a5,a5,-1
ffffffffc020452c:	c11c                	sw	a5,0(a0)
ffffffffc020452e:	4501                	li	a0,0
ffffffffc0204530:	60a6                	ld	ra,72(sp)
ffffffffc0204532:	6406                	ld	s0,64(sp)
ffffffffc0204534:	74e2                	ld	s1,56(sp)
ffffffffc0204536:	6161                	addi	sp,sp,80
ffffffffc0204538:	8082                	ret
ffffffffc020453a:	00850413          	addi	s0,a0,8 # ffffffffc8000008 <end+0x7d696f8>
ffffffffc020453e:	0024                	addi	s1,sp,8
ffffffffc0204540:	10000613          	li	a2,256
ffffffffc0204544:	85a6                	mv	a1,s1
ffffffffc0204546:	8522                	mv	a0,s0
ffffffffc0204548:	2d8000ef          	jal	ra,ffffffffc0204820 <wait_current_set>
ffffffffc020454c:	7d5020ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc0204550:	100027f3          	csrr	a5,sstatus
ffffffffc0204554:	8b89                	andi	a5,a5,2
ffffffffc0204556:	efb9                	bnez	a5,ffffffffc02045b4 <__down.constprop.0+0xa2>
ffffffffc0204558:	8526                	mv	a0,s1
ffffffffc020455a:	19c000ef          	jal	ra,ffffffffc02046f6 <wait_in_queue>
ffffffffc020455e:	e531                	bnez	a0,ffffffffc02045aa <__down.constprop.0+0x98>
ffffffffc0204560:	4542                	lw	a0,16(sp)
ffffffffc0204562:	10000793          	li	a5,256
ffffffffc0204566:	fcf515e3          	bne	a0,a5,ffffffffc0204530 <__down.constprop.0+0x1e>
ffffffffc020456a:	60a6                	ld	ra,72(sp)
ffffffffc020456c:	6406                	ld	s0,64(sp)
ffffffffc020456e:	74e2                	ld	s1,56(sp)
ffffffffc0204570:	4501                	li	a0,0
ffffffffc0204572:	6161                	addi	sp,sp,80
ffffffffc0204574:	8082                	ret
ffffffffc0204576:	efcfc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020457a:	401c                	lw	a5,0(s0)
ffffffffc020457c:	00f05c63          	blez	a5,ffffffffc0204594 <__down.constprop.0+0x82>
ffffffffc0204580:	37fd                	addiw	a5,a5,-1
ffffffffc0204582:	c01c                	sw	a5,0(s0)
ffffffffc0204584:	ee8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204588:	60a6                	ld	ra,72(sp)
ffffffffc020458a:	6406                	ld	s0,64(sp)
ffffffffc020458c:	74e2                	ld	s1,56(sp)
ffffffffc020458e:	4501                	li	a0,0
ffffffffc0204590:	6161                	addi	sp,sp,80
ffffffffc0204592:	8082                	ret
ffffffffc0204594:	0421                	addi	s0,s0,8
ffffffffc0204596:	0024                	addi	s1,sp,8
ffffffffc0204598:	10000613          	li	a2,256
ffffffffc020459c:	85a6                	mv	a1,s1
ffffffffc020459e:	8522                	mv	a0,s0
ffffffffc02045a0:	280000ef          	jal	ra,ffffffffc0204820 <wait_current_set>
ffffffffc02045a4:	ec8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02045a8:	b755                	j	ffffffffc020454c <__down.constprop.0+0x3a>
ffffffffc02045aa:	85a6                	mv	a1,s1
ffffffffc02045ac:	8522                	mv	a0,s0
ffffffffc02045ae:	0ee000ef          	jal	ra,ffffffffc020469c <wait_queue_del>
ffffffffc02045b2:	b77d                	j	ffffffffc0204560 <__down.constprop.0+0x4e>
ffffffffc02045b4:	ebefc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02045b8:	8526                	mv	a0,s1
ffffffffc02045ba:	13c000ef          	jal	ra,ffffffffc02046f6 <wait_in_queue>
ffffffffc02045be:	e501                	bnez	a0,ffffffffc02045c6 <__down.constprop.0+0xb4>
ffffffffc02045c0:	eacfc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02045c4:	bf71                	j	ffffffffc0204560 <__down.constprop.0+0x4e>
ffffffffc02045c6:	85a6                	mv	a1,s1
ffffffffc02045c8:	8522                	mv	a0,s0
ffffffffc02045ca:	0d2000ef          	jal	ra,ffffffffc020469c <wait_queue_del>
ffffffffc02045ce:	bfcd                	j	ffffffffc02045c0 <__down.constprop.0+0xae>

ffffffffc02045d0 <__up.constprop.0>:
ffffffffc02045d0:	1101                	addi	sp,sp,-32
ffffffffc02045d2:	e822                	sd	s0,16(sp)
ffffffffc02045d4:	ec06                	sd	ra,24(sp)
ffffffffc02045d6:	e426                	sd	s1,8(sp)
ffffffffc02045d8:	e04a                	sd	s2,0(sp)
ffffffffc02045da:	842a                	mv	s0,a0
ffffffffc02045dc:	100027f3          	csrr	a5,sstatus
ffffffffc02045e0:	8b89                	andi	a5,a5,2
ffffffffc02045e2:	4901                	li	s2,0
ffffffffc02045e4:	eba1                	bnez	a5,ffffffffc0204634 <__up.constprop.0+0x64>
ffffffffc02045e6:	00840493          	addi	s1,s0,8
ffffffffc02045ea:	8526                	mv	a0,s1
ffffffffc02045ec:	0ee000ef          	jal	ra,ffffffffc02046da <wait_queue_first>
ffffffffc02045f0:	85aa                	mv	a1,a0
ffffffffc02045f2:	cd0d                	beqz	a0,ffffffffc020462c <__up.constprop.0+0x5c>
ffffffffc02045f4:	6118                	ld	a4,0(a0)
ffffffffc02045f6:	10000793          	li	a5,256
ffffffffc02045fa:	0ec72703          	lw	a4,236(a4)
ffffffffc02045fe:	02f71f63          	bne	a4,a5,ffffffffc020463c <__up.constprop.0+0x6c>
ffffffffc0204602:	4685                	li	a3,1
ffffffffc0204604:	10000613          	li	a2,256
ffffffffc0204608:	8526                	mv	a0,s1
ffffffffc020460a:	0fa000ef          	jal	ra,ffffffffc0204704 <wakeup_wait>
ffffffffc020460e:	00091863          	bnez	s2,ffffffffc020461e <__up.constprop.0+0x4e>
ffffffffc0204612:	60e2                	ld	ra,24(sp)
ffffffffc0204614:	6442                	ld	s0,16(sp)
ffffffffc0204616:	64a2                	ld	s1,8(sp)
ffffffffc0204618:	6902                	ld	s2,0(sp)
ffffffffc020461a:	6105                	addi	sp,sp,32
ffffffffc020461c:	8082                	ret
ffffffffc020461e:	6442                	ld	s0,16(sp)
ffffffffc0204620:	60e2                	ld	ra,24(sp)
ffffffffc0204622:	64a2                	ld	s1,8(sp)
ffffffffc0204624:	6902                	ld	s2,0(sp)
ffffffffc0204626:	6105                	addi	sp,sp,32
ffffffffc0204628:	e44fc06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020462c:	401c                	lw	a5,0(s0)
ffffffffc020462e:	2785                	addiw	a5,a5,1
ffffffffc0204630:	c01c                	sw	a5,0(s0)
ffffffffc0204632:	bff1                	j	ffffffffc020460e <__up.constprop.0+0x3e>
ffffffffc0204634:	e3efc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0204638:	4905                	li	s2,1
ffffffffc020463a:	b775                	j	ffffffffc02045e6 <__up.constprop.0+0x16>
ffffffffc020463c:	00009697          	auipc	a3,0x9
ffffffffc0204640:	abc68693          	addi	a3,a3,-1348 # ffffffffc020d0f8 <default_pmm_manager+0xaa0>
ffffffffc0204644:	00007617          	auipc	a2,0x7
ffffffffc0204648:	53460613          	addi	a2,a2,1332 # ffffffffc020bb78 <commands+0x210>
ffffffffc020464c:	45e5                	li	a1,25
ffffffffc020464e:	00009517          	auipc	a0,0x9
ffffffffc0204652:	ad250513          	addi	a0,a0,-1326 # ffffffffc020d120 <default_pmm_manager+0xac8>
ffffffffc0204656:	e49fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020465a <sem_init>:
ffffffffc020465a:	c10c                	sw	a1,0(a0)
ffffffffc020465c:	0521                	addi	a0,a0,8
ffffffffc020465e:	a825                	j	ffffffffc0204696 <wait_queue_init>

ffffffffc0204660 <up>:
ffffffffc0204660:	f71ff06f          	j	ffffffffc02045d0 <__up.constprop.0>

ffffffffc0204664 <down>:
ffffffffc0204664:	1141                	addi	sp,sp,-16
ffffffffc0204666:	e406                	sd	ra,8(sp)
ffffffffc0204668:	eabff0ef          	jal	ra,ffffffffc0204512 <__down.constprop.0>
ffffffffc020466c:	2501                	sext.w	a0,a0
ffffffffc020466e:	e501                	bnez	a0,ffffffffc0204676 <down+0x12>
ffffffffc0204670:	60a2                	ld	ra,8(sp)
ffffffffc0204672:	0141                	addi	sp,sp,16
ffffffffc0204674:	8082                	ret
ffffffffc0204676:	00009697          	auipc	a3,0x9
ffffffffc020467a:	aba68693          	addi	a3,a3,-1350 # ffffffffc020d130 <default_pmm_manager+0xad8>
ffffffffc020467e:	00007617          	auipc	a2,0x7
ffffffffc0204682:	4fa60613          	addi	a2,a2,1274 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204686:	04000593          	li	a1,64
ffffffffc020468a:	00009517          	auipc	a0,0x9
ffffffffc020468e:	a9650513          	addi	a0,a0,-1386 # ffffffffc020d120 <default_pmm_manager+0xac8>
ffffffffc0204692:	e0dfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204696 <wait_queue_init>:
ffffffffc0204696:	e508                	sd	a0,8(a0)
ffffffffc0204698:	e108                	sd	a0,0(a0)
ffffffffc020469a:	8082                	ret

ffffffffc020469c <wait_queue_del>:
ffffffffc020469c:	7198                	ld	a4,32(a1)
ffffffffc020469e:	01858793          	addi	a5,a1,24 # fffffffffffff018 <end+0x3fd68708>
ffffffffc02046a2:	00e78b63          	beq	a5,a4,ffffffffc02046b8 <wait_queue_del+0x1c>
ffffffffc02046a6:	6994                	ld	a3,16(a1)
ffffffffc02046a8:	00a69863          	bne	a3,a0,ffffffffc02046b8 <wait_queue_del+0x1c>
ffffffffc02046ac:	6d94                	ld	a3,24(a1)
ffffffffc02046ae:	e698                	sd	a4,8(a3)
ffffffffc02046b0:	e314                	sd	a3,0(a4)
ffffffffc02046b2:	f19c                	sd	a5,32(a1)
ffffffffc02046b4:	ed9c                	sd	a5,24(a1)
ffffffffc02046b6:	8082                	ret
ffffffffc02046b8:	1141                	addi	sp,sp,-16
ffffffffc02046ba:	00009697          	auipc	a3,0x9
ffffffffc02046be:	ad668693          	addi	a3,a3,-1322 # ffffffffc020d190 <default_pmm_manager+0xb38>
ffffffffc02046c2:	00007617          	auipc	a2,0x7
ffffffffc02046c6:	4b660613          	addi	a2,a2,1206 # ffffffffc020bb78 <commands+0x210>
ffffffffc02046ca:	45f1                	li	a1,28
ffffffffc02046cc:	00009517          	auipc	a0,0x9
ffffffffc02046d0:	aac50513          	addi	a0,a0,-1364 # ffffffffc020d178 <default_pmm_manager+0xb20>
ffffffffc02046d4:	e406                	sd	ra,8(sp)
ffffffffc02046d6:	dc9fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02046da <wait_queue_first>:
ffffffffc02046da:	651c                	ld	a5,8(a0)
ffffffffc02046dc:	00f50563          	beq	a0,a5,ffffffffc02046e6 <wait_queue_first+0xc>
ffffffffc02046e0:	fe878513          	addi	a0,a5,-24
ffffffffc02046e4:	8082                	ret
ffffffffc02046e6:	4501                	li	a0,0
ffffffffc02046e8:	8082                	ret

ffffffffc02046ea <wait_queue_empty>:
ffffffffc02046ea:	651c                	ld	a5,8(a0)
ffffffffc02046ec:	40a78533          	sub	a0,a5,a0
ffffffffc02046f0:	00153513          	seqz	a0,a0
ffffffffc02046f4:	8082                	ret

ffffffffc02046f6 <wait_in_queue>:
ffffffffc02046f6:	711c                	ld	a5,32(a0)
ffffffffc02046f8:	0561                	addi	a0,a0,24
ffffffffc02046fa:	40a78533          	sub	a0,a5,a0
ffffffffc02046fe:	00a03533          	snez	a0,a0
ffffffffc0204702:	8082                	ret

ffffffffc0204704 <wakeup_wait>:
ffffffffc0204704:	e689                	bnez	a3,ffffffffc020470e <wakeup_wait+0xa>
ffffffffc0204706:	6188                	ld	a0,0(a1)
ffffffffc0204708:	c590                	sw	a2,8(a1)
ffffffffc020470a:	5650206f          	j	ffffffffc020746e <wakeup_proc>
ffffffffc020470e:	7198                	ld	a4,32(a1)
ffffffffc0204710:	01858793          	addi	a5,a1,24
ffffffffc0204714:	00e78e63          	beq	a5,a4,ffffffffc0204730 <wakeup_wait+0x2c>
ffffffffc0204718:	6994                	ld	a3,16(a1)
ffffffffc020471a:	00d51b63          	bne	a0,a3,ffffffffc0204730 <wakeup_wait+0x2c>
ffffffffc020471e:	6d94                	ld	a3,24(a1)
ffffffffc0204720:	6188                	ld	a0,0(a1)
ffffffffc0204722:	e698                	sd	a4,8(a3)
ffffffffc0204724:	e314                	sd	a3,0(a4)
ffffffffc0204726:	f19c                	sd	a5,32(a1)
ffffffffc0204728:	ed9c                	sd	a5,24(a1)
ffffffffc020472a:	c590                	sw	a2,8(a1)
ffffffffc020472c:	5430206f          	j	ffffffffc020746e <wakeup_proc>
ffffffffc0204730:	1141                	addi	sp,sp,-16
ffffffffc0204732:	00009697          	auipc	a3,0x9
ffffffffc0204736:	a5e68693          	addi	a3,a3,-1442 # ffffffffc020d190 <default_pmm_manager+0xb38>
ffffffffc020473a:	00007617          	auipc	a2,0x7
ffffffffc020473e:	43e60613          	addi	a2,a2,1086 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204742:	45f1                	li	a1,28
ffffffffc0204744:	00009517          	auipc	a0,0x9
ffffffffc0204748:	a3450513          	addi	a0,a0,-1484 # ffffffffc020d178 <default_pmm_manager+0xb20>
ffffffffc020474c:	e406                	sd	ra,8(sp)
ffffffffc020474e:	d51fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204752 <wakeup_queue>:
ffffffffc0204752:	651c                	ld	a5,8(a0)
ffffffffc0204754:	0ca78563          	beq	a5,a0,ffffffffc020481e <wakeup_queue+0xcc>
ffffffffc0204758:	1101                	addi	sp,sp,-32
ffffffffc020475a:	e822                	sd	s0,16(sp)
ffffffffc020475c:	e426                	sd	s1,8(sp)
ffffffffc020475e:	e04a                	sd	s2,0(sp)
ffffffffc0204760:	ec06                	sd	ra,24(sp)
ffffffffc0204762:	84aa                	mv	s1,a0
ffffffffc0204764:	892e                	mv	s2,a1
ffffffffc0204766:	fe878413          	addi	s0,a5,-24
ffffffffc020476a:	e23d                	bnez	a2,ffffffffc02047d0 <wakeup_queue+0x7e>
ffffffffc020476c:	6008                	ld	a0,0(s0)
ffffffffc020476e:	01242423          	sw	s2,8(s0)
ffffffffc0204772:	4fd020ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc0204776:	701c                	ld	a5,32(s0)
ffffffffc0204778:	01840713          	addi	a4,s0,24
ffffffffc020477c:	02e78463          	beq	a5,a4,ffffffffc02047a4 <wakeup_queue+0x52>
ffffffffc0204780:	6818                	ld	a4,16(s0)
ffffffffc0204782:	02e49163          	bne	s1,a4,ffffffffc02047a4 <wakeup_queue+0x52>
ffffffffc0204786:	02f48f63          	beq	s1,a5,ffffffffc02047c4 <wakeup_queue+0x72>
ffffffffc020478a:	fe87b503          	ld	a0,-24(a5)
ffffffffc020478e:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204792:	fe878413          	addi	s0,a5,-24
ffffffffc0204796:	4d9020ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc020479a:	701c                	ld	a5,32(s0)
ffffffffc020479c:	01840713          	addi	a4,s0,24
ffffffffc02047a0:	fee790e3          	bne	a5,a4,ffffffffc0204780 <wakeup_queue+0x2e>
ffffffffc02047a4:	00009697          	auipc	a3,0x9
ffffffffc02047a8:	9ec68693          	addi	a3,a3,-1556 # ffffffffc020d190 <default_pmm_manager+0xb38>
ffffffffc02047ac:	00007617          	auipc	a2,0x7
ffffffffc02047b0:	3cc60613          	addi	a2,a2,972 # ffffffffc020bb78 <commands+0x210>
ffffffffc02047b4:	02200593          	li	a1,34
ffffffffc02047b8:	00009517          	auipc	a0,0x9
ffffffffc02047bc:	9c050513          	addi	a0,a0,-1600 # ffffffffc020d178 <default_pmm_manager+0xb20>
ffffffffc02047c0:	cdffb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02047c4:	60e2                	ld	ra,24(sp)
ffffffffc02047c6:	6442                	ld	s0,16(sp)
ffffffffc02047c8:	64a2                	ld	s1,8(sp)
ffffffffc02047ca:	6902                	ld	s2,0(sp)
ffffffffc02047cc:	6105                	addi	sp,sp,32
ffffffffc02047ce:	8082                	ret
ffffffffc02047d0:	6798                	ld	a4,8(a5)
ffffffffc02047d2:	02f70763          	beq	a4,a5,ffffffffc0204800 <wakeup_queue+0xae>
ffffffffc02047d6:	6814                	ld	a3,16(s0)
ffffffffc02047d8:	02d49463          	bne	s1,a3,ffffffffc0204800 <wakeup_queue+0xae>
ffffffffc02047dc:	6c14                	ld	a3,24(s0)
ffffffffc02047de:	6008                	ld	a0,0(s0)
ffffffffc02047e0:	e698                	sd	a4,8(a3)
ffffffffc02047e2:	e314                	sd	a3,0(a4)
ffffffffc02047e4:	f01c                	sd	a5,32(s0)
ffffffffc02047e6:	ec1c                	sd	a5,24(s0)
ffffffffc02047e8:	01242423          	sw	s2,8(s0)
ffffffffc02047ec:	483020ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc02047f0:	6480                	ld	s0,8(s1)
ffffffffc02047f2:	fc8489e3          	beq	s1,s0,ffffffffc02047c4 <wakeup_queue+0x72>
ffffffffc02047f6:	6418                	ld	a4,8(s0)
ffffffffc02047f8:	87a2                	mv	a5,s0
ffffffffc02047fa:	1421                	addi	s0,s0,-24
ffffffffc02047fc:	fce79de3          	bne	a5,a4,ffffffffc02047d6 <wakeup_queue+0x84>
ffffffffc0204800:	00009697          	auipc	a3,0x9
ffffffffc0204804:	99068693          	addi	a3,a3,-1648 # ffffffffc020d190 <default_pmm_manager+0xb38>
ffffffffc0204808:	00007617          	auipc	a2,0x7
ffffffffc020480c:	37060613          	addi	a2,a2,880 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204810:	45f1                	li	a1,28
ffffffffc0204812:	00009517          	auipc	a0,0x9
ffffffffc0204816:	96650513          	addi	a0,a0,-1690 # ffffffffc020d178 <default_pmm_manager+0xb20>
ffffffffc020481a:	c85fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020481e:	8082                	ret

ffffffffc0204820 <wait_current_set>:
ffffffffc0204820:	00092797          	auipc	a5,0x92
ffffffffc0204824:	0a07b783          	ld	a5,160(a5) # ffffffffc02968c0 <current>
ffffffffc0204828:	c39d                	beqz	a5,ffffffffc020484e <wait_current_set+0x2e>
ffffffffc020482a:	01858713          	addi	a4,a1,24
ffffffffc020482e:	800006b7          	lui	a3,0x80000
ffffffffc0204832:	ed98                	sd	a4,24(a1)
ffffffffc0204834:	e19c                	sd	a5,0(a1)
ffffffffc0204836:	c594                	sw	a3,8(a1)
ffffffffc0204838:	4685                	li	a3,1
ffffffffc020483a:	c394                	sw	a3,0(a5)
ffffffffc020483c:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204840:	611c                	ld	a5,0(a0)
ffffffffc0204842:	e988                	sd	a0,16(a1)
ffffffffc0204844:	e118                	sd	a4,0(a0)
ffffffffc0204846:	e798                	sd	a4,8(a5)
ffffffffc0204848:	f188                	sd	a0,32(a1)
ffffffffc020484a:	ed9c                	sd	a5,24(a1)
ffffffffc020484c:	8082                	ret
ffffffffc020484e:	1141                	addi	sp,sp,-16
ffffffffc0204850:	00009697          	auipc	a3,0x9
ffffffffc0204854:	98068693          	addi	a3,a3,-1664 # ffffffffc020d1d0 <default_pmm_manager+0xb78>
ffffffffc0204858:	00007617          	auipc	a2,0x7
ffffffffc020485c:	32060613          	addi	a2,a2,800 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204860:	07400593          	li	a1,116
ffffffffc0204864:	00009517          	auipc	a0,0x9
ffffffffc0204868:	91450513          	addi	a0,a0,-1772 # ffffffffc020d178 <default_pmm_manager+0xb20>
ffffffffc020486c:	e406                	sd	ra,8(sp)
ffffffffc020486e:	c31fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204872 <get_fd_array.part.0>:
ffffffffc0204872:	1141                	addi	sp,sp,-16
ffffffffc0204874:	00009697          	auipc	a3,0x9
ffffffffc0204878:	96c68693          	addi	a3,a3,-1684 # ffffffffc020d1e0 <default_pmm_manager+0xb88>
ffffffffc020487c:	00007617          	auipc	a2,0x7
ffffffffc0204880:	2fc60613          	addi	a2,a2,764 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204884:	45d1                	li	a1,20
ffffffffc0204886:	00009517          	auipc	a0,0x9
ffffffffc020488a:	98a50513          	addi	a0,a0,-1654 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc020488e:	e406                	sd	ra,8(sp)
ffffffffc0204890:	c0ffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204894 <fd_array_alloc>:
ffffffffc0204894:	00092797          	auipc	a5,0x92
ffffffffc0204898:	02c7b783          	ld	a5,44(a5) # ffffffffc02968c0 <current>
ffffffffc020489c:	1487b783          	ld	a5,328(a5)
ffffffffc02048a0:	1141                	addi	sp,sp,-16
ffffffffc02048a2:	e406                	sd	ra,8(sp)
ffffffffc02048a4:	c3a5                	beqz	a5,ffffffffc0204904 <fd_array_alloc+0x70>
ffffffffc02048a6:	4b98                	lw	a4,16(a5)
ffffffffc02048a8:	04e05e63          	blez	a4,ffffffffc0204904 <fd_array_alloc+0x70>
ffffffffc02048ac:	775d                	lui	a4,0xffff7
ffffffffc02048ae:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02048b2:	679c                	ld	a5,8(a5)
ffffffffc02048b4:	02e50863          	beq	a0,a4,ffffffffc02048e4 <fd_array_alloc+0x50>
ffffffffc02048b8:	04700713          	li	a4,71
ffffffffc02048bc:	04a76263          	bltu	a4,a0,ffffffffc0204900 <fd_array_alloc+0x6c>
ffffffffc02048c0:	00351713          	slli	a4,a0,0x3
ffffffffc02048c4:	40a70533          	sub	a0,a4,a0
ffffffffc02048c8:	050e                	slli	a0,a0,0x3
ffffffffc02048ca:	97aa                	add	a5,a5,a0
ffffffffc02048cc:	4398                	lw	a4,0(a5)
ffffffffc02048ce:	e71d                	bnez	a4,ffffffffc02048fc <fd_array_alloc+0x68>
ffffffffc02048d0:	5b88                	lw	a0,48(a5)
ffffffffc02048d2:	e91d                	bnez	a0,ffffffffc0204908 <fd_array_alloc+0x74>
ffffffffc02048d4:	4705                	li	a4,1
ffffffffc02048d6:	c398                	sw	a4,0(a5)
ffffffffc02048d8:	0207b423          	sd	zero,40(a5)
ffffffffc02048dc:	e19c                	sd	a5,0(a1)
ffffffffc02048de:	60a2                	ld	ra,8(sp)
ffffffffc02048e0:	0141                	addi	sp,sp,16
ffffffffc02048e2:	8082                	ret
ffffffffc02048e4:	6685                	lui	a3,0x1
ffffffffc02048e6:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02048ea:	96be                	add	a3,a3,a5
ffffffffc02048ec:	4398                	lw	a4,0(a5)
ffffffffc02048ee:	d36d                	beqz	a4,ffffffffc02048d0 <fd_array_alloc+0x3c>
ffffffffc02048f0:	03878793          	addi	a5,a5,56
ffffffffc02048f4:	fef69ce3          	bne	a3,a5,ffffffffc02048ec <fd_array_alloc+0x58>
ffffffffc02048f8:	5529                	li	a0,-22
ffffffffc02048fa:	b7d5                	j	ffffffffc02048de <fd_array_alloc+0x4a>
ffffffffc02048fc:	5545                	li	a0,-15
ffffffffc02048fe:	b7c5                	j	ffffffffc02048de <fd_array_alloc+0x4a>
ffffffffc0204900:	5575                	li	a0,-3
ffffffffc0204902:	bff1                	j	ffffffffc02048de <fd_array_alloc+0x4a>
ffffffffc0204904:	f6fff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>
ffffffffc0204908:	00009697          	auipc	a3,0x9
ffffffffc020490c:	91868693          	addi	a3,a3,-1768 # ffffffffc020d220 <default_pmm_manager+0xbc8>
ffffffffc0204910:	00007617          	auipc	a2,0x7
ffffffffc0204914:	26860613          	addi	a2,a2,616 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204918:	03b00593          	li	a1,59
ffffffffc020491c:	00009517          	auipc	a0,0x9
ffffffffc0204920:	8f450513          	addi	a0,a0,-1804 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204924:	b7bfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204928 <fd_array_free>:
ffffffffc0204928:	411c                	lw	a5,0(a0)
ffffffffc020492a:	1141                	addi	sp,sp,-16
ffffffffc020492c:	e022                	sd	s0,0(sp)
ffffffffc020492e:	e406                	sd	ra,8(sp)
ffffffffc0204930:	4705                	li	a4,1
ffffffffc0204932:	842a                	mv	s0,a0
ffffffffc0204934:	04e78063          	beq	a5,a4,ffffffffc0204974 <fd_array_free+0x4c>
ffffffffc0204938:	470d                	li	a4,3
ffffffffc020493a:	04e79563          	bne	a5,a4,ffffffffc0204984 <fd_array_free+0x5c>
ffffffffc020493e:	591c                	lw	a5,48(a0)
ffffffffc0204940:	c38d                	beqz	a5,ffffffffc0204962 <fd_array_free+0x3a>
ffffffffc0204942:	00009697          	auipc	a3,0x9
ffffffffc0204946:	8de68693          	addi	a3,a3,-1826 # ffffffffc020d220 <default_pmm_manager+0xbc8>
ffffffffc020494a:	00007617          	auipc	a2,0x7
ffffffffc020494e:	22e60613          	addi	a2,a2,558 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204952:	04500593          	li	a1,69
ffffffffc0204956:	00009517          	auipc	a0,0x9
ffffffffc020495a:	8ba50513          	addi	a0,a0,-1862 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc020495e:	b41fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204962:	7408                	ld	a0,40(s0)
ffffffffc0204964:	181030ef          	jal	ra,ffffffffc02082e4 <vfs_close>
ffffffffc0204968:	60a2                	ld	ra,8(sp)
ffffffffc020496a:	00042023          	sw	zero,0(s0)
ffffffffc020496e:	6402                	ld	s0,0(sp)
ffffffffc0204970:	0141                	addi	sp,sp,16
ffffffffc0204972:	8082                	ret
ffffffffc0204974:	591c                	lw	a5,48(a0)
ffffffffc0204976:	f7f1                	bnez	a5,ffffffffc0204942 <fd_array_free+0x1a>
ffffffffc0204978:	60a2                	ld	ra,8(sp)
ffffffffc020497a:	00042023          	sw	zero,0(s0)
ffffffffc020497e:	6402                	ld	s0,0(sp)
ffffffffc0204980:	0141                	addi	sp,sp,16
ffffffffc0204982:	8082                	ret
ffffffffc0204984:	00009697          	auipc	a3,0x9
ffffffffc0204988:	8d468693          	addi	a3,a3,-1836 # ffffffffc020d258 <default_pmm_manager+0xc00>
ffffffffc020498c:	00007617          	auipc	a2,0x7
ffffffffc0204990:	1ec60613          	addi	a2,a2,492 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204994:	04400593          	li	a1,68
ffffffffc0204998:	00009517          	auipc	a0,0x9
ffffffffc020499c:	87850513          	addi	a0,a0,-1928 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc02049a0:	afffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049a4 <fd_array_release>:
ffffffffc02049a4:	4118                	lw	a4,0(a0)
ffffffffc02049a6:	1141                	addi	sp,sp,-16
ffffffffc02049a8:	e406                	sd	ra,8(sp)
ffffffffc02049aa:	4685                	li	a3,1
ffffffffc02049ac:	3779                	addiw	a4,a4,-2
ffffffffc02049ae:	04e6e063          	bltu	a3,a4,ffffffffc02049ee <fd_array_release+0x4a>
ffffffffc02049b2:	5918                	lw	a4,48(a0)
ffffffffc02049b4:	00e05d63          	blez	a4,ffffffffc02049ce <fd_array_release+0x2a>
ffffffffc02049b8:	fff7069b          	addiw	a3,a4,-1
ffffffffc02049bc:	d914                	sw	a3,48(a0)
ffffffffc02049be:	c681                	beqz	a3,ffffffffc02049c6 <fd_array_release+0x22>
ffffffffc02049c0:	60a2                	ld	ra,8(sp)
ffffffffc02049c2:	0141                	addi	sp,sp,16
ffffffffc02049c4:	8082                	ret
ffffffffc02049c6:	60a2                	ld	ra,8(sp)
ffffffffc02049c8:	0141                	addi	sp,sp,16
ffffffffc02049ca:	f5fff06f          	j	ffffffffc0204928 <fd_array_free>
ffffffffc02049ce:	00009697          	auipc	a3,0x9
ffffffffc02049d2:	8fa68693          	addi	a3,a3,-1798 # ffffffffc020d2c8 <default_pmm_manager+0xc70>
ffffffffc02049d6:	00007617          	auipc	a2,0x7
ffffffffc02049da:	1a260613          	addi	a2,a2,418 # ffffffffc020bb78 <commands+0x210>
ffffffffc02049de:	05600593          	li	a1,86
ffffffffc02049e2:	00009517          	auipc	a0,0x9
ffffffffc02049e6:	82e50513          	addi	a0,a0,-2002 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc02049ea:	ab5fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02049ee:	00009697          	auipc	a3,0x9
ffffffffc02049f2:	8a268693          	addi	a3,a3,-1886 # ffffffffc020d290 <default_pmm_manager+0xc38>
ffffffffc02049f6:	00007617          	auipc	a2,0x7
ffffffffc02049fa:	18260613          	addi	a2,a2,386 # ffffffffc020bb78 <commands+0x210>
ffffffffc02049fe:	05500593          	li	a1,85
ffffffffc0204a02:	00009517          	auipc	a0,0x9
ffffffffc0204a06:	80e50513          	addi	a0,a0,-2034 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204a0a:	a95fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204a0e <fd_array_open.part.0>:
ffffffffc0204a0e:	1141                	addi	sp,sp,-16
ffffffffc0204a10:	00009697          	auipc	a3,0x9
ffffffffc0204a14:	8d068693          	addi	a3,a3,-1840 # ffffffffc020d2e0 <default_pmm_manager+0xc88>
ffffffffc0204a18:	00007617          	auipc	a2,0x7
ffffffffc0204a1c:	16060613          	addi	a2,a2,352 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204a20:	05f00593          	li	a1,95
ffffffffc0204a24:	00008517          	auipc	a0,0x8
ffffffffc0204a28:	7ec50513          	addi	a0,a0,2028 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204a2c:	e406                	sd	ra,8(sp)
ffffffffc0204a2e:	a71fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204a32 <fd_array_init>:
ffffffffc0204a32:	4781                	li	a5,0
ffffffffc0204a34:	04800713          	li	a4,72
ffffffffc0204a38:	cd1c                	sw	a5,24(a0)
ffffffffc0204a3a:	02052823          	sw	zero,48(a0)
ffffffffc0204a3e:	00052023          	sw	zero,0(a0)
ffffffffc0204a42:	2785                	addiw	a5,a5,1
ffffffffc0204a44:	03850513          	addi	a0,a0,56
ffffffffc0204a48:	fee798e3          	bne	a5,a4,ffffffffc0204a38 <fd_array_init+0x6>
ffffffffc0204a4c:	8082                	ret

ffffffffc0204a4e <fd_array_close>:
ffffffffc0204a4e:	4118                	lw	a4,0(a0)
ffffffffc0204a50:	1141                	addi	sp,sp,-16
ffffffffc0204a52:	e406                	sd	ra,8(sp)
ffffffffc0204a54:	e022                	sd	s0,0(sp)
ffffffffc0204a56:	4789                	li	a5,2
ffffffffc0204a58:	04f71a63          	bne	a4,a5,ffffffffc0204aac <fd_array_close+0x5e>
ffffffffc0204a5c:	591c                	lw	a5,48(a0)
ffffffffc0204a5e:	842a                	mv	s0,a0
ffffffffc0204a60:	02f05663          	blez	a5,ffffffffc0204a8c <fd_array_close+0x3e>
ffffffffc0204a64:	37fd                	addiw	a5,a5,-1
ffffffffc0204a66:	470d                	li	a4,3
ffffffffc0204a68:	c118                	sw	a4,0(a0)
ffffffffc0204a6a:	d91c                	sw	a5,48(a0)
ffffffffc0204a6c:	0007871b          	sext.w	a4,a5
ffffffffc0204a70:	c709                	beqz	a4,ffffffffc0204a7a <fd_array_close+0x2c>
ffffffffc0204a72:	60a2                	ld	ra,8(sp)
ffffffffc0204a74:	6402                	ld	s0,0(sp)
ffffffffc0204a76:	0141                	addi	sp,sp,16
ffffffffc0204a78:	8082                	ret
ffffffffc0204a7a:	7508                	ld	a0,40(a0)
ffffffffc0204a7c:	069030ef          	jal	ra,ffffffffc02082e4 <vfs_close>
ffffffffc0204a80:	60a2                	ld	ra,8(sp)
ffffffffc0204a82:	00042023          	sw	zero,0(s0)
ffffffffc0204a86:	6402                	ld	s0,0(sp)
ffffffffc0204a88:	0141                	addi	sp,sp,16
ffffffffc0204a8a:	8082                	ret
ffffffffc0204a8c:	00009697          	auipc	a3,0x9
ffffffffc0204a90:	83c68693          	addi	a3,a3,-1988 # ffffffffc020d2c8 <default_pmm_manager+0xc70>
ffffffffc0204a94:	00007617          	auipc	a2,0x7
ffffffffc0204a98:	0e460613          	addi	a2,a2,228 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204a9c:	06800593          	li	a1,104
ffffffffc0204aa0:	00008517          	auipc	a0,0x8
ffffffffc0204aa4:	77050513          	addi	a0,a0,1904 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204aa8:	9f7fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204aac:	00008697          	auipc	a3,0x8
ffffffffc0204ab0:	78c68693          	addi	a3,a3,1932 # ffffffffc020d238 <default_pmm_manager+0xbe0>
ffffffffc0204ab4:	00007617          	auipc	a2,0x7
ffffffffc0204ab8:	0c460613          	addi	a2,a2,196 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204abc:	06700593          	li	a1,103
ffffffffc0204ac0:	00008517          	auipc	a0,0x8
ffffffffc0204ac4:	75050513          	addi	a0,a0,1872 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204ac8:	9d7fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204acc <fd_array_dup>:
ffffffffc0204acc:	7179                	addi	sp,sp,-48
ffffffffc0204ace:	e84a                	sd	s2,16(sp)
ffffffffc0204ad0:	00052903          	lw	s2,0(a0)
ffffffffc0204ad4:	f406                	sd	ra,40(sp)
ffffffffc0204ad6:	f022                	sd	s0,32(sp)
ffffffffc0204ad8:	ec26                	sd	s1,24(sp)
ffffffffc0204ada:	e44e                	sd	s3,8(sp)
ffffffffc0204adc:	4785                	li	a5,1
ffffffffc0204ade:	04f91663          	bne	s2,a5,ffffffffc0204b2a <fd_array_dup+0x5e>
ffffffffc0204ae2:	0005a983          	lw	s3,0(a1)
ffffffffc0204ae6:	4789                	li	a5,2
ffffffffc0204ae8:	04f99163          	bne	s3,a5,ffffffffc0204b2a <fd_array_dup+0x5e>
ffffffffc0204aec:	7584                	ld	s1,40(a1)
ffffffffc0204aee:	699c                	ld	a5,16(a1)
ffffffffc0204af0:	7194                	ld	a3,32(a1)
ffffffffc0204af2:	6598                	ld	a4,8(a1)
ffffffffc0204af4:	842a                	mv	s0,a0
ffffffffc0204af6:	e91c                	sd	a5,16(a0)
ffffffffc0204af8:	f114                	sd	a3,32(a0)
ffffffffc0204afa:	e518                	sd	a4,8(a0)
ffffffffc0204afc:	8526                	mv	a0,s1
ffffffffc0204afe:	745020ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0204b02:	8526                	mv	a0,s1
ffffffffc0204b04:	74b020ef          	jal	ra,ffffffffc0207a4e <inode_open_inc>
ffffffffc0204b08:	401c                	lw	a5,0(s0)
ffffffffc0204b0a:	f404                	sd	s1,40(s0)
ffffffffc0204b0c:	03279f63          	bne	a5,s2,ffffffffc0204b4a <fd_array_dup+0x7e>
ffffffffc0204b10:	cc8d                	beqz	s1,ffffffffc0204b4a <fd_array_dup+0x7e>
ffffffffc0204b12:	581c                	lw	a5,48(s0)
ffffffffc0204b14:	01342023          	sw	s3,0(s0)
ffffffffc0204b18:	70a2                	ld	ra,40(sp)
ffffffffc0204b1a:	2785                	addiw	a5,a5,1
ffffffffc0204b1c:	d81c                	sw	a5,48(s0)
ffffffffc0204b1e:	7402                	ld	s0,32(sp)
ffffffffc0204b20:	64e2                	ld	s1,24(sp)
ffffffffc0204b22:	6942                	ld	s2,16(sp)
ffffffffc0204b24:	69a2                	ld	s3,8(sp)
ffffffffc0204b26:	6145                	addi	sp,sp,48
ffffffffc0204b28:	8082                	ret
ffffffffc0204b2a:	00008697          	auipc	a3,0x8
ffffffffc0204b2e:	7e668693          	addi	a3,a3,2022 # ffffffffc020d310 <default_pmm_manager+0xcb8>
ffffffffc0204b32:	00007617          	auipc	a2,0x7
ffffffffc0204b36:	04660613          	addi	a2,a2,70 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204b3a:	07300593          	li	a1,115
ffffffffc0204b3e:	00008517          	auipc	a0,0x8
ffffffffc0204b42:	6d250513          	addi	a0,a0,1746 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204b46:	959fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204b4a:	ec5ff0ef          	jal	ra,ffffffffc0204a0e <fd_array_open.part.0>

ffffffffc0204b4e <file_testfd>:
ffffffffc0204b4e:	04700793          	li	a5,71
ffffffffc0204b52:	04a7e263          	bltu	a5,a0,ffffffffc0204b96 <file_testfd+0x48>
ffffffffc0204b56:	00092797          	auipc	a5,0x92
ffffffffc0204b5a:	d6a7b783          	ld	a5,-662(a5) # ffffffffc02968c0 <current>
ffffffffc0204b5e:	1487b783          	ld	a5,328(a5)
ffffffffc0204b62:	cf85                	beqz	a5,ffffffffc0204b9a <file_testfd+0x4c>
ffffffffc0204b64:	4b98                	lw	a4,16(a5)
ffffffffc0204b66:	02e05a63          	blez	a4,ffffffffc0204b9a <file_testfd+0x4c>
ffffffffc0204b6a:	6798                	ld	a4,8(a5)
ffffffffc0204b6c:	00351793          	slli	a5,a0,0x3
ffffffffc0204b70:	8f89                	sub	a5,a5,a0
ffffffffc0204b72:	078e                	slli	a5,a5,0x3
ffffffffc0204b74:	97ba                	add	a5,a5,a4
ffffffffc0204b76:	4394                	lw	a3,0(a5)
ffffffffc0204b78:	4709                	li	a4,2
ffffffffc0204b7a:	00e69e63          	bne	a3,a4,ffffffffc0204b96 <file_testfd+0x48>
ffffffffc0204b7e:	4f98                	lw	a4,24(a5)
ffffffffc0204b80:	00a71b63          	bne	a4,a0,ffffffffc0204b96 <file_testfd+0x48>
ffffffffc0204b84:	c199                	beqz	a1,ffffffffc0204b8a <file_testfd+0x3c>
ffffffffc0204b86:	6788                	ld	a0,8(a5)
ffffffffc0204b88:	c901                	beqz	a0,ffffffffc0204b98 <file_testfd+0x4a>
ffffffffc0204b8a:	4505                	li	a0,1
ffffffffc0204b8c:	c611                	beqz	a2,ffffffffc0204b98 <file_testfd+0x4a>
ffffffffc0204b8e:	6b88                	ld	a0,16(a5)
ffffffffc0204b90:	00a03533          	snez	a0,a0
ffffffffc0204b94:	8082                	ret
ffffffffc0204b96:	4501                	li	a0,0
ffffffffc0204b98:	8082                	ret
ffffffffc0204b9a:	1141                	addi	sp,sp,-16
ffffffffc0204b9c:	e406                	sd	ra,8(sp)
ffffffffc0204b9e:	cd5ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc0204ba2 <file_open>:
ffffffffc0204ba2:	711d                	addi	sp,sp,-96
ffffffffc0204ba4:	ec86                	sd	ra,88(sp)
ffffffffc0204ba6:	e8a2                	sd	s0,80(sp)
ffffffffc0204ba8:	e4a6                	sd	s1,72(sp)
ffffffffc0204baa:	e0ca                	sd	s2,64(sp)
ffffffffc0204bac:	fc4e                	sd	s3,56(sp)
ffffffffc0204bae:	f852                	sd	s4,48(sp)
ffffffffc0204bb0:	0035f793          	andi	a5,a1,3
ffffffffc0204bb4:	470d                	li	a4,3
ffffffffc0204bb6:	0ce78163          	beq	a5,a4,ffffffffc0204c78 <file_open+0xd6>
ffffffffc0204bba:	078e                	slli	a5,a5,0x3
ffffffffc0204bbc:	00009717          	auipc	a4,0x9
ffffffffc0204bc0:	9c470713          	addi	a4,a4,-1596 # ffffffffc020d580 <CSWTCH.79>
ffffffffc0204bc4:	892a                	mv	s2,a0
ffffffffc0204bc6:	00009697          	auipc	a3,0x9
ffffffffc0204bca:	9a268693          	addi	a3,a3,-1630 # ffffffffc020d568 <CSWTCH.78>
ffffffffc0204bce:	755d                	lui	a0,0xffff7
ffffffffc0204bd0:	96be                	add	a3,a3,a5
ffffffffc0204bd2:	84ae                	mv	s1,a1
ffffffffc0204bd4:	97ba                	add	a5,a5,a4
ffffffffc0204bd6:	858a                	mv	a1,sp
ffffffffc0204bd8:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204bdc:	0006ba03          	ld	s4,0(a3)
ffffffffc0204be0:	0007b983          	ld	s3,0(a5)
ffffffffc0204be4:	cb1ff0ef          	jal	ra,ffffffffc0204894 <fd_array_alloc>
ffffffffc0204be8:	842a                	mv	s0,a0
ffffffffc0204bea:	c911                	beqz	a0,ffffffffc0204bfe <file_open+0x5c>
ffffffffc0204bec:	60e6                	ld	ra,88(sp)
ffffffffc0204bee:	8522                	mv	a0,s0
ffffffffc0204bf0:	6446                	ld	s0,80(sp)
ffffffffc0204bf2:	64a6                	ld	s1,72(sp)
ffffffffc0204bf4:	6906                	ld	s2,64(sp)
ffffffffc0204bf6:	79e2                	ld	s3,56(sp)
ffffffffc0204bf8:	7a42                	ld	s4,48(sp)
ffffffffc0204bfa:	6125                	addi	sp,sp,96
ffffffffc0204bfc:	8082                	ret
ffffffffc0204bfe:	0030                	addi	a2,sp,8
ffffffffc0204c00:	85a6                	mv	a1,s1
ffffffffc0204c02:	854a                	mv	a0,s2
ffffffffc0204c04:	53a030ef          	jal	ra,ffffffffc020813e <vfs_open>
ffffffffc0204c08:	842a                	mv	s0,a0
ffffffffc0204c0a:	e13d                	bnez	a0,ffffffffc0204c70 <file_open+0xce>
ffffffffc0204c0c:	6782                	ld	a5,0(sp)
ffffffffc0204c0e:	0204f493          	andi	s1,s1,32
ffffffffc0204c12:	6422                	ld	s0,8(sp)
ffffffffc0204c14:	0207b023          	sd	zero,32(a5)
ffffffffc0204c18:	c885                	beqz	s1,ffffffffc0204c48 <file_open+0xa6>
ffffffffc0204c1a:	c03d                	beqz	s0,ffffffffc0204c80 <file_open+0xde>
ffffffffc0204c1c:	783c                	ld	a5,112(s0)
ffffffffc0204c1e:	c3ad                	beqz	a5,ffffffffc0204c80 <file_open+0xde>
ffffffffc0204c20:	779c                	ld	a5,40(a5)
ffffffffc0204c22:	cfb9                	beqz	a5,ffffffffc0204c80 <file_open+0xde>
ffffffffc0204c24:	8522                	mv	a0,s0
ffffffffc0204c26:	00008597          	auipc	a1,0x8
ffffffffc0204c2a:	77258593          	addi	a1,a1,1906 # ffffffffc020d398 <default_pmm_manager+0xd40>
ffffffffc0204c2e:	62d020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0204c32:	783c                	ld	a5,112(s0)
ffffffffc0204c34:	6522                	ld	a0,8(sp)
ffffffffc0204c36:	080c                	addi	a1,sp,16
ffffffffc0204c38:	779c                	ld	a5,40(a5)
ffffffffc0204c3a:	9782                	jalr	a5
ffffffffc0204c3c:	842a                	mv	s0,a0
ffffffffc0204c3e:	e515                	bnez	a0,ffffffffc0204c6a <file_open+0xc8>
ffffffffc0204c40:	6782                	ld	a5,0(sp)
ffffffffc0204c42:	7722                	ld	a4,40(sp)
ffffffffc0204c44:	6422                	ld	s0,8(sp)
ffffffffc0204c46:	f398                	sd	a4,32(a5)
ffffffffc0204c48:	4394                	lw	a3,0(a5)
ffffffffc0204c4a:	f780                	sd	s0,40(a5)
ffffffffc0204c4c:	0147b423          	sd	s4,8(a5)
ffffffffc0204c50:	0137b823          	sd	s3,16(a5)
ffffffffc0204c54:	4705                	li	a4,1
ffffffffc0204c56:	02e69363          	bne	a3,a4,ffffffffc0204c7c <file_open+0xda>
ffffffffc0204c5a:	c00d                	beqz	s0,ffffffffc0204c7c <file_open+0xda>
ffffffffc0204c5c:	5b98                	lw	a4,48(a5)
ffffffffc0204c5e:	4689                	li	a3,2
ffffffffc0204c60:	4f80                	lw	s0,24(a5)
ffffffffc0204c62:	2705                	addiw	a4,a4,1
ffffffffc0204c64:	c394                	sw	a3,0(a5)
ffffffffc0204c66:	db98                	sw	a4,48(a5)
ffffffffc0204c68:	b751                	j	ffffffffc0204bec <file_open+0x4a>
ffffffffc0204c6a:	6522                	ld	a0,8(sp)
ffffffffc0204c6c:	678030ef          	jal	ra,ffffffffc02082e4 <vfs_close>
ffffffffc0204c70:	6502                	ld	a0,0(sp)
ffffffffc0204c72:	cb7ff0ef          	jal	ra,ffffffffc0204928 <fd_array_free>
ffffffffc0204c76:	bf9d                	j	ffffffffc0204bec <file_open+0x4a>
ffffffffc0204c78:	5475                	li	s0,-3
ffffffffc0204c7a:	bf8d                	j	ffffffffc0204bec <file_open+0x4a>
ffffffffc0204c7c:	d93ff0ef          	jal	ra,ffffffffc0204a0e <fd_array_open.part.0>
ffffffffc0204c80:	00008697          	auipc	a3,0x8
ffffffffc0204c84:	6c868693          	addi	a3,a3,1736 # ffffffffc020d348 <default_pmm_manager+0xcf0>
ffffffffc0204c88:	00007617          	auipc	a2,0x7
ffffffffc0204c8c:	ef060613          	addi	a2,a2,-272 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204c90:	0b500593          	li	a1,181
ffffffffc0204c94:	00008517          	auipc	a0,0x8
ffffffffc0204c98:	57c50513          	addi	a0,a0,1404 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204c9c:	803fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ca0 <file_close>:
ffffffffc0204ca0:	04700713          	li	a4,71
ffffffffc0204ca4:	04a76563          	bltu	a4,a0,ffffffffc0204cee <file_close+0x4e>
ffffffffc0204ca8:	00092717          	auipc	a4,0x92
ffffffffc0204cac:	c1873703          	ld	a4,-1000(a4) # ffffffffc02968c0 <current>
ffffffffc0204cb0:	14873703          	ld	a4,328(a4)
ffffffffc0204cb4:	1141                	addi	sp,sp,-16
ffffffffc0204cb6:	e406                	sd	ra,8(sp)
ffffffffc0204cb8:	cf0d                	beqz	a4,ffffffffc0204cf2 <file_close+0x52>
ffffffffc0204cba:	4b14                	lw	a3,16(a4)
ffffffffc0204cbc:	02d05b63          	blez	a3,ffffffffc0204cf2 <file_close+0x52>
ffffffffc0204cc0:	6718                	ld	a4,8(a4)
ffffffffc0204cc2:	87aa                	mv	a5,a0
ffffffffc0204cc4:	050e                	slli	a0,a0,0x3
ffffffffc0204cc6:	8d1d                	sub	a0,a0,a5
ffffffffc0204cc8:	050e                	slli	a0,a0,0x3
ffffffffc0204cca:	953a                	add	a0,a0,a4
ffffffffc0204ccc:	4114                	lw	a3,0(a0)
ffffffffc0204cce:	4709                	li	a4,2
ffffffffc0204cd0:	00e69b63          	bne	a3,a4,ffffffffc0204ce6 <file_close+0x46>
ffffffffc0204cd4:	4d18                	lw	a4,24(a0)
ffffffffc0204cd6:	00f71863          	bne	a4,a5,ffffffffc0204ce6 <file_close+0x46>
ffffffffc0204cda:	d75ff0ef          	jal	ra,ffffffffc0204a4e <fd_array_close>
ffffffffc0204cde:	60a2                	ld	ra,8(sp)
ffffffffc0204ce0:	4501                	li	a0,0
ffffffffc0204ce2:	0141                	addi	sp,sp,16
ffffffffc0204ce4:	8082                	ret
ffffffffc0204ce6:	60a2                	ld	ra,8(sp)
ffffffffc0204ce8:	5575                	li	a0,-3
ffffffffc0204cea:	0141                	addi	sp,sp,16
ffffffffc0204cec:	8082                	ret
ffffffffc0204cee:	5575                	li	a0,-3
ffffffffc0204cf0:	8082                	ret
ffffffffc0204cf2:	b81ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc0204cf6 <file_read>:
ffffffffc0204cf6:	715d                	addi	sp,sp,-80
ffffffffc0204cf8:	e486                	sd	ra,72(sp)
ffffffffc0204cfa:	e0a2                	sd	s0,64(sp)
ffffffffc0204cfc:	fc26                	sd	s1,56(sp)
ffffffffc0204cfe:	f84a                	sd	s2,48(sp)
ffffffffc0204d00:	f44e                	sd	s3,40(sp)
ffffffffc0204d02:	f052                	sd	s4,32(sp)
ffffffffc0204d04:	0006b023          	sd	zero,0(a3)
ffffffffc0204d08:	04700793          	li	a5,71
ffffffffc0204d0c:	0aa7e463          	bltu	a5,a0,ffffffffc0204db4 <file_read+0xbe>
ffffffffc0204d10:	00092797          	auipc	a5,0x92
ffffffffc0204d14:	bb07b783          	ld	a5,-1104(a5) # ffffffffc02968c0 <current>
ffffffffc0204d18:	1487b783          	ld	a5,328(a5)
ffffffffc0204d1c:	cfd1                	beqz	a5,ffffffffc0204db8 <file_read+0xc2>
ffffffffc0204d1e:	4b98                	lw	a4,16(a5)
ffffffffc0204d20:	08e05c63          	blez	a4,ffffffffc0204db8 <file_read+0xc2>
ffffffffc0204d24:	6780                	ld	s0,8(a5)
ffffffffc0204d26:	00351793          	slli	a5,a0,0x3
ffffffffc0204d2a:	8f89                	sub	a5,a5,a0
ffffffffc0204d2c:	078e                	slli	a5,a5,0x3
ffffffffc0204d2e:	943e                	add	s0,s0,a5
ffffffffc0204d30:	00042983          	lw	s3,0(s0)
ffffffffc0204d34:	4789                	li	a5,2
ffffffffc0204d36:	06f99f63          	bne	s3,a5,ffffffffc0204db4 <file_read+0xbe>
ffffffffc0204d3a:	4c1c                	lw	a5,24(s0)
ffffffffc0204d3c:	06a79c63          	bne	a5,a0,ffffffffc0204db4 <file_read+0xbe>
ffffffffc0204d40:	641c                	ld	a5,8(s0)
ffffffffc0204d42:	cbad                	beqz	a5,ffffffffc0204db4 <file_read+0xbe>
ffffffffc0204d44:	581c                	lw	a5,48(s0)
ffffffffc0204d46:	8a36                	mv	s4,a3
ffffffffc0204d48:	7014                	ld	a3,32(s0)
ffffffffc0204d4a:	2785                	addiw	a5,a5,1
ffffffffc0204d4c:	850a                	mv	a0,sp
ffffffffc0204d4e:	d81c                	sw	a5,48(s0)
ffffffffc0204d50:	792000ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc0204d54:	02843903          	ld	s2,40(s0)
ffffffffc0204d58:	84aa                	mv	s1,a0
ffffffffc0204d5a:	06090163          	beqz	s2,ffffffffc0204dbc <file_read+0xc6>
ffffffffc0204d5e:	07093783          	ld	a5,112(s2)
ffffffffc0204d62:	cfa9                	beqz	a5,ffffffffc0204dbc <file_read+0xc6>
ffffffffc0204d64:	6f9c                	ld	a5,24(a5)
ffffffffc0204d66:	cbb9                	beqz	a5,ffffffffc0204dbc <file_read+0xc6>
ffffffffc0204d68:	00008597          	auipc	a1,0x8
ffffffffc0204d6c:	68858593          	addi	a1,a1,1672 # ffffffffc020d3f0 <default_pmm_manager+0xd98>
ffffffffc0204d70:	854a                	mv	a0,s2
ffffffffc0204d72:	4e9020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0204d76:	07093783          	ld	a5,112(s2)
ffffffffc0204d7a:	7408                	ld	a0,40(s0)
ffffffffc0204d7c:	85a6                	mv	a1,s1
ffffffffc0204d7e:	6f9c                	ld	a5,24(a5)
ffffffffc0204d80:	9782                	jalr	a5
ffffffffc0204d82:	689c                	ld	a5,16(s1)
ffffffffc0204d84:	6c94                	ld	a3,24(s1)
ffffffffc0204d86:	4018                	lw	a4,0(s0)
ffffffffc0204d88:	84aa                	mv	s1,a0
ffffffffc0204d8a:	8f95                	sub	a5,a5,a3
ffffffffc0204d8c:	03370063          	beq	a4,s3,ffffffffc0204dac <file_read+0xb6>
ffffffffc0204d90:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204d94:	8522                	mv	a0,s0
ffffffffc0204d96:	c0fff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc0204d9a:	60a6                	ld	ra,72(sp)
ffffffffc0204d9c:	6406                	ld	s0,64(sp)
ffffffffc0204d9e:	7942                	ld	s2,48(sp)
ffffffffc0204da0:	79a2                	ld	s3,40(sp)
ffffffffc0204da2:	7a02                	ld	s4,32(sp)
ffffffffc0204da4:	8526                	mv	a0,s1
ffffffffc0204da6:	74e2                	ld	s1,56(sp)
ffffffffc0204da8:	6161                	addi	sp,sp,80
ffffffffc0204daa:	8082                	ret
ffffffffc0204dac:	7018                	ld	a4,32(s0)
ffffffffc0204dae:	973e                	add	a4,a4,a5
ffffffffc0204db0:	f018                	sd	a4,32(s0)
ffffffffc0204db2:	bff9                	j	ffffffffc0204d90 <file_read+0x9a>
ffffffffc0204db4:	54f5                	li	s1,-3
ffffffffc0204db6:	b7d5                	j	ffffffffc0204d9a <file_read+0xa4>
ffffffffc0204db8:	abbff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>
ffffffffc0204dbc:	00008697          	auipc	a3,0x8
ffffffffc0204dc0:	5e468693          	addi	a3,a3,1508 # ffffffffc020d3a0 <default_pmm_manager+0xd48>
ffffffffc0204dc4:	00007617          	auipc	a2,0x7
ffffffffc0204dc8:	db460613          	addi	a2,a2,-588 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204dcc:	0de00593          	li	a1,222
ffffffffc0204dd0:	00008517          	auipc	a0,0x8
ffffffffc0204dd4:	44050513          	addi	a0,a0,1088 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204dd8:	ec6fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ddc <file_write>:
ffffffffc0204ddc:	715d                	addi	sp,sp,-80
ffffffffc0204dde:	e486                	sd	ra,72(sp)
ffffffffc0204de0:	e0a2                	sd	s0,64(sp)
ffffffffc0204de2:	fc26                	sd	s1,56(sp)
ffffffffc0204de4:	f84a                	sd	s2,48(sp)
ffffffffc0204de6:	f44e                	sd	s3,40(sp)
ffffffffc0204de8:	f052                	sd	s4,32(sp)
ffffffffc0204dea:	0006b023          	sd	zero,0(a3)
ffffffffc0204dee:	04700793          	li	a5,71
ffffffffc0204df2:	0aa7e463          	bltu	a5,a0,ffffffffc0204e9a <file_write+0xbe>
ffffffffc0204df6:	00092797          	auipc	a5,0x92
ffffffffc0204dfa:	aca7b783          	ld	a5,-1334(a5) # ffffffffc02968c0 <current>
ffffffffc0204dfe:	1487b783          	ld	a5,328(a5)
ffffffffc0204e02:	cfd1                	beqz	a5,ffffffffc0204e9e <file_write+0xc2>
ffffffffc0204e04:	4b98                	lw	a4,16(a5)
ffffffffc0204e06:	08e05c63          	blez	a4,ffffffffc0204e9e <file_write+0xc2>
ffffffffc0204e0a:	6780                	ld	s0,8(a5)
ffffffffc0204e0c:	00351793          	slli	a5,a0,0x3
ffffffffc0204e10:	8f89                	sub	a5,a5,a0
ffffffffc0204e12:	078e                	slli	a5,a5,0x3
ffffffffc0204e14:	943e                	add	s0,s0,a5
ffffffffc0204e16:	00042983          	lw	s3,0(s0)
ffffffffc0204e1a:	4789                	li	a5,2
ffffffffc0204e1c:	06f99f63          	bne	s3,a5,ffffffffc0204e9a <file_write+0xbe>
ffffffffc0204e20:	4c1c                	lw	a5,24(s0)
ffffffffc0204e22:	06a79c63          	bne	a5,a0,ffffffffc0204e9a <file_write+0xbe>
ffffffffc0204e26:	681c                	ld	a5,16(s0)
ffffffffc0204e28:	cbad                	beqz	a5,ffffffffc0204e9a <file_write+0xbe>
ffffffffc0204e2a:	581c                	lw	a5,48(s0)
ffffffffc0204e2c:	8a36                	mv	s4,a3
ffffffffc0204e2e:	7014                	ld	a3,32(s0)
ffffffffc0204e30:	2785                	addiw	a5,a5,1
ffffffffc0204e32:	850a                	mv	a0,sp
ffffffffc0204e34:	d81c                	sw	a5,48(s0)
ffffffffc0204e36:	6ac000ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc0204e3a:	02843903          	ld	s2,40(s0)
ffffffffc0204e3e:	84aa                	mv	s1,a0
ffffffffc0204e40:	06090163          	beqz	s2,ffffffffc0204ea2 <file_write+0xc6>
ffffffffc0204e44:	07093783          	ld	a5,112(s2)
ffffffffc0204e48:	cfa9                	beqz	a5,ffffffffc0204ea2 <file_write+0xc6>
ffffffffc0204e4a:	739c                	ld	a5,32(a5)
ffffffffc0204e4c:	cbb9                	beqz	a5,ffffffffc0204ea2 <file_write+0xc6>
ffffffffc0204e4e:	00008597          	auipc	a1,0x8
ffffffffc0204e52:	5fa58593          	addi	a1,a1,1530 # ffffffffc020d448 <default_pmm_manager+0xdf0>
ffffffffc0204e56:	854a                	mv	a0,s2
ffffffffc0204e58:	403020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0204e5c:	07093783          	ld	a5,112(s2)
ffffffffc0204e60:	7408                	ld	a0,40(s0)
ffffffffc0204e62:	85a6                	mv	a1,s1
ffffffffc0204e64:	739c                	ld	a5,32(a5)
ffffffffc0204e66:	9782                	jalr	a5
ffffffffc0204e68:	689c                	ld	a5,16(s1)
ffffffffc0204e6a:	6c94                	ld	a3,24(s1)
ffffffffc0204e6c:	4018                	lw	a4,0(s0)
ffffffffc0204e6e:	84aa                	mv	s1,a0
ffffffffc0204e70:	8f95                	sub	a5,a5,a3
ffffffffc0204e72:	03370063          	beq	a4,s3,ffffffffc0204e92 <file_write+0xb6>
ffffffffc0204e76:	00fa3023          	sd	a5,0(s4)
ffffffffc0204e7a:	8522                	mv	a0,s0
ffffffffc0204e7c:	b29ff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc0204e80:	60a6                	ld	ra,72(sp)
ffffffffc0204e82:	6406                	ld	s0,64(sp)
ffffffffc0204e84:	7942                	ld	s2,48(sp)
ffffffffc0204e86:	79a2                	ld	s3,40(sp)
ffffffffc0204e88:	7a02                	ld	s4,32(sp)
ffffffffc0204e8a:	8526                	mv	a0,s1
ffffffffc0204e8c:	74e2                	ld	s1,56(sp)
ffffffffc0204e8e:	6161                	addi	sp,sp,80
ffffffffc0204e90:	8082                	ret
ffffffffc0204e92:	7018                	ld	a4,32(s0)
ffffffffc0204e94:	973e                	add	a4,a4,a5
ffffffffc0204e96:	f018                	sd	a4,32(s0)
ffffffffc0204e98:	bff9                	j	ffffffffc0204e76 <file_write+0x9a>
ffffffffc0204e9a:	54f5                	li	s1,-3
ffffffffc0204e9c:	b7d5                	j	ffffffffc0204e80 <file_write+0xa4>
ffffffffc0204e9e:	9d5ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>
ffffffffc0204ea2:	00008697          	auipc	a3,0x8
ffffffffc0204ea6:	55668693          	addi	a3,a3,1366 # ffffffffc020d3f8 <default_pmm_manager+0xda0>
ffffffffc0204eaa:	00007617          	auipc	a2,0x7
ffffffffc0204eae:	cce60613          	addi	a2,a2,-818 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204eb2:	0f800593          	li	a1,248
ffffffffc0204eb6:	00008517          	auipc	a0,0x8
ffffffffc0204eba:	35a50513          	addi	a0,a0,858 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204ebe:	de0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ec2 <file_seek>:
ffffffffc0204ec2:	7139                	addi	sp,sp,-64
ffffffffc0204ec4:	fc06                	sd	ra,56(sp)
ffffffffc0204ec6:	f822                	sd	s0,48(sp)
ffffffffc0204ec8:	f426                	sd	s1,40(sp)
ffffffffc0204eca:	f04a                	sd	s2,32(sp)
ffffffffc0204ecc:	04700793          	li	a5,71
ffffffffc0204ed0:	08a7e863          	bltu	a5,a0,ffffffffc0204f60 <file_seek+0x9e>
ffffffffc0204ed4:	00092797          	auipc	a5,0x92
ffffffffc0204ed8:	9ec7b783          	ld	a5,-1556(a5) # ffffffffc02968c0 <current>
ffffffffc0204edc:	1487b783          	ld	a5,328(a5)
ffffffffc0204ee0:	cfdd                	beqz	a5,ffffffffc0204f9e <file_seek+0xdc>
ffffffffc0204ee2:	4b98                	lw	a4,16(a5)
ffffffffc0204ee4:	0ae05d63          	blez	a4,ffffffffc0204f9e <file_seek+0xdc>
ffffffffc0204ee8:	6780                	ld	s0,8(a5)
ffffffffc0204eea:	00351793          	slli	a5,a0,0x3
ffffffffc0204eee:	8f89                	sub	a5,a5,a0
ffffffffc0204ef0:	078e                	slli	a5,a5,0x3
ffffffffc0204ef2:	943e                	add	s0,s0,a5
ffffffffc0204ef4:	4018                	lw	a4,0(s0)
ffffffffc0204ef6:	4789                	li	a5,2
ffffffffc0204ef8:	06f71463          	bne	a4,a5,ffffffffc0204f60 <file_seek+0x9e>
ffffffffc0204efc:	4c1c                	lw	a5,24(s0)
ffffffffc0204efe:	06a79163          	bne	a5,a0,ffffffffc0204f60 <file_seek+0x9e>
ffffffffc0204f02:	581c                	lw	a5,48(s0)
ffffffffc0204f04:	4685                	li	a3,1
ffffffffc0204f06:	892e                	mv	s2,a1
ffffffffc0204f08:	2785                	addiw	a5,a5,1
ffffffffc0204f0a:	d81c                	sw	a5,48(s0)
ffffffffc0204f0c:	02d60063          	beq	a2,a3,ffffffffc0204f2c <file_seek+0x6a>
ffffffffc0204f10:	06e60063          	beq	a2,a4,ffffffffc0204f70 <file_seek+0xae>
ffffffffc0204f14:	54f5                	li	s1,-3
ffffffffc0204f16:	ce11                	beqz	a2,ffffffffc0204f32 <file_seek+0x70>
ffffffffc0204f18:	8522                	mv	a0,s0
ffffffffc0204f1a:	a8bff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc0204f1e:	70e2                	ld	ra,56(sp)
ffffffffc0204f20:	7442                	ld	s0,48(sp)
ffffffffc0204f22:	7902                	ld	s2,32(sp)
ffffffffc0204f24:	8526                	mv	a0,s1
ffffffffc0204f26:	74a2                	ld	s1,40(sp)
ffffffffc0204f28:	6121                	addi	sp,sp,64
ffffffffc0204f2a:	8082                	ret
ffffffffc0204f2c:	701c                	ld	a5,32(s0)
ffffffffc0204f2e:	00f58933          	add	s2,a1,a5
ffffffffc0204f32:	7404                	ld	s1,40(s0)
ffffffffc0204f34:	c4bd                	beqz	s1,ffffffffc0204fa2 <file_seek+0xe0>
ffffffffc0204f36:	78bc                	ld	a5,112(s1)
ffffffffc0204f38:	c7ad                	beqz	a5,ffffffffc0204fa2 <file_seek+0xe0>
ffffffffc0204f3a:	6fbc                	ld	a5,88(a5)
ffffffffc0204f3c:	c3bd                	beqz	a5,ffffffffc0204fa2 <file_seek+0xe0>
ffffffffc0204f3e:	8526                	mv	a0,s1
ffffffffc0204f40:	00008597          	auipc	a1,0x8
ffffffffc0204f44:	56058593          	addi	a1,a1,1376 # ffffffffc020d4a0 <default_pmm_manager+0xe48>
ffffffffc0204f48:	313020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0204f4c:	78bc                	ld	a5,112(s1)
ffffffffc0204f4e:	7408                	ld	a0,40(s0)
ffffffffc0204f50:	85ca                	mv	a1,s2
ffffffffc0204f52:	6fbc                	ld	a5,88(a5)
ffffffffc0204f54:	9782                	jalr	a5
ffffffffc0204f56:	84aa                	mv	s1,a0
ffffffffc0204f58:	f161                	bnez	a0,ffffffffc0204f18 <file_seek+0x56>
ffffffffc0204f5a:	03243023          	sd	s2,32(s0)
ffffffffc0204f5e:	bf6d                	j	ffffffffc0204f18 <file_seek+0x56>
ffffffffc0204f60:	70e2                	ld	ra,56(sp)
ffffffffc0204f62:	7442                	ld	s0,48(sp)
ffffffffc0204f64:	54f5                	li	s1,-3
ffffffffc0204f66:	7902                	ld	s2,32(sp)
ffffffffc0204f68:	8526                	mv	a0,s1
ffffffffc0204f6a:	74a2                	ld	s1,40(sp)
ffffffffc0204f6c:	6121                	addi	sp,sp,64
ffffffffc0204f6e:	8082                	ret
ffffffffc0204f70:	7404                	ld	s1,40(s0)
ffffffffc0204f72:	c8a1                	beqz	s1,ffffffffc0204fc2 <file_seek+0x100>
ffffffffc0204f74:	78bc                	ld	a5,112(s1)
ffffffffc0204f76:	c7b1                	beqz	a5,ffffffffc0204fc2 <file_seek+0x100>
ffffffffc0204f78:	779c                	ld	a5,40(a5)
ffffffffc0204f7a:	c7a1                	beqz	a5,ffffffffc0204fc2 <file_seek+0x100>
ffffffffc0204f7c:	8526                	mv	a0,s1
ffffffffc0204f7e:	00008597          	auipc	a1,0x8
ffffffffc0204f82:	41a58593          	addi	a1,a1,1050 # ffffffffc020d398 <default_pmm_manager+0xd40>
ffffffffc0204f86:	2d5020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0204f8a:	78bc                	ld	a5,112(s1)
ffffffffc0204f8c:	7408                	ld	a0,40(s0)
ffffffffc0204f8e:	858a                	mv	a1,sp
ffffffffc0204f90:	779c                	ld	a5,40(a5)
ffffffffc0204f92:	9782                	jalr	a5
ffffffffc0204f94:	84aa                	mv	s1,a0
ffffffffc0204f96:	f149                	bnez	a0,ffffffffc0204f18 <file_seek+0x56>
ffffffffc0204f98:	67e2                	ld	a5,24(sp)
ffffffffc0204f9a:	993e                	add	s2,s2,a5
ffffffffc0204f9c:	bf59                	j	ffffffffc0204f32 <file_seek+0x70>
ffffffffc0204f9e:	8d5ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>
ffffffffc0204fa2:	00008697          	auipc	a3,0x8
ffffffffc0204fa6:	4ae68693          	addi	a3,a3,1198 # ffffffffc020d450 <default_pmm_manager+0xdf8>
ffffffffc0204faa:	00007617          	auipc	a2,0x7
ffffffffc0204fae:	bce60613          	addi	a2,a2,-1074 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204fb2:	11a00593          	li	a1,282
ffffffffc0204fb6:	00008517          	auipc	a0,0x8
ffffffffc0204fba:	25a50513          	addi	a0,a0,602 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204fbe:	ce0fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204fc2:	00008697          	auipc	a3,0x8
ffffffffc0204fc6:	38668693          	addi	a3,a3,902 # ffffffffc020d348 <default_pmm_manager+0xcf0>
ffffffffc0204fca:	00007617          	auipc	a2,0x7
ffffffffc0204fce:	bae60613          	addi	a2,a2,-1106 # ffffffffc020bb78 <commands+0x210>
ffffffffc0204fd2:	11200593          	li	a1,274
ffffffffc0204fd6:	00008517          	auipc	a0,0x8
ffffffffc0204fda:	23a50513          	addi	a0,a0,570 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0204fde:	cc0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204fe2 <file_fstat>:
ffffffffc0204fe2:	1101                	addi	sp,sp,-32
ffffffffc0204fe4:	ec06                	sd	ra,24(sp)
ffffffffc0204fe6:	e822                	sd	s0,16(sp)
ffffffffc0204fe8:	e426                	sd	s1,8(sp)
ffffffffc0204fea:	e04a                	sd	s2,0(sp)
ffffffffc0204fec:	04700793          	li	a5,71
ffffffffc0204ff0:	06a7ef63          	bltu	a5,a0,ffffffffc020506e <file_fstat+0x8c>
ffffffffc0204ff4:	00092797          	auipc	a5,0x92
ffffffffc0204ff8:	8cc7b783          	ld	a5,-1844(a5) # ffffffffc02968c0 <current>
ffffffffc0204ffc:	1487b783          	ld	a5,328(a5)
ffffffffc0205000:	cfd9                	beqz	a5,ffffffffc020509e <file_fstat+0xbc>
ffffffffc0205002:	4b98                	lw	a4,16(a5)
ffffffffc0205004:	08e05d63          	blez	a4,ffffffffc020509e <file_fstat+0xbc>
ffffffffc0205008:	6780                	ld	s0,8(a5)
ffffffffc020500a:	00351793          	slli	a5,a0,0x3
ffffffffc020500e:	8f89                	sub	a5,a5,a0
ffffffffc0205010:	078e                	slli	a5,a5,0x3
ffffffffc0205012:	943e                	add	s0,s0,a5
ffffffffc0205014:	4018                	lw	a4,0(s0)
ffffffffc0205016:	4789                	li	a5,2
ffffffffc0205018:	04f71b63          	bne	a4,a5,ffffffffc020506e <file_fstat+0x8c>
ffffffffc020501c:	4c1c                	lw	a5,24(s0)
ffffffffc020501e:	04a79863          	bne	a5,a0,ffffffffc020506e <file_fstat+0x8c>
ffffffffc0205022:	581c                	lw	a5,48(s0)
ffffffffc0205024:	02843903          	ld	s2,40(s0)
ffffffffc0205028:	2785                	addiw	a5,a5,1
ffffffffc020502a:	d81c                	sw	a5,48(s0)
ffffffffc020502c:	04090963          	beqz	s2,ffffffffc020507e <file_fstat+0x9c>
ffffffffc0205030:	07093783          	ld	a5,112(s2)
ffffffffc0205034:	c7a9                	beqz	a5,ffffffffc020507e <file_fstat+0x9c>
ffffffffc0205036:	779c                	ld	a5,40(a5)
ffffffffc0205038:	c3b9                	beqz	a5,ffffffffc020507e <file_fstat+0x9c>
ffffffffc020503a:	84ae                	mv	s1,a1
ffffffffc020503c:	854a                	mv	a0,s2
ffffffffc020503e:	00008597          	auipc	a1,0x8
ffffffffc0205042:	35a58593          	addi	a1,a1,858 # ffffffffc020d398 <default_pmm_manager+0xd40>
ffffffffc0205046:	215020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc020504a:	07093783          	ld	a5,112(s2)
ffffffffc020504e:	7408                	ld	a0,40(s0)
ffffffffc0205050:	85a6                	mv	a1,s1
ffffffffc0205052:	779c                	ld	a5,40(a5)
ffffffffc0205054:	9782                	jalr	a5
ffffffffc0205056:	87aa                	mv	a5,a0
ffffffffc0205058:	8522                	mv	a0,s0
ffffffffc020505a:	843e                	mv	s0,a5
ffffffffc020505c:	949ff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc0205060:	60e2                	ld	ra,24(sp)
ffffffffc0205062:	8522                	mv	a0,s0
ffffffffc0205064:	6442                	ld	s0,16(sp)
ffffffffc0205066:	64a2                	ld	s1,8(sp)
ffffffffc0205068:	6902                	ld	s2,0(sp)
ffffffffc020506a:	6105                	addi	sp,sp,32
ffffffffc020506c:	8082                	ret
ffffffffc020506e:	5475                	li	s0,-3
ffffffffc0205070:	60e2                	ld	ra,24(sp)
ffffffffc0205072:	8522                	mv	a0,s0
ffffffffc0205074:	6442                	ld	s0,16(sp)
ffffffffc0205076:	64a2                	ld	s1,8(sp)
ffffffffc0205078:	6902                	ld	s2,0(sp)
ffffffffc020507a:	6105                	addi	sp,sp,32
ffffffffc020507c:	8082                	ret
ffffffffc020507e:	00008697          	auipc	a3,0x8
ffffffffc0205082:	2ca68693          	addi	a3,a3,714 # ffffffffc020d348 <default_pmm_manager+0xcf0>
ffffffffc0205086:	00007617          	auipc	a2,0x7
ffffffffc020508a:	af260613          	addi	a2,a2,-1294 # ffffffffc020bb78 <commands+0x210>
ffffffffc020508e:	12c00593          	li	a1,300
ffffffffc0205092:	00008517          	auipc	a0,0x8
ffffffffc0205096:	17e50513          	addi	a0,a0,382 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc020509a:	c04fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020509e:	fd4ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc02050a2 <file_fsync>:
ffffffffc02050a2:	1101                	addi	sp,sp,-32
ffffffffc02050a4:	ec06                	sd	ra,24(sp)
ffffffffc02050a6:	e822                	sd	s0,16(sp)
ffffffffc02050a8:	e426                	sd	s1,8(sp)
ffffffffc02050aa:	04700793          	li	a5,71
ffffffffc02050ae:	06a7e863          	bltu	a5,a0,ffffffffc020511e <file_fsync+0x7c>
ffffffffc02050b2:	00092797          	auipc	a5,0x92
ffffffffc02050b6:	80e7b783          	ld	a5,-2034(a5) # ffffffffc02968c0 <current>
ffffffffc02050ba:	1487b783          	ld	a5,328(a5)
ffffffffc02050be:	c7d9                	beqz	a5,ffffffffc020514c <file_fsync+0xaa>
ffffffffc02050c0:	4b98                	lw	a4,16(a5)
ffffffffc02050c2:	08e05563          	blez	a4,ffffffffc020514c <file_fsync+0xaa>
ffffffffc02050c6:	6780                	ld	s0,8(a5)
ffffffffc02050c8:	00351793          	slli	a5,a0,0x3
ffffffffc02050cc:	8f89                	sub	a5,a5,a0
ffffffffc02050ce:	078e                	slli	a5,a5,0x3
ffffffffc02050d0:	943e                	add	s0,s0,a5
ffffffffc02050d2:	4018                	lw	a4,0(s0)
ffffffffc02050d4:	4789                	li	a5,2
ffffffffc02050d6:	04f71463          	bne	a4,a5,ffffffffc020511e <file_fsync+0x7c>
ffffffffc02050da:	4c1c                	lw	a5,24(s0)
ffffffffc02050dc:	04a79163          	bne	a5,a0,ffffffffc020511e <file_fsync+0x7c>
ffffffffc02050e0:	581c                	lw	a5,48(s0)
ffffffffc02050e2:	7404                	ld	s1,40(s0)
ffffffffc02050e4:	2785                	addiw	a5,a5,1
ffffffffc02050e6:	d81c                	sw	a5,48(s0)
ffffffffc02050e8:	c0b1                	beqz	s1,ffffffffc020512c <file_fsync+0x8a>
ffffffffc02050ea:	78bc                	ld	a5,112(s1)
ffffffffc02050ec:	c3a1                	beqz	a5,ffffffffc020512c <file_fsync+0x8a>
ffffffffc02050ee:	7b9c                	ld	a5,48(a5)
ffffffffc02050f0:	cf95                	beqz	a5,ffffffffc020512c <file_fsync+0x8a>
ffffffffc02050f2:	00008597          	auipc	a1,0x8
ffffffffc02050f6:	40658593          	addi	a1,a1,1030 # ffffffffc020d4f8 <default_pmm_manager+0xea0>
ffffffffc02050fa:	8526                	mv	a0,s1
ffffffffc02050fc:	15f020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0205100:	78bc                	ld	a5,112(s1)
ffffffffc0205102:	7408                	ld	a0,40(s0)
ffffffffc0205104:	7b9c                	ld	a5,48(a5)
ffffffffc0205106:	9782                	jalr	a5
ffffffffc0205108:	87aa                	mv	a5,a0
ffffffffc020510a:	8522                	mv	a0,s0
ffffffffc020510c:	843e                	mv	s0,a5
ffffffffc020510e:	897ff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc0205112:	60e2                	ld	ra,24(sp)
ffffffffc0205114:	8522                	mv	a0,s0
ffffffffc0205116:	6442                	ld	s0,16(sp)
ffffffffc0205118:	64a2                	ld	s1,8(sp)
ffffffffc020511a:	6105                	addi	sp,sp,32
ffffffffc020511c:	8082                	ret
ffffffffc020511e:	5475                	li	s0,-3
ffffffffc0205120:	60e2                	ld	ra,24(sp)
ffffffffc0205122:	8522                	mv	a0,s0
ffffffffc0205124:	6442                	ld	s0,16(sp)
ffffffffc0205126:	64a2                	ld	s1,8(sp)
ffffffffc0205128:	6105                	addi	sp,sp,32
ffffffffc020512a:	8082                	ret
ffffffffc020512c:	00008697          	auipc	a3,0x8
ffffffffc0205130:	37c68693          	addi	a3,a3,892 # ffffffffc020d4a8 <default_pmm_manager+0xe50>
ffffffffc0205134:	00007617          	auipc	a2,0x7
ffffffffc0205138:	a4460613          	addi	a2,a2,-1468 # ffffffffc020bb78 <commands+0x210>
ffffffffc020513c:	13a00593          	li	a1,314
ffffffffc0205140:	00008517          	auipc	a0,0x8
ffffffffc0205144:	0d050513          	addi	a0,a0,208 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc0205148:	b56fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020514c:	f26ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc0205150 <file_getdirentry>:
ffffffffc0205150:	715d                	addi	sp,sp,-80
ffffffffc0205152:	e486                	sd	ra,72(sp)
ffffffffc0205154:	e0a2                	sd	s0,64(sp)
ffffffffc0205156:	fc26                	sd	s1,56(sp)
ffffffffc0205158:	f84a                	sd	s2,48(sp)
ffffffffc020515a:	f44e                	sd	s3,40(sp)
ffffffffc020515c:	04700793          	li	a5,71
ffffffffc0205160:	0aa7e063          	bltu	a5,a0,ffffffffc0205200 <file_getdirentry+0xb0>
ffffffffc0205164:	00091797          	auipc	a5,0x91
ffffffffc0205168:	75c7b783          	ld	a5,1884(a5) # ffffffffc02968c0 <current>
ffffffffc020516c:	1487b783          	ld	a5,328(a5)
ffffffffc0205170:	c3e9                	beqz	a5,ffffffffc0205232 <file_getdirentry+0xe2>
ffffffffc0205172:	4b98                	lw	a4,16(a5)
ffffffffc0205174:	0ae05f63          	blez	a4,ffffffffc0205232 <file_getdirentry+0xe2>
ffffffffc0205178:	6780                	ld	s0,8(a5)
ffffffffc020517a:	00351793          	slli	a5,a0,0x3
ffffffffc020517e:	8f89                	sub	a5,a5,a0
ffffffffc0205180:	078e                	slli	a5,a5,0x3
ffffffffc0205182:	943e                	add	s0,s0,a5
ffffffffc0205184:	4018                	lw	a4,0(s0)
ffffffffc0205186:	4789                	li	a5,2
ffffffffc0205188:	06f71c63          	bne	a4,a5,ffffffffc0205200 <file_getdirentry+0xb0>
ffffffffc020518c:	4c1c                	lw	a5,24(s0)
ffffffffc020518e:	06a79963          	bne	a5,a0,ffffffffc0205200 <file_getdirentry+0xb0>
ffffffffc0205192:	581c                	lw	a5,48(s0)
ffffffffc0205194:	6194                	ld	a3,0(a1)
ffffffffc0205196:	84ae                	mv	s1,a1
ffffffffc0205198:	2785                	addiw	a5,a5,1
ffffffffc020519a:	10000613          	li	a2,256
ffffffffc020519e:	d81c                	sw	a5,48(s0)
ffffffffc02051a0:	05a1                	addi	a1,a1,8
ffffffffc02051a2:	850a                	mv	a0,sp
ffffffffc02051a4:	33e000ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc02051a8:	02843983          	ld	s3,40(s0)
ffffffffc02051ac:	892a                	mv	s2,a0
ffffffffc02051ae:	06098263          	beqz	s3,ffffffffc0205212 <file_getdirentry+0xc2>
ffffffffc02051b2:	0709b783          	ld	a5,112(s3) # 1070 <_binary_bin_swap_img_size-0x6c90>
ffffffffc02051b6:	cfb1                	beqz	a5,ffffffffc0205212 <file_getdirentry+0xc2>
ffffffffc02051b8:	63bc                	ld	a5,64(a5)
ffffffffc02051ba:	cfa1                	beqz	a5,ffffffffc0205212 <file_getdirentry+0xc2>
ffffffffc02051bc:	854e                	mv	a0,s3
ffffffffc02051be:	00008597          	auipc	a1,0x8
ffffffffc02051c2:	39a58593          	addi	a1,a1,922 # ffffffffc020d558 <default_pmm_manager+0xf00>
ffffffffc02051c6:	095020ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc02051ca:	0709b783          	ld	a5,112(s3)
ffffffffc02051ce:	7408                	ld	a0,40(s0)
ffffffffc02051d0:	85ca                	mv	a1,s2
ffffffffc02051d2:	63bc                	ld	a5,64(a5)
ffffffffc02051d4:	9782                	jalr	a5
ffffffffc02051d6:	89aa                	mv	s3,a0
ffffffffc02051d8:	e909                	bnez	a0,ffffffffc02051ea <file_getdirentry+0x9a>
ffffffffc02051da:	609c                	ld	a5,0(s1)
ffffffffc02051dc:	01093683          	ld	a3,16(s2)
ffffffffc02051e0:	01893703          	ld	a4,24(s2)
ffffffffc02051e4:	97b6                	add	a5,a5,a3
ffffffffc02051e6:	8f99                	sub	a5,a5,a4
ffffffffc02051e8:	e09c                	sd	a5,0(s1)
ffffffffc02051ea:	8522                	mv	a0,s0
ffffffffc02051ec:	fb8ff0ef          	jal	ra,ffffffffc02049a4 <fd_array_release>
ffffffffc02051f0:	60a6                	ld	ra,72(sp)
ffffffffc02051f2:	6406                	ld	s0,64(sp)
ffffffffc02051f4:	74e2                	ld	s1,56(sp)
ffffffffc02051f6:	7942                	ld	s2,48(sp)
ffffffffc02051f8:	854e                	mv	a0,s3
ffffffffc02051fa:	79a2                	ld	s3,40(sp)
ffffffffc02051fc:	6161                	addi	sp,sp,80
ffffffffc02051fe:	8082                	ret
ffffffffc0205200:	60a6                	ld	ra,72(sp)
ffffffffc0205202:	6406                	ld	s0,64(sp)
ffffffffc0205204:	59f5                	li	s3,-3
ffffffffc0205206:	74e2                	ld	s1,56(sp)
ffffffffc0205208:	7942                	ld	s2,48(sp)
ffffffffc020520a:	854e                	mv	a0,s3
ffffffffc020520c:	79a2                	ld	s3,40(sp)
ffffffffc020520e:	6161                	addi	sp,sp,80
ffffffffc0205210:	8082                	ret
ffffffffc0205212:	00008697          	auipc	a3,0x8
ffffffffc0205216:	2ee68693          	addi	a3,a3,750 # ffffffffc020d500 <default_pmm_manager+0xea8>
ffffffffc020521a:	00007617          	auipc	a2,0x7
ffffffffc020521e:	95e60613          	addi	a2,a2,-1698 # ffffffffc020bb78 <commands+0x210>
ffffffffc0205222:	14a00593          	li	a1,330
ffffffffc0205226:	00008517          	auipc	a0,0x8
ffffffffc020522a:	fea50513          	addi	a0,a0,-22 # ffffffffc020d210 <default_pmm_manager+0xbb8>
ffffffffc020522e:	a70fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205232:	e40ff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc0205236 <file_dup>:
ffffffffc0205236:	04700713          	li	a4,71
ffffffffc020523a:	06a76463          	bltu	a4,a0,ffffffffc02052a2 <file_dup+0x6c>
ffffffffc020523e:	00091717          	auipc	a4,0x91
ffffffffc0205242:	68273703          	ld	a4,1666(a4) # ffffffffc02968c0 <current>
ffffffffc0205246:	14873703          	ld	a4,328(a4)
ffffffffc020524a:	1101                	addi	sp,sp,-32
ffffffffc020524c:	ec06                	sd	ra,24(sp)
ffffffffc020524e:	e822                	sd	s0,16(sp)
ffffffffc0205250:	cb39                	beqz	a4,ffffffffc02052a6 <file_dup+0x70>
ffffffffc0205252:	4b14                	lw	a3,16(a4)
ffffffffc0205254:	04d05963          	blez	a3,ffffffffc02052a6 <file_dup+0x70>
ffffffffc0205258:	6700                	ld	s0,8(a4)
ffffffffc020525a:	00351713          	slli	a4,a0,0x3
ffffffffc020525e:	8f09                	sub	a4,a4,a0
ffffffffc0205260:	070e                	slli	a4,a4,0x3
ffffffffc0205262:	943a                	add	s0,s0,a4
ffffffffc0205264:	4014                	lw	a3,0(s0)
ffffffffc0205266:	4709                	li	a4,2
ffffffffc0205268:	02e69863          	bne	a3,a4,ffffffffc0205298 <file_dup+0x62>
ffffffffc020526c:	4c18                	lw	a4,24(s0)
ffffffffc020526e:	02a71563          	bne	a4,a0,ffffffffc0205298 <file_dup+0x62>
ffffffffc0205272:	852e                	mv	a0,a1
ffffffffc0205274:	002c                	addi	a1,sp,8
ffffffffc0205276:	e1eff0ef          	jal	ra,ffffffffc0204894 <fd_array_alloc>
ffffffffc020527a:	c509                	beqz	a0,ffffffffc0205284 <file_dup+0x4e>
ffffffffc020527c:	60e2                	ld	ra,24(sp)
ffffffffc020527e:	6442                	ld	s0,16(sp)
ffffffffc0205280:	6105                	addi	sp,sp,32
ffffffffc0205282:	8082                	ret
ffffffffc0205284:	6522                	ld	a0,8(sp)
ffffffffc0205286:	85a2                	mv	a1,s0
ffffffffc0205288:	845ff0ef          	jal	ra,ffffffffc0204acc <fd_array_dup>
ffffffffc020528c:	67a2                	ld	a5,8(sp)
ffffffffc020528e:	60e2                	ld	ra,24(sp)
ffffffffc0205290:	6442                	ld	s0,16(sp)
ffffffffc0205292:	4f88                	lw	a0,24(a5)
ffffffffc0205294:	6105                	addi	sp,sp,32
ffffffffc0205296:	8082                	ret
ffffffffc0205298:	60e2                	ld	ra,24(sp)
ffffffffc020529a:	6442                	ld	s0,16(sp)
ffffffffc020529c:	5575                	li	a0,-3
ffffffffc020529e:	6105                	addi	sp,sp,32
ffffffffc02052a0:	8082                	ret
ffffffffc02052a2:	5575                	li	a0,-3
ffffffffc02052a4:	8082                	ret
ffffffffc02052a6:	dccff0ef          	jal	ra,ffffffffc0204872 <get_fd_array.part.0>

ffffffffc02052aa <fs_init>:
ffffffffc02052aa:	1141                	addi	sp,sp,-16
ffffffffc02052ac:	e406                	sd	ra,8(sp)
ffffffffc02052ae:	1cb020ef          	jal	ra,ffffffffc0207c78 <vfs_init>
ffffffffc02052b2:	6a2030ef          	jal	ra,ffffffffc0208954 <dev_init>
ffffffffc02052b6:	60a2                	ld	ra,8(sp)
ffffffffc02052b8:	0141                	addi	sp,sp,16
ffffffffc02052ba:	7f30306f          	j	ffffffffc02092ac <sfs_init>

ffffffffc02052be <fs_cleanup>:
ffffffffc02052be:	40d0206f          	j	ffffffffc0207eca <vfs_cleanup>

ffffffffc02052c2 <lock_files>:
ffffffffc02052c2:	0561                	addi	a0,a0,24
ffffffffc02052c4:	ba0ff06f          	j	ffffffffc0204664 <down>

ffffffffc02052c8 <unlock_files>:
ffffffffc02052c8:	0561                	addi	a0,a0,24
ffffffffc02052ca:	b96ff06f          	j	ffffffffc0204660 <up>

ffffffffc02052ce <files_create>:
ffffffffc02052ce:	1141                	addi	sp,sp,-16
ffffffffc02052d0:	6505                	lui	a0,0x1
ffffffffc02052d2:	e022                	sd	s0,0(sp)
ffffffffc02052d4:	e406                	sd	ra,8(sp)
ffffffffc02052d6:	d41fc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02052da:	842a                	mv	s0,a0
ffffffffc02052dc:	cd19                	beqz	a0,ffffffffc02052fa <files_create+0x2c>
ffffffffc02052de:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02052e2:	00043023          	sd	zero,0(s0)
ffffffffc02052e6:	0561                	addi	a0,a0,24
ffffffffc02052e8:	e41c                	sd	a5,8(s0)
ffffffffc02052ea:	00042823          	sw	zero,16(s0)
ffffffffc02052ee:	4585                	li	a1,1
ffffffffc02052f0:	b6aff0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc02052f4:	6408                	ld	a0,8(s0)
ffffffffc02052f6:	f3cff0ef          	jal	ra,ffffffffc0204a32 <fd_array_init>
ffffffffc02052fa:	60a2                	ld	ra,8(sp)
ffffffffc02052fc:	8522                	mv	a0,s0
ffffffffc02052fe:	6402                	ld	s0,0(sp)
ffffffffc0205300:	0141                	addi	sp,sp,16
ffffffffc0205302:	8082                	ret

ffffffffc0205304 <files_destroy>:
ffffffffc0205304:	7179                	addi	sp,sp,-48
ffffffffc0205306:	f406                	sd	ra,40(sp)
ffffffffc0205308:	f022                	sd	s0,32(sp)
ffffffffc020530a:	ec26                	sd	s1,24(sp)
ffffffffc020530c:	e84a                	sd	s2,16(sp)
ffffffffc020530e:	e44e                	sd	s3,8(sp)
ffffffffc0205310:	c52d                	beqz	a0,ffffffffc020537a <files_destroy+0x76>
ffffffffc0205312:	491c                	lw	a5,16(a0)
ffffffffc0205314:	89aa                	mv	s3,a0
ffffffffc0205316:	e3b5                	bnez	a5,ffffffffc020537a <files_destroy+0x76>
ffffffffc0205318:	6108                	ld	a0,0(a0)
ffffffffc020531a:	c119                	beqz	a0,ffffffffc0205320 <files_destroy+0x1c>
ffffffffc020531c:	7f4020ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc0205320:	0089b403          	ld	s0,8(s3)
ffffffffc0205324:	6485                	lui	s1,0x1
ffffffffc0205326:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc020532a:	94a2                	add	s1,s1,s0
ffffffffc020532c:	4909                	li	s2,2
ffffffffc020532e:	401c                	lw	a5,0(s0)
ffffffffc0205330:	03278063          	beq	a5,s2,ffffffffc0205350 <files_destroy+0x4c>
ffffffffc0205334:	e39d                	bnez	a5,ffffffffc020535a <files_destroy+0x56>
ffffffffc0205336:	03840413          	addi	s0,s0,56
ffffffffc020533a:	fe849ae3          	bne	s1,s0,ffffffffc020532e <files_destroy+0x2a>
ffffffffc020533e:	7402                	ld	s0,32(sp)
ffffffffc0205340:	70a2                	ld	ra,40(sp)
ffffffffc0205342:	64e2                	ld	s1,24(sp)
ffffffffc0205344:	6942                	ld	s2,16(sp)
ffffffffc0205346:	854e                	mv	a0,s3
ffffffffc0205348:	69a2                	ld	s3,8(sp)
ffffffffc020534a:	6145                	addi	sp,sp,48
ffffffffc020534c:	d7bfc06f          	j	ffffffffc02020c6 <kfree>
ffffffffc0205350:	8522                	mv	a0,s0
ffffffffc0205352:	efcff0ef          	jal	ra,ffffffffc0204a4e <fd_array_close>
ffffffffc0205356:	401c                	lw	a5,0(s0)
ffffffffc0205358:	bff1                	j	ffffffffc0205334 <files_destroy+0x30>
ffffffffc020535a:	00008697          	auipc	a3,0x8
ffffffffc020535e:	27e68693          	addi	a3,a3,638 # ffffffffc020d5d8 <CSWTCH.79+0x58>
ffffffffc0205362:	00007617          	auipc	a2,0x7
ffffffffc0205366:	81660613          	addi	a2,a2,-2026 # ffffffffc020bb78 <commands+0x210>
ffffffffc020536a:	03d00593          	li	a1,61
ffffffffc020536e:	00008517          	auipc	a0,0x8
ffffffffc0205372:	25a50513          	addi	a0,a0,602 # ffffffffc020d5c8 <CSWTCH.79+0x48>
ffffffffc0205376:	928fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020537a:	00008697          	auipc	a3,0x8
ffffffffc020537e:	21e68693          	addi	a3,a3,542 # ffffffffc020d598 <CSWTCH.79+0x18>
ffffffffc0205382:	00006617          	auipc	a2,0x6
ffffffffc0205386:	7f660613          	addi	a2,a2,2038 # ffffffffc020bb78 <commands+0x210>
ffffffffc020538a:	03300593          	li	a1,51
ffffffffc020538e:	00008517          	auipc	a0,0x8
ffffffffc0205392:	23a50513          	addi	a0,a0,570 # ffffffffc020d5c8 <CSWTCH.79+0x48>
ffffffffc0205396:	908fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020539a <files_closeall>:
ffffffffc020539a:	1101                	addi	sp,sp,-32
ffffffffc020539c:	ec06                	sd	ra,24(sp)
ffffffffc020539e:	e822                	sd	s0,16(sp)
ffffffffc02053a0:	e426                	sd	s1,8(sp)
ffffffffc02053a2:	e04a                	sd	s2,0(sp)
ffffffffc02053a4:	c129                	beqz	a0,ffffffffc02053e6 <files_closeall+0x4c>
ffffffffc02053a6:	491c                	lw	a5,16(a0)
ffffffffc02053a8:	02f05f63          	blez	a5,ffffffffc02053e6 <files_closeall+0x4c>
ffffffffc02053ac:	6504                	ld	s1,8(a0)
ffffffffc02053ae:	6785                	lui	a5,0x1
ffffffffc02053b0:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02053b4:	07048413          	addi	s0,s1,112
ffffffffc02053b8:	4909                	li	s2,2
ffffffffc02053ba:	94be                	add	s1,s1,a5
ffffffffc02053bc:	a029                	j	ffffffffc02053c6 <files_closeall+0x2c>
ffffffffc02053be:	03840413          	addi	s0,s0,56
ffffffffc02053c2:	00848c63          	beq	s1,s0,ffffffffc02053da <files_closeall+0x40>
ffffffffc02053c6:	401c                	lw	a5,0(s0)
ffffffffc02053c8:	ff279be3          	bne	a5,s2,ffffffffc02053be <files_closeall+0x24>
ffffffffc02053cc:	8522                	mv	a0,s0
ffffffffc02053ce:	03840413          	addi	s0,s0,56
ffffffffc02053d2:	e7cff0ef          	jal	ra,ffffffffc0204a4e <fd_array_close>
ffffffffc02053d6:	fe8498e3          	bne	s1,s0,ffffffffc02053c6 <files_closeall+0x2c>
ffffffffc02053da:	60e2                	ld	ra,24(sp)
ffffffffc02053dc:	6442                	ld	s0,16(sp)
ffffffffc02053de:	64a2                	ld	s1,8(sp)
ffffffffc02053e0:	6902                	ld	s2,0(sp)
ffffffffc02053e2:	6105                	addi	sp,sp,32
ffffffffc02053e4:	8082                	ret
ffffffffc02053e6:	00008697          	auipc	a3,0x8
ffffffffc02053ea:	dfa68693          	addi	a3,a3,-518 # ffffffffc020d1e0 <default_pmm_manager+0xb88>
ffffffffc02053ee:	00006617          	auipc	a2,0x6
ffffffffc02053f2:	78a60613          	addi	a2,a2,1930 # ffffffffc020bb78 <commands+0x210>
ffffffffc02053f6:	04500593          	li	a1,69
ffffffffc02053fa:	00008517          	auipc	a0,0x8
ffffffffc02053fe:	1ce50513          	addi	a0,a0,462 # ffffffffc020d5c8 <CSWTCH.79+0x48>
ffffffffc0205402:	89cfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205406 <dup_files>:
ffffffffc0205406:	7179                	addi	sp,sp,-48
ffffffffc0205408:	f406                	sd	ra,40(sp)
ffffffffc020540a:	f022                	sd	s0,32(sp)
ffffffffc020540c:	ec26                	sd	s1,24(sp)
ffffffffc020540e:	e84a                	sd	s2,16(sp)
ffffffffc0205410:	e44e                	sd	s3,8(sp)
ffffffffc0205412:	e052                	sd	s4,0(sp)
ffffffffc0205414:	c52d                	beqz	a0,ffffffffc020547e <dup_files+0x78>
ffffffffc0205416:	842e                	mv	s0,a1
ffffffffc0205418:	c1bd                	beqz	a1,ffffffffc020547e <dup_files+0x78>
ffffffffc020541a:	491c                	lw	a5,16(a0)
ffffffffc020541c:	84aa                	mv	s1,a0
ffffffffc020541e:	e3c1                	bnez	a5,ffffffffc020549e <dup_files+0x98>
ffffffffc0205420:	499c                	lw	a5,16(a1)
ffffffffc0205422:	06f05e63          	blez	a5,ffffffffc020549e <dup_files+0x98>
ffffffffc0205426:	6188                	ld	a0,0(a1)
ffffffffc0205428:	e088                	sd	a0,0(s1)
ffffffffc020542a:	c119                	beqz	a0,ffffffffc0205430 <dup_files+0x2a>
ffffffffc020542c:	616020ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0205430:	6400                	ld	s0,8(s0)
ffffffffc0205432:	6905                	lui	s2,0x1
ffffffffc0205434:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205438:	6484                	ld	s1,8(s1)
ffffffffc020543a:	9922                	add	s2,s2,s0
ffffffffc020543c:	4989                	li	s3,2
ffffffffc020543e:	4a05                	li	s4,1
ffffffffc0205440:	a039                	j	ffffffffc020544e <dup_files+0x48>
ffffffffc0205442:	03840413          	addi	s0,s0,56
ffffffffc0205446:	03848493          	addi	s1,s1,56
ffffffffc020544a:	02890163          	beq	s2,s0,ffffffffc020546c <dup_files+0x66>
ffffffffc020544e:	401c                	lw	a5,0(s0)
ffffffffc0205450:	ff3799e3          	bne	a5,s3,ffffffffc0205442 <dup_files+0x3c>
ffffffffc0205454:	0144a023          	sw	s4,0(s1)
ffffffffc0205458:	85a2                	mv	a1,s0
ffffffffc020545a:	8526                	mv	a0,s1
ffffffffc020545c:	03840413          	addi	s0,s0,56
ffffffffc0205460:	e6cff0ef          	jal	ra,ffffffffc0204acc <fd_array_dup>
ffffffffc0205464:	03848493          	addi	s1,s1,56
ffffffffc0205468:	fe8913e3          	bne	s2,s0,ffffffffc020544e <dup_files+0x48>
ffffffffc020546c:	70a2                	ld	ra,40(sp)
ffffffffc020546e:	7402                	ld	s0,32(sp)
ffffffffc0205470:	64e2                	ld	s1,24(sp)
ffffffffc0205472:	6942                	ld	s2,16(sp)
ffffffffc0205474:	69a2                	ld	s3,8(sp)
ffffffffc0205476:	6a02                	ld	s4,0(sp)
ffffffffc0205478:	4501                	li	a0,0
ffffffffc020547a:	6145                	addi	sp,sp,48
ffffffffc020547c:	8082                	ret
ffffffffc020547e:	00008697          	auipc	a3,0x8
ffffffffc0205482:	ab268693          	addi	a3,a3,-1358 # ffffffffc020cf30 <default_pmm_manager+0x8d8>
ffffffffc0205486:	00006617          	auipc	a2,0x6
ffffffffc020548a:	6f260613          	addi	a2,a2,1778 # ffffffffc020bb78 <commands+0x210>
ffffffffc020548e:	05300593          	li	a1,83
ffffffffc0205492:	00008517          	auipc	a0,0x8
ffffffffc0205496:	13650513          	addi	a0,a0,310 # ffffffffc020d5c8 <CSWTCH.79+0x48>
ffffffffc020549a:	804fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020549e:	00008697          	auipc	a3,0x8
ffffffffc02054a2:	15268693          	addi	a3,a3,338 # ffffffffc020d5f0 <CSWTCH.79+0x70>
ffffffffc02054a6:	00006617          	auipc	a2,0x6
ffffffffc02054aa:	6d260613          	addi	a2,a2,1746 # ffffffffc020bb78 <commands+0x210>
ffffffffc02054ae:	05400593          	li	a1,84
ffffffffc02054b2:	00008517          	auipc	a0,0x8
ffffffffc02054b6:	11650513          	addi	a0,a0,278 # ffffffffc020d5c8 <CSWTCH.79+0x48>
ffffffffc02054ba:	fe5fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02054be <iobuf_skip.part.0>:
ffffffffc02054be:	1141                	addi	sp,sp,-16
ffffffffc02054c0:	00008697          	auipc	a3,0x8
ffffffffc02054c4:	16068693          	addi	a3,a3,352 # ffffffffc020d620 <CSWTCH.79+0xa0>
ffffffffc02054c8:	00006617          	auipc	a2,0x6
ffffffffc02054cc:	6b060613          	addi	a2,a2,1712 # ffffffffc020bb78 <commands+0x210>
ffffffffc02054d0:	04a00593          	li	a1,74
ffffffffc02054d4:	00008517          	auipc	a0,0x8
ffffffffc02054d8:	16450513          	addi	a0,a0,356 # ffffffffc020d638 <CSWTCH.79+0xb8>
ffffffffc02054dc:	e406                	sd	ra,8(sp)
ffffffffc02054de:	fc1fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02054e2 <iobuf_init>:
ffffffffc02054e2:	e10c                	sd	a1,0(a0)
ffffffffc02054e4:	e514                	sd	a3,8(a0)
ffffffffc02054e6:	ed10                	sd	a2,24(a0)
ffffffffc02054e8:	e910                	sd	a2,16(a0)
ffffffffc02054ea:	8082                	ret

ffffffffc02054ec <iobuf_move>:
ffffffffc02054ec:	7179                	addi	sp,sp,-48
ffffffffc02054ee:	ec26                	sd	s1,24(sp)
ffffffffc02054f0:	6d04                	ld	s1,24(a0)
ffffffffc02054f2:	f022                	sd	s0,32(sp)
ffffffffc02054f4:	e84a                	sd	s2,16(sp)
ffffffffc02054f6:	e44e                	sd	s3,8(sp)
ffffffffc02054f8:	f406                	sd	ra,40(sp)
ffffffffc02054fa:	842a                	mv	s0,a0
ffffffffc02054fc:	8932                	mv	s2,a2
ffffffffc02054fe:	852e                	mv	a0,a1
ffffffffc0205500:	89ba                	mv	s3,a4
ffffffffc0205502:	00967363          	bgeu	a2,s1,ffffffffc0205508 <iobuf_move+0x1c>
ffffffffc0205506:	84b2                	mv	s1,a2
ffffffffc0205508:	c495                	beqz	s1,ffffffffc0205534 <iobuf_move+0x48>
ffffffffc020550a:	600c                	ld	a1,0(s0)
ffffffffc020550c:	c681                	beqz	a3,ffffffffc0205514 <iobuf_move+0x28>
ffffffffc020550e:	87ae                	mv	a5,a1
ffffffffc0205510:	85aa                	mv	a1,a0
ffffffffc0205512:	853e                	mv	a0,a5
ffffffffc0205514:	8626                	mv	a2,s1
ffffffffc0205516:	190060ef          	jal	ra,ffffffffc020b6a6 <memmove>
ffffffffc020551a:	6c1c                	ld	a5,24(s0)
ffffffffc020551c:	0297ea63          	bltu	a5,s1,ffffffffc0205550 <iobuf_move+0x64>
ffffffffc0205520:	6014                	ld	a3,0(s0)
ffffffffc0205522:	6418                	ld	a4,8(s0)
ffffffffc0205524:	8f85                	sub	a5,a5,s1
ffffffffc0205526:	96a6                	add	a3,a3,s1
ffffffffc0205528:	9726                	add	a4,a4,s1
ffffffffc020552a:	e014                	sd	a3,0(s0)
ffffffffc020552c:	e418                	sd	a4,8(s0)
ffffffffc020552e:	ec1c                	sd	a5,24(s0)
ffffffffc0205530:	40990933          	sub	s2,s2,s1
ffffffffc0205534:	00098463          	beqz	s3,ffffffffc020553c <iobuf_move+0x50>
ffffffffc0205538:	0099b023          	sd	s1,0(s3)
ffffffffc020553c:	4501                	li	a0,0
ffffffffc020553e:	00091b63          	bnez	s2,ffffffffc0205554 <iobuf_move+0x68>
ffffffffc0205542:	70a2                	ld	ra,40(sp)
ffffffffc0205544:	7402                	ld	s0,32(sp)
ffffffffc0205546:	64e2                	ld	s1,24(sp)
ffffffffc0205548:	6942                	ld	s2,16(sp)
ffffffffc020554a:	69a2                	ld	s3,8(sp)
ffffffffc020554c:	6145                	addi	sp,sp,48
ffffffffc020554e:	8082                	ret
ffffffffc0205550:	f6fff0ef          	jal	ra,ffffffffc02054be <iobuf_skip.part.0>
ffffffffc0205554:	5571                	li	a0,-4
ffffffffc0205556:	b7f5                	j	ffffffffc0205542 <iobuf_move+0x56>

ffffffffc0205558 <iobuf_skip>:
ffffffffc0205558:	6d1c                	ld	a5,24(a0)
ffffffffc020555a:	00b7eb63          	bltu	a5,a1,ffffffffc0205570 <iobuf_skip+0x18>
ffffffffc020555e:	6114                	ld	a3,0(a0)
ffffffffc0205560:	6518                	ld	a4,8(a0)
ffffffffc0205562:	8f8d                	sub	a5,a5,a1
ffffffffc0205564:	96ae                	add	a3,a3,a1
ffffffffc0205566:	95ba                	add	a1,a1,a4
ffffffffc0205568:	e114                	sd	a3,0(a0)
ffffffffc020556a:	e50c                	sd	a1,8(a0)
ffffffffc020556c:	ed1c                	sd	a5,24(a0)
ffffffffc020556e:	8082                	ret
ffffffffc0205570:	1141                	addi	sp,sp,-16
ffffffffc0205572:	e406                	sd	ra,8(sp)
ffffffffc0205574:	f4bff0ef          	jal	ra,ffffffffc02054be <iobuf_skip.part.0>

ffffffffc0205578 <copy_path>:
ffffffffc0205578:	7139                	addi	sp,sp,-64
ffffffffc020557a:	f04a                	sd	s2,32(sp)
ffffffffc020557c:	00091917          	auipc	s2,0x91
ffffffffc0205580:	34490913          	addi	s2,s2,836 # ffffffffc02968c0 <current>
ffffffffc0205584:	00093703          	ld	a4,0(s2)
ffffffffc0205588:	ec4e                	sd	s3,24(sp)
ffffffffc020558a:	89aa                	mv	s3,a0
ffffffffc020558c:	6505                	lui	a0,0x1
ffffffffc020558e:	f426                	sd	s1,40(sp)
ffffffffc0205590:	e852                	sd	s4,16(sp)
ffffffffc0205592:	fc06                	sd	ra,56(sp)
ffffffffc0205594:	f822                	sd	s0,48(sp)
ffffffffc0205596:	e456                	sd	s5,8(sp)
ffffffffc0205598:	02873a03          	ld	s4,40(a4)
ffffffffc020559c:	84ae                	mv	s1,a1
ffffffffc020559e:	a79fc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02055a2:	c141                	beqz	a0,ffffffffc0205622 <copy_path+0xaa>
ffffffffc02055a4:	842a                	mv	s0,a0
ffffffffc02055a6:	040a0563          	beqz	s4,ffffffffc02055f0 <copy_path+0x78>
ffffffffc02055aa:	038a0a93          	addi	s5,s4,56
ffffffffc02055ae:	8556                	mv	a0,s5
ffffffffc02055b0:	8b4ff0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02055b4:	00093783          	ld	a5,0(s2)
ffffffffc02055b8:	cba1                	beqz	a5,ffffffffc0205608 <copy_path+0x90>
ffffffffc02055ba:	43dc                	lw	a5,4(a5)
ffffffffc02055bc:	6685                	lui	a3,0x1
ffffffffc02055be:	8626                	mv	a2,s1
ffffffffc02055c0:	04fa2823          	sw	a5,80(s4)
ffffffffc02055c4:	85a2                	mv	a1,s0
ffffffffc02055c6:	8552                	mv	a0,s4
ffffffffc02055c8:	e4dfe0ef          	jal	ra,ffffffffc0204414 <copy_string>
ffffffffc02055cc:	c529                	beqz	a0,ffffffffc0205616 <copy_path+0x9e>
ffffffffc02055ce:	8556                	mv	a0,s5
ffffffffc02055d0:	890ff0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc02055d4:	040a2823          	sw	zero,80(s4)
ffffffffc02055d8:	0089b023          	sd	s0,0(s3)
ffffffffc02055dc:	4501                	li	a0,0
ffffffffc02055de:	70e2                	ld	ra,56(sp)
ffffffffc02055e0:	7442                	ld	s0,48(sp)
ffffffffc02055e2:	74a2                	ld	s1,40(sp)
ffffffffc02055e4:	7902                	ld	s2,32(sp)
ffffffffc02055e6:	69e2                	ld	s3,24(sp)
ffffffffc02055e8:	6a42                	ld	s4,16(sp)
ffffffffc02055ea:	6aa2                	ld	s5,8(sp)
ffffffffc02055ec:	6121                	addi	sp,sp,64
ffffffffc02055ee:	8082                	ret
ffffffffc02055f0:	85aa                	mv	a1,a0
ffffffffc02055f2:	6685                	lui	a3,0x1
ffffffffc02055f4:	8626                	mv	a2,s1
ffffffffc02055f6:	4501                	li	a0,0
ffffffffc02055f8:	e1dfe0ef          	jal	ra,ffffffffc0204414 <copy_string>
ffffffffc02055fc:	fd71                	bnez	a0,ffffffffc02055d8 <copy_path+0x60>
ffffffffc02055fe:	8522                	mv	a0,s0
ffffffffc0205600:	ac7fc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0205604:	5575                	li	a0,-3
ffffffffc0205606:	bfe1                	j	ffffffffc02055de <copy_path+0x66>
ffffffffc0205608:	6685                	lui	a3,0x1
ffffffffc020560a:	8626                	mv	a2,s1
ffffffffc020560c:	85a2                	mv	a1,s0
ffffffffc020560e:	8552                	mv	a0,s4
ffffffffc0205610:	e05fe0ef          	jal	ra,ffffffffc0204414 <copy_string>
ffffffffc0205614:	fd4d                	bnez	a0,ffffffffc02055ce <copy_path+0x56>
ffffffffc0205616:	8556                	mv	a0,s5
ffffffffc0205618:	848ff0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020561c:	040a2823          	sw	zero,80(s4)
ffffffffc0205620:	bff9                	j	ffffffffc02055fe <copy_path+0x86>
ffffffffc0205622:	5571                	li	a0,-4
ffffffffc0205624:	bf6d                	j	ffffffffc02055de <copy_path+0x66>

ffffffffc0205626 <sysfile_open>:
ffffffffc0205626:	7179                	addi	sp,sp,-48
ffffffffc0205628:	872a                	mv	a4,a0
ffffffffc020562a:	ec26                	sd	s1,24(sp)
ffffffffc020562c:	0028                	addi	a0,sp,8
ffffffffc020562e:	84ae                	mv	s1,a1
ffffffffc0205630:	85ba                	mv	a1,a4
ffffffffc0205632:	f022                	sd	s0,32(sp)
ffffffffc0205634:	f406                	sd	ra,40(sp)
ffffffffc0205636:	f43ff0ef          	jal	ra,ffffffffc0205578 <copy_path>
ffffffffc020563a:	842a                	mv	s0,a0
ffffffffc020563c:	e909                	bnez	a0,ffffffffc020564e <sysfile_open+0x28>
ffffffffc020563e:	6522                	ld	a0,8(sp)
ffffffffc0205640:	85a6                	mv	a1,s1
ffffffffc0205642:	d60ff0ef          	jal	ra,ffffffffc0204ba2 <file_open>
ffffffffc0205646:	842a                	mv	s0,a0
ffffffffc0205648:	6522                	ld	a0,8(sp)
ffffffffc020564a:	a7dfc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020564e:	70a2                	ld	ra,40(sp)
ffffffffc0205650:	8522                	mv	a0,s0
ffffffffc0205652:	7402                	ld	s0,32(sp)
ffffffffc0205654:	64e2                	ld	s1,24(sp)
ffffffffc0205656:	6145                	addi	sp,sp,48
ffffffffc0205658:	8082                	ret

ffffffffc020565a <sysfile_close>:
ffffffffc020565a:	e46ff06f          	j	ffffffffc0204ca0 <file_close>

ffffffffc020565e <sysfile_read>:
ffffffffc020565e:	7159                	addi	sp,sp,-112
ffffffffc0205660:	f0a2                	sd	s0,96(sp)
ffffffffc0205662:	f486                	sd	ra,104(sp)
ffffffffc0205664:	eca6                	sd	s1,88(sp)
ffffffffc0205666:	e8ca                	sd	s2,80(sp)
ffffffffc0205668:	e4ce                	sd	s3,72(sp)
ffffffffc020566a:	e0d2                	sd	s4,64(sp)
ffffffffc020566c:	fc56                	sd	s5,56(sp)
ffffffffc020566e:	f85a                	sd	s6,48(sp)
ffffffffc0205670:	f45e                	sd	s7,40(sp)
ffffffffc0205672:	f062                	sd	s8,32(sp)
ffffffffc0205674:	ec66                	sd	s9,24(sp)
ffffffffc0205676:	4401                	li	s0,0
ffffffffc0205678:	ee19                	bnez	a2,ffffffffc0205696 <sysfile_read+0x38>
ffffffffc020567a:	70a6                	ld	ra,104(sp)
ffffffffc020567c:	8522                	mv	a0,s0
ffffffffc020567e:	7406                	ld	s0,96(sp)
ffffffffc0205680:	64e6                	ld	s1,88(sp)
ffffffffc0205682:	6946                	ld	s2,80(sp)
ffffffffc0205684:	69a6                	ld	s3,72(sp)
ffffffffc0205686:	6a06                	ld	s4,64(sp)
ffffffffc0205688:	7ae2                	ld	s5,56(sp)
ffffffffc020568a:	7b42                	ld	s6,48(sp)
ffffffffc020568c:	7ba2                	ld	s7,40(sp)
ffffffffc020568e:	7c02                	ld	s8,32(sp)
ffffffffc0205690:	6ce2                	ld	s9,24(sp)
ffffffffc0205692:	6165                	addi	sp,sp,112
ffffffffc0205694:	8082                	ret
ffffffffc0205696:	00091c97          	auipc	s9,0x91
ffffffffc020569a:	22ac8c93          	addi	s9,s9,554 # ffffffffc02968c0 <current>
ffffffffc020569e:	000cb783          	ld	a5,0(s9)
ffffffffc02056a2:	84b2                	mv	s1,a2
ffffffffc02056a4:	8b2e                	mv	s6,a1
ffffffffc02056a6:	4601                	li	a2,0
ffffffffc02056a8:	4585                	li	a1,1
ffffffffc02056aa:	0287b903          	ld	s2,40(a5)
ffffffffc02056ae:	8aaa                	mv	s5,a0
ffffffffc02056b0:	c9eff0ef          	jal	ra,ffffffffc0204b4e <file_testfd>
ffffffffc02056b4:	c959                	beqz	a0,ffffffffc020574a <sysfile_read+0xec>
ffffffffc02056b6:	6505                	lui	a0,0x1
ffffffffc02056b8:	95ffc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02056bc:	89aa                	mv	s3,a0
ffffffffc02056be:	c941                	beqz	a0,ffffffffc020574e <sysfile_read+0xf0>
ffffffffc02056c0:	4b81                	li	s7,0
ffffffffc02056c2:	6a05                	lui	s4,0x1
ffffffffc02056c4:	03890c13          	addi	s8,s2,56
ffffffffc02056c8:	0744ec63          	bltu	s1,s4,ffffffffc0205740 <sysfile_read+0xe2>
ffffffffc02056cc:	e452                	sd	s4,8(sp)
ffffffffc02056ce:	6605                	lui	a2,0x1
ffffffffc02056d0:	0034                	addi	a3,sp,8
ffffffffc02056d2:	85ce                	mv	a1,s3
ffffffffc02056d4:	8556                	mv	a0,s5
ffffffffc02056d6:	e20ff0ef          	jal	ra,ffffffffc0204cf6 <file_read>
ffffffffc02056da:	66a2                	ld	a3,8(sp)
ffffffffc02056dc:	842a                	mv	s0,a0
ffffffffc02056de:	ca9d                	beqz	a3,ffffffffc0205714 <sysfile_read+0xb6>
ffffffffc02056e0:	00090c63          	beqz	s2,ffffffffc02056f8 <sysfile_read+0x9a>
ffffffffc02056e4:	8562                	mv	a0,s8
ffffffffc02056e6:	f7ffe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02056ea:	000cb783          	ld	a5,0(s9)
ffffffffc02056ee:	cfa1                	beqz	a5,ffffffffc0205746 <sysfile_read+0xe8>
ffffffffc02056f0:	43dc                	lw	a5,4(a5)
ffffffffc02056f2:	66a2                	ld	a3,8(sp)
ffffffffc02056f4:	04f92823          	sw	a5,80(s2)
ffffffffc02056f8:	864e                	mv	a2,s3
ffffffffc02056fa:	85da                	mv	a1,s6
ffffffffc02056fc:	854a                	mv	a0,s2
ffffffffc02056fe:	ce5fe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc0205702:	c50d                	beqz	a0,ffffffffc020572c <sysfile_read+0xce>
ffffffffc0205704:	67a2                	ld	a5,8(sp)
ffffffffc0205706:	04f4e663          	bltu	s1,a5,ffffffffc0205752 <sysfile_read+0xf4>
ffffffffc020570a:	9b3e                	add	s6,s6,a5
ffffffffc020570c:	8c9d                	sub	s1,s1,a5
ffffffffc020570e:	9bbe                	add	s7,s7,a5
ffffffffc0205710:	02091263          	bnez	s2,ffffffffc0205734 <sysfile_read+0xd6>
ffffffffc0205714:	e401                	bnez	s0,ffffffffc020571c <sysfile_read+0xbe>
ffffffffc0205716:	67a2                	ld	a5,8(sp)
ffffffffc0205718:	c391                	beqz	a5,ffffffffc020571c <sysfile_read+0xbe>
ffffffffc020571a:	f4dd                	bnez	s1,ffffffffc02056c8 <sysfile_read+0x6a>
ffffffffc020571c:	854e                	mv	a0,s3
ffffffffc020571e:	9a9fc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0205722:	f40b8ce3          	beqz	s7,ffffffffc020567a <sysfile_read+0x1c>
ffffffffc0205726:	000b841b          	sext.w	s0,s7
ffffffffc020572a:	bf81                	j	ffffffffc020567a <sysfile_read+0x1c>
ffffffffc020572c:	e011                	bnez	s0,ffffffffc0205730 <sysfile_read+0xd2>
ffffffffc020572e:	5475                	li	s0,-3
ffffffffc0205730:	fe0906e3          	beqz	s2,ffffffffc020571c <sysfile_read+0xbe>
ffffffffc0205734:	8562                	mv	a0,s8
ffffffffc0205736:	f2bfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020573a:	04092823          	sw	zero,80(s2)
ffffffffc020573e:	bfd9                	j	ffffffffc0205714 <sysfile_read+0xb6>
ffffffffc0205740:	e426                	sd	s1,8(sp)
ffffffffc0205742:	8626                	mv	a2,s1
ffffffffc0205744:	b771                	j	ffffffffc02056d0 <sysfile_read+0x72>
ffffffffc0205746:	66a2                	ld	a3,8(sp)
ffffffffc0205748:	bf45                	j	ffffffffc02056f8 <sysfile_read+0x9a>
ffffffffc020574a:	5475                	li	s0,-3
ffffffffc020574c:	b73d                	j	ffffffffc020567a <sysfile_read+0x1c>
ffffffffc020574e:	5471                	li	s0,-4
ffffffffc0205750:	b72d                	j	ffffffffc020567a <sysfile_read+0x1c>
ffffffffc0205752:	00008697          	auipc	a3,0x8
ffffffffc0205756:	ef668693          	addi	a3,a3,-266 # ffffffffc020d648 <CSWTCH.79+0xc8>
ffffffffc020575a:	00006617          	auipc	a2,0x6
ffffffffc020575e:	41e60613          	addi	a2,a2,1054 # ffffffffc020bb78 <commands+0x210>
ffffffffc0205762:	05500593          	li	a1,85
ffffffffc0205766:	00008517          	auipc	a0,0x8
ffffffffc020576a:	ef250513          	addi	a0,a0,-270 # ffffffffc020d658 <CSWTCH.79+0xd8>
ffffffffc020576e:	d31fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205772 <sysfile_write>:
ffffffffc0205772:	7159                	addi	sp,sp,-112
ffffffffc0205774:	e8ca                	sd	s2,80(sp)
ffffffffc0205776:	f486                	sd	ra,104(sp)
ffffffffc0205778:	f0a2                	sd	s0,96(sp)
ffffffffc020577a:	eca6                	sd	s1,88(sp)
ffffffffc020577c:	e4ce                	sd	s3,72(sp)
ffffffffc020577e:	e0d2                	sd	s4,64(sp)
ffffffffc0205780:	fc56                	sd	s5,56(sp)
ffffffffc0205782:	f85a                	sd	s6,48(sp)
ffffffffc0205784:	f45e                	sd	s7,40(sp)
ffffffffc0205786:	f062                	sd	s8,32(sp)
ffffffffc0205788:	ec66                	sd	s9,24(sp)
ffffffffc020578a:	4901                	li	s2,0
ffffffffc020578c:	ee19                	bnez	a2,ffffffffc02057aa <sysfile_write+0x38>
ffffffffc020578e:	70a6                	ld	ra,104(sp)
ffffffffc0205790:	7406                	ld	s0,96(sp)
ffffffffc0205792:	64e6                	ld	s1,88(sp)
ffffffffc0205794:	69a6                	ld	s3,72(sp)
ffffffffc0205796:	6a06                	ld	s4,64(sp)
ffffffffc0205798:	7ae2                	ld	s5,56(sp)
ffffffffc020579a:	7b42                	ld	s6,48(sp)
ffffffffc020579c:	7ba2                	ld	s7,40(sp)
ffffffffc020579e:	7c02                	ld	s8,32(sp)
ffffffffc02057a0:	6ce2                	ld	s9,24(sp)
ffffffffc02057a2:	854a                	mv	a0,s2
ffffffffc02057a4:	6946                	ld	s2,80(sp)
ffffffffc02057a6:	6165                	addi	sp,sp,112
ffffffffc02057a8:	8082                	ret
ffffffffc02057aa:	00091c17          	auipc	s8,0x91
ffffffffc02057ae:	116c0c13          	addi	s8,s8,278 # ffffffffc02968c0 <current>
ffffffffc02057b2:	000c3783          	ld	a5,0(s8)
ffffffffc02057b6:	8432                	mv	s0,a2
ffffffffc02057b8:	89ae                	mv	s3,a1
ffffffffc02057ba:	4605                	li	a2,1
ffffffffc02057bc:	4581                	li	a1,0
ffffffffc02057be:	7784                	ld	s1,40(a5)
ffffffffc02057c0:	8baa                	mv	s7,a0
ffffffffc02057c2:	b8cff0ef          	jal	ra,ffffffffc0204b4e <file_testfd>
ffffffffc02057c6:	cd59                	beqz	a0,ffffffffc0205864 <sysfile_write+0xf2>
ffffffffc02057c8:	6505                	lui	a0,0x1
ffffffffc02057ca:	84dfc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02057ce:	8a2a                	mv	s4,a0
ffffffffc02057d0:	cd41                	beqz	a0,ffffffffc0205868 <sysfile_write+0xf6>
ffffffffc02057d2:	4c81                	li	s9,0
ffffffffc02057d4:	6a85                	lui	s5,0x1
ffffffffc02057d6:	03848b13          	addi	s6,s1,56
ffffffffc02057da:	05546a63          	bltu	s0,s5,ffffffffc020582e <sysfile_write+0xbc>
ffffffffc02057de:	e456                	sd	s5,8(sp)
ffffffffc02057e0:	c8a9                	beqz	s1,ffffffffc0205832 <sysfile_write+0xc0>
ffffffffc02057e2:	855a                	mv	a0,s6
ffffffffc02057e4:	e81fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02057e8:	000c3783          	ld	a5,0(s8)
ffffffffc02057ec:	c399                	beqz	a5,ffffffffc02057f2 <sysfile_write+0x80>
ffffffffc02057ee:	43dc                	lw	a5,4(a5)
ffffffffc02057f0:	c8bc                	sw	a5,80(s1)
ffffffffc02057f2:	66a2                	ld	a3,8(sp)
ffffffffc02057f4:	4701                	li	a4,0
ffffffffc02057f6:	864e                	mv	a2,s3
ffffffffc02057f8:	85d2                	mv	a1,s4
ffffffffc02057fa:	8526                	mv	a0,s1
ffffffffc02057fc:	bb3fe0ef          	jal	ra,ffffffffc02043ae <copy_from_user>
ffffffffc0205800:	c139                	beqz	a0,ffffffffc0205846 <sysfile_write+0xd4>
ffffffffc0205802:	855a                	mv	a0,s6
ffffffffc0205804:	e5dfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205808:	0404a823          	sw	zero,80(s1)
ffffffffc020580c:	6622                	ld	a2,8(sp)
ffffffffc020580e:	0034                	addi	a3,sp,8
ffffffffc0205810:	85d2                	mv	a1,s4
ffffffffc0205812:	855e                	mv	a0,s7
ffffffffc0205814:	dc8ff0ef          	jal	ra,ffffffffc0204ddc <file_write>
ffffffffc0205818:	67a2                	ld	a5,8(sp)
ffffffffc020581a:	892a                	mv	s2,a0
ffffffffc020581c:	ef85                	bnez	a5,ffffffffc0205854 <sysfile_write+0xe2>
ffffffffc020581e:	8552                	mv	a0,s4
ffffffffc0205820:	8a7fc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0205824:	f60c85e3          	beqz	s9,ffffffffc020578e <sysfile_write+0x1c>
ffffffffc0205828:	000c891b          	sext.w	s2,s9
ffffffffc020582c:	b78d                	j	ffffffffc020578e <sysfile_write+0x1c>
ffffffffc020582e:	e422                	sd	s0,8(sp)
ffffffffc0205830:	f8cd                	bnez	s1,ffffffffc02057e2 <sysfile_write+0x70>
ffffffffc0205832:	66a2                	ld	a3,8(sp)
ffffffffc0205834:	4701                	li	a4,0
ffffffffc0205836:	864e                	mv	a2,s3
ffffffffc0205838:	85d2                	mv	a1,s4
ffffffffc020583a:	4501                	li	a0,0
ffffffffc020583c:	b73fe0ef          	jal	ra,ffffffffc02043ae <copy_from_user>
ffffffffc0205840:	f571                	bnez	a0,ffffffffc020580c <sysfile_write+0x9a>
ffffffffc0205842:	5975                	li	s2,-3
ffffffffc0205844:	bfe9                	j	ffffffffc020581e <sysfile_write+0xac>
ffffffffc0205846:	855a                	mv	a0,s6
ffffffffc0205848:	e19fe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020584c:	5975                	li	s2,-3
ffffffffc020584e:	0404a823          	sw	zero,80(s1)
ffffffffc0205852:	b7f1                	j	ffffffffc020581e <sysfile_write+0xac>
ffffffffc0205854:	00f46c63          	bltu	s0,a5,ffffffffc020586c <sysfile_write+0xfa>
ffffffffc0205858:	99be                	add	s3,s3,a5
ffffffffc020585a:	8c1d                	sub	s0,s0,a5
ffffffffc020585c:	9cbe                	add	s9,s9,a5
ffffffffc020585e:	f161                	bnez	a0,ffffffffc020581e <sysfile_write+0xac>
ffffffffc0205860:	fc2d                	bnez	s0,ffffffffc02057da <sysfile_write+0x68>
ffffffffc0205862:	bf75                	j	ffffffffc020581e <sysfile_write+0xac>
ffffffffc0205864:	5975                	li	s2,-3
ffffffffc0205866:	b725                	j	ffffffffc020578e <sysfile_write+0x1c>
ffffffffc0205868:	5971                	li	s2,-4
ffffffffc020586a:	b715                	j	ffffffffc020578e <sysfile_write+0x1c>
ffffffffc020586c:	00008697          	auipc	a3,0x8
ffffffffc0205870:	ddc68693          	addi	a3,a3,-548 # ffffffffc020d648 <CSWTCH.79+0xc8>
ffffffffc0205874:	00006617          	auipc	a2,0x6
ffffffffc0205878:	30460613          	addi	a2,a2,772 # ffffffffc020bb78 <commands+0x210>
ffffffffc020587c:	08a00593          	li	a1,138
ffffffffc0205880:	00008517          	auipc	a0,0x8
ffffffffc0205884:	dd850513          	addi	a0,a0,-552 # ffffffffc020d658 <CSWTCH.79+0xd8>
ffffffffc0205888:	c17fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020588c <sysfile_seek>:
ffffffffc020588c:	e36ff06f          	j	ffffffffc0204ec2 <file_seek>

ffffffffc0205890 <sysfile_fstat>:
ffffffffc0205890:	715d                	addi	sp,sp,-80
ffffffffc0205892:	f44e                	sd	s3,40(sp)
ffffffffc0205894:	00091997          	auipc	s3,0x91
ffffffffc0205898:	02c98993          	addi	s3,s3,44 # ffffffffc02968c0 <current>
ffffffffc020589c:	0009b703          	ld	a4,0(s3)
ffffffffc02058a0:	fc26                	sd	s1,56(sp)
ffffffffc02058a2:	84ae                	mv	s1,a1
ffffffffc02058a4:	858a                	mv	a1,sp
ffffffffc02058a6:	e0a2                	sd	s0,64(sp)
ffffffffc02058a8:	f84a                	sd	s2,48(sp)
ffffffffc02058aa:	e486                	sd	ra,72(sp)
ffffffffc02058ac:	02873903          	ld	s2,40(a4)
ffffffffc02058b0:	f052                	sd	s4,32(sp)
ffffffffc02058b2:	f30ff0ef          	jal	ra,ffffffffc0204fe2 <file_fstat>
ffffffffc02058b6:	842a                	mv	s0,a0
ffffffffc02058b8:	e91d                	bnez	a0,ffffffffc02058ee <sysfile_fstat+0x5e>
ffffffffc02058ba:	04090363          	beqz	s2,ffffffffc0205900 <sysfile_fstat+0x70>
ffffffffc02058be:	03890a13          	addi	s4,s2,56
ffffffffc02058c2:	8552                	mv	a0,s4
ffffffffc02058c4:	da1fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02058c8:	0009b783          	ld	a5,0(s3)
ffffffffc02058cc:	c3b9                	beqz	a5,ffffffffc0205912 <sysfile_fstat+0x82>
ffffffffc02058ce:	43dc                	lw	a5,4(a5)
ffffffffc02058d0:	02000693          	li	a3,32
ffffffffc02058d4:	860a                	mv	a2,sp
ffffffffc02058d6:	04f92823          	sw	a5,80(s2)
ffffffffc02058da:	85a6                	mv	a1,s1
ffffffffc02058dc:	854a                	mv	a0,s2
ffffffffc02058de:	b05fe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc02058e2:	c121                	beqz	a0,ffffffffc0205922 <sysfile_fstat+0x92>
ffffffffc02058e4:	8552                	mv	a0,s4
ffffffffc02058e6:	d7bfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc02058ea:	04092823          	sw	zero,80(s2)
ffffffffc02058ee:	60a6                	ld	ra,72(sp)
ffffffffc02058f0:	8522                	mv	a0,s0
ffffffffc02058f2:	6406                	ld	s0,64(sp)
ffffffffc02058f4:	74e2                	ld	s1,56(sp)
ffffffffc02058f6:	7942                	ld	s2,48(sp)
ffffffffc02058f8:	79a2                	ld	s3,40(sp)
ffffffffc02058fa:	7a02                	ld	s4,32(sp)
ffffffffc02058fc:	6161                	addi	sp,sp,80
ffffffffc02058fe:	8082                	ret
ffffffffc0205900:	02000693          	li	a3,32
ffffffffc0205904:	860a                	mv	a2,sp
ffffffffc0205906:	85a6                	mv	a1,s1
ffffffffc0205908:	adbfe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc020590c:	f16d                	bnez	a0,ffffffffc02058ee <sysfile_fstat+0x5e>
ffffffffc020590e:	5475                	li	s0,-3
ffffffffc0205910:	bff9                	j	ffffffffc02058ee <sysfile_fstat+0x5e>
ffffffffc0205912:	02000693          	li	a3,32
ffffffffc0205916:	860a                	mv	a2,sp
ffffffffc0205918:	85a6                	mv	a1,s1
ffffffffc020591a:	854a                	mv	a0,s2
ffffffffc020591c:	ac7fe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc0205920:	f171                	bnez	a0,ffffffffc02058e4 <sysfile_fstat+0x54>
ffffffffc0205922:	8552                	mv	a0,s4
ffffffffc0205924:	d3dfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205928:	5475                	li	s0,-3
ffffffffc020592a:	04092823          	sw	zero,80(s2)
ffffffffc020592e:	b7c1                	j	ffffffffc02058ee <sysfile_fstat+0x5e>

ffffffffc0205930 <sysfile_fsync>:
ffffffffc0205930:	f72ff06f          	j	ffffffffc02050a2 <file_fsync>

ffffffffc0205934 <sysfile_getcwd>:
ffffffffc0205934:	715d                	addi	sp,sp,-80
ffffffffc0205936:	f44e                	sd	s3,40(sp)
ffffffffc0205938:	00091997          	auipc	s3,0x91
ffffffffc020593c:	f8898993          	addi	s3,s3,-120 # ffffffffc02968c0 <current>
ffffffffc0205940:	0009b783          	ld	a5,0(s3)
ffffffffc0205944:	f84a                	sd	s2,48(sp)
ffffffffc0205946:	e486                	sd	ra,72(sp)
ffffffffc0205948:	e0a2                	sd	s0,64(sp)
ffffffffc020594a:	fc26                	sd	s1,56(sp)
ffffffffc020594c:	f052                	sd	s4,32(sp)
ffffffffc020594e:	0287b903          	ld	s2,40(a5)
ffffffffc0205952:	cda9                	beqz	a1,ffffffffc02059ac <sysfile_getcwd+0x78>
ffffffffc0205954:	842e                	mv	s0,a1
ffffffffc0205956:	84aa                	mv	s1,a0
ffffffffc0205958:	04090363          	beqz	s2,ffffffffc020599e <sysfile_getcwd+0x6a>
ffffffffc020595c:	03890a13          	addi	s4,s2,56
ffffffffc0205960:	8552                	mv	a0,s4
ffffffffc0205962:	d03fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0205966:	0009b783          	ld	a5,0(s3)
ffffffffc020596a:	c781                	beqz	a5,ffffffffc0205972 <sysfile_getcwd+0x3e>
ffffffffc020596c:	43dc                	lw	a5,4(a5)
ffffffffc020596e:	04f92823          	sw	a5,80(s2)
ffffffffc0205972:	4685                	li	a3,1
ffffffffc0205974:	8622                	mv	a2,s0
ffffffffc0205976:	85a6                	mv	a1,s1
ffffffffc0205978:	854a                	mv	a0,s2
ffffffffc020597a:	9a1fe0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc020597e:	e90d                	bnez	a0,ffffffffc02059b0 <sysfile_getcwd+0x7c>
ffffffffc0205980:	5475                	li	s0,-3
ffffffffc0205982:	8552                	mv	a0,s4
ffffffffc0205984:	cddfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205988:	04092823          	sw	zero,80(s2)
ffffffffc020598c:	60a6                	ld	ra,72(sp)
ffffffffc020598e:	8522                	mv	a0,s0
ffffffffc0205990:	6406                	ld	s0,64(sp)
ffffffffc0205992:	74e2                	ld	s1,56(sp)
ffffffffc0205994:	7942                	ld	s2,48(sp)
ffffffffc0205996:	79a2                	ld	s3,40(sp)
ffffffffc0205998:	7a02                	ld	s4,32(sp)
ffffffffc020599a:	6161                	addi	sp,sp,80
ffffffffc020599c:	8082                	ret
ffffffffc020599e:	862e                	mv	a2,a1
ffffffffc02059a0:	4685                	li	a3,1
ffffffffc02059a2:	85aa                	mv	a1,a0
ffffffffc02059a4:	4501                	li	a0,0
ffffffffc02059a6:	975fe0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc02059aa:	ed09                	bnez	a0,ffffffffc02059c4 <sysfile_getcwd+0x90>
ffffffffc02059ac:	5475                	li	s0,-3
ffffffffc02059ae:	bff9                	j	ffffffffc020598c <sysfile_getcwd+0x58>
ffffffffc02059b0:	8622                	mv	a2,s0
ffffffffc02059b2:	4681                	li	a3,0
ffffffffc02059b4:	85a6                	mv	a1,s1
ffffffffc02059b6:	850a                	mv	a0,sp
ffffffffc02059b8:	b2bff0ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc02059bc:	445020ef          	jal	ra,ffffffffc0208600 <vfs_getcwd>
ffffffffc02059c0:	842a                	mv	s0,a0
ffffffffc02059c2:	b7c1                	j	ffffffffc0205982 <sysfile_getcwd+0x4e>
ffffffffc02059c4:	8622                	mv	a2,s0
ffffffffc02059c6:	4681                	li	a3,0
ffffffffc02059c8:	85a6                	mv	a1,s1
ffffffffc02059ca:	850a                	mv	a0,sp
ffffffffc02059cc:	b17ff0ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc02059d0:	431020ef          	jal	ra,ffffffffc0208600 <vfs_getcwd>
ffffffffc02059d4:	842a                	mv	s0,a0
ffffffffc02059d6:	bf5d                	j	ffffffffc020598c <sysfile_getcwd+0x58>

ffffffffc02059d8 <sysfile_getdirentry>:
ffffffffc02059d8:	7139                	addi	sp,sp,-64
ffffffffc02059da:	e852                	sd	s4,16(sp)
ffffffffc02059dc:	00091a17          	auipc	s4,0x91
ffffffffc02059e0:	ee4a0a13          	addi	s4,s4,-284 # ffffffffc02968c0 <current>
ffffffffc02059e4:	000a3703          	ld	a4,0(s4)
ffffffffc02059e8:	ec4e                	sd	s3,24(sp)
ffffffffc02059ea:	89aa                	mv	s3,a0
ffffffffc02059ec:	10800513          	li	a0,264
ffffffffc02059f0:	f426                	sd	s1,40(sp)
ffffffffc02059f2:	f04a                	sd	s2,32(sp)
ffffffffc02059f4:	fc06                	sd	ra,56(sp)
ffffffffc02059f6:	f822                	sd	s0,48(sp)
ffffffffc02059f8:	e456                	sd	s5,8(sp)
ffffffffc02059fa:	7704                	ld	s1,40(a4)
ffffffffc02059fc:	892e                	mv	s2,a1
ffffffffc02059fe:	e18fc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0205a02:	c169                	beqz	a0,ffffffffc0205ac4 <sysfile_getdirentry+0xec>
ffffffffc0205a04:	842a                	mv	s0,a0
ffffffffc0205a06:	c8c1                	beqz	s1,ffffffffc0205a96 <sysfile_getdirentry+0xbe>
ffffffffc0205a08:	03848a93          	addi	s5,s1,56
ffffffffc0205a0c:	8556                	mv	a0,s5
ffffffffc0205a0e:	c57fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0205a12:	000a3783          	ld	a5,0(s4)
ffffffffc0205a16:	c399                	beqz	a5,ffffffffc0205a1c <sysfile_getdirentry+0x44>
ffffffffc0205a18:	43dc                	lw	a5,4(a5)
ffffffffc0205a1a:	c8bc                	sw	a5,80(s1)
ffffffffc0205a1c:	4705                	li	a4,1
ffffffffc0205a1e:	46a1                	li	a3,8
ffffffffc0205a20:	864a                	mv	a2,s2
ffffffffc0205a22:	85a2                	mv	a1,s0
ffffffffc0205a24:	8526                	mv	a0,s1
ffffffffc0205a26:	989fe0ef          	jal	ra,ffffffffc02043ae <copy_from_user>
ffffffffc0205a2a:	e505                	bnez	a0,ffffffffc0205a52 <sysfile_getdirentry+0x7a>
ffffffffc0205a2c:	8556                	mv	a0,s5
ffffffffc0205a2e:	c33fe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205a32:	59f5                	li	s3,-3
ffffffffc0205a34:	0404a823          	sw	zero,80(s1)
ffffffffc0205a38:	8522                	mv	a0,s0
ffffffffc0205a3a:	e8cfc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0205a3e:	70e2                	ld	ra,56(sp)
ffffffffc0205a40:	7442                	ld	s0,48(sp)
ffffffffc0205a42:	74a2                	ld	s1,40(sp)
ffffffffc0205a44:	7902                	ld	s2,32(sp)
ffffffffc0205a46:	6a42                	ld	s4,16(sp)
ffffffffc0205a48:	6aa2                	ld	s5,8(sp)
ffffffffc0205a4a:	854e                	mv	a0,s3
ffffffffc0205a4c:	69e2                	ld	s3,24(sp)
ffffffffc0205a4e:	6121                	addi	sp,sp,64
ffffffffc0205a50:	8082                	ret
ffffffffc0205a52:	8556                	mv	a0,s5
ffffffffc0205a54:	c0dfe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205a58:	854e                	mv	a0,s3
ffffffffc0205a5a:	85a2                	mv	a1,s0
ffffffffc0205a5c:	0404a823          	sw	zero,80(s1)
ffffffffc0205a60:	ef0ff0ef          	jal	ra,ffffffffc0205150 <file_getdirentry>
ffffffffc0205a64:	89aa                	mv	s3,a0
ffffffffc0205a66:	f969                	bnez	a0,ffffffffc0205a38 <sysfile_getdirentry+0x60>
ffffffffc0205a68:	8556                	mv	a0,s5
ffffffffc0205a6a:	bfbfe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0205a6e:	000a3783          	ld	a5,0(s4)
ffffffffc0205a72:	c399                	beqz	a5,ffffffffc0205a78 <sysfile_getdirentry+0xa0>
ffffffffc0205a74:	43dc                	lw	a5,4(a5)
ffffffffc0205a76:	c8bc                	sw	a5,80(s1)
ffffffffc0205a78:	10800693          	li	a3,264
ffffffffc0205a7c:	8622                	mv	a2,s0
ffffffffc0205a7e:	85ca                	mv	a1,s2
ffffffffc0205a80:	8526                	mv	a0,s1
ffffffffc0205a82:	961fe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc0205a86:	e111                	bnez	a0,ffffffffc0205a8a <sysfile_getdirentry+0xb2>
ffffffffc0205a88:	59f5                	li	s3,-3
ffffffffc0205a8a:	8556                	mv	a0,s5
ffffffffc0205a8c:	bd5fe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205a90:	0404a823          	sw	zero,80(s1)
ffffffffc0205a94:	b755                	j	ffffffffc0205a38 <sysfile_getdirentry+0x60>
ffffffffc0205a96:	85aa                	mv	a1,a0
ffffffffc0205a98:	4705                	li	a4,1
ffffffffc0205a9a:	46a1                	li	a3,8
ffffffffc0205a9c:	864a                	mv	a2,s2
ffffffffc0205a9e:	4501                	li	a0,0
ffffffffc0205aa0:	90ffe0ef          	jal	ra,ffffffffc02043ae <copy_from_user>
ffffffffc0205aa4:	cd11                	beqz	a0,ffffffffc0205ac0 <sysfile_getdirentry+0xe8>
ffffffffc0205aa6:	854e                	mv	a0,s3
ffffffffc0205aa8:	85a2                	mv	a1,s0
ffffffffc0205aaa:	ea6ff0ef          	jal	ra,ffffffffc0205150 <file_getdirentry>
ffffffffc0205aae:	89aa                	mv	s3,a0
ffffffffc0205ab0:	f541                	bnez	a0,ffffffffc0205a38 <sysfile_getdirentry+0x60>
ffffffffc0205ab2:	10800693          	li	a3,264
ffffffffc0205ab6:	8622                	mv	a2,s0
ffffffffc0205ab8:	85ca                	mv	a1,s2
ffffffffc0205aba:	929fe0ef          	jal	ra,ffffffffc02043e2 <copy_to_user>
ffffffffc0205abe:	fd2d                	bnez	a0,ffffffffc0205a38 <sysfile_getdirentry+0x60>
ffffffffc0205ac0:	59f5                	li	s3,-3
ffffffffc0205ac2:	bf9d                	j	ffffffffc0205a38 <sysfile_getdirentry+0x60>
ffffffffc0205ac4:	59f1                	li	s3,-4
ffffffffc0205ac6:	bfa5                	j	ffffffffc0205a3e <sysfile_getdirentry+0x66>

ffffffffc0205ac8 <sysfile_dup>:
ffffffffc0205ac8:	f6eff06f          	j	ffffffffc0205236 <file_dup>

ffffffffc0205acc <kernel_thread_entry>:
ffffffffc0205acc:	8526                	mv	a0,s1
ffffffffc0205ace:	9402                	jalr	s0
ffffffffc0205ad0:	5ee000ef          	jal	ra,ffffffffc02060be <do_exit>

ffffffffc0205ad4 <alloc_proc>:
ffffffffc0205ad4:	1141                	addi	sp,sp,-16
ffffffffc0205ad6:	15000513          	li	a0,336
ffffffffc0205ada:	e022                	sd	s0,0(sp)
ffffffffc0205adc:	e406                	sd	ra,8(sp)
ffffffffc0205ade:	d38fc0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0205ae2:	842a                	mv	s0,a0
ffffffffc0205ae4:	cd35                	beqz	a0,ffffffffc0205b60 <alloc_proc+0x8c>
ffffffffc0205ae6:	57fd                	li	a5,-1
ffffffffc0205ae8:	1782                	slli	a5,a5,0x20
ffffffffc0205aea:	e11c                	sd	a5,0(a0)
ffffffffc0205aec:	07000613          	li	a2,112
ffffffffc0205af0:	4581                	li	a1,0
ffffffffc0205af2:	00052423          	sw	zero,8(a0)
ffffffffc0205af6:	00053823          	sd	zero,16(a0)
ffffffffc0205afa:	00053c23          	sd	zero,24(a0)
ffffffffc0205afe:	02053023          	sd	zero,32(a0)
ffffffffc0205b02:	02053423          	sd	zero,40(a0)
ffffffffc0205b06:	03050513          	addi	a0,a0,48
ffffffffc0205b0a:	38b050ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0205b0e:	00091797          	auipc	a5,0x91
ffffffffc0205b12:	d827b783          	ld	a5,-638(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205b16:	f45c                	sd	a5,168(s0)
ffffffffc0205b18:	0a043023          	sd	zero,160(s0)
ffffffffc0205b1c:	0a042823          	sw	zero,176(s0)
ffffffffc0205b20:	463d                	li	a2,15
ffffffffc0205b22:	4581                	li	a1,0
ffffffffc0205b24:	0b440513          	addi	a0,s0,180
ffffffffc0205b28:	36d050ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0205b2c:	11040793          	addi	a5,s0,272
ffffffffc0205b30:	0e042623          	sw	zero,236(s0)
ffffffffc0205b34:	0e043c23          	sd	zero,248(s0)
ffffffffc0205b38:	10043023          	sd	zero,256(s0)
ffffffffc0205b3c:	0e043823          	sd	zero,240(s0)
ffffffffc0205b40:	10043423          	sd	zero,264(s0)
ffffffffc0205b44:	10f43c23          	sd	a5,280(s0)
ffffffffc0205b48:	10f43823          	sd	a5,272(s0)
ffffffffc0205b4c:	12042023          	sw	zero,288(s0)
ffffffffc0205b50:	12043423          	sd	zero,296(s0)
ffffffffc0205b54:	12043823          	sd	zero,304(s0)
ffffffffc0205b58:	12043c23          	sd	zero,312(s0)
ffffffffc0205b5c:	14043023          	sd	zero,320(s0)
ffffffffc0205b60:	60a2                	ld	ra,8(sp)
ffffffffc0205b62:	8522                	mv	a0,s0
ffffffffc0205b64:	6402                	ld	s0,0(sp)
ffffffffc0205b66:	0141                	addi	sp,sp,16
ffffffffc0205b68:	8082                	ret

ffffffffc0205b6a <forkret>:
ffffffffc0205b6a:	00091797          	auipc	a5,0x91
ffffffffc0205b6e:	d567b783          	ld	a5,-682(a5) # ffffffffc02968c0 <current>
ffffffffc0205b72:	73c8                	ld	a0,160(a5)
ffffffffc0205b74:	fbefb06f          	j	ffffffffc0201332 <forkrets>

ffffffffc0205b78 <put_pgdir.isra.0>:
ffffffffc0205b78:	1141                	addi	sp,sp,-16
ffffffffc0205b7a:	e406                	sd	ra,8(sp)
ffffffffc0205b7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b80:	02f56e63          	bltu	a0,a5,ffffffffc0205bbc <put_pgdir.isra.0+0x44>
ffffffffc0205b84:	00091697          	auipc	a3,0x91
ffffffffc0205b88:	d346b683          	ld	a3,-716(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205b8c:	8d15                	sub	a0,a0,a3
ffffffffc0205b8e:	8131                	srli	a0,a0,0xc
ffffffffc0205b90:	00091797          	auipc	a5,0x91
ffffffffc0205b94:	d107b783          	ld	a5,-752(a5) # ffffffffc02968a0 <npage>
ffffffffc0205b98:	02f57f63          	bgeu	a0,a5,ffffffffc0205bd6 <put_pgdir.isra.0+0x5e>
ffffffffc0205b9c:	0000a697          	auipc	a3,0xa
ffffffffc0205ba0:	d046b683          	ld	a3,-764(a3) # ffffffffc020f8a0 <nbase>
ffffffffc0205ba4:	60a2                	ld	ra,8(sp)
ffffffffc0205ba6:	8d15                	sub	a0,a0,a3
ffffffffc0205ba8:	00091797          	auipc	a5,0x91
ffffffffc0205bac:	d007b783          	ld	a5,-768(a5) # ffffffffc02968a8 <pages>
ffffffffc0205bb0:	051a                	slli	a0,a0,0x6
ffffffffc0205bb2:	4585                	li	a1,1
ffffffffc0205bb4:	953e                	add	a0,a0,a5
ffffffffc0205bb6:	0141                	addi	sp,sp,16
ffffffffc0205bb8:	e7afc06f          	j	ffffffffc0202232 <free_pages>
ffffffffc0205bbc:	86aa                	mv	a3,a0
ffffffffc0205bbe:	00007617          	auipc	a2,0x7
ffffffffc0205bc2:	b7a60613          	addi	a2,a2,-1158 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc0205bc6:	07700593          	li	a1,119
ffffffffc0205bca:	00007517          	auipc	a0,0x7
ffffffffc0205bce:	aee50513          	addi	a0,a0,-1298 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0205bd2:	8cdfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205bd6:	00007617          	auipc	a2,0x7
ffffffffc0205bda:	b8a60613          	addi	a2,a2,-1142 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc0205bde:	06900593          	li	a1,105
ffffffffc0205be2:	00007517          	auipc	a0,0x7
ffffffffc0205be6:	ad650513          	addi	a0,a0,-1322 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0205bea:	8b5fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205bee <proc_run>:
ffffffffc0205bee:	7179                	addi	sp,sp,-48
ffffffffc0205bf0:	f026                	sd	s1,32(sp)
ffffffffc0205bf2:	00091497          	auipc	s1,0x91
ffffffffc0205bf6:	cce48493          	addi	s1,s1,-818 # ffffffffc02968c0 <current>
ffffffffc0205bfa:	6098                	ld	a4,0(s1)
ffffffffc0205bfc:	f406                	sd	ra,40(sp)
ffffffffc0205bfe:	ec4a                	sd	s2,24(sp)
ffffffffc0205c00:	02a70763          	beq	a4,a0,ffffffffc0205c2e <proc_run+0x40>
ffffffffc0205c04:	100027f3          	csrr	a5,sstatus
ffffffffc0205c08:	8b89                	andi	a5,a5,2
ffffffffc0205c0a:	4901                	li	s2,0
ffffffffc0205c0c:	ef85                	bnez	a5,ffffffffc0205c44 <proc_run+0x56>
ffffffffc0205c0e:	755c                	ld	a5,168(a0)
ffffffffc0205c10:	56fd                	li	a3,-1
ffffffffc0205c12:	16fe                	slli	a3,a3,0x3f
ffffffffc0205c14:	83b1                	srli	a5,a5,0xc
ffffffffc0205c16:	e088                	sd	a0,0(s1)
ffffffffc0205c18:	8fd5                	or	a5,a5,a3
ffffffffc0205c1a:	18079073          	csrw	satp,a5
ffffffffc0205c1e:	03050593          	addi	a1,a0,48
ffffffffc0205c22:	03070513          	addi	a0,a4,48
ffffffffc0205c26:	6a4010ef          	jal	ra,ffffffffc02072ca <switch_to>
ffffffffc0205c2a:	00091763          	bnez	s2,ffffffffc0205c38 <proc_run+0x4a>
ffffffffc0205c2e:	70a2                	ld	ra,40(sp)
ffffffffc0205c30:	7482                	ld	s1,32(sp)
ffffffffc0205c32:	6962                	ld	s2,24(sp)
ffffffffc0205c34:	6145                	addi	sp,sp,48
ffffffffc0205c36:	8082                	ret
ffffffffc0205c38:	70a2                	ld	ra,40(sp)
ffffffffc0205c3a:	7482                	ld	s1,32(sp)
ffffffffc0205c3c:	6962                	ld	s2,24(sp)
ffffffffc0205c3e:	6145                	addi	sp,sp,48
ffffffffc0205c40:	82cfb06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0205c44:	e42a                	sd	a0,8(sp)
ffffffffc0205c46:	82cfb0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205c4a:	6098                	ld	a4,0(s1)
ffffffffc0205c4c:	6522                	ld	a0,8(sp)
ffffffffc0205c4e:	4905                	li	s2,1
ffffffffc0205c50:	bf7d                	j	ffffffffc0205c0e <proc_run+0x20>

ffffffffc0205c52 <do_fork>:
ffffffffc0205c52:	7119                	addi	sp,sp,-128
ffffffffc0205c54:	ecce                	sd	s3,88(sp)
ffffffffc0205c56:	00091997          	auipc	s3,0x91
ffffffffc0205c5a:	c8298993          	addi	s3,s3,-894 # ffffffffc02968d8 <nr_process>
ffffffffc0205c5e:	0009a703          	lw	a4,0(s3)
ffffffffc0205c62:	fc86                	sd	ra,120(sp)
ffffffffc0205c64:	f8a2                	sd	s0,112(sp)
ffffffffc0205c66:	f4a6                	sd	s1,104(sp)
ffffffffc0205c68:	f0ca                	sd	s2,96(sp)
ffffffffc0205c6a:	e8d2                	sd	s4,80(sp)
ffffffffc0205c6c:	e4d6                	sd	s5,72(sp)
ffffffffc0205c6e:	e0da                	sd	s6,64(sp)
ffffffffc0205c70:	fc5e                	sd	s7,56(sp)
ffffffffc0205c72:	f862                	sd	s8,48(sp)
ffffffffc0205c74:	f466                	sd	s9,40(sp)
ffffffffc0205c76:	f06a                	sd	s10,32(sp)
ffffffffc0205c78:	ec6e                	sd	s11,24(sp)
ffffffffc0205c7a:	6785                	lui	a5,0x1
ffffffffc0205c7c:	32f75e63          	bge	a4,a5,ffffffffc0205fb8 <do_fork+0x366>
ffffffffc0205c80:	84aa                	mv	s1,a0
ffffffffc0205c82:	892e                	mv	s2,a1
ffffffffc0205c84:	8432                	mv	s0,a2
ffffffffc0205c86:	e4fff0ef          	jal	ra,ffffffffc0205ad4 <alloc_proc>
ffffffffc0205c8a:	8aaa                	mv	s5,a0
ffffffffc0205c8c:	34050963          	beqz	a0,ffffffffc0205fde <do_fork+0x38c>
ffffffffc0205c90:	00091b97          	auipc	s7,0x91
ffffffffc0205c94:	c30b8b93          	addi	s7,s7,-976 # ffffffffc02968c0 <current>
ffffffffc0205c98:	000bb783          	ld	a5,0(s7)
ffffffffc0205c9c:	4509                	li	a0,2
ffffffffc0205c9e:	02fab023          	sd	a5,32(s5) # 1020 <_binary_bin_swap_img_size-0x6ce0>
ffffffffc0205ca2:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205ca6:	d4efc0ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0205caa:	30050163          	beqz	a0,ffffffffc0205fac <do_fork+0x35a>
ffffffffc0205cae:	00091c17          	auipc	s8,0x91
ffffffffc0205cb2:	bfac0c13          	addi	s8,s8,-1030 # ffffffffc02968a8 <pages>
ffffffffc0205cb6:	000c3683          	ld	a3,0(s8)
ffffffffc0205cba:	00091c97          	auipc	s9,0x91
ffffffffc0205cbe:	be6c8c93          	addi	s9,s9,-1050 # ffffffffc02968a0 <npage>
ffffffffc0205cc2:	0000aa17          	auipc	s4,0xa
ffffffffc0205cc6:	bdea3a03          	ld	s4,-1058(s4) # ffffffffc020f8a0 <nbase>
ffffffffc0205cca:	40d506b3          	sub	a3,a0,a3
ffffffffc0205cce:	8699                	srai	a3,a3,0x6
ffffffffc0205cd0:	5b7d                	li	s6,-1
ffffffffc0205cd2:	000cb783          	ld	a5,0(s9)
ffffffffc0205cd6:	96d2                	add	a3,a3,s4
ffffffffc0205cd8:	00cb5b13          	srli	s6,s6,0xc
ffffffffc0205cdc:	0166f733          	and	a4,a3,s6
ffffffffc0205ce0:	06b2                	slli	a3,a3,0xc
ffffffffc0205ce2:	30f77563          	bgeu	a4,a5,ffffffffc0205fec <do_fork+0x39a>
ffffffffc0205ce6:	000bb703          	ld	a4,0(s7)
ffffffffc0205cea:	00091d97          	auipc	s11,0x91
ffffffffc0205cee:	bced8d93          	addi	s11,s11,-1074 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205cf2:	000db783          	ld	a5,0(s11)
ffffffffc0205cf6:	02873d03          	ld	s10,40(a4)
ffffffffc0205cfa:	96be                	add	a3,a3,a5
ffffffffc0205cfc:	00dab823          	sd	a3,16(s5)
ffffffffc0205d00:	020d0a63          	beqz	s10,ffffffffc0205d34 <do_fork+0xe2>
ffffffffc0205d04:	1004f793          	andi	a5,s1,256
ffffffffc0205d08:	1c078463          	beqz	a5,ffffffffc0205ed0 <do_fork+0x27e>
ffffffffc0205d0c:	030d2683          	lw	a3,48(s10)
ffffffffc0205d10:	018d3783          	ld	a5,24(s10)
ffffffffc0205d14:	c0200637          	lui	a2,0xc0200
ffffffffc0205d18:	2685                	addiw	a3,a3,1
ffffffffc0205d1a:	02dd2823          	sw	a3,48(s10)
ffffffffc0205d1e:	03aab423          	sd	s10,40(s5)
ffffffffc0205d22:	30c7e963          	bltu	a5,a2,ffffffffc0206034 <do_fork+0x3e2>
ffffffffc0205d26:	000db703          	ld	a4,0(s11)
ffffffffc0205d2a:	010ab683          	ld	a3,16(s5)
ffffffffc0205d2e:	8f99                	sub	a5,a5,a4
ffffffffc0205d30:	0afab423          	sd	a5,168(s5)
ffffffffc0205d34:	6789                	lui	a5,0x2
ffffffffc0205d36:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205d3a:	96be                	add	a3,a3,a5
ffffffffc0205d3c:	0adab023          	sd	a3,160(s5)
ffffffffc0205d40:	87b6                	mv	a5,a3
ffffffffc0205d42:	12040813          	addi	a6,s0,288
ffffffffc0205d46:	6008                	ld	a0,0(s0)
ffffffffc0205d48:	640c                	ld	a1,8(s0)
ffffffffc0205d4a:	6810                	ld	a2,16(s0)
ffffffffc0205d4c:	6c18                	ld	a4,24(s0)
ffffffffc0205d4e:	e388                	sd	a0,0(a5)
ffffffffc0205d50:	e78c                	sd	a1,8(a5)
ffffffffc0205d52:	eb90                	sd	a2,16(a5)
ffffffffc0205d54:	ef98                	sd	a4,24(a5)
ffffffffc0205d56:	02040413          	addi	s0,s0,32
ffffffffc0205d5a:	02078793          	addi	a5,a5,32
ffffffffc0205d5e:	ff0414e3          	bne	s0,a6,ffffffffc0205d46 <do_fork+0xf4>
ffffffffc0205d62:	0406b823          	sd	zero,80(a3)
ffffffffc0205d66:	00091363          	bnez	s2,ffffffffc0205d6c <do_fork+0x11a>
ffffffffc0205d6a:	8936                	mv	s2,a3
ffffffffc0205d6c:	0008b817          	auipc	a6,0x8b
ffffffffc0205d70:	2ec80813          	addi	a6,a6,748 # ffffffffc0291058 <last_pid.1>
ffffffffc0205d74:	00082783          	lw	a5,0(a6)
ffffffffc0205d78:	0126b823          	sd	s2,16(a3)
ffffffffc0205d7c:	00000717          	auipc	a4,0x0
ffffffffc0205d80:	dee70713          	addi	a4,a4,-530 # ffffffffc0205b6a <forkret>
ffffffffc0205d84:	0017851b          	addiw	a0,a5,1
ffffffffc0205d88:	02eab823          	sd	a4,48(s5)
ffffffffc0205d8c:	02dabc23          	sd	a3,56(s5)
ffffffffc0205d90:	00a82023          	sw	a0,0(a6)
ffffffffc0205d94:	6789                	lui	a5,0x2
ffffffffc0205d96:	1af55e63          	bge	a0,a5,ffffffffc0205f52 <do_fork+0x300>
ffffffffc0205d9a:	0008b317          	auipc	t1,0x8b
ffffffffc0205d9e:	2c230313          	addi	t1,t1,706 # ffffffffc029105c <next_safe.0>
ffffffffc0205da2:	00032783          	lw	a5,0(t1)
ffffffffc0205da6:	00090417          	auipc	s0,0x90
ffffffffc0205daa:	a1a40413          	addi	s0,s0,-1510 # ffffffffc02957c0 <proc_list>
ffffffffc0205dae:	06f54063          	blt	a0,a5,ffffffffc0205e0e <do_fork+0x1bc>
ffffffffc0205db2:	00090417          	auipc	s0,0x90
ffffffffc0205db6:	a0e40413          	addi	s0,s0,-1522 # ffffffffc02957c0 <proc_list>
ffffffffc0205dba:	00843e03          	ld	t3,8(s0)
ffffffffc0205dbe:	6789                	lui	a5,0x2
ffffffffc0205dc0:	00f32023          	sw	a5,0(t1)
ffffffffc0205dc4:	86aa                	mv	a3,a0
ffffffffc0205dc6:	4581                	li	a1,0
ffffffffc0205dc8:	6e89                	lui	t4,0x2
ffffffffc0205dca:	208e0563          	beq	t3,s0,ffffffffc0205fd4 <do_fork+0x382>
ffffffffc0205dce:	88ae                	mv	a7,a1
ffffffffc0205dd0:	87f2                	mv	a5,t3
ffffffffc0205dd2:	6609                	lui	a2,0x2
ffffffffc0205dd4:	a811                	j	ffffffffc0205de8 <do_fork+0x196>
ffffffffc0205dd6:	00e6d663          	bge	a3,a4,ffffffffc0205de2 <do_fork+0x190>
ffffffffc0205dda:	00c75463          	bge	a4,a2,ffffffffc0205de2 <do_fork+0x190>
ffffffffc0205dde:	863a                	mv	a2,a4
ffffffffc0205de0:	4885                	li	a7,1
ffffffffc0205de2:	679c                	ld	a5,8(a5)
ffffffffc0205de4:	00878d63          	beq	a5,s0,ffffffffc0205dfe <do_fork+0x1ac>
ffffffffc0205de8:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205dec:	fed715e3          	bne	a4,a3,ffffffffc0205dd6 <do_fork+0x184>
ffffffffc0205df0:	2685                	addiw	a3,a3,1
ffffffffc0205df2:	1ac6d863          	bge	a3,a2,ffffffffc0205fa2 <do_fork+0x350>
ffffffffc0205df6:	679c                	ld	a5,8(a5)
ffffffffc0205df8:	4585                	li	a1,1
ffffffffc0205dfa:	fe8797e3          	bne	a5,s0,ffffffffc0205de8 <do_fork+0x196>
ffffffffc0205dfe:	c581                	beqz	a1,ffffffffc0205e06 <do_fork+0x1b4>
ffffffffc0205e00:	00d82023          	sw	a3,0(a6)
ffffffffc0205e04:	8536                	mv	a0,a3
ffffffffc0205e06:	00088463          	beqz	a7,ffffffffc0205e0e <do_fork+0x1bc>
ffffffffc0205e0a:	00c32023          	sw	a2,0(t1)
ffffffffc0205e0e:	00aaa223          	sw	a0,4(s5)
ffffffffc0205e12:	45a9                	li	a1,10
ffffffffc0205e14:	2501                	sext.w	a0,a0
ffffffffc0205e16:	34a050ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc0205e1a:	02051793          	slli	a5,a0,0x20
ffffffffc0205e1e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205e22:	0008c797          	auipc	a5,0x8c
ffffffffc0205e26:	99e78793          	addi	a5,a5,-1634 # ffffffffc02917c0 <hash_list>
ffffffffc0205e2a:	953e                	add	a0,a0,a5
ffffffffc0205e2c:	650c                	ld	a1,8(a0)
ffffffffc0205e2e:	020ab683          	ld	a3,32(s5)
ffffffffc0205e32:	0d8a8793          	addi	a5,s5,216
ffffffffc0205e36:	e19c                	sd	a5,0(a1)
ffffffffc0205e38:	6410                	ld	a2,8(s0)
ffffffffc0205e3a:	e51c                	sd	a5,8(a0)
ffffffffc0205e3c:	7af8                	ld	a4,240(a3)
ffffffffc0205e3e:	0c8a8793          	addi	a5,s5,200
ffffffffc0205e42:	0ebab023          	sd	a1,224(s5)
ffffffffc0205e46:	0caabc23          	sd	a0,216(s5)
ffffffffc0205e4a:	e21c                	sd	a5,0(a2)
ffffffffc0205e4c:	e41c                	sd	a5,8(s0)
ffffffffc0205e4e:	0ccab823          	sd	a2,208(s5)
ffffffffc0205e52:	0c8ab423          	sd	s0,200(s5)
ffffffffc0205e56:	0e0abc23          	sd	zero,248(s5)
ffffffffc0205e5a:	10eab023          	sd	a4,256(s5)
ffffffffc0205e5e:	c319                	beqz	a4,ffffffffc0205e64 <do_fork+0x212>
ffffffffc0205e60:	0f573c23          	sd	s5,248(a4)
ffffffffc0205e64:	0009a783          	lw	a5,0(s3)
ffffffffc0205e68:	0f56b823          	sd	s5,240(a3)
ffffffffc0205e6c:	8556                	mv	a0,s5
ffffffffc0205e6e:	2785                	addiw	a5,a5,1
ffffffffc0205e70:	00f9a023          	sw	a5,0(s3)
ffffffffc0205e74:	5fa010ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc0205e78:	000bb783          	ld	a5,0(s7)
ffffffffc0205e7c:	004aa403          	lw	s0,4(s5)
ffffffffc0205e80:	1487b903          	ld	s2,328(a5)
ffffffffc0205e84:	1c090563          	beqz	s2,ffffffffc020604e <do_fork+0x3fc>
ffffffffc0205e88:	80ad                	srli	s1,s1,0xb
ffffffffc0205e8a:	8885                	andi	s1,s1,1
ffffffffc0205e8c:	e899                	bnez	s1,ffffffffc0205ea2 <do_fork+0x250>
ffffffffc0205e8e:	c40ff0ef          	jal	ra,ffffffffc02052ce <files_create>
ffffffffc0205e92:	84aa                	mv	s1,a0
ffffffffc0205e94:	cd61                	beqz	a0,ffffffffc0205f6c <do_fork+0x31a>
ffffffffc0205e96:	85ca                	mv	a1,s2
ffffffffc0205e98:	d6eff0ef          	jal	ra,ffffffffc0205406 <dup_files>
ffffffffc0205e9c:	8926                	mv	s2,s1
ffffffffc0205e9e:	10051963          	bnez	a0,ffffffffc0205fb0 <do_fork+0x35e>
ffffffffc0205ea2:	01092783          	lw	a5,16(s2)
ffffffffc0205ea6:	2785                	addiw	a5,a5,1
ffffffffc0205ea8:	00f92823          	sw	a5,16(s2)
ffffffffc0205eac:	152ab423          	sd	s2,328(s5)
ffffffffc0205eb0:	70e6                	ld	ra,120(sp)
ffffffffc0205eb2:	8522                	mv	a0,s0
ffffffffc0205eb4:	7446                	ld	s0,112(sp)
ffffffffc0205eb6:	74a6                	ld	s1,104(sp)
ffffffffc0205eb8:	7906                	ld	s2,96(sp)
ffffffffc0205eba:	69e6                	ld	s3,88(sp)
ffffffffc0205ebc:	6a46                	ld	s4,80(sp)
ffffffffc0205ebe:	6aa6                	ld	s5,72(sp)
ffffffffc0205ec0:	6b06                	ld	s6,64(sp)
ffffffffc0205ec2:	7be2                	ld	s7,56(sp)
ffffffffc0205ec4:	7c42                	ld	s8,48(sp)
ffffffffc0205ec6:	7ca2                	ld	s9,40(sp)
ffffffffc0205ec8:	7d02                	ld	s10,32(sp)
ffffffffc0205eca:	6de2                	ld	s11,24(sp)
ffffffffc0205ecc:	6109                	addi	sp,sp,128
ffffffffc0205ece:	8082                	ret
ffffffffc0205ed0:	dc1fd0ef          	jal	ra,ffffffffc0203c90 <mm_create>
ffffffffc0205ed4:	e02a                	sd	a0,0(sp)
ffffffffc0205ed6:	10050963          	beqz	a0,ffffffffc0205fe8 <do_fork+0x396>
ffffffffc0205eda:	4505                	li	a0,1
ffffffffc0205edc:	b18fc0ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc0205ee0:	c151                	beqz	a0,ffffffffc0205f64 <do_fork+0x312>
ffffffffc0205ee2:	000c3683          	ld	a3,0(s8)
ffffffffc0205ee6:	000cb783          	ld	a5,0(s9)
ffffffffc0205eea:	40d506b3          	sub	a3,a0,a3
ffffffffc0205eee:	8699                	srai	a3,a3,0x6
ffffffffc0205ef0:	96d2                	add	a3,a3,s4
ffffffffc0205ef2:	0166fb33          	and	s6,a3,s6
ffffffffc0205ef6:	06b2                	slli	a3,a3,0xc
ffffffffc0205ef8:	0efb7a63          	bgeu	s6,a5,ffffffffc0205fec <do_fork+0x39a>
ffffffffc0205efc:	000dbb03          	ld	s6,0(s11)
ffffffffc0205f00:	6605                	lui	a2,0x1
ffffffffc0205f02:	00091597          	auipc	a1,0x91
ffffffffc0205f06:	9965b583          	ld	a1,-1642(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0205f0a:	9b36                	add	s6,s6,a3
ffffffffc0205f0c:	855a                	mv	a0,s6
ffffffffc0205f0e:	7d8050ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0205f12:	6702                	ld	a4,0(sp)
ffffffffc0205f14:	038d0793          	addi	a5,s10,56
ffffffffc0205f18:	853e                	mv	a0,a5
ffffffffc0205f1a:	01673c23          	sd	s6,24(a4)
ffffffffc0205f1e:	e43e                	sd	a5,8(sp)
ffffffffc0205f20:	f44fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0205f24:	000bb683          	ld	a3,0(s7)
ffffffffc0205f28:	67a2                	ld	a5,8(sp)
ffffffffc0205f2a:	c681                	beqz	a3,ffffffffc0205f32 <do_fork+0x2e0>
ffffffffc0205f2c:	42d4                	lw	a3,4(a3)
ffffffffc0205f2e:	04dd2823          	sw	a3,80(s10)
ffffffffc0205f32:	6502                	ld	a0,0(sp)
ffffffffc0205f34:	85ea                	mv	a1,s10
ffffffffc0205f36:	e43e                	sd	a5,8(sp)
ffffffffc0205f38:	fa9fd0ef          	jal	ra,ffffffffc0203ee0 <dup_mmap>
ffffffffc0205f3c:	67a2                	ld	a5,8(sp)
ffffffffc0205f3e:	8b2a                	mv	s6,a0
ffffffffc0205f40:	853e                	mv	a0,a5
ffffffffc0205f42:	f1efe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0205f46:	040d2823          	sw	zero,80(s10)
ffffffffc0205f4a:	060b1963          	bnez	s6,ffffffffc0205fbc <do_fork+0x36a>
ffffffffc0205f4e:	6d02                	ld	s10,0(sp)
ffffffffc0205f50:	bb75                	j	ffffffffc0205d0c <do_fork+0xba>
ffffffffc0205f52:	4785                	li	a5,1
ffffffffc0205f54:	00f82023          	sw	a5,0(a6)
ffffffffc0205f58:	4505                	li	a0,1
ffffffffc0205f5a:	0008b317          	auipc	t1,0x8b
ffffffffc0205f5e:	10230313          	addi	t1,t1,258 # ffffffffc029105c <next_safe.0>
ffffffffc0205f62:	bd81                	j	ffffffffc0205db2 <do_fork+0x160>
ffffffffc0205f64:	6502                	ld	a0,0(sp)
ffffffffc0205f66:	5471                	li	s0,-4
ffffffffc0205f68:	e77fd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc0205f6c:	010ab683          	ld	a3,16(s5)
ffffffffc0205f70:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f74:	0af6e463          	bltu	a3,a5,ffffffffc020601c <do_fork+0x3ca>
ffffffffc0205f78:	000db703          	ld	a4,0(s11)
ffffffffc0205f7c:	000cb783          	ld	a5,0(s9)
ffffffffc0205f80:	8e99                	sub	a3,a3,a4
ffffffffc0205f82:	82b1                	srli	a3,a3,0xc
ffffffffc0205f84:	08f6f063          	bgeu	a3,a5,ffffffffc0206004 <do_fork+0x3b2>
ffffffffc0205f88:	000c3503          	ld	a0,0(s8)
ffffffffc0205f8c:	414686b3          	sub	a3,a3,s4
ffffffffc0205f90:	069a                	slli	a3,a3,0x6
ffffffffc0205f92:	4589                	li	a1,2
ffffffffc0205f94:	9536                	add	a0,a0,a3
ffffffffc0205f96:	a9cfc0ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0205f9a:	8556                	mv	a0,s5
ffffffffc0205f9c:	92afc0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0205fa0:	bf01                	j	ffffffffc0205eb0 <do_fork+0x25e>
ffffffffc0205fa2:	01d6c363          	blt	a3,t4,ffffffffc0205fa8 <do_fork+0x356>
ffffffffc0205fa6:	4685                	li	a3,1
ffffffffc0205fa8:	4585                	li	a1,1
ffffffffc0205faa:	b505                	j	ffffffffc0205dca <do_fork+0x178>
ffffffffc0205fac:	5471                	li	s0,-4
ffffffffc0205fae:	b7f5                	j	ffffffffc0205f9a <do_fork+0x348>
ffffffffc0205fb0:	8526                	mv	a0,s1
ffffffffc0205fb2:	b52ff0ef          	jal	ra,ffffffffc0205304 <files_destroy>
ffffffffc0205fb6:	bf5d                	j	ffffffffc0205f6c <do_fork+0x31a>
ffffffffc0205fb8:	546d                	li	s0,-5
ffffffffc0205fba:	bddd                	j	ffffffffc0205eb0 <do_fork+0x25e>
ffffffffc0205fbc:	6482                	ld	s1,0(sp)
ffffffffc0205fbe:	5471                	li	s0,-4
ffffffffc0205fc0:	8526                	mv	a0,s1
ffffffffc0205fc2:	fb9fd0ef          	jal	ra,ffffffffc0203f7a <exit_mmap>
ffffffffc0205fc6:	6c88                	ld	a0,24(s1)
ffffffffc0205fc8:	bb1ff0ef          	jal	ra,ffffffffc0205b78 <put_pgdir.isra.0>
ffffffffc0205fcc:	8526                	mv	a0,s1
ffffffffc0205fce:	e11fd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc0205fd2:	bf69                	j	ffffffffc0205f6c <do_fork+0x31a>
ffffffffc0205fd4:	c599                	beqz	a1,ffffffffc0205fe2 <do_fork+0x390>
ffffffffc0205fd6:	00d82023          	sw	a3,0(a6)
ffffffffc0205fda:	8536                	mv	a0,a3
ffffffffc0205fdc:	bd0d                	j	ffffffffc0205e0e <do_fork+0x1bc>
ffffffffc0205fde:	5471                	li	s0,-4
ffffffffc0205fe0:	bdc1                	j	ffffffffc0205eb0 <do_fork+0x25e>
ffffffffc0205fe2:	00082503          	lw	a0,0(a6)
ffffffffc0205fe6:	b525                	j	ffffffffc0205e0e <do_fork+0x1bc>
ffffffffc0205fe8:	5471                	li	s0,-4
ffffffffc0205fea:	b749                	j	ffffffffc0205f6c <do_fork+0x31a>
ffffffffc0205fec:	00006617          	auipc	a2,0x6
ffffffffc0205ff0:	6a460613          	addi	a2,a2,1700 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0205ff4:	07100593          	li	a1,113
ffffffffc0205ff8:	00006517          	auipc	a0,0x6
ffffffffc0205ffc:	6c050513          	addi	a0,a0,1728 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0206000:	c9efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206004:	00006617          	auipc	a2,0x6
ffffffffc0206008:	75c60613          	addi	a2,a2,1884 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc020600c:	06900593          	li	a1,105
ffffffffc0206010:	00006517          	auipc	a0,0x6
ffffffffc0206014:	6a850513          	addi	a0,a0,1704 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0206018:	c86fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020601c:	00006617          	auipc	a2,0x6
ffffffffc0206020:	71c60613          	addi	a2,a2,1820 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc0206024:	07700593          	li	a1,119
ffffffffc0206028:	00006517          	auipc	a0,0x6
ffffffffc020602c:	69050513          	addi	a0,a0,1680 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0206030:	c6efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206034:	86be                	mv	a3,a5
ffffffffc0206036:	00006617          	auipc	a2,0x6
ffffffffc020603a:	70260613          	addi	a2,a2,1794 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc020603e:	1c700593          	li	a1,455
ffffffffc0206042:	00007517          	auipc	a0,0x7
ffffffffc0206046:	62e50513          	addi	a0,a0,1582 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020604a:	c54fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020604e:	00007697          	auipc	a3,0x7
ffffffffc0206052:	63a68693          	addi	a3,a3,1594 # ffffffffc020d688 <CSWTCH.79+0x108>
ffffffffc0206056:	00006617          	auipc	a2,0x6
ffffffffc020605a:	b2260613          	addi	a2,a2,-1246 # ffffffffc020bb78 <commands+0x210>
ffffffffc020605e:	1e700593          	li	a1,487
ffffffffc0206062:	00007517          	auipc	a0,0x7
ffffffffc0206066:	60e50513          	addi	a0,a0,1550 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020606a:	c34fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020606e <kernel_thread>:
ffffffffc020606e:	7129                	addi	sp,sp,-320
ffffffffc0206070:	fa22                	sd	s0,304(sp)
ffffffffc0206072:	f626                	sd	s1,296(sp)
ffffffffc0206074:	f24a                	sd	s2,288(sp)
ffffffffc0206076:	84ae                	mv	s1,a1
ffffffffc0206078:	892a                	mv	s2,a0
ffffffffc020607a:	8432                	mv	s0,a2
ffffffffc020607c:	4581                	li	a1,0
ffffffffc020607e:	12000613          	li	a2,288
ffffffffc0206082:	850a                	mv	a0,sp
ffffffffc0206084:	fe06                	sd	ra,312(sp)
ffffffffc0206086:	60e050ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc020608a:	e0ca                	sd	s2,64(sp)
ffffffffc020608c:	e4a6                	sd	s1,72(sp)
ffffffffc020608e:	100027f3          	csrr	a5,sstatus
ffffffffc0206092:	edd7f793          	andi	a5,a5,-291
ffffffffc0206096:	1207e793          	ori	a5,a5,288
ffffffffc020609a:	e23e                	sd	a5,256(sp)
ffffffffc020609c:	860a                	mv	a2,sp
ffffffffc020609e:	10046513          	ori	a0,s0,256
ffffffffc02060a2:	00000797          	auipc	a5,0x0
ffffffffc02060a6:	a2a78793          	addi	a5,a5,-1494 # ffffffffc0205acc <kernel_thread_entry>
ffffffffc02060aa:	4581                	li	a1,0
ffffffffc02060ac:	e63e                	sd	a5,264(sp)
ffffffffc02060ae:	ba5ff0ef          	jal	ra,ffffffffc0205c52 <do_fork>
ffffffffc02060b2:	70f2                	ld	ra,312(sp)
ffffffffc02060b4:	7452                	ld	s0,304(sp)
ffffffffc02060b6:	74b2                	ld	s1,296(sp)
ffffffffc02060b8:	7912                	ld	s2,288(sp)
ffffffffc02060ba:	6131                	addi	sp,sp,320
ffffffffc02060bc:	8082                	ret

ffffffffc02060be <do_exit>:
ffffffffc02060be:	7179                	addi	sp,sp,-48
ffffffffc02060c0:	f022                	sd	s0,32(sp)
ffffffffc02060c2:	00090417          	auipc	s0,0x90
ffffffffc02060c6:	7fe40413          	addi	s0,s0,2046 # ffffffffc02968c0 <current>
ffffffffc02060ca:	601c                	ld	a5,0(s0)
ffffffffc02060cc:	f406                	sd	ra,40(sp)
ffffffffc02060ce:	ec26                	sd	s1,24(sp)
ffffffffc02060d0:	e84a                	sd	s2,16(sp)
ffffffffc02060d2:	e44e                	sd	s3,8(sp)
ffffffffc02060d4:	e052                	sd	s4,0(sp)
ffffffffc02060d6:	00090717          	auipc	a4,0x90
ffffffffc02060da:	7f273703          	ld	a4,2034(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02060de:	0ee78763          	beq	a5,a4,ffffffffc02061cc <do_exit+0x10e>
ffffffffc02060e2:	00090497          	auipc	s1,0x90
ffffffffc02060e6:	7ee48493          	addi	s1,s1,2030 # ffffffffc02968d0 <initproc>
ffffffffc02060ea:	6098                	ld	a4,0(s1)
ffffffffc02060ec:	10e78763          	beq	a5,a4,ffffffffc02061fa <do_exit+0x13c>
ffffffffc02060f0:	0287b983          	ld	s3,40(a5)
ffffffffc02060f4:	892a                	mv	s2,a0
ffffffffc02060f6:	02098e63          	beqz	s3,ffffffffc0206132 <do_exit+0x74>
ffffffffc02060fa:	00090797          	auipc	a5,0x90
ffffffffc02060fe:	7967b783          	ld	a5,1942(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206102:	577d                	li	a4,-1
ffffffffc0206104:	177e                	slli	a4,a4,0x3f
ffffffffc0206106:	83b1                	srli	a5,a5,0xc
ffffffffc0206108:	8fd9                	or	a5,a5,a4
ffffffffc020610a:	18079073          	csrw	satp,a5
ffffffffc020610e:	0309a783          	lw	a5,48(s3)
ffffffffc0206112:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206116:	02e9a823          	sw	a4,48(s3)
ffffffffc020611a:	c769                	beqz	a4,ffffffffc02061e4 <do_exit+0x126>
ffffffffc020611c:	601c                	ld	a5,0(s0)
ffffffffc020611e:	1487b503          	ld	a0,328(a5)
ffffffffc0206122:	0207b423          	sd	zero,40(a5)
ffffffffc0206126:	c511                	beqz	a0,ffffffffc0206132 <do_exit+0x74>
ffffffffc0206128:	491c                	lw	a5,16(a0)
ffffffffc020612a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020612e:	c918                	sw	a4,16(a0)
ffffffffc0206130:	cb59                	beqz	a4,ffffffffc02061c6 <do_exit+0x108>
ffffffffc0206132:	601c                	ld	a5,0(s0)
ffffffffc0206134:	470d                	li	a4,3
ffffffffc0206136:	c398                	sw	a4,0(a5)
ffffffffc0206138:	0f27a423          	sw	s2,232(a5)
ffffffffc020613c:	100027f3          	csrr	a5,sstatus
ffffffffc0206140:	8b89                	andi	a5,a5,2
ffffffffc0206142:	4a01                	li	s4,0
ffffffffc0206144:	e7f9                	bnez	a5,ffffffffc0206212 <do_exit+0x154>
ffffffffc0206146:	6018                	ld	a4,0(s0)
ffffffffc0206148:	800007b7          	lui	a5,0x80000
ffffffffc020614c:	0785                	addi	a5,a5,1
ffffffffc020614e:	7308                	ld	a0,32(a4)
ffffffffc0206150:	0ec52703          	lw	a4,236(a0)
ffffffffc0206154:	0cf70363          	beq	a4,a5,ffffffffc020621a <do_exit+0x15c>
ffffffffc0206158:	6018                	ld	a4,0(s0)
ffffffffc020615a:	7b7c                	ld	a5,240(a4)
ffffffffc020615c:	c3a1                	beqz	a5,ffffffffc020619c <do_exit+0xde>
ffffffffc020615e:	800009b7          	lui	s3,0x80000
ffffffffc0206162:	490d                	li	s2,3
ffffffffc0206164:	0985                	addi	s3,s3,1
ffffffffc0206166:	a021                	j	ffffffffc020616e <do_exit+0xb0>
ffffffffc0206168:	6018                	ld	a4,0(s0)
ffffffffc020616a:	7b7c                	ld	a5,240(a4)
ffffffffc020616c:	cb85                	beqz	a5,ffffffffc020619c <do_exit+0xde>
ffffffffc020616e:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc0206172:	6088                	ld	a0,0(s1)
ffffffffc0206174:	fb74                	sd	a3,240(a4)
ffffffffc0206176:	7978                	ld	a4,240(a0)
ffffffffc0206178:	0e07bc23          	sd	zero,248(a5)
ffffffffc020617c:	10e7b023          	sd	a4,256(a5)
ffffffffc0206180:	c311                	beqz	a4,ffffffffc0206184 <do_exit+0xc6>
ffffffffc0206182:	ff7c                	sd	a5,248(a4)
ffffffffc0206184:	4398                	lw	a4,0(a5)
ffffffffc0206186:	f388                	sd	a0,32(a5)
ffffffffc0206188:	f97c                	sd	a5,240(a0)
ffffffffc020618a:	fd271fe3          	bne	a4,s2,ffffffffc0206168 <do_exit+0xaa>
ffffffffc020618e:	0ec52783          	lw	a5,236(a0)
ffffffffc0206192:	fd379be3          	bne	a5,s3,ffffffffc0206168 <do_exit+0xaa>
ffffffffc0206196:	2d8010ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc020619a:	b7f9                	j	ffffffffc0206168 <do_exit+0xaa>
ffffffffc020619c:	020a1263          	bnez	s4,ffffffffc02061c0 <do_exit+0x102>
ffffffffc02061a0:	380010ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc02061a4:	601c                	ld	a5,0(s0)
ffffffffc02061a6:	00007617          	auipc	a2,0x7
ffffffffc02061aa:	51a60613          	addi	a2,a2,1306 # ffffffffc020d6c0 <CSWTCH.79+0x140>
ffffffffc02061ae:	2c900593          	li	a1,713
ffffffffc02061b2:	43d4                	lw	a3,4(a5)
ffffffffc02061b4:	00007517          	auipc	a0,0x7
ffffffffc02061b8:	4bc50513          	addi	a0,a0,1212 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02061bc:	ae2fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061c0:	aadfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02061c4:	bff1                	j	ffffffffc02061a0 <do_exit+0xe2>
ffffffffc02061c6:	93eff0ef          	jal	ra,ffffffffc0205304 <files_destroy>
ffffffffc02061ca:	b7a5                	j	ffffffffc0206132 <do_exit+0x74>
ffffffffc02061cc:	00007617          	auipc	a2,0x7
ffffffffc02061d0:	4d460613          	addi	a2,a2,1236 # ffffffffc020d6a0 <CSWTCH.79+0x120>
ffffffffc02061d4:	29400593          	li	a1,660
ffffffffc02061d8:	00007517          	auipc	a0,0x7
ffffffffc02061dc:	49850513          	addi	a0,a0,1176 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02061e0:	abefa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061e4:	854e                	mv	a0,s3
ffffffffc02061e6:	d95fd0ef          	jal	ra,ffffffffc0203f7a <exit_mmap>
ffffffffc02061ea:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc02061ee:	98bff0ef          	jal	ra,ffffffffc0205b78 <put_pgdir.isra.0>
ffffffffc02061f2:	854e                	mv	a0,s3
ffffffffc02061f4:	bebfd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc02061f8:	b715                	j	ffffffffc020611c <do_exit+0x5e>
ffffffffc02061fa:	00007617          	auipc	a2,0x7
ffffffffc02061fe:	4b660613          	addi	a2,a2,1206 # ffffffffc020d6b0 <CSWTCH.79+0x130>
ffffffffc0206202:	29800593          	li	a1,664
ffffffffc0206206:	00007517          	auipc	a0,0x7
ffffffffc020620a:	46a50513          	addi	a0,a0,1130 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020620e:	a90fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206212:	a61fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206216:	4a05                	li	s4,1
ffffffffc0206218:	b73d                	j	ffffffffc0206146 <do_exit+0x88>
ffffffffc020621a:	254010ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc020621e:	bf2d                	j	ffffffffc0206158 <do_exit+0x9a>

ffffffffc0206220 <do_wait.part.0>:
ffffffffc0206220:	715d                	addi	sp,sp,-80
ffffffffc0206222:	f84a                	sd	s2,48(sp)
ffffffffc0206224:	f44e                	sd	s3,40(sp)
ffffffffc0206226:	80000937          	lui	s2,0x80000
ffffffffc020622a:	6989                	lui	s3,0x2
ffffffffc020622c:	fc26                	sd	s1,56(sp)
ffffffffc020622e:	f052                	sd	s4,32(sp)
ffffffffc0206230:	ec56                	sd	s5,24(sp)
ffffffffc0206232:	e85a                	sd	s6,16(sp)
ffffffffc0206234:	e45e                	sd	s7,8(sp)
ffffffffc0206236:	e486                	sd	ra,72(sp)
ffffffffc0206238:	e0a2                	sd	s0,64(sp)
ffffffffc020623a:	84aa                	mv	s1,a0
ffffffffc020623c:	8a2e                	mv	s4,a1
ffffffffc020623e:	00090b97          	auipc	s7,0x90
ffffffffc0206242:	682b8b93          	addi	s7,s7,1666 # ffffffffc02968c0 <current>
ffffffffc0206246:	00050b1b          	sext.w	s6,a0
ffffffffc020624a:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020624e:	19f9                	addi	s3,s3,-2
ffffffffc0206250:	0905                	addi	s2,s2,1
ffffffffc0206252:	ccbd                	beqz	s1,ffffffffc02062d0 <do_wait.part.0+0xb0>
ffffffffc0206254:	0359e863          	bltu	s3,s5,ffffffffc0206284 <do_wait.part.0+0x64>
ffffffffc0206258:	45a9                	li	a1,10
ffffffffc020625a:	855a                	mv	a0,s6
ffffffffc020625c:	705040ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc0206260:	02051793          	slli	a5,a0,0x20
ffffffffc0206264:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206268:	0008b797          	auipc	a5,0x8b
ffffffffc020626c:	55878793          	addi	a5,a5,1368 # ffffffffc02917c0 <hash_list>
ffffffffc0206270:	953e                	add	a0,a0,a5
ffffffffc0206272:	842a                	mv	s0,a0
ffffffffc0206274:	a029                	j	ffffffffc020627e <do_wait.part.0+0x5e>
ffffffffc0206276:	f2c42783          	lw	a5,-212(s0)
ffffffffc020627a:	02978163          	beq	a5,s1,ffffffffc020629c <do_wait.part.0+0x7c>
ffffffffc020627e:	6400                	ld	s0,8(s0)
ffffffffc0206280:	fe851be3          	bne	a0,s0,ffffffffc0206276 <do_wait.part.0+0x56>
ffffffffc0206284:	5579                	li	a0,-2
ffffffffc0206286:	60a6                	ld	ra,72(sp)
ffffffffc0206288:	6406                	ld	s0,64(sp)
ffffffffc020628a:	74e2                	ld	s1,56(sp)
ffffffffc020628c:	7942                	ld	s2,48(sp)
ffffffffc020628e:	79a2                	ld	s3,40(sp)
ffffffffc0206290:	7a02                	ld	s4,32(sp)
ffffffffc0206292:	6ae2                	ld	s5,24(sp)
ffffffffc0206294:	6b42                	ld	s6,16(sp)
ffffffffc0206296:	6ba2                	ld	s7,8(sp)
ffffffffc0206298:	6161                	addi	sp,sp,80
ffffffffc020629a:	8082                	ret
ffffffffc020629c:	000bb683          	ld	a3,0(s7)
ffffffffc02062a0:	f4843783          	ld	a5,-184(s0)
ffffffffc02062a4:	fed790e3          	bne	a5,a3,ffffffffc0206284 <do_wait.part.0+0x64>
ffffffffc02062a8:	f2842703          	lw	a4,-216(s0)
ffffffffc02062ac:	478d                	li	a5,3
ffffffffc02062ae:	0ef70b63          	beq	a4,a5,ffffffffc02063a4 <do_wait.part.0+0x184>
ffffffffc02062b2:	4785                	li	a5,1
ffffffffc02062b4:	c29c                	sw	a5,0(a3)
ffffffffc02062b6:	0f26a623          	sw	s2,236(a3)
ffffffffc02062ba:	266010ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc02062be:	000bb783          	ld	a5,0(s7)
ffffffffc02062c2:	0b07a783          	lw	a5,176(a5)
ffffffffc02062c6:	8b85                	andi	a5,a5,1
ffffffffc02062c8:	d7c9                	beqz	a5,ffffffffc0206252 <do_wait.part.0+0x32>
ffffffffc02062ca:	555d                	li	a0,-9
ffffffffc02062cc:	df3ff0ef          	jal	ra,ffffffffc02060be <do_exit>
ffffffffc02062d0:	000bb683          	ld	a3,0(s7)
ffffffffc02062d4:	7ae0                	ld	s0,240(a3)
ffffffffc02062d6:	d45d                	beqz	s0,ffffffffc0206284 <do_wait.part.0+0x64>
ffffffffc02062d8:	470d                	li	a4,3
ffffffffc02062da:	a021                	j	ffffffffc02062e2 <do_wait.part.0+0xc2>
ffffffffc02062dc:	10043403          	ld	s0,256(s0)
ffffffffc02062e0:	d869                	beqz	s0,ffffffffc02062b2 <do_wait.part.0+0x92>
ffffffffc02062e2:	401c                	lw	a5,0(s0)
ffffffffc02062e4:	fee79ce3          	bne	a5,a4,ffffffffc02062dc <do_wait.part.0+0xbc>
ffffffffc02062e8:	00090797          	auipc	a5,0x90
ffffffffc02062ec:	5e07b783          	ld	a5,1504(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02062f0:	0c878963          	beq	a5,s0,ffffffffc02063c2 <do_wait.part.0+0x1a2>
ffffffffc02062f4:	00090797          	auipc	a5,0x90
ffffffffc02062f8:	5dc7b783          	ld	a5,1500(a5) # ffffffffc02968d0 <initproc>
ffffffffc02062fc:	0cf40363          	beq	s0,a5,ffffffffc02063c2 <do_wait.part.0+0x1a2>
ffffffffc0206300:	000a0663          	beqz	s4,ffffffffc020630c <do_wait.part.0+0xec>
ffffffffc0206304:	0e842783          	lw	a5,232(s0)
ffffffffc0206308:	00fa2023          	sw	a5,0(s4)
ffffffffc020630c:	100027f3          	csrr	a5,sstatus
ffffffffc0206310:	8b89                	andi	a5,a5,2
ffffffffc0206312:	4581                	li	a1,0
ffffffffc0206314:	e7c1                	bnez	a5,ffffffffc020639c <do_wait.part.0+0x17c>
ffffffffc0206316:	6c70                	ld	a2,216(s0)
ffffffffc0206318:	7074                	ld	a3,224(s0)
ffffffffc020631a:	10043703          	ld	a4,256(s0)
ffffffffc020631e:	7c7c                	ld	a5,248(s0)
ffffffffc0206320:	e614                	sd	a3,8(a2)
ffffffffc0206322:	e290                	sd	a2,0(a3)
ffffffffc0206324:	6470                	ld	a2,200(s0)
ffffffffc0206326:	6874                	ld	a3,208(s0)
ffffffffc0206328:	e614                	sd	a3,8(a2)
ffffffffc020632a:	e290                	sd	a2,0(a3)
ffffffffc020632c:	c319                	beqz	a4,ffffffffc0206332 <do_wait.part.0+0x112>
ffffffffc020632e:	ff7c                	sd	a5,248(a4)
ffffffffc0206330:	7c7c                	ld	a5,248(s0)
ffffffffc0206332:	c3b5                	beqz	a5,ffffffffc0206396 <do_wait.part.0+0x176>
ffffffffc0206334:	10e7b023          	sd	a4,256(a5)
ffffffffc0206338:	00090717          	auipc	a4,0x90
ffffffffc020633c:	5a070713          	addi	a4,a4,1440 # ffffffffc02968d8 <nr_process>
ffffffffc0206340:	431c                	lw	a5,0(a4)
ffffffffc0206342:	37fd                	addiw	a5,a5,-1
ffffffffc0206344:	c31c                	sw	a5,0(a4)
ffffffffc0206346:	e5a9                	bnez	a1,ffffffffc0206390 <do_wait.part.0+0x170>
ffffffffc0206348:	6814                	ld	a3,16(s0)
ffffffffc020634a:	c02007b7          	lui	a5,0xc0200
ffffffffc020634e:	04f6ee63          	bltu	a3,a5,ffffffffc02063aa <do_wait.part.0+0x18a>
ffffffffc0206352:	00090797          	auipc	a5,0x90
ffffffffc0206356:	5667b783          	ld	a5,1382(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc020635a:	8e9d                	sub	a3,a3,a5
ffffffffc020635c:	82b1                	srli	a3,a3,0xc
ffffffffc020635e:	00090797          	auipc	a5,0x90
ffffffffc0206362:	5427b783          	ld	a5,1346(a5) # ffffffffc02968a0 <npage>
ffffffffc0206366:	06f6fa63          	bgeu	a3,a5,ffffffffc02063da <do_wait.part.0+0x1ba>
ffffffffc020636a:	00009517          	auipc	a0,0x9
ffffffffc020636e:	53653503          	ld	a0,1334(a0) # ffffffffc020f8a0 <nbase>
ffffffffc0206372:	8e89                	sub	a3,a3,a0
ffffffffc0206374:	069a                	slli	a3,a3,0x6
ffffffffc0206376:	00090517          	auipc	a0,0x90
ffffffffc020637a:	53253503          	ld	a0,1330(a0) # ffffffffc02968a8 <pages>
ffffffffc020637e:	9536                	add	a0,a0,a3
ffffffffc0206380:	4589                	li	a1,2
ffffffffc0206382:	eb1fb0ef          	jal	ra,ffffffffc0202232 <free_pages>
ffffffffc0206386:	8522                	mv	a0,s0
ffffffffc0206388:	d3ffb0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020638c:	4501                	li	a0,0
ffffffffc020638e:	bde5                	j	ffffffffc0206286 <do_wait.part.0+0x66>
ffffffffc0206390:	8ddfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206394:	bf55                	j	ffffffffc0206348 <do_wait.part.0+0x128>
ffffffffc0206396:	701c                	ld	a5,32(s0)
ffffffffc0206398:	fbf8                	sd	a4,240(a5)
ffffffffc020639a:	bf79                	j	ffffffffc0206338 <do_wait.part.0+0x118>
ffffffffc020639c:	8d7fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02063a0:	4585                	li	a1,1
ffffffffc02063a2:	bf95                	j	ffffffffc0206316 <do_wait.part.0+0xf6>
ffffffffc02063a4:	f2840413          	addi	s0,s0,-216
ffffffffc02063a8:	b781                	j	ffffffffc02062e8 <do_wait.part.0+0xc8>
ffffffffc02063aa:	00006617          	auipc	a2,0x6
ffffffffc02063ae:	38e60613          	addi	a2,a2,910 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc02063b2:	07700593          	li	a1,119
ffffffffc02063b6:	00006517          	auipc	a0,0x6
ffffffffc02063ba:	30250513          	addi	a0,a0,770 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02063be:	8e0fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02063c2:	00007617          	auipc	a2,0x7
ffffffffc02063c6:	31e60613          	addi	a2,a2,798 # ffffffffc020d6e0 <CSWTCH.79+0x160>
ffffffffc02063ca:	4c900593          	li	a1,1225
ffffffffc02063ce:	00007517          	auipc	a0,0x7
ffffffffc02063d2:	2a250513          	addi	a0,a0,674 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02063d6:	8c8fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02063da:	00006617          	auipc	a2,0x6
ffffffffc02063de:	38660613          	addi	a2,a2,902 # ffffffffc020c760 <default_pmm_manager+0x108>
ffffffffc02063e2:	06900593          	li	a1,105
ffffffffc02063e6:	00006517          	auipc	a0,0x6
ffffffffc02063ea:	2d250513          	addi	a0,a0,722 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc02063ee:	8b0fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02063f2 <init_main>:
ffffffffc02063f2:	1141                	addi	sp,sp,-16
ffffffffc02063f4:	00007517          	auipc	a0,0x7
ffffffffc02063f8:	30c50513          	addi	a0,a0,780 # ffffffffc020d700 <CSWTCH.79+0x180>
ffffffffc02063fc:	e406                	sd	ra,8(sp)
ffffffffc02063fe:	093010ef          	jal	ra,ffffffffc0207c90 <vfs_set_bootfs>
ffffffffc0206402:	e179                	bnez	a0,ffffffffc02064c8 <init_main+0xd6>
ffffffffc0206404:	e6ffb0ef          	jal	ra,ffffffffc0202272 <nr_free_pages>
ffffffffc0206408:	c0bfb0ef          	jal	ra,ffffffffc0202012 <kallocated>
ffffffffc020640c:	4601                	li	a2,0
ffffffffc020640e:	4581                	li	a1,0
ffffffffc0206410:	00001517          	auipc	a0,0x1
ffffffffc0206414:	ab850513          	addi	a0,a0,-1352 # ffffffffc0206ec8 <user_main>
ffffffffc0206418:	c57ff0ef          	jal	ra,ffffffffc020606e <kernel_thread>
ffffffffc020641c:	00a04563          	bgtz	a0,ffffffffc0206426 <init_main+0x34>
ffffffffc0206420:	a841                	j	ffffffffc02064b0 <init_main+0xbe>
ffffffffc0206422:	0fe010ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc0206426:	4581                	li	a1,0
ffffffffc0206428:	4501                	li	a0,0
ffffffffc020642a:	df7ff0ef          	jal	ra,ffffffffc0206220 <do_wait.part.0>
ffffffffc020642e:	d975                	beqz	a0,ffffffffc0206422 <init_main+0x30>
ffffffffc0206430:	e8ffe0ef          	jal	ra,ffffffffc02052be <fs_cleanup>
ffffffffc0206434:	00007517          	auipc	a0,0x7
ffffffffc0206438:	31450513          	addi	a0,a0,788 # ffffffffc020d748 <CSWTCH.79+0x1c8>
ffffffffc020643c:	d6bf90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206440:	00090797          	auipc	a5,0x90
ffffffffc0206444:	4907b783          	ld	a5,1168(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206448:	7bf8                	ld	a4,240(a5)
ffffffffc020644a:	e339                	bnez	a4,ffffffffc0206490 <init_main+0x9e>
ffffffffc020644c:	7ff8                	ld	a4,248(a5)
ffffffffc020644e:	e329                	bnez	a4,ffffffffc0206490 <init_main+0x9e>
ffffffffc0206450:	1007b703          	ld	a4,256(a5)
ffffffffc0206454:	ef15                	bnez	a4,ffffffffc0206490 <init_main+0x9e>
ffffffffc0206456:	00090697          	auipc	a3,0x90
ffffffffc020645a:	4826a683          	lw	a3,1154(a3) # ffffffffc02968d8 <nr_process>
ffffffffc020645e:	4709                	li	a4,2
ffffffffc0206460:	0ce69163          	bne	a3,a4,ffffffffc0206522 <init_main+0x130>
ffffffffc0206464:	0008f717          	auipc	a4,0x8f
ffffffffc0206468:	35c70713          	addi	a4,a4,860 # ffffffffc02957c0 <proc_list>
ffffffffc020646c:	6714                	ld	a3,8(a4)
ffffffffc020646e:	0c878793          	addi	a5,a5,200
ffffffffc0206472:	08d79863          	bne	a5,a3,ffffffffc0206502 <init_main+0x110>
ffffffffc0206476:	6318                	ld	a4,0(a4)
ffffffffc0206478:	06e79563          	bne	a5,a4,ffffffffc02064e2 <init_main+0xf0>
ffffffffc020647c:	00007517          	auipc	a0,0x7
ffffffffc0206480:	3b450513          	addi	a0,a0,948 # ffffffffc020d830 <CSWTCH.79+0x2b0>
ffffffffc0206484:	d23f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206488:	60a2                	ld	ra,8(sp)
ffffffffc020648a:	4501                	li	a0,0
ffffffffc020648c:	0141                	addi	sp,sp,16
ffffffffc020648e:	8082                	ret
ffffffffc0206490:	00007697          	auipc	a3,0x7
ffffffffc0206494:	2e068693          	addi	a3,a3,736 # ffffffffc020d770 <CSWTCH.79+0x1f0>
ffffffffc0206498:	00005617          	auipc	a2,0x5
ffffffffc020649c:	6e060613          	addi	a2,a2,1760 # ffffffffc020bb78 <commands+0x210>
ffffffffc02064a0:	53f00593          	li	a1,1343
ffffffffc02064a4:	00007517          	auipc	a0,0x7
ffffffffc02064a8:	1cc50513          	addi	a0,a0,460 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02064ac:	ff3f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064b0:	00007617          	auipc	a2,0x7
ffffffffc02064b4:	27860613          	addi	a2,a2,632 # ffffffffc020d728 <CSWTCH.79+0x1a8>
ffffffffc02064b8:	53200593          	li	a1,1330
ffffffffc02064bc:	00007517          	auipc	a0,0x7
ffffffffc02064c0:	1b450513          	addi	a0,a0,436 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02064c4:	fdbf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064c8:	86aa                	mv	a3,a0
ffffffffc02064ca:	00007617          	auipc	a2,0x7
ffffffffc02064ce:	23e60613          	addi	a2,a2,574 # ffffffffc020d708 <CSWTCH.79+0x188>
ffffffffc02064d2:	52a00593          	li	a1,1322
ffffffffc02064d6:	00007517          	auipc	a0,0x7
ffffffffc02064da:	19a50513          	addi	a0,a0,410 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02064de:	fc1f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064e2:	00007697          	auipc	a3,0x7
ffffffffc02064e6:	31e68693          	addi	a3,a3,798 # ffffffffc020d800 <CSWTCH.79+0x280>
ffffffffc02064ea:	00005617          	auipc	a2,0x5
ffffffffc02064ee:	68e60613          	addi	a2,a2,1678 # ffffffffc020bb78 <commands+0x210>
ffffffffc02064f2:	54200593          	li	a1,1346
ffffffffc02064f6:	00007517          	auipc	a0,0x7
ffffffffc02064fa:	17a50513          	addi	a0,a0,378 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02064fe:	fa1f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206502:	00007697          	auipc	a3,0x7
ffffffffc0206506:	2ce68693          	addi	a3,a3,718 # ffffffffc020d7d0 <CSWTCH.79+0x250>
ffffffffc020650a:	00005617          	auipc	a2,0x5
ffffffffc020650e:	66e60613          	addi	a2,a2,1646 # ffffffffc020bb78 <commands+0x210>
ffffffffc0206512:	54100593          	li	a1,1345
ffffffffc0206516:	00007517          	auipc	a0,0x7
ffffffffc020651a:	15a50513          	addi	a0,a0,346 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020651e:	f81f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206522:	00007697          	auipc	a3,0x7
ffffffffc0206526:	29e68693          	addi	a3,a3,670 # ffffffffc020d7c0 <CSWTCH.79+0x240>
ffffffffc020652a:	00005617          	auipc	a2,0x5
ffffffffc020652e:	64e60613          	addi	a2,a2,1614 # ffffffffc020bb78 <commands+0x210>
ffffffffc0206532:	54000593          	li	a1,1344
ffffffffc0206536:	00007517          	auipc	a0,0x7
ffffffffc020653a:	13a50513          	addi	a0,a0,314 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020653e:	f61f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206542 <do_execve>:
ffffffffc0206542:	bd010113          	addi	sp,sp,-1072
ffffffffc0206546:	3f513c23          	sd	s5,1016(sp)
ffffffffc020654a:	00090a97          	auipc	s5,0x90
ffffffffc020654e:	376a8a93          	addi	s5,s5,886 # ffffffffc02968c0 <current>
ffffffffc0206552:	000ab683          	ld	a3,0(s5)
ffffffffc0206556:	3f613823          	sd	s6,1008(sp)
ffffffffc020655a:	fff58b1b          	addiw	s6,a1,-1
ffffffffc020655e:	3f713423          	sd	s7,1000(sp)
ffffffffc0206562:	42113423          	sd	ra,1064(sp)
ffffffffc0206566:	42813023          	sd	s0,1056(sp)
ffffffffc020656a:	40913c23          	sd	s1,1048(sp)
ffffffffc020656e:	41213823          	sd	s2,1040(sp)
ffffffffc0206572:	41313423          	sd	s3,1032(sp)
ffffffffc0206576:	41413023          	sd	s4,1024(sp)
ffffffffc020657a:	3f813023          	sd	s8,992(sp)
ffffffffc020657e:	3d913c23          	sd	s9,984(sp)
ffffffffc0206582:	3da13823          	sd	s10,976(sp)
ffffffffc0206586:	3db13423          	sd	s11,968(sp)
ffffffffc020658a:	000b071b          	sext.w	a4,s6
ffffffffc020658e:	47fd                	li	a5,31
ffffffffc0206590:	0286bb83          	ld	s7,40(a3)
ffffffffc0206594:	60e7e263          	bltu	a5,a4,ffffffffc0206b98 <do_execve+0x656>
ffffffffc0206598:	842e                	mv	s0,a1
ffffffffc020659a:	84aa                	mv	s1,a0
ffffffffc020659c:	8c32                	mv	s8,a2
ffffffffc020659e:	4581                	li	a1,0
ffffffffc02065a0:	4641                	li	a2,16
ffffffffc02065a2:	10a8                	addi	a0,sp,104
ffffffffc02065a4:	0f0050ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc02065a8:	000b8c63          	beqz	s7,ffffffffc02065c0 <do_execve+0x7e>
ffffffffc02065ac:	038b8513          	addi	a0,s7,56
ffffffffc02065b0:	8b4fe0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02065b4:	000ab783          	ld	a5,0(s5)
ffffffffc02065b8:	c781                	beqz	a5,ffffffffc02065c0 <do_execve+0x7e>
ffffffffc02065ba:	43dc                	lw	a5,4(a5)
ffffffffc02065bc:	04fba823          	sw	a5,80(s7)
ffffffffc02065c0:	30048063          	beqz	s1,ffffffffc02068c0 <do_execve+0x37e>
ffffffffc02065c4:	46c1                	li	a3,16
ffffffffc02065c6:	8626                	mv	a2,s1
ffffffffc02065c8:	10ac                	addi	a1,sp,104
ffffffffc02065ca:	855e                	mv	a0,s7
ffffffffc02065cc:	e49fd0ef          	jal	ra,ffffffffc0204414 <copy_string>
ffffffffc02065d0:	6e050c63          	beqz	a0,ffffffffc0206cc8 <do_execve+0x786>
ffffffffc02065d4:	00341793          	slli	a5,s0,0x3
ffffffffc02065d8:	4681                	li	a3,0
ffffffffc02065da:	863e                	mv	a2,a5
ffffffffc02065dc:	85e2                	mv	a1,s8
ffffffffc02065de:	855e                	mv	a0,s7
ffffffffc02065e0:	e83e                	sd	a5,16(sp)
ffffffffc02065e2:	d39fd0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc02065e6:	89e2                	mv	s3,s8
ffffffffc02065e8:	6c050c63          	beqz	a0,ffffffffc0206cc0 <do_execve+0x77e>
ffffffffc02065ec:	0b810a13          	addi	s4,sp,184
ffffffffc02065f0:	4481                	li	s1,0
ffffffffc02065f2:	a011                	j	ffffffffc02065f6 <do_execve+0xb4>
ffffffffc02065f4:	84ea                	mv	s1,s10
ffffffffc02065f6:	6505                	lui	a0,0x1
ffffffffc02065f8:	a1ffb0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02065fc:	892a                	mv	s2,a0
ffffffffc02065fe:	22050e63          	beqz	a0,ffffffffc020683a <do_execve+0x2f8>
ffffffffc0206602:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0206606:	85aa                	mv	a1,a0
ffffffffc0206608:	6685                	lui	a3,0x1
ffffffffc020660a:	855e                	mv	a0,s7
ffffffffc020660c:	e09fd0ef          	jal	ra,ffffffffc0204414 <copy_string>
ffffffffc0206610:	2a050363          	beqz	a0,ffffffffc02068b6 <do_execve+0x374>
ffffffffc0206614:	012a3023          	sd	s2,0(s4)
ffffffffc0206618:	00148d1b          	addiw	s10,s1,1
ffffffffc020661c:	0a21                	addi	s4,s4,8
ffffffffc020661e:	09a1                	addi	s3,s3,8
ffffffffc0206620:	fda41ae3          	bne	s0,s10,ffffffffc02065f4 <do_execve+0xb2>
ffffffffc0206624:	000c3903          	ld	s2,0(s8)
ffffffffc0206628:	100b8d63          	beqz	s7,ffffffffc0206742 <do_execve+0x200>
ffffffffc020662c:	038b8513          	addi	a0,s7,56
ffffffffc0206630:	830fe0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0206634:	000ab703          	ld	a4,0(s5)
ffffffffc0206638:	040ba823          	sw	zero,80(s7)
ffffffffc020663c:	14873503          	ld	a0,328(a4)
ffffffffc0206640:	d5bfe0ef          	jal	ra,ffffffffc020539a <files_closeall>
ffffffffc0206644:	854a                	mv	a0,s2
ffffffffc0206646:	4581                	li	a1,0
ffffffffc0206648:	fdffe0ef          	jal	ra,ffffffffc0205626 <sysfile_open>
ffffffffc020664c:	892a                	mv	s2,a0
ffffffffc020664e:	28054563          	bltz	a0,ffffffffc02068d8 <do_execve+0x396>
ffffffffc0206652:	00090717          	auipc	a4,0x90
ffffffffc0206656:	23e73703          	ld	a4,574(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc020665a:	56fd                	li	a3,-1
ffffffffc020665c:	16fe                	slli	a3,a3,0x3f
ffffffffc020665e:	8331                	srli	a4,a4,0xc
ffffffffc0206660:	8f55                	or	a4,a4,a3
ffffffffc0206662:	18071073          	csrw	satp,a4
ffffffffc0206666:	030ba703          	lw	a4,48(s7)
ffffffffc020666a:	fff7069b          	addiw	a3,a4,-1
ffffffffc020666e:	02dba823          	sw	a3,48(s7)
ffffffffc0206672:	4e068a63          	beqz	a3,ffffffffc0206b66 <do_execve+0x624>
ffffffffc0206676:	000ab703          	ld	a4,0(s5)
ffffffffc020667a:	02073423          	sd	zero,40(a4)
ffffffffc020667e:	e12fd0ef          	jal	ra,ffffffffc0203c90 <mm_create>
ffffffffc0206682:	8a2a                	mv	s4,a0
ffffffffc0206684:	16050f63          	beqz	a0,ffffffffc0206802 <do_execve+0x2c0>
ffffffffc0206688:	4505                	li	a0,1
ffffffffc020668a:	b6bfb0ef          	jal	ra,ffffffffc02021f4 <alloc_pages>
ffffffffc020668e:	16050763          	beqz	a0,ffffffffc02067fc <do_execve+0x2ba>
ffffffffc0206692:	00090c17          	auipc	s8,0x90
ffffffffc0206696:	216c0c13          	addi	s8,s8,534 # ffffffffc02968a8 <pages>
ffffffffc020669a:	000c3683          	ld	a3,0(s8)
ffffffffc020669e:	00090717          	auipc	a4,0x90
ffffffffc02066a2:	20270713          	addi	a4,a4,514 # ffffffffc02968a0 <npage>
ffffffffc02066a6:	00009797          	auipc	a5,0x9
ffffffffc02066aa:	1fa7b783          	ld	a5,506(a5) # ffffffffc020f8a0 <nbase>
ffffffffc02066ae:	40d506b3          	sub	a3,a0,a3
ffffffffc02066b2:	8699                	srai	a3,a3,0x6
ffffffffc02066b4:	5bfd                	li	s7,-1
ffffffffc02066b6:	6318                	ld	a4,0(a4)
ffffffffc02066b8:	96be                	add	a3,a3,a5
ffffffffc02066ba:	e43e                	sd	a5,8(sp)
ffffffffc02066bc:	00cbd793          	srli	a5,s7,0xc
ffffffffc02066c0:	00f6f633          	and	a2,a3,a5
ffffffffc02066c4:	e03e                	sd	a5,0(sp)
ffffffffc02066c6:	06b2                	slli	a3,a3,0xc
ffffffffc02066c8:	70e67f63          	bgeu	a2,a4,ffffffffc0206de6 <do_execve+0x8a4>
ffffffffc02066cc:	00090c97          	auipc	s9,0x90
ffffffffc02066d0:	1ecc8c93          	addi	s9,s9,492 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02066d4:	000cb983          	ld	s3,0(s9)
ffffffffc02066d8:	6605                	lui	a2,0x1
ffffffffc02066da:	00090597          	auipc	a1,0x90
ffffffffc02066de:	1be5b583          	ld	a1,446(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc02066e2:	99b6                	add	s3,s3,a3
ffffffffc02066e4:	854e                	mv	a0,s3
ffffffffc02066e6:	000050ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc02066ea:	4601                	li	a2,0
ffffffffc02066ec:	013a3c23          	sd	s3,24(s4)
ffffffffc02066f0:	4581                	li	a1,0
ffffffffc02066f2:	854a                	mv	a0,s2
ffffffffc02066f4:	998ff0ef          	jal	ra,ffffffffc020588c <sysfile_seek>
ffffffffc02066f8:	8daa                	mv	s11,a0
ffffffffc02066fa:	e10d                	bnez	a0,ffffffffc020671c <do_execve+0x1da>
ffffffffc02066fc:	04000613          	li	a2,64
ffffffffc0206700:	18ac                	addi	a1,sp,120
ffffffffc0206702:	854a                	mv	a0,s2
ffffffffc0206704:	f5bfe0ef          	jal	ra,ffffffffc020565e <sysfile_read>
ffffffffc0206708:	04000713          	li	a4,64
ffffffffc020670c:	06e50963          	beq	a0,a4,ffffffffc020677e <do_execve+0x23c>
ffffffffc0206710:	87aa                	mv	a5,a0
ffffffffc0206712:	00054363          	bltz	a0,ffffffffc0206718 <do_execve+0x1d6>
ffffffffc0206716:	57fd                	li	a5,-1
ffffffffc0206718:	00078d9b          	sext.w	s11,a5
ffffffffc020671c:	1b02                	slli	s6,s6,0x20
ffffffffc020671e:	0a810893          	addi	a7,sp,168
ffffffffc0206722:	020b5b13          	srli	s6,s6,0x20
ffffffffc0206726:	018a3503          	ld	a0,24(s4)
ffffffffc020672a:	e046                	sd	a7,0(sp)
ffffffffc020672c:	c4cff0ef          	jal	ra,ffffffffc0205b78 <put_pgdir.isra.0>
ffffffffc0206730:	8552                	mv	a0,s4
ffffffffc0206732:	eacfd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc0206736:	854a                	mv	a0,s2
ffffffffc0206738:	f23fe0ef          	jal	ra,ffffffffc020565a <sysfile_close>
ffffffffc020673c:	6882                	ld	a7,0(sp)
ffffffffc020673e:	896e                	mv	s2,s11
ffffffffc0206740:	a8d1                	j	ffffffffc0206814 <do_execve+0x2d2>
ffffffffc0206742:	000ab703          	ld	a4,0(s5)
ffffffffc0206746:	14873503          	ld	a0,328(a4)
ffffffffc020674a:	c51fe0ef          	jal	ra,ffffffffc020539a <files_closeall>
ffffffffc020674e:	854a                	mv	a0,s2
ffffffffc0206750:	4581                	li	a1,0
ffffffffc0206752:	ed5fe0ef          	jal	ra,ffffffffc0205626 <sysfile_open>
ffffffffc0206756:	892a                	mv	s2,a0
ffffffffc0206758:	18054063          	bltz	a0,ffffffffc02068d8 <do_execve+0x396>
ffffffffc020675c:	000ab703          	ld	a4,0(s5)
ffffffffc0206760:	7718                	ld	a4,40(a4)
ffffffffc0206762:	f0070ee3          	beqz	a4,ffffffffc020667e <do_execve+0x13c>
ffffffffc0206766:	00007617          	auipc	a2,0x7
ffffffffc020676a:	0fa60613          	addi	a2,a2,250 # ffffffffc020d860 <CSWTCH.79+0x2e0>
ffffffffc020676e:	2fc00593          	li	a1,764
ffffffffc0206772:	00007517          	auipc	a0,0x7
ffffffffc0206776:	efe50513          	addi	a0,a0,-258 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020677a:	d25f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020677e:	56e6                	lw	a3,120(sp)
ffffffffc0206780:	464c4737          	lui	a4,0x464c4
ffffffffc0206784:	57f70713          	addi	a4,a4,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206788:	14e69e63          	bne	a3,a4,ffffffffc02068e4 <do_execve+0x3a2>
ffffffffc020678c:	0ae15683          	lhu	a3,174(sp)
ffffffffc0206790:	03800713          	li	a4,56
ffffffffc0206794:	14e69863          	bne	a3,a4,ffffffffc02068e4 <do_execve+0x3a2>
ffffffffc0206798:	0b015703          	lhu	a4,176(sp)
ffffffffc020679c:	e082                	sd	zero,64(sp)
ffffffffc020679e:	ec02                	sd	zero,24(sp)
ffffffffc02067a0:	18070963          	beqz	a4,ffffffffc0206932 <do_execve+0x3f0>
ffffffffc02067a4:	e8ea                	sd	s10,80(sp)
ffffffffc02067a6:	eca6                	sd	s1,88(sp)
ffffffffc02067a8:	e4ee                	sd	s11,72(sp)
ffffffffc02067aa:	f822                	sd	s0,48(sp)
ffffffffc02067ac:	dc5a                	sw	s6,56(sp)
ffffffffc02067ae:	65ea                	ld	a1,152(sp)
ffffffffc02067b0:	6786                	ld	a5,64(sp)
ffffffffc02067b2:	4601                	li	a2,0
ffffffffc02067b4:	854a                	mv	a0,s2
ffffffffc02067b6:	95be                	add	a1,a1,a5
ffffffffc02067b8:	8d4ff0ef          	jal	ra,ffffffffc020588c <sysfile_seek>
ffffffffc02067bc:	3a051263          	bnez	a0,ffffffffc0206b60 <do_execve+0x61e>
ffffffffc02067c0:	03800613          	li	a2,56
ffffffffc02067c4:	1d2c                	addi	a1,sp,696
ffffffffc02067c6:	854a                	mv	a0,s2
ffffffffc02067c8:	e97fe0ef          	jal	ra,ffffffffc020565e <sysfile_read>
ffffffffc02067cc:	03800793          	li	a5,56
ffffffffc02067d0:	12f50d63          	beq	a0,a5,ffffffffc020690a <do_execve+0x3c8>
ffffffffc02067d4:	7442                	ld	s0,48(sp)
ffffffffc02067d6:	5b62                	lw	s6,56(sp)
ffffffffc02067d8:	87aa                	mv	a5,a0
ffffffffc02067da:	00054363          	bltz	a0,ffffffffc02067e0 <do_execve+0x29e>
ffffffffc02067de:	57fd                	li	a5,-1
ffffffffc02067e0:	0007851b          	sext.w	a0,a5
ffffffffc02067e4:	8daa                	mv	s11,a0
ffffffffc02067e6:	1b02                	slli	s6,s6,0x20
ffffffffc02067e8:	0a810893          	addi	a7,sp,168
ffffffffc02067ec:	020b5b13          	srli	s6,s6,0x20
ffffffffc02067f0:	8552                	mv	a0,s4
ffffffffc02067f2:	e046                	sd	a7,0(sp)
ffffffffc02067f4:	f86fd0ef          	jal	ra,ffffffffc0203f7a <exit_mmap>
ffffffffc02067f8:	6882                	ld	a7,0(sp)
ffffffffc02067fa:	b735                	j	ffffffffc0206726 <do_execve+0x1e4>
ffffffffc02067fc:	8552                	mv	a0,s4
ffffffffc02067fe:	de0fd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc0206802:	854a                	mv	a0,s2
ffffffffc0206804:	e57fe0ef          	jal	ra,ffffffffc020565a <sysfile_close>
ffffffffc0206808:	1b02                	slli	s6,s6,0x20
ffffffffc020680a:	5971                	li	s2,-4
ffffffffc020680c:	0a810893          	addi	a7,sp,168
ffffffffc0206810:	020b5b13          	srli	s6,s6,0x20
ffffffffc0206814:	67c2                	ld	a5,16(sp)
ffffffffc0206816:	147d                	addi	s0,s0,-1
ffffffffc0206818:	040e                	slli	s0,s0,0x3
ffffffffc020681a:	00f88733          	add	a4,a7,a5
ffffffffc020681e:	0b0e                	slli	s6,s6,0x3
ffffffffc0206820:	193c                	addi	a5,sp,184
ffffffffc0206822:	943e                	add	s0,s0,a5
ffffffffc0206824:	41670b33          	sub	s6,a4,s6
ffffffffc0206828:	6008                	ld	a0,0(s0)
ffffffffc020682a:	1461                	addi	s0,s0,-8
ffffffffc020682c:	89bfb0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0206830:	fe8b1ce3          	bne	s6,s0,ffffffffc0206828 <do_execve+0x2e6>
ffffffffc0206834:	854a                	mv	a0,s2
ffffffffc0206836:	889ff0ef          	jal	ra,ffffffffc02060be <do_exit>
ffffffffc020683a:	5df1                	li	s11,-4
ffffffffc020683c:	c49d                	beqz	s1,ffffffffc020686a <do_execve+0x328>
ffffffffc020683e:	00349713          	slli	a4,s1,0x3
ffffffffc0206842:	fff48413          	addi	s0,s1,-1
ffffffffc0206846:	113c                	addi	a5,sp,168
ffffffffc0206848:	34fd                	addiw	s1,s1,-1
ffffffffc020684a:	97ba                	add	a5,a5,a4
ffffffffc020684c:	02049713          	slli	a4,s1,0x20
ffffffffc0206850:	01d75493          	srli	s1,a4,0x1d
ffffffffc0206854:	040e                	slli	s0,s0,0x3
ffffffffc0206856:	1938                	addi	a4,sp,184
ffffffffc0206858:	943a                	add	s0,s0,a4
ffffffffc020685a:	409784b3          	sub	s1,a5,s1
ffffffffc020685e:	6008                	ld	a0,0(s0)
ffffffffc0206860:	1461                	addi	s0,s0,-8
ffffffffc0206862:	865fb0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0206866:	fe849ce3          	bne	s1,s0,ffffffffc020685e <do_execve+0x31c>
ffffffffc020686a:	000b8863          	beqz	s7,ffffffffc020687a <do_execve+0x338>
ffffffffc020686e:	038b8513          	addi	a0,s7,56
ffffffffc0206872:	deffd0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0206876:	040ba823          	sw	zero,80(s7)
ffffffffc020687a:	42813083          	ld	ra,1064(sp)
ffffffffc020687e:	42013403          	ld	s0,1056(sp)
ffffffffc0206882:	41813483          	ld	s1,1048(sp)
ffffffffc0206886:	41013903          	ld	s2,1040(sp)
ffffffffc020688a:	40813983          	ld	s3,1032(sp)
ffffffffc020688e:	40013a03          	ld	s4,1024(sp)
ffffffffc0206892:	3f813a83          	ld	s5,1016(sp)
ffffffffc0206896:	3f013b03          	ld	s6,1008(sp)
ffffffffc020689a:	3e813b83          	ld	s7,1000(sp)
ffffffffc020689e:	3e013c03          	ld	s8,992(sp)
ffffffffc02068a2:	3d813c83          	ld	s9,984(sp)
ffffffffc02068a6:	3d013d03          	ld	s10,976(sp)
ffffffffc02068aa:	856e                	mv	a0,s11
ffffffffc02068ac:	3c813d83          	ld	s11,968(sp)
ffffffffc02068b0:	43010113          	addi	sp,sp,1072
ffffffffc02068b4:	8082                	ret
ffffffffc02068b6:	854a                	mv	a0,s2
ffffffffc02068b8:	80ffb0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc02068bc:	5df5                	li	s11,-3
ffffffffc02068be:	bfbd                	j	ffffffffc020683c <do_execve+0x2fa>
ffffffffc02068c0:	000ab783          	ld	a5,0(s5)
ffffffffc02068c4:	00007617          	auipc	a2,0x7
ffffffffc02068c8:	f8c60613          	addi	a2,a2,-116 # ffffffffc020d850 <CSWTCH.79+0x2d0>
ffffffffc02068cc:	45c1                	li	a1,16
ffffffffc02068ce:	43d4                	lw	a3,4(a5)
ffffffffc02068d0:	10a8                	addi	a0,sp,104
ffffffffc02068d2:	4d3040ef          	jal	ra,ffffffffc020b5a4 <snprintf>
ffffffffc02068d6:	b9fd                	j	ffffffffc02065d4 <do_execve+0x92>
ffffffffc02068d8:	1b02                	slli	s6,s6,0x20
ffffffffc02068da:	0a810893          	addi	a7,sp,168
ffffffffc02068de:	020b5b13          	srli	s6,s6,0x20
ffffffffc02068e2:	bf0d                	j	ffffffffc0206814 <do_execve+0x2d2>
ffffffffc02068e4:	018a3503          	ld	a0,24(s4)
ffffffffc02068e8:	0a810893          	addi	a7,sp,168
ffffffffc02068ec:	e046                	sd	a7,0(sp)
ffffffffc02068ee:	a8aff0ef          	jal	ra,ffffffffc0205b78 <put_pgdir.isra.0>
ffffffffc02068f2:	8552                	mv	a0,s4
ffffffffc02068f4:	ceafd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc02068f8:	854a                	mv	a0,s2
ffffffffc02068fa:	1b02                	slli	s6,s6,0x20
ffffffffc02068fc:	d5ffe0ef          	jal	ra,ffffffffc020565a <sysfile_close>
ffffffffc0206900:	6882                	ld	a7,0(sp)
ffffffffc0206902:	020b5b13          	srli	s6,s6,0x20
ffffffffc0206906:	5961                	li	s2,-8
ffffffffc0206908:	b731                	j	ffffffffc0206814 <do_execve+0x2d2>
ffffffffc020690a:	2b812783          	lw	a5,696(sp)
ffffffffc020690e:	4705                	li	a4,1
ffffffffc0206910:	16e78a63          	beq	a5,a4,ffffffffc0206a84 <do_execve+0x542>
ffffffffc0206914:	6726                	ld	a4,72(sp)
ffffffffc0206916:	6686                	ld	a3,64(sp)
ffffffffc0206918:	0b015783          	lhu	a5,176(sp)
ffffffffc020691c:	2705                	addiw	a4,a4,1
ffffffffc020691e:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206922:	e4ba                	sd	a4,72(sp)
ffffffffc0206924:	e0b6                	sd	a3,64(sp)
ffffffffc0206926:	e8f744e3          	blt	a4,a5,ffffffffc02067ae <do_execve+0x26c>
ffffffffc020692a:	6d46                	ld	s10,80(sp)
ffffffffc020692c:	64e6                	ld	s1,88(sp)
ffffffffc020692e:	7442                	ld	s0,48(sp)
ffffffffc0206930:	5b62                	lw	s6,56(sp)
ffffffffc0206932:	4701                	li	a4,0
ffffffffc0206934:	46ad                	li	a3,11
ffffffffc0206936:	00100637          	lui	a2,0x100
ffffffffc020693a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc020693e:	8552                	mv	a0,s4
ffffffffc0206940:	cf0fd0ef          	jal	ra,ffffffffc0203e30 <mm_map>
ffffffffc0206944:	8daa                	mv	s11,a0
ffffffffc0206946:	ea0510e3          	bnez	a0,ffffffffc02067e6 <do_execve+0x2a4>
ffffffffc020694a:	018a3503          	ld	a0,24(s4)
ffffffffc020694e:	467d                	li	a2,31
ffffffffc0206950:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206954:	a56fd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc0206958:	38050763          	beqz	a0,ffffffffc0206ce6 <do_execve+0x7a4>
ffffffffc020695c:	018a3503          	ld	a0,24(s4)
ffffffffc0206960:	467d                	li	a2,31
ffffffffc0206962:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206966:	a44fd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc020696a:	36050e63          	beqz	a0,ffffffffc0206ce6 <do_execve+0x7a4>
ffffffffc020696e:	018a3503          	ld	a0,24(s4)
ffffffffc0206972:	467d                	li	a2,31
ffffffffc0206974:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206978:	a32fd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc020697c:	36050563          	beqz	a0,ffffffffc0206ce6 <do_execve+0x7a4>
ffffffffc0206980:	018a3503          	ld	a0,24(s4)
ffffffffc0206984:	467d                	li	a2,31
ffffffffc0206986:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020698a:	a20fd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc020698e:	34050c63          	beqz	a0,ffffffffc0206ce6 <do_execve+0x7a4>
ffffffffc0206992:	6742                	ld	a4,16(sp)
ffffffffc0206994:	0a810893          	addi	a7,sp,168
ffffffffc0206998:	1b02                	slli	s6,s6,0x20
ffffffffc020699a:	ff870793          	addi	a5,a4,-8
ffffffffc020699e:	00e889b3          	add	s3,a7,a4
ffffffffc02069a2:	1938                	addi	a4,sp,184
ffffffffc02069a4:	973e                	add	a4,a4,a5
ffffffffc02069a6:	020b5b13          	srli	s6,s6,0x20
ffffffffc02069aa:	003b1693          	slli	a3,s6,0x3
ffffffffc02069ae:	e03a                	sd	a4,0(sp)
ffffffffc02069b0:	1b38                	addi	a4,sp,440
ffffffffc02069b2:	97ba                	add	a5,a5,a4
ffffffffc02069b4:	40d989b3          	sub	s3,s3,a3
ffffffffc02069b8:	4b85                	li	s7,1
ffffffffc02069ba:	56fd                	li	a3,-1
ffffffffc02069bc:	fc3e                	sd	a5,56(sp)
ffffffffc02069be:	00c6d713          	srli	a4,a3,0xc
ffffffffc02069c2:	01fb9793          	slli	a5,s7,0x1f
ffffffffc02069c6:	f022                	sd	s0,32(sp)
ffffffffc02069c8:	e0ba                	sd	a4,64(sp)
ffffffffc02069ca:	e8ea                	sd	s10,80(sp)
ffffffffc02069cc:	ec4a                	sd	s2,24(sp)
ffffffffc02069ce:	eca6                	sd	s1,88(sp)
ffffffffc02069d0:	843e                	mv	s0,a5
ffffffffc02069d2:	f45a                	sd	s6,40(sp)
ffffffffc02069d4:	f846                	sd	a7,48(sp)
ffffffffc02069d6:	6782                	ld	a5,0(sp)
ffffffffc02069d8:	0007bb83          	ld	s7,0(a5)
ffffffffc02069dc:	855e                	mv	a0,s7
ffffffffc02069de:	415040ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc02069e2:	00150493          	addi	s1,a0,1
ffffffffc02069e6:	409407b3          	sub	a5,s0,s1
ffffffffc02069ea:	e4be                	sd	a5,72(sp)
ffffffffc02069ec:	ff87f413          	andi	s0,a5,-8
ffffffffc02069f0:	7ff007b7          	lui	a5,0x7ff00
ffffffffc02069f4:	40f46963          	bltu	s0,a5,ffffffffc0206e06 <do_execve+0x8c4>
ffffffffc02069f8:	8922                	mv	s2,s0
ffffffffc02069fa:	8b26                	mv	s6,s1
ffffffffc02069fc:	e8b9                	bnez	s1,ffffffffc0206a52 <do_execve+0x510>
ffffffffc02069fe:	acdd                	j	ffffffffc0206cf4 <do_execve+0x7b2>
ffffffffc0206a00:	41248d33          	sub	s10,s1,s2
ffffffffc0206a04:	6705                	lui	a4,0x1
ffffffffc0206a06:	9d3a                	add	s10,s10,a4
ffffffffc0206a08:	40990533          	sub	a0,s2,s1
ffffffffc0206a0c:	01ab7363          	bgeu	s6,s10,ffffffffc0206a12 <do_execve+0x4d0>
ffffffffc0206a10:	8d5a                	mv	s10,s6
ffffffffc0206a12:	000c3683          	ld	a3,0(s8)
ffffffffc0206a16:	00090717          	auipc	a4,0x90
ffffffffc0206a1a:	e8a70713          	addi	a4,a4,-374 # ffffffffc02968a0 <npage>
ffffffffc0206a1e:	6310                	ld	a2,0(a4)
ffffffffc0206a20:	6722                	ld	a4,8(sp)
ffffffffc0206a22:	8f95                	sub	a5,a5,a3
ffffffffc0206a24:	8799                	srai	a5,a5,0x6
ffffffffc0206a26:	97ba                	add	a5,a5,a4
ffffffffc0206a28:	6706                	ld	a4,64(sp)
ffffffffc0206a2a:	00c79693          	slli	a3,a5,0xc
ffffffffc0206a2e:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206a32:	3ac5fa63          	bgeu	a1,a2,ffffffffc0206de6 <do_execve+0x8a4>
ffffffffc0206a36:	000cb783          	ld	a5,0(s9)
ffffffffc0206a3a:	85de                	mv	a1,s7
ffffffffc0206a3c:	866a                	mv	a2,s10
ffffffffc0206a3e:	97b6                	add	a5,a5,a3
ffffffffc0206a40:	953e                	add	a0,a0,a5
ffffffffc0206a42:	41ab0b33          	sub	s6,s6,s10
ffffffffc0206a46:	4a1040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0206a4a:	996a                	add	s2,s2,s10
ffffffffc0206a4c:	9bea                	add	s7,s7,s10
ffffffffc0206a4e:	2a0b0363          	beqz	s6,ffffffffc0206cf4 <do_execve+0x7b2>
ffffffffc0206a52:	77fd                	lui	a5,0xfffff
ffffffffc0206a54:	018a3503          	ld	a0,24(s4)
ffffffffc0206a58:	00f974b3          	and	s1,s2,a5
ffffffffc0206a5c:	4601                	li	a2,0
ffffffffc0206a5e:	85a6                	mv	a1,s1
ffffffffc0206a60:	b3bfb0ef          	jal	ra,ffffffffc020259a <get_page>
ffffffffc0206a64:	87aa                	mv	a5,a0
ffffffffc0206a66:	fd49                	bnez	a0,ffffffffc0206a00 <do_execve+0x4be>
ffffffffc0206a68:	018a3503          	ld	a0,24(s4)
ffffffffc0206a6c:	467d                	li	a2,31
ffffffffc0206a6e:	85a6                	mv	a1,s1
ffffffffc0206a70:	93afd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc0206a74:	87aa                	mv	a5,a0
ffffffffc0206a76:	f549                	bnez	a0,ffffffffc0206a00 <do_execve+0x4be>
ffffffffc0206a78:	6962                	ld	s2,24(sp)
ffffffffc0206a7a:	7402                	ld	s0,32(sp)
ffffffffc0206a7c:	7b22                	ld	s6,40(sp)
ffffffffc0206a7e:	78c2                	ld	a7,48(sp)
ffffffffc0206a80:	5df1                	li	s11,-4
ffffffffc0206a82:	b3bd                	j	ffffffffc02067f0 <do_execve+0x2ae>
ffffffffc0206a84:	2e013603          	ld	a2,736(sp)
ffffffffc0206a88:	2d813783          	ld	a5,728(sp)
ffffffffc0206a8c:	36f66963          	bltu	a2,a5,ffffffffc0206dfe <do_execve+0x8bc>
ffffffffc0206a90:	2bc12783          	lw	a5,700(sp)
ffffffffc0206a94:	0027f713          	andi	a4,a5,2
ffffffffc0206a98:	0017f693          	andi	a3,a5,1
ffffffffc0206a9c:	e365                	bnez	a4,ffffffffc0206b7c <do_execve+0x63a>
ffffffffc0206a9e:	c291                	beqz	a3,ffffffffc0206aa2 <do_execve+0x560>
ffffffffc0206aa0:	4691                	li	a3,4
ffffffffc0206aa2:	8b91                	andi	a5,a5,4
ffffffffc0206aa4:	1e079d63          	bnez	a5,ffffffffc0206c9e <do_execve+0x75c>
ffffffffc0206aa8:	05100793          	li	a5,81
ffffffffc0206aac:	f43e                	sd	a5,40(sp)
ffffffffc0206aae:	0046f793          	andi	a5,a3,4
ffffffffc0206ab2:	c789                	beqz	a5,ffffffffc0206abc <do_execve+0x57a>
ffffffffc0206ab4:	77a2                	ld	a5,40(sp)
ffffffffc0206ab6:	0087e793          	ori	a5,a5,8
ffffffffc0206aba:	f43e                	sd	a5,40(sp)
ffffffffc0206abc:	2c813583          	ld	a1,712(sp)
ffffffffc0206ac0:	4701                	li	a4,0
ffffffffc0206ac2:	8552                	mv	a0,s4
ffffffffc0206ac4:	b6cfd0ef          	jal	ra,ffffffffc0203e30 <mm_map>
ffffffffc0206ac8:	ed41                	bnez	a0,ffffffffc0206b60 <do_execve+0x61e>
ffffffffc0206aca:	2c813403          	ld	s0,712(sp)
ffffffffc0206ace:	2d813b83          	ld	s7,728(sp)
ffffffffc0206ad2:	76fd                	lui	a3,0xfffff
ffffffffc0206ad4:	2c013983          	ld	s3,704(sp)
ffffffffc0206ad8:	9ba2                	add	s7,s7,s0
ffffffffc0206ada:	00d47db3          	and	s11,s0,a3
ffffffffc0206ade:	03746363          	bltu	s0,s7,ffffffffc0206b04 <do_execve+0x5c2>
ffffffffc0206ae2:	aafd                	j	ffffffffc0206ce0 <do_execve+0x79e>
ffffffffc0206ae4:	6762                	ld	a4,24(sp)
ffffffffc0206ae6:	7782                	ld	a5,32(sp)
ffffffffc0206ae8:	409405b3          	sub	a1,s0,s1
ffffffffc0206aec:	866a                	mv	a2,s10
ffffffffc0206aee:	97ba                	add	a5,a5,a4
ffffffffc0206af0:	95be                	add	a1,a1,a5
ffffffffc0206af2:	854a                	mv	a0,s2
ffffffffc0206af4:	b6bfe0ef          	jal	ra,ffffffffc020565e <sysfile_read>
ffffffffc0206af8:	ccad1ee3          	bne	s10,a0,ffffffffc02067d4 <do_execve+0x292>
ffffffffc0206afc:	946a                	add	s0,s0,s10
ffffffffc0206afe:	99ea                	add	s3,s3,s10
ffffffffc0206b00:	11747863          	bgeu	s0,s7,ffffffffc0206c10 <do_execve+0x6ce>
ffffffffc0206b04:	018a3503          	ld	a0,24(s4)
ffffffffc0206b08:	7622                	ld	a2,40(sp)
ffffffffc0206b0a:	85ee                	mv	a1,s11
ffffffffc0206b0c:	84ee                	mv	s1,s11
ffffffffc0206b0e:	89cfd0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc0206b12:	8b2a                	mv	s6,a0
ffffffffc0206b14:	0e050a63          	beqz	a0,ffffffffc0206c08 <do_execve+0x6c6>
ffffffffc0206b18:	6785                	lui	a5,0x1
ffffffffc0206b1a:	9dbe                	add	s11,s11,a5
ffffffffc0206b1c:	408d8d33          	sub	s10,s11,s0
ffffffffc0206b20:	01bbf463          	bgeu	s7,s11,ffffffffc0206b28 <do_execve+0x5e6>
ffffffffc0206b24:	408b8d33          	sub	s10,s7,s0
ffffffffc0206b28:	000c3783          	ld	a5,0(s8)
ffffffffc0206b2c:	00090717          	auipc	a4,0x90
ffffffffc0206b30:	d7470713          	addi	a4,a4,-652 # ffffffffc02968a0 <npage>
ffffffffc0206b34:	6310                	ld	a2,0(a4)
ffffffffc0206b36:	6722                	ld	a4,8(sp)
ffffffffc0206b38:	40fb07b3          	sub	a5,s6,a5
ffffffffc0206b3c:	8799                	srai	a5,a5,0x6
ffffffffc0206b3e:	97ba                	add	a5,a5,a4
ffffffffc0206b40:	6702                	ld	a4,0(sp)
ffffffffc0206b42:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206b46:	07b2                	slli	a5,a5,0xc
ffffffffc0206b48:	ec3e                	sd	a5,24(sp)
ffffffffc0206b4a:	28c5fd63          	bgeu	a1,a2,ffffffffc0206de4 <do_execve+0x8a2>
ffffffffc0206b4e:	000cb783          	ld	a5,0(s9)
ffffffffc0206b52:	4601                	li	a2,0
ffffffffc0206b54:	85ce                	mv	a1,s3
ffffffffc0206b56:	854a                	mv	a0,s2
ffffffffc0206b58:	f03e                	sd	a5,32(sp)
ffffffffc0206b5a:	d33fe0ef          	jal	ra,ffffffffc020588c <sysfile_seek>
ffffffffc0206b5e:	d159                	beqz	a0,ffffffffc0206ae4 <do_execve+0x5a2>
ffffffffc0206b60:	7442                	ld	s0,48(sp)
ffffffffc0206b62:	5b62                	lw	s6,56(sp)
ffffffffc0206b64:	b141                	j	ffffffffc02067e4 <do_execve+0x2a2>
ffffffffc0206b66:	855e                	mv	a0,s7
ffffffffc0206b68:	c12fd0ef          	jal	ra,ffffffffc0203f7a <exit_mmap>
ffffffffc0206b6c:	018bb503          	ld	a0,24(s7)
ffffffffc0206b70:	808ff0ef          	jal	ra,ffffffffc0205b78 <put_pgdir.isra.0>
ffffffffc0206b74:	855e                	mv	a0,s7
ffffffffc0206b76:	a68fd0ef          	jal	ra,ffffffffc0203dde <mm_destroy>
ffffffffc0206b7a:	bcf5                	j	ffffffffc0206676 <do_execve+0x134>
ffffffffc0206b7c:	14069063          	bnez	a3,ffffffffc0206cbc <do_execve+0x77a>
ffffffffc0206b80:	4689                	li	a3,2
ffffffffc0206b82:	8b91                	andi	a5,a5,4
ffffffffc0206b84:	12079963          	bnez	a5,ffffffffc0206cb6 <do_execve+0x774>
ffffffffc0206b88:	0d100793          	li	a5,209
ffffffffc0206b8c:	f43e                	sd	a5,40(sp)
ffffffffc0206b8e:	77a2                	ld	a5,40(sp)
ffffffffc0206b90:	0067e793          	ori	a5,a5,6
ffffffffc0206b94:	f43e                	sd	a5,40(sp)
ffffffffc0206b96:	bf21                	j	ffffffffc0206aae <do_execve+0x56c>
ffffffffc0206b98:	5df5                	li	s11,-3
ffffffffc0206b9a:	b1c5                	j	ffffffffc020687a <do_execve+0x338>
ffffffffc0206b9c:	0f679163          	bne	a5,s6,ffffffffc0206c7e <do_execve+0x73c>
ffffffffc0206ba0:	845a                	mv	s0,s6
ffffffffc0206ba2:	d73479e3          	bgeu	s0,s3,ffffffffc0206914 <do_execve+0x3d2>
ffffffffc0206ba6:	7ba2                	ld	s7,40(sp)
ffffffffc0206ba8:	6d22                	ld	s10,8(sp)
ffffffffc0206baa:	a0b9                	j	ffffffffc0206bf8 <do_execve+0x6b6>
ffffffffc0206bac:	6785                	lui	a5,0x1
ffffffffc0206bae:	41640533          	sub	a0,s0,s6
ffffffffc0206bb2:	9b3e                	add	s6,s6,a5
ffffffffc0206bb4:	408b0633          	sub	a2,s6,s0
ffffffffc0206bb8:	0169f463          	bgeu	s3,s6,ffffffffc0206bc0 <do_execve+0x67e>
ffffffffc0206bbc:	40898633          	sub	a2,s3,s0
ffffffffc0206bc0:	000c3783          	ld	a5,0(s8)
ffffffffc0206bc4:	6682                	ld	a3,0(sp)
ffffffffc0206bc6:	00090717          	auipc	a4,0x90
ffffffffc0206bca:	cda70713          	addi	a4,a4,-806 # ffffffffc02968a0 <npage>
ffffffffc0206bce:	40f487b3          	sub	a5,s1,a5
ffffffffc0206bd2:	8799                	srai	a5,a5,0x6
ffffffffc0206bd4:	6318                	ld	a4,0(a4)
ffffffffc0206bd6:	97ea                	add	a5,a5,s10
ffffffffc0206bd8:	00d7f5b3          	and	a1,a5,a3
ffffffffc0206bdc:	00c79693          	slli	a3,a5,0xc
ffffffffc0206be0:	20e5f363          	bgeu	a1,a4,ffffffffc0206de6 <do_execve+0x8a4>
ffffffffc0206be4:	000cb783          	ld	a5,0(s9)
ffffffffc0206be8:	9432                	add	s0,s0,a2
ffffffffc0206bea:	4581                	li	a1,0
ffffffffc0206bec:	97b6                	add	a5,a5,a3
ffffffffc0206bee:	953e                	add	a0,a0,a5
ffffffffc0206bf0:	2a5040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0206bf4:	0f347463          	bgeu	s0,s3,ffffffffc0206cdc <do_execve+0x79a>
ffffffffc0206bf8:	018a3503          	ld	a0,24(s4)
ffffffffc0206bfc:	865e                	mv	a2,s7
ffffffffc0206bfe:	85da                	mv	a1,s6
ffffffffc0206c00:	fabfc0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc0206c04:	84aa                	mv	s1,a0
ffffffffc0206c06:	f15d                	bnez	a0,ffffffffc0206bac <do_execve+0x66a>
ffffffffc0206c08:	7442                	ld	s0,48(sp)
ffffffffc0206c0a:	5b62                	lw	s6,56(sp)
ffffffffc0206c0c:	5571                	li	a0,-4
ffffffffc0206c0e:	bed9                	j	ffffffffc02067e4 <do_execve+0x2a2>
ffffffffc0206c10:	2c813983          	ld	s3,712(sp)
ffffffffc0206c14:	ec5a                	sd	s6,24(sp)
ffffffffc0206c16:	8b6e                	mv	s6,s11
ffffffffc0206c18:	2e013683          	ld	a3,736(sp)
ffffffffc0206c1c:	99b6                	add	s3,s3,a3
ffffffffc0206c1e:	f96472e3          	bgeu	s0,s6,ffffffffc0206ba2 <do_execve+0x660>
ffffffffc0206c22:	ce8989e3          	beq	s3,s0,ffffffffc0206914 <do_execve+0x3d2>
ffffffffc0206c26:	6785                	lui	a5,0x1
ffffffffc0206c28:	00f40533          	add	a0,s0,a5
ffffffffc0206c2c:	41650533          	sub	a0,a0,s6
ffffffffc0206c30:	40898bb3          	sub	s7,s3,s0
ffffffffc0206c34:	0169e463          	bltu	s3,s6,ffffffffc0206c3c <do_execve+0x6fa>
ffffffffc0206c38:	408b0bb3          	sub	s7,s6,s0
ffffffffc0206c3c:	00090797          	auipc	a5,0x90
ffffffffc0206c40:	c6478793          	addi	a5,a5,-924 # ffffffffc02968a0 <npage>
ffffffffc0206c44:	000c3683          	ld	a3,0(s8)
ffffffffc0206c48:	6390                	ld	a2,0(a5)
ffffffffc0206c4a:	67e2                	ld	a5,24(sp)
ffffffffc0206c4c:	40d786b3          	sub	a3,a5,a3
ffffffffc0206c50:	67a2                	ld	a5,8(sp)
ffffffffc0206c52:	8699                	srai	a3,a3,0x6
ffffffffc0206c54:	96be                	add	a3,a3,a5
ffffffffc0206c56:	6782                	ld	a5,0(sp)
ffffffffc0206c58:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206c5c:	06b2                	slli	a3,a3,0xc
ffffffffc0206c5e:	18c5f463          	bgeu	a1,a2,ffffffffc0206de6 <do_execve+0x8a4>
ffffffffc0206c62:	000cb803          	ld	a6,0(s9)
ffffffffc0206c66:	865e                	mv	a2,s7
ffffffffc0206c68:	4581                	li	a1,0
ffffffffc0206c6a:	96c2                	add	a3,a3,a6
ffffffffc0206c6c:	9536                	add	a0,a0,a3
ffffffffc0206c6e:	227040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0206c72:	008b87b3          	add	a5,s7,s0
ffffffffc0206c76:	f369f3e3          	bgeu	s3,s6,ffffffffc0206b9c <do_execve+0x65a>
ffffffffc0206c7a:	c8f98de3          	beq	s3,a5,ffffffffc0206914 <do_execve+0x3d2>
ffffffffc0206c7e:	00007697          	auipc	a3,0x7
ffffffffc0206c82:	c0a68693          	addi	a3,a3,-1014 # ffffffffc020d888 <CSWTCH.79+0x308>
ffffffffc0206c86:	00005617          	auipc	a2,0x5
ffffffffc0206c8a:	ef260613          	addi	a2,a2,-270 # ffffffffc020bb78 <commands+0x210>
ffffffffc0206c8e:	37300593          	li	a1,883
ffffffffc0206c92:	00007517          	auipc	a0,0x7
ffffffffc0206c96:	9de50513          	addi	a0,a0,-1570 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc0206c9a:	805f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c9e:	05100d93          	li	s11,81
ffffffffc0206ca2:	002de713          	ori	a4,s11,2
ffffffffc0206ca6:	0026f793          	andi	a5,a3,2
ffffffffc0206caa:	f43a                	sd	a4,40(sp)
ffffffffc0206cac:	0016e693          	ori	a3,a3,1
ffffffffc0206cb0:	de078fe3          	beqz	a5,ffffffffc0206aae <do_execve+0x56c>
ffffffffc0206cb4:	bde9                	j	ffffffffc0206b8e <do_execve+0x64c>
ffffffffc0206cb6:	0d100d93          	li	s11,209
ffffffffc0206cba:	b7e5                	j	ffffffffc0206ca2 <do_execve+0x760>
ffffffffc0206cbc:	4699                	li	a3,6
ffffffffc0206cbe:	b5d1                	j	ffffffffc0206b82 <do_execve+0x640>
ffffffffc0206cc0:	5df5                	li	s11,-3
ffffffffc0206cc2:	ba0b96e3          	bnez	s7,ffffffffc020686e <do_execve+0x32c>
ffffffffc0206cc6:	be55                	j	ffffffffc020687a <do_execve+0x338>
ffffffffc0206cc8:	ec0b88e3          	beqz	s7,ffffffffc0206b98 <do_execve+0x656>
ffffffffc0206ccc:	038b8513          	addi	a0,s7,56
ffffffffc0206cd0:	991fd0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0206cd4:	5df5                	li	s11,-3
ffffffffc0206cd6:	040ba823          	sw	zero,80(s7)
ffffffffc0206cda:	b645                	j	ffffffffc020687a <do_execve+0x338>
ffffffffc0206cdc:	ec26                	sd	s1,24(sp)
ffffffffc0206cde:	b91d                	j	ffffffffc0206914 <do_execve+0x3d2>
ffffffffc0206ce0:	89a2                	mv	s3,s0
ffffffffc0206ce2:	8b6e                	mv	s6,s11
ffffffffc0206ce4:	bf15                	j	ffffffffc0206c18 <do_execve+0x6d6>
ffffffffc0206ce6:	1b02                	slli	s6,s6,0x20
ffffffffc0206ce8:	0a810893          	addi	a7,sp,168
ffffffffc0206cec:	020b5b13          	srli	s6,s6,0x20
ffffffffc0206cf0:	5df1                	li	s11,-4
ffffffffc0206cf2:	bcfd                	j	ffffffffc02067f0 <do_execve+0x2ae>
ffffffffc0206cf4:	77e2                	ld	a5,56(sp)
ffffffffc0206cf6:	6702                	ld	a4,0(sp)
ffffffffc0206cf8:	e380                	sd	s0,0(a5)
ffffffffc0206cfa:	1761                	addi	a4,a4,-8
ffffffffc0206cfc:	17e1                	addi	a5,a5,-8
ffffffffc0206cfe:	e03a                	sd	a4,0(sp)
ffffffffc0206d00:	fc3e                	sd	a5,56(sp)
ffffffffc0206d02:	cd371ae3          	bne	a4,s3,ffffffffc02069d6 <do_execve+0x494>
ffffffffc0206d06:	67a6                	ld	a5,72(sp)
ffffffffc0206d08:	6742                	ld	a4,16(sp)
ffffffffc0206d0a:	7ff006b7          	lui	a3,0x7ff00
ffffffffc0206d0e:	9bc1                	andi	a5,a5,-16
ffffffffc0206d10:	0721                	addi	a4,a4,8
ffffffffc0206d12:	8f99                	sub	a5,a5,a4
ffffffffc0206d14:	ff07fb93          	andi	s7,a5,-16
ffffffffc0206d18:	6d46                	ld	s10,80(sp)
ffffffffc0206d1a:	6962                	ld	s2,24(sp)
ffffffffc0206d1c:	64e6                	ld	s1,88(sp)
ffffffffc0206d1e:	7402                	ld	s0,32(sp)
ffffffffc0206d20:	7b22                	ld	s6,40(sp)
ffffffffc0206d22:	78c2                	ld	a7,48(sp)
ffffffffc0206d24:	0edbe563          	bltu	s7,a3,ffffffffc0206e0e <do_execve+0x8cc>
ffffffffc0206d28:	1b34                	addi	a3,sp,440
ffffffffc0206d2a:	1d2c                	addi	a1,sp,696
ffffffffc0206d2c:	4601                	li	a2,0
ffffffffc0206d2e:	6288                	ld	a0,0(a3)
ffffffffc0206d30:	87b2                	mv	a5,a2
ffffffffc0206d32:	06a1                	addi	a3,a3,8
ffffffffc0206d34:	e188                	sd	a0,0(a1)
ffffffffc0206d36:	2605                	addiw	a2,a2,1
ffffffffc0206d38:	05a1                	addi	a1,a1,8
ffffffffc0206d3a:	fe97cae3          	blt	a5,s1,ffffffffc0206d2e <do_execve+0x7ec>
ffffffffc0206d3e:	003d1793          	slli	a5,s10,0x3
ffffffffc0206d42:	0794                	addi	a3,sp,960
ffffffffc0206d44:	97b6                	add	a5,a5,a3
ffffffffc0206d46:	ee07bc23          	sd	zero,-264(a5)
ffffffffc0206d4a:	1d3c                	addi	a5,sp,696
ffffffffc0206d4c:	f022                	sd	s0,32(sp)
ffffffffc0206d4e:	5d7d                	li	s10,-1
ffffffffc0206d50:	e03e                	sd	a5,0(sp)
ffffffffc0206d52:	ec4a                	sd	s2,24(sp)
ffffffffc0206d54:	845e                	mv	s0,s7
ffffffffc0206d56:	84ba                	mv	s1,a4
ffffffffc0206d58:	f446                	sd	a7,40(sp)
ffffffffc0206d5a:	a8a9                	j	ffffffffc0206db4 <do_execve+0x872>
ffffffffc0206d5c:	40890633          	sub	a2,s2,s0
ffffffffc0206d60:	6705                	lui	a4,0x1
ffffffffc0206d62:	963a                	add	a2,a2,a4
ffffffffc0206d64:	41240533          	sub	a0,s0,s2
ffffffffc0206d68:	00c4f363          	bgeu	s1,a2,ffffffffc0206d6e <do_execve+0x82c>
ffffffffc0206d6c:	8626                	mv	a2,s1
ffffffffc0206d6e:	000c3683          	ld	a3,0(s8)
ffffffffc0206d72:	00090717          	auipc	a4,0x90
ffffffffc0206d76:	b2e70713          	addi	a4,a4,-1234 # ffffffffc02968a0 <npage>
ffffffffc0206d7a:	630c                	ld	a1,0(a4)
ffffffffc0206d7c:	6722                	ld	a4,8(sp)
ffffffffc0206d7e:	8f95                	sub	a5,a5,a3
ffffffffc0206d80:	8799                	srai	a5,a5,0x6
ffffffffc0206d82:	97ba                	add	a5,a5,a4
ffffffffc0206d84:	577d                	li	a4,-1
ffffffffc0206d86:	8331                	srli	a4,a4,0xc
ffffffffc0206d88:	00e7f8b3          	and	a7,a5,a4
ffffffffc0206d8c:	00c79693          	slli	a3,a5,0xc
ffffffffc0206d90:	04b8fb63          	bgeu	a7,a1,ffffffffc0206de6 <do_execve+0x8a4>
ffffffffc0206d94:	000cb783          	ld	a5,0(s9)
ffffffffc0206d98:	6902                	ld	s2,0(sp)
ffffffffc0206d9a:	8c91                	sub	s1,s1,a2
ffffffffc0206d9c:	97b6                	add	a5,a5,a3
ffffffffc0206d9e:	953e                	add	a0,a0,a5
ffffffffc0206da0:	85ca                	mv	a1,s2
ffffffffc0206da2:	e032                	sd	a2,0(sp)
ffffffffc0206da4:	143040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0206da8:	6602                	ld	a2,0(sp)
ffffffffc0206daa:	00c907b3          	add	a5,s2,a2
ffffffffc0206dae:	e03e                	sd	a5,0(sp)
ffffffffc0206db0:	9432                	add	s0,s0,a2
ffffffffc0206db2:	c0a5                	beqz	s1,ffffffffc0206e12 <do_execve+0x8d0>
ffffffffc0206db4:	77fd                	lui	a5,0xfffff
ffffffffc0206db6:	018a3503          	ld	a0,24(s4)
ffffffffc0206dba:	00f47933          	and	s2,s0,a5
ffffffffc0206dbe:	4601                	li	a2,0
ffffffffc0206dc0:	85ca                	mv	a1,s2
ffffffffc0206dc2:	fd8fb0ef          	jal	ra,ffffffffc020259a <get_page>
ffffffffc0206dc6:	87aa                	mv	a5,a0
ffffffffc0206dc8:	f951                	bnez	a0,ffffffffc0206d5c <do_execve+0x81a>
ffffffffc0206dca:	018a3503          	ld	a0,24(s4)
ffffffffc0206dce:	467d                	li	a2,31
ffffffffc0206dd0:	85ca                	mv	a1,s2
ffffffffc0206dd2:	dd9fc0ef          	jal	ra,ffffffffc0203baa <pgdir_alloc_page>
ffffffffc0206dd6:	87aa                	mv	a5,a0
ffffffffc0206dd8:	f151                	bnez	a0,ffffffffc0206d5c <do_execve+0x81a>
ffffffffc0206dda:	6962                	ld	s2,24(sp)
ffffffffc0206ddc:	7402                	ld	s0,32(sp)
ffffffffc0206dde:	78a2                	ld	a7,40(sp)
ffffffffc0206de0:	5df1                	li	s11,-4
ffffffffc0206de2:	b439                	j	ffffffffc02067f0 <do_execve+0x2ae>
ffffffffc0206de4:	86be                	mv	a3,a5
ffffffffc0206de6:	00006617          	auipc	a2,0x6
ffffffffc0206dea:	8aa60613          	addi	a2,a2,-1878 # ffffffffc020c690 <default_pmm_manager+0x38>
ffffffffc0206dee:	07100593          	li	a1,113
ffffffffc0206df2:	00006517          	auipc	a0,0x6
ffffffffc0206df6:	8c650513          	addi	a0,a0,-1850 # ffffffffc020c6b8 <default_pmm_manager+0x60>
ffffffffc0206dfa:	ea4f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206dfe:	7442                	ld	s0,48(sp)
ffffffffc0206e00:	5b62                	lw	s6,56(sp)
ffffffffc0206e02:	5561                	li	a0,-8
ffffffffc0206e04:	b2c5                	j	ffffffffc02067e4 <do_execve+0x2a2>
ffffffffc0206e06:	6962                	ld	s2,24(sp)
ffffffffc0206e08:	7402                	ld	s0,32(sp)
ffffffffc0206e0a:	7b22                	ld	s6,40(sp)
ffffffffc0206e0c:	78c2                	ld	a7,48(sp)
ffffffffc0206e0e:	5dd1                	li	s11,-12
ffffffffc0206e10:	b2c5                	j	ffffffffc02067f0 <do_execve+0x2ae>
ffffffffc0206e12:	030a2783          	lw	a5,48(s4)
ffffffffc0206e16:	000ab603          	ld	a2,0(s5)
ffffffffc0206e1a:	018a3683          	ld	a3,24(s4)
ffffffffc0206e1e:	2785                	addiw	a5,a5,1
ffffffffc0206e20:	02fa2823          	sw	a5,48(s4)
ffffffffc0206e24:	03463423          	sd	s4,40(a2)
ffffffffc0206e28:	c02007b7          	lui	a5,0xc0200
ffffffffc0206e2c:	6962                	ld	s2,24(sp)
ffffffffc0206e2e:	7402                	ld	s0,32(sp)
ffffffffc0206e30:	08f6e063          	bltu	a3,a5,ffffffffc0206eb0 <do_execve+0x96e>
ffffffffc0206e34:	000cb783          	ld	a5,0(s9)
ffffffffc0206e38:	03fd1713          	slli	a4,s10,0x3f
ffffffffc0206e3c:	8e9d                	sub	a3,a3,a5
ffffffffc0206e3e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206e42:	f654                	sd	a3,168(a2)
ffffffffc0206e44:	8fd9                	or	a5,a5,a4
ffffffffc0206e46:	18079073          	csrw	satp,a5
ffffffffc0206e4a:	7244                	ld	s1,160(a2)
ffffffffc0206e4c:	4581                	li	a1,0
ffffffffc0206e4e:	12000613          	li	a2,288
ffffffffc0206e52:	1004bb03          	ld	s6,256(s1)
ffffffffc0206e56:	8526                	mv	a0,s1
ffffffffc0206e58:	03d040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0206e5c:	67ca                	ld	a5,144(sp)
ffffffffc0206e5e:	edfb7b13          	andi	s6,s6,-289
ffffffffc0206e62:	020b6b13          	ori	s6,s6,32
ffffffffc0206e66:	e8a0                	sd	s0,80(s1)
ffffffffc0206e68:	10f4b423          	sd	a5,264(s1)
ffffffffc0206e6c:	0174b823          	sd	s7,16(s1)
ffffffffc0206e70:	0574bc23          	sd	s7,88(s1)
ffffffffc0206e74:	1164b023          	sd	s6,256(s1)
ffffffffc0206e78:	854a                	mv	a0,s2
ffffffffc0206e7a:	fe0fe0ef          	jal	ra,ffffffffc020565a <sysfile_close>
ffffffffc0206e7e:	147d                	addi	s0,s0,-1
ffffffffc0206e80:	040e                	slli	s0,s0,0x3
ffffffffc0206e82:	193c                	addi	a5,sp,184
ffffffffc0206e84:	943e                	add	s0,s0,a5
ffffffffc0206e86:	6008                	ld	a0,0(s0)
ffffffffc0206e88:	1461                	addi	s0,s0,-8
ffffffffc0206e8a:	a3cfb0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0206e8e:	ff341ce3          	bne	s0,s3,ffffffffc0206e86 <do_execve+0x944>
ffffffffc0206e92:	000ab403          	ld	s0,0(s5)
ffffffffc0206e96:	4641                	li	a2,16
ffffffffc0206e98:	4581                	li	a1,0
ffffffffc0206e9a:	0b440413          	addi	s0,s0,180
ffffffffc0206e9e:	8522                	mv	a0,s0
ffffffffc0206ea0:	7f4040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0206ea4:	463d                	li	a2,15
ffffffffc0206ea6:	10ac                	addi	a1,sp,104
ffffffffc0206ea8:	8522                	mv	a0,s0
ffffffffc0206eaa:	03d040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0206eae:	b2f1                	j	ffffffffc020687a <do_execve+0x338>
ffffffffc0206eb0:	00006617          	auipc	a2,0x6
ffffffffc0206eb4:	88860613          	addi	a2,a2,-1912 # ffffffffc020c738 <default_pmm_manager+0xe0>
ffffffffc0206eb8:	3f800593          	li	a1,1016
ffffffffc0206ebc:	00006517          	auipc	a0,0x6
ffffffffc0206ec0:	7b450513          	addi	a0,a0,1972 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc0206ec4:	ddaf90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206ec8 <user_main>:
ffffffffc0206ec8:	7179                	addi	sp,sp,-48
ffffffffc0206eca:	e84a                	sd	s2,16(sp)
ffffffffc0206ecc:	00090917          	auipc	s2,0x90
ffffffffc0206ed0:	9f490913          	addi	s2,s2,-1548 # ffffffffc02968c0 <current>
ffffffffc0206ed4:	00093783          	ld	a5,0(s2)
ffffffffc0206ed8:	00007617          	auipc	a2,0x7
ffffffffc0206edc:	9f060613          	addi	a2,a2,-1552 # ffffffffc020d8c8 <CSWTCH.79+0x348>
ffffffffc0206ee0:	00007517          	auipc	a0,0x7
ffffffffc0206ee4:	9f050513          	addi	a0,a0,-1552 # ffffffffc020d8d0 <CSWTCH.79+0x350>
ffffffffc0206ee8:	43cc                	lw	a1,4(a5)
ffffffffc0206eea:	f406                	sd	ra,40(sp)
ffffffffc0206eec:	f022                	sd	s0,32(sp)
ffffffffc0206eee:	ec26                	sd	s1,24(sp)
ffffffffc0206ef0:	e032                	sd	a2,0(sp)
ffffffffc0206ef2:	e402                	sd	zero,8(sp)
ffffffffc0206ef4:	ab2f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206ef8:	6782                	ld	a5,0(sp)
ffffffffc0206efa:	cfb9                	beqz	a5,ffffffffc0206f58 <user_main+0x90>
ffffffffc0206efc:	003c                	addi	a5,sp,8
ffffffffc0206efe:	4401                	li	s0,0
ffffffffc0206f00:	6398                	ld	a4,0(a5)
ffffffffc0206f02:	0405                	addi	s0,s0,1
ffffffffc0206f04:	07a1                	addi	a5,a5,8
ffffffffc0206f06:	ff6d                	bnez	a4,ffffffffc0206f00 <user_main+0x38>
ffffffffc0206f08:	00093783          	ld	a5,0(s2)
ffffffffc0206f0c:	12000613          	li	a2,288
ffffffffc0206f10:	6b84                	ld	s1,16(a5)
ffffffffc0206f12:	73cc                	ld	a1,160(a5)
ffffffffc0206f14:	6789                	lui	a5,0x2
ffffffffc0206f16:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206f1a:	94be                	add	s1,s1,a5
ffffffffc0206f1c:	8526                	mv	a0,s1
ffffffffc0206f1e:	7c8040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0206f22:	00093783          	ld	a5,0(s2)
ffffffffc0206f26:	860a                	mv	a2,sp
ffffffffc0206f28:	0004059b          	sext.w	a1,s0
ffffffffc0206f2c:	f3c4                	sd	s1,160(a5)
ffffffffc0206f2e:	00007517          	auipc	a0,0x7
ffffffffc0206f32:	99a50513          	addi	a0,a0,-1638 # ffffffffc020d8c8 <CSWTCH.79+0x348>
ffffffffc0206f36:	e0cff0ef          	jal	ra,ffffffffc0206542 <do_execve>
ffffffffc0206f3a:	8126                	mv	sp,s1
ffffffffc0206f3c:	b9cfa06f          	j	ffffffffc02012d8 <__trapret>
ffffffffc0206f40:	00007617          	auipc	a2,0x7
ffffffffc0206f44:	9b860613          	addi	a2,a2,-1608 # ffffffffc020d8f8 <CSWTCH.79+0x378>
ffffffffc0206f48:	52000593          	li	a1,1312
ffffffffc0206f4c:	00006517          	auipc	a0,0x6
ffffffffc0206f50:	72450513          	addi	a0,a0,1828 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc0206f54:	d4af90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f58:	4401                	li	s0,0
ffffffffc0206f5a:	b77d                	j	ffffffffc0206f08 <user_main+0x40>

ffffffffc0206f5c <do_yield>:
ffffffffc0206f5c:	00090797          	auipc	a5,0x90
ffffffffc0206f60:	9647b783          	ld	a5,-1692(a5) # ffffffffc02968c0 <current>
ffffffffc0206f64:	4705                	li	a4,1
ffffffffc0206f66:	ef98                	sd	a4,24(a5)
ffffffffc0206f68:	4501                	li	a0,0
ffffffffc0206f6a:	8082                	ret

ffffffffc0206f6c <do_wait>:
ffffffffc0206f6c:	1101                	addi	sp,sp,-32
ffffffffc0206f6e:	e822                	sd	s0,16(sp)
ffffffffc0206f70:	e426                	sd	s1,8(sp)
ffffffffc0206f72:	ec06                	sd	ra,24(sp)
ffffffffc0206f74:	842e                	mv	s0,a1
ffffffffc0206f76:	84aa                	mv	s1,a0
ffffffffc0206f78:	c999                	beqz	a1,ffffffffc0206f8e <do_wait+0x22>
ffffffffc0206f7a:	00090797          	auipc	a5,0x90
ffffffffc0206f7e:	9467b783          	ld	a5,-1722(a5) # ffffffffc02968c0 <current>
ffffffffc0206f82:	7788                	ld	a0,40(a5)
ffffffffc0206f84:	4685                	li	a3,1
ffffffffc0206f86:	4611                	li	a2,4
ffffffffc0206f88:	b92fd0ef          	jal	ra,ffffffffc020431a <user_mem_check>
ffffffffc0206f8c:	c909                	beqz	a0,ffffffffc0206f9e <do_wait+0x32>
ffffffffc0206f8e:	85a2                	mv	a1,s0
ffffffffc0206f90:	6442                	ld	s0,16(sp)
ffffffffc0206f92:	60e2                	ld	ra,24(sp)
ffffffffc0206f94:	8526                	mv	a0,s1
ffffffffc0206f96:	64a2                	ld	s1,8(sp)
ffffffffc0206f98:	6105                	addi	sp,sp,32
ffffffffc0206f9a:	a86ff06f          	j	ffffffffc0206220 <do_wait.part.0>
ffffffffc0206f9e:	60e2                	ld	ra,24(sp)
ffffffffc0206fa0:	6442                	ld	s0,16(sp)
ffffffffc0206fa2:	64a2                	ld	s1,8(sp)
ffffffffc0206fa4:	5575                	li	a0,-3
ffffffffc0206fa6:	6105                	addi	sp,sp,32
ffffffffc0206fa8:	8082                	ret

ffffffffc0206faa <do_kill>:
ffffffffc0206faa:	1141                	addi	sp,sp,-16
ffffffffc0206fac:	6789                	lui	a5,0x2
ffffffffc0206fae:	e406                	sd	ra,8(sp)
ffffffffc0206fb0:	e022                	sd	s0,0(sp)
ffffffffc0206fb2:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206fb6:	17f9                	addi	a5,a5,-2
ffffffffc0206fb8:	02e7e963          	bltu	a5,a4,ffffffffc0206fea <do_kill+0x40>
ffffffffc0206fbc:	842a                	mv	s0,a0
ffffffffc0206fbe:	45a9                	li	a1,10
ffffffffc0206fc0:	2501                	sext.w	a0,a0
ffffffffc0206fc2:	19e040ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc0206fc6:	02051793          	slli	a5,a0,0x20
ffffffffc0206fca:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206fce:	0008a797          	auipc	a5,0x8a
ffffffffc0206fd2:	7f278793          	addi	a5,a5,2034 # ffffffffc02917c0 <hash_list>
ffffffffc0206fd6:	953e                	add	a0,a0,a5
ffffffffc0206fd8:	87aa                	mv	a5,a0
ffffffffc0206fda:	a029                	j	ffffffffc0206fe4 <do_kill+0x3a>
ffffffffc0206fdc:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206fe0:	00870b63          	beq	a4,s0,ffffffffc0206ff6 <do_kill+0x4c>
ffffffffc0206fe4:	679c                	ld	a5,8(a5)
ffffffffc0206fe6:	fef51be3          	bne	a0,a5,ffffffffc0206fdc <do_kill+0x32>
ffffffffc0206fea:	5475                	li	s0,-3
ffffffffc0206fec:	60a2                	ld	ra,8(sp)
ffffffffc0206fee:	8522                	mv	a0,s0
ffffffffc0206ff0:	6402                	ld	s0,0(sp)
ffffffffc0206ff2:	0141                	addi	sp,sp,16
ffffffffc0206ff4:	8082                	ret
ffffffffc0206ff6:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206ffa:	00177693          	andi	a3,a4,1
ffffffffc0206ffe:	e295                	bnez	a3,ffffffffc0207022 <do_kill+0x78>
ffffffffc0207000:	4bd4                	lw	a3,20(a5)
ffffffffc0207002:	00176713          	ori	a4,a4,1
ffffffffc0207006:	fce7ac23          	sw	a4,-40(a5)
ffffffffc020700a:	4401                	li	s0,0
ffffffffc020700c:	fe06d0e3          	bgez	a3,ffffffffc0206fec <do_kill+0x42>
ffffffffc0207010:	f2878513          	addi	a0,a5,-216
ffffffffc0207014:	45a000ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc0207018:	60a2                	ld	ra,8(sp)
ffffffffc020701a:	8522                	mv	a0,s0
ffffffffc020701c:	6402                	ld	s0,0(sp)
ffffffffc020701e:	0141                	addi	sp,sp,16
ffffffffc0207020:	8082                	ret
ffffffffc0207022:	545d                	li	s0,-9
ffffffffc0207024:	b7e1                	j	ffffffffc0206fec <do_kill+0x42>

ffffffffc0207026 <proc_init>:
ffffffffc0207026:	1101                	addi	sp,sp,-32
ffffffffc0207028:	e426                	sd	s1,8(sp)
ffffffffc020702a:	0008e797          	auipc	a5,0x8e
ffffffffc020702e:	79678793          	addi	a5,a5,1942 # ffffffffc02957c0 <proc_list>
ffffffffc0207032:	ec06                	sd	ra,24(sp)
ffffffffc0207034:	e822                	sd	s0,16(sp)
ffffffffc0207036:	e04a                	sd	s2,0(sp)
ffffffffc0207038:	0008a497          	auipc	s1,0x8a
ffffffffc020703c:	78848493          	addi	s1,s1,1928 # ffffffffc02917c0 <hash_list>
ffffffffc0207040:	e79c                	sd	a5,8(a5)
ffffffffc0207042:	e39c                	sd	a5,0(a5)
ffffffffc0207044:	0008e717          	auipc	a4,0x8e
ffffffffc0207048:	77c70713          	addi	a4,a4,1916 # ffffffffc02957c0 <proc_list>
ffffffffc020704c:	87a6                	mv	a5,s1
ffffffffc020704e:	e79c                	sd	a5,8(a5)
ffffffffc0207050:	e39c                	sd	a5,0(a5)
ffffffffc0207052:	07c1                	addi	a5,a5,16
ffffffffc0207054:	fef71de3          	bne	a4,a5,ffffffffc020704e <proc_init+0x28>
ffffffffc0207058:	a7dfe0ef          	jal	ra,ffffffffc0205ad4 <alloc_proc>
ffffffffc020705c:	00090917          	auipc	s2,0x90
ffffffffc0207060:	86c90913          	addi	s2,s2,-1940 # ffffffffc02968c8 <idleproc>
ffffffffc0207064:	00a93023          	sd	a0,0(s2)
ffffffffc0207068:	842a                	mv	s0,a0
ffffffffc020706a:	12050863          	beqz	a0,ffffffffc020719a <proc_init+0x174>
ffffffffc020706e:	4789                	li	a5,2
ffffffffc0207070:	e11c                	sd	a5,0(a0)
ffffffffc0207072:	0000a797          	auipc	a5,0xa
ffffffffc0207076:	f8e78793          	addi	a5,a5,-114 # ffffffffc0211000 <bootstack>
ffffffffc020707a:	e91c                	sd	a5,16(a0)
ffffffffc020707c:	4785                	li	a5,1
ffffffffc020707e:	ed1c                	sd	a5,24(a0)
ffffffffc0207080:	a4efe0ef          	jal	ra,ffffffffc02052ce <files_create>
ffffffffc0207084:	14a43423          	sd	a0,328(s0)
ffffffffc0207088:	0e050d63          	beqz	a0,ffffffffc0207182 <proc_init+0x15c>
ffffffffc020708c:	00093403          	ld	s0,0(s2)
ffffffffc0207090:	4641                	li	a2,16
ffffffffc0207092:	4581                	li	a1,0
ffffffffc0207094:	14843703          	ld	a4,328(s0)
ffffffffc0207098:	0b440413          	addi	s0,s0,180
ffffffffc020709c:	8522                	mv	a0,s0
ffffffffc020709e:	4b1c                	lw	a5,16(a4)
ffffffffc02070a0:	2785                	addiw	a5,a5,1
ffffffffc02070a2:	cb1c                	sw	a5,16(a4)
ffffffffc02070a4:	5f0040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc02070a8:	463d                	li	a2,15
ffffffffc02070aa:	00007597          	auipc	a1,0x7
ffffffffc02070ae:	8ae58593          	addi	a1,a1,-1874 # ffffffffc020d958 <CSWTCH.79+0x3d8>
ffffffffc02070b2:	8522                	mv	a0,s0
ffffffffc02070b4:	632040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc02070b8:	00090717          	auipc	a4,0x90
ffffffffc02070bc:	82070713          	addi	a4,a4,-2016 # ffffffffc02968d8 <nr_process>
ffffffffc02070c0:	431c                	lw	a5,0(a4)
ffffffffc02070c2:	00093683          	ld	a3,0(s2)
ffffffffc02070c6:	4601                	li	a2,0
ffffffffc02070c8:	2785                	addiw	a5,a5,1
ffffffffc02070ca:	4581                	li	a1,0
ffffffffc02070cc:	fffff517          	auipc	a0,0xfffff
ffffffffc02070d0:	32650513          	addi	a0,a0,806 # ffffffffc02063f2 <init_main>
ffffffffc02070d4:	c31c                	sw	a5,0(a4)
ffffffffc02070d6:	0008f797          	auipc	a5,0x8f
ffffffffc02070da:	7ed7b523          	sd	a3,2026(a5) # ffffffffc02968c0 <current>
ffffffffc02070de:	f91fe0ef          	jal	ra,ffffffffc020606e <kernel_thread>
ffffffffc02070e2:	842a                	mv	s0,a0
ffffffffc02070e4:	08a05363          	blez	a0,ffffffffc020716a <proc_init+0x144>
ffffffffc02070e8:	6789                	lui	a5,0x2
ffffffffc02070ea:	fff5071b          	addiw	a4,a0,-1
ffffffffc02070ee:	17f9                	addi	a5,a5,-2
ffffffffc02070f0:	2501                	sext.w	a0,a0
ffffffffc02070f2:	02e7e363          	bltu	a5,a4,ffffffffc0207118 <proc_init+0xf2>
ffffffffc02070f6:	45a9                	li	a1,10
ffffffffc02070f8:	068040ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc02070fc:	02051793          	slli	a5,a0,0x20
ffffffffc0207100:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0207104:	96a6                	add	a3,a3,s1
ffffffffc0207106:	87b6                	mv	a5,a3
ffffffffc0207108:	a029                	j	ffffffffc0207112 <proc_init+0xec>
ffffffffc020710a:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc020710e:	04870b63          	beq	a4,s0,ffffffffc0207164 <proc_init+0x13e>
ffffffffc0207112:	679c                	ld	a5,8(a5)
ffffffffc0207114:	fef69be3          	bne	a3,a5,ffffffffc020710a <proc_init+0xe4>
ffffffffc0207118:	4781                	li	a5,0
ffffffffc020711a:	0b478493          	addi	s1,a5,180
ffffffffc020711e:	4641                	li	a2,16
ffffffffc0207120:	4581                	li	a1,0
ffffffffc0207122:	0008f417          	auipc	s0,0x8f
ffffffffc0207126:	7ae40413          	addi	s0,s0,1966 # ffffffffc02968d0 <initproc>
ffffffffc020712a:	8526                	mv	a0,s1
ffffffffc020712c:	e01c                	sd	a5,0(s0)
ffffffffc020712e:	566040ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0207132:	463d                	li	a2,15
ffffffffc0207134:	00007597          	auipc	a1,0x7
ffffffffc0207138:	84c58593          	addi	a1,a1,-1972 # ffffffffc020d980 <CSWTCH.79+0x400>
ffffffffc020713c:	8526                	mv	a0,s1
ffffffffc020713e:	5a8040ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc0207142:	00093783          	ld	a5,0(s2)
ffffffffc0207146:	c7d1                	beqz	a5,ffffffffc02071d2 <proc_init+0x1ac>
ffffffffc0207148:	43dc                	lw	a5,4(a5)
ffffffffc020714a:	e7c1                	bnez	a5,ffffffffc02071d2 <proc_init+0x1ac>
ffffffffc020714c:	601c                	ld	a5,0(s0)
ffffffffc020714e:	c3b5                	beqz	a5,ffffffffc02071b2 <proc_init+0x18c>
ffffffffc0207150:	43d8                	lw	a4,4(a5)
ffffffffc0207152:	4785                	li	a5,1
ffffffffc0207154:	04f71f63          	bne	a4,a5,ffffffffc02071b2 <proc_init+0x18c>
ffffffffc0207158:	60e2                	ld	ra,24(sp)
ffffffffc020715a:	6442                	ld	s0,16(sp)
ffffffffc020715c:	64a2                	ld	s1,8(sp)
ffffffffc020715e:	6902                	ld	s2,0(sp)
ffffffffc0207160:	6105                	addi	sp,sp,32
ffffffffc0207162:	8082                	ret
ffffffffc0207164:	f2878793          	addi	a5,a5,-216
ffffffffc0207168:	bf4d                	j	ffffffffc020711a <proc_init+0xf4>
ffffffffc020716a:	00006617          	auipc	a2,0x6
ffffffffc020716e:	7f660613          	addi	a2,a2,2038 # ffffffffc020d960 <CSWTCH.79+0x3e0>
ffffffffc0207172:	56c00593          	li	a1,1388
ffffffffc0207176:	00006517          	auipc	a0,0x6
ffffffffc020717a:	4fa50513          	addi	a0,a0,1274 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc020717e:	b20f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207182:	00006617          	auipc	a2,0x6
ffffffffc0207186:	7ae60613          	addi	a2,a2,1966 # ffffffffc020d930 <CSWTCH.79+0x3b0>
ffffffffc020718a:	56000593          	li	a1,1376
ffffffffc020718e:	00006517          	auipc	a0,0x6
ffffffffc0207192:	4e250513          	addi	a0,a0,1250 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc0207196:	b08f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020719a:	00006617          	auipc	a2,0x6
ffffffffc020719e:	77e60613          	addi	a2,a2,1918 # ffffffffc020d918 <CSWTCH.79+0x398>
ffffffffc02071a2:	55600593          	li	a1,1366
ffffffffc02071a6:	00006517          	auipc	a0,0x6
ffffffffc02071aa:	4ca50513          	addi	a0,a0,1226 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02071ae:	af0f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02071b2:	00006697          	auipc	a3,0x6
ffffffffc02071b6:	7fe68693          	addi	a3,a3,2046 # ffffffffc020d9b0 <CSWTCH.79+0x430>
ffffffffc02071ba:	00005617          	auipc	a2,0x5
ffffffffc02071be:	9be60613          	addi	a2,a2,-1602 # ffffffffc020bb78 <commands+0x210>
ffffffffc02071c2:	57300593          	li	a1,1395
ffffffffc02071c6:	00006517          	auipc	a0,0x6
ffffffffc02071ca:	4aa50513          	addi	a0,a0,1194 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02071ce:	ad0f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02071d2:	00006697          	auipc	a3,0x6
ffffffffc02071d6:	7b668693          	addi	a3,a3,1974 # ffffffffc020d988 <CSWTCH.79+0x408>
ffffffffc02071da:	00005617          	auipc	a2,0x5
ffffffffc02071de:	99e60613          	addi	a2,a2,-1634 # ffffffffc020bb78 <commands+0x210>
ffffffffc02071e2:	57200593          	li	a1,1394
ffffffffc02071e6:	00006517          	auipc	a0,0x6
ffffffffc02071ea:	48a50513          	addi	a0,a0,1162 # ffffffffc020d670 <CSWTCH.79+0xf0>
ffffffffc02071ee:	ab0f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02071f2 <cpu_idle>:
ffffffffc02071f2:	1141                	addi	sp,sp,-16
ffffffffc02071f4:	e022                	sd	s0,0(sp)
ffffffffc02071f6:	e406                	sd	ra,8(sp)
ffffffffc02071f8:	0008f417          	auipc	s0,0x8f
ffffffffc02071fc:	6c840413          	addi	s0,s0,1736 # ffffffffc02968c0 <current>
ffffffffc0207200:	6018                	ld	a4,0(s0)
ffffffffc0207202:	6f1c                	ld	a5,24(a4)
ffffffffc0207204:	dffd                	beqz	a5,ffffffffc0207202 <cpu_idle+0x10>
ffffffffc0207206:	31a000ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc020720a:	bfdd                	j	ffffffffc0207200 <cpu_idle+0xe>

ffffffffc020720c <lab6_set_priority>:
ffffffffc020720c:	1141                	addi	sp,sp,-16
ffffffffc020720e:	e022                	sd	s0,0(sp)
ffffffffc0207210:	85aa                	mv	a1,a0
ffffffffc0207212:	842a                	mv	s0,a0
ffffffffc0207214:	00006517          	auipc	a0,0x6
ffffffffc0207218:	7c450513          	addi	a0,a0,1988 # ffffffffc020d9d8 <CSWTCH.79+0x458>
ffffffffc020721c:	e406                	sd	ra,8(sp)
ffffffffc020721e:	f89f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207222:	0008f797          	auipc	a5,0x8f
ffffffffc0207226:	69e7b783          	ld	a5,1694(a5) # ffffffffc02968c0 <current>
ffffffffc020722a:	e801                	bnez	s0,ffffffffc020723a <lab6_set_priority+0x2e>
ffffffffc020722c:	60a2                	ld	ra,8(sp)
ffffffffc020722e:	6402                	ld	s0,0(sp)
ffffffffc0207230:	4705                	li	a4,1
ffffffffc0207232:	14e7a223          	sw	a4,324(a5)
ffffffffc0207236:	0141                	addi	sp,sp,16
ffffffffc0207238:	8082                	ret
ffffffffc020723a:	60a2                	ld	ra,8(sp)
ffffffffc020723c:	1487a223          	sw	s0,324(a5)
ffffffffc0207240:	6402                	ld	s0,0(sp)
ffffffffc0207242:	0141                	addi	sp,sp,16
ffffffffc0207244:	8082                	ret

ffffffffc0207246 <do_sleep>:
ffffffffc0207246:	c539                	beqz	a0,ffffffffc0207294 <do_sleep+0x4e>
ffffffffc0207248:	7179                	addi	sp,sp,-48
ffffffffc020724a:	f022                	sd	s0,32(sp)
ffffffffc020724c:	f406                	sd	ra,40(sp)
ffffffffc020724e:	842a                	mv	s0,a0
ffffffffc0207250:	100027f3          	csrr	a5,sstatus
ffffffffc0207254:	8b89                	andi	a5,a5,2
ffffffffc0207256:	e3a9                	bnez	a5,ffffffffc0207298 <do_sleep+0x52>
ffffffffc0207258:	0008f797          	auipc	a5,0x8f
ffffffffc020725c:	6687b783          	ld	a5,1640(a5) # ffffffffc02968c0 <current>
ffffffffc0207260:	0818                	addi	a4,sp,16
ffffffffc0207262:	c02a                	sw	a0,0(sp)
ffffffffc0207264:	ec3a                	sd	a4,24(sp)
ffffffffc0207266:	e83a                	sd	a4,16(sp)
ffffffffc0207268:	e43e                	sd	a5,8(sp)
ffffffffc020726a:	4705                	li	a4,1
ffffffffc020726c:	c398                	sw	a4,0(a5)
ffffffffc020726e:	80000737          	lui	a4,0x80000
ffffffffc0207272:	840a                	mv	s0,sp
ffffffffc0207274:	0709                	addi	a4,a4,2
ffffffffc0207276:	0ee7a623          	sw	a4,236(a5)
ffffffffc020727a:	8522                	mv	a0,s0
ffffffffc020727c:	364000ef          	jal	ra,ffffffffc02075e0 <add_timer>
ffffffffc0207280:	2a0000ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc0207284:	8522                	mv	a0,s0
ffffffffc0207286:	422000ef          	jal	ra,ffffffffc02076a8 <del_timer>
ffffffffc020728a:	70a2                	ld	ra,40(sp)
ffffffffc020728c:	7402                	ld	s0,32(sp)
ffffffffc020728e:	4501                	li	a0,0
ffffffffc0207290:	6145                	addi	sp,sp,48
ffffffffc0207292:	8082                	ret
ffffffffc0207294:	4501                	li	a0,0
ffffffffc0207296:	8082                	ret
ffffffffc0207298:	9dbf90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020729c:	0008f797          	auipc	a5,0x8f
ffffffffc02072a0:	6247b783          	ld	a5,1572(a5) # ffffffffc02968c0 <current>
ffffffffc02072a4:	0818                	addi	a4,sp,16
ffffffffc02072a6:	c022                	sw	s0,0(sp)
ffffffffc02072a8:	e43e                	sd	a5,8(sp)
ffffffffc02072aa:	ec3a                	sd	a4,24(sp)
ffffffffc02072ac:	e83a                	sd	a4,16(sp)
ffffffffc02072ae:	4705                	li	a4,1
ffffffffc02072b0:	c398                	sw	a4,0(a5)
ffffffffc02072b2:	80000737          	lui	a4,0x80000
ffffffffc02072b6:	0709                	addi	a4,a4,2
ffffffffc02072b8:	840a                	mv	s0,sp
ffffffffc02072ba:	8522                	mv	a0,s0
ffffffffc02072bc:	0ee7a623          	sw	a4,236(a5)
ffffffffc02072c0:	320000ef          	jal	ra,ffffffffc02075e0 <add_timer>
ffffffffc02072c4:	9a9f90ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02072c8:	bf65                	j	ffffffffc0207280 <do_sleep+0x3a>

ffffffffc02072ca <switch_to>:
ffffffffc02072ca:	00153023          	sd	ra,0(a0)
ffffffffc02072ce:	00253423          	sd	sp,8(a0)
ffffffffc02072d2:	e900                	sd	s0,16(a0)
ffffffffc02072d4:	ed04                	sd	s1,24(a0)
ffffffffc02072d6:	03253023          	sd	s2,32(a0)
ffffffffc02072da:	03353423          	sd	s3,40(a0)
ffffffffc02072de:	03453823          	sd	s4,48(a0)
ffffffffc02072e2:	03553c23          	sd	s5,56(a0)
ffffffffc02072e6:	05653023          	sd	s6,64(a0)
ffffffffc02072ea:	05753423          	sd	s7,72(a0)
ffffffffc02072ee:	05853823          	sd	s8,80(a0)
ffffffffc02072f2:	05953c23          	sd	s9,88(a0)
ffffffffc02072f6:	07a53023          	sd	s10,96(a0)
ffffffffc02072fa:	07b53423          	sd	s11,104(a0)
ffffffffc02072fe:	0005b083          	ld	ra,0(a1)
ffffffffc0207302:	0085b103          	ld	sp,8(a1)
ffffffffc0207306:	6980                	ld	s0,16(a1)
ffffffffc0207308:	6d84                	ld	s1,24(a1)
ffffffffc020730a:	0205b903          	ld	s2,32(a1)
ffffffffc020730e:	0285b983          	ld	s3,40(a1)
ffffffffc0207312:	0305ba03          	ld	s4,48(a1)
ffffffffc0207316:	0385ba83          	ld	s5,56(a1)
ffffffffc020731a:	0405bb03          	ld	s6,64(a1)
ffffffffc020731e:	0485bb83          	ld	s7,72(a1)
ffffffffc0207322:	0505bc03          	ld	s8,80(a1)
ffffffffc0207326:	0585bc83          	ld	s9,88(a1)
ffffffffc020732a:	0605bd03          	ld	s10,96(a1)
ffffffffc020732e:	0685bd83          	ld	s11,104(a1)
ffffffffc0207332:	8082                	ret

ffffffffc0207334 <RR_init>:
ffffffffc0207334:	e508                	sd	a0,8(a0)
ffffffffc0207336:	e108                	sd	a0,0(a0)
ffffffffc0207338:	00052823          	sw	zero,16(a0)
ffffffffc020733c:	8082                	ret

ffffffffc020733e <RR_pick_next>:
ffffffffc020733e:	651c                	ld	a5,8(a0)
ffffffffc0207340:	00f50563          	beq	a0,a5,ffffffffc020734a <RR_pick_next+0xc>
ffffffffc0207344:	ef078513          	addi	a0,a5,-272
ffffffffc0207348:	8082                	ret
ffffffffc020734a:	4501                	li	a0,0
ffffffffc020734c:	8082                	ret

ffffffffc020734e <RR_proc_tick>:
ffffffffc020734e:	1205a783          	lw	a5,288(a1)
ffffffffc0207352:	00f05563          	blez	a5,ffffffffc020735c <RR_proc_tick+0xe>
ffffffffc0207356:	37fd                	addiw	a5,a5,-1
ffffffffc0207358:	12f5a023          	sw	a5,288(a1)
ffffffffc020735c:	e399                	bnez	a5,ffffffffc0207362 <RR_proc_tick+0x14>
ffffffffc020735e:	4785                	li	a5,1
ffffffffc0207360:	ed9c                	sd	a5,24(a1)
ffffffffc0207362:	8082                	ret

ffffffffc0207364 <RR_dequeue>:
ffffffffc0207364:	1185b703          	ld	a4,280(a1)
ffffffffc0207368:	11058793          	addi	a5,a1,272
ffffffffc020736c:	02e78363          	beq	a5,a4,ffffffffc0207392 <RR_dequeue+0x2e>
ffffffffc0207370:	1085b683          	ld	a3,264(a1)
ffffffffc0207374:	00a69f63          	bne	a3,a0,ffffffffc0207392 <RR_dequeue+0x2e>
ffffffffc0207378:	1105b503          	ld	a0,272(a1)
ffffffffc020737c:	4a90                	lw	a2,16(a3)
ffffffffc020737e:	e518                	sd	a4,8(a0)
ffffffffc0207380:	e308                	sd	a0,0(a4)
ffffffffc0207382:	10f5bc23          	sd	a5,280(a1)
ffffffffc0207386:	10f5b823          	sd	a5,272(a1)
ffffffffc020738a:	fff6079b          	addiw	a5,a2,-1
ffffffffc020738e:	ca9c                	sw	a5,16(a3)
ffffffffc0207390:	8082                	ret
ffffffffc0207392:	1141                	addi	sp,sp,-16
ffffffffc0207394:	00006697          	auipc	a3,0x6
ffffffffc0207398:	65c68693          	addi	a3,a3,1628 # ffffffffc020d9f0 <CSWTCH.79+0x470>
ffffffffc020739c:	00004617          	auipc	a2,0x4
ffffffffc02073a0:	7dc60613          	addi	a2,a2,2012 # ffffffffc020bb78 <commands+0x210>
ffffffffc02073a4:	04400593          	li	a1,68
ffffffffc02073a8:	00006517          	auipc	a0,0x6
ffffffffc02073ac:	68050513          	addi	a0,a0,1664 # ffffffffc020da28 <CSWTCH.79+0x4a8>
ffffffffc02073b0:	e406                	sd	ra,8(sp)
ffffffffc02073b2:	8ecf90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02073b6 <RR_enqueue>:
ffffffffc02073b6:	1185b703          	ld	a4,280(a1)
ffffffffc02073ba:	11058793          	addi	a5,a1,272
ffffffffc02073be:	02e79d63          	bne	a5,a4,ffffffffc02073f8 <RR_enqueue+0x42>
ffffffffc02073c2:	6118                	ld	a4,0(a0)
ffffffffc02073c4:	1205a683          	lw	a3,288(a1)
ffffffffc02073c8:	e11c                	sd	a5,0(a0)
ffffffffc02073ca:	e71c                	sd	a5,8(a4)
ffffffffc02073cc:	10a5bc23          	sd	a0,280(a1)
ffffffffc02073d0:	10e5b823          	sd	a4,272(a1)
ffffffffc02073d4:	495c                	lw	a5,20(a0)
ffffffffc02073d6:	ea89                	bnez	a3,ffffffffc02073e8 <RR_enqueue+0x32>
ffffffffc02073d8:	12f5a023          	sw	a5,288(a1)
ffffffffc02073dc:	491c                	lw	a5,16(a0)
ffffffffc02073de:	10a5b423          	sd	a0,264(a1)
ffffffffc02073e2:	2785                	addiw	a5,a5,1
ffffffffc02073e4:	c91c                	sw	a5,16(a0)
ffffffffc02073e6:	8082                	ret
ffffffffc02073e8:	fed7c8e3          	blt	a5,a3,ffffffffc02073d8 <RR_enqueue+0x22>
ffffffffc02073ec:	491c                	lw	a5,16(a0)
ffffffffc02073ee:	10a5b423          	sd	a0,264(a1)
ffffffffc02073f2:	2785                	addiw	a5,a5,1
ffffffffc02073f4:	c91c                	sw	a5,16(a0)
ffffffffc02073f6:	8082                	ret
ffffffffc02073f8:	1141                	addi	sp,sp,-16
ffffffffc02073fa:	00006697          	auipc	a3,0x6
ffffffffc02073fe:	64e68693          	addi	a3,a3,1614 # ffffffffc020da48 <CSWTCH.79+0x4c8>
ffffffffc0207402:	00004617          	auipc	a2,0x4
ffffffffc0207406:	77660613          	addi	a2,a2,1910 # ffffffffc020bb78 <commands+0x210>
ffffffffc020740a:	02c00593          	li	a1,44
ffffffffc020740e:	00006517          	auipc	a0,0x6
ffffffffc0207412:	61a50513          	addi	a0,a0,1562 # ffffffffc020da28 <CSWTCH.79+0x4a8>
ffffffffc0207416:	e406                	sd	ra,8(sp)
ffffffffc0207418:	886f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020741c <sched_init>:
ffffffffc020741c:	1141                	addi	sp,sp,-16
ffffffffc020741e:	0008a717          	auipc	a4,0x8a
ffffffffc0207422:	c0270713          	addi	a4,a4,-1022 # ffffffffc0291020 <default_sched_class>
ffffffffc0207426:	e022                	sd	s0,0(sp)
ffffffffc0207428:	e406                	sd	ra,8(sp)
ffffffffc020742a:	0008e797          	auipc	a5,0x8e
ffffffffc020742e:	3c678793          	addi	a5,a5,966 # ffffffffc02957f0 <timer_list>
ffffffffc0207432:	6714                	ld	a3,8(a4)
ffffffffc0207434:	0008e517          	auipc	a0,0x8e
ffffffffc0207438:	39c50513          	addi	a0,a0,924 # ffffffffc02957d0 <__rq>
ffffffffc020743c:	e79c                	sd	a5,8(a5)
ffffffffc020743e:	e39c                	sd	a5,0(a5)
ffffffffc0207440:	4795                	li	a5,5
ffffffffc0207442:	c95c                	sw	a5,20(a0)
ffffffffc0207444:	0008f417          	auipc	s0,0x8f
ffffffffc0207448:	4a440413          	addi	s0,s0,1188 # ffffffffc02968e8 <sched_class>
ffffffffc020744c:	0008f797          	auipc	a5,0x8f
ffffffffc0207450:	48a7ba23          	sd	a0,1172(a5) # ffffffffc02968e0 <rq>
ffffffffc0207454:	e018                	sd	a4,0(s0)
ffffffffc0207456:	9682                	jalr	a3
ffffffffc0207458:	601c                	ld	a5,0(s0)
ffffffffc020745a:	6402                	ld	s0,0(sp)
ffffffffc020745c:	60a2                	ld	ra,8(sp)
ffffffffc020745e:	638c                	ld	a1,0(a5)
ffffffffc0207460:	00006517          	auipc	a0,0x6
ffffffffc0207464:	61850513          	addi	a0,a0,1560 # ffffffffc020da78 <CSWTCH.79+0x4f8>
ffffffffc0207468:	0141                	addi	sp,sp,16
ffffffffc020746a:	d3df806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc020746e <wakeup_proc>:
ffffffffc020746e:	4118                	lw	a4,0(a0)
ffffffffc0207470:	1101                	addi	sp,sp,-32
ffffffffc0207472:	ec06                	sd	ra,24(sp)
ffffffffc0207474:	e822                	sd	s0,16(sp)
ffffffffc0207476:	e426                	sd	s1,8(sp)
ffffffffc0207478:	478d                	li	a5,3
ffffffffc020747a:	08f70363          	beq	a4,a5,ffffffffc0207500 <wakeup_proc+0x92>
ffffffffc020747e:	842a                	mv	s0,a0
ffffffffc0207480:	100027f3          	csrr	a5,sstatus
ffffffffc0207484:	8b89                	andi	a5,a5,2
ffffffffc0207486:	4481                	li	s1,0
ffffffffc0207488:	e7bd                	bnez	a5,ffffffffc02074f6 <wakeup_proc+0x88>
ffffffffc020748a:	4789                	li	a5,2
ffffffffc020748c:	04f70863          	beq	a4,a5,ffffffffc02074dc <wakeup_proc+0x6e>
ffffffffc0207490:	c01c                	sw	a5,0(s0)
ffffffffc0207492:	0e042623          	sw	zero,236(s0)
ffffffffc0207496:	0008f797          	auipc	a5,0x8f
ffffffffc020749a:	42a7b783          	ld	a5,1066(a5) # ffffffffc02968c0 <current>
ffffffffc020749e:	02878363          	beq	a5,s0,ffffffffc02074c4 <wakeup_proc+0x56>
ffffffffc02074a2:	0008f797          	auipc	a5,0x8f
ffffffffc02074a6:	4267b783          	ld	a5,1062(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02074aa:	00f40d63          	beq	s0,a5,ffffffffc02074c4 <wakeup_proc+0x56>
ffffffffc02074ae:	0008f797          	auipc	a5,0x8f
ffffffffc02074b2:	43a7b783          	ld	a5,1082(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02074b6:	6b9c                	ld	a5,16(a5)
ffffffffc02074b8:	85a2                	mv	a1,s0
ffffffffc02074ba:	0008f517          	auipc	a0,0x8f
ffffffffc02074be:	42653503          	ld	a0,1062(a0) # ffffffffc02968e0 <rq>
ffffffffc02074c2:	9782                	jalr	a5
ffffffffc02074c4:	e491                	bnez	s1,ffffffffc02074d0 <wakeup_proc+0x62>
ffffffffc02074c6:	60e2                	ld	ra,24(sp)
ffffffffc02074c8:	6442                	ld	s0,16(sp)
ffffffffc02074ca:	64a2                	ld	s1,8(sp)
ffffffffc02074cc:	6105                	addi	sp,sp,32
ffffffffc02074ce:	8082                	ret
ffffffffc02074d0:	6442                	ld	s0,16(sp)
ffffffffc02074d2:	60e2                	ld	ra,24(sp)
ffffffffc02074d4:	64a2                	ld	s1,8(sp)
ffffffffc02074d6:	6105                	addi	sp,sp,32
ffffffffc02074d8:	f94f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02074dc:	00006617          	auipc	a2,0x6
ffffffffc02074e0:	5ec60613          	addi	a2,a2,1516 # ffffffffc020dac8 <CSWTCH.79+0x548>
ffffffffc02074e4:	05200593          	li	a1,82
ffffffffc02074e8:	00006517          	auipc	a0,0x6
ffffffffc02074ec:	5c850513          	addi	a0,a0,1480 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc02074f0:	816f90ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02074f4:	bfc1                	j	ffffffffc02074c4 <wakeup_proc+0x56>
ffffffffc02074f6:	f7cf90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02074fa:	4018                	lw	a4,0(s0)
ffffffffc02074fc:	4485                	li	s1,1
ffffffffc02074fe:	b771                	j	ffffffffc020748a <wakeup_proc+0x1c>
ffffffffc0207500:	00006697          	auipc	a3,0x6
ffffffffc0207504:	59068693          	addi	a3,a3,1424 # ffffffffc020da90 <CSWTCH.79+0x510>
ffffffffc0207508:	00004617          	auipc	a2,0x4
ffffffffc020750c:	67060613          	addi	a2,a2,1648 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207510:	04300593          	li	a1,67
ffffffffc0207514:	00006517          	auipc	a0,0x6
ffffffffc0207518:	59c50513          	addi	a0,a0,1436 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc020751c:	f83f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207520 <schedule>:
ffffffffc0207520:	7179                	addi	sp,sp,-48
ffffffffc0207522:	f406                	sd	ra,40(sp)
ffffffffc0207524:	f022                	sd	s0,32(sp)
ffffffffc0207526:	ec26                	sd	s1,24(sp)
ffffffffc0207528:	e84a                	sd	s2,16(sp)
ffffffffc020752a:	e44e                	sd	s3,8(sp)
ffffffffc020752c:	e052                	sd	s4,0(sp)
ffffffffc020752e:	100027f3          	csrr	a5,sstatus
ffffffffc0207532:	8b89                	andi	a5,a5,2
ffffffffc0207534:	4a01                	li	s4,0
ffffffffc0207536:	e3cd                	bnez	a5,ffffffffc02075d8 <schedule+0xb8>
ffffffffc0207538:	0008f497          	auipc	s1,0x8f
ffffffffc020753c:	38848493          	addi	s1,s1,904 # ffffffffc02968c0 <current>
ffffffffc0207540:	608c                	ld	a1,0(s1)
ffffffffc0207542:	0008f997          	auipc	s3,0x8f
ffffffffc0207546:	3a698993          	addi	s3,s3,934 # ffffffffc02968e8 <sched_class>
ffffffffc020754a:	0008f917          	auipc	s2,0x8f
ffffffffc020754e:	39690913          	addi	s2,s2,918 # ffffffffc02968e0 <rq>
ffffffffc0207552:	4194                	lw	a3,0(a1)
ffffffffc0207554:	0005bc23          	sd	zero,24(a1)
ffffffffc0207558:	4709                	li	a4,2
ffffffffc020755a:	0009b783          	ld	a5,0(s3)
ffffffffc020755e:	00093503          	ld	a0,0(s2)
ffffffffc0207562:	04e68e63          	beq	a3,a4,ffffffffc02075be <schedule+0x9e>
ffffffffc0207566:	739c                	ld	a5,32(a5)
ffffffffc0207568:	9782                	jalr	a5
ffffffffc020756a:	842a                	mv	s0,a0
ffffffffc020756c:	c521                	beqz	a0,ffffffffc02075b4 <schedule+0x94>
ffffffffc020756e:	0009b783          	ld	a5,0(s3)
ffffffffc0207572:	00093503          	ld	a0,0(s2)
ffffffffc0207576:	85a2                	mv	a1,s0
ffffffffc0207578:	6f9c                	ld	a5,24(a5)
ffffffffc020757a:	9782                	jalr	a5
ffffffffc020757c:	441c                	lw	a5,8(s0)
ffffffffc020757e:	6098                	ld	a4,0(s1)
ffffffffc0207580:	2785                	addiw	a5,a5,1
ffffffffc0207582:	c41c                	sw	a5,8(s0)
ffffffffc0207584:	00870563          	beq	a4,s0,ffffffffc020758e <schedule+0x6e>
ffffffffc0207588:	8522                	mv	a0,s0
ffffffffc020758a:	e64fe0ef          	jal	ra,ffffffffc0205bee <proc_run>
ffffffffc020758e:	000a1a63          	bnez	s4,ffffffffc02075a2 <schedule+0x82>
ffffffffc0207592:	70a2                	ld	ra,40(sp)
ffffffffc0207594:	7402                	ld	s0,32(sp)
ffffffffc0207596:	64e2                	ld	s1,24(sp)
ffffffffc0207598:	6942                	ld	s2,16(sp)
ffffffffc020759a:	69a2                	ld	s3,8(sp)
ffffffffc020759c:	6a02                	ld	s4,0(sp)
ffffffffc020759e:	6145                	addi	sp,sp,48
ffffffffc02075a0:	8082                	ret
ffffffffc02075a2:	7402                	ld	s0,32(sp)
ffffffffc02075a4:	70a2                	ld	ra,40(sp)
ffffffffc02075a6:	64e2                	ld	s1,24(sp)
ffffffffc02075a8:	6942                	ld	s2,16(sp)
ffffffffc02075aa:	69a2                	ld	s3,8(sp)
ffffffffc02075ac:	6a02                	ld	s4,0(sp)
ffffffffc02075ae:	6145                	addi	sp,sp,48
ffffffffc02075b0:	ebcf906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02075b4:	0008f417          	auipc	s0,0x8f
ffffffffc02075b8:	31443403          	ld	s0,788(s0) # ffffffffc02968c8 <idleproc>
ffffffffc02075bc:	b7c1                	j	ffffffffc020757c <schedule+0x5c>
ffffffffc02075be:	0008f717          	auipc	a4,0x8f
ffffffffc02075c2:	30a73703          	ld	a4,778(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02075c6:	fae580e3          	beq	a1,a4,ffffffffc0207566 <schedule+0x46>
ffffffffc02075ca:	6b9c                	ld	a5,16(a5)
ffffffffc02075cc:	9782                	jalr	a5
ffffffffc02075ce:	0009b783          	ld	a5,0(s3)
ffffffffc02075d2:	00093503          	ld	a0,0(s2)
ffffffffc02075d6:	bf41                	j	ffffffffc0207566 <schedule+0x46>
ffffffffc02075d8:	e9af90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02075dc:	4a05                	li	s4,1
ffffffffc02075de:	bfa9                	j	ffffffffc0207538 <schedule+0x18>

ffffffffc02075e0 <add_timer>:
ffffffffc02075e0:	1141                	addi	sp,sp,-16
ffffffffc02075e2:	e022                	sd	s0,0(sp)
ffffffffc02075e4:	e406                	sd	ra,8(sp)
ffffffffc02075e6:	842a                	mv	s0,a0
ffffffffc02075e8:	100027f3          	csrr	a5,sstatus
ffffffffc02075ec:	8b89                	andi	a5,a5,2
ffffffffc02075ee:	4501                	li	a0,0
ffffffffc02075f0:	eba5                	bnez	a5,ffffffffc0207660 <add_timer+0x80>
ffffffffc02075f2:	401c                	lw	a5,0(s0)
ffffffffc02075f4:	cbb5                	beqz	a5,ffffffffc0207668 <add_timer+0x88>
ffffffffc02075f6:	6418                	ld	a4,8(s0)
ffffffffc02075f8:	cb25                	beqz	a4,ffffffffc0207668 <add_timer+0x88>
ffffffffc02075fa:	6c18                	ld	a4,24(s0)
ffffffffc02075fc:	01040593          	addi	a1,s0,16
ffffffffc0207600:	08e59463          	bne	a1,a4,ffffffffc0207688 <add_timer+0xa8>
ffffffffc0207604:	0008e617          	auipc	a2,0x8e
ffffffffc0207608:	1ec60613          	addi	a2,a2,492 # ffffffffc02957f0 <timer_list>
ffffffffc020760c:	6618                	ld	a4,8(a2)
ffffffffc020760e:	00c71863          	bne	a4,a2,ffffffffc020761e <add_timer+0x3e>
ffffffffc0207612:	a80d                	j	ffffffffc0207644 <add_timer+0x64>
ffffffffc0207614:	6718                	ld	a4,8(a4)
ffffffffc0207616:	9f95                	subw	a5,a5,a3
ffffffffc0207618:	c01c                	sw	a5,0(s0)
ffffffffc020761a:	02c70563          	beq	a4,a2,ffffffffc0207644 <add_timer+0x64>
ffffffffc020761e:	ff072683          	lw	a3,-16(a4)
ffffffffc0207622:	fed7f9e3          	bgeu	a5,a3,ffffffffc0207614 <add_timer+0x34>
ffffffffc0207626:	40f687bb          	subw	a5,a3,a5
ffffffffc020762a:	fef72823          	sw	a5,-16(a4)
ffffffffc020762e:	631c                	ld	a5,0(a4)
ffffffffc0207630:	e30c                	sd	a1,0(a4)
ffffffffc0207632:	e78c                	sd	a1,8(a5)
ffffffffc0207634:	ec18                	sd	a4,24(s0)
ffffffffc0207636:	e81c                	sd	a5,16(s0)
ffffffffc0207638:	c105                	beqz	a0,ffffffffc0207658 <add_timer+0x78>
ffffffffc020763a:	6402                	ld	s0,0(sp)
ffffffffc020763c:	60a2                	ld	ra,8(sp)
ffffffffc020763e:	0141                	addi	sp,sp,16
ffffffffc0207640:	e2cf906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0207644:	0008e717          	auipc	a4,0x8e
ffffffffc0207648:	1ac70713          	addi	a4,a4,428 # ffffffffc02957f0 <timer_list>
ffffffffc020764c:	631c                	ld	a5,0(a4)
ffffffffc020764e:	e30c                	sd	a1,0(a4)
ffffffffc0207650:	e78c                	sd	a1,8(a5)
ffffffffc0207652:	ec18                	sd	a4,24(s0)
ffffffffc0207654:	e81c                	sd	a5,16(s0)
ffffffffc0207656:	f175                	bnez	a0,ffffffffc020763a <add_timer+0x5a>
ffffffffc0207658:	60a2                	ld	ra,8(sp)
ffffffffc020765a:	6402                	ld	s0,0(sp)
ffffffffc020765c:	0141                	addi	sp,sp,16
ffffffffc020765e:	8082                	ret
ffffffffc0207660:	e12f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207664:	4505                	li	a0,1
ffffffffc0207666:	b771                	j	ffffffffc02075f2 <add_timer+0x12>
ffffffffc0207668:	00006697          	auipc	a3,0x6
ffffffffc020766c:	48068693          	addi	a3,a3,1152 # ffffffffc020dae8 <CSWTCH.79+0x568>
ffffffffc0207670:	00004617          	auipc	a2,0x4
ffffffffc0207674:	50860613          	addi	a2,a2,1288 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207678:	07a00593          	li	a1,122
ffffffffc020767c:	00006517          	auipc	a0,0x6
ffffffffc0207680:	43450513          	addi	a0,a0,1076 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc0207684:	e1bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207688:	00006697          	auipc	a3,0x6
ffffffffc020768c:	49068693          	addi	a3,a3,1168 # ffffffffc020db18 <CSWTCH.79+0x598>
ffffffffc0207690:	00004617          	auipc	a2,0x4
ffffffffc0207694:	4e860613          	addi	a2,a2,1256 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207698:	07b00593          	li	a1,123
ffffffffc020769c:	00006517          	auipc	a0,0x6
ffffffffc02076a0:	41450513          	addi	a0,a0,1044 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc02076a4:	dfbf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02076a8 <del_timer>:
ffffffffc02076a8:	1101                	addi	sp,sp,-32
ffffffffc02076aa:	e822                	sd	s0,16(sp)
ffffffffc02076ac:	ec06                	sd	ra,24(sp)
ffffffffc02076ae:	e426                	sd	s1,8(sp)
ffffffffc02076b0:	842a                	mv	s0,a0
ffffffffc02076b2:	100027f3          	csrr	a5,sstatus
ffffffffc02076b6:	8b89                	andi	a5,a5,2
ffffffffc02076b8:	01050493          	addi	s1,a0,16
ffffffffc02076bc:	eb9d                	bnez	a5,ffffffffc02076f2 <del_timer+0x4a>
ffffffffc02076be:	6d1c                	ld	a5,24(a0)
ffffffffc02076c0:	02978463          	beq	a5,s1,ffffffffc02076e8 <del_timer+0x40>
ffffffffc02076c4:	4114                	lw	a3,0(a0)
ffffffffc02076c6:	6918                	ld	a4,16(a0)
ffffffffc02076c8:	ce81                	beqz	a3,ffffffffc02076e0 <del_timer+0x38>
ffffffffc02076ca:	0008e617          	auipc	a2,0x8e
ffffffffc02076ce:	12660613          	addi	a2,a2,294 # ffffffffc02957f0 <timer_list>
ffffffffc02076d2:	00c78763          	beq	a5,a2,ffffffffc02076e0 <del_timer+0x38>
ffffffffc02076d6:	ff07a603          	lw	a2,-16(a5)
ffffffffc02076da:	9eb1                	addw	a3,a3,a2
ffffffffc02076dc:	fed7a823          	sw	a3,-16(a5)
ffffffffc02076e0:	e71c                	sd	a5,8(a4)
ffffffffc02076e2:	e398                	sd	a4,0(a5)
ffffffffc02076e4:	ec04                	sd	s1,24(s0)
ffffffffc02076e6:	e804                	sd	s1,16(s0)
ffffffffc02076e8:	60e2                	ld	ra,24(sp)
ffffffffc02076ea:	6442                	ld	s0,16(sp)
ffffffffc02076ec:	64a2                	ld	s1,8(sp)
ffffffffc02076ee:	6105                	addi	sp,sp,32
ffffffffc02076f0:	8082                	ret
ffffffffc02076f2:	d80f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02076f6:	6c1c                	ld	a5,24(s0)
ffffffffc02076f8:	02978463          	beq	a5,s1,ffffffffc0207720 <del_timer+0x78>
ffffffffc02076fc:	4014                	lw	a3,0(s0)
ffffffffc02076fe:	6818                	ld	a4,16(s0)
ffffffffc0207700:	ce81                	beqz	a3,ffffffffc0207718 <del_timer+0x70>
ffffffffc0207702:	0008e617          	auipc	a2,0x8e
ffffffffc0207706:	0ee60613          	addi	a2,a2,238 # ffffffffc02957f0 <timer_list>
ffffffffc020770a:	00c78763          	beq	a5,a2,ffffffffc0207718 <del_timer+0x70>
ffffffffc020770e:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207712:	9eb1                	addw	a3,a3,a2
ffffffffc0207714:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207718:	e71c                	sd	a5,8(a4)
ffffffffc020771a:	e398                	sd	a4,0(a5)
ffffffffc020771c:	ec04                	sd	s1,24(s0)
ffffffffc020771e:	e804                	sd	s1,16(s0)
ffffffffc0207720:	6442                	ld	s0,16(sp)
ffffffffc0207722:	60e2                	ld	ra,24(sp)
ffffffffc0207724:	64a2                	ld	s1,8(sp)
ffffffffc0207726:	6105                	addi	sp,sp,32
ffffffffc0207728:	d44f906f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc020772c <run_timer_list>:
ffffffffc020772c:	7139                	addi	sp,sp,-64
ffffffffc020772e:	fc06                	sd	ra,56(sp)
ffffffffc0207730:	f822                	sd	s0,48(sp)
ffffffffc0207732:	f426                	sd	s1,40(sp)
ffffffffc0207734:	f04a                	sd	s2,32(sp)
ffffffffc0207736:	ec4e                	sd	s3,24(sp)
ffffffffc0207738:	e852                	sd	s4,16(sp)
ffffffffc020773a:	e456                	sd	s5,8(sp)
ffffffffc020773c:	e05a                	sd	s6,0(sp)
ffffffffc020773e:	100027f3          	csrr	a5,sstatus
ffffffffc0207742:	8b89                	andi	a5,a5,2
ffffffffc0207744:	4b01                	li	s6,0
ffffffffc0207746:	efe9                	bnez	a5,ffffffffc0207820 <run_timer_list+0xf4>
ffffffffc0207748:	0008e997          	auipc	s3,0x8e
ffffffffc020774c:	0a898993          	addi	s3,s3,168 # ffffffffc02957f0 <timer_list>
ffffffffc0207750:	0089b403          	ld	s0,8(s3)
ffffffffc0207754:	07340a63          	beq	s0,s3,ffffffffc02077c8 <run_timer_list+0x9c>
ffffffffc0207758:	ff042783          	lw	a5,-16(s0)
ffffffffc020775c:	ff040913          	addi	s2,s0,-16
ffffffffc0207760:	0e078763          	beqz	a5,ffffffffc020784e <run_timer_list+0x122>
ffffffffc0207764:	fff7871b          	addiw	a4,a5,-1
ffffffffc0207768:	fee42823          	sw	a4,-16(s0)
ffffffffc020776c:	ef31                	bnez	a4,ffffffffc02077c8 <run_timer_list+0x9c>
ffffffffc020776e:	00006a97          	auipc	s5,0x6
ffffffffc0207772:	412a8a93          	addi	s5,s5,1042 # ffffffffc020db80 <CSWTCH.79+0x600>
ffffffffc0207776:	00006a17          	auipc	s4,0x6
ffffffffc020777a:	33aa0a13          	addi	s4,s4,826 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc020777e:	a005                	j	ffffffffc020779e <run_timer_list+0x72>
ffffffffc0207780:	0a07d763          	bgez	a5,ffffffffc020782e <run_timer_list+0x102>
ffffffffc0207784:	8526                	mv	a0,s1
ffffffffc0207786:	ce9ff0ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc020778a:	854a                	mv	a0,s2
ffffffffc020778c:	f1dff0ef          	jal	ra,ffffffffc02076a8 <del_timer>
ffffffffc0207790:	03340c63          	beq	s0,s3,ffffffffc02077c8 <run_timer_list+0x9c>
ffffffffc0207794:	ff042783          	lw	a5,-16(s0)
ffffffffc0207798:	ff040913          	addi	s2,s0,-16
ffffffffc020779c:	e795                	bnez	a5,ffffffffc02077c8 <run_timer_list+0x9c>
ffffffffc020779e:	00893483          	ld	s1,8(s2)
ffffffffc02077a2:	6400                	ld	s0,8(s0)
ffffffffc02077a4:	0ec4a783          	lw	a5,236(s1)
ffffffffc02077a8:	ffe1                	bnez	a5,ffffffffc0207780 <run_timer_list+0x54>
ffffffffc02077aa:	40d4                	lw	a3,4(s1)
ffffffffc02077ac:	8656                	mv	a2,s5
ffffffffc02077ae:	0ba00593          	li	a1,186
ffffffffc02077b2:	8552                	mv	a0,s4
ffffffffc02077b4:	d53f80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02077b8:	8526                	mv	a0,s1
ffffffffc02077ba:	cb5ff0ef          	jal	ra,ffffffffc020746e <wakeup_proc>
ffffffffc02077be:	854a                	mv	a0,s2
ffffffffc02077c0:	ee9ff0ef          	jal	ra,ffffffffc02076a8 <del_timer>
ffffffffc02077c4:	fd3418e3          	bne	s0,s3,ffffffffc0207794 <run_timer_list+0x68>
ffffffffc02077c8:	0008f597          	auipc	a1,0x8f
ffffffffc02077cc:	0f85b583          	ld	a1,248(a1) # ffffffffc02968c0 <current>
ffffffffc02077d0:	c18d                	beqz	a1,ffffffffc02077f2 <run_timer_list+0xc6>
ffffffffc02077d2:	0008f797          	auipc	a5,0x8f
ffffffffc02077d6:	0f67b783          	ld	a5,246(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02077da:	04f58763          	beq	a1,a5,ffffffffc0207828 <run_timer_list+0xfc>
ffffffffc02077de:	0008f797          	auipc	a5,0x8f
ffffffffc02077e2:	10a7b783          	ld	a5,266(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02077e6:	779c                	ld	a5,40(a5)
ffffffffc02077e8:	0008f517          	auipc	a0,0x8f
ffffffffc02077ec:	0f853503          	ld	a0,248(a0) # ffffffffc02968e0 <rq>
ffffffffc02077f0:	9782                	jalr	a5
ffffffffc02077f2:	000b1c63          	bnez	s6,ffffffffc020780a <run_timer_list+0xde>
ffffffffc02077f6:	70e2                	ld	ra,56(sp)
ffffffffc02077f8:	7442                	ld	s0,48(sp)
ffffffffc02077fa:	74a2                	ld	s1,40(sp)
ffffffffc02077fc:	7902                	ld	s2,32(sp)
ffffffffc02077fe:	69e2                	ld	s3,24(sp)
ffffffffc0207800:	6a42                	ld	s4,16(sp)
ffffffffc0207802:	6aa2                	ld	s5,8(sp)
ffffffffc0207804:	6b02                	ld	s6,0(sp)
ffffffffc0207806:	6121                	addi	sp,sp,64
ffffffffc0207808:	8082                	ret
ffffffffc020780a:	7442                	ld	s0,48(sp)
ffffffffc020780c:	70e2                	ld	ra,56(sp)
ffffffffc020780e:	74a2                	ld	s1,40(sp)
ffffffffc0207810:	7902                	ld	s2,32(sp)
ffffffffc0207812:	69e2                	ld	s3,24(sp)
ffffffffc0207814:	6a42                	ld	s4,16(sp)
ffffffffc0207816:	6aa2                	ld	s5,8(sp)
ffffffffc0207818:	6b02                	ld	s6,0(sp)
ffffffffc020781a:	6121                	addi	sp,sp,64
ffffffffc020781c:	c50f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0207820:	c52f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207824:	4b05                	li	s6,1
ffffffffc0207826:	b70d                	j	ffffffffc0207748 <run_timer_list+0x1c>
ffffffffc0207828:	4785                	li	a5,1
ffffffffc020782a:	ed9c                	sd	a5,24(a1)
ffffffffc020782c:	b7d9                	j	ffffffffc02077f2 <run_timer_list+0xc6>
ffffffffc020782e:	00006697          	auipc	a3,0x6
ffffffffc0207832:	32a68693          	addi	a3,a3,810 # ffffffffc020db58 <CSWTCH.79+0x5d8>
ffffffffc0207836:	00004617          	auipc	a2,0x4
ffffffffc020783a:	34260613          	addi	a2,a2,834 # ffffffffc020bb78 <commands+0x210>
ffffffffc020783e:	0b600593          	li	a1,182
ffffffffc0207842:	00006517          	auipc	a0,0x6
ffffffffc0207846:	26e50513          	addi	a0,a0,622 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc020784a:	c55f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020784e:	00006697          	auipc	a3,0x6
ffffffffc0207852:	2f268693          	addi	a3,a3,754 # ffffffffc020db40 <CSWTCH.79+0x5c0>
ffffffffc0207856:	00004617          	auipc	a2,0x4
ffffffffc020785a:	32260613          	addi	a2,a2,802 # ffffffffc020bb78 <commands+0x210>
ffffffffc020785e:	0ae00593          	li	a1,174
ffffffffc0207862:	00006517          	auipc	a0,0x6
ffffffffc0207866:	24e50513          	addi	a0,a0,590 # ffffffffc020dab0 <CSWTCH.79+0x530>
ffffffffc020786a:	c35f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020786e <sys_getpid>:
ffffffffc020786e:	0008f797          	auipc	a5,0x8f
ffffffffc0207872:	0527b783          	ld	a5,82(a5) # ffffffffc02968c0 <current>
ffffffffc0207876:	43c8                	lw	a0,4(a5)
ffffffffc0207878:	8082                	ret

ffffffffc020787a <sys_pgdir>:
ffffffffc020787a:	4501                	li	a0,0
ffffffffc020787c:	8082                	ret

ffffffffc020787e <sys_gettime>:
ffffffffc020787e:	0008f797          	auipc	a5,0x8f
ffffffffc0207882:	ff27b783          	ld	a5,-14(a5) # ffffffffc0296870 <ticks>
ffffffffc0207886:	0027951b          	slliw	a0,a5,0x2
ffffffffc020788a:	9d3d                	addw	a0,a0,a5
ffffffffc020788c:	0015151b          	slliw	a0,a0,0x1
ffffffffc0207890:	8082                	ret

ffffffffc0207892 <sys_lab6_set_priority>:
ffffffffc0207892:	4108                	lw	a0,0(a0)
ffffffffc0207894:	1141                	addi	sp,sp,-16
ffffffffc0207896:	e406                	sd	ra,8(sp)
ffffffffc0207898:	975ff0ef          	jal	ra,ffffffffc020720c <lab6_set_priority>
ffffffffc020789c:	60a2                	ld	ra,8(sp)
ffffffffc020789e:	4501                	li	a0,0
ffffffffc02078a0:	0141                	addi	sp,sp,16
ffffffffc02078a2:	8082                	ret

ffffffffc02078a4 <sys_dup>:
ffffffffc02078a4:	450c                	lw	a1,8(a0)
ffffffffc02078a6:	4108                	lw	a0,0(a0)
ffffffffc02078a8:	a20fe06f          	j	ffffffffc0205ac8 <sysfile_dup>

ffffffffc02078ac <sys_getdirentry>:
ffffffffc02078ac:	650c                	ld	a1,8(a0)
ffffffffc02078ae:	4108                	lw	a0,0(a0)
ffffffffc02078b0:	928fe06f          	j	ffffffffc02059d8 <sysfile_getdirentry>

ffffffffc02078b4 <sys_getcwd>:
ffffffffc02078b4:	650c                	ld	a1,8(a0)
ffffffffc02078b6:	6108                	ld	a0,0(a0)
ffffffffc02078b8:	87cfe06f          	j	ffffffffc0205934 <sysfile_getcwd>

ffffffffc02078bc <sys_fsync>:
ffffffffc02078bc:	4108                	lw	a0,0(a0)
ffffffffc02078be:	872fe06f          	j	ffffffffc0205930 <sysfile_fsync>

ffffffffc02078c2 <sys_fstat>:
ffffffffc02078c2:	650c                	ld	a1,8(a0)
ffffffffc02078c4:	4108                	lw	a0,0(a0)
ffffffffc02078c6:	fcbfd06f          	j	ffffffffc0205890 <sysfile_fstat>

ffffffffc02078ca <sys_seek>:
ffffffffc02078ca:	4910                	lw	a2,16(a0)
ffffffffc02078cc:	650c                	ld	a1,8(a0)
ffffffffc02078ce:	4108                	lw	a0,0(a0)
ffffffffc02078d0:	fbdfd06f          	j	ffffffffc020588c <sysfile_seek>

ffffffffc02078d4 <sys_write>:
ffffffffc02078d4:	6910                	ld	a2,16(a0)
ffffffffc02078d6:	650c                	ld	a1,8(a0)
ffffffffc02078d8:	4108                	lw	a0,0(a0)
ffffffffc02078da:	e99fd06f          	j	ffffffffc0205772 <sysfile_write>

ffffffffc02078de <sys_read>:
ffffffffc02078de:	6910                	ld	a2,16(a0)
ffffffffc02078e0:	650c                	ld	a1,8(a0)
ffffffffc02078e2:	4108                	lw	a0,0(a0)
ffffffffc02078e4:	d7bfd06f          	j	ffffffffc020565e <sysfile_read>

ffffffffc02078e8 <sys_close>:
ffffffffc02078e8:	4108                	lw	a0,0(a0)
ffffffffc02078ea:	d71fd06f          	j	ffffffffc020565a <sysfile_close>

ffffffffc02078ee <sys_open>:
ffffffffc02078ee:	450c                	lw	a1,8(a0)
ffffffffc02078f0:	6108                	ld	a0,0(a0)
ffffffffc02078f2:	d35fd06f          	j	ffffffffc0205626 <sysfile_open>

ffffffffc02078f6 <sys_putc>:
ffffffffc02078f6:	4108                	lw	a0,0(a0)
ffffffffc02078f8:	1141                	addi	sp,sp,-16
ffffffffc02078fa:	e406                	sd	ra,8(sp)
ffffffffc02078fc:	8e7f80ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0207900:	60a2                	ld	ra,8(sp)
ffffffffc0207902:	4501                	li	a0,0
ffffffffc0207904:	0141                	addi	sp,sp,16
ffffffffc0207906:	8082                	ret

ffffffffc0207908 <sys_kill>:
ffffffffc0207908:	4108                	lw	a0,0(a0)
ffffffffc020790a:	ea0ff06f          	j	ffffffffc0206faa <do_kill>

ffffffffc020790e <sys_sleep>:
ffffffffc020790e:	4108                	lw	a0,0(a0)
ffffffffc0207910:	937ff06f          	j	ffffffffc0207246 <do_sleep>

ffffffffc0207914 <sys_yield>:
ffffffffc0207914:	e48ff06f          	j	ffffffffc0206f5c <do_yield>

ffffffffc0207918 <sys_exec>:
ffffffffc0207918:	6910                	ld	a2,16(a0)
ffffffffc020791a:	450c                	lw	a1,8(a0)
ffffffffc020791c:	6108                	ld	a0,0(a0)
ffffffffc020791e:	c25fe06f          	j	ffffffffc0206542 <do_execve>

ffffffffc0207922 <sys_wait>:
ffffffffc0207922:	650c                	ld	a1,8(a0)
ffffffffc0207924:	4108                	lw	a0,0(a0)
ffffffffc0207926:	e46ff06f          	j	ffffffffc0206f6c <do_wait>

ffffffffc020792a <sys_fork>:
ffffffffc020792a:	0008f797          	auipc	a5,0x8f
ffffffffc020792e:	f967b783          	ld	a5,-106(a5) # ffffffffc02968c0 <current>
ffffffffc0207932:	73d0                	ld	a2,160(a5)
ffffffffc0207934:	4501                	li	a0,0
ffffffffc0207936:	6a0c                	ld	a1,16(a2)
ffffffffc0207938:	b1afe06f          	j	ffffffffc0205c52 <do_fork>

ffffffffc020793c <sys_exit>:
ffffffffc020793c:	4108                	lw	a0,0(a0)
ffffffffc020793e:	f80fe06f          	j	ffffffffc02060be <do_exit>

ffffffffc0207942 <syscall>:
ffffffffc0207942:	715d                	addi	sp,sp,-80
ffffffffc0207944:	fc26                	sd	s1,56(sp)
ffffffffc0207946:	0008f497          	auipc	s1,0x8f
ffffffffc020794a:	f7a48493          	addi	s1,s1,-134 # ffffffffc02968c0 <current>
ffffffffc020794e:	6098                	ld	a4,0(s1)
ffffffffc0207950:	e0a2                	sd	s0,64(sp)
ffffffffc0207952:	f84a                	sd	s2,48(sp)
ffffffffc0207954:	7340                	ld	s0,160(a4)
ffffffffc0207956:	e486                	sd	ra,72(sp)
ffffffffc0207958:	0ff00793          	li	a5,255
ffffffffc020795c:	05042903          	lw	s2,80(s0)
ffffffffc0207960:	0327ee63          	bltu	a5,s2,ffffffffc020799c <syscall+0x5a>
ffffffffc0207964:	00391713          	slli	a4,s2,0x3
ffffffffc0207968:	00006797          	auipc	a5,0x6
ffffffffc020796c:	28078793          	addi	a5,a5,640 # ffffffffc020dbe8 <syscalls>
ffffffffc0207970:	97ba                	add	a5,a5,a4
ffffffffc0207972:	639c                	ld	a5,0(a5)
ffffffffc0207974:	c785                	beqz	a5,ffffffffc020799c <syscall+0x5a>
ffffffffc0207976:	6c28                	ld	a0,88(s0)
ffffffffc0207978:	702c                	ld	a1,96(s0)
ffffffffc020797a:	7430                	ld	a2,104(s0)
ffffffffc020797c:	7834                	ld	a3,112(s0)
ffffffffc020797e:	7c38                	ld	a4,120(s0)
ffffffffc0207980:	e42a                	sd	a0,8(sp)
ffffffffc0207982:	e82e                	sd	a1,16(sp)
ffffffffc0207984:	ec32                	sd	a2,24(sp)
ffffffffc0207986:	f036                	sd	a3,32(sp)
ffffffffc0207988:	f43a                	sd	a4,40(sp)
ffffffffc020798a:	0028                	addi	a0,sp,8
ffffffffc020798c:	9782                	jalr	a5
ffffffffc020798e:	60a6                	ld	ra,72(sp)
ffffffffc0207990:	e828                	sd	a0,80(s0)
ffffffffc0207992:	6406                	ld	s0,64(sp)
ffffffffc0207994:	74e2                	ld	s1,56(sp)
ffffffffc0207996:	7942                	ld	s2,48(sp)
ffffffffc0207998:	6161                	addi	sp,sp,80
ffffffffc020799a:	8082                	ret
ffffffffc020799c:	8522                	mv	a0,s0
ffffffffc020799e:	decf90ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc02079a2:	609c                	ld	a5,0(s1)
ffffffffc02079a4:	86ca                	mv	a3,s2
ffffffffc02079a6:	00006617          	auipc	a2,0x6
ffffffffc02079aa:	1fa60613          	addi	a2,a2,506 # ffffffffc020dba0 <CSWTCH.79+0x620>
ffffffffc02079ae:	43d8                	lw	a4,4(a5)
ffffffffc02079b0:	0d800593          	li	a1,216
ffffffffc02079b4:	0b478793          	addi	a5,a5,180
ffffffffc02079b8:	00006517          	auipc	a0,0x6
ffffffffc02079bc:	21850513          	addi	a0,a0,536 # ffffffffc020dbd0 <CSWTCH.79+0x650>
ffffffffc02079c0:	adff80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02079c4 <__alloc_inode>:
ffffffffc02079c4:	1141                	addi	sp,sp,-16
ffffffffc02079c6:	e022                	sd	s0,0(sp)
ffffffffc02079c8:	842a                	mv	s0,a0
ffffffffc02079ca:	07800513          	li	a0,120
ffffffffc02079ce:	e406                	sd	ra,8(sp)
ffffffffc02079d0:	e46fa0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02079d4:	c111                	beqz	a0,ffffffffc02079d8 <__alloc_inode+0x14>
ffffffffc02079d6:	cd20                	sw	s0,88(a0)
ffffffffc02079d8:	60a2                	ld	ra,8(sp)
ffffffffc02079da:	6402                	ld	s0,0(sp)
ffffffffc02079dc:	0141                	addi	sp,sp,16
ffffffffc02079de:	8082                	ret

ffffffffc02079e0 <inode_init>:
ffffffffc02079e0:	4785                	li	a5,1
ffffffffc02079e2:	06052023          	sw	zero,96(a0)
ffffffffc02079e6:	f92c                	sd	a1,112(a0)
ffffffffc02079e8:	f530                	sd	a2,104(a0)
ffffffffc02079ea:	cd7c                	sw	a5,92(a0)
ffffffffc02079ec:	8082                	ret

ffffffffc02079ee <inode_kill>:
ffffffffc02079ee:	4d78                	lw	a4,92(a0)
ffffffffc02079f0:	1141                	addi	sp,sp,-16
ffffffffc02079f2:	e406                	sd	ra,8(sp)
ffffffffc02079f4:	e719                	bnez	a4,ffffffffc0207a02 <inode_kill+0x14>
ffffffffc02079f6:	513c                	lw	a5,96(a0)
ffffffffc02079f8:	e78d                	bnez	a5,ffffffffc0207a22 <inode_kill+0x34>
ffffffffc02079fa:	60a2                	ld	ra,8(sp)
ffffffffc02079fc:	0141                	addi	sp,sp,16
ffffffffc02079fe:	ec8fa06f          	j	ffffffffc02020c6 <kfree>
ffffffffc0207a02:	00007697          	auipc	a3,0x7
ffffffffc0207a06:	9e668693          	addi	a3,a3,-1562 # ffffffffc020e3e8 <syscalls+0x800>
ffffffffc0207a0a:	00004617          	auipc	a2,0x4
ffffffffc0207a0e:	16e60613          	addi	a2,a2,366 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207a12:	02900593          	li	a1,41
ffffffffc0207a16:	00007517          	auipc	a0,0x7
ffffffffc0207a1a:	9f250513          	addi	a0,a0,-1550 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207a1e:	a81f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207a22:	00007697          	auipc	a3,0x7
ffffffffc0207a26:	9fe68693          	addi	a3,a3,-1538 # ffffffffc020e420 <syscalls+0x838>
ffffffffc0207a2a:	00004617          	auipc	a2,0x4
ffffffffc0207a2e:	14e60613          	addi	a2,a2,334 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207a32:	02a00593          	li	a1,42
ffffffffc0207a36:	00007517          	auipc	a0,0x7
ffffffffc0207a3a:	9d250513          	addi	a0,a0,-1582 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207a3e:	a61f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207a42 <inode_ref_inc>:
ffffffffc0207a42:	4d7c                	lw	a5,92(a0)
ffffffffc0207a44:	2785                	addiw	a5,a5,1
ffffffffc0207a46:	cd7c                	sw	a5,92(a0)
ffffffffc0207a48:	0007851b          	sext.w	a0,a5
ffffffffc0207a4c:	8082                	ret

ffffffffc0207a4e <inode_open_inc>:
ffffffffc0207a4e:	513c                	lw	a5,96(a0)
ffffffffc0207a50:	2785                	addiw	a5,a5,1
ffffffffc0207a52:	d13c                	sw	a5,96(a0)
ffffffffc0207a54:	0007851b          	sext.w	a0,a5
ffffffffc0207a58:	8082                	ret

ffffffffc0207a5a <inode_check>:
ffffffffc0207a5a:	1141                	addi	sp,sp,-16
ffffffffc0207a5c:	e406                	sd	ra,8(sp)
ffffffffc0207a5e:	c90d                	beqz	a0,ffffffffc0207a90 <inode_check+0x36>
ffffffffc0207a60:	793c                	ld	a5,112(a0)
ffffffffc0207a62:	c79d                	beqz	a5,ffffffffc0207a90 <inode_check+0x36>
ffffffffc0207a64:	6398                	ld	a4,0(a5)
ffffffffc0207a66:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207a6a:	0786                	slli	a5,a5,0x1
ffffffffc0207a6c:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207a70:	08f71063          	bne	a4,a5,ffffffffc0207af0 <inode_check+0x96>
ffffffffc0207a74:	4d78                	lw	a4,92(a0)
ffffffffc0207a76:	513c                	lw	a5,96(a0)
ffffffffc0207a78:	04f74c63          	blt	a4,a5,ffffffffc0207ad0 <inode_check+0x76>
ffffffffc0207a7c:	0407ca63          	bltz	a5,ffffffffc0207ad0 <inode_check+0x76>
ffffffffc0207a80:	66c1                	lui	a3,0x10
ffffffffc0207a82:	02d75763          	bge	a4,a3,ffffffffc0207ab0 <inode_check+0x56>
ffffffffc0207a86:	02d7d563          	bge	a5,a3,ffffffffc0207ab0 <inode_check+0x56>
ffffffffc0207a8a:	60a2                	ld	ra,8(sp)
ffffffffc0207a8c:	0141                	addi	sp,sp,16
ffffffffc0207a8e:	8082                	ret
ffffffffc0207a90:	00007697          	auipc	a3,0x7
ffffffffc0207a94:	9b068693          	addi	a3,a3,-1616 # ffffffffc020e440 <syscalls+0x858>
ffffffffc0207a98:	00004617          	auipc	a2,0x4
ffffffffc0207a9c:	0e060613          	addi	a2,a2,224 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207aa0:	06e00593          	li	a1,110
ffffffffc0207aa4:	00007517          	auipc	a0,0x7
ffffffffc0207aa8:	96450513          	addi	a0,a0,-1692 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207aac:	9f3f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207ab0:	00007697          	auipc	a3,0x7
ffffffffc0207ab4:	a1068693          	addi	a3,a3,-1520 # ffffffffc020e4c0 <syscalls+0x8d8>
ffffffffc0207ab8:	00004617          	auipc	a2,0x4
ffffffffc0207abc:	0c060613          	addi	a2,a2,192 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207ac0:	07200593          	li	a1,114
ffffffffc0207ac4:	00007517          	auipc	a0,0x7
ffffffffc0207ac8:	94450513          	addi	a0,a0,-1724 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207acc:	9d3f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207ad0:	00007697          	auipc	a3,0x7
ffffffffc0207ad4:	9c068693          	addi	a3,a3,-1600 # ffffffffc020e490 <syscalls+0x8a8>
ffffffffc0207ad8:	00004617          	auipc	a2,0x4
ffffffffc0207adc:	0a060613          	addi	a2,a2,160 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207ae0:	07100593          	li	a1,113
ffffffffc0207ae4:	00007517          	auipc	a0,0x7
ffffffffc0207ae8:	92450513          	addi	a0,a0,-1756 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207aec:	9b3f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207af0:	00007697          	auipc	a3,0x7
ffffffffc0207af4:	97868693          	addi	a3,a3,-1672 # ffffffffc020e468 <syscalls+0x880>
ffffffffc0207af8:	00004617          	auipc	a2,0x4
ffffffffc0207afc:	08060613          	addi	a2,a2,128 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207b00:	06f00593          	li	a1,111
ffffffffc0207b04:	00007517          	auipc	a0,0x7
ffffffffc0207b08:	90450513          	addi	a0,a0,-1788 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207b0c:	993f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207b10 <inode_ref_dec>:
ffffffffc0207b10:	4d7c                	lw	a5,92(a0)
ffffffffc0207b12:	1101                	addi	sp,sp,-32
ffffffffc0207b14:	ec06                	sd	ra,24(sp)
ffffffffc0207b16:	e822                	sd	s0,16(sp)
ffffffffc0207b18:	e426                	sd	s1,8(sp)
ffffffffc0207b1a:	e04a                	sd	s2,0(sp)
ffffffffc0207b1c:	06f05e63          	blez	a5,ffffffffc0207b98 <inode_ref_dec+0x88>
ffffffffc0207b20:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207b24:	cd64                	sw	s1,92(a0)
ffffffffc0207b26:	842a                	mv	s0,a0
ffffffffc0207b28:	e09d                	bnez	s1,ffffffffc0207b4e <inode_ref_dec+0x3e>
ffffffffc0207b2a:	793c                	ld	a5,112(a0)
ffffffffc0207b2c:	c7b1                	beqz	a5,ffffffffc0207b78 <inode_ref_dec+0x68>
ffffffffc0207b2e:	0487b903          	ld	s2,72(a5)
ffffffffc0207b32:	04090363          	beqz	s2,ffffffffc0207b78 <inode_ref_dec+0x68>
ffffffffc0207b36:	00007597          	auipc	a1,0x7
ffffffffc0207b3a:	a3a58593          	addi	a1,a1,-1478 # ffffffffc020e570 <syscalls+0x988>
ffffffffc0207b3e:	f1dff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0207b42:	8522                	mv	a0,s0
ffffffffc0207b44:	9902                	jalr	s2
ffffffffc0207b46:	c501                	beqz	a0,ffffffffc0207b4e <inode_ref_dec+0x3e>
ffffffffc0207b48:	57c5                	li	a5,-15
ffffffffc0207b4a:	00f51963          	bne	a0,a5,ffffffffc0207b5c <inode_ref_dec+0x4c>
ffffffffc0207b4e:	60e2                	ld	ra,24(sp)
ffffffffc0207b50:	6442                	ld	s0,16(sp)
ffffffffc0207b52:	6902                	ld	s2,0(sp)
ffffffffc0207b54:	8526                	mv	a0,s1
ffffffffc0207b56:	64a2                	ld	s1,8(sp)
ffffffffc0207b58:	6105                	addi	sp,sp,32
ffffffffc0207b5a:	8082                	ret
ffffffffc0207b5c:	85aa                	mv	a1,a0
ffffffffc0207b5e:	00007517          	auipc	a0,0x7
ffffffffc0207b62:	a1a50513          	addi	a0,a0,-1510 # ffffffffc020e578 <syscalls+0x990>
ffffffffc0207b66:	e40f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207b6a:	60e2                	ld	ra,24(sp)
ffffffffc0207b6c:	6442                	ld	s0,16(sp)
ffffffffc0207b6e:	6902                	ld	s2,0(sp)
ffffffffc0207b70:	8526                	mv	a0,s1
ffffffffc0207b72:	64a2                	ld	s1,8(sp)
ffffffffc0207b74:	6105                	addi	sp,sp,32
ffffffffc0207b76:	8082                	ret
ffffffffc0207b78:	00007697          	auipc	a3,0x7
ffffffffc0207b7c:	9a868693          	addi	a3,a3,-1624 # ffffffffc020e520 <syscalls+0x938>
ffffffffc0207b80:	00004617          	auipc	a2,0x4
ffffffffc0207b84:	ff860613          	addi	a2,a2,-8 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207b88:	04400593          	li	a1,68
ffffffffc0207b8c:	00007517          	auipc	a0,0x7
ffffffffc0207b90:	87c50513          	addi	a0,a0,-1924 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207b94:	90bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207b98:	00007697          	auipc	a3,0x7
ffffffffc0207b9c:	96868693          	addi	a3,a3,-1688 # ffffffffc020e500 <syscalls+0x918>
ffffffffc0207ba0:	00004617          	auipc	a2,0x4
ffffffffc0207ba4:	fd860613          	addi	a2,a2,-40 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207ba8:	03f00593          	li	a1,63
ffffffffc0207bac:	00007517          	auipc	a0,0x7
ffffffffc0207bb0:	85c50513          	addi	a0,a0,-1956 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207bb4:	8ebf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207bb8 <inode_open_dec>:
ffffffffc0207bb8:	513c                	lw	a5,96(a0)
ffffffffc0207bba:	1101                	addi	sp,sp,-32
ffffffffc0207bbc:	ec06                	sd	ra,24(sp)
ffffffffc0207bbe:	e822                	sd	s0,16(sp)
ffffffffc0207bc0:	e426                	sd	s1,8(sp)
ffffffffc0207bc2:	e04a                	sd	s2,0(sp)
ffffffffc0207bc4:	06f05b63          	blez	a5,ffffffffc0207c3a <inode_open_dec+0x82>
ffffffffc0207bc8:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207bcc:	d124                	sw	s1,96(a0)
ffffffffc0207bce:	842a                	mv	s0,a0
ffffffffc0207bd0:	e085                	bnez	s1,ffffffffc0207bf0 <inode_open_dec+0x38>
ffffffffc0207bd2:	793c                	ld	a5,112(a0)
ffffffffc0207bd4:	c3b9                	beqz	a5,ffffffffc0207c1a <inode_open_dec+0x62>
ffffffffc0207bd6:	0107b903          	ld	s2,16(a5)
ffffffffc0207bda:	04090063          	beqz	s2,ffffffffc0207c1a <inode_open_dec+0x62>
ffffffffc0207bde:	00007597          	auipc	a1,0x7
ffffffffc0207be2:	a2a58593          	addi	a1,a1,-1494 # ffffffffc020e608 <syscalls+0xa20>
ffffffffc0207be6:	e75ff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0207bea:	8522                	mv	a0,s0
ffffffffc0207bec:	9902                	jalr	s2
ffffffffc0207bee:	e901                	bnez	a0,ffffffffc0207bfe <inode_open_dec+0x46>
ffffffffc0207bf0:	60e2                	ld	ra,24(sp)
ffffffffc0207bf2:	6442                	ld	s0,16(sp)
ffffffffc0207bf4:	6902                	ld	s2,0(sp)
ffffffffc0207bf6:	8526                	mv	a0,s1
ffffffffc0207bf8:	64a2                	ld	s1,8(sp)
ffffffffc0207bfa:	6105                	addi	sp,sp,32
ffffffffc0207bfc:	8082                	ret
ffffffffc0207bfe:	85aa                	mv	a1,a0
ffffffffc0207c00:	00007517          	auipc	a0,0x7
ffffffffc0207c04:	a1050513          	addi	a0,a0,-1520 # ffffffffc020e610 <syscalls+0xa28>
ffffffffc0207c08:	d9ef80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207c0c:	60e2                	ld	ra,24(sp)
ffffffffc0207c0e:	6442                	ld	s0,16(sp)
ffffffffc0207c10:	6902                	ld	s2,0(sp)
ffffffffc0207c12:	8526                	mv	a0,s1
ffffffffc0207c14:	64a2                	ld	s1,8(sp)
ffffffffc0207c16:	6105                	addi	sp,sp,32
ffffffffc0207c18:	8082                	ret
ffffffffc0207c1a:	00007697          	auipc	a3,0x7
ffffffffc0207c1e:	99e68693          	addi	a3,a3,-1634 # ffffffffc020e5b8 <syscalls+0x9d0>
ffffffffc0207c22:	00004617          	auipc	a2,0x4
ffffffffc0207c26:	f5660613          	addi	a2,a2,-170 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207c2a:	06100593          	li	a1,97
ffffffffc0207c2e:	00006517          	auipc	a0,0x6
ffffffffc0207c32:	7da50513          	addi	a0,a0,2010 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207c36:	869f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207c3a:	00007697          	auipc	a3,0x7
ffffffffc0207c3e:	95e68693          	addi	a3,a3,-1698 # ffffffffc020e598 <syscalls+0x9b0>
ffffffffc0207c42:	00004617          	auipc	a2,0x4
ffffffffc0207c46:	f3660613          	addi	a2,a2,-202 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207c4a:	05c00593          	li	a1,92
ffffffffc0207c4e:	00006517          	auipc	a0,0x6
ffffffffc0207c52:	7ba50513          	addi	a0,a0,1978 # ffffffffc020e408 <syscalls+0x820>
ffffffffc0207c56:	849f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207c5a <__alloc_fs>:
ffffffffc0207c5a:	1141                	addi	sp,sp,-16
ffffffffc0207c5c:	e022                	sd	s0,0(sp)
ffffffffc0207c5e:	842a                	mv	s0,a0
ffffffffc0207c60:	0d800513          	li	a0,216
ffffffffc0207c64:	e406                	sd	ra,8(sp)
ffffffffc0207c66:	bb0fa0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0207c6a:	c119                	beqz	a0,ffffffffc0207c70 <__alloc_fs+0x16>
ffffffffc0207c6c:	0a852823          	sw	s0,176(a0)
ffffffffc0207c70:	60a2                	ld	ra,8(sp)
ffffffffc0207c72:	6402                	ld	s0,0(sp)
ffffffffc0207c74:	0141                	addi	sp,sp,16
ffffffffc0207c76:	8082                	ret

ffffffffc0207c78 <vfs_init>:
ffffffffc0207c78:	1141                	addi	sp,sp,-16
ffffffffc0207c7a:	4585                	li	a1,1
ffffffffc0207c7c:	0008e517          	auipc	a0,0x8e
ffffffffc0207c80:	b8450513          	addi	a0,a0,-1148 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c84:	e406                	sd	ra,8(sp)
ffffffffc0207c86:	9d5fc0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0207c8a:	60a2                	ld	ra,8(sp)
ffffffffc0207c8c:	0141                	addi	sp,sp,16
ffffffffc0207c8e:	a40d                	j	ffffffffc0207eb0 <vfs_devlist_init>

ffffffffc0207c90 <vfs_set_bootfs>:
ffffffffc0207c90:	7179                	addi	sp,sp,-48
ffffffffc0207c92:	f022                	sd	s0,32(sp)
ffffffffc0207c94:	f406                	sd	ra,40(sp)
ffffffffc0207c96:	ec26                	sd	s1,24(sp)
ffffffffc0207c98:	e402                	sd	zero,8(sp)
ffffffffc0207c9a:	842a                	mv	s0,a0
ffffffffc0207c9c:	c915                	beqz	a0,ffffffffc0207cd0 <vfs_set_bootfs+0x40>
ffffffffc0207c9e:	03a00593          	li	a1,58
ffffffffc0207ca2:	1dd030ef          	jal	ra,ffffffffc020b67e <strchr>
ffffffffc0207ca6:	c135                	beqz	a0,ffffffffc0207d0a <vfs_set_bootfs+0x7a>
ffffffffc0207ca8:	00154783          	lbu	a5,1(a0)
ffffffffc0207cac:	efb9                	bnez	a5,ffffffffc0207d0a <vfs_set_bootfs+0x7a>
ffffffffc0207cae:	8522                	mv	a0,s0
ffffffffc0207cb0:	11f000ef          	jal	ra,ffffffffc02085ce <vfs_chdir>
ffffffffc0207cb4:	842a                	mv	s0,a0
ffffffffc0207cb6:	c519                	beqz	a0,ffffffffc0207cc4 <vfs_set_bootfs+0x34>
ffffffffc0207cb8:	70a2                	ld	ra,40(sp)
ffffffffc0207cba:	8522                	mv	a0,s0
ffffffffc0207cbc:	7402                	ld	s0,32(sp)
ffffffffc0207cbe:	64e2                	ld	s1,24(sp)
ffffffffc0207cc0:	6145                	addi	sp,sp,48
ffffffffc0207cc2:	8082                	ret
ffffffffc0207cc4:	0028                	addi	a0,sp,8
ffffffffc0207cc6:	013000ef          	jal	ra,ffffffffc02084d8 <vfs_get_curdir>
ffffffffc0207cca:	842a                	mv	s0,a0
ffffffffc0207ccc:	f575                	bnez	a0,ffffffffc0207cb8 <vfs_set_bootfs+0x28>
ffffffffc0207cce:	6422                	ld	s0,8(sp)
ffffffffc0207cd0:	0008e517          	auipc	a0,0x8e
ffffffffc0207cd4:	b3050513          	addi	a0,a0,-1232 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207cd8:	98dfc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0207cdc:	0008f797          	auipc	a5,0x8f
ffffffffc0207ce0:	c1478793          	addi	a5,a5,-1004 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207ce4:	6384                	ld	s1,0(a5)
ffffffffc0207ce6:	0008e517          	auipc	a0,0x8e
ffffffffc0207cea:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207cee:	e380                	sd	s0,0(a5)
ffffffffc0207cf0:	4401                	li	s0,0
ffffffffc0207cf2:	96ffc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207cf6:	d0e9                	beqz	s1,ffffffffc0207cb8 <vfs_set_bootfs+0x28>
ffffffffc0207cf8:	8526                	mv	a0,s1
ffffffffc0207cfa:	e17ff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc0207cfe:	70a2                	ld	ra,40(sp)
ffffffffc0207d00:	8522                	mv	a0,s0
ffffffffc0207d02:	7402                	ld	s0,32(sp)
ffffffffc0207d04:	64e2                	ld	s1,24(sp)
ffffffffc0207d06:	6145                	addi	sp,sp,48
ffffffffc0207d08:	8082                	ret
ffffffffc0207d0a:	5475                	li	s0,-3
ffffffffc0207d0c:	b775                	j	ffffffffc0207cb8 <vfs_set_bootfs+0x28>

ffffffffc0207d0e <vfs_get_bootfs>:
ffffffffc0207d0e:	1101                	addi	sp,sp,-32
ffffffffc0207d10:	e426                	sd	s1,8(sp)
ffffffffc0207d12:	0008f497          	auipc	s1,0x8f
ffffffffc0207d16:	bde48493          	addi	s1,s1,-1058 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207d1a:	609c                	ld	a5,0(s1)
ffffffffc0207d1c:	ec06                	sd	ra,24(sp)
ffffffffc0207d1e:	e822                	sd	s0,16(sp)
ffffffffc0207d20:	c3a1                	beqz	a5,ffffffffc0207d60 <vfs_get_bootfs+0x52>
ffffffffc0207d22:	842a                	mv	s0,a0
ffffffffc0207d24:	0008e517          	auipc	a0,0x8e
ffffffffc0207d28:	adc50513          	addi	a0,a0,-1316 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207d2c:	939fc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0207d30:	6084                	ld	s1,0(s1)
ffffffffc0207d32:	c08d                	beqz	s1,ffffffffc0207d54 <vfs_get_bootfs+0x46>
ffffffffc0207d34:	8526                	mv	a0,s1
ffffffffc0207d36:	d0dff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0207d3a:	0008e517          	auipc	a0,0x8e
ffffffffc0207d3e:	ac650513          	addi	a0,a0,-1338 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207d42:	91ffc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207d46:	4501                	li	a0,0
ffffffffc0207d48:	e004                	sd	s1,0(s0)
ffffffffc0207d4a:	60e2                	ld	ra,24(sp)
ffffffffc0207d4c:	6442                	ld	s0,16(sp)
ffffffffc0207d4e:	64a2                	ld	s1,8(sp)
ffffffffc0207d50:	6105                	addi	sp,sp,32
ffffffffc0207d52:	8082                	ret
ffffffffc0207d54:	0008e517          	auipc	a0,0x8e
ffffffffc0207d58:	aac50513          	addi	a0,a0,-1364 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207d5c:	905fc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207d60:	5541                	li	a0,-16
ffffffffc0207d62:	b7e5                	j	ffffffffc0207d4a <vfs_get_bootfs+0x3c>

ffffffffc0207d64 <vfs_do_add>:
ffffffffc0207d64:	7139                	addi	sp,sp,-64
ffffffffc0207d66:	fc06                	sd	ra,56(sp)
ffffffffc0207d68:	f822                	sd	s0,48(sp)
ffffffffc0207d6a:	f426                	sd	s1,40(sp)
ffffffffc0207d6c:	f04a                	sd	s2,32(sp)
ffffffffc0207d6e:	ec4e                	sd	s3,24(sp)
ffffffffc0207d70:	e852                	sd	s4,16(sp)
ffffffffc0207d72:	e456                	sd	s5,8(sp)
ffffffffc0207d74:	e05a                	sd	s6,0(sp)
ffffffffc0207d76:	0e050b63          	beqz	a0,ffffffffc0207e6c <vfs_do_add+0x108>
ffffffffc0207d7a:	842a                	mv	s0,a0
ffffffffc0207d7c:	8a2e                	mv	s4,a1
ffffffffc0207d7e:	8b32                	mv	s6,a2
ffffffffc0207d80:	8ab6                	mv	s5,a3
ffffffffc0207d82:	c5cd                	beqz	a1,ffffffffc0207e2c <vfs_do_add+0xc8>
ffffffffc0207d84:	4db8                	lw	a4,88(a1)
ffffffffc0207d86:	6785                	lui	a5,0x1
ffffffffc0207d88:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207d8c:	0af71163          	bne	a4,a5,ffffffffc0207e2e <vfs_do_add+0xca>
ffffffffc0207d90:	8522                	mv	a0,s0
ffffffffc0207d92:	061030ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc0207d96:	47fd                	li	a5,31
ffffffffc0207d98:	0ca7e663          	bltu	a5,a0,ffffffffc0207e64 <vfs_do_add+0x100>
ffffffffc0207d9c:	8522                	mv	a0,s0
ffffffffc0207d9e:	c56f80ef          	jal	ra,ffffffffc02001f4 <strdup>
ffffffffc0207da2:	84aa                	mv	s1,a0
ffffffffc0207da4:	c171                	beqz	a0,ffffffffc0207e68 <vfs_do_add+0x104>
ffffffffc0207da6:	03000513          	li	a0,48
ffffffffc0207daa:	a6cfa0ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0207dae:	89aa                	mv	s3,a0
ffffffffc0207db0:	c92d                	beqz	a0,ffffffffc0207e22 <vfs_do_add+0xbe>
ffffffffc0207db2:	0008e517          	auipc	a0,0x8e
ffffffffc0207db6:	a7650513          	addi	a0,a0,-1418 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207dba:	0008e917          	auipc	s2,0x8e
ffffffffc0207dbe:	a5e90913          	addi	s2,s2,-1442 # ffffffffc0295818 <vdev_list>
ffffffffc0207dc2:	8a3fc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0207dc6:	844a                	mv	s0,s2
ffffffffc0207dc8:	a039                	j	ffffffffc0207dd6 <vfs_do_add+0x72>
ffffffffc0207dca:	fe043503          	ld	a0,-32(s0)
ffffffffc0207dce:	85a6                	mv	a1,s1
ffffffffc0207dd0:	06b030ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc0207dd4:	cd2d                	beqz	a0,ffffffffc0207e4e <vfs_do_add+0xea>
ffffffffc0207dd6:	6400                	ld	s0,8(s0)
ffffffffc0207dd8:	ff2419e3          	bne	s0,s2,ffffffffc0207dca <vfs_do_add+0x66>
ffffffffc0207ddc:	6418                	ld	a4,8(s0)
ffffffffc0207dde:	02098793          	addi	a5,s3,32
ffffffffc0207de2:	0099b023          	sd	s1,0(s3)
ffffffffc0207de6:	0149b423          	sd	s4,8(s3)
ffffffffc0207dea:	0159bc23          	sd	s5,24(s3)
ffffffffc0207dee:	0169b823          	sd	s6,16(s3)
ffffffffc0207df2:	e31c                	sd	a5,0(a4)
ffffffffc0207df4:	0289b023          	sd	s0,32(s3)
ffffffffc0207df8:	02e9b423          	sd	a4,40(s3)
ffffffffc0207dfc:	0008e517          	auipc	a0,0x8e
ffffffffc0207e00:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e04:	e41c                	sd	a5,8(s0)
ffffffffc0207e06:	4401                	li	s0,0
ffffffffc0207e08:	859fc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207e0c:	70e2                	ld	ra,56(sp)
ffffffffc0207e0e:	8522                	mv	a0,s0
ffffffffc0207e10:	7442                	ld	s0,48(sp)
ffffffffc0207e12:	74a2                	ld	s1,40(sp)
ffffffffc0207e14:	7902                	ld	s2,32(sp)
ffffffffc0207e16:	69e2                	ld	s3,24(sp)
ffffffffc0207e18:	6a42                	ld	s4,16(sp)
ffffffffc0207e1a:	6aa2                	ld	s5,8(sp)
ffffffffc0207e1c:	6b02                	ld	s6,0(sp)
ffffffffc0207e1e:	6121                	addi	sp,sp,64
ffffffffc0207e20:	8082                	ret
ffffffffc0207e22:	5471                	li	s0,-4
ffffffffc0207e24:	8526                	mv	a0,s1
ffffffffc0207e26:	aa0fa0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0207e2a:	b7cd                	j	ffffffffc0207e0c <vfs_do_add+0xa8>
ffffffffc0207e2c:	d2b5                	beqz	a3,ffffffffc0207d90 <vfs_do_add+0x2c>
ffffffffc0207e2e:	00007697          	auipc	a3,0x7
ffffffffc0207e32:	82a68693          	addi	a3,a3,-2006 # ffffffffc020e658 <syscalls+0xa70>
ffffffffc0207e36:	00004617          	auipc	a2,0x4
ffffffffc0207e3a:	d4260613          	addi	a2,a2,-702 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207e3e:	08f00593          	li	a1,143
ffffffffc0207e42:	00006517          	auipc	a0,0x6
ffffffffc0207e46:	7fe50513          	addi	a0,a0,2046 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc0207e4a:	e54f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207e4e:	0008e517          	auipc	a0,0x8e
ffffffffc0207e52:	9da50513          	addi	a0,a0,-1574 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e56:	80bfc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207e5a:	854e                	mv	a0,s3
ffffffffc0207e5c:	a6afa0ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0207e60:	5425                	li	s0,-23
ffffffffc0207e62:	b7c9                	j	ffffffffc0207e24 <vfs_do_add+0xc0>
ffffffffc0207e64:	5451                	li	s0,-12
ffffffffc0207e66:	b75d                	j	ffffffffc0207e0c <vfs_do_add+0xa8>
ffffffffc0207e68:	5471                	li	s0,-4
ffffffffc0207e6a:	b74d                	j	ffffffffc0207e0c <vfs_do_add+0xa8>
ffffffffc0207e6c:	00006697          	auipc	a3,0x6
ffffffffc0207e70:	7c468693          	addi	a3,a3,1988 # ffffffffc020e630 <syscalls+0xa48>
ffffffffc0207e74:	00004617          	auipc	a2,0x4
ffffffffc0207e78:	d0460613          	addi	a2,a2,-764 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207e7c:	08e00593          	li	a1,142
ffffffffc0207e80:	00006517          	auipc	a0,0x6
ffffffffc0207e84:	7c050513          	addi	a0,a0,1984 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc0207e88:	e16f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207e8c <find_mount.part.0>:
ffffffffc0207e8c:	1141                	addi	sp,sp,-16
ffffffffc0207e8e:	00006697          	auipc	a3,0x6
ffffffffc0207e92:	7a268693          	addi	a3,a3,1954 # ffffffffc020e630 <syscalls+0xa48>
ffffffffc0207e96:	00004617          	auipc	a2,0x4
ffffffffc0207e9a:	ce260613          	addi	a2,a2,-798 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207e9e:	0cd00593          	li	a1,205
ffffffffc0207ea2:	00006517          	auipc	a0,0x6
ffffffffc0207ea6:	79e50513          	addi	a0,a0,1950 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc0207eaa:	e406                	sd	ra,8(sp)
ffffffffc0207eac:	df2f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207eb0 <vfs_devlist_init>:
ffffffffc0207eb0:	0008e797          	auipc	a5,0x8e
ffffffffc0207eb4:	96878793          	addi	a5,a5,-1688 # ffffffffc0295818 <vdev_list>
ffffffffc0207eb8:	4585                	li	a1,1
ffffffffc0207eba:	0008e517          	auipc	a0,0x8e
ffffffffc0207ebe:	96e50513          	addi	a0,a0,-1682 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207ec2:	e79c                	sd	a5,8(a5)
ffffffffc0207ec4:	e39c                	sd	a5,0(a5)
ffffffffc0207ec6:	f94fc06f          	j	ffffffffc020465a <sem_init>

ffffffffc0207eca <vfs_cleanup>:
ffffffffc0207eca:	1101                	addi	sp,sp,-32
ffffffffc0207ecc:	e426                	sd	s1,8(sp)
ffffffffc0207ece:	0008e497          	auipc	s1,0x8e
ffffffffc0207ed2:	94a48493          	addi	s1,s1,-1718 # ffffffffc0295818 <vdev_list>
ffffffffc0207ed6:	649c                	ld	a5,8(s1)
ffffffffc0207ed8:	ec06                	sd	ra,24(sp)
ffffffffc0207eda:	e822                	sd	s0,16(sp)
ffffffffc0207edc:	02978e63          	beq	a5,s1,ffffffffc0207f18 <vfs_cleanup+0x4e>
ffffffffc0207ee0:	0008e517          	auipc	a0,0x8e
ffffffffc0207ee4:	94850513          	addi	a0,a0,-1720 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207ee8:	f7cfc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0207eec:	6480                	ld	s0,8(s1)
ffffffffc0207eee:	00940b63          	beq	s0,s1,ffffffffc0207f04 <vfs_cleanup+0x3a>
ffffffffc0207ef2:	ff043783          	ld	a5,-16(s0)
ffffffffc0207ef6:	853e                	mv	a0,a5
ffffffffc0207ef8:	c399                	beqz	a5,ffffffffc0207efe <vfs_cleanup+0x34>
ffffffffc0207efa:	6bfc                	ld	a5,208(a5)
ffffffffc0207efc:	9782                	jalr	a5
ffffffffc0207efe:	6400                	ld	s0,8(s0)
ffffffffc0207f00:	fe9419e3          	bne	s0,s1,ffffffffc0207ef2 <vfs_cleanup+0x28>
ffffffffc0207f04:	6442                	ld	s0,16(sp)
ffffffffc0207f06:	60e2                	ld	ra,24(sp)
ffffffffc0207f08:	64a2                	ld	s1,8(sp)
ffffffffc0207f0a:	0008e517          	auipc	a0,0x8e
ffffffffc0207f0e:	91e50513          	addi	a0,a0,-1762 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f12:	6105                	addi	sp,sp,32
ffffffffc0207f14:	f4cfc06f          	j	ffffffffc0204660 <up>
ffffffffc0207f18:	60e2                	ld	ra,24(sp)
ffffffffc0207f1a:	6442                	ld	s0,16(sp)
ffffffffc0207f1c:	64a2                	ld	s1,8(sp)
ffffffffc0207f1e:	6105                	addi	sp,sp,32
ffffffffc0207f20:	8082                	ret

ffffffffc0207f22 <vfs_get_root>:
ffffffffc0207f22:	7179                	addi	sp,sp,-48
ffffffffc0207f24:	f406                	sd	ra,40(sp)
ffffffffc0207f26:	f022                	sd	s0,32(sp)
ffffffffc0207f28:	ec26                	sd	s1,24(sp)
ffffffffc0207f2a:	e84a                	sd	s2,16(sp)
ffffffffc0207f2c:	e44e                	sd	s3,8(sp)
ffffffffc0207f2e:	e052                	sd	s4,0(sp)
ffffffffc0207f30:	c541                	beqz	a0,ffffffffc0207fb8 <vfs_get_root+0x96>
ffffffffc0207f32:	0008e917          	auipc	s2,0x8e
ffffffffc0207f36:	8e690913          	addi	s2,s2,-1818 # ffffffffc0295818 <vdev_list>
ffffffffc0207f3a:	00893783          	ld	a5,8(s2)
ffffffffc0207f3e:	07278b63          	beq	a5,s2,ffffffffc0207fb4 <vfs_get_root+0x92>
ffffffffc0207f42:	89aa                	mv	s3,a0
ffffffffc0207f44:	0008e517          	auipc	a0,0x8e
ffffffffc0207f48:	8e450513          	addi	a0,a0,-1820 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f4c:	8a2e                	mv	s4,a1
ffffffffc0207f4e:	844a                	mv	s0,s2
ffffffffc0207f50:	f14fc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0207f54:	a801                	j	ffffffffc0207f64 <vfs_get_root+0x42>
ffffffffc0207f56:	fe043583          	ld	a1,-32(s0)
ffffffffc0207f5a:	854e                	mv	a0,s3
ffffffffc0207f5c:	6de030ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc0207f60:	84aa                	mv	s1,a0
ffffffffc0207f62:	c505                	beqz	a0,ffffffffc0207f8a <vfs_get_root+0x68>
ffffffffc0207f64:	6400                	ld	s0,8(s0)
ffffffffc0207f66:	ff2418e3          	bne	s0,s2,ffffffffc0207f56 <vfs_get_root+0x34>
ffffffffc0207f6a:	54cd                	li	s1,-13
ffffffffc0207f6c:	0008e517          	auipc	a0,0x8e
ffffffffc0207f70:	8bc50513          	addi	a0,a0,-1860 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f74:	eecfc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0207f78:	70a2                	ld	ra,40(sp)
ffffffffc0207f7a:	7402                	ld	s0,32(sp)
ffffffffc0207f7c:	6942                	ld	s2,16(sp)
ffffffffc0207f7e:	69a2                	ld	s3,8(sp)
ffffffffc0207f80:	6a02                	ld	s4,0(sp)
ffffffffc0207f82:	8526                	mv	a0,s1
ffffffffc0207f84:	64e2                	ld	s1,24(sp)
ffffffffc0207f86:	6145                	addi	sp,sp,48
ffffffffc0207f88:	8082                	ret
ffffffffc0207f8a:	ff043503          	ld	a0,-16(s0)
ffffffffc0207f8e:	c519                	beqz	a0,ffffffffc0207f9c <vfs_get_root+0x7a>
ffffffffc0207f90:	617c                	ld	a5,192(a0)
ffffffffc0207f92:	9782                	jalr	a5
ffffffffc0207f94:	c519                	beqz	a0,ffffffffc0207fa2 <vfs_get_root+0x80>
ffffffffc0207f96:	00aa3023          	sd	a0,0(s4)
ffffffffc0207f9a:	bfc9                	j	ffffffffc0207f6c <vfs_get_root+0x4a>
ffffffffc0207f9c:	ff843783          	ld	a5,-8(s0)
ffffffffc0207fa0:	c399                	beqz	a5,ffffffffc0207fa6 <vfs_get_root+0x84>
ffffffffc0207fa2:	54c9                	li	s1,-14
ffffffffc0207fa4:	b7e1                	j	ffffffffc0207f6c <vfs_get_root+0x4a>
ffffffffc0207fa6:	fe843503          	ld	a0,-24(s0)
ffffffffc0207faa:	a99ff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0207fae:	fe843503          	ld	a0,-24(s0)
ffffffffc0207fb2:	b7cd                	j	ffffffffc0207f94 <vfs_get_root+0x72>
ffffffffc0207fb4:	54cd                	li	s1,-13
ffffffffc0207fb6:	b7c9                	j	ffffffffc0207f78 <vfs_get_root+0x56>
ffffffffc0207fb8:	00006697          	auipc	a3,0x6
ffffffffc0207fbc:	67868693          	addi	a3,a3,1656 # ffffffffc020e630 <syscalls+0xa48>
ffffffffc0207fc0:	00004617          	auipc	a2,0x4
ffffffffc0207fc4:	bb860613          	addi	a2,a2,-1096 # ffffffffc020bb78 <commands+0x210>
ffffffffc0207fc8:	04500593          	li	a1,69
ffffffffc0207fcc:	00006517          	auipc	a0,0x6
ffffffffc0207fd0:	67450513          	addi	a0,a0,1652 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc0207fd4:	ccaf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207fd8 <vfs_get_devname>:
ffffffffc0207fd8:	0008e697          	auipc	a3,0x8e
ffffffffc0207fdc:	84068693          	addi	a3,a3,-1984 # ffffffffc0295818 <vdev_list>
ffffffffc0207fe0:	87b6                	mv	a5,a3
ffffffffc0207fe2:	e511                	bnez	a0,ffffffffc0207fee <vfs_get_devname+0x16>
ffffffffc0207fe4:	a829                	j	ffffffffc0207ffe <vfs_get_devname+0x26>
ffffffffc0207fe6:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207fea:	00a70763          	beq	a4,a0,ffffffffc0207ff8 <vfs_get_devname+0x20>
ffffffffc0207fee:	679c                	ld	a5,8(a5)
ffffffffc0207ff0:	fed79be3          	bne	a5,a3,ffffffffc0207fe6 <vfs_get_devname+0xe>
ffffffffc0207ff4:	4501                	li	a0,0
ffffffffc0207ff6:	8082                	ret
ffffffffc0207ff8:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207ffc:	8082                	ret
ffffffffc0207ffe:	1141                	addi	sp,sp,-16
ffffffffc0208000:	00006697          	auipc	a3,0x6
ffffffffc0208004:	6b868693          	addi	a3,a3,1720 # ffffffffc020e6b8 <syscalls+0xad0>
ffffffffc0208008:	00004617          	auipc	a2,0x4
ffffffffc020800c:	b7060613          	addi	a2,a2,-1168 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208010:	06a00593          	li	a1,106
ffffffffc0208014:	00006517          	auipc	a0,0x6
ffffffffc0208018:	62c50513          	addi	a0,a0,1580 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc020801c:	e406                	sd	ra,8(sp)
ffffffffc020801e:	c80f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208022 <vfs_add_dev>:
ffffffffc0208022:	86b2                	mv	a3,a2
ffffffffc0208024:	4601                	li	a2,0
ffffffffc0208026:	d3fff06f          	j	ffffffffc0207d64 <vfs_do_add>

ffffffffc020802a <vfs_mount>:
ffffffffc020802a:	7179                	addi	sp,sp,-48
ffffffffc020802c:	e84a                	sd	s2,16(sp)
ffffffffc020802e:	892a                	mv	s2,a0
ffffffffc0208030:	0008d517          	auipc	a0,0x8d
ffffffffc0208034:	7f850513          	addi	a0,a0,2040 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0208038:	e44e                	sd	s3,8(sp)
ffffffffc020803a:	f406                	sd	ra,40(sp)
ffffffffc020803c:	f022                	sd	s0,32(sp)
ffffffffc020803e:	ec26                	sd	s1,24(sp)
ffffffffc0208040:	89ae                	mv	s3,a1
ffffffffc0208042:	e22fc0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0208046:	08090a63          	beqz	s2,ffffffffc02080da <vfs_mount+0xb0>
ffffffffc020804a:	0008d497          	auipc	s1,0x8d
ffffffffc020804e:	7ce48493          	addi	s1,s1,1998 # ffffffffc0295818 <vdev_list>
ffffffffc0208052:	6480                	ld	s0,8(s1)
ffffffffc0208054:	00941663          	bne	s0,s1,ffffffffc0208060 <vfs_mount+0x36>
ffffffffc0208058:	a8ad                	j	ffffffffc02080d2 <vfs_mount+0xa8>
ffffffffc020805a:	6400                	ld	s0,8(s0)
ffffffffc020805c:	06940b63          	beq	s0,s1,ffffffffc02080d2 <vfs_mount+0xa8>
ffffffffc0208060:	ff843783          	ld	a5,-8(s0)
ffffffffc0208064:	dbfd                	beqz	a5,ffffffffc020805a <vfs_mount+0x30>
ffffffffc0208066:	fe043503          	ld	a0,-32(s0)
ffffffffc020806a:	85ca                	mv	a1,s2
ffffffffc020806c:	5ce030ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc0208070:	f56d                	bnez	a0,ffffffffc020805a <vfs_mount+0x30>
ffffffffc0208072:	ff043783          	ld	a5,-16(s0)
ffffffffc0208076:	e3a5                	bnez	a5,ffffffffc02080d6 <vfs_mount+0xac>
ffffffffc0208078:	fe043783          	ld	a5,-32(s0)
ffffffffc020807c:	c3c9                	beqz	a5,ffffffffc02080fe <vfs_mount+0xd4>
ffffffffc020807e:	ff843783          	ld	a5,-8(s0)
ffffffffc0208082:	cfb5                	beqz	a5,ffffffffc02080fe <vfs_mount+0xd4>
ffffffffc0208084:	fe843503          	ld	a0,-24(s0)
ffffffffc0208088:	c939                	beqz	a0,ffffffffc02080de <vfs_mount+0xb4>
ffffffffc020808a:	4d38                	lw	a4,88(a0)
ffffffffc020808c:	6785                	lui	a5,0x1
ffffffffc020808e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208092:	04f71663          	bne	a4,a5,ffffffffc02080de <vfs_mount+0xb4>
ffffffffc0208096:	ff040593          	addi	a1,s0,-16
ffffffffc020809a:	9982                	jalr	s3
ffffffffc020809c:	84aa                	mv	s1,a0
ffffffffc020809e:	ed01                	bnez	a0,ffffffffc02080b6 <vfs_mount+0x8c>
ffffffffc02080a0:	ff043783          	ld	a5,-16(s0)
ffffffffc02080a4:	cfad                	beqz	a5,ffffffffc020811e <vfs_mount+0xf4>
ffffffffc02080a6:	fe043583          	ld	a1,-32(s0)
ffffffffc02080aa:	00006517          	auipc	a0,0x6
ffffffffc02080ae:	69e50513          	addi	a0,a0,1694 # ffffffffc020e748 <syscalls+0xb60>
ffffffffc02080b2:	8f4f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02080b6:	0008d517          	auipc	a0,0x8d
ffffffffc02080ba:	77250513          	addi	a0,a0,1906 # ffffffffc0295828 <vdev_list_sem>
ffffffffc02080be:	da2fc0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc02080c2:	70a2                	ld	ra,40(sp)
ffffffffc02080c4:	7402                	ld	s0,32(sp)
ffffffffc02080c6:	6942                	ld	s2,16(sp)
ffffffffc02080c8:	69a2                	ld	s3,8(sp)
ffffffffc02080ca:	8526                	mv	a0,s1
ffffffffc02080cc:	64e2                	ld	s1,24(sp)
ffffffffc02080ce:	6145                	addi	sp,sp,48
ffffffffc02080d0:	8082                	ret
ffffffffc02080d2:	54cd                	li	s1,-13
ffffffffc02080d4:	b7cd                	j	ffffffffc02080b6 <vfs_mount+0x8c>
ffffffffc02080d6:	54c5                	li	s1,-15
ffffffffc02080d8:	bff9                	j	ffffffffc02080b6 <vfs_mount+0x8c>
ffffffffc02080da:	db3ff0ef          	jal	ra,ffffffffc0207e8c <find_mount.part.0>
ffffffffc02080de:	00006697          	auipc	a3,0x6
ffffffffc02080e2:	61a68693          	addi	a3,a3,1562 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc02080e6:	00004617          	auipc	a2,0x4
ffffffffc02080ea:	a9260613          	addi	a2,a2,-1390 # ffffffffc020bb78 <commands+0x210>
ffffffffc02080ee:	0ed00593          	li	a1,237
ffffffffc02080f2:	00006517          	auipc	a0,0x6
ffffffffc02080f6:	54e50513          	addi	a0,a0,1358 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc02080fa:	ba4f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02080fe:	00006697          	auipc	a3,0x6
ffffffffc0208102:	5ca68693          	addi	a3,a3,1482 # ffffffffc020e6c8 <syscalls+0xae0>
ffffffffc0208106:	00004617          	auipc	a2,0x4
ffffffffc020810a:	a7260613          	addi	a2,a2,-1422 # ffffffffc020bb78 <commands+0x210>
ffffffffc020810e:	0eb00593          	li	a1,235
ffffffffc0208112:	00006517          	auipc	a0,0x6
ffffffffc0208116:	52e50513          	addi	a0,a0,1326 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc020811a:	b84f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020811e:	00006697          	auipc	a3,0x6
ffffffffc0208122:	61268693          	addi	a3,a3,1554 # ffffffffc020e730 <syscalls+0xb48>
ffffffffc0208126:	00004617          	auipc	a2,0x4
ffffffffc020812a:	a5260613          	addi	a2,a2,-1454 # ffffffffc020bb78 <commands+0x210>
ffffffffc020812e:	0ef00593          	li	a1,239
ffffffffc0208132:	00006517          	auipc	a0,0x6
ffffffffc0208136:	50e50513          	addi	a0,a0,1294 # ffffffffc020e640 <syscalls+0xa58>
ffffffffc020813a:	b64f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020813e <vfs_open>:
ffffffffc020813e:	711d                	addi	sp,sp,-96
ffffffffc0208140:	e4a6                	sd	s1,72(sp)
ffffffffc0208142:	e0ca                	sd	s2,64(sp)
ffffffffc0208144:	fc4e                	sd	s3,56(sp)
ffffffffc0208146:	ec86                	sd	ra,88(sp)
ffffffffc0208148:	e8a2                	sd	s0,80(sp)
ffffffffc020814a:	f852                	sd	s4,48(sp)
ffffffffc020814c:	f456                	sd	s5,40(sp)
ffffffffc020814e:	0035f793          	andi	a5,a1,3
ffffffffc0208152:	84ae                	mv	s1,a1
ffffffffc0208154:	892a                	mv	s2,a0
ffffffffc0208156:	89b2                	mv	s3,a2
ffffffffc0208158:	0e078663          	beqz	a5,ffffffffc0208244 <vfs_open+0x106>
ffffffffc020815c:	470d                	li	a4,3
ffffffffc020815e:	0105fa93          	andi	s5,a1,16
ffffffffc0208162:	0ce78f63          	beq	a5,a4,ffffffffc0208240 <vfs_open+0x102>
ffffffffc0208166:	002c                	addi	a1,sp,8
ffffffffc0208168:	854a                	mv	a0,s2
ffffffffc020816a:	2ae000ef          	jal	ra,ffffffffc0208418 <vfs_lookup>
ffffffffc020816e:	842a                	mv	s0,a0
ffffffffc0208170:	0044fa13          	andi	s4,s1,4
ffffffffc0208174:	e159                	bnez	a0,ffffffffc02081fa <vfs_open+0xbc>
ffffffffc0208176:	00c4f793          	andi	a5,s1,12
ffffffffc020817a:	4731                	li	a4,12
ffffffffc020817c:	0ee78263          	beq	a5,a4,ffffffffc0208260 <vfs_open+0x122>
ffffffffc0208180:	6422                	ld	s0,8(sp)
ffffffffc0208182:	12040163          	beqz	s0,ffffffffc02082a4 <vfs_open+0x166>
ffffffffc0208186:	783c                	ld	a5,112(s0)
ffffffffc0208188:	cff1                	beqz	a5,ffffffffc0208264 <vfs_open+0x126>
ffffffffc020818a:	679c                	ld	a5,8(a5)
ffffffffc020818c:	cfe1                	beqz	a5,ffffffffc0208264 <vfs_open+0x126>
ffffffffc020818e:	8522                	mv	a0,s0
ffffffffc0208190:	00006597          	auipc	a1,0x6
ffffffffc0208194:	69858593          	addi	a1,a1,1688 # ffffffffc020e828 <syscalls+0xc40>
ffffffffc0208198:	8c3ff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc020819c:	783c                	ld	a5,112(s0)
ffffffffc020819e:	6522                	ld	a0,8(sp)
ffffffffc02081a0:	85a6                	mv	a1,s1
ffffffffc02081a2:	679c                	ld	a5,8(a5)
ffffffffc02081a4:	9782                	jalr	a5
ffffffffc02081a6:	842a                	mv	s0,a0
ffffffffc02081a8:	6522                	ld	a0,8(sp)
ffffffffc02081aa:	e845                	bnez	s0,ffffffffc020825a <vfs_open+0x11c>
ffffffffc02081ac:	015a6a33          	or	s4,s4,s5
ffffffffc02081b0:	89fff0ef          	jal	ra,ffffffffc0207a4e <inode_open_inc>
ffffffffc02081b4:	020a0663          	beqz	s4,ffffffffc02081e0 <vfs_open+0xa2>
ffffffffc02081b8:	64a2                	ld	s1,8(sp)
ffffffffc02081ba:	c4e9                	beqz	s1,ffffffffc0208284 <vfs_open+0x146>
ffffffffc02081bc:	78bc                	ld	a5,112(s1)
ffffffffc02081be:	c3f9                	beqz	a5,ffffffffc0208284 <vfs_open+0x146>
ffffffffc02081c0:	73bc                	ld	a5,96(a5)
ffffffffc02081c2:	c3e9                	beqz	a5,ffffffffc0208284 <vfs_open+0x146>
ffffffffc02081c4:	00006597          	auipc	a1,0x6
ffffffffc02081c8:	6c458593          	addi	a1,a1,1732 # ffffffffc020e888 <syscalls+0xca0>
ffffffffc02081cc:	8526                	mv	a0,s1
ffffffffc02081ce:	88dff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc02081d2:	78bc                	ld	a5,112(s1)
ffffffffc02081d4:	6522                	ld	a0,8(sp)
ffffffffc02081d6:	4581                	li	a1,0
ffffffffc02081d8:	73bc                	ld	a5,96(a5)
ffffffffc02081da:	9782                	jalr	a5
ffffffffc02081dc:	87aa                	mv	a5,a0
ffffffffc02081de:	e92d                	bnez	a0,ffffffffc0208250 <vfs_open+0x112>
ffffffffc02081e0:	67a2                	ld	a5,8(sp)
ffffffffc02081e2:	00f9b023          	sd	a5,0(s3)
ffffffffc02081e6:	60e6                	ld	ra,88(sp)
ffffffffc02081e8:	8522                	mv	a0,s0
ffffffffc02081ea:	6446                	ld	s0,80(sp)
ffffffffc02081ec:	64a6                	ld	s1,72(sp)
ffffffffc02081ee:	6906                	ld	s2,64(sp)
ffffffffc02081f0:	79e2                	ld	s3,56(sp)
ffffffffc02081f2:	7a42                	ld	s4,48(sp)
ffffffffc02081f4:	7aa2                	ld	s5,40(sp)
ffffffffc02081f6:	6125                	addi	sp,sp,96
ffffffffc02081f8:	8082                	ret
ffffffffc02081fa:	57c1                	li	a5,-16
ffffffffc02081fc:	fef515e3          	bne	a0,a5,ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208200:	fe0a03e3          	beqz	s4,ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208204:	0810                	addi	a2,sp,16
ffffffffc0208206:	082c                	addi	a1,sp,24
ffffffffc0208208:	854a                	mv	a0,s2
ffffffffc020820a:	2a4000ef          	jal	ra,ffffffffc02084ae <vfs_lookup_parent>
ffffffffc020820e:	842a                	mv	s0,a0
ffffffffc0208210:	f979                	bnez	a0,ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208212:	6462                	ld	s0,24(sp)
ffffffffc0208214:	c845                	beqz	s0,ffffffffc02082c4 <vfs_open+0x186>
ffffffffc0208216:	783c                	ld	a5,112(s0)
ffffffffc0208218:	c7d5                	beqz	a5,ffffffffc02082c4 <vfs_open+0x186>
ffffffffc020821a:	77bc                	ld	a5,104(a5)
ffffffffc020821c:	c7c5                	beqz	a5,ffffffffc02082c4 <vfs_open+0x186>
ffffffffc020821e:	8522                	mv	a0,s0
ffffffffc0208220:	00006597          	auipc	a1,0x6
ffffffffc0208224:	5a058593          	addi	a1,a1,1440 # ffffffffc020e7c0 <syscalls+0xbd8>
ffffffffc0208228:	833ff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc020822c:	783c                	ld	a5,112(s0)
ffffffffc020822e:	65c2                	ld	a1,16(sp)
ffffffffc0208230:	6562                	ld	a0,24(sp)
ffffffffc0208232:	77bc                	ld	a5,104(a5)
ffffffffc0208234:	4034d613          	srai	a2,s1,0x3
ffffffffc0208238:	0034                	addi	a3,sp,8
ffffffffc020823a:	8a05                	andi	a2,a2,1
ffffffffc020823c:	9782                	jalr	a5
ffffffffc020823e:	b789                	j	ffffffffc0208180 <vfs_open+0x42>
ffffffffc0208240:	5475                	li	s0,-3
ffffffffc0208242:	b755                	j	ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208244:	0105fa93          	andi	s5,a1,16
ffffffffc0208248:	5475                	li	s0,-3
ffffffffc020824a:	f80a9ee3          	bnez	s5,ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc020824e:	bf21                	j	ffffffffc0208166 <vfs_open+0x28>
ffffffffc0208250:	6522                	ld	a0,8(sp)
ffffffffc0208252:	843e                	mv	s0,a5
ffffffffc0208254:	965ff0ef          	jal	ra,ffffffffc0207bb8 <inode_open_dec>
ffffffffc0208258:	6522                	ld	a0,8(sp)
ffffffffc020825a:	8b7ff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020825e:	b761                	j	ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208260:	5425                	li	s0,-23
ffffffffc0208262:	b751                	j	ffffffffc02081e6 <vfs_open+0xa8>
ffffffffc0208264:	00006697          	auipc	a3,0x6
ffffffffc0208268:	57468693          	addi	a3,a3,1396 # ffffffffc020e7d8 <syscalls+0xbf0>
ffffffffc020826c:	00004617          	auipc	a2,0x4
ffffffffc0208270:	90c60613          	addi	a2,a2,-1780 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208274:	03300593          	li	a1,51
ffffffffc0208278:	00006517          	auipc	a0,0x6
ffffffffc020827c:	53050513          	addi	a0,a0,1328 # ffffffffc020e7a8 <syscalls+0xbc0>
ffffffffc0208280:	a1ef80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208284:	00006697          	auipc	a3,0x6
ffffffffc0208288:	5ac68693          	addi	a3,a3,1452 # ffffffffc020e830 <syscalls+0xc48>
ffffffffc020828c:	00004617          	auipc	a2,0x4
ffffffffc0208290:	8ec60613          	addi	a2,a2,-1812 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208294:	03a00593          	li	a1,58
ffffffffc0208298:	00006517          	auipc	a0,0x6
ffffffffc020829c:	51050513          	addi	a0,a0,1296 # ffffffffc020e7a8 <syscalls+0xbc0>
ffffffffc02082a0:	9fef80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02082a4:	00006697          	auipc	a3,0x6
ffffffffc02082a8:	52468693          	addi	a3,a3,1316 # ffffffffc020e7c8 <syscalls+0xbe0>
ffffffffc02082ac:	00004617          	auipc	a2,0x4
ffffffffc02082b0:	8cc60613          	addi	a2,a2,-1844 # ffffffffc020bb78 <commands+0x210>
ffffffffc02082b4:	03100593          	li	a1,49
ffffffffc02082b8:	00006517          	auipc	a0,0x6
ffffffffc02082bc:	4f050513          	addi	a0,a0,1264 # ffffffffc020e7a8 <syscalls+0xbc0>
ffffffffc02082c0:	9def80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02082c4:	00006697          	auipc	a3,0x6
ffffffffc02082c8:	49468693          	addi	a3,a3,1172 # ffffffffc020e758 <syscalls+0xb70>
ffffffffc02082cc:	00004617          	auipc	a2,0x4
ffffffffc02082d0:	8ac60613          	addi	a2,a2,-1876 # ffffffffc020bb78 <commands+0x210>
ffffffffc02082d4:	02c00593          	li	a1,44
ffffffffc02082d8:	00006517          	auipc	a0,0x6
ffffffffc02082dc:	4d050513          	addi	a0,a0,1232 # ffffffffc020e7a8 <syscalls+0xbc0>
ffffffffc02082e0:	9bef80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02082e4 <vfs_close>:
ffffffffc02082e4:	1141                	addi	sp,sp,-16
ffffffffc02082e6:	e406                	sd	ra,8(sp)
ffffffffc02082e8:	e022                	sd	s0,0(sp)
ffffffffc02082ea:	842a                	mv	s0,a0
ffffffffc02082ec:	8cdff0ef          	jal	ra,ffffffffc0207bb8 <inode_open_dec>
ffffffffc02082f0:	8522                	mv	a0,s0
ffffffffc02082f2:	81fff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc02082f6:	60a2                	ld	ra,8(sp)
ffffffffc02082f8:	6402                	ld	s0,0(sp)
ffffffffc02082fa:	4501                	li	a0,0
ffffffffc02082fc:	0141                	addi	sp,sp,16
ffffffffc02082fe:	8082                	ret

ffffffffc0208300 <get_device>:
ffffffffc0208300:	7179                	addi	sp,sp,-48
ffffffffc0208302:	ec26                	sd	s1,24(sp)
ffffffffc0208304:	e84a                	sd	s2,16(sp)
ffffffffc0208306:	f406                	sd	ra,40(sp)
ffffffffc0208308:	f022                	sd	s0,32(sp)
ffffffffc020830a:	00054303          	lbu	t1,0(a0)
ffffffffc020830e:	892e                	mv	s2,a1
ffffffffc0208310:	84b2                	mv	s1,a2
ffffffffc0208312:	02030463          	beqz	t1,ffffffffc020833a <get_device+0x3a>
ffffffffc0208316:	00150413          	addi	s0,a0,1
ffffffffc020831a:	86a2                	mv	a3,s0
ffffffffc020831c:	879a                	mv	a5,t1
ffffffffc020831e:	4701                	li	a4,0
ffffffffc0208320:	03a00813          	li	a6,58
ffffffffc0208324:	02f00893          	li	a7,47
ffffffffc0208328:	03078263          	beq	a5,a6,ffffffffc020834c <get_device+0x4c>
ffffffffc020832c:	05178963          	beq	a5,a7,ffffffffc020837e <get_device+0x7e>
ffffffffc0208330:	0006c783          	lbu	a5,0(a3)
ffffffffc0208334:	2705                	addiw	a4,a4,1
ffffffffc0208336:	0685                	addi	a3,a3,1
ffffffffc0208338:	fbe5                	bnez	a5,ffffffffc0208328 <get_device+0x28>
ffffffffc020833a:	7402                	ld	s0,32(sp)
ffffffffc020833c:	00a93023          	sd	a0,0(s2)
ffffffffc0208340:	70a2                	ld	ra,40(sp)
ffffffffc0208342:	6942                	ld	s2,16(sp)
ffffffffc0208344:	8526                	mv	a0,s1
ffffffffc0208346:	64e2                	ld	s1,24(sp)
ffffffffc0208348:	6145                	addi	sp,sp,48
ffffffffc020834a:	a279                	j	ffffffffc02084d8 <vfs_get_curdir>
ffffffffc020834c:	cb15                	beqz	a4,ffffffffc0208380 <get_device+0x80>
ffffffffc020834e:	00e507b3          	add	a5,a0,a4
ffffffffc0208352:	0705                	addi	a4,a4,1
ffffffffc0208354:	00078023          	sb	zero,0(a5)
ffffffffc0208358:	972a                	add	a4,a4,a0
ffffffffc020835a:	02f00613          	li	a2,47
ffffffffc020835e:	00074783          	lbu	a5,0(a4)
ffffffffc0208362:	86ba                	mv	a3,a4
ffffffffc0208364:	0705                	addi	a4,a4,1
ffffffffc0208366:	fec78ce3          	beq	a5,a2,ffffffffc020835e <get_device+0x5e>
ffffffffc020836a:	7402                	ld	s0,32(sp)
ffffffffc020836c:	70a2                	ld	ra,40(sp)
ffffffffc020836e:	00d93023          	sd	a3,0(s2)
ffffffffc0208372:	85a6                	mv	a1,s1
ffffffffc0208374:	6942                	ld	s2,16(sp)
ffffffffc0208376:	64e2                	ld	s1,24(sp)
ffffffffc0208378:	6145                	addi	sp,sp,48
ffffffffc020837a:	ba9ff06f          	j	ffffffffc0207f22 <vfs_get_root>
ffffffffc020837e:	ff55                	bnez	a4,ffffffffc020833a <get_device+0x3a>
ffffffffc0208380:	02f00793          	li	a5,47
ffffffffc0208384:	04f30563          	beq	t1,a5,ffffffffc02083ce <get_device+0xce>
ffffffffc0208388:	03a00793          	li	a5,58
ffffffffc020838c:	06f31663          	bne	t1,a5,ffffffffc02083f8 <get_device+0xf8>
ffffffffc0208390:	0028                	addi	a0,sp,8
ffffffffc0208392:	146000ef          	jal	ra,ffffffffc02084d8 <vfs_get_curdir>
ffffffffc0208396:	e515                	bnez	a0,ffffffffc02083c2 <get_device+0xc2>
ffffffffc0208398:	67a2                	ld	a5,8(sp)
ffffffffc020839a:	77a8                	ld	a0,104(a5)
ffffffffc020839c:	cd15                	beqz	a0,ffffffffc02083d8 <get_device+0xd8>
ffffffffc020839e:	617c                	ld	a5,192(a0)
ffffffffc02083a0:	9782                	jalr	a5
ffffffffc02083a2:	87aa                	mv	a5,a0
ffffffffc02083a4:	6522                	ld	a0,8(sp)
ffffffffc02083a6:	e09c                	sd	a5,0(s1)
ffffffffc02083a8:	f68ff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc02083ac:	02f00713          	li	a4,47
ffffffffc02083b0:	a011                	j	ffffffffc02083b4 <get_device+0xb4>
ffffffffc02083b2:	0405                	addi	s0,s0,1
ffffffffc02083b4:	00044783          	lbu	a5,0(s0)
ffffffffc02083b8:	fee78de3          	beq	a5,a4,ffffffffc02083b2 <get_device+0xb2>
ffffffffc02083bc:	00893023          	sd	s0,0(s2)
ffffffffc02083c0:	4501                	li	a0,0
ffffffffc02083c2:	70a2                	ld	ra,40(sp)
ffffffffc02083c4:	7402                	ld	s0,32(sp)
ffffffffc02083c6:	64e2                	ld	s1,24(sp)
ffffffffc02083c8:	6942                	ld	s2,16(sp)
ffffffffc02083ca:	6145                	addi	sp,sp,48
ffffffffc02083cc:	8082                	ret
ffffffffc02083ce:	8526                	mv	a0,s1
ffffffffc02083d0:	93fff0ef          	jal	ra,ffffffffc0207d0e <vfs_get_bootfs>
ffffffffc02083d4:	dd61                	beqz	a0,ffffffffc02083ac <get_device+0xac>
ffffffffc02083d6:	b7f5                	j	ffffffffc02083c2 <get_device+0xc2>
ffffffffc02083d8:	00006697          	auipc	a3,0x6
ffffffffc02083dc:	4e868693          	addi	a3,a3,1256 # ffffffffc020e8c0 <syscalls+0xcd8>
ffffffffc02083e0:	00003617          	auipc	a2,0x3
ffffffffc02083e4:	79860613          	addi	a2,a2,1944 # ffffffffc020bb78 <commands+0x210>
ffffffffc02083e8:	03900593          	li	a1,57
ffffffffc02083ec:	00006517          	auipc	a0,0x6
ffffffffc02083f0:	4bc50513          	addi	a0,a0,1212 # ffffffffc020e8a8 <syscalls+0xcc0>
ffffffffc02083f4:	8aaf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02083f8:	00006697          	auipc	a3,0x6
ffffffffc02083fc:	4a068693          	addi	a3,a3,1184 # ffffffffc020e898 <syscalls+0xcb0>
ffffffffc0208400:	00003617          	auipc	a2,0x3
ffffffffc0208404:	77860613          	addi	a2,a2,1912 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208408:	03300593          	li	a1,51
ffffffffc020840c:	00006517          	auipc	a0,0x6
ffffffffc0208410:	49c50513          	addi	a0,a0,1180 # ffffffffc020e8a8 <syscalls+0xcc0>
ffffffffc0208414:	88af80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208418 <vfs_lookup>:
ffffffffc0208418:	7139                	addi	sp,sp,-64
ffffffffc020841a:	f426                	sd	s1,40(sp)
ffffffffc020841c:	0830                	addi	a2,sp,24
ffffffffc020841e:	84ae                	mv	s1,a1
ffffffffc0208420:	002c                	addi	a1,sp,8
ffffffffc0208422:	f822                	sd	s0,48(sp)
ffffffffc0208424:	fc06                	sd	ra,56(sp)
ffffffffc0208426:	f04a                	sd	s2,32(sp)
ffffffffc0208428:	e42a                	sd	a0,8(sp)
ffffffffc020842a:	ed7ff0ef          	jal	ra,ffffffffc0208300 <get_device>
ffffffffc020842e:	842a                	mv	s0,a0
ffffffffc0208430:	ed1d                	bnez	a0,ffffffffc020846e <vfs_lookup+0x56>
ffffffffc0208432:	67a2                	ld	a5,8(sp)
ffffffffc0208434:	6962                	ld	s2,24(sp)
ffffffffc0208436:	0007c783          	lbu	a5,0(a5)
ffffffffc020843a:	c3a9                	beqz	a5,ffffffffc020847c <vfs_lookup+0x64>
ffffffffc020843c:	04090963          	beqz	s2,ffffffffc020848e <vfs_lookup+0x76>
ffffffffc0208440:	07093783          	ld	a5,112(s2)
ffffffffc0208444:	c7a9                	beqz	a5,ffffffffc020848e <vfs_lookup+0x76>
ffffffffc0208446:	7bbc                	ld	a5,112(a5)
ffffffffc0208448:	c3b9                	beqz	a5,ffffffffc020848e <vfs_lookup+0x76>
ffffffffc020844a:	854a                	mv	a0,s2
ffffffffc020844c:	00006597          	auipc	a1,0x6
ffffffffc0208450:	4dc58593          	addi	a1,a1,1244 # ffffffffc020e928 <syscalls+0xd40>
ffffffffc0208454:	e06ff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0208458:	07093783          	ld	a5,112(s2)
ffffffffc020845c:	65a2                	ld	a1,8(sp)
ffffffffc020845e:	6562                	ld	a0,24(sp)
ffffffffc0208460:	7bbc                	ld	a5,112(a5)
ffffffffc0208462:	8626                	mv	a2,s1
ffffffffc0208464:	9782                	jalr	a5
ffffffffc0208466:	842a                	mv	s0,a0
ffffffffc0208468:	6562                	ld	a0,24(sp)
ffffffffc020846a:	ea6ff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020846e:	70e2                	ld	ra,56(sp)
ffffffffc0208470:	8522                	mv	a0,s0
ffffffffc0208472:	7442                	ld	s0,48(sp)
ffffffffc0208474:	74a2                	ld	s1,40(sp)
ffffffffc0208476:	7902                	ld	s2,32(sp)
ffffffffc0208478:	6121                	addi	sp,sp,64
ffffffffc020847a:	8082                	ret
ffffffffc020847c:	70e2                	ld	ra,56(sp)
ffffffffc020847e:	8522                	mv	a0,s0
ffffffffc0208480:	7442                	ld	s0,48(sp)
ffffffffc0208482:	0124b023          	sd	s2,0(s1)
ffffffffc0208486:	74a2                	ld	s1,40(sp)
ffffffffc0208488:	7902                	ld	s2,32(sp)
ffffffffc020848a:	6121                	addi	sp,sp,64
ffffffffc020848c:	8082                	ret
ffffffffc020848e:	00006697          	auipc	a3,0x6
ffffffffc0208492:	44a68693          	addi	a3,a3,1098 # ffffffffc020e8d8 <syscalls+0xcf0>
ffffffffc0208496:	00003617          	auipc	a2,0x3
ffffffffc020849a:	6e260613          	addi	a2,a2,1762 # ffffffffc020bb78 <commands+0x210>
ffffffffc020849e:	04f00593          	li	a1,79
ffffffffc02084a2:	00006517          	auipc	a0,0x6
ffffffffc02084a6:	40650513          	addi	a0,a0,1030 # ffffffffc020e8a8 <syscalls+0xcc0>
ffffffffc02084aa:	ff5f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02084ae <vfs_lookup_parent>:
ffffffffc02084ae:	7139                	addi	sp,sp,-64
ffffffffc02084b0:	f822                	sd	s0,48(sp)
ffffffffc02084b2:	f426                	sd	s1,40(sp)
ffffffffc02084b4:	842e                	mv	s0,a1
ffffffffc02084b6:	84b2                	mv	s1,a2
ffffffffc02084b8:	002c                	addi	a1,sp,8
ffffffffc02084ba:	0830                	addi	a2,sp,24
ffffffffc02084bc:	fc06                	sd	ra,56(sp)
ffffffffc02084be:	e42a                	sd	a0,8(sp)
ffffffffc02084c0:	e41ff0ef          	jal	ra,ffffffffc0208300 <get_device>
ffffffffc02084c4:	e509                	bnez	a0,ffffffffc02084ce <vfs_lookup_parent+0x20>
ffffffffc02084c6:	67a2                	ld	a5,8(sp)
ffffffffc02084c8:	e09c                	sd	a5,0(s1)
ffffffffc02084ca:	67e2                	ld	a5,24(sp)
ffffffffc02084cc:	e01c                	sd	a5,0(s0)
ffffffffc02084ce:	70e2                	ld	ra,56(sp)
ffffffffc02084d0:	7442                	ld	s0,48(sp)
ffffffffc02084d2:	74a2                	ld	s1,40(sp)
ffffffffc02084d4:	6121                	addi	sp,sp,64
ffffffffc02084d6:	8082                	ret

ffffffffc02084d8 <vfs_get_curdir>:
ffffffffc02084d8:	0008e797          	auipc	a5,0x8e
ffffffffc02084dc:	3e87b783          	ld	a5,1000(a5) # ffffffffc02968c0 <current>
ffffffffc02084e0:	1487b783          	ld	a5,328(a5)
ffffffffc02084e4:	1101                	addi	sp,sp,-32
ffffffffc02084e6:	e426                	sd	s1,8(sp)
ffffffffc02084e8:	6384                	ld	s1,0(a5)
ffffffffc02084ea:	ec06                	sd	ra,24(sp)
ffffffffc02084ec:	e822                	sd	s0,16(sp)
ffffffffc02084ee:	cc81                	beqz	s1,ffffffffc0208506 <vfs_get_curdir+0x2e>
ffffffffc02084f0:	842a                	mv	s0,a0
ffffffffc02084f2:	8526                	mv	a0,s1
ffffffffc02084f4:	d4eff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc02084f8:	4501                	li	a0,0
ffffffffc02084fa:	e004                	sd	s1,0(s0)
ffffffffc02084fc:	60e2                	ld	ra,24(sp)
ffffffffc02084fe:	6442                	ld	s0,16(sp)
ffffffffc0208500:	64a2                	ld	s1,8(sp)
ffffffffc0208502:	6105                	addi	sp,sp,32
ffffffffc0208504:	8082                	ret
ffffffffc0208506:	5541                	li	a0,-16
ffffffffc0208508:	bfd5                	j	ffffffffc02084fc <vfs_get_curdir+0x24>

ffffffffc020850a <vfs_set_curdir>:
ffffffffc020850a:	7139                	addi	sp,sp,-64
ffffffffc020850c:	f04a                	sd	s2,32(sp)
ffffffffc020850e:	0008e917          	auipc	s2,0x8e
ffffffffc0208512:	3b290913          	addi	s2,s2,946 # ffffffffc02968c0 <current>
ffffffffc0208516:	00093783          	ld	a5,0(s2)
ffffffffc020851a:	f822                	sd	s0,48(sp)
ffffffffc020851c:	842a                	mv	s0,a0
ffffffffc020851e:	1487b503          	ld	a0,328(a5)
ffffffffc0208522:	ec4e                	sd	s3,24(sp)
ffffffffc0208524:	fc06                	sd	ra,56(sp)
ffffffffc0208526:	f426                	sd	s1,40(sp)
ffffffffc0208528:	d9bfc0ef          	jal	ra,ffffffffc02052c2 <lock_files>
ffffffffc020852c:	00093783          	ld	a5,0(s2)
ffffffffc0208530:	1487b503          	ld	a0,328(a5)
ffffffffc0208534:	00053983          	ld	s3,0(a0)
ffffffffc0208538:	07340963          	beq	s0,s3,ffffffffc02085aa <vfs_set_curdir+0xa0>
ffffffffc020853c:	cc39                	beqz	s0,ffffffffc020859a <vfs_set_curdir+0x90>
ffffffffc020853e:	783c                	ld	a5,112(s0)
ffffffffc0208540:	c7bd                	beqz	a5,ffffffffc02085ae <vfs_set_curdir+0xa4>
ffffffffc0208542:	6bbc                	ld	a5,80(a5)
ffffffffc0208544:	c7ad                	beqz	a5,ffffffffc02085ae <vfs_set_curdir+0xa4>
ffffffffc0208546:	00006597          	auipc	a1,0x6
ffffffffc020854a:	45258593          	addi	a1,a1,1106 # ffffffffc020e998 <syscalls+0xdb0>
ffffffffc020854e:	8522                	mv	a0,s0
ffffffffc0208550:	d0aff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0208554:	783c                	ld	a5,112(s0)
ffffffffc0208556:	006c                	addi	a1,sp,12
ffffffffc0208558:	8522                	mv	a0,s0
ffffffffc020855a:	6bbc                	ld	a5,80(a5)
ffffffffc020855c:	9782                	jalr	a5
ffffffffc020855e:	84aa                	mv	s1,a0
ffffffffc0208560:	e901                	bnez	a0,ffffffffc0208570 <vfs_set_curdir+0x66>
ffffffffc0208562:	47b2                	lw	a5,12(sp)
ffffffffc0208564:	669d                	lui	a3,0x7
ffffffffc0208566:	6709                	lui	a4,0x2
ffffffffc0208568:	8ff5                	and	a5,a5,a3
ffffffffc020856a:	54b9                	li	s1,-18
ffffffffc020856c:	02e78063          	beq	a5,a4,ffffffffc020858c <vfs_set_curdir+0x82>
ffffffffc0208570:	00093783          	ld	a5,0(s2)
ffffffffc0208574:	1487b503          	ld	a0,328(a5)
ffffffffc0208578:	d51fc0ef          	jal	ra,ffffffffc02052c8 <unlock_files>
ffffffffc020857c:	70e2                	ld	ra,56(sp)
ffffffffc020857e:	7442                	ld	s0,48(sp)
ffffffffc0208580:	7902                	ld	s2,32(sp)
ffffffffc0208582:	69e2                	ld	s3,24(sp)
ffffffffc0208584:	8526                	mv	a0,s1
ffffffffc0208586:	74a2                	ld	s1,40(sp)
ffffffffc0208588:	6121                	addi	sp,sp,64
ffffffffc020858a:	8082                	ret
ffffffffc020858c:	8522                	mv	a0,s0
ffffffffc020858e:	cb4ff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0208592:	00093783          	ld	a5,0(s2)
ffffffffc0208596:	1487b503          	ld	a0,328(a5)
ffffffffc020859a:	e100                	sd	s0,0(a0)
ffffffffc020859c:	4481                	li	s1,0
ffffffffc020859e:	fc098de3          	beqz	s3,ffffffffc0208578 <vfs_set_curdir+0x6e>
ffffffffc02085a2:	854e                	mv	a0,s3
ffffffffc02085a4:	d6cff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc02085a8:	b7e1                	j	ffffffffc0208570 <vfs_set_curdir+0x66>
ffffffffc02085aa:	4481                	li	s1,0
ffffffffc02085ac:	b7f1                	j	ffffffffc0208578 <vfs_set_curdir+0x6e>
ffffffffc02085ae:	00006697          	auipc	a3,0x6
ffffffffc02085b2:	38268693          	addi	a3,a3,898 # ffffffffc020e930 <syscalls+0xd48>
ffffffffc02085b6:	00003617          	auipc	a2,0x3
ffffffffc02085ba:	5c260613          	addi	a2,a2,1474 # ffffffffc020bb78 <commands+0x210>
ffffffffc02085be:	04300593          	li	a1,67
ffffffffc02085c2:	00006517          	auipc	a0,0x6
ffffffffc02085c6:	3be50513          	addi	a0,a0,958 # ffffffffc020e980 <syscalls+0xd98>
ffffffffc02085ca:	ed5f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02085ce <vfs_chdir>:
ffffffffc02085ce:	1101                	addi	sp,sp,-32
ffffffffc02085d0:	002c                	addi	a1,sp,8
ffffffffc02085d2:	e822                	sd	s0,16(sp)
ffffffffc02085d4:	ec06                	sd	ra,24(sp)
ffffffffc02085d6:	e43ff0ef          	jal	ra,ffffffffc0208418 <vfs_lookup>
ffffffffc02085da:	842a                	mv	s0,a0
ffffffffc02085dc:	c511                	beqz	a0,ffffffffc02085e8 <vfs_chdir+0x1a>
ffffffffc02085de:	60e2                	ld	ra,24(sp)
ffffffffc02085e0:	8522                	mv	a0,s0
ffffffffc02085e2:	6442                	ld	s0,16(sp)
ffffffffc02085e4:	6105                	addi	sp,sp,32
ffffffffc02085e6:	8082                	ret
ffffffffc02085e8:	6522                	ld	a0,8(sp)
ffffffffc02085ea:	f21ff0ef          	jal	ra,ffffffffc020850a <vfs_set_curdir>
ffffffffc02085ee:	842a                	mv	s0,a0
ffffffffc02085f0:	6522                	ld	a0,8(sp)
ffffffffc02085f2:	d1eff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc02085f6:	60e2                	ld	ra,24(sp)
ffffffffc02085f8:	8522                	mv	a0,s0
ffffffffc02085fa:	6442                	ld	s0,16(sp)
ffffffffc02085fc:	6105                	addi	sp,sp,32
ffffffffc02085fe:	8082                	ret

ffffffffc0208600 <vfs_getcwd>:
ffffffffc0208600:	0008e797          	auipc	a5,0x8e
ffffffffc0208604:	2c07b783          	ld	a5,704(a5) # ffffffffc02968c0 <current>
ffffffffc0208608:	1487b783          	ld	a5,328(a5)
ffffffffc020860c:	7179                	addi	sp,sp,-48
ffffffffc020860e:	ec26                	sd	s1,24(sp)
ffffffffc0208610:	6384                	ld	s1,0(a5)
ffffffffc0208612:	f406                	sd	ra,40(sp)
ffffffffc0208614:	f022                	sd	s0,32(sp)
ffffffffc0208616:	e84a                	sd	s2,16(sp)
ffffffffc0208618:	ccbd                	beqz	s1,ffffffffc0208696 <vfs_getcwd+0x96>
ffffffffc020861a:	892a                	mv	s2,a0
ffffffffc020861c:	8526                	mv	a0,s1
ffffffffc020861e:	c24ff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc0208622:	74a8                	ld	a0,104(s1)
ffffffffc0208624:	c93d                	beqz	a0,ffffffffc020869a <vfs_getcwd+0x9a>
ffffffffc0208626:	9b3ff0ef          	jal	ra,ffffffffc0207fd8 <vfs_get_devname>
ffffffffc020862a:	842a                	mv	s0,a0
ffffffffc020862c:	7c7020ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc0208630:	862a                	mv	a2,a0
ffffffffc0208632:	85a2                	mv	a1,s0
ffffffffc0208634:	4701                	li	a4,0
ffffffffc0208636:	4685                	li	a3,1
ffffffffc0208638:	854a                	mv	a0,s2
ffffffffc020863a:	eb3fc0ef          	jal	ra,ffffffffc02054ec <iobuf_move>
ffffffffc020863e:	842a                	mv	s0,a0
ffffffffc0208640:	c919                	beqz	a0,ffffffffc0208656 <vfs_getcwd+0x56>
ffffffffc0208642:	8526                	mv	a0,s1
ffffffffc0208644:	cccff0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc0208648:	70a2                	ld	ra,40(sp)
ffffffffc020864a:	8522                	mv	a0,s0
ffffffffc020864c:	7402                	ld	s0,32(sp)
ffffffffc020864e:	64e2                	ld	s1,24(sp)
ffffffffc0208650:	6942                	ld	s2,16(sp)
ffffffffc0208652:	6145                	addi	sp,sp,48
ffffffffc0208654:	8082                	ret
ffffffffc0208656:	03a00793          	li	a5,58
ffffffffc020865a:	4701                	li	a4,0
ffffffffc020865c:	4685                	li	a3,1
ffffffffc020865e:	4605                	li	a2,1
ffffffffc0208660:	00f10593          	addi	a1,sp,15
ffffffffc0208664:	854a                	mv	a0,s2
ffffffffc0208666:	00f107a3          	sb	a5,15(sp)
ffffffffc020866a:	e83fc0ef          	jal	ra,ffffffffc02054ec <iobuf_move>
ffffffffc020866e:	842a                	mv	s0,a0
ffffffffc0208670:	f969                	bnez	a0,ffffffffc0208642 <vfs_getcwd+0x42>
ffffffffc0208672:	78bc                	ld	a5,112(s1)
ffffffffc0208674:	c3b9                	beqz	a5,ffffffffc02086ba <vfs_getcwd+0xba>
ffffffffc0208676:	7f9c                	ld	a5,56(a5)
ffffffffc0208678:	c3a9                	beqz	a5,ffffffffc02086ba <vfs_getcwd+0xba>
ffffffffc020867a:	00006597          	auipc	a1,0x6
ffffffffc020867e:	37e58593          	addi	a1,a1,894 # ffffffffc020e9f8 <syscalls+0xe10>
ffffffffc0208682:	8526                	mv	a0,s1
ffffffffc0208684:	bd6ff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0208688:	78bc                	ld	a5,112(s1)
ffffffffc020868a:	85ca                	mv	a1,s2
ffffffffc020868c:	8526                	mv	a0,s1
ffffffffc020868e:	7f9c                	ld	a5,56(a5)
ffffffffc0208690:	9782                	jalr	a5
ffffffffc0208692:	842a                	mv	s0,a0
ffffffffc0208694:	b77d                	j	ffffffffc0208642 <vfs_getcwd+0x42>
ffffffffc0208696:	5441                	li	s0,-16
ffffffffc0208698:	bf45                	j	ffffffffc0208648 <vfs_getcwd+0x48>
ffffffffc020869a:	00006697          	auipc	a3,0x6
ffffffffc020869e:	22668693          	addi	a3,a3,550 # ffffffffc020e8c0 <syscalls+0xcd8>
ffffffffc02086a2:	00003617          	auipc	a2,0x3
ffffffffc02086a6:	4d660613          	addi	a2,a2,1238 # ffffffffc020bb78 <commands+0x210>
ffffffffc02086aa:	06e00593          	li	a1,110
ffffffffc02086ae:	00006517          	auipc	a0,0x6
ffffffffc02086b2:	2d250513          	addi	a0,a0,722 # ffffffffc020e980 <syscalls+0xd98>
ffffffffc02086b6:	de9f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02086ba:	00006697          	auipc	a3,0x6
ffffffffc02086be:	2e668693          	addi	a3,a3,742 # ffffffffc020e9a0 <syscalls+0xdb8>
ffffffffc02086c2:	00003617          	auipc	a2,0x3
ffffffffc02086c6:	4b660613          	addi	a2,a2,1206 # ffffffffc020bb78 <commands+0x210>
ffffffffc02086ca:	07800593          	li	a1,120
ffffffffc02086ce:	00006517          	auipc	a0,0x6
ffffffffc02086d2:	2b250513          	addi	a0,a0,690 # ffffffffc020e980 <syscalls+0xd98>
ffffffffc02086d6:	dc9f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086da <dev_lookup>:
ffffffffc02086da:	0005c783          	lbu	a5,0(a1)
ffffffffc02086de:	e385                	bnez	a5,ffffffffc02086fe <dev_lookup+0x24>
ffffffffc02086e0:	1101                	addi	sp,sp,-32
ffffffffc02086e2:	e822                	sd	s0,16(sp)
ffffffffc02086e4:	e426                	sd	s1,8(sp)
ffffffffc02086e6:	ec06                	sd	ra,24(sp)
ffffffffc02086e8:	84aa                	mv	s1,a0
ffffffffc02086ea:	8432                	mv	s0,a2
ffffffffc02086ec:	b56ff0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc02086f0:	60e2                	ld	ra,24(sp)
ffffffffc02086f2:	e004                	sd	s1,0(s0)
ffffffffc02086f4:	6442                	ld	s0,16(sp)
ffffffffc02086f6:	64a2                	ld	s1,8(sp)
ffffffffc02086f8:	4501                	li	a0,0
ffffffffc02086fa:	6105                	addi	sp,sp,32
ffffffffc02086fc:	8082                	ret
ffffffffc02086fe:	5541                	li	a0,-16
ffffffffc0208700:	8082                	ret

ffffffffc0208702 <dev_fstat>:
ffffffffc0208702:	1101                	addi	sp,sp,-32
ffffffffc0208704:	e426                	sd	s1,8(sp)
ffffffffc0208706:	84ae                	mv	s1,a1
ffffffffc0208708:	e822                	sd	s0,16(sp)
ffffffffc020870a:	02000613          	li	a2,32
ffffffffc020870e:	842a                	mv	s0,a0
ffffffffc0208710:	4581                	li	a1,0
ffffffffc0208712:	8526                	mv	a0,s1
ffffffffc0208714:	ec06                	sd	ra,24(sp)
ffffffffc0208716:	77f020ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc020871a:	c429                	beqz	s0,ffffffffc0208764 <dev_fstat+0x62>
ffffffffc020871c:	783c                	ld	a5,112(s0)
ffffffffc020871e:	c3b9                	beqz	a5,ffffffffc0208764 <dev_fstat+0x62>
ffffffffc0208720:	6bbc                	ld	a5,80(a5)
ffffffffc0208722:	c3a9                	beqz	a5,ffffffffc0208764 <dev_fstat+0x62>
ffffffffc0208724:	00006597          	auipc	a1,0x6
ffffffffc0208728:	27458593          	addi	a1,a1,628 # ffffffffc020e998 <syscalls+0xdb0>
ffffffffc020872c:	8522                	mv	a0,s0
ffffffffc020872e:	b2cff0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0208732:	783c                	ld	a5,112(s0)
ffffffffc0208734:	85a6                	mv	a1,s1
ffffffffc0208736:	8522                	mv	a0,s0
ffffffffc0208738:	6bbc                	ld	a5,80(a5)
ffffffffc020873a:	9782                	jalr	a5
ffffffffc020873c:	ed19                	bnez	a0,ffffffffc020875a <dev_fstat+0x58>
ffffffffc020873e:	4c38                	lw	a4,88(s0)
ffffffffc0208740:	6785                	lui	a5,0x1
ffffffffc0208742:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208746:	02f71f63          	bne	a4,a5,ffffffffc0208784 <dev_fstat+0x82>
ffffffffc020874a:	6018                	ld	a4,0(s0)
ffffffffc020874c:	641c                	ld	a5,8(s0)
ffffffffc020874e:	4685                	li	a3,1
ffffffffc0208750:	e494                	sd	a3,8(s1)
ffffffffc0208752:	02e787b3          	mul	a5,a5,a4
ffffffffc0208756:	e898                	sd	a4,16(s1)
ffffffffc0208758:	ec9c                	sd	a5,24(s1)
ffffffffc020875a:	60e2                	ld	ra,24(sp)
ffffffffc020875c:	6442                	ld	s0,16(sp)
ffffffffc020875e:	64a2                	ld	s1,8(sp)
ffffffffc0208760:	6105                	addi	sp,sp,32
ffffffffc0208762:	8082                	ret
ffffffffc0208764:	00006697          	auipc	a3,0x6
ffffffffc0208768:	1cc68693          	addi	a3,a3,460 # ffffffffc020e930 <syscalls+0xd48>
ffffffffc020876c:	00003617          	auipc	a2,0x3
ffffffffc0208770:	40c60613          	addi	a2,a2,1036 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208774:	04200593          	li	a1,66
ffffffffc0208778:	00006517          	auipc	a0,0x6
ffffffffc020877c:	29050513          	addi	a0,a0,656 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc0208780:	d1ff70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208784:	00006697          	auipc	a3,0x6
ffffffffc0208788:	f7468693          	addi	a3,a3,-140 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc020878c:	00003617          	auipc	a2,0x3
ffffffffc0208790:	3ec60613          	addi	a2,a2,1004 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208794:	04500593          	li	a1,69
ffffffffc0208798:	00006517          	auipc	a0,0x6
ffffffffc020879c:	27050513          	addi	a0,a0,624 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc02087a0:	cfff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02087a4 <dev_ioctl>:
ffffffffc02087a4:	c909                	beqz	a0,ffffffffc02087b6 <dev_ioctl+0x12>
ffffffffc02087a6:	4d34                	lw	a3,88(a0)
ffffffffc02087a8:	6705                	lui	a4,0x1
ffffffffc02087aa:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02087ae:	00e69463          	bne	a3,a4,ffffffffc02087b6 <dev_ioctl+0x12>
ffffffffc02087b2:	751c                	ld	a5,40(a0)
ffffffffc02087b4:	8782                	jr	a5
ffffffffc02087b6:	1141                	addi	sp,sp,-16
ffffffffc02087b8:	00006697          	auipc	a3,0x6
ffffffffc02087bc:	f4068693          	addi	a3,a3,-192 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc02087c0:	00003617          	auipc	a2,0x3
ffffffffc02087c4:	3b860613          	addi	a2,a2,952 # ffffffffc020bb78 <commands+0x210>
ffffffffc02087c8:	03500593          	li	a1,53
ffffffffc02087cc:	00006517          	auipc	a0,0x6
ffffffffc02087d0:	23c50513          	addi	a0,a0,572 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc02087d4:	e406                	sd	ra,8(sp)
ffffffffc02087d6:	cc9f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02087da <dev_tryseek>:
ffffffffc02087da:	c51d                	beqz	a0,ffffffffc0208808 <dev_tryseek+0x2e>
ffffffffc02087dc:	4d38                	lw	a4,88(a0)
ffffffffc02087de:	6785                	lui	a5,0x1
ffffffffc02087e0:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02087e4:	02f71263          	bne	a4,a5,ffffffffc0208808 <dev_tryseek+0x2e>
ffffffffc02087e8:	611c                	ld	a5,0(a0)
ffffffffc02087ea:	cf89                	beqz	a5,ffffffffc0208804 <dev_tryseek+0x2a>
ffffffffc02087ec:	6518                	ld	a4,8(a0)
ffffffffc02087ee:	02e5f6b3          	remu	a3,a1,a4
ffffffffc02087f2:	ea89                	bnez	a3,ffffffffc0208804 <dev_tryseek+0x2a>
ffffffffc02087f4:	0005c863          	bltz	a1,ffffffffc0208804 <dev_tryseek+0x2a>
ffffffffc02087f8:	02e787b3          	mul	a5,a5,a4
ffffffffc02087fc:	00f5f463          	bgeu	a1,a5,ffffffffc0208804 <dev_tryseek+0x2a>
ffffffffc0208800:	4501                	li	a0,0
ffffffffc0208802:	8082                	ret
ffffffffc0208804:	5575                	li	a0,-3
ffffffffc0208806:	8082                	ret
ffffffffc0208808:	1141                	addi	sp,sp,-16
ffffffffc020880a:	00006697          	auipc	a3,0x6
ffffffffc020880e:	eee68693          	addi	a3,a3,-274 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc0208812:	00003617          	auipc	a2,0x3
ffffffffc0208816:	36660613          	addi	a2,a2,870 # ffffffffc020bb78 <commands+0x210>
ffffffffc020881a:	05f00593          	li	a1,95
ffffffffc020881e:	00006517          	auipc	a0,0x6
ffffffffc0208822:	1ea50513          	addi	a0,a0,490 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc0208826:	e406                	sd	ra,8(sp)
ffffffffc0208828:	c77f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020882c <dev_gettype>:
ffffffffc020882c:	c10d                	beqz	a0,ffffffffc020884e <dev_gettype+0x22>
ffffffffc020882e:	4d38                	lw	a4,88(a0)
ffffffffc0208830:	6785                	lui	a5,0x1
ffffffffc0208832:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208836:	00f71c63          	bne	a4,a5,ffffffffc020884e <dev_gettype+0x22>
ffffffffc020883a:	6118                	ld	a4,0(a0)
ffffffffc020883c:	6795                	lui	a5,0x5
ffffffffc020883e:	c701                	beqz	a4,ffffffffc0208846 <dev_gettype+0x1a>
ffffffffc0208840:	c19c                	sw	a5,0(a1)
ffffffffc0208842:	4501                	li	a0,0
ffffffffc0208844:	8082                	ret
ffffffffc0208846:	6791                	lui	a5,0x4
ffffffffc0208848:	c19c                	sw	a5,0(a1)
ffffffffc020884a:	4501                	li	a0,0
ffffffffc020884c:	8082                	ret
ffffffffc020884e:	1141                	addi	sp,sp,-16
ffffffffc0208850:	00006697          	auipc	a3,0x6
ffffffffc0208854:	ea868693          	addi	a3,a3,-344 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc0208858:	00003617          	auipc	a2,0x3
ffffffffc020885c:	32060613          	addi	a2,a2,800 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208860:	05300593          	li	a1,83
ffffffffc0208864:	00006517          	auipc	a0,0x6
ffffffffc0208868:	1a450513          	addi	a0,a0,420 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc020886c:	e406                	sd	ra,8(sp)
ffffffffc020886e:	c31f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208872 <dev_write>:
ffffffffc0208872:	c911                	beqz	a0,ffffffffc0208886 <dev_write+0x14>
ffffffffc0208874:	4d34                	lw	a3,88(a0)
ffffffffc0208876:	6705                	lui	a4,0x1
ffffffffc0208878:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020887c:	00e69563          	bne	a3,a4,ffffffffc0208886 <dev_write+0x14>
ffffffffc0208880:	711c                	ld	a5,32(a0)
ffffffffc0208882:	4605                	li	a2,1
ffffffffc0208884:	8782                	jr	a5
ffffffffc0208886:	1141                	addi	sp,sp,-16
ffffffffc0208888:	00006697          	auipc	a3,0x6
ffffffffc020888c:	e7068693          	addi	a3,a3,-400 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc0208890:	00003617          	auipc	a2,0x3
ffffffffc0208894:	2e860613          	addi	a2,a2,744 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208898:	02c00593          	li	a1,44
ffffffffc020889c:	00006517          	auipc	a0,0x6
ffffffffc02088a0:	16c50513          	addi	a0,a0,364 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc02088a4:	e406                	sd	ra,8(sp)
ffffffffc02088a6:	bf9f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02088aa <dev_read>:
ffffffffc02088aa:	c911                	beqz	a0,ffffffffc02088be <dev_read+0x14>
ffffffffc02088ac:	4d34                	lw	a3,88(a0)
ffffffffc02088ae:	6705                	lui	a4,0x1
ffffffffc02088b0:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088b4:	00e69563          	bne	a3,a4,ffffffffc02088be <dev_read+0x14>
ffffffffc02088b8:	711c                	ld	a5,32(a0)
ffffffffc02088ba:	4601                	li	a2,0
ffffffffc02088bc:	8782                	jr	a5
ffffffffc02088be:	1141                	addi	sp,sp,-16
ffffffffc02088c0:	00006697          	auipc	a3,0x6
ffffffffc02088c4:	e3868693          	addi	a3,a3,-456 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc02088c8:	00003617          	auipc	a2,0x3
ffffffffc02088cc:	2b060613          	addi	a2,a2,688 # ffffffffc020bb78 <commands+0x210>
ffffffffc02088d0:	02300593          	li	a1,35
ffffffffc02088d4:	00006517          	auipc	a0,0x6
ffffffffc02088d8:	13450513          	addi	a0,a0,308 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc02088dc:	e406                	sd	ra,8(sp)
ffffffffc02088de:	bc1f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02088e2 <dev_close>:
ffffffffc02088e2:	c909                	beqz	a0,ffffffffc02088f4 <dev_close+0x12>
ffffffffc02088e4:	4d34                	lw	a3,88(a0)
ffffffffc02088e6:	6705                	lui	a4,0x1
ffffffffc02088e8:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088ec:	00e69463          	bne	a3,a4,ffffffffc02088f4 <dev_close+0x12>
ffffffffc02088f0:	6d1c                	ld	a5,24(a0)
ffffffffc02088f2:	8782                	jr	a5
ffffffffc02088f4:	1141                	addi	sp,sp,-16
ffffffffc02088f6:	00006697          	auipc	a3,0x6
ffffffffc02088fa:	e0268693          	addi	a3,a3,-510 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc02088fe:	00003617          	auipc	a2,0x3
ffffffffc0208902:	27a60613          	addi	a2,a2,634 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208906:	45e9                	li	a1,26
ffffffffc0208908:	00006517          	auipc	a0,0x6
ffffffffc020890c:	10050513          	addi	a0,a0,256 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc0208910:	e406                	sd	ra,8(sp)
ffffffffc0208912:	b8df70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208916 <dev_open>:
ffffffffc0208916:	03c5f713          	andi	a4,a1,60
ffffffffc020891a:	eb11                	bnez	a4,ffffffffc020892e <dev_open+0x18>
ffffffffc020891c:	c919                	beqz	a0,ffffffffc0208932 <dev_open+0x1c>
ffffffffc020891e:	4d34                	lw	a3,88(a0)
ffffffffc0208920:	6705                	lui	a4,0x1
ffffffffc0208922:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208926:	00e69663          	bne	a3,a4,ffffffffc0208932 <dev_open+0x1c>
ffffffffc020892a:	691c                	ld	a5,16(a0)
ffffffffc020892c:	8782                	jr	a5
ffffffffc020892e:	5575                	li	a0,-3
ffffffffc0208930:	8082                	ret
ffffffffc0208932:	1141                	addi	sp,sp,-16
ffffffffc0208934:	00006697          	auipc	a3,0x6
ffffffffc0208938:	dc468693          	addi	a3,a3,-572 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc020893c:	00003617          	auipc	a2,0x3
ffffffffc0208940:	23c60613          	addi	a2,a2,572 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208944:	45c5                	li	a1,17
ffffffffc0208946:	00006517          	auipc	a0,0x6
ffffffffc020894a:	0c250513          	addi	a0,a0,194 # ffffffffc020ea08 <syscalls+0xe20>
ffffffffc020894e:	e406                	sd	ra,8(sp)
ffffffffc0208950:	b4ff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208954 <dev_init>:
ffffffffc0208954:	1141                	addi	sp,sp,-16
ffffffffc0208956:	e406                	sd	ra,8(sp)
ffffffffc0208958:	542000ef          	jal	ra,ffffffffc0208e9a <dev_init_stdin>
ffffffffc020895c:	65a000ef          	jal	ra,ffffffffc0208fb6 <dev_init_stdout>
ffffffffc0208960:	60a2                	ld	ra,8(sp)
ffffffffc0208962:	0141                	addi	sp,sp,16
ffffffffc0208964:	a439                	j	ffffffffc0208b72 <dev_init_disk0>

ffffffffc0208966 <dev_create_inode>:
ffffffffc0208966:	6505                	lui	a0,0x1
ffffffffc0208968:	1141                	addi	sp,sp,-16
ffffffffc020896a:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020896e:	e022                	sd	s0,0(sp)
ffffffffc0208970:	e406                	sd	ra,8(sp)
ffffffffc0208972:	852ff0ef          	jal	ra,ffffffffc02079c4 <__alloc_inode>
ffffffffc0208976:	842a                	mv	s0,a0
ffffffffc0208978:	c901                	beqz	a0,ffffffffc0208988 <dev_create_inode+0x22>
ffffffffc020897a:	4601                	li	a2,0
ffffffffc020897c:	00006597          	auipc	a1,0x6
ffffffffc0208980:	0a458593          	addi	a1,a1,164 # ffffffffc020ea20 <dev_node_ops>
ffffffffc0208984:	85cff0ef          	jal	ra,ffffffffc02079e0 <inode_init>
ffffffffc0208988:	60a2                	ld	ra,8(sp)
ffffffffc020898a:	8522                	mv	a0,s0
ffffffffc020898c:	6402                	ld	s0,0(sp)
ffffffffc020898e:	0141                	addi	sp,sp,16
ffffffffc0208990:	8082                	ret

ffffffffc0208992 <disk0_open>:
ffffffffc0208992:	4501                	li	a0,0
ffffffffc0208994:	8082                	ret

ffffffffc0208996 <disk0_close>:
ffffffffc0208996:	4501                	li	a0,0
ffffffffc0208998:	8082                	ret

ffffffffc020899a <disk0_ioctl>:
ffffffffc020899a:	5531                	li	a0,-20
ffffffffc020899c:	8082                	ret

ffffffffc020899e <disk0_io>:
ffffffffc020899e:	659c                	ld	a5,8(a1)
ffffffffc02089a0:	7159                	addi	sp,sp,-112
ffffffffc02089a2:	eca6                	sd	s1,88(sp)
ffffffffc02089a4:	f45e                	sd	s7,40(sp)
ffffffffc02089a6:	6d84                	ld	s1,24(a1)
ffffffffc02089a8:	6b85                	lui	s7,0x1
ffffffffc02089aa:	1bfd                	addi	s7,s7,-1
ffffffffc02089ac:	e4ce                	sd	s3,72(sp)
ffffffffc02089ae:	43f7d993          	srai	s3,a5,0x3f
ffffffffc02089b2:	0179f9b3          	and	s3,s3,s7
ffffffffc02089b6:	99be                	add	s3,s3,a5
ffffffffc02089b8:	8fc5                	or	a5,a5,s1
ffffffffc02089ba:	f486                	sd	ra,104(sp)
ffffffffc02089bc:	f0a2                	sd	s0,96(sp)
ffffffffc02089be:	e8ca                	sd	s2,80(sp)
ffffffffc02089c0:	e0d2                	sd	s4,64(sp)
ffffffffc02089c2:	fc56                	sd	s5,56(sp)
ffffffffc02089c4:	f85a                	sd	s6,48(sp)
ffffffffc02089c6:	f062                	sd	s8,32(sp)
ffffffffc02089c8:	ec66                	sd	s9,24(sp)
ffffffffc02089ca:	e86a                	sd	s10,16(sp)
ffffffffc02089cc:	0177f7b3          	and	a5,a5,s7
ffffffffc02089d0:	10079d63          	bnez	a5,ffffffffc0208aea <disk0_io+0x14c>
ffffffffc02089d4:	40c9d993          	srai	s3,s3,0xc
ffffffffc02089d8:	00c4d713          	srli	a4,s1,0xc
ffffffffc02089dc:	2981                	sext.w	s3,s3
ffffffffc02089de:	2701                	sext.w	a4,a4
ffffffffc02089e0:	00e987bb          	addw	a5,s3,a4
ffffffffc02089e4:	6114                	ld	a3,0(a0)
ffffffffc02089e6:	1782                	slli	a5,a5,0x20
ffffffffc02089e8:	9381                	srli	a5,a5,0x20
ffffffffc02089ea:	10f6e063          	bltu	a3,a5,ffffffffc0208aea <disk0_io+0x14c>
ffffffffc02089ee:	4501                	li	a0,0
ffffffffc02089f0:	ef19                	bnez	a4,ffffffffc0208a0e <disk0_io+0x70>
ffffffffc02089f2:	70a6                	ld	ra,104(sp)
ffffffffc02089f4:	7406                	ld	s0,96(sp)
ffffffffc02089f6:	64e6                	ld	s1,88(sp)
ffffffffc02089f8:	6946                	ld	s2,80(sp)
ffffffffc02089fa:	69a6                	ld	s3,72(sp)
ffffffffc02089fc:	6a06                	ld	s4,64(sp)
ffffffffc02089fe:	7ae2                	ld	s5,56(sp)
ffffffffc0208a00:	7b42                	ld	s6,48(sp)
ffffffffc0208a02:	7ba2                	ld	s7,40(sp)
ffffffffc0208a04:	7c02                	ld	s8,32(sp)
ffffffffc0208a06:	6ce2                	ld	s9,24(sp)
ffffffffc0208a08:	6d42                	ld	s10,16(sp)
ffffffffc0208a0a:	6165                	addi	sp,sp,112
ffffffffc0208a0c:	8082                	ret
ffffffffc0208a0e:	0008d517          	auipc	a0,0x8d
ffffffffc0208a12:	e3250513          	addi	a0,a0,-462 # ffffffffc0295840 <disk0_sem>
ffffffffc0208a16:	8b2e                	mv	s6,a1
ffffffffc0208a18:	8c32                	mv	s8,a2
ffffffffc0208a1a:	0008ea97          	auipc	s5,0x8e
ffffffffc0208a1e:	edea8a93          	addi	s5,s5,-290 # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208a22:	c43fb0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc0208a26:	6c91                	lui	s9,0x4
ffffffffc0208a28:	e4b9                	bnez	s1,ffffffffc0208a76 <disk0_io+0xd8>
ffffffffc0208a2a:	a845                	j	ffffffffc0208ada <disk0_io+0x13c>
ffffffffc0208a2c:	00c4d413          	srli	s0,s1,0xc
ffffffffc0208a30:	0034169b          	slliw	a3,s0,0x3
ffffffffc0208a34:	00068d1b          	sext.w	s10,a3
ffffffffc0208a38:	1682                	slli	a3,a3,0x20
ffffffffc0208a3a:	2401                	sext.w	s0,s0
ffffffffc0208a3c:	9281                	srli	a3,a3,0x20
ffffffffc0208a3e:	8926                	mv	s2,s1
ffffffffc0208a40:	00399a1b          	slliw	s4,s3,0x3
ffffffffc0208a44:	862e                	mv	a2,a1
ffffffffc0208a46:	4509                	li	a0,2
ffffffffc0208a48:	85d2                	mv	a1,s4
ffffffffc0208a4a:	8f6f80ef          	jal	ra,ffffffffc0200b40 <ide_read_secs>
ffffffffc0208a4e:	e165                	bnez	a0,ffffffffc0208b2e <disk0_io+0x190>
ffffffffc0208a50:	000ab583          	ld	a1,0(s5)
ffffffffc0208a54:	0038                	addi	a4,sp,8
ffffffffc0208a56:	4685                	li	a3,1
ffffffffc0208a58:	864a                	mv	a2,s2
ffffffffc0208a5a:	855a                	mv	a0,s6
ffffffffc0208a5c:	a91fc0ef          	jal	ra,ffffffffc02054ec <iobuf_move>
ffffffffc0208a60:	67a2                	ld	a5,8(sp)
ffffffffc0208a62:	09279663          	bne	a5,s2,ffffffffc0208aee <disk0_io+0x150>
ffffffffc0208a66:	017977b3          	and	a5,s2,s7
ffffffffc0208a6a:	e3d1                	bnez	a5,ffffffffc0208aee <disk0_io+0x150>
ffffffffc0208a6c:	412484b3          	sub	s1,s1,s2
ffffffffc0208a70:	013409bb          	addw	s3,s0,s3
ffffffffc0208a74:	c0bd                	beqz	s1,ffffffffc0208ada <disk0_io+0x13c>
ffffffffc0208a76:	000ab583          	ld	a1,0(s5)
ffffffffc0208a7a:	000c1b63          	bnez	s8,ffffffffc0208a90 <disk0_io+0xf2>
ffffffffc0208a7e:	fb94e7e3          	bltu	s1,s9,ffffffffc0208a2c <disk0_io+0x8e>
ffffffffc0208a82:	02000693          	li	a3,32
ffffffffc0208a86:	02000d13          	li	s10,32
ffffffffc0208a8a:	4411                	li	s0,4
ffffffffc0208a8c:	6911                	lui	s2,0x4
ffffffffc0208a8e:	bf4d                	j	ffffffffc0208a40 <disk0_io+0xa2>
ffffffffc0208a90:	0038                	addi	a4,sp,8
ffffffffc0208a92:	4681                	li	a3,0
ffffffffc0208a94:	6611                	lui	a2,0x4
ffffffffc0208a96:	855a                	mv	a0,s6
ffffffffc0208a98:	a55fc0ef          	jal	ra,ffffffffc02054ec <iobuf_move>
ffffffffc0208a9c:	6422                	ld	s0,8(sp)
ffffffffc0208a9e:	c825                	beqz	s0,ffffffffc0208b0e <disk0_io+0x170>
ffffffffc0208aa0:	0684e763          	bltu	s1,s0,ffffffffc0208b0e <disk0_io+0x170>
ffffffffc0208aa4:	017477b3          	and	a5,s0,s7
ffffffffc0208aa8:	e3bd                	bnez	a5,ffffffffc0208b0e <disk0_io+0x170>
ffffffffc0208aaa:	8031                	srli	s0,s0,0xc
ffffffffc0208aac:	0034179b          	slliw	a5,s0,0x3
ffffffffc0208ab0:	000ab603          	ld	a2,0(s5)
ffffffffc0208ab4:	0039991b          	slliw	s2,s3,0x3
ffffffffc0208ab8:	02079693          	slli	a3,a5,0x20
ffffffffc0208abc:	9281                	srli	a3,a3,0x20
ffffffffc0208abe:	85ca                	mv	a1,s2
ffffffffc0208ac0:	4509                	li	a0,2
ffffffffc0208ac2:	2401                	sext.w	s0,s0
ffffffffc0208ac4:	00078a1b          	sext.w	s4,a5
ffffffffc0208ac8:	90ef80ef          	jal	ra,ffffffffc0200bd6 <ide_write_secs>
ffffffffc0208acc:	e151                	bnez	a0,ffffffffc0208b50 <disk0_io+0x1b2>
ffffffffc0208ace:	6922                	ld	s2,8(sp)
ffffffffc0208ad0:	013409bb          	addw	s3,s0,s3
ffffffffc0208ad4:	412484b3          	sub	s1,s1,s2
ffffffffc0208ad8:	fcd9                	bnez	s1,ffffffffc0208a76 <disk0_io+0xd8>
ffffffffc0208ada:	0008d517          	auipc	a0,0x8d
ffffffffc0208ade:	d6650513          	addi	a0,a0,-666 # ffffffffc0295840 <disk0_sem>
ffffffffc0208ae2:	b7ffb0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc0208ae6:	4501                	li	a0,0
ffffffffc0208ae8:	b729                	j	ffffffffc02089f2 <disk0_io+0x54>
ffffffffc0208aea:	5575                	li	a0,-3
ffffffffc0208aec:	b719                	j	ffffffffc02089f2 <disk0_io+0x54>
ffffffffc0208aee:	00006697          	auipc	a3,0x6
ffffffffc0208af2:	0aa68693          	addi	a3,a3,170 # ffffffffc020eb98 <dev_node_ops+0x178>
ffffffffc0208af6:	00003617          	auipc	a2,0x3
ffffffffc0208afa:	08260613          	addi	a2,a2,130 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208afe:	06200593          	li	a1,98
ffffffffc0208b02:	00006517          	auipc	a0,0x6
ffffffffc0208b06:	fde50513          	addi	a0,a0,-34 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208b0a:	995f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b0e:	00006697          	auipc	a3,0x6
ffffffffc0208b12:	f9268693          	addi	a3,a3,-110 # ffffffffc020eaa0 <dev_node_ops+0x80>
ffffffffc0208b16:	00003617          	auipc	a2,0x3
ffffffffc0208b1a:	06260613          	addi	a2,a2,98 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208b1e:	05700593          	li	a1,87
ffffffffc0208b22:	00006517          	auipc	a0,0x6
ffffffffc0208b26:	fbe50513          	addi	a0,a0,-66 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208b2a:	975f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b2e:	88aa                	mv	a7,a0
ffffffffc0208b30:	886a                	mv	a6,s10
ffffffffc0208b32:	87a2                	mv	a5,s0
ffffffffc0208b34:	8752                	mv	a4,s4
ffffffffc0208b36:	86ce                	mv	a3,s3
ffffffffc0208b38:	00006617          	auipc	a2,0x6
ffffffffc0208b3c:	01860613          	addi	a2,a2,24 # ffffffffc020eb50 <dev_node_ops+0x130>
ffffffffc0208b40:	02d00593          	li	a1,45
ffffffffc0208b44:	00006517          	auipc	a0,0x6
ffffffffc0208b48:	f9c50513          	addi	a0,a0,-100 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208b4c:	953f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b50:	88aa                	mv	a7,a0
ffffffffc0208b52:	8852                	mv	a6,s4
ffffffffc0208b54:	87a2                	mv	a5,s0
ffffffffc0208b56:	874a                	mv	a4,s2
ffffffffc0208b58:	86ce                	mv	a3,s3
ffffffffc0208b5a:	00006617          	auipc	a2,0x6
ffffffffc0208b5e:	fa660613          	addi	a2,a2,-90 # ffffffffc020eb00 <dev_node_ops+0xe0>
ffffffffc0208b62:	03700593          	li	a1,55
ffffffffc0208b66:	00006517          	auipc	a0,0x6
ffffffffc0208b6a:	f7a50513          	addi	a0,a0,-134 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208b6e:	931f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208b72 <dev_init_disk0>:
ffffffffc0208b72:	1101                	addi	sp,sp,-32
ffffffffc0208b74:	ec06                	sd	ra,24(sp)
ffffffffc0208b76:	e822                	sd	s0,16(sp)
ffffffffc0208b78:	e426                	sd	s1,8(sp)
ffffffffc0208b7a:	dedff0ef          	jal	ra,ffffffffc0208966 <dev_create_inode>
ffffffffc0208b7e:	c541                	beqz	a0,ffffffffc0208c06 <dev_init_disk0+0x94>
ffffffffc0208b80:	4d38                	lw	a4,88(a0)
ffffffffc0208b82:	6485                	lui	s1,0x1
ffffffffc0208b84:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208b88:	842a                	mv	s0,a0
ffffffffc0208b8a:	0cf71f63          	bne	a4,a5,ffffffffc0208c68 <dev_init_disk0+0xf6>
ffffffffc0208b8e:	4509                	li	a0,2
ffffffffc0208b90:	f65f70ef          	jal	ra,ffffffffc0200af4 <ide_device_valid>
ffffffffc0208b94:	cd55                	beqz	a0,ffffffffc0208c50 <dev_init_disk0+0xde>
ffffffffc0208b96:	4509                	li	a0,2
ffffffffc0208b98:	f81f70ef          	jal	ra,ffffffffc0200b18 <ide_device_size>
ffffffffc0208b9c:	00355793          	srli	a5,a0,0x3
ffffffffc0208ba0:	e01c                	sd	a5,0(s0)
ffffffffc0208ba2:	00000797          	auipc	a5,0x0
ffffffffc0208ba6:	df078793          	addi	a5,a5,-528 # ffffffffc0208992 <disk0_open>
ffffffffc0208baa:	e81c                	sd	a5,16(s0)
ffffffffc0208bac:	00000797          	auipc	a5,0x0
ffffffffc0208bb0:	dea78793          	addi	a5,a5,-534 # ffffffffc0208996 <disk0_close>
ffffffffc0208bb4:	ec1c                	sd	a5,24(s0)
ffffffffc0208bb6:	00000797          	auipc	a5,0x0
ffffffffc0208bba:	de878793          	addi	a5,a5,-536 # ffffffffc020899e <disk0_io>
ffffffffc0208bbe:	f01c                	sd	a5,32(s0)
ffffffffc0208bc0:	00000797          	auipc	a5,0x0
ffffffffc0208bc4:	dda78793          	addi	a5,a5,-550 # ffffffffc020899a <disk0_ioctl>
ffffffffc0208bc8:	f41c                	sd	a5,40(s0)
ffffffffc0208bca:	4585                	li	a1,1
ffffffffc0208bcc:	0008d517          	auipc	a0,0x8d
ffffffffc0208bd0:	c7450513          	addi	a0,a0,-908 # ffffffffc0295840 <disk0_sem>
ffffffffc0208bd4:	e404                	sd	s1,8(s0)
ffffffffc0208bd6:	a85fb0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0208bda:	6511                	lui	a0,0x4
ffffffffc0208bdc:	c3af90ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0208be0:	0008e797          	auipc	a5,0x8e
ffffffffc0208be4:	d0a7bc23          	sd	a0,-744(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208be8:	c921                	beqz	a0,ffffffffc0208c38 <dev_init_disk0+0xc6>
ffffffffc0208bea:	4605                	li	a2,1
ffffffffc0208bec:	85a2                	mv	a1,s0
ffffffffc0208bee:	00006517          	auipc	a0,0x6
ffffffffc0208bf2:	03a50513          	addi	a0,a0,58 # ffffffffc020ec28 <dev_node_ops+0x208>
ffffffffc0208bf6:	c2cff0ef          	jal	ra,ffffffffc0208022 <vfs_add_dev>
ffffffffc0208bfa:	e115                	bnez	a0,ffffffffc0208c1e <dev_init_disk0+0xac>
ffffffffc0208bfc:	60e2                	ld	ra,24(sp)
ffffffffc0208bfe:	6442                	ld	s0,16(sp)
ffffffffc0208c00:	64a2                	ld	s1,8(sp)
ffffffffc0208c02:	6105                	addi	sp,sp,32
ffffffffc0208c04:	8082                	ret
ffffffffc0208c06:	00006617          	auipc	a2,0x6
ffffffffc0208c0a:	fc260613          	addi	a2,a2,-62 # ffffffffc020ebc8 <dev_node_ops+0x1a8>
ffffffffc0208c0e:	08700593          	li	a1,135
ffffffffc0208c12:	00006517          	auipc	a0,0x6
ffffffffc0208c16:	ece50513          	addi	a0,a0,-306 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208c1a:	885f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c1e:	86aa                	mv	a3,a0
ffffffffc0208c20:	00006617          	auipc	a2,0x6
ffffffffc0208c24:	01060613          	addi	a2,a2,16 # ffffffffc020ec30 <dev_node_ops+0x210>
ffffffffc0208c28:	08d00593          	li	a1,141
ffffffffc0208c2c:	00006517          	auipc	a0,0x6
ffffffffc0208c30:	eb450513          	addi	a0,a0,-332 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208c34:	86bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c38:	00006617          	auipc	a2,0x6
ffffffffc0208c3c:	fd060613          	addi	a2,a2,-48 # ffffffffc020ec08 <dev_node_ops+0x1e8>
ffffffffc0208c40:	07f00593          	li	a1,127
ffffffffc0208c44:	00006517          	auipc	a0,0x6
ffffffffc0208c48:	e9c50513          	addi	a0,a0,-356 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208c4c:	853f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c50:	00006617          	auipc	a2,0x6
ffffffffc0208c54:	f9860613          	addi	a2,a2,-104 # ffffffffc020ebe8 <dev_node_ops+0x1c8>
ffffffffc0208c58:	07300593          	li	a1,115
ffffffffc0208c5c:	00006517          	auipc	a0,0x6
ffffffffc0208c60:	e8450513          	addi	a0,a0,-380 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208c64:	83bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208c68:	00006697          	auipc	a3,0x6
ffffffffc0208c6c:	a9068693          	addi	a3,a3,-1392 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc0208c70:	00003617          	auipc	a2,0x3
ffffffffc0208c74:	f0860613          	addi	a2,a2,-248 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208c78:	08900593          	li	a1,137
ffffffffc0208c7c:	00006517          	auipc	a0,0x6
ffffffffc0208c80:	e6450513          	addi	a0,a0,-412 # ffffffffc020eae0 <dev_node_ops+0xc0>
ffffffffc0208c84:	81bf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208c88 <stdin_open>:
ffffffffc0208c88:	4501                	li	a0,0
ffffffffc0208c8a:	e191                	bnez	a1,ffffffffc0208c8e <stdin_open+0x6>
ffffffffc0208c8c:	8082                	ret
ffffffffc0208c8e:	5575                	li	a0,-3
ffffffffc0208c90:	8082                	ret

ffffffffc0208c92 <stdin_close>:
ffffffffc0208c92:	4501                	li	a0,0
ffffffffc0208c94:	8082                	ret

ffffffffc0208c96 <stdin_ioctl>:
ffffffffc0208c96:	5575                	li	a0,-3
ffffffffc0208c98:	8082                	ret

ffffffffc0208c9a <stdin_io>:
ffffffffc0208c9a:	7135                	addi	sp,sp,-160
ffffffffc0208c9c:	ed06                	sd	ra,152(sp)
ffffffffc0208c9e:	e922                	sd	s0,144(sp)
ffffffffc0208ca0:	e526                	sd	s1,136(sp)
ffffffffc0208ca2:	e14a                	sd	s2,128(sp)
ffffffffc0208ca4:	fcce                	sd	s3,120(sp)
ffffffffc0208ca6:	f8d2                	sd	s4,112(sp)
ffffffffc0208ca8:	f4d6                	sd	s5,104(sp)
ffffffffc0208caa:	f0da                	sd	s6,96(sp)
ffffffffc0208cac:	ecde                	sd	s7,88(sp)
ffffffffc0208cae:	e8e2                	sd	s8,80(sp)
ffffffffc0208cb0:	e4e6                	sd	s9,72(sp)
ffffffffc0208cb2:	e0ea                	sd	s10,64(sp)
ffffffffc0208cb4:	fc6e                	sd	s11,56(sp)
ffffffffc0208cb6:	14061163          	bnez	a2,ffffffffc0208df8 <stdin_io+0x15e>
ffffffffc0208cba:	0005bd83          	ld	s11,0(a1)
ffffffffc0208cbe:	0185bd03          	ld	s10,24(a1)
ffffffffc0208cc2:	8b2e                	mv	s6,a1
ffffffffc0208cc4:	100027f3          	csrr	a5,sstatus
ffffffffc0208cc8:	8b89                	andi	a5,a5,2
ffffffffc0208cca:	10079e63          	bnez	a5,ffffffffc0208de6 <stdin_io+0x14c>
ffffffffc0208cce:	4401                	li	s0,0
ffffffffc0208cd0:	100d0963          	beqz	s10,ffffffffc0208de2 <stdin_io+0x148>
ffffffffc0208cd4:	0008e997          	auipc	s3,0x8e
ffffffffc0208cd8:	c2c98993          	addi	s3,s3,-980 # ffffffffc0296900 <p_rpos>
ffffffffc0208cdc:	0009b783          	ld	a5,0(s3)
ffffffffc0208ce0:	800004b7          	lui	s1,0x80000
ffffffffc0208ce4:	6c85                	lui	s9,0x1
ffffffffc0208ce6:	4a81                	li	s5,0
ffffffffc0208ce8:	0008ea17          	auipc	s4,0x8e
ffffffffc0208cec:	c20a0a13          	addi	s4,s4,-992 # ffffffffc0296908 <p_wpos>
ffffffffc0208cf0:	0491                	addi	s1,s1,4
ffffffffc0208cf2:	0008d917          	auipc	s2,0x8d
ffffffffc0208cf6:	b6690913          	addi	s2,s2,-1178 # ffffffffc0295858 <__wait_queue>
ffffffffc0208cfa:	1cfd                	addi	s9,s9,-1
ffffffffc0208cfc:	000a3703          	ld	a4,0(s4)
ffffffffc0208d00:	000a8c1b          	sext.w	s8,s5
ffffffffc0208d04:	8be2                	mv	s7,s8
ffffffffc0208d06:	02e7d763          	bge	a5,a4,ffffffffc0208d34 <stdin_io+0x9a>
ffffffffc0208d0a:	a859                	j	ffffffffc0208da0 <stdin_io+0x106>
ffffffffc0208d0c:	815fe0ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc0208d10:	100027f3          	csrr	a5,sstatus
ffffffffc0208d14:	8b89                	andi	a5,a5,2
ffffffffc0208d16:	4401                	li	s0,0
ffffffffc0208d18:	ef8d                	bnez	a5,ffffffffc0208d52 <stdin_io+0xb8>
ffffffffc0208d1a:	0028                	addi	a0,sp,8
ffffffffc0208d1c:	9dbfb0ef          	jal	ra,ffffffffc02046f6 <wait_in_queue>
ffffffffc0208d20:	e121                	bnez	a0,ffffffffc0208d60 <stdin_io+0xc6>
ffffffffc0208d22:	47c2                	lw	a5,16(sp)
ffffffffc0208d24:	04979563          	bne	a5,s1,ffffffffc0208d6e <stdin_io+0xd4>
ffffffffc0208d28:	0009b783          	ld	a5,0(s3)
ffffffffc0208d2c:	000a3703          	ld	a4,0(s4)
ffffffffc0208d30:	06e7c863          	blt	a5,a4,ffffffffc0208da0 <stdin_io+0x106>
ffffffffc0208d34:	8626                	mv	a2,s1
ffffffffc0208d36:	002c                	addi	a1,sp,8
ffffffffc0208d38:	854a                	mv	a0,s2
ffffffffc0208d3a:	ae7fb0ef          	jal	ra,ffffffffc0204820 <wait_current_set>
ffffffffc0208d3e:	d479                	beqz	s0,ffffffffc0208d0c <stdin_io+0x72>
ffffffffc0208d40:	f2df70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208d44:	fdcfe0ef          	jal	ra,ffffffffc0207520 <schedule>
ffffffffc0208d48:	100027f3          	csrr	a5,sstatus
ffffffffc0208d4c:	8b89                	andi	a5,a5,2
ffffffffc0208d4e:	4401                	li	s0,0
ffffffffc0208d50:	d7e9                	beqz	a5,ffffffffc0208d1a <stdin_io+0x80>
ffffffffc0208d52:	f21f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208d56:	0028                	addi	a0,sp,8
ffffffffc0208d58:	4405                	li	s0,1
ffffffffc0208d5a:	99dfb0ef          	jal	ra,ffffffffc02046f6 <wait_in_queue>
ffffffffc0208d5e:	d171                	beqz	a0,ffffffffc0208d22 <stdin_io+0x88>
ffffffffc0208d60:	002c                	addi	a1,sp,8
ffffffffc0208d62:	854a                	mv	a0,s2
ffffffffc0208d64:	939fb0ef          	jal	ra,ffffffffc020469c <wait_queue_del>
ffffffffc0208d68:	47c2                	lw	a5,16(sp)
ffffffffc0208d6a:	fa978fe3          	beq	a5,s1,ffffffffc0208d28 <stdin_io+0x8e>
ffffffffc0208d6e:	e435                	bnez	s0,ffffffffc0208dda <stdin_io+0x140>
ffffffffc0208d70:	060b8963          	beqz	s7,ffffffffc0208de2 <stdin_io+0x148>
ffffffffc0208d74:	018b3783          	ld	a5,24(s6)
ffffffffc0208d78:	41578ab3          	sub	s5,a5,s5
ffffffffc0208d7c:	015b3c23          	sd	s5,24(s6)
ffffffffc0208d80:	60ea                	ld	ra,152(sp)
ffffffffc0208d82:	644a                	ld	s0,144(sp)
ffffffffc0208d84:	64aa                	ld	s1,136(sp)
ffffffffc0208d86:	690a                	ld	s2,128(sp)
ffffffffc0208d88:	79e6                	ld	s3,120(sp)
ffffffffc0208d8a:	7a46                	ld	s4,112(sp)
ffffffffc0208d8c:	7aa6                	ld	s5,104(sp)
ffffffffc0208d8e:	7b06                	ld	s6,96(sp)
ffffffffc0208d90:	6c46                	ld	s8,80(sp)
ffffffffc0208d92:	6ca6                	ld	s9,72(sp)
ffffffffc0208d94:	6d06                	ld	s10,64(sp)
ffffffffc0208d96:	7de2                	ld	s11,56(sp)
ffffffffc0208d98:	855e                	mv	a0,s7
ffffffffc0208d9a:	6be6                	ld	s7,88(sp)
ffffffffc0208d9c:	610d                	addi	sp,sp,160
ffffffffc0208d9e:	8082                	ret
ffffffffc0208da0:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208da4:	03475693          	srli	a3,a4,0x34
ffffffffc0208da8:	00d78733          	add	a4,a5,a3
ffffffffc0208dac:	01977733          	and	a4,a4,s9
ffffffffc0208db0:	8f15                	sub	a4,a4,a3
ffffffffc0208db2:	0008d697          	auipc	a3,0x8d
ffffffffc0208db6:	ab668693          	addi	a3,a3,-1354 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208dba:	9736                	add	a4,a4,a3
ffffffffc0208dbc:	00074683          	lbu	a3,0(a4)
ffffffffc0208dc0:	0785                	addi	a5,a5,1
ffffffffc0208dc2:	015d8733          	add	a4,s11,s5
ffffffffc0208dc6:	00d70023          	sb	a3,0(a4)
ffffffffc0208dca:	00f9b023          	sd	a5,0(s3)
ffffffffc0208dce:	0a85                	addi	s5,s5,1
ffffffffc0208dd0:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208dd4:	f3aae4e3          	bltu	s5,s10,ffffffffc0208cfc <stdin_io+0x62>
ffffffffc0208dd8:	dc51                	beqz	s0,ffffffffc0208d74 <stdin_io+0xda>
ffffffffc0208dda:	e93f70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208dde:	f80b9be3          	bnez	s7,ffffffffc0208d74 <stdin_io+0xda>
ffffffffc0208de2:	4b81                	li	s7,0
ffffffffc0208de4:	bf71                	j	ffffffffc0208d80 <stdin_io+0xe6>
ffffffffc0208de6:	e8df70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208dea:	4405                	li	s0,1
ffffffffc0208dec:	ee0d14e3          	bnez	s10,ffffffffc0208cd4 <stdin_io+0x3a>
ffffffffc0208df0:	e7df70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208df4:	4b81                	li	s7,0
ffffffffc0208df6:	b769                	j	ffffffffc0208d80 <stdin_io+0xe6>
ffffffffc0208df8:	5bf5                	li	s7,-3
ffffffffc0208dfa:	b759                	j	ffffffffc0208d80 <stdin_io+0xe6>

ffffffffc0208dfc <dev_stdin_write>:
ffffffffc0208dfc:	e111                	bnez	a0,ffffffffc0208e00 <dev_stdin_write+0x4>
ffffffffc0208dfe:	8082                	ret
ffffffffc0208e00:	1101                	addi	sp,sp,-32
ffffffffc0208e02:	e822                	sd	s0,16(sp)
ffffffffc0208e04:	ec06                	sd	ra,24(sp)
ffffffffc0208e06:	e426                	sd	s1,8(sp)
ffffffffc0208e08:	842a                	mv	s0,a0
ffffffffc0208e0a:	100027f3          	csrr	a5,sstatus
ffffffffc0208e0e:	8b89                	andi	a5,a5,2
ffffffffc0208e10:	4481                	li	s1,0
ffffffffc0208e12:	e3c1                	bnez	a5,ffffffffc0208e92 <dev_stdin_write+0x96>
ffffffffc0208e14:	0008e597          	auipc	a1,0x8e
ffffffffc0208e18:	af458593          	addi	a1,a1,-1292 # ffffffffc0296908 <p_wpos>
ffffffffc0208e1c:	6198                	ld	a4,0(a1)
ffffffffc0208e1e:	6605                	lui	a2,0x1
ffffffffc0208e20:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208e24:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208e28:	92d1                	srli	a3,a3,0x34
ffffffffc0208e2a:	00d707b3          	add	a5,a4,a3
ffffffffc0208e2e:	8fe9                	and	a5,a5,a0
ffffffffc0208e30:	8f95                	sub	a5,a5,a3
ffffffffc0208e32:	0008d697          	auipc	a3,0x8d
ffffffffc0208e36:	a3668693          	addi	a3,a3,-1482 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208e3a:	97b6                	add	a5,a5,a3
ffffffffc0208e3c:	00878023          	sb	s0,0(a5)
ffffffffc0208e40:	0008e797          	auipc	a5,0x8e
ffffffffc0208e44:	ac07b783          	ld	a5,-1344(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208e48:	40f707b3          	sub	a5,a4,a5
ffffffffc0208e4c:	00c7d463          	bge	a5,a2,ffffffffc0208e54 <dev_stdin_write+0x58>
ffffffffc0208e50:	0705                	addi	a4,a4,1
ffffffffc0208e52:	e198                	sd	a4,0(a1)
ffffffffc0208e54:	0008d517          	auipc	a0,0x8d
ffffffffc0208e58:	a0450513          	addi	a0,a0,-1532 # ffffffffc0295858 <__wait_queue>
ffffffffc0208e5c:	88ffb0ef          	jal	ra,ffffffffc02046ea <wait_queue_empty>
ffffffffc0208e60:	cd09                	beqz	a0,ffffffffc0208e7a <dev_stdin_write+0x7e>
ffffffffc0208e62:	e491                	bnez	s1,ffffffffc0208e6e <dev_stdin_write+0x72>
ffffffffc0208e64:	60e2                	ld	ra,24(sp)
ffffffffc0208e66:	6442                	ld	s0,16(sp)
ffffffffc0208e68:	64a2                	ld	s1,8(sp)
ffffffffc0208e6a:	6105                	addi	sp,sp,32
ffffffffc0208e6c:	8082                	ret
ffffffffc0208e6e:	6442                	ld	s0,16(sp)
ffffffffc0208e70:	60e2                	ld	ra,24(sp)
ffffffffc0208e72:	64a2                	ld	s1,8(sp)
ffffffffc0208e74:	6105                	addi	sp,sp,32
ffffffffc0208e76:	df7f706f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0208e7a:	800005b7          	lui	a1,0x80000
ffffffffc0208e7e:	4605                	li	a2,1
ffffffffc0208e80:	0591                	addi	a1,a1,4
ffffffffc0208e82:	0008d517          	auipc	a0,0x8d
ffffffffc0208e86:	9d650513          	addi	a0,a0,-1578 # ffffffffc0295858 <__wait_queue>
ffffffffc0208e8a:	8c9fb0ef          	jal	ra,ffffffffc0204752 <wakeup_queue>
ffffffffc0208e8e:	d8f9                	beqz	s1,ffffffffc0208e64 <dev_stdin_write+0x68>
ffffffffc0208e90:	bff9                	j	ffffffffc0208e6e <dev_stdin_write+0x72>
ffffffffc0208e92:	de1f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208e96:	4485                	li	s1,1
ffffffffc0208e98:	bfb5                	j	ffffffffc0208e14 <dev_stdin_write+0x18>

ffffffffc0208e9a <dev_init_stdin>:
ffffffffc0208e9a:	1141                	addi	sp,sp,-16
ffffffffc0208e9c:	e406                	sd	ra,8(sp)
ffffffffc0208e9e:	e022                	sd	s0,0(sp)
ffffffffc0208ea0:	ac7ff0ef          	jal	ra,ffffffffc0208966 <dev_create_inode>
ffffffffc0208ea4:	c93d                	beqz	a0,ffffffffc0208f1a <dev_init_stdin+0x80>
ffffffffc0208ea6:	4d38                	lw	a4,88(a0)
ffffffffc0208ea8:	6785                	lui	a5,0x1
ffffffffc0208eaa:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208eae:	842a                	mv	s0,a0
ffffffffc0208eb0:	08f71e63          	bne	a4,a5,ffffffffc0208f4c <dev_init_stdin+0xb2>
ffffffffc0208eb4:	4785                	li	a5,1
ffffffffc0208eb6:	e41c                	sd	a5,8(s0)
ffffffffc0208eb8:	00000797          	auipc	a5,0x0
ffffffffc0208ebc:	dd078793          	addi	a5,a5,-560 # ffffffffc0208c88 <stdin_open>
ffffffffc0208ec0:	e81c                	sd	a5,16(s0)
ffffffffc0208ec2:	00000797          	auipc	a5,0x0
ffffffffc0208ec6:	dd078793          	addi	a5,a5,-560 # ffffffffc0208c92 <stdin_close>
ffffffffc0208eca:	ec1c                	sd	a5,24(s0)
ffffffffc0208ecc:	00000797          	auipc	a5,0x0
ffffffffc0208ed0:	dce78793          	addi	a5,a5,-562 # ffffffffc0208c9a <stdin_io>
ffffffffc0208ed4:	f01c                	sd	a5,32(s0)
ffffffffc0208ed6:	00000797          	auipc	a5,0x0
ffffffffc0208eda:	dc078793          	addi	a5,a5,-576 # ffffffffc0208c96 <stdin_ioctl>
ffffffffc0208ede:	f41c                	sd	a5,40(s0)
ffffffffc0208ee0:	0008d517          	auipc	a0,0x8d
ffffffffc0208ee4:	97850513          	addi	a0,a0,-1672 # ffffffffc0295858 <__wait_queue>
ffffffffc0208ee8:	00043023          	sd	zero,0(s0)
ffffffffc0208eec:	0008e797          	auipc	a5,0x8e
ffffffffc0208ef0:	a007be23          	sd	zero,-1508(a5) # ffffffffc0296908 <p_wpos>
ffffffffc0208ef4:	0008e797          	auipc	a5,0x8e
ffffffffc0208ef8:	a007b623          	sd	zero,-1524(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208efc:	f9afb0ef          	jal	ra,ffffffffc0204696 <wait_queue_init>
ffffffffc0208f00:	4601                	li	a2,0
ffffffffc0208f02:	85a2                	mv	a1,s0
ffffffffc0208f04:	00006517          	auipc	a0,0x6
ffffffffc0208f08:	d8c50513          	addi	a0,a0,-628 # ffffffffc020ec90 <dev_node_ops+0x270>
ffffffffc0208f0c:	916ff0ef          	jal	ra,ffffffffc0208022 <vfs_add_dev>
ffffffffc0208f10:	e10d                	bnez	a0,ffffffffc0208f32 <dev_init_stdin+0x98>
ffffffffc0208f12:	60a2                	ld	ra,8(sp)
ffffffffc0208f14:	6402                	ld	s0,0(sp)
ffffffffc0208f16:	0141                	addi	sp,sp,16
ffffffffc0208f18:	8082                	ret
ffffffffc0208f1a:	00006617          	auipc	a2,0x6
ffffffffc0208f1e:	d3660613          	addi	a2,a2,-714 # ffffffffc020ec50 <dev_node_ops+0x230>
ffffffffc0208f22:	07500593          	li	a1,117
ffffffffc0208f26:	00006517          	auipc	a0,0x6
ffffffffc0208f2a:	d4a50513          	addi	a0,a0,-694 # ffffffffc020ec70 <dev_node_ops+0x250>
ffffffffc0208f2e:	d70f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f32:	86aa                	mv	a3,a0
ffffffffc0208f34:	00006617          	auipc	a2,0x6
ffffffffc0208f38:	d6460613          	addi	a2,a2,-668 # ffffffffc020ec98 <dev_node_ops+0x278>
ffffffffc0208f3c:	07b00593          	li	a1,123
ffffffffc0208f40:	00006517          	auipc	a0,0x6
ffffffffc0208f44:	d3050513          	addi	a0,a0,-720 # ffffffffc020ec70 <dev_node_ops+0x250>
ffffffffc0208f48:	d56f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f4c:	00005697          	auipc	a3,0x5
ffffffffc0208f50:	7ac68693          	addi	a3,a3,1964 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc0208f54:	00003617          	auipc	a2,0x3
ffffffffc0208f58:	c2460613          	addi	a2,a2,-988 # ffffffffc020bb78 <commands+0x210>
ffffffffc0208f5c:	07700593          	li	a1,119
ffffffffc0208f60:	00006517          	auipc	a0,0x6
ffffffffc0208f64:	d1050513          	addi	a0,a0,-752 # ffffffffc020ec70 <dev_node_ops+0x250>
ffffffffc0208f68:	d36f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208f6c <stdout_open>:
ffffffffc0208f6c:	4785                	li	a5,1
ffffffffc0208f6e:	4501                	li	a0,0
ffffffffc0208f70:	00f59363          	bne	a1,a5,ffffffffc0208f76 <stdout_open+0xa>
ffffffffc0208f74:	8082                	ret
ffffffffc0208f76:	5575                	li	a0,-3
ffffffffc0208f78:	8082                	ret

ffffffffc0208f7a <stdout_close>:
ffffffffc0208f7a:	4501                	li	a0,0
ffffffffc0208f7c:	8082                	ret

ffffffffc0208f7e <stdout_ioctl>:
ffffffffc0208f7e:	5575                	li	a0,-3
ffffffffc0208f80:	8082                	ret

ffffffffc0208f82 <stdout_io>:
ffffffffc0208f82:	ca05                	beqz	a2,ffffffffc0208fb2 <stdout_io+0x30>
ffffffffc0208f84:	6d9c                	ld	a5,24(a1)
ffffffffc0208f86:	1101                	addi	sp,sp,-32
ffffffffc0208f88:	e822                	sd	s0,16(sp)
ffffffffc0208f8a:	e426                	sd	s1,8(sp)
ffffffffc0208f8c:	ec06                	sd	ra,24(sp)
ffffffffc0208f8e:	6180                	ld	s0,0(a1)
ffffffffc0208f90:	84ae                	mv	s1,a1
ffffffffc0208f92:	cb91                	beqz	a5,ffffffffc0208fa6 <stdout_io+0x24>
ffffffffc0208f94:	00044503          	lbu	a0,0(s0)
ffffffffc0208f98:	0405                	addi	s0,s0,1
ffffffffc0208f9a:	a48f70ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0208f9e:	6c9c                	ld	a5,24(s1)
ffffffffc0208fa0:	17fd                	addi	a5,a5,-1
ffffffffc0208fa2:	ec9c                	sd	a5,24(s1)
ffffffffc0208fa4:	fbe5                	bnez	a5,ffffffffc0208f94 <stdout_io+0x12>
ffffffffc0208fa6:	60e2                	ld	ra,24(sp)
ffffffffc0208fa8:	6442                	ld	s0,16(sp)
ffffffffc0208faa:	64a2                	ld	s1,8(sp)
ffffffffc0208fac:	4501                	li	a0,0
ffffffffc0208fae:	6105                	addi	sp,sp,32
ffffffffc0208fb0:	8082                	ret
ffffffffc0208fb2:	5575                	li	a0,-3
ffffffffc0208fb4:	8082                	ret

ffffffffc0208fb6 <dev_init_stdout>:
ffffffffc0208fb6:	1141                	addi	sp,sp,-16
ffffffffc0208fb8:	e406                	sd	ra,8(sp)
ffffffffc0208fba:	9adff0ef          	jal	ra,ffffffffc0208966 <dev_create_inode>
ffffffffc0208fbe:	c939                	beqz	a0,ffffffffc0209014 <dev_init_stdout+0x5e>
ffffffffc0208fc0:	4d38                	lw	a4,88(a0)
ffffffffc0208fc2:	6785                	lui	a5,0x1
ffffffffc0208fc4:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208fc8:	85aa                	mv	a1,a0
ffffffffc0208fca:	06f71e63          	bne	a4,a5,ffffffffc0209046 <dev_init_stdout+0x90>
ffffffffc0208fce:	4785                	li	a5,1
ffffffffc0208fd0:	e51c                	sd	a5,8(a0)
ffffffffc0208fd2:	00000797          	auipc	a5,0x0
ffffffffc0208fd6:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208f6c <stdout_open>
ffffffffc0208fda:	e91c                	sd	a5,16(a0)
ffffffffc0208fdc:	00000797          	auipc	a5,0x0
ffffffffc0208fe0:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208f7a <stdout_close>
ffffffffc0208fe4:	ed1c                	sd	a5,24(a0)
ffffffffc0208fe6:	00000797          	auipc	a5,0x0
ffffffffc0208fea:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208f82 <stdout_io>
ffffffffc0208fee:	f11c                	sd	a5,32(a0)
ffffffffc0208ff0:	00000797          	auipc	a5,0x0
ffffffffc0208ff4:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208f7e <stdout_ioctl>
ffffffffc0208ff8:	00053023          	sd	zero,0(a0)
ffffffffc0208ffc:	f51c                	sd	a5,40(a0)
ffffffffc0208ffe:	4601                	li	a2,0
ffffffffc0209000:	00006517          	auipc	a0,0x6
ffffffffc0209004:	cf850513          	addi	a0,a0,-776 # ffffffffc020ecf8 <dev_node_ops+0x2d8>
ffffffffc0209008:	81aff0ef          	jal	ra,ffffffffc0208022 <vfs_add_dev>
ffffffffc020900c:	e105                	bnez	a0,ffffffffc020902c <dev_init_stdout+0x76>
ffffffffc020900e:	60a2                	ld	ra,8(sp)
ffffffffc0209010:	0141                	addi	sp,sp,16
ffffffffc0209012:	8082                	ret
ffffffffc0209014:	00006617          	auipc	a2,0x6
ffffffffc0209018:	ca460613          	addi	a2,a2,-860 # ffffffffc020ecb8 <dev_node_ops+0x298>
ffffffffc020901c:	03700593          	li	a1,55
ffffffffc0209020:	00006517          	auipc	a0,0x6
ffffffffc0209024:	cb850513          	addi	a0,a0,-840 # ffffffffc020ecd8 <dev_node_ops+0x2b8>
ffffffffc0209028:	c76f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020902c:	86aa                	mv	a3,a0
ffffffffc020902e:	00006617          	auipc	a2,0x6
ffffffffc0209032:	cd260613          	addi	a2,a2,-814 # ffffffffc020ed00 <dev_node_ops+0x2e0>
ffffffffc0209036:	03d00593          	li	a1,61
ffffffffc020903a:	00006517          	auipc	a0,0x6
ffffffffc020903e:	c9e50513          	addi	a0,a0,-866 # ffffffffc020ecd8 <dev_node_ops+0x2b8>
ffffffffc0209042:	c5cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209046:	00005697          	auipc	a3,0x5
ffffffffc020904a:	6b268693          	addi	a3,a3,1714 # ffffffffc020e6f8 <syscalls+0xb10>
ffffffffc020904e:	00003617          	auipc	a2,0x3
ffffffffc0209052:	b2a60613          	addi	a2,a2,-1238 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209056:	03900593          	li	a1,57
ffffffffc020905a:	00006517          	auipc	a0,0x6
ffffffffc020905e:	c7e50513          	addi	a0,a0,-898 # ffffffffc020ecd8 <dev_node_ops+0x2b8>
ffffffffc0209062:	c3cf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209066 <bitmap_translate.part.0>:
ffffffffc0209066:	1141                	addi	sp,sp,-16
ffffffffc0209068:	00006697          	auipc	a3,0x6
ffffffffc020906c:	cb868693          	addi	a3,a3,-840 # ffffffffc020ed20 <dev_node_ops+0x300>
ffffffffc0209070:	00003617          	auipc	a2,0x3
ffffffffc0209074:	b0860613          	addi	a2,a2,-1272 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209078:	04c00593          	li	a1,76
ffffffffc020907c:	00006517          	auipc	a0,0x6
ffffffffc0209080:	cbc50513          	addi	a0,a0,-836 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209084:	e406                	sd	ra,8(sp)
ffffffffc0209086:	c18f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020908a <bitmap_create>:
ffffffffc020908a:	7139                	addi	sp,sp,-64
ffffffffc020908c:	fc06                	sd	ra,56(sp)
ffffffffc020908e:	f822                	sd	s0,48(sp)
ffffffffc0209090:	f426                	sd	s1,40(sp)
ffffffffc0209092:	f04a                	sd	s2,32(sp)
ffffffffc0209094:	ec4e                	sd	s3,24(sp)
ffffffffc0209096:	e852                	sd	s4,16(sp)
ffffffffc0209098:	e456                	sd	s5,8(sp)
ffffffffc020909a:	c14d                	beqz	a0,ffffffffc020913c <bitmap_create+0xb2>
ffffffffc020909c:	842a                	mv	s0,a0
ffffffffc020909e:	4541                	li	a0,16
ffffffffc02090a0:	f77f80ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02090a4:	84aa                	mv	s1,a0
ffffffffc02090a6:	cd25                	beqz	a0,ffffffffc020911e <bitmap_create+0x94>
ffffffffc02090a8:	02041a13          	slli	s4,s0,0x20
ffffffffc02090ac:	020a5a13          	srli	s4,s4,0x20
ffffffffc02090b0:	01fa0793          	addi	a5,s4,31
ffffffffc02090b4:	0057d993          	srli	s3,a5,0x5
ffffffffc02090b8:	00299a93          	slli	s5,s3,0x2
ffffffffc02090bc:	8556                	mv	a0,s5
ffffffffc02090be:	894e                	mv	s2,s3
ffffffffc02090c0:	f57f80ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc02090c4:	c53d                	beqz	a0,ffffffffc0209132 <bitmap_create+0xa8>
ffffffffc02090c6:	0134a223          	sw	s3,4(s1) # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc02090ca:	c080                	sw	s0,0(s1)
ffffffffc02090cc:	8656                	mv	a2,s5
ffffffffc02090ce:	0ff00593          	li	a1,255
ffffffffc02090d2:	5c2020ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc02090d6:	e488                	sd	a0,8(s1)
ffffffffc02090d8:	0996                	slli	s3,s3,0x5
ffffffffc02090da:	053a0263          	beq	s4,s3,ffffffffc020911e <bitmap_create+0x94>
ffffffffc02090de:	fff9079b          	addiw	a5,s2,-1
ffffffffc02090e2:	0057969b          	slliw	a3,a5,0x5
ffffffffc02090e6:	0054561b          	srliw	a2,s0,0x5
ffffffffc02090ea:	40d4073b          	subw	a4,s0,a3
ffffffffc02090ee:	0054541b          	srliw	s0,s0,0x5
ffffffffc02090f2:	08f61463          	bne	a2,a5,ffffffffc020917a <bitmap_create+0xf0>
ffffffffc02090f6:	fff7069b          	addiw	a3,a4,-1
ffffffffc02090fa:	47f9                	li	a5,30
ffffffffc02090fc:	04d7ef63          	bltu	a5,a3,ffffffffc020915a <bitmap_create+0xd0>
ffffffffc0209100:	1402                	slli	s0,s0,0x20
ffffffffc0209102:	8079                	srli	s0,s0,0x1e
ffffffffc0209104:	9522                	add	a0,a0,s0
ffffffffc0209106:	411c                	lw	a5,0(a0)
ffffffffc0209108:	4585                	li	a1,1
ffffffffc020910a:	02000613          	li	a2,32
ffffffffc020910e:	00e596bb          	sllw	a3,a1,a4
ffffffffc0209112:	8fb5                	xor	a5,a5,a3
ffffffffc0209114:	2705                	addiw	a4,a4,1
ffffffffc0209116:	2781                	sext.w	a5,a5
ffffffffc0209118:	fec71be3          	bne	a4,a2,ffffffffc020910e <bitmap_create+0x84>
ffffffffc020911c:	c11c                	sw	a5,0(a0)
ffffffffc020911e:	70e2                	ld	ra,56(sp)
ffffffffc0209120:	7442                	ld	s0,48(sp)
ffffffffc0209122:	7902                	ld	s2,32(sp)
ffffffffc0209124:	69e2                	ld	s3,24(sp)
ffffffffc0209126:	6a42                	ld	s4,16(sp)
ffffffffc0209128:	6aa2                	ld	s5,8(sp)
ffffffffc020912a:	8526                	mv	a0,s1
ffffffffc020912c:	74a2                	ld	s1,40(sp)
ffffffffc020912e:	6121                	addi	sp,sp,64
ffffffffc0209130:	8082                	ret
ffffffffc0209132:	8526                	mv	a0,s1
ffffffffc0209134:	f93f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0209138:	4481                	li	s1,0
ffffffffc020913a:	b7d5                	j	ffffffffc020911e <bitmap_create+0x94>
ffffffffc020913c:	00006697          	auipc	a3,0x6
ffffffffc0209140:	c1468693          	addi	a3,a3,-1004 # ffffffffc020ed50 <dev_node_ops+0x330>
ffffffffc0209144:	00003617          	auipc	a2,0x3
ffffffffc0209148:	a3460613          	addi	a2,a2,-1484 # ffffffffc020bb78 <commands+0x210>
ffffffffc020914c:	45d5                	li	a1,21
ffffffffc020914e:	00006517          	auipc	a0,0x6
ffffffffc0209152:	bea50513          	addi	a0,a0,-1046 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209156:	b48f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020915a:	00006697          	auipc	a3,0x6
ffffffffc020915e:	c3668693          	addi	a3,a3,-970 # ffffffffc020ed90 <dev_node_ops+0x370>
ffffffffc0209162:	00003617          	auipc	a2,0x3
ffffffffc0209166:	a1660613          	addi	a2,a2,-1514 # ffffffffc020bb78 <commands+0x210>
ffffffffc020916a:	02b00593          	li	a1,43
ffffffffc020916e:	00006517          	auipc	a0,0x6
ffffffffc0209172:	bca50513          	addi	a0,a0,-1078 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209176:	b28f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020917a:	00006697          	auipc	a3,0x6
ffffffffc020917e:	bfe68693          	addi	a3,a3,-1026 # ffffffffc020ed78 <dev_node_ops+0x358>
ffffffffc0209182:	00003617          	auipc	a2,0x3
ffffffffc0209186:	9f660613          	addi	a2,a2,-1546 # ffffffffc020bb78 <commands+0x210>
ffffffffc020918a:	02a00593          	li	a1,42
ffffffffc020918e:	00006517          	auipc	a0,0x6
ffffffffc0209192:	baa50513          	addi	a0,a0,-1110 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209196:	b08f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020919a <bitmap_alloc>:
ffffffffc020919a:	4150                	lw	a2,4(a0)
ffffffffc020919c:	651c                	ld	a5,8(a0)
ffffffffc020919e:	c231                	beqz	a2,ffffffffc02091e2 <bitmap_alloc+0x48>
ffffffffc02091a0:	4701                	li	a4,0
ffffffffc02091a2:	a029                	j	ffffffffc02091ac <bitmap_alloc+0x12>
ffffffffc02091a4:	2705                	addiw	a4,a4,1
ffffffffc02091a6:	0791                	addi	a5,a5,4
ffffffffc02091a8:	02e60d63          	beq	a2,a4,ffffffffc02091e2 <bitmap_alloc+0x48>
ffffffffc02091ac:	4394                	lw	a3,0(a5)
ffffffffc02091ae:	dafd                	beqz	a3,ffffffffc02091a4 <bitmap_alloc+0xa>
ffffffffc02091b0:	4501                	li	a0,0
ffffffffc02091b2:	4885                	li	a7,1
ffffffffc02091b4:	8e36                	mv	t3,a3
ffffffffc02091b6:	02000313          	li	t1,32
ffffffffc02091ba:	a021                	j	ffffffffc02091c2 <bitmap_alloc+0x28>
ffffffffc02091bc:	2505                	addiw	a0,a0,1
ffffffffc02091be:	02650463          	beq	a0,t1,ffffffffc02091e6 <bitmap_alloc+0x4c>
ffffffffc02091c2:	00a8983b          	sllw	a6,a7,a0
ffffffffc02091c6:	0106f633          	and	a2,a3,a6
ffffffffc02091ca:	2601                	sext.w	a2,a2
ffffffffc02091cc:	da65                	beqz	a2,ffffffffc02091bc <bitmap_alloc+0x22>
ffffffffc02091ce:	010e4833          	xor	a6,t3,a6
ffffffffc02091d2:	0057171b          	slliw	a4,a4,0x5
ffffffffc02091d6:	9f29                	addw	a4,a4,a0
ffffffffc02091d8:	0107a023          	sw	a6,0(a5)
ffffffffc02091dc:	c198                	sw	a4,0(a1)
ffffffffc02091de:	4501                	li	a0,0
ffffffffc02091e0:	8082                	ret
ffffffffc02091e2:	5571                	li	a0,-4
ffffffffc02091e4:	8082                	ret
ffffffffc02091e6:	1141                	addi	sp,sp,-16
ffffffffc02091e8:	00004697          	auipc	a3,0x4
ffffffffc02091ec:	a0868693          	addi	a3,a3,-1528 # ffffffffc020cbf0 <default_pmm_manager+0x598>
ffffffffc02091f0:	00003617          	auipc	a2,0x3
ffffffffc02091f4:	98860613          	addi	a2,a2,-1656 # ffffffffc020bb78 <commands+0x210>
ffffffffc02091f8:	04300593          	li	a1,67
ffffffffc02091fc:	00006517          	auipc	a0,0x6
ffffffffc0209200:	b3c50513          	addi	a0,a0,-1220 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209204:	e406                	sd	ra,8(sp)
ffffffffc0209206:	a98f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020920a <bitmap_test>:
ffffffffc020920a:	411c                	lw	a5,0(a0)
ffffffffc020920c:	00f5ff63          	bgeu	a1,a5,ffffffffc020922a <bitmap_test+0x20>
ffffffffc0209210:	651c                	ld	a5,8(a0)
ffffffffc0209212:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209216:	070a                	slli	a4,a4,0x2
ffffffffc0209218:	97ba                	add	a5,a5,a4
ffffffffc020921a:	4388                	lw	a0,0(a5)
ffffffffc020921c:	4785                	li	a5,1
ffffffffc020921e:	00b795bb          	sllw	a1,a5,a1
ffffffffc0209222:	8d6d                	and	a0,a0,a1
ffffffffc0209224:	1502                	slli	a0,a0,0x20
ffffffffc0209226:	9101                	srli	a0,a0,0x20
ffffffffc0209228:	8082                	ret
ffffffffc020922a:	1141                	addi	sp,sp,-16
ffffffffc020922c:	e406                	sd	ra,8(sp)
ffffffffc020922e:	e39ff0ef          	jal	ra,ffffffffc0209066 <bitmap_translate.part.0>

ffffffffc0209232 <bitmap_free>:
ffffffffc0209232:	411c                	lw	a5,0(a0)
ffffffffc0209234:	1141                	addi	sp,sp,-16
ffffffffc0209236:	e406                	sd	ra,8(sp)
ffffffffc0209238:	02f5f463          	bgeu	a1,a5,ffffffffc0209260 <bitmap_free+0x2e>
ffffffffc020923c:	651c                	ld	a5,8(a0)
ffffffffc020923e:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209242:	070a                	slli	a4,a4,0x2
ffffffffc0209244:	97ba                	add	a5,a5,a4
ffffffffc0209246:	4398                	lw	a4,0(a5)
ffffffffc0209248:	4685                	li	a3,1
ffffffffc020924a:	00b695bb          	sllw	a1,a3,a1
ffffffffc020924e:	00b776b3          	and	a3,a4,a1
ffffffffc0209252:	2681                	sext.w	a3,a3
ffffffffc0209254:	ea81                	bnez	a3,ffffffffc0209264 <bitmap_free+0x32>
ffffffffc0209256:	60a2                	ld	ra,8(sp)
ffffffffc0209258:	8f4d                	or	a4,a4,a1
ffffffffc020925a:	c398                	sw	a4,0(a5)
ffffffffc020925c:	0141                	addi	sp,sp,16
ffffffffc020925e:	8082                	ret
ffffffffc0209260:	e07ff0ef          	jal	ra,ffffffffc0209066 <bitmap_translate.part.0>
ffffffffc0209264:	00006697          	auipc	a3,0x6
ffffffffc0209268:	b5468693          	addi	a3,a3,-1196 # ffffffffc020edb8 <dev_node_ops+0x398>
ffffffffc020926c:	00003617          	auipc	a2,0x3
ffffffffc0209270:	90c60613          	addi	a2,a2,-1780 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209274:	05f00593          	li	a1,95
ffffffffc0209278:	00006517          	auipc	a0,0x6
ffffffffc020927c:	ac050513          	addi	a0,a0,-1344 # ffffffffc020ed38 <dev_node_ops+0x318>
ffffffffc0209280:	a1ef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209284 <bitmap_destroy>:
ffffffffc0209284:	1141                	addi	sp,sp,-16
ffffffffc0209286:	e022                	sd	s0,0(sp)
ffffffffc0209288:	842a                	mv	s0,a0
ffffffffc020928a:	6508                	ld	a0,8(a0)
ffffffffc020928c:	e406                	sd	ra,8(sp)
ffffffffc020928e:	e39f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0209292:	8522                	mv	a0,s0
ffffffffc0209294:	6402                	ld	s0,0(sp)
ffffffffc0209296:	60a2                	ld	ra,8(sp)
ffffffffc0209298:	0141                	addi	sp,sp,16
ffffffffc020929a:	e2df806f          	j	ffffffffc02020c6 <kfree>

ffffffffc020929e <bitmap_getdata>:
ffffffffc020929e:	c589                	beqz	a1,ffffffffc02092a8 <bitmap_getdata+0xa>
ffffffffc02092a0:	00456783          	lwu	a5,4(a0)
ffffffffc02092a4:	078a                	slli	a5,a5,0x2
ffffffffc02092a6:	e19c                	sd	a5,0(a1)
ffffffffc02092a8:	6508                	ld	a0,8(a0)
ffffffffc02092aa:	8082                	ret

ffffffffc02092ac <sfs_init>:
ffffffffc02092ac:	1141                	addi	sp,sp,-16
ffffffffc02092ae:	00006517          	auipc	a0,0x6
ffffffffc02092b2:	97a50513          	addi	a0,a0,-1670 # ffffffffc020ec28 <dev_node_ops+0x208>
ffffffffc02092b6:	e406                	sd	ra,8(sp)
ffffffffc02092b8:	554000ef          	jal	ra,ffffffffc020980c <sfs_mount>
ffffffffc02092bc:	e501                	bnez	a0,ffffffffc02092c4 <sfs_init+0x18>
ffffffffc02092be:	60a2                	ld	ra,8(sp)
ffffffffc02092c0:	0141                	addi	sp,sp,16
ffffffffc02092c2:	8082                	ret
ffffffffc02092c4:	86aa                	mv	a3,a0
ffffffffc02092c6:	00006617          	auipc	a2,0x6
ffffffffc02092ca:	b0260613          	addi	a2,a2,-1278 # ffffffffc020edc8 <dev_node_ops+0x3a8>
ffffffffc02092ce:	45c1                	li	a1,16
ffffffffc02092d0:	00006517          	auipc	a0,0x6
ffffffffc02092d4:	b1850513          	addi	a0,a0,-1256 # ffffffffc020ede8 <dev_node_ops+0x3c8>
ffffffffc02092d8:	9c6f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02092dc <sfs_unmount>:
ffffffffc02092dc:	1141                	addi	sp,sp,-16
ffffffffc02092de:	e406                	sd	ra,8(sp)
ffffffffc02092e0:	e022                	sd	s0,0(sp)
ffffffffc02092e2:	cd1d                	beqz	a0,ffffffffc0209320 <sfs_unmount+0x44>
ffffffffc02092e4:	0b052783          	lw	a5,176(a0)
ffffffffc02092e8:	842a                	mv	s0,a0
ffffffffc02092ea:	eb9d                	bnez	a5,ffffffffc0209320 <sfs_unmount+0x44>
ffffffffc02092ec:	7158                	ld	a4,160(a0)
ffffffffc02092ee:	09850793          	addi	a5,a0,152
ffffffffc02092f2:	02f71563          	bne	a4,a5,ffffffffc020931c <sfs_unmount+0x40>
ffffffffc02092f6:	613c                	ld	a5,64(a0)
ffffffffc02092f8:	e7a1                	bnez	a5,ffffffffc0209340 <sfs_unmount+0x64>
ffffffffc02092fa:	7d08                	ld	a0,56(a0)
ffffffffc02092fc:	f89ff0ef          	jal	ra,ffffffffc0209284 <bitmap_destroy>
ffffffffc0209300:	6428                	ld	a0,72(s0)
ffffffffc0209302:	dc5f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0209306:	7448                	ld	a0,168(s0)
ffffffffc0209308:	dbff80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020930c:	8522                	mv	a0,s0
ffffffffc020930e:	db9f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0209312:	4501                	li	a0,0
ffffffffc0209314:	60a2                	ld	ra,8(sp)
ffffffffc0209316:	6402                	ld	s0,0(sp)
ffffffffc0209318:	0141                	addi	sp,sp,16
ffffffffc020931a:	8082                	ret
ffffffffc020931c:	5545                	li	a0,-15
ffffffffc020931e:	bfdd                	j	ffffffffc0209314 <sfs_unmount+0x38>
ffffffffc0209320:	00006697          	auipc	a3,0x6
ffffffffc0209324:	ae068693          	addi	a3,a3,-1312 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc0209328:	00003617          	auipc	a2,0x3
ffffffffc020932c:	85060613          	addi	a2,a2,-1968 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209330:	04100593          	li	a1,65
ffffffffc0209334:	00006517          	auipc	a0,0x6
ffffffffc0209338:	afc50513          	addi	a0,a0,-1284 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc020933c:	962f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209340:	00006697          	auipc	a3,0x6
ffffffffc0209344:	b0868693          	addi	a3,a3,-1272 # ffffffffc020ee48 <dev_node_ops+0x428>
ffffffffc0209348:	00003617          	auipc	a2,0x3
ffffffffc020934c:	83060613          	addi	a2,a2,-2000 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209350:	04500593          	li	a1,69
ffffffffc0209354:	00006517          	auipc	a0,0x6
ffffffffc0209358:	adc50513          	addi	a0,a0,-1316 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc020935c:	942f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209360 <sfs_cleanup>:
ffffffffc0209360:	1101                	addi	sp,sp,-32
ffffffffc0209362:	ec06                	sd	ra,24(sp)
ffffffffc0209364:	e822                	sd	s0,16(sp)
ffffffffc0209366:	e426                	sd	s1,8(sp)
ffffffffc0209368:	e04a                	sd	s2,0(sp)
ffffffffc020936a:	c525                	beqz	a0,ffffffffc02093d2 <sfs_cleanup+0x72>
ffffffffc020936c:	0b052783          	lw	a5,176(a0)
ffffffffc0209370:	84aa                	mv	s1,a0
ffffffffc0209372:	e3a5                	bnez	a5,ffffffffc02093d2 <sfs_cleanup+0x72>
ffffffffc0209374:	4158                	lw	a4,4(a0)
ffffffffc0209376:	4514                	lw	a3,8(a0)
ffffffffc0209378:	00c50913          	addi	s2,a0,12
ffffffffc020937c:	85ca                	mv	a1,s2
ffffffffc020937e:	40d7063b          	subw	a2,a4,a3
ffffffffc0209382:	00006517          	auipc	a0,0x6
ffffffffc0209386:	ade50513          	addi	a0,a0,-1314 # ffffffffc020ee60 <dev_node_ops+0x440>
ffffffffc020938a:	e1df60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020938e:	02000413          	li	s0,32
ffffffffc0209392:	a019                	j	ffffffffc0209398 <sfs_cleanup+0x38>
ffffffffc0209394:	347d                	addiw	s0,s0,-1
ffffffffc0209396:	c819                	beqz	s0,ffffffffc02093ac <sfs_cleanup+0x4c>
ffffffffc0209398:	7cdc                	ld	a5,184(s1)
ffffffffc020939a:	8526                	mv	a0,s1
ffffffffc020939c:	9782                	jalr	a5
ffffffffc020939e:	f97d                	bnez	a0,ffffffffc0209394 <sfs_cleanup+0x34>
ffffffffc02093a0:	60e2                	ld	ra,24(sp)
ffffffffc02093a2:	6442                	ld	s0,16(sp)
ffffffffc02093a4:	64a2                	ld	s1,8(sp)
ffffffffc02093a6:	6902                	ld	s2,0(sp)
ffffffffc02093a8:	6105                	addi	sp,sp,32
ffffffffc02093aa:	8082                	ret
ffffffffc02093ac:	6442                	ld	s0,16(sp)
ffffffffc02093ae:	60e2                	ld	ra,24(sp)
ffffffffc02093b0:	64a2                	ld	s1,8(sp)
ffffffffc02093b2:	86ca                	mv	a3,s2
ffffffffc02093b4:	6902                	ld	s2,0(sp)
ffffffffc02093b6:	872a                	mv	a4,a0
ffffffffc02093b8:	00006617          	auipc	a2,0x6
ffffffffc02093bc:	ac860613          	addi	a2,a2,-1336 # ffffffffc020ee80 <dev_node_ops+0x460>
ffffffffc02093c0:	05f00593          	li	a1,95
ffffffffc02093c4:	00006517          	auipc	a0,0x6
ffffffffc02093c8:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02093cc:	6105                	addi	sp,sp,32
ffffffffc02093ce:	938f706f          	j	ffffffffc0200506 <__warn>
ffffffffc02093d2:	00006697          	auipc	a3,0x6
ffffffffc02093d6:	a2e68693          	addi	a3,a3,-1490 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc02093da:	00002617          	auipc	a2,0x2
ffffffffc02093de:	79e60613          	addi	a2,a2,1950 # ffffffffc020bb78 <commands+0x210>
ffffffffc02093e2:	05400593          	li	a1,84
ffffffffc02093e6:	00006517          	auipc	a0,0x6
ffffffffc02093ea:	a4a50513          	addi	a0,a0,-1462 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02093ee:	8b0f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02093f2 <sfs_sync>:
ffffffffc02093f2:	7179                	addi	sp,sp,-48
ffffffffc02093f4:	f406                	sd	ra,40(sp)
ffffffffc02093f6:	f022                	sd	s0,32(sp)
ffffffffc02093f8:	ec26                	sd	s1,24(sp)
ffffffffc02093fa:	e84a                	sd	s2,16(sp)
ffffffffc02093fc:	e44e                	sd	s3,8(sp)
ffffffffc02093fe:	e052                	sd	s4,0(sp)
ffffffffc0209400:	cd4d                	beqz	a0,ffffffffc02094ba <sfs_sync+0xc8>
ffffffffc0209402:	0b052783          	lw	a5,176(a0)
ffffffffc0209406:	8a2a                	mv	s4,a0
ffffffffc0209408:	ebcd                	bnez	a5,ffffffffc02094ba <sfs_sync+0xc8>
ffffffffc020940a:	537010ef          	jal	ra,ffffffffc020b140 <lock_sfs_fs>
ffffffffc020940e:	0a0a3403          	ld	s0,160(s4)
ffffffffc0209412:	098a0913          	addi	s2,s4,152
ffffffffc0209416:	02890763          	beq	s2,s0,ffffffffc0209444 <sfs_sync+0x52>
ffffffffc020941a:	00004997          	auipc	s3,0x4
ffffffffc020941e:	0de98993          	addi	s3,s3,222 # ffffffffc020d4f8 <default_pmm_manager+0xea0>
ffffffffc0209422:	7c1c                	ld	a5,56(s0)
ffffffffc0209424:	fc840493          	addi	s1,s0,-56
ffffffffc0209428:	cbb5                	beqz	a5,ffffffffc020949c <sfs_sync+0xaa>
ffffffffc020942a:	7b9c                	ld	a5,48(a5)
ffffffffc020942c:	cba5                	beqz	a5,ffffffffc020949c <sfs_sync+0xaa>
ffffffffc020942e:	85ce                	mv	a1,s3
ffffffffc0209430:	8526                	mv	a0,s1
ffffffffc0209432:	e28fe0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209436:	7c1c                	ld	a5,56(s0)
ffffffffc0209438:	8526                	mv	a0,s1
ffffffffc020943a:	7b9c                	ld	a5,48(a5)
ffffffffc020943c:	9782                	jalr	a5
ffffffffc020943e:	6400                	ld	s0,8(s0)
ffffffffc0209440:	fe8911e3          	bne	s2,s0,ffffffffc0209422 <sfs_sync+0x30>
ffffffffc0209444:	8552                	mv	a0,s4
ffffffffc0209446:	50b010ef          	jal	ra,ffffffffc020b150 <unlock_sfs_fs>
ffffffffc020944a:	040a3783          	ld	a5,64(s4)
ffffffffc020944e:	4501                	li	a0,0
ffffffffc0209450:	eb89                	bnez	a5,ffffffffc0209462 <sfs_sync+0x70>
ffffffffc0209452:	70a2                	ld	ra,40(sp)
ffffffffc0209454:	7402                	ld	s0,32(sp)
ffffffffc0209456:	64e2                	ld	s1,24(sp)
ffffffffc0209458:	6942                	ld	s2,16(sp)
ffffffffc020945a:	69a2                	ld	s3,8(sp)
ffffffffc020945c:	6a02                	ld	s4,0(sp)
ffffffffc020945e:	6145                	addi	sp,sp,48
ffffffffc0209460:	8082                	ret
ffffffffc0209462:	040a3023          	sd	zero,64(s4)
ffffffffc0209466:	8552                	mv	a0,s4
ffffffffc0209468:	3bd010ef          	jal	ra,ffffffffc020b024 <sfs_sync_super>
ffffffffc020946c:	cd01                	beqz	a0,ffffffffc0209484 <sfs_sync+0x92>
ffffffffc020946e:	70a2                	ld	ra,40(sp)
ffffffffc0209470:	7402                	ld	s0,32(sp)
ffffffffc0209472:	4785                	li	a5,1
ffffffffc0209474:	04fa3023          	sd	a5,64(s4)
ffffffffc0209478:	64e2                	ld	s1,24(sp)
ffffffffc020947a:	6942                	ld	s2,16(sp)
ffffffffc020947c:	69a2                	ld	s3,8(sp)
ffffffffc020947e:	6a02                	ld	s4,0(sp)
ffffffffc0209480:	6145                	addi	sp,sp,48
ffffffffc0209482:	8082                	ret
ffffffffc0209484:	8552                	mv	a0,s4
ffffffffc0209486:	3e5010ef          	jal	ra,ffffffffc020b06a <sfs_sync_freemap>
ffffffffc020948a:	f175                	bnez	a0,ffffffffc020946e <sfs_sync+0x7c>
ffffffffc020948c:	70a2                	ld	ra,40(sp)
ffffffffc020948e:	7402                	ld	s0,32(sp)
ffffffffc0209490:	64e2                	ld	s1,24(sp)
ffffffffc0209492:	6942                	ld	s2,16(sp)
ffffffffc0209494:	69a2                	ld	s3,8(sp)
ffffffffc0209496:	6a02                	ld	s4,0(sp)
ffffffffc0209498:	6145                	addi	sp,sp,48
ffffffffc020949a:	8082                	ret
ffffffffc020949c:	00004697          	auipc	a3,0x4
ffffffffc02094a0:	00c68693          	addi	a3,a3,12 # ffffffffc020d4a8 <default_pmm_manager+0xe50>
ffffffffc02094a4:	00002617          	auipc	a2,0x2
ffffffffc02094a8:	6d460613          	addi	a2,a2,1748 # ffffffffc020bb78 <commands+0x210>
ffffffffc02094ac:	45ed                	li	a1,27
ffffffffc02094ae:	00006517          	auipc	a0,0x6
ffffffffc02094b2:	98250513          	addi	a0,a0,-1662 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02094b6:	fe9f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02094ba:	00006697          	auipc	a3,0x6
ffffffffc02094be:	94668693          	addi	a3,a3,-1722 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc02094c2:	00002617          	auipc	a2,0x2
ffffffffc02094c6:	6b660613          	addi	a2,a2,1718 # ffffffffc020bb78 <commands+0x210>
ffffffffc02094ca:	45d5                	li	a1,21
ffffffffc02094cc:	00006517          	auipc	a0,0x6
ffffffffc02094d0:	96450513          	addi	a0,a0,-1692 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02094d4:	fcbf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02094d8 <sfs_get_root>:
ffffffffc02094d8:	1101                	addi	sp,sp,-32
ffffffffc02094da:	ec06                	sd	ra,24(sp)
ffffffffc02094dc:	cd09                	beqz	a0,ffffffffc02094f6 <sfs_get_root+0x1e>
ffffffffc02094de:	0b052783          	lw	a5,176(a0)
ffffffffc02094e2:	eb91                	bnez	a5,ffffffffc02094f6 <sfs_get_root+0x1e>
ffffffffc02094e4:	4605                	li	a2,1
ffffffffc02094e6:	002c                	addi	a1,sp,8
ffffffffc02094e8:	36e010ef          	jal	ra,ffffffffc020a856 <sfs_load_inode>
ffffffffc02094ec:	e50d                	bnez	a0,ffffffffc0209516 <sfs_get_root+0x3e>
ffffffffc02094ee:	60e2                	ld	ra,24(sp)
ffffffffc02094f0:	6522                	ld	a0,8(sp)
ffffffffc02094f2:	6105                	addi	sp,sp,32
ffffffffc02094f4:	8082                	ret
ffffffffc02094f6:	00006697          	auipc	a3,0x6
ffffffffc02094fa:	90a68693          	addi	a3,a3,-1782 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc02094fe:	00002617          	auipc	a2,0x2
ffffffffc0209502:	67a60613          	addi	a2,a2,1658 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209506:	03600593          	li	a1,54
ffffffffc020950a:	00006517          	auipc	a0,0x6
ffffffffc020950e:	92650513          	addi	a0,a0,-1754 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc0209512:	f8df60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209516:	86aa                	mv	a3,a0
ffffffffc0209518:	00006617          	auipc	a2,0x6
ffffffffc020951c:	98860613          	addi	a2,a2,-1656 # ffffffffc020eea0 <dev_node_ops+0x480>
ffffffffc0209520:	03700593          	li	a1,55
ffffffffc0209524:	00006517          	auipc	a0,0x6
ffffffffc0209528:	90c50513          	addi	a0,a0,-1780 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc020952c:	f73f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209530 <sfs_do_mount>:
ffffffffc0209530:	6518                	ld	a4,8(a0)
ffffffffc0209532:	7171                	addi	sp,sp,-176
ffffffffc0209534:	f506                	sd	ra,168(sp)
ffffffffc0209536:	f122                	sd	s0,160(sp)
ffffffffc0209538:	ed26                	sd	s1,152(sp)
ffffffffc020953a:	e94a                	sd	s2,144(sp)
ffffffffc020953c:	e54e                	sd	s3,136(sp)
ffffffffc020953e:	e152                	sd	s4,128(sp)
ffffffffc0209540:	fcd6                	sd	s5,120(sp)
ffffffffc0209542:	f8da                	sd	s6,112(sp)
ffffffffc0209544:	f4de                	sd	s7,104(sp)
ffffffffc0209546:	f0e2                	sd	s8,96(sp)
ffffffffc0209548:	ece6                	sd	s9,88(sp)
ffffffffc020954a:	e8ea                	sd	s10,80(sp)
ffffffffc020954c:	e4ee                	sd	s11,72(sp)
ffffffffc020954e:	6785                	lui	a5,0x1
ffffffffc0209550:	24f71663          	bne	a4,a5,ffffffffc020979c <sfs_do_mount+0x26c>
ffffffffc0209554:	892a                	mv	s2,a0
ffffffffc0209556:	4501                	li	a0,0
ffffffffc0209558:	8aae                	mv	s5,a1
ffffffffc020955a:	f00fe0ef          	jal	ra,ffffffffc0207c5a <__alloc_fs>
ffffffffc020955e:	842a                	mv	s0,a0
ffffffffc0209560:	24050463          	beqz	a0,ffffffffc02097a8 <sfs_do_mount+0x278>
ffffffffc0209564:	0b052b03          	lw	s6,176(a0)
ffffffffc0209568:	260b1263          	bnez	s6,ffffffffc02097cc <sfs_do_mount+0x29c>
ffffffffc020956c:	03253823          	sd	s2,48(a0)
ffffffffc0209570:	6505                	lui	a0,0x1
ffffffffc0209572:	aa5f80ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0209576:	e428                	sd	a0,72(s0)
ffffffffc0209578:	84aa                	mv	s1,a0
ffffffffc020957a:	16050363          	beqz	a0,ffffffffc02096e0 <sfs_do_mount+0x1b0>
ffffffffc020957e:	85aa                	mv	a1,a0
ffffffffc0209580:	4681                	li	a3,0
ffffffffc0209582:	6605                	lui	a2,0x1
ffffffffc0209584:	1008                	addi	a0,sp,32
ffffffffc0209586:	f5dfb0ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc020958a:	02093783          	ld	a5,32(s2)
ffffffffc020958e:	85aa                	mv	a1,a0
ffffffffc0209590:	4601                	li	a2,0
ffffffffc0209592:	854a                	mv	a0,s2
ffffffffc0209594:	9782                	jalr	a5
ffffffffc0209596:	8a2a                	mv	s4,a0
ffffffffc0209598:	10051e63          	bnez	a0,ffffffffc02096b4 <sfs_do_mount+0x184>
ffffffffc020959c:	408c                	lw	a1,0(s1)
ffffffffc020959e:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc02095a2:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02095a6:	14c59863          	bne	a1,a2,ffffffffc02096f6 <sfs_do_mount+0x1c6>
ffffffffc02095aa:	40dc                	lw	a5,4(s1)
ffffffffc02095ac:	00093603          	ld	a2,0(s2)
ffffffffc02095b0:	02079713          	slli	a4,a5,0x20
ffffffffc02095b4:	9301                	srli	a4,a4,0x20
ffffffffc02095b6:	12e66763          	bltu	a2,a4,ffffffffc02096e4 <sfs_do_mount+0x1b4>
ffffffffc02095ba:	020485a3          	sb	zero,43(s1)
ffffffffc02095be:	0084af03          	lw	t5,8(s1)
ffffffffc02095c2:	00c4ae83          	lw	t4,12(s1)
ffffffffc02095c6:	0104ae03          	lw	t3,16(s1)
ffffffffc02095ca:	0144a303          	lw	t1,20(s1)
ffffffffc02095ce:	0184a883          	lw	a7,24(s1)
ffffffffc02095d2:	01c4a803          	lw	a6,28(s1)
ffffffffc02095d6:	5090                	lw	a2,32(s1)
ffffffffc02095d8:	50d4                	lw	a3,36(s1)
ffffffffc02095da:	5498                	lw	a4,40(s1)
ffffffffc02095dc:	6511                	lui	a0,0x4
ffffffffc02095de:	c00c                	sw	a1,0(s0)
ffffffffc02095e0:	c05c                	sw	a5,4(s0)
ffffffffc02095e2:	01e42423          	sw	t5,8(s0)
ffffffffc02095e6:	01d42623          	sw	t4,12(s0)
ffffffffc02095ea:	01c42823          	sw	t3,16(s0)
ffffffffc02095ee:	00642a23          	sw	t1,20(s0)
ffffffffc02095f2:	01142c23          	sw	a7,24(s0)
ffffffffc02095f6:	01042e23          	sw	a6,28(s0)
ffffffffc02095fa:	d010                	sw	a2,32(s0)
ffffffffc02095fc:	d054                	sw	a3,36(s0)
ffffffffc02095fe:	d418                	sw	a4,40(s0)
ffffffffc0209600:	a17f80ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc0209604:	f448                	sd	a0,168(s0)
ffffffffc0209606:	8c2a                	mv	s8,a0
ffffffffc0209608:	18050c63          	beqz	a0,ffffffffc02097a0 <sfs_do_mount+0x270>
ffffffffc020960c:	6711                	lui	a4,0x4
ffffffffc020960e:	87aa                	mv	a5,a0
ffffffffc0209610:	972a                	add	a4,a4,a0
ffffffffc0209612:	e79c                	sd	a5,8(a5)
ffffffffc0209614:	e39c                	sd	a5,0(a5)
ffffffffc0209616:	07c1                	addi	a5,a5,16
ffffffffc0209618:	fee79de3          	bne	a5,a4,ffffffffc0209612 <sfs_do_mount+0xe2>
ffffffffc020961c:	0044eb83          	lwu	s7,4(s1)
ffffffffc0209620:	67a1                	lui	a5,0x8
ffffffffc0209622:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209626:	9bce                	add	s7,s7,s3
ffffffffc0209628:	77e1                	lui	a5,0xffff8
ffffffffc020962a:	00fbfbb3          	and	s7,s7,a5
ffffffffc020962e:	2b81                	sext.w	s7,s7
ffffffffc0209630:	855e                	mv	a0,s7
ffffffffc0209632:	a59ff0ef          	jal	ra,ffffffffc020908a <bitmap_create>
ffffffffc0209636:	fc08                	sd	a0,56(s0)
ffffffffc0209638:	8d2a                	mv	s10,a0
ffffffffc020963a:	14050f63          	beqz	a0,ffffffffc0209798 <sfs_do_mount+0x268>
ffffffffc020963e:	0044e783          	lwu	a5,4(s1)
ffffffffc0209642:	082c                	addi	a1,sp,24
ffffffffc0209644:	97ce                	add	a5,a5,s3
ffffffffc0209646:	00f7d713          	srli	a4,a5,0xf
ffffffffc020964a:	e43a                	sd	a4,8(sp)
ffffffffc020964c:	40f7d993          	srai	s3,a5,0xf
ffffffffc0209650:	c4fff0ef          	jal	ra,ffffffffc020929e <bitmap_getdata>
ffffffffc0209654:	14050c63          	beqz	a0,ffffffffc02097ac <sfs_do_mount+0x27c>
ffffffffc0209658:	00c9979b          	slliw	a5,s3,0xc
ffffffffc020965c:	66e2                	ld	a3,24(sp)
ffffffffc020965e:	1782                	slli	a5,a5,0x20
ffffffffc0209660:	9381                	srli	a5,a5,0x20
ffffffffc0209662:	14d79563          	bne	a5,a3,ffffffffc02097ac <sfs_do_mount+0x27c>
ffffffffc0209666:	6722                	ld	a4,8(sp)
ffffffffc0209668:	6d89                	lui	s11,0x2
ffffffffc020966a:	89aa                	mv	s3,a0
ffffffffc020966c:	00c71c93          	slli	s9,a4,0xc
ffffffffc0209670:	9caa                	add	s9,s9,a0
ffffffffc0209672:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0209676:	e711                	bnez	a4,ffffffffc0209682 <sfs_do_mount+0x152>
ffffffffc0209678:	a079                	j	ffffffffc0209706 <sfs_do_mount+0x1d6>
ffffffffc020967a:	6785                	lui	a5,0x1
ffffffffc020967c:	99be                	add	s3,s3,a5
ffffffffc020967e:	093c8463          	beq	s9,s3,ffffffffc0209706 <sfs_do_mount+0x1d6>
ffffffffc0209682:	013d86bb          	addw	a3,s11,s3
ffffffffc0209686:	1682                	slli	a3,a3,0x20
ffffffffc0209688:	6605                	lui	a2,0x1
ffffffffc020968a:	85ce                	mv	a1,s3
ffffffffc020968c:	9281                	srli	a3,a3,0x20
ffffffffc020968e:	1008                	addi	a0,sp,32
ffffffffc0209690:	e53fb0ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc0209694:	02093783          	ld	a5,32(s2)
ffffffffc0209698:	85aa                	mv	a1,a0
ffffffffc020969a:	4601                	li	a2,0
ffffffffc020969c:	854a                	mv	a0,s2
ffffffffc020969e:	9782                	jalr	a5
ffffffffc02096a0:	dd69                	beqz	a0,ffffffffc020967a <sfs_do_mount+0x14a>
ffffffffc02096a2:	e42a                	sd	a0,8(sp)
ffffffffc02096a4:	856a                	mv	a0,s10
ffffffffc02096a6:	bdfff0ef          	jal	ra,ffffffffc0209284 <bitmap_destroy>
ffffffffc02096aa:	67a2                	ld	a5,8(sp)
ffffffffc02096ac:	8a3e                	mv	s4,a5
ffffffffc02096ae:	8562                	mv	a0,s8
ffffffffc02096b0:	a17f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc02096b4:	8526                	mv	a0,s1
ffffffffc02096b6:	a11f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc02096ba:	8522                	mv	a0,s0
ffffffffc02096bc:	a0bf80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc02096c0:	70aa                	ld	ra,168(sp)
ffffffffc02096c2:	740a                	ld	s0,160(sp)
ffffffffc02096c4:	64ea                	ld	s1,152(sp)
ffffffffc02096c6:	694a                	ld	s2,144(sp)
ffffffffc02096c8:	69aa                	ld	s3,136(sp)
ffffffffc02096ca:	7ae6                	ld	s5,120(sp)
ffffffffc02096cc:	7b46                	ld	s6,112(sp)
ffffffffc02096ce:	7ba6                	ld	s7,104(sp)
ffffffffc02096d0:	7c06                	ld	s8,96(sp)
ffffffffc02096d2:	6ce6                	ld	s9,88(sp)
ffffffffc02096d4:	6d46                	ld	s10,80(sp)
ffffffffc02096d6:	6da6                	ld	s11,72(sp)
ffffffffc02096d8:	8552                	mv	a0,s4
ffffffffc02096da:	6a0a                	ld	s4,128(sp)
ffffffffc02096dc:	614d                	addi	sp,sp,176
ffffffffc02096de:	8082                	ret
ffffffffc02096e0:	5a71                	li	s4,-4
ffffffffc02096e2:	bfe1                	j	ffffffffc02096ba <sfs_do_mount+0x18a>
ffffffffc02096e4:	85be                	mv	a1,a5
ffffffffc02096e6:	00006517          	auipc	a0,0x6
ffffffffc02096ea:	81250513          	addi	a0,a0,-2030 # ffffffffc020eef8 <dev_node_ops+0x4d8>
ffffffffc02096ee:	ab9f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02096f2:	5a75                	li	s4,-3
ffffffffc02096f4:	b7c1                	j	ffffffffc02096b4 <sfs_do_mount+0x184>
ffffffffc02096f6:	00005517          	auipc	a0,0x5
ffffffffc02096fa:	7ca50513          	addi	a0,a0,1994 # ffffffffc020eec0 <dev_node_ops+0x4a0>
ffffffffc02096fe:	aa9f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209702:	5a75                	li	s4,-3
ffffffffc0209704:	bf45                	j	ffffffffc02096b4 <sfs_do_mount+0x184>
ffffffffc0209706:	00442903          	lw	s2,4(s0)
ffffffffc020970a:	4481                	li	s1,0
ffffffffc020970c:	080b8c63          	beqz	s7,ffffffffc02097a4 <sfs_do_mount+0x274>
ffffffffc0209710:	85a6                	mv	a1,s1
ffffffffc0209712:	856a                	mv	a0,s10
ffffffffc0209714:	af7ff0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc0209718:	c111                	beqz	a0,ffffffffc020971c <sfs_do_mount+0x1ec>
ffffffffc020971a:	2b05                	addiw	s6,s6,1
ffffffffc020971c:	2485                	addiw	s1,s1,1
ffffffffc020971e:	fe9b99e3          	bne	s7,s1,ffffffffc0209710 <sfs_do_mount+0x1e0>
ffffffffc0209722:	441c                	lw	a5,8(s0)
ffffffffc0209724:	0d679463          	bne	a5,s6,ffffffffc02097ec <sfs_do_mount+0x2bc>
ffffffffc0209728:	4585                	li	a1,1
ffffffffc020972a:	05040513          	addi	a0,s0,80
ffffffffc020972e:	04043023          	sd	zero,64(s0)
ffffffffc0209732:	f29fa0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0209736:	4585                	li	a1,1
ffffffffc0209738:	06840513          	addi	a0,s0,104
ffffffffc020973c:	f1ffa0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc0209740:	4585                	li	a1,1
ffffffffc0209742:	08040513          	addi	a0,s0,128
ffffffffc0209746:	f15fa0ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc020974a:	09840793          	addi	a5,s0,152
ffffffffc020974e:	f05c                	sd	a5,160(s0)
ffffffffc0209750:	ec5c                	sd	a5,152(s0)
ffffffffc0209752:	874a                	mv	a4,s2
ffffffffc0209754:	86da                	mv	a3,s6
ffffffffc0209756:	4169063b          	subw	a2,s2,s6
ffffffffc020975a:	00c40593          	addi	a1,s0,12
ffffffffc020975e:	00006517          	auipc	a0,0x6
ffffffffc0209762:	82a50513          	addi	a0,a0,-2006 # ffffffffc020ef88 <dev_node_ops+0x568>
ffffffffc0209766:	a41f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020976a:	00000797          	auipc	a5,0x0
ffffffffc020976e:	c8878793          	addi	a5,a5,-888 # ffffffffc02093f2 <sfs_sync>
ffffffffc0209772:	fc5c                	sd	a5,184(s0)
ffffffffc0209774:	00000797          	auipc	a5,0x0
ffffffffc0209778:	d6478793          	addi	a5,a5,-668 # ffffffffc02094d8 <sfs_get_root>
ffffffffc020977c:	e07c                	sd	a5,192(s0)
ffffffffc020977e:	00000797          	auipc	a5,0x0
ffffffffc0209782:	b5e78793          	addi	a5,a5,-1186 # ffffffffc02092dc <sfs_unmount>
ffffffffc0209786:	e47c                	sd	a5,200(s0)
ffffffffc0209788:	00000797          	auipc	a5,0x0
ffffffffc020978c:	bd878793          	addi	a5,a5,-1064 # ffffffffc0209360 <sfs_cleanup>
ffffffffc0209790:	e87c                	sd	a5,208(s0)
ffffffffc0209792:	008ab023          	sd	s0,0(s5)
ffffffffc0209796:	b72d                	j	ffffffffc02096c0 <sfs_do_mount+0x190>
ffffffffc0209798:	5a71                	li	s4,-4
ffffffffc020979a:	bf11                	j	ffffffffc02096ae <sfs_do_mount+0x17e>
ffffffffc020979c:	5a49                	li	s4,-14
ffffffffc020979e:	b70d                	j	ffffffffc02096c0 <sfs_do_mount+0x190>
ffffffffc02097a0:	5a71                	li	s4,-4
ffffffffc02097a2:	bf09                	j	ffffffffc02096b4 <sfs_do_mount+0x184>
ffffffffc02097a4:	4b01                	li	s6,0
ffffffffc02097a6:	bfb5                	j	ffffffffc0209722 <sfs_do_mount+0x1f2>
ffffffffc02097a8:	5a71                	li	s4,-4
ffffffffc02097aa:	bf19                	j	ffffffffc02096c0 <sfs_do_mount+0x190>
ffffffffc02097ac:	00005697          	auipc	a3,0x5
ffffffffc02097b0:	77c68693          	addi	a3,a3,1916 # ffffffffc020ef28 <dev_node_ops+0x508>
ffffffffc02097b4:	00002617          	auipc	a2,0x2
ffffffffc02097b8:	3c460613          	addi	a2,a2,964 # ffffffffc020bb78 <commands+0x210>
ffffffffc02097bc:	08300593          	li	a1,131
ffffffffc02097c0:	00005517          	auipc	a0,0x5
ffffffffc02097c4:	67050513          	addi	a0,a0,1648 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02097c8:	cd7f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02097cc:	00005697          	auipc	a3,0x5
ffffffffc02097d0:	63468693          	addi	a3,a3,1588 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc02097d4:	00002617          	auipc	a2,0x2
ffffffffc02097d8:	3a460613          	addi	a2,a2,932 # ffffffffc020bb78 <commands+0x210>
ffffffffc02097dc:	0a300593          	li	a1,163
ffffffffc02097e0:	00005517          	auipc	a0,0x5
ffffffffc02097e4:	65050513          	addi	a0,a0,1616 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc02097e8:	cb7f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02097ec:	00005697          	auipc	a3,0x5
ffffffffc02097f0:	76c68693          	addi	a3,a3,1900 # ffffffffc020ef58 <dev_node_ops+0x538>
ffffffffc02097f4:	00002617          	auipc	a2,0x2
ffffffffc02097f8:	38460613          	addi	a2,a2,900 # ffffffffc020bb78 <commands+0x210>
ffffffffc02097fc:	0e000593          	li	a1,224
ffffffffc0209800:	00005517          	auipc	a0,0x5
ffffffffc0209804:	63050513          	addi	a0,a0,1584 # ffffffffc020ee30 <dev_node_ops+0x410>
ffffffffc0209808:	c97f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020980c <sfs_mount>:
ffffffffc020980c:	00000597          	auipc	a1,0x0
ffffffffc0209810:	d2458593          	addi	a1,a1,-732 # ffffffffc0209530 <sfs_do_mount>
ffffffffc0209814:	817fe06f          	j	ffffffffc020802a <vfs_mount>

ffffffffc0209818 <sfs_opendir>:
ffffffffc0209818:	0235f593          	andi	a1,a1,35
ffffffffc020981c:	4501                	li	a0,0
ffffffffc020981e:	e191                	bnez	a1,ffffffffc0209822 <sfs_opendir+0xa>
ffffffffc0209820:	8082                	ret
ffffffffc0209822:	553d                	li	a0,-17
ffffffffc0209824:	8082                	ret

ffffffffc0209826 <sfs_openfile>:
ffffffffc0209826:	4501                	li	a0,0
ffffffffc0209828:	8082                	ret

ffffffffc020982a <sfs_gettype>:
ffffffffc020982a:	1141                	addi	sp,sp,-16
ffffffffc020982c:	e406                	sd	ra,8(sp)
ffffffffc020982e:	c939                	beqz	a0,ffffffffc0209884 <sfs_gettype+0x5a>
ffffffffc0209830:	4d34                	lw	a3,88(a0)
ffffffffc0209832:	6785                	lui	a5,0x1
ffffffffc0209834:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209838:	04e69663          	bne	a3,a4,ffffffffc0209884 <sfs_gettype+0x5a>
ffffffffc020983c:	6114                	ld	a3,0(a0)
ffffffffc020983e:	4709                	li	a4,2
ffffffffc0209840:	0046d683          	lhu	a3,4(a3)
ffffffffc0209844:	02e68a63          	beq	a3,a4,ffffffffc0209878 <sfs_gettype+0x4e>
ffffffffc0209848:	470d                	li	a4,3
ffffffffc020984a:	02e68163          	beq	a3,a4,ffffffffc020986c <sfs_gettype+0x42>
ffffffffc020984e:	4705                	li	a4,1
ffffffffc0209850:	00e68f63          	beq	a3,a4,ffffffffc020986e <sfs_gettype+0x44>
ffffffffc0209854:	00005617          	auipc	a2,0x5
ffffffffc0209858:	7a460613          	addi	a2,a2,1956 # ffffffffc020eff8 <dev_node_ops+0x5d8>
ffffffffc020985c:	39000593          	li	a1,912
ffffffffc0209860:	00005517          	auipc	a0,0x5
ffffffffc0209864:	78050513          	addi	a0,a0,1920 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209868:	c37f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020986c:	678d                	lui	a5,0x3
ffffffffc020986e:	60a2                	ld	ra,8(sp)
ffffffffc0209870:	c19c                	sw	a5,0(a1)
ffffffffc0209872:	4501                	li	a0,0
ffffffffc0209874:	0141                	addi	sp,sp,16
ffffffffc0209876:	8082                	ret
ffffffffc0209878:	60a2                	ld	ra,8(sp)
ffffffffc020987a:	6789                	lui	a5,0x2
ffffffffc020987c:	c19c                	sw	a5,0(a1)
ffffffffc020987e:	4501                	li	a0,0
ffffffffc0209880:	0141                	addi	sp,sp,16
ffffffffc0209882:	8082                	ret
ffffffffc0209884:	00005697          	auipc	a3,0x5
ffffffffc0209888:	72468693          	addi	a3,a3,1828 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020988c:	00002617          	auipc	a2,0x2
ffffffffc0209890:	2ec60613          	addi	a2,a2,748 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209894:	38400593          	li	a1,900
ffffffffc0209898:	00005517          	auipc	a0,0x5
ffffffffc020989c:	74850513          	addi	a0,a0,1864 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc02098a0:	bfff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02098a4 <sfs_fsync>:
ffffffffc02098a4:	7179                	addi	sp,sp,-48
ffffffffc02098a6:	ec26                	sd	s1,24(sp)
ffffffffc02098a8:	7524                	ld	s1,104(a0)
ffffffffc02098aa:	f406                	sd	ra,40(sp)
ffffffffc02098ac:	f022                	sd	s0,32(sp)
ffffffffc02098ae:	e84a                	sd	s2,16(sp)
ffffffffc02098b0:	e44e                	sd	s3,8(sp)
ffffffffc02098b2:	c4bd                	beqz	s1,ffffffffc0209920 <sfs_fsync+0x7c>
ffffffffc02098b4:	0b04a783          	lw	a5,176(s1)
ffffffffc02098b8:	e7a5                	bnez	a5,ffffffffc0209920 <sfs_fsync+0x7c>
ffffffffc02098ba:	4d38                	lw	a4,88(a0)
ffffffffc02098bc:	6785                	lui	a5,0x1
ffffffffc02098be:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02098c2:	842a                	mv	s0,a0
ffffffffc02098c4:	06f71e63          	bne	a4,a5,ffffffffc0209940 <sfs_fsync+0x9c>
ffffffffc02098c8:	691c                	ld	a5,16(a0)
ffffffffc02098ca:	4901                	li	s2,0
ffffffffc02098cc:	eb89                	bnez	a5,ffffffffc02098de <sfs_fsync+0x3a>
ffffffffc02098ce:	70a2                	ld	ra,40(sp)
ffffffffc02098d0:	7402                	ld	s0,32(sp)
ffffffffc02098d2:	64e2                	ld	s1,24(sp)
ffffffffc02098d4:	69a2                	ld	s3,8(sp)
ffffffffc02098d6:	854a                	mv	a0,s2
ffffffffc02098d8:	6942                	ld	s2,16(sp)
ffffffffc02098da:	6145                	addi	sp,sp,48
ffffffffc02098dc:	8082                	ret
ffffffffc02098de:	02050993          	addi	s3,a0,32
ffffffffc02098e2:	854e                	mv	a0,s3
ffffffffc02098e4:	d81fa0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc02098e8:	681c                	ld	a5,16(s0)
ffffffffc02098ea:	ef81                	bnez	a5,ffffffffc0209902 <sfs_fsync+0x5e>
ffffffffc02098ec:	854e                	mv	a0,s3
ffffffffc02098ee:	d73fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc02098f2:	70a2                	ld	ra,40(sp)
ffffffffc02098f4:	7402                	ld	s0,32(sp)
ffffffffc02098f6:	64e2                	ld	s1,24(sp)
ffffffffc02098f8:	69a2                	ld	s3,8(sp)
ffffffffc02098fa:	854a                	mv	a0,s2
ffffffffc02098fc:	6942                	ld	s2,16(sp)
ffffffffc02098fe:	6145                	addi	sp,sp,48
ffffffffc0209900:	8082                	ret
ffffffffc0209902:	4414                	lw	a3,8(s0)
ffffffffc0209904:	600c                	ld	a1,0(s0)
ffffffffc0209906:	00043823          	sd	zero,16(s0)
ffffffffc020990a:	4701                	li	a4,0
ffffffffc020990c:	04000613          	li	a2,64
ffffffffc0209910:	8526                	mv	a0,s1
ffffffffc0209912:	67e010ef          	jal	ra,ffffffffc020af90 <sfs_wbuf>
ffffffffc0209916:	892a                	mv	s2,a0
ffffffffc0209918:	d971                	beqz	a0,ffffffffc02098ec <sfs_fsync+0x48>
ffffffffc020991a:	4785                	li	a5,1
ffffffffc020991c:	e81c                	sd	a5,16(s0)
ffffffffc020991e:	b7f9                	j	ffffffffc02098ec <sfs_fsync+0x48>
ffffffffc0209920:	00005697          	auipc	a3,0x5
ffffffffc0209924:	4e068693          	addi	a3,a3,1248 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc0209928:	00002617          	auipc	a2,0x2
ffffffffc020992c:	25060613          	addi	a2,a2,592 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209930:	2c800593          	li	a1,712
ffffffffc0209934:	00005517          	auipc	a0,0x5
ffffffffc0209938:	6ac50513          	addi	a0,a0,1708 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020993c:	b63f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209940:	00005697          	auipc	a3,0x5
ffffffffc0209944:	66868693          	addi	a3,a3,1640 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc0209948:	00002617          	auipc	a2,0x2
ffffffffc020994c:	23060613          	addi	a2,a2,560 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209950:	2c900593          	li	a1,713
ffffffffc0209954:	00005517          	auipc	a0,0x5
ffffffffc0209958:	68c50513          	addi	a0,a0,1676 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020995c:	b43f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209960 <sfs_fstat>:
ffffffffc0209960:	1101                	addi	sp,sp,-32
ffffffffc0209962:	e426                	sd	s1,8(sp)
ffffffffc0209964:	84ae                	mv	s1,a1
ffffffffc0209966:	e822                	sd	s0,16(sp)
ffffffffc0209968:	02000613          	li	a2,32
ffffffffc020996c:	842a                	mv	s0,a0
ffffffffc020996e:	4581                	li	a1,0
ffffffffc0209970:	8526                	mv	a0,s1
ffffffffc0209972:	ec06                	sd	ra,24(sp)
ffffffffc0209974:	521010ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc0209978:	c439                	beqz	s0,ffffffffc02099c6 <sfs_fstat+0x66>
ffffffffc020997a:	783c                	ld	a5,112(s0)
ffffffffc020997c:	c7a9                	beqz	a5,ffffffffc02099c6 <sfs_fstat+0x66>
ffffffffc020997e:	6bbc                	ld	a5,80(a5)
ffffffffc0209980:	c3b9                	beqz	a5,ffffffffc02099c6 <sfs_fstat+0x66>
ffffffffc0209982:	00005597          	auipc	a1,0x5
ffffffffc0209986:	01658593          	addi	a1,a1,22 # ffffffffc020e998 <syscalls+0xdb0>
ffffffffc020998a:	8522                	mv	a0,s0
ffffffffc020998c:	8cefe0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209990:	783c                	ld	a5,112(s0)
ffffffffc0209992:	85a6                	mv	a1,s1
ffffffffc0209994:	8522                	mv	a0,s0
ffffffffc0209996:	6bbc                	ld	a5,80(a5)
ffffffffc0209998:	9782                	jalr	a5
ffffffffc020999a:	e10d                	bnez	a0,ffffffffc02099bc <sfs_fstat+0x5c>
ffffffffc020999c:	4c38                	lw	a4,88(s0)
ffffffffc020999e:	6785                	lui	a5,0x1
ffffffffc02099a0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02099a4:	04f71163          	bne	a4,a5,ffffffffc02099e6 <sfs_fstat+0x86>
ffffffffc02099a8:	601c                	ld	a5,0(s0)
ffffffffc02099aa:	0067d683          	lhu	a3,6(a5)
ffffffffc02099ae:	0087e703          	lwu	a4,8(a5)
ffffffffc02099b2:	0007e783          	lwu	a5,0(a5)
ffffffffc02099b6:	e494                	sd	a3,8(s1)
ffffffffc02099b8:	e898                	sd	a4,16(s1)
ffffffffc02099ba:	ec9c                	sd	a5,24(s1)
ffffffffc02099bc:	60e2                	ld	ra,24(sp)
ffffffffc02099be:	6442                	ld	s0,16(sp)
ffffffffc02099c0:	64a2                	ld	s1,8(sp)
ffffffffc02099c2:	6105                	addi	sp,sp,32
ffffffffc02099c4:	8082                	ret
ffffffffc02099c6:	00005697          	auipc	a3,0x5
ffffffffc02099ca:	f6a68693          	addi	a3,a3,-150 # ffffffffc020e930 <syscalls+0xd48>
ffffffffc02099ce:	00002617          	auipc	a2,0x2
ffffffffc02099d2:	1aa60613          	addi	a2,a2,426 # ffffffffc020bb78 <commands+0x210>
ffffffffc02099d6:	2b900593          	li	a1,697
ffffffffc02099da:	00005517          	auipc	a0,0x5
ffffffffc02099de:	60650513          	addi	a0,a0,1542 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc02099e2:	abdf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02099e6:	00005697          	auipc	a3,0x5
ffffffffc02099ea:	5c268693          	addi	a3,a3,1474 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc02099ee:	00002617          	auipc	a2,0x2
ffffffffc02099f2:	18a60613          	addi	a2,a2,394 # ffffffffc020bb78 <commands+0x210>
ffffffffc02099f6:	2bc00593          	li	a1,700
ffffffffc02099fa:	00005517          	auipc	a0,0x5
ffffffffc02099fe:	5e650513          	addi	a0,a0,1510 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209a02:	a9df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209a06 <sfs_tryseek>:
ffffffffc0209a06:	080007b7          	lui	a5,0x8000
ffffffffc0209a0a:	04f5fd63          	bgeu	a1,a5,ffffffffc0209a64 <sfs_tryseek+0x5e>
ffffffffc0209a0e:	1101                	addi	sp,sp,-32
ffffffffc0209a10:	e822                	sd	s0,16(sp)
ffffffffc0209a12:	ec06                	sd	ra,24(sp)
ffffffffc0209a14:	e426                	sd	s1,8(sp)
ffffffffc0209a16:	842a                	mv	s0,a0
ffffffffc0209a18:	c921                	beqz	a0,ffffffffc0209a68 <sfs_tryseek+0x62>
ffffffffc0209a1a:	4d38                	lw	a4,88(a0)
ffffffffc0209a1c:	6785                	lui	a5,0x1
ffffffffc0209a1e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209a22:	04f71363          	bne	a4,a5,ffffffffc0209a68 <sfs_tryseek+0x62>
ffffffffc0209a26:	611c                	ld	a5,0(a0)
ffffffffc0209a28:	84ae                	mv	s1,a1
ffffffffc0209a2a:	0007e783          	lwu	a5,0(a5)
ffffffffc0209a2e:	02b7d563          	bge	a5,a1,ffffffffc0209a58 <sfs_tryseek+0x52>
ffffffffc0209a32:	793c                	ld	a5,112(a0)
ffffffffc0209a34:	cbb1                	beqz	a5,ffffffffc0209a88 <sfs_tryseek+0x82>
ffffffffc0209a36:	73bc                	ld	a5,96(a5)
ffffffffc0209a38:	cba1                	beqz	a5,ffffffffc0209a88 <sfs_tryseek+0x82>
ffffffffc0209a3a:	00005597          	auipc	a1,0x5
ffffffffc0209a3e:	e4e58593          	addi	a1,a1,-434 # ffffffffc020e888 <syscalls+0xca0>
ffffffffc0209a42:	818fe0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209a46:	783c                	ld	a5,112(s0)
ffffffffc0209a48:	8522                	mv	a0,s0
ffffffffc0209a4a:	6442                	ld	s0,16(sp)
ffffffffc0209a4c:	60e2                	ld	ra,24(sp)
ffffffffc0209a4e:	73bc                	ld	a5,96(a5)
ffffffffc0209a50:	85a6                	mv	a1,s1
ffffffffc0209a52:	64a2                	ld	s1,8(sp)
ffffffffc0209a54:	6105                	addi	sp,sp,32
ffffffffc0209a56:	8782                	jr	a5
ffffffffc0209a58:	60e2                	ld	ra,24(sp)
ffffffffc0209a5a:	6442                	ld	s0,16(sp)
ffffffffc0209a5c:	64a2                	ld	s1,8(sp)
ffffffffc0209a5e:	4501                	li	a0,0
ffffffffc0209a60:	6105                	addi	sp,sp,32
ffffffffc0209a62:	8082                	ret
ffffffffc0209a64:	5575                	li	a0,-3
ffffffffc0209a66:	8082                	ret
ffffffffc0209a68:	00005697          	auipc	a3,0x5
ffffffffc0209a6c:	54068693          	addi	a3,a3,1344 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc0209a70:	00002617          	auipc	a2,0x2
ffffffffc0209a74:	10860613          	addi	a2,a2,264 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209a78:	39b00593          	li	a1,923
ffffffffc0209a7c:	00005517          	auipc	a0,0x5
ffffffffc0209a80:	56450513          	addi	a0,a0,1380 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209a84:	a1bf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a88:	00005697          	auipc	a3,0x5
ffffffffc0209a8c:	da868693          	addi	a3,a3,-600 # ffffffffc020e830 <syscalls+0xc48>
ffffffffc0209a90:	00002617          	auipc	a2,0x2
ffffffffc0209a94:	0e860613          	addi	a2,a2,232 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209a98:	39d00593          	li	a1,925
ffffffffc0209a9c:	00005517          	auipc	a0,0x5
ffffffffc0209aa0:	54450513          	addi	a0,a0,1348 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209aa4:	9fbf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209aa8 <sfs_close>:
ffffffffc0209aa8:	1141                	addi	sp,sp,-16
ffffffffc0209aaa:	e406                	sd	ra,8(sp)
ffffffffc0209aac:	e022                	sd	s0,0(sp)
ffffffffc0209aae:	c11d                	beqz	a0,ffffffffc0209ad4 <sfs_close+0x2c>
ffffffffc0209ab0:	793c                	ld	a5,112(a0)
ffffffffc0209ab2:	842a                	mv	s0,a0
ffffffffc0209ab4:	c385                	beqz	a5,ffffffffc0209ad4 <sfs_close+0x2c>
ffffffffc0209ab6:	7b9c                	ld	a5,48(a5)
ffffffffc0209ab8:	cf91                	beqz	a5,ffffffffc0209ad4 <sfs_close+0x2c>
ffffffffc0209aba:	00004597          	auipc	a1,0x4
ffffffffc0209abe:	a3e58593          	addi	a1,a1,-1474 # ffffffffc020d4f8 <default_pmm_manager+0xea0>
ffffffffc0209ac2:	f99fd0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209ac6:	783c                	ld	a5,112(s0)
ffffffffc0209ac8:	8522                	mv	a0,s0
ffffffffc0209aca:	6402                	ld	s0,0(sp)
ffffffffc0209acc:	60a2                	ld	ra,8(sp)
ffffffffc0209ace:	7b9c                	ld	a5,48(a5)
ffffffffc0209ad0:	0141                	addi	sp,sp,16
ffffffffc0209ad2:	8782                	jr	a5
ffffffffc0209ad4:	00004697          	auipc	a3,0x4
ffffffffc0209ad8:	9d468693          	addi	a3,a3,-1580 # ffffffffc020d4a8 <default_pmm_manager+0xe50>
ffffffffc0209adc:	00002617          	auipc	a2,0x2
ffffffffc0209ae0:	09c60613          	addi	a2,a2,156 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209ae4:	21d00593          	li	a1,541
ffffffffc0209ae8:	00005517          	auipc	a0,0x5
ffffffffc0209aec:	4f850513          	addi	a0,a0,1272 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209af0:	9aff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209af4 <sfs_io.part.0>:
ffffffffc0209af4:	1141                	addi	sp,sp,-16
ffffffffc0209af6:	00005697          	auipc	a3,0x5
ffffffffc0209afa:	4b268693          	addi	a3,a3,1202 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc0209afe:	00002617          	auipc	a2,0x2
ffffffffc0209b02:	07a60613          	addi	a2,a2,122 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209b06:	29800593          	li	a1,664
ffffffffc0209b0a:	00005517          	auipc	a0,0x5
ffffffffc0209b0e:	4d650513          	addi	a0,a0,1238 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209b12:	e406                	sd	ra,8(sp)
ffffffffc0209b14:	98bf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209b18 <sfs_block_free>:
ffffffffc0209b18:	1101                	addi	sp,sp,-32
ffffffffc0209b1a:	e426                	sd	s1,8(sp)
ffffffffc0209b1c:	ec06                	sd	ra,24(sp)
ffffffffc0209b1e:	e822                	sd	s0,16(sp)
ffffffffc0209b20:	4154                	lw	a3,4(a0)
ffffffffc0209b22:	84ae                	mv	s1,a1
ffffffffc0209b24:	c595                	beqz	a1,ffffffffc0209b50 <sfs_block_free+0x38>
ffffffffc0209b26:	02d5f563          	bgeu	a1,a3,ffffffffc0209b50 <sfs_block_free+0x38>
ffffffffc0209b2a:	842a                	mv	s0,a0
ffffffffc0209b2c:	7d08                	ld	a0,56(a0)
ffffffffc0209b2e:	edcff0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc0209b32:	ed05                	bnez	a0,ffffffffc0209b6a <sfs_block_free+0x52>
ffffffffc0209b34:	7c08                	ld	a0,56(s0)
ffffffffc0209b36:	85a6                	mv	a1,s1
ffffffffc0209b38:	efaff0ef          	jal	ra,ffffffffc0209232 <bitmap_free>
ffffffffc0209b3c:	441c                	lw	a5,8(s0)
ffffffffc0209b3e:	4705                	li	a4,1
ffffffffc0209b40:	60e2                	ld	ra,24(sp)
ffffffffc0209b42:	2785                	addiw	a5,a5,1
ffffffffc0209b44:	e038                	sd	a4,64(s0)
ffffffffc0209b46:	c41c                	sw	a5,8(s0)
ffffffffc0209b48:	6442                	ld	s0,16(sp)
ffffffffc0209b4a:	64a2                	ld	s1,8(sp)
ffffffffc0209b4c:	6105                	addi	sp,sp,32
ffffffffc0209b4e:	8082                	ret
ffffffffc0209b50:	8726                	mv	a4,s1
ffffffffc0209b52:	00005617          	auipc	a2,0x5
ffffffffc0209b56:	4be60613          	addi	a2,a2,1214 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc0209b5a:	05400593          	li	a1,84
ffffffffc0209b5e:	00005517          	auipc	a0,0x5
ffffffffc0209b62:	48250513          	addi	a0,a0,1154 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209b66:	939f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b6a:	00005697          	auipc	a3,0x5
ffffffffc0209b6e:	4de68693          	addi	a3,a3,1246 # ffffffffc020f048 <dev_node_ops+0x628>
ffffffffc0209b72:	00002617          	auipc	a2,0x2
ffffffffc0209b76:	00660613          	addi	a2,a2,6 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209b7a:	06b00593          	li	a1,107
ffffffffc0209b7e:	00005517          	auipc	a0,0x5
ffffffffc0209b82:	46250513          	addi	a0,a0,1122 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209b86:	919f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209b8a <sfs_reclaim>:
ffffffffc0209b8a:	1101                	addi	sp,sp,-32
ffffffffc0209b8c:	e426                	sd	s1,8(sp)
ffffffffc0209b8e:	7524                	ld	s1,104(a0)
ffffffffc0209b90:	ec06                	sd	ra,24(sp)
ffffffffc0209b92:	e822                	sd	s0,16(sp)
ffffffffc0209b94:	e04a                	sd	s2,0(sp)
ffffffffc0209b96:	0e048a63          	beqz	s1,ffffffffc0209c8a <sfs_reclaim+0x100>
ffffffffc0209b9a:	0b04a783          	lw	a5,176(s1)
ffffffffc0209b9e:	0e079663          	bnez	a5,ffffffffc0209c8a <sfs_reclaim+0x100>
ffffffffc0209ba2:	4d38                	lw	a4,88(a0)
ffffffffc0209ba4:	6785                	lui	a5,0x1
ffffffffc0209ba6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209baa:	842a                	mv	s0,a0
ffffffffc0209bac:	10f71f63          	bne	a4,a5,ffffffffc0209cca <sfs_reclaim+0x140>
ffffffffc0209bb0:	8526                	mv	a0,s1
ffffffffc0209bb2:	58e010ef          	jal	ra,ffffffffc020b140 <lock_sfs_fs>
ffffffffc0209bb6:	4c1c                	lw	a5,24(s0)
ffffffffc0209bb8:	0ef05963          	blez	a5,ffffffffc0209caa <sfs_reclaim+0x120>
ffffffffc0209bbc:	fff7871b          	addiw	a4,a5,-1
ffffffffc0209bc0:	cc18                	sw	a4,24(s0)
ffffffffc0209bc2:	eb59                	bnez	a4,ffffffffc0209c58 <sfs_reclaim+0xce>
ffffffffc0209bc4:	05c42903          	lw	s2,92(s0)
ffffffffc0209bc8:	08091863          	bnez	s2,ffffffffc0209c58 <sfs_reclaim+0xce>
ffffffffc0209bcc:	601c                	ld	a5,0(s0)
ffffffffc0209bce:	0067d783          	lhu	a5,6(a5)
ffffffffc0209bd2:	e785                	bnez	a5,ffffffffc0209bfa <sfs_reclaim+0x70>
ffffffffc0209bd4:	783c                	ld	a5,112(s0)
ffffffffc0209bd6:	10078a63          	beqz	a5,ffffffffc0209cea <sfs_reclaim+0x160>
ffffffffc0209bda:	73bc                	ld	a5,96(a5)
ffffffffc0209bdc:	10078763          	beqz	a5,ffffffffc0209cea <sfs_reclaim+0x160>
ffffffffc0209be0:	00005597          	auipc	a1,0x5
ffffffffc0209be4:	ca858593          	addi	a1,a1,-856 # ffffffffc020e888 <syscalls+0xca0>
ffffffffc0209be8:	8522                	mv	a0,s0
ffffffffc0209bea:	e71fd0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209bee:	783c                	ld	a5,112(s0)
ffffffffc0209bf0:	4581                	li	a1,0
ffffffffc0209bf2:	8522                	mv	a0,s0
ffffffffc0209bf4:	73bc                	ld	a5,96(a5)
ffffffffc0209bf6:	9782                	jalr	a5
ffffffffc0209bf8:	e559                	bnez	a0,ffffffffc0209c86 <sfs_reclaim+0xfc>
ffffffffc0209bfa:	681c                	ld	a5,16(s0)
ffffffffc0209bfc:	c39d                	beqz	a5,ffffffffc0209c22 <sfs_reclaim+0x98>
ffffffffc0209bfe:	783c                	ld	a5,112(s0)
ffffffffc0209c00:	10078563          	beqz	a5,ffffffffc0209d0a <sfs_reclaim+0x180>
ffffffffc0209c04:	7b9c                	ld	a5,48(a5)
ffffffffc0209c06:	10078263          	beqz	a5,ffffffffc0209d0a <sfs_reclaim+0x180>
ffffffffc0209c0a:	8522                	mv	a0,s0
ffffffffc0209c0c:	00004597          	auipc	a1,0x4
ffffffffc0209c10:	8ec58593          	addi	a1,a1,-1812 # ffffffffc020d4f8 <default_pmm_manager+0xea0>
ffffffffc0209c14:	e47fd0ef          	jal	ra,ffffffffc0207a5a <inode_check>
ffffffffc0209c18:	783c                	ld	a5,112(s0)
ffffffffc0209c1a:	8522                	mv	a0,s0
ffffffffc0209c1c:	7b9c                	ld	a5,48(a5)
ffffffffc0209c1e:	9782                	jalr	a5
ffffffffc0209c20:	e13d                	bnez	a0,ffffffffc0209c86 <sfs_reclaim+0xfc>
ffffffffc0209c22:	7c18                	ld	a4,56(s0)
ffffffffc0209c24:	603c                	ld	a5,64(s0)
ffffffffc0209c26:	8526                	mv	a0,s1
ffffffffc0209c28:	e71c                	sd	a5,8(a4)
ffffffffc0209c2a:	e398                	sd	a4,0(a5)
ffffffffc0209c2c:	6438                	ld	a4,72(s0)
ffffffffc0209c2e:	683c                	ld	a5,80(s0)
ffffffffc0209c30:	e71c                	sd	a5,8(a4)
ffffffffc0209c32:	e398                	sd	a4,0(a5)
ffffffffc0209c34:	51c010ef          	jal	ra,ffffffffc020b150 <unlock_sfs_fs>
ffffffffc0209c38:	6008                	ld	a0,0(s0)
ffffffffc0209c3a:	00655783          	lhu	a5,6(a0)
ffffffffc0209c3e:	cb85                	beqz	a5,ffffffffc0209c6e <sfs_reclaim+0xe4>
ffffffffc0209c40:	c86f80ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc0209c44:	8522                	mv	a0,s0
ffffffffc0209c46:	da9fd0ef          	jal	ra,ffffffffc02079ee <inode_kill>
ffffffffc0209c4a:	60e2                	ld	ra,24(sp)
ffffffffc0209c4c:	6442                	ld	s0,16(sp)
ffffffffc0209c4e:	64a2                	ld	s1,8(sp)
ffffffffc0209c50:	854a                	mv	a0,s2
ffffffffc0209c52:	6902                	ld	s2,0(sp)
ffffffffc0209c54:	6105                	addi	sp,sp,32
ffffffffc0209c56:	8082                	ret
ffffffffc0209c58:	5945                	li	s2,-15
ffffffffc0209c5a:	8526                	mv	a0,s1
ffffffffc0209c5c:	4f4010ef          	jal	ra,ffffffffc020b150 <unlock_sfs_fs>
ffffffffc0209c60:	60e2                	ld	ra,24(sp)
ffffffffc0209c62:	6442                	ld	s0,16(sp)
ffffffffc0209c64:	64a2                	ld	s1,8(sp)
ffffffffc0209c66:	854a                	mv	a0,s2
ffffffffc0209c68:	6902                	ld	s2,0(sp)
ffffffffc0209c6a:	6105                	addi	sp,sp,32
ffffffffc0209c6c:	8082                	ret
ffffffffc0209c6e:	440c                	lw	a1,8(s0)
ffffffffc0209c70:	8526                	mv	a0,s1
ffffffffc0209c72:	ea7ff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc0209c76:	6008                	ld	a0,0(s0)
ffffffffc0209c78:	5d4c                	lw	a1,60(a0)
ffffffffc0209c7a:	d1f9                	beqz	a1,ffffffffc0209c40 <sfs_reclaim+0xb6>
ffffffffc0209c7c:	8526                	mv	a0,s1
ffffffffc0209c7e:	e9bff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc0209c82:	6008                	ld	a0,0(s0)
ffffffffc0209c84:	bf75                	j	ffffffffc0209c40 <sfs_reclaim+0xb6>
ffffffffc0209c86:	892a                	mv	s2,a0
ffffffffc0209c88:	bfc9                	j	ffffffffc0209c5a <sfs_reclaim+0xd0>
ffffffffc0209c8a:	00005697          	auipc	a3,0x5
ffffffffc0209c8e:	17668693          	addi	a3,a3,374 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc0209c92:	00002617          	auipc	a2,0x2
ffffffffc0209c96:	ee660613          	addi	a2,a2,-282 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209c9a:	35900593          	li	a1,857
ffffffffc0209c9e:	00005517          	auipc	a0,0x5
ffffffffc0209ca2:	34250513          	addi	a0,a0,834 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209ca6:	ff8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209caa:	00005697          	auipc	a3,0x5
ffffffffc0209cae:	3be68693          	addi	a3,a3,958 # ffffffffc020f068 <dev_node_ops+0x648>
ffffffffc0209cb2:	00002617          	auipc	a2,0x2
ffffffffc0209cb6:	ec660613          	addi	a2,a2,-314 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209cba:	35f00593          	li	a1,863
ffffffffc0209cbe:	00005517          	auipc	a0,0x5
ffffffffc0209cc2:	32250513          	addi	a0,a0,802 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209cc6:	fd8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209cca:	00005697          	auipc	a3,0x5
ffffffffc0209cce:	2de68693          	addi	a3,a3,734 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc0209cd2:	00002617          	auipc	a2,0x2
ffffffffc0209cd6:	ea660613          	addi	a2,a2,-346 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209cda:	35a00593          	li	a1,858
ffffffffc0209cde:	00005517          	auipc	a0,0x5
ffffffffc0209ce2:	30250513          	addi	a0,a0,770 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209ce6:	fb8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209cea:	00005697          	auipc	a3,0x5
ffffffffc0209cee:	b4668693          	addi	a3,a3,-1210 # ffffffffc020e830 <syscalls+0xc48>
ffffffffc0209cf2:	00002617          	auipc	a2,0x2
ffffffffc0209cf6:	e8660613          	addi	a2,a2,-378 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209cfa:	36400593          	li	a1,868
ffffffffc0209cfe:	00005517          	auipc	a0,0x5
ffffffffc0209d02:	2e250513          	addi	a0,a0,738 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209d06:	f98f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d0a:	00003697          	auipc	a3,0x3
ffffffffc0209d0e:	79e68693          	addi	a3,a3,1950 # ffffffffc020d4a8 <default_pmm_manager+0xe50>
ffffffffc0209d12:	00002617          	auipc	a2,0x2
ffffffffc0209d16:	e6660613          	addi	a2,a2,-410 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209d1a:	36900593          	li	a1,873
ffffffffc0209d1e:	00005517          	auipc	a0,0x5
ffffffffc0209d22:	2c250513          	addi	a0,a0,706 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209d26:	f78f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209d2a <sfs_block_alloc>:
ffffffffc0209d2a:	1101                	addi	sp,sp,-32
ffffffffc0209d2c:	e822                	sd	s0,16(sp)
ffffffffc0209d2e:	842a                	mv	s0,a0
ffffffffc0209d30:	7d08                	ld	a0,56(a0)
ffffffffc0209d32:	e426                	sd	s1,8(sp)
ffffffffc0209d34:	ec06                	sd	ra,24(sp)
ffffffffc0209d36:	84ae                	mv	s1,a1
ffffffffc0209d38:	c62ff0ef          	jal	ra,ffffffffc020919a <bitmap_alloc>
ffffffffc0209d3c:	e90d                	bnez	a0,ffffffffc0209d6e <sfs_block_alloc+0x44>
ffffffffc0209d3e:	441c                	lw	a5,8(s0)
ffffffffc0209d40:	cbad                	beqz	a5,ffffffffc0209db2 <sfs_block_alloc+0x88>
ffffffffc0209d42:	37fd                	addiw	a5,a5,-1
ffffffffc0209d44:	c41c                	sw	a5,8(s0)
ffffffffc0209d46:	408c                	lw	a1,0(s1)
ffffffffc0209d48:	4785                	li	a5,1
ffffffffc0209d4a:	e03c                	sd	a5,64(s0)
ffffffffc0209d4c:	4054                	lw	a3,4(s0)
ffffffffc0209d4e:	c58d                	beqz	a1,ffffffffc0209d78 <sfs_block_alloc+0x4e>
ffffffffc0209d50:	02d5f463          	bgeu	a1,a3,ffffffffc0209d78 <sfs_block_alloc+0x4e>
ffffffffc0209d54:	7c08                	ld	a0,56(s0)
ffffffffc0209d56:	cb4ff0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc0209d5a:	ed05                	bnez	a0,ffffffffc0209d92 <sfs_block_alloc+0x68>
ffffffffc0209d5c:	8522                	mv	a0,s0
ffffffffc0209d5e:	6442                	ld	s0,16(sp)
ffffffffc0209d60:	408c                	lw	a1,0(s1)
ffffffffc0209d62:	60e2                	ld	ra,24(sp)
ffffffffc0209d64:	64a2                	ld	s1,8(sp)
ffffffffc0209d66:	4605                	li	a2,1
ffffffffc0209d68:	6105                	addi	sp,sp,32
ffffffffc0209d6a:	3760106f          	j	ffffffffc020b0e0 <sfs_clear_block>
ffffffffc0209d6e:	60e2                	ld	ra,24(sp)
ffffffffc0209d70:	6442                	ld	s0,16(sp)
ffffffffc0209d72:	64a2                	ld	s1,8(sp)
ffffffffc0209d74:	6105                	addi	sp,sp,32
ffffffffc0209d76:	8082                	ret
ffffffffc0209d78:	872e                	mv	a4,a1
ffffffffc0209d7a:	00005617          	auipc	a2,0x5
ffffffffc0209d7e:	29660613          	addi	a2,a2,662 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc0209d82:	05400593          	li	a1,84
ffffffffc0209d86:	00005517          	auipc	a0,0x5
ffffffffc0209d8a:	25a50513          	addi	a0,a0,602 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209d8e:	f10f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d92:	00005697          	auipc	a3,0x5
ffffffffc0209d96:	30e68693          	addi	a3,a3,782 # ffffffffc020f0a0 <dev_node_ops+0x680>
ffffffffc0209d9a:	00002617          	auipc	a2,0x2
ffffffffc0209d9e:	dde60613          	addi	a2,a2,-546 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209da2:	06200593          	li	a1,98
ffffffffc0209da6:	00005517          	auipc	a0,0x5
ffffffffc0209daa:	23a50513          	addi	a0,a0,570 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209dae:	ef0f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209db2:	00005697          	auipc	a3,0x5
ffffffffc0209db6:	2ce68693          	addi	a3,a3,718 # ffffffffc020f080 <dev_node_ops+0x660>
ffffffffc0209dba:	00002617          	auipc	a2,0x2
ffffffffc0209dbe:	dbe60613          	addi	a2,a2,-578 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209dc2:	06000593          	li	a1,96
ffffffffc0209dc6:	00005517          	auipc	a0,0x5
ffffffffc0209dca:	21a50513          	addi	a0,a0,538 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209dce:	ed0f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209dd2 <sfs_bmap_load_nolock>:
ffffffffc0209dd2:	7159                	addi	sp,sp,-112
ffffffffc0209dd4:	f85a                	sd	s6,48(sp)
ffffffffc0209dd6:	0005bb03          	ld	s6,0(a1)
ffffffffc0209dda:	f45e                	sd	s7,40(sp)
ffffffffc0209ddc:	f486                	sd	ra,104(sp)
ffffffffc0209dde:	008b2b83          	lw	s7,8(s6)
ffffffffc0209de2:	f0a2                	sd	s0,96(sp)
ffffffffc0209de4:	eca6                	sd	s1,88(sp)
ffffffffc0209de6:	e8ca                	sd	s2,80(sp)
ffffffffc0209de8:	e4ce                	sd	s3,72(sp)
ffffffffc0209dea:	e0d2                	sd	s4,64(sp)
ffffffffc0209dec:	fc56                	sd	s5,56(sp)
ffffffffc0209dee:	f062                	sd	s8,32(sp)
ffffffffc0209df0:	ec66                	sd	s9,24(sp)
ffffffffc0209df2:	18cbe363          	bltu	s7,a2,ffffffffc0209f78 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209df6:	47ad                	li	a5,11
ffffffffc0209df8:	8aae                	mv	s5,a1
ffffffffc0209dfa:	8432                	mv	s0,a2
ffffffffc0209dfc:	84aa                	mv	s1,a0
ffffffffc0209dfe:	89b6                	mv	s3,a3
ffffffffc0209e00:	04c7f563          	bgeu	a5,a2,ffffffffc0209e4a <sfs_bmap_load_nolock+0x78>
ffffffffc0209e04:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209e08:	0007069b          	sext.w	a3,a4
ffffffffc0209e0c:	3ff00793          	li	a5,1023
ffffffffc0209e10:	1ad7e163          	bltu	a5,a3,ffffffffc0209fb2 <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209e14:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209e18:	02071793          	slli	a5,a4,0x20
ffffffffc0209e1c:	c602                	sw	zero,12(sp)
ffffffffc0209e1e:	c452                	sw	s4,8(sp)
ffffffffc0209e20:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209e24:	0e0a1e63          	bnez	s4,ffffffffc0209f20 <sfs_bmap_load_nolock+0x14e>
ffffffffc0209e28:	0acb8663          	beq	s7,a2,ffffffffc0209ed4 <sfs_bmap_load_nolock+0x102>
ffffffffc0209e2c:	4a01                	li	s4,0
ffffffffc0209e2e:	40d4                	lw	a3,4(s1)
ffffffffc0209e30:	8752                	mv	a4,s4
ffffffffc0209e32:	00005617          	auipc	a2,0x5
ffffffffc0209e36:	1de60613          	addi	a2,a2,478 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc0209e3a:	05400593          	li	a1,84
ffffffffc0209e3e:	00005517          	auipc	a0,0x5
ffffffffc0209e42:	1a250513          	addi	a0,a0,418 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209e46:	e58f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e4a:	02061793          	slli	a5,a2,0x20
ffffffffc0209e4e:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209e52:	9a5a                	add	s4,s4,s6
ffffffffc0209e54:	00ca2583          	lw	a1,12(s4)
ffffffffc0209e58:	c22e                	sw	a1,4(sp)
ffffffffc0209e5a:	ed99                	bnez	a1,ffffffffc0209e78 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209e5c:	fccb98e3          	bne	s7,a2,ffffffffc0209e2c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e60:	004c                	addi	a1,sp,4
ffffffffc0209e62:	ec9ff0ef          	jal	ra,ffffffffc0209d2a <sfs_block_alloc>
ffffffffc0209e66:	892a                	mv	s2,a0
ffffffffc0209e68:	e921                	bnez	a0,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209e6a:	4592                	lw	a1,4(sp)
ffffffffc0209e6c:	4705                	li	a4,1
ffffffffc0209e6e:	00ba2623          	sw	a1,12(s4)
ffffffffc0209e72:	00eab823          	sd	a4,16(s5)
ffffffffc0209e76:	d9dd                	beqz	a1,ffffffffc0209e2c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e78:	40d4                	lw	a3,4(s1)
ffffffffc0209e7a:	10d5ff63          	bgeu	a1,a3,ffffffffc0209f98 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209e7e:	7c88                	ld	a0,56(s1)
ffffffffc0209e80:	b8aff0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc0209e84:	18051363          	bnez	a0,ffffffffc020a00a <sfs_bmap_load_nolock+0x238>
ffffffffc0209e88:	4a12                	lw	s4,4(sp)
ffffffffc0209e8a:	fa0a02e3          	beqz	s4,ffffffffc0209e2e <sfs_bmap_load_nolock+0x5c>
ffffffffc0209e8e:	40dc                	lw	a5,4(s1)
ffffffffc0209e90:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209e2e <sfs_bmap_load_nolock+0x5c>
ffffffffc0209e94:	7c88                	ld	a0,56(s1)
ffffffffc0209e96:	85d2                	mv	a1,s4
ffffffffc0209e98:	b72ff0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc0209e9c:	12051763          	bnez	a0,ffffffffc0209fca <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209ea0:	008b9763          	bne	s7,s0,ffffffffc0209eae <sfs_bmap_load_nolock+0xdc>
ffffffffc0209ea4:	008b2783          	lw	a5,8(s6)
ffffffffc0209ea8:	2785                	addiw	a5,a5,1
ffffffffc0209eaa:	00fb2423          	sw	a5,8(s6)
ffffffffc0209eae:	4901                	li	s2,0
ffffffffc0209eb0:	00098463          	beqz	s3,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209eb4:	0149a023          	sw	s4,0(s3)
ffffffffc0209eb8:	70a6                	ld	ra,104(sp)
ffffffffc0209eba:	7406                	ld	s0,96(sp)
ffffffffc0209ebc:	64e6                	ld	s1,88(sp)
ffffffffc0209ebe:	69a6                	ld	s3,72(sp)
ffffffffc0209ec0:	6a06                	ld	s4,64(sp)
ffffffffc0209ec2:	7ae2                	ld	s5,56(sp)
ffffffffc0209ec4:	7b42                	ld	s6,48(sp)
ffffffffc0209ec6:	7ba2                	ld	s7,40(sp)
ffffffffc0209ec8:	7c02                	ld	s8,32(sp)
ffffffffc0209eca:	6ce2                	ld	s9,24(sp)
ffffffffc0209ecc:	854a                	mv	a0,s2
ffffffffc0209ece:	6946                	ld	s2,80(sp)
ffffffffc0209ed0:	6165                	addi	sp,sp,112
ffffffffc0209ed2:	8082                	ret
ffffffffc0209ed4:	002c                	addi	a1,sp,8
ffffffffc0209ed6:	e55ff0ef          	jal	ra,ffffffffc0209d2a <sfs_block_alloc>
ffffffffc0209eda:	892a                	mv	s2,a0
ffffffffc0209edc:	00c10c93          	addi	s9,sp,12
ffffffffc0209ee0:	fd61                	bnez	a0,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209ee2:	85e6                	mv	a1,s9
ffffffffc0209ee4:	8526                	mv	a0,s1
ffffffffc0209ee6:	e45ff0ef          	jal	ra,ffffffffc0209d2a <sfs_block_alloc>
ffffffffc0209eea:	892a                	mv	s2,a0
ffffffffc0209eec:	e925                	bnez	a0,ffffffffc0209f5c <sfs_bmap_load_nolock+0x18a>
ffffffffc0209eee:	46a2                	lw	a3,8(sp)
ffffffffc0209ef0:	85e6                	mv	a1,s9
ffffffffc0209ef2:	8762                	mv	a4,s8
ffffffffc0209ef4:	4611                	li	a2,4
ffffffffc0209ef6:	8526                	mv	a0,s1
ffffffffc0209ef8:	098010ef          	jal	ra,ffffffffc020af90 <sfs_wbuf>
ffffffffc0209efc:	45b2                	lw	a1,12(sp)
ffffffffc0209efe:	892a                	mv	s2,a0
ffffffffc0209f00:	e939                	bnez	a0,ffffffffc0209f56 <sfs_bmap_load_nolock+0x184>
ffffffffc0209f02:	03cb2683          	lw	a3,60(s6)
ffffffffc0209f06:	4722                	lw	a4,8(sp)
ffffffffc0209f08:	c22e                	sw	a1,4(sp)
ffffffffc0209f0a:	f6d706e3          	beq	a4,a3,ffffffffc0209e76 <sfs_bmap_load_nolock+0xa4>
ffffffffc0209f0e:	eef1                	bnez	a3,ffffffffc0209fea <sfs_bmap_load_nolock+0x218>
ffffffffc0209f10:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209f14:	4705                	li	a4,1
ffffffffc0209f16:	00eab823          	sd	a4,16(s5)
ffffffffc0209f1a:	f00589e3          	beqz	a1,ffffffffc0209e2c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209f1e:	bfa9                	j	ffffffffc0209e78 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209f20:	00c10c93          	addi	s9,sp,12
ffffffffc0209f24:	8762                	mv	a4,s8
ffffffffc0209f26:	86d2                	mv	a3,s4
ffffffffc0209f28:	4611                	li	a2,4
ffffffffc0209f2a:	85e6                	mv	a1,s9
ffffffffc0209f2c:	7e5000ef          	jal	ra,ffffffffc020af10 <sfs_rbuf>
ffffffffc0209f30:	892a                	mv	s2,a0
ffffffffc0209f32:	f159                	bnez	a0,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209f34:	45b2                	lw	a1,12(sp)
ffffffffc0209f36:	e995                	bnez	a1,ffffffffc0209f6a <sfs_bmap_load_nolock+0x198>
ffffffffc0209f38:	fa8b85e3          	beq	s7,s0,ffffffffc0209ee2 <sfs_bmap_load_nolock+0x110>
ffffffffc0209f3c:	03cb2703          	lw	a4,60(s6)
ffffffffc0209f40:	47a2                	lw	a5,8(sp)
ffffffffc0209f42:	c202                	sw	zero,4(sp)
ffffffffc0209f44:	eee784e3          	beq	a5,a4,ffffffffc0209e2c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209f48:	e34d                	bnez	a4,ffffffffc0209fea <sfs_bmap_load_nolock+0x218>
ffffffffc0209f4a:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209f4e:	4785                	li	a5,1
ffffffffc0209f50:	00fab823          	sd	a5,16(s5)
ffffffffc0209f54:	bde1                	j	ffffffffc0209e2c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209f56:	8526                	mv	a0,s1
ffffffffc0209f58:	bc1ff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc0209f5c:	45a2                	lw	a1,8(sp)
ffffffffc0209f5e:	f4ba0de3          	beq	s4,a1,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209f62:	8526                	mv	a0,s1
ffffffffc0209f64:	bb5ff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc0209f68:	bf81                	j	ffffffffc0209eb8 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209f6a:	03cb2683          	lw	a3,60(s6)
ffffffffc0209f6e:	4722                	lw	a4,8(sp)
ffffffffc0209f70:	c22e                	sw	a1,4(sp)
ffffffffc0209f72:	f8e69ee3          	bne	a3,a4,ffffffffc0209f0e <sfs_bmap_load_nolock+0x13c>
ffffffffc0209f76:	b709                	j	ffffffffc0209e78 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209f78:	00005697          	auipc	a3,0x5
ffffffffc0209f7c:	15068693          	addi	a3,a3,336 # ffffffffc020f0c8 <dev_node_ops+0x6a8>
ffffffffc0209f80:	00002617          	auipc	a2,0x2
ffffffffc0209f84:	bf860613          	addi	a2,a2,-1032 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209f88:	16500593          	li	a1,357
ffffffffc0209f8c:	00005517          	auipc	a0,0x5
ffffffffc0209f90:	05450513          	addi	a0,a0,84 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209f94:	d0af60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209f98:	872e                	mv	a4,a1
ffffffffc0209f9a:	00005617          	auipc	a2,0x5
ffffffffc0209f9e:	07660613          	addi	a2,a2,118 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc0209fa2:	05400593          	li	a1,84
ffffffffc0209fa6:	00005517          	auipc	a0,0x5
ffffffffc0209faa:	03a50513          	addi	a0,a0,58 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209fae:	cf0f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209fb2:	00005617          	auipc	a2,0x5
ffffffffc0209fb6:	14660613          	addi	a2,a2,326 # ffffffffc020f0f8 <dev_node_ops+0x6d8>
ffffffffc0209fba:	11f00593          	li	a1,287
ffffffffc0209fbe:	00005517          	auipc	a0,0x5
ffffffffc0209fc2:	02250513          	addi	a0,a0,34 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209fc6:	cd8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209fca:	00005697          	auipc	a3,0x5
ffffffffc0209fce:	07e68693          	addi	a3,a3,126 # ffffffffc020f048 <dev_node_ops+0x628>
ffffffffc0209fd2:	00002617          	auipc	a2,0x2
ffffffffc0209fd6:	ba660613          	addi	a2,a2,-1114 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209fda:	16c00593          	li	a1,364
ffffffffc0209fde:	00005517          	auipc	a0,0x5
ffffffffc0209fe2:	00250513          	addi	a0,a0,2 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc0209fe6:	cb8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209fea:	00005697          	auipc	a3,0x5
ffffffffc0209fee:	0f668693          	addi	a3,a3,246 # ffffffffc020f0e0 <dev_node_ops+0x6c0>
ffffffffc0209ff2:	00002617          	auipc	a2,0x2
ffffffffc0209ff6:	b8660613          	addi	a2,a2,-1146 # ffffffffc020bb78 <commands+0x210>
ffffffffc0209ffa:	11900593          	li	a1,281
ffffffffc0209ffe:	00005517          	auipc	a0,0x5
ffffffffc020a002:	fe250513          	addi	a0,a0,-30 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a006:	c98f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a00a:	00005697          	auipc	a3,0x5
ffffffffc020a00e:	11e68693          	addi	a3,a3,286 # ffffffffc020f128 <dev_node_ops+0x708>
ffffffffc020a012:	00002617          	auipc	a2,0x2
ffffffffc020a016:	b6660613          	addi	a2,a2,-1178 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a01a:	12200593          	li	a1,290
ffffffffc020a01e:	00005517          	auipc	a0,0x5
ffffffffc020a022:	fc250513          	addi	a0,a0,-62 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a026:	c78f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a02a <sfs_io_nolock>:
ffffffffc020a02a:	7175                	addi	sp,sp,-144
ffffffffc020a02c:	ecd6                	sd	s5,88(sp)
ffffffffc020a02e:	8aae                	mv	s5,a1
ffffffffc020a030:	618c                	ld	a1,0(a1)
ffffffffc020a032:	e506                	sd	ra,136(sp)
ffffffffc020a034:	e122                	sd	s0,128(sp)
ffffffffc020a036:	0045d883          	lhu	a7,4(a1)
ffffffffc020a03a:	fca6                	sd	s1,120(sp)
ffffffffc020a03c:	f8ca                	sd	s2,112(sp)
ffffffffc020a03e:	f4ce                	sd	s3,104(sp)
ffffffffc020a040:	f0d2                	sd	s4,96(sp)
ffffffffc020a042:	e8da                	sd	s6,80(sp)
ffffffffc020a044:	e4de                	sd	s7,72(sp)
ffffffffc020a046:	e0e2                	sd	s8,64(sp)
ffffffffc020a048:	fc66                	sd	s9,56(sp)
ffffffffc020a04a:	f86a                	sd	s10,48(sp)
ffffffffc020a04c:	f46e                	sd	s11,40(sp)
ffffffffc020a04e:	4809                	li	a6,2
ffffffffc020a050:	19088b63          	beq	a7,a6,ffffffffc020a1e6 <sfs_io_nolock+0x1bc>
ffffffffc020a054:	00073b03          	ld	s6,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc020a058:	8c3a                	mv	s8,a4
ffffffffc020a05a:	000c3023          	sd	zero,0(s8)
ffffffffc020a05e:	08000737          	lui	a4,0x8000
ffffffffc020a062:	8436                	mv	s0,a3
ffffffffc020a064:	8d36                	mv	s10,a3
ffffffffc020a066:	9b36                	add	s6,s6,a3
ffffffffc020a068:	16e6fd63          	bgeu	a3,a4,ffffffffc020a1e2 <sfs_io_nolock+0x1b8>
ffffffffc020a06c:	16db4b63          	blt	s6,a3,ffffffffc020a1e2 <sfs_io_nolock+0x1b8>
ffffffffc020a070:	892a                	mv	s2,a0
ffffffffc020a072:	4501                	li	a0,0
ffffffffc020a074:	0d668563          	beq	a3,s6,ffffffffc020a13e <sfs_io_nolock+0x114>
ffffffffc020a078:	84b2                	mv	s1,a2
ffffffffc020a07a:	01677463          	bgeu	a4,s6,ffffffffc020a082 <sfs_io_nolock+0x58>
ffffffffc020a07e:	08000b37          	lui	s6,0x8000
ffffffffc020a082:	cfe9                	beqz	a5,ffffffffc020a15c <sfs_io_nolock+0x132>
ffffffffc020a084:	00001797          	auipc	a5,0x1
ffffffffc020a088:	f0c78793          	addi	a5,a5,-244 # ffffffffc020af90 <sfs_wbuf>
ffffffffc020a08c:	00001c97          	auipc	s9,0x1
ffffffffc020a090:	e24c8c93          	addi	s9,s9,-476 # ffffffffc020aeb0 <sfs_wblock>
ffffffffc020a094:	e03e                	sd	a5,0(sp)
ffffffffc020a096:	6705                	lui	a4,0x1
ffffffffc020a098:	40c45d93          	srai	s11,s0,0xc
ffffffffc020a09c:	40cb5993          	srai	s3,s6,0xc
ffffffffc020a0a0:	fff70b93          	addi	s7,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a0a4:	41b987bb          	subw	a5,s3,s11
ffffffffc020a0a8:	01747bb3          	and	s7,s0,s7
ffffffffc020a0ac:	89be                	mv	s3,a5
ffffffffc020a0ae:	2d81                	sext.w	s11,s11
ffffffffc020a0b0:	8a5e                	mv	s4,s7
ffffffffc020a0b2:	020b8e63          	beqz	s7,ffffffffc020a0ee <sfs_io_nolock+0xc4>
ffffffffc020a0b6:	408b0a33          	sub	s4,s6,s0
ffffffffc020a0ba:	e3f1                	bnez	a5,ffffffffc020a17e <sfs_io_nolock+0x154>
ffffffffc020a0bc:	0874                	addi	a3,sp,28
ffffffffc020a0be:	866e                	mv	a2,s11
ffffffffc020a0c0:	85d6                	mv	a1,s5
ffffffffc020a0c2:	854a                	mv	a0,s2
ffffffffc020a0c4:	e43e                	sd	a5,8(sp)
ffffffffc020a0c6:	d0dff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a0ca:	e561                	bnez	a0,ffffffffc020a192 <sfs_io_nolock+0x168>
ffffffffc020a0cc:	46f2                	lw	a3,28(sp)
ffffffffc020a0ce:	6782                	ld	a5,0(sp)
ffffffffc020a0d0:	875e                	mv	a4,s7
ffffffffc020a0d2:	8652                	mv	a2,s4
ffffffffc020a0d4:	85a6                	mv	a1,s1
ffffffffc020a0d6:	854a                	mv	a0,s2
ffffffffc020a0d8:	9782                	jalr	a5
ffffffffc020a0da:	ed45                	bnez	a0,ffffffffc020a192 <sfs_io_nolock+0x168>
ffffffffc020a0dc:	67a2                	ld	a5,8(sp)
ffffffffc020a0de:	01440d33          	add	s10,s0,s4
ffffffffc020a0e2:	c3a1                	beqz	a5,ffffffffc020a122 <sfs_io_nolock+0xf8>
ffffffffc020a0e4:	94d2                	add	s1,s1,s4
ffffffffc020a0e6:	846a                	mv	s0,s10
ffffffffc020a0e8:	2d85                	addiw	s11,s11,1
ffffffffc020a0ea:	fff9879b          	addiw	a5,s3,-1
ffffffffc020a0ee:	cfdd                	beqz	a5,ffffffffc020a1ac <sfs_io_nolock+0x182>
ffffffffc020a0f0:	01b78bbb          	addw	s7,a5,s11
ffffffffc020a0f4:	6985                	lui	s3,0x1
ffffffffc020a0f6:	a829                	j	ffffffffc020a110 <sfs_io_nolock+0xe6>
ffffffffc020a0f8:	4672                	lw	a2,28(sp)
ffffffffc020a0fa:	4685                	li	a3,1
ffffffffc020a0fc:	85a6                	mv	a1,s1
ffffffffc020a0fe:	854a                	mv	a0,s2
ffffffffc020a100:	9c82                	jalr	s9
ffffffffc020a102:	ed11                	bnez	a0,ffffffffc020a11e <sfs_io_nolock+0xf4>
ffffffffc020a104:	2d85                	addiw	s11,s11,1
ffffffffc020a106:	9a4e                	add	s4,s4,s3
ffffffffc020a108:	94ce                	add	s1,s1,s3
ffffffffc020a10a:	944e                	add	s0,s0,s3
ffffffffc020a10c:	0bbb8163          	beq	s7,s11,ffffffffc020a1ae <sfs_io_nolock+0x184>
ffffffffc020a110:	0874                	addi	a3,sp,28
ffffffffc020a112:	866e                	mv	a2,s11
ffffffffc020a114:	85d6                	mv	a1,s5
ffffffffc020a116:	854a                	mv	a0,s2
ffffffffc020a118:	cbbff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a11c:	dd71                	beqz	a0,ffffffffc020a0f8 <sfs_io_nolock+0xce>
ffffffffc020a11e:	008a0d33          	add	s10,s4,s0
ffffffffc020a122:	000ab783          	ld	a5,0(s5)
ffffffffc020a126:	014c3023          	sd	s4,0(s8)
ffffffffc020a12a:	0007e703          	lwu	a4,0(a5)
ffffffffc020a12e:	01a77863          	bgeu	a4,s10,ffffffffc020a13e <sfs_io_nolock+0x114>
ffffffffc020a132:	0144043b          	addw	s0,s0,s4
ffffffffc020a136:	c380                	sw	s0,0(a5)
ffffffffc020a138:	4785                	li	a5,1
ffffffffc020a13a:	00fab823          	sd	a5,16(s5)
ffffffffc020a13e:	60aa                	ld	ra,136(sp)
ffffffffc020a140:	640a                	ld	s0,128(sp)
ffffffffc020a142:	74e6                	ld	s1,120(sp)
ffffffffc020a144:	7946                	ld	s2,112(sp)
ffffffffc020a146:	79a6                	ld	s3,104(sp)
ffffffffc020a148:	7a06                	ld	s4,96(sp)
ffffffffc020a14a:	6ae6                	ld	s5,88(sp)
ffffffffc020a14c:	6b46                	ld	s6,80(sp)
ffffffffc020a14e:	6ba6                	ld	s7,72(sp)
ffffffffc020a150:	6c06                	ld	s8,64(sp)
ffffffffc020a152:	7ce2                	ld	s9,56(sp)
ffffffffc020a154:	7d42                	ld	s10,48(sp)
ffffffffc020a156:	7da2                	ld	s11,40(sp)
ffffffffc020a158:	6149                	addi	sp,sp,144
ffffffffc020a15a:	8082                	ret
ffffffffc020a15c:	0005e783          	lwu	a5,0(a1)
ffffffffc020a160:	4501                	li	a0,0
ffffffffc020a162:	fcf45ee3          	bge	s0,a5,ffffffffc020a13e <sfs_io_nolock+0x114>
ffffffffc020a166:	0367c863          	blt	a5,s6,ffffffffc020a196 <sfs_io_nolock+0x16c>
ffffffffc020a16a:	00001797          	auipc	a5,0x1
ffffffffc020a16e:	da678793          	addi	a5,a5,-602 # ffffffffc020af10 <sfs_rbuf>
ffffffffc020a172:	00001c97          	auipc	s9,0x1
ffffffffc020a176:	cdec8c93          	addi	s9,s9,-802 # ffffffffc020ae50 <sfs_rblock>
ffffffffc020a17a:	e03e                	sd	a5,0(sp)
ffffffffc020a17c:	bf29                	j	ffffffffc020a096 <sfs_io_nolock+0x6c>
ffffffffc020a17e:	0874                	addi	a3,sp,28
ffffffffc020a180:	866e                	mv	a2,s11
ffffffffc020a182:	85d6                	mv	a1,s5
ffffffffc020a184:	854a                	mv	a0,s2
ffffffffc020a186:	41770a33          	sub	s4,a4,s7
ffffffffc020a18a:	e43e                	sd	a5,8(sp)
ffffffffc020a18c:	c47ff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a190:	dd15                	beqz	a0,ffffffffc020a0cc <sfs_io_nolock+0xa2>
ffffffffc020a192:	4a01                	li	s4,0
ffffffffc020a194:	b779                	j	ffffffffc020a122 <sfs_io_nolock+0xf8>
ffffffffc020a196:	8b3e                	mv	s6,a5
ffffffffc020a198:	00001797          	auipc	a5,0x1
ffffffffc020a19c:	d7878793          	addi	a5,a5,-648 # ffffffffc020af10 <sfs_rbuf>
ffffffffc020a1a0:	00001c97          	auipc	s9,0x1
ffffffffc020a1a4:	cb0c8c93          	addi	s9,s9,-848 # ffffffffc020ae50 <sfs_rblock>
ffffffffc020a1a8:	e03e                	sd	a5,0(sp)
ffffffffc020a1aa:	b5f5                	j	ffffffffc020a096 <sfs_io_nolock+0x6c>
ffffffffc020a1ac:	8bee                	mv	s7,s11
ffffffffc020a1ae:	1b52                	slli	s6,s6,0x34
ffffffffc020a1b0:	034b5993          	srli	s3,s6,0x34
ffffffffc020a1b4:	000b1663          	bnez	s6,ffffffffc020a1c0 <sfs_io_nolock+0x196>
ffffffffc020a1b8:	01440d33          	add	s10,s0,s4
ffffffffc020a1bc:	4501                	li	a0,0
ffffffffc020a1be:	b795                	j	ffffffffc020a122 <sfs_io_nolock+0xf8>
ffffffffc020a1c0:	0874                	addi	a3,sp,28
ffffffffc020a1c2:	865e                	mv	a2,s7
ffffffffc020a1c4:	85d6                	mv	a1,s5
ffffffffc020a1c6:	854a                	mv	a0,s2
ffffffffc020a1c8:	c0bff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a1cc:	f929                	bnez	a0,ffffffffc020a11e <sfs_io_nolock+0xf4>
ffffffffc020a1ce:	46f2                	lw	a3,28(sp)
ffffffffc020a1d0:	6782                	ld	a5,0(sp)
ffffffffc020a1d2:	4701                	li	a4,0
ffffffffc020a1d4:	864e                	mv	a2,s3
ffffffffc020a1d6:	85a6                	mv	a1,s1
ffffffffc020a1d8:	854a                	mv	a0,s2
ffffffffc020a1da:	9782                	jalr	a5
ffffffffc020a1dc:	f129                	bnez	a0,ffffffffc020a11e <sfs_io_nolock+0xf4>
ffffffffc020a1de:	9a4e                	add	s4,s4,s3
ffffffffc020a1e0:	bf3d                	j	ffffffffc020a11e <sfs_io_nolock+0xf4>
ffffffffc020a1e2:	5575                	li	a0,-3
ffffffffc020a1e4:	bfa9                	j	ffffffffc020a13e <sfs_io_nolock+0x114>
ffffffffc020a1e6:	00005697          	auipc	a3,0x5
ffffffffc020a1ea:	f6a68693          	addi	a3,a3,-150 # ffffffffc020f150 <dev_node_ops+0x730>
ffffffffc020a1ee:	00002617          	auipc	a2,0x2
ffffffffc020a1f2:	98a60613          	addi	a2,a2,-1654 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a1f6:	22c00593          	li	a1,556
ffffffffc020a1fa:	00005517          	auipc	a0,0x5
ffffffffc020a1fe:	de650513          	addi	a0,a0,-538 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a202:	a9cf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a206 <sfs_read>:
ffffffffc020a206:	7139                	addi	sp,sp,-64
ffffffffc020a208:	f04a                	sd	s2,32(sp)
ffffffffc020a20a:	06853903          	ld	s2,104(a0)
ffffffffc020a20e:	fc06                	sd	ra,56(sp)
ffffffffc020a210:	f822                	sd	s0,48(sp)
ffffffffc020a212:	f426                	sd	s1,40(sp)
ffffffffc020a214:	ec4e                	sd	s3,24(sp)
ffffffffc020a216:	04090f63          	beqz	s2,ffffffffc020a274 <sfs_read+0x6e>
ffffffffc020a21a:	0b092783          	lw	a5,176(s2)
ffffffffc020a21e:	ebb9                	bnez	a5,ffffffffc020a274 <sfs_read+0x6e>
ffffffffc020a220:	4d38                	lw	a4,88(a0)
ffffffffc020a222:	6785                	lui	a5,0x1
ffffffffc020a224:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a228:	842a                	mv	s0,a0
ffffffffc020a22a:	06f71563          	bne	a4,a5,ffffffffc020a294 <sfs_read+0x8e>
ffffffffc020a22e:	02050993          	addi	s3,a0,32
ffffffffc020a232:	854e                	mv	a0,s3
ffffffffc020a234:	84ae                	mv	s1,a1
ffffffffc020a236:	c2efa0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020a23a:	0184b803          	ld	a6,24(s1)
ffffffffc020a23e:	6494                	ld	a3,8(s1)
ffffffffc020a240:	6090                	ld	a2,0(s1)
ffffffffc020a242:	85a2                	mv	a1,s0
ffffffffc020a244:	4781                	li	a5,0
ffffffffc020a246:	0038                	addi	a4,sp,8
ffffffffc020a248:	854a                	mv	a0,s2
ffffffffc020a24a:	e442                	sd	a6,8(sp)
ffffffffc020a24c:	ddfff0ef          	jal	ra,ffffffffc020a02a <sfs_io_nolock>
ffffffffc020a250:	65a2                	ld	a1,8(sp)
ffffffffc020a252:	842a                	mv	s0,a0
ffffffffc020a254:	ed81                	bnez	a1,ffffffffc020a26c <sfs_read+0x66>
ffffffffc020a256:	854e                	mv	a0,s3
ffffffffc020a258:	c08fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a25c:	70e2                	ld	ra,56(sp)
ffffffffc020a25e:	8522                	mv	a0,s0
ffffffffc020a260:	7442                	ld	s0,48(sp)
ffffffffc020a262:	74a2                	ld	s1,40(sp)
ffffffffc020a264:	7902                	ld	s2,32(sp)
ffffffffc020a266:	69e2                	ld	s3,24(sp)
ffffffffc020a268:	6121                	addi	sp,sp,64
ffffffffc020a26a:	8082                	ret
ffffffffc020a26c:	8526                	mv	a0,s1
ffffffffc020a26e:	aeafb0ef          	jal	ra,ffffffffc0205558 <iobuf_skip>
ffffffffc020a272:	b7d5                	j	ffffffffc020a256 <sfs_read+0x50>
ffffffffc020a274:	00005697          	auipc	a3,0x5
ffffffffc020a278:	b8c68693          	addi	a3,a3,-1140 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020a27c:	00002617          	auipc	a2,0x2
ffffffffc020a280:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a284:	29700593          	li	a1,663
ffffffffc020a288:	00005517          	auipc	a0,0x5
ffffffffc020a28c:	d5850513          	addi	a0,a0,-680 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a290:	a0ef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a294:	861ff0ef          	jal	ra,ffffffffc0209af4 <sfs_io.part.0>

ffffffffc020a298 <sfs_write>:
ffffffffc020a298:	7139                	addi	sp,sp,-64
ffffffffc020a29a:	f04a                	sd	s2,32(sp)
ffffffffc020a29c:	06853903          	ld	s2,104(a0)
ffffffffc020a2a0:	fc06                	sd	ra,56(sp)
ffffffffc020a2a2:	f822                	sd	s0,48(sp)
ffffffffc020a2a4:	f426                	sd	s1,40(sp)
ffffffffc020a2a6:	ec4e                	sd	s3,24(sp)
ffffffffc020a2a8:	04090f63          	beqz	s2,ffffffffc020a306 <sfs_write+0x6e>
ffffffffc020a2ac:	0b092783          	lw	a5,176(s2)
ffffffffc020a2b0:	ebb9                	bnez	a5,ffffffffc020a306 <sfs_write+0x6e>
ffffffffc020a2b2:	4d38                	lw	a4,88(a0)
ffffffffc020a2b4:	6785                	lui	a5,0x1
ffffffffc020a2b6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a2ba:	842a                	mv	s0,a0
ffffffffc020a2bc:	06f71563          	bne	a4,a5,ffffffffc020a326 <sfs_write+0x8e>
ffffffffc020a2c0:	02050993          	addi	s3,a0,32
ffffffffc020a2c4:	854e                	mv	a0,s3
ffffffffc020a2c6:	84ae                	mv	s1,a1
ffffffffc020a2c8:	b9cfa0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020a2cc:	0184b803          	ld	a6,24(s1)
ffffffffc020a2d0:	6494                	ld	a3,8(s1)
ffffffffc020a2d2:	6090                	ld	a2,0(s1)
ffffffffc020a2d4:	85a2                	mv	a1,s0
ffffffffc020a2d6:	4785                	li	a5,1
ffffffffc020a2d8:	0038                	addi	a4,sp,8
ffffffffc020a2da:	854a                	mv	a0,s2
ffffffffc020a2dc:	e442                	sd	a6,8(sp)
ffffffffc020a2de:	d4dff0ef          	jal	ra,ffffffffc020a02a <sfs_io_nolock>
ffffffffc020a2e2:	65a2                	ld	a1,8(sp)
ffffffffc020a2e4:	842a                	mv	s0,a0
ffffffffc020a2e6:	ed81                	bnez	a1,ffffffffc020a2fe <sfs_write+0x66>
ffffffffc020a2e8:	854e                	mv	a0,s3
ffffffffc020a2ea:	b76fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a2ee:	70e2                	ld	ra,56(sp)
ffffffffc020a2f0:	8522                	mv	a0,s0
ffffffffc020a2f2:	7442                	ld	s0,48(sp)
ffffffffc020a2f4:	74a2                	ld	s1,40(sp)
ffffffffc020a2f6:	7902                	ld	s2,32(sp)
ffffffffc020a2f8:	69e2                	ld	s3,24(sp)
ffffffffc020a2fa:	6121                	addi	sp,sp,64
ffffffffc020a2fc:	8082                	ret
ffffffffc020a2fe:	8526                	mv	a0,s1
ffffffffc020a300:	a58fb0ef          	jal	ra,ffffffffc0205558 <iobuf_skip>
ffffffffc020a304:	b7d5                	j	ffffffffc020a2e8 <sfs_write+0x50>
ffffffffc020a306:	00005697          	auipc	a3,0x5
ffffffffc020a30a:	afa68693          	addi	a3,a3,-1286 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020a30e:	00002617          	auipc	a2,0x2
ffffffffc020a312:	86a60613          	addi	a2,a2,-1942 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a316:	29700593          	li	a1,663
ffffffffc020a31a:	00005517          	auipc	a0,0x5
ffffffffc020a31e:	cc650513          	addi	a0,a0,-826 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a322:	97cf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a326:	fceff0ef          	jal	ra,ffffffffc0209af4 <sfs_io.part.0>

ffffffffc020a32a <sfs_dirent_read_nolock>:
ffffffffc020a32a:	6198                	ld	a4,0(a1)
ffffffffc020a32c:	7179                	addi	sp,sp,-48
ffffffffc020a32e:	f406                	sd	ra,40(sp)
ffffffffc020a330:	00475883          	lhu	a7,4(a4)
ffffffffc020a334:	f022                	sd	s0,32(sp)
ffffffffc020a336:	ec26                	sd	s1,24(sp)
ffffffffc020a338:	4809                	li	a6,2
ffffffffc020a33a:	05089b63          	bne	a7,a6,ffffffffc020a390 <sfs_dirent_read_nolock+0x66>
ffffffffc020a33e:	4718                	lw	a4,8(a4)
ffffffffc020a340:	87b2                	mv	a5,a2
ffffffffc020a342:	2601                	sext.w	a2,a2
ffffffffc020a344:	04e7f663          	bgeu	a5,a4,ffffffffc020a390 <sfs_dirent_read_nolock+0x66>
ffffffffc020a348:	84b6                	mv	s1,a3
ffffffffc020a34a:	0074                	addi	a3,sp,12
ffffffffc020a34c:	842a                	mv	s0,a0
ffffffffc020a34e:	a85ff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a352:	c511                	beqz	a0,ffffffffc020a35e <sfs_dirent_read_nolock+0x34>
ffffffffc020a354:	70a2                	ld	ra,40(sp)
ffffffffc020a356:	7402                	ld	s0,32(sp)
ffffffffc020a358:	64e2                	ld	s1,24(sp)
ffffffffc020a35a:	6145                	addi	sp,sp,48
ffffffffc020a35c:	8082                	ret
ffffffffc020a35e:	45b2                	lw	a1,12(sp)
ffffffffc020a360:	4054                	lw	a3,4(s0)
ffffffffc020a362:	c5b9                	beqz	a1,ffffffffc020a3b0 <sfs_dirent_read_nolock+0x86>
ffffffffc020a364:	04d5f663          	bgeu	a1,a3,ffffffffc020a3b0 <sfs_dirent_read_nolock+0x86>
ffffffffc020a368:	7c08                	ld	a0,56(s0)
ffffffffc020a36a:	ea1fe0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc020a36e:	ed31                	bnez	a0,ffffffffc020a3ca <sfs_dirent_read_nolock+0xa0>
ffffffffc020a370:	46b2                	lw	a3,12(sp)
ffffffffc020a372:	4701                	li	a4,0
ffffffffc020a374:	10400613          	li	a2,260
ffffffffc020a378:	85a6                	mv	a1,s1
ffffffffc020a37a:	8522                	mv	a0,s0
ffffffffc020a37c:	395000ef          	jal	ra,ffffffffc020af10 <sfs_rbuf>
ffffffffc020a380:	f971                	bnez	a0,ffffffffc020a354 <sfs_dirent_read_nolock+0x2a>
ffffffffc020a382:	100481a3          	sb	zero,259(s1)
ffffffffc020a386:	70a2                	ld	ra,40(sp)
ffffffffc020a388:	7402                	ld	s0,32(sp)
ffffffffc020a38a:	64e2                	ld	s1,24(sp)
ffffffffc020a38c:	6145                	addi	sp,sp,48
ffffffffc020a38e:	8082                	ret
ffffffffc020a390:	00005697          	auipc	a3,0x5
ffffffffc020a394:	de068693          	addi	a3,a3,-544 # ffffffffc020f170 <dev_node_ops+0x750>
ffffffffc020a398:	00001617          	auipc	a2,0x1
ffffffffc020a39c:	7e060613          	addi	a2,a2,2016 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a3a0:	18f00593          	li	a1,399
ffffffffc020a3a4:	00005517          	auipc	a0,0x5
ffffffffc020a3a8:	c3c50513          	addi	a0,a0,-964 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a3ac:	8f2f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a3b0:	872e                	mv	a4,a1
ffffffffc020a3b2:	00005617          	auipc	a2,0x5
ffffffffc020a3b6:	c5e60613          	addi	a2,a2,-930 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc020a3ba:	05400593          	li	a1,84
ffffffffc020a3be:	00005517          	auipc	a0,0x5
ffffffffc020a3c2:	c2250513          	addi	a0,a0,-990 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a3c6:	8d8f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a3ca:	00005697          	auipc	a3,0x5
ffffffffc020a3ce:	c7e68693          	addi	a3,a3,-898 # ffffffffc020f048 <dev_node_ops+0x628>
ffffffffc020a3d2:	00001617          	auipc	a2,0x1
ffffffffc020a3d6:	7a660613          	addi	a2,a2,1958 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a3da:	19600593          	li	a1,406
ffffffffc020a3de:	00005517          	auipc	a0,0x5
ffffffffc020a3e2:	c0250513          	addi	a0,a0,-1022 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a3e6:	8b8f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a3ea <sfs_getdirentry>:
ffffffffc020a3ea:	715d                	addi	sp,sp,-80
ffffffffc020a3ec:	ec56                	sd	s5,24(sp)
ffffffffc020a3ee:	8aaa                	mv	s5,a0
ffffffffc020a3f0:	10400513          	li	a0,260
ffffffffc020a3f4:	e85a                	sd	s6,16(sp)
ffffffffc020a3f6:	e486                	sd	ra,72(sp)
ffffffffc020a3f8:	e0a2                	sd	s0,64(sp)
ffffffffc020a3fa:	fc26                	sd	s1,56(sp)
ffffffffc020a3fc:	f84a                	sd	s2,48(sp)
ffffffffc020a3fe:	f44e                	sd	s3,40(sp)
ffffffffc020a400:	f052                	sd	s4,32(sp)
ffffffffc020a402:	e45e                	sd	s7,8(sp)
ffffffffc020a404:	e062                	sd	s8,0(sp)
ffffffffc020a406:	8b2e                	mv	s6,a1
ffffffffc020a408:	c0ff70ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020a40c:	cd61                	beqz	a0,ffffffffc020a4e4 <sfs_getdirentry+0xfa>
ffffffffc020a40e:	068abb83          	ld	s7,104(s5)
ffffffffc020a412:	0c0b8b63          	beqz	s7,ffffffffc020a4e8 <sfs_getdirentry+0xfe>
ffffffffc020a416:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a41a:	e7f9                	bnez	a5,ffffffffc020a4e8 <sfs_getdirentry+0xfe>
ffffffffc020a41c:	058aa703          	lw	a4,88(s5)
ffffffffc020a420:	6785                	lui	a5,0x1
ffffffffc020a422:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a426:	0ef71163          	bne	a4,a5,ffffffffc020a508 <sfs_getdirentry+0x11e>
ffffffffc020a42a:	008b3983          	ld	s3,8(s6) # 8000008 <_binary_bin_sfs_img_size+0x7f8ad08>
ffffffffc020a42e:	892a                	mv	s2,a0
ffffffffc020a430:	0a09c163          	bltz	s3,ffffffffc020a4d2 <sfs_getdirentry+0xe8>
ffffffffc020a434:	0ff9f793          	zext.b	a5,s3
ffffffffc020a438:	efc9                	bnez	a5,ffffffffc020a4d2 <sfs_getdirentry+0xe8>
ffffffffc020a43a:	000ab783          	ld	a5,0(s5)
ffffffffc020a43e:	0089d993          	srli	s3,s3,0x8
ffffffffc020a442:	2981                	sext.w	s3,s3
ffffffffc020a444:	479c                	lw	a5,8(a5)
ffffffffc020a446:	0937eb63          	bltu	a5,s3,ffffffffc020a4dc <sfs_getdirentry+0xf2>
ffffffffc020a44a:	020a8c13          	addi	s8,s5,32
ffffffffc020a44e:	8562                	mv	a0,s8
ffffffffc020a450:	a14fa0ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020a454:	000ab783          	ld	a5,0(s5)
ffffffffc020a458:	0087aa03          	lw	s4,8(a5)
ffffffffc020a45c:	07405663          	blez	s4,ffffffffc020a4c8 <sfs_getdirentry+0xde>
ffffffffc020a460:	4481                	li	s1,0
ffffffffc020a462:	a811                	j	ffffffffc020a476 <sfs_getdirentry+0x8c>
ffffffffc020a464:	00092783          	lw	a5,0(s2)
ffffffffc020a468:	c781                	beqz	a5,ffffffffc020a470 <sfs_getdirentry+0x86>
ffffffffc020a46a:	02098263          	beqz	s3,ffffffffc020a48e <sfs_getdirentry+0xa4>
ffffffffc020a46e:	39fd                	addiw	s3,s3,-1
ffffffffc020a470:	2485                	addiw	s1,s1,1
ffffffffc020a472:	049a0b63          	beq	s4,s1,ffffffffc020a4c8 <sfs_getdirentry+0xde>
ffffffffc020a476:	86ca                	mv	a3,s2
ffffffffc020a478:	8626                	mv	a2,s1
ffffffffc020a47a:	85d6                	mv	a1,s5
ffffffffc020a47c:	855e                	mv	a0,s7
ffffffffc020a47e:	eadff0ef          	jal	ra,ffffffffc020a32a <sfs_dirent_read_nolock>
ffffffffc020a482:	842a                	mv	s0,a0
ffffffffc020a484:	d165                	beqz	a0,ffffffffc020a464 <sfs_getdirentry+0x7a>
ffffffffc020a486:	8562                	mv	a0,s8
ffffffffc020a488:	9d8fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a48c:	a831                	j	ffffffffc020a4a8 <sfs_getdirentry+0xbe>
ffffffffc020a48e:	8562                	mv	a0,s8
ffffffffc020a490:	9d0fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a494:	4701                	li	a4,0
ffffffffc020a496:	4685                	li	a3,1
ffffffffc020a498:	10000613          	li	a2,256
ffffffffc020a49c:	00490593          	addi	a1,s2,4
ffffffffc020a4a0:	855a                	mv	a0,s6
ffffffffc020a4a2:	84afb0ef          	jal	ra,ffffffffc02054ec <iobuf_move>
ffffffffc020a4a6:	842a                	mv	s0,a0
ffffffffc020a4a8:	854a                	mv	a0,s2
ffffffffc020a4aa:	c1df70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020a4ae:	60a6                	ld	ra,72(sp)
ffffffffc020a4b0:	8522                	mv	a0,s0
ffffffffc020a4b2:	6406                	ld	s0,64(sp)
ffffffffc020a4b4:	74e2                	ld	s1,56(sp)
ffffffffc020a4b6:	7942                	ld	s2,48(sp)
ffffffffc020a4b8:	79a2                	ld	s3,40(sp)
ffffffffc020a4ba:	7a02                	ld	s4,32(sp)
ffffffffc020a4bc:	6ae2                	ld	s5,24(sp)
ffffffffc020a4be:	6b42                	ld	s6,16(sp)
ffffffffc020a4c0:	6ba2                	ld	s7,8(sp)
ffffffffc020a4c2:	6c02                	ld	s8,0(sp)
ffffffffc020a4c4:	6161                	addi	sp,sp,80
ffffffffc020a4c6:	8082                	ret
ffffffffc020a4c8:	8562                	mv	a0,s8
ffffffffc020a4ca:	5441                	li	s0,-16
ffffffffc020a4cc:	994fa0ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a4d0:	bfe1                	j	ffffffffc020a4a8 <sfs_getdirentry+0xbe>
ffffffffc020a4d2:	854a                	mv	a0,s2
ffffffffc020a4d4:	bf3f70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020a4d8:	5475                	li	s0,-3
ffffffffc020a4da:	bfd1                	j	ffffffffc020a4ae <sfs_getdirentry+0xc4>
ffffffffc020a4dc:	bebf70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020a4e0:	5441                	li	s0,-16
ffffffffc020a4e2:	b7f1                	j	ffffffffc020a4ae <sfs_getdirentry+0xc4>
ffffffffc020a4e4:	5471                	li	s0,-4
ffffffffc020a4e6:	b7e1                	j	ffffffffc020a4ae <sfs_getdirentry+0xc4>
ffffffffc020a4e8:	00005697          	auipc	a3,0x5
ffffffffc020a4ec:	91868693          	addi	a3,a3,-1768 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020a4f0:	00001617          	auipc	a2,0x1
ffffffffc020a4f4:	68860613          	addi	a2,a2,1672 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a4f8:	33b00593          	li	a1,827
ffffffffc020a4fc:	00005517          	auipc	a0,0x5
ffffffffc020a500:	ae450513          	addi	a0,a0,-1308 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a504:	f9bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a508:	00005697          	auipc	a3,0x5
ffffffffc020a50c:	aa068693          	addi	a3,a3,-1376 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020a510:	00001617          	auipc	a2,0x1
ffffffffc020a514:	66860613          	addi	a2,a2,1640 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a518:	33c00593          	li	a1,828
ffffffffc020a51c:	00005517          	auipc	a0,0x5
ffffffffc020a520:	ac450513          	addi	a0,a0,-1340 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a524:	f7bf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a528 <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a528:	715d                	addi	sp,sp,-80
ffffffffc020a52a:	f052                	sd	s4,32(sp)
ffffffffc020a52c:	8a2a                	mv	s4,a0
ffffffffc020a52e:	8532                	mv	a0,a2
ffffffffc020a530:	f44e                	sd	s3,40(sp)
ffffffffc020a532:	e85a                	sd	s6,16(sp)
ffffffffc020a534:	e45e                	sd	s7,8(sp)
ffffffffc020a536:	e486                	sd	ra,72(sp)
ffffffffc020a538:	e0a2                	sd	s0,64(sp)
ffffffffc020a53a:	fc26                	sd	s1,56(sp)
ffffffffc020a53c:	f84a                	sd	s2,48(sp)
ffffffffc020a53e:	ec56                	sd	s5,24(sp)
ffffffffc020a540:	e062                	sd	s8,0(sp)
ffffffffc020a542:	8b32                	mv	s6,a2
ffffffffc020a544:	89ae                	mv	s3,a1
ffffffffc020a546:	8bb6                	mv	s7,a3
ffffffffc020a548:	0aa010ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc020a54c:	0ff00793          	li	a5,255
ffffffffc020a550:	06a7ef63          	bltu	a5,a0,ffffffffc020a5ce <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a554:	10400513          	li	a0,260
ffffffffc020a558:	abff70ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020a55c:	892a                	mv	s2,a0
ffffffffc020a55e:	c535                	beqz	a0,ffffffffc020a5ca <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a560:	0009b783          	ld	a5,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020a564:	0087aa83          	lw	s5,8(a5)
ffffffffc020a568:	05505a63          	blez	s5,ffffffffc020a5bc <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a56c:	4481                	li	s1,0
ffffffffc020a56e:	00450c13          	addi	s8,a0,4
ffffffffc020a572:	a829                	j	ffffffffc020a58c <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a574:	00092783          	lw	a5,0(s2)
ffffffffc020a578:	c799                	beqz	a5,ffffffffc020a586 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a57a:	85e2                	mv	a1,s8
ffffffffc020a57c:	855a                	mv	a0,s6
ffffffffc020a57e:	0bc010ef          	jal	ra,ffffffffc020b63a <strcmp>
ffffffffc020a582:	842a                	mv	s0,a0
ffffffffc020a584:	cd15                	beqz	a0,ffffffffc020a5c0 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a586:	2485                	addiw	s1,s1,1
ffffffffc020a588:	029a8a63          	beq	s5,s1,ffffffffc020a5bc <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a58c:	86ca                	mv	a3,s2
ffffffffc020a58e:	8626                	mv	a2,s1
ffffffffc020a590:	85ce                	mv	a1,s3
ffffffffc020a592:	8552                	mv	a0,s4
ffffffffc020a594:	d97ff0ef          	jal	ra,ffffffffc020a32a <sfs_dirent_read_nolock>
ffffffffc020a598:	842a                	mv	s0,a0
ffffffffc020a59a:	dd69                	beqz	a0,ffffffffc020a574 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a59c:	854a                	mv	a0,s2
ffffffffc020a59e:	b29f70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020a5a2:	60a6                	ld	ra,72(sp)
ffffffffc020a5a4:	8522                	mv	a0,s0
ffffffffc020a5a6:	6406                	ld	s0,64(sp)
ffffffffc020a5a8:	74e2                	ld	s1,56(sp)
ffffffffc020a5aa:	7942                	ld	s2,48(sp)
ffffffffc020a5ac:	79a2                	ld	s3,40(sp)
ffffffffc020a5ae:	7a02                	ld	s4,32(sp)
ffffffffc020a5b0:	6ae2                	ld	s5,24(sp)
ffffffffc020a5b2:	6b42                	ld	s6,16(sp)
ffffffffc020a5b4:	6ba2                	ld	s7,8(sp)
ffffffffc020a5b6:	6c02                	ld	s8,0(sp)
ffffffffc020a5b8:	6161                	addi	sp,sp,80
ffffffffc020a5ba:	8082                	ret
ffffffffc020a5bc:	5441                	li	s0,-16
ffffffffc020a5be:	bff9                	j	ffffffffc020a59c <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a5c0:	00092783          	lw	a5,0(s2)
ffffffffc020a5c4:	00fba023          	sw	a5,0(s7)
ffffffffc020a5c8:	bfd1                	j	ffffffffc020a59c <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a5ca:	5471                	li	s0,-4
ffffffffc020a5cc:	bfd9                	j	ffffffffc020a5a2 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a5ce:	00005697          	auipc	a3,0x5
ffffffffc020a5d2:	bf268693          	addi	a3,a3,-1038 # ffffffffc020f1c0 <dev_node_ops+0x7a0>
ffffffffc020a5d6:	00001617          	auipc	a2,0x1
ffffffffc020a5da:	5a260613          	addi	a2,a2,1442 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a5de:	1bb00593          	li	a1,443
ffffffffc020a5e2:	00005517          	auipc	a0,0x5
ffffffffc020a5e6:	9fe50513          	addi	a0,a0,-1538 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a5ea:	eb5f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a5ee <sfs_truncfile>:
ffffffffc020a5ee:	7175                	addi	sp,sp,-144
ffffffffc020a5f0:	e506                	sd	ra,136(sp)
ffffffffc020a5f2:	e122                	sd	s0,128(sp)
ffffffffc020a5f4:	fca6                	sd	s1,120(sp)
ffffffffc020a5f6:	f8ca                	sd	s2,112(sp)
ffffffffc020a5f8:	f4ce                	sd	s3,104(sp)
ffffffffc020a5fa:	f0d2                	sd	s4,96(sp)
ffffffffc020a5fc:	ecd6                	sd	s5,88(sp)
ffffffffc020a5fe:	e8da                	sd	s6,80(sp)
ffffffffc020a600:	e4de                	sd	s7,72(sp)
ffffffffc020a602:	e0e2                	sd	s8,64(sp)
ffffffffc020a604:	fc66                	sd	s9,56(sp)
ffffffffc020a606:	f86a                	sd	s10,48(sp)
ffffffffc020a608:	f46e                	sd	s11,40(sp)
ffffffffc020a60a:	080007b7          	lui	a5,0x8000
ffffffffc020a60e:	16b7e463          	bltu	a5,a1,ffffffffc020a776 <sfs_truncfile+0x188>
ffffffffc020a612:	06853c83          	ld	s9,104(a0)
ffffffffc020a616:	89aa                	mv	s3,a0
ffffffffc020a618:	160c8163          	beqz	s9,ffffffffc020a77a <sfs_truncfile+0x18c>
ffffffffc020a61c:	0b0ca783          	lw	a5,176(s9)
ffffffffc020a620:	14079d63          	bnez	a5,ffffffffc020a77a <sfs_truncfile+0x18c>
ffffffffc020a624:	4d38                	lw	a4,88(a0)
ffffffffc020a626:	6405                	lui	s0,0x1
ffffffffc020a628:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a62c:	16f71763          	bne	a4,a5,ffffffffc020a79a <sfs_truncfile+0x1ac>
ffffffffc020a630:	00053a83          	ld	s5,0(a0)
ffffffffc020a634:	147d                	addi	s0,s0,-1
ffffffffc020a636:	942e                	add	s0,s0,a1
ffffffffc020a638:	000ae783          	lwu	a5,0(s5)
ffffffffc020a63c:	8031                	srli	s0,s0,0xc
ffffffffc020a63e:	8a2e                	mv	s4,a1
ffffffffc020a640:	2401                	sext.w	s0,s0
ffffffffc020a642:	02b79763          	bne	a5,a1,ffffffffc020a670 <sfs_truncfile+0x82>
ffffffffc020a646:	008aa783          	lw	a5,8(s5)
ffffffffc020a64a:	4901                	li	s2,0
ffffffffc020a64c:	18879763          	bne	a5,s0,ffffffffc020a7da <sfs_truncfile+0x1ec>
ffffffffc020a650:	60aa                	ld	ra,136(sp)
ffffffffc020a652:	640a                	ld	s0,128(sp)
ffffffffc020a654:	74e6                	ld	s1,120(sp)
ffffffffc020a656:	79a6                	ld	s3,104(sp)
ffffffffc020a658:	7a06                	ld	s4,96(sp)
ffffffffc020a65a:	6ae6                	ld	s5,88(sp)
ffffffffc020a65c:	6b46                	ld	s6,80(sp)
ffffffffc020a65e:	6ba6                	ld	s7,72(sp)
ffffffffc020a660:	6c06                	ld	s8,64(sp)
ffffffffc020a662:	7ce2                	ld	s9,56(sp)
ffffffffc020a664:	7d42                	ld	s10,48(sp)
ffffffffc020a666:	7da2                	ld	s11,40(sp)
ffffffffc020a668:	854a                	mv	a0,s2
ffffffffc020a66a:	7946                	ld	s2,112(sp)
ffffffffc020a66c:	6149                	addi	sp,sp,144
ffffffffc020a66e:	8082                	ret
ffffffffc020a670:	02050b13          	addi	s6,a0,32
ffffffffc020a674:	855a                	mv	a0,s6
ffffffffc020a676:	feff90ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020a67a:	008aa483          	lw	s1,8(s5)
ffffffffc020a67e:	0a84e663          	bltu	s1,s0,ffffffffc020a72a <sfs_truncfile+0x13c>
ffffffffc020a682:	0c947163          	bgeu	s0,s1,ffffffffc020a744 <sfs_truncfile+0x156>
ffffffffc020a686:	4dad                	li	s11,11
ffffffffc020a688:	4b85                	li	s7,1
ffffffffc020a68a:	a09d                	j	ffffffffc020a6f0 <sfs_truncfile+0x102>
ffffffffc020a68c:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a690:	0009079b          	sext.w	a5,s2
ffffffffc020a694:	3ff00713          	li	a4,1023
ffffffffc020a698:	04f76563          	bltu	a4,a5,ffffffffc020a6e2 <sfs_truncfile+0xf4>
ffffffffc020a69c:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a6a0:	040c0163          	beqz	s8,ffffffffc020a6e2 <sfs_truncfile+0xf4>
ffffffffc020a6a4:	004ca783          	lw	a5,4(s9)
ffffffffc020a6a8:	18fc7963          	bgeu	s8,a5,ffffffffc020a83a <sfs_truncfile+0x24c>
ffffffffc020a6ac:	038cb503          	ld	a0,56(s9)
ffffffffc020a6b0:	85e2                	mv	a1,s8
ffffffffc020a6b2:	b59fe0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc020a6b6:	16051263          	bnez	a0,ffffffffc020a81a <sfs_truncfile+0x22c>
ffffffffc020a6ba:	02091793          	slli	a5,s2,0x20
ffffffffc020a6be:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a6c2:	86e2                	mv	a3,s8
ffffffffc020a6c4:	4611                	li	a2,4
ffffffffc020a6c6:	082c                	addi	a1,sp,24
ffffffffc020a6c8:	8566                	mv	a0,s9
ffffffffc020a6ca:	e43a                	sd	a4,8(sp)
ffffffffc020a6cc:	ce02                	sw	zero,28(sp)
ffffffffc020a6ce:	043000ef          	jal	ra,ffffffffc020af10 <sfs_rbuf>
ffffffffc020a6d2:	892a                	mv	s2,a0
ffffffffc020a6d4:	e141                	bnez	a0,ffffffffc020a754 <sfs_truncfile+0x166>
ffffffffc020a6d6:	47e2                	lw	a5,24(sp)
ffffffffc020a6d8:	6722                	ld	a4,8(sp)
ffffffffc020a6da:	e3c9                	bnez	a5,ffffffffc020a75c <sfs_truncfile+0x16e>
ffffffffc020a6dc:	008d2603          	lw	a2,8(s10)
ffffffffc020a6e0:	367d                	addiw	a2,a2,-1
ffffffffc020a6e2:	00cd2423          	sw	a2,8(s10)
ffffffffc020a6e6:	0179b823          	sd	s7,16(s3)
ffffffffc020a6ea:	34fd                	addiw	s1,s1,-1
ffffffffc020a6ec:	04940a63          	beq	s0,s1,ffffffffc020a740 <sfs_truncfile+0x152>
ffffffffc020a6f0:	0009bd03          	ld	s10,0(s3)
ffffffffc020a6f4:	008d2703          	lw	a4,8(s10)
ffffffffc020a6f8:	c369                	beqz	a4,ffffffffc020a7ba <sfs_truncfile+0x1cc>
ffffffffc020a6fa:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a6fe:	0007861b          	sext.w	a2,a5
ffffffffc020a702:	f8cde5e3          	bltu	s11,a2,ffffffffc020a68c <sfs_truncfile+0x9e>
ffffffffc020a706:	02079713          	slli	a4,a5,0x20
ffffffffc020a70a:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a70e:	00fd0933          	add	s2,s10,a5
ffffffffc020a712:	00c92583          	lw	a1,12(s2)
ffffffffc020a716:	d5f1                	beqz	a1,ffffffffc020a6e2 <sfs_truncfile+0xf4>
ffffffffc020a718:	8566                	mv	a0,s9
ffffffffc020a71a:	bfeff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc020a71e:	00092623          	sw	zero,12(s2)
ffffffffc020a722:	008d2603          	lw	a2,8(s10)
ffffffffc020a726:	367d                	addiw	a2,a2,-1
ffffffffc020a728:	bf6d                	j	ffffffffc020a6e2 <sfs_truncfile+0xf4>
ffffffffc020a72a:	4681                	li	a3,0
ffffffffc020a72c:	8626                	mv	a2,s1
ffffffffc020a72e:	85ce                	mv	a1,s3
ffffffffc020a730:	8566                	mv	a0,s9
ffffffffc020a732:	ea0ff0ef          	jal	ra,ffffffffc0209dd2 <sfs_bmap_load_nolock>
ffffffffc020a736:	892a                	mv	s2,a0
ffffffffc020a738:	ed11                	bnez	a0,ffffffffc020a754 <sfs_truncfile+0x166>
ffffffffc020a73a:	2485                	addiw	s1,s1,1
ffffffffc020a73c:	fe9417e3          	bne	s0,s1,ffffffffc020a72a <sfs_truncfile+0x13c>
ffffffffc020a740:	008aa483          	lw	s1,8(s5)
ffffffffc020a744:	0a941b63          	bne	s0,s1,ffffffffc020a7fa <sfs_truncfile+0x20c>
ffffffffc020a748:	014aa023          	sw	s4,0(s5)
ffffffffc020a74c:	4785                	li	a5,1
ffffffffc020a74e:	00f9b823          	sd	a5,16(s3)
ffffffffc020a752:	4901                	li	s2,0
ffffffffc020a754:	855a                	mv	a0,s6
ffffffffc020a756:	f0bf90ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020a75a:	bddd                	j	ffffffffc020a650 <sfs_truncfile+0x62>
ffffffffc020a75c:	86e2                	mv	a3,s8
ffffffffc020a75e:	4611                	li	a2,4
ffffffffc020a760:	086c                	addi	a1,sp,28
ffffffffc020a762:	8566                	mv	a0,s9
ffffffffc020a764:	02d000ef          	jal	ra,ffffffffc020af90 <sfs_wbuf>
ffffffffc020a768:	892a                	mv	s2,a0
ffffffffc020a76a:	f56d                	bnez	a0,ffffffffc020a754 <sfs_truncfile+0x166>
ffffffffc020a76c:	45e2                	lw	a1,24(sp)
ffffffffc020a76e:	8566                	mv	a0,s9
ffffffffc020a770:	ba8ff0ef          	jal	ra,ffffffffc0209b18 <sfs_block_free>
ffffffffc020a774:	b7a5                	j	ffffffffc020a6dc <sfs_truncfile+0xee>
ffffffffc020a776:	5975                	li	s2,-3
ffffffffc020a778:	bde1                	j	ffffffffc020a650 <sfs_truncfile+0x62>
ffffffffc020a77a:	00004697          	auipc	a3,0x4
ffffffffc020a77e:	68668693          	addi	a3,a3,1670 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020a782:	00001617          	auipc	a2,0x1
ffffffffc020a786:	3f660613          	addi	a2,a2,1014 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a78a:	3aa00593          	li	a1,938
ffffffffc020a78e:	00005517          	auipc	a0,0x5
ffffffffc020a792:	85250513          	addi	a0,a0,-1966 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a796:	d09f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a79a:	00005697          	auipc	a3,0x5
ffffffffc020a79e:	80e68693          	addi	a3,a3,-2034 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020a7a2:	00001617          	auipc	a2,0x1
ffffffffc020a7a6:	3d660613          	addi	a2,a2,982 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a7aa:	3ab00593          	li	a1,939
ffffffffc020a7ae:	00005517          	auipc	a0,0x5
ffffffffc020a7b2:	83250513          	addi	a0,a0,-1998 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a7b6:	ce9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7ba:	00005697          	auipc	a3,0x5
ffffffffc020a7be:	a4668693          	addi	a3,a3,-1466 # ffffffffc020f200 <dev_node_ops+0x7e0>
ffffffffc020a7c2:	00001617          	auipc	a2,0x1
ffffffffc020a7c6:	3b660613          	addi	a2,a2,950 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a7ca:	17c00593          	li	a1,380
ffffffffc020a7ce:	00005517          	auipc	a0,0x5
ffffffffc020a7d2:	81250513          	addi	a0,a0,-2030 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a7d6:	cc9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7da:	00005697          	auipc	a3,0x5
ffffffffc020a7de:	a0e68693          	addi	a3,a3,-1522 # ffffffffc020f1e8 <dev_node_ops+0x7c8>
ffffffffc020a7e2:	00001617          	auipc	a2,0x1
ffffffffc020a7e6:	39660613          	addi	a2,a2,918 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a7ea:	3b200593          	li	a1,946
ffffffffc020a7ee:	00004517          	auipc	a0,0x4
ffffffffc020a7f2:	7f250513          	addi	a0,a0,2034 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a7f6:	ca9f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a7fa:	00005697          	auipc	a3,0x5
ffffffffc020a7fe:	a5668693          	addi	a3,a3,-1450 # ffffffffc020f250 <dev_node_ops+0x830>
ffffffffc020a802:	00001617          	auipc	a2,0x1
ffffffffc020a806:	37660613          	addi	a2,a2,886 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a80a:	3cb00593          	li	a1,971
ffffffffc020a80e:	00004517          	auipc	a0,0x4
ffffffffc020a812:	7d250513          	addi	a0,a0,2002 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a816:	c89f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a81a:	00005697          	auipc	a3,0x5
ffffffffc020a81e:	9fe68693          	addi	a3,a3,-1538 # ffffffffc020f218 <dev_node_ops+0x7f8>
ffffffffc020a822:	00001617          	auipc	a2,0x1
ffffffffc020a826:	35660613          	addi	a2,a2,854 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a82a:	12c00593          	li	a1,300
ffffffffc020a82e:	00004517          	auipc	a0,0x4
ffffffffc020a832:	7b250513          	addi	a0,a0,1970 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a836:	c69f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a83a:	8762                	mv	a4,s8
ffffffffc020a83c:	86be                	mv	a3,a5
ffffffffc020a83e:	00004617          	auipc	a2,0x4
ffffffffc020a842:	7d260613          	addi	a2,a2,2002 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc020a846:	05400593          	li	a1,84
ffffffffc020a84a:	00004517          	auipc	a0,0x4
ffffffffc020a84e:	79650513          	addi	a0,a0,1942 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020a852:	c4df50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a856 <sfs_load_inode>:
ffffffffc020a856:	7139                	addi	sp,sp,-64
ffffffffc020a858:	fc06                	sd	ra,56(sp)
ffffffffc020a85a:	f822                	sd	s0,48(sp)
ffffffffc020a85c:	f426                	sd	s1,40(sp)
ffffffffc020a85e:	f04a                	sd	s2,32(sp)
ffffffffc020a860:	84b2                	mv	s1,a2
ffffffffc020a862:	892a                	mv	s2,a0
ffffffffc020a864:	ec4e                	sd	s3,24(sp)
ffffffffc020a866:	e852                	sd	s4,16(sp)
ffffffffc020a868:	89ae                	mv	s3,a1
ffffffffc020a86a:	e456                	sd	s5,8(sp)
ffffffffc020a86c:	0d5000ef          	jal	ra,ffffffffc020b140 <lock_sfs_fs>
ffffffffc020a870:	45a9                	li	a1,10
ffffffffc020a872:	8526                	mv	a0,s1
ffffffffc020a874:	0a893403          	ld	s0,168(s2)
ffffffffc020a878:	0e9000ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc020a87c:	02051793          	slli	a5,a0,0x20
ffffffffc020a880:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a884:	9722                	add	a4,a4,s0
ffffffffc020a886:	843a                	mv	s0,a4
ffffffffc020a888:	a029                	j	ffffffffc020a892 <sfs_load_inode+0x3c>
ffffffffc020a88a:	fc042783          	lw	a5,-64(s0)
ffffffffc020a88e:	10978863          	beq	a5,s1,ffffffffc020a99e <sfs_load_inode+0x148>
ffffffffc020a892:	6400                	ld	s0,8(s0)
ffffffffc020a894:	fe871be3          	bne	a4,s0,ffffffffc020a88a <sfs_load_inode+0x34>
ffffffffc020a898:	04000513          	li	a0,64
ffffffffc020a89c:	f7af70ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020a8a0:	8aaa                	mv	s5,a0
ffffffffc020a8a2:	16050563          	beqz	a0,ffffffffc020aa0c <sfs_load_inode+0x1b6>
ffffffffc020a8a6:	00492683          	lw	a3,4(s2)
ffffffffc020a8aa:	18048363          	beqz	s1,ffffffffc020aa30 <sfs_load_inode+0x1da>
ffffffffc020a8ae:	18d4f163          	bgeu	s1,a3,ffffffffc020aa30 <sfs_load_inode+0x1da>
ffffffffc020a8b2:	03893503          	ld	a0,56(s2)
ffffffffc020a8b6:	85a6                	mv	a1,s1
ffffffffc020a8b8:	953fe0ef          	jal	ra,ffffffffc020920a <bitmap_test>
ffffffffc020a8bc:	18051763          	bnez	a0,ffffffffc020aa4a <sfs_load_inode+0x1f4>
ffffffffc020a8c0:	4701                	li	a4,0
ffffffffc020a8c2:	86a6                	mv	a3,s1
ffffffffc020a8c4:	04000613          	li	a2,64
ffffffffc020a8c8:	85d6                	mv	a1,s5
ffffffffc020a8ca:	854a                	mv	a0,s2
ffffffffc020a8cc:	644000ef          	jal	ra,ffffffffc020af10 <sfs_rbuf>
ffffffffc020a8d0:	842a                	mv	s0,a0
ffffffffc020a8d2:	0e051563          	bnez	a0,ffffffffc020a9bc <sfs_load_inode+0x166>
ffffffffc020a8d6:	006ad783          	lhu	a5,6(s5)
ffffffffc020a8da:	12078b63          	beqz	a5,ffffffffc020aa10 <sfs_load_inode+0x1ba>
ffffffffc020a8de:	6405                	lui	s0,0x1
ffffffffc020a8e0:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a8e4:	8e0fd0ef          	jal	ra,ffffffffc02079c4 <__alloc_inode>
ffffffffc020a8e8:	8a2a                	mv	s4,a0
ffffffffc020a8ea:	c961                	beqz	a0,ffffffffc020a9ba <sfs_load_inode+0x164>
ffffffffc020a8ec:	004ad683          	lhu	a3,4(s5)
ffffffffc020a8f0:	4785                	li	a5,1
ffffffffc020a8f2:	0cf69c63          	bne	a3,a5,ffffffffc020a9ca <sfs_load_inode+0x174>
ffffffffc020a8f6:	864a                	mv	a2,s2
ffffffffc020a8f8:	00005597          	auipc	a1,0x5
ffffffffc020a8fc:	a6858593          	addi	a1,a1,-1432 # ffffffffc020f360 <sfs_node_fileops>
ffffffffc020a900:	8e0fd0ef          	jal	ra,ffffffffc02079e0 <inode_init>
ffffffffc020a904:	058a2783          	lw	a5,88(s4)
ffffffffc020a908:	23540413          	addi	s0,s0,565
ffffffffc020a90c:	0e879063          	bne	a5,s0,ffffffffc020a9ec <sfs_load_inode+0x196>
ffffffffc020a910:	4785                	li	a5,1
ffffffffc020a912:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a916:	015a3023          	sd	s5,0(s4)
ffffffffc020a91a:	009a2423          	sw	s1,8(s4)
ffffffffc020a91e:	000a3823          	sd	zero,16(s4)
ffffffffc020a922:	4585                	li	a1,1
ffffffffc020a924:	020a0513          	addi	a0,s4,32
ffffffffc020a928:	d33f90ef          	jal	ra,ffffffffc020465a <sem_init>
ffffffffc020a92c:	058a2703          	lw	a4,88(s4)
ffffffffc020a930:	6785                	lui	a5,0x1
ffffffffc020a932:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a936:	14f71663          	bne	a4,a5,ffffffffc020aa82 <sfs_load_inode+0x22c>
ffffffffc020a93a:	0a093703          	ld	a4,160(s2)
ffffffffc020a93e:	038a0793          	addi	a5,s4,56
ffffffffc020a942:	008a2503          	lw	a0,8(s4)
ffffffffc020a946:	e31c                	sd	a5,0(a4)
ffffffffc020a948:	0af93023          	sd	a5,160(s2)
ffffffffc020a94c:	09890793          	addi	a5,s2,152
ffffffffc020a950:	0a893403          	ld	s0,168(s2)
ffffffffc020a954:	45a9                	li	a1,10
ffffffffc020a956:	04ea3023          	sd	a4,64(s4)
ffffffffc020a95a:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a95e:	003000ef          	jal	ra,ffffffffc020b160 <hash32>
ffffffffc020a962:	02051713          	slli	a4,a0,0x20
ffffffffc020a966:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a96a:	97a2                	add	a5,a5,s0
ffffffffc020a96c:	6798                	ld	a4,8(a5)
ffffffffc020a96e:	048a0693          	addi	a3,s4,72
ffffffffc020a972:	e314                	sd	a3,0(a4)
ffffffffc020a974:	e794                	sd	a3,8(a5)
ffffffffc020a976:	04ea3823          	sd	a4,80(s4)
ffffffffc020a97a:	04fa3423          	sd	a5,72(s4)
ffffffffc020a97e:	854a                	mv	a0,s2
ffffffffc020a980:	7d0000ef          	jal	ra,ffffffffc020b150 <unlock_sfs_fs>
ffffffffc020a984:	4401                	li	s0,0
ffffffffc020a986:	0149b023          	sd	s4,0(s3)
ffffffffc020a98a:	70e2                	ld	ra,56(sp)
ffffffffc020a98c:	8522                	mv	a0,s0
ffffffffc020a98e:	7442                	ld	s0,48(sp)
ffffffffc020a990:	74a2                	ld	s1,40(sp)
ffffffffc020a992:	7902                	ld	s2,32(sp)
ffffffffc020a994:	69e2                	ld	s3,24(sp)
ffffffffc020a996:	6a42                	ld	s4,16(sp)
ffffffffc020a998:	6aa2                	ld	s5,8(sp)
ffffffffc020a99a:	6121                	addi	sp,sp,64
ffffffffc020a99c:	8082                	ret
ffffffffc020a99e:	fb840a13          	addi	s4,s0,-72
ffffffffc020a9a2:	8552                	mv	a0,s4
ffffffffc020a9a4:	89efd0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc020a9a8:	4785                	li	a5,1
ffffffffc020a9aa:	fcf51ae3          	bne	a0,a5,ffffffffc020a97e <sfs_load_inode+0x128>
ffffffffc020a9ae:	fd042783          	lw	a5,-48(s0)
ffffffffc020a9b2:	2785                	addiw	a5,a5,1
ffffffffc020a9b4:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a9b8:	b7d9                	j	ffffffffc020a97e <sfs_load_inode+0x128>
ffffffffc020a9ba:	5471                	li	s0,-4
ffffffffc020a9bc:	8556                	mv	a0,s5
ffffffffc020a9be:	f08f70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020a9c2:	854a                	mv	a0,s2
ffffffffc020a9c4:	78c000ef          	jal	ra,ffffffffc020b150 <unlock_sfs_fs>
ffffffffc020a9c8:	b7c9                	j	ffffffffc020a98a <sfs_load_inode+0x134>
ffffffffc020a9ca:	4789                	li	a5,2
ffffffffc020a9cc:	08f69f63          	bne	a3,a5,ffffffffc020aa6a <sfs_load_inode+0x214>
ffffffffc020a9d0:	864a                	mv	a2,s2
ffffffffc020a9d2:	00005597          	auipc	a1,0x5
ffffffffc020a9d6:	90e58593          	addi	a1,a1,-1778 # ffffffffc020f2e0 <sfs_node_dirops>
ffffffffc020a9da:	806fd0ef          	jal	ra,ffffffffc02079e0 <inode_init>
ffffffffc020a9de:	058a2703          	lw	a4,88(s4)
ffffffffc020a9e2:	6785                	lui	a5,0x1
ffffffffc020a9e4:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a9e8:	f2f704e3          	beq	a4,a5,ffffffffc020a910 <sfs_load_inode+0xba>
ffffffffc020a9ec:	00004697          	auipc	a3,0x4
ffffffffc020a9f0:	5bc68693          	addi	a3,a3,1468 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020a9f4:	00001617          	auipc	a2,0x1
ffffffffc020a9f8:	18460613          	addi	a2,a2,388 # ffffffffc020bb78 <commands+0x210>
ffffffffc020a9fc:	07800593          	li	a1,120
ffffffffc020aa00:	00004517          	auipc	a0,0x4
ffffffffc020aa04:	5e050513          	addi	a0,a0,1504 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa08:	a97f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa0c:	5471                	li	s0,-4
ffffffffc020aa0e:	bf55                	j	ffffffffc020a9c2 <sfs_load_inode+0x16c>
ffffffffc020aa10:	00005697          	auipc	a3,0x5
ffffffffc020aa14:	85868693          	addi	a3,a3,-1960 # ffffffffc020f268 <dev_node_ops+0x848>
ffffffffc020aa18:	00001617          	auipc	a2,0x1
ffffffffc020aa1c:	16060613          	addi	a2,a2,352 # ffffffffc020bb78 <commands+0x210>
ffffffffc020aa20:	0ae00593          	li	a1,174
ffffffffc020aa24:	00004517          	auipc	a0,0x4
ffffffffc020aa28:	5bc50513          	addi	a0,a0,1468 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa2c:	a73f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa30:	8726                	mv	a4,s1
ffffffffc020aa32:	00004617          	auipc	a2,0x4
ffffffffc020aa36:	5de60613          	addi	a2,a2,1502 # ffffffffc020f010 <dev_node_ops+0x5f0>
ffffffffc020aa3a:	05400593          	li	a1,84
ffffffffc020aa3e:	00004517          	auipc	a0,0x4
ffffffffc020aa42:	5a250513          	addi	a0,a0,1442 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa46:	a59f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa4a:	00004697          	auipc	a3,0x4
ffffffffc020aa4e:	5fe68693          	addi	a3,a3,1534 # ffffffffc020f048 <dev_node_ops+0x628>
ffffffffc020aa52:	00001617          	auipc	a2,0x1
ffffffffc020aa56:	12660613          	addi	a2,a2,294 # ffffffffc020bb78 <commands+0x210>
ffffffffc020aa5a:	0a900593          	li	a1,169
ffffffffc020aa5e:	00004517          	auipc	a0,0x4
ffffffffc020aa62:	58250513          	addi	a0,a0,1410 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa66:	a39f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa6a:	00004617          	auipc	a2,0x4
ffffffffc020aa6e:	58e60613          	addi	a2,a2,1422 # ffffffffc020eff8 <dev_node_ops+0x5d8>
ffffffffc020aa72:	02f00593          	li	a1,47
ffffffffc020aa76:	00004517          	auipc	a0,0x4
ffffffffc020aa7a:	56a50513          	addi	a0,a0,1386 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa7e:	a21f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa82:	00004697          	auipc	a3,0x4
ffffffffc020aa86:	52668693          	addi	a3,a3,1318 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020aa8a:	00001617          	auipc	a2,0x1
ffffffffc020aa8e:	0ee60613          	addi	a2,a2,238 # ffffffffc020bb78 <commands+0x210>
ffffffffc020aa92:	0b200593          	li	a1,178
ffffffffc020aa96:	00004517          	auipc	a0,0x4
ffffffffc020aa9a:	54a50513          	addi	a0,a0,1354 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aa9e:	a01f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020aaa2 <sfs_lookup>:
ffffffffc020aaa2:	7139                	addi	sp,sp,-64
ffffffffc020aaa4:	ec4e                	sd	s3,24(sp)
ffffffffc020aaa6:	06853983          	ld	s3,104(a0)
ffffffffc020aaaa:	fc06                	sd	ra,56(sp)
ffffffffc020aaac:	f822                	sd	s0,48(sp)
ffffffffc020aaae:	f426                	sd	s1,40(sp)
ffffffffc020aab0:	f04a                	sd	s2,32(sp)
ffffffffc020aab2:	e852                	sd	s4,16(sp)
ffffffffc020aab4:	0a098c63          	beqz	s3,ffffffffc020ab6c <sfs_lookup+0xca>
ffffffffc020aab8:	0b09a783          	lw	a5,176(s3)
ffffffffc020aabc:	ebc5                	bnez	a5,ffffffffc020ab6c <sfs_lookup+0xca>
ffffffffc020aabe:	0005c783          	lbu	a5,0(a1)
ffffffffc020aac2:	84ae                	mv	s1,a1
ffffffffc020aac4:	c7c1                	beqz	a5,ffffffffc020ab4c <sfs_lookup+0xaa>
ffffffffc020aac6:	02f00713          	li	a4,47
ffffffffc020aaca:	08e78163          	beq	a5,a4,ffffffffc020ab4c <sfs_lookup+0xaa>
ffffffffc020aace:	842a                	mv	s0,a0
ffffffffc020aad0:	8a32                	mv	s4,a2
ffffffffc020aad2:	f71fc0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc020aad6:	4c38                	lw	a4,88(s0)
ffffffffc020aad8:	6785                	lui	a5,0x1
ffffffffc020aada:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aade:	0af71763          	bne	a4,a5,ffffffffc020ab8c <sfs_lookup+0xea>
ffffffffc020aae2:	6018                	ld	a4,0(s0)
ffffffffc020aae4:	4789                	li	a5,2
ffffffffc020aae6:	00475703          	lhu	a4,4(a4)
ffffffffc020aaea:	04f71c63          	bne	a4,a5,ffffffffc020ab42 <sfs_lookup+0xa0>
ffffffffc020aaee:	02040913          	addi	s2,s0,32
ffffffffc020aaf2:	854a                	mv	a0,s2
ffffffffc020aaf4:	b71f90ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020aaf8:	8626                	mv	a2,s1
ffffffffc020aafa:	0054                	addi	a3,sp,4
ffffffffc020aafc:	85a2                	mv	a1,s0
ffffffffc020aafe:	854e                	mv	a0,s3
ffffffffc020ab00:	a29ff0ef          	jal	ra,ffffffffc020a528 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020ab04:	84aa                	mv	s1,a0
ffffffffc020ab06:	854a                	mv	a0,s2
ffffffffc020ab08:	b59f90ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020ab0c:	cc89                	beqz	s1,ffffffffc020ab26 <sfs_lookup+0x84>
ffffffffc020ab0e:	8522                	mv	a0,s0
ffffffffc020ab10:	800fd0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ab14:	70e2                	ld	ra,56(sp)
ffffffffc020ab16:	7442                	ld	s0,48(sp)
ffffffffc020ab18:	7902                	ld	s2,32(sp)
ffffffffc020ab1a:	69e2                	ld	s3,24(sp)
ffffffffc020ab1c:	6a42                	ld	s4,16(sp)
ffffffffc020ab1e:	8526                	mv	a0,s1
ffffffffc020ab20:	74a2                	ld	s1,40(sp)
ffffffffc020ab22:	6121                	addi	sp,sp,64
ffffffffc020ab24:	8082                	ret
ffffffffc020ab26:	4612                	lw	a2,4(sp)
ffffffffc020ab28:	002c                	addi	a1,sp,8
ffffffffc020ab2a:	854e                	mv	a0,s3
ffffffffc020ab2c:	d2bff0ef          	jal	ra,ffffffffc020a856 <sfs_load_inode>
ffffffffc020ab30:	84aa                	mv	s1,a0
ffffffffc020ab32:	8522                	mv	a0,s0
ffffffffc020ab34:	fddfc0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ab38:	fcf1                	bnez	s1,ffffffffc020ab14 <sfs_lookup+0x72>
ffffffffc020ab3a:	67a2                	ld	a5,8(sp)
ffffffffc020ab3c:	00fa3023          	sd	a5,0(s4)
ffffffffc020ab40:	bfd1                	j	ffffffffc020ab14 <sfs_lookup+0x72>
ffffffffc020ab42:	8522                	mv	a0,s0
ffffffffc020ab44:	fcdfc0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ab48:	54b9                	li	s1,-18
ffffffffc020ab4a:	b7e9                	j	ffffffffc020ab14 <sfs_lookup+0x72>
ffffffffc020ab4c:	00004697          	auipc	a3,0x4
ffffffffc020ab50:	73468693          	addi	a3,a3,1844 # ffffffffc020f280 <dev_node_ops+0x860>
ffffffffc020ab54:	00001617          	auipc	a2,0x1
ffffffffc020ab58:	02460613          	addi	a2,a2,36 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ab5c:	3dc00593          	li	a1,988
ffffffffc020ab60:	00004517          	auipc	a0,0x4
ffffffffc020ab64:	48050513          	addi	a0,a0,1152 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020ab68:	937f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab6c:	00004697          	auipc	a3,0x4
ffffffffc020ab70:	29468693          	addi	a3,a3,660 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020ab74:	00001617          	auipc	a2,0x1
ffffffffc020ab78:	00460613          	addi	a2,a2,4 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ab7c:	3db00593          	li	a1,987
ffffffffc020ab80:	00004517          	auipc	a0,0x4
ffffffffc020ab84:	46050513          	addi	a0,a0,1120 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020ab88:	917f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ab8c:	00004697          	auipc	a3,0x4
ffffffffc020ab90:	41c68693          	addi	a3,a3,1052 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020ab94:	00001617          	auipc	a2,0x1
ffffffffc020ab98:	fe460613          	addi	a2,a2,-28 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ab9c:	3de00593          	li	a1,990
ffffffffc020aba0:	00004517          	auipc	a0,0x4
ffffffffc020aba4:	44050513          	addi	a0,a0,1088 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020aba8:	8f7f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020abac <sfs_namefile>:
ffffffffc020abac:	6d98                	ld	a4,24(a1)
ffffffffc020abae:	7175                	addi	sp,sp,-144
ffffffffc020abb0:	e506                	sd	ra,136(sp)
ffffffffc020abb2:	e122                	sd	s0,128(sp)
ffffffffc020abb4:	fca6                	sd	s1,120(sp)
ffffffffc020abb6:	f8ca                	sd	s2,112(sp)
ffffffffc020abb8:	f4ce                	sd	s3,104(sp)
ffffffffc020abba:	f0d2                	sd	s4,96(sp)
ffffffffc020abbc:	ecd6                	sd	s5,88(sp)
ffffffffc020abbe:	e8da                	sd	s6,80(sp)
ffffffffc020abc0:	e4de                	sd	s7,72(sp)
ffffffffc020abc2:	e0e2                	sd	s8,64(sp)
ffffffffc020abc4:	fc66                	sd	s9,56(sp)
ffffffffc020abc6:	f86a                	sd	s10,48(sp)
ffffffffc020abc8:	f46e                	sd	s11,40(sp)
ffffffffc020abca:	e42e                	sd	a1,8(sp)
ffffffffc020abcc:	4789                	li	a5,2
ffffffffc020abce:	1ae7f363          	bgeu	a5,a4,ffffffffc020ad74 <sfs_namefile+0x1c8>
ffffffffc020abd2:	89aa                	mv	s3,a0
ffffffffc020abd4:	10400513          	li	a0,260
ffffffffc020abd8:	c3ef70ef          	jal	ra,ffffffffc0202016 <kmalloc>
ffffffffc020abdc:	842a                	mv	s0,a0
ffffffffc020abde:	18050b63          	beqz	a0,ffffffffc020ad74 <sfs_namefile+0x1c8>
ffffffffc020abe2:	0689b483          	ld	s1,104(s3)
ffffffffc020abe6:	1e048963          	beqz	s1,ffffffffc020add8 <sfs_namefile+0x22c>
ffffffffc020abea:	0b04a783          	lw	a5,176(s1)
ffffffffc020abee:	1e079563          	bnez	a5,ffffffffc020add8 <sfs_namefile+0x22c>
ffffffffc020abf2:	0589ac83          	lw	s9,88(s3)
ffffffffc020abf6:	6785                	lui	a5,0x1
ffffffffc020abf8:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020abfc:	1afc9e63          	bne	s9,a5,ffffffffc020adb8 <sfs_namefile+0x20c>
ffffffffc020ac00:	6722                	ld	a4,8(sp)
ffffffffc020ac02:	854e                	mv	a0,s3
ffffffffc020ac04:	8ace                	mv	s5,s3
ffffffffc020ac06:	6f1c                	ld	a5,24(a4)
ffffffffc020ac08:	00073b03          	ld	s6,0(a4)
ffffffffc020ac0c:	02098a13          	addi	s4,s3,32
ffffffffc020ac10:	ffe78b93          	addi	s7,a5,-2
ffffffffc020ac14:	9b3e                	add	s6,s6,a5
ffffffffc020ac16:	00004d17          	auipc	s10,0x4
ffffffffc020ac1a:	68ad0d13          	addi	s10,s10,1674 # ffffffffc020f2a0 <dev_node_ops+0x880>
ffffffffc020ac1e:	e25fc0ef          	jal	ra,ffffffffc0207a42 <inode_ref_inc>
ffffffffc020ac22:	00440c13          	addi	s8,s0,4
ffffffffc020ac26:	e066                	sd	s9,0(sp)
ffffffffc020ac28:	8552                	mv	a0,s4
ffffffffc020ac2a:	a3bf90ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020ac2e:	0854                	addi	a3,sp,20
ffffffffc020ac30:	866a                	mv	a2,s10
ffffffffc020ac32:	85d6                	mv	a1,s5
ffffffffc020ac34:	8526                	mv	a0,s1
ffffffffc020ac36:	8f3ff0ef          	jal	ra,ffffffffc020a528 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020ac3a:	8daa                	mv	s11,a0
ffffffffc020ac3c:	8552                	mv	a0,s4
ffffffffc020ac3e:	a23f90ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020ac42:	020d8863          	beqz	s11,ffffffffc020ac72 <sfs_namefile+0xc6>
ffffffffc020ac46:	854e                	mv	a0,s3
ffffffffc020ac48:	ec9fc0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ac4c:	8522                	mv	a0,s0
ffffffffc020ac4e:	c78f70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020ac52:	60aa                	ld	ra,136(sp)
ffffffffc020ac54:	640a                	ld	s0,128(sp)
ffffffffc020ac56:	74e6                	ld	s1,120(sp)
ffffffffc020ac58:	7946                	ld	s2,112(sp)
ffffffffc020ac5a:	79a6                	ld	s3,104(sp)
ffffffffc020ac5c:	7a06                	ld	s4,96(sp)
ffffffffc020ac5e:	6ae6                	ld	s5,88(sp)
ffffffffc020ac60:	6b46                	ld	s6,80(sp)
ffffffffc020ac62:	6ba6                	ld	s7,72(sp)
ffffffffc020ac64:	6c06                	ld	s8,64(sp)
ffffffffc020ac66:	7ce2                	ld	s9,56(sp)
ffffffffc020ac68:	7d42                	ld	s10,48(sp)
ffffffffc020ac6a:	856e                	mv	a0,s11
ffffffffc020ac6c:	7da2                	ld	s11,40(sp)
ffffffffc020ac6e:	6149                	addi	sp,sp,144
ffffffffc020ac70:	8082                	ret
ffffffffc020ac72:	4652                	lw	a2,20(sp)
ffffffffc020ac74:	082c                	addi	a1,sp,24
ffffffffc020ac76:	8526                	mv	a0,s1
ffffffffc020ac78:	bdfff0ef          	jal	ra,ffffffffc020a856 <sfs_load_inode>
ffffffffc020ac7c:	8daa                	mv	s11,a0
ffffffffc020ac7e:	f561                	bnez	a0,ffffffffc020ac46 <sfs_namefile+0x9a>
ffffffffc020ac80:	854e                	mv	a0,s3
ffffffffc020ac82:	008aa903          	lw	s2,8(s5)
ffffffffc020ac86:	e8bfc0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ac8a:	6ce2                	ld	s9,24(sp)
ffffffffc020ac8c:	0b3c8463          	beq	s9,s3,ffffffffc020ad34 <sfs_namefile+0x188>
ffffffffc020ac90:	100c8463          	beqz	s9,ffffffffc020ad98 <sfs_namefile+0x1ec>
ffffffffc020ac94:	058ca703          	lw	a4,88(s9)
ffffffffc020ac98:	6782                	ld	a5,0(sp)
ffffffffc020ac9a:	0ef71f63          	bne	a4,a5,ffffffffc020ad98 <sfs_namefile+0x1ec>
ffffffffc020ac9e:	008ca703          	lw	a4,8(s9)
ffffffffc020aca2:	8ae6                	mv	s5,s9
ffffffffc020aca4:	0d270a63          	beq	a4,s2,ffffffffc020ad78 <sfs_namefile+0x1cc>
ffffffffc020aca8:	000cb703          	ld	a4,0(s9)
ffffffffc020acac:	4789                	li	a5,2
ffffffffc020acae:	00475703          	lhu	a4,4(a4)
ffffffffc020acb2:	0cf71363          	bne	a4,a5,ffffffffc020ad78 <sfs_namefile+0x1cc>
ffffffffc020acb6:	020c8a13          	addi	s4,s9,32
ffffffffc020acba:	8552                	mv	a0,s4
ffffffffc020acbc:	9a9f90ef          	jal	ra,ffffffffc0204664 <down>
ffffffffc020acc0:	000cb703          	ld	a4,0(s9)
ffffffffc020acc4:	00872983          	lw	s3,8(a4)
ffffffffc020acc8:	01304963          	bgtz	s3,ffffffffc020acda <sfs_namefile+0x12e>
ffffffffc020accc:	a899                	j	ffffffffc020ad22 <sfs_namefile+0x176>
ffffffffc020acce:	4018                	lw	a4,0(s0)
ffffffffc020acd0:	01270e63          	beq	a4,s2,ffffffffc020acec <sfs_namefile+0x140>
ffffffffc020acd4:	2d85                	addiw	s11,s11,1
ffffffffc020acd6:	05b98663          	beq	s3,s11,ffffffffc020ad22 <sfs_namefile+0x176>
ffffffffc020acda:	86a2                	mv	a3,s0
ffffffffc020acdc:	866e                	mv	a2,s11
ffffffffc020acde:	85e6                	mv	a1,s9
ffffffffc020ace0:	8526                	mv	a0,s1
ffffffffc020ace2:	e48ff0ef          	jal	ra,ffffffffc020a32a <sfs_dirent_read_nolock>
ffffffffc020ace6:	872a                	mv	a4,a0
ffffffffc020ace8:	d17d                	beqz	a0,ffffffffc020acce <sfs_namefile+0x122>
ffffffffc020acea:	a82d                	j	ffffffffc020ad24 <sfs_namefile+0x178>
ffffffffc020acec:	8552                	mv	a0,s4
ffffffffc020acee:	973f90ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020acf2:	8562                	mv	a0,s8
ffffffffc020acf4:	0ff000ef          	jal	ra,ffffffffc020b5f2 <strlen>
ffffffffc020acf8:	00150793          	addi	a5,a0,1
ffffffffc020acfc:	862a                	mv	a2,a0
ffffffffc020acfe:	06fbe863          	bltu	s7,a5,ffffffffc020ad6e <sfs_namefile+0x1c2>
ffffffffc020ad02:	fff64913          	not	s2,a2
ffffffffc020ad06:	995a                	add	s2,s2,s6
ffffffffc020ad08:	85e2                	mv	a1,s8
ffffffffc020ad0a:	854a                	mv	a0,s2
ffffffffc020ad0c:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020ad10:	1d7000ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc020ad14:	02f00793          	li	a5,47
ffffffffc020ad18:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020ad1c:	89e6                	mv	s3,s9
ffffffffc020ad1e:	8b4a                	mv	s6,s2
ffffffffc020ad20:	b721                	j	ffffffffc020ac28 <sfs_namefile+0x7c>
ffffffffc020ad22:	5741                	li	a4,-16
ffffffffc020ad24:	8552                	mv	a0,s4
ffffffffc020ad26:	e03a                	sd	a4,0(sp)
ffffffffc020ad28:	939f90ef          	jal	ra,ffffffffc0204660 <up>
ffffffffc020ad2c:	6702                	ld	a4,0(sp)
ffffffffc020ad2e:	89e6                	mv	s3,s9
ffffffffc020ad30:	8dba                	mv	s11,a4
ffffffffc020ad32:	bf11                	j	ffffffffc020ac46 <sfs_namefile+0x9a>
ffffffffc020ad34:	854e                	mv	a0,s3
ffffffffc020ad36:	ddbfc0ef          	jal	ra,ffffffffc0207b10 <inode_ref_dec>
ffffffffc020ad3a:	64a2                	ld	s1,8(sp)
ffffffffc020ad3c:	85da                	mv	a1,s6
ffffffffc020ad3e:	6c98                	ld	a4,24(s1)
ffffffffc020ad40:	6088                	ld	a0,0(s1)
ffffffffc020ad42:	1779                	addi	a4,a4,-2
ffffffffc020ad44:	41770bb3          	sub	s7,a4,s7
ffffffffc020ad48:	865e                	mv	a2,s7
ffffffffc020ad4a:	0505                	addi	a0,a0,1
ffffffffc020ad4c:	15b000ef          	jal	ra,ffffffffc020b6a6 <memmove>
ffffffffc020ad50:	02f00713          	li	a4,47
ffffffffc020ad54:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ad58:	955e                	add	a0,a0,s7
ffffffffc020ad5a:	00050023          	sb	zero,0(a0)
ffffffffc020ad5e:	85de                	mv	a1,s7
ffffffffc020ad60:	8526                	mv	a0,s1
ffffffffc020ad62:	ff6fa0ef          	jal	ra,ffffffffc0205558 <iobuf_skip>
ffffffffc020ad66:	8522                	mv	a0,s0
ffffffffc020ad68:	b5ef70ef          	jal	ra,ffffffffc02020c6 <kfree>
ffffffffc020ad6c:	b5dd                	j	ffffffffc020ac52 <sfs_namefile+0xa6>
ffffffffc020ad6e:	89e6                	mv	s3,s9
ffffffffc020ad70:	5df1                	li	s11,-4
ffffffffc020ad72:	bdd1                	j	ffffffffc020ac46 <sfs_namefile+0x9a>
ffffffffc020ad74:	5df1                	li	s11,-4
ffffffffc020ad76:	bdf1                	j	ffffffffc020ac52 <sfs_namefile+0xa6>
ffffffffc020ad78:	00004697          	auipc	a3,0x4
ffffffffc020ad7c:	53068693          	addi	a3,a3,1328 # ffffffffc020f2a8 <dev_node_ops+0x888>
ffffffffc020ad80:	00001617          	auipc	a2,0x1
ffffffffc020ad84:	df860613          	addi	a2,a2,-520 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ad88:	2fa00593          	li	a1,762
ffffffffc020ad8c:	00004517          	auipc	a0,0x4
ffffffffc020ad90:	25450513          	addi	a0,a0,596 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020ad94:	f0af50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ad98:	00004697          	auipc	a3,0x4
ffffffffc020ad9c:	21068693          	addi	a3,a3,528 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020ada0:	00001617          	auipc	a2,0x1
ffffffffc020ada4:	dd860613          	addi	a2,a2,-552 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ada8:	2f900593          	li	a1,761
ffffffffc020adac:	00004517          	auipc	a0,0x4
ffffffffc020adb0:	23450513          	addi	a0,a0,564 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020adb4:	eeaf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020adb8:	00004697          	auipc	a3,0x4
ffffffffc020adbc:	1f068693          	addi	a3,a3,496 # ffffffffc020efa8 <dev_node_ops+0x588>
ffffffffc020adc0:	00001617          	auipc	a2,0x1
ffffffffc020adc4:	db860613          	addi	a2,a2,-584 # ffffffffc020bb78 <commands+0x210>
ffffffffc020adc8:	2e600593          	li	a1,742
ffffffffc020adcc:	00004517          	auipc	a0,0x4
ffffffffc020add0:	21450513          	addi	a0,a0,532 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020add4:	ecaf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020add8:	00004697          	auipc	a3,0x4
ffffffffc020addc:	02868693          	addi	a3,a3,40 # ffffffffc020ee00 <dev_node_ops+0x3e0>
ffffffffc020ade0:	00001617          	auipc	a2,0x1
ffffffffc020ade4:	d9860613          	addi	a2,a2,-616 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ade8:	2e500593          	li	a1,741
ffffffffc020adec:	00004517          	auipc	a0,0x4
ffffffffc020adf0:	1f450513          	addi	a0,a0,500 # ffffffffc020efe0 <dev_node_ops+0x5c0>
ffffffffc020adf4:	eaaf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020adf8 <sfs_rwblock_nolock>:
ffffffffc020adf8:	7139                	addi	sp,sp,-64
ffffffffc020adfa:	f822                	sd	s0,48(sp)
ffffffffc020adfc:	f426                	sd	s1,40(sp)
ffffffffc020adfe:	fc06                	sd	ra,56(sp)
ffffffffc020ae00:	842a                	mv	s0,a0
ffffffffc020ae02:	84b6                	mv	s1,a3
ffffffffc020ae04:	e211                	bnez	a2,ffffffffc020ae08 <sfs_rwblock_nolock+0x10>
ffffffffc020ae06:	e715                	bnez	a4,ffffffffc020ae32 <sfs_rwblock_nolock+0x3a>
ffffffffc020ae08:	405c                	lw	a5,4(s0)
ffffffffc020ae0a:	02f67463          	bgeu	a2,a5,ffffffffc020ae32 <sfs_rwblock_nolock+0x3a>
ffffffffc020ae0e:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020ae12:	1682                	slli	a3,a3,0x20
ffffffffc020ae14:	6605                	lui	a2,0x1
ffffffffc020ae16:	9281                	srli	a3,a3,0x20
ffffffffc020ae18:	850a                	mv	a0,sp
ffffffffc020ae1a:	ec8fa0ef          	jal	ra,ffffffffc02054e2 <iobuf_init>
ffffffffc020ae1e:	85aa                	mv	a1,a0
ffffffffc020ae20:	7808                	ld	a0,48(s0)
ffffffffc020ae22:	8626                	mv	a2,s1
ffffffffc020ae24:	7118                	ld	a4,32(a0)
ffffffffc020ae26:	9702                	jalr	a4
ffffffffc020ae28:	70e2                	ld	ra,56(sp)
ffffffffc020ae2a:	7442                	ld	s0,48(sp)
ffffffffc020ae2c:	74a2                	ld	s1,40(sp)
ffffffffc020ae2e:	6121                	addi	sp,sp,64
ffffffffc020ae30:	8082                	ret
ffffffffc020ae32:	00004697          	auipc	a3,0x4
ffffffffc020ae36:	5ae68693          	addi	a3,a3,1454 # ffffffffc020f3e0 <sfs_node_fileops+0x80>
ffffffffc020ae3a:	00001617          	auipc	a2,0x1
ffffffffc020ae3e:	d3e60613          	addi	a2,a2,-706 # ffffffffc020bb78 <commands+0x210>
ffffffffc020ae42:	45d5                	li	a1,21
ffffffffc020ae44:	00004517          	auipc	a0,0x4
ffffffffc020ae48:	5d450513          	addi	a0,a0,1492 # ffffffffc020f418 <sfs_node_fileops+0xb8>
ffffffffc020ae4c:	e52f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ae50 <sfs_rblock>:
ffffffffc020ae50:	7139                	addi	sp,sp,-64
ffffffffc020ae52:	ec4e                	sd	s3,24(sp)
ffffffffc020ae54:	89b6                	mv	s3,a3
ffffffffc020ae56:	f822                	sd	s0,48(sp)
ffffffffc020ae58:	f04a                	sd	s2,32(sp)
ffffffffc020ae5a:	e852                	sd	s4,16(sp)
ffffffffc020ae5c:	fc06                	sd	ra,56(sp)
ffffffffc020ae5e:	f426                	sd	s1,40(sp)
ffffffffc020ae60:	e456                	sd	s5,8(sp)
ffffffffc020ae62:	8a2a                	mv	s4,a0
ffffffffc020ae64:	892e                	mv	s2,a1
ffffffffc020ae66:	8432                	mv	s0,a2
ffffffffc020ae68:	2e0000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020ae6c:	04098063          	beqz	s3,ffffffffc020aeac <sfs_rblock+0x5c>
ffffffffc020ae70:	013409bb          	addw	s3,s0,s3
ffffffffc020ae74:	6a85                	lui	s5,0x1
ffffffffc020ae76:	a021                	j	ffffffffc020ae7e <sfs_rblock+0x2e>
ffffffffc020ae78:	9956                	add	s2,s2,s5
ffffffffc020ae7a:	02898963          	beq	s3,s0,ffffffffc020aeac <sfs_rblock+0x5c>
ffffffffc020ae7e:	8622                	mv	a2,s0
ffffffffc020ae80:	85ca                	mv	a1,s2
ffffffffc020ae82:	4705                	li	a4,1
ffffffffc020ae84:	4681                	li	a3,0
ffffffffc020ae86:	8552                	mv	a0,s4
ffffffffc020ae88:	f71ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020ae8c:	84aa                	mv	s1,a0
ffffffffc020ae8e:	2405                	addiw	s0,s0,1
ffffffffc020ae90:	d565                	beqz	a0,ffffffffc020ae78 <sfs_rblock+0x28>
ffffffffc020ae92:	8552                	mv	a0,s4
ffffffffc020ae94:	2c4000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020ae98:	70e2                	ld	ra,56(sp)
ffffffffc020ae9a:	7442                	ld	s0,48(sp)
ffffffffc020ae9c:	7902                	ld	s2,32(sp)
ffffffffc020ae9e:	69e2                	ld	s3,24(sp)
ffffffffc020aea0:	6a42                	ld	s4,16(sp)
ffffffffc020aea2:	6aa2                	ld	s5,8(sp)
ffffffffc020aea4:	8526                	mv	a0,s1
ffffffffc020aea6:	74a2                	ld	s1,40(sp)
ffffffffc020aea8:	6121                	addi	sp,sp,64
ffffffffc020aeaa:	8082                	ret
ffffffffc020aeac:	4481                	li	s1,0
ffffffffc020aeae:	b7d5                	j	ffffffffc020ae92 <sfs_rblock+0x42>

ffffffffc020aeb0 <sfs_wblock>:
ffffffffc020aeb0:	7139                	addi	sp,sp,-64
ffffffffc020aeb2:	ec4e                	sd	s3,24(sp)
ffffffffc020aeb4:	89b6                	mv	s3,a3
ffffffffc020aeb6:	f822                	sd	s0,48(sp)
ffffffffc020aeb8:	f04a                	sd	s2,32(sp)
ffffffffc020aeba:	e852                	sd	s4,16(sp)
ffffffffc020aebc:	fc06                	sd	ra,56(sp)
ffffffffc020aebe:	f426                	sd	s1,40(sp)
ffffffffc020aec0:	e456                	sd	s5,8(sp)
ffffffffc020aec2:	8a2a                	mv	s4,a0
ffffffffc020aec4:	892e                	mv	s2,a1
ffffffffc020aec6:	8432                	mv	s0,a2
ffffffffc020aec8:	280000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020aecc:	04098063          	beqz	s3,ffffffffc020af0c <sfs_wblock+0x5c>
ffffffffc020aed0:	013409bb          	addw	s3,s0,s3
ffffffffc020aed4:	6a85                	lui	s5,0x1
ffffffffc020aed6:	a021                	j	ffffffffc020aede <sfs_wblock+0x2e>
ffffffffc020aed8:	9956                	add	s2,s2,s5
ffffffffc020aeda:	02898963          	beq	s3,s0,ffffffffc020af0c <sfs_wblock+0x5c>
ffffffffc020aede:	8622                	mv	a2,s0
ffffffffc020aee0:	85ca                	mv	a1,s2
ffffffffc020aee2:	4705                	li	a4,1
ffffffffc020aee4:	4685                	li	a3,1
ffffffffc020aee6:	8552                	mv	a0,s4
ffffffffc020aee8:	f11ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020aeec:	84aa                	mv	s1,a0
ffffffffc020aeee:	2405                	addiw	s0,s0,1
ffffffffc020aef0:	d565                	beqz	a0,ffffffffc020aed8 <sfs_wblock+0x28>
ffffffffc020aef2:	8552                	mv	a0,s4
ffffffffc020aef4:	264000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020aef8:	70e2                	ld	ra,56(sp)
ffffffffc020aefa:	7442                	ld	s0,48(sp)
ffffffffc020aefc:	7902                	ld	s2,32(sp)
ffffffffc020aefe:	69e2                	ld	s3,24(sp)
ffffffffc020af00:	6a42                	ld	s4,16(sp)
ffffffffc020af02:	6aa2                	ld	s5,8(sp)
ffffffffc020af04:	8526                	mv	a0,s1
ffffffffc020af06:	74a2                	ld	s1,40(sp)
ffffffffc020af08:	6121                	addi	sp,sp,64
ffffffffc020af0a:	8082                	ret
ffffffffc020af0c:	4481                	li	s1,0
ffffffffc020af0e:	b7d5                	j	ffffffffc020aef2 <sfs_wblock+0x42>

ffffffffc020af10 <sfs_rbuf>:
ffffffffc020af10:	7179                	addi	sp,sp,-48
ffffffffc020af12:	f406                	sd	ra,40(sp)
ffffffffc020af14:	f022                	sd	s0,32(sp)
ffffffffc020af16:	ec26                	sd	s1,24(sp)
ffffffffc020af18:	e84a                	sd	s2,16(sp)
ffffffffc020af1a:	e44e                	sd	s3,8(sp)
ffffffffc020af1c:	e052                	sd	s4,0(sp)
ffffffffc020af1e:	6785                	lui	a5,0x1
ffffffffc020af20:	04f77863          	bgeu	a4,a5,ffffffffc020af70 <sfs_rbuf+0x60>
ffffffffc020af24:	84ba                	mv	s1,a4
ffffffffc020af26:	9732                	add	a4,a4,a2
ffffffffc020af28:	89b2                	mv	s3,a2
ffffffffc020af2a:	04e7e363          	bltu	a5,a4,ffffffffc020af70 <sfs_rbuf+0x60>
ffffffffc020af2e:	8936                	mv	s2,a3
ffffffffc020af30:	842a                	mv	s0,a0
ffffffffc020af32:	8a2e                	mv	s4,a1
ffffffffc020af34:	214000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020af38:	642c                	ld	a1,72(s0)
ffffffffc020af3a:	864a                	mv	a2,s2
ffffffffc020af3c:	4705                	li	a4,1
ffffffffc020af3e:	4681                	li	a3,0
ffffffffc020af40:	8522                	mv	a0,s0
ffffffffc020af42:	eb7ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020af46:	892a                	mv	s2,a0
ffffffffc020af48:	cd09                	beqz	a0,ffffffffc020af62 <sfs_rbuf+0x52>
ffffffffc020af4a:	8522                	mv	a0,s0
ffffffffc020af4c:	20c000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020af50:	70a2                	ld	ra,40(sp)
ffffffffc020af52:	7402                	ld	s0,32(sp)
ffffffffc020af54:	64e2                	ld	s1,24(sp)
ffffffffc020af56:	69a2                	ld	s3,8(sp)
ffffffffc020af58:	6a02                	ld	s4,0(sp)
ffffffffc020af5a:	854a                	mv	a0,s2
ffffffffc020af5c:	6942                	ld	s2,16(sp)
ffffffffc020af5e:	6145                	addi	sp,sp,48
ffffffffc020af60:	8082                	ret
ffffffffc020af62:	642c                	ld	a1,72(s0)
ffffffffc020af64:	864e                	mv	a2,s3
ffffffffc020af66:	8552                	mv	a0,s4
ffffffffc020af68:	95a6                	add	a1,a1,s1
ffffffffc020af6a:	77c000ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc020af6e:	bff1                	j	ffffffffc020af4a <sfs_rbuf+0x3a>
ffffffffc020af70:	00004697          	auipc	a3,0x4
ffffffffc020af74:	4c068693          	addi	a3,a3,1216 # ffffffffc020f430 <sfs_node_fileops+0xd0>
ffffffffc020af78:	00001617          	auipc	a2,0x1
ffffffffc020af7c:	c0060613          	addi	a2,a2,-1024 # ffffffffc020bb78 <commands+0x210>
ffffffffc020af80:	05500593          	li	a1,85
ffffffffc020af84:	00004517          	auipc	a0,0x4
ffffffffc020af88:	49450513          	addi	a0,a0,1172 # ffffffffc020f418 <sfs_node_fileops+0xb8>
ffffffffc020af8c:	d12f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020af90 <sfs_wbuf>:
ffffffffc020af90:	7139                	addi	sp,sp,-64
ffffffffc020af92:	fc06                	sd	ra,56(sp)
ffffffffc020af94:	f822                	sd	s0,48(sp)
ffffffffc020af96:	f426                	sd	s1,40(sp)
ffffffffc020af98:	f04a                	sd	s2,32(sp)
ffffffffc020af9a:	ec4e                	sd	s3,24(sp)
ffffffffc020af9c:	e852                	sd	s4,16(sp)
ffffffffc020af9e:	e456                	sd	s5,8(sp)
ffffffffc020afa0:	6785                	lui	a5,0x1
ffffffffc020afa2:	06f77163          	bgeu	a4,a5,ffffffffc020b004 <sfs_wbuf+0x74>
ffffffffc020afa6:	893a                	mv	s2,a4
ffffffffc020afa8:	9732                	add	a4,a4,a2
ffffffffc020afaa:	8a32                	mv	s4,a2
ffffffffc020afac:	04e7ec63          	bltu	a5,a4,ffffffffc020b004 <sfs_wbuf+0x74>
ffffffffc020afb0:	842a                	mv	s0,a0
ffffffffc020afb2:	89b6                	mv	s3,a3
ffffffffc020afb4:	8aae                	mv	s5,a1
ffffffffc020afb6:	192000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020afba:	642c                	ld	a1,72(s0)
ffffffffc020afbc:	4705                	li	a4,1
ffffffffc020afbe:	4681                	li	a3,0
ffffffffc020afc0:	864e                	mv	a2,s3
ffffffffc020afc2:	8522                	mv	a0,s0
ffffffffc020afc4:	e35ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020afc8:	84aa                	mv	s1,a0
ffffffffc020afca:	cd11                	beqz	a0,ffffffffc020afe6 <sfs_wbuf+0x56>
ffffffffc020afcc:	8522                	mv	a0,s0
ffffffffc020afce:	18a000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020afd2:	70e2                	ld	ra,56(sp)
ffffffffc020afd4:	7442                	ld	s0,48(sp)
ffffffffc020afd6:	7902                	ld	s2,32(sp)
ffffffffc020afd8:	69e2                	ld	s3,24(sp)
ffffffffc020afda:	6a42                	ld	s4,16(sp)
ffffffffc020afdc:	6aa2                	ld	s5,8(sp)
ffffffffc020afde:	8526                	mv	a0,s1
ffffffffc020afe0:	74a2                	ld	s1,40(sp)
ffffffffc020afe2:	6121                	addi	sp,sp,64
ffffffffc020afe4:	8082                	ret
ffffffffc020afe6:	6428                	ld	a0,72(s0)
ffffffffc020afe8:	8652                	mv	a2,s4
ffffffffc020afea:	85d6                	mv	a1,s5
ffffffffc020afec:	954a                	add	a0,a0,s2
ffffffffc020afee:	6f8000ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc020aff2:	642c                	ld	a1,72(s0)
ffffffffc020aff4:	4705                	li	a4,1
ffffffffc020aff6:	4685                	li	a3,1
ffffffffc020aff8:	864e                	mv	a2,s3
ffffffffc020affa:	8522                	mv	a0,s0
ffffffffc020affc:	dfdff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020b000:	84aa                	mv	s1,a0
ffffffffc020b002:	b7e9                	j	ffffffffc020afcc <sfs_wbuf+0x3c>
ffffffffc020b004:	00004697          	auipc	a3,0x4
ffffffffc020b008:	42c68693          	addi	a3,a3,1068 # ffffffffc020f430 <sfs_node_fileops+0xd0>
ffffffffc020b00c:	00001617          	auipc	a2,0x1
ffffffffc020b010:	b6c60613          	addi	a2,a2,-1172 # ffffffffc020bb78 <commands+0x210>
ffffffffc020b014:	06b00593          	li	a1,107
ffffffffc020b018:	00004517          	auipc	a0,0x4
ffffffffc020b01c:	40050513          	addi	a0,a0,1024 # ffffffffc020f418 <sfs_node_fileops+0xb8>
ffffffffc020b020:	c7ef50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020b024 <sfs_sync_super>:
ffffffffc020b024:	1101                	addi	sp,sp,-32
ffffffffc020b026:	ec06                	sd	ra,24(sp)
ffffffffc020b028:	e822                	sd	s0,16(sp)
ffffffffc020b02a:	e426                	sd	s1,8(sp)
ffffffffc020b02c:	842a                	mv	s0,a0
ffffffffc020b02e:	11a000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020b032:	6428                	ld	a0,72(s0)
ffffffffc020b034:	6605                	lui	a2,0x1
ffffffffc020b036:	4581                	li	a1,0
ffffffffc020b038:	65c000ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc020b03c:	6428                	ld	a0,72(s0)
ffffffffc020b03e:	85a2                	mv	a1,s0
ffffffffc020b040:	02c00613          	li	a2,44
ffffffffc020b044:	6a2000ef          	jal	ra,ffffffffc020b6e6 <memcpy>
ffffffffc020b048:	642c                	ld	a1,72(s0)
ffffffffc020b04a:	4701                	li	a4,0
ffffffffc020b04c:	4685                	li	a3,1
ffffffffc020b04e:	4601                	li	a2,0
ffffffffc020b050:	8522                	mv	a0,s0
ffffffffc020b052:	da7ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020b056:	84aa                	mv	s1,a0
ffffffffc020b058:	8522                	mv	a0,s0
ffffffffc020b05a:	0fe000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020b05e:	60e2                	ld	ra,24(sp)
ffffffffc020b060:	6442                	ld	s0,16(sp)
ffffffffc020b062:	8526                	mv	a0,s1
ffffffffc020b064:	64a2                	ld	s1,8(sp)
ffffffffc020b066:	6105                	addi	sp,sp,32
ffffffffc020b068:	8082                	ret

ffffffffc020b06a <sfs_sync_freemap>:
ffffffffc020b06a:	7139                	addi	sp,sp,-64
ffffffffc020b06c:	ec4e                	sd	s3,24(sp)
ffffffffc020b06e:	e852                	sd	s4,16(sp)
ffffffffc020b070:	00456983          	lwu	s3,4(a0)
ffffffffc020b074:	8a2a                	mv	s4,a0
ffffffffc020b076:	7d08                	ld	a0,56(a0)
ffffffffc020b078:	67a1                	lui	a5,0x8
ffffffffc020b07a:	17fd                	addi	a5,a5,-1
ffffffffc020b07c:	4581                	li	a1,0
ffffffffc020b07e:	f822                	sd	s0,48(sp)
ffffffffc020b080:	fc06                	sd	ra,56(sp)
ffffffffc020b082:	f426                	sd	s1,40(sp)
ffffffffc020b084:	f04a                	sd	s2,32(sp)
ffffffffc020b086:	e456                	sd	s5,8(sp)
ffffffffc020b088:	99be                	add	s3,s3,a5
ffffffffc020b08a:	a14fe0ef          	jal	ra,ffffffffc020929e <bitmap_getdata>
ffffffffc020b08e:	00f9d993          	srli	s3,s3,0xf
ffffffffc020b092:	842a                	mv	s0,a0
ffffffffc020b094:	8552                	mv	a0,s4
ffffffffc020b096:	0b2000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020b09a:	04098163          	beqz	s3,ffffffffc020b0dc <sfs_sync_freemap+0x72>
ffffffffc020b09e:	09b2                	slli	s3,s3,0xc
ffffffffc020b0a0:	99a2                	add	s3,s3,s0
ffffffffc020b0a2:	4909                	li	s2,2
ffffffffc020b0a4:	6a85                	lui	s5,0x1
ffffffffc020b0a6:	a021                	j	ffffffffc020b0ae <sfs_sync_freemap+0x44>
ffffffffc020b0a8:	2905                	addiw	s2,s2,1
ffffffffc020b0aa:	02898963          	beq	s3,s0,ffffffffc020b0dc <sfs_sync_freemap+0x72>
ffffffffc020b0ae:	85a2                	mv	a1,s0
ffffffffc020b0b0:	864a                	mv	a2,s2
ffffffffc020b0b2:	4705                	li	a4,1
ffffffffc020b0b4:	4685                	li	a3,1
ffffffffc020b0b6:	8552                	mv	a0,s4
ffffffffc020b0b8:	d41ff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020b0bc:	84aa                	mv	s1,a0
ffffffffc020b0be:	9456                	add	s0,s0,s5
ffffffffc020b0c0:	d565                	beqz	a0,ffffffffc020b0a8 <sfs_sync_freemap+0x3e>
ffffffffc020b0c2:	8552                	mv	a0,s4
ffffffffc020b0c4:	094000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020b0c8:	70e2                	ld	ra,56(sp)
ffffffffc020b0ca:	7442                	ld	s0,48(sp)
ffffffffc020b0cc:	7902                	ld	s2,32(sp)
ffffffffc020b0ce:	69e2                	ld	s3,24(sp)
ffffffffc020b0d0:	6a42                	ld	s4,16(sp)
ffffffffc020b0d2:	6aa2                	ld	s5,8(sp)
ffffffffc020b0d4:	8526                	mv	a0,s1
ffffffffc020b0d6:	74a2                	ld	s1,40(sp)
ffffffffc020b0d8:	6121                	addi	sp,sp,64
ffffffffc020b0da:	8082                	ret
ffffffffc020b0dc:	4481                	li	s1,0
ffffffffc020b0de:	b7d5                	j	ffffffffc020b0c2 <sfs_sync_freemap+0x58>

ffffffffc020b0e0 <sfs_clear_block>:
ffffffffc020b0e0:	7179                	addi	sp,sp,-48
ffffffffc020b0e2:	f022                	sd	s0,32(sp)
ffffffffc020b0e4:	e84a                	sd	s2,16(sp)
ffffffffc020b0e6:	e44e                	sd	s3,8(sp)
ffffffffc020b0e8:	f406                	sd	ra,40(sp)
ffffffffc020b0ea:	89b2                	mv	s3,a2
ffffffffc020b0ec:	ec26                	sd	s1,24(sp)
ffffffffc020b0ee:	892a                	mv	s2,a0
ffffffffc020b0f0:	842e                	mv	s0,a1
ffffffffc020b0f2:	056000ef          	jal	ra,ffffffffc020b148 <lock_sfs_io>
ffffffffc020b0f6:	04893503          	ld	a0,72(s2)
ffffffffc020b0fa:	6605                	lui	a2,0x1
ffffffffc020b0fc:	4581                	li	a1,0
ffffffffc020b0fe:	596000ef          	jal	ra,ffffffffc020b694 <memset>
ffffffffc020b102:	02098d63          	beqz	s3,ffffffffc020b13c <sfs_clear_block+0x5c>
ffffffffc020b106:	013409bb          	addw	s3,s0,s3
ffffffffc020b10a:	a019                	j	ffffffffc020b110 <sfs_clear_block+0x30>
ffffffffc020b10c:	02898863          	beq	s3,s0,ffffffffc020b13c <sfs_clear_block+0x5c>
ffffffffc020b110:	04893583          	ld	a1,72(s2)
ffffffffc020b114:	8622                	mv	a2,s0
ffffffffc020b116:	4705                	li	a4,1
ffffffffc020b118:	4685                	li	a3,1
ffffffffc020b11a:	854a                	mv	a0,s2
ffffffffc020b11c:	cddff0ef          	jal	ra,ffffffffc020adf8 <sfs_rwblock_nolock>
ffffffffc020b120:	84aa                	mv	s1,a0
ffffffffc020b122:	2405                	addiw	s0,s0,1
ffffffffc020b124:	d565                	beqz	a0,ffffffffc020b10c <sfs_clear_block+0x2c>
ffffffffc020b126:	854a                	mv	a0,s2
ffffffffc020b128:	030000ef          	jal	ra,ffffffffc020b158 <unlock_sfs_io>
ffffffffc020b12c:	70a2                	ld	ra,40(sp)
ffffffffc020b12e:	7402                	ld	s0,32(sp)
ffffffffc020b130:	6942                	ld	s2,16(sp)
ffffffffc020b132:	69a2                	ld	s3,8(sp)
ffffffffc020b134:	8526                	mv	a0,s1
ffffffffc020b136:	64e2                	ld	s1,24(sp)
ffffffffc020b138:	6145                	addi	sp,sp,48
ffffffffc020b13a:	8082                	ret
ffffffffc020b13c:	4481                	li	s1,0
ffffffffc020b13e:	b7e5                	j	ffffffffc020b126 <sfs_clear_block+0x46>

ffffffffc020b140 <lock_sfs_fs>:
ffffffffc020b140:	05050513          	addi	a0,a0,80
ffffffffc020b144:	d20f906f          	j	ffffffffc0204664 <down>

ffffffffc020b148 <lock_sfs_io>:
ffffffffc020b148:	06850513          	addi	a0,a0,104
ffffffffc020b14c:	d18f906f          	j	ffffffffc0204664 <down>

ffffffffc020b150 <unlock_sfs_fs>:
ffffffffc020b150:	05050513          	addi	a0,a0,80
ffffffffc020b154:	d0cf906f          	j	ffffffffc0204660 <up>

ffffffffc020b158 <unlock_sfs_io>:
ffffffffc020b158:	06850513          	addi	a0,a0,104
ffffffffc020b15c:	d04f906f          	j	ffffffffc0204660 <up>

ffffffffc020b160 <hash32>:
ffffffffc020b160:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b164:	2785                	addiw	a5,a5,1
ffffffffc020b166:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b16a:	02000793          	li	a5,32
ffffffffc020b16e:	9f8d                	subw	a5,a5,a1
ffffffffc020b170:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b174:	8082                	ret

ffffffffc020b176 <printnum>:
ffffffffc020b176:	02071893          	slli	a7,a4,0x20
ffffffffc020b17a:	7139                	addi	sp,sp,-64
ffffffffc020b17c:	0208d893          	srli	a7,a7,0x20
ffffffffc020b180:	e456                	sd	s5,8(sp)
ffffffffc020b182:	0316fab3          	remu	s5,a3,a7
ffffffffc020b186:	f822                	sd	s0,48(sp)
ffffffffc020b188:	f426                	sd	s1,40(sp)
ffffffffc020b18a:	f04a                	sd	s2,32(sp)
ffffffffc020b18c:	ec4e                	sd	s3,24(sp)
ffffffffc020b18e:	fc06                	sd	ra,56(sp)
ffffffffc020b190:	e852                	sd	s4,16(sp)
ffffffffc020b192:	84aa                	mv	s1,a0
ffffffffc020b194:	89ae                	mv	s3,a1
ffffffffc020b196:	8932                	mv	s2,a2
ffffffffc020b198:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b19c:	2a81                	sext.w	s5,s5
ffffffffc020b19e:	0516f163          	bgeu	a3,a7,ffffffffc020b1e0 <printnum+0x6a>
ffffffffc020b1a2:	8a42                	mv	s4,a6
ffffffffc020b1a4:	00805863          	blez	s0,ffffffffc020b1b4 <printnum+0x3e>
ffffffffc020b1a8:	347d                	addiw	s0,s0,-1
ffffffffc020b1aa:	864e                	mv	a2,s3
ffffffffc020b1ac:	85ca                	mv	a1,s2
ffffffffc020b1ae:	8552                	mv	a0,s4
ffffffffc020b1b0:	9482                	jalr	s1
ffffffffc020b1b2:	f87d                	bnez	s0,ffffffffc020b1a8 <printnum+0x32>
ffffffffc020b1b4:	1a82                	slli	s5,s5,0x20
ffffffffc020b1b6:	00004797          	auipc	a5,0x4
ffffffffc020b1ba:	2c278793          	addi	a5,a5,706 # ffffffffc020f478 <sfs_node_fileops+0x118>
ffffffffc020b1be:	020ada93          	srli	s5,s5,0x20
ffffffffc020b1c2:	9abe                	add	s5,s5,a5
ffffffffc020b1c4:	7442                	ld	s0,48(sp)
ffffffffc020b1c6:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020b1ca:	70e2                	ld	ra,56(sp)
ffffffffc020b1cc:	6a42                	ld	s4,16(sp)
ffffffffc020b1ce:	6aa2                	ld	s5,8(sp)
ffffffffc020b1d0:	864e                	mv	a2,s3
ffffffffc020b1d2:	85ca                	mv	a1,s2
ffffffffc020b1d4:	69e2                	ld	s3,24(sp)
ffffffffc020b1d6:	7902                	ld	s2,32(sp)
ffffffffc020b1d8:	87a6                	mv	a5,s1
ffffffffc020b1da:	74a2                	ld	s1,40(sp)
ffffffffc020b1dc:	6121                	addi	sp,sp,64
ffffffffc020b1de:	8782                	jr	a5
ffffffffc020b1e0:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b1e4:	87a2                	mv	a5,s0
ffffffffc020b1e6:	f91ff0ef          	jal	ra,ffffffffc020b176 <printnum>
ffffffffc020b1ea:	b7e9                	j	ffffffffc020b1b4 <printnum+0x3e>

ffffffffc020b1ec <sprintputch>:
ffffffffc020b1ec:	499c                	lw	a5,16(a1)
ffffffffc020b1ee:	6198                	ld	a4,0(a1)
ffffffffc020b1f0:	6594                	ld	a3,8(a1)
ffffffffc020b1f2:	2785                	addiw	a5,a5,1
ffffffffc020b1f4:	c99c                	sw	a5,16(a1)
ffffffffc020b1f6:	00d77763          	bgeu	a4,a3,ffffffffc020b204 <sprintputch+0x18>
ffffffffc020b1fa:	00170793          	addi	a5,a4,1
ffffffffc020b1fe:	e19c                	sd	a5,0(a1)
ffffffffc020b200:	00a70023          	sb	a0,0(a4)
ffffffffc020b204:	8082                	ret

ffffffffc020b206 <vprintfmt>:
ffffffffc020b206:	7119                	addi	sp,sp,-128
ffffffffc020b208:	f4a6                	sd	s1,104(sp)
ffffffffc020b20a:	f0ca                	sd	s2,96(sp)
ffffffffc020b20c:	ecce                	sd	s3,88(sp)
ffffffffc020b20e:	e8d2                	sd	s4,80(sp)
ffffffffc020b210:	e4d6                	sd	s5,72(sp)
ffffffffc020b212:	e0da                	sd	s6,64(sp)
ffffffffc020b214:	fc5e                	sd	s7,56(sp)
ffffffffc020b216:	ec6e                	sd	s11,24(sp)
ffffffffc020b218:	fc86                	sd	ra,120(sp)
ffffffffc020b21a:	f8a2                	sd	s0,112(sp)
ffffffffc020b21c:	f862                	sd	s8,48(sp)
ffffffffc020b21e:	f466                	sd	s9,40(sp)
ffffffffc020b220:	f06a                	sd	s10,32(sp)
ffffffffc020b222:	89aa                	mv	s3,a0
ffffffffc020b224:	892e                	mv	s2,a1
ffffffffc020b226:	84b2                	mv	s1,a2
ffffffffc020b228:	8db6                	mv	s11,a3
ffffffffc020b22a:	8aba                	mv	s5,a4
ffffffffc020b22c:	02500a13          	li	s4,37
ffffffffc020b230:	5bfd                	li	s7,-1
ffffffffc020b232:	00004b17          	auipc	s6,0x4
ffffffffc020b236:	272b0b13          	addi	s6,s6,626 # ffffffffc020f4a4 <sfs_node_fileops+0x144>
ffffffffc020b23a:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b23e:	001d8413          	addi	s0,s11,1
ffffffffc020b242:	01450b63          	beq	a0,s4,ffffffffc020b258 <vprintfmt+0x52>
ffffffffc020b246:	c129                	beqz	a0,ffffffffc020b288 <vprintfmt+0x82>
ffffffffc020b248:	864a                	mv	a2,s2
ffffffffc020b24a:	85a6                	mv	a1,s1
ffffffffc020b24c:	0405                	addi	s0,s0,1
ffffffffc020b24e:	9982                	jalr	s3
ffffffffc020b250:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b254:	ff4519e3          	bne	a0,s4,ffffffffc020b246 <vprintfmt+0x40>
ffffffffc020b258:	00044583          	lbu	a1,0(s0)
ffffffffc020b25c:	02000813          	li	a6,32
ffffffffc020b260:	4d01                	li	s10,0
ffffffffc020b262:	4301                	li	t1,0
ffffffffc020b264:	5cfd                	li	s9,-1
ffffffffc020b266:	5c7d                	li	s8,-1
ffffffffc020b268:	05500513          	li	a0,85
ffffffffc020b26c:	48a5                	li	a7,9
ffffffffc020b26e:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b272:	0ff67613          	zext.b	a2,a2
ffffffffc020b276:	00140d93          	addi	s11,s0,1
ffffffffc020b27a:	04c56263          	bltu	a0,a2,ffffffffc020b2be <vprintfmt+0xb8>
ffffffffc020b27e:	060a                	slli	a2,a2,0x2
ffffffffc020b280:	965a                	add	a2,a2,s6
ffffffffc020b282:	4214                	lw	a3,0(a2)
ffffffffc020b284:	96da                	add	a3,a3,s6
ffffffffc020b286:	8682                	jr	a3
ffffffffc020b288:	70e6                	ld	ra,120(sp)
ffffffffc020b28a:	7446                	ld	s0,112(sp)
ffffffffc020b28c:	74a6                	ld	s1,104(sp)
ffffffffc020b28e:	7906                	ld	s2,96(sp)
ffffffffc020b290:	69e6                	ld	s3,88(sp)
ffffffffc020b292:	6a46                	ld	s4,80(sp)
ffffffffc020b294:	6aa6                	ld	s5,72(sp)
ffffffffc020b296:	6b06                	ld	s6,64(sp)
ffffffffc020b298:	7be2                	ld	s7,56(sp)
ffffffffc020b29a:	7c42                	ld	s8,48(sp)
ffffffffc020b29c:	7ca2                	ld	s9,40(sp)
ffffffffc020b29e:	7d02                	ld	s10,32(sp)
ffffffffc020b2a0:	6de2                	ld	s11,24(sp)
ffffffffc020b2a2:	6109                	addi	sp,sp,128
ffffffffc020b2a4:	8082                	ret
ffffffffc020b2a6:	882e                	mv	a6,a1
ffffffffc020b2a8:	00144583          	lbu	a1,1(s0)
ffffffffc020b2ac:	846e                	mv	s0,s11
ffffffffc020b2ae:	00140d93          	addi	s11,s0,1
ffffffffc020b2b2:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b2b6:	0ff67613          	zext.b	a2,a2
ffffffffc020b2ba:	fcc572e3          	bgeu	a0,a2,ffffffffc020b27e <vprintfmt+0x78>
ffffffffc020b2be:	864a                	mv	a2,s2
ffffffffc020b2c0:	85a6                	mv	a1,s1
ffffffffc020b2c2:	02500513          	li	a0,37
ffffffffc020b2c6:	9982                	jalr	s3
ffffffffc020b2c8:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b2cc:	8da2                	mv	s11,s0
ffffffffc020b2ce:	f74786e3          	beq	a5,s4,ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b2d2:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b2d6:	1dfd                	addi	s11,s11,-1
ffffffffc020b2d8:	ff479de3          	bne	a5,s4,ffffffffc020b2d2 <vprintfmt+0xcc>
ffffffffc020b2dc:	bfb9                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b2de:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b2e2:	00144583          	lbu	a1,1(s0)
ffffffffc020b2e6:	846e                	mv	s0,s11
ffffffffc020b2e8:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b2ec:	0005861b          	sext.w	a2,a1
ffffffffc020b2f0:	02d8e463          	bltu	a7,a3,ffffffffc020b318 <vprintfmt+0x112>
ffffffffc020b2f4:	00144583          	lbu	a1,1(s0)
ffffffffc020b2f8:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b2fc:	0196873b          	addw	a4,a3,s9
ffffffffc020b300:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b304:	9f31                	addw	a4,a4,a2
ffffffffc020b306:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b30a:	0405                	addi	s0,s0,1
ffffffffc020b30c:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b310:	0005861b          	sext.w	a2,a1
ffffffffc020b314:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b2f4 <vprintfmt+0xee>
ffffffffc020b318:	f40c5be3          	bgez	s8,ffffffffc020b26e <vprintfmt+0x68>
ffffffffc020b31c:	8c66                	mv	s8,s9
ffffffffc020b31e:	5cfd                	li	s9,-1
ffffffffc020b320:	b7b9                	j	ffffffffc020b26e <vprintfmt+0x68>
ffffffffc020b322:	fffc4693          	not	a3,s8
ffffffffc020b326:	96fd                	srai	a3,a3,0x3f
ffffffffc020b328:	00dc77b3          	and	a5,s8,a3
ffffffffc020b32c:	00144583          	lbu	a1,1(s0)
ffffffffc020b330:	00078c1b          	sext.w	s8,a5
ffffffffc020b334:	846e                	mv	s0,s11
ffffffffc020b336:	bf25                	j	ffffffffc020b26e <vprintfmt+0x68>
ffffffffc020b338:	000aac83          	lw	s9,0(s5)
ffffffffc020b33c:	00144583          	lbu	a1,1(s0)
ffffffffc020b340:	0aa1                	addi	s5,s5,8
ffffffffc020b342:	846e                	mv	s0,s11
ffffffffc020b344:	bfd1                	j	ffffffffc020b318 <vprintfmt+0x112>
ffffffffc020b346:	4705                	li	a4,1
ffffffffc020b348:	008a8613          	addi	a2,s5,8
ffffffffc020b34c:	00674463          	blt	a4,t1,ffffffffc020b354 <vprintfmt+0x14e>
ffffffffc020b350:	1c030c63          	beqz	t1,ffffffffc020b528 <vprintfmt+0x322>
ffffffffc020b354:	000ab683          	ld	a3,0(s5)
ffffffffc020b358:	4741                	li	a4,16
ffffffffc020b35a:	8ab2                	mv	s5,a2
ffffffffc020b35c:	2801                	sext.w	a6,a6
ffffffffc020b35e:	87e2                	mv	a5,s8
ffffffffc020b360:	8626                	mv	a2,s1
ffffffffc020b362:	85ca                	mv	a1,s2
ffffffffc020b364:	854e                	mv	a0,s3
ffffffffc020b366:	e11ff0ef          	jal	ra,ffffffffc020b176 <printnum>
ffffffffc020b36a:	bdc1                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b36c:	000aa503          	lw	a0,0(s5)
ffffffffc020b370:	864a                	mv	a2,s2
ffffffffc020b372:	85a6                	mv	a1,s1
ffffffffc020b374:	0aa1                	addi	s5,s5,8
ffffffffc020b376:	9982                	jalr	s3
ffffffffc020b378:	b5c9                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b37a:	4705                	li	a4,1
ffffffffc020b37c:	008a8613          	addi	a2,s5,8
ffffffffc020b380:	00674463          	blt	a4,t1,ffffffffc020b388 <vprintfmt+0x182>
ffffffffc020b384:	18030d63          	beqz	t1,ffffffffc020b51e <vprintfmt+0x318>
ffffffffc020b388:	000ab683          	ld	a3,0(s5)
ffffffffc020b38c:	4729                	li	a4,10
ffffffffc020b38e:	8ab2                	mv	s5,a2
ffffffffc020b390:	b7f1                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b392:	00144583          	lbu	a1,1(s0)
ffffffffc020b396:	4d05                	li	s10,1
ffffffffc020b398:	846e                	mv	s0,s11
ffffffffc020b39a:	bdd1                	j	ffffffffc020b26e <vprintfmt+0x68>
ffffffffc020b39c:	864a                	mv	a2,s2
ffffffffc020b39e:	85a6                	mv	a1,s1
ffffffffc020b3a0:	02500513          	li	a0,37
ffffffffc020b3a4:	9982                	jalr	s3
ffffffffc020b3a6:	bd51                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b3a8:	00144583          	lbu	a1,1(s0)
ffffffffc020b3ac:	2305                	addiw	t1,t1,1
ffffffffc020b3ae:	846e                	mv	s0,s11
ffffffffc020b3b0:	bd7d                	j	ffffffffc020b26e <vprintfmt+0x68>
ffffffffc020b3b2:	4705                	li	a4,1
ffffffffc020b3b4:	008a8613          	addi	a2,s5,8
ffffffffc020b3b8:	00674463          	blt	a4,t1,ffffffffc020b3c0 <vprintfmt+0x1ba>
ffffffffc020b3bc:	14030c63          	beqz	t1,ffffffffc020b514 <vprintfmt+0x30e>
ffffffffc020b3c0:	000ab683          	ld	a3,0(s5)
ffffffffc020b3c4:	4721                	li	a4,8
ffffffffc020b3c6:	8ab2                	mv	s5,a2
ffffffffc020b3c8:	bf51                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b3ca:	03000513          	li	a0,48
ffffffffc020b3ce:	864a                	mv	a2,s2
ffffffffc020b3d0:	85a6                	mv	a1,s1
ffffffffc020b3d2:	e042                	sd	a6,0(sp)
ffffffffc020b3d4:	9982                	jalr	s3
ffffffffc020b3d6:	864a                	mv	a2,s2
ffffffffc020b3d8:	85a6                	mv	a1,s1
ffffffffc020b3da:	07800513          	li	a0,120
ffffffffc020b3de:	9982                	jalr	s3
ffffffffc020b3e0:	0aa1                	addi	s5,s5,8
ffffffffc020b3e2:	6802                	ld	a6,0(sp)
ffffffffc020b3e4:	4741                	li	a4,16
ffffffffc020b3e6:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b3ea:	bf8d                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b3ec:	000ab403          	ld	s0,0(s5)
ffffffffc020b3f0:	008a8793          	addi	a5,s5,8
ffffffffc020b3f4:	e03e                	sd	a5,0(sp)
ffffffffc020b3f6:	14040c63          	beqz	s0,ffffffffc020b54e <vprintfmt+0x348>
ffffffffc020b3fa:	11805063          	blez	s8,ffffffffc020b4fa <vprintfmt+0x2f4>
ffffffffc020b3fe:	02d00693          	li	a3,45
ffffffffc020b402:	0cd81963          	bne	a6,a3,ffffffffc020b4d4 <vprintfmt+0x2ce>
ffffffffc020b406:	00044683          	lbu	a3,0(s0)
ffffffffc020b40a:	0006851b          	sext.w	a0,a3
ffffffffc020b40e:	ce8d                	beqz	a3,ffffffffc020b448 <vprintfmt+0x242>
ffffffffc020b410:	00140a93          	addi	s5,s0,1
ffffffffc020b414:	05e00413          	li	s0,94
ffffffffc020b418:	000cc563          	bltz	s9,ffffffffc020b422 <vprintfmt+0x21c>
ffffffffc020b41c:	3cfd                	addiw	s9,s9,-1
ffffffffc020b41e:	037c8363          	beq	s9,s7,ffffffffc020b444 <vprintfmt+0x23e>
ffffffffc020b422:	864a                	mv	a2,s2
ffffffffc020b424:	85a6                	mv	a1,s1
ffffffffc020b426:	100d0663          	beqz	s10,ffffffffc020b532 <vprintfmt+0x32c>
ffffffffc020b42a:	3681                	addiw	a3,a3,-32
ffffffffc020b42c:	10d47363          	bgeu	s0,a3,ffffffffc020b532 <vprintfmt+0x32c>
ffffffffc020b430:	03f00513          	li	a0,63
ffffffffc020b434:	9982                	jalr	s3
ffffffffc020b436:	000ac683          	lbu	a3,0(s5)
ffffffffc020b43a:	3c7d                	addiw	s8,s8,-1
ffffffffc020b43c:	0a85                	addi	s5,s5,1
ffffffffc020b43e:	0006851b          	sext.w	a0,a3
ffffffffc020b442:	faf9                	bnez	a3,ffffffffc020b418 <vprintfmt+0x212>
ffffffffc020b444:	01805a63          	blez	s8,ffffffffc020b458 <vprintfmt+0x252>
ffffffffc020b448:	3c7d                	addiw	s8,s8,-1
ffffffffc020b44a:	864a                	mv	a2,s2
ffffffffc020b44c:	85a6                	mv	a1,s1
ffffffffc020b44e:	02000513          	li	a0,32
ffffffffc020b452:	9982                	jalr	s3
ffffffffc020b454:	fe0c1ae3          	bnez	s8,ffffffffc020b448 <vprintfmt+0x242>
ffffffffc020b458:	6a82                	ld	s5,0(sp)
ffffffffc020b45a:	b3c5                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b45c:	4705                	li	a4,1
ffffffffc020b45e:	008a8d13          	addi	s10,s5,8
ffffffffc020b462:	00674463          	blt	a4,t1,ffffffffc020b46a <vprintfmt+0x264>
ffffffffc020b466:	0a030463          	beqz	t1,ffffffffc020b50e <vprintfmt+0x308>
ffffffffc020b46a:	000ab403          	ld	s0,0(s5)
ffffffffc020b46e:	0c044463          	bltz	s0,ffffffffc020b536 <vprintfmt+0x330>
ffffffffc020b472:	86a2                	mv	a3,s0
ffffffffc020b474:	8aea                	mv	s5,s10
ffffffffc020b476:	4729                	li	a4,10
ffffffffc020b478:	b5d5                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b47a:	000aa783          	lw	a5,0(s5)
ffffffffc020b47e:	46e1                	li	a3,24
ffffffffc020b480:	0aa1                	addi	s5,s5,8
ffffffffc020b482:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b486:	8fb9                	xor	a5,a5,a4
ffffffffc020b488:	40e7873b          	subw	a4,a5,a4
ffffffffc020b48c:	02e6c663          	blt	a3,a4,ffffffffc020b4b8 <vprintfmt+0x2b2>
ffffffffc020b490:	00371793          	slli	a5,a4,0x3
ffffffffc020b494:	00004697          	auipc	a3,0x4
ffffffffc020b498:	34468693          	addi	a3,a3,836 # ffffffffc020f7d8 <error_string>
ffffffffc020b49c:	97b6                	add	a5,a5,a3
ffffffffc020b49e:	639c                	ld	a5,0(a5)
ffffffffc020b4a0:	cf81                	beqz	a5,ffffffffc020b4b8 <vprintfmt+0x2b2>
ffffffffc020b4a2:	873e                	mv	a4,a5
ffffffffc020b4a4:	00000697          	auipc	a3,0x0
ffffffffc020b4a8:	28468693          	addi	a3,a3,644 # ffffffffc020b728 <etext+0x2a>
ffffffffc020b4ac:	8626                	mv	a2,s1
ffffffffc020b4ae:	85ca                	mv	a1,s2
ffffffffc020b4b0:	854e                	mv	a0,s3
ffffffffc020b4b2:	0d4000ef          	jal	ra,ffffffffc020b586 <printfmt>
ffffffffc020b4b6:	b351                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b4b8:	00004697          	auipc	a3,0x4
ffffffffc020b4bc:	fe068693          	addi	a3,a3,-32 # ffffffffc020f498 <sfs_node_fileops+0x138>
ffffffffc020b4c0:	8626                	mv	a2,s1
ffffffffc020b4c2:	85ca                	mv	a1,s2
ffffffffc020b4c4:	854e                	mv	a0,s3
ffffffffc020b4c6:	0c0000ef          	jal	ra,ffffffffc020b586 <printfmt>
ffffffffc020b4ca:	bb85                	j	ffffffffc020b23a <vprintfmt+0x34>
ffffffffc020b4cc:	00004417          	auipc	s0,0x4
ffffffffc020b4d0:	fc440413          	addi	s0,s0,-60 # ffffffffc020f490 <sfs_node_fileops+0x130>
ffffffffc020b4d4:	85e6                	mv	a1,s9
ffffffffc020b4d6:	8522                	mv	a0,s0
ffffffffc020b4d8:	e442                	sd	a6,8(sp)
ffffffffc020b4da:	132000ef          	jal	ra,ffffffffc020b60c <strnlen>
ffffffffc020b4de:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b4e2:	01805c63          	blez	s8,ffffffffc020b4fa <vprintfmt+0x2f4>
ffffffffc020b4e6:	6822                	ld	a6,8(sp)
ffffffffc020b4e8:	00080a9b          	sext.w	s5,a6
ffffffffc020b4ec:	3c7d                	addiw	s8,s8,-1
ffffffffc020b4ee:	864a                	mv	a2,s2
ffffffffc020b4f0:	85a6                	mv	a1,s1
ffffffffc020b4f2:	8556                	mv	a0,s5
ffffffffc020b4f4:	9982                	jalr	s3
ffffffffc020b4f6:	fe0c1be3          	bnez	s8,ffffffffc020b4ec <vprintfmt+0x2e6>
ffffffffc020b4fa:	00044683          	lbu	a3,0(s0)
ffffffffc020b4fe:	00140a93          	addi	s5,s0,1
ffffffffc020b502:	0006851b          	sext.w	a0,a3
ffffffffc020b506:	daa9                	beqz	a3,ffffffffc020b458 <vprintfmt+0x252>
ffffffffc020b508:	05e00413          	li	s0,94
ffffffffc020b50c:	b731                	j	ffffffffc020b418 <vprintfmt+0x212>
ffffffffc020b50e:	000aa403          	lw	s0,0(s5)
ffffffffc020b512:	bfb1                	j	ffffffffc020b46e <vprintfmt+0x268>
ffffffffc020b514:	000ae683          	lwu	a3,0(s5)
ffffffffc020b518:	4721                	li	a4,8
ffffffffc020b51a:	8ab2                	mv	s5,a2
ffffffffc020b51c:	b581                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b51e:	000ae683          	lwu	a3,0(s5)
ffffffffc020b522:	4729                	li	a4,10
ffffffffc020b524:	8ab2                	mv	s5,a2
ffffffffc020b526:	bd1d                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b528:	000ae683          	lwu	a3,0(s5)
ffffffffc020b52c:	4741                	li	a4,16
ffffffffc020b52e:	8ab2                	mv	s5,a2
ffffffffc020b530:	b535                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b532:	9982                	jalr	s3
ffffffffc020b534:	b709                	j	ffffffffc020b436 <vprintfmt+0x230>
ffffffffc020b536:	864a                	mv	a2,s2
ffffffffc020b538:	85a6                	mv	a1,s1
ffffffffc020b53a:	02d00513          	li	a0,45
ffffffffc020b53e:	e042                	sd	a6,0(sp)
ffffffffc020b540:	9982                	jalr	s3
ffffffffc020b542:	6802                	ld	a6,0(sp)
ffffffffc020b544:	8aea                	mv	s5,s10
ffffffffc020b546:	408006b3          	neg	a3,s0
ffffffffc020b54a:	4729                	li	a4,10
ffffffffc020b54c:	bd01                	j	ffffffffc020b35c <vprintfmt+0x156>
ffffffffc020b54e:	03805163          	blez	s8,ffffffffc020b570 <vprintfmt+0x36a>
ffffffffc020b552:	02d00693          	li	a3,45
ffffffffc020b556:	f6d81be3          	bne	a6,a3,ffffffffc020b4cc <vprintfmt+0x2c6>
ffffffffc020b55a:	00004417          	auipc	s0,0x4
ffffffffc020b55e:	f3640413          	addi	s0,s0,-202 # ffffffffc020f490 <sfs_node_fileops+0x130>
ffffffffc020b562:	02800693          	li	a3,40
ffffffffc020b566:	02800513          	li	a0,40
ffffffffc020b56a:	00140a93          	addi	s5,s0,1
ffffffffc020b56e:	b55d                	j	ffffffffc020b414 <vprintfmt+0x20e>
ffffffffc020b570:	00004a97          	auipc	s5,0x4
ffffffffc020b574:	f21a8a93          	addi	s5,s5,-223 # ffffffffc020f491 <sfs_node_fileops+0x131>
ffffffffc020b578:	02800513          	li	a0,40
ffffffffc020b57c:	02800693          	li	a3,40
ffffffffc020b580:	05e00413          	li	s0,94
ffffffffc020b584:	bd51                	j	ffffffffc020b418 <vprintfmt+0x212>

ffffffffc020b586 <printfmt>:
ffffffffc020b586:	7139                	addi	sp,sp,-64
ffffffffc020b588:	02010313          	addi	t1,sp,32
ffffffffc020b58c:	f03a                	sd	a4,32(sp)
ffffffffc020b58e:	871a                	mv	a4,t1
ffffffffc020b590:	ec06                	sd	ra,24(sp)
ffffffffc020b592:	f43e                	sd	a5,40(sp)
ffffffffc020b594:	f842                	sd	a6,48(sp)
ffffffffc020b596:	fc46                	sd	a7,56(sp)
ffffffffc020b598:	e41a                	sd	t1,8(sp)
ffffffffc020b59a:	c6dff0ef          	jal	ra,ffffffffc020b206 <vprintfmt>
ffffffffc020b59e:	60e2                	ld	ra,24(sp)
ffffffffc020b5a0:	6121                	addi	sp,sp,64
ffffffffc020b5a2:	8082                	ret

ffffffffc020b5a4 <snprintf>:
ffffffffc020b5a4:	711d                	addi	sp,sp,-96
ffffffffc020b5a6:	15fd                	addi	a1,a1,-1
ffffffffc020b5a8:	03810313          	addi	t1,sp,56
ffffffffc020b5ac:	95aa                	add	a1,a1,a0
ffffffffc020b5ae:	f406                	sd	ra,40(sp)
ffffffffc020b5b0:	fc36                	sd	a3,56(sp)
ffffffffc020b5b2:	e0ba                	sd	a4,64(sp)
ffffffffc020b5b4:	e4be                	sd	a5,72(sp)
ffffffffc020b5b6:	e8c2                	sd	a6,80(sp)
ffffffffc020b5b8:	ecc6                	sd	a7,88(sp)
ffffffffc020b5ba:	e01a                	sd	t1,0(sp)
ffffffffc020b5bc:	e42a                	sd	a0,8(sp)
ffffffffc020b5be:	e82e                	sd	a1,16(sp)
ffffffffc020b5c0:	cc02                	sw	zero,24(sp)
ffffffffc020b5c2:	c515                	beqz	a0,ffffffffc020b5ee <snprintf+0x4a>
ffffffffc020b5c4:	02a5e563          	bltu	a1,a0,ffffffffc020b5ee <snprintf+0x4a>
ffffffffc020b5c8:	75dd                	lui	a1,0xffff7
ffffffffc020b5ca:	86b2                	mv	a3,a2
ffffffffc020b5cc:	00000517          	auipc	a0,0x0
ffffffffc020b5d0:	c2050513          	addi	a0,a0,-992 # ffffffffc020b1ec <sprintputch>
ffffffffc020b5d4:	871a                	mv	a4,t1
ffffffffc020b5d6:	0030                	addi	a2,sp,8
ffffffffc020b5d8:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b5dc:	c2bff0ef          	jal	ra,ffffffffc020b206 <vprintfmt>
ffffffffc020b5e0:	67a2                	ld	a5,8(sp)
ffffffffc020b5e2:	00078023          	sb	zero,0(a5)
ffffffffc020b5e6:	4562                	lw	a0,24(sp)
ffffffffc020b5e8:	70a2                	ld	ra,40(sp)
ffffffffc020b5ea:	6125                	addi	sp,sp,96
ffffffffc020b5ec:	8082                	ret
ffffffffc020b5ee:	5575                	li	a0,-3
ffffffffc020b5f0:	bfe5                	j	ffffffffc020b5e8 <snprintf+0x44>

ffffffffc020b5f2 <strlen>:
ffffffffc020b5f2:	00054783          	lbu	a5,0(a0)
ffffffffc020b5f6:	872a                	mv	a4,a0
ffffffffc020b5f8:	4501                	li	a0,0
ffffffffc020b5fa:	cb81                	beqz	a5,ffffffffc020b60a <strlen+0x18>
ffffffffc020b5fc:	0505                	addi	a0,a0,1
ffffffffc020b5fe:	00a707b3          	add	a5,a4,a0
ffffffffc020b602:	0007c783          	lbu	a5,0(a5)
ffffffffc020b606:	fbfd                	bnez	a5,ffffffffc020b5fc <strlen+0xa>
ffffffffc020b608:	8082                	ret
ffffffffc020b60a:	8082                	ret

ffffffffc020b60c <strnlen>:
ffffffffc020b60c:	4781                	li	a5,0
ffffffffc020b60e:	e589                	bnez	a1,ffffffffc020b618 <strnlen+0xc>
ffffffffc020b610:	a811                	j	ffffffffc020b624 <strnlen+0x18>
ffffffffc020b612:	0785                	addi	a5,a5,1
ffffffffc020b614:	00f58863          	beq	a1,a5,ffffffffc020b624 <strnlen+0x18>
ffffffffc020b618:	00f50733          	add	a4,a0,a5
ffffffffc020b61c:	00074703          	lbu	a4,0(a4)
ffffffffc020b620:	fb6d                	bnez	a4,ffffffffc020b612 <strnlen+0x6>
ffffffffc020b622:	85be                	mv	a1,a5
ffffffffc020b624:	852e                	mv	a0,a1
ffffffffc020b626:	8082                	ret

ffffffffc020b628 <strcpy>:
ffffffffc020b628:	87aa                	mv	a5,a0
ffffffffc020b62a:	0005c703          	lbu	a4,0(a1)
ffffffffc020b62e:	0785                	addi	a5,a5,1
ffffffffc020b630:	0585                	addi	a1,a1,1
ffffffffc020b632:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b636:	fb75                	bnez	a4,ffffffffc020b62a <strcpy+0x2>
ffffffffc020b638:	8082                	ret

ffffffffc020b63a <strcmp>:
ffffffffc020b63a:	00054783          	lbu	a5,0(a0)
ffffffffc020b63e:	0005c703          	lbu	a4,0(a1)
ffffffffc020b642:	cb89                	beqz	a5,ffffffffc020b654 <strcmp+0x1a>
ffffffffc020b644:	0505                	addi	a0,a0,1
ffffffffc020b646:	0585                	addi	a1,a1,1
ffffffffc020b648:	fee789e3          	beq	a5,a4,ffffffffc020b63a <strcmp>
ffffffffc020b64c:	0007851b          	sext.w	a0,a5
ffffffffc020b650:	9d19                	subw	a0,a0,a4
ffffffffc020b652:	8082                	ret
ffffffffc020b654:	4501                	li	a0,0
ffffffffc020b656:	bfed                	j	ffffffffc020b650 <strcmp+0x16>

ffffffffc020b658 <strncmp>:
ffffffffc020b658:	c20d                	beqz	a2,ffffffffc020b67a <strncmp+0x22>
ffffffffc020b65a:	962e                	add	a2,a2,a1
ffffffffc020b65c:	a031                	j	ffffffffc020b668 <strncmp+0x10>
ffffffffc020b65e:	0505                	addi	a0,a0,1
ffffffffc020b660:	00e79a63          	bne	a5,a4,ffffffffc020b674 <strncmp+0x1c>
ffffffffc020b664:	00b60b63          	beq	a2,a1,ffffffffc020b67a <strncmp+0x22>
ffffffffc020b668:	00054783          	lbu	a5,0(a0)
ffffffffc020b66c:	0585                	addi	a1,a1,1
ffffffffc020b66e:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b672:	f7f5                	bnez	a5,ffffffffc020b65e <strncmp+0x6>
ffffffffc020b674:	40e7853b          	subw	a0,a5,a4
ffffffffc020b678:	8082                	ret
ffffffffc020b67a:	4501                	li	a0,0
ffffffffc020b67c:	8082                	ret

ffffffffc020b67e <strchr>:
ffffffffc020b67e:	00054783          	lbu	a5,0(a0)
ffffffffc020b682:	c799                	beqz	a5,ffffffffc020b690 <strchr+0x12>
ffffffffc020b684:	00f58763          	beq	a1,a5,ffffffffc020b692 <strchr+0x14>
ffffffffc020b688:	00154783          	lbu	a5,1(a0)
ffffffffc020b68c:	0505                	addi	a0,a0,1
ffffffffc020b68e:	fbfd                	bnez	a5,ffffffffc020b684 <strchr+0x6>
ffffffffc020b690:	4501                	li	a0,0
ffffffffc020b692:	8082                	ret

ffffffffc020b694 <memset>:
ffffffffc020b694:	ca01                	beqz	a2,ffffffffc020b6a4 <memset+0x10>
ffffffffc020b696:	962a                	add	a2,a2,a0
ffffffffc020b698:	87aa                	mv	a5,a0
ffffffffc020b69a:	0785                	addi	a5,a5,1
ffffffffc020b69c:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b6a0:	fec79de3          	bne	a5,a2,ffffffffc020b69a <memset+0x6>
ffffffffc020b6a4:	8082                	ret

ffffffffc020b6a6 <memmove>:
ffffffffc020b6a6:	02a5f263          	bgeu	a1,a0,ffffffffc020b6ca <memmove+0x24>
ffffffffc020b6aa:	00c587b3          	add	a5,a1,a2
ffffffffc020b6ae:	00f57e63          	bgeu	a0,a5,ffffffffc020b6ca <memmove+0x24>
ffffffffc020b6b2:	00c50733          	add	a4,a0,a2
ffffffffc020b6b6:	c615                	beqz	a2,ffffffffc020b6e2 <memmove+0x3c>
ffffffffc020b6b8:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b6bc:	17fd                	addi	a5,a5,-1
ffffffffc020b6be:	177d                	addi	a4,a4,-1
ffffffffc020b6c0:	00d70023          	sb	a3,0(a4)
ffffffffc020b6c4:	fef59ae3          	bne	a1,a5,ffffffffc020b6b8 <memmove+0x12>
ffffffffc020b6c8:	8082                	ret
ffffffffc020b6ca:	00c586b3          	add	a3,a1,a2
ffffffffc020b6ce:	87aa                	mv	a5,a0
ffffffffc020b6d0:	ca11                	beqz	a2,ffffffffc020b6e4 <memmove+0x3e>
ffffffffc020b6d2:	0005c703          	lbu	a4,0(a1)
ffffffffc020b6d6:	0585                	addi	a1,a1,1
ffffffffc020b6d8:	0785                	addi	a5,a5,1
ffffffffc020b6da:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b6de:	fed59ae3          	bne	a1,a3,ffffffffc020b6d2 <memmove+0x2c>
ffffffffc020b6e2:	8082                	ret
ffffffffc020b6e4:	8082                	ret

ffffffffc020b6e6 <memcpy>:
ffffffffc020b6e6:	ca19                	beqz	a2,ffffffffc020b6fc <memcpy+0x16>
ffffffffc020b6e8:	962e                	add	a2,a2,a1
ffffffffc020b6ea:	87aa                	mv	a5,a0
ffffffffc020b6ec:	0005c703          	lbu	a4,0(a1)
ffffffffc020b6f0:	0585                	addi	a1,a1,1
ffffffffc020b6f2:	0785                	addi	a5,a5,1
ffffffffc020b6f4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b6f8:	fec59ae3          	bne	a1,a2,ffffffffc020b6ec <memcpy+0x6>
ffffffffc020b6fc:	8082                	ret
