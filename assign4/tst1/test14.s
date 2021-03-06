	.text
			  # foo (i, j)	
	.globl foo
foo:
	subq $24, %rsp
	movq %rdi, 4(%rsp)
	movq %rsi, 8(%rsp)
			  #  t1 = i + j
	movl 4(%rsp), %r10d
	movl 8(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 12(%rsp)
			  #  return t1
	movl 12(%rsp), %eax
	addq $24, %rsp
	ret
			  # main () (b, i, j)	
	.globl main
main:
	subq $56, %rsp
			  #  b = true
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  t2 = call foo(1, 2)
	movq $1, %rdi
	movq $2, %rsi
	call foo
	movl %eax, 8(%rsp)
			  #  i = t2
	movl 8(%rsp), %r10d
	movl %r10d, 12(%rsp)
			  #  t3 = 2 * 3
	movq $2, %r10
	movq $3, %r11
	imulq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  j = t3
	movl 16(%rsp), %r10d
	movl %r10d, 20(%rsp)
			  #  call printInt(b)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(i)
	leaq .S0(%rip), %rdi
	movl 12(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(j)
	leaq .S0(%rip), %rdi
	movl 20(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $56, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
