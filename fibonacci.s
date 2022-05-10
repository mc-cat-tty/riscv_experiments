.include "mylib.s"

.text
fib:  # a0 -> n
	addi sp, sp, -32
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	sd ra, 24(sp)
	
	mv s0, a0
	li s1, 2
	li s2, 3

	# base case
	li a0, 1	# ready for base case too	
	beq s0, s1, e
	beq s0, s2, e	# s1 is 1 at this point of the program

	# general case
	addi a0, s0, -1
	jal fib
	mv s1, a0

	addi a0, s0, -2
	jal fib
	mv s2, a0
	
	add a0, s1, s2
e:	ld s0, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	ld ra, 24(sp)
	addi sp, sp, 32
	ret

.text
.globl main
main:
	.section .rodata
	get_num_s:	.string	"Enter a number: "
	result_s:	.string	"The result is: "
	newl:		.string	"\n"
	
	.section .text
	addi sp, sp, -16
	sd s0, 0(sp)
	sd ra, 8(sp)
	
	la a0, get_num_s
	jal print_str
	
	addi sp, sp, -8
	mv a0, sp
	li a1, 8
	jal get_str	
	mv a0, sp
	jal str_to_int
	addi sp, sp, 8
	# a0 -> just entered int
	
	jal fib
	mv s0, a0

	la a0, result_s
	jal print_str
	mv a0, s0
	jal print_num
	la a0, newl
	jal print_str

	ld s0, 0(sp)
	ld ra, 8(sp)
	addi sp, sp, 16
	ret
