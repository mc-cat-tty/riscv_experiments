.include "mylib.s"

.text
.local fact
fact:  # a0 -> n
	addi sp, sp, -24
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd ra, 16(sp)

	mv s0, a0

	# base case
	li a0, 1
	beq s0, zero, e
	
	# general case
	addi a0, s0, -1
	jal fact
	mv s1, a0
	mul a0, s0, s1

e:
	ld s0, 0(sp)
	ld s1, 8(sp)
	ld ra, 16(sp)
	addi sp, sp, 24
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
	
	jal fact
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
