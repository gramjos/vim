
statements:	file format mach-o 64-bit x86-64


Disassembly of section __TEXT,__text:

0000000000000000 <_main>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 48 8d 3d 10 00 00 00         	leaq	16(%rip), %rdi  # 1b <_main+0x1b>
       b: be 38 a2 87 00               	movl	$8888888, %esi
      10: 31 c0                        	xorl	%eax, %eax
      12: e8 00 00 00 00               	callq	0x17 <_main+0x17>
      17: 31 c0                        	xorl	%eax, %eax
      19: 5d                           	popq	%rbp
      1a: c3                           	retq

Disassembly of section __TEXT,__cstring:

000000000000001b <__cstring>:
      1b: 74 68                        	je	0x85 <__cstring+0x6a>
      1d: 69 73 20 6e 75 6d 3a         	imull	$980252014, 32(%rbx), %esi
      24: 20 25                        	<unknown>
      26: 64 0a 00                     	orb	%fs:(%rax), %al

Disassembly of section __DWARF,__debug_loc:

0000000000000029 <__debug_loc>:
		...
      31: 0b 00                        	orl	(%rax), %eax
      33: 00 00                        	addb	%al, (%rax)
      35: 00 00                        	addb	%al, (%rax)
      37: 00 00                        	addb	%al, (%rax)
      39: 01 00                        	addl	%eax, (%rax)
      3b: 55                           	pushq	%rbp
      3c: 0b 00                        	orl	(%rax), %eax
      3e: 00 00                        	addb	%al, (%rax)
      40: 00 00                        	addb	%al, (%rax)
      42: 00 00                        	addb	%al, (%rax)
      44: 1b 00                        	sbbl	(%rax), %eax
      46: 00 00                        	addb	%al, (%rax)
      48: 00 00                        	addb	%al, (%rax)
      4a: 00 00                        	addb	%al, (%rax)
      4c: 04 00                        	addb	$0, %al
      4e: a3 01 55 9f 00 00 00 00 00   	movabsl	%eax, 10441985
		...
      67: 00 00                        	addb	%al, (%rax)
      69: 00 10                        	addb	%dl, (%rax)
      6b: 00 00                        	addb	%al, (%rax)
      6d: 00 00                        	addb	%al, (%rax)
      6f: 00 00                        	addb	%al, (%rax)
      71: 00 01                        	addb	%al, (%rcx)
      73: 00 54 10 00                  	addb	%dl, (%rax,%rdx)
      77: 00 00                        	addb	%al, (%rax)
      79: 00 00                        	addb	%al, (%rax)
      7b: 00 00                        	addb	%al, (%rax)
      7d: 1b 00                        	sbbl	(%rax), %eax
      7f: 00 00                        	addb	%al, (%rax)
      81: 00 00                        	addb	%al, (%rax)
      83: 00 00                        	addb	%al, (%rax)
      85: 04 00                        	addb	$0, %al
      87: a3 01 54 9f 00 00 00 00 00   	movabsl	%eax, 10441729
		...
      98: 00 00                        	addb	%al, (%rax)
      9a: 00                           	<unknown>

Disassembly of section __DWARF,__debug_abbrev:

000000000000009b <__debug_abbrev>:
      9b: 01 11                        	addl	%edx, (%rcx)
      9d: 01 25 0e 13 05 03            	addl	%esp, 50664206(%rip)  # 30513b1 <__debug_abbrev+0x3051316>
      a3: 0e                           	<unknown>
      a4: 82                           	<unknown>
      a5: 7c 0e                        	jl	0xb5 <__debug_abbrev+0x1a>
      a7: ef                           	outl	%eax, %dx
      a8: 7f 0e                        	jg	0xb8 <__debug_abbrev+0x1d>
      aa: 10 17                        	adcb	%dl, (%rdi)
      ac: 1b 0e                        	sbbl	(%rsi), %ecx
      ae: e1 7f                        	loope	0x12f <__debug_abbrev+0x94>
      b0: 19 11                        	sbbl	%edx, (%rcx)
      b2: 01 12                        	addl	%edx, (%rdx)
      b4: 06                           	<unknown>
      b5: 00 00                        	addb	%al, (%rax)
      b7: 02 2e                        	addb	(%rsi), %ch
      b9: 01 11                        	addl	%edx, (%rcx)
      bb: 01 12                        	addl	%edx, (%rdx)
      bd: 06                           	<unknown>
      be: 40 18 7a 19                  	sbbb	%dil, 25(%rdx)
      c2: 03 0e                        	addl	(%rsi), %ecx
      c4: 3a 0b                        	cmpb	(%rbx), %cl
      c6: 3b 0b                        	cmpl	(%rbx), %ecx
      c8: 27                           	<unknown>
      c9: 19 49 13                     	sbbl	%ecx, 19(%rcx)
      cc: 3f                           	<unknown>
      cd: 19 e1                        	sbbl	%esp, %ecx
      cf: 7f 19                        	jg	0xea <__debug_abbrev+0x4f>
      d1: 00 00                        	addb	%al, (%rax)
      d3: 03 05 00 02 17 03            	addl	51839488(%rip), %eax  # 31702d9 <__debug_abbrev+0x317023e>
      d9: 0e                           	<unknown>
      da: 3a 0b                        	cmpb	(%rbx), %cl
      dc: 3b 0b                        	cmpl	(%rbx), %ecx
      de: 49 13 00                     	adcq	(%r8), %rax
      e1: 00 04 34                     	addb	%al, (%rsp,%rsi)
      e4: 00 1c 0d 03 0e 3a 0b         	addb	%bl, 188354051(,%rcx)
      eb: 3b 0b                        	cmpl	(%rbx), %ecx
      ed: 49 13 00                     	adcq	(%r8), %rax
      f0: 00 05 24 00 03 0e            	addb	%al, 235077668(%rip)  # e03011a <__debug_abbrev+0xe03007f>
      f6: 3e 0b 0b                     	orl	%ds:(%rbx), %ecx
      f9: 0b 00                        	orl	(%rax), %eax
      fb: 00 06                        	addb	%al, (%rsi)
      fd: 0f 00 49 13                  	strw	19(%rcx)
     101: 00 00                        	addb	%al, (%rax)
     103: 00                           	<unknown>

Disassembly of section __DWARF,__debug_info:

0000000000000104 <__debug_info>:
     104: 8e 00                        	movw	(%rax), %es
     106: 00 00                        	addb	%al, (%rax)
     108: 04 00                        	addb	$0, %al
     10a: 00 00                        	addb	%al, (%rax)
     10c: 00 00                        	addb	%al, (%rax)
     10e: 08 01                        	orb	%al, (%rcx)
     110: 00 00                        	addb	%al, (%rax)
     112: 00 00                        	addb	%al, (%rax)
     114: 0c 00                        	orb	$0, %al
     116: 2f                           	<unknown>
     117: 00 00                        	addb	%al, (%rax)
     119: 00 3c 00                     	addb	%bh, (%rax,%rax)
     11c: 00 00                        	addb	%al, (%rax)
     11e: 9b                           	wait
     11f: 00 00                        	addb	%al, (%rax)
     121: 00 00                        	addb	%al, (%rax)
     123: 00 00                        	addb	%al, (%rax)
     125: 00 a6 00 00 00 00            	addb	%ah, (%rsi)
     12b: 00 00                        	addb	%al, (%rax)
     12d: 00 00                        	addb	%al, (%rax)
     12f: 00 00                        	addb	%al, (%rax)
     131: 00 1b                        	addb	%bl, (%rbx)
     133: 00 00                        	addb	%al, (%rax)
     135: 00 02                        	addb	%al, (%rdx)
		...
     13f: 1b 00                        	sbbl	(%rax), %eax
     141: 00 00                        	addb	%al, (%rax)
     143: 01 56 c9                     	addl	%edx, -55(%rsi)
     146: 00 00                        	addb	%al, (%rax)
     148: 00 01                        	addb	%al, (%rcx)
     14a: 04 79                        	addb	$121, %al
     14c: 00 00                        	addb	%al, (%rax)
     14e: 00 03                        	addb	%al, (%rbx)
     150: 00 00                        	addb	%al, (%rax)
     152: 00 00                        	addb	%al, (%rax)
     154: d2 00                        	rolb	%cl, (%rax)
     156: 00 00                        	addb	%al, (%rax)
     158: 01 04 79                     	addl	%eax, (%rcx,%rdi,2)
     15b: 00 00                        	addb	%al, (%rax)
     15d: 00 03                        	addb	%al, (%rbx)
     15f: 39 00                        	cmpl	%eax, (%rax)
     161: 00 00                        	addb	%al, (%rax)
     163: d7                           	xlatb
     164: 00 00                        	addb	%al, (%rax)
     166: 00 01                        	addb	%al, (%rcx)
     168: 04 80                        	addb	$-128, %al
     16a: 00 00                        	addb	%al, (%rax)
     16c: 00 04 b8                     	addb	%al, (%rax,%rdi,4)
     16f: c4 9e 04                     	<unknown>
     172: e1 00                        	loope	0x174 <__debug_info+0x70>
     174: 00 00                        	addb	%al, (%rax)
     176: 01 05 79 00 00 00            	addl	%eax, 121(%rip)  # 1f5 <__debug_info+0xf1>
     17c: 00 05 ce 00 00 00            	addb	%al, 206(%rip)  # 250 <__debug_info+0x14c>
     182: 05 04 06 85 00               	addl	$8717828, %eax
     187: 00 00                        	addb	%al, (%rax)
     189: 06                           	<unknown>
     18a: 8a 00                        	movb	(%rax), %al
     18c: 00 00                        	addb	%al, (%rax)
     18e: 05 dc 00 00 00               	addl	$220, %eax
     193: 06                           	<unknown>
     194: 01 00                        	addl	%eax, (%rax)

Disassembly of section __DWARF,__debug_str:

0000000000000196 <__debug_str>:
     196: 41 70 70                     	jo	0x209 <__debug_str+0x73>
     199: 6c                           	insb	%dx, %es:(%rdi)
     19a: 65 20 63 6c                  	andb	%ah, %gs:108(%rbx)
     19e: 61                           	<unknown>
     19f: 6e                           	outsb	(%rsi), %dx
     1a0: 67 20 76 65                  	andb	%dh, 101(%esi)
     1a4: 72 73                        	jb	0x219 <__debug_str+0x83>
     1a6: 69 6f 6e 20 31 33 2e         	imull	$775106848, 110(%rdi), %ebp
     1ad: 30 2e                        	xorb	%ch, (%rsi)
     1af: 30 20                        	xorb	%ah, (%rax)
     1b1: 28 63 6c                     	subb	%ah, 108(%rbx)
     1b4: 61                           	<unknown>
     1b5: 6e                           	outsb	(%rsi), %dx
     1b6: 67 2d 31 33 30 30            	subl	$808465201, %eax
     1bc: 2e 30 2e                     	xorb	%ch, %cs:(%rsi)
     1bf: 32 39                        	xorb	(%rcx), %bh
     1c1: 2e 33 29                     	xorl	%cs:(%rcx), %ebp
     1c4: 00 73 74                     	addb	%dh, 116(%rbx)
     1c7: 61                           	<unknown>
     1c8: 74 65                        	je	0x22f <__debug_str+0x99>
     1ca: 6d                           	insl	%dx, %es:(%rdi)
     1cb: 65 6e                        	outsb	%gs:(%rsi), %dx
     1cd: 74 73                        	je	0x242 <__debug_str+0xac>
     1cf: 2e 63 00                     	movslq	%cs:(%rax), %eax
     1d2: 2f                           	<unknown>
     1d3: 41 70 70                     	jo	0x246 <__debug_str+0xb0>
     1d6: 6c                           	insb	%dx, %es:(%rdi)
     1d7: 69 63 61 74 69 6f 6e         	imull	$1852795252, 97(%rbx), %esp
     1de: 73 2f                        	jae	0x20f <__debug_str+0x79>
     1e0: 58                           	popq	%rax
     1e1: 63 6f 64                     	movslq	100(%rdi), %ebp
     1e4: 65 2e 61                     	<unknown>
     1e7: 70 70                        	jo	0x259 <__debug_str+0xc3>
     1e9: 2f                           	<unknown>
     1ea: 43 6f                        	outsl	(%rsi), %dx
     1ec: 6e                           	outsb	(%rsi), %dx
     1ed: 74 65                        	je	0x254 <__debug_str+0xbe>
     1ef: 6e                           	outsb	(%rsi), %dx
     1f0: 74 73                        	je	0x265 <__debug_str+0xcf>
     1f2: 2f                           	<unknown>
     1f3: 44 65                        	gs
     1f5: 76 65                        	jbe	0x25c <__debug_str+0xc6>
     1f7: 6c                           	insb	%dx, %es:(%rdi)
     1f8: 6f                           	outsl	(%rsi), %dx
     1f9: 70 65                        	jo	0x260 <__debug_str+0xca>
     1fb: 72 2f                        	jb	0x22c <__debug_str+0x96>
     1fd: 50                           	pushq	%rax
     1fe: 6c                           	insb	%dx, %es:(%rdi)
     1ff: 61                           	<unknown>
     200: 74 66                        	je	0x268 <__debug_str+0xd2>
     202: 6f                           	outsl	(%rsi), %dx
     203: 72 6d                        	jb	0x272 <__debug_str+0xdc>
     205: 73 2f                        	jae	0x236 <__debug_str+0xa0>
     207: 4d 61                        	<unknown>
     209: 63 4f 53                     	movslq	83(%rdi), %ecx
     20c: 58                           	popq	%rax
     20d: 2e 70 6c                     	jo	0x27c <__debug_str+0xe6>
     210: 61                           	<unknown>
     211: 74 66                        	je	0x279 <__debug_str+0xe3>
     213: 6f                           	outsl	(%rsi), %dx
     214: 72 6d                        	jb	0x283 <__debug_str+0xed>
     216: 2f                           	<unknown>
     217: 44 65                        	gs
     219: 76 65                        	jbe	0x280 <__debug_str+0xea>
     21b: 6c                           	insb	%dx, %es:(%rdi)
     21c: 6f                           	outsl	(%rsi), %dx
     21d: 70 65                        	jo	0x284 <__debug_str+0xee>
     21f: 72 2f                        	jb	0x250 <__debug_str+0xba>
     221: 53                           	pushq	%rbx
     222: 44 4b                        	<unknown>
     224: 73 2f                        	jae	0x255 <__debug_str+0xbf>
     226: 4d 61                        	<unknown>
     228: 63 4f 53                     	movslq	83(%rdi), %ecx
     22b: 58                           	popq	%rax
     22c: 2e 73 64                     	jae	0x293 <__debug_str+0xfd>
     22f: 6b 00 4d                     	imull	$77, (%rax), %eax
     232: 61                           	<unknown>
     233: 63 4f 53                     	movslq	83(%rdi), %ecx
     236: 58                           	popq	%rax
     237: 2e 73 64                     	jae	0x29e <__debug_str+0x108>
     23a: 6b 00 2f                     	imull	$47, (%rax), %eax
     23d: 55                           	pushq	%rbp
     23e: 73 65                        	jae	0x2a5 <__debug_str+0x10f>
     240: 72 73                        	jb	0x2b5 <__debug_str+0x11f>
     242: 2f                           	<unknown>
     243: 67 5f                        	popq	%rdi
     245: 6a 6f                        	pushq	$111
     247: 73 73                        	jae	0x2bc <__debug_str+0x126>
     249: 2f                           	<unknown>
     24a: 44 65                        	gs
     24c: 73 6b                        	jae	0x2b9 <__debug_str+0x123>
     24e: 74 6f                        	je	0x2bf <__debug_str+0x129>
     250: 70 2f                        	jo	0x281 <__debug_str+0xeb>
     252: 76 69                        	jbe	0x2bd <__debug_str+0x127>
     254: 6d                           	insl	%dx, %es:(%rdi)
     255: 5f                           	popq	%rdi
     256: 54                           	pushq	%rsp
     257: 65 72 44                     	jb	0x29e <__debug_str+0x108>
     25a: 65 62                        	<unknown>
     25c: 75 67                        	jne	0x2c5 <__debug_str+0x12f>
     25e: 00 6d 61                     	addb	%ch, 97(%rbp)
     261: 69 6e 00 69 6e 74 00         	imull	$7630441, (%rsi), %ebp
     268: 61                           	<unknown>
     269: 72 67                        	jb	0x2d2 <__debug_str+0x13c>
     26b: 63 00                        	movslq	(%rax), %eax
     26d: 61                           	<unknown>
     26e: 72 67                        	jb	0x2d7 <__debug_str+0x141>
     270: 76 00                        	jbe	0x272 <__debug_str+0xdc>
     272: 63 68 61                     	movslq	97(%rax), %ebp
     275: 72 00                        	jb	0x277 <__debug_str+0xe1>
     277: 78 00                        	js	0x279 <__debug_str+0xe3>

Disassembly of section __DWARF,__apple_names:

0000000000000279 <__apple_names>:
     279: 48 53                        	pushq	%rbx
     27b: 41 48                        	rex64
     27d: 01 00                        	addl	%eax, (%rax)
     27f: 00 00                        	addb	%al, (%rax)
     281: 01 00                        	addl	%eax, (%rax)
     283: 00 00                        	addb	%al, (%rax)
     285: 01 00                        	addl	%eax, (%rax)
     287: 00 00                        	addb	%al, (%rax)
     289: 0c 00                        	orb	$0, %al
     28b: 00 00                        	addb	%al, (%rax)
     28d: 00 00                        	addb	%al, (%rax)
     28f: 00 00                        	addb	%al, (%rax)
     291: 01 00                        	addl	%eax, (%rax)
     293: 00 00                        	addb	%al, (%rax)
     295: 01 00                        	addl	%eax, (%rax)
     297: 06                           	<unknown>
     298: 00 00                        	addb	%al, (%rax)
     29a: 00 00                        	addb	%al, (%rax)
     29c: 00 6a 7f                     	addb	%ch, 127(%rdx)
     29f: 9a                           	<unknown>
     2a0: 7c 2c                        	jl	0x2ce <__apple_names+0x55>
     2a2: 00 00                        	addb	%al, (%rax)
     2a4: 00 c9                        	addb	%cl, %cl
     2a6: 00 00                        	addb	%al, (%rax)
     2a8: 00 01                        	addb	%al, (%rcx)
     2aa: 00 00                        	addb	%al, (%rax)
     2ac: 00 32                        	addb	%dh, (%rdx)
     2ae: 00 00                        	addb	%al, (%rax)
     2b0: 00 00                        	addb	%al, (%rax)
     2b2: 00 00                        	addb	%al, (%rax)
     2b4: 00                           	<unknown>

Disassembly of section __DWARF,__apple_objc:

00000000000002b5 <__apple_objc>:
     2b5: 48 53                        	pushq	%rbx
     2b7: 41 48                        	rex64
     2b9: 01 00                        	addl	%eax, (%rax)
     2bb: 00 00                        	addb	%al, (%rax)
     2bd: 01 00                        	addl	%eax, (%rax)
     2bf: 00 00                        	addb	%al, (%rax)
     2c1: 00 00                        	addb	%al, (%rax)
     2c3: 00 00                        	addb	%al, (%rax)
     2c5: 0c 00                        	orb	$0, %al
     2c7: 00 00                        	addb	%al, (%rax)
     2c9: 00 00                        	addb	%al, (%rax)
     2cb: 00 00                        	addb	%al, (%rax)
     2cd: 01 00                        	addl	%eax, (%rax)
     2cf: 00 00                        	addb	%al, (%rax)
     2d1: 01 00                        	addl	%eax, (%rax)
     2d3: 06                           	<unknown>
     2d4: 00 ff                        	addb	%bh, %bh
     2d6: ff ff                        	<unknown>
     2d8: ff                           	<unknown>

Disassembly of section __DWARF,__apple_namespac:

00000000000002d9 <__apple_namespac>:
     2d9: 48 53                        	pushq	%rbx
     2db: 41 48                        	rex64
     2dd: 01 00                        	addl	%eax, (%rax)
     2df: 00 00                        	addb	%al, (%rax)
     2e1: 01 00                        	addl	%eax, (%rax)
     2e3: 00 00                        	addb	%al, (%rax)
     2e5: 00 00                        	addb	%al, (%rax)
     2e7: 00 00                        	addb	%al, (%rax)
     2e9: 0c 00                        	orb	$0, %al
     2eb: 00 00                        	addb	%al, (%rax)
     2ed: 00 00                        	addb	%al, (%rax)
     2ef: 00 00                        	addb	%al, (%rax)
     2f1: 01 00                        	addl	%eax, (%rax)
     2f3: 00 00                        	addb	%al, (%rax)
     2f5: 01 00                        	addl	%eax, (%rax)
     2f7: 06                           	<unknown>
     2f8: 00 ff                        	addb	%bh, %bh
     2fa: ff ff                        	<unknown>
     2fc: ff                           	<unknown>

Disassembly of section __DWARF,__apple_types:

00000000000002fd <__apple_types>:
     2fd: 48 53                        	pushq	%rbx
     2ff: 41 48                        	rex64
     301: 01 00                        	addl	%eax, (%rax)
     303: 00 00                        	addb	%al, (%rax)
     305: 02 00                        	addb	(%rax), %al
     307: 00 00                        	addb	%al, (%rax)
     309: 02 00                        	addb	(%rax), %al
     30b: 00 00                        	addb	%al, (%rax)
     30d: 14 00                        	adcb	$0, %al
     30f: 00 00                        	addb	%al, (%rax)
     311: 00 00                        	addb	%al, (%rax)
     313: 00 00                        	addb	%al, (%rax)
     315: 03 00                        	addl	(%rax), %eax
     317: 00 00                        	addb	%al, (%rax)
     319: 01 00                        	addl	%eax, (%rax)
     31b: 06                           	<unknown>
     31c: 00 03                        	addb	%al, (%rbx)
     31e: 00 05 00 04 00 0b            	addb	%al, 184550400(%rip)  # b000724 <__apple_types+0xb000427>
     324: 00 00                        	addb	%al, (%rax)
     326: 00 00                        	addb	%al, (%rax)
     328: 00 01                        	addb	%al, (%rcx)
     32a: 00 00                        	addb	%al, (%rax)
     32c: 00 30                        	addb	%dh, (%rax)
     32e: 80 88 0b 63 20 95 7c         	orb	$124, -1793039605(%rax)
     335: 40 00 00                     	addb	%al, (%rax)
     338: 00 53 00                     	addb	%dl, (%rbx)
     33b: 00 00                        	addb	%al, (%rax)
     33d: ce                           	<unknown>
     33e: 00 00                        	addb	%al, (%rax)
     340: 00 01                        	addb	%al, (%rcx)
     342: 00 00                        	addb	%al, (%rax)
     344: 00 79 00                     	addb	%bh, (%rcx)
     347: 00 00                        	addb	%al, (%rax)
     349: 24 00                        	andb	$0, %al
     34b: 00 00                        	addb	%al, (%rax)
     34d: 00 00                        	addb	%al, (%rax)
     34f: 00 dc                        	addb	%bl, %ah
     351: 00 00                        	addb	%al, (%rax)
     353: 00 01                        	addb	%al, (%rcx)
     355: 00 00                        	addb	%al, (%rax)
     357: 00 8a 00 00 00 24            	addb	%cl, 603979776(%rdx)
     35d: 00 00                        	addb	%al, (%rax)
     35f: 00 00                        	addb	%al, (%rax)
     361: 00 00                        	addb	%al, (%rax)

Disassembly of section __LD,__compact_unwind:

0000000000000368 <__compact_unwind>:
		...
     370: 1b 00                        	sbbl	(%rax), %eax
     372: 00 00                        	addb	%al, (%rax)
     374: 00 00                        	addb	%al, (%rax)
     376: 00 01                        	addb	%al, (%rcx)
		...

Disassembly of section __TEXT,__eh_frame:

0000000000000388 <__eh_frame>:
     388: 14 00                        	adcb	$0, %al
     38a: 00 00                        	addb	%al, (%rax)
     38c: 00 00                        	addb	%al, (%rax)
     38e: 00 00                        	addb	%al, (%rax)
     390: 01 7a 52                     	addl	%edi, 82(%rdx)
     393: 00 01                        	addb	%al, (%rcx)
     395: 78 10                        	js	0x3a7 <__eh_frame+0x1f>
     397: 01 10                        	addl	%edx, (%rax)
     399: 0c 07                        	orb	$7, %al
     39b: 08 90 01 00 00 24            	orb	%dl, 603979777(%rax)
     3a1: 00 00                        	addb	%al, (%rax)
     3a3: 00 1c 00                     	addb	%bl, (%rax,%rax)
     3a6: 00 00                        	addb	%al, (%rax)
     3a8: 58                           	popq	%rax
     3a9: fc                           	cld
     3aa: ff ff                        	<unknown>
     3ac: ff ff                        	<unknown>
     3ae: ff ff                        	<unknown>
     3b0: 1b 00                        	sbbl	(%rax), %eax
     3b2: 00 00                        	addb	%al, (%rax)
     3b4: 00 00                        	addb	%al, (%rax)
     3b6: 00 00                        	addb	%al, (%rax)
     3b8: 00 41 0e                     	addb	%al, 14(%rcx)
     3bb: 10 86 02 43 0d 06            	adcb	%al, 101532418(%rsi)
     3c1: 00 00                        	addb	%al, (%rax)
     3c3: 00 00                        	addb	%al, (%rax)
     3c5: 00 00                        	addb	%al, (%rax)
     3c7: 00                           	<unknown>

Disassembly of section __DWARF,__debug_line:

00000000000003c8 <__debug_line>:
     3c8: 41 00 00                     	addb	%al, (%r8)
     3cb: 00 04 00                     	addb	%al, (%rax,%rax)
     3ce: 24 00                        	andb	$0, %al
     3d0: 00 00                        	addb	%al, (%rax)
     3d2: 01 01                        	addl	%eax, (%rcx)
     3d4: 01 fb                        	addl	%edi, %ebx
     3d6: 0e                           	<unknown>
     3d7: 0d 00 01 01 01               	orl	$16843008, %eax
     3dc: 01 00                        	addl	%eax, (%rax)
     3de: 00 00                        	addb	%al, (%rax)
     3e0: 01 00                        	addl	%eax, (%rax)
     3e2: 00 01                        	addb	%al, (%rcx)
     3e4: 00 73 74                     	addb	%dh, 116(%rbx)
     3e7: 61                           	<unknown>
     3e8: 74 65                        	je	0x44f <__debug_line+0x87>
     3ea: 6d                           	insl	%dx, %es:(%rdi)
     3eb: 65 6e                        	outsb	%gs:(%rsi), %dx
     3ed: 74 73                        	je	0x462 <__debug_line+0x9a>
     3ef: 2e 63 00                     	movslq	%cs:(%rax), %eax
     3f2: 00 00                        	addb	%al, (%rax)
     3f4: 00 00                        	addb	%al, (%rax)
     3f6: 00 09                        	addb	%cl, (%rcx)
     3f8: 02 00                        	addb	(%rax), %al
     3fa: 00 00                        	addb	%al, (%rax)
     3fc: 00 00                        	addb	%al, (%rax)
     3fe: 00 00                        	addb	%al, (%rax)
     400: 00 15 05 02 0a 4d            	addb	%dl, 1292501509(%rip)  # 4d0a060b <__debug_line+0x4d0a0243>
     406: 08 2f                        	orb	%ch, (%rdi)
     408: 02 04 00                     	addb	(%rax,%rax), %al
     40b: 01 01                        	addl	%eax, (%rcx)
