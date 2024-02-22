# SESSION 01 - EXCERCISE 02

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	a:	.word	10
	b:	.word	-1

# The text section is used for the code of your program.
.text
main:
	# print a^2 + b^2
	lw		t0, a
	mul		t0, t0, t0		
	lw		t1, b	
	mul		t1, t1, t1	
	add		t0, t0, t1
	
	mv		a0, t0		# put the result in a0
	li		a7, 1		# put the ecall type (1: write integer) in a7
	ecall				# environment call: writes the content of a0 (as integer) to the standard output


	# exit program with exit code 0 (= success)
	li    	a7, 10		# put the ecall type (10: exit with code 0) in a7
	ecall				# environment call: stops execution of this program