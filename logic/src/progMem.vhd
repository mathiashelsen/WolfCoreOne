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
when X"00000000" =>
     instrOutput <= X"80002912";
when X"00000001" =>
     instrOutput <= X"80022922";
when X"00000002" =>
     instrOutput <= X"80000000";
when X"00000003" =>
     instrOutput <= X"88030a12";
when X"00000004" =>
     instrOutput <= X"80000000";
when X"00000005" =>
     instrOutput <= X"80000000";
when X"00000006" =>
     instrOutput <= X"10800200";
when X"00000007" =>
     instrOutput <= X"80000902";
when X"00000008" =>
     instrOutput <= X"80028912";
when X"00000009" =>
     instrOutput <= X"80000000";
when X"0000000a" =>
     instrOutput <= X"80000000";
when X"0000000b" =>
     instrOutput <= X"80002602";
when X"0000000c" =>
     instrOutput <= X"08000701";
when X"0000000d" =>
     instrOutput <= X"800169de";
when X"0000000e" =>
     instrOutput <= X"8000e9dc";
when X"0000000f" =>
     instrOutput <= X"80000000";
when X"00000010" =>
     instrOutput <= X"80000000";
when X"00000011" =>
     instrOutput <= X"8000a602";
when X"00000012" =>
     instrOutput <= X"80002912";
when X"00000013" =>
     instrOutput <= X"80000000";
when X"00000014" =>
     instrOutput <= X"80000000";
when X"00000015" =>
     instrOutput <= X"88030a12";
when X"00000016" =>
     instrOutput <= X"80002922";
when X"00000017" =>
     instrOutput <= X"80000000";
when X"00000018" =>
     instrOutput <= X"88020412";
when X"00000019" =>
     instrOutput <= X"80000000";
when X"0000001a" =>
     instrOutput <= X"80000000";
when X"0000001b" =>
     instrOutput <= X"10800200";
when X"0000001c" =>
     instrOutput <= X"80000000";
when X"0000001d" =>
     instrOutput <= X"80000000";
			when others =>
				instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
