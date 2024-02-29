# OEFENING 10

.globl main

.data
# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in registers:
#	n:		s0
#	deler:	s1
#	mult:	s2
#	getal:	s3
main:									# main () {								
		li		a7, 5
		ecall							#	n = getint();
		mv		s0, a0					#	printint(1,-1);
		li		a7, 1
		li		a0, 1					#	// 1
		ecall
		li 		a0, 32							
		li 		a7, 11					# 	// space
		ecall
		li		a7, 1
		li		a0, 1					# 	// 1
		ecall
		li		a7, 11
		li		a0, 10					#	// new line
		ecall
		li		s1, 2					# 	deler = 2;
		li		t0, 2					#	// 2
		div		t1, s0, t0				#	// n/2
wh1:	bgt		s1, t1, endWh1			#	while( deler <= (n/2) ) {
		mv		s2, x0					#		mult = 0;
		mv		s3, s0					#		getal = n;
wh2:	rem		t2, s3, s1				#		// getal % deler
		bnez	t2, endWh2				#		while( (getal%deler) == 0 ) {
		addi	s2, s2, 1				#			mult = mult + 1;
		div		s3, s3, s1				#			getal = getal / deler;
		j		wh2						#		}
endWh2:	beqz	s2, endif				#		if (mult != 0)
		li		a7, 1					#			print(deler, mult);
		mv		a0, s1					#			// deler
		ecall
		li		a7, 11
		li		a0, 32					#			// space
		ecall
		li		a7, 1
		mv		a0, s2					#			// mult
		ecall
		li		a7, 11
		li		a0, 10					#			// new line
		ecall
endif:	addi	s1, s1, 1				#		deler = deler + 1;
		j		wh1						#	}
endWh1:	li		a7, 1					#	print(n,1);
		mv		a0, s0					#	// n
		ecall			
		li		a7, 11
		li		a0,	32					#	// space
		ecall
		li		a7, 1
		li		a0, 1
		ecall							#	// 1
		li		a7, 11
		li		a0, 10					#	// new line
		ecall
		li		a7, 10					# } // end of main			
		ecall	
