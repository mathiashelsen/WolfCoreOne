library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mmu is 
    port(
        -- Coming from the CPU
        dataIn      : in    std_logic_vector(31 downto 0);
        dataAddr    : in    std_logic_vector(31 downto 0);
        wrEn        : in    std_logic;
        -- Going to the CPU
        dataOut     : out   std_logic_vector(31 downto 0);

        -- I/O with data cache
        memIn       : out   std_logic_vector(31 downto 0);
        memAddr     : out   std_logic_vector(31 downto 0);
        memWrEn     : out   std_logic;
        memOut      : in    std_logic_vector(31 downto 0);

        -- I/O with the flowController
        flowCtrlIn      : out   std_logic_vector(31 downto 0);
        flowCtrlAddr    : out   std_logic_vector(31 downto 0);
        flowCtrlWrEn    : out   std_logic;
        flowCtrlOut     : in    std_logic_vector(31 downto 0)
        
    );
end entity;

architecture default of mmu is 

begin
process(dataAddr, dataIn, wrEn, memOut, flowCtrlOut) begin
    case dataAddr(31 downto 24) is 
        when X"00" =>
            memIn   <= dataIn;
            memAddr <= dataAddr;
            dataOut <= memOut;
            memWrEn <= wrEn;

            flowCtrlWrEn    <= '0';
        when X"01" =>
            flowCtrlIn      <= dataIn;
            flowCtrlAddr    <= dataAddr; 
            dataOut         <= flowCtrlOut;
            flowCtrlWren    <= wrEn;
    
            memWrEn <= '0';
        when others =>
            memWrEn         <= '0';
            flowCtrlWrEn    <= '0';
    end case;
end process;

end architecture;
