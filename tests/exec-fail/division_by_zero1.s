	.text
	.globl main
main:
	movq $1, %rdi
	movq $0, %r8
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %r8
	movq %r11, %rdx
	movq %rax, %rdi
	call putchar
	movq $0, %rax
	ret
	.data
