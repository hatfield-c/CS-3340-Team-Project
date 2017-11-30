# This file contains the functionality
# of the title screen of the Reversi
# game application

.text
.globl getMainMenu
getMainMenu:

	#method: Save the return address
	move $a0, $ra
	jal saveReturnAdd

	#output: Print the main title screen
	la $a0, str_MainTitle
	li $v0, 4
	syscall
	
	#output: Print the user prompt
	la $a0, str_mainPrompt
	la $a1, str_mainSubtitle
	jal renderPrompt
	
	get_menu_choice:
	#input: Get the users choise
	li $v0, 5
	syscall
	sw $v0, int_buffer
	
	#method: validate the input
	move $a0, $v0
	li $a1, 1
	li $a2, 2
	jal checkIntRange
	
	#condition: If the input is invalid, ask again
	bnez $v0, valid_menu_choice
		la $a0, str_mainSubtitle
		jal renderError
		j get_menu_choice
	valid_menu_choice:
	
	#method: Return the user input
	lw $v0, int_buffer
	
	#method: Reload the return address
	jal loadReturnAdd
	jr $ra

.data
	
	str_MainTitle:		.asciiz 	"------------------------\n|**********************|\n|******           *****|\n|******  Reversi  *****|\n|******           *****|\n|**********************|\n|                      |\n|  A Game Of Strategy  |\n| By The Forsaken Four |\n|                      |\n------------------------\n"
	str_mainPrompt:		.asciiz		"MAIN MENU"
	str_mainSubtitle:	.asciiz		"Welcome! Please choose from the following options.\n1. Play 'Reversi'\n2. Exit the application\n\n[INPUT]: "
	int_buffer:		.word		0
