INCLUDE MACROS1.ASM
    .8086
    .MODEL SMALL
    .STACK 256    


  
.DATA

.CODE       
   ASSUME CS:CODE, DS:DATA

MAIN PROC FAR

	MOV AX, DATA
	MOV DS,AX 

START:
    		
     CALL HEX_KEYB         ;read 1ST digit
     CMP AL,'Q'         
     JE FINISH           
     ROL AL,4  			; MOVE IT TO 4 LSB  
     MOV BL,AL   		; MOVE IT TO 4 LSB
     
     CALL HEX_KEYB          ; read 2ND digit
     CMP AL,'Q'             
     JE FINISH
     ADD BL,AL 			; SUM IN BL
      
     NEW_LINE
     
     PUSH BX			; PRINT HEX
     CALL PRINT_HEX
     PRINT '='          ; =
     POP BX 			
     
     PUSH BX 			  
     CALL PRINT_DEC     ; PRINT DEC
     PRINT '='
     POP BX 			; =
     
     PUSH BX			 
     CALL PRINT_OCT     ; PRINT OCT
     PRINT '='
     POP BX 			; =
     
     CALL PRINT_BIN     ; PRINT BIN

     JMP START

FINISH:
    EXIT

MAIN ENDP 

; -----------------------------------------------------

HEX_KEYB PROC NEAR    
    PUSH DX
ARXH1:
    READ 
    CMP AL,30H        ; if <= 30 then skip it
    JL ARXH1 
    CMP AL,39H
    JG SYMBOL                 ; INPUT >= 9 GO TO SYMBOL    
    SUB AL,30H                ; HERE IT IS A NUMBER SO sub 30 FOR THE ascii
    JMP FINAL              
SYMBOL:  
    CMP AL,'Q'			; if Q, SAVE IT AND WE WILL QUIT AFTER 
    JE FINAL
    CMP AL,'A'
    JL ARXH1            ; BAD SYMBOL         
    CMP AL,'F'
    JG ARXH1            ; BAD SYMBOL 
    SUB AL,37H           ; TURN TO ASCII
FINAL:                   
    POP DX 
    RET 
ENDP HEX_KEYB      
                  
; -------------------------------------------------
                  
PRINT_DEC PROC NEAR     
    MOV AH,0            ; AH<- 0
    MOV AL,BL 			; AL <- the 2 digits
    MOV BL,10           ; BL <- 10, the divisor 	
    MOV CX,1 			; decs counter

LOOP1: 
    DIV BL			; AX<-AX/BL, AL<-phliko, AH<-ypoloipo
    PUSH AX         ; save decs    
    CMP AL,0 		; if decs=0 -> WE HAVE PUSHED ALL THE DIGITS  
    JE DEC_DIGITS 	    ;    
    INC CX			; decs counter ++  FOR THE LOOP LATER
    MOV AH,0        ;
    JMP LOOP1		; loop again

DEC_DIGITS:
    POP DX			; digit TO PRINT at DH (we pushed AX, with the ypoloipo at AH)
    MOV DL,DH       ; DL <- digit
    MOV DH,0		
    ADD DX,30H      ; to get ascii code if the digit			
    MOV AH,2
    INT 21H			; the 2 print steps
    LOOP DEC_DIGITS  	; repeat for each digit  (CX TIMES)    
    RET
ENDP PRINT_DEC     
     
; -------------------------------------------------
            

PRINT_OCT PROC NEAR     ; same process but we divide with 8 instead of 10
    MOV AH,0
    MOV AL,BL 			
    MOV BL,8 	
    MOV CX,1     
    			
LOOP2: 
    DIV BL			
    PUSH AX             	     
    CMP AL,0 			 
    JE OCT_DIGITS 	    
    INC CX			
    MOV AH,0   
    JMP LOOP2
    			
OCT_DIGITS:
    POP DX			
    MOV DL,DH
    MOV DH,0			
    ADD DX,30H			
    MOV AH,2
    INT 21H			    
    LOOP OCT_DIGITS  	       
    RET
ENDP PRINT_OCT            
        
; --------------------------------------------------------

PRINT_BIN PROC NEAR     ; same process but we divide with 2 instead of 8
    MOV AH,0
    MOV AL,BL 			
    MOV BL,2 	
    MOV CX,1 			

LOOP3: 
    DIV BL			
    PUSH AX             	     
    CMP AL,0 			 
    JE BIN_DIGITS 	   
    INC CX			
    MOV AH,0   
    JMP LOOP3			

BIN_DIGITS:
    MOV DH, AL
    PUSH DX
    POP DX
DIGITS2:
    POP DX			
    MOV DL,DH
    MOV DH,0			
    ADD DX,30H			
    MOV AH,2
    INT 21H			
    LOOP DIGITS2  	        
    RET
ENDP PRINT_BIN   
                    
; -------------------------------------------------------------                    
                    
PRINT_HEX PROC NEAR    ; same process but we divide with 16 instead of 2
    MOV AH,0
    MOV AL,BL 			
    MOV BL,16 	
    MOV CX,1 			

LOOP4: 
    DIV BL			
    PUSH AX             	     
    CMP AL,0 			 
    JE HEX_DIGITS 	    
    INC CX			
    MOV AH,0   
    JMP LOOP4			
   
HEX_DIGITS:
    POP DX			
    MOV DL,DH
    MOV DH,0			 
    CMP DL,10       ; difference to make the ascii code
    JL  USUAL
    ADD DX,37H
    JMP AFTER_ASCII
USUAL:  
    ADD DX,30H      ; number < 10 so the digit is 0,1,...,9 and we need to add 41 to get the ascii code
AFTER_ASCII:    			
    MOV AH,2
    INT 21H			
    LOOP HEX_DIGITS  	      
    RET
ENDP PRINT_HEX         

; --------------------------------------------------------------