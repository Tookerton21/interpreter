	.text
			  # main ()	
	.globl main
main:
	subq $20, %rsp
			  #  call printInt(123)
	leaq .S0(%rip), %rdi
	movq $123, %rsi
	xorl %eax, %eax
	call printf
			  #  call printStr("abc")
	leaq .S1(%rip), %rdi
	xorl %eax, %eax
	call printf
			  #  call printStr("second string")
	leaq .S2(%rip), %rdi
	xorl %eax, %eax
	call printf
			  #  call printInt(true)
	leaq .S0(%rip), %rdi
	movq $1, %rsi
	xorl %eax, %eax
	call printf
			  #  return 
	addq $20, %rsp
	ret
			  # string literals
	.data
.S0:
	.asciz "%d\n"
.S1:
	.asciz "abc\n"
.S2:
	.asciz "second string\n"
