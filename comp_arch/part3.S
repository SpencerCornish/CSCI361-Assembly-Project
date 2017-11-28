	.globl insertion_sort
/*
	The values that are passed in to this function are stored in:
		X0: unsorted array
		X1: length of array
		X2: key being searched for

	To return a value we want to store it in X0 before we do 'br X30'
*/

insertion_sort:
	//code for sorting the unsorted array
	b sort

	sort:
		mov X9, X0 //i starts at 0 index
		b sort_outer_loop

	sort_outer_loop:
		add X9, X9, #8  //increase index of i by 1
		sub X10, X9, #8 //j starts at index i-1

		ldur X12, [X9]	//arr[i], get value at index i

		lsl X11, X1, #3 	//multiply length of array by 8
		add X11, X0, X11 	//add last index to start address of the array

		cmp X9, X11				//check if we are at the last index of the array
		b.eq search				//if we are at the last index, sorting is done, branch to search
		b.ne sort_inner_loop	//otherwise branch to the inner loop

	sort_inner_loop:
		cmp X10, X0
		b.lt after_inner_loop //j >= 0 is false, X10 is before the first index of the array

		ldur X13, [X10] //arr[j], get value at index j
		cmp X13, X12 	//compare key and arr[j]
		b.gt move_index //move the index if arr[j] is greater than the key
		b after_inner_loop	//else, we are done with this loop

	move_index:
		add X14, X10, #8 //j+1
		stur X13, [X14]  //arr[j+1] = arr[j]
		sub X10, X10, #8 //j = j-1
		b sort_inner_loop

	after_inner_loop:
		add X14, X10, #8 //j+1
		stur X12, [X14]  //arr[j+1] = key
		b sort_outer_loop

	//code for searching the now sorted array
	search:
		mov X9, X0 	 		//address of low index

		lsl X10, X1, #3		//multiply length of array by 8 by shifting left
		sub X10, X10, #8	//subtract 8 to get last index
		add X10, X0, X10  	//add result to start of index to get address of high index
		b search_loop

	search_loop:
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
		b search_loop

	high:
		mov X10, X13		//set the high address as the center
		sub X10, X10, #8	//minus 1 index
		b search_loop

	found:
		sub X13, X13, X0	//get offset of X13 from X0
		lsr X13, X13, #3	//divide by 8 to get index position
		mov X0, X13			//store index of found key in X0 to be returned
		br X30

	notFound:
		mov X0, #-1			//store -1 in X0 to be returned
		br X30
