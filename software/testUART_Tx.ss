// First we create the base address of the UART module

MOV R0  1   A   R7  -cmp
MOV R0  0   A   R6  -cmp
BSL R7  17  A   R7  -cmp
MOV R0  0   A   R5  -cmp
ADD R7  1   A   R6  -cmp
ADD R7  2   A   R5  -cmp
MOV R0  10  A   *R6 -cmp
MOV R0  0xA A   *R5 -cmp
MOV R0  1   A   *R7 -cmp
MOV R0  0   A   *R7 -cmp
