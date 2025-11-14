
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
