.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0
	numX:			.word		0
	numO:			.word		0
	numberOfX:		.asciiz		"\n\n  X Pieces: "
	numberOfO:		.asciiz		"\n  O Pieces: "
	firstRow: 		.asciiz 	"   A  B  C  D  E  F  G  H"
	leftBracket: 		.asciiz 	"["
	rightBracket: 		.asciiz 	"]"
	space: 			.asciiz 	" "
	newLine: 		.asciiz 	"\n"

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

.globl displayGameboard
displayGameboard:
	
	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
	#set row and colomn at 0,0
	add $s3, $zero,$zero
	add $s4, $zero,$zero
	
	#clear s1 s2 register in case not empty
	add $s1, $zero,$zero
	add $s2, $zero,$zero
	
	#display row one
	la $a0, firstRow
	li $v0, 4
	syscall
	
	#disply row two to row nine
	displayRows:
	#start new line
	la $a0, newLine
	li $v0, 4
	syscall
		
	#display row number
	addi $s1, $s1, 1
	move $a0, $s1
	li $v0, 1
	syscall
	
	#add space after row number
	la $a0, space
	li $v0, 4
	syscall

	displayEachElement:
	
	#element counter
	addi $s2, $s2, 1
	
	#left bracket
	la $a0,leftBracket
	li $v0,4
	syscall
	
	#method: get current position on board (0 centered)
	addi $t0, $s1, -1
	addi $t1, $s2, -1
	
	#method: reading the board position
	move $a0, $t0
	move $a1, $t1
	jal readBoardPosition

	#numX is the total number of X
	#numY is the total number of O

	#condition: If the board position is X, then add 1 to numX
	bne $v0, 88, count_X #check if it's X
	lw $t0, numX
	addi $t0, $t0, 1 #register $s3 count number of "X"
	sw $t0, numX
	count_X:
	
	#condition: If the board position is Y, then add 1 to numY
	bne $v0, 79, count_O #check if it's O
	lw $t0, numO
	addi $s4, $s4, 1 #register $s4 count number of "0"
	lw $t0, numO
	count_O:
	
	#output: Print the character at the board position
	move $a0, $v0
	li $v0,11
	syscall
	
	#update to next element position
	addi $s3, $s3, 1
	bne $s3, 9, notNewRow
	addi $s4, $s4, 1
	add $s3, $zero, $zero
	notNewRow:
	
	#right bracket
	la $a0,rightBracket
	li $v0,4
	syscall
	
	#display 8 elements with brackets
	bne $s2, 8, displayEachElement
	#after displaying 8 elements, clear counter
	add $s2, $zero, $zero
	#go to the next rows
	bne $s1, 8, displayRows
	
	#output: Print the number of X pieces
	la $a0, numberOfX
	li $v0, 4
	syscall
	
	lw $a0, numX
	li $v0, 1
	syscall
	
	#output: Print the number of O pieces
	la $a0, numberOfO
	li $v0, 4
	syscall
	
	lw $a0, numO
	li $v0, 1
	syscall
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 
