.section .rodata
fmt: .string "%d"
fmt_sp: .string "%d "

.section .text
.globl main

main:
    addi sp, sp, -48
    sw ra, 44(sp)
    sw s0, 40(sp)
    sw s1, 36(sp)
    sw s2, 32(sp)
    sw s3, 28(sp)
    sw s4, 24(sp)
    sw s5, 20(sp)

    mv s5, a1
    addi s0, a0, -1         # s0 = count (argc - 1)
    
    slli a0, s0, 2
    call malloc
    mv s1, a0               # s1 = input array
    
    slli a0, s0, 2
    call malloc
    mv s2, a0               # s2 = result array
    
    slli a0, s0, 2
    call malloc
    mv s3, a0               # s3 = stack (indices)
    
    li s4, -1               # s4 = stack top index
    li t0, 0                # t0 = loop counter

array_insert:
    bge t0, s0, array_done
    addi t1, t0, 1
    slli t1, t1, 3          # 8-byte pointer offset
    add t1, s5, t1
    ld a0, 0(t1)            # load argv[i+1]
    
    sw t0, 8(sp)
    call atoi
    lw t0, 8(sp)
    
    slli t1, t0, 2
    add t1, s1, t1
    sw a0, 0(t1)            # store in input array
    addi t0, t0, 1
    j array_insert

array_done:
    li t0, 0                # reset counter

nge_loop:
    bge t0, s0, finalize_stack
    slli t1, t0, 2
    add t1, s1, t1
    lw t2, 0(t1)            # t2 = current_val

while_stack:
    li t3, -1
    beq s4, t3, push_index
    
    slli t1, s4, 2
    add t1, s3, t1
    lw t4, 0(t1)            # t4 = stack top index
    
    slli t1, t4, 2
    add t1, s1, t1
    lw t5, 0(t1)            # t5 = val_at_top
    
    ble t2, t5, push_index
    
    slli t1, t4, 2
    add t1, s2, t1
    sw t0, 0(t1)            # set NGE index in s2
    addi s4, s4, -1         # pop
    j while_stack

push_index:
    addi s4, s4, 1
    slli t1, s4, 2
    add t1, s3, t1
    sw t0, 0(t1)            # push current index
    addi t0, t0, 1
    j nge_loop

finalize_stack:
    li t3, -1
    beq s4, t3, print_array
    slli t1, s4, 2
    add t1, s3, t1
    lw t4, 0(t1)
    slli t1, t4, 2
    add t1, s2, t1
    li t5, -1
    sw t5, 0(t1)            # no NGE found
    addi s4, s4, -1
    j finalize_stack

print_array:
    li t0, 0
print_loop:
    bge t0, s0, exit
    slli t1, t0, 2
    add t1, s2, t1
    lw a1, 0(t1)
    la a0, fmt_sp
    call printf
    addi t0, t0, 1
    j print_loop

exit:
    lw ra, 44(sp)
    lw s0, 40(sp)
    lw s1, 36(sp)
    lw s2, 32(sp)
    lw s3, 28(sp)
    lw s4, 24(sp)
    lw s5, 20(sp)
    addi sp, sp, 48
    li a0, 0
    ret
