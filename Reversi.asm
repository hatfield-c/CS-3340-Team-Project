# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:

	li $a0, 5
	li $a1, 0
	li $a2, 0
	jal writeBoardPosition
	
	li $a0, 0
	li $a1, 0
	jal readBoardPosition
	move $s1, $v0
	
	li $a0, 6
	li $a1, 7
	li $a2, 7
	jal writeBoardPosition
	
	li $a0, 7
	li $a1, 7
	jal readBoardPosition
	move $s2, $v0
	
	#method: End the application
	li $v0, 10
	syscall
