  INCLUDE MACROS5.ASM
    .8086
    .MODEL SMALL
    .STACK 256               
     
    
    
.DATA
    MSG1 DB 0AH,0DH,'START(Y,N):$'
    MSG2 DB 0AH,0DH,'ERROR$'

.CODE
    ASSUME CS : CODE_SEG, DS : DATA_SEG
    
MAIN PROC FAR
    MOV AX, DATA
    MOV DS, AX   

   
START:  
    PUSH DX   
    PRINT_STR MSG1   
    POP DX

WAIT1:  
   
    CALL HEX_KEYB1                           ;wait until you read Yor N , if you read N stop
    CMP AL, 'N'
    JE MY_EXIT
    CMP AL, 'Y'        
    JNE WAIT1
    MOV AL ,0 
    CALL HEX_KEYB2                          ;1st digit
    CMP AL, 'N'
    JE MY_EXIT
    MOV DH,AL                               ; in DH
    
    CALL HEX_KEYB2                          ;2nd digit
    CMP AL, 'N'
    JE MY_EXIT
    MOV DL,AL                               ; in DL
    
    CALL HEX_KEYB2                          ;3nd digit
    CMP AL, 'N'
    JE MY_EXIT
    MOV BL,AL                               ; in BL
    
    ROL DL,4                                ; shift left for 4
    
                                              
    ADD DL,BL
   
    CMP DX ,3E8H                             ; if number>999,9 , print error
    JL INPUT                                ; else go to INPUT
    
    PUSH DX
    PRINT_STR MSG2                          ; print the error message
    NEW_LINE
    POP DX
    JMP START
    
INPUT:                                      ; number in DX -> AX
    MOV AX,DX 
    PUSH DX
    NEW_LINE                                ; BECAUSE NEWLINE USES DX
    POP DX
    CMP AX,500D                             ; 0<number<500 -> flag1  
    JNA FLAG1                            
    
FLAG2:
    CMP AX,700D                             ; 700=<number<1000 -> FLAG3
    JNA FLAG4                               ; 500=<number<700 -> flag4

FLAG3:    
    SUB AX , 700D                           ; number -700
    MOV DX, 4095D
    MUL DX 
    MOV CX, 300D
    DIV CX  
    ADD AX , 36855D 
    MOV CX ,0                               ; (1,8+0,2/300*(number -700))          *4095*10/2

DIGIT1: 
    MOV DX, 0
    MOV BX, 10D
    DIV BX 
    PUSH DX 
    INC CX
    CMP AX, 0
    JNE DIGIT1
    DEC CX
    JMP MY_PRINT

FLAG1:
    MOV DX, 4095D
    MUL DX 
    MOV CX, 100D 
    DIV CX
    MOV CX, 0                               ; 1/500 *number *4095*10/2

DIGIT2: 
    MOV DX, 0
    MOV BX, 10D
    DIV BX 
    PUSH DX 
    INC CX
    CMP AX, 0
    JNE DIGIT2
    DEC CX
    JMP MY_PRINT
            
FLAG4: 
    SUB AX, 500D                            ; ( 1+0,8/200*(number -500)) *4095*10/2
    MOV DX, 4095D
    MUL DX 
    MOV CX, 50D
    DIV CX 
    ADD AX, 20475D
    MOV CX, 0
DIGIT3: 
    MOV DX, 0
    MOV BX, 10D
    DIV BX 
    PUSH DX 
    INC CX
    CMP AX, 0
    JNE DIGIT3
    DEC CX
    JMP MY_PRINT
    
MY_PRINT: 
    POP DX
    PUSH DX 
    PRINT_DEC
    POP DX                                  ;print the digits of result 1 by 1 except the last digit
    LOOP MY_PRINT  
    PUSH DX                                 ;print .
    PRINT '.'
    POP DX
    POP DX                                  ;then print the last digit
    PUSH DX
    PRINT_DEC 
    NEW_LINE
    POP DX
    JMP START
    

    
MY_EXIT: 
    EXIT
    
   MAIN ENDP
            
            
            
            
            
            
HEX_KEYB1 PROC NEAR    
    PUSH DX
ARXH1:
    READ 
    CMP AL,30H 
    JL ARXH1 
    CMP AL,39H
    JG SYMBOL1                ;If input>=9, GO TO SYMBOL1   
    SUB AL,30H                ; IF NUMBER, sub 30
    JMP END1              
SYMBOL1:  
    CMP AL,'Y'			      
    JE END1
	CMP AL,'N'			      
    JE END1
    CMP AL,'A'
    JL ARXH1         
    CMP AL,'F'
    JG ARXH1 
    SUB AL,37H                ; A<=input<=F sub 37
END1:                          
    POP DX
    RET 
HEX_KEYB1 ENDP 

HEX_KEYB2 PROC NEAR    
    PUSH DX
ARXH2:
    READ  
    CMP AL,30H 
    JL ARXH2
    CMP AL,39H
    JG SYMBOL2                 ;If input>=9, GO TO SYMBOL2  
    SUB AL,30H                ; IF NUMBER, sub 30 
    JMP END2              
SYMBOL2:
    CMP AL,'N'
    JE END2  
    CMP AL,'A'
    JL ARXH2         
    CMP AL,'F'
    JG ARXH2 
    SUB AL,37H                ; A<=input<=F sub 37  
END2:                      
    POP DX 
    RET 
HEX_KEYB2 ENDP 