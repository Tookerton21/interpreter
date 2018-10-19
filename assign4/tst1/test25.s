	.text
			  # go ()	
	.globl go
go:
	subq $8, %rsp
			  #  t1 = call value(1, 2, 3)
	movq $1, %rdi
	movq $2, %rsi
	movq $3, %rdx
	call value
	movl %eax, 4(%rsp)
			  #  return t1
	movl 4(%rsp), %eax
	addq $8, %rsp
	ret
			  # value (i, j, k)	
	.globl value
value:
	subq $24, %rsp
	movq %rdi, 4(%rsp)
	movq %rsi, 8(%rsp)
	movq %rdx, 12(%rsp)
			  #  t2 = i + j
	movl 4(%rsp), %r10d
	movl 8(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  t3 = t2 + k
	movl 16(%rsp), %r10d
	movl 12(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  return t3
	movl 20(%rsp), %eax
	addq $24, %rsp
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
