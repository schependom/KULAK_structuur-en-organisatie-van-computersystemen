# SESSION 05 - EXCERCISE 10 - BINAIRE ZOEKBOMEN

# Dezelfde opmerking als bij vorige oefeningen geldt hier.
# Binaire zoekbomen moeten vanuit het geheugen bewaard worden (b moet dus in het geheugen zitten).
# 	Dit komt omdat sommige functies een wijzer naar een wijzer als parameter verwachten, en dan moeten we 
#	het adres van b meegeven. Als b in een register zit, dan heeft b geen adres en kan die functie 
#	niet worden opgeroepen. 
#

.globl 	main
.data
		prompt:				.string		"Geef een getal (0 om te stoppen): "
		b:					.align		2
							.word		0
		
.text


		
# FUNCTIE void voegtoe(struct knooptype **b, int g)
# parameters: 		
#	   b in a0
#	   g in a1
# lokale variabelen: (non-leaf)
#
voegtoe:							# void voegtoe(struct knooptype **b, int g) {
			lw		t0, 0(a0)
			bnez	t0, elseV		#	if(*b == NULL){
			# zet even a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)
			li		a0, 12			
			li		a7, 9			
			ecall					
			mv		t1, a0			#		// t1 = malloc(12)
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			sw		t1, 0(a0)		#		*b = malloc(12);
			sw		a1, 0(t1)		#		*b->waarde = g;
			sw		zero, 4(t1)		#		*b-links = NULL;
			sw		zero, 8(t1)		#		*b-rechts = NULL;
			j		endIfV			#	}
elseV:								#	 else{
			lw		t1, 0(t0)		#		// t1 = *b->waarde
			ble		t1, a1, elseV2	#		if(*b->waarde > g){
			# call voegtoe
			# backup eigen parameters niet nodig, daarna niet meer gebruikt
			# zet parameters goed
			addi	a0, t0, 4		#			// &(*b->links) in a0
									#			// g zit al in a1		
			# roep voegtoe op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	voegtoe			#			voegtoe(&(*b->links),g);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			j		endIfV2			#		}
elseV2:								#		 else{
			# call voegtoe
			# backup eigen parameters niet nodig, daarna niet meer gebruikt
			# zet parameters goed
			addi	a0, t0, 8		#			// (*b->rechts) in a0
									#			// g zit al in a1		
			# roep voegtoe op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	voegtoe			#			voegtoe(&(*b->rechts),g);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
endIfV2:							#		}
endIfV:								#	}
			ret						# } 


# FUNCTIE void drukboom(struct knooptype *b)
# parameters: 		
#	 b in a0
# lokale variabelen: (leaf)
#
drukboom:							# void drukboom(struct knooptype *b) {
			beqz	a0, endDB		#	if (b!= NULL){
			# call drukboom
			# zet eigen a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)
			# zet parameters goed
			lw		a0, 4(a0)		#			// b->links in a0
			# roep drukboom op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukboom			#			drukboom(b->links);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			# backup a0
			addi	sp, sp, -4
			sw		a0, 0(sp)
			lw		a0, 0(a0)	
			li		a7, 1		
			ecall					# 		print(b->waarde);
			li 		a0, 32			
			li 		a7, 11 		
			ecall					#		print(" ");
			# restore a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			# call drukboom
			# zet eigen a0 aan de kant (nu eigenlijk niet meer per se nodig)
			addi	sp, sp, -4
			sw		a0, 0(sp)
			# zet parameters goed
			lw		a0, 8(a0)		#			// b->rechts in a0
			# roep drukboom op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukboom			#			drukboom(b->rechts);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4

endDB:		ret						# } 

# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#  		b: geheugen (4 bytes)
#   getal: s1
#
main:								# main() {
			li		t0, 0
			sw		t0, b, t1		#	b = NULL;
			la		a0, prompt
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#	getal = getint();
whM:		beqz	s1, endWM		#	while(getal > 0){
			
			# call voegtoe
			# zet parameters goed
			la		a0, b			
			mv		a1, s1
			# roep voegtoe op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	voegtoe		#		voegtoe(&b,getal);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			la		a0, prompt
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#		getal = getint();
			j		whM				#	}
endWM:		
			# call drukboom
			# zet parameters goed
			lw		a0, b			
			# roep drukboom op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	drukboom		#	drukboom(b);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			li 		a0, 10			
			li 		a7, 11 		
			ecall					#	print("\n");			
			

			li		a7, 10			#
			ecall 					# }
			
