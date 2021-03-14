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
	testq %rdi, %rdi
	jz L9
	movq $66, %rdi
	call putchar
L6:
	movq %rbx, %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L9:
	movq $67, %rdi
	call putchar
	jmp L6
	.data
