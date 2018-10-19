	.text
			  # go () (a, b, c, x)	
	.globl go
go:
	subq $100, %rsp
			  #  a = true
	movq $1, %r10
	movl %r10d, 4(%rsp)
			  #  t1 = !a
	movl 4(%rsp), %r10d
	notq %r10
	movl %r10d, 8(%rsp)
			  #  b = t1
	movl 8(%rsp), %r10d
	movl %r10d, 12(%rsp)
			  #  t2 = true
	movq $1, %r10
	movl %r10d, 16(%rsp)
			  #  t3 = false
	movq $0, %r10
	movl %r10d, 20(%rsp)
			  #  if a == false goto L1
	movl 4(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L1
			  #  if b == false goto L1
	movl 12(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L1
			  #  t3 = true
	movq $1, %r10
	movl %r10d, 20(%rsp)
			  # L1:
L1:
			  #  if t3 == true goto L0
	movl 20(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  if a == true goto L0
	movl 4(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  t2 = false
	movq $0, %r10
	movl %r10d, 16(%rsp)
			  # L0:
L0:
			  #  c = t2
	movl 16(%rsp), %r10d
	movl %r10d, 24(%rsp)
			  #  if c == false goto L2
	movl 24(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L2
			  #  x = 1
	movq $1, %r10
	movl %r10d, 28(%rsp)
			  #  goto L3
	jmp L3
			  # L2:
L2:
			  #  x = 0
	movq $0, %r10
	movl %r10d, 28(%rsp)
			  # L3:
L3:
			  #  return x
	movl 28(%rsp), %eax
	addq $100, %rsp
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
