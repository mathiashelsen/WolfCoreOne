library ieee;
use ieee.std_logic_1164.all;

entity wolfcore is
	port(
		dataOutput	: out std_logic_vector(31 downto 0);
		dataInput	: in std_logic_vector(31 downto 0);
		dataAddr	: out std_logic_vector(31 downto 0);
		dataWrEn	: out std_logic;
		instrInput	: in std_logic_vector(31 downto 0);
		instrAddr	: out std_logic_Vector(31 downto 0);
		CPU_Status	: buffer std_logic_vector(31 downto 0);
		rst			: in std_logic;
		clk			: in std_logic;
	);
end entity;

architecture default of wolfcore is
	type regFileType is array(3 downto 0) of std_logic_vector(31 downto 0);
	signal inputA	: std_logic_vector(31 downto 0);
	signal inputB	: std_logic_vector(31 downto 0);
	signal regFile	: regFileType;
	signal pc		: std_logic_vector(31 downto 0);
	signal ALU_Overflow : std_logic_vector(31 downto 0);
	signal ALU_Out	: std_logic_vector(31 downto 0);
	signal ALU_Result : std_logic_vector(31 downto 0);
	-- The instruction as it travels down the pipeline
	signal instrDecode	: std_logic_vector(31 downto 0);
	signal instrExecute	: std_logic_vector(31 downto 0);
	signal instrWB		: std_logic_vector(31 downto 0);
	-- Used during decode
	signal immEn	: std_logic;
	signal regA		: std_logic_vector(3 downto 0);
	signal regB		: std_logic_vector(3 downto 0);
	signal inputImm	: std_logic_vector(13 downto 0);

	-- Used during execute
	signal opcExecute: std_logic_vector(4 downto 0);
	signal wbReg	: std_logic_vector(3 downto 0);
	signal wbCond	: std_logic_vector(2 downto 0);
	signal wbEn		: std_logic;

	-- The magnificent combinatorial ALU! All hail the ALU!
	component ALU 
    	port(
		instr		    : in std_logic_vector(4 downto 0);	    -- instruction (decoded)
		inputA		    : in std_logic_vector(31 downto 0);	    -- input data A
		inputB		    : in std_logic_vector(31 downto 0);	    -- input data B
		ALU_Out		    : buffer std_logic_vector(31 downto 0);    -- ALU results 
		ALU_Overflow    : buffer std_logic_vector(31 downto 0);    -- ALU overflow results 
		ALU_Status		: buffer std_logic_vector(7 downto 0)		-- Status of the ALU
    	);

	end component;	

begin

	ALU: ALU port map( 
		instr => opcExecute,
		inputA => inputA,
		inputB => inputB,
		ALU_Out => ALU_Out,
		ALU_Overflow => ALU_Overflow,
		ALU_Status => CPU_Status(7 downto 0)
		);

process(clk, rst) begin
	if(rst = '1') then
		inputA	<= X"0000_0000";	
		inputB	<= X"0000_0000";	
		pc		<= X"0000_0000";	
		for i in regFile'range loop
			regFile(i)	<= X"0000_0000";
		end loop;
		instrDecode	<= X"0000_0000";
		instrExecute <= X"0000_0000";
		instrWB		<= X"0000_0000";

		immEn	<= '0';
		regA	<= X"0";
		regB	<= X"0";
		inputImm <= "00_0000_0000";
		opcExecute	<= "0_0000";
		wbReg	<= X"0";
		wbCond	<= "000";
		wbEn	<= '0';
	elseif(clk'event and clk = '1') then
		-- FETCH
		immEn	<= instrInput(31);
		regA	<= instrInput(30 downto 27);
		regB	<= instrInput(26 downto 23);
		inputImm <= instrInput(26 downto 13);

		-- DECODE
		instrDecode	<= instrInput;
		if(immEn) then
			inputB	<= resize(unsigned(inputImm), 32);
		else
			case conv_integer(unsigned(regB))
				when 0 to 12 =>
					inputB	<= regFile(conv_integer(unsigned(regB)));
				when 13 =>
					inputB	<= pc;
				when 14 =>
					inputB	<= ALU_Overflow;
				when 15 =>
					inputB	<= CPU_Status;
				when others =>
					inputB	<= X"0000_0000";
			end case;
		endif;
		case conv_integer(unsigned(regA))
			when 0 to 12 =>
				inputA	<= regFile(conv_integer(unsigned(regA)));
			when 13 =>
				inputA	<= pc;
			when 14 =>
				inputA	<= ALU_Overflow;
			when 15 =>
				inputA	<= CPU_Status;
			when others =>
				inputA	<= X"0000_0000";
		end case;
		opcExecute <= instr(12 downto 8);
	
		-- EXECUTE
		instrExecute	<= instrDecode;
		opcWriteBack	<= instrDecode(12 downto 0);
		wbReg			<= instrDecode(7 downto 4);
		wbCond			<= instrDecode(3 downto 1);
		wbEn			<= instrDecode(0);
		ALU_Result		<= ALU_Out;
		wbA				<= inputA;
		wbB				<= inputB;

		-- WRITEBACK
		-- If STORE operation
		if( opcWriteBack = "00010" ) then
			dataWrEn	<= '1';	
			dataOutput	<= wbA;
			dataAddr	<= wbB;
		-- Perhaps LOAD then?
		elseif ( opcWriteBack = "00001" ) then
			dataWrEn	<= '0';
			dataAddr	<= wbB;
		else
			dataWrEn	<= '0';
			dataOutput	<= X"0000_0000";
			dataAddr	<= X"0000_0000";
		end if;

	end if;	
end process;
end architecture;
