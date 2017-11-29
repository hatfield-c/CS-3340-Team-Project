# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:
	li $a0, 88
	li $a1, 1
	li $a2, 1
	jal writeBoardPosition
	
	li $a1, 1
	li $a2, 1
	jal readBoardPosition
	move $s0, $v0

	jal displayGameboard
	
	#method: End the application
	li $v0, 10
	syscall
