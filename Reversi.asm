# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:
	#input: Get the users menu choice
	#jal getMainMenu
	#beq $v0, 2, end_application
	
	#method: Begin running the application
	jal runApplication
	
	#method: Check if pplayer wants to play again
	#jal playAgain
	#beq $v0, 2, end_application
	#j main
	end_application:
	#method: End the application
	li $v0, 10
	syscall

runApplication:
	#method: Save the return address
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Place the initial pieces for the game
	jal placeInitialPieces

	begin_turn:
	#output: Render the gameboard
	jal displayGameboard
	
	#input: Get the validated input for the user's move this turn
	jal getUserInput
	
	#method: Extract the row data
	srl $t0, $v0, 4
	
	#method: Extract the column data
	andi $t1, $v0, 0xf
	
	#method: Place the user's piece on the board
	li $a0, 88
	move $a1, $t0
	move $a2, $t1
	jal placePiece
	
	#jal computerTurn
	
	j begin_turn
	
	#method: Load the return address
	jal loadReturnAdd
	jr $ra

placeInitialPieces:
	#method: Save the return address
	move $a0, $ra
	jal saveReturnAdd

	#method: Place the first X
	li $a0, 88
	li $a1, 3
	li $a2, 3
	jal writeBoardPosition
	
	#method: Place the second X
	li $a0, 88
	li $a1, 4
	li $a2, 4
	jal writeBoardPosition
	
	#method: Place the first O
	li $a0, 79
	li $a1, 3
	li $a2, 4
	jal writeBoardPosition
	
	#method: Place the second O
	li $a0, 79
	li $a1, 4
	li $a2, 3
	jal writeBoardPosition
	
	#method: Load the return address
	jal loadReturnAdd
	jr $ra