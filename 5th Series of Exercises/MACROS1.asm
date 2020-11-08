READ MACRO          ; AL <- ascii code
     MOV AH, 8
     INT 21H
ENDM

PRINT MACRO CHAR    
      MOV DL, CHAR
      MOV AH, 2
      INT 21H
ENDM     

PRINT_STR MACRO STRING
    MOV DX, OFFSET STRING 
    MOV AH,9
    INT 21H
ENDM  

EXIT MACRO 
     MOV AX, 4C00H 
     INT 21H
ENDM
          
NEW_LINE MACRO
    PUSH DX
    PUSH AX ; save them because we will use them

    MOV DX,13  ; DL <- 0DH (newline)
    MOV AH,2    ;  \ 
    INT 21H     ;  /  print char macro

    MOV DX,10   ; DL <- 0AH (go to the beggining of the line)
    MOV AH,2    ; \
    INT 21H     ; /  print char macro

    POP AX
    POP DX  ; pop from the stack
ENDM


