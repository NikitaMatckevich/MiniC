	.text
	.globl main
make:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, %rbx
	movq $24, %rdi
	call sbrk
	movq %rax, %rdi
	movq %rdi, %r9
	movq %rbx, %r8
	movq %r8, 0(%r9)
	movq %rdi, %r9
	movq %rdi, %rbx
	movq %rdi, %r8
	movq %r8, 8(%rbx)
	movq %r8, 16(%r9)
	movq %rdi, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
inserer_apres:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rdi, -8(%rbp)
	movq %rsi, %rdi
	call make
	movq %rax, %rdi
	movq %rdi, %r8
	movq -8(%rbp), %rsi
	movq 16(%rsi), %rsi
	movq %rsi, 16(%r8)
	movq -8(%rbp), %rsi
	movq %rdi, %r8
	movq %r8, 16(%rsi)
	movq %rdi, %rsi
	movq 16(%rsi), %r8
	movq %rdi, %rsi
	movq %rsi, 8(%r8)
	movq -8(%rbp), %r8
	movq %r8, 8(%rdi)
	movq $0, %rdi
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
supprimer:
	movq %rdi, %rax
	movq 8(%rax), %r8
	movq %rdi, %rax
	movq 16(%rax), %rax
	movq %rax, 16(%r8)
	movq %rdi, %rax
	movq 16(%rax), %rax
	movq 8(%rdi), %rdi
	movq %rdi, 8(%rax)
	movq $0, %rax
	ret
afficher:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, -16(%rbp)
	movq -16(%rbp), %rbx
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
L57:
	movq %rbx, %rax
	movq -16(%rbp), %rdi
	cmpq %rdi, %rax
	setne %r11b
	movzbq %r11b, %rax
	testq %rax, %rax
	jz L47
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
	jmp L57
L47:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
cercle:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %rbx, -16(%rbp)
	movq %rdi, %rbx
	movq $1, %rdi
	call make
	movq %rax, -8(%rbp)
L75:
	movq %rbx, %rsi
	movq $2, %rdi
	cmpq %rdi, %rsi
	setge %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L65
	movq -8(%rbp), %rdi
	movq %rbx, %rsi
	call inserer_apres
	movq $1, %rdi
	subq %rdi, %rbx
	jmp L75
L65:
	movq -8(%rbp), %rdi
	movq %rdi, %rax
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
josephus:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq %rsi, %r12
	call cercle
	movq %rax, %rbx
L101:
	movq %rbx, %rsi
	movq %rbx, %rdi
	movq 16(%rdi), %rdi
	cmpq %rdi, %rsi
	setne %r11b
	movzbq %r11b, %rsi
	testq %rsi, %rsi
	jz L81
	movq $1, %r8
L95:
	movq %r8, %r9
	movq %r12, %rdi
	cmpq %rdi, %r9
	setl %r11b
	movzbq %r11b, %r9
	testq %r9, %r9
	jz L86
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
	movq $1, %rdi
	addq %rdi, %r8
	jmp L95
L86:
	movq %rbx, %rdi
	call supprimer
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
	jmp L101
L81:
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	movq %rdi, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
print_int:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, -16(%rbp)
	movq -16(%rbp), %rbx
	movq $10, %rdi
	movq %rbx, %rax
	movq %rdx, %r11
	cqto
	idivq %rdi
	movq %r11, %rdx
	movq %rax, %rbx
	movq -16(%rbp), %rdi
	movq $9, %rax
	cmpq %rax, %rdi
	jg L115
L113:
	movq $48, %rdi
	movq -16(%rbp), %r8
	movq $10, %rax
	imulq %rbx, %rax
	subq %rax, %r8
	addq %r8, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
L115:
	movq %rbx, %rdi
	call print_int
	jmp L113
main:
	movq $7, %rdi
	movq $5, %rsi
	call josephus
	movq %rax, %rdi
	call print_int
	movq $10, %rdi
	call putchar
	movq $5, %rdi
	movq $5, %r8
	movq %r8, %rsi
	call josephus
	movq %rax, %rdi
	call print_int
	movq $10, %rdi
	call putchar
	movq $5, %rdi
	movq $17, %rsi
	call josephus
	movq %rax, %rdi
	call print_int
	movq $10, %rdi
	call putchar
	movq $13, %rdi
	movq $2, %r8
	movq %r8, %rsi
	call josephus
	movq %rax, %rdi
	call print_int
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	ret
	.data
