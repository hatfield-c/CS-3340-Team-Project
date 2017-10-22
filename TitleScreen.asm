# This file contains the functionality
# of the title screen of the Reversi
# game application

.text
.globl title_screen
title_screen:

	la $a0, str_MainTitle
	li $v0, 4
	syscall
	
	jr $ra

.data
	
	str_MainTitle:		.asciiz 	"------------------------\n|**********************|\n|******           *****|\n|******  Reversi  *****|\n|******           *****|\n|**********************|\n|                      |\n|  A Game Of Strategy  |\n| By The Forsaken Four |\n|                      |\n------------------------\n"
