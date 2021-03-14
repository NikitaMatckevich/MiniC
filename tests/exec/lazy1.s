	.text
	.globl main
any:
	ret
zero:
	movq $10, %rax
L9:
	movq %rax, %rdi
	testq %rdi, %rdi
	jz L4
	movq $1, %rdi
	subq %rdi, %rax
	jmp L9
L4:
	ret
false:
	call zero
	movq %rax, %rdi
	movq %rdi, %rax
	ret
true:
	call zero
	movq %rax, %rdi
	cmpq $0, %rdi
	sete %r11b
	movzbq %r11b, %rdi
	movq %rdi, %rax
	ret
fail:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %r12, -8(%rbp)
	call any
	movq %rax, %r12
	call zero
	movq %rax, %rdi
	movq %r12, %rax
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	movq %rax, %r12
	movq %r12, %rax
	movq -8(%rbp), %r12
	movq %rbp, %rsp
	popq %rbp
	ret
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	call true
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jnz L134
L132:
	testq %rbx, %rbx
	jz L129
	movq $65, %rbx
	movq %rbx, %rdi
	call putchar
L129:
	call false
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jnz L126
L124:
	testq %rbx, %rbx
	jz L121
	movq $66, %rbx
	movq %rbx, %rdi
	call putchar
L121:
	call true
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jnz L118
L116:
	testq %rbx, %rbx
	jz L113
	movq $66, %rbx
	movq %rbx, %rdi
	call putchar
L113:
	call false
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jnz L110
L108:
	testq %rbx, %rbx
	jz L105
	movq $66, %rbx
	movq %rbx, %rdi
	call putchar
L105:
	movq $0, %rbx
	testq %rbx, %rbx
	jnz L103
L101:
	testq %rbx, %rbx
	jz L98
	movq $66, %rbx
	movq %rbx, %rdi
	call putchar
L98:
	call false
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jnz L95
L93:
	testq %rbx, %rbx
	jz L90
	movq $66, %rbx
	movq %rbx, %rdi
	call putchar
L90:
	movq $10, %rbx
	movq %rbx, %rdi
	call putchar
	call true
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L85
L83:
	testq %rdi, %rdi
	jz L80
	movq $65, %rdi
	call putchar
L80:
	call false
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L77
L75:
	testq %rdi, %rdi
	jz L72
	movq $65, %rdi
	call putchar
L72:
	call true
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L69
L67:
	testq %rdi, %rdi
	jz L64
	movq $65, %rdi
	call putchar
L64:
	call false
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L61
L59:
	testq %rdi, %rdi
	jz L56
	movq $66, %rdi
	call putchar
L56:
	movq $1, %rdi
	testq %rdi, %rdi
	jz L54
L52:
	testq %rdi, %rdi
	jz L49
	movq $65, %rbx
	movq %rbx, %rdi
	call putchar
L49:
	call true
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	testq %rbx, %rbx
	jz L46
L44:
	testq %rbx, %rbx
	jz L41
	movq $65, %rbx
	movq %rbx, %rdi
	call putchar
L41:
	movq $10, %rbx
	movq %rbx, %rdi
	call putchar
	movq $65, %rbx
	call false
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jnz L35
L33:
	addq %rdi, %rbx
	movq %rbx, %rdi
	call putchar
	movq $64, %rbx
	call true
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	testq %rdi, %rdi
	jz L27
L25:
	addq %rdi, %rbx
	movq %rbx, %rdi
	call putchar
	movq $10, %rbx
	movq %rbx, %rdi
	call putchar
	movq $0, %rbx
	movq %rbx, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L27:
	call fail
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L25
L35:
	call fail
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L33
	jmp L41
L46:
	call fail
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L44
	jmp L49
L54:
	call fail
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L52
	jmp L56
L61:
	call false
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L59
	jmp L64
L69:
	call false
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L67
	jmp L72
L77:
	call true
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L75
	jmp L80
L85:
	call true
	movq %rax, %rdi
	cmpq $0, %rdi
	setne %r11b
	movzbq %r11b, %rdi
	jmp L83
	jmp L90
L95:
	call fail
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L93
	jmp L98
L103:
	call fail
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L101
	jmp L105
L110:
	call false
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L108
	jmp L113
L118:
	call false
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L116
	jmp L121
L126:
	call true
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L124
	jmp L129
L134:
	call true
	movq %rax, %rbx
	cmpq $0, %rbx
	setne %r11b
	movzbq %r11b, %rbx
	jmp L132
	.data
