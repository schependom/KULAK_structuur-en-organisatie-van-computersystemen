# OEFENING 5

.globl main

.data

# we hebben in deze oefening geen waarden in het geheugen

.text
# variabelen in register:
#	getal: s1
#	aantal: s2
main:

									# main () {
		li		s2, 0				# 	aantal = 0;
	
		li		a7, 5
		ecall						# 	getal = getInt();
		mv		s1, a0				

wh:		bltz 	a0, x0, stop		# 	while (getal >= 0) {
	
		addi	s2, s2, 1			# 		aantal += 1
	
		li		a7, 5				
		ecall						#		getal = getInt();
		mv		s1, a0
		
		j		wh					#	}
		
endWh:	mv		a0, s2
		li		a7, 1				# 	printint(aantal);
		ecall
			
		# end of program			# }
		li    	a7, 10		
		ecall		
