# SESSION 03 - EXCERCISE 00 - INTRODUCTION

.globl 	main
.data
		a:		.align		2
				.space		80		# 5*4 = 20 words

.text
# variabelen in registers:	
#   i: s1	     k: s3   	
#   j: s2	    i4: s4

main:							# main() {
		la		t1, a			#									// t1 = a = &a[0]
		li		s4, 16			#	i4 = 16;
		li		s1, 4			#	i=4;
for1:	bltz	s1, endF1		#	for(    ; i>=0;    ;){
		li		s2, 3			#		j=3;	
for2:	bltz	s2, endF2		#		for(    ; j>=0;    ;){
		add		s3, s4, s2		#			k = i4 + j;
		slli	t0, s3, 2		#									// t0 = 4*k
		add		t0, t0, t1		#									// t0 = &a[k]
		li  	a7, 5			#
		ecall					#									// a0 = getint()
		sw		a0, 0(t0)		#			a[k] = getint();
		addi	s2, s2, -1		#			j--;
		j		for2			#		}
endF2:	addi	s4, s4, -4		#		i4-=4;
		addi	s1, s1, -1		#		i--;
		j		for1			#	}
endF1:	li		a7, 10			#
		ecall 					# }
