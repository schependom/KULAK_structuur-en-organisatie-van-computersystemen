# SESSION 04 - EXCERCISE 00 - BUBBLE SORT WITH FRAME POINTER

.globl 	main
.data
		a:		.word	15,20,1,6,7,14,18,2,5,13,3,4,8,19,10,11,16,12,17,9		

.text

# functie: void swap(int[] v, int k)
# PARAMETERS:
#	a0: v = &v[0]
#	a1: k
# LOKALE VARIABELEN: (leaf functie)
#	t1: temp
# 
swap:		# zet eerst de frame pointer goed
			addi	sp, sp, -4		# void swap(int[] v, int k){
			sw		fp, 0(sp)		#
			mv		fp, sp			# 
			
			slli	t0, a1, 2		#									// t0 = 4*k
			add		t0, t0, a0		#									// t0 = &v[k]
			lw		t1, 0(t0)		#	temp = v[k];
			lw		t2, 4(t0)		#
			sw		t2, 0(t0)		#	v[k] = v[k+1]
			sw		t1, 4(t0)		#	v[k+1] = temp;
			
			# herstel de frame pointer
			lw		fp,0(sp)		#
			addi	sp, sp, 4		# 
			# en keer terug
			ret						# }

# functie: void sort(int[] v, int n)
# PARAMETERS:
#	a0: v = &v[0]
#	a1: n
# LOKALE VARIABEELEN: (geen leaf functie)
#	s1: i
#	s2: j
#
sort:		# zet eerst de frame pointer goed
			addi	sp, sp, -4		# void swap(int[] v, int n){
			sw		fp, 0(sp)		#
			mv		fp, sp			# 
			# backup de saved registers voor de lokale variabelen
			addi	sp, sp, -8		#
			sw		s1, 0(sp)		#
			sw		s2, 4(sp)		#
			
			li		s1, 0			#	i=0;
for1:		bge		s1, a1, endF1	#	for(    ; i<n;    ){
			addi	s2, s1, -1		#		j=i-1;
for2:		bltz	s2, endF2		#		for(    ; j>=0 
			slli	t0, s2, 2		#														// t0 = j*4
			add		t0, t0, a0		#														// t0 = &v[j]
			lw		t1, 0(t0)		#														// t1 = v[j]
			lw		t2, 4(t0)		#														// t2 = v[j+1]
			ble		t1, t2, endF2	#		                && v[j] > v[j+1];    ){
			
			# call swap(v,j)
			# zet de eigen waarden uit a0 en a1 aan de kant!
			addi	sp, sp, -8		#
			sw		a0, 0(sp)		#
			sw		a1, 4(sp) 		#
			# zet de parameters goed voor swap
									#														// v zit al in a0!
			mv		a1, s2			#														// j in a1 steken
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	swap			#			swap(v,j);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# herstel de eigen waarden uit a0 en a1!
			lw		a0, 0(sp)		#
			lw		a1, 4(sp) 		#
			addi	sp, sp, 8		#
			
			addi	s2, s2, -1		#			j--;
			j		for2			#		}
endF2:		addi	s1, s1, 1		#		i++;
			j		for1			#	}
endF1:		
			# herstel de originele waarden van de gebruikte saved registers
			lw		s1, 0(sp)		#
			lw		s2, 4(sp)		#
			addi	sp, sp, 8		#
			# herstel de vorige frame pointer
			lw		fp,0(sp)		#
			addi	sp, sp, 4		# 
			# en keer terug
			ret						# }
			

# main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	s1: n
#
main:								# main() {
			li		s1, 20			#	n = 20;
		
			# zet waarden in saved registers ter controle achteraf
			li		s0, 100
			li		s2, 102
			li		s3, 103
			li		s4, 104
			li		s5, 105
			li		s6, 106
			li		s7, 107
			li		s8, 108
			li		s9, 109
			li		s10, 110
			li		s11, 111
					
			# call sort
			# zet eerst de parameters goed
			la		a0, a			#						// a0 = a = &a[0]
			mv		a1, s1			#						// a1 = n = 20
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	sort			#	sort(a,n);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			li		a7, 10			#
			ecall 					# }
