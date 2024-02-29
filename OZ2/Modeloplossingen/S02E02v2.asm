# SESSION 02 - EXCERCISE 02 - version 2

.globl 	main
.data
		f:		.align		2
				.space		400

.text
# variabelen in registers:
# 	    p: 	s1
# 	    n:	s2
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s2, a0			# 	n = getint();
		la		s1, f			#	p = f
		li		t1, 1			#									// t1 = 1
		sw		t1, 0(s1)		#	*p = 1;
		sw		t1, 4(s1)		#	*p = 1;
		addi	s1, s1, 8		#	p++;
		
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
		
		la		t2, f			#									// t2 = f = &f[0]
		slli	t3, s2, 2		#									// t3 = n*4
		add		t2, t2, t3		#									// t2 = f+n	= &f[n]			
for:	bge		s1, t2, eF		#	for(; p<f+n;    ;){
		lw		t4, -8(s1)		#									// t4 = *(p-2)
		lw		t5, -4(s1)		#									// t5 = *(p-1)
		add		t0, t4, t5		#									// t0 = *(p-1) + *(p-2)
		sw		t0, 0(s1)		#	   	*p = *(p-1) + *(p-2);
		mv 		a0, t0			#
		li		a7, 1			#
		ecall					# 	   	printint(*p);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 		print();
		addi	s1, s1, 4		#	   	p++;						// +4!
		j		for				#	}
eF:		li    	a7, 10			#
		ecall					# }
