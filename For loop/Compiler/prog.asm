
;start -1
.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
output_integer_msg_format byte "%d", 0Ah, 0
output_string_msg_format byte "%s", 0Ah, 0
input_integer_format byte "%d",0

number sdword ?

.code

main proc
	push ebp
	mov ebp, esp
	sub ebp, 100
	mov ebx, ebp
	add ebx, 4

;ld_int 0
	mov eax, 0
	mov dword ptr [ebx], eax
	add ebx, 4


;store 0
	mov eax, [ebx-4]
	mov dword ptr [ebp-0], eax

;ld_int 1
	mov eax, 1
	mov dword ptr [ebx], eax
	add ebx, 4


;store 1
	mov eax, [ebx-4]
	mov dword ptr [ebp-4], eax

;while_label 5
WHILE_START_LABEL_5:


;ld_var 1
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int 11
	mov eax, 11
	mov dword ptr [ebx], eax
	add ebx, 4


;lt 8
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	cmp edx, eax
	jl LS8
	mov dword ptr [ebx], 0
	jmp LE8
	LS8: mov dword ptr [ebx], 1
	LE8: add ebx, 4



;while_start 5
	mov eax, [ebx-4]
	cmp eax, 0
	jle WHILE_END_LABEL_5


;ld_var 0
	mov eax, [ebp-0]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_var 1
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


;add -1
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	add eax, edx
	mov dword ptr [ebx], eax
	add ebx, 4


;store 0
	mov eax, [ebx-4]
	mov dword ptr [ebp-0], eax

;ld_var 1
	mov eax, [ebp-4]
	mov dword ptr [ebx], eax
	add ebx, 4


;ld_int 1
	mov eax, 1
	mov dword ptr [ebx], eax
	add ebx, 4


;add -1
	sub ebx, 4
	mov eax, [ebx]
	sub ebx, 4
	mov edx, [ebx]
	add eax, edx
	mov dword ptr [ebx], eax
	add ebx, 4


;store 1
	mov eax, [ebx-4]
	mov dword ptr [ebp-4], eax

;while_end 5
	jmp WHILE_START_LABEL_5
WHILE_END_LABEL_5:


;print_int_value 0
	push eax
	push ebx
	push ecx
	push edx
	push [ebp-0]
	push [ebp+4]
	push [ebp+8]
	push [ebp+12]
	push [ebp+16]
	push [ebp+20]
	push [ebp+24]
	push ebp
	mov eax, [ebp-0]
	INVOKE printf, ADDR output_integer_msg_format, eax
	pop ebp
	pop [ebp+24]
	pop [ebp+20]
	pop [ebp+16]
	pop [ebp+12]
	pop [ebp+8]
	pop [ebp+4]
	pop [ebp-0]
	pop edx
	pop ecx
	pop ebx
	pop eax

;halt -1
	add ebp, 100
	mov esp, ebp
	pop ebp
	ret
main endp
end
