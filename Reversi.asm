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
	
	la $a0,prompt   #print input message for command
	li $v0,4
	syscall
	
	li $v0 ,8   
	syscall
		
	move $a1, $v0
	la $a2, del
	jal promptTitle
	
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
	prompt:	.asciiz		"\nPlease enter a title :"
	tit:	.asciiz		"Title"
	subt:	.asciiz		"Subtitle"
	err:	.asciiz		"Error"
	noti:	.asciiz		"Notice"
	del:	.asciiz		"-"
	sta:	.asciiz		"*"
	eqs:	.asciiz		"="
