# SESSION 04 - EXCERCISE 06

.globl 	main
.data
.text

# Fibon is een leaf functie
# Argumenten:	a0: int n
#				a1: int r[] (reference semantics dus dit is &r[0])
# Lokale variabelen:
# t1: i

fibon:		li		t0, 1			# void fibon(int n, int r[]) {
			sw		t0, 0(a1)		#	r[0] = 1;
			sw		t0, 4(a1)		#	r[1] = 1;
			li		t1, 2			#	int i = 2;
for:		bge		t1, a0, eFor	#	for( ; i<n; ) {
			slli	t2, t1, 2		#		// 4*i
			add		t3, t2, a1		#		// &r[i]
			lw		t4, -8(t3)		#		// r[i-2]
			lw		t5, -4(t3)		#		// r[i-1]
			add		t4, t4, t5		#		// r[i-2] + r[i-1]
			sw		t4, 0(t3)		#		r[i] = r[i-2] + r[i-1];
			addi	t1, t1, 1		#		i++;
			j		for				#	}
eFor:		ret						# }
				

# Main is een non-leaf functie
# s1: m
# s2: i
# f zullen we op de stack bewaren -400(fp) -> -4(fp)
main:								# main() {
			# zet fp goed
			addi	sp, sp, -4
			sw		fp, 0(sp)
			mv		fp, sp
			# maak plaats op de stack voor de lijst f
			addi	sp, sp, -400
			li		a7, 5
			ecall					
			mv		s1, a0			#	m = getint();
			# m zit al in a0 dus we moeten enkel nog &f[0] meegeven in a1
			mv		a1, fp			#	// &f[100]
			addi	a1, a1, -400	#	// &f[0]
			# call fibon
			addi	sp, sp, -4
			sw		ra, 0(sp)
			call	fibon			#	fibon(m,f);
			lw		ra, 0(sp)
			addi	sp, sp, 4
			# end call
			mv		t1, fp
			addi	t1, t1, -400	#	&f[0]
			li		s2, 0			#	i = 0;
for2:		bge		s2, s1, eFor2	#	for( ; i<m; ) {
			slli	t0, s2, 2		#		// 4*i
			add		t0, t0, t1		#		// &f[i]
			lw		a0, 0(t0)		#		// f[i]
			li		a7, 1
			ecall					#		printint(f[i]);
			li		a7, 11
			li		a0, 10
			ecall					#		printf("\n");
			addi	s2, s2, 1		#		i++;
			j		for2			#	}
eFor2:		
			# geef plaats van f terug weg op de stack
			addi	sp, sp, 400
			# herstel de framepointer
			lw		fp, 0(sp)
			addi	sp, sp, 4
			# exit code 0 (hopelijk)
			li		a7, 10			#
			ecall 					# }
