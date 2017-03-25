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

entity outputDataMux is
    port(
        -- Basic reset and clock
        outputAddr          : in std_logic_vector(31 downto 0);
        outputDataUART      : in std_logic_vector(31 downto 0);
        outputDataFlowCtrl  : in std_logic_vector(31 downto 0);
        outputDataDataCache : in std_logic_vector(31 downto 0);
        outputData          : out std_logic_vector(31 downto 0)
    );
end entity;


architecture default of outputDataMux is
begin

process(outputAddr, outputDataUART, outputDataFlowCtrl, outputDataDataCache) begin
    -- Flow control  can talk
    if( unsigned(outputAddr) > X"0000_FFFF" and 
        unsigned(outputAddr) < X"0002_0000" ) then
        outputData  <= outputDataFlowCtrl;
    -- UART
    elsif( 
        unsigned(outputAddr) > X"0001_FFFF" and 
        unsigned(outputAddr) < X"0002_0100") then
        outputData  <= outputDataUART;
    -- Cache memory
    elsif( outputAddr < X"0000_4000" ) then
        outputData  <= outputDataDataCache;
    else
        outputData	<= X"0000_0000";
    end if;
end process;

end architecture;
