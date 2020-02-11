;Name: Avery Lee
;Class: CSC 314
;Assign: 8
;Due: 12/11/19

; This program asks the user for a list of character
; and won't stop until either 15 numbers have been entered or
; a negative number is entered. The program will then display 
; #'s for every value of each number entered. If the number
; is greater than 80 (Max number of chars that can be displayed
; on a single line) each # will represent more than 1 value. 

INCLUDE PCMAC.INC      
        .MODEL  SMALL
        .586

        .STACK  100h

        .DATA
CR      EQU     13
LF      EQU     10
Message DB      'Enter a number, any negative value will stop the program', CR, LF, '$'
Line 	DB		CR,LF, '$'
Number  DW 15 DUP(?)
number_elts DB ?
count 	DB ?
dividend DB 80
decrement DW 1
temp 	DW 0

        .CODE
		EXTRN GetDec: Near, PutDec: Near
main   PROC
        _Begin	
		mov ax, Number
		mov bx, offset Number
		call getNum
		call display
        _Exit   0		
main  ENDP

getNum PROC
		sub si, si
		mov number_elts, 0
		_PutStr Message
while_1:call getDec
		cmp ax,0
		jl end_while_1
		mov [bx+si], ax
		add si, 2
		inc number_elts
		cmp number_elts, 15
		jge end_while_1
		jmp while_1
end_while_1:
		ret
getNum	ENDP

display PROC
		mov cl, number_elts
		mov ch, 0
for_1:  mov ax, [bx]
if_1: 	cmp ax, 80
		jl while_2
		add ax, 80			;(num + 80)/80 to determine how many values one '#' will represent
		div dividend		;Fix where this formula is so that it checks all values first.
		mov decrement, ax
while_2: _PutCh '#'
if_2:	cmp temp, 0			;If the temp is zero, load value from array
		jne else_2
		mov ax, [bx]
		jmp end_if_2
else_2:	mov ax, temp		;If the temp is not zero, load the partially decremented value
end_if_2:sub ax, decrement
		mov temp, ax	  ;Stores the partialy decremented number
		cmp ax, 0		  
		jg while_2		  ;Continues to decrement the current number if it's not a zero
		mov temp, 0		  ;Sets temp to 0 so that that the array value is loaded first and can be decremented
		add bx, 2		  ;Counts up in the array
		_PutStr Line
		dec cx
		cmp cx, 0
		jnz for_1
end_for_1:ret
display	ENDP
	
	END main