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
                -- [MOV R0 1 A R7 -cmp]
                when X"00000000" =>
                     instrOutput <= X"80010972";
                -- [MOV R0 0 A R6 -cmp]
                when X"00000001" =>
                     instrOutput <= X"80000962";
                -- [BSL R7 17 A R7 -cmp]
                when X"00000002" =>
                     instrOutput <= X"b8110a72";
                -- [MOV R0 0 A R5 -cmp]
                when X"00000003" =>
                     instrOutput <= X"80000952";
                -- [ADD R7 1 A R6 -cmp]
                when X"00000004" =>
                     instrOutput <= X"b8010662";
                -- [ADD R7 2 A R5 -cmp]
                when X"00000005" =>
                     instrOutput <= X"b8020652";
                -- [MOV R0 10 A *R6 -cmp]
                when X"00000006" =>
                     instrOutput <= X"800a8962";
                -- [MOV R0 0xA A *R5 -cmp]
                when X"00000007" =>
                     instrOutput <= X"800a8952";
                -- [MOV R0 1 A *R7 -cmp]
                when X"00000008" =>
                    instrOutput <= X"80018972";
                -- [MOV R0 0 A *R7 -cmp]
                when X"00000009" =>
                     instrOutput <= X"80008972";
                when others =>
                    instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
