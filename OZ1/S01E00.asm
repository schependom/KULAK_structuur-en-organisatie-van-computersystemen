# SESSION 01 - EXCERCISE 00 - INTRODUCTION

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
# FORMAT:
#	label: .datatype <optional value>
# EXAMPLES:
#	a:	.word 	2	# 1 word holding the value 2
#	b:	.word	-1	# 1 word holing the value -1 (2-complement)
#	c:	.space	4	# generic space of 4 bytes (no value)
#	s:	.string	"An example string with end of line character\n" # a string (automatically ends with a null character)

.data

	s:	.string		"An example string with end of line character\n"


# The text section is used for the code of your program.
# Always label your program in a main function!
.text
main:
	# write your code here
	
	
	
	# EXAMPLE CODE FOR I/O:
	
	# write a string to the standard output:
	la		a0, s		# put the address of the string in a0
	li		a7, 4		# put the ecall type (4: write string) in a7
	ecall				# environment call: write the string with address in a0 to the standard output
	
	# read an integer from the standard input:
	li		a7, 5		# put the ecall type (5: read integer) in a7
	ecall				# environment call: after completion, a7 contains the read integer
	
	# write an integer to the standard output:			
	li		a0, 100		# put the integer to write in a0
	li		a7, 1		# put the ecall type (1: write integer) in a7
	ecall				# environment call: writes the content of a0 (as integer) to the standard output

	# write an end-of-line (eol) character to the standard output (SHORTCUT)	
	li 		a0, 10		# put the \n character in a0
	li 		a7, 11 		# put the ecall type (11: print character) in a7
	ecall				# environment call: write the character in a0 to the standard ouput

	# exit program with exit code 0 (= success)
	li    	a7, 10		# put the ecall type (10: exit with code 0) in a7
	ecall				# environment call: stops execution of this program
