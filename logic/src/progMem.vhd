library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity progMem is
	port(
		instrOutput	: out std_logic_vector(31 downto 0);
		instrAddress: in std_logic_vector(31 downto 0);
		clk			: in std_logic
	);
end entity;

architecture default of progMem is
	type regFileType is array(3 downto 0) of std_logic_vector(31 downto 0);
begin
process(clk) begin
	if (clk'event and clk='0') then
		case instrAddress is
-- [MOV R0 0 A R0 -cmp]
when X"00000000" =>
	 instrOutput <= X"80000902";
-- [MOV R0 10 A R1 -cmp]
when X"00000001" =>
	 instrOutput <= X"800a0912";
-- [MOV R0 0 N R0 -cmp]
when X"00000002" =>
	 instrOutput <= X"80000900";
-- [MOV R0 0 N R0 -cmp]
when X"00000003" =>
	 instrOutput <= X"80000900";
-- [MOV R0 25 A *R0 -cmp]
when X"00000004" =>
	 instrOutput <= X"80198902";
-- [MOV R0 30 A *R1 -cmp]
when X"00000005" =>
	 instrOutput <= X"801e8912";
-- [MOV R0 0 N R0 -cmp]
when X"00000006" =>
	 instrOutput <= X"80000900";
-- [MOV R0 0 N R0 -cmp]
when X"00000007" =>
	 instrOutput <= X"80000900";
-- [MOV R0 0 N R0 -cmp]
when X"00000008" =>
	 instrOutput <= X"80000900";
-- [MOV R0 0 N R0 -cmp]
when X"00000009" =>
	 instrOutput <= X"80000900";
-- [MOV R0 0 N R0 -cmp]
when X"0000000a" =>
	 instrOutput <= X"80000900";
-- [ADD *R0 *R1 A R3 -cmp]
when X"0000000b" =>
	 instrOutput <= X"00806632";
			when others =>
				instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
