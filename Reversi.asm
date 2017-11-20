# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:
	jal displayGameboard
	#method: End the application
	li $v0, 10
	syscall
