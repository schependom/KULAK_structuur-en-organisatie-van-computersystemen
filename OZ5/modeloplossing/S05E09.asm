# SESSION 05 - EXCERCISE 09 - LIJSTEN ZONDER KOPELEMENT

# Lijsten met kopelement kunnen via een variabele p in een register bijgehouden worden.
# Lijsten zonder kopelement moeten vanuit het geheugen bewaard worden (p moet dus in het geheugen zitten).
# 	Dit komt omdat sommige functies een wijzer naar een wijzer als parameter verwachten, en dan moeten we 
#	het adres van p meegeven. Als p in een register zit, dan heeft p geen adres en kan die functie 
#	niet worden opgeroepen. 
#	We zullen dus p als label in het geheugen plaatsen, ongeacht of er nu wel of geen kopelement is.
#

.globl 	main
.data
		prompt:				.string		"Geef een getal (0 om te stoppen): "
		promptDelete:		.string		"Geef te verwijderen getal (0 om te stoppen): "
		p:					.align		2
							.space		4
		
.text


		
# FUNCTIE void verwijder(struct lijstelem **l, int g)
# parameters: 		
#	   l in a0
#	   g in a1
# lokale variabelen: (leaf)
#	   p in t0
#	  pp in t1
#
verwijder:							# void verwijder(struct lijstelem **l, int g) {
			lw		t3, 0(a0)		#	// t3 = *l
			lw		t4, 0(t3)		#	// t4 = *l->info
			bne		t4, a1, elseV	#	if(*l->info == g){
			lw		t3, 4(t3)		
			sw		t3, 0(a0)		#		*l = *l->volgend;
			j		endIfV			#	}
elseV:								#	 else{
			lw		t1, 0(a0)		#		pp = *l;	
			lw		t0, 4(t1)		#		p = *l->volgend;
whV:		lw		t2, 0(t0)
			beq		t2, a1, endWV	#		while(p->info != g){
			mv		t1, t0			#			pp = p;
			lw		t0, 4(t0)		#			p = p->volgend;
			j		whV				#		}
endWV:		
			lw		t2, 4(t0)
			sw		t2, 4(t1)		#		pp->volgend = p->volgend;
endIfV:								#	}
			ret						# } 



# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#  		p: geheugen (4 bytes)
#   getal: s1
#
main:								# main() {
			la		a0, prompt
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#	getal = getint();
whM:		beqz	s1, endWM		#	while(getal > 0){
			
			# call inlassen
			# zet parameters goed
			la		a0, p			
			mv		a1, s1
			# roep inlassen op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	inlassen		#		inlassen(&p,getal);
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
			# call druklijst
			# zet parameters goed
			lw		a0, p			
			# roep druklijst op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	druklijst		#		druklijst(p);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			la		a0, promptDelete
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#	getal = getint();
whM2:		beqz	s1, endWM2		#	while(getal > 0){
			
			# call verwijder
			# zet parameters goed
			la		a0, p			
			mv		a1, s1
			# roep verwijder op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	verwijder		#		verwijder(&p,getal);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			la		a0, promptDelete
			li		a7, 4
			ecall					
			li		a7, 5
			ecall					
			mv		s1, a0			#		getal = getint();
			j		whM2				#	}
endWM2:		
			# call druklijst
			# zet parameters goed
			lw		a0, p			
			# roep druklijst op
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	druklijst		#		druklijst(p);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
					
			li		a7, 10			#
			ecall 					# }
			


####################################################################################################################
######  HIERONDER COPYPASTE UIT VORIGE OEFENING, ZONDER WIJZIGINGEN  ###############################################
####################################################################################################################


# FUNCTIE void inlassen(struct lijstelem **lst, int g)
# parameters: 		
#	 lst in a0
#	   g in a1
# lokale variabelen: (leaf)
#	   p in t0
#	  pp in t1
#	   n in t2
#
inlassen:							# void inlassen(struct lijstelem **lst, int g) {
			# zet even a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)
			li		a0, 8			
			li		a7, 9			
			ecall					
			mv		t2, a0			#	n = malloc(8);
			sw		a1, 0(t2)		#	n->info = g;
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			lw		t3, 0(a0)		#	// t0 = *lst
			beqz	t3, ifI			#	if(*lst == NULL
			lw		t4, 0(t3)		#					   // t1 = *lst-info
			ble		t4, a1, elseI	#	                || *lst->info > g) {
ifI:		sw		t3, 4(t2)		#		n->volgend = *lst;
			sw		t2, 0(a0)		#		*lst = n;
			j		endIfI			#	}
elseI:								#	 else{
			lw		t1, 0(a0)		#		pp = lst;	
			lw		t0, 4(t1)		#		p = pp->volgend;
whI:		beqz	t0, endWI		#		while( p != null
			lw		t3, 0(t0)
			bge		t3, a1, endWI	#					 	&& p->info < g){
			mv		t1, t0			#			pp = p;
			lw		t0, 4(t0)		#			p = p->volgend;
			j		whI				#		}
endWI:		
			sw		t0, 4(t2)		#		n->volgend = p;
			sw		t2, 4(t1)		#		pp->volgend = n;
			
endIfI:								#	}
			ret						# } 


# FUNCTIE void druklijst(struct lijstelem *lst)
# parameters: 		
#	 lst in a0
# lokale variabelen: (leaf)
#
druklijst:							# void druklijst(struct lijstelem *lst) {
whDL:		beqz	a0, endWDL		#	while(lst != null) {
			# backup a0
			addi	sp, sp, -4
			sw		a0, 0(sp)
			lw		a0, 0(a0)	
			li		a7, 1		
			ecall					# 		print(lst->info);
			li 		a0, 32			
			li 		a7, 11 		
			ecall					#		print(" ");
			# restore a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			lw		a0, 4(a0)		#		lst = lst->volgend; 
			j		whDL			#	}
endWDL:		li 		a0, 10			
			li 		a7, 11 		
			ecall					#	print("\n");			
			ret						# } 
