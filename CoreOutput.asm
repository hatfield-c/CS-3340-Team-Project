# This file contains the core
# output manipulation & formatting
# subroutines utilized in the
# Reversi application

.data
	str_newLine:    .asciiz     	"\n"
	str_whitespace:	.asciiz		" "
	delimWidth:	.word		10
	ptr_title:	.word		0
	ptr_delimiter:	.word		0
	ptr_subtitle:	.word		0

.text
.globl renderTitle
renderTitle:
    	#method: Move arguments into saved registers
    	# $a0 : title address
    	# $a1 : subtitle address
    	# $a2 : delimiter address
	sw $a0, ptr_title
	sw $a1, ptr_subtitle
	sw $a2, ptr_delimiter
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	lw $s0, ptr_title
    	lw $s1, ptr_subtitle
    	lw $s2, ptr_delimiter
    	
    	#method: Move the delimiter into $a0 and call printDelimiter
    	move $a0, $s2
    	jal printDelimiter
    
    	#output: Print the str_whitespace between delimiter and title
	la $a0, str_whitespace
	li $v0, 4
	syscall
	
	#output: Print the title
	move $a0, $s0
	li $v0, 4
	syscall
	
	#output: Print the str_whitespace between delimiter and title
	la $a0, str_whitespace
	li $v0, 4
	syscall
	
	#method: Move the delimiter into $a0 and call printDelimiter
	move $a0, $s2
	jal printDelimiter
	
	#output: Print newline
	la $a0, str_newLine
	li $v0, 4
	syscall
	
	#output: Print subtitle
	move $a0, $s1
	li $v0, 4
	syscall
	
	#method: Load registers from the stack
	jal loadAllRegisters
    
    	jr $ra
    
# Print the delimieter stored in $a0 10 times 
printDelimiter:
	# $t0 : total times to print
	# $t1 : loop counter
	# $v0 : syscall to print string
	lw $t0, delimWidth
	li $t1, 0
	li $v0, 4
	
	print_delim:
	#condition: if done printing, exit loop
	beq $t0, $t1, print_delim_complete
	
		#output: Print the delimiter
		syscall
	
		#method: add 1 to the counter
		addi $t1, $t1, 1
	
		j print_delim
	print_delim_complete:

	jr $ra

.globl clearScreen
#method: Display 40 new lines before each launch to clear the screen
clearScreen:
	#method: Print the newline character
    	la $a0, str_newLine
	li $v0, 4
	syscall
	
	#conditon: If 40 newlines haven't been printed yet, continue looping.
	addi $a3, $a3, 1
	bne $a3, 40, clearScreen
	
	jr $ra
    	
