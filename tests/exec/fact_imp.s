	.text
	.globl main
fact_imp:
	movq $1, %r8
L13:
	movq %rdi, %rcx
	movq $1, %r9
	cmpq %r9, %rcx
	setg %r11b
	movzbq %r11b, %rcx
	testq %rcx, %rcx
	jz L2
	movq $1, %r9
	subq %r9, %rdi
	movq %rdi, %rcx
	movq $1, %r9
	addq %r9, %rcx
	imulq %rcx, %r8
	jmp L13
L2:
	movq %r8, %rax
	ret
main:
	movq $0, %rdi
	call fact_imp
	movq %rax, %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $0, %rdi
	call fact_imp
	movq %rax, %rdi
	cmpq $1, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L38
	movq $49, %rdi
	call putchar
L38:
	movq $1, %rdi
	call fact_imp
	movq %rax, %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $1, %rdi
	call fact_imp
	movq %rax, %rdi
	cmpq $1, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L28
	movq $50, %rdi
	call putchar
L28:
	movq $5, %rdi
	call fact_imp
	movq %rax, %rdi
	movq $120, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $5, %rdi
	call fact_imp
	movq %rax, %rdi
	cmpq $120, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L18
	movq $51, %rdi
	call putchar
L18:
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	ret
	jmp L18
	jmp L28
	jmp L38
	.data
