library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity write_sdram is
    port(
	clk		:   in std_logic;
	rst		:   in std_logic;
	address		:   out std_logic_vector(28 downto 0);
	waitRequest	:   in std_logic;
	data		:   out std_logic_vector(63 downto 0);
	write		:   out std_logic
    );
end write_sdram;

architecture default of write_sdram is
    signal  ctr		:   std_logic_vector(31 downto 0) := X"0000_0000";
    type states is (init, waitForValid, writeData, idle);
    signal  state	:   states := init;
    signal  dataCache	:   std_logic_vector(31 downto 0) := X"FAFA_FAFA";
begin
    process(rst, clk) begin
	if( rst = '1' ) then
	    ctr		<= X"0000_0000"; 
	    address	<= std_logic_vector(to_unsigned(0, address'length));
	    write	<= '0';
	    state	<= init;
	elsif( clk'event and clk = '1' ) then
	    case state is
		when init =>
		    address(27 downto 0) <= X"772_0000";
		    write   <= '0';
		    state   <= waitForValid;
		    ctr	    <= X"017D_7840";
		when waitForValid =>
		    if( ctr = X"0000_0000") then
			state <= init;
		    else
			ctr <= ctr - X"1";
			state <= writeData;
		    end if;
		when writeData =>
		    write   <= '1';
		    data    <= dataCache & '0' & dataCache(31 downto 1);
		    ctr	    <= X"017D_7840";
		    if( waitRequest = '0' ) then
			state   <= idle;
		    end if;
		when idle =>
		    write	<= '0';
		    
		    if( ctr = X"0000_0000" ) then
			state <= init;
		    else 
			ctr <= ctr - X"1";
		    end if;
	    end case;
	end if;
    end process;
end architecture;
