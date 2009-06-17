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



section '.text' executable




;==============================================================================
;       SubBytes function.
;==============================================================================
proc SubBytes, v1, v2, v3

local tamere:DWORD

	mov	eax, [v1]
	mov	ebx, [v2]

    xor eax, ebx

    mov ebx, [v3]
    mov [ebx], eax

    mov eax, 2

    ret
endp






section '.data' writeable

msg db 'Hello world!',0xA
msg_size = $-msg
