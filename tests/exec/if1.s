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
	movq %rbx, %rdi
	testq %rdi, %rdi
	jz L38
	movq $66, %rbx
L38:
	movq %rbx, %rdi
	call putchar
	movq %rbx, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jnz L33
L32:
	testq %rdi, %rdi
	jz L30
	movq $67, %rbx
L30:
	movq %rbx, %rdi
	call putchar
	movq %rbx, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jnz L25
L24:
	testq %rdi, %rdi
	jz L22
	movq $68, %rbx
L22:
	movq %rbx, %rdi
	call putchar
	movq %rbx, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L17
L16:
	testq %rdi, %rdi
	jz L14
	movq $69, %rbx
L14:
	movq %rbx, %rdi
	call putchar
	movq %rbx, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L9
L8:
	testq %rdi, %rdi
	jz L6
	movq $70, %rbx
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
	jmp L6
L9:
	movq $1, %rdi
	jmp L8
	jmp L14
L17:
	movq $0, %rdi
	jmp L16
	jmp L22
L25:
	movq $1, %rdi
	jmp L24
	jmp L30
L33:
	movq $0, %rdi
	jmp L32
	jmp L38
	.data
