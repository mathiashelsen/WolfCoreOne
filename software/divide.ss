
// This test program calculates both the modulo
// and the division value

#def retAddr R0
#def num	R1
#def den	R2
#def mod	R3
#def quo	R4

#def wr		R5

// This should happen before the function call...
MOV R0 21 A num
MOV R0 5 A den
NOP R0 R0 N R0
NOP R0 R0 N R0
NOP R0 R0 N R0

#label _init
AND wr 0 A wr 
AND mod 0 A mod
AND quo 0 A quo 
ADD num 0 A wr +cmp
NOP R0 R0 N R0
NOP R0 R0 N R0


#label _loop
SUB wr den A wr +cmp
MOV PC _finish OF PC
ADD quo 1 NOF quo 
MOV PC _loop NOF PC 
NOP R0 R0 N R0

#label _finish
ADD wr den A mod +cmp
