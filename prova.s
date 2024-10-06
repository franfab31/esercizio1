.data
v1:     .byte 10,9,8,7,6,5,4,3,2,1
v2:     .byte 1,2,3,4,5,6,7,8,9,10
v3:     .space 10  
len:    .word 10                             
flag1:  .byte 1 ;1 se v3 è vuoto, 0 altrimenti 
flag2:  .byte 0 ;1 se v3 è crescente, 0 altrimenti 
flag3:  .byte 0 ;1 se v3 è decrescente, 0 altrimenti 
                            

.text

main:    
    dadd R1, R0, R0  ;indice per v1
    dadd R3, R0, R0   ;indice per v3
    lw   R5, len(R0)            

Scorre_v1:
    beq  R1, R5, verifica_flags 
    lb   R10, v1(R1)   
    dadd R2, R0, R0    ;indice per v2 

Confronta_v1v2:
    beq  R2, R5, Next_v1  
    lb   R11, v2(R2)    
    beq  R10, R11, Match   

    daddi R2, R2, 1      
    j Confronta_v1v2    

Match: 
    dadd R7, R0, R0  ;indice per controllare v3
Check_v3:
    beq  R7, R3, SaveElement   ;non ci sono dupl
    lb   R12, v3(R7)        
    beq  R10, R12, Next_v1   ;ele già in v3
    daddi R7, R7, 1  
    j Check_v3          

SaveElement: 
    sb   R10, v3(R3)       ;salviamo in v3
    daddi R3, R3, 1          ;indice di v3++
    sb   R0, flag1(R0)  ;flag1 a 0 (v3 non è vuoto)
    j Next_v1            

Next_v1:
    daddi R1, R1, 1     
    j Scorre_v1       

verifica_flags:
    beqz R3, end   ;se v3 vuoto terminiamo  
    dadd R7, R0, R0      ;indice per v3
    lb   R8, v3(R7)   ; R8 = primo elemento di v3  

check_crescente:
    daddi R7, R7, 1 
    beq R7, R3, set_flag2   ;se R7 è uguale a R6, v3 è tutto crescente
    lb   R9, v3(R7)       ;R12=ele successivo
    slt  R14, R8, R9        ;Controlla se v3[i] < v3[i+1]
    beqz R14, check_decrescente ; se = 0 non è crescente, salta al controllo decrescente
    dadd R8, R0, R9            ; aggiorna R8 =nuovo elemento corrente
    j check_crescente   

check_decrescente:
    dadd R7, R0, R0     
    lb   R8, v3(R7)     ;R8= primo elemento di v3
    
checkdl:
    daddi R7, R7, 1       ;incrementa l'indice
    beq R7, R3, set_flag3   ;se siamo alla fine di v3 abbiamo controllato tutto e sono tutti decrescenti-> flag3 a 1
    lb   R9, v3(R7)        ;R9=elemento successivo di v3
    slt  R14, R9, R8      ;v3[i] > v3[i+1] 
    beqz R14, end         ;se = 0 non è neanche decrescente, termina
    dadd R8, R9, R0       
    j checkdl

set_flag2:
daddi R4, R0, 1
sb   R4, flag2(R0)   
j end               

set_flag3:
daddi R4, R0, 1
sb   R4, flag3(R0)   
j end            

end:
    HALT