	.text
			  # main () (b, i, j)	
	.globl main
main:
	subq $40, %rsp
			  #  b = true
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  i = 2
	movq $2, %r10
	movl %r10d, 8(%rsp)
			  #  j = 6
	movq $6, %r10
	movl %r10d, 12(%rsp)
			  #  call printInt(b)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(i)
	leaq .S0(%rip), %rdi
	movl 8(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(j)
	leaq .S0(%rip), %rdi
	movl 12(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $40, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
