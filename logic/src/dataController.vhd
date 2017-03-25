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

entity dataController is 
    port(
        -- Coming from the CPU
        dataIn      : in    std_logic_vector(31 downto 0);
        dataInAddr  : in    std_logic_vector(31 downto 0);
        dataOut     : out   std_logic_vector(31 downto 0);
        dataOutAddr : in    std_logic_vector(31 downto 0);
        wrEn        : in    std_logic;
        clk         : in    std_logic
    );
end entity;

architecture default of dataController is 

    signal wrEnMux      : std_logic;
    signal dataOutMux   : std_logic_vector(31 downto 0);

    component data_cache
    port
    (
        clock_y     : IN STD_LOGIC  := '1';
        data        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        rdaddress   : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
        wraddress   : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
        wren        : IN STD_LOGIC  := '0';
        q           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
    end component;

begin
    data_cache_instance: data_cache port map(
        clock_y     => "not"(clk),
        data        => dataIn,
        rdaddress   => dataOutAddr(13 downto 0),
        wraddress   => dataInAddr(13 downto 0),
        wren        => wrEnMux,
        q           => dataOut
    );

process(dataIn, dataInAddr, dataOutMux, dataOutAddr, wrEn)
begin
    if(dataInAddr < X"0000_4000") then
        wrEnMux <= wrEn;
    else
        wrEnMux <= '0';
    end if;

end process;

end architecture;
