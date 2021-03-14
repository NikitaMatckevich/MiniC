	.text
	.globl main
fact:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, %r8
	movq $1, %r9
	cmpq %r9, %r8
	jg L7
	movq $1, %rbx
L1:
	movq %rbx, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L7:
	movq %rdi, %rbx
	movq $1, %r8
	subq %r8, %rdi
	call fact
	movq %rax, %rdi
	imulq %rdi, %rbx
	jmp L1
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq $0, %r12
L27:
	movq %r12, %rbx
	movq $4, %rdi
	cmpq %rdi, %rbx
	setle %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jz L15
	movq $65, %rbx
	movq %r12, %rdi
	call fact
	movq %rax, %rdi
	addq %rdi, %rbx
	movq %rbx, %rdi
	call putchar
	movq $1, %rdi
	addq %rdi, %r12
	jmp L27
L15:
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
