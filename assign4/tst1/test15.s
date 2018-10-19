	.text
			  # foo (i) (x)	
	.globl foo
foo:
	subq $12, %rsp
	movq %rdi, 4(%rsp)
			  #  return i
	movl 4(%rsp), %eax
	addq $12, %rsp
	ret
			  # bar (i) (x)	
	.globl bar
bar:
	subq $24, %rsp
	movq %rdi, 4(%rsp)
			  #  x = 2
	movq $2, %r10
	movl %r10d, 8(%rsp)
			  #  return x
	movl 8(%rsp), %eax
	addq $24, %rsp
	ret
			  # main () (i, j)	
	.globl main
main:
	subq $36, %rsp
			  #  t1 = call foo(1)
	movq $1, %rdi
	call foo
	movl %eax, 4(%rsp)
			  #  i = t1
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  t2 = call bar(1)
	movq $1, %rdi
	call bar
	movl %eax, 12(%rsp)
			  #  j = t2
	movl 12(%rsp), %r10d
	movl %r10d, 16(%rsp)
			  #  call printInt(i)
	leaq .S0(%rip), %rdi
	movl 8(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  call printInt(j)
	leaq .S0(%rip), %rdi
	movl 16(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $36, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
