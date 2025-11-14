
statements:	file format mach-o 64-bit x86-64


Disassembly of section __TEXT,__text:

0000000000000000 <_FuncTown>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 53                           	pushq	%rbx
       5: 50                           	pushq	%rax
       6: 89 fb                        	movl	%edi, %ebx
       8: 48 8d 3d a4 00 00 00         	leaq	164(%rip), %rdi  # b3 <_main+0x83>
       f: 89 de                        	movl	%ebx, %esi
      11: 31 c0                        	xorl	%eax, %eax
      13: e8 00 00 00 00               	callq	0x18 <_FuncTown+0x18>
      18: 8d 43 01                     	leal	1(%rbx), %eax
      1b: 48 83 c4 08                  	addq	$8, %rsp
      1f: 5b                           	popq	%rbx
      20: 5d                           	popq	%rbp
      21: c3                           	retq
      22: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
      2c: 0f 1f 40 00                  	nopl	(%rax)

0000000000000030 <_main>:
      30: 55                           	pushq	%rbp
      31: 48 89 e5                     	movq	%rsp, %rbp
      34: 53                           	pushq	%rbx
      35: 48 81 ec 08 01 00 00         	subq	$264, %rsp
      3c: 48 8b 05 00 00 00 00         	movq	(%rip), %rax  # 43 <_main+0x13>
      43: 48 8b 00                     	movq	(%rax), %rax
      46: 48 89 45 f0                  	movq	%rax, -16(%rbp)
      4a: 48 8d 3d 7a 00 00 00         	leaq	122(%rip), %rdi  # cb <_main+0x9b>
      51: 48 8d 9d f0 fe ff ff         	leaq	-272(%rbp), %rbx
      58: 48 89 de                     	movq	%rbx, %rsi
      5b: 31 c0                        	xorl	%eax, %eax
      5d: e8 00 00 00 00               	callq	0x62 <_main+0x32>
      62: 48 89 df                     	movq	%rbx, %rdi
      65: e8 00 00 00 00               	callq	0x6a <_main+0x3a>
      6a: 89 c3                        	movl	%eax, %ebx
      6c: 48 8d 3d 40 00 00 00         	leaq	64(%rip), %rdi  # b3 <_main+0x83>
      73: 89 c6                        	movl	%eax, %esi
      75: 31 c0                        	xorl	%eax, %eax
      77: e8 00 00 00 00               	callq	0x7c <_main+0x4c>
      7c: 8d 53 01                     	leal	1(%rbx), %edx
      7f: 48 8d 3d 48 00 00 00         	leaq	72(%rip), %rdi  # ce <_main+0x9e>
      86: be 38 a2 87 00               	movl	$8888888, %esi
      8b: 31 c0                        	xorl	%eax, %eax
      8d: e8 00 00 00 00               	callq	0x92 <_main+0x62>
      92: 48 8b 05 00 00 00 00         	movq	(%rip), %rax  # 99 <_main+0x69>
      99: 48 8b 00                     	movq	(%rax), %rax
      9c: 48 3b 45 f0                  	cmpq	-16(%rbp), %rax
      a0: 75 0c                        	jne	0xae <_main+0x7e>
      a2: 31 c0                        	xorl	%eax, %eax
      a4: 48 81 c4 08 01 00 00         	addq	$264, %rsp
      ab: 5b                           	popq	%rbx
      ac: 5d                           	popq	%rbp
      ad: c3                           	retq
      ae: e8 00 00 00 00               	callq	0xb3 <_main+0x83>
