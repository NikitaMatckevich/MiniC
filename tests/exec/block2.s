	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq $65, %r12
	movq %r12, %rdi
	call putchar
	movq $0, %rdi
	testq %rdi, %rdi
	jz L12
	movq $66, %rdi
	call putchar
L6:
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
L12:
	movq $67, %rdi
	movq $68, %rbx
	call putchar
	movq %rbx, %rdi
	call putchar
	jmp L6
	.data
