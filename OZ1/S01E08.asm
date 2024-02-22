# OEFENING 8

.globl main

.data
# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in registers:
#	laatste:		s0
#	voorlaatste:	s1
#	volgend:		s2
#	aantal:			s3
#	n:				s4
main:									# main () {								
		li		a7, 5
		ecall							#	n = getint();
		mv		s4, a0					
		li		s1, 1					#	voorlaatste = 1;
		li		s0, 1					#	laatste = 1;
		li		a7, 1
		mv		a0, s1					# 	// voorlaatste					
		ecall
		li 		a0, 32					
		li 		a7, 11					#	// space					
		ecall
		li		a7, 1
		mv		a0, s0					#	// laatste					
		ecall
		li		s3, 2					#	aantal = 2;
wh:		bge		s3, s4, endWh			#	while (aantal < n) {
		add		s2, s1, s0				#		volgend = voorlaatste + laatste;
		li		a7, 1
		mv		a0, s2					#		printint(volgend);
		ecall
		li 		a0, 32					
		li 		a7, 11					#	// space					
		ecall
		addi	s3, s3, 1				#		s3 = s3 + 1;
		mv		s1, s0					#		voorlaatste = laatste;
		mv		s0, s2					#		laatste = volgend;
		j		wh
endWh:									#	}
		li		a7, 10					# } 	/* end of main */					
		ecall	
