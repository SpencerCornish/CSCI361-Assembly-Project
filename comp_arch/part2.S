	.globl binary_search
/*
	The values that are passed in to this function are stored in:
		X0: sorted array
		X1: length of array
		X2: key being searched for

	To return a value we want to store it in X0 before we do 'br X30'
*/
binary_search:
	mov X9, X0 	 		//address of low index

	lsl X10, X1, #3		//multiply length of array by 8 by shifting left
	sub X10, X10, #8	//subtract 8 to get last index
	add X10, X0, X10  	//add result to start of index to get address of high index

	loop:
		cmp X9, X10		//if low index is greater than high index
		b.gt notFound

		sub X11, X9, X0		//distance of first index from start of array
		sub X12, X10, X0	//distance of last index from start of array
		add X13, X11, X12	//sum of distances

		lsr X13, X13, #1	//divide sum by two to get center
		lsr X14, X13, #3	//check if X13 is divisible by 8 by shifting right 3 then shifting left 3 and seeing if it is still equal to X13
		lsl X14, X14, #3
		cmp X13, X14
		b.ne addFour

		b compare

	addFour:
		add X13, X13, #4	//add 4 to the address so that it isn't in the middle of an integer
		b compare

	compare:
		add X13, X0, X13	//address of center of first and last index pointers
		ldur X11, [X13]		//get value at center address
		cmp X11, X2			//compare this value to key
		b.eq found
		b.lt low
		b.gt high

	low:
		mov X9, X13			//set the low address as the center
		add X9, X9, #8		//plus 1 index
		b loop

	high:
		mov X10, X13		//set the high address as the center
		sub X10, X10, #8	//minus 1 index
		b loop

	found:
		mov X0, X11			//store found key value in X0 to be returned
		br X30

	notFound:
		mov X0, #-1			//store -1 in X0 to be returned
		br X30

