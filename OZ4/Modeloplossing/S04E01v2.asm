# SESSION 04 - EXCERCISE 01 - version 2 - lokale variabelen

.globl 	main
.data

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
# LOKALE VARIABELEN: (geen leaf functie)
#	a: -40(fp) -> -4(fp)
#	b: -80(fp) -> -44(fp)
#	i: s1
#	s: s2
#
main:								# main() {
			# zet eerst de frame pointer goed
			addi	sp, sp, -4		 
			sw		fp, 0(sp)		
			mv		fp, sp			 
			
			# maak plaats voor de lokale variabelen op de stack
			addi	sp, sp, -80	
			
			# vul a en b op
			li		t0, 1
			sw		t0, -40(fp)
			sw		t0, -44(fp)
			li		t0, 2
			sw		t0, -36(fp)
			sw		t0, -48(fp)
			li		t0, 3
			sw		t0, -32(fp)
			sw		t0, -52(fp)
			li		t0, 4
			sw		t0, -28(fp)
			sw		t0, -56(fp)
			li		t0, 5
			sw		t0, -24(fp)
			sw		t0, -60(fp)
			li		t0, 6
			sw		t0, -20(fp)
			sw		t0, -64(fp)
			li		t0, 7
			sw		t0, -16(fp)
			sw		t0, -68(fp)
			li		t0, 8
			sw		t0, -12(fp)
			sw		t0, -72(fp)
			li		t0, 9
			sw		t0, -8(fp)
			sw		t0, -76(fp)
			li		t0, 10
			sw		t0, -4(fp)		#	a = {1,2,3,4,5,6,7,8,9,10};
			sw		t0, -80(fp)		#	b = {10,9,8,7,6,5,4,3,2,1};
			
			li		s2, 0			#	s=0;
			li		s1, 0			#	i=0;
			li		s3, 10			#	// s3 = 10; // let op met bvb t0, 
									#				// want de opgeroepen functie mag deze wijzigen!
for:		bge		s1, s3, endF	#	for(   ; i<10;   ){
			
			# call som(a[i],b[i])
			# zet eerst de parameters goed
			mv		t0, fp			#		// t0 = fp
			addi	t1, t0, -40		#		// t1 = -40(fp) = a = &a[0]
			addi	t2, t0, -80		#		// t2 = -80(fp) = b = &b[0]
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
			
			# geef de plaats van f terug vrij
			addi	sp, sp, 400
			
			# herstel de frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4	
			
			li		a7, 10			#
			ecall 					# }
