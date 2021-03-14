	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq $16, %rdi
	call sbrk
	movq %rax, %r12
	movq %r12, %rbx
	movq %rbx, %rdi
	movq $65, %r8
	movq %r8, 0(%rdi)
	movq %r12, %r8
	movq 0(%r8), %rdi
	call putchar
	movq %rbx, %r8
	movq 0(%r8), %rdi
	call putchar
	movq %rbx, %r8
	movq $66, %rdi
	movq %rdi, 8(%r8)
	movq %r12, %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
