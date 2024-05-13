# SESSION 05 - EXCERCISE 00 - RECORDS - SPILLING

.globl 	main
.data
	rij:	.align	2
			.space	600		# 50 elementen, 3 cellen per element, 4 bytes per cel: 50*3*4 = 600
.text

# FUNCTIE struct schakelaar kopieer(struct schakelaar s)
# parameters: 		s in   8(fp) -> 16(fp)
# lokale variabele:	t in -12(fp) -> -4(fp)
# resultaat: 	  	  in  20(fp) -> 28(fp)
kopieer:							# struct schakelaar kopieer(struct schakelaar s) {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		 
	
			# lokale variabele
			addi	sp, sp, -12	
	
			# argument struct op de stack zetten boven de fp
			lw		t0, 8(fp)
			sw		t0, -12(fp)
			lw		t0, 12(fp)
			sw		t0, -8(fp)
			lw		t0, 16(fp)
			sw		t0, -4(fp)		# 	t = s;

			# zet het resutlaat op de juiste plaats
			lw		t0, -12(fp)
			sw		t0, 20(fp)
			lw		t0, -8(fp)
			sw		t0, 24(fp)
			lw		t0, -4(fp)
			sw		t0, 28(fp)		#	return t;
	
			# lokale variabele
			addi	sp, sp, 12
	
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		 
			
			ret						# } 





# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#   rij: geheugen
main:								# main() {
			la		t0, rij			
			li		t1, 10
			sw		t1, 0(t0)		#	rij[0].lokaal = 10;
			li		t1, 5
			sw		t1, 4(t0)		#	rij[0].nr = 5;
			sw		zero, 8(t0)		#	rij[0].aan = 0;
			
			# maak plaats op stack voor resultaat
			addi	sp, sp, -12
			# zet parameters goed
			addi	sp, sp, -12
			lw		t1, 0(t0)
			sw		t1, 0(sp)		#	// rij[0].lokaal op stack
			lw		t1, 4(t0)
			sw		t1, 4(sp)		#	// rij[0].nr op stack
			lw		t1, 8(t0)
			sw		t1, 8(sp)		#	// rij[0].aan op stack
			# roep functie op
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call 	kopieer			#	kopieer(rij[0]); // res op stack
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# verwijder parameter van stack
			addi	sp, sp, 12	
			# zet resultaat goed
			# alles kopieren naar r[1] en dus 12(t0) -> 20(t0)
			la		t0, rij			
			lw		t1, 0(sp)
			sw		t1, 12(t0)
			lw		t1, 4(sp)
			sw		t1, 16(t0)
			lw		t1, 8(sp)
			sw		t1, 20(t0)		#	rij[1] = ...
			# verwijder resultaat van de stack
			addi	sp, sp, 12
			
			li		a7, 10			#
			ecall 					# }
