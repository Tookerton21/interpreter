	.text
			  # foo (i)	
	.globl foo
foo:
	subq $36, %rsp
	movq %rdi, 4(%rsp)
			  #  t1 = i > 1
	movl 4(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	setg %r11b
	movzbq %r11b, %r11
	movl %r11d, 8(%rsp)
			  #  if t1 == false goto L0
	movl 8(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L0
			  #  t2 = call bar()
	call bar
	movl %eax, 12(%rsp)
			  #  return t2
	movl 12(%rsp), %eax
	addq $36, %rsp
	ret
			  #  goto L1
	jmp L1
			  # L0:
L0:
			  #  return 3
	movq $3, %rax
	addq $36, %rsp
	ret
			  # L1:
L1:
			  # bar ()	
	.globl bar
bar:
	subq $8, %rsp
			  #  t3 = call foo(1)
	movq $1, %rdi
	call foo
	movl %eax, 4(%rsp)
			  #  return t3
	movl 4(%rsp), %eax
	addq $8, %rsp
	ret
			  # main () (i)	
	.globl main
main:
	subq $20, %rsp
			  #  t4 = call foo(2)
	movq $2, %rdi
	call foo
	movl %eax, 4(%rsp)
			  #  i = t4
	movl 4(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  #  call printInt(i)
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
