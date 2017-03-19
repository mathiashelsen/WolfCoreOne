
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

//`define ENABLE_HPS
module DE0_NANO_SOC_Default(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_SCK,
	output		          		ADC_SDI,
	input 		          		ADC_SDO,
	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,
	
`ifdef ENABLE_HPS
	//////////// HPS //////////
	inout 		          		HPS_CONV_USB_N,
	output		    [14:0]		HPS_DDR3_ADDR,
	output		     [2:0]		HPS_DDR3_BA,
	output		          		HPS_DDR3_CAS_N,
	output		          		HPS_DDR3_CK_N,
	output		          		HPS_DDR3_CK_P,
	output		          		HPS_DDR3_CKE,
	output		          		HPS_DDR3_CS_N,
	output		     [3:0]		HPS_DDR3_DM,
	inout 		    [31:0]		HPS_DDR3_DQ,
	inout 		     [3:0]		HPS_DDR3_DQS_N,
	inout 		     [3:0]		HPS_DDR3_DQS_P,
	output		          		HPS_DDR3_ODT,
	output		          		HPS_DDR3_RAS_N,
	output		          		HPS_DDR3_RESET_N,
	input 		          		HPS_DDR3_RZQ,
	output		          		HPS_DDR3_WE_N,
	output		          		HPS_ENET_GTX_CLK,
	inout 		          		HPS_ENET_INT_N,
	output		          		HPS_ENET_MDC,
	inout 		          		HPS_ENET_MDIO,
	input 		          		HPS_ENET_RX_CLK,
	input 		     [3:0]		HPS_ENET_RX_DATA,
	input 		          		HPS_ENET_RX_DV,
	output		     [3:0]		HPS_ENET_TX_DATA,
	output		          		HPS_ENET_TX_EN,
	inout 		          		HPS_GSENSOR_INT,
	inout 		          		HPS_I2C0_SCLK,
	inout 		          		HPS_I2C0_SDAT,
	inout 		          		HPS_I2C1_SCLK,
	inout 		          		HPS_I2C1_SDAT,
	inout 		          		HPS_KEY,
	inout 		          		HPS_LED,
	inout 		          		HPS_LTC_GPIO,
	output		          		HPS_SD_CLK,
	inout 		          		HPS_SD_CMD,
	inout 		     [3:0]		HPS_SD_DATA,
	output		          		HPS_SPIM_CLK,
	input 		          		HPS_SPIM_MISO,
	output		          		HPS_SPIM_MOSI,
	inout 		          		HPS_SPIM_SS,
	input 		          		HPS_UART_RX,
	output		          		HPS_UART_TX,
	input 		          		HPS_USB_CLKOUT,
	inout 		     [7:0]		HPS_USB_DATA,
	input 		          		HPS_USB_DIR,
	input 		          		HPS_USB_NXT,
	output		          		HPS_USB_STP,
`endif /*ENABLE_HPS*/

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// GPIO_0, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  Structural coding
//=======================================================

assign GPIO_0  		=	36'hzzzzzzzz;
assign GPIO_1  		=	36'hzzzzzzzz;
			
//mainPLL PLL( FPGA_CLK1_50, SW[2], clk );

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
			
wire clk;
wire rst;
wire TxD;

assign GPIO_0[0] = TxD;
assign rst = SW[0];
assign clk = FPGA_CLK1_50;

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
	.IRQ(32'h00000000),
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

mmu dataCache(
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
        .wren(cpuWrEn)
);

outputDataMux dataMux(
	.outputAddr(cpuDataInAddr),
	.outputDataUART(dataOutUART),
	.outputDataFlowCtrl(dataOutFlowCtrl),
	.outputDataDataCache(dataOutDataCache),
	.outputData(cpuDataIn)
	);
	
endmodule
