# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text main:

	#output: Display the title screen of the Reversi game
	jal title_screen
	
	#method: End the application
	li $v0, 10
	syscall