# SESSION 01 - EXCERCISE 10

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	tab:	.string		"\t"
	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	n: 		s1
# 	deler:	s2
#	mult:	s3
#	getal:	s4
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	n = getint();
		li 		a0, 1			#
		li		a7, 1			#
		ecall					# 	printint(1);
		la 		a0, tab			#
		li		a7, 4			#
		ecall					# 	printstr("\t");
		li 		a0, -1			#
		li		a7, 1			#
		ecall					# 	printint(-1);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#	print();
		li		s2, 2			#	deler = 2;
		li		t0, 2			#	// t0 = 2
		div		t1, s1, t0		#	// t1 = n/2
wh1:	bgt		s2, t1, eW1		#	while (deler <= (n/2)) {
		li		s3, 0			#		mult = 0;
		mv		s4, s1			#		getal = n;
wh2:	rem		t2, s4, s2		#		// t2 = getal % deler
		bnez	t2, eW2			#		while ((getal%deler) == 0) {
		addi	s3, s3, 1		#			mult += 1;
		div		s4, s4, s2		#			getal = getal / deler;
		j		wh2				#		}
eW2:	beqz	s3, endif		#		if (mult != 0) {
		mv 		a0, s2			#
		li		a7, 1			#
		ecall					# 			printint(deler);
		la 		a0, tab			#
		li		a7, 4			#
		ecall					# 			printstr("\t");
		mv 		a0, s3			#
		li		a7, 1			#
		ecall					# 			printint(mult);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#			print();
								#		}
endif:	addi	s2, s2, 1		#		deler += 1;
		j		wh1				#	}
eW1:	mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 	printint(n);
		la 		a0, tab			#
		li		a7, 4			#
		ecall					# 	printstr("\t");
		li 		a0, 1			#
		li		a7, 1			#
		ecall					# 	printint(1);
		li 		a0, 10			#
		li 		a7, 11 			#
		ecall					#	print();
		li    	a7, 10			#
		ecall					# }
	