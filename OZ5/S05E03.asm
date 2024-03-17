# SESSION 05 - EXCERCISE 02 

.globl 	main
.data
		promptTeller:		.string		"      geef de teller: "
		promptNoemer:		.string		"      geef de noemer: "
		promptGeheelDeel:	.string		"geef het geheel deel: "
		rij:				.align		2
							.space		60
		
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
			
# int isgelijk(struct rationaalgetal a, struct rationaalgetal b)
# non-leaf functie
# PARAMETERS
#		a: stack: 8(fp) -> 16(fp)
#		b: stack: 20(fp) -> 28(fp)
isgelijk:							# int isgelijk(struct rationaalgetal a, struct rationaalgetal b) {
			# backup van de sp
			addi	sp, sp, -4
			sw		fp, 0(sp)
			mv		fp, sp
			
			# zet &a in a0
			mv		a0, fp
			addi	a0, a0, 8
			
			# zet struct a op de stack om mee te geven met vereenvoudig
			addi	sp, sp, -12
			lw		t0, 8(fp)
			sw		t0, 0(sp)		#	// a.t
			lw		t0, 12(fp)
			sw		t0, 4(sp)		#	// a.n
			lw		t0, 16(fp)
			sw		t0, 8(sp)		#	// a.gd
			
			# call vereenvoudig
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	vereenvoudig	#	vereenvoudig(a,&a);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# geef plaats van argument struct a op de stack terug vrij
			addi	sp, sp, 12
			
			# zet &b in a0
			mv		a0, fp
			addi	a0, a0, 20
			
			# zet struct b op de stack om mee te geven met vereenvoudig
			addi	sp, sp, -12
			lw		t0, 20(fp)
			sw		t0, 0(sp)		#	// b.t
			lw		t0, 24(fp)
			sw		t0, 4(sp)		#	// b.n
			lw		t0, 28(fp)
			sw		t0, 8(sp)		#	// b.gd
			
			# call vereenvoudig
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	vereenvoudig	#	vereenvoudig(b,&b);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# geef plaats van argument struct b op de stack terug vrij
			addi	sp, sp, 12
			
			# zet alles in temp regs
			lw		t0, 8(fp)
			lw		t1, 12(fp)
			lw		t2, 16(fp)
			lw		t3, 20(fp)
			lw		t4, 24(fp)
			lw		t5, 28(fp)
			
			bne		t0, t3, else	#	if(a.teller == b.teller && a.noemer == b.noemer && a.gehdeel == b.gehdeel)
			bne		t1, t4, else	
			bne		t2, t5, else
			li		a0, 1
			# restore fp
			lw		fp, 0(sp)
			addi	sp, sp, 4
			ret						#		return 1;
			
else:		li		a0, 0			#	else
			# restore fp
			lw		fp, 0(sp)
			addi	sp, sp, 4
			ret						#		return 0;
			
# FUNCTIE void drukrij(struct rationaalgetal *r, int n)
# leaf!
# ARGUMENTEN:
#	*r: a0
#	n:	a1
# LOKALE VARIABELE:
#	i:	s1
drukrij:							# void drukrij(struct rationaalgetal *r, int n) {
			li		s1, 1			#	int i = 0;
			
			# maak backup van a0
			addi	sp, sp, -4
			sw		a0, 0(sp)
			
forD:		bge		s1, a1, eForD	#	for( ; i<n; ) {
			# zet parameter goed
			slli	t0, s1, 2		#		// 4*i
			add		a0, a0, t0		#		// &(r+i)
			lw		a0, 0(a0)		#		// *(r+i)
			# roep functie aan
			addi	sp, sp, 4
			sw		ra, 0(sp)
			call	drukR			#		drukrationaal(*(r+i));
			lw		ra, 0(sp)
			addi	sp, sp, -4
			# restore de waarde van a0
			lw		a0, 0(sp)
	
			addi	s1, s1, 1		#		i++;
			j		forD			#	}
eForD:		# geef plaats op de stack terug vrij van a0
			addi	sp, sp, 4
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
#	i: s1
#	j: s2
#  in: s3
# 	5: s4
# adres van rij in s5
main:								# main() {
			# backup frame pointer
			addi	sp, sp, -4	
			sw		fp, 0(sp)		
			mv		fp, sp		
									#	int j;
			# lokale variabele q
			addi	sp, sp, -12		#	struct rationaalgetal q;
			
			li		s3, 0			#	in=0;
			
			# zet het argument voor leesrationaal goed
			la		a0, rij			#	// &(rij[in]) = &(rij[0])
			# call leesrationaal
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	leesR			#	leesrationaal(&(rij[in]));
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			li		s1, 1			#	int i=1;
			li		s4, 100			#	// 100 in s4
			la		s5, rij
forM:		bge		s1, s4, eForM	#	for( ; i<100; ) {
			# zet param goed
			addi	a0, fp, -12		#		// &q
			# call
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	leesR			#		leesrationaal(&q);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# zet &(rij[++in]) in a0
			addi	s3, s3, 1		#		in++;
			slli	a0, s3, 2		#		4*in
			add		a0, a0, s5		#		// &(rij[in]) (in is al verhoogd!)
			# zet q op de stack
			addi	sp, sp, -12
			lw		t0, -12(fp)
			sw		t0, 0(sp)		#		// q.t
			lw		t0, -8(fp)
			sw		t0, 4(sp)		#		// q.n
			lw		t0, -4(fp)
			sw		t0, 8(sp)		#		// q.gd
			
			# call vereenvoudig
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	vereenvoudig	#		vereenvoudig(q,&(rij[++in]));
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# geef plaats van argument q terug vrij op de stack
			addi	sp, sp, 12
			
			li		s2, 1			#		j = 0;
			
			slli	t0, s2, 4
			slli	t1, s3, 4
			# zet argumenten goed voor isgelijk
			add		a0, s5, t0		#		&rij[j]
			lw		a0, 0(a0)		#		rij[j]
			add		a1, s5, t1		#		&rij[in]
			lw		a1,	0(a1)		#		rij[in]
			
			# call isgelijk
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	isgelijk		#		// isgelijk(rij[j],rij[in])
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# het resultaat van isgelijk zit in a0!
whM:		beqz	a0, eWhM		#		while(!isgelijk(rij[j],rij[in]) {
			addi	s2, s2, 1		#			j++;
			j		whM				#		}
eWhM:		beq		s2, s3, eIf		#		if (j != in)
			addi	s3, s3, -1		#			in--;
eIf:		addi	s1, s1, 1		#		i++;
			j		forM			#	}
eForM:		addi	s3, s3, 1		#	in++;
			# zet argumenten goed
			la		a0, rij
			mv		a1, s3
			# call
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	drukrij			#	drukrij(rij, in); 	// (in is al verhoogd!)
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# herstel frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		
			
			li		a7, 10			#
			ecall 					# }
