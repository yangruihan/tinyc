; ==== begin function `main` ====
%define main.argc 0

%MACRO $main 0
   CALL @main
   ADD ESP, 4*main.argc
   PUSH EAX
%ENDMACRO

%define main.varc 1

%MACRO main.var main.varc
	%define i [EBP - 4*1]
	SUB ESP, 4*main.varc
%ENDMACRO

%MACRO ENDFUNC@main 0
	LEAVE
	RET
	%undef i
%ENDMACRO
; ==== end function `main`   ====

; ==== begin function `factor` ====
%define factor.argc 1

%MACRO $factor 0
   CALL @factor
   ADD ESP, 4*factor.argc
   PUSH EAX
%ENDMACRO

%MACRO factor.arg factor.argc
	%define n [EBP + 8 + 4*factor.argc - 4*1]
%ENDMACRO

%MACRO ENDFUNC@factor 0
	LEAVE
	RET
	%undef n
%ENDMACRO
; ==== end function `factor`   ====

