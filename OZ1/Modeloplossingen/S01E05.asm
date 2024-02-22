# SESSION 01 - EXCERCISE 05

# Make the main function globally visible (s.t. the RARS simulator knows where to start executing code).
.globl main

# The data section is used to define variables to be stored in memory.
.data
	
# The text section is used for the code of your program.
.text
# variabelen in registers:
# 	getal: 	s1
# 	aantal: s2
main:						# main(){

		li		s2, 0		# 	aantal = 0;
	
		li		a7, 5		
		ecall			
		mv		s1, a0		# 	getal = getint();
	
wh:		bltz	s1, endWh	# 	while (getal >= 0) {
		addi	s2, s2, 1	#		aantal++;
		li		a7, 5		
		ecall			
		mv		s1, a0		# 		getal = getint();
		j		wh			# 	}
endWh:	mv 		a0, s2		
		li		a7, 1		
		ecall				# 	printint(aantal);

		li    	a7, 10	
		ecall				# }
	