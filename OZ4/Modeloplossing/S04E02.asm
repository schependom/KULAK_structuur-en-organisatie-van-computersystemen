# SESSION 04 - EXCERCISE 02

.globl 	main
.data

.text

# iteratieve functie: int ggdI(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (leaf functie)
#	r: t0
# 
ggdI:								# int ggd(int a, int b){
			rem		t0, a0, a1		#	r = a % b;
wh:			beqz	t0, endW		#	while(r != 0){
			mv		a0, a1			#		a = b;
			mv		a1, t0			#		b = r;
			rem		t0, a0, a1		#		r = a % b;
			j		wh				#	}
endW:		mv		a0, a1			#	return b;
			ret						# }
			
# recursieve functie: int ggdR(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (non-leaf functie)
#	-
# 
ggd:
ggdR:							# int ggd(int a, int b){
			bne		a0, a1, else	#	if(a == b)
									#		// a0 = a
			ret						#		return a;
else:		bge		a0, a1, else2	#	else if(a<b)
			# zet parameters goed
			# backup is niet nodig, we hebben achteraf 
			# a0 en a1 niet meer nodig in deze functie!
			mv		t0, a0
			mv		a0, a1			#			// a0 = b
			mv		a1, t0			#			// a1 = a
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#			// a0 = ggd(b,a)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			ret						#			return ggd(b,a);
else2:								#		 else
			# zet parameters goed
			# backup is niet nodig, we hebben achteraf 
			# a0 en a1 niet meer nodig in deze functie!
			sub		a0, a0, a1		#			// a0 = a-b
									#			// a1 = b
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#			// a0 = ggd(a-b,b)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			ret						#			return ggd(a-b,b);
									# }



# EXTRA main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	x: s1
#	y: s2
#	z: s3
#
main:								# main() {
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	x = getint();
			li		a7, 5			#
			ecall					# 
			mv		s2, a0			#	y = getint();
			
			# call som
			# zet eerst de parameters goed
			mv		a0, s1			#	// a0 = x
			mv		a1, s2			#	// a1 = y
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#	// a0 = ggd(x,y)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			mv		s3, a0			#	z = ggd(x,y);
			
			li		a7, 1		
			ecall					# 	printint(z);
			
			li		a7, 10			#
			ecall 					# }
