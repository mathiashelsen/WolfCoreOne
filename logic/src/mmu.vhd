library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mmu is 
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

architecture default of mmu is 

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
