# SESSION 01 - EXCERCISE 03

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	a:			.word		0
	prompt:		.string 	"Geef een integer in: "

# The text section is used for the code of your program.
.text
main:

	# read a
	la 		a0, prompt	# put the address of the prompt in a0
	li		a7, 4		# put the ecall type (4: write string) in a7
	ecall				# environment call: writes the string with address in a0 to the standard output
	
	li		a7, 5		# put the ecall type (5: read integer) in a7
	ecall				# environment call: after completion, a7 contains the read integer
	sw		a0, a, t6	# store a in memory
	
	# calculate a^7 as efficiently as possible
	lw		t0, a		# t0 = a
	mul		t1, t0, t0	# t1 = a^2
	mul		t1, t1, t1	# t1 = a^4
	mul		t1, t1, t1	# t1 = a^8
	div		t1, t1, t0	# t1 = a^7
	
	mv 		a0, t1		# put the result in a0
	li		a7, 1		# put the ecall type (1: write integer) in a7
	ecall				# environment call: writes the content of a0 (as integer) to the standard output

	li 		a0, 10		# put the \n character in a0
	li 		a7, 11 		# put the ecall type (11: print character) in a7
	ecall				# environment call: write the character in a0 to the standard ouput


	# calculate a^13 as efficiently as possible (5 multiplications/divisions)
	lw		t0, a		# t0 = a
	mul		t1, t0, t0	# t1 = a^2
	mul		t2, t1, t0	# t2 = a^3
	mul		t1, t2, t1	# t1 = a^5
	mul		t1, t1, t1	# t1 = a^10
	mul		t1, t1, t2	# t1 = a^13
	
	mv 		a0, t1		# put the result in a0
	li		a7, 1		# put the ecall type (1: write integer) in a7
	ecall				# environment call: writes the content of a0 (as integer) to the standard output
	
	
	# exit program with exit code 0 (= success)
	li    	a7, 10	# put the ecall type (10: exit with code 0) in a7
	ecall			# environment call: stops execution of this program