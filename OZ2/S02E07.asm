# SESSION 02 - EXCERCISE 7

.globl 	main
.data
		a:		.align		2
				.word		2, 4, 6, 8, 10, 12, 14
		b:		.align
				.word		1, 3, 5, 7, 9, 11, 13
		n:		.word 		7
		m:		.word		7
		c:		.align		2
				.space		160
		
.text

# s0: &c
# s1: i
# s2: j
# s3: k
# s4: n
# s5: m
# s6: $a
# s7: $b

main:							# main () {
		li		s1, 0			#	i = 0;
		li		s2, 0			#	j = 0;
		li		s3, 0			#	k = 0;
		lw		s4, n
		lw		s5, m
		la		s6, a
		la		s7, b
wh:		bge		s1, s4, eWh		#	while (i<n
		bge		s2, s5, eWh		#				&& j<m) {
		slli	t0, s3, 2		#		// 4k
		add		t0, t0, s0		#		// &c[k]
		slli	t1, s1, 2		#		// 4i
		add		t1, t1, s6		#		// &a[i]
		slli	t2, s2, 2		#		// 4j
		add		t2, t2, s7		#		// &b[j]
		lw		t3, 0(t1)		#		// a[i]
		lw		t4, 0(t2)		#		// b[i]
		bge		t3, t4, else	#		if (a[i] < b[j]) {
		sw		t3, 0(t0)		#			c[k] = a[i];
		addi	s1, s1, 1		#			i++;
		j		endif			#		}
else:	sw		t4, 0(t0)		#		else {
		addi	s2, s2, 1		#			c[k= = b[j++];
endif:							#		}
		addi	s3, s3, 1		#		k++
