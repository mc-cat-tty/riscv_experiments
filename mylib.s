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
