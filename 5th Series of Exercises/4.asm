INCLUDE MACRO_INST.ASM
    .8086
    .MODEL SMALL
    .STACK 256
        
    .DATA
    TABLE DB 16 DUP(?)


    .CODE
    ASSUME DS:DATA
    
MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
   
START:
    MOV DI,0			;initialize DI to 0 
    MOV CX,0			; same for CX
    
READING:
    READ_IN
    CMP AL,13			;compare AL with ASCII of enter 
    JE END_PROG                                 	;if enter is pressed end.
    CMP AL,'0'			;numbers > 0 -> accept 
    JL READING                                 	;else read again
    CMP AL,'9'			;accept numbers < 9
    JNA ACCEPTED			
    CMP AL,'A'			;accepts letters between A
    JL READING
    CMP AL,'Z'			;and Z
    JG READING			;if not read again else accept
    
ACCEPTED:
    MOV [TABLE + DI],AL		;insert in table if terms are fullfilled
    INC DI			;DI ++
    INC CL                                             ;CL++                           
    CMP CL,16                               	;if we reach 16 characters then print them 
    JZ PRINT_OUT                            
    JMP READING
    
PRINT_OUT:
    MOV DI,0			;DI<-0
PRINT_LOOP:
    MOV AL,[TABLE + DI]                   ;print chars until we have printed all of them.
    PRINT AL                                	
    INC DI                                  
    INC CH
    CMP CH,15
    JG YAPRINT			;then go to PRINT2
    JMP PRINT_LOOP
        
YAPRINT:
    NEW_LINE			;print new line
    MOV DI,0
    MOV CH,0
YAPRINT_LOOP:                                	;we iterate over the table and when we find a number we print it
    MOV AL,[TABLE + DI]                   ;when we reach 16 chars(AL = 16) we have printed all the numbers
    CMP AL,3AH                              	;and then we print small letters
    JL PRINT_NUM
    JMP CONTINUING
PRINT_NUM:
    PRINT AL
CONTINUING:
    INC DI			;DI++
    INC CH			;CH++
    CMP CH,15			;compare with 15
    JG PRINT_LETTERS		
    JMP YAPRINT_LOOP
    
PRINT_LETTERS:
    PRINT '-'			;print a dash first 
    MOV DI,0                                	
    MOV CH,0                                	
PRINT_LETTERS_LOOP:                   
    MOV AL,[TABLE + DI] 		;we run the table again and now we print only the letters
    CMP AL,41H
    JGE PRINT_A_LET
    JMP CONTINUING2
PRINT_A_LET:
    ADD AL,32			;we convert caps to regular
    PRINT AL			; and print them
CONTINUING2:
    INC DI			;DI++
    INC CH			;CH++
    CMP CH,15			;if we reach the end of the table 
    JG BEGINNING		
    JMP PRINT_LETTERS_LOOP
        
BEGINNING:			;then we have finished and we change line and go to start
    NEW_LINE
    JMP START    
    
END_PROG:			;program ends through here
    EXIT
    MAIN ENDP
