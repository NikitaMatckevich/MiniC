	.text
	.globl main
f:
	pushq %rbp
	movq %rsp, %rbp
	addq $-120, %rsp
	movq %r12, -56(%rbp)
	movq %rbx, -64(%rbp)
	movq 24(%rbp), %rbx
	movq 16(%rbp), %r12
	movq %r9, -8(%rbp)
	movq %r8, -16(%rbp)
	movq %rcx, -24(%rbp)
	movq %rdx, -32(%rbp)
	movq %rsi, -40(%rbp)
	movq %rdi, -48(%rbp)
	movq $9, -120(%rbp)
	movq $10, -112(%rbp)
	movq $11, -104(%rbp)
	movq $12, -96(%rbp)
	movq $13, -88(%rbp)
	movq $14, -80(%rbp)
	movq $15, -72(%rbp)
	movq $65, %rcx
	movq -48(%rbp), %r10
	movq -40(%rbp), %rdi
	imulq %rdi, %r10
	addq %r10, %rcx
	movq -32(%rbp), %r8
	movq -24(%rbp), %r10
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %r10
	movq %r11, %rdx
	movq %rax, %r8
	movq -16(%rbp), %r10
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %r10
	movq %r11, %rdx
	movq %rax, %r8
	movq -8(%rbp), %r10
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %r10
	movq %r11, %rdx
	movq %rax, %r8
	subq %r8, %rcx
	movq %r12, %r8
	addq %r8, %rcx
	movq %rbx, %r8
	subq %r8, %rcx
	movq -120(%rbp), %r10
	movq -112(%rbp), %r8
	cmpq %r8, %r10
	sete %r11b
	movzbq %r11b, %r10
	addq %r10, %rcx
	movq -104(%rbp), %rsi
	movq -96(%rbp), %r8
	cmpq %r8, %rsi
	setl %r11b
	movzbq %r11b, %rsi
	subq %rsi, %rcx
	movq -88(%rbp), %rdi
	movq -80(%rbp), %rsi
	cmpq %rsi, %rdi
	setle %r11b
	movzbq %r11b, %rdi
	subq %rdi, %rcx
	movq -48(%rbp), %rdi
	movq -40(%rbp), %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	movq -32(%rbp), %rsi
	cmpq %rsi, %rdi
	setg %r11b
	movzbq %r11b, %rdi
	addq %rdi, %rcx
	movq %rcx, %rdi
	call putchar
	movq $65, %r10
	movq $-1, %rcx
	movq %rbx, %rsi
	imulq %rsi, %rcx
	addq %rcx, %r10
	movq -48(%rbp), %rdi
	movq -40(%rbp), %rcx
	imulq %rcx, %rdi
	movq -32(%rbp), %rsi
	movq -72(%rbp), %rcx
	cmpq %rcx, %rsi
	setl %r11b
	movzbq %r11b, %rsi
	imulq %rsi, %rdi
	addq %rdi, %r10
	movq -80(%rbp), %r8
	movq -88(%rbp), %rsi
	movq -120(%rbp), %rdi
	addq %rdi, %rsi
	cmpq %rsi, %r8
	setg %r11b
	movzbq %r11b, %r8
	movq -40(%rbp), %rsi
	imulq %rsi, %r8
	movq -40(%rbp), %rsi
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %r8
	movq -40(%rbp), %rdi
	imulq %rdi, %r8
	movq -40(%rbp), %rdi
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	movq %rax, %r8
	subq %r8, %r10
	movq -104(%rbp), %r8
	movq $0, %rdi
	subq %r8, %rdi
	movq %rdi, %r8
	addq %r8, %r10
	movq -104(%rbp), %r8
	movq -104(%rbp), %rdi
	cmpq %rdi, %r8
	setne %r11b
	movzbq %r11b, %r8
	movq $0, %rsi
	subq %r8, %rsi
	movq %rsi, %r8
	addq %r8, %r10
	movq -24(%rbp), %rdi
	addq %rdi, %r10
	movq %r12, %rdi
	addq %rdi, %r10
	movq %r10, %rdi
	call putchar
	movq $65, %rcx
	movq -48(%rbp), %r8
	movq -40(%rbp), %r10
	imulq %r10, %r8
	movq -48(%rbp), %rdi
	movq -40(%rbp), %r10
	movq $2, %rsi
	cmpq %rsi, %r10
	setne %r11b
	movzbq %r11b, %r10
	movq -40(%rbp), %r10
	cmpq $2, %r10
	setne %r11b
	movzbq %r11b, %r10
	movq $4, %rsi
	imulq %rsi, %r10
	cmpq %r10, %rdi
	setl %r11b
	movzbq %r11b, %rdi
	imulq %rdi, %r8
	movq -32(%rbp), %r10
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %r10
	movq %r11, %rdx
	movq %rax, %r8
	movq -24(%rbp), %rsi
	imulq %rsi, %r8
	movq -16(%rbp), %rsi
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %r8
	movq -8(%rbp), %rsi
	movq %r8, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %r8
	addq %r8, %rcx
	movq %r12, %rdi
	movq %rbx, %rsi
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %rdi
	movq -120(%rbp), %rsi
	imulq %rsi, %rdi
	addq %rdi, %rcx
	movq -112(%rbp), %rsi
	movq -104(%rbp), %rdi
	imulq %rdi, %rsi
	movq -96(%rbp), %rbx
	movq %rsi, %rax
	movq %rdx, %r11
	cqto
	idivq %rbx
	movq %r11, %rdx
	movq %rax, %rsi
	addq %rsi, %rcx
	movq $1, %rdi
	movq -88(%rbp), %rsi
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %rdi
	addq %rdi, %rcx
	movq $30, %rsi
	movq -80(%rbp), %rdi
	movq %rsi, %rax
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	movq %rax, %rsi
	addq %rsi, %rcx
	movq %r12, %rsi
	movq -80(%rbp), %rbx
	movq -80(%rbp), %rdi
	cmpq %rdi, %rbx
	sete %r11b
	movzbq %r11b, %rbx
	movq %rsi, %rax
	movq %rdx, %r11
	cqto
	idivq %rbx
	movq %r11, %rdx
	movq %rax, %rsi
	addq %rsi, %rcx
	movq %rcx, %rdi
	call putchar
	movq $0, %rsi
	movq %rsi, %rax
	movq -56(%rbp), %r12
	movq -64(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq $1, %rdi
	movq $2, %rsi
	movq $3, -8(%rbp)
	movq $4, %rcx
	movq $5, %r8
	movq $6, %rdx
	movq $7, %r10
	movq $8, %rax
	pushq %rax
	pushq %r10
	movq %rdx, %r9
	movq -8(%rbp), %rdx
	call f
	addq $16, %rsp
	movq $1, %rdi
	movq $1, %rsi
	movq $1, %rdx
	movq $1, %rax
	movq $1, %r10
	movq $1, %rcx
	movq $1, %r8
	movq $1, %r9
	pushq %r9
	pushq %r8
	movq %rcx, %r9
	movq %r10, %r8
	movq %rax, %rcx
	call f
	addq $16, %rsp
	movq $2, %rdi
	movq $2, %rsi
	movq $2, %rdx
	movq $2, %rcx
	movq $2, %rax
	movq $2, %r9
	movq $2, %r10
	movq $2, %r8
	pushq %r8
	pushq %r10
	movq %rax, %r8
	call f
	addq $16, %rsp
	movq $8, -8(%rbp)
	movq $1, %rdi
	movq $2, %r10
	movq $3, %rcx
	movq $4, %r8
	movq $5, %r9
	movq $6, %rax
	movq $7, %rdx
	pushq %rdx
	pushq %rax
	movq %r10, %rdx
	movq %rdi, %rsi
	movq -8(%rbp), %rdi
	call f
	addq $16, %rsp
	movq $7, %rdi
	movq $6, %rsi
	movq $5, %rdx
	movq $4, %rax
	movq $3, %r10
	movq $2, %r8
	movq $1, %r9
	movq $8, %rcx
	pushq %rcx
	pushq %r9
	movq %r8, %r9
	movq %r10, %r8
	movq %rax, %rcx
	call f
	addq $16, %rsp
	movq $-1, %r10
	movq $-2, %rdi
	movq $-3, %rax
	movq $-4, %rcx
	movq $-5, %r8
	movq $-6, %r9
	movq $-7, %rdx
	movq $-8, %rsi
	pushq %rsi
	pushq %rdx
	movq %rax, %rdx
	movq %rdi, %rsi
	movq %r10, %rdi
	call f
	addq $16, %rsp
	movq $1, %rdi
	movq $-2, %rsi
	movq $3, %rdx
	movq $-4, %rcx
	movq $5, %r8
	movq $-6, %r9
	movq $7, %rax
	movq $-8, %r10
	pushq %r10
	pushq %rax
	call f
	addq $16, %rsp
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
