	.686P
	.XMM
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	my_cpuid
_TEXT	SEGMENT
_CPUInfo$  = 8						; size = 4
_InfoType$ = 12						; size = 4
my_cpuid PROC						; COMDAT
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ecx, DWORD PTR _InfoType$[ebp]
	cpuid
	mov		DWORD PTR _CPUInfo$[ebp  ], eax
	mov		DWORD PTR _CPUInfo$[ebp+1], ebx
	mov		DWORD PTR _CPUInfo$[ebp+2], ecx
	mov		DWORD PTR _CPUInfo$[ebp+3], edx
	pop		ebx
	pop		ebp
	ret		8
my_cpuid ENDP				; __cpuid
_TEXT	ENDS
END
