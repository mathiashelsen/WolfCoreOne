module ALU(input [31:0]A, input [31:0]B, input [4:0]Opc, input [7:0]statusIn, output reg [7:0]statusOut, output reg [31:0]OutA, output reg [31:0]overflow);
`define LOAD	    5'h1
`define STORE	    5'h2
`define AND	    5'h3
`define OR	    5'h4
`define XOR	    5'h5
`define ADD	    5'h6
`define ADDC	    5'h7
`define SUB	    5'h8
`define MUL	    5'h9
`define DIV	    5'hA
`define SDIV	    5'hB

wire carryIn;
assign carryIn = gtatusIn[1];

wire [31:0] addResult;
wire carryOut;
assign {carryOut, addResult} = A + B;

wire [63:0] mulResult;
assign mulResult = A * B;

wire [31:0] divRes, divMod;

uDivOp myDiv(
	B,
	A,
	divRes,
	divMod);

always @(*) begin
    statusOut[0] = (OutA == 32'h0);
    statusOut[2] = OutA[31];

    if( (Opc == `ADD) || (Opc == `ADDC) )
	statusOut[1] = carryOut;
    else
	statusOut[1] = 1'b0;
end

always @(*) begin
    if( Opc == `MUL )
	overflow = mulResult[63:32];
    else if ( Opc == `DIV )
	overflow = divMod;
    else
	overflow = 0;
end

always @(*) begin
    case(Opc)
	`STORE: begin
	    OutA = B - 32'h1;
	end
	`AND: begin
	    OutA = A & B;
	end
	`OR: begin
	    OutA = A | B;
	end
	`XOR: begin
	    OutA = A ^ B;
	end
	`ADD: begin
	    OutA = addResult[31:0];
	end
	`ADDC: begin
	    OutA = addResult[31:0] + carryIn;
	end
	`SUB: begin
	    OutA = A - B;
	end
	`MUL: begin
	    OutA = mulResult[31:0];
	end
	`DIV: begin
	    OutA = divRes;
	end
	default: begin
	    OutA = 32'h0;
	end
    endcase
end

endmodule
