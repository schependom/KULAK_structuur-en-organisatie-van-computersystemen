# SESSION 04 - EXCERCISE 09

.globl 	main
.data
		ja:		.word	1,2,3,4,5,5,4,3,2,1
		nee:	.word	1,2,3,4,0,9,4,3,2,1

.text


# functie: int spiegelRec(int *r, int begin, int eind)
# PARAMETERS:
#	    r: a0
#	begin: a1
#	 eind: a2
# LOKALE VARIABELEN: (non-leaf functie)
#	   -
spR:								# int spiegelRec(int *r, int begin, int eind){
			blt		a1, a2, else	#	if(begin >= eind)
			li		a0, 1	
			ret						#		return 1;
else:								#	else
			slli	t0, a1, 2		#		// t0 = 4*begin
			add		t0, t0, a0		#		// t0 = r+begin
			lw		t0, 0(t0)		#		// t0 = *(r+begin)
			slli	t1, a2, 2		#		// t1 = 4*eind
			add		t1, t1, a0		#		// t1 = r+eind
			lw		t1, 0(t1)		#		// t1 = *(r+eind)
			bne		t0, t1, else2	#		if(*(r+begin) == *(r+eind))
			# zet parameters goed
									#			// r zit al in a0
			addi	a1, a1, 1		#			// begin + 1 in a1
			addi	a2, a2, -1		#			// eind -1 in a2
			# roep recursieve functie op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	spR				#			// a0 = spiegelRec(r, begin+1, eind-1)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# en geef het resultaat door 
			# aan oproeper (zit al in a0!)
			ret						#			return spiegelRec(r, begin+1, eind-1);
else2:								#		else
			li		a0, 0			#			
			ret						#			return 0;
									# }


# functie: int spiegel(int *r)
# PARAMETERS:
#	    r: a0
# LOKALE VARIABELEN: (non-leaf functie)
#	   -
spiegel:							# int spiegelRec(int *r, int begin, int eind){
			# zet parameters goed
									#		// r zit al in a0
			li		a1, 0			#		// 0 in a1
			li		a2, 9			#		// 9 in a2
			# roep recursieve functie op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	spR				#		// a0 = spiegelRec(r, 0, 9)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# en geef het resultaat door 
			# aan oproeper (zit al in a0!)
			ret						#		return spiegelRec(r, 0, 9);	
									# }
					

# main functie
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#	ja, nee: geheugen
main:								# main() {
			# call spiegel(ja)
			# zet eerst de parameters goed
			la		a0, ja			#	// a0 = ja = &ja[0]
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	spiegel			#	// a0 = spiegel(ja)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			li		a7, 1		
			ecall					# 	print(spiegel(ja));
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");
			
			# call spiegel(nee)
			# zet eerst de parameters goed
			la		a0, nee			#	// a0 = nee = &nee[0]
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	spiegel			#	// a0 = spiegel(nee)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			li		a7, 1		
			ecall					# 	print(spiegel(nee));
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");
			

			li		a7, 10			#
			ecall 					# }