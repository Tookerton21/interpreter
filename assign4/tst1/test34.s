	.text
			  # foo (i) (k)	
	.globl foo
foo:
	subq $44, %rsp
	movq %rdi, 4(%rsp)
			  #  k = 10
	movq $10, %r10
	movl %r10d, 8(%rsp)
			  #  t1 = i > 0
	movl 4(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	setg %r11b
	movzbq %r11b, %r11
	movl %r11d, 12(%rsp)
			  #  if t1 == false goto L0
	movl 12(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L0
			  #  t2 = call bar(i)
	movl 4(%rsp), %edi
	call bar
	movl %eax, 16(%rsp)
			  #  t3 = call foo(t2)
	movl 16(%rsp), %edi
	call foo
	movl %eax, 20(%rsp)
			  #  t4 = k + t3
	movl 8(%rsp), %r10d
	movl 20(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 24(%rsp)
			  #  k = t4
	movl 24(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  # L0:
L0:
			  #  return k
	movl 8(%rsp), %eax
	addq $44, %rsp
	ret
			  # bar (i)	
	.globl bar
bar:
	subq $12, %rsp
	movq %rdi, 4(%rsp)
			  #  t5 = i - 1
	movl 4(%rsp), %r10d
	movq $1, %r11
	subq %r11, %r10
	movl %r10d, 8(%rsp)
			  #  return t5
	movl 8(%rsp), %eax
	addq $12, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t6 = call foo(2)
	movq $2, %rdi
	call foo
	movl %eax, 4(%rsp)
			  #  call printInt(t6)
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
