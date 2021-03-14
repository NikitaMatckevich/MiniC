	.text
	.globl main
main:
	movq $42, %r8
	movq $0, %rdi
	movq %r8, %r9
	subq %r8, %r9
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %r9
	movq %r11, %rdx
	movq %rax, %rdi
	call putchar
	movq $0, %rax
	ret
	.data
