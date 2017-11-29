.data
	boardData:		.space		256
	boardSize:		.word 		256
	boardElements:		.word		64
	boardWidth:		.word		8
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0
	firstRow: 		.asciiz "   A  B  C  D  E  F  G  H"
	leftBracket: 		.asciiz "["
	rightBracket: 		.asciiz "]"
	space: 			.asciiz " "
	newLine: 		.asciiz "\n"
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
	
.globl displayGameboard
displayGameboard:
	
	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
	#set row and colomn at 0,0
	add $t0,$zero,$zero
	add $t1,$zero,$zero
	
	#clear s1 s2 register in case not empty
	add $s1,$zero,$zero
	add $s2,$zero,$zero
	
	#display row one
	la $a0,firstRow
	li $v0,4
	syscall
	
	#disply row two to row nine
	displayRows:
	#start new line
	la $a0,newLine
	li $v0,4
	syscall
		
	#display row number
	addi $s1, $s1, 1
	move $a0,$s1
	li $v0,1
	syscall
	
	#add space after row number
	la $a0,space
	li $v0,4
	syscall

	displayEachElement:
	
	#element counter
	addi $s2, $s2, 1
	
	#left bracket
	la $a0,leftBracket
	li $v0,4
	syscall
	
	#calling and display the element in the array
	#s3 is the total number of X
	#s4 is the total number of O
	# jal getElement
	bne $v0, 88, notX #check if it's X
	addi $s3, $s3, 1 #register $s3 count number of "X"
	
	notX:
	
	bne $v0, 79, notO #check if it's O
	addi $s4, $s4, 1 #register $s4 count number of "0"
	
	notO:
	
	li $v0, 32 #all space, testing purpose. try 88 for "X", 79 for "O"
	move $a0, $v0
	li $v0,11
	syscall
	
	#update to next element position
	addi $t0, $t0, 1
	bne $t0, 9, notNewRow
	addi $t1, $t1, 1
	add $t0, $zero, $zero
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
	
	#method: Load the registers from the stack
	jal loadAllRegisters
	
	#method: Return to callee
	jr $ra 
