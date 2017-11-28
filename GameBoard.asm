.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0
	ptr_a4:			.word 		0
	
.text
.globl readBoardPosition
readBoardPosition:
	# $v0 : The word stored at the position on the board
	# $a0 : Row of board
	# $a1 : Column of board

    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a0, ptr_a0
    	lw $a1, ptr_a1
    	la $a2, boardData
    	
	#method: Get the address of the element to write to
	jal readElement
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 
	
.globl writeBoardPosition
writeBoardPosition:
	# $a0 : Word to write to board
	# $a1 : Row of board
	# $a2 : Column of board

    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a0, ptr_a0
    	lw $a1, ptr_a1
    	lw $a2, ptr_a2
    	la $a3, boardData
    	
	#method: Get the address of the element to write to
	jal writeElement
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 

.globl readElement
readElement:
	# $v0 : The word stored at the element
	# $a0 : Row of table
	# $a1 : Column of table
	# $a2 : Address of table to read from
	# $t2 : Address of element

    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a0, ptr_a0
    	lw $a1, ptr_a1
    	lw $a2, ptr_a2
    	
	#method: Get the address of the element to write to
	jal getElement
	move $t2, $v0
	
	#method: Read the element from the position
	lw $v0, 0($t2)
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 

.globl writeElement
writeElement:
	# $a0 : Word to write
	# $a1 : Row of table
	# $a2 : Column of table
	# $a3 : Address of table to write to
	# $t3 : Address of element
	
    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
	sw $a3, ptr_a3
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $s0, ptr_a0
    	lw $s1, ptr_a1
    	lw $s2, ptr_a2
    	lw $s3, ptr_a3
	
	#method: Get the address of the element to write to
	move $a0, $s1
	move $a1, $s2
	move $a2, $s3
	jal getElement
	move $t3, $v0
	
	#method: Write the element to the position
	sw $s0, 0($t3)
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 

getElement:
	# $a0 : Row of table
	# $a1 : Column of table
	# $a2 : Address of table to access
	# $t2 : Width of board
	# $t3 : Offset amount
	# $v0 : Address of element to access
	
	#method: Move the arguments into local variables, and load the width of the board
	move $t0, $a0
	move $t1, $a1
	move $v0, $a2
	lw $t2, boardWidth
	
	#method: Offset (integer) = i * Width + j
	mulu $t3, $t0, $t2
	add $t3, $t3, $t1
	
	#method: Offset (bytes) = (offset integer) * 4
	mulu $t3, $t3, 4
	
	#method: Compute the address of the element to access
	add $v0, $v0, $t3
	
	#method: Return to callee
	jr $ra
	
isEmpty:
	# $v0 : if the board position is empty
	# $a0 : row of board
	# $a1 : column of board

	#method: Place arguments in memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	
	#method: Save registers to the stack
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Read the ascii code at the board position
	lw $a0, ptr_a0
	lw $a1, ptr_a1
	jal readBoardPosition
	move $t0, $v0
	
	#condition: If the space is empty, return true
	li $v0, 0
	bne $t0, $v0, non_empty
	li $v0, 1
	non_empty:
	
	jal loadReturnAdd
	jr $ra
	
canCaptureDirection:
	# $a0 : initial row
	# $a1 : initial column
	# $a2 : row direction
	# $a3 : column direction
	# $s4 : player piece code
	
	#method: Place arguments in memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
	sw $a3, ptr_a3
	
	#method: Save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	#method: Pull arguments from memory
	lw $s0, ptr_a0
	lw $s1, ptr_a1
	lw $s2, ptr_a2
	lw $s3, ptr_a3
	lw $s4, ptr_a4
	
	# $t4 : current row
	# $t5 : current column
	# $t6 : current board position value
	# $t7 : is a valid direction
	move $t4, $s0
	move $t5, $s1
	li $t6, 0
	li $t7, 0
	
	#method: Claculate the first position to check
	add $t4, $t4, $s2
	add $t5, $t5, $s3
	
	#condition: If the offset is not within the bounds of the table, then the direction is invalid
	blt $t4, 0, not_valid_direction
	blt $t5, 0, not_valid_direction
	bgt $t4, 7, not_valid_direction
	bgt $t5, 7, not_valid_direction
	
	#method: Get the current space value to check
	move $a0, $t4
	move $a1, $t5
	jal readBoardPosition
	move $t6, $v0
	
	#method: If the first offset position is empty or has the current players piece, then the direction is invalid
	beqz $t6, not_valid_direction
	beq $t6, $s4, not_valid_direction
	
	#method: Check each successive position
	check_next_position:
	
		#method: Claculate the next position to check
		add $t4, $t4, $s2
		add $t5, $t5, $s3
	
		#condition: If the offset is not within the bounds of the table, then the direction is invalid
		blt $t4, 0, not_valid_direction
		blt $t5, 0, not_valid_direction
		bgt $t4, 7, not_valid_direction
		bgt $t5, 7, not_valid_direction
		
		#method: Get the next space value to check
		move $a0, $t4
		move $a1, $t5
		jal readBoardPosition
		move $t6, $v0
		
		#condition: If the next space is empty, exit with false.
		#	    If the next space has an enemy piece, check the next space
		#	    If the next space has friendly piece, the move is valid
		beqz $t6, not_valid_direction
		bne $t6, $s4, check_next_position
		li $t7, 1
	
	not_valid_direction:
	
	#method: Move the final result to the return register
	move $v0, $t7
	
	#method: Reload all registers, and return to caller
	jal loadAllRegisters
	jr $ra

.globl isValidMove
isValidMove:
	# $v0 : If the move is valid
	# $a0 : Row of board
	# $a1 : Column of board
	# $a2 : Player piece code
	# $s3 : Result of check
	
	#method: Place arguments in memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
	
	#method: Save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	#method: Pull arguments from memory
	lw $s0, ptr_a0
	lw $s1, ptr_a1
	lw $s2, ptr_a2
	li $s3, 0
	
	#method: Check if space is empty
	move $a0, $s0
	move $a1, $s1
	jal isEmpty
	beqz $v0, not_valid_move

	#method: Check if this move can capture a piece in any of eight directions
	
	# top left
	move $a0, $s0
	move $a1, $s1
	li $a2, -1
	li $a3, -1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# top center
	move $a0, $s0
	move $a1, $s1
	li $a2, -1
	li $a3, 0
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# top right
	move $a0, $s0
	move $a1, $s1
	li $a2, -1
	li $a3, 1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# middle left
	move $a0, $s0
	move $a1, $s1
	li $a2, 0
	li $a3, -1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# middle right
	move $a0, $s0
	move $a1, $s1
	li $a2, 0
	li $a3, 1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom left
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, -1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom center
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, 0
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom right
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, 1
	li $t0, 5
	sw $t0, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	#condition: If no captures in any direction, move is not valid
	j not_valid_move
	
	#method: If the direction is valid, return true
	valid_move:
	li $s3, 1
		
	not_valid_move:
	move $v0, $s3
	
	#method: Reload all registers, and return to caller
	jal loadAllRegisters
	jr $ra
