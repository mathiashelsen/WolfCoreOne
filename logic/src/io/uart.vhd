library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UART is
    port(
	clk         : in std_logic;
	rst         : in std_logic;          -- async reset
	RxD         : in std_logic;          -- serial input for the UART
	TxD         : out std_logic;         -- output from the UART
	inputData   : in std_logic_vector(31 downto 0);
        inputAddr   : in std_logic_Vector(31 downto 0); 
        outputData  : out std_logic_vector(31 downto 0);
        outputAddr  : in std_logic_vector(31 downto 0);
        wrEn        : in std_logic;
        UART_IRQ    : out std_logic
    );
end UART;

architecture default of UART is
    type txState is ( IDLE, SENDING );
	signal txCurrent: txState;
    signal outputBuffer : std_logic_vector(9 downto 0);
    signal inputBuffer  : std_logic_vector(9 downto 0);
    signal txReq        : std_logic;
    signal clkDiv       : unsigned(31 downto 0);
    signal clkDivCtr    : unsigned(31 downto 0);
    signal bitCtr       : unsigned(4 downto 0);

    signal uartStatus   : std_logic_vector(31 downto 0);
    signal uartStatusC  : std_logic_vector(31 downto 0);
    signal outputCache  : std_logic_vector(7 downto 0);
begin

process(clk, rst) begin
    if(rst = '1') then
        outputBuffer    <= "1000000000"; 
        TxD             <= '1';
        txReq           <= '0';
        inputBuffer     <= "0000000000";
        outputBuffer    <= "1000000000";
        uartStatus      <= X"0000_0000";
        txCurrent       <= IDLE;
        clkDivCtr       <= to_unsigned(0, 32);
    elsif(clk'event and clk='0') then
        -- Incoming data from bus --
        if( unsigned(inputAddr) > X"0001_FFFF" and 
            unsigned(inputAddr) < X"0002_0100"
        ) then
            if(wrEn = '1') then
                case inputAddr(7 downto 0) is
                    when X"0" =>
                        uartStatusC <= inputData;
                    when X"1" =>
                        clkDiv      <= unsigned(inputData);
                    when X"2" =>
                        outputCache <= inputData(7 downto 0);
                    when others =>

                end case;
            end if; 
        end if;
    
        -- Outgoing data to bus --
        if( unsigned(outputAddr) > X"0001_FFFF" and
            unsigned(outputAddr) < X"0002_0100") then
            case outputAddr(7 downto 0) is
                when X"0" =>
                    outputData  <= uartStatus;
                when X"1" =>
                    outputData  <= std_logic_vector(clkDiv);
                when X"2" =>
                    outputData  <= std_logic_vector(to_unsigned(0, 24)) & outputCache;
                when others =>

            end case;  
        end if;
    end if;
      
        case txCurrent is
            when IDLE =>
                if(uartStatusC(0) = '1') then
                    txCurrent                   <= SENDING;
                    clkDivCtr                   <= clkDiv;
                    bitCtr                      <= to_unsigned(9, 4);
                    uartStatus(0)               <= '1';
                    outputBuffer(8 downto 1)    <= outputCache;
                end if;

            when SENDING =>
                if(clkDivCtr = X"0000_0000") then
                    -- Reset the prescaler counter
                    clkDivCtr       <= clkDiv;

                    if(bitCtr = to_unsigned(0, 4)) then
                        uartStatus(0)   <= '0';
                        uartStatus(1)   <= '1'; 
                        txCurrent       <= IDLE;
                    else
                        -- Another bit bites the dust (you have to sing this comment line)
                        bitCtr  <= bitCtr - to_unsigned(1, 4);
                        -- Bit away! (Requires pirate voice library)
                        TxD             <= outputBuffer(0);
                        -- Shift register on the outputBuffer (there is nothing funny about this)
                        outputBuffer    <= '0' & outputBuffer(9 downto 0);
                    end if;
                else
                    clkDivCtr   <= clkDivCtr - to_unsigned(1, 32);
                end if; 

            when others =>

        end case;  
    end if;
end process;

end architecture;
