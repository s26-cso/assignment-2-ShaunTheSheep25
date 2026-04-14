.section .rodata
fmt: .string "%d"
fmt_sp: .string "%d "
fmt_newline: .string "%d\n"

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
    mv s5, a1               # s5 = argv
    addi s0, a0, -1         # s0 = count (argc - 1)
    slli a0, s0, 2
    call malloc
    mv s1, a0               # s1 = input array
    slli a0, s0, 2
    call malloc
    mv s2, a0               # s2 = result array (initialized to -1)
    slli a0, s0, 2
    call malloc
    mv s3, a0               # s3 = stack (indices)
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
    li s4, -1               # s4 = stack top index
    li t0, 0                # t0 = loop counter

array_insert:
    bge t0, s0, array_done
    addi t1, t0, 1
    slli t1, t1, 3          # 8-byte pointer offset for argv
    add t1, s5, t1
    ld a0, 0(t1)            # load argv[i+1]
    call atoi
    slli t1, t0, 2
    add t1, s1, t1
    sw a0, 0(t1)            # store in input array
    addi t0, t0, 1
    j array_insert

array_done:
    li t0, 0                # reset counter for NGE logic

nge_loop:
    bge t0, s0, print_prep
    slli t1, t0, 2
    add t1, s1, t1
    lw t2, 0(t1)            # t2 = current_val

while_stack:
    li t3, -1
    beq s4, t3, push_index  # if stack empty, push
    slli t1, s4, 2
    add t1, s3, t1
    lw t4, 0(t1)            # t4 = stack top index
    slli t1, t4, 2
    add t1, s1, t1
    lw t5, 0(t1)            # t5 = val_at_top
    ble t2, t5, push_index  # if current <= top, push
    slli t1, t4, 2
    add t1, s2, t1
    sw t2, 0(t1)            # update result[t4] with current_val
    addi s4, s4, -1         # pop
    j while_stack

push_index:
    addi s4, s4, 1
    slli t1, s4, 2
    add t1, s3, t1
    sw t0, 0(t1)
    addi t0, t0, 1
    j nge_loop

print_prep:
    li t0, 0                # reset counter for printing
    addi s6, s0, -1         # s6 = last index (count - 1)

print_loop:
    bge t0, s0, exit_program
    slli t1, t0, 2
    add t1, s2, t1
    lw a1, 0(t1)            # load result[i]
    beq t0, s6, last_item   # check if current index is the last one
    la a0, fmt_sp           # "%d "
    call printf
    j print_next

last_item:
    la a0, fmt_newline      # "%d\n"
    call printf

print_next:
    addi t0, t0, 1
    j print_loop

exit_program:
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
