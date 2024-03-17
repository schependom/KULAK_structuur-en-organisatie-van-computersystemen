# SESSION 04 - EXCERCISE 07 - version 2

.globl 	main
.data

.text

# functie: void hanoi(int n, int van, int naar)
# PARAMETERS:
#	    n: a0
#	  van: a1
#	 naar: a2
# LOKALE VARIABELEN: (non-leaf functie)
#	  via: s1
hanoi:								# void hanoi(int n, int van, int naar){
			# backup s1 en s2
			addi	sp, sp, -8
			sw		s1, 0(sp)	
			sw		s2, 4(sp)	
			
			beqz	a0, end			#	if(n!= 0){
			li		s1, 6			#
			sub		s1, s1, a1		#
			sub		s1, s1, a2		#		via = 6 - van - naar;
			
			# call hanoi(n-1, van, via)	
			# zet eerst de eigen waarde uit a0, a1, a2 aan de kant!
			addi	sp, sp, -12		
			sw		a0, 0(sp)		
			sw		a1, 4(sp)		
			sw		a2, 8(sp)		
			# zet de parameters goed voor hanoi
			addi	a0, a0, -1		#				// n-1 in a0
									#				// van staat al in a1
			mv		a2, s1			#				// via in a2
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		
			sw		ra, 0(sp)		
			call  	hanoi			#		hanoi(n-1, van, via);
			lw		ra, 0(sp)		
			addi	sp, sp, 4		
			# herstel de eigen waarde uit a0, a1, a2!
			lw		a0, 0(sp)		
			lw		a1, 4(sp)		
			lw		a2, 8(sp)		
			addi	sp, sp, 12		
			
			# print van en naar
			# zet eerst even a0 aan de kant, we gebruiken deze keer s2 ipv de stack
			# (maar de oude waarde van s2 moet dan toch ook op de stack gezet worden
			#  aan het begin van deze functie...)
			mv		s2, a0
			mv		a0, a1	
			li		a7, 1		
			ecall					# 		print(van);
			li 		a0, 32			# 		// put the " " character in a0
			li 		a7, 11 		
			ecall					#		print(" ");
			mv		a0, a2	
			li		a7, 1		
			ecall					# 		print(naar);
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");
			# en herstel a0
			mv		a0, s2
			
			# call hanoi(n-1, via, naar)	
			# zet eerst de eigen waarde uit a0, a1, a2 aan de kant!
			addi	sp, sp, -12		
			sw		a0, 0(sp)		
			sw		a1, 4(sp)		
			sw		a2, 8(sp)		
			# zet de parameters goed voor hanoi
			addi	a0, a0, -1		#				// n-1 in a0
			mv		a1, s1 			#				// via in a1
									#				// naar staat al in a2
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		
			sw		ra, 0(sp)		
			call  	hanoi			#		hanoi(n-1, via, naar);
			lw		ra, 0(sp)		
			addi	sp, sp, 4		
			# herstel de eigen waarde uit a0, a1, a2!
			lw		a0, 0(sp)		
			lw		a1, 4(sp)		
			lw		a2, 8(sp)		
			addi	sp, sp, 12
			
end:								#	}
			# herstel s1 en s2
			lw		s1, 0(sp)
			lw		s2, 4(sp)
			addi	sp, sp, 8
			ret						# }
	

# main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	  aantal: s1
main:								# main() {
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	aantal = getint();
			
			
			# call hanoi
			# zet eerst de parameters goed
			mv		a0, s1			#	// a0 = aantal
			li		a1, 1			#	// a1 = 1
			li		a2, 3			#	// a2 = 3
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	hanoi			#	hanoi(aantal, 1, 3);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			li		a7, 10			#
			ecall 					# }