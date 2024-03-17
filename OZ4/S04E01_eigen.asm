# SESSION 04 - EXCERCISE 01 - version 1: globale variabelen

.globl 	main
.data
	a:		.word		1,2,3,4,5,6,7,8,9,10
	b:		.word		10,9,8,7,6,5,4,3,2,1

.text

# Som is een leaf functie dus we kunnen de variabelen gewoon in temp registers bewaren
som:
		add		a0, a0, a1
		ret

# Main is non-leaf -> saved registers
#	s1: i
#	s2: s	
main:
		li		s2, 0				# s = 0;
		li		s1, 0				# i = 0;
		li		s3, 10				
for:	bge		s1, s3, eFor
		la		t0, a
		la		t1, b
		slli	t2, s1, 2
		add		t0, t0, t2			# a0 = &a[i]
		add		t1, t1, t2			# a1 = &b[i]
		lw		a0, 0(t0)
		lw		a1, 0(t1)
		addi	sp, sp, -4
		sw		ra, 0(sp)			
		call	som
		lw		ra, 0(sp)
		addi	sp, sp, 4
		add		s2, s2, a0
		addi	s1, s1, 1
		j		for
eFor:	li		a7, 1
		mv		a0, s2
		ecall
		li		a7, 10
		ecall