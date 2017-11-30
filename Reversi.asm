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
	
	#input: Get the validated user input for their move position this turn
	jal getUserInput
	move $t7, $v0
	
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