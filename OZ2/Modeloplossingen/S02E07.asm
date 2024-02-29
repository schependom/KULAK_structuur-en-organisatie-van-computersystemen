# SESSION 02 - EXCERCISE 07

.globl 	main
.data
	a:			.word	2,4,6,8,10,12,14
	b:			.word	1,3,5,7,9,11,13
	c:			.align	2
				.space	160
.text
# variabelen in registers:
# 	    m:	s1
# 	    n:	s2
# 	    i:	s3
# 	    j:	s4
# 	    k:	s5
main:							# main(){
		la		t1, a			#								// t1 = &a[0] = a
		la		t2, b			#								// t2 = &b[0] = b
		la		t3, c			#								// t3 = &c[0] = c
		li		s1, 7			#	m = 7;
		li		s2, 7			#	n = 7;	
		li		s3, 0			#	i = 0;
		li		s4, 0			#	j = 0;
		li		s5, 0			#	k = 0;		
wh:		bge		s3, s2, endW
		bge		s4, s1, endW	#	while(i<n && j<m){
		slli	t4, s3, 2		#								// t4 = i*4
		add		t4, t4, t1		#								// t4 = &a[i]
		lw		t4, 0(t4)		#								// t4 = a[i]
		slli	t5, s4, 2		#								// t5 = j*4
		add		t5, t5, t2		#								// t5 = &b[j]
		lw		t5, 0(t5)		#								// t5 = b[j]
		slli	t6, s5, 2		#								// t6 = k*4
		add		t6, t6, t3		#								// t6 = &c[k]
		bge		t4, t5, else	#		if(a[i] < b[j]){
		sw		t4, 0(t6)		#			c[k] = a[i];
		addi	s3, s3, 1		#			i++;
		j		endif			#		}else{
else:	sw		t5, 0(t6)		#			c[k] = b[j];
		addi	s4, s4, 1		#			j++;
endif:							#		}
		addi	s5, s5, 1		#		k++;
		j		wh				#	}
endW:	
for:	bge		s3, s2, endF	#	for(; i<n;   ;){
		slli	t4, s3, 2		#								// t4 = i*4
		add		t4, t4, t1		#								// t4 = &a[i]
		lw		t4, 0(t4)		#								// t4 = a[i]
		slli	t6, s5, 2		#								// t6 = k*4
		add		t6, t6, t3		#								// t6 = &c[k]
		sw		t4, 0(t6)		#		c[k] = a[i];
		addi	s5, s5, 1		#		k++;
		addi	s3, s3, 1		#		i++;
		j		for				#	}
endF:
wh2:	bge		s4, s1, endW2	#	while(j<m){
		slli	t5, s4, 2		#								// t5 = j*4
		add		t5, t5, t2		#								// t5 = &b[j]
		lw		t5, 0(t5)		#								// t5 = b[j]
		slli	t6, s5, 2		#								// t6 = k*4
		add		t6, t6, t3		#								// t6 = &c[k]
		sw		t5, 0(t6)		#		c[k] = b[j];
		addi	s5, s5, 1		#		k++;
		addi	s4, s4, 1		#		j++;
		j		wh2				#	}
endW2:					
		li		s5, 0			#	k = 0;
		add		t0, s1, s2		#								// t0 = n+m
for2:	bge		s5, t0, endF2	#	for(    ; k<n+m;    ;){
		slli	t6, s5, 2		#								// t6 = k*4
		add		t6, t6, t3		#								// t6 = &c[k]
		lw		a0, 0(t6)		#								// a0 = c[k]
		li		a7, 1			#
		ecall					# 	   		printint(c[k]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	  		print();
		addi	s5, s5, 1		#		k++;
		j		for2			#	}
endF2:														
		li    	a7, 10			#
		ecall					# }