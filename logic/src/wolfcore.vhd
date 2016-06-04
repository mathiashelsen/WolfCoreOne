library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity wolfcore is
	port (
		CLOCK_50: in   std_logic;
		KEY:      in   std_logic_vector(1 downto 0);
		LED:      out  std_logic_vector(7 downto 0);
		SW:       in   std_logic_vector(3 downto 0));
end wolfcore;

architecture a of wolfcore is
	signal a: unsigned(31 downto 0);
begin

	a <= a+1 when rising_edge(clock_50);
	LED <= std_logic_vector(a(31 downto 24));

end a;
