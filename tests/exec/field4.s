	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $16, %rdi
	call sbrk
	movq %rax, %rbx
	movq %rbx, %rdi
	movq $65, %r8
	movq %r8, 0(%rdi)
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq $66, %r8
	movq %r8, 8(%rdi)
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
