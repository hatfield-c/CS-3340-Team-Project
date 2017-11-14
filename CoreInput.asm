.data
	#Used asciiz string in order to get the ascii value bits from memory
	Input: .asciiz "A1"
.text
#PRJ-13
	#sets $t0 and $t1 to 0 and 1 in order to retrieve their corresponding bytes from the string
	add $t0, $zero, $zero
	addi $t1, $zero, 1
	j checkCharInt
#PRJ-12
.globl ifBetween
ifBetween:
	#$a0 : Word
	#$a1 : Lower Value
	#$a2 : Upper Value
	#$v0 : Resulting Value
	#checks if $a0 >= $a1
	bge $a0, $a1, Next
	j False
	
	Next:
	#checks if $a0 <= $a2
	ble $a0, $a2, True 
	j False
	
	False:
	#sets $v0 to zero if either test fails
	addi $v0, $zero, 0
	addi $t0, $zero, 1
	add $t1, $zero, $zero
	j checkCharInt
	
	True:
	#sets $v0 to one is both tests pass
	addi $v0, $zero, 1
	jr $ra
	
.globl checkCharInt
checkCharInt:
	#$a0 : Char Value
	#loads first byte of Input string from memory
	lb $a0, Input($t0)
	#ascii values of 1 and 9
	li $a1, 49
	li $a2, 57
	jal ifBetween

#PRJ-14
.globl checkCharLetter
checkCharLetter:
	#$a0 : Char Value
	#Loads the next byte of Input String from memory
	lb $a0, Input($t1)
	#ascii values of A and H
	li $a1, 65
	li $a2, 72
	jal ifBetween
	j end
	
end:
	#end of code