# SESSION 01 - EXCERCISE 04

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	promptX:		.string 	"Geef een integer x in: "
	promptY:		.string 	"Geef een integer y in: "
	res:			.string 	"(x^2 + 4y^2)/(9xy) =  "

# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	x: s1
# 	y: s2
main:

	# read x
	la 		a0, promptX		# put the address of the prompt in a0
	li		a7, 4			# put the ecall type (4: write string) in a7
	ecall					# environment call: writes the string with address in a0 to the standard output
	
	li		a7, 5			# put the ecall type (5: read integer) in a7
	ecall					# environment call: after completion, a7 contains the read integer
	mv		s1, a0			# put x in s1
	
	# read y
	la 		a0, promptY		# put the address of the prompt in a0
	li		a7, 4			# put the ecall type (4: write string) in a7
	ecall					# environment call: writes the string with address in a0 to the standard output
	
	li		a7, 5			# put the ecall type (5: read integer) in a7
	ecall					# environment call: after completion, a7 contains the read integer
	mv		s2, a0			# put y in s2
	
	# calculate (x^2 + 4y^2)/(9xy)
	mv		t1, s1
	mul		t1, t1, t1		# t1 = x^2
	mv		t2, s2
	mul		t2, t2, t2
	addi	t0, zero, 4	
	li		t0, 4									#
	mul		t2, t2, t0		# t2 = 4y^2				# efficienter: slli		t2, t2, 2	
	add		t3, t1, t2		# t3 = x^2 + 4y^2
	addi	t4, zero, 9
	mul		t4, t4, s1
	mul		t4, t4, s2		# t4 = 9xy
	div		t5, t3, t4		# t5 = (x^2 + 4y^2)/(9xy)
	
	# print the result
	la 		a0, res			# put the address of the result string in a0
	li		a7, 4			# put the ecall type (4: write string) in a7
	ecall					# environment call: writes the string with address in a0 to the standard output
	
	mv 		a0, t5			# put the result in a0
	li		a7, 1			# put the ecall type (1: write integer) in a7
	ecall					# environment call: writes the content of a0 (as integer) to the standard output

	# exit program with exit code 0 (= success)
	li    	a7, 10			# put the ecall type (10: exit with code 0) in a7
	ecall					# environment call: stops execution of this program
	
