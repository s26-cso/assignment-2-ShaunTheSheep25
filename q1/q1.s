.section .text

.globl make_node
make_node:
    addi sp, sp, -16
    sw ra, 12(sp)       
    sw s0, 8(sp)
    mv s0, a0
    li a0, 24               # size for 64-bit pointers
    call malloc
    sw s0, 0(a0)            # store val
    sd x0, 8(a0)            # left = NULL
    sd x0, 16(a0)           # right = NULL
    lw ra, 12(sp)       
    lw s0, 8(sp)
    addi sp, sp, 16
    ret

.globl insert
insert:
    addi sp, sp, -16
    sw ra, 12(sp)       
    sw s0, 8(sp)
    sw s1, 4(sp)
    mv s0, a0
    mv s1, a1
    beqz s0, insert_null

insert_check:
    lw t0, 0(s0)
    beq t0, s1, insert_done
    blt s1, t0, insert_left
    j insert_right

insert_left:
    ld a0, 8(s0)            # load 8-byte ptr
    mv a1, s1
    call insert
    sd a0, 8(s0)            # store 8-byte ptr
    j insert_done

insert_right:
    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)
    j insert_done

insert_null:
    mv a0, s1
    call make_node
    j insert_restore

insert_done:
    mv a0, s0

insert_restore:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16
    ret

.globl get
get:
    addi sp, sp, -16
    sw ra, 12(sp)       
    sw s0, 8(sp)
    sw s1, 4(sp)
    mv s0, a0
    mv s1, a1

get_check:
    beqz s0, get_null
    lw t0, 0(s0)
    beq t0, s1, get_found
    blt s1, t0, get_left
    j get_right

get_left:
    ld a0, 8(s0)
    mv a1, s1
    call get
    j get_restore

get_right:
    ld a0, 16(s0)
    mv a1, s1
    call get
    j get_restore

get_found:
    mv a0, s0
    j get_restore

get_null:
    li a0, 0

get_restore:
    lw ra, 12(sp)       
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16
    ret

.globl getAtMost
getAtMost:
    addi sp, sp, -24
    sw ra, 20(sp)       
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    mv s0, a0               # target val
    mv s1, a1               # root
    li s2, -1               # default result

pred_check:
    beqz s1, pred_null
    lw t0, 0(s1)
    beq t0, s0, pred_exact
    blt s0, t0, pred_left

pred_right:
    lw t0, 0(s1)
    mv s2, t0               # update candidate
    ld s1, 16(s1)           # move right
    j pred_check

pred_left:
    ld s1, 8(s1)            # move left
    j pred_check

pred_exact:
    lw a0, 0(s1)
    j pred_restore

pred_null:
    mv a0, s2

pred_restore:
    lw ra, 20(sp)       
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    addi sp, sp, 24
    ret
