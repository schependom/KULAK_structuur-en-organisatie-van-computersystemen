# SESSION 05 - EXCERCISE 02

.globl 	main
.data
		promptTeller:		.string		"      geef de teller: "
		promptNoemer:		.string		"      geef de noemer: "
		promptGeheelDeel:	.string		"geef het geheel deel: "
		
.text

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
			
			
# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#   q: stack: -12(fp) ->  -4(fp)
#   r: stack: -24(fp) -> -16(fp)
#
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
			
			# lokale variabele q,r
			addi	sp, sp, -24	
			
			# call leesrationaal
			# zet parameters goed
			mv		a0, fp
			addi	a0, a0, -12		#	// a0 = &q
			# roep leesR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leesR			#	leesRationaal(&q);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
whM:		lw		t0, -8(fp)		
			beqz	t0, endWM		#	while(0 != q.noemer){
			
			# call vereenvoudig
			# zet parameters goed
			addi	sp, sp, -12		#	// plaats voor param
			lw		t1, -12(fp)
			sw		t1, 0(sp)
			lw		t1, -8(fp)
			sw		t1, 4(sp)
			lw		t1, -4(fp)
			sw		t1, 8(sp)		#	// param q op stack	
			addi	a0, fp, -24		#	// a0 = &r		
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#	vereenvoudig(q,&r);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			
			# call drukrationaal
			# zet parameters goed
			addi	sp, sp, -12		#	// plaats voor param
			lw		t1, -24(fp)
			sw		t1, 0(sp)
			lw		t1, -20(fp)
			sw		t1, 4(sp)
			lw		t1, -16(fp)
			sw		t1, 8(sp)		#	// param r op stack			
			# roep drukR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukR			#	drukRationaal(r);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# verwijder param van de stack
			addi	sp, sp, 12
			# call leesrationaal
			# zet parameters goed
			mv		a0, fp
			addi	a0, a0, -12		#	// a0 = &q
			# roep leesR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	leesR			#	leesRationaal(&q);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			j		whM
			
endWM:		# lokale variabele q,r
			addi	sp, sp, 24
	
			# herstel frame pointer
			lw		fp, 0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }


####################################################################################################################
######  HIERONDER COPYPASTE UIT VORIGE OEFENING, ZONDER WIJZIGINGEN  ###############################################
####################################################################################################################


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
			lw		s1, 0(sp)		
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
			lw		fp, 0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 
			

