	.text
			  # main () (r)	
	.globl main
main:
	subq $120, %rsp
			  #  t1 = 1
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  t2 = 2
	movq $2, %r10
	movl %r10d, 8(%rsp)
			  #  t3 = 3
	movq $3, %r10
	movl %r10d, 12(%rsp)
			  #  t4 = 4
	movq $4, %r10
	movl %r10d, 16(%rsp)
			  #  t5 = 5
	movq $5, %r10
	movl %r10d, 20(%rsp)
			  #  t6 = 6
	movq $6, %r10
	movl %r10d, 24(%rsp)
			  #  t7 = 7
	movq $7, %r10
	movl %r10d, 28(%rsp)
			  #  t8 = 8
	movq $8, %r10
	movl %r10d, 32(%rsp)
			  #  t9 = 9
	movq $9, %r10
	movl %r10d, 36(%rsp)
			  #  t10 = 10
	movq $10, %r10
	movl %r10d, 40(%rsp)
			  #  t11 = 11
	movq $11, %r10
	movl %r10d, 44(%rsp)
			  #  t12 = 12
	movq $12, %r10
	movl %r10d, 48(%rsp)
			  #  r = 0
	movq $0, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t12
	movl 52(%rsp), %r10d
	movl 48(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t11
	movl 52(%rsp), %r10d
	movl 44(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t10
	movl 52(%rsp), %r10d
	movl 40(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t9
	movl 52(%rsp), %r10d
	movl 36(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t8
	movl 52(%rsp), %r10d
	movl 32(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t7
	movl 52(%rsp), %r10d
	movl 28(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t6
	movl 52(%rsp), %r10d
	movl 24(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t5
	movl 52(%rsp), %r10d
	movl 20(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t4
	movl 52(%rsp), %r10d
	movl 16(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t3
	movl 52(%rsp), %r10d
	movl 12(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t2
	movl 52(%rsp), %r10d
	movl 8(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  r = r + t1
	movl 52(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 52(%rsp)
			  #  call printInt(r)
	leaq .S0(%rip), %rdi
	movl 52(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $120, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
