.data
instructions_msg: .asciz "Enter a positive integer to calculate the n-th Fibonacci number.\nOnly integers are accepted.\nNegative numbers or non-integers will be rejected.\nIf the result exceeds 32 bits, an overflow message will be shown.\n"
prompt: .asciz "Int Number= "
overflow_msg: .asciz "overflow: result exceeds 32-bit\n"
input_buf: .space 32
invalid_msg: .asciz "invalid input: only integers allowed\n"
.text
.globl main
main:
        # Show instructions before prompt
        la a0, instructions_msg
        li a7, 4
        ecall
    la a0, prompt
    li a7, 4
    ecall

    # Read line into buffer and parse as integer (validate chars)
    la a0, input_buf
    li a1, 32
    li a7, 8         # read_string (RARS syscall)
    ecall

    la t0, input_buf  # t0 = pointer to buffer
    li t1, 0          # t1 = result
    li t2, 0          # t2 = any_digit flag
    li t3, 1          # t3 = sign (1 or -1)
    lb t4, 0(t0)      # t4 = *ptr
    # Skip leading whitespace
skip_spaces_iter:
    li t5, 32
    beq t4, t5, skip_space_next_iter
    li t5, 9
    beq t4, t5, skip_space_next_iter
    li t5, 10
    beq t4, t5, skip_space_next_iter
    li t5, 13
    beq t4, t5, skip_space_next_iter
    j parse_start_iter
skip_space_next_iter:
    addi t0, t0, 1
    lb t4, 0(t0)
    j skip_spaces_iter

parse_start_iter:
    # Optional sign
    li t5, 45         # '-'
    beq t4, t5, set_neg_iter
    li t5, 43         # '+'
    beq t4, t5, skip_sign_iter
    j parse_digits_iter
set_neg_iter:
    li t3, -1
    addi t0, t0, 1
    lb t4, 0(t0)
    j parse_digits_iter
skip_sign_iter:
    addi t0, t0, 1
    lb t4, 0(t0)

parse_digits_iter:
    # Loop over characters
    li t5, 0
parse_loop_iter:
    beq t4, t5, parse_done_iter   # null terminator
    li t6, 10
    beq t4, t6, parse_done_iter   # newline
    li t6, 13
    beq t4, t6, parse_done_iter
    # Check digit: if t4 < '0' or t4 > '9' -> invalid
    li t6, 48
    blt t4, t6, invalid_input_iter
    li t6, 57
    bgt t4, t6, invalid_input_iter
    # Digit: result = result*10 + (t4 - '0')
    li t6, 48
    addi t5, t4, -48    # t5 = digit value
    slli t6, t1, 3      # t6 = t1 * 8
    slli t1, t1, 1      # t1 = t1 * 2
    add t1, t1, t6      # t1 = t1*10
    add t1, t1, t5      # t1 += digit
    li t2, 1            # any_digit = 1
    addi t0, t0, 1
    lb t4, 0(t0)
    j parse_loop_iter

invalid_input_iter:
    la a0, invalid_msg
    li a7, 4
    ecall
    j fib_exit

parse_done_iter:
    beqz t2, invalid_input_iter
    # Apply sign if negative
    li t5, -1
    beq t3, t5, make_negative_iter
    j parse_finish_iter
make_negative_iter:
    sub t1, x0, t1
parse_finish_iter:
    mv t0, t1          # n in t0

    li t1, 0        # a = 0
    li t2, 1        # b = 1
    li t6, 2147483647  # MAX signed 32-bit for overflow detection
    beqz t0, fib_print_zero

    li t3, 1        # i = 1
loop_check:
    slt t4, t3, t0  # t4 = (i < n)
    beqz t4, fib_print_result
    # Overflow check: if t1 > MAX - t2 then adding will overflow signed 32-bit
    sub t5, t6, t2   # t5 = MAX - t2  (use t5 as temp)
    slt t4, t5, t1   # t4 = (t5 < t1) ? 1 : 0  => overflow if 1
    bnez t4, fib_overflow
    add t5, t1, t2
    mv t1, t2
    mv t2, t5
    addi t3, t3, 1
    j loop_check

fib_print_zero:
    li a0, 0
    li a7, 1
    ecall
    j fib_exit

fib_print_result:
    mv a0, t2
    li a7, 1
    ecall

fib_exit:
    li a7, 10
    ecall

fib_overflow:
    la a0, overflow_msg
    li a7, 4
    ecall
    j fib_exit
