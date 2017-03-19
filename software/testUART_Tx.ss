// First we create the base address of the UART module

MOV R0  1   A   R7  -cmp
MOV R0  0   A   R6  -cmp
BSL R7  17  A   R7  -cmp
MOV R0  0   A   R5  -cmp
ADD R7  1   A   R6  -cmp
ADD R7  2   A   R5  -cmp
MOV R0  0x14    A   R4  -cmp
MOV R0  R0  N   R0  -cmp
BSL R4  8   A   R4  -cmp
MOV R0  R0  N   R0  -cmp
OR  R4  0x58    A   R4  -cmp
MOV R0  R0  N   R0  -cmp
MOV R0  R4  A   *R6 -cmp
MOV R0  0x62 A   *R5 -cmp
MOV R0  1   A   *R7 -cmp
MOV R0  0   A   *R7 -cmp
