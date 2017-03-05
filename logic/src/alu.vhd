library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
	instr		    : in std_logic_vector(4 downto 0);	    -- instruction (decoded)
	inputA		    : in std_logic_vector(31 downto 0);	    -- input data A
	inputB		    : in std_logic_vector(31 downto 0);	    -- input data B
	ALU_Out		    : buffer std_logic_vector(31 downto 0);    -- ALU results 
	ALU_Overflow    : buffer std_logic_vector(31 downto 0);    -- ALU overflow results 
	ALU_Status		: buffer std_logic_vector(7 downto 0)		-- Status of the ALU
    );
end ALU;

architecture default of ALU is
	constant LOAD	: std_logic_vector(4 downto 0) := "00001";
	constant STORE	: std_logic_vector(4 downto 0) := "00010";
	constant AND_OPC: std_logic_vector(4 downto 0) := "00011";
	constant OR_OPC	: std_logic_vector(4 downto 0) := "00100";
	constant XOR_OPC: std_logic_vector(4 downto 0) := "00101";
	constant ADD	: std_logic_vector(4 downto 0) := "00110";
	constant SUB	: std_logic_vector(4 downto 0) := "00111";
	constant SUBS	: std_logic_vector(4 downto 0) := "01000";
	constant MOV	: std_logic_vector(4 downto 0) := "01001";
	constant BSL    : std_logic_vector(4 downto 0) := "01010";
	constant BSR    : std_logic_vector(4 downto 0) := "01011";
	signal unsgndA	: unsigned(31 downto 0);
	signal unsgndB	: unsigned(31 downto 0);
	signal sgndA	: signed(31 downto 0);
	signal sgndB	: signed(31 downto 0);
	signal resTmp	: std_logic_vector(32 downto 0);
begin
	process(inputA, inputB, instr, resTmp, unsgndA, unsgndB, sgndA, sgndB, ALU_Out, ALU_Overflow, ALU_Status) begin
		unsgndA	<= unsigned(inputA);	
		unsgndB	<= unsigned(inputB);	
		sgndA	<= signed(inputA);	
		sgndB	<= signed(inputB);
	
		ALU_Overflow <= X"0000_0000";
	
		-- Check for all zeros output result
		if (ALU_Out = X"0000_0000") then
			ALU_Status(7) <= '1';
		else
			ALU_Status(7) <= '0';
		end if;
	
		-- Check if the left-most bit is '1'
		if( ALU_Out(31) = '1' ) then
			ALU_Status(6) <= '1';
		else
			ALU_Status(6)	<= '0';
		end if;
	
		-- Under/overflow when ADD, SUB or SUBS
		if( instr = ADD or instr = SUB or instr = SUBS ) then
			ALU_Status(5)	<= resTmp(32);
		else
			ALU_Status(5)	<= '0';
		end if;

		ALU_Status(4 downto 0)	<= "00000";
		--	ALU_Status <= X"00";
	
		case instr is
		when STORE =>
			ALU_Out <= std_logic_vector(unsgndA - X"1");
		when AND_OPC =>
			ALU_Out <= inputA and inputB;
		when OR_OPC =>
			ALU_Out <= inputA or inputB;
		when XOR_OPC =>
			ALU_Out <= inputA xor inputB;
		when ADD =>
			resTmp	<= std_logic_vector(resize(unsgndA, unsgndA'length+1) + resize(unsgndB, unsgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when SUB =>
			resTmp	<= std_logic_vector(resize(unsgndA, unsgndA'length+1) - resize(unsgndB, unsgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when SUBS =>
			resTmp	<= std_logic_vector(resize(sgndA, sgndA'length+1) - resize(sgndB, sgndB'length+1));
			ALU_Out	<= resTmp(31 downto 0);
		when MOV =>
			ALU_Out <= inputB;
                when BSL =>
                        ALU_Out <= std_logic_vector(shift_left(unsgndA, to_integer(unsigned(inputB(4 downto 0)))));
                when BSR =>
                        ALU_Out <= std_logic_vector(shift_right(unsgndA, to_integer(unsigned(inputB(4 downto 0)))));
		when others =>
		    ALU_Out	<= X"0000_0000";
		end case;
	end process;
end architecture;
