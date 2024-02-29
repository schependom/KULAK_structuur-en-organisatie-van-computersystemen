# SESSION 02 - EXCERCISE 01

.globl 	main
.data
		a:		.align		2
				.space		80
		b:		.align 		2		# .align not strictly necessary, the above is still word-aligned
				.space		80			

.text
# variabelen in registers:
# 	    n: 	s1
# 	    i:	s2
#    inpr:	s3
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	n = getint();
		li		s2, 0			#	i=0;
		la		t1, a			#									// t1 = &a[0]
wh1:	bge		s2, s1, eW1		#	while(i<n){
		li		a7, 5			#
		ecall					#
		slli	t0, s2, 2		#	   								// t0 = 4*i
		add		t0, t0, t1		#	   								// t0 = &a[i]
		sw		a0, 0(t0)		# 	   a[i] = getint();
		addi	s2, s2, 1		#	   i++;
		j		wh1				#	}
eW1:	mv		s2, zero		#	i=0;
		la		t2, b			#									// t2 = &b[0]
wh2:	bge		s2, s1, eW2		#	while(i<n){
		li		a7, 5			#
		ecall					#
		slli	t0, s2, 2		#	  								// t0 = 4*i
		add		t0, t0, t2		#	   								// t0 = &b[i]
		sw		a0, 0(t0)		# 	   b[i] = getint();
		addi	s2, s2, 1		#	   i++;
		j		wh2				#	}
eW2:	mv		s2, zero		#	i=0;
		mv		s3, zero		#	inpr = 0;
wh3:	bge		s2, s1, eW3		#	while(i<n){
		slli	t0, s2, 2		#	   								// t0 = 4*i
		add		t3, t1, t0		#	   								// t3 = &a[i]
		add		t4, t2, t0		#	   								// t4 = &b[i]
		lw		t3, 0(t3)		#	   								// t3 = a[i]
		lw		t4, 0(t4)		#	  								// t4 = b[i]
		mul		t0, t3, t4		#	   								// t0 = a[i]*b[i]
		add		s3, s3, t0		#	   inpr = inpr + a[i]*b[i];
		addi	s2, s2, 1		#	   i++;
		j		wh3				#	}
eW3:	mv 		a0, s3			#
		li		a7, 1			#
		ecall					# 	printint(inpr);
		li    	a7, 10			#
		ecall					# }
