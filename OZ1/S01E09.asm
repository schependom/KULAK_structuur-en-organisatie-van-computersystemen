# OEFENING 9

.globl main

.data
# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in registers:
#	a:		s0
#	b:		s1
#	r:		s2
#	n:		s3
main:									# main () {								
		li		a7, 5
		ecall							#	n = getint();
		mv		s3, a0					
		li		s0, 1					#	a = 1;
wh1:	bgt		s0, s3, endWh1			#	while (a <= n) {
		li		s1, 1					#		b = 1;
wh2:	bgt		s1, s3, endWh2			#		while (b <= n) {
		mul		s2, s0, s1				#			r = a * b;
		li		a7, 1					#			printint(a,b,r);		// splits dit op!
		mv		a0, s0					#			// a
		ecall
		li 		a0, 32							
		li 		a7, 11					# 			// space
		ecall
		li		a7, 1
		mv		a0, s1					# 			// b
		ecall
		li 		a0, 32					
		li 		a7, 11					# 			// space
		ecall	
		li		a7, 1
		mv		a0, s2					# 			// r
		ecall
		li		a7, 11
		li		a0,	10					#			// end of line
		ecall
		addi	s1, s1, 1				#			b = b + 1;
		j		wh2						#		}
endWh2:	addi	s0, s0, 1				#		a = a + 1;
		j		wh1						#	}
endWh1:	li		a7, 10					# } 	/* end of main */					
		ecall	
