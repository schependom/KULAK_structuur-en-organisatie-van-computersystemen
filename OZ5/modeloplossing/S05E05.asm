# SESSION 05 - EXCERCISE 05

.globl 	main
.data
		promptAantal:		.string		"Aantal coordinaten: "
		promptX:			.string		"geef de x-coordinaat: "
		promptY:			.string		"geef de y-coordinaat: "
		corij:				.align 		2
							.space		800
		
.text


# FUNCTIE void leesco(struct Tco *co)
# parameters: 		co in a0
#
leesco:								# void leesco(struct Tco *co) {
			# backup s1 op de stack
			addi	sp, sp, -4	
			sw		s1, 0(sp)	
			# en gebruik s1 om a0 op te slaan
			mv		s1, a0	
			
			la		a0, promptX
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			sw		a0, 0(s1)		#	co->x = getint();
			la		a0, promptY
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			sw		a0, 4(s1)		#	co->x = getint();
			
			# herstel s1
			lw		s1, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 


# FUNCTIE void schrijfco(struct Tco co)
# parameters: 	co  in   8(fp) -> 12(fp)
#
schrijfco:							# void schrijfco(struct Tco co) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			lw		a0, 8(fp)
			li		a7, 1
			ecall					#	print(co.x);
			li 		a0, 32			
			li 		a7, 11 		
			ecall					#	print(" ");
			lw		a0, 12(fp)	
			li		a7, 1		
			ecall					# 	print(co.y);
			li 		a0, 10			
			li 		a7, 11 		
			ecall					#	print("\n");			

			# herstel frame pointer
			lw		fp, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 
			
			
# FUNCTIE void leescorij(struct Tco r[], int n)
# parameters: 		cr in a0
#					n  in a1
# lokale variabele: (non-leaf)
#					i  in s1
#
leescorij:							# void leescorij(struct Tco cr[], int n) {
			# backup s1 op de stack
			addi	sp, sp, -4	
			sw		s1, 0(sp)	
			
			li		s1, 0			#	i=0;
forLCR:		bge		s1, a1, endFLCR	#	for(   ; i<n;   ){

			# call leesco
			# backup a0 en a1
			addi	sp, sp, -8
			sw		a0, 0(sp)
			sw		a1, 4(sp)
			# zet parameters goed
			slli	t0, s1, 3		#		// t0 = 8*i
			add		a0, t0, a0		#		// t0 = &cr[i]
			# roep leesco op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leesco			#		leesco(&cr[i]);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# restore a0 en a1
			lw		a0, 0(sp)
			lw		a1, 4(sp)
			addi	sp, sp, 8
			
			addi	s1, s1, 1		#		i++;
			j		forLCR			#	}
endFLCR:			
			# herstel s1
			lw		s1, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 


# FUNCTIE int cogr(struct Tco co1, struct Tco co2)
# parameters:    co1 in    8(fp) -> 12(fp)
#			     co2 in   16(fp) -> 20(fp)
# lokale variabele: (leaf)
# resultaat: a0
#
cogr:								# int cogr(struct Tco co1, struct Tco co2) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			lw		t0, 8(fp)
			mul		t0, t0, t0
			lw		t1, 12(fp)
			mul		t1, t1, t1
			add		t0, t0, t1		#	// t0 = co1.x * co1.x + co1.y * co1.y
			lw		t2, 16(fp)
			mul		t2, t2, t2
			lw		t3, 20(fp)
			mul		t3, t2, t3
			add		t2, t2, t3		#	// t2 = co2.x * co2.x + co2.y * co2.y
			ble		t1, t2, elseCG	#	if(t0 > t2)
			li		a0, 1			#		return 1;
			j		endICG			
elseCG:								#	else
			li		a0, 0			#		return 0;
endICG:									
			# herstel frame pointer
			lw		fp, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# }
			

# FUNCTIE void vindmaxco(struct Tco cr[], struct Tco *maxco, int n)
# parameters:    
#		cr: a0
#	 maxco: a1
#		 n: a2
# lokale variabele: (non-leaf)
#		 i: s1
#	   max:	s2
#
vindmaxco:							# void vindmaxco(struct Tco cr[], struct Tco *maxco, int n) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
			
			# backup s1-s3
			addi	sp, sp, -12
			sw		s1, 0(sp)
			sw		s2, 4(sp)
			sw		s3, 8(sp)
			
			mv		s2, zero		#	max = 0
			li		s1, 1			#	i=1;
forVM:		bge		s1, a2, endFVM	#	for(   ; i<n;   ){
			# call cogr
			# backup eigen a0-a2
			addi	sp, sp, -12
			sw		a0, 0(sp)
			sw		a1, 4(sp)
			sw		a2, 8(sp)		# 		// ook a2, cogr mag deze wijzigen!
			# zet parameters goed
			slli	t1, s1, 3
			add		t1, t1, a0		#		// t1 = &cr[i]
			slli	t2, s2, 3
			add		t2, t2, a0		#		// t2 = &cr[max]
			addi	sp, sp, -16		#		// plaats voor param
			lw		t0, 0(t1)
			sw		t0, 0(sp)
			lw		t0, 4(t1)
			sw		t0, 4(sp)		#		// cr[i] op de stack
			lw		t0, 0(t2)
			sw		t0, 8(sp)
			lw		t0, 4(t2)
			sw		t0, 12(sp)		#		// cr[max] op de stack
			# roep cogr op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	cogr			#		// a0 = cogr(cr[i], cr[max])
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 16
			# verplaats resultaat
			mv		s3, a0			#		// s3 = cogr(cr[i], cr[max])
			# restore eigen a0-a2
			lw		a0, 0(sp)
			lw		a1, 4(sp)
			lw		a2, 8(sp)		
			addi	sp, sp, 12
			li		t0, 1
			bne		s3, t0, endIVM	#		if(cogr(cr[i], cr[max]) == 1)
			mv		s2, s1			#			max = i;
endIVM:						
			addi	s1, s1, 1		#		i++;
			j		forVM			#	}
endFVM:
			slli	t0, s2, 3
			add		t0, t0, a0		#	// t0 = &cr[max] 
			lw		t1, 0(t0)
			sw		t1, 0(a1)
			lw		t1, 4(t0)
			sw		t1, 4(a1)		#	*maxco = cr[max];
	
			# restore s1-s3
			lw		s1, 0(sp)
			lw		s2, 4(sp)
			lw		s3, 8(sp)
			addi	sp, sp, 12
			
			# herstel frame pointer
			lw		fp, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# }




# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#  corij: geheugen (800 bytes)
#  maxco: stack: -8(fp) ->  -4(fp)
#    len: s1
#
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
			
			# lokale variabele maxco
			addi	sp, sp, -8
			
			la		a0, promptAantal
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#	len = getint();
			
			# call leescorij
			# zet parameters goed
			la		a0, corij
			mv		a1, s1
			# roep leescorij op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leescorij		#		leescorij(corij, len);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# call vincmaxco
			# zet parameters goed
			la		a0, corij
			mv		a1, fp
			addi	a1, a1, -8
			mv		a2, s1
			# roep leescorij op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vindmaxco		#		vindmaxco(corij, &maxco, len);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# call schrijfco
			# zet parameters goed
			addi	sp, sp, -8		#		// plaats voor param
			lw		t0, -8(fp)
			sw		t0, 0(sp)
			lw		t0, -4(fp)
			sw		t0, 4(sp)		#		// *maxco op de stack
			# roep schrijfco op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	schrijfco		#		schrijfco(*maxco);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#			
			
			# lokale variabele maxco
			addi	sp, sp, 8
	
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }

