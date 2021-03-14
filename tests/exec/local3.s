	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $65, %rbx
	movq %rbx, %rdi
	call putchar
	movq $1, %rdi
	addq %rdi, %rbx
	movq %rbx, %rdi
	call putchar
	movq %rbx, %rdi
	movq $1, %r8
	addq %r8, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
