library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
    port(
	instr		    : in std_logic_vector(4 downto 0);	    -- instruction (decoded)
	inputA		    : in std_logic_vector(31 downto 0);	    -- input data A
	inputB		    : in std_logic_vector(31 downto 0);	    -- input data B
	ALU_Out		    : out std_logic_vector(31 downto 0);    -- ALU results 
	ALU_Overflow    : out std_logic_vector(31 downto 0);    -- ALU overflow results 
	ALU_Status		: out std_logic_vector(31 downto 0)		-- Status of the ALU
    );
end ALU;

architecture default of ALU is
	constant LOAD	: std_logic_vector(4 downto 0) := X"01";
	constant STORE	: std_logic_vector(4 downto 0) := X"02";
	constant AND_OPC: std_logic_vector(4 downto 0) := X"03";
	constant OR_OPC	: std_logic_vector(4 downto 0) := X"04";
	constant XOR_OPC: std_logic_vector(4 downto 0) := X"05";
	constant ADD	: std_logic_vector(4 downto 0) := X"06";
	constant SUB	: std_logic_vector(4 downto 0) := X"08";
	constant SUBS	: std_logic_vector(4 downto 0) := X"09";
	signal overflow	: std_logic;
	signal allZeros	: std_logic;
	signal lmbOne	: std_logic;
	signal unsgndA	: unsigned(32 downto 0);
	signal unsgndB	: unsigned(32 downto 0);
	signal sgndA	: signed(32 downto 0);
	signal sgndB	: signed(32 downto 0);
	signal resTmp	: std_logic_vector(32 downto 0);
begin
	process(inputA, inputB, instr) begin
		unsgndA	<= to_unsigned(inputA, unsgndA'length);	
		unsgndB	<= to_unsigned(inputA, unsgndB'length);	
		sgndA	<= to_signed(inputA, sgndA'length);	
		sgndB	<= to_signed(inputA, sgndB'length);
	
		ALU_Status <= std_logic_vector(resize(to_unsigned(overflow & allZeros & lmbOne), ALU_Status'length));
	
		ALU_Overflow <= X"0000_0000";
	
		-- Check for all zeros output result
		if (ALU_Out = X"0000_0000") then
			allZeros	<= '1';
		else
			allZeros	<= '0';
		end if;
	
		-- Check if the left-most bit is '1'
		if( ALU_Out(31) = '1' ) then
			lmbOne		<= '1';
		else
			lmbOne		<= '0';
		end if;
	
		-- Under/overflow when ADD, SUB or SUBS
		if( instr = ADD or instr = SUB or instr = SUBS ) then
			overflow	<= resTmp(32);
		else
			overflow	<= '0';
		end if;
	
		case instr is
		when STORE =>
			ALU_Out <= inputA - X"1";
		when AND_OPC =>
			ALU_Out <= inputA and inputB;
		when OR_OPC =>
			ALU_Out <= inputA or inputB;
		when XOR_OPC =>
			ALU_Out <= inputA xor inputB;
		when ADD =>
			resTmp	<= std_logic_vector(resize(unsgnA, unsgndA'length+1) + resize(unsgndB, unsgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when SUB =>
			resTmp	<= std_logic_vector(resize(unsgnA, unsgndA'length+1) - resize(unsgndB, unsgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when SUBS =>
			resTmp	<= std_logic_vector(resize(sgndA, sgndA'length+1) - resize(sgndB, sgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when others =>
		    ALU_Out	<= X"0000_0000";
		end case;
	end process;
end architecture;
