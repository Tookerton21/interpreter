	.text
			  # go () (b)	
	.globl go
go:
	subq $68, %rsp
			  #  t1 = call malloc(8)
	movq $8, %rdi
	call malloc
	movl %eax, 4(%rsp)
			  #  b = t1
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  t2 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 12(%rsp)
			  #  t3 = b + t2
	movl 8(%rsp), %r10d
	movl 12(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  [t3] = 3
	movq $3, %r10
	movl 16(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t4 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  t5 = b + t4
	movl 8(%rsp), %r10d
	movl 20(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  [t5] = 4
	movq $4, %r10
	movl 24(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t6 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 28(%rsp)
			  #  t7 = b + t6
	movl 8(%rsp), %r10d
	movl 28(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 32(%rsp)
			  #  t8 = [t7]
	movl 32(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 36(%rsp)
			  #  call printInt(t8)
	leaq .S0(%rip), %rdi
	movl 36(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  t9 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 40(%rsp)
			  #  t10 = b + t9
	movl 8(%rsp), %r10d
	movl 40(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 44(%rsp)
			  #  t11 = [t10]
	movl 44(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 48(%rsp)
			  #  return t11
	movl 48(%rsp), %eax
	addq $68, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t12 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t12)
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
