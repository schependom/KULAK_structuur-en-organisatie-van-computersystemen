# SESSION 05 - EXCERCISE 02 

.globl 	main
.data
		promptTeller:		.string		"      geef de teller: "
		promptNoemer:		.string		"      geef de noemer: "
		promptGeheelDeel:	.string		"geef het geheel deel: "
		
.text

ggdI:								# int ggd(int a, int b){
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
			
# void vereenvoudig(struct rationaalgetal in, struct rationaalgetal *uit)
# non-leaf functie
# PARAMETERS
#	struct in: 		8(fp) -> 16(fp)
#	struct *uit:	a0
# LOKALE VARIABELEN
#	deler:	s1
vereenvoudig:							# void vereenvoudig(struct rationaalgetal in, struct rationaalgetal *uit) {
			# backup van frame pointer
			addi	sp, sp, -4
			sw		fp, 0(sp)
			mv		fp, sp
			
			# kopie van s1
			addi	sp, sp, -4			#	int deler;
			sw		s1, 0(sp)
			
			# backup van a0
			addi	sp, sp, -4
			sw		a0, 0(sp)
			
			# zet de parameters goed voor ggd
			lw		a0, 8(fp)			# 	// in.teller in a0
			lw		a1, 12(fp)			#	// in.noemer in a1
			
			# call de functie ggd
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	ggdI
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# sla het resultaat van ggd op in deler
			mv		s1, a0				#	deler = ggd(in.teller, in.noemer);
			
			# restore a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
	
			# pas het argument aan (lokaal aan de oproep, dus mag gewoon)		
			lw		t1, 8(fp)			#	// in.teller in t1
			div		t1, t1, s1
			sw		t1, 8(fp)			#	in.teller = in.teller / deler;
			lw		t2, 12(fp)			#	// in.noemer in t2
			div		t2, t2, s1
			sw		t2, 12(fp)			#	in.noemer = in.noemer / deler;
			
			# berekeningen op uit
			lw		t3, 16(fp)			#	// in.gehdeel in t3
			div		t0, t1, t2			#	// in.teller / in.noemer in t0
			add		t0, t3, t0			#	// (in.teller / in.noemer) + in.gehdeel in t0
			sw		t0, 8(a0)			#	uit->gehdeel = (in.teller / in.noemer) + in.gehdeel;
			rem		t0, t1, t2			#	// in.teller % in.noemer
			sw		t0, 0(a0)			#	uit->teller = in.teller % in.noemer;
			sw		t2, 4(a0)			#	uit->noemer = in.noemer;
			
			# herstel s1
			lw		s1, 0(sp)
			addi	sp, sp, 4
			
			# herstel framepointer
			lw		fp, 0(sp)
			addi	sp, sp, 4
			
			ret

# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#   q: stack: -12(fp) -> -4(fp)
#	r: stack: -24(fp) -> -16(fp)
#
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
			
			# lokale variabelen q en r
			addi	sp, sp, -24		# 	struct rationaalgetal q,r;
			
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
			# zet q op de stack
			addi	sp, sp, -12
			lw		t0, -12(fp)
			sw		t0, 0(sp)
			lw		t0, -8(fp)
			sw		t0, 4(sp)
			lw		t0, -4(fp)
			sw		t0, 8(sp)
			# zet &r in a0
			addi	a0, fp, -24
			
			# roep vereenvoudig op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	vereenvoudig	#	vereenvoudig(q, &r);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# geef plaats van q op de stack terug vrij
			addi	sp, sp, 12
			
			# call drukrationaal
			# zet r op de stack
			addi	sp, sp, -12
			lw		t0, -24(fp)
			sw		t0, 0(sp)
			lw		t0, -20(fp)
			sw		t0, 4(sp)
			lw		t0, -16(fp)
			sw		t0, 8(sp)	
				
			# roep drukR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukR			#	drukRationaal(r);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# verwijder r van de stack
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
			
endWM:		# lokale variabele q
			addi	sp, sp, 24
	
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }
