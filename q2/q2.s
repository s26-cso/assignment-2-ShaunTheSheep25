.section .rodata
fmt_sp:      .string "%d "
fmt_newline: .string "%d\n"

.section .text
.globl main

main:
    addi sp, sp, -72
    sd ra, 64(sp)
    sd s0, 56(sp)
    sd s1, 48(sp)
    sd s2, 40(sp)
    sd s3, 32(sp)
    sd s4, 24(sp)
    sd s5, 16(sp)
    sd s6, 8(sp)

    mv s5, a1
    addi s0, a0, -1

    ble s0, zero, exit_program

    slli a0, s0, 2
    call malloc
    mv s1, a0

    slli a0, s0, 2
    call malloc
    mv s2, a0

    slli a0, s0, 3
    call malloc
    mv s3, a0

    li t0, 0
init_res:
    bge t0, s0, array_prep
    slli t1, t0, 2
    add t1, s2, t1
    li t2, -1
    sw t2, 0(t1)
    addi t0, t0, 1
    j init_res

array_prep:
    li s4, -1
    li t0, 0

array_insert:
    bge t0, s0, array_done
    addi t1, t0, 1
    slli t1, t1, 3
    add t1, s5, t1
    ld a0, 0(t1)
    call atoi
    slli t1, t0, 2
    add t1, s1, t1
    sw a0, 0(t1)
    addi t0, t0, 1
    j array_insert

array_done:
    addi t0, s0, -1

nge_loop:
    bltz t0, print_prep
    slli t1, t0, 2
    add t1, s1, t1
    lw t2, 0(t1)

while_stack:
    li t3, -1
    beq s4, t3, after_while
    slli t1, s4, 3
    add t1, s3, t1
    ld t4, 0(t1)
    slli t1, t4, 2
    add t1, s1, t1
    lw t5, 0(t1)
    bgt t5, t2, after_while
    addi s4, s4, -1
    j while_stack

after_while:
    li t3, -1
    beq s4, t3, push_index
    slli t1, s4, 3
    add t1, s3, t1
    ld t4, 0(t1)
    slli t1, t0, 2
    add t1, s2, t1
    sw t4, 0(t1)

push_index:
    addi s4, s4, 1
    slli t1, s4, 3
    add t1, s3, t1
    sd t0, 0(t1)
    addi t0, t0, -1
    j nge_loop

print_prep:
    li s4, 0
    addi s6, s0, -1

print_loop:
    bge s4, s0, exit_program
    slli t1, s4, 2
    add t1, s2, t1
    lw a1, 0(t1)
    beq s4, s6, last_item
    la a0, fmt_sp
    call printf
    addi s4, s4, 1
    j print_loop

last_item:
    la a0, fmt_newline
    call printf

exit_program:
    ld ra, 64(sp)
    ld s0, 56(sp)
    ld s1, 48(sp)
    ld s2, 40(sp)
    ld s3, 32(sp)
    ld s4, 24(sp)
    ld s5, 16(sp)
    ld s6, 8(sp)
    addi sp, sp, 72
    li a0, 0
    ret
