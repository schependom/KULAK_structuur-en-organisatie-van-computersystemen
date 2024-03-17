# SESSION 04 - EXCERCISE 07

.globl 	main
.data
.text

# void hanoi(int n, int van, int naar)
#	-> geen leaf functie (want recursief)
#	-> ARGUMENTEN:
#			a0: n	a1: van		a2: naar
#	-> LOKALE VARIABELEN
#			s1: via

hanoi:								# void hanoi(int n, int van, int naar) {
									#	int via;
			beqz	a0, endIf		#	if(n!=0) {
			# backup van s1
			addi	sp, sp, -4
			sw		s1, 0(sp)
			# code
			sub		s1, x0, a1		#		// - van
			sub		s1, s1, a2		#		// - van - naar
			addi	s1, s1, 6		#		via = 6 - van - naar;
			# backup van a0, a1 en a2
			addi	sp, sp, -12
			sw		a0, 8(sp)
			sw		a1, 4(sp)
			sw		a2, 0(sp)
			# zet de argumenten goed
			addi	a0, a0, -1		#		// n-1
			mv		a2, s1
			# call hanoi
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	hanoi			# 		hanoi(n-1, van, via);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# restore a0, a1, a2
			lw		a0, 8(sp)
			lw		a1, 4(sp)
			lw		a2, 0(sp)
			# print het resultaat
			li		a7, 1
			mv		a0, a1
			ecall
			li		a7, 11
			li		a0, 32
			ecall
			li		a7, 1
			mv		a0, a2
			ecall
			li		a7, 11
			li		a0, 10
			ecall
			# restore a0 na print
			lw		a0, 8(sp)
			addi	sp, sp, 12
			# backup van a0, a1 en a2
			addi	sp, sp, -12
			sw		a0, 8(sp)
			sw		a1, 4(sp)
			sw		a2, 0(sp)
			# zet de argumenten goed
			addi	a0, a0, -1		#		// n-1
			mv		a1, s1
			# call hanoi
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	hanoi			# 		hanoi(n-1, via, naar);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# restore a0, a1, a2
			lw		a0, 8(sp)
			lw		a1, 4(sp)
			lw		a2, 0(sp)
			addi	sp, sp, 12
			# restore s1
			lw		s1, 0(sp)
			addi	sp, sp, 4
endIf:		ret


# de main is geen leaf functie, dus we storen variabelen in saved regs:
#	s1: aantal
main:								# main() {
			li		a7, 5
			ecall
			mv		s1, a0			#	int aantal = getint();
			# zet de argumenten goed
			mv		a0, s1
			li		a1, 1
			li		a2,	3
			# call hanoi
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	hanoi			# 		hanoi(aantal, 1, 3);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# exit code 0
			li		a7, 10			#
			ecall 					# }
