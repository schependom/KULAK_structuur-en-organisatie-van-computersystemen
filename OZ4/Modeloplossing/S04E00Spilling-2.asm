# SESSION 04 - EXCERCISE 00 - SPILLING - 2

.globl 	main
.data
	rij:	.align	2
			.space	400
.text

# functie: int func(int a, int b, int c, int d, int e,
# 					int f, int g, int h, int i, int j)
# PARAMETERS:
#	a: a0
#	b: a1
#	c: a2
#	d: a3
#	e: a4
#	f: a5
#	g: a6
#	h: a7
#	i: 8(fp)
#	j: 12(fp)
# LOKALE VARIABELEN: (geen leaf functie wegens '//...')
#	x: s1
#	r: -40(fp) -> -4(fp)
# 	s: -80(fp) -> -44(fp)
#
func:								# int func(...){
			# zet eerst de frame pointer goed
			addi	sp, sp, -4		# 
			sw		fp, 0(sp)		#
			mv		fp, sp			# 
			
			# maak plaats voor de lokale variabelen op de stack
			addi	sp, sp, -80	
			
			# backup de saved registers voor de lokale variabelen
			addi	sp, sp, -4		#
			sw		s1, 0(sp)		#
			
			# ...					#	// ...
			
			add		s1, a0, a1
			add		s1, s1, a2
			add		s1, s1, a3
			add		s1, s1, a4
			add		s1, s1, a5
			add		s1, s1, a6
			add		s1, s1, a7
			lw		t0, 8(fp)
			add		s1, s1, t0
			lw		t0, 12(fp)
			add		s1, s1, t0		# 	x = a+b+c+d+e+f+g+h+i+j;
			
			mv		a0, s1			#  	return x;
			
			# herstel de originele waarden van de gebruikte saved registers
			lw		s1, 0(sp)		#
			addi	sp, sp, 4		#
			
			# geef de plaats van r en s terug vrij
			addi	sp, sp, 80
			
			# herstel de frame pointer
			lw		fp,0(sp)		#
			addi	sp, sp, 4		# 
			
			ret						# }



# MAIN functie
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#     a: s1
#	rij: geheugen
#
main:								# main() {
			li		s1, 1			#	a = 1;
			
			# ...					#	// ...
	
			# call func(...)
			# zet de parameters goed voor func
			mv		a0, s1			#														
			mv		a1, s1			#														
			mv		a2, s1			#														
			mv		a3, s1			#														
			mv		a4, s1			#														
			mv		a5, s1			#														
			mv		a6, s1			#														
			mv		a7, s1			#														
			addi	sp, sp, -8		#
			sw		s1, 0(sp)		# 	// de 9e parameter
			sw		s1, 4(sp)		#	// de 10e parameter
			
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	func			#	// a0 = func(a,a,a,a,a,a,a,a,a,a);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# gooi de extra parameters die nog op de stapel staan eraf!
			addi	sp, sp, 8
			
			
			li		a7, 1			#
			ecall					#   // printint(a0);
			
			# ...					#	// ...
			
			li		a7, 10			#
			ecall 					# }
