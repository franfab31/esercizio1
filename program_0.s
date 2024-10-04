        .data
v1: .byte 2, 6 , -3, 11, 9, 18, -13, 16, 5, 1
v2: .byte 4, 2 , -13, 3, 9, 9, 7, 16, 4, 7
v3: .space 10

flag1: .byte 0
flag2: .byte 0
flag3: .byte 0

.text
main:
    daddui r1, r0, 0
    daddui r3, r0, 0 ;indice di r3
    daddui r10, r0, 9; usato per il controllo

loop_1:
    beq r1, r10, sfs
    lb r4, v1(r1)
    daddui r2, r0, 0

loop_2:
    beq r2, r10, l_f1 ; ho finito di vedere v2
    lb  r5, v2(r2)
    daddui r2, r2, 1
    beq r4, r5, co_v3
    j loop_2

co_v3:
    dadd r7, r0, r0

c_v3:
    beq r7, r3, salva_v3 ; se non ci sono doppioni allora salva
    lb  r8, v3(r7)
    beq r4, r8, l_f1
    daddui r7, r7, 1
    j c_v3

salva_v3:
    sb  r4, v3(r3)
    lb r12, v3(r3)
    daddui r3, r3, 1
    j   l_f1

l_f1:
    daddui r1,r1, 1
    j loop_1

sfs:
    daddui r2, r0, 1
    beqz r3, fl1 ;se non ho elementi in v3
    j fl23

fl23:
    daddui r7, r0, 0
    beq r3, r2, fine ; se c'è solo un elemto setto flag2 e 3 a 0
    daddui r3,r3,-1
    lb r12, v3(r7)
    daddui r7,r7, 1
    lb r13, v3(r7)
    slt r4, r12, r13 ;se r13>r12 r4=1 altrimenti 0
    bnez r4, fl2 ; se v3[i+1]>v3[i] (r4!=0) allora potrei dovre cambiare fl2
    j fl3

fl1:
    sb r2, flag1(r0)
    j fine

fl2:
    beq r7, r3, setf2
    daddui r7,r7,1
    dadd r12, r0, r13
    lb r13, v3(r7)
    slt r4, r12, r13 ;se r13>r12 r4=1 altrimenti 0
    bnez r4, fl2
    j fine

fl3:
    beq r7, r3, setf3
    daddui r7, r7, 1
    dadd r12, r0, r13
    lb r13, v3(r7)
    slt r4, r12, r13 ;se r13>r12 r4=1 altrimenti 0
    beqz r4, fl3
    j fine


setf2:
    sb r2, flag2(r0)
    j fine

setf3:
    daddi r3,r0,2
    sb r2, flag3(r0)
    j fine

fine:
    halt


