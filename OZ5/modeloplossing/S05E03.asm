# SESSION 05 - EXCERCISE 03

.globl 	main
.data
		promptTeller:		.string		"      geef de teller: "
		promptNoemer:		.string		"      geef de noemer: "
		promptGeheelDeel:	.string		"geef het geheel deel: "
		rij:				.align 		2
							.space		1200
		
.text

# FUNCTIE int isgelijk(struct rationaalgetal a, struct rationaalgetal b)
# parameters:    a in    8(fp) -> 16(fp)
#			     b in   20(fp) -> 28(fp)
# lokale variabele: (non-leaf)
# resultaat: a0
#
isgelijk:							# int isgelijk(struct rationaalgetal a, struct rationaalgetal b) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			# call vereenvoudig
			# zet parameters goed
			addi	sp, sp, -12		#	// plaats voor param
			lw		t1, 8(fp)
			sw		t1, 0(sp)
			lw		t1, 12(fp)
			sw		t1, 4(sp)
			lw		t1, 16(fp)
			sw		t1, 8(sp)		#	// param a op stack	
			mv		a0, fp
			addi	a0, a0, 8		#	// a0 = &a
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#	vereenvoudig(a,&a);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			
			# call vereenvoudig
			# zet parameters goed
			addi	sp, sp, -12		#	// plaats voor param
			lw		t1, 20(fp)
			sw		t1, 0(sp)
			lw		t1, 24(fp)
			sw		t1, 4(sp)
			lw		t1, 28(fp)
			sw		t1, 8(sp)		#	// param b op stack	
			mv		a0, fp
			addi	a0, a0, 20		#	// a0 = &b
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#	vereenvoudig(b,&b);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			
ifIG:		lw		t0, 8(fp)
			lw		t1, 20(fp)
			bne		t0, t1, elseIG	#	if(a.teller == b.teller && 
			lw		t0, 12(fp)
			lw		t1, 24(fp)
			bne		t0, t1, elseIG	#	   a.noemer == b.noemer &&
			lw		t0, 16(fp)
			lw		t1, 28(fp)
			bne		t0, t1, elseIG	#	   a.gehdeel == b.gehdeel) 
			li		a0, 1			#		 return 1;
			j		endifIG
elseIG:		li		a0, 0			#	else return 0;
endifIG:			
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# }
			

# FUNCTIE void drukrij(struct rationaalgetal *r, int n)
# parameters: 		r in a0
#					n in a1
# lokale variabele: (non-leaf)
#					i in s1
#
drukrij:							# void drukrij(struct rationaalgetal *r, int n) {
			# backup s1 op de stack
			addi	sp, sp, -4	
			sw		s1, 0(sp)	
			
			li		s1, 0			#	i=0;
forDR:		bge		s1, a1, endFDR	#	for(   ; i<n;   ){

			# call drukrationaal
			# backup a0 en a1
			addi	sp, sp, -8
			sw		a0, 0(sp)
			sw		a1, 4(sp)
			# zet parameters goed
			li		t0, 12			
			mul		t0, t0, s1		#		// t0 = 12*i
			add		t0, t0, a0		#		// t0 = &(*(r+i))
			addi	sp, sp, -12		#		// plaats voor param
			lw		t1, 0(t0)
			sw		t1, 0(sp)
			lw		t1, 4(t0)
			sw		t1, 4(sp)
			lw		t1, 8(t0)
			sw		t1, 8(sp)		#		// param *(r+i) op stack			
			# roep drukR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukR			#		drukRationaal(*(r+i));
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			# restore a0 en a1
			lw		a0, 0(sp)
			lw		a1, 4(sp)
			addi	sp, sp, 8
			
			addi	s1, s1, 1		#		i++;
			j		forDR			#	}
endFDR:			
			# herstel s1
			lw		s1,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 
			
									
# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#	rij: geheugen (1200 bytes)
#     q: stack: -12(fp) ->  -4(fp)
#     i: s1, j: s2, in: s3
#
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
			
			# lokale variabele q
			addi	sp, sp, -12
			
			li		s3, 0			#	in = 0;
			
			# call leesrationaal
			# zet parameters goed
			addi	a0, fp, -12		#		// a0 = &q
			# roep leesR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leesR			#		leesRationaal(&q);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# call vereenvoudig
			# zet parameters goed
			addi	sp, sp, -12		#		// plaats voor param
			lw		t1, -12(fp)
			sw		t1, 0(sp)
			lw		t1, -8(fp)
			sw		t1, 4(sp)
			lw		t1, -4(fp)
			sw		t1, 8(sp)		#		// param q op stack	
			la		t1, rij
			li		a0, 12			
			mul		a0, a0, s3		#		// a0 = 12*in
			add		a0, a0, t1		#		// a0 = &rij[in]
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#		vereenvoudig(q,&(rij[in]));
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			
			li		s1, 1			#	i=1;
			li		s10, 4			#									# TESTEN MET 4 ipv 100!			
forM:		bge		s1, s10, endFM	#	for(   ; i<100;   ){
			
			# call leesrationaal
			# zet parameters goed
			addi	a0, fp, -12		#		// a0 = &q
			# roep leesR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leesR			#		leesRationaal(&q);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# call vereenvoudig
			# zet parameters goed
			addi	sp, sp, -12		#		// plaats voor param
			lw		t1, -12(fp)
			sw		t1, 0(sp)
			lw		t1, -8(fp)
			sw		t1, 4(sp)
			lw		t1, -4(fp)
			sw		t1, 8(sp)		#		// param q op stack	
			addi	s3, s3, 1		#		// ++in
			la		t1, rij
			li		a0, 12			
			mul		a0, a0, s3		#		// a0 = 12*in
			add		a0, a0, t1		#		// a0 = &rij[in]
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#		vereenvoudig(q,&(rij[++in]));
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			
			li		s2, 0			#		j=0;
whM:		# call isgelijk
			# zet parameters goed
			li		t0, 12
			mul		t1, t0, s2		
			mul		t2, t0, s3			
			la		t0, rij
			add		t1, t1, t0		#		// t1 = &rij[j]
			add		t2, t2, t0		#		// t2 = &rij[in]			
			addi	sp, sp, -24		#		// plaats voor param
			lw		t0, 0(t1)
			sw		t0, 0(sp)
			lw		t0, 4(t1)
			sw		t0, 4(sp)
			lw		t0, 8(t1)
			sw		t0, 8(sp)		#		// rij[j] op de stack
			lw		t0, 0(t2)
			sw		t0, 12(sp)
			lw		t0, 4(t2)
			sw		t0, 16(sp)
			lw		t0, 8(t2)
			sw		t0, 20(sp)		#		// rij[in] op de stack
			# roep isgelijk op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	isgelijk		#		// a0 = isgelijk(rij[j],rij[in])
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 24
			
			bnez	a0, endWM		#		while(isGelijk(rij[j],rij[in]) == 0){ 
			addi	s2, s2, 1		#			j++;
			j		whM				#		}
endWM:		beq		s2, s3, endIM	#		if(j != in){
			addi	s3, s3, -1		#			in--;
endIM:								#		}
			addi	s1, s1, 1		#		i++;
			j		forM			#	}
endFM:		

			# call drukrij
			# zet parameters goed
			la		a0, rij
			addi	s3, s3, 1
			mv		a1, s3
			# roep drukrij op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukrij			#		drukrij(rij,++in);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
									
			# lokale variabele q
			addi	sp, sp, 12
	
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }


####################################################################################################################
######  HIERONDER COPYPASTE UIT VORIGE OEFENING, ZONDER WIJZIGINGEN  ###############################################
####################################################################################################################


# FUNCTIE void vereenvoudig(struct rationaalgetal in, struct rationaalgetal *uit)
# parameters:    in in   8(fp) -> 16(fp)
#			    uit in   a0
# lokale variabele: (non-leaf)
#			  deler in  s1
#
vereenvoudig:						# void vereenvoudig(struct rationaalgetal in, struct rationaalgetal *uit) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			# backup s1
			addi	sp, sp, -4
			sw		s1, 0(sp)
			
			# call ggd
			# backup eerst a0!
			addi	sp, sp, -4
			sw		a0, 0(sp)
			# zet parameters goed
			lw		a0, 8(fp)
			lw		a1, 12(fp)
			# roep ggd op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#	// a0 = ggd(in.teller, in.noemer)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verplaats resultaat
			mv		s1, a0			#	deler = ggd(in.teller, in.noemer);
			# en restore a0!
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			lw		t1, 8(fp)
			div		t1, t1, s1
			sw		t1, 8(fp)		#	in.teller = in.teller / deler;
			lw		t2, 12(fp)
			div		t2, t2, s1
			sw		t2, 12(fp)		#	in.noemer = in.noemer / deler;
			lw		t3, 16(fp)
			div		t0, t1, t2
			add		t0, t0, t3		
			sw		t0, 8(a0)		#	uit->gehdeel = (in.teller / in.noemer) + in.gehdeel;
			rem		t0, t1, t2	
			sw		t0, 0(a0)		#	uit->teller = in.teller % in.noemer;
			sw		t2, 4(a0)		#	uit->noemer = in.noemer;
									
			# restore s1
			lw		s1, 0(sp)
			addi	sp, sp, 4
			
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 
			
			
# iteratieve functie: int ggd(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (leaf functie)
#	r: t0
# 
ggd:								# int ggd(int a, int b){
			rem		t0, a0, a1		#	r = a % b;
wh:			beqz	t0, endW		#	while(r != 0){
			mv		a0, a1			#		a = b;
			mv		a1, t0			#		b = r;
			rem		t0, a0, a1		#		r = a % b;
			j		wh				#	}
endW:		mv		a0, a1			#	return b;
			ret						# }
			
			
# FUNCTIE void leesRationaal(struct rationaalgetal *g)
# parameters: 		g in a0
#
leesR:								# void leesRationaal(struct rationaalgetal *g) {
			# backup s1 op de stack
			addi	sp, sp, -4	
			sw		s1, 0(sp)	
			# en gebruik s1 om a0 op te slaan
			mv		s1, a0	
			
			la		a0, promptGeheelDeel
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			sw		a0, 8(s1)		#	g->gehdeel = getint();
			la		a0, promptTeller
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			sw		a0, 0(s1)		#	g->teller = getint();
			la		a0, promptNoemer
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			sw		a0, 4(s1)		#	g->noemer = getint();
			
			# herstel s1
			lw		s1,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 


# FUNCTIE void drukRationaal(struct rationaalgetal g)
# parameters: 		g in   8(fp) -> 16(fp)
#
drukR:								# void drukRationaal(struct rationaalgetal g) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			lw		a0, 16(fp)
			li		a7, 1
			ecall					#	print(q.gehdeel);
			li 		a0, 32			
			li 		a7, 11 		
			ecall					#	print(" ");
			lw		a0, 8(fp)	
			li		a7, 1		
			ecall					# 	print(q.teller);
			li 		a0, 32			
			li 		a7, 11 		
			ecall					#	print(" ");
			lw		a0, 12(fp)	
			li		a7, 1		
			ecall					# 	print(q.noemer);
			li 		a0, 10			
			li 		a7, 11 		
			ecall					#	print("\n");			

			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 
			

