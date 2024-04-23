# SESSION 05 - EXCERCISE 05

.globl 	main
.data
		promptAantal:		.string		"Aantal coordinaten: "
		promptX:			.string		"geef de x-coordinaat: "
		promptY:			.string		"geef de y-coordinaat: "
		corij:				.align 		2
							.space		800
		
.text


# int cogr(struct Tco co1, struct Tco co2)
#	ARGUMENTEN
#		co1: 8(fp) -> 12(fp)
#		c02: 16(sp) -> 20(sp)
# 	LOKALE VARIABELEN
#		in temp registers want leaf

cogr:									# int cogr(struct Tco co1, struct Tco co2) {

		# backup fp
		addi	sp, sp, -4
		sw		fp, 0(sp)
		mv		fp, sp

		lw 	t0, 8(fp)
		mul	t0, t0, t0					#		// co1.x * co1.x
		lw	t1, 12(fp)
		mul	t1, t1, t1					#		// co1.y * co1.y
		add	t0, t0, t1					#		// vorige twee opgeteld in t0
		
		lw	t1, 16(fp)
		mul	t1, t1, t1					#		// co2.x * co2.x
		lw	t2, 20(fp)
		mul	t2, t2, t2					#		// co2.y * co2.y
		add	t1, t1, t2					#		// vorige twee opgeteld t1
		
		bge t0, t1, else				#		if (co1.x * co1.x + co1.y * co1.y >
		li	a0, 1						#				co2.x * co2.x + co2.y * co2.y) {
										#			return (1);
		j 	endif
else:	li	a0, 0						#		} else {
										#			return (0);
endif:	# restore fp					#		}
		lw		fp, 0(sp)
		addi	sp, sp, 4
		ret								# }
								
# void leesco(struct Tco *co)
#	ARGUMENTEN
#		co: a0
leesco:									# void leesco(struct Tco *co) {
		# maak backup van a0
		addi	sp, sp, -4
		sw		a0, 0(sp)
		
		li		a7, 4
		la		a0, promptX
		ecall
	
		li		a7, 5
		ecall
		mv		t0, a0					#	// getint()
		
		li		a7, 4
		la		a0, promptY
		ecall
		
		li		a7, 5
		ecall
		mv		t1, a0					#	// getint()
		
		# restore a0 na getint()
		lw		a0, 0(sp)
		addi	sp, sp, 4
		
		sw		t0, 0(a0)				#	co->x=getint();
		sw		t1, 4(a0)				#	co->y=getint();
		
		ret								# }
		
		
# void schrijfco(struct Tco co)
#	ARGUMENTEN
#		co: 8(fp)->12(fp)

schrijfco:

		# backup frame pointer
		addi	sp, sp, -4
		sw		fp, 0(sp)
		mv		fp, sp

		lw		a0, 8(fp)
		li		a7, 1
		ecall
		
		li		a7, 11
		li		a0, 32
		ecall
		
		lw		a0, 12(fp)
		li		a7, 1
		ecall
		
		li		a7, 11
		li		a0, 10
		ecall
		
		# restore frame pointer
		lw		fp, 0(sp)
		addi	sp, sp, 4
		
		ret
		
		
# void leescorij(struct Tco cr[], int n)
#	PARAMETERS
#		cr: lijst dus adres!! -> a0
#		n:	int -> a1
#	LOKALE VARIABELEN (geen leaf functie dus in saved registers -> backup!!)
#		s1: i

leescorij:								# void leescorij(struct Tco cr[], int n) {

		# backup saved registers
		addi	sp, sp, -4
		sw		s1, 0(sp)
		
		li		s1, 0					#	int i = 0;
		
for:	bge		s1, a1, eFor			#	for( ; i<n; ) {
		
		# maak backup van a0 en a1
		addi	sp, sp, -8
		sw		a0, 0(sp)
		sw		a1, 4(sp)
		
		slli	t0, s1, 3				#		// 8i
		add		a0, t0, a0				#		// &cr[i]
		
		# roep leesco aan
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	leesco					#		leesco(&cr[i]);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# einde call
		
		# restore a0 en a1
		lw		a0, 0(sp)
		lw		a1, 4(sp)
		addi	sp, sp, 8
		
		addi	s1, s1, 1				#		i++;
		j		for						#	}
		
eFor:
		# restore saved registers
		lw		s1, 0(sp)
		addi	sp, sp, 4
		
		ret								# }
		
		
# void vindmaxco(struct Tco cr[], struct Tco *maxco, int n)
# 	PARAMETERS
#		a0: &cr
#		a1: maxco (adres naar struct)
#		a2: n
#	GEEN ! LEAF FUNCTIE DUS LOKALE VARIABELEN IN SAVED REGS (backup!!)
#		s1: i
#		s2: max
#		s3: resultaat functieoproep
		
vindmaxco:								# void vindmaxco(struct Tco cr[], struct Tco *maxco, int n) {

		# backup saved registers
		addi	sp, sp, -12
		sw		s1, 0(sp)
		sw		s2, 4(sp)
		sw		s3, 8(sp)

		li		s1, 1					#	int i = 1;
		li		s2, 0					#	int max = 0;
		
forMax:	bge		s1, a2, endForMax			#	for( ; i<n; ) {

		# zet twee structs als argumenten op de stack in volgorde van signatuur
		addi	sp, sp, -16
		
		slli	t0, s1, 3				#		// 8i
		add		t0, a0, t0				#		// &cr[i]
		slli	t1, s2, 3				#		// 8max
		add		t1, a0, t1				#		// &cr[max]
		
		# zet cr[i] bovenaan op de stack
		lw		t2, 0(t0)				#		// *cr[i].x
		sw		t2, 0(sp)				
		lw		t2, 4(t0)				#		// *cr[i].y
		sw		t2, 4(sp)
		# zet cr[max] onderaan op de stack
		lw		t2, 0(t1)				#		// *cr[max].x
		sw		t2, 8(sp)
		lw		t2, 4(t1)				#		// *cr[max].y
		sw		t2, 12(sp)
		
		# zet a0 - a2 (!) aan de kant voor de functie-oproep!
		addi	sp, sp, -12
		sw		a0, 0(sp)
		sw		a1,	4(sp)
		sw		a2, 8(sp)
		
		# roep cogr aan
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	cogr					#		// cogr(cr[i],cr[max])
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# einde call
		
		# verplaats resultaat naar s3
		mv		s3, a0
		
		# restore a0 - a2
		lw		a0, 0(sp)
		lw		a1, 4(sp)
		lw		a2, 8(sp)
		addi	sp, sp, 12
		
		# geef plaats op de stack van spilling parameters terug vrij
		addi	sp, sp, 16
		
		li		t0, 1
		bne		s3, t0, endIfMax		#		if (cogr(cr[i], cr[max]) == 1) {
		mv		s2, s1					#			max = i;
endIfMax:								#		}
		addi	s1, s1, 1				#		i++;
		j		forMax					#	}
endForMax:		
		slli	t0, s2, 3				#	// 8max
		add		t0, t0, a0				#	// &cr[max]
		lw		t1, 0(t0)				#	// *cr[max].x
		sw		t1, 0(a1)
		lw		t1, 4(t0)				#	// *cr[max].y
		sw		t1, 4(a1)
		
		# restore saved registers
		lw		s1, 0(sp)
		lw		s2, 4(sp)
		lw		s3, 8(sp)
		addi	sp, sp, 12
		
		ret								# }
		
	
main:

		# backup fp
		addi	sp, sp, -4
		sw		fp, 0(sp)
		mv		fp, sp
		
		# lokale variabele maxco -8(fp)->-4(fp)
		addi	sp, sp, -8

		# prompt tekst aantal
		li		a7, 4
		la		a0, promptAantal
		ecall
		
		# prompt aantal
		li		a7, 5
		ecall
		mv		s1, a0
		
		# zet parameters goed voor leescorij
		mv		a1, s1		# resultaat in a1
		la		a0, corij
		
		# call leescorij
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	leescorij
		lw		ra, 0(sp)
		addi	sp, sp, 4
		
		# zet parameters goed vindmaxco
		la		a0, corij
		addi	a1, fp, -8	# // &maxco
		mv		a2, s1
		
		# call vindmaxco
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	vindmaxco
		lw		ra, 0(sp)
		addi	sp, sp, 4
		
		# zet de volledige (!) maxco struct op de stack
		addi	sp, sp, -8
		lw		t0, -8(fp)
		sw		t0, 0(sp)
		lw		t0, -4(fp)
		sw		t0, 4(sp)
		
		# functieoproep schrijfco
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	schrijfco
		lw		ra, 0(sp)
		addi	sp, sp, 4
		
		# maak plaats op de stack voor parameter struct terug vrij
		addi	sp, sp, 8
		
		# maak plaats van lokale variabele terug vrij
		addi	sp, sp, 8
		
		# restore fp
		lw		fp, 0(sp)
		addi	sp, sp, 4
		
		li		a7, 10
		ecall
		
