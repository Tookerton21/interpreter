	.text
			  # go (n) (i)	
	.globl go
go:
	subq $44, %rsp
	movq %rdi, 4(%rsp)
			  #  i = 0
	movq $0, %r10
	movl %r10d, 8(%rsp)
			  #  t1 = n > 0
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
			  #  call printInt(n)
	leaq .S0(%rip), %rdi
	movl 4(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  t2 = n - 1
	movl 4(%rsp), %r10d
	movq $1, %r11
	subq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  t3 = call back(t2)
	movl 16(%rsp), %edi
	call back
	movl %eax, 20(%rsp)
			  #  i = t3
	movl 20(%rsp), %r10d
	movl %r10d, 8(%rsp)
			  # L0:
L0:
			  #  return i
	movl 8(%rsp), %eax
	addq $44, %rsp
	ret
			  # back (n) (i)	
	.globl back
back:
	subq $20, %rsp
	movq %rdi, 4(%rsp)
			  #  t4 = call go(n)
	movl 4(%rsp), %edi
	call go
	movl %eax, 8(%rsp)
			  #  i = t4
	movl 8(%rsp), %r10d
	movl %r10d, 12(%rsp)
			  #  return 0
	movq $0, %rax
	addq $20, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t5 = call go(5)
	movq $5, %rdi
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t5)
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
