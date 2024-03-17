# SESSION 05 - EXCERCISE 01 

.globl 	main
.data
		promptTeller:		.string		"      geef de teller: "
		promptNoemer:		.string		"      geef de noemer: "
		promptGeheelDeel:	.string		"geef het geheel deel: "
		
.text

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
			

# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#   q: stack: -12(fp) -> -4(fp)
#
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
			
			# lokale variabele q
			addi	sp, sp, -12	
			
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
			# call drukrationaal
			# zet parameters goed
			mv		t0, fp
			addi	t0, t0, -12		#	// t0 = &q
			addi	sp, sp, -12		#	// plaats voor param
			lw		t1, 0(t0)
			sw		t1, 0(sp)
			lw		t1, 4(t0)
			sw		t1, 4(sp)
			lw		t1, 8(t0)
			sw		t1, 8(sp)		#	// param q op stack			
			# roep drukR op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukR			#	drukRationaal(q);
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
			
endWM:		# lokale variabele q
			addi	sp, sp, 12
	
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }
