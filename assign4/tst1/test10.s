	.text
			  # go ()	
	.globl go
go:
	subq $60, %rsp
			  #  t1 = 1 < 2
	movq $1, %r10
	movq $2, %r11
	cmpq %r11, %r10
	setl %r11b
	movzbq %r11b, %r11
	movl %r11d, 4(%rsp)
			  #  if t1 == false goto L0
	movl 4(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L0
			  #  call printInt(1)
	leaq .S0(%rip), %rdi
	movq $1, %rsi
	xorl %eax, %eax
	call printf
			  #  goto L1
	jmp L1
			  # L0:
L0:
			  #  t2 = 3 * 4
	movq $3, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 8(%rsp)
			  #  t3 = t2 == 10
	movl 8(%rsp), %r10d
	movq $10, %r11
	cmpq %r11, %r10
	sete %r11b
	movzbq %r11b, %r11
	movl %r11d, 12(%rsp)
			  #  if t3 == false goto L2
	movl 12(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L2
			  #  call printInt(4)
	leaq .S0(%rip), %rdi
	movq $4, %rsi
	xorl %eax, %eax
	call printf
			  #  goto L3
	jmp L3
			  # L2:
L2:
			  #  call printInt(5)
	leaq .S0(%rip), %rdi
	movq $5, %rsi
	xorl %eax, %eax
	call printf
			  # L3:
L3:
			  # L1:
L1:
			  #  return 6
	movq $6, %rax
	addq $60, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t4 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t4)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $12, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
