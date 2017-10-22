# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text 
.globl main
main:

	#output: Display the title screen of the Reversi game
	jal renderTitleScreen
	
	#output: Test code for displaying a title on the command line
	la $a0, tit
	la $a1, subt
	la $a2, del
	jal renderTitle
	
	#method: End the application
	li $v0, 10
	syscall
	
.data
	tit:	.asciiz		"Title"
	subt:	.asciiz		"Subtitle"
	del:	.asciiz		"-"