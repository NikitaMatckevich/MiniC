	.text
	.globl main
main:
	movq $0, %r8
	movq $0, %r9
L29:
	movq %r9, %rcx
	movq $10, %rdi
	cmpq %rdi, %rcx
	setl %r11b
	movzbq %r11b, %rcx
	testq %rcx, %rcx
	jz L12
	movq $10, %rdi
L24:
	movq %rdi, %rcx
	movq $0, %rax
	cmpq %rax, %rcx
	setg %r11b
	movzbq %r11b, %rcx
	testq %rcx, %rcx
	jz L15
	movq $1, %rcx
	addq %rcx, %r8
	movq $1, %rcx
	subq %rcx, %rdi
	jmp L24
L15:
	movq $1, %rdi
	addq %rdi, %r9
	jmp L29
L12:
	movq %r8, %rax
	movq $100, %rcx
	cmpq %rcx, %rax
	sete %r11b
	movzbq %r11b, %rax
	movq %r8, %rax
	cmpq $100, %rax
	sete %r11b
	movzbq %r11b, %rax
	testq %rax, %rax
	jz L4
	movq $33, %rdi
	call putchar
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
	jmp L4
	.data
