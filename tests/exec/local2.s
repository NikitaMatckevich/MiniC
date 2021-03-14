	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq $65, %rbx
	movq %rbx, %rdi
	call putchar
	movq $1, %rdi
	addq %rdi, %rbx
	movq %rbx, %rdi
	call putchar
	movq %rbx, %r12
	movq $1, %rdi
	addq %rdi, %r12
	movq %rbx, %rdi
	call putchar
	movq %r12, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
