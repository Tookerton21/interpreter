	.text
			  # go ()	
	.globl go
go:
	subq $8, %rsp
			  #  t1 = call value(true)
	movq $1, %rdi
	call value
	movl %eax, 4(%rsp)
			  #  return t1
	movl 4(%rsp), %eax
	addq $8, %rsp
	ret
			  # value (cond) (i, j, k)	
	.globl value
value:
	subq $52, %rsp
	movq %rdi, 4(%rsp)
			  #  i = 5
	movq $5, %r10
	movl %r10d, 8(%rsp)
			  #  j = 6
	movq $6, %r10
	movl %r10d, 12(%rsp)
			  #  if cond == false goto L0
	movl 4(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L0
			  #  k = i
	movl 8(%rsp), %r10d
	movl %r10d, 16(%rsp)
			  #  goto L1
	jmp L1
			  # L0:
L0:
			  #  k = j
	movl 12(%rsp), %r10d
	movl %r10d, 16(%rsp)
			  # L1:
L1:
			  #  return k
	movl 16(%rsp), %eax
	addq $52, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t2 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t2)
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
