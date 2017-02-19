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

        -- Control register input
        regAddr     : in    std_logic_vector(31 downto 0);
        regData     : in    std_logic_vector(31 downto 0);
        regOutput   : out   std_logic_vector(31 downto 0);
        regWrEn     : in    std_logic
    );
end entity;

architecture default of flowController is
    type flowCtrlStates is (IDLE, IRQ_Init_0, IRQ_Init_1, 
        IRQ_Init_2, IRQ_Init_3, IRQ_Init_4, IRQ_Active,
        IRQ_Finished_0, IRQ_Finished_1, IRQ_Finished_2, IRQ_Finished_3);
    signal flowCtrlState    : flowCtrlStates;


    type regFile is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal irqAddrReg       : regFile;

    signal IRQ_Finished     : std_logic_vector(31 downto 0);
    signal instrGen         : std_logic_vector(31 downto 0);
    signal pcCopy           : std_logic_vector(31 downto 0);
    signal CPU_StatusCopy   : std_logic_vector(31 downto 0);
    signal nopCtr           : unsigned(31 downto 0);
begin

process(pc, pcCopy, instrIn, instrGen, flowCtrlState) begin
    if(flowCtrlState = IDLE or flowCtrlState = IRQ_Active) then
        memAddr     <= pc;
        instrOut    <= instrIn;
    else
        memAddr     <= pcCopy;
        instrOut    <= instrGen;
    end if;
end process;


process(clk, rst) 
    variable irqRunning: integer := 31;
begin
    if(rst = '1') then
        flowCtrlState   <= IDLE;
        instrGen        <= X"0000_0000";
        pcCopy          <= X"0000_0000";
        CPU_StatusCopy  <= X"0000_0000";
        forceRoot       <= '0';
        IRQ_Finished    <= X"0000_0000";
        for i in irqAddrReg'range loop
            irqAddrReg(i) <= X"0000_0000";
        end loop;
    elsif(clk'event and clk='0') then
        if(regWrEn = '1') then
            case regAddr(8 downto 5) is
                when "0000" =>
                    irqAddrReg(to_integer(unsigned(regAddr(4 downto 0)))) <= regData;
                when "0001" =>
                    IRQ_Finished  <= regData;
                when others =>
            end case;
        else
            case regAddr(8 downto 5) is
                when "0000" =>
                    regOutput <= irqAddrReg(to_integer(unsigned(regAddr(4 downto 0))));
                when others =>
                    regOutput <= X"0000_0000";
            end case;

        end if;
    elsif(clk'event and clk='1') then
        case flowCtrlState is
            when IDLE =>
                if(IRQBus /= X"0000_0000") then
                    flowCtrlState   <= IRQ_Init_0;
                    instrGen        <= X"0000_0000";
                    pcCopy          <= pc;

                    for i in IRQBus'range loop
                        if(IRQBus(i) = '1') then
                            irqRunning := i;
                        end if; 
                    end loop;
                end if;
            when IRQ_Init_0 =>
                instrGen        <= "1" & "0000" & irqAddrReg(irqRunning)(13 downto 0) & "01001" & "1101" & "001" & "0";
                flowCtrlState   <= IRQ_Init_1;
                nopCtr          <= X"0000_0004";
            when IRQ_Init_1 =>
                instrGen        <= X"0000_0000";
                if(nopCtr = X"0000_0000") then
                    flowCtrlState   <= IRQ_Active;
                else
                    nopCtr      <= nopCtr - to_unsigned(1, 32);
                end if;
            when IRQ_Active =>
                if(IRQ_Finished(irqRunning) = '1') then
                    flowCtrlState   <= IRQ_Finished_0;
                end if;
            when IRQ_Finished_0 =>
                forceRoot       <= '1';
                flowCtrlState   <= IRQ_Finished_1;
                instrGen        <= "1" & "0000" & CPU_StatusCopy(13 downto 0) & "01001" & "1111" & "001" & "0";
            when IRQ_Finished_1 =>
                flowCtrlState   <= IRQ_Finished_2;
                instrGen        <= "1" & "0000" & pcCopy(13 downto 0) & "01001" & "1101" & "001" & "0";
                nopCtr          <= to_unsigned(2, 32);
            when IRQ_Finished_2 =>
                instrGen        <= X"0000_0000";
                if(nopCtr = X"0000_0000") then
                    flowCtrlState   <= IRQ_Finished_3;
                else
                    nopCtr      <= nopCtr - to_unsigned(1, 32);
                end if;
            when IRQ_Finished_3 =>
                forceRoot       <= '0';
                flowCtrlState   <= IDLE;
            when others =>
                flowCtrlState <= IDLE;
        end case; 
    end if;
end process;
end architecture;
