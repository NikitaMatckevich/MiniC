	.text
	.globl main
main:
	movq %rdi, %r8
	cmpq %rdi, %r8
	sete %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L4
	movq $97, %rdi
	call putchar
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
	jmp L4
	.data
