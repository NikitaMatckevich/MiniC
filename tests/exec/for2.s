	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $10, %rbx
L17:
	movq %rbx, %r8
	movq $0, %rdi
	cmpq %rdi, %r8
	setg %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L4
	movq $65, %rdi
	movq $1, %r8
	subq %r8, %rbx
	movq %rbx, %r8
	addq %r8, %rdi
	movq $1, %r8
	addq %r8, %rdi
	call putchar
	jmp L17
L4:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
