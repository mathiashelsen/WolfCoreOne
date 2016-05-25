library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
    port(
	clk		    : in std_logic;			    -- master clock signal
	rst		    : in std_logic;			    -- async rester
	instr		    : in std_logic_vector(7 downto 0);	    -- instruction (decoded)
	inputA		    : in std_logic_vector(63 downto 0);	    -- input data A
	inputB		    : in std_logic_vector(63 downto 0);	    -- input data B
	ALU_Out		    : out std_logic_vector(63 downto 0);    -- ALU results 
	ALU_Status_Register : out std_logic_vector(63 downto 0);    -- Status of the ALU
	writeback_In	    : in std_logic_vector(7 downto 0);	    -- blind copy in to out
	writeback_Out	    : out std_logic_vector(7 downto 0);
	registerC_In	    : in std_logic_vector(7 downto 0);	    -- blind copy in to out
	registerC_Out	    : out std_logic_vector(7 downto 0);
    );
end ALU;
