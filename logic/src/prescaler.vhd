library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity prescaler is
	generic(
		  n: integer);
	port (
		clock_in:  in  std_logic;
		clock_out: out std_logic);
end prescaler;

architecture a of prescaler is
	signal count: unsigned(31 downto 0);
	signal enable: std_logic := '0';
begin
	p: process(count)
	begin
		if rising_edge(clock_in) then
			if count = n then
				count <= X"00000000";
				enable <= not enable;
			else
				count <= count + 1;
			end if;
		end if;
	end process p;
	clock_out <= enable when rising_edge(clock_in);
end a;
