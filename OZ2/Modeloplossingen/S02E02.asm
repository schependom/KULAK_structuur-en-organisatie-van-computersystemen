# SESSION 02 - EXCERCISE 02

.globl 	main
.data
		f:		.align		2
				.space		400

.text
# variabelen in registers:
# 	    i: 	s1
# 	    n:	s2
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s2, a0			# 	n = getint();
		la		t0, f			#									// t0 = &f[0]

		li		t1, 1			#									// t1 = 1
		sw		t1, 0(t0)		#	f[0] = 1;
		sw		t1, 4(t0)		#	f[1] = 1;
		
		mv 		a0, t1			#
		li		a7, 1			#
		ecall					# 	printint(1);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	print();
		mv 		a0, t1			#
		li		a7, 1			#
		ecall					# 	printint(1);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	print();
		
		li		s1, 2			#	i = 2;			
wh1:	bge		s1, s2, eW1		#	while(i<n){
		slli	t1, s1, 2		#	   								// t1 = i*4
		add		t1, t1, t0		#	   								// t1 = &f[i]
		lw		t2, -4(t1)		#
		lw		t3, -8(t1)		#	
		add		t2, t2, t3		#
		sw		t2, 0(t1)		#	   f[i] = f[i-2] + f[i-1];
		mv 		a0, t2			#
		li		a7, 1			#
		ecall					# 	   printint(f[i]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	   print();
		addi	s1, s1, 1		#	   i++;
		j		wh1				#	}
eW1:	li    	a7, 10			#
		ecall					# }
