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
    mv a0, a0       # n in a0 for call
    jal ra, fib

    li a7, 1
    ecall

    li a7, 10
    ecall

fib:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    mv s0, a0

    li t0, 0
    beq a0, t0, fib_ret0
    li t1, 1
    beq a0, t1, fib_ret1

    addi a0, s0, -1
    jal ra, fib
    mv t2, a0

    addi a0, s0, -2
    jal ra, fib

    add a0, a0, t2
    j fib_restore

fib_ret0:
    li a0, 0
    j fib_restore

fib_ret1:
    li a0, 1

fib_restore:
    lw ra, 12(sp)
    lw s0, 8(sp)
    addi sp, sp, 16
    ret
