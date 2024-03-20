# SESSION 05 - EXCERCISE 07

.globl 	main
.data
	p:	.space	4 # struct lijstel *p		
.text

# void verwijder(struct lijstelem *l, int g)
# argumenten
#		a0: l
#		a1: g
# lokale variabelen
#		t0: p
#		t1: pp

verwijder:							# void verwijder(struct lijstelem *l, int g) {
									#	struct lijstelem *p, **p;
		mv		t1, a0				#	pp = l;
		lw		t0, 4(a0)			#	p = l->volgend
whV:	lw		t2, 0(t0)			#	// p->info
		beq		t2, a1, eWhV		#	while (p->info != g) {
		mv		t1, t0				#		pp = p;
		lw		t0, 4(t0)			#		p = p->volgend;
		j		whV					#	}
eWhV:	lw		t0, 4(t0)
		sw		t0, 4(t1)			#	pp->volgend = p->volgend;
		ret							# }
		

# void inlassen(struct lijstelem *lst, int g)
# argumenten:
#		a0: lst
#		a1: g
# leaf functie, dus lokale variabelen in temp registers:
#		t0: p
#		t1: pp
#		t2: n

inlassen:							# void inlassen(struct lijstelem *lst, int g) {
									#	struct lijstelem *pp;
									#	struct lijstelem *p;
									#	struct lijstelem *n;
		mv		t1, a0				#	pp = lst;
		lw		t0, 4(t1)			#	p = pp->volgend;
wh:		beqz	t0, eWh				#	while( (p!=NULL) &&
		lw		t3, 0(t0)			#				// p->info
		bge		t3, a1, eWh			#				(p->info < g) ) {
		mv		t1, t0				#		pp = p;
		lw		t0, 4(t0)			#		p = p->volgend;
		j		wh					#	}
eWh:	li		a7, 9				#	// malloc type voor ecall
		li		a0, 8				#	// 8 bytes
		ecall
		mv		t2, a0				#	n = malloc(8);
		sw		a1, 0(t2)			#	n->info = g;
		sw		t0, 4(t2)			#	n->volgend = p;
		sw		t2, 4(t1)			#	pp->volgend = n;
		ret							# }
		
# void druklijst(struct lijstelem *lst)
#	parameter in a0: *lst
#	leaf functie
#		t0: kopie van *lst

druklijst:							# void druklijst(struct lijstelem *lst) {
		lw		a0, 4(a0)			#	lst = lst->volgend;
		mv		t0, a0				#	// maak een kopie van a0 want we hebben a0 nodig voor printint
whD:	beqz	t0, eWhD			#	while(lst != null) {
		li		a7, 1
		lw		a0, 0(t0)			#		// lst->info
		ecall						#		printint(lst->info);
		li		a7, 11
		li		a0, 10				#		printf("\n");
		ecall
		lw		t0, 4(t0)			#		lst = lst->volgend;
		j		whD					#	}
eWhD:	ret							# }


# main
# non-leaf
#	s1: getal
#	s2: &p

main:								# main() {
		# malloc van 8 bytes
		li		a7, 9
		li		a0, 8
		ecall
		mv		s2, a0
		# zet het resultaat van de malloc in de pointer p in het .data segment
		sw		s2, p, t0			#	p = malloc(8);
		sw		x0, 0(s2)			#	p->info = 0;
		sw		x0, 4(s2)			#	p->volgend = NULL;
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#	getal = getint();
whM:	blez	s1, eWhM			#	while(getal > 0) {
		# zet parameters goed voor function call
		lw		a0, p				#		waarde in de pointer p
		mv		a1, s1
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	inlassen			#		inlassen(p, getal);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#		getal = getint();
		j		whM					#	}
eWhM:	# zet argument goed
		lw		a0, p
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	druklijst			#	druklijst(p);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#	getal = getint();
whM2:	blez	s1, eWhM2			#	while(getal > 0) {
		# zet parameters goed voor function call
		lw		a0, p				#		waarde in de pointer p
		mv		a1, s1
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	verwijder			#		verwijder(p, getal);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#		getal = getint();
		j		whM2				#	}
eWhM2:	# zet argument goed
		lw		a0, p
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	druklijst			#	druklijst(p);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		li		a7, 10
		ecall	




		
