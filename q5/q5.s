.section .rodata
fname:      .string "input.txt"
read_mode:  .string "r"
yes_msg:    .string "Yes\n"
no_msg:     .string "No\n"

.section .text
.globl main
main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
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
    li s2, 0                # left pointer
    addi s3, s1, -1         # initial right pointer
    mv a0, s0
    mv a1, s3
    li a2, 0
    call fseek
    mv a0, s0
    call fgetc
    li t0, 10               # '\n'
    bne a0, t0, pal_loop
    addi s3, s3, -1         # skip newline if present

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
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    addi sp, sp, 48
    li a0, 0
    ret

