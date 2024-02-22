# SESSION 01 - EXCERCISE 09

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	tab:	.string		"\t"
	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	a: 	s1
# 	b:	s2
#	r:	s3
#	n:	s4
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s4, a0			# 	n = getint();
		li		s1, 1			#	a = 1;
wh1:	bgt		s1, s4, endW1	#	while (a <= n) {
		li		s2, 1			#		b = 1;
wh2:	bgt		s2, s4, endW2	#		while (b <= n) {
		mul		s3, s1, s2		#			r = a * b;
		mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 			printint(a);
		la 		a0, tab			#
		li		a7, 4			#
		ecall					# 			printstr("\t");
		mv 		a0, s2			#
		li		a7, 1			#
		ecall					# 			printint(b);
		la 		a0, tab			#
		li		a7, 4			#
		ecall					# 			printstr("\t");
		mv 		a0, s3			#
		li		a7, 1			#
		ecall					# 			printint(r);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#			print();
		addi	s2, s2, 1		#			b += 1;
		j		wh2				#		}
endW2:	addi	s1, s1, 1		#		a += 1;
		j		wh1				#	}
endW1:	li    	a7, 10			#
		ecall					# }
	