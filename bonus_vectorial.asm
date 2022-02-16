section .text
	global vectorial_ops

;; void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

vectorial_ops:
	push	rbp
	mov		rbp, rsp
	sub 	rsp, 48
	mov 	qword [rbp - 8], RDI ; s
	mov 	qword [rbp - 16], RSI ; int * A
	mov 	qword [rbp - 24], RDX ; int * B
	mov 	qword [rbp - 32], RCX ; int * C
	mov 	qword [rbp - 40], R8 ; int n
	mov 	qword [rbp - 48], R9 ; int * D


	mov 	rax, r8	; rax = n
	xor 	rdx, rdx
	mov 	rcx, 8	
	idiv 	rcx		; rax = n / 8
	mov 	rcx, 0
parcurge_8:
	cmp 	rcx, rax
	je 		iesire
	
	push 	rax
	mov 	rax, 32

	mul 	rcx

	vbroadcastss 	ymm0, [rbp - 8] 	; populam ymm0 cu s (vom avea un vector
									; unde pe toate cele 8 pozitii va fi
									; valoarea s)
	
	mov 	rdx, [rbp - 16]
	add 	rdx, rax
	vmovdqu ymm1, [rdx]
	vpmulld ymm2, ymm0, ymm1 ; s * A

	mov 	rdx, [rbp - 24]
	add 	rdx, rax
	vmovdqu ymm0, [rdx] ; B
	mov 	rdx, [rbp - 32]
	add 	rdx, rax
	vmovdqu 	ymm1, [rdx] ; C

	vpmulld 	ymm0, ymm0, ymm1 ; B .* C

	vpaddd 		ymm2, ymm2, ymm0 ; s * A + B .* C

	mov 	r9, [rbp - 48]
	add 	r9, rax
	vmovdqu 	[r9], ymm2 ; D = s * A + B .* C

	pop 	rax
	inc 	rcx
	jmp 	parcurge_8

iesire:
	add 	rsp, 48
	leave
	ret
