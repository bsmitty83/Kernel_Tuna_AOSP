#include <linux/linkage.h>

ENTRY(strlen)

	stmfd	sp!, {v1, v2, v3, v4, lr}
 
	mov	v2, a1
	mov	v3, #255
 
	// un-aligned address till we get aligned
1:	ands	v4, v2, #3
	beq	0f
	ldrb	v1, [v2], #1
	ands	v4, v3, v1
	beq	1f
	bal	1b
 
	// un-rolling strings
	// as few instructions in the loop
	// as possible
	// - Check whether any position equals 0
0:	ldr	v1, [v2], #4
	ands	v4, v3, v1
	andnes	v4, v3, v1, LSR #8
	andnes	v4, v3, v1, LSR #16
	andnes	v4, v3, v1, LSR #24
	bne	0b
 
	//After the loop we calculate the diff
	//between the end and the begining of the str
	ands	v4, v3, v1
	subeq	v2, v2, #1
	andnes	v4, v3, v1, LSR #8
	subeq	v2, v2, #1
	andnes	v4, v3, v1, LSR #16
	subeq	v2, v2, #1
	andnes	v4, v3, v1, LSR #24
1:	subeq	v2, v2, #1
 
	sub	a1, v2, a1
	ldmfd	sp!, {v1, v2, v3, v4, pc}
END(strlen)
