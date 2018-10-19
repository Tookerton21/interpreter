	.text
			  # main () (a, b, i)	
	.globl main
main:
	subq $92, %rsp
			  #  t1 = call malloc(8)
	movq $8, %rdi
	call malloc
	movl %eax, 4(%rsp)
			  #  a = t1
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  t2 = 0 * 4
	movq $0, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 12(%rsp)
			  #  t3 = a + t2
	movl 8(%rsp), %r10d
	movl 12(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  [t3] = 2
	movq $2, %r10
	movl 16(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t4 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  t5 = a + t4
	movl 8(%rsp), %r10d
	movl 20(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  [t5] = 4
	movq $4, %r10
	movl 24(%rsp), %r11d
	movl %r10d, (%r11)
			  #  i = 0
	movq $0, %r10
	movl %r10d, 28(%rsp)
			  #  t6 = i * 4
	movl 28(%rsp), %r10d
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 32(%rsp)
			  #  t7 = a + t6
	movl 8(%rsp), %r10d
	movl 32(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 36(%rsp)
			  #  t8 = [t7]
	movl 36(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 40(%rsp)
			  #  t9 = i + 1
	movl 28(%rsp), %r10d
	movq $1, %r11
	addq %r11, %r10
	movl %r10d, 44(%rsp)
			  #  t10 = t9 * 4
	movl 44(%rsp), %r10d
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 48(%rsp)
			  #  t11 = a + t10
	movl 8(%rsp), %r10d
	movl 48(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  t12 = [t11]
	movl 52(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 56(%rsp)
			  #  t13 = t8 + t12
	movl 40(%rsp), %r10d
	movl 56(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 60(%rsp)
			  #  b = t13
	movl 60(%rsp), %r10d
	movl %r10d, 64(%rsp)
			  #  call printInt(b)
	leaq .S0(%rip), %rdi
	movl 64(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $92, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
