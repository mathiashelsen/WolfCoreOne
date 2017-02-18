library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flowController is
    port(
        -- Basic reset and clock
        rst         : in    std_logic;
        clk         : in    std_logic;
        -- Input from the CPU
        pc          : in    std_logic_vector(31 downto 0);
        CPU_Status  : in    std_logic_vector(31 downto 0);
        -- Output to the CPU
        instrOut    : out   std_logic_vector(31 downto 0);
        forceRoot   : out   std_logic;
        -- I/O with the program cache memory
        memAddr     : out   std_logic_vector(31 downto 0);
        instrIn     : in    std_logic_vector(31 downto 0);
        -- The bus on which the IRQ's arrive
        IRQBus      : in    std_logic_vector(31 downto 0);
    );
end entity;

architecture default of flowController is
    type flowCtrlStates is (IDLE, IRQ_Init, IRQ_Active, IRQ_Done);
    signal flowCtrlState    : flowCtrlStates;
    signal instrGen         : std_logic_vector(31 downto 0);
    signal pcCopy           : std_logic_vector(31 downto 0);
    signal CPU_StatusCopy   : std_logic_vector(31 downto 0);
begin

process(pc, pcCopy, instrIn, instrGen, flowCtrlState) begin
    if(flowCtrlState = IDLE) then
        memAddr     <= pc;
        instrOut    <= instrIn;
    else
        memAddr     <= pcCopy;
        instrOut    <= instrGen;
    end if;
end process;


process(clk, rst) begin
    if(rst = '1') then
        flowCtrlState <= IDLE;
    elsif(clk'event and clk='1') then
        case flowCtrlState is
            when IDLE =>
                if(IRQBus /= X"0000_0000" and ) then
                    flowCtrlState <= IRQ_Init_0;
                end if;
            when others =>
                flowCtrlState <= IDLE;
        end case; 
    end if;
end process;
end architecture;
