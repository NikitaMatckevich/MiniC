	.text
	.globl main
main:
	movq $0, %rdi
	movq 0(%rdi), %rdi
	call putchar
	movq $0, %rax
	ret
	.data
