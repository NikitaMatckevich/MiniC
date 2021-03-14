	.text
	.globl main
f:
	pushq %rbp
	movq %rsp, %rbp
	addq $-32, %rsp
	movq %r12, -24(%rbp)
	movq %rbx, -32(%rbp)
	movq %rcx, %rbx
	movq %rdx, %r12
	movq %rsi, -8(%rbp)
	movq %rdi, -16(%rbp)
	movq -16(%rbp), %rdi
	cmpq $0, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L8
	movq $10, %rdi
L1:
	movq %rdi, %rax
	movq -24(%rbp), %r12
	movq -32(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L8:
	movq -16(%rbp), %rdi
	call putchar
	movq -8(%rbp), %rdi
	movq %r12, %r8
	movq %rbx, %r9
	movq -16(%rbp), %rcx
	movq %r9, %rdx
	movq %r8, %rsi
	call f
	movq %rax, %rdi
	jmp L1
main:
	movq $65, %rdi
	movq $66, %rsi
	movq $67, %rdx
	movq $0, %r8
	movq %r8, %rcx
	call f
	movq %rax, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	ret
	.data
