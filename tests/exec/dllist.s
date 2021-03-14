	.text
	.globl main
make:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rdi, -8(%rbp)
	movq $24, %rdi
	call sbrk
	movq %rax, %rdi
	movq %rdi, %r9
	movq -8(%rbp), %r8
	movq %r8, 0(%r9)
	movq %rdi, %r9
	movq %rdi, %rcx
	movq %rdi, %r8
	movq %r8, 8(%rcx)
	movq %r8, 16(%r9)
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
afficher:
	pushq %rbp
	movq %rsp, %rbp
	addq $-16, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq %rdi, %r12
	movq %r12, %rbx
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
L27:
	movq %rbx, %rax
	movq %r12, %rdi
	cmpq %rdi, %rax
	setne %r11b
	movzbq %r11b, %rax
	testq %rax, %rax
	jz L17
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rbx
	jmp L27
L17:
	movq $10, %rdi
	call putchar
	movq $0, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
inserer_apres:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq %rdi, %rbx
	movq %rsi, %rdi
	call make
	movq %rax, %rdi
	movq %rdi, %r8
	movq %rbx, %rsi
	movq 16(%rsi), %rsi
	movq %rsi, 16(%r8)
	movq %rbx, %rsi
	movq %rdi, %r8
	movq %r8, 16(%rsi)
	movq %rdi, %rsi
	movq 16(%rsi), %rsi
	movq %rdi, %r8
	movq %r8, 8(%rsi)
	movq %rbx, 8(%rdi)
	movq $0, %rdi
	movq %rdi, %rax
	movq -8(%rbp), %rbx
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
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-8, %rsp
	movq %rbx, -8(%rbp)
	movq $65, %rdi
	call make
	movq %rax, %rbx
	movq %rbx, %rdi
	call afficher
	movq %rbx, %rdi
	movq $66, %rsi
	call inserer_apres
	movq %rbx, %rdi
	call afficher
	movq %rbx, %rdi
	movq $67, %rsi
	call inserer_apres
	movq %rbx, %rdi
	call afficher
	movq %rbx, %rdi
	movq 16(%rdi), %rdi
	call supprimer
	movq %rbx, %rdi
	call afficher
	movq $0, %rdi
	movq %rdi, %rax
	movq -8(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
