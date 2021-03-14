	.text
	.globl main
f:
	addq %rsi, %rdi
	movq %rdi, %rax
	ret
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $65, %rdi
	movq $0, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $65, %rdi
	movq $1, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $65, %rdi
	movq $2, %rsi
	call f
	movq %rax, %rdi
	call putchar
	movq $65, %rdi
	movq $3, %rsi
	call f
	movq %rax, %rbx
	movq %rbx, %rsi
	movq %rsi, %rdi
	call putchar
	movq $1, %rsi
	addq %rsi, %rbx
	movq %rbx, %rdi
	call putchar
	movq $10, %rsi
	movq %rsi, %rdi
	call putchar
	movq $0, %rsi
	movq %rsi, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
