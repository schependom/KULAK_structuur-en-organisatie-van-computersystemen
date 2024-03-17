# SESSION 04 - EXCERCISE 09

.globl 	main
.data	
		ja:		.word	1, 2, 3, 4, 5, 5, 4, 3, 2, 1
		nee:	.word	1, 2, 3, 4, 0, 9, 4, 3, 2, 1
.text

# int spiegelRec(int *r, int begin, int eind)
# 	-> geen leaf functie (recursief)
#	-> ARGUMENTEN
#		a0: *r		a1: begin	  a2: eind

spiegelRec:							# int spiegelRec(int *r, int begin, int eind) {
			blt		a1, a2, elseIf	#	if(begin>=eind){
			li		a0, 1			#		return 1;
			ret						# 	}
elseIf:	
			slli	t0, a1, 2		#	// 4*begin
			slli	t1, a2, 2		#	// 4*eind
			add		t0, t0, a0		#	// &(r+begin)
			lw		t0, 0(t0)		#	// *(r+begin)
			add		t1, t1, a0		#	// &(r+eind)
			lw		t1, 0(t1)		#	// *(r+eind)
			bne		t0, t1, else	#	if ( *(r+begin) == *(r+eind) ) {

			# zet de parameters goed
			addi	a1, a1, 1
			addi	a2, a2, -1
			# roep spiegelRec aan
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	spiegelRec		#		return spiegelRec(r, begin+1, eind-1)
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# return
			ret						# 	}
else:		li		a0, 0			#	else
			ret						#		return 0;	
			

# int spiegel(int *r)
# 	-> geen leaf functie
#	-> ARGUMENT: a0: *r
spiegel:							# int spiegel(int *r) {
			# argumenten goedzetten (a0 zit al goed)
			li		a1, 0
			li		a2, 9
			# functie aanroepen
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	spiegelRec		#	return spiegelRec(r,0,9);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# a0 bevat al de return waarde van hanoi
			ret						# }

main:								# main() {
			la		s1, ja			# 	&ja[0]
			la		s2, nee			# 	&nee[0]
			mv		a0, s1
			
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	spiegel			#	// spiegel(ja);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			li		a7, 1
			ecall					# 	printint(spiegel(ja));
			
			mv		a0, s2
			call	spiegel			#	// spiegel(nee);
			li		a7, 1
			ecall					# 	printint(spiegel(nee));
			li		a7, 10
			ecall					# }
