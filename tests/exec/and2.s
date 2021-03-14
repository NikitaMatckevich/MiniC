	.text
	.globl main
main:
	movq $65, %rdi
	movq $0, %r8
	testq %r8, %r8
	jnz L26
L25:
	addq %r8, %rdi
	call putchar
	movq $65, %rdi
	movq $0, %r8
	testq %r8, %r8
	jnz L20
L18:
	addq %r8, %rdi
	call putchar
	movq $65, %rdi
	movq $1, %r8
	testq %r8, %r8
	jnz L13
L12:
	addq %r8, %rdi
	call putchar
	movq $65, %rdi
	movq $0, %r8
	testq %r8, %r8
	jnz L7
L6:
	addq %r8, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
L7:
	movq $0, %r8
	jmp L6
L13:
	movq $0, %r8
	jmp L12
L20:
	movq $2, %r8
	cmpq $0, %r8
	setne %r11b
	movzbq %r11b, %r8
	jmp L18
L26:
	movq $1, %r8
	jmp L25
	.data
