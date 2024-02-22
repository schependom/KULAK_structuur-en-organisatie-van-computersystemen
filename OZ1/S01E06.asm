# OEFENING 6

.globl main

.data

# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in registers:
#	voriggetal: s0
# 	getal:		s1
#	geordend:	s2
#	i:			s3
main:									# main () {								
		li		s2, 1					#	geordend = 1; /* true */
		li		s3, 1					#	i = 1;
		li		a7, 5
		ecall							#	voriggetal = getint();
		mv		s0, a0
		li		t0, 10
wh:		bge		s3, t0, endWh			#	while (i < 10
		beqz	s2, endWh				#		&& geordend != 0) { /* als er || had gestaan -> extra adres om in while te springen */
		li		a7, 5
		ecall							#		getal = getint();
		mv		s1, a0
		ble		s0, s1, endif			#		if (voriggetal > getal ) {
		li		s2, 0					#			geordend = 0; /* false */
endif:									#		}
		mv		s0, s1					# 		voriggetal = getal;
		addi	s3, s3, 1				# 		i += 1;
		j		wh						#	}
endWh:									
		li    	a7, 1		
		mv		a0, s2					#	printint(geordend);
		ecall	
		
		li    	a7, 10					# }		
		ecall	
