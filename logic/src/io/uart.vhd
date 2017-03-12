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
        UART_IRQ    : out std_logic;
    );
end UART;

architecture default of UART is
    type txState is ( IDLE, SENDING );
	signal txCurrent: txState;
    signal outputBuffer : std_logic_vector(9 downto 0);
    signal txReq        : std_logic;
    signal clkDiv       : unsigned(31 downto 0);
    signal clkDivCtr    : unsigned(31 downto 0);
    signal bitCtr       : unsigned(4 downto 0);
begin

process(clk, rst) begin
    if(rst = '1') then
        outputBuffer    <= "1_0000_0000_0"; 
        TxD             <= '1';
        txReq           <= '0';
        outputData      <= (others => 'Z');
    else
    elsif(clk'event and clk='0') then
        if( unsigned(inputAddr) > X"0001_FFFF" and 
            unsigned(inputAddr) < X"0002_00FF"
        ) then
            if(wrEn) then
                case(inputAddr(7 downto 0) is
                    when X"0" =>
                        outputData(8 downto 1) <= inputData(7 downto 0);
                    when X"1" =>
                        txReq   <= inputData(0);
                    when X"2" =>
                        clkDiv  <= unsigned(inputData);
                    when others =>

                end case;
            end if; 
        end if;
    end if;
end process;

process(clk, rst) begin
    if(rst = '1') then
        txCurrent   <= IDLE;
        clkDivCtr   <= to_unsigned(0, 32);
    elsif(clk'event and clk='1') then
        
        if(txReq = '1' and txCurrent = IDLE) then
            txCurrent   <= SENDING;
            clkDivCtr   <= clkDiv;
            bitCtr      <= to_unsigned(9, 4);
        end if;

        if(txCurrent = SENDING) then
            if(clkDivCtr = X"0000_0000") then
                if(bitCtr = to_unsigned(0, 4)) then

                else
                bitCtr  <= bitCtr - to_unsigned(1, 4);

                end if;
            else

            end if; 
        end if;
    end if;
end process;

end architecture;
