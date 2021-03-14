	.text
	.globl main
main:
	movq $0, %r8
	movq $65, %rdi
	cmpq $0, %r8
	sete %r11b
	movzbq %r11b, %r8
	addq %r8, %rdi
	call putchar
	movq $1, %r8
	movq $65, %rdi
	cmpq $0, %r8
	sete %r11b
	movzbq %r11b, %r8
	addq %r8, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
	.data
