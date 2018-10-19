	.text
			  # go () (i, j)	
	.globl go
go:
	subq $24, %rsp
			  #  i = 4
	movq $4, %r10
	movl %r10d, 4(%rsp)
			  #  t1 = i + 2
	movl 4(%rsp), %r10d
	movq $2, %r11
	addq %r11, %r10
	movl %r10d, 8(%rsp)
			  #  j = t1
	movl 8(%rsp), %r10d
	movl %r10d, 12(%rsp)
			  #  return j
	movl 12(%rsp), %eax
	addq $24, %rsp
	ret
			  # main () (r)	
	.globl main
main:
	subq $20, %rsp
			  #  t2 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  r = t2
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  call printInt(r)
	leaq .S0(%rip), %rdi
	movl 8(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $20, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
