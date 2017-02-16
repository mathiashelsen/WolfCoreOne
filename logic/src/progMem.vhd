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
			when X"0000_0000" =>
				instrOutput <= X"8002a912";
			when X"0000_0001" =>
				instrOutput <= X"8000a922";
			when X"0000_0002" =>
				instrOutput <= X"00000000";
			when X"0000_0003" =>
				instrOutput <= X"00000000";
			when X"0000_0004" =>
				instrOutput <= X"00000000";
			when X"0000_0005" =>
				instrOutput <= X"a8000352";
			when X"0000_0006" =>
				instrOutput <= X"98000332";
			when X"0000_0007" =>
				instrOutput <= X"a0000342";
			when X"0000_0008" =>
				instrOutput <= X"88000652";
			when X"0000_0009" =>
				instrOutput <= X"00000000";
			when X"0000_000A" =>
				instrOutput <= X"00000000";
			when X"0000_000B" =>
				instrOutput <= X"29000753";
			when X"0000_000C" =>
				instrOutput <= X"e801c9dc";
			when X"0000_000D" =>
				instrOutput <= X"a000264e";
			when X"0000_000E" =>
				instrOutput <= X"e80169de";
			when X"0000_000F" =>
				instrOutput <= X"00000000";
			when X"0000_0010" =>
				instrOutput <= X"29000632";
			when others =>
				instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
