.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0

.text
.globl readElement
readElement:
	# $v0 : The word stored at the element
	# $t0 : Row of board
	# $t1 : Column of board
	# $t2 : Address of element

    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $t0, ptr_a0
    	lw $t1, ptr_a1
    	
	#method: Get the address of the element to write to
	move $a0, $t0
	move $a1, $t1
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
	# $t0 : Word to write
	# $t1 : Row of board
	# $t2 : Column of board
	# $t3 : Address of element
	
    	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $s0, ptr_a0
    	lw $s1, ptr_a1
    	lw $s2, ptr_a2
	
	#method: Get the address of the element to write to
	move $a0, $s1
	move $a1, $s2
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
	# $t0 : Row of board
	# $t1 : Column of board
	# $t2 : Width of board
	# $t3 : Offset amount
	# $v0 : Address of element to access
	
	#method: Move the arguments into local variables, and load the width of the board
	move $t0, $a0
	move $t1, $a1
	lw $t2, boardWidth
	
	#method: Offset (integer) = i * Width + j
	mulu $t3, $t0, $t2
	add $t3, $t3, $t1
	
	#method: Offset (bytes) = (offset integer) * 4
	mulu $t3, $t3, 4
	
	#method: Compute the address of the element to access
	la $v0, boardData
	add $v0, $v0, $t3
	
	#method: Return to callee
	jr $ra
