library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;

-- entity declaration for your testbench.Dont declare any ports here
entity tb_flowctrl is 
end tb_flowctrl;

architecture behavior of tb_flowctrl IS
   -- Component Declaration for the Unit Under Test (UUT)
    component flowController 
    port(
        -- Basic reset and clock
        rst         : in    std_logic;
        clk         : in    std_logic;
        -- Input from the CPU
        pc          : in    std_logic_vector(31 downto 0);
        CPU_Status  : in    std_logic_vector(31 downto 0);
        -- Output to the CPU
        instrOut    : out   std_logic_vector(31 downto 0);
        forceRoot   : out   std_logic;
        -- I/O with the program cache memory
        memAddr     : out   std_logic_vector(31 downto 0);
        instrIn     : in    std_logic_vector(31 downto 0);
        -- The bus on which the IRQ's arrive
        IRQBus      : in    std_logic_vector(31 downto 0);

        -- Control register input
        regAddr     : in    std_logic_vector(31 downto 0);
        regData     : in    std_logic_vector(31 downto 0);
        regOutput   : out   std_logic_vector(31 downto 0);
        regWrEn     : in    std_logic
    );
    end component;

    component progMem
    port(
        instrOutput     : out   std_logic_vector(31 downto 0);
        instrAddress    : in    std_logic_vector(31 downto 0);
        clk             : in    std_logic
    );
    end component;

    component wolfcore
    port( 
        dataOutput  : out std_logic_vector(31 downto 0);
        dataInput   : in std_logic_vector(31 downto 0);
        dataAddr    : out std_logic_vector(31 downto 0);
        dataWrEn    : out std_logic;
        instrInput  : in std_logic_vector(31 downto 0);
        pc          : buffer std_logic_Vector(31 downto 0);
        CPU_Status  : buffer std_logic_vector(31 downto 0);
        rst         : in std_logic;
        clk         : in std_logic;
        forceRoot   : in std_logic
        );
    end component;

    --declare inputs and initialize them
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';

    signal instrMem2Ctrl: std_logic_vector(31 downto 0);
    signal addrCtrl2Mem : std_logic_vector(31 downto 0);

    signal IRQBus       : std_logic_vector(31 downto 0);
    
    signal CPU_Status   : std_logic_vector(31 downto 0);
    -- Output to the CPU
    signal instrCtrl2CPU     : std_logic_vector(31 downto 0);
    signal forceRoot    : std_logic;

        -- Control register input
    signal  regAddr     : std_logic_vector(31 downto 0);
    signal  regData     : std_logic_vector(31 downto 0);
    signal  regOutput   : std_logic_vector(31 downto 0);
    signal  regWrEn     : std_logic;

    signal pcCPU2Ctrl   : std_logic_vector(31 downto 0);
   -- Clock period definitions
   constant clk_period : time := 100 ps;

    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: flowController port map (
        clk => clk,
        rst => reset,
        pc => pcCPU2Ctrl,
        CPU_Status => CPU_Status,
        instrOut => instrCtrl2CPU,
        forceRoot => forceRoot,
        memAddr => addrCtrl2Mem,
        instrIn => instrMem2Ctrl,
        IRQBus => IRQBus,
        regAddr => regAddr,
        regData => regData,
        regOutput => regOutput,
        regWrEn =>regWrEn
        );       

	mem: progMem port map(
		clk => clk,
		instrOutput => instrMem2Ctrl,
		instrAddress => addrCtrl2Mem 
	); 
        cpu: wolfcore port map (
            clk => clk,
            rst => reset,
            pc => pcCPU2Ctrl,
	    instrInput => instrCtrl2CPU,
	    dataInput => X"0000_0000",
            forceRoot   => forceRoot
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
        IRQBus      <= X"0000_0000";
        regAddr     <= X"0000_0000";
        regData     <= X"0000_0000";
        regWrEn     <= '0';

        wait for clk_period;
        reset <='1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        regData     <= X"0000_000B";
        regWrEn     <= '1';
        wait for clk_period;
        regWrEn     <= '0';
        wait for clk_period;
        IRQBus      <= X"0000_0001";
        wait for 20 ns;
        wait;
  end process;

END;
