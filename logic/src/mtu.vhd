library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mtu is
	port(
		clk	:	in	std_logic;
		rst	:	in	std_logic;
		-- Ports to the Instruction cache
		dataICache		:	out	std_logic_vector(63 downto 0);
		addressICache	:	out std_logic_vector(13 downto 0);
		wrenICache		:	out std_logic;
		-- Ports to the Data cache
		dataDCache		:	out	std_logic_vector(63 downto 0);
		addressDCache	:	out std_logic_vector(913 downto 0);
		wrenDCache		:	out std_logic;
		-- Ports to the SDRAM bridge
		-- For writing to the RAM
		sdramWriteAddr		:	out	std_logic_vector(28 downto 0);
		sdramWriteData		:	out	std_logic_Vector(31 downto 0);
		sdramWriteBurstCnt	:	out	std_logic_vector(7 downto 0);
		sdramWriteWaitReq	:	in	std_logic;
		sdramWriteWrite		:	out std_logic;
		sdramWriteByteEn	:	out	std_logic_vector(3 downto 0);
		-- For reading from the RAM
		sdramReadAddr		:	out std_logic_vector(28 downto 0);
		sdramReadData		:	in	std_logic_vector(31 downto 0);
		sdramReadBurstCnt	:	out std_logic_Vector(7 downto 0);
		sdramReadWaitReq	:	in	std_logic;
		sdramReadDataValid	:	in	std_logic;
		sdramReadRead		:	out	std_logic;
		-- Control ports
		direction		:	in	std_logic;							-- 0 For read, 1 for write
		cacheBank		:	in	std_logic_vector(3 downto 0);
		sdramAddress	:	in	std_logic_vector(27 downto 0);
		enableXfer		:	in	std_logic
		--idle			:	out	std_logic
	);
end mtu;

architecture default of mtu is
	type states is (IDLE, READ1, READ2, READ3);
	signal	state			:	states	:= IDLE;
	signal	ctr				:	std_logic_vector(31 downto 0);
	signal	dramAddress		:	std_logic_vector(28 downto 0);
	signal	cacheAddress	:	std_logic_vector(13 downto 0);
	signal	wordLow			:	std_logic_vector(31 downto 0);
	signal	wordHigh		:	std_logic_vector(31 downto 0);
begin	
	process(clk, rst) begin
		if( rst = '1' ) then
			ctr	<= X"0000_0000";
			cacheAddress	<= std_logic_vector(to_unsigned(0, cacheAddress'length));
			state	<= IDLE;
		elsif( clk'event and clk = '1' ) then
			case state is
				when IDLE =>
					sdramReadRead	<= '0';	
					sdramWriteWrite	<= '0';	
					wrenICache	<= '0';
					wrenDCache	<= '0';
					ctr			<= X"0000_0000";

					if( enableXfer = '1' and direction ='0' ) then
						dramAddress			<= sdramAddress;
						cacheAddress		<= std_logic_vector(to_unsigned(0, addressICache'length));
						state				<= READ1;
					end if;
				when READ1 =>
					-- Initial read state, put the right pins high and low
					sdramReadAddr		<= dramAddress;
					sdramReadBurstCnt	<=	X"FF";
					sdramReadRead			<= '1';	
					state				<= READ2;
					ctr					<= std_logic_vector(to_unsigned(10_000_000, 32));

				when READ2 =>
					wrenICache			<= '0';

					if( sdramReadWaitReq = '0' ) then
						sdramReadRead	<= '0';	
					end if;

					if( sdramReadDataValid = '1' ) then
						wordLow			<= sdramReadData;	
						ctr				<= std_logic_vector(to_unsigned(10_000_000, 32));
						state			<= READ3;
					else
						if( ctr = X"0" ) then
							state 		<= IDLE;
							sdramReadRead	<= '0';
						else
							ctr			<= ctr - X"1";
						end if;
					end if;

				when READ3 =>
					if( sdramReadDataValid = '1' ) then
						wordHigh		<= sdramReadData;

						addressICache	<= cacheAddress;
						dataICache		<= wordHigh & wordLow;
						wrenICache		<= '1';	

						
						if( cacheAddress = std_logic_vector(to_unsigned(128, 14)) ) then
							state		<= IDLE;
						else
							cacheAddress	<= cacheAddress + X"1";
							ctr				<= std_logic_vector(to_unsigned(10_000_000, 32));
							state			<= READ2;	
						end if;	
					else
						if( ctr = X"0" ) then
							state 		<= IDLE;
							sdramReadRead	<= '0';
						else
							ctr			<= ctr - X"1";
						end if;
					end if;
				
				when others =>
					state <= IDLE;
			end case;
		end if;
	end process;
end architecture;
