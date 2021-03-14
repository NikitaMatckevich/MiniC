	.text
	.globl main
main:
	pushq %rbp
	movq %rsp, %rbp
	addq $-24, %rsp
	movq %r12, -8(%rbp)
	movq %rbx, -16(%rbp)
	movq $16, %rdi
	call sbrk
	movq %rax, %r12
	movq $24, %rdi
	call sbrk
	movq %rax, %rbx
	movq %rbx, -24(%rbp)
	movq $16, %rdi
	call sbrk
	movq %rax, %rdi
	movq -24(%rbp), %r11
	movq %rdi, 8(%r11)
	movq %rbx, %rdi
	movq $65, %rsi
	movq %rsi, 0(%rdi)
	movq %rbx, %rdi
	movq $66, %rsi
	movq %rsi, 16(%rdi)
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq $120, %rsi
	movq %rsi, 0(%rdi)
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq $121, %rsi
	movq %rsi, 8(%rdi)
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq %r12, %rdi
	movq $88, %rsi
	movq %rsi, 0(%rdi)
	movq %r12, %rsi
	movq $89, %rdi
	movq %rdi, 8(%rsi)
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq %rbx, %rsi
	movq %r12, %rdi
	movq %rdi, 8(%rsi)
	movq %rbx, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 8(%rdi), %rdi
	movq 8(%rdi), %rdi
	call putchar
	movq %rbx, %rdi
	movq 16(%rdi), %rdi
	call putchar
	movq $10, %rdi
	call putchar
	movq $0, %rdi
	movq %rdi, %rax
	movq -8(%rbp), %r12
	movq -16(%rbp), %rbx
	movq %rbp, %rsp
	popq %rbp
	ret
	.data
