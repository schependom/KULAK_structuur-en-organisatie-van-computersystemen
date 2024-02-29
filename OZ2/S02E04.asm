# SESSION 02 - EXCERCISE 04

.globl 	main
.data
		r:		.align		2
				.space		400		# r is maximaal 100, 100*4bytes = 100 * 1 woord = 400 bytes
		br:		.align		2
				.space		400
		
.text

# s0: getal
# s1: ar
# s2: abr
# s3: i
# s4: j
# s5: &r[0]
# s6: &br[0]

main:							# main () {
								#	/* inlezen van de gegevens (de rij wordt afgesloten met -1) */
		li		s1, 0			#	ar = 0;
		li 		a7, 5
		ecall
		mv 		s0, a0			#	getal = getint();
		li		t0, -1			#	// waarde -1 voor de check in de while loop
		la		s5, r			#	// &r[0]	(adres)
		la		s6, br			#	// &br[0]	(adres)
wh1:	beq		s0, t0, eWh1	#	while (getal != -1) {
		slli	t1, s1, 2		#		// 4*ar
		add		t1, s5, t1		#		// &r[ar]	(adres)
		sw		s0, 0(t1)		#		r[ar] = getal;
		addi	s1, s1, 1		#		ar++;
		li 		a7, 5
		ecall
		mv 		s0, a0			#		getal = getint();
		j		wh1				#	}
								#	/* opbouwen van een nieuwe rij br zonder dubbels /*
eWh1:	lw		t1, 0(s5)		#	// r[0] in t1
		sw		t1, 0(s6)		#	br[0] = r[0];
		li		s2, 1			#	abr = 1;
		li		s3, 1			#	i = 1;
for:	bge		s3, s1, eFor	#	for(; i<ar; ) {
		slli	t1, s2, 2		#		// 4*abr
		add		t1, s6, t1		#		// &br + 4*abr
		slli	t2, s3, 2		#		// 4*i
		add		t2, s5, t2		#		// 4*i + &r
		lw		t3, 0(t2)		#		// r[i]
		sw		t3, 0(t1)		#		br[abr] = r[i];
		li		s4, 0			#		j=0;
wh2:							#		while(br[j++] != r[i]);			// we doen hier eig j++
		slli	t4, s4, 2		#		// 4*j
		add		t4, s6, t4		#		// &br + 4j
		lw		t4, 0(t4)		#		// effectieve waarde van br[j] 
		addi	s4, s4, 1
		bne		t4, t3, wh2
		addi	t5, s2, 1		#		// abr + 1
		bne		s4, t5, endif	#		if (j==abr+1) {
		addi	s2, s2, 1		#			abr++;
endif:	addi	s3, s3, 1		#		} i++;
		j		for				#	}
eFor:	li		s4, 0			#	j=0;
for2:	bge		s4, s2, eFor2	#	for(; j<abr; ) {
		slli	t4, s4, 2		#		// 4*j
		add		t4, s6, t4		#		// &br + 4j
		lw		a0, 0(t4)		#		// br[j]
		li		a7, 1
		ecall					#		printint(br[j]);
		li		a7, 11
		li		a0, 10			#		printstr("\n");
		ecall
		addi	s4, s4, 1		#		j++;
		j		for2			#	}
eFor2:	
		li		a7, 10			# }
		ecall
