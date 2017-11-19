.data
	ptr_a0:		.word		0
.text
.globl checkIntRange
checkIntRange:
	#$a0 : Word
	#$a1 : Lower Value
	#$a2 : Upper Value
	#$v0 : Result
	li $v0, 0
	
	#checks if $a0 >= $a1
	blt $a0, $a1, range_check_complete
	
	#checks if $a0 <= $a2
	bgt $a0, $a2, range_check_complete
	
	#sets $v0 to one if both tests pass
	li $v0, 1
	
	range_check_complete:
	jr $ra
	
.globl isInteger
isInteger:
	#$a0 : ascii code to test
	#method: Move $a0 into pointer to preserve it
	sw $a0, ptr_a0
	
	#method: Save return address to the stack
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Check if the ascii value in $a0 is within the the acsii values of 1 and 9 (49 and 57)
	lw $a0, ptr_a0
	li $a1, 49
	li $a2, 57
	jal checkIntRange
	
	#method: Reload the return address, and return to caller
	jal loadReturnAdd
	jr $ra

.globl isChar
isChar:
	#$a0 : ascii code to test
	#method: Move $a0 into pointer to preserve it
	sw $a0, ptr_a0
	
	#method: Save return address to the stack
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Check if the ascii value in $a0 is within the the acsii values of A and H (65 and 72)
	lw $a0, ptr_a0
	li $a1, 65
	li $a2, 72
	jal checkIntRange
	
	#method: Reload the return address, and return to caller
	jal loadReturnAdd
	jr $ra
