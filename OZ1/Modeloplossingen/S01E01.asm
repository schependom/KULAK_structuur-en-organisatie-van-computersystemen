# SESSION 01 - EXCERCISE 01

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	a:	.word	10
	b:	.word	-1

# The text section is used for the code of your program.
.text
main:
	# Swap a and b, both kept in memory
	lw		t0, a		# load in t0 what is in memory at address a
	lw		t1, b		# load in t1 what is in memory at address b
	sw		t0, b, t6	# store t0 in memory at address b (using t6 as auxiliary register) 
	sw		t1, a, t6	# store t1 in memory at address a (using t6 as auxiliary register) 

	# alternative stores with base instructions:

	la		t3, a		# address of a in t3
	sw		t0, 0(t3)	# store at address 0+t3
	la		t3, b		# address of b in t3
	sw		t1, 0(t3)	# store at address 0+t3
	
	
	# exit program with exit code 0 (= success)
	li    	a7, 10		# put the ecall type (10: exit with code 0) in a7
	ecall				# environment call: stops execution of this program
