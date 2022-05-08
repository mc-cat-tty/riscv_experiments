
.text
.globl main
main:
	.data
	str: .asciz	"Hello world from asm!\n"
	len: .word	22

	.text
	la t0, str
	la t1, len
	lw t1, 0(t1)
	li a0, 1	# file descriptor to write to: a1 -> stdout
	li a7, 64	# system call code: sys_write
	mv a2, t1	# a2 -> string len
	mv a1, t0	# a1 -> string base address
	ecall
	li a0, 0
	ret
