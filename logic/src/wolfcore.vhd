library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity wolfcore is
	port (
		clock_50: in   std_logic;
		key:      in   std_logic_vector(1 downto 0);
		led:      out  std_logic_vector(3 downto 0));
end wolfcore;

architecture a of wolfcore is
	signal a: unsigned(24 downto 0);
begin

	a <= a+1 when rising_edge(clock_50);
    led(0) <= a(24);
    led(2) <= key(0);

end a;
