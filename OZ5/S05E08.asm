# SESSION 05 - EXCERCISE 08

.globl 	main
.data
	p:	.space	4 # struct lijstel *p		
.text

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
		li		a7, 10
		ecall						# }





		
