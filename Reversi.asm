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
	
	#output: Test code for displaying a prompt title on the command line
	la $a0, prompt 
	li $v0, 4
	syscall
	

        li $v0,8 #take in input
        la $a0, buffer #load byte space into address
        li $a1, 20 # allot the byte space for string
        move $t0,$a0 #save string to t0
        syscall
        
        #delete the /n from user input
    	li $s0,0        # Set index to 0
remove:
    	lb $a3,buffer($s0)    # Load character at index
    	addi $s0,$s0,1      # Increment index
    	bnez $a3,remove     # Loop until the end of string is reached
    	beq $a1,$s0,skip    # Do not remove \n when string = maxlength
    	subiu $s0,$s0,2     # If above not true, Backtrack index to '\n'
    	sb $0, buffer($s0)    # Add the terminating character in its place
skip:	
        
        #call proptTitle
	move $a0, $t0
	la $a1, subt
	la $a2, del
	la $a3, buffer
	jal promptTitle
	
	la $a0, str_newLine
	li $v0, 4
	syscall
	
	#output: Test code for displaying a error subtitle on the command line
	la $a0, err
	la $a2, sta
	jal errorTitle
	
	#output: Test code for displaying a notice subtitle on the command line
	la $a0, noti
	la $a2, eqs
	jal noticeTitle
	
	#method: End the application
	li $v0, 10
	syscall
	
.data	
	buffer: .space 		20
	prompt:	.asciiz		"\nPlease enter a title :"
	tit:	.asciiz		"Title"
	subt:	.asciiz		"Subtitle"
	err:	.asciiz		"Error"
	noti:	.asciiz		"Notice"
	del:	.asciiz		"-"
	sta:	.asciiz		"*"
	eqs:	.asciiz		"="
	str_newLine:    .asciiz     	"\n"