.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0
	
	xMovesList:		.space		256
	oMovesList:		.space		256

.text
.global readBoardPosition
readBoardPosition:
# $v0 : The word stored at the element
	# $a0 : Row of board
	# $a1 : Column of board
	# $v0 : Value at the position of the board

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
	jal getElement
	move $t2, $v0
	
	#method: Read the element from the position
	lw $v0, 0($t2)
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 
	
.globl writeBoardPosition
writeBoardPosition:

.globl readElement
readElement:
	# $v0 : The word stored at the element
	# $a0 : Row of board
	# $a1 : Column of board
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
	# $a1 : Row of board
	# $a2 : Column of board
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

.globl getElement
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

.globl compileValidMoves
compileValidMoves:

	# $a0 : Ascii code of player to check

	jr $ra
