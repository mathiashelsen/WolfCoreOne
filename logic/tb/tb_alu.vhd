library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- entity declaration for your testbench.dont declare any ports here
entity tb_alu is 
end tb_alu;

architecture behavior of tb_alu is
   -- component declaration for the unit under test (uut)
    component alu--'test' is the name of the module needed to be tested.
--just copy and paste the input and output ports of your module as such. 
    port( 
		instr		    : in std_logic_vector(4 downto 0);	    -- instruction (decoded)
		inputA		    : in std_logic_vector(31 downto 0);	    -- input data a
		inputB		    : in std_logic_vector(31 downto 0);	    -- input data b
		ALU_Out		    : buffer std_logic_vector(31 downto 0);    -- alu results 
		ALU_Overflow    : out std_logic_vector(31 downto 0);    -- alu overflow results 
		ALU_Status		: out std_logic_vector(31 downto 0)		-- status of the alu
        );
    end component;
   --declare inputs and initialize them

	signal instr	: std_logic_vector(4 downto 0) := "00000";	    -- instruction (decoded)
	signal inputA	: std_logic_vector(31 downto 0) := X"0000_0000";	    -- input data a
	signal inputB	: std_logic_vector(31 downto 0) := X"0000_0000";	    -- input data b
	signal ALU_Out	: std_logic_vector(31 downto 0);    -- alu results 
	signal ALU_Overflow	: std_logic_vector(31 downto 0);    -- alu overflow results 
	signal ALU_Status	: std_logic_vector(31 downto 0);		-- status of the alu
   -- clock period definitions
   constant clk_period : time := 10 ns;
begin
    -- instantiate the unit under test (uut)
   uut: alu port map (
			instr => instr,
			inputA => inputA,
			inputB => inputB,
			ALU_Out => ALU_Out,
			ALU_Overflow => ALU_Overflow,
			ALU_Status => ALU_Status
        );       

   -- clock process definitions( clock with 50% duty cycle is generated here.
   --clk_process :process
   --begin
   --     clk <= '0';
   --     wait for clk_period/2;  --for 0.5 ns signal is '0'.
   --     clk <= '1';
   --     wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   --end process;
   -- stimulus process
  stim_proc: process
   begin         
        wait for 5 ns;
		instr <= "00011";
		inputA <= X"0000_FFFF";
		inputB <= X"FFFF_0000";
		wait for 10 ns;
		inputB <= X"0000_FFFF";
        wait;
  end process;

end;

