# SESSION 02 - EXCERCISE 05

.globl 	main
.data
		p:		.align		2
				.word		2, 3
				.space		392
		
.text

# s0: ap
# s1: kp
# s2: i
# s3: &p

main:							# main () {
		la		s3, p			#	// adres van p in s3
		li		t0, 2			#	// 2
		sw		t0, 0(s3)		#	p[0] = 2;
		addi	t0, t0, 1		#	// 3
		sw		t0, 4(s3)		#	p[1] = 3;
		li		s0, 2			#	ap = 2;
		li		s1, 4			#	kp = 4;
		li		t0, 200			#	// 200
for:	bge		s1, t0, eFor	#	for( ; kp<200; kp++) {
		slli	t1, s0, 2		#		// 4*ap
		add		t1, s3, t1		#		// &p[ap]
		sw		s1, 0(t1)		#		p[ap] = kp;
		li		s2, 0			#		i=0;
wh:		slli	t2, s2, 2		#		// 4i
		add		t2, t2, s3		#		// 4i+&p = &p[i]
		lw		t2, 0(t2)		#		// p[i]
		rem		t2, s1, t2		#		// kp % p[i]
		beqz	t2, eWh			#		while( (kp % p[i]) != 0) {
		addi	s2, s2, 1		#			i++;
		j		wh				#		}
eWh:	bne		s2, s0, endIf	#		if (i==ap) {
		addi	s0, s0, 1		#			ap++;
endIf:	addi	s1, s1, 1		#		}
		j		for				#		// kp++;
eFor:	li		s2, 0			#	}		
for2:	ble		s2, s0, eFor2	#	for(i=0; i<ap; i++) {
		slli	t2, s2, 2		#		// 4i
		add		t2, t2, s3
		sw		a0, 0(t2)
		li		a7, 1			#		printint(p[i]);
		ecall		
		addi	s2, s2, 1		#		// i++;
		j		for2			#	}	
eFor2:	li		a7, 10			# }
		ecall
