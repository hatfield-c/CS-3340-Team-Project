# This file contains the core
# memory and data manipulation
# subroutines utilized in the
# Reversi application

# Save the return address and all saved registers to the stack
# Before you call this function, make sure to move the $ra register
# into the $a0 register so that it will be preserved across jal
.globl saveAllRegisters
saveAllRegisters:
	#method: Save al the registers to the stack
	addi $sp, $sp, -36
	sw $a0, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)

	jr $ra

# Load the return address and all saved registers from the stack
.globl loadAllRegisters
loadAllRegisters:
	#method: Move the content of $ra into $t1 so that we can correctly jump back
	move $t1, $ra
	
	#method: Load all the registers from the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36

	#method: Jump back to the address that called this function
	jr $t1

# Save the return address to the stack
# Before you call this function, make sure to move the $ra register
# into the $a0 register so that it will be preserved across jal
.globl saveReturnAdd
saveReturnAdd:
	#method: Save the retuen address to the stack
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	jr $ra

# Load the return address from the stack	
.globl loadReturnAdd
loadReturnAdd:
	#method: Move the content of $ra into $t1 so that we can correctly jump back
	move $t1, $ra
	
	#method: Load the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#method: Jump back to the address that called this function
	jr $t1