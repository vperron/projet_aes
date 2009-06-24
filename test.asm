;==============================================================================
; Essai d'implementation de la librairie à utiliser
; 
; Victor Perron 2009 - Projet AES
;==============================================================================


format ELF



; Include standard defs with proc, .if, etc
include 'default.inc'




; Exporter les symboles necessaires
public  SubBytes
public  AesInit



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
;       SubBytes function.
;==============================================================================
proc SubBytes, v1, v2, v3

local tamere:DWORD

	mov	eax, [v1]
	mov	ebx, [v2]

    add eax, ebx

    mov ebx, [v3]
    mov [ebx], eax

	inc eax

    ret
endp







section '.data' writeable

msg db 'Hello world!',0xA
msg_size = $-msg
