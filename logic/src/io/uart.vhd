library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UART is
    port(
	baudRtClk	    : in std_logic;			    			-- clock running at X2 the baud rate clock
	rst			    : in std_logic;			    			-- async reset
	RxD				: in std_logic;							-- serial input for the UART
	TxD				: out std_logic;						-- output from the UART
	inputData		: in std_logic_vector(7 downto 0);		-- 8-bit input data
	TxEnable		: in std_logic;							-- start sending
	TxActive		: out std_logic;						-- sending is active

	outputData		: out std_logic_vector(7 downto 0);		-- 8-bit data that was received
	RxActive		: out std_logic;						-- new data is available
	RxClearFlag		: in std_logic							-- reset the above flag
    );
end UART;

architecture default of UART is
    type txState is ( IDLE, SENDING );
	signal txCurrent: txState;
	signal outputBuffer : std_logic_vector(9 downto 0);
	signal txBitCtr : unsigned(3 downto 0);
	signal txClkDivCtr : unsigned(3 downto 0);
begin

	-- UART TX MODULE --
	process(baudRtClk, rst)
	begin
		if(rst = '1') then
			txCurrent	<= IDLE;
			txClkDivCtr <= to_unsigned(0, txClkDivCtr'length);
			TxActive	<= '0';
			TxD			<= '1';
		elsif (baudRtClk'event and baudRtClk = '1') then
			case txCurrent is
				----------------
				-- IDLE STATE --
				----------------
				when IDLE =>
					TxActive	<= '0';
					if(TxEnable = '1') then
						outputBuffer 	<= '1' & inputData & '0';
						txBitCtr 		<= to_unsigned(0, txBitCtr'length);
						txClkDivCtr 	<= to_unsigned(0, txClkDivCtr'length);
						txCurrent		<= SENDING;
					end if;	

				-------------------
				-- SENDING STATE --
				-------------------
				when SENDING =>
					TxActive	<= '1';
					-- Last bit has been sent...
					if(txBitCtr = 9 and txClkDivCtr = 9) then
						TxD				<= '1';
						txCurrent		<= IDLE;
					-- Still bits to send...
					elsif(txClkDivCtr = 9) then
						txBitCtr 		<= txBitCtr + 1;				-- one bit out
						TxD 			<= outputBuffer(0);				-- bit on the output line
						outputBuffer	<= '0' & outputBuffer(9 downto 1);-- bitshift to the right
						txClkDivCtr 	<= to_unsigned(0, txClkDivCtr'length);	-- reset baud rate divider
					-- Just some clk dividing...
					else
						txClkDivCtr		<= txClkDivCtr + 1;
					end if;
			end case;
		end if;
	end process;
end architecture;
