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
-- [MOV R0 1 A R1 -cmp]
when X"00000000" =>
	 instrOutput <= X"80010912";
-- [MOV R0 _ISR A R2 -cmp]
when X"00000001" =>
	 instrOutput <= X"80130922";
-- [NOP R0 0 N R0 -cmp]
when X"00000002" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"00000003" =>
	 instrOutput <= X"80000000";
-- [BSL R1 16 A R1 -cmp]
when X"00000004" =>
	 instrOutput <= X"88100a12";
-- [NOP R0 0 N R0 -cmp]
when X"00000005" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"00000006" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"00000007" =>
	 instrOutput <= X"80000000";
-- [MOV R0 R2 A *R1 -cmp]
when X"00000008" =>
	 instrOutput <= X"01008912";
-- [MOV R0 0 A R7 -cmp]
when X"00000009" =>
	 instrOutput <= X"80000972";
-- [MOV R0 20 A R5 -cmp]
when X"0000000a" =>
	 instrOutput <= X"80140952";
-- [NOP R0 0 N R0 -cmp]
when X"0000000b" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"0000000c" =>
	 instrOutput <= X"80000000";
-- [ADD R7 1 A R7 -cmp]
when X"0000000d" =>
	 instrOutput <= X"b8010672";
-- [NOP R0 0 N R0 -cmp]
when X"0000000e" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"0000000f" =>
	 instrOutput <= X"80000000";
-- [SUB R5 R7 N R0 +cmp]
when X"00000010" =>
	 instrOutput <= X"2b800701";
-- [MOV R0 _loop NZ PC -cmp]
when X"00000011" =>
	 instrOutput <= X"800d09d6";
-- [MOV R0 _init Z PC -cmp]
when X"00000012" =>
	 instrOutput <= X"800909d4";
-- [ADD R0 5 A R7 +cmp]
when X"00000013" =>
	 instrOutput <= X"80050673";
-- [MOV R0 1 A R1 -cmp]
when X"00000014" =>
	 instrOutput <= X"80010912";
-- [NOP R0 0 N R0 -cmp]
when X"00000015" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"00000016" =>
	 instrOutput <= X"80000000";
-- [BSL R1 16 A R1 -cmp]
when X"00000017" =>
	 instrOutput <= X"88100a12";
-- [MOV R0 1 A R2 -cmp]
when X"00000018" =>
	 instrOutput <= X"80010922";
-- [NOP R0 0 N R0 -cmp]
when X"00000019" =>
	 instrOutput <= X"80000000";
-- [OR R1 32 A R1 -cmp]
when X"0000001a" =>
	 instrOutput <= X"88200412";
-- [NOP R0 0 N R0 -cmp]
when X"0000001b" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"0000001c" =>
	 instrOutput <= X"80000000";
-- [MOV R0 R2 A *R1 -cmp]
when X"0000001d" =>
	 instrOutput <= X"01008912";
-- [NOP R0 0 N R0 -cmp]
when X"0000001e" =>
	 instrOutput <= X"80000000";
-- [NOP R0 0 N R0 -cmp]
when X"0000001f" =>
	 instrOutput <= X"80000000";

			when others =>
				instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
