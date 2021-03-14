	.text
	.globl main
fact_rec:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, %r8
	movq $1, %r9
	cmpq %r9, %r8
	jg L7
	movq $1, %rbx
L1:
	movq %rbx, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L7:
	movq %rdi, %rbx
	movq $1, %r8
	subq %r8, %rdi
	call fact_rec
	movq %rax, %rdi
	imulq %rdi, %rbx
	jmp L1
main:
	movq $0, %rdi
	call fact_rec
	movq %rax, %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $0, %rdi
	call fact_rec
	movq %rax, %rdi
	cmpq $1, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L35
	movq $49, %rdi
	call putchar
L35:
	movq $1, %rdi
	call fact_rec
	movq %rax, %rdi
	movq $1, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $1, %rdi
	call fact_rec
	movq %rax, %rdi
	cmpq $1, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L25
	movq $50, %rdi
	call putchar
L25:
	movq $5, %rdi
	call fact_rec
	movq %rax, %rdi
	movq $120, %rsi
	cmpq %rsi, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq $5, %rdi
	call fact_rec
	movq %rax, %rdi
	cmpq $120, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L15
	movq $51, %rdi
	call putchar
L15:
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	ret
	jmp L15
	jmp L25
	jmp L35
	.data
