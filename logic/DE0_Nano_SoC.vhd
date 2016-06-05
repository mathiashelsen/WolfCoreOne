-- Top-level entity for the DE0-Nano-SoC (Atlas SoC) board.
-- Defines how the core is wired to the baseboard.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DE0_Nano_SoC is
	port (
		CLOCK_50: in   std_logic;
		KEY:      in   std_logic_vector(1 downto 0);
		LED:      out  std_logic_vector(7 downto 0);
		SW:       in   std_logic_vector(3 downto 0);
		GPIO_0: inout std_logic_vector(23 downto 0));
end DE0_Nano_SoC;

architecture a of DE0_Nano_SoC is
begin

	--TODO: wire core here
	LED(3 downto 0) <= SW;

end a;
