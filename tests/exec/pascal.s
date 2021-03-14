	.text
	.globl main
get:
	movq %rsi, %r8
	movq $0, %r9
	cmpq %r9, %r8
	sete %r11b
	movzbq %r11b, %r8
	movq %rsi, %r8
	cmpq $0, %r8
	sete %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L7
	movq 0(%rdi), %rdi
L1:
	movq %rdi, %rax
	ret
L7:
	movq 8(%rdi), %rdi
	movq $1, %r9
	subq %r9, %rsi
	call get
	movq %rax, %rdi
	jmp L1
set:
	movq %rsi, %r9
	movq $0, %r8
	cmpq %r8, %r9
	sete %r11b
	movzbq %r11b, %r9
	movq %rsi, %r9
	cmpq $0, %r9
	sete %r11b
	movzbq %r11b, %r9
	testq %r9, %r9
	jz L23
	movq %rdx, %rsi
	movq %rsi, 0(%rdi)
L16:
	movq %rsi, %rax
	ret
L23:
	movq 8(%rdi), %rdi
	movq $1, %r9
	subq %r9, %rsi
	call set
	movq %rax, %rsi
	jmp L16
create:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	movq %rbx, -24(%rbp)
	movq %rdi, -16(%rbp)
	movq -16(%rbp), %r8
	movq $0, %rdi
	cmpq %rdi, %r8
	sete %r11b
	movzbq %r11b, %r8
	movq -16(%rbp), %r8
	cmpq $0, %r8
	sete %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L46
	movq $0, %rdi
L34:
	movq %rdi, %rax
	movq -24(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L46:
	movq $16, %rdi
	call sbrk
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rdi
	movq $0, %rbx
	movq %rbx, 0(%rdi)
	movq -8(%rbp), %rbx
	movq -16(%rbp), %rdi
	movq $1, %r8
	subq %r8, %rdi
	call create
	movq %rax, %rdi
	movq %rdi, 8(%rbx)
	movq -8(%rbp), %rdi
	jmp L34
print_row:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	movq %rsi, -16(%rbp)
	movq %rdi, -24(%rbp)
	movq $0, -8(%rbp)
L78:
	movq -8(%rbp), %rsi
	movq -16(%rbp), %rdi
	cmpq %rdi, %rsi
	setle %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L57
	movq -24(%rbp), %rdi
	movq -8(%rbp), %rsi
	call get
	movq %rax, %rdi
	movq $0, %rsi
	cmpq %rsi, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	movq -24(%rbp), %rdi
	movq -8(%rbp), %rsi
	call get
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L62
	movq $42, %rdi
	call putchar
L60:
	movq $1, %rdi
	addq %rdi, -8(%rbp)
	jmp L78
L62:
	movq $46, %rdi
	call putchar
	jmp L60
L57:
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
mod7:
	movq %rdi, %r9
	movq $7, %r8
	movq %rdi, %rax
	movq $7, %rdi
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	imulq %rax, %r8
	subq %r8, %r9
	movq %r9, %rax
	ret
compute_row:
	pushq %rbp
	movq %rsp, %rbp
	addq $-40, %rsp
	movq %rbx, -16(%rbp)
	movq %rsi, %r8
	movq %rdi, -32(%rbp)
	movq %r8, -24(%rbp)
L113:
	movq -24(%rbp), %rsi
	movq $0, %r8
	cmpq %r8, %rsi
	setg %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L93
	movq -32(%rbp), %r15
	movq %r15, -40(%rbp)
	movq -24(%rbp), %rbx
	movq -32(%rbp), %rdi
	movq -24(%rbp), %r8
	movq %r8, %rsi
	call get
	movq %rax, -8(%rbp)
	movq -32(%rbp), %rdi
	movq -24(%rbp), %r8
	movq $1, %rsi
	subq %rsi, %r8
	movq %r8, %rsi
	call get
	movq %rax, %rdi
	addq %rdi, -8(%rbp)
	movq -8(%rbp), %rdi
	call mod7
	movq %rax, %rdi
	movq %rdi, %rdx
	movq %rbx, %rsi
	movq -40(%rbp), %rdi
	call set
	movq $1, %rsi
	subq %rsi, -24(%rbp)
	jmp L113
L93:
	movq -32(%rbp), %rdi
	movq $0, %r8
	movq $1, %rsi
	movq %rsi, %rdx
	movq %r8, %rsi
	call set
	movq $0, %r8
	movq %r8, %rax
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
pascal:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	movq %rdi, -24(%rbp)
	movq -24(%rbp), %rdi
	movq $1, %rsi
	addq %rsi, %rdi
	call create
	movq %rax, -8(%rbp)
	movq $0, -16(%rbp)
L133:
	movq -16(%rbp), %rsi
	movq -24(%rbp), %rdi
	cmpq %rdi, %rsi
	setl %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L116
	movq -8(%rbp), %rdi
	movq -16(%rbp), %r8
	movq $0, %r9
	movq %r9, %rdx
	movq %r8, %rsi
	call set
	movq -8(%rbp), %rdi
	movq -16(%rbp), %r9
	movq %r9, %rsi
	call compute_row
	movq -8(%rbp), %rdi
	movq -16(%rbp), %r9
	movq %r9, %rsi
	call print_row
	movq $1, %rdi
	addq %rdi, -16(%rbp)
	jmp L133
L116:
	movq $0, %rdi
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
main:
	movq $42, %rdi
	call pascal
	movq $0, %rax
	ret
	.data
