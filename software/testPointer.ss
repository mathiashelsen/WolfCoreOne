
// Testing reading and writing to memory

MOV     R0      0   A   R0
MOV     R0      10  A   R1
MOV     R0      0   N   R0
MOV     R0      0   N   R0
MOV     R0      25  A   *R0
MOV     R0      30  A   *R1
MOV     R0      0   N   R0
MOV     R0      0   N   R0
MOV     R0      0   N   R0
MOV     R0      0   N   R0
MOV     R0      0   N   R0
ADD     *R0     *R1 A   R3
