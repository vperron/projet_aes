; This is example of mixing C code and assembly

; this file demonstrates following:
; - declaring stdcall procedure, using pure assembly            (fasm_stdcall_avg)
; - declaring stdcall procedure, using FASM standard macros     (fasm_stdcall_avg2)
; - declaring ccall procedure, using pure assembly              (fasm_ccall_avg)
; - declaring ccall procedure, using FASM standard macros       (fasm_stdcall_avg2)
; - calling stdcall procedure defined with C                    (c_stdcall_display in access_c)
; - calling ccall procedure defined with C                      (c_ccall_display   in access_c)
; - access data defined with C                                  (c_int             in access_c)

; definitions of macros we use
include 'win32a.inc'

format MS COFF

;-----------------------------------------------------------------------------
; declarations

; declare procedures as public, so C code can use them
; public names must be "decorated" by prepending "_".
; stdcall procedure names must be be also decorated by "@" and size of arguments at the end
public fasm_stdcall_avg   as '_fasm_stdcall_avg@8'
public fasm_stdcall_avg2  as '_fasm_stdcall_avg2@8'
public fasm_ccall_avg	  as '_fasm_ccall_avg'
public fasm_ccall_avg2	  as '_fasm_ccall_avg2'
public access_c 	  as '_access_c'

; declare our data as public, so we can access it in C code
public fasm_string	  as '_fasm_string'

; declare C procedures as extern, so we can access it here
extrn '_c_stdcall_display@8' as c_stdcall_display
extrn '_c_ccall_display'  as c_ccall_display
extrn '_printf' 	  as printf

; declare C data as extern, so we can access it here
extrn '_c_int'	  as c_int:dword

; code section
section '.text' code readable executable


;-----------------------------------------------------------------------------
; declare "fasm_stdcall_avg" using pure assembly
; this computes average value of two unsigned numbers
fasm_stdcall_avg:

	; create stack frame
	push	ebp
	mov	ebp, esp
label .num1 dword at ebp+8	      ;num1 argument is now located at ebp+8
label .num2 dword at ebp+12	      ;num2 argument is now is located at ebp+12

	; allocate space for local variables in stack
	sub	esp, 8
label .loc1 dword at ebp-4
label .loc2 dword at ebp-8

	; registers EBX ESI EDI need to be preserved
	; (not needed in this particular example)
	push	ebx esi edi

	;compute average
	mov	eax, [.num1]
	add	eax, [.num2]
	rcr	eax, 1

	;return. return value is in EAX
	pop	edi esi ebx	;restore registers
	mov	esp, ebp	;set esp back to stack frame
	pop	ebp		;destroy stack frame
	retn	2*4		;return and restore arguments from stack

;-----------------------------------------------------------------------------
; declare "fasm_stdcall_avg2" using FASM macros
; this is same as "fasm_stdcall_avg", just done with macros
proc fasm_stdcall_avg2 num1, num2
local loc1 dd ?
local loc2 dd ?
	mov	eax, [num1]
	add	eax, [num2]
	rcr	eax, 1
	ret			;NOTE: "ret" is macro, different from "retn" instruction
endp


;-----------------------------------------------------------------------------
; declare "fasm_ccall_avg" using pure assembly
; this computes average value of two unsigned numbers
fasm_ccall_avg:

	;same as fasm_stdcall_avg
	push	ebp
	mov	ebp, esp
label .num1 dword at ebp+8	      ;num1 argument is now located at ebp+8
label .num2 dword at ebp+12	      ;num2 argument is now is located at ebp+12

	sub	esp, 2*4
label .loc1 dword at ebp-4
label .loc2 dword at ebp-8

	push	ebx esi edi

	mov	eax, [.num1]
	add	eax, [.num2]
	rcr	eax, 1

	pop	edi esi ebx
	mov	esp, ebp
	pop	ebp

	;this is only difference. In ccall, we leave arguments on stack
	retn 0


;-----------------------------------------------------------------------------
; declare "fasm_ccall_avg2" using FASM macros
; this is same as "fasm_ccall_avg", just done with macros
proc fasm_ccall_avg2 c num1, num2  ;note the "c" declaration modifier
local loc1 dd ?
local loc2 dd ?
	mov	eax, [num1]
	add	eax, [num2]
	rcr	eax, 1
	ret
endp


;-----------------------------------------------------------------------------
; access_c
; this procedure demonstrates how to access things defined in external C code
; calls are done using pure assembly
proc access_c

	; c_stdcall_display("The 'c_int' variable is located at: ", &c_int);
	push	c_int
	push	_addr
	call	c_stdcall_display

	; returned value must be 0
	cmp	eax, 0
	jne	.error

	; c_ccall_display("Value of C variable is", c_int);
	push	[c_int] 	;access c variable
	push	_value
	call	c_ccall_display
	add	esp, 2*4	;remove arguments from stack

	; returned value must be 0
	cmp	eax, 0
	jne	.error

	;return (0 is already stored in EAX)
	ret

	;on error return 1
.error: mov	eax, 1
	ret
endp


;-----------------------------------------------------------------------------
; access_c2
; this is same as "access_c", just done with FASM standard macros
proc access_c2
	stdcall c_stdcall_display, _addr, c_int
	cmp	eax, 0
	je	.error

	ccall	c_ccall_display, _value, [c_int]
	cmp	eax, 0
	je	.error

	ret

.error: mov	eax, 1
	ret
endp


;-----------------------------------------------------------------------------
; data section
section '.data' data readable writeable

	;you can place data here
	fasm_string db	'This string is defined in FASM module.',0
	_addr  db  "The 'c_int' variable is located at: ",0
	_value db  'Value of C variable is: ',0

;by vid  (vid@inMail.sk)
;see: http://flatassembler.net
;discuss assembly at: http://board.flatassembler.net