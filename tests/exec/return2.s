	.text
	.globl main
f:
	movq $2, %r8
	imulq %rsi, %r8
	addq %r8, %rdi
	movq %rdi, %rax
	ret
main:
	movq $65, %rdi
	movq $0, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $65, %rdi
	movq $1, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $65, %rdi
	movq $2, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	ret
	.data
