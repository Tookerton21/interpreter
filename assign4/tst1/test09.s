	.text
			  # go () (b, i, a)	
	.globl go
go:
	subq $180, %rsp
			  #  i = 0
	movq $0, %r10
	movl %r10d, 4(%rsp)
			  #  t1 = call malloc(16)
	movq $16, %rdi
	call malloc
	movl %eax, 8(%rsp)
			  #  a = t1
	movl 8(%rsp), %r10d
	movl %r10d, 12(%rsp)
			  #  t2 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 16(%rsp)
			  #  t3 = a + t2
	movl 12(%rsp), %r10d
	movl 16(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 20(%rsp)
			  #  [t3] = 2
	movq $2, %r10
	movl 20(%rsp), %r11d
	movl %r10d, (%r11)
			  #  t4 = true
	movq $1, %r10
	movl %r10d, 24(%rsp)
			  #  t5 = true
	movq $1, %r10
	movl %r10d, 28(%rsp)
			  #  t6 = 1 < 2
	movq $1, %r10
	movq $2, %r11
	cmpq %r11, %r10
	setl %r11b
	movzbq %r11b, %r11
	movl %r11d, 32(%rsp)
			  #  if t6 == true goto L1
	movl 32(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L1
			  #  t7 = false
	movq $0, %r10
	movl %r10d, 36(%rsp)
			  #  t8 = 3 > 4
	movq $3, %r10
	movq $4, %r11
	cmpq %r11, %r10
	setg %r11b
	movzbq %r11b, %r11
	movl %r11d, 40(%rsp)
			  #  if t8 == false goto L2
	movl 40(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L2
			  #  t9 = 7 * 8
	movq $7, %r10
	movq $8, %r11
	imulq %r11, %r10
	movl %r10d, 44(%rsp)
			  #  t10 = 6 + t9
	movq $6, %r10
	movl 44(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 48(%rsp)
			  #  t11 = 5 == t10
	movq $5, %r10
	movl 48(%rsp), %r11d
	cmpq %r11, %r10
	sete %r11b
	movzbq %r11b, %r11
	movl %r11d, 52(%rsp)
			  #  if t11 == false goto L2
	movl 52(%rsp), %r10d
	movq $0, %r11
	cmpq %r11, %r10
	je L2
			  #  t7 = true
	movq $1, %r10
	movl %r10d, 36(%rsp)
			  # L2:
L2:
			  #  if t7 == true goto L1
	movl 36(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L1
			  #  t5 = false
	movq $0, %r10
	movl %r10d, 28(%rsp)
			  # L1:
L1:
			  #  if t5 == true goto L0
	movl 28(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  t12 = !true
	movq $1, %r10
	notq %r10
	movl %r10d, 56(%rsp)
			  #  if t12 == true goto L0
	movl 56(%rsp), %r10d
	movq $1, %r11
	cmpq %r11, %r10
	je L0
			  #  t4 = false
	movq $0, %r10
	movl %r10d, 24(%rsp)
			  # L0:
L0:
			  #  b = t4
	movl 24(%rsp), %r10d
	movl %r10d, 60(%rsp)
			  #  t13 = -3
	movq $3, %r10
	negq %r10
	movl %r10d, 64(%rsp)
			  #  t14 = -t13
	movl 64(%rsp), %r10d
	negq %r10
	movl %r10d, 68(%rsp)
			  #  t15 = 5 * 4
	movq $5, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 72(%rsp)
			  #  t16 = t15 / 2
	movl 72(%rsp), %eax
	movq $2, %r10
	cqto
	idivq %r10
	movl %eax, 76(%rsp)
			  #  t17 = 1 * 4
	movq $1, %r10
	movq $4, %r11
	imulq %r11, %r10
	movl %r10d, 80(%rsp)
			  #  t18 = a + t17
	movl 12(%rsp), %r10d
	movl 80(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 84(%rsp)
			  #  t19 = [t18]
	movl 84(%rsp), %r10d
	movslq (%r10), %r10
	movl %r10d, 88(%rsp)
			  #  t20 = t16 * t19
	movl 76(%rsp), %r10d
	movl 88(%rsp), %r11d
	imulq %r11, %r10
	movl %r10d, 92(%rsp)
			  #  t21 = t14 + t20
	movl 68(%rsp), %r10d
	movl 92(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 96(%rsp)
			  #  t22 = i * 2
	movl 4(%rsp), %r10d
	movq $2, %r11
	imulq %r11, %r10
	movl %r10d, 100(%rsp)
			  #  t23 = t21 + t22
	movl 96(%rsp), %r10d
	movl 100(%rsp), %r11d
	addq %r11, %r10
	movl %r10d, 104(%rsp)
			  #  i = t23
	movl 104(%rsp), %r10d
	movl %r10d, 4(%rsp)
			  #  call printInt(b)
	leaq .S0(%rip), %rdi
	movl 60(%rsp), %esi
	xorl %eax, %eax
	call printf
			  #  return i
	movl 4(%rsp), %eax
	addq $180, %rsp
	ret
			  # main ()	
	.globl main
main:
	subq $12, %rsp
			  #  t24 = call go()
	call go
	movl %eax, 4(%rsp)
			  #  call printInt(t24)
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
