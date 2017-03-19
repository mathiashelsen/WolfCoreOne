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

process(outputAddr, outputDataFlowCtrl, outputDataDataCache) begin
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
