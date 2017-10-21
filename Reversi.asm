# The entrypoint of the Reversi Game
# we will be building for our Computer
# Architecture class

.text main:

	la $a0, str_MainTitle
	li $v0, 4
	syscall
	
exit:

.data
	
	str_MainTitle:		.asciiz 	"------------------------\n|**********************|\n|******           *****|\n|******  Reversi  *****|\n|******           *****|\n|**********************|\n|                      |\n|  A Game Of Strategy  |\n| By The Forsaken Four |\n|                      |\n------------------------\n"