	.text
	.globl main
make:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	movq %rdx, -8(%rbp)
	movq %rsi, -16(%rbp)
	movq %rdi, -24(%rbp)
	movq $24, %rdi
	call sbrk
	movq %rax, %rdi
	movq %rdi, %r9
	movq -24(%rbp), %r8
	movq %r8, 0(%r9)
	movq %rdi, %r9
	movq -16(%rbp), %r8
	movq %r8, 16(%r9)
	movq %rdi, %r9
	movq -8(%rbp), %r8
	movq %r8, 8(%r9)
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
insere:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %r12, -8(%rbp)
	movq %rsi, %r8
	movq %rdi, %r12
	movq 0(%r12), %r12
	cmpq %r12, %r8
	sete %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L55
	movq $0, %rsi
L14:
	movq %rsi, %rax
	movq -8(%rbp), %r12
	movq %rbp, %rsp
	popq %rbp
	ret
L55:
	movq %rsi, %r8
	movq %rdi, %r12
	movq 0(%r12), %r12
	cmpq %r12, %r8
	jge L33
	movq %rdi, %r12
	movq 16(%r12), %r8
	movq $0, %r12
	cmpq %r12, %r8
	sete %r11b
	movzbq %r11b, %r8
	movq %rdi, %r8
	movq 16(%r8), %r12
	cmpq $0, %r12
	sete %r11b
	movzbq %r11b, %r12
	testq %r12, %r12
	jz L37
	movq %rdi, %r12
	movq %rsi, %rdi
	movq $0, %r8
	movq $0, %rsi
	movq %rsi, %rdx
	movq %r8, %rsi
	call make
	movq %rax, %rsi
	movq %rsi, 16(%r12)
L15:
	movq $0, %rsi
	jmp L14
L37:
	movq 16(%rdi), %rdi
	movq %rsi, %r12
	movq %r12, %rsi
	call insere
	jmp L15
L33:
	movq %rdi, %r12
	movq 8(%r12), %r8
	movq $0, %r12
	cmpq %r12, %r8
	sete %r11b
	movzbq %r11b, %r8
	movq %rdi, %r8
	movq 8(%r8), %r12
	cmpq $0, %r12
	sete %r11b
	movzbq %r11b, %r12
	testq %r12, %r12
	jz L19
	movq %rdi, %r12
	movq %rsi, %rdi
	movq $0, %rsi
	movq $0, %r8
	movq %r8, %rdx
	call make
	movq %rax, %rsi
	movq %rsi, 8(%r12)
	jmp L15
L19:
	movq 8(%rdi), %rdi
	movq %rsi, %r12
	movq %r12, %rsi
	call insere
	jmp L15
contient:
	movq %rsi, %r9
	movq %rdi, %r8
	movq 0(%r8), %r8
	cmpq %r8, %r9
	sete %r11b
	movzbq %r11b, %r9
	testq %r9, %r9
	jz L92
	movq $1, %rdi
L62:
	movq %rdi, %rax
	ret
L92:
	movq %rsi, %rdx
	movq %rdi, %r9
	movq 0(%r9), %r10
	cmpq %r10, %rdx
	setl %r11b
	movzbq %r11b, %rdx
	testq %rdx, %rdx
	jnz L87
L80:
	testq %rdx, %rdx
	jz L75
	movq 16(%rdi), %rdi
	call contient
	movq %rax, %rdi
	jmp L62
L75:
	movq %rdi, %r10
	movq 8(%r10), %r10
	movq $0, %rdx
	cmpq %rdx, %r10
	setne %r11b
	movzbq %r11b, %r10
	movq %rdi, %r10
	movq 8(%r10), %r10
	cmpq $0, %r10
	setne %r11b
	movzbq %r11b, %r10
	testq %r10, %r10
	jz L63
	movq 8(%rdi), %rdi
	call contient
	movq %rax, %rdi
	jmp L62
L63:
	movq $0, %rdi
	jmp L62
L87:
	movq %rdi, %r10
	movq 16(%r10), %r10
	movq $0, %rdx
	cmpq %rdx, %r10
	setne %r11b
	movzbq %r11b, %r10
	movq %rdi, %r10
	movq 16(%r10), %rdx
	cmpq $0, %rdx
	setne %r11b
	movzbq %r11b, %rdx
	jmp L80
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
	movq $9, %rax
	cmpq %rax, %rdi
	jg L110
L108:
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
L110:
	movq %rbx, %rdi
	call print_int
	jmp L108
print:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rdi, -8(%rbp)
	movq $40, %rdi
	call putchar
	movq -8(%rbp), %r8
	movq 16(%r8), %rdi
	movq $0, %r8
	cmpq %r8, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	movq -8(%rbp), %rdi
	movq 16(%rdi), %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L133
	movq -8(%rbp), %r8
	movq 16(%r8), %rdi
	call print
L133:
	movq -8(%rbp), %r8
	movq 0(%r8), %rdi
	call print_int
	movq -8(%rbp), %r8
	movq 8(%r8), %r8
	movq $0, %rdi
	cmpq %rdi, %r8
	setne %r11b
	movzbq %r11b, %r8
	movq -8(%rbp), %r8
	movq 8(%r8), %r8
	cmpq $0, %r8
	setne %r11b
	movzbq %r11b, %r8
	testq %r8, %r8
	jz L119
	movq -8(%rbp), %rdi
	movq 8(%rdi), %rdi
	call print
L119:
	movq $41, %rdi
	call putchar
	movq %rax, %rdi
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L119
	jmp L133
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $1, %rbx
	movq $0, %rsi
	movq $0, %rdx
	movq %rbx, %rdi
	call make
	movq %rax, %rbx
	movq %rbx, %rdi
	movq $17, %r8
	movq %r8, %rsi
	call insere
	movq %rbx, %rdi
	movq $5, %rsi
	call insere
	movq %rbx, %rdi
	movq $8, %rsi
	call insere
	movq %rbx, %rsi
	movq %rsi, %rdi
	call print
	movq $10, %rsi
	movq %rsi, %rdi
	call putchar
	movq %rbx, %rdi
	movq $5, %rsi
	call contient
	movq %rax, %rsi
	cmpq $0, %rsi
	setne %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jnz L184
L168:
	testq %rsi, %rsi
	jz L161
	movq $111, %rsi
	movq %rsi, %rdi
	call putchar
	movq $107, %rsi
	movq %rsi, %rdi
	call putchar
	movq $10, %rsi
	movq %rsi, %rdi
	call putchar
L161:
	movq %rbx, %rdi
	movq $42, %r8
	movq %r8, %rsi
	call insere
	movq %rbx, %rdi
	movq $1000, %r8
	movq %r8, %rsi
	call insere
	movq %rbx, %rdi
	movq $0, %r8
	movq %r8, %rsi
	call insere
	movq %rbx, %rsi
	movq %rsi, %rdi
	call print
	movq $10, %rsi
	movq %rsi, %rdi
	call putchar
	movq $0, %rsi
	movq %rsi, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	jmp L161
L184:
	movq %rbx, %rdx
	movq $0, %rsi
	movq %rdx, %rdi
	call contient
	movq %rax, %rsi
	cmpq $0, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	cmpq $0, %rsi
	setne %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jnz L178
	jmp L168
L178:
	movq %rbx, %rdx
	movq $17, %rsi
	movq %rdx, %rdi
	call contient
	movq %rax, %rsi
	cmpq $0, %rsi
	setne %r11b
	movzbq %r11b, %rsi
	cmpq $0, %rsi
	setne %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jnz L172
	jmp L168
L172:
	movq %rbx, %rdx
	movq $3, %rsi
	movq %rdx, %rdi
	call contient
	movq %rax, %rsi
	cmpq $0, %rsi
	sete %r11b
	movzbq %r11b, %rsi
	jmp L168
	.data
