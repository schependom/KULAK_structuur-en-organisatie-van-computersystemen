# SESSION 01 - EXCERCISE 07

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	space:	.string		" "
	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	getal:	 	s1
# 	aantal:		s2
#	n:			s3
#	anul:		s4
#	apos:		s5
#	aneg:		s6
main:							# main(){
		li		s4, 0			# 	anul = 0;
		li		s5, 0			# 	apos = 0;
		li		s6, 0			# 	aneg = 0;
		li		s2, 0			# 	aantal = 0;
		li		a7, 5			#
		ecall					#
		mv		s3, a0			# 	n = getint();
wh:		bge		s2, s3, endWh	# 	while (aantal < n) {
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 		getal = getint();
		addi	s2, s2, 1		#		aantal++;
		bnez	s1, else		#		if (getal == 0) {
		addi	s4, s4, 1		#			anul++;
		j		endif			#		} else {					# jumpen naar endif!
else:	blez	s1, else2		#			if (getal > 0) {
		addi	s5, s5, 1		#				apos++;
		j		endif			#			} else {
else2:	addi	s6, s6, 1		#				aneg++;
endif:							#			}
								#		}
		j		wh				#	}
endWh:	mv 		a0, s4			#
		li		a7, 1			#
		ecall					# 	printint(anul);
		la 		a0, space		#
		li		a7, 4			#
		ecall					# 	printstr(" ");
		mv 		a0, s5			#
		li		a7, 1			#
		ecall					# 	printint(apos);
		la 		a0, space		#
		li		a7, 4			#
		ecall					# 	printstr(" ");
		mv 		a0, s6			#
		li		a7, 1			#
		ecall					# 	printint(aneg);
		li    	a7, 10			#
		ecall					# }
	
