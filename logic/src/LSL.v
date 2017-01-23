module LSL(input [31:0]A, input [4:0]shift, output reg [31:0]OutA);

wire [63:0]doubled_A;
assign doubled_A = {A, A};

always@(*)
case(shift)
    0 : OutA = doubled_A[ 63 : 32 ];
    1 : OutA = doubled_A[ 62 : 31 ];
    2 : OutA = doubled_A[ 61 : 30 ];
    3 : OutA = doubled_A[ 60 : 29 ];
    4 : OutA = doubled_A[ 59 : 28 ];
    5 : OutA = doubled_A[ 58 : 27 ];
    6 : OutA = doubled_A[ 57 : 26 ];
    7 : OutA = doubled_A[ 56 : 25 ];
    8 : OutA = doubled_A[ 55 : 24 ];
    9 : OutA = doubled_A[ 54 : 23 ];
    10 : OutA = doubled_A[ 53 : 22 ];
    11 : OutA = doubled_A[ 52 : 21 ];
    12 : OutA = doubled_A[ 51 : 20 ];
    13 : OutA = doubled_A[ 50 : 19 ];
    14 : OutA = doubled_A[ 49 : 18 ];
    15 : OutA = doubled_A[ 48 : 17 ];
    16 : OutA = doubled_A[ 47 : 16 ];
    17 : OutA = doubled_A[ 46 : 15 ];
    18 : OutA = doubled_A[ 45 : 14 ];
    19 : OutA = doubled_A[ 44 : 13 ];
    20 : OutA = doubled_A[ 43 : 12 ];
    21 : OutA = doubled_A[ 42 : 11 ];
    22 : OutA = doubled_A[ 41 : 10 ];
    23 : OutA = doubled_A[ 40 : 9 ];
    24 : OutA = doubled_A[ 39 : 8 ];
    25 : OutA = doubled_A[ 38 : 7 ];
    26 : OutA = doubled_A[ 37 : 6 ];
    27 : OutA = doubled_A[ 36 : 5 ];
    28 : OutA = doubled_A[ 35 : 4 ];
    29 : OutA = doubled_A[ 34 : 3 ];
    30 : OutA = doubled_A[ 33 : 2 ];
    31 : OutA = doubled_A[ 32 : 1 ];
endcase

endmodule
