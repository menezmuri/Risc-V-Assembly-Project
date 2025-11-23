.data
prompt: .asciiz "n = "
.text
.global main
main:
    la a0, prompt
    li a7, 4
    ecall

    li a7, 5
    ecall
    mv t0, a0       # n in t0

    li t1, 0        # a = 0
    li t2, 1        # b = 1
    beqz t0, fib_print_zero

    li t3, 1        # i = 1
loop_check:
    slt t4, t3, t0  # t4 = (i < n)
    beqz t4, fib_print_result
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
