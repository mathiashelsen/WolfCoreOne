library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mainArch.all;

entity wolfcore is
        port(
                dataOutput      : out std_logic_vector(31 downto 0);
                dataInput       : in std_logic_vector(31 downto 0);
                dataInAddr      : out std_logic_vector(31 downto 0);
                dataOutAddr     : out std_logic_vector(31 downto 0);
                dataWrEn        : out std_logic;
                instrInput      : in std_logic_vector(31 downto 0);
                pc                      : buffer std_logic_Vector(31 downto 0);
                CPU_Status      : buffer std_logic_vector(31 downto 0);
                rst                     : in std_logic;
                clk                     : in std_logic;
                forceRoot       : in std_logic;
                flushing        : out std_logic
        );
end entity;

architecture default of wolfcore is
        type regFileType is array(12 downto 0) of std_logic_vector(31 downto 0);
        signal inputA   : std_logic_vector(31 downto 0);
        signal inputFA  : std_logic_vector(31 downto 0);
        signal inputB   : std_logic_vector(31 downto 0);
        signal regFile  : regFileType;

        type cpuStateType is ( Nominal, Flush );
        signal cpuState :   cpuStateType;
        --signal pc             : std_logic_vector(31 downto 0);
        signal ALU_Overflow : std_logic_vector(31 downto 0);
        signal ALU_Out      : std_logic_vector(31 downto 0);
        signal ALU_Status   : std_logic_vector(7 downto 0);
        -- The instruction as it travels down the pipeline
        signal instrFetchB  : std_logic_vector(31 downto 0);
        signal instrExecute : std_logic_vector(31 downto 0);
        signal instrWriteBack : std_logic_vector(31 downto 0);

        signal shadowPC_FA  : std_logic_vector(31 downto 0);
        signal shadowPC_FB  : std_logic_vector(31 downto 0);

        -- Used during execute
        signal wbEn         : std_logic;
        signal updateStatus : std_logic;

        -- The magnificent combinatorial ALU! All hail the ALU!
        component ALU 
                port(
                instr                   : in std_logic_vector(4 downto 0);              -- instruction (decoded)
                inputA                  : in std_logic_vector(31 downto 0);             -- input data A
                inputB                  : in std_logic_vector(31 downto 0);             -- input data B
                ALU_Out                 : buffer std_logic_vector(31 downto 0);    -- ALU results 
                ALU_Overflow            : buffer std_logic_vector(31 downto 0);    -- ALU overflow results 
                ALU_Status              : buffer std_logic_vector(7 downto 0)           -- Status of the ALU
                );
        end component;  


begin

        mainALU: ALU port map( 
                instr   => instrWriteBack(12 downto 8),
                inputA  => inputA,
                inputB  => inputB,
                ALU_Out => ALU_Out,
                ALU_Overflow => ALU_Overflow,
                ALU_Status => ALU_Status
                );

process(instrWriteBack, CPU_Status) begin
case instrWriteBack(COND) is
        -- Always
        when "001" =>
                wbEn <= '1';
        -- Never
        when "000" =>
                wbEn <= '0';
        -- When 0
        when "010" =>
                wbEn <= CPU_Status(7);
        -- When not 0
        when "011" =>
                wbEn <= not CPU_Status(7);
        -- When "positive" -> MSB = 0
        when "100" =>
                wbEn <= not CPU_Status(6);
        -- When "negative" -> MSB = 1
        when "101" =>
                wbEn <= CPU_Status(6);
        when "110" =>
                wbEn <= CPU_Status(5);
        when "111" =>
                wbEn <= not CPU_Status(5);
        when others =>
                wbEn <= '0';
end case;

end process;

process(cpuState) begin
    if(cpuState = Nominal) then
        flushing <= '0';
    else
        flushing <= '1';
    end if;
end process;

process(clk, rst) begin
        if(rst = '1') then
                inputA  <= X"0000_0000";        
                inputB  <= X"0000_0000";        
                pc      <= X"0000_0000";        
                CPU_Status <= X"0000_0000";
                for i in regFile'range loop
                        regFile(i)      <= X"0000_0000";
                end loop;

                instrFetchB     <= X"0000_0000";
                instrExecute    <= X"0000_0000";
                instrWriteBack  <= X"0000_0000";

                cpuState    <= Nominal;

                dataWrEn    <= '0';
                dataInAddr  <= X"0000_0000";
                dataOutAddr <= X"0000_0000";
                dataOutput  <= X"0000_0000";
                
        elsif (clk'event and clk='1') then
                -- FETCH-A
                if(instrInput(PTRa) = '1') then
                    dataInAddr  <= regFile(to_integer(unsigned(instrInput(REGA))));
                end if;
                shadowPC_FA     <= pc;

                instrFetchB <= instrInput;

                -- FETCH-B
                if( cpuState = Nominal ) then
                    
                    if(instrFetchB(PTRa) = '1') then
                        inputFA <= dataInput;
                    end if;
                    shadowPC_FB <= shadowPC_FB;

                    if(instrFetchB(PTRb) = '1') then
                        if(instrFetchB(IMMb) = '1') then
                            dataInAddr  <= std_logic_vector(to_unsigned(0, 21)) & instrFetchB(IMMv);
                        else
                            dataInAddr  <= regFile(to_integer(unsigned(instrFetchB(REGb))));
                        end if;
                    end if;

                    instrExecute    <= instrFetchB;
                else
                    inputFA         <= X"0000_0000";
                    instrExecute    <= X"0000_0000";
                end if;
        
                -- EXECUTE
                if( cpuState = Nominal ) then
                    if(instrExecute(PTRa) = '1') then
                        inputA      <= inputFA;
                    else
                        case to_integer(unsigned(instrExecute(REGa))) is
                        when 13 =>
                            inputA  <= shadowPC_FB;
                        when 14 =>
                            inputA  <= ALU_Overflow;
                        when 15 =>
                            inputA  <= CPU_Status;
                        when others =>
                            inputA  <= regFile(to_integer(unsigned(instrExecute(REGa))));
                        end case;
                    end if;

                    if(instrExecute(PTRb) = '1') then
                        inputB      <= dataInput;
                    else
                        if(instrExecute(IMMb) = '1') then
                            inputB  <= std_logic_vector(to_unsigned(0, 21)) & instrExecute(IMMv);
                        else
                            case to_integer(unsigned(instrExecute(REGb))) is
                            when 13 =>
                                inputB  <= shadowPC_FB;
                            when 14 =>
                                inputB  <= ALU_Overflow;
                            when 15 =>
                                inputB  <= CPU_Status;
                            when others =>
                                inputB  <= regFile(to_integer(unsigned(instrExecute(REGb))));
                            end case;
                        end if;
                    end if;

                    -- We take along important information for the writeback
                    instrWriteBack  <= instrExecute;
                else
                    instrWriteBack  <= X"0000_0000";
                    inputA          <= X"0000_0000";
                    inputB          <= X"0000_0000";
                end if;

                -- WRITEBACK
                if(wbEn='1' and cpuState = Nominal) then
                    if(instrWriteBack(PTRc) = '1') then
                        dataOutAddr <=  regFile(to_integer(unsigned(instrWriteBack(REGc))));
                        dataOutput  <=  ALU_Out;
                        dataWrEn    <= '1';
                        pc          <= std_logic_vector(unsigned(pc) + to_unsigned(1, pc'length));
                    else
                        dataWrEn    <= '0';
                        case to_integer(unsigned(instrWriteBack(REGc))) is
                        when 0 to 12 =>
                            regFile(to_integer(unsigned(instrWriteBack(REGc)))) <= ALU_out;
                            pc          <= std_logic_vector(unsigned(pc) + to_unsigned(1, pc'length));
                            cpuState    <= Nominal;
                        when 13 =>
                            pc          <= ALU_out;
                            cpuState    <= Flush;
                        when others =>
                            pc          <= std_logic_vector(unsigned(pc) + to_unsigned(1, pc'length));
                            cpuState    <= Nominal;
                        end case;                       
                    end if;
                else
                    dataWrEn    <= '0';
                    pc          <= std_logic_vector(unsigned(pc) + to_unsigned(1, pc'length));
                    cpuState    <= Nominal;
                end if;

                if( (forceRoot = '1' or CPU_Status(31 downto 30) = "00") 
                        and instrWriteBack(REGc) = X"F" 
                        and wbEn = '1'
                        ) then
                        CPU_Status              <= ALU_Out;
                elsif(instrWriteBack(0) = '1') then
                        CPU_Status(7 downto 0)  <= ALU_Status;
                end if;
        end if;
end process;
end architecture;
