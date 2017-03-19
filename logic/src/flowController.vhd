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
        flushing    : in    std_logic;
        -- Output to the CPU
        instrOut    : out   std_logic_vector(31 downto 0);
        forceRoot   : out   std_logic;
        -- I/O with the program cache memory
        memAddr     : out   std_logic_vector(31 downto 0);
        instrIn     : in    std_logic_vector(31 downto 0);
        -- The bus on which the IRQ's arrive
        IRQ         : in    std_logic_vector(31 downto 0);

        -- Control register input
        inputAddr   : in    std_logic_vector(31 downto 0);
        outputAddr  : in    std_logic_vector(31 downto 0);
        outputData  : out   std_logic_vector(31 downto 0);
        inputData   : in    std_logic_vector(31 downto 0);
        wrEn        : in    std_logic
    );
end entity;

architecture default of flowController is
    type flowCtrlStates is (IDLE, IRQ_Init_0, IRQ_Init_1, 
        IRQ_Init_2, IRQ_Init_3, IRQ_Init_4, IRQ_Active,
        IRQ_Finished_0, IRQ_Finished_1, IRQ_Finished_2, IRQ_Finished_3);
    signal flowCtrlState    : flowCtrlStates;

    type regFile is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal irqAddrReg       : regFile;
    signal retAddrStack     : regFile;
    signal CPU_StatusStack  : regFile;

    signal tmpPC            : std_logic_vector(31 downto 0);
    signal IRQBus           : std_logic_vector(31 downto 0);

    type smallRegFile is array(31 downto 0) of unsigned(4 downto 0);
    signal activeIRQStack   : smallRegFile;
    signal IRQDepth         : unsigned(5 downto 0);

    signal IRQ_FinishedFlag : std_logic;
    signal IRQ_Finished     : std_logic_vector(31 downto 0);
    signal instrGen         : std_logic_vector(31 downto 0);
    signal addrGen          : std_logic_vector(31 downto 0);
    signal nopCtr           : unsigned(31 downto 0);
    signal flushFlag        : std_logic;
begin

process(pc, instrIn, instrGen, addrGen, flowCtrlState) begin
    if(flowCtrlState = IDLE or flowCtrlState = IRQ_Active) then
        memAddr     <= pc;
        instrOut    <= instrIn;
    else
        memAddr     <= addrGen;
        instrOut    <= instrGen;
    end if;
end process;


process(clk, rst) 
    variable irqRunning: integer := 31;
begin
    if(rst = '1') then
        IRQBus              <= X"0000_0000";
        IRQ_FinishedFlag    <= '0';
        flowCtrlState       <= IDLE;
        instrGen            <= X"0000_0000";
        forceRoot           <= '0';
        IRQ_Finished        <= X"0000_0000";
        nopCtr              <= X"0000_0000";
        flushFlag           <= '0';
        for i in irqAddrReg'range loop
            irqAddrReg(i)       <= X"0000_0000";
            activeIRQStack(i)   <= "00000";
            retAddrStack(i)     <= X"0000_0000";
            CPU_StatusStack(i)  <= X"0000_0000";
        end loop;

        IRQDepth            <= "111111";
    elsif(clk'event and clk='0') then

        -- INPUT PROCESSING --
        if( unsigned(inputAddr) > X"0000_FFFF" and 
            unsigned(inputAddr) < X"0002_0000"
        ) then
            if(wrEn = '1') then
                case inputAddr(8 downto 5) is
                    when "0000" =>
                        irqAddrReg(to_integer(unsigned(inputAddr(4 downto 0)))) <= inputData;
                    when "0001" =>
                        if(IRQ_FinishedFlag = '0') then
                            IRQ_Finished  <= inputData;
                        else
                            IRQ_Finished(0) <= '0';
                        end if;
                    when others =>
                end case;
            end if;
        end if;

        -- OUTPUT PROCESSING --
        if( unsigned(outputAddr) > X"0000_FFFF" and
            unsigned(outputAddr) < X"0002_0000") then
            case outputAddr(8 downto 5) is
                when "0000" =>
                    outputData  <= irqAddrReg(to_integer(unsigned(outputAddr(4 downto 0))));
                when others =>
                    outputData  <= X"0000_0000";
            end case;
        end if;



    elsif(clk'event and clk='1') then

        IRQBus  <= IRQ;

        case flowCtrlState is
            when IDLE =>
                if(IRQBus /= X"0000_0000") then
                    flowCtrlState   <= IRQ_Init_0;
                    instrGen        <= X"0000_0000";
                    addrGen         <= X"0000_0000";
                    flushFlag       <= '0';
                    IRQDepth        <= IRQDepth + to_unsigned(1, 6);
                    tmpPC           <= std_logic_vector(unsigned(pc) + to_unsigned(1, 32));

                    for i in IRQBus'range loop
                        if(IRQBus(i) = '1') then
                            irqRunning := i;
                        end if; 
                    end loop;
                end if;
            when IRQ_Init_0 =>
                instrGen        <= X"0000_0000";
                flowCtrlState   <= IRQ_Init_1;
                if( flushing = '1' ) then
                    tmpPC       <= pc;
                end if;
            when IRQ_Init_1 =>
                if( flushing = '1' ) then
                    tmpPC       <= pc;    
                end if;
                flowCtrlState <= IRQ_Init_2;
            when IRQ_Init_2 =>
                if( flushing = '1' ) then
                    tmpPC       <= pc;    
                end if;
                flowCtrlState <= IRQ_Init_3;
            when IRQ_Init_3 =>
                if( flushing = '1' ) then
                    tmpPC       <= pc;    
                end if;

                instrGen        <= "1" & "0000" & irqAddrReg(irqRunning)(10 downto 0) & "000" & "01001" & "1101" & "001" & "0";
                addrGen         <= irqAddrReg(irqRunning);
                nopCtr          <= to_unsigned(2, 32);
                
                flowCtrlState   <= IRQ_Init_4;

            when IRQ_Init_4 => 
                if( flushing = '1' ) then
                    tmpPC   <= pc;    
                end if;
                
                instrGen        <= X"0000_0000";
                if(nopCtr = X"0000_0000") then
                    flowCtrlState   <= IRQ_Active;
                else
                    nopCtr      <= nopCtr - to_unsigned(1, 32);
                end if;

                -- Save PC, CPU_Status and active IRQ on the stack
                retAddrStack(to_integer(IRQDepth))  <=  tmpPC;
                CPU_StatusStack(to_integer(IRQDepth))   <= CPU_Status;
                activeIRQStack(to_integer(IRQDepth))    <= to_unsigned(irqRunning, 5);

            when IRQ_Active =>
                if(IRQ_Finished(0) = '1') then
                    IRQ_FinishedFlag    <= '1';
                    flowCtrlState       <= IRQ_Finished_0;
                else
                    for i in IRQBus'range loop
                        if(IRQBus(i) = '1') then
                            irqRunning := i;
                        end if; 
                    end loop;
                    if( to_unsigned(irqRunning, 5) /= activeIRQStack(to_integer(IRQDepth))) then
                        flowCtrlState   <= IRQ_Init_0; 
                        IRQDepth    <= IRQDepth + to_unsigned(1, 6);
                        tmpPC       <= std_logic_vector(unsigned(pc) + to_unsigned(1, 32));
                    end if;
                end if;
            when IRQ_Finished_0 =>
                IRQ_FinishedFlag<= '0';
                forceRoot       <= '1';
                flowCtrlState   <= IRQ_Finished_1;
                instrGen        <= "1" & "0000" & CPU_StatusStack(to_integer(IRQDepth))(10 downto 0) & "000" & "01001" & "1111" & "001" & "0";
            when IRQ_Finished_1 =>
                flowCtrlState   <= IRQ_Finished_2;
                instrGen        <= "1" & "0000" & retAddrStack(to_integer(IRQDepth))(10 downto 0) & "000" & "01001" & "1101" & "001" & "0";
                nopCtr          <= to_unsigned(1, 32);
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
                IRQDepth        <= IRQDepth - to_unsigned(1, IRQDepth'length);
            when others =>
                flowCtrlState <= IDLE;
        end case; 
    end if;
end process;
end architecture;
