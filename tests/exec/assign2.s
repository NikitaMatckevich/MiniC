	.text
	.globl main
main:
	movq $1, %r8
	movq $65, %rdi
	addq %r8, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
	.data
