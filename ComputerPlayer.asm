.data
	directionOffset:	.word		1
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	str_computerTurn:	.asciiz		"\n\n****** CALCULATING COMPUTER'S TURN ******\n\n"
	
.text
.globl computerTurn
computerTurn:
	#method: save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	#output: Print the computer turn message so the user knows the application isn't frozen
	la $a0, str_computerTurn
	li $v0, 4
	syscall
	
	# $s0 : current row
	# $s1 : current column
	# $s2 : direction offset
	# $s3 : beginning offset
	# $s4 : ending offset
	# $s5 : If there is a valid move
	
	#method: Determine direction offset, and calibrate initial values
	li $s0, -1
	li $s1, -1
	li $s3, -1
	li $s4, 7
	li $s5, 0
	lw $t0, directionOffset
	mulu $s2, $t0, 1
	
	#condition: If the offset begins at the end of the board, then initialize beginning values appropriately
	bgtz $t0, offset_calculated
		li $s0, 8
		li $s1, 8
		li $s3, 8
		li $s4, 0
	offset_calculated:
	
	#method: Iterate through gameboard based on offset, and choose the first valid move found. If no move is found, the game is complete
	iterate_row:
		#method: Calculate current row position
		add $s0, $s0, $s2
		iterate_column:
			#method: Calculate current column position
			add $s1, $s1, $s2
			
			#method: Check if the move at that position is legal for the computer
			move $a0, $s0
			move $a1, $s1
			li $a2, 79
			jal isValidMove
			move $s5, $v0
			
			#condition: If the move is valid, exit the loop
			beqz $s5, next_iteration
				#method: Place the computer's piece, and exit the loop
				li $a0, 79
				move $a1, $s0
				move $a2, $s1
				jal placePiece
				j computer_turn_complete
			next_iteration:
			bne $s1, $s4, iterate_column
			
		#method: Update the column value for next iteration
		move $s1, $s3
		bne $s0, $s4, iterate_row
			
	computer_turn_complete:
	
	#method: Update the direction offset for the next turn
	lw $t0, directionOffset
	mulu $t0, $t0, -1
	sw $t0, directionOffset
	
	jal loadAllRegisters
	jr $ra
	
.globl validMovesRemaining
validMovesRemaining:

	#method: save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	# $s0 : current row
	# $s1 : current column
	# $s2 : If there is a valid move
	
	#method: Determine direction offset, and calibrate initial values
	li $s0, -1
	li $s1, -1
	li $s2, 0
	
	#method: Iterate through gameboard based on offset, and exit on the first valid move found. If no move is found, the game is complete
	next_row:
		#method: Calculate current row position
		addi $s0, $s0, 1
		next_column:
			#method: Calculate current column position
			addi $s1, $s1, 1
			
			#method: Check if the move at that position is legal for the user
			move $a0, $s0
			move $a1, $s1
			li $a2, 88
			jal isValidMove
			move $s2, $v0
			
			#condition: If the move is valid, exit the loop
			beqz $s2, next_it_check
				j valid_moves_check_complete
			next_it_check:
			bne $s1, 7, next_column
			
		#method: Update the column value for next iteration
		li $s1, 0
		bne $s0, 7, next_row
			
	valid_moves_check_complete:
	
	#method: Return the result of the check
	move $v0, $s2
	
	jal loadAllRegisters
	jr $ra

