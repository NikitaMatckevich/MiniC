	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $0, %rbx
	movq $1, %r8
	movq %r8, %rdi
	movq $1, %r9
	cmpq %r9, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq %r8, %rdi
	cmpq $1, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L12
	movq $97, %rdi
	call putchar
L12:
	movq %rbx, %r9
	movq $0, %rdi
	cmpq %rdi, %r9
	sete %r11b
	movzbq %r11b, %r9
	movq %rbx, %r9
	cmpq $0, %r9
	sete %r11b
	movzbq %r11b, %r9
	testq %r9, %r9
	jz L4
	movq $98, %rdi
	call putchar
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L4
	jmp L12
	.data
