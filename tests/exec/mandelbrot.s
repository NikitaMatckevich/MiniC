	.text
	.globl main
add:
	addq %rsi, %rdi
	movq %rdi, %rax
	ret
sub:
	subq %rsi, %rdi
	movq %rdi, %rax
	ret
mul:
	imulq %rsi, %rdi
	movq $4096, %rsi
	addq %rsi, %rdi
	movq $8192, %rsi
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %rdi
	movq %rdi, %rax
	ret
div:
	movq $8192, %rax
	imulq %rax, %rdi
	movq %rsi, %rax
	movq $2, %r8
	movq %rdx, %r11
	cqto
	idivq %r8
	movq %r11, %rdx
	addq %rax, %rdi
	movq %rdi, %rax
	movq %rdx, %r11
	cqto
	idivq %rsi
	movq %r11, %rdx
	movq %rax, %rdi
	movq %rdi, %rax
	ret
of_int:
	movq $8192, %r8
	imulq %r8, %rdi
	movq %rdi, %rax
	ret
iter:
	pushq %rbp
	movq %rsp, %rbp
	addq $-72, %rsp
	movq %r12, -40(%rbp)
	movq %rbx, -56(%rbp)
	movq %r8, -48(%rbp)
	movq %rcx, -64(%rbp)
	movq %rdx, -72(%rbp)
	movq %rsi, %r12
	movq %rdi, %rbx
	movq %rbx, %rdx
	movq $100, %rsi
	cmpq %rsi, %rdx
	sete %r11b
	movzbq %r11b, %rdx
	movq %rbx, %rdx
	cmpq $100, %rdx
	sete %r11b
	movzbq %r11b, %rdx
	testq %rdx, %rdx
	jz L65
	movq $1, %rsi
L33:
	movq %rsi, %rax
	movq -40(%rbp), %r12
	movq -56(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L65:
	movq -64(%rbp), %rdx
	movq -64(%rbp), %rsi
	movq %rdx, %rdi
	call mul
	movq %rax, -24(%rbp)
	movq -48(%rbp), %rdx
	movq -48(%rbp), %rsi
	movq %rdx, %rdi
	call mul
	movq %rax, -32(%rbp)
	movq -24(%rbp), %rdx
	movq -32(%rbp), %rsi
	movq %rdx, %rdi
	call add
	movq %rax, -16(%rbp)
	movq $4, %rsi
	movq %rsi, %rdi
	call of_int
	movq %rax, %rsi
	cmpq %rsi, -16(%rbp)
	jg L53
	movq $1, %rsi
	addq %rsi, %rbx
	movq %r12, -8(%rbp)
	movq -72(%rbp), %r15
	movq %r15, -16(%rbp)
	movq -24(%rbp), %rdi
	movq -32(%rbp), %r8
	movq %r8, %rsi
	call sub
	movq %rax, %rdi
	movq %r12, %rsi
	call add
	movq %rax, %r12
	movq $2, %rsi
	movq %rsi, %rdi
	call of_int
	movq %rax, -24(%rbp)
	movq -64(%rbp), %rdx
	movq -48(%rbp), %rsi
	movq %rdx, %rdi
	call mul
	movq %rax, %rsi
	movq -24(%rbp), %rdi
	call mul
	movq %rax, %rdx
	movq -72(%rbp), %rsi
	movq %rdx, %rdi
	call add
	movq %rax, %rsi
	movq %rsi, %r8
	movq %r12, %rcx
	movq -16(%rbp), %rdx
	movq -8(%rbp), %rsi
	movq %rbx, %rdi
	call iter
	movq %rax, %rsi
	jmp L33
L53:
	movq $0, %rsi
	jmp L33
inside:
	pushq %rbp
	movq %rsp, %rbp
	addq $-32, %rsp
	movq %r12, -24(%rbp)
	movq %rbx, -32(%rbp)
	movq %rsi, %r8
	movq $0, %rbx
	movq %rdi, %r12
	movq %r8, -8(%rbp)
	movq $0, %rdi
	call of_int
	movq %rax, -16(%rbp)
	movq $0, %rdi
	call of_int
	movq %rax, %rdi
	movq %rdi, %r8
	movq -16(%rbp), %rcx
	movq -8(%rbp), %rdx
	movq %r12, %rsi
	movq %rbx, %rdi
	call iter
	movq %rax, %rdi
	movq %rdi, %rax
	movq -24(%rbp), %r12
	movq -32(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
run:
	pushq %rbp
	movq %rsp, %rbp
	addq $-72, %rsp
	movq %rdi, -64(%rbp)
	movq $-2, %r10
	movq %r10, %rdi
	call of_int
	movq %rax, -24(%rbp)
	movq $1, %r10
	movq %r10, %rdi
	call of_int
	movq %rax, %r10
	movq -24(%rbp), %rsi
	movq %r10, %rdi
	call sub
	movq %rax, -56(%rbp)
	movq $2, %r10
	movq -64(%rbp), %rsi
	imulq %rsi, %r10
	movq %r10, %rdi
	call of_int
	movq %rax, %r10
	movq %r10, %rsi
	movq -56(%rbp), %rdi
	call div
	movq %rax, -32(%rbp)
	movq $-1, %r10
	movq %r10, %rdi
	call of_int
	movq %rax, -40(%rbp)
	movq $1, %r10
	movq %r10, %rdi
	call of_int
	movq %rax, %r10
	movq -40(%rbp), %rsi
	movq %r10, %rdi
	call sub
	movq %rax, -56(%rbp)
	movq -64(%rbp), %r10
	movq %r10, %rdi
	call of_int
	movq %rax, %r10
	movq %r10, %rsi
	movq -56(%rbp), %rdi
	call div
	movq %rax, -48(%rbp)
	movq $0, -56(%rbp)
L122:
	movq -56(%rbp), %rsi
	movq -64(%rbp), %r10
	cmpq %r10, %rsi
	setl %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L83
	movq -40(%rbp), %r15
	movq %r15, -8(%rbp)
	movq -56(%rbp), %rsi
	movq %rsi, %rdi
	call of_int
	movq %rax, %rdi
	movq -48(%rbp), %rsi
	call mul
	movq %rax, %rsi
	movq -8(%rbp), %rdi
	call add
	movq %rax, -8(%rbp)
	movq $0, -16(%rbp)
L111:
	movq -16(%rbp), %r10
	movq $2, %rdx
	movq -64(%rbp), %rsi
	imulq %rsi, %rdx
	cmpq %rdx, %r10
	setl %r11b
	movzbq %r11b, %r10
	testq %r10, %r10
	jz L88
	movq -24(%rbp), %r15
	movq %r15, -72(%rbp)
	movq -16(%rbp), %r10
	movq %r10, %rdi
	call of_int
	movq %rax, %r10
	movq -32(%rbp), %rdi
	movq %rdi, %rsi
	movq %r10, %rdi
	call mul
	movq %rax, %rdi
	movq %rdi, %rsi
	movq -72(%rbp), %rdi
	call add
	movq %rax, %rdi
	movq -8(%rbp), %r8
	movq %r8, %rsi
	call inside
	movq %rax, %rsi
	testq %rsi, %rsi
	jz L93
	movq $48, %rsi
	movq %rsi, %rdi
	call putchar
L91:
	movq $1, %rsi
	addq %rsi, -16(%rbp)
	jmp L111
L93:
	movq $49, %rsi
	movq %rsi, %rdi
	call putchar
	jmp L91
L88:
	movq $10, %r10
	movq %r10, %rdi
	call putchar
	movq $1, %r10
	addq %r10, -56(%rbp)
	jmp L122
L83:
	movq $0, %r10
	movq %r10, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
main:
	movq $30, %rdi
	call run
	movq $0, %rax
	ret
	.data
