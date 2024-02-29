# SESSION 02 - EXCERCISE 05

.globl 	main
.data
		p:		.align		2
				.space		400

.text
# variabelen in registers:
# 	   ap:	s1
# 	   kp:	s2
# 	    i:	s3
main:							# main(){
		la		t1, p			#								// t1 = &p[0] = p
		li		t2, 200			#								// t2 = 200

		li		t0, 2
		sw		t0, 0(t1)		#	p[0] = 2;		
		li		t0, 3
		sw		t0, 4(t1)		#	p[1] = 2;		

		li		s1, 2			#	ap = 0;
		li		s2, 4			#	kp = 4;
for:	bge		s2, t2, endF	#	for(    ; kp<200;    ;){
		slli	t0, s1, 2		#								// t0 = ap*4
		add		t0, t0, t1		#								// t0 = &p[ap]
		sw		s2, 0(t0)		#		p[ap] = kp;
		li		s3, 0			#		i=0;
wh:		slli	t0, s3, 2		#								// t0 = i*4
		add		t0, t0, t1		#								// t0 = &p[i]
		lw		t0, 0(t0)		#								// t0 = p[i]
		rem		t3, s2, t0		#								// t3 = kp % p[i]
		beqz	t3, endW		#		while( (kp % p[i]) != 0){
		addi	s3, s3, 1		#			i++;
		j		wh				#		}
endW:	bne		s3, s1, endif	#		if(i == ap)
		addi	s1, s1, 1		#			ap++;
endif:	addi	s2, s2, 1		#		kp++;
		j		for				#	}
endF:	
		li		s3, 0			#	i=0;
for2:	bge		s3, s1, endF2	#	for(    ; i<ap;    ;){
		slli	t0, s3, 2		#								// t0 = i*4
		add		t0, t0, t1		#								// t0 = &p[i]
		lw		a0, 0(t0)		#								// a0 = p[i]
		li		a7, 1			#
		ecall					# 	   	printint(p[i]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	   	print();
		addi	s3, s3, 1		#		i++;
		j		for2			#	}
endF2:
		li    	a7, 10			#
		ecall					# }
