INCLUDE MACRO_INST.ASM 
    .8086
    .MODEL SMALL
    .STACK 256
    .DATA
        
    STRING DB "EXERCISE 3:" , '$'
    .CODE
    ASSUME CS:CODE
      
 
MAIN PROC FAR     
        MOV AX,@DATA  
        MOV DS,AX 
        LEA DX,STRING  		;load the address of the string in DX and output the string loaded in DX 
        MOV AH,09H 
        INT 21H  
        NEW_LINE
   
        PRINT "X"               		;print X=
        PRINT "="               		;read first digit of first number
        CALL HEX_KEYB
        MOV DL,AL               		;4 lsb of DL contain the first digit
        MOV BL,BH  
        CALL HEX_KEYB           	;read second digit of first number
        MOV DH,AL               		;4 lsb of DH contain the second digit
         
        PUSH DX
        PRINT BL 
        PRINT BH
        POP DX
          
        ROL DL,4               		;4 msb of DL now have the first digit
        ADD DL,DH               		;DL has the first number after addition of DH to it
        
        PUSH DX   
         
        PRINT ' ' 
        PRINT 'Y'               		;print Y= with a space before 
        PRINT '='
        CALL HEX_KEYB           	;read first digit of second number
        MOV DL,AL               		;4 lsb of DL contain the first digit
        MOV BL,BH  
        CALL HEX_KEYB           	;read second digit of seocnd number
        MOV DH,AL                   	;4 lsb of DH contain the second digit
         
        PUSH DX
        PRINT BL 
        PRINT BH
        POP DX 
          
        MOV BL,DL
        MOV BH,DH
        ROL BL,4                		;4 msb of DL have the first digit
        ADD BL,BH               		;DL has the first number after addition of DH to it 
        
        POP DX 
    
    
        NEW_LINE  		;print new line
    
        PUSH BX
        PUSH DX                 		;print X+Y=
        PRINT 'X'
        PRINT '+' 
        PRINT 'Y' 
        PRINT '='
        POP DX 
        
        PUSH DX                 		;adding the 2 numbers
        AND DH,0x00
        AND BH,0x00 
        ADD DX,BX			;store result of addition in DX
        PUSH AX
        MOV AX, DX		;move result to AX 
        CALL PRINT_DEC          	;print them in decimal form
        POP AX
        POP DX 
        POP BX
             
             
        PUSH DX                 		;print X-Y=
        PRINT ' '
        PRINT 'X'
        PRINT '-' 
        PRINT 'Y' 
        PRINT '='
        POP DX
        
        
        PUSH BX 
        PUSH DX
        AND DH,0x00  
        CMP DL,BL               		;if the substraction returns a negative
        JAE GOOD_ENOUGH       
        PUSH DX                 		;print a '-' and perform the opposite substraction
        PRINT '-' 
        POP DX
        SUB BL,DL			;opposite substraction done like this 
        MOV DL,BL 		;store result in DL
        JMP FINAL
    GOOD_ENOUGH:               	;if the substraction would be positive then just do it
        SUB DL,BL
    FINAL: 
        MOV AX,DX               		;print result in decimal form after storing it in AX
        CALL PRINT_DEC
        POP DX
        POP BX
   
    RET
MAIN ENDP  


HEX_KEYB PROC NEAR              	;same as the one of other exercises
        PUSH DX            
    DO:
        READ 
        CMP AL,30H 
        JL DO
        CMP AL,39H
        JG FLAG1
        MOV BH,AL   
        SUB AL,30H 
        JMP FLAG2
    FLAG1:
        CMP AL,'A'
        JL DO
        CMP AL,'F'
        JG DO
        MOV BH,AL               		;store hex representation of input
        SUB AL,37H 
    FLAG2:
        POP DX 
        RET 
HEX_KEYB ENDP


PRINT_HEX PROC NEAR             	;print the hexadecimal number 
        PUSH DX  
        
        MOV CX,DX
        AND DX,0xF000 
        ROL DH,4
        CMP DH,0x09
        JA LETTER_0
        ADD DH,30H
        JMP NEXT0
    LETTER_0:
        ADD DH,37H
        NEXT0: 
        PRINT DH
    
        MOV DX,CX
        AND DX,0x0F00
        CMP DH,0x09
        JA LETTER_1
        ADD DH,30H
        JMP NEXT1
    LETTER_1:
        ADD DH,37H
    NEXT1: 
        PRINT DH
        
        MOV DX,CX
        AND DX,0x00F0 
        ROL DL,4
        CMP DL,0x09
        JA LETTER_2
        ADD DL,30H    
        JMP NEXT2
    LETTER_2:
        ADD DL,37H
        NEXT2: 
        PRINT DL
    
        MOV DX,CX
        AND DX,0x000F
        CMP DL,0x09
        JA LETTER_3
        ADD DL,30H
        JMP NEXT3
    LETTER_3:
        ADD DL,37H
    NEXT3:
        PRINT DL
        POP DX
    RET
PRINT_HEX ENDP
    


PRINT_DEC PROC NEAR
    MOV BL,10 
    MOV CX,1 				;decades counter
LOOP_10: 
    DIV BL				;divide number by 10
    PUSH AX                			;save decades  
    CMP AL,0 				;if there are no more decades then we have reached single digits 
    JE PRINT_DIGITS_      			;the whole number into dec digits          
    INC CX				;increase number of decades
    MOV AH,0   
    JMP LOOP_10			;if we have not reached single digits I have to divide again so loop again
PRINT_DIGITS_:
    POP DX				;pop dec digit to be printed
    MOV DL,DH
    MOV DH,0				;DX = 00000000xxxxxxxx (ASCII of number to be printed)
    ADD DX,30H				;make ASCII code
    MOV AH,2
    INT 21H				;print
    LOOP PRINT_DIGITS_       
    RET
ENDP PRINT_DEC        


    END MAIN


