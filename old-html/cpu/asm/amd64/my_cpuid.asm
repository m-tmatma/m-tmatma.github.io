INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

;	void my_cpuid(
;	   int CPUInfo[4],
;	   int InfoType
;	)
;
;	Parameter Passing 
;		First 4 parameters - RCX, RDX, R8, R9
;	http://msdn.microsoft.com/en-us/library/zthk2dkh%28v=VS.80%29.aspx
;
;	Caller/Callee Saved Registers
;		The registers RAX, RCX, RDX, R8, R9, R10, R11 are considered volatile 
;		and must be considered destroyed on function calls (unless otherwise 
;		safety-provable by analysis such as whole program optimization).
;		
;		The registers RBX, RBP, RDI, RSI, R12, R13, R14, and R15 are considered 
;		nonvolatile and must be saved and restored by a function that uses them.
;	http://msdn.microsoft.com/en-us/library/6t169e9c%28v=VS.80%29.aspx
;
PUBLIC	my_cpuid
_TEXT	SEGMENT
my_cpuid PROC						; COMDAT
	mov		r9,  rbx				; save rbx
	mov		r8,  rcx				; save rcx (function parameter)
	mov		eax, edx				; set paramter to cpuid
	cpuid
	mov		DWORD PTR [r8   ], eax
	mov		DWORD PTR [r8+ 4], ebx
	mov		DWORD PTR [r8+ 8], ecx
	mov		DWORD PTR [r8+12], edx
	mov		rbx,  r9				; restore rbx
	ret		0
my_cpuid ENDP
END
