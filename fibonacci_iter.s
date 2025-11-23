.data
prompt: .asciz "n = "
overflow_msg: .asciz "overflow: resultado excede 32-bit\n"
.text
.globl main
main:
    la a0, prompt
    li a7, 4
    ecall

    li a7, 5
    ecall
    mv t0, a0       # n in t0

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
