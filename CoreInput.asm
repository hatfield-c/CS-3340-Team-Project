.data
	ptr_a0:				.word		0
	str_getUserInputTitle:		.asciiz		"YOUR MOVE"
	str_getUserInputSubtitle:	.asciiz		"Please choose where you would like to place your piece.\nYou can enter your choice in any order, but it must be capitalized.\n(Example: A3 or 2B)\n\n[INPUT]: "
	str_playAgainTitle:		.asciiz		"PLAY AGAIN?"
	str_playAgainSubtitle:		.asciiz		"Would you like to play again?\n1. Return to main menu\n2. Exit application\n\n[INPUT]: "
	str_userInput:			.asciiz		""
	str_newLine:    		.asciiz     	"\n"
	str_buffer:			.asciiz		"        "
	int_buffer:			.word		0

.text
.globl checkIntRange
checkIntRange:
	#$a0 : Word
	#$a1 : Lower Value
	#$a2 : Upper Value
	#$v0 : Result
	li $v0, 0
	
	#checks if $a0 >= $a1
	blt $a0, $a1, range_check_complete
	
	#checks if $a0 <= $a2
	bgt $a0, $a2, range_check_complete
	
	#sets $v0 to one if both tests pass
	li $v0, 1
	
	range_check_complete:
	jr $ra
	
.globl isInteger
isInteger:
	#$a0 : ascii code to test
	#method: Move $a0 into pointer to preserve it
	sw $a0, ptr_a0
	
	#method: Save return address to the stack
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Check if the ascii value in $a0 is within the the acsii values of 1 and 8 (49 and 56)
	lw $a0, ptr_a0
	li $a1, 49
	li $a2, 56
	jal checkIntRange
	
	#method: Reload the return address, and return to caller
	jal loadReturnAdd
	jr $ra

.globl isChar
isChar:
	#$a0 : ascii code to test
	#method: Move $a0 into pointer to preserve it
	sw $a0, ptr_a0
	
	#method: Save return address to the stack
	move $a0, $ra
	jal saveReturnAdd
	
	#method: Check if the ascii value in $a0 is within the the acsii values of A and H (65 and 72)
	lw $a0, ptr_a0
	li $a1, 65
	li $a2, 72
	jal checkIntRange
	
	#method: Reload the return address, and return to caller
	jal loadReturnAdd
	jr $ra

.globl getUserInput
getUserInput:
	#method: save registers to the stack
	move $a0, $ra
	jal saveAllRegisters
	
	# $s0 : First character
	# $s1 : Second character
	# $s2 : If the move is valid
	# $s3 : Validated user input
	
	#output: Print the input prompt
	la $a0, str_getUserInputTitle
	la $a1, str_getUserInputSubtitle
	jal renderPrompt
	
	begin_validation:
	
		#input: Get the user input
		la $a0, str_userInput
		li $a1, 3
		li $v0, 8
		syscall
		
		#input: Read the newline character
		la $a0, str_buffer
		li $a1, 0
		li $v0, 8
		syscall
	
		#method: Get the characters from the input string
		la $t1, str_userInput
		lb $s0, 0($t1)
		lb $s1, 1($t1)
		li $s2, 0
	
		#condition: Check if the first character is an integer
		move $a0, $s0
		jal isInteger
		beq $v0, 1, first_is_int
		
		#condition: Check if the first character is a letter
		move $a0, $s0
		jal isChar
		beqz $v0, validation_complete
		
		#condition: Check if the second character is an integer
		move $a0, $s1
		jal isInteger
		beqz $v0, validation_complete
	
		#method: Make the first character the integer, and the second character a letter
		move $t0, $s0
		move $s0, $s1
		move $s1, $t0
		
		#method: Input is validated
		li $s2, 1
		j validation_complete
	
		first_is_int:
		#condition: Check if the second character is a letter
		move $a0, $s1
		jal isChar
		beqz $v0, validation_complete
		
		#method: Input is validated
		li $s2, 1
		j validation_complete
	
	validation_complete:
	
	#condition: If the input isn't valid, redo input
	beq $s2, 1, return_input
	
	#method: Render error if input isn't valid
	la $a0, str_getUserInputSubtitle
	jal renderError
	j begin_validation
	
	return_input:
	
	#method: Set the inputs to be aligned with the rows & columns of a table
	addi $s0, $s0, -49
	addi $s1, $s1, -65
	
	#method: Combine the user input into a single register
	sll $s3, $s0, 4
	add $s3, $s3, $s1
	move $v0, $s3
	
	#method: Reload registers from the stack and return to the caller
	jal loadAllRegisters
	jr $ra
	
.globl playAgain
playAgain:
	move $a0, $ra
	jal saveReturnAdd
	
	#output: Print the user prompt
	la $a0, str_playAgainTitle
	la $a1, str_playAgainSubtitle
	jal renderPrompt
	
	get_replay_choice:
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
	bnez $v0, valid_replay_choice
		la $a0, str_playAgainSubtitle
		jal renderError
		j get_replay_choice
	valid_replay_choice:
	
	#method: Return the user input
	lw $v0, int_buffer
	
	#method: Reload the return address
	jal loadReturnAdd
	jr $ra
	