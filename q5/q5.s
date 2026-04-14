.section .rodata
fname:      .string "input.txt"
read_mode:  .string "r"
yes_msg:    .string "Yes\n"
no_msg:     .string "No\n"

.section .text
.globl main
main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)
    sd s7, 8(sp)

    la a0, fname
    la a1, read_mode
    call fopen
    mv s0, a0

    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    mv a0, s0
    call ftell
    mv s1, a0

    li s2, 0
    addi s3, s1, -1

    mv a0, s0
    mv a1, s3
    li a2, 0
    call fseek
    mv a0, s0
    call fgetc
    mv s6, a0
    li t0, 10
    bne s6, t0, pal_loop
    addi s3, s3, -1

pal_loop:
    bge s2, s3, is_pal

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek
    mv a0, s0
    call fgetc
    mv s4, a0

    mv a0, s0
    mv a1, s3
    li a2, 0
    call fseek
    mv a0, s0
    call fgetc
    mv s5, a0

    bne s4, s5, not_pal
    addi s2, s2, 1
    addi s3, s3, -1
    j pal_loop

is_pal:
    la a0, yes_msg
    call printf
    j cleanup

not_pal:
    la a0, no_msg
    call printf

cleanup:
    mv a0, s0
    call fclose
    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s6, 16(sp)
    ld s7, 8(sp)
    addi sp, sp, 80
    li a0, 0
    ret
