.include "mylib.s"

.text
exp:
	# a0 -> base
	# a1 -> exponent
	addi sp, sp, -8
	sd s0, 0(sp)

	li s0, 1	# accumulator
loop_exp:
	ble a1, zero, exit_exp
	mul s0, s0, a0
	addi a1, a1, -1
	j loop_exp
exit_exp:
	mv a0, s0
	
	ld s0, 0(sp)
	addi sp, sp, 8
	ret

.text
.globl main
main:
	.section .rodata
	# b:		.word	5	# base
	# e:		.word	3	# exponent
	fmt:	.string	"The result is: "
	newl:	.string	"\n"
	base_s:	.string	"Base: "
	exp_s:	.string	"Exponent: "
	
	.section .text
	addi sp, sp, 32
	sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
	sd ra, 24(sp)
	
	# Load literals into register file
	# la s0, b
	# la s1, e
	# lw s0, 0(s0)
	# lw s1, 0(s1)
	
	# Get input - base
	la a0, base_s
	jal print_str

	addi sp, sp, -16
	mv a0, sp
	li a1, 16
	jal get_str
	mv a0, sp
	jal str_to_int
	addi sp, sp, 16
	mv s0, a0

	# Get input - exponent
	la a0, exp_s
	jal print_str

	addi sp, sp, -16
	mv a0, sp
	li a1, 16
	jal get_str
	mv a0, sp
	jal str_to_int
	addi sp, sp, 16
	mv s1, a0
	
	# Call exp function
	mv a0, s0
	mv a1, s1
	jal exp
	mv s3, a0
	
	# Print result
	la a0, fmt
	jal print_str
	
	mv a0, s3
	jal print_num
	
	la a0, newl
	jal print_str	

	# Return from main
	ld ra, 24(sp)
	ld s2, 16(sp)
	ld s1, 8(sp)
	ld s0, 0(sp)
	addi sp, sp, 12
	li a0, 0
	ret
