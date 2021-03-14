	.text
	.globl main
print_int:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq %rdi, %r12
	movq %r12, %rbx
	movq $10, %rdi
	movq %rbx, %rax
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	movq %rax, %rbx
	movq %r12, %rdi
	movq $9, %r8
	cmpq %r8, %rdi
	jg L12
L10:
	movq $48, %rdi
	movq %r12, %r8
	movq $10, %rax
	movq %rbx, %r9
	imulq %r9, %rax
	subq %rax, %r8
	addq %r8, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L12:
	movq %rbx, %rdi
	call print_int
	jmp L10
main:
	movq $42, %rdi
	call print_int
	movq $10, %rdi
	call putchar
	movq $0, %rax
	ret
	.data
