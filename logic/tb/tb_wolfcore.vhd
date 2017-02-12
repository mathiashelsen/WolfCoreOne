library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;

-- entity declaration for your testbench.Dont declare any ports here
entity tb_wolfcore is 
end tb_wolfcore;

architecture behavior of tb_wolfcore IS
   -- Component Declaration for the Unit Under Test (UUT)
    component wolfcore
    port( 
		dataOutput	: out std_logic_vector(31 downto 0);
		dataInput	: in std_logic_vector(31 downto 0);
		dataAddr	: out std_logic_vector(31 downto 0);
		dataWrEn	: out std_logic;
		instrInput	: in std_logic_vector(31 downto 0);
		pc			: buffer std_logic_Vector(31 downto 0);
		CPU_Status	: buffer std_logic_vector(31 downto 0);
		rst			: in std_logic;
		clk			: in std_logic
        );
    end component;

	component progMem
	port(
		instrOutput	: out std_logic_vector(31 downto 0);
		instrAddress: in std_logic_vector(31 downto 0);
		clk			: in std_logic
	);
	end component;
   --declare inputs and initialize them
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

   signal instrBus : std_logic_vector(31 downto 0);
	signal addrBus : std_logic_vector(31 downto 0);
   -- Clock period definitions
   constant clk_period : time := 1 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: wolfcore PORT MAP (
         clk => clk,
         rst => reset,
		pc => addrBus,
		instrInput => instrBus,
		dataInput => X"0000_0000"
        );       

	mem: progMem port map(
		clk => clk,
		instrOutput => instrBus,
		instrAddress => addrBus
	); 

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
   -- Stimulus process
  stim_proc: process
   begin         
        wait for 5 ns;
        reset <='1';
        wait for 5 ns;
        reset <='0';
        wait for 20 ns;
        wait;
  end process;

END;
