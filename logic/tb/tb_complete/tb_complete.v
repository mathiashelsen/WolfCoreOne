`timescale 1ns / 1ps

module DE0_NANO_SOC_Default();

wire [31:0] cpuDataOut;
wire [31:0] cpuDataIn;
wire [31:0] cpuDataInAddr;
wire [31:0] cpuDataOutAddr;
wire cpuWrEn;
wire [31:0] instrBus;
wire [31:0] pcBus;
wire [31:0] CPU_StatusBus;
wire forceRoot;
wire flushing;

wire [31:0] instrCacheAddr;
wire [31:0] instrCacheData;			
			
wire [31:0] dataOutFlowCtrl;
wire [31:0] dataOutUART;
wire [31:0] dataOutDataCache;
wire [31:0] IRQBus;
wire [31:0] uartStatus;
reg clk;
reg rst;
wire TxD;

assign IRQBus       = 0;
assign IRQBus[0]    = uartStatus[2]; // RX buffer ready
assign IRQBus[1]    = uartStatus[1]; // TX complete

wolfcore CPU(
	.dataOutput(cpuDataOut),
	.dataInput(cpuDataIn),
	.dataInAddr(cpuDataInAddr),
	.dataOutAddr(cpuDataOutAddr),
	.dataWrEn(cpuWrEn),
	.instrInput(instrBus),
	.pc(pcBus),
	.CPU_Status(CPU_StatusBus),
	.rst(rst),
	.clk(clk),
	.forceRoot(forceRoot),
	.flushing(flushing)
	);
	
flowController instrCtrl(
	.rst(rst),
	.clk(clk),
	.pc(pcBus),
	.CPU_Status(CPU_StatusBus),
	.flushing(flushing),
	.instrOut(instrBus),
	.forceRoot(forceRoot),
	.memAddr(instrCacheAddr),
	.instrIn(instrCacheData),
	.IRQ(IRQBus),
	.inputAddr(cpuDataOutAddr),
	.outputAddr(cpuDataInAddr),
	.inputData(cpuDataOut),
	.outputData(dataOutFlowCtrl),
	.wrEn(cpuWrEn)
);	
	
progMem instrCache(
	.instrOutput(instrCacheData),
	.instrAddress(instrCacheAddr),
	.clk(clk)
);

dataController dataCache(
	.dataIn(cpuDataOut),
	.dataInAddr(cpuDataOutAddr),
	.dataOut(dataOutDataCache),
	.dataOutAddr(cpuDataInAddr),
	.wren(cpuWrEn),
	.clk(clk)
);

UART testUART(
	.clk(clk),
	.rst(rst),
	.RxD(1'b0),
	.TxD(TxD),
	.inputData(cpuDataOut),
        .inputAddr(cpuDataOutAddr),
        .outputData(dataOutUART), 
        .outputAddr(cpuDataInAddr),
        .wren(cpuWrEn),
        .uartStatus(uartStatus)
);

outputDataMux dataMux(
	.outputAddr(cpuDataInAddr),
	.outputDataUART(dataOutUART),
	.outputDataFlowCtrl(dataOutFlowCtrl),
	.outputDataDataCache(dataOutDataCache),
	.outputData(cpuDataIn)
	);

initial begin
    clk = 1'b0;
    forever begin
        #1
        clk = ~clk;
    end

end

initial begin
    rst = 1'b1;
    #10
    rst = 1'b0;
end

endmodule
