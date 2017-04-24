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
-- [MOV R0 0 A R0 -cmp]
when X"00000000" =>
     instrOutput <= X"80000902";
-- [MOV R0 100 A R4 -cmp]
when X"00000001" =>
     instrOutput <= X"80640942";
-- [ADD R0 1 A R0 -cmp]
when X"00000002" =>
     instrOutput <= X"80010602";
-- [MOV R0 5 A *R0 +cmp]
when X"00000003" =>
     instrOutput <= X"80058903";
-- [MOV R0 R0 N R0 -cmp]
when X"00000004" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000005" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000006" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000007" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000008" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000009" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"0000000a" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"0000000b" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000000c" =>
     instrOutput <= X"00000900";
-- [ADD R0 1 A R0 -cmp]
when X"0000000d" =>
     instrOutput <= X"80010602";
-- [MOV R0 1 A *R0 +cmp]
when X"0000000e" =>
     instrOutput <= X"80018903";
-- [MOV R0 R0 N R0 -cmp]
when X"0000000f" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000010" =>
     instrOutput <= X"00000900";
-- [ADD R4 1 A R1 -cmp]
when X"00000011" =>
     instrOutput <= X"a0010612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000012" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000013" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000014" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000015" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"00000016" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000017" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000018" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000019" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000001a" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R1 A *R0 +cmp]
when X"0000001b" =>
     instrOutput <= X"0080c903";
-- [ADD R0 1 A R0 -cmp]
when X"0000001c" =>
     instrOutput <= X"80010602";
-- [MOV R0 R0 N R0 -cmp]
when X"0000001d" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000001e" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_If_0 NZ PC -cmp]
when X"0000001f" =>
     instrOutput <= X"802109e6";
-- [MOV R0 Label_Else_0 Z PC -cmp]
when X"00000020" =>
     instrOutput <= X"805d09e4";
-- [ADD R0 1 A R0 -cmp]
when X"00000021" =>
     instrOutput <= X"80010602";
-- [MOV R0 6 A *R0 +cmp]
when X"00000022" =>
     instrOutput <= X"80068903";
-- [MOV R0 R0 N R0 -cmp]
when X"00000023" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000024" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000025" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000026" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000027" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000028" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000029" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"0000002a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000002b" =>
     instrOutput <= X"00000900";
-- [ADD R4 1 A R1 -cmp]
when X"0000002c" =>
     instrOutput <= X"a0010612";
-- [MOV R0 R0 N R0 -cmp]
when X"0000002d" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000002e" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R1 A *R0 +cmp]
when X"0000002f" =>
     instrOutput <= X"0080c903";
-- [ADD R0 1 A R0 -cmp]
when X"00000030" =>
     instrOutput <= X"80010602";
-- [MOV R0 R0 N R0 -cmp]
when X"00000031" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000032" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_If_1 NZ PC -cmp]
when X"00000033" =>
     instrOutput <= X"803509e6";
-- [MOV R0 Label_Else_1 Z PC -cmp]
when X"00000034" =>
     instrOutput <= X"805109e4";
-- [ADD R4 0 A R1 -cmp]
when X"00000035" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000036" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000037" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R1 A *R0 +cmp]
when X"00000038" =>
     instrOutput <= X"0080c903";
-- [ADD R0 1 A R0 -cmp]
when X"00000039" =>
     instrOutput <= X"80010602";
-- [MOV R0 R0 N R0 -cmp]
when X"0000003a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000003b" =>
     instrOutput <= X"00000900";
-- [ADD R0 1 A R0 -cmp]
when X"0000003c" =>
     instrOutput <= X"80010602";
-- [MOV R0 1 A *R0 +cmp]
when X"0000003d" =>
     instrOutput <= X"80018903";
-- [MOV R0 R0 N R0 -cmp]
when X"0000003e" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000003f" =>
     instrOutput <= X"00000900";
-- [SUBS R0 1 A R0 -cmp]
when X"00000040" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 A R1 -cmp]
when X"00000041" =>
     instrOutput <= X"00000912";
-- [MOV R0 R0 N R0 -cmp]
when X"00000042" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000043" =>
     instrOutput <= X"00000900";
-- [ADD *R0 *R1 A *R0 +cmp]
when X"00000044" =>
     instrOutput <= X"0080e603";
-- [MOV R0 R0 N R0 -cmp]
when X"00000045" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000046" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000047" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000048" =>
     instrOutput <= X"00000900";
-- [ADD R4 1 A R1 -cmp]
when X"00000049" =>
     instrOutput <= X"a0010612";
-- [MOV R0 R0 N R0 -cmp]
when X"0000004a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000004b" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"0000004c" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"0000004d" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"0000004e" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000004f" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_IfFinal_1 A PC -cmp]
when X"00000050" =>
     instrOutput <= X"805c09e2";
-- [ADD R0 1 A R0 -cmp]
when X"00000051" =>
     instrOutput <= X"80010602";
-- [MOV R0 1 A *R0 +cmp]
when X"00000052" =>
     instrOutput <= X"80018903";
-- [MOV R0 R0 N R0 -cmp]
when X"00000053" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000054" =>
     instrOutput <= X"00000900";
-- [ADD R4 1 A R1 -cmp]
when X"00000055" =>
     instrOutput <= X"a0010612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000056" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000057" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000058" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000059" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"0000005a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000005b" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_IfFinal_0 A PC -cmp]
when X"0000005c" =>
     instrOutput <= X"808809e2";
-- [ADD R0 1 A R0 -cmp]
when X"0000005d" =>
     instrOutput <= X"80010602";
-- [MOV R0 7 A *R0 +cmp]
when X"0000005e" =>
     instrOutput <= X"80078903";
-- [MOV R0 R0 N R0 -cmp]
when X"0000005f" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000060" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000061" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000062" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000063" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000064" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000065" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"00000066" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000067" =>
     instrOutput <= X"00000900";
-- [ADD R4 1 A R1 -cmp]
when X"00000068" =>
     instrOutput <= X"a0010612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000069" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000006a" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R1 A *R0 +cmp]
when X"0000006b" =>
     instrOutput <= X"0080c903";
-- [ADD R0 1 A R0 -cmp]
when X"0000006c" =>
     instrOutput <= X"80010602";
-- [MOV R0 R0 N R0 -cmp]
when X"0000006d" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000006e" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_If_2 NZ PC -cmp]
when X"0000006f" =>
     instrOutput <= X"807109e6";
-- [MOV R0 Label_Else_2 Z PC -cmp]
when X"00000070" =>
     instrOutput <= X"807d09e4";
-- [ADD R0 1 A R0 -cmp]
when X"00000071" =>
     instrOutput <= X"80010602";
-- [MOV R0 4 A *R0 +cmp]
when X"00000072" =>
     instrOutput <= X"80048903";
-- [MOV R0 R0 N R0 -cmp]
when X"00000073" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000074" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000075" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000076" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000077" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000078" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000079" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"0000007a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000007b" =>
     instrOutput <= X"00000900";
-- [MOV R0 Label_IfFinal_2 A PC -cmp]
when X"0000007c" =>
     instrOutput <= X"808809e2";
-- [ADD R0 1 A R0 -cmp]
when X"0000007d" =>
     instrOutput <= X"80010602";
-- [MOV R0 3 A *R0 +cmp]
when X"0000007e" =>
     instrOutput <= X"80038903";
-- [MOV R0 R0 N R0 -cmp]
when X"0000007f" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000080" =>
     instrOutput <= X"00000900";
-- [ADD R4 0 A R1 -cmp]
when X"00000081" =>
     instrOutput <= X"a0000612";
-- [MOV R0 R0 N R0 -cmp]
when X"00000082" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000083" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R0 A *R1 +cmp]
when X"00000084" =>
     instrOutput <= X"0000c913";
-- [SUBS R0 1 A R0 -cmp]
when X"00000085" =>
     instrOutput <= X"80010802";
-- [MOV R0 R0 N R0 -cmp]
when X"00000086" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000087" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R4 A R5 -cmp]
when X"00000088" =>
     instrOutput <= X"02004952";
-- [ADD R4 1 A R2 -cmp]
when X"00000089" =>
     instrOutput <= X"a0010622";
-- [MOV R0 R0 N R0 -cmp]
when X"0000008a" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000008b" =>
     instrOutput <= X"00000900";
-- [MOV R0 *R2 A R6 -cmp]
when X"0000008c" =>
     instrOutput <= X"01004962";
-- [MOV R0 R0 N R0 -cmp]
when X"0000008d" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000008e" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"0000008f" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000090" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000091" =>
     instrOutput <= X"00000900";
-- [MOV R0 R0 N R0 -cmp]
when X"00000092" =>
     instrOutput <= X"00000900";

          when others =>
                    instrOutput <= X"0000_0000";
		end case;
	end if;
end process;
end architecture;
