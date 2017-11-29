# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:
	li $a0, 5
	li $a1, 1
	li $a2, 1
	jal writeBoardPosition

	jal displayGameboard
	
	#method: End the application
	li $v0, 10
	syscall
