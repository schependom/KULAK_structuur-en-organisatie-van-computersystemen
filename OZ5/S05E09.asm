# SESSION 05 - EXCERCISE 09

.globl 	main
.data
	p:	.space	4 # struct lijstel *p		
.text

# void verwijder(struct lijstelem **l, int g)
# leaf functie
# argumenten:
#	a0: l (pointer naar een pointer die wijst naar een struct lijstelem)
#	a1: g (int)
# lokale variabelen:
#	t0: *p
#	t1: *pp

verwijder:							# void verwijder(struct lijstelem **l, int g) {
									#	struct lijstelem *p;
									# 	struct lijstelem *pp;
		lw		t2, 0(a0)			#	// *l
		lw		t3, 0(t2)			#	// *l->info (=**l.info)
		bne		t3, a1, elseV		#	if(*l->info == g) {
		lw		t4, 4(t2)			#		// *l->volgend
		sw		t4, 0(a0)			#		*l = *l->volgend;
		j		endIfV				#	} else {
elseV:	mv		t1, t2				#		pp = *l;
		lw		t4, 4(t2)			#		// *l->volgend
		mv		t0, t4				#		p = *l->volgend;
whV:	lw		t5, 0(t0)			#		// p->info
		beq		t5, a1, eWhV		#		while(p->info != g){
		mv		t1, t0				#			pp = p;
		sw		t0, 4(t0)			#			p = p->volgend;
		j		whV					#		}
eWhV:	lw		t5, 4(t0)			#		// p->volgend
		sw		t5,4(t1)			#		pp->volgend = p->volgend;
endIfV:								#	}
		ret							# }
		


# void inlassen(struct lijstelem **lst, int g)
# argumenten:
#		a0: lst
#		a1: g
# leaf functie, dus lokale variabelen in temp registers:
#		t0: p
#		t1: pp
#		t2: n
#		t5: lst

inlassen:							# void inlassen(struct lijstelem **lst, int g) {
									#	struct lijstelem *pp;
									#	struct lijstelem *p;
									#	struct lijstelem *n;
		mv		t5, a0				#	// kopie van lst (uit a0)
		li		a7, 9
		li		a0, 8
		ecall						#	// malloc van 8 bytes
		mv		t2, a0				#	n = malloc(8);
		sw		a1, 0(t2)			#	n->info = g;
		lw		t3, 0(t5)			#	// *lst
		bnez	t3, ifAnd			#	if(*lst == NULL ||
		j		if
ifAnd:	lw		t4, 0(t3)			#		// **lst = *lst->info
		ble		t4, a1, else		#		*lst->info > g) {
if:		sw		t3, 4(t2)			#			n->volgend = *lst;
		sw		t2, 0(t5)
		j		endIf				# 	} else {
else:	lw		t1, 0(t5)			#		pp = *lst;
		lw 		t0, 4(t1)			#		p = pp->volgend;
wh:		beqz	t0, eWh				#		while( (p!=NULL) &&
		lw		t3, 0(t0)			#				// p->info
		bge		t3, a1, eWh			#				(p->info < g) ) {
		mv		t1, t0				#			pp = p;
		lw		t0, 4(t0)			#			p = p->volgend;
		j		wh					#		}
eWh:	sw		t0, 4(t2)			#		n->volgend = p;
		sw		t2, 4(t1)			#		pp->volgend = n;
endIf:								#	}
		ret							# }
		
# void druklijst(struct lijstelem *lst)
#	parameter in a0: lst
#	leaf functie
#		t0: kopie van lst

druklijst:							# void druklijst(struct lijstelem *lst) {
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
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#	getal = getint();
whM:	blez	s1, eWhM			#	while(getal > 0) {
		# zet parameters goed voor function call
		la		a0, p				#		&p
		mv		a1, s1
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	inlassen			#		inlassen(&p, getal);
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
		# end call
		# inlezen 2
		li		a7, 5
		ecall
		mv		s1, a0				#	getal = getint();
whM2:	blez	s1, eWhM2			#	while(getal > 0) {
		# zet parameters goed voor function call
		la		a0, p				#		&p
		mv		a1, s1
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	verwijder			#		verwijder(&p, getal);
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
		ecall						# }





		
