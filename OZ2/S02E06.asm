# SESSION 02 - EXCERCISE 06

.globl 	main
.data
		ftab:	.align		2
				.space		144		# 36 * 4 = 144
		
.text

# s0: t
# s1: i
# s2: &ftab

main:							# main () {
		li		s0, -15			#	t=-15;
		li		t0, 20
		la		s2, ftab
for1:	bgt		s0, t0, eFor1	#	for(;t<=20;t++) {
		slli	t1, s0, 2		#		// 4t
		add		t1, t1, s2		#		// ftab[t]
		sw		x0, 60(t1)		#		ftab[t+15] = 0;
		addi	s0, s0, 1		#	}
		j		for1		
eFor1:	li		s1, 0			#	i=0;
		li		t0, 31
for2:	bge		s1, t0, eFor2	#	for(;i<31;i++) {
		li		a7, 5
		ecall
		mv		s0, a0			#		t = getint();
		slli	t1, s0, 2		#		// 4t
		add		t1, t1, s2		#		// &ftab[t+15]
		lw		t2, 60(t1)		#		// ftab[t+15]
		addi	t2, t2, 1
		sw		t2, 60(t1)		#		ftab[t+15]++;
		addi	s1, s1, 1		#		// i++
		j		for2			#	}
eFor2:	li		s0, -15			#	t=-15;
		li		t0, 20
for3:	bgt		s0, t0, eFor3	#	for(;t<=20;t++) {
		slli	t1, s0, 2		#		// 4t
		add		t1, t1, s2
		lw		t2, 60(t1)		#		// ftab[t+15]
		beqz	t2, endif		#		if(ftab[t+15] != 0)
		li		a7, 1
		mv		a0, s0
		ecall					#			printint(t);
		li		a7, 11
		li		a0, 32
		ecall					#			// print space
		li		a7, 1
		mv		a0, t2
		ecall					#			printint(ftab[t+15]);
		li		a7, 11
		li		a0, 10
		ecall					#			// print end of line
endif:	addi	s0, s0, 1		#	// t++;
		j		for3
eFor3:	li		a7, 10			# }
		ecall
