.section .text

.globl make_node
make_node:
    # Stack must be 16-byte aligned. Saving ra and s0 (8 bytes each).
    addi sp, sp, -16
    sd ra, 8(sp)       
    sd s0, 0(sp)
    
    mv s0, a0               # Store the value to be put in node
    li a0, 24               # Allocation: 4(val) + 4(padding) + 8(left) + 8(right)
    call malloc
    
    sw s0, 0(a0)            # Store 4-byte int val
    sd x0, 8(a0)            # Set 8-byte left pointer to NULL
    sd x0, 16(a0)           # Set 8-byte right pointer to NULL
    
    ld ra, 8(sp)       
    ld s0, 0(sp)
    addi sp, sp, 16
    ret

.globl insert
insert:
    # Using 32 bytes to maintain 16-byte alignment while saving 3 registers
    addi sp, sp, -32
    sd ra, 24(sp)       
    sd s0, 16(sp)
    sd s1, 8(sp)
    
    mv s0, a0               # s0 = current root pointer
    mv s1, a1               # s1 = value to insert
    
    # If root is NULL, create a new node
    beqz s0, insert_null

    lw t0, 0(s0)            # Load current node's value
    beq t0, s1, insert_done # Value already exists
    blt s1, t0, insert_left
    j insert_right

insert_left:
    ld a0, 8(s0)            # Load 8-byte left child pointer
    mv a1, s1
    call insert
    sd a0, 8(s0)            # Update left child pointer with result
    j insert_done

insert_right:
    ld a0, 16(s0)           # Load 8-byte right child pointer
    mv a1, s1
    call insert
    sd a0, 16(s0)           # Update right child pointer with result
    j insert_done

insert_null:
    mv a0, s1
    call make_node          # Returns new node pointer in a0
    j insert_restore

insert_done:
    mv a0, s0               # Return the (possibly updated) root pointer

insert_restore:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

.globl getAtMost
getAtMost:
    addi sp, sp, -32
    sd ra, 24(sp)       
    sd s0, 16(sp)           # s0 = target value
    sd s1, 8(sp)            # s1 = current node pointer
    sd s2, 0(sp)            # s2 = best candidate found so far
    
    mv s0, a0               
    mv s1, a1               
    li s2, -1               # Initialize result to -1

pred_loop:
    beqz s1, pred_finish    # If node is NULL, we are done
    
    lw t0, 0(s1)            # t0 = current node value
    beq t0, s0, pred_exact  # Exact match found
    blt s0, t0, pred_go_left # Target < current: must go left

pred_go_right:
    # Target > current: current is a candidate, then try to find a better one on the right
    mv s2, t0               
    ld s1, 16(s1)           # Move to right child
    j pred_loop

pred_go_left:
    # Target < current: current is too big, must go left
    ld s1, 8(s1)            # Move to left child
    j pred_loop

pred_exact:
    mv a0, s0               # Return the exact match
    j pred_exit

pred_finish:
    mv a0, s2               # Return the best candidate found

pred_exit:
    ld ra, 24(sp)       
    ld s0, 16(sp)
    ld s1, 8(sp)
    ld s2, 0(sp)
    addi sp, sp, 32
    ret
