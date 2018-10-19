	.text
			  # main () (r)	
	.globl main
main:
	subq $28, %rsp
			  #  t1 = 1
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  t2 = 2
	movq $2, %r10
	movl %r10d, 8(%rsp)
			  #  t3 = 3
	movq $3, %r10
	movl %r10d, 12(%rsp)
			  #  t4 = call f(t1, t2, t3)
	movl 4(%rsp), %edi
	movl 8(%rsp), %esi
	movl 12(%rsp), %edx
	call f
	movl %eax, 16(%rsp)
			  #  call printInt(t4)
	leaq .S0(%rip), %rdi
	movl 16(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $28, %rsp
	ret
			  # f (a, b, c)	
	.globl f
f:
	subq $28, %rsp
	movq %rdi, 4(%rsp)
	movq %rsi, 8(%rsp)
	movq %rdx, 12(%rsp)
			  #  t1 = call g(a, b, c)
	movl 4(%rsp), %edi
	movl 8(%rsp), %esi
	movl 12(%rsp), %edx
	call g
	movl %eax, 16(%rsp)
			  #  t2 = call g(b, c, a)
	movl 8(%rsp), %edi
	movl 12(%rsp), %esi
	movl 4(%rsp), %edx
	call g
	movl %eax, 20(%rsp)
			  #  t3 = t2 - t1
	movl 20(%rsp), %r10d
	movl 16(%rsp), %r11d
	subq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  return t3
	movl 24(%rsp), %eax
	addq $28, %rsp
	ret
			  # g (x, y, z)	
	.globl g
g:
	subq $24, %rsp
	movq %rdi, 4(%rsp)
	movq %rsi, 8(%rsp)
	movq %rdx, 12(%rsp)
			  #  t1 = z + y
	movl 12(%rsp), %r10d
	movl 8(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  t2 = t1 - x
	movl 16(%rsp), %r10d
	movl 4(%rsp), %r11d
	subq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  return t2
	movl 20(%rsp), %eax
	addq $24, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
