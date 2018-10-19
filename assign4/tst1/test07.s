	.text
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t1 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t1)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $12, %rsp
	ret
			  # go () (a, b)	
	.globl go
go:
	subq $120, %rsp
			  #  t2 = call malloc(8)
	movq $8, %rdi
	call malloc
	movl %eax, 4(%rsp)
			  #  a = t2
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  t3 = call malloc(8)
	movq $8, %rdi
	call malloc
	movl %eax, 12(%rsp)
			  #  b = t3
	movl 12(%rsp), %r10d
	movl %r10d, 16(%rsp)
			  #  t4 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  t5 = a + t4
	movl 8(%rsp), %r10d
	movl 20(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  [t5] = 1
	movq $1, %r10
	movl 24(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t6 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 28(%rsp)
			  #  t7 = a + t6
	movl 8(%rsp), %r10d
	movl 28(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 32(%rsp)
			  #  [t7] = 2
	movq $2, %r10
	movl 32(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t8 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 36(%rsp)
			  #  t9 = b + t8
	movl 16(%rsp), %r10d
	movl 36(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 40(%rsp)
			  #  [t9] = 3
	movq $3, %r10
	movl 40(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t10 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 44(%rsp)
			  #  t11 = b + t10
	movl 16(%rsp), %r10d
	movl 44(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 48(%rsp)
			  #  [t11] = 4
	movq $4, %r10
	movl 48(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t12 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  t13 = a + t12
	movl 8(%rsp), %r10d
	movl 52(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 56(%rsp)
			  #  t14 = [t13]
	movl 56(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 60(%rsp)
			  #  call printInt(t14)
	leaq .S0(%rip), %rdi
	movl 60(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  t15 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 64(%rsp)
			  #  t16 = b + t15
	movl 16(%rsp), %r10d
	movl 64(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 68(%rsp)
			  #  t17 = [t16]
	movl 68(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 72(%rsp)
			  #  call printInt(t17)
	leaq .S0(%rip), %rdi
	movl 72(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  t18 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 76(%rsp)
			  #  t19 = a + t18
	movl 8(%rsp), %r10d
	movl 76(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 80(%rsp)
			  #  t20 = [t19]
	movl 80(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 84(%rsp)
			  #  return t20
	movl 84(%rsp), %eax
	addq $120, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
