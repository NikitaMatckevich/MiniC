	.text
	.globl main
many:
	pushq %rbp
	movq %rsp, %rbp
	addq $-80, %rsp
	movq %r12, -56(%rbp)
	movq %rbx, -64(%rbp)
	movq 40(%rbp), %r11
	movq %r11, -72(%rbp)
	movq 32(%rbp), %r11
	movq %r11, -80(%rbp)
	movq 24(%rbp), %rbx
	movq 16(%rbp), %r12
	movq %r9, -8(%rbp)
	movq %r8, -16(%rbp)
	movq %rcx, -24(%rbp)
	movq %rdx, -32(%rbp)
	movq %rsi, -40(%rbp)
	movq %rdi, -48(%rbp)
	movq $64, %r8
	movq -48(%rbp), %rdi
	addq %rdi, %r8
	movq %r8, %rdi
	call putchar
	movq $64, %r8
	movq -40(%rbp), %rdi
	addq %rdi, %r8
	movq %r8, %rdi
	call putchar
	movq $64, %r8
	movq -32(%rbp), %rdi
	addq %rdi, %r8
	movq %r8, %rdi
	call putchar
	movq $64, %rsi
	movq -24(%rbp), %rdi
	addq %rdi, %rsi
	movq %rsi, %rdi
	call putchar
	movq $64, %rdi
	movq -16(%rbp), %rsi
	addq %rsi, %rdi
	call putchar
	movq $64, %rsi
	movq -8(%rbp), %rdi
	addq %rdi, %rsi
	movq %rsi, %rdi
	call putchar
	movq $64, %rdi
	movq %r12, %rsi
	addq %rsi, %rdi
	call putchar
	movq $64, %rsi
	movq %rbx, %rdi
	addq %rdi, %rsi
	movq %rsi, %rdi
	call putchar
	movq $64, %rdi
	movq -80(%rbp), %rsi
	addq %rsi, %rdi
	call putchar
	movq $64, %rdi
	movq -72(%rbp), %rsi
	addq %rsi, %rdi
	call putchar
	movq $10, %rsi
	movq %rsi, %rdi
	call putchar
	movq -48(%rbp), %rsi
	movq $10, %rdi
	cmpq %rdi, %rsi
	jge L2
	movq -40(%rbp), %rdi
	movq -32(%rbp), %rsi
	movq -24(%rbp), %rdx
	movq -16(%rbp), %r10
	movq -8(%rbp), %r8
	movq -80(%rbp), %r9
	movq -72(%rbp), %rcx
	movq -48(%rbp), %rax
	pushq %rax
	pushq %rcx
	pushq %r9
	pushq %rbx
	movq %r12, %r9
	movq %r10, %rcx
	call many
	addq $32, %rsp
L2:
	movq $0, %rax
	movq -56(%rbp), %r12
	movq -64(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L2
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq $1, %rdi
	movq $2, %rsi
	movq $3, %r10
	movq $4, -8(%rbp)
	movq $5, -16(%rbp)
	movq $6, %r8
	movq $7, %r9
	movq $8, %rcx
	movq $9, %rdx
	movq $10, %rax
	pushq %rax
	pushq %rdx
	pushq %rcx
	pushq %r9
	movq %r8, %r9
	movq -16(%rbp), %r8
	movq -8(%rbp), %rcx
	movq %r10, %rdx
	call many
	addq $32, %rsp
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
