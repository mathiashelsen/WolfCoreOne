
// Program to verify interupt handling

#label _initISR
MOV R0  1   A   R1
MOV R0  _ISR    A   R2
NOP R0  0   N   R0
BSL R1  24  A   R1
NOP R0  0   N   R0
NOP R0  0   N   R0
STORE   R2  R1  N   R0


#label _init
MOV R0  0   A   R0
MOV R0  20  A   R5
NOP R0  0   N   R0
NOP R0  0   N   R0

// Das loop
#label _loop
ADD R0  1   A   R0
NOP R0  0   N   R0
NOP R0  0   N   R0
SUB R5  R0  N   R0  +cmp
MOV R0  _loop   NZ PC
MOV R0  _init   Z  PC

#label _ISR
ADD R0  5   A   R7 +cmp
MOV R0  1   A   R1
NOP R0  0   N   R0
NOP R0  0   N   R0
BSL R1  24  A   R1
MOV R0  1   A   R2
NOP R0  0   N   R0
OR  R1  32  A   R1
NOP R0  0   N   R0
NOP R0  0   N   R0
STORE   R2  R1  N   R0
NOP R0  0   N   R0
NOP R0  0   N   R0
