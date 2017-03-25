--
-- MIT License
-- 
-- Copyright (c) 2017 Mathias Helsen, Arne Vansteenkiste
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
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
    -- [MOV R0 0x14 A R4 -cmp]
    when X"00000006" =>
    	 instrOutput <= X"80140942";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000007" =>
    	 instrOutput <= X"00000900";
    -- [BSL R4 8 A R4 -cmp]
    when X"00000008" =>
    	 instrOutput <= X"a0080a42";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000009" =>
    	 instrOutput <= X"00000900";
    -- [OR R4 0x58 A R4 -cmp]
    when X"0000000a" =>
    	 instrOutput <= X"a0580442";
    -- [MOV R0 R0 N R0 -cmp]
    when X"0000000b" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R4 A *R6 -cmp]
    when X"0000000c" =>
    	 instrOutput <= X"02008962";
    -- [MOV R0 0x62 A *R5 -cmp]
    when X"0000000d" =>
    	 instrOutput <= X"80628952";
    -- [MOV R0 1 A *R7 -cmp]
    when X"0000000e" =>
    	 instrOutput <= X"80018972";
    -- [MOV R0 0 A *R7 -cmp]
    when X"0000000f" =>
    	 instrOutput <= X"80008972";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000010" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000011" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000012" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000013" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000014" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000015" =>
    	 instrOutput <= X"00000900";
    -- [MOV R0 *R7 A R1 -cmp]
    when X"00000016" =>
    	 instrOutput <= X"03804912";
    -- [MOV R0 R0 N R0 -cmp]
    when X"00000017" =>
    	 instrOutput <= X"00000900";
    -- [AND R1 1 A R1 +cmp]
    when X"00000018" =>
    	 instrOutput <= X"88010313";
    -- [MOV R0 _sendChar Z PC -cmp]
    when X"00000019" =>
    	 instrOutput <= X"800609e4";
    -- [MOV R0 _loop NZ PC -cmp]
    when X"0000001a" =>
    	 instrOutput <= X"801609e6";
          when others =>
                    instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
