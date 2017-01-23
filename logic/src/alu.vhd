library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
    port(
	clk			    : in std_logic;			    			-- master clock signal
	rst			    : in std_logic;			    			-- async reset
	instr		    : in std_logic_vector(4 downto 0);	    -- instruction (decoded)
	inputA		    : in std_logic_vector(31 downto 0);	    -- input data A
	inputB		    : in std_logic_vector(31 downto 0);	    -- input data B
	ALU_Out		    : out std_logic_vector(31 downto 0);    -- ALU results 
	ALU_Overflow    : out std_logic_vector(31 downto 0);    -- ALU overflow results 
	ALU_Status_Out	: out std_logic_vector(7 downto 0);    -- Status of the ALU
	ALU_Status_In	: in std_logic_vector(7 downto 0);
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
begin
    process( clk, rst ) begin
	if( rst = '1' ) then
	    ALU_Out		<= X"0000_0000";
	    ALU_Status_Register	<= X"0000_0000";
		ALU_Status_Out	<= X"00";
	elsif (clk'event and clk = '1') then
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
			ALU_Out <= std_logic_vector(to_unsigned(unsigned(inputA) + unsigned(inputB) + unsigned(ALU_Status_In(0))));
		when others =>
		    null;
	    end case;
	end if;
    end process;
end architecture;
