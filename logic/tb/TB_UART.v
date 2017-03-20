`timescale 1ns / 100ps

module TB_UART();

reg RxD;
reg clk;
reg rst;

UART testUART(
	.clk(clk),
	.rst(rst),
	.RxD(RxD),
	.TxD(),
	.inputData(32'h00000000),
        .inputAddr(32'h00000000),
        .outputAddr(32'h00000000),
        .wren(1'b0)
);

initial begin
    clk = 1'b0;
    forever begin
        #20
        clk = ~clk;
    end

end

initial begin
    rst = 1'b1;
    #10
    rst = 1'b0;

end

initial begin
    RxD = 1'b1;
    #(104167)
    RxD = 1'b0;     //START
    #(104167)
    RxD = 1'b1;     // 1
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b1;     // 1
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b0;     // 0
    #(104167)
    RxD = 1'b1;     // STOP
    #(104167)
    RxD = 1'b1;     // --IDLE--
end

endmodule
