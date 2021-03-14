	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq $10, -8(%rbp)
L13:
	movq -8(%rbp), %rdi
	testq %rdi, %rdi
	jz L4
	movq $1, %rdi
	subq %rdi, -8(%rbp)
	movq $65, %rdi
	movq -8(%rbp), %r8
	addq %r8, %rdi
	call putchar
	jmp L13
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
