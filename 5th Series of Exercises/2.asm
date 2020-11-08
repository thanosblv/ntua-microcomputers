INCLUDE MACRO_INST.ASM    
    .8086
    .MODEL SMALL
    .STACK 256 

DATA_SEG SEGMENT
    TABLE DB 256 DUP(?)
    MIN db ?
    MAX db ?
DATA_SEG ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX                           
    MOV AL,254                          		;first number to be stored -> 254                      
    MOV DI,0                            		;index = 0
   
TABLE_SV:
    MOV [TABLE + DI],AL                 		;save number in TABLE
    DEC AL                              		;AL<- ÁL - 1
    INC DI                              		;index++
    CMP AL,0                            		;if we reached 0 then exit loop
    JNE TABLE_SV			;else continue 
    
    MOV [TABLE + DI],255                		;255 will be stored last place after 0
    
    MOV DI,0				;initialize index
    MOV AH,0				;initialize AH
    MOV DX,0				;initialize DX
    
MEAN:
    MOV AL,[TABLE + DI]                 		;load even number
    ADD DX,AX                           		;the sum which will then be divided for the mean value
    ADD DI,2                            		;we only want even numbers so we add 2 
    CMP DI,254
    JL MEAN				;if di > 254 exit loop else continue adding 
    
    ADD AL,[TABLE + DI]                 		
    ADD DX,AX                          		;add to sum the last place of the table
    MOV AX,DX                           		;move sum to accumulator AX
    MOV BH,0				
    MOV BL,128                          		
    DIV BL          			                ;divide sum with 128-> the number of even numbers
    
    MOV AH,0    
                                        			;print mean value in hex form
    CALL PRINT_NUMBER                
    NEW_LINE                         		;print new line 
    
    MOV DI,0                      			;initialize DI->0
    MOV MIN,0xFF                        		;initialize MIN-> 255
    MOV MAX,0                           		;initialize MAX-> 0
    
MIN_AND_MAX:
    MOV AL,[TABLE + DI]                 		;load number of TABLE[DI] to AL 
    CMP MIN,AL				;compare with MIN
    JB IT
    MOV MIN,AL                          		;if AL < MIN then MIN = AL  
IT:
    CMP MAX,AL				;compare with MAX
    JA IT2
    MOV MAX,AL                          		;if AL > MAX then MAX = AL
IT2:    
    INC DI                              		;increase index
    CMP DI,256                          		
    JNE MIN_AND_MAX                         		;if we have reached 256 - 1 exit
    
    MOV AH,0
    MOV AL,MIN                          
    CALL PRINT_NUMBER                   	;print min in hex form
    PRINT ' '                           		;print ' '
    MOV AH,0
    MOV AL,MAX
    CALL PRINT_NUMBER                   	;print max in hex form
    NEW_LINE				;print new line 
     
       
ENDP                 
EXIT

PRINT_NUMBER PROC NEAR                  	;routine for printing number in hex
    
    MOV BL,16                           
    MOV CX,1                            		;sixteens count
LOOP1:
    DIV BL                              		;divide number with 16
    PUSH AX                             		;save units
    CMP AL,0                            		;continue until we have found the digits 
    JE PRINT_HEX                         		
    INC CX                              		;increment number of sixteens
    MOV AH,0                            
    JMP LOOP1
PRINT_HEX:
    POP DX				
    MOV DL,DH
    MOV DH,0                            
    CMP DL,09H
    JLE DO
    ADD DX,37H                          		;ASCII offset for A B C D E F
    JMP DO1
    			
DO:                                   		;ASCII offset for single digit
    ADD DX,30H				
DO1:
    MOV AH,2
    INT 21H				
    LOOP PRINT_HEX       
    RET
ENDP PRINT_NUMBER

