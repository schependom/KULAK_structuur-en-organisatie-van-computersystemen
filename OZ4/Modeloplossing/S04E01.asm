# SESSION 04 - EXCERCISE 01 - version 1: globale variabelen

.globl 	main
.data
	a:		.word		1,2,3,4,5,6,7,8,9,10
	b:		.word		10,9,8,7,6,5,4,3,2,1

.text

# functie: int som(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (leaf functie)
#	-
# 
som:								# int som(int a, int b){
			add		a0, a0, a1		#	return a+b;
			ret						# }

# main functie
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#	a: geheugen
#	b: geuheugen
#	i: s1
#	s: s2
#
main:								# main() {		
			li		s2, 0			#	s=0;
			li		s1, 0			#	i=0;
			li		s3, 10			#	// s3 = 10; // let op met bvb t0, 
									#				// want de opgeroepen functie mag deze wijzigen!
for:		bge		s1, s3, endF	#	for(   ; i<10;   ){
			
			# call som(a[i],b[i])
			# zet eerst de parameters goed
			la		t1, a			#		// t1 = a = &a[0]
			la		t2, b			#		// t2 = b = &b[0]
			slli	t3, s1, 2		#		// t3 = 4*i
			add		t1, t1, t3		#		// t1 = &a[i]
			lw		a0, 0(t1)		#		// a0 = a[i]
			add		t2, t2, t3		#		// t2 = &b[i]
			lw		a1, 0(t2)		#		// a1 = b[i]
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	som				#		// a0 = som(a[i],b[i])
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			add		s2, s2, a0		#		s += som(a[i],b[i]);
			
			addi	s1, s1, 1		#		i++;
			j		for				#	}
endF:		
			mv		a0, s2
			li		a7, 1		
			ecall					# 	printint(s);
			
			li		a7, 10			#
			ecall 					# }

