.equ SYS_READ, 63
.equ SYS_WRITE, 64

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.text
.globl print_num
print_num:  # a0 -> input number
    addi sp, sp, -24
    sd s3, 0(sp)
    sd s4, 4(sp)
    sd s5, 8(sp)

    # li s3, 1234   # test number
    mv s3, a0
    li s4, 0    # counter
    li s5, 10   # divisor
loop_push:
    ble s3, zero, exit_push
    remu t0, s3, s5
    addi t0, t0, 48
    addi sp, sp, -4
    sw t0, 0(sp)    # push ascii digit into the stack
    addi s4, s4, 1  # increment counter
    divu s3, s3, s5
    j loop_push
exit_push:

loop_pop:
    ble s4, zero, exit_pop
    li a0, STDOUT
    li a7, SYS_WRITE
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
.globl strlen
strlen:  # a0 -> string's base address
	addi sp, sp, -16
	sd s0, 0(sp)
	sd s1, 8(sp)
	
	mv s0, zero  # counter
loop_strlen:
	lbu s1, 0(a0)
	beq s1, zero, exit_strlen
	addi s0, s0, 1  # increment counter
	addi a0, a0, 1
	j loop_strlen
exit_strlen:
	mv a0, s0
	
	ld s0, 0(sp)
	ld s1, 8(sp)
	addi sp, sp, 16
	ret

.text
.globl print_chars
print_chars:
# a0 -> string's base address
# a1 -> number of chars to print on stdout
	addi sp, sp, -24
    sd s0, 0(sp)
    sd s1, 8(sp)
	sd ra, 16(sp)

	mv s0, a0	# s0 -> string's base address
	mv s1, a1	# s1 -> chars num
	li a0, STDOUT
	li a7, SYS_WRITE
	mv a1, s0
	mv a2, s1
	ecall

    ld s0, 0(sp)
    ld s1, 8(sp)
	ld ra, 16(sp)
    addi sp, sp, 24
    ret

.text
.globl print_str
print_str:  # a0 -> string's base address
	addi sp, sp, -24
    sd s0, 0(sp)
    sd s1, 8(sp)
	sd ra, 16(sp)

	mv s0, a0	# s0 -> string's base address
	jal strlen
	mv s1, a0	# s1 -> string's length
	li a0, STDOUT
	li a7, SYS_WRITE
	mv a1, s0
	mv a2, s1
	ecall

    ld s0, 0(sp)
    ld s1, 8(sp)
	ld ra, 16(sp)
    addi sp, sp, 24
    ret

.text
.globl get_chars
get_chars:
# a0 -> buf (where to store data)
# a1 -> len (how many chars read from stdin)
	addi sp, sp, -16
	sd s0, 0(sp)
	sd s1, 8(sp)

	mv s0, a0
	mv s1, a1
	li a0, STDIN
	li a7, SYS_READ
	mv a1, s0
	mv a2, s1
	ecall

	ld s0, 0(sp)
	ld s1, 8(sp)
	addi sp, sp, 16
	ret

.text
.globl get_str
get_str:  # Read characters from stdin until "\n" is entered or the max number of characters is hit
# a0 -> buf (where to store data)
# a1 -> max char number
	.section .rodata
	__newl:	.byte	'\n'
	.section .text
	addi sp, sp, -48
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	sd s3, 24(sp)
	sd s4, 32(sp)
	sd ra, 40(sp)

	mv s0, a0
	mv s1, a1
	addi s1, s1, -1  # keep space for terminator
	li a0, STDIN
	li a7, SYS_READ
	mv a1, s0
	mv s2, zero  # counter
	la s3, __newl
	lbu s3, 0(s3)
loop_get_str:
	mv a0, s0
	li a1, 1
	jal get_chars
	bge s2, s1, exit_get_str	# while (just_read_char != '\n' && counter < max_char_num)
	lbu s4, 0(s0)
	beq s3, s4, exit_get_str
	addi s2, s2, 1
	addi s0, s0, 1
	j loop_get_str
exit_get_str:
	sb zero, 0(s0)
	mv a0, s2
	
	ld s0, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	ld s3, 24(sp)
	ld s4, 32(sp)
	ld ra, 40(sp)
	addi sp, sp, 48
	ret

.text
.globl str_to_int
str_to_int:
# a0 -> '\0' terminated string
# return -> int represented by the string in a0
	addi sp, sp, -56
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	sd s3, 24(sp)
	sd s4, 32(sp)
	sd s5, 40(sp)
	sd ra, 48(sp)

	mv s4, a0	# s4 -> string base pointer
	jal strlen
	mv s0, a0	# s0 -> string length
	li s1, 1	# s1 -> weight of the current digit (positional system, base 10)
	mv s2, zero	# s2 -> iteration counter
	mv s3, zero	# s3 -> accumulator; keeps the result
loop_str_to_int:
	bge s2, s0, exit_str_to_int
	lbu s5, 0(s4)
	addi s5, s5, -48	# from char to digit
	mul s5, s1, s5	# multiply each digit for its weight
	add s3, s3, s5
	addi s4, s4, 1
	addi s2, s2, 1
	li s5, 10
	mul s1, s1, s5	# use s5 to store 10
	j loop_str_to_int
exit_str_to_int:
	mv a0, s3
	
	ld s0, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	ld s3, 24(sp)
	ld s4, 32(sp)
	ld s5, 40(sp)
	ld ra, 48(sp)
	addi sp, sp, 56
	ret
