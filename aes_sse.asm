;==============================================================================
; Essai d'implementation de la librairie à utiliser
; 
; Victor Perron 2009 - Projet AES
;==============================================================================


format ELF



; Include standard defs with proc, .if, etc
include 'inc/default.inc'


; Exporter les symboles necessaires
public  SetState
public  AesInit
public  SubBytes
public  DumpState
public  AddRoundKey
public	ShiftRows

section '.text' executable
;==============================================================================
;      AesInit function : Si je retourne 1 tout va bien...
;==============================================================================
proc AesInit  

	; On veut la commande 1
	mov eax, 1
	cpuid 
	; On lit le resultat dans edx pour SSE et SSE2 (positions 25 & 26)
	shr edx, 25
	and edx, 03h

	; On lit le resultat pour les autres dans SSE3, etc.
	and ecx, 110000000001000000001b
	
	
	xor eax, eax
	; On place les bits SSE4
	rol ecx, 2
	mov ebx, ecx
	and ebx, 011b

	or  eax, ebx
	shl eax, 1
	 
	; On place les bits SSSE3
	rol ecx, 10
	mov ebx, ecx
	and ebx, 01b
	
	or  eax, ebx
	shl eax, 1

	; Puis SSE3
	rol ecx, 9
	mov ebx, ecx
	and ebx, 01b

	or  eax, ebx
	shl eax, 2

	; Enfin SSE2 et 1
	or eax, edx
		
	ret

endp


;==============================================================================
;      MixColumns function : Si je retourne 1 tout va bien...
;==============================================================================


;==============================================================================
;      Function : AddRoundKey : Load Memory-mapped RoundKey and performs encryption
;==============================================================================
proc AddRoundKey, v1
	mov	eax, [v1]

	; Load RoundKey into xmm1
	movups	xmm1, [eax]

	; Performs XOR-based encryption
	xorps	xmm0, xmm1

	ret
endp

;==============================================================================
;      Function : ShiftRows : Performs Cyclic Permutation on rows
;==============================================================================
proc ShiftRows
	lea	eax, [shiftable]
	movups	xmm1, [eax]
	pshufb	xmm0, xmm1
endp

;==============================================================================
;      Debug Function : DumpState : Extract current state value into Memory
;==============================================================================
proc DumpState, v1
	mov	eax, [v1]
	movups	[eax], xmm0

    ret
endp

;==============================================================================
;      Debug function : SetState : Load state value from memory
;==============================================================================
proc SetState, v1
	mov	eax, [v1]
	movups	xmm0, [eax]

    ret
endp

;==============================================================================
;      Example Function
;==============================================================================
proc SubBytes, v1, v2, v3


	mov	eax, [v1]
	mov	ebx, [v2]

    add eax, ebx

    mov ebx, [v3]
    mov [ebx], eax

;	inc eax

    ret
endp

section '.data' writeable align 16
; Acces : [matable+n*octets]
matable db 	01h, 02h, 03h
	db	04h 

shiftable db	0fh, 0eh, 0dh, 0ch
	  db	0ah, 09h, 08h, 0bh
	  db	05h, 04h, 07h, 06h
	  db	00h, 03h, 02h, 01h

msg db 'Hello world!',0xA
msg_size = $-msg
