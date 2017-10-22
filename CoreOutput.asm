
.data
title: .asciiz "title" #hint: $a0  (delete line 2 and line 12 when combine)
subtile: .asciiz "This is testing subtitle"  #hint:$a1 (delete line 3 and line 13 when combine)
delimiter: .asciiz" - " #hint: $a1 (delete line 4 and line 14 when combine)
				   #(delete last sys call line 79 80 when combine)
newline:    .asciiz     "\n"
table_width: .word 20 #set table width
title_too_big: .asciiz "please enter a smaller title or change the table width in CoreOutput.asm line 5"

.text
main:
	li $t1,0
	la $a0,title
	la $a1,subtile
	la $a2,delimiter
	la $a3, ($a0)
    
title_loop:
	lb   $t0,0($a0) #get info chars from register $a0
	beqz $t0,add_delimiter
	addi $a0,$a0,1
	addi $t1,$t1,1
	j     title_loop
	
display_error:
	li $v0, 4
        la $a0, title_too_big
        syscall

add_delimiter:
	lw $t3,table_width
	bgt $t1,$t3, display_error #if tile is greater than table width, display error message
	sub $t3, $t3, $t1
	li $t2, 2
	div $t3, $t2
	mfhi $t4 #remaninder
	mflo $t5 #quotient
	beqz $t4,display_delimiter_left #size of title is odd, both side needs the same amount of delimiter	
	li $v0, 4 #if size of title is even, it will display a delimiter on the left first
        la $a0, ($a2)
        syscall
        
display_delimiter_left:
	addi $t6,$t6,1
	li $v0, 4
        la $a0, ($a2)
        syscall
        bne $t6,$t5,display_delimiter_left
        li $t6, 0
        
display_title:
	li $v0, 4
        la $a0, ($a3)
        syscall
        
display_delimiter_right:
	li $v0, 4
        la $a0, ($a2)
        syscall
        addi $t6,$t6,1
        bne $t6,$t5,display_delimiter_right
        
display_subtitle:
	li $v0, 4
    	la $a0, newline
    	syscall
    
	li $v0, 4
        la $a0, ($a1)
        syscall

	
	li   $v0,10
	syscall
  
