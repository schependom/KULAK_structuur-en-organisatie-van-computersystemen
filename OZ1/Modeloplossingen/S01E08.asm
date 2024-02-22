# SESSION 01 - EXCERCISE 08

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data

	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	laatste: 		s1
# 	voorlaatste:	s2
#	volgend:		s3
#	aantal:			s4
#	n:				s5
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s5, a0			# 	n = getint();
		li		s1, 1			#	laatste = 1;
		li		s2, 1			#	voorlaatste = 1;
		mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 	printint(laatste);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#	print();
		mv 		a0, s2			#
		li		a7, 1			#
		ecall					# 	printint(voorlaatste);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#	print();
		li		s4, 2			#	aantal = 2;
wh:		bge		s4, s5, endWh	# 	while (aantal < n) {
		add		s3, s1, s2		#		volgend = laatste + voorlaatste;
		mv 		a0, s3			#
		li		a7, 1			#
		ecall					# 		printint(volgend);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#		print();
		addi	s4, s4, 1		#		aantal++;
		mv		s2, s1			#		voorlaatste = laatste;
		mv		s1, s3			#		laatste = volgend;
		j		wh				#	}
endWh:	li    	a7, 10			#
		ecall					# }
	