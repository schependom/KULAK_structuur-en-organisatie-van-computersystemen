# EXAMEN - EXCERCISE 02 

########################################################################
########################################################################
############ 
############ NAAM STUDENT: Van Schependom Vincent
############
########################################################################
########################################################################

.globl 	main
.data
		p: 	.word 	0
		q: 	.align	2
			.word	9,2,8
				
.text


# functie int g(struct crd x, int y)
# PARAMETERS
#	x: (struct card)	op de stack: 8(fp)->24(fp)
#	y: (int)			in a0
#	
# LOKALE VARIABELEN (leaf functie dus in temp registers)
#	we gebruiken temp registers voor de tussentijdse resultaten,
#	maar er zijn niet echt variabelen.
# RESULTAAT
#	in a0
#
g:									# int g(struct crd x, int y){

			# backup fp
			addi	sp, sp, -4
			sw		fp, 0(sp)
			mv		fp, sp
			
			# ...					#	... (a0 en a1 worden hier bewaard)
			
			# x.link zit op 12(fp) en bevat &lnk = &lnk.info
			lw		t0, 12(fp)		# // adres van lnk
			lw		t1, 0(t0)		# // *(x.lnk).info
			
			add		a0, t1, a0		# // x.lnk->info + y
			
			# restore fp
			lw		fp, 0(sp)
			addi	sp, sp, 4
									
			ret						# }
			
# functie void f(struct crd **c, int x[])
# PARAMETERS
#		c: 	a0 (pointer naar pointer naar struct crd, dus gewoon een adres)
#		&x: a1
#	
# LOKALE VARIABELEN (geef leaf functie dus variabelen moeten in saved registers)
#		tmp: -20(fp) -> -4(fp)
#		i: 	 s1
#
f:									# void f(struct crd **c, int x[]){
									#		int i;
			# backup frame pointer
			addi	sp, sp, -4
			sw		fp, 0(sp)
			mv		fp, sp
			
			# maak plaats voor lokale variabele tmp op stack
			addi	sp, sp, -20		#		struct crd tmp;
			
			# backup saved register s1
			addi	sp, sp, -4
			sw		s1, 0(sp)		
			
			# ...					#	...
			
			# maak een backup van a0, want malloc gebruikt dat register
			addi	sp, sp, -4
			sw		a0, 0(sp)
			
			li		a7, 9			#		// type 9: malloc
			li		a0, 20			#		// 20 bytes
			ecall					#		// malloc()
			
			# verplaats het resultaat naar t0
			mv		t0, a0
			
			# restore a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			sw		t0, -16(fp)		#		tmp.link = malloc(20);
			
			lw		t0, 0(a1)		#		// x[0]
			sw		t0, -12(fp)		#		tmp.x = x[0];
			lw		t0, 4(a1)		#		// x[1]
			sw		t0, -8(fp)		#		tmp.y = x[1];
			lw		t0, 8(a1)		#		// x[2]
			sw		t0, -4(fp)		#		tmp.z = x[2];
			
			lw		t0, -12(fp)		#		// tmp.x
			mul		t1, t0, t0		#		// tmp.x * tmp.x
			
			lw		t0, -8(fp)		# 		// tmp.y
			mul		t0, t0, t0		#		// tmp.y * tmp.y
			add		t1, t1, t0		#		// tmp.x * tmp.x + tmp.y * tmp.y
			
			lw		t0, -4(fp)		# 		// tmp.z
			mul		t0, t0, t0		#		// tmp.z * tmp.z
			add		t1, t1, t0		#		// tmp.x * tmp.x + tmp.y * tmp.y + tmp.z * tmp.z
			
			lw		t0, -16(fp)		#		// laad het adres waarnaar tmp.lnk wijst
			sw		t1, 0(t0)		#		// berg de bewerking weg in het eerste veld van *tmp.lnk
						
			# ...					#	...
					
			li		s1, 1			#		i = 1;
			
			# backup a0 en a1 voor functie-oproep
			addi	sp, sp, -8
			sw		a0, 0(sp)
			sw		a1, 4(sp)
			
			# zet parameters goed voor functie-oproep
			#	--> tmp moet volledig op de stack
			#	--> i moet in a0
			
			mv		a0, s1			#		// i in a0
			
			# zet de volledige struct op de stack
			addi	sp, sp, -20
			lw		t0, -20(fp)
			sw		t0, 0(sp)
			lw		t0, -16(fp)
			sw		t0, 4(sp)
			lw		t0, -12(fp)
			sw		t0, 8(sp)
			lw		t0, -8(fp)
			sw		t0, 12(sp)
			lw		t0, -4(fp)
			sw		t0, 16(sp)	
			
			# roep de functie g aan en zet dus het ra aan de kant
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	g
			lw		ra, 0(sp)
			addi	sp, sp, 4
			
			# geef plaats van het argument op de stack terug vrij
			addi	sp, sp, 20
			
			# restore a0 en a1
			lw		a0, 0(sp)
			lw		a1, 4(sp)
			addi	sp, sp, 8
											
			# ...					#	...
			
			# restore saved register s1
			lw		s1, 0(sp)
			addi	sp, sp, 4
			
			# geef plaats op de stack van de lokale variabele terug vrij
			addi	sp, sp, 20
		
			# restore fp
			lw		fp, 0(sp)
			addi	sp, sp, 4
						
			ret						# }


# main
# GLOBALE VARIABELEN: 
#  	p: in het geheugen (pointer (dus gewoon 1 32 bit adres) naar een struct)
#   q: lijst geinitialiseerd in het geheugen (dus 3*32 bits)     
#
# LOKALE VARIABELEN:
#	s1: i
#
main:								# void main() {

			li		s1, 121			#	int i = 121;
			# --> hier moeten we geen backup van maken want de main wordt door niemand aangeroepen
			
			# ...					#	...
			
			li		a7, 9
			li		a0, 20
			ecall					# 	// malloc van 20 bytes --> resultaat in a0
			
			la		t0, p			# 	// &p
			sw		a0, 0(t0)		#	p = malloc(20);
			
			# zet parameters goed voor de function call van f
			#	--> adres van p in a0
			#	--> adres van q in a1
			#	--> we moeten geen backup maken van a0 en a1 hier
			la		a0, p			# 	// &p
			la		a1, q			# 	// &q = &q[0]
			
			# functieoproep -> ra aan de kant!
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	f
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# einde oproep
			
			li		a7, 1
			mv		a0, s1
			ecall					# 	print(i);
			
			li		a7, 11
			li		a0, 32
			ecall					# 	print(" ");
			
			la		t0, p			# 	// &p
			lw		t1, 0(t0)		#	// haal het adres van de struct waarnaar p wijst
			lw		a0, 0(t1)		#	// *p.info = p->info in a0
			
			li		a7, 1
			ecall					#	print(p->info);
			
			li		a7, 11
			li		a7, 10
			ecall					# 	print("\n");
			
			# ...					#	...
						
			li		a7, 10			#	// exit code 0
			ecall 					# }
			
