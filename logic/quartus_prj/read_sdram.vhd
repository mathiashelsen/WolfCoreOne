library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity read_sdram is
    port(
	clk		:   in std_logic;
	rst		:   in std_logic;
	address		:   out std_logic_vector(28 downto 0);
	burstCount	:   out std_logic_vector(7 downto 0);
	waitRequest	:   in std_logic;
	data		:   in std_logic_vector(63 downto 0);
	dataValid	:   in std_logic;
	read		:   out std_logic;
	LEDs		:   out std_logic_vector(7 downto 0)
    );
end read_sdram;

architecture default of read_sdram is
    signal  ctr		:   std_logic_vector(31 downto 0) := X"0000_0000";
    type states is (init, waitForValid, sample, reset);
    signal  state	:   states := init;
begin
    process(rst, clk) begin
	if( rst = '1' ) then
	    ctr		<= X"0000_0000"; 
	    address	<= std_logic_vector(to_unsigned(0, address'length));
	    read	<= '0';
	    LEDs	<= X"00";
	    burstCount	<= X"01";
	elsif( clk'event and clk = '1' ) then
	    case state is
		when init =>
		    address(27 downto 0) <= X"EE4_0000";
		    read	<= '1';
		    burstCount	<= X"01";
		    state	<= waitForValid;
		    LEDs(7 downto 6)	<= B"00";
		    ctr	    <= X"017D_7840";
		when waitForValid =>
		    LEDs(7 downto 6)	<= B"01";
		    if( ctr = X"0000_0000") then
			state <= init;
		    else
			ctr <= ctr - X"1";
			if( dataValid = '1' ) then
			    state <= sample;
			end if;
		    end if;
		when sample=>
		    LEDs(7 downto 6)	<= B"10";
		    LEDs(3 downto 0)    <=  data(3 downto 0);
		    state   <= reset;
		    read    <= '0';
		    ctr	    <= X"017D_7840";
		when reset =>
		    LEDs(7 downto 6)	<= B"11";
		    if( ctr = X"0000_0000" ) then
			state <= init;
		    else 
			ctr <= ctr - X"1";
		    end if;
	    end case;
	end if;
    end process;
end architecture;
