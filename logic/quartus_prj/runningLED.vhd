library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity runningLED is
	port(
		clk			: in std_logic;			    			-- master clock signal
		LED_output	: out std_logic_vector(7 downto 0)
);
end runningLED;

architecture default of runningLED is
	signal ctr : unsigned(31 downto 0);
	signal pattern : std_logic_vector(7 downto 0);
begin	
	process( clk ) begin
		if (clk'event and clk = '1') then
			if(ctr = 5000000) then
				ctr <= X"0000_0000";
				pattern <= pattern + X"1";
				LED_output <= pattern;
			else
				ctr <= ctr + 1;
			end if;
		end if;
	end process;
end architecture;