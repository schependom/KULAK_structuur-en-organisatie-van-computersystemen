# OEFENING 7

.globl main

.data

# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in registers:
#	getal: 	s0
#	aantal:	s1
#	n:		s2
#	anul:	s3
#	apos:	s4
#	aneg:	s5
main:									# main () {								
		li		s3, 0					#	anul = 0;
		li		s4, 0					#	apos = 0;
		li		s5, 0					#	aneg = 0;
		li		s1, 0					#	aantal = 0;
		
		li		a7, 5
		ecall
		mv		s2, a0					#	n = getint();
wh:		bge		s1, s2, endWh			#	while (aantal < n) {
		li		a7, 5
		ecall
		mv		s0, a0					#		getal = getint();
		addi	s1, s1, 1				#		aantal = aantal + 1;
		bnez	s0, else1				#		if (getal == 0) {
		addi	s3, s3, 1				#			anul = anul + 1;
		j		endif
else1:									#		} else {
		blez	s0, else2				#			if (getal > 0) {
		addi	s4, s4, 1				#				apos = apos + 1;
		j		endif
else2:									#			} else {
		addi	s5, s5, 1				#				aneg = aneg + 1;
										#			}
endif:									#		}
		j		wh						#	}
endWh:	li		a7, 1
		mv		a0, s3					# /* 	anul
		ecall
		li 		a0, 32					# 		put the [space] character in a0
		li 		a7, 11					# 		ecall type for printing a string
		ecall
		li		a7, 1
		mv		a0, s4					# 		apos
		ecall
		li 		a0, 32					
		li 		a7, 11					# 		space
		ecall	
		li		a7, 1
		mv		a0, s5					# 		aneg 	*/
		ecall
		
		li    	a7, 10					# } 	/* end of main */					
		ecall	
