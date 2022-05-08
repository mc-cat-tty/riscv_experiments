.text
.globl exp
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
.globl print_num
print_num:
	addi sp, sp, -24
	sd s3, 0(sp)
	sd s4, 4(sp)
	sd s5, 8(sp)

	# li s3, 1234	# test number
	mv s3, a0
	li s4, 0	# counter
	li s5, 10	# divisor
loop_push:
	ble s3, zero, exit_push
	remu t0, s3, s5
	addi t0, t0, 48
	addi sp, sp, -4
	sw t0, 0(sp)	# push ascii digit into the stack
	addi s4, s4, 1	# increment counter
	divu s3, s3, s5
	j loop_push
exit_push:

loop_pop:
	ble s4, zero, exit_pop
	li a0, 1
	li a7, 64
	li a2, 1
	mv a1, sp
	ecall
	addi sp, sp, 4
	addi s4, s4, -1
	j loop_pop
exit_pop:
	ld s5, 8(sp)
	ld s4, 4(sp)
	ld s3, 0(sp)
	addi sp, sp, 24
	ret

.text
.globl main
main:
	.data
	b:		.word	5	# base
	e:		.word	3	# exponent
	fmt:	.asciz	"The result is: "
	newl:	.asciz	"\n"

	.text
	addi sp, sp, 32
	sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
	sd ra, 24(sp)
	
	# Load literals into register file
	la s0, b
	la s1, e
	la s2, fmt
	lw s0, 0(s0)
	lw s1, 0(s1)

	# Call exp function
	mv a0, s0
	mv a1, s1
	jal exp
	mv s3, a0
	
	# Print result
	li a0, 1
	li a7, 64
	mv a1, s2	# string base address
	li a2, 15	# string length
	ecall
	
	mv a0, s3
	jal print_num
	
	li a0, 1
    li a7, 64
	la s2, newl
    mv a1, s2   # string base address
    li a2, 1   # string length
    ecall

	# Return from main
	ld ra, 24(sp)
	ld s2, 16(sp)
	ld s1, 8(sp)
	ld s0, 0(sp)
	addi sp, sp, 12
	li a0, 0
	ret
