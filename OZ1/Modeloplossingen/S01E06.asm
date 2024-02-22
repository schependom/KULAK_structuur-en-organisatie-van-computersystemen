# SESSION 01 - EXCERCISE 06

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	voriggetal: 	s1
# 	getal:			s2
#	geordend:		s3
#	i:				s4
main:							# main(){
		li		s3, 1			# 	geordend = 1; /* true */
		li		s4, 1			#	i = 1;
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	voriggetal = getint();
		li		t0, 10			#
wh:		bge		s4, t0, endWh	# 	while (i < 10) {
		li		a7, 5			#
		ecall					#
		mv		s2, a0			# 		getal = getint();
		ble		s1, s2, endif	#		if (voriggetal > getal) {
		li		s3, 0			#			geordend = 0; /* false */
								#		}
endif:	mv		s1, s2			#		voriggetal = getal;
		addi	s4, s4, 1		#		i++;
		j		wh				# 	}
endWh:	mv 		a0, s3			#
		li		a7, 1			#
		ecall					# 	printint(geordend);
		li    	a7, 10			#
		ecall					# }
		