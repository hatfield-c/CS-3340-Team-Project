# This file contains the core
# output manipulation & formatting
# subroutines utilized in the
# Reversi application

.data
	str_newLine:    	.asciiz     	"\n"
	str_whitespace:		.asciiz		" "
	str_promptDelim:	.asciiz		"-"
	str_errorDelim:		.asciiz		"*"
	str_noticeDelim:	.asciiz		"="
	str_errorTitle:		.asciiz		"ERROR"
	str_noticeTitle:	.asciiz		"NOTICE"
	delimWidth:		.word		10
	ptr_a0:			.word		0
	ptr_a1:			.word		0
	ptr_a2:			.word		0
	ptr_a3:			.word		0

.text
.globl renderTitle
renderTitle:
    	#method: Move arguments into memory
    	# $a0 : title address
    	# $a1 : subtitle address
    	# $a2 : delimiter address
	sw $a0, ptr_a0
	sw $a1, ptr_a1
	sw $a2, ptr_a2
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $s0, ptr_a0
    	lw $s1, ptr_a1
    	lw $s2, ptr_a2
    	
    	#method: Print newline
    	la $a0, str_newLine
    	li $v0, 4
    	syscall
    	
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
    	
.globl renderPrompt
renderPrompt:
    	#method: Move arguments into memory
    	# $a0 : title address
    	# $a1 : subtitle address
    	# $a2 : delimiter address
    	# $a3 : string buffer
	sw $a0, ptr_a0
	sw $a1, ptr_a1
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a0, ptr_a0
    	lw $a1, ptr_a1
    	
    	#method: Set the delimiter to '-'
    	la $a2, str_promptDelim
	
	#output: Print the prompt
	jal renderTitle
	
	#method: Load registers from the stack
	jal loadAllRegisters
    
    	jr $ra
    	

.text
.globl renderError
renderError:
    	#method: Move arguments into memory
    	# $a0 : subtitle address
	sw $a0, ptr_a0
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a1, ptr_a0
	
	#method: Set the title to "ERROR" and the delimiter to "*"
    	la $a0, str_errorTitle
       	la $a2, str_errorDelim
    	
    	#output: Print the error
    	jal renderTitle
		
	#method: Load registers from the stack
	jal loadAllRegisters
    
    	jr $ra
 
.globl renderNotice
renderNotice:
    	#method: Move arguments into memory
    	# $a0 : subtitle address
	sw $a0, ptr_a0
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    	
    	#method: Pull arguments out of memory
    	lw $a1, ptr_a0
    	
    	#method: Set the title to "NOTICE" and the delimiter to "="
	la $a0, str_noticeTitle
	la $a2, str_noticeDelim
	
	#output: Print the error
	jal renderTitle
		
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
    	
