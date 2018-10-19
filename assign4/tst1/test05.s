	.text
			  # main () (r)	
	.globl main
main:
	subq $44, %rsp
			  #  r = 1
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  t1 = r
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  t2 = t1 + r
	movl 8(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 12(%rsp)
			  #  t3 = t2 + r
	movl 12(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  t4 = t3 + r
	movl 16(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  t5 = t4 + r
	movl 20(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  t6 = t5 + r
	movl 24(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 28(%rsp)
			  #  r = t5 + r
	movl 24(%rsp), %r10d
	movl 4(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 4(%rsp)
			  #  call printInt(r)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $44, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
