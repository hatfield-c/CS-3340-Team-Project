.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0
	ptr_a4:			.word		0
	numX:			.word		0
	numO:			.word		0
	numberOfX:		.asciiz		"\n\n  X Pieces (You)     : "
	numberOfO:		.asciiz		"\n  O Pieces (Computer): "
	firstRow: 		.asciiz 	"\n   A  B  C  D  E  F  G  H"
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
	
captureDirection:
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
	
	#condition: Check if can capture in this direction
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal canCaptureDirection
	beqz $v0, capture_complete
	
	begin_capture:
	add $s0, $s0, $s2
	add $s1, $s1, $s3
	
	#method: Check the current position for an enemy piece
	move $a0, $s0
	move $a1, $s1
	jal readBoardPosition
	
	#condition: If a capturer's piece is detected, the capture is complete
	beq $v0, $s4, capture_complete
	
	#method: Replace opponent's piece with capturer's piece
	move $a0, $s4
	move $a1, $s0
	move $a2, $s1
	jal writeBoardPosition
	j begin_capture
	
	capture_complete:
	
	#method: Reload all registers, and return to caller
	jal loadAllRegisters
	jr $ra
	
.globl placePiece
placePiece:
	# $a0 : the player piece to place
	# $a1 : the row on the board to place the piece
	# $a2 : the column on the board to place the piece

	#method: Move arguments into memory
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
	
	#method: Save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	#method: Move the arguments out of memory
	lw $s0, ptr_a0
	lw $s1, ptr_a1
	lw $s2, ptr_a2
	
	#method: Write the piece to the gameboard
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal writeBoardPosition
	
	#method: Capture top left
	move $a0, $s1
	move $a1, $s2
	li $a2, -1
	li $a3, -1
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture top center
	move $a0, $s1
	move $a1, $s2
	li $a2, -1
	li $a3, 0
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture top right
	move $a0, $s1
	move $a1, $s2
	li $a2, -1
	li $a3, 1
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture middle left
	move $a0, $s1
	move $a1, $s2
	li $a2, 0
	li $a3, -1
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture middle right
	move $a0, $s1
	move $a1, $s2
	li $a2, 0
	li $a3, 1
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture bottom left
	move $a0, $s1
	move $a1, $s2
	li $a2, 1
	li $a3, -1
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture bottom center
	move $a0, $s1
	move $a1, $s2
	li $a2, 1
	li $a3, 0
	sw $s0, ptr_a4
	jal captureDirection
	
	#method: Capture bottom right
	move $a0, $s1
	move $a1, $s2
	li $a2, 1
	li $a3, 1
	sw $s0, ptr_a4
	jal captureDirection

	#method: Load registers from the stack
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
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# top center
	move $a0, $s0
	move $a1, $s1
	li $a2, -1
	li $a3, 0
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# top right
	move $a0, $s0
	move $a1, $s1
	li $a2, -1
	li $a3, 1
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# middle left
	move $a0, $s0
	move $a1, $s1
	li $a2, 0
	li $a3, -1
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# middle right
	move $a0, $s0
	move $a1, $s1
	li $a2, 0
	li $a3, 1
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom left
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, -1
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom center
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, 0
	sw $s2, ptr_a4
	jal canCaptureDirection
	beq $v0, 1, valid_move
	
	# bottom right
	move $a0, $s0
	move $a1, $s1
	li $a2, 1
	li $a3, 1
	sw $s2, ptr_a4
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
	
	#method: Clear the piece counter numbers
	sw $zero, numX
	sw $zero, numO
	
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
	
	#method: reading the board position
	addi $a0, $s1, -1
	addi $a1, $s2, -1
	jal readBoardPosition
	move $s5, $v0

	#numX is the total number of X
	#numY is the total number of O

	#condition: If the board position is X, then add 1 to numX
	bne $s5, 88, count_X #check if it's X
	lw $s3, numX
	addi $s3, $s3, 1 #register $s3 count number of "X"
	sw $s3, numX
	j finish_print_char
	count_X:
	
	#condition: If the board position is Y, then add 1 to numY
	bne $s5, 79, count_O #check if it's O
	lw $s4, numO
	addi $s4, $s4, 1 #register $s4 count number of "0"
	sw $s4, numO
	j finish_print_char
	count_O:
	
	#method: If the board is empty, then replace the null character with the ascii code for space
	li $s5, 32
	
	#DEBUGGIN
	#method: Check if this space is a valid move
	#addi $a0, $s1, -1
	#addi $a1, $s2, -1
	#li $a2, 88
	#jal isValidMove
	
	#condition: If the space is a valid move, print out a *
	#beqz $v0, finish_print_char
	#li $s5, 42
	finish_print_char:
	
	#output: Print the character at the board position
	move $a0, $s5
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
