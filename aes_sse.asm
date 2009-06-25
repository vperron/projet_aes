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
;      Function : MixColumns
;==============================================================================
proc MixColumns
	movups	xmm1, xmm0

	; Selectionne la premiere colonne
	; et la duplique dans xmm2
	lea	eax, [mask1]
	movups	xmm6, [eax]
	andps	xmm1, xmm6

	movups	xmm2, xmm1

	; Calcul des valeurs de la premiere colonne
	; x {02}

	; Premiere etape, decalage d'un bit vers la gauche
	pslld	xmm2, 01h

	; Chargement de la valeur de comparaison dans xmm3
	lea	eax, [mixtable]
	movups  xmm3, [eax]

	; Realisation de la comparaison xmm3 > xmm2 ? xmm3 = { { FF FF FF FF } : { 00 00 00 00 } , 4 }
	pcmpgtd	xmm3, xmm2

	; On doit realiser un XOR avec {1b} si un bit est sorti 
	; (ie : si xmm3{x} = { 00 00 00 00 }
	lea	eax,[mixtable2]
	movups	xmm4, [eax]
	por	xmm3, xxm4

	; Apres l'instruction precedente xmm3 contient :
	;	- Une ligne FF FF FF FF si il n'y a pas eu de depassement
	;	- Une Ligne FF FF FF E4 Si il y en a eu un
	; (soit en inversant : ~(00 00 00 00) ou ( 00 00 00 1b)
	; On realise donc l'inversion, puis ENFIN le XOR !
	lea	eax,[ones]
	movups	xmm5, [eax]

	; xmm3 <= NOT( xmm3 ) AND xmm5
	andnpd	xmm3, xmm5	

	; Realise le XOR
	pxor	xmm2, xmm3

	; On dispose de :
	;	- Colonne 1 dans xmm1
	;	- Colonne 1 * {02} dans xmm2
	; On peut alors realiser le calcul matriciel qui va conduire 
	; a la nouvelle valeur de la colonne

	ret
endp

;==============================================================================
;      Function : ShiftRows : Performs Cyclic Permutation on rows
;==============================================================================
proc ShiftRows_SSSE3
	lea		eax 	, [shiftable]
	movaps	xmm1 	, [eax]
	
	
	pshufb	xmm0, xmm1

	ret
endp

; Macro instuction lire 32bits
macro load32 dest, xmmreg, imm {
	
	push 	ebx 				; Sauve ebx
	pextrw 	ebx, xmmreg, imm+1  ; Extrait les 16bits de poids fort
	shl 	ebx, 16 			; Les decale en poids fort dans ebx
	pextrw 	dest, xmmreg, imm 	; 16bits de poids faible
	or 		dest, ebx 			; Mix des deux
	pop 	ebx 				; Restauration ebx

}

macro store32 xmmreg, src, imm {
	pinsrw 	xmmreg, src, imm
	shr 	src, 16
	pinsrw 	xmmreg, src, imm+1
}

macro load_rol_extract xmmreg, imm {
	load32 	eax, xmmreg, 2*imm
	rol 	eax, 8*imm
	store32 xmmreg, eax, 2*imm
}

; Adaptation pour tous processeurs: on declae successivement dans eax avant de tourner
proc ShiftRows
	; On copie xmm0 dans un autre registre
	movaps 	xmm1, xmm0
 	
	load_rol_extract xmm1,1	
	load_rol_extract xmm1,2	
	load_rol_extract xmm1,3	

	movaps 	xmm0, xmm1
	
	ret

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

; Table des 4 vecteurs de rotation. Sera chargée dans cet ordre.
; Donc le dernier vecteur ici sera chergé en quatrieme dword de xmm0.
; Par contre chaque dword indépendamment est considéré en little indian.
shiftable 	dd	03020100h
	  		dd	06050407h
	  		dd	09080b0ah
	  		dd	0c0f0e0dh

; Table de comparaison pour detecter la sortie
; d'un bit de l'octet de base
mixtable1  db	00h, 00h, 01h, 00h
	   db	00h, 00h, 01h, 00h
	   db	00h, 00h, 01h, 00h
	   db	00h, 00h, 01h, 00h

; Table contenant ~{1b} pour renormalisation
; du polynome
mixtable2  db	0ffh, 0ffh, 0ffh, 0e4h
	   db	0ffh, 0ffh, 0ffh, 0e4h
	   db	0ffh, 0ffh, 0ffh, 0e4h
	   db	0ffh, 0ffh, 0ffh, 0e4h

; Table contenant un 1 sur les positions de la matrice
; de calcul où l'on doit 

ones	   db	0ffh, 0ffh, 0ffh, 0ffh	
	   db	0ffh, 0ffh, 0ffh, 0ffh	
	   db	0ffh, 0ffh, 0ffh, 0ffh	
	   db	0ffh, 0ffh, 0ffh, 0ffh	

; Table de masquage
mask1	  db	00h, 00h, 00h, 0ffh
	  db	00h, 00h, 00h, 0ffh
	  db	00h, 00h, 00h, 0ffh
	  db	00h, 00h, 00h, 0ffh

msg db 'Hello world!',0xA
msg_size = $-msg
