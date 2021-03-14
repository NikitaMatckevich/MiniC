	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %r12, -8(%rbp)
	movq $10, %r12
L15:
	movq $1, %rdi
	subq %rdi, %r12
	movq %r12, %r8
	movq $1, %rdi
	addq %rdi, %r8
	testq %r8, %r8
	jz L4
	movq $65, %rdi
	movq %r12, %r8
	addq %r8, %rdi
	call putchar
	jmp L15
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %r12
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
