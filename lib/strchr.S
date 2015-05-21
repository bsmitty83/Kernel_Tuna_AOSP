#include <linux/linkage.h>

ENTRY(strchr)
	stmfd	sp!, { v1, v2, v3, v4, v5, v6, lr }
 
	//a1 : src
	//a2 : char
 
	mov	v6, #255
 
	// When src pointer is un-aligned go Byte by Byte
	// till we reach an aligned address
1:	and	v1, a1, #3
	beq	1f
	ldrb	v1, [a1], #1
	cmp	v1, #0
	cmpne	v1, a2
	beq	exit
	bal	1b
 
	// Aligned mode
	// 1. Read Word
	// 2. Check whether we got a \0 and keep the shifted data for later use
	// 3. Find char
	// 4. If any of the above is true, break
1:	ldr	v5, [a1], #4
	ands	v1, v6, v5
	andnes	v2, v6, v5, LSR #8
	andnes	v3, v6, v5, LSR #16
	andnes	v4, v6, v5, LSR #24
	eornes	v5, a2, v1
	eornes	v5, a2, v2
	eornes	v5, a2, v3
	eornes	v5, a2, v4
	beq	check
	bal	1b
 
	// Char Found?
	// Check for 0x0 and reduce src pointer to the matched char
check: 	cmp	v1, #0
	beq	error
	eors	v5, a2, v1
	subeq	a1, a1, #4
	beq	ret
 
	cmp	v2, #0
	beq	error
	eors	v1, a2, v2
	subeq	a1, a1, #3
	beq	ret
 
	cmp	v3, #0
	beq	error
	eors	v1, a2, v3
	subeq	a1, a1, #2
	beq	ret
 
	cmp	v4, #0
	beq	error
	eors	v1, a2, v4
	subeq	a1, a1, #1
	beq	ret
 
	//We shouldnt reach here, but just in case return NULL
	mov	a1, #0
 
	//If we leave with 0 do not substract	
exit:	cmp	v1, #0
	subne	a1, a1, #1
error:	moveq	a1, #0
 
ret:	ldmfd	sp!, { v1, v2, v3, v4, v5, v6, pc }
END(strchr)
