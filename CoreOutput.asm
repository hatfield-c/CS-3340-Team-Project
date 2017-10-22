.data
	str_newLine:    	.asciiz     	"\n"
	str_whitespace:	.asciiz		" "
	delimWidth:	.word		10

.text
.globl renderTitle
renderTitle:
    	#method: Move arguments into saved registers
    	# $s0 : title address
    	# $s1 : subtitle address
    	# $s2 : delimiter address
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
    
    	#method: Save registers to the stack
    	move $a0, $ra
    	jal saveAllRegisters
    
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