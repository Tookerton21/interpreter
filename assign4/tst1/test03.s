	.text
			  # main () (i, b)	
	.globl main
main:
	subq $104, %rsp
			  #  t1 = 2 * 4
	movq $2, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 4(%rsp)
			  #  t2 = 2 + t1
	movq $2, %r10
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 8(%rsp)
			  #  t3 = 9 / 3
	movq $9, %rax
	movq $3, %r10
	cqto
	idivq %r10
	movl %eax, 12(%rsp)
			  #  t4 = t2 - t3
	movl 8(%rsp), %r10d
	movl 12(%rsp), %r11d
	subq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  i = t4
	movl 16(%rsp), %r10d
	movl %r10d, 20(%rsp)
			  #  t5 = true
	movq $1, %r10
	movl %r10d, 24(%rsp)
			  #  t6 = 1 > 2
	movq $1, %r10
	movq $2, %r11
	cmpq %r11, %r10
	setg %r11b
	movzbq %r11b, %r11
	movl %r11d, 28(%rsp)
			  #  if t6 == true goto L0
	movl 28(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  t7 = false
	movq $0, %r10
	movl %r10d, 32(%rsp)
			  #  t8 = 3 < 4
	movq $3, %r10
	movq $4, %r11
	cmpq %r11, %r10
	setl %r11b
	movzbq %r11b, %r11
	movl %r11d, 36(%rsp)
			  #  if t8 == false goto L1
	movl 36(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L1
			  #  t9 = !false
	movq $0, %r10
	notq %r10
	movl %r10d, 40(%rsp)
			  #  if t9 == false goto L1
	movl 40(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L1
			  #  t7 = true
	movq $1, %r10
	movl %r10d, 32(%rsp)
			  # L1:
L1:
			  #  if t7 == true goto L0
	movl 32(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  t5 = false
	movq $0, %r10
	movl %r10d, 24(%rsp)
			  # L0:
L0:
			  #  b = t5
	movl 24(%rsp), %r10d
	movl %r10d, 44(%rsp)
			  #  call printInt(i)
	leaq .S0(%rip), %rdi
	movl 20(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(b)
	leaq .S0(%rip), %rdi
	movl 44(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $104, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
