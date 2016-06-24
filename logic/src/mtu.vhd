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
		qICache			:	in 	std_logic_vector(63 downto 0);
		addressICache	:	out std_logic_vector(13 downto 0);
		wrenICache		:	out std_logic;
		-- Ports to the Data cache
		-- Data input to cache
		dataDCache		:	out	std_logic_vector(63 downto 0);
		-- Data output to cache
		qDCache			:	in 	std_logic_vector(63 downto 0);
		addressDCache	:	out std_logic_vector(13 downto 0);
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
		cacheBank		:	in	std_logic_vector(7 downto 0);
		sdramAddress	:	in	std_logic_vector(28 downto 0);
		enableXfer		:	in	std_logic
		--idle			:	out	std_logic
	);
end mtu;

architecture mdefault of mtu is
	type states is (IDLE, READ1, READ2, READ3, READ4, WRITE1, WRITE2, WRITE3);
	signal	state			:	states	:= IDLE;
	signal	ctr				:	std_logic_vector(31 downto 0);
	signal	dramAddress		:	std_logic_vector(28 downto 0);
	signal	cacheAddress	:	std_logic_vector(13 downto 0);
	signal	cacheAddressCtr	:	std_logic_vector(13 downto 0);
	signal	cacheData		:	std_logic_vector(63 downto 0);
	signal	cacheQ			:	std_logic_vector(63 downto 0);
	signal	wordLow			:	std_logic_vector(31 downto 0);
	signal	wordHigh		:	std_logic_vector(31 downto 0);
	signal	wrenCache		:	std_logic;
	signal	sramCtr			:	std_logic_vector(7 downto 0);
	signal	cacheCtr		:	std_logic_vector(7 downto 0);

	component mux
		port(
				sel				:	in std_logic;
				cacheData		:	in	std_logic_vector(63 downto 0);
				cacheAddress	:	in std_logic_vector(13 downto 0);
				cacheQ			:	out std_logic_vector(63 downto 0);
				wrenCache		:	in std_logic;
				-- Ports to the Instruction cache
				dataICache		:	out	std_logic_vector(63 downto 0);
				qICache			:	in	std_logic_vector(63 downto 0);
				addressICache	:	out std_logic_vector(13 downto 0);
				wrenICache		:	out std_logic;
				-- Ports to the Data cache
				dataDCache		:	out	std_logic_vector(63 downto 0);
				qDCache			:	in	std_logic_vector(63 downto 0);
				addressDCache	:	out std_logic_vector(13 downto 0);
				wrenDCache		:	out std_logic
		);
	end component;
begin	

	mux0 : mux port map(
		cacheBank(7),
		cacheData,
		cacheAddress,
		cacheQ,
		wrenCache,
		-- Ports to the Instruction cache
		dataICache,
		qICache,
		addressICache,
		wrenICache,	
		-- Ports to the Data cache
		dataDCache,
		qDCache,
		addressDCache,
		wrenDCache
		);

	process(clk, rst) begin
		if( rst = '1' ) then
			ctr				<= X"0000_0000";
			cacheAddressCtr	<= std_logic_vector(to_unsigned(0, cacheAddressCtr'length));
			sramCtr			<= X"FF";
			state			<= IDLE;
		elsif( clk'event and clk = '1' ) then
			case state is
				when IDLE =>
					sdramWriteByteEn	<= X"F";
					sdramReadRead	<= '0';	
					sdramWriteWrite	<= '0';	
					wrenCache		<= '0';
					ctr				<= X"0000_0000";

					if( enableXfer = '1' ) then
						dramAddress			<= sdramAddress;
						cacheAddressCtr		<= cacheBank(6 downto 0) & std_logic_vector(to_unsigned(0, cacheAddress'length-7));
						cacheCtr			<= X"00";
						if(direction = '0') then
							state				<= READ1;
						else
							state				<= WRITE1;
						end if;
					end if;
				when READ1 =>
					-- Initial read state, put the right pins high and low
					sdramReadAddr		<= dramAddress;
					sdramReadBurstCnt	<=	X"FF";
					sdramReadRead		<= '1';	
					sramCtr				<= X"FF";
					state				<= READ2;
					ctr					<= std_logic_vector(to_unsigned(10_000_000, 32));

				when READ2 =>
					wrenCache			<= '0';

					if( sdramReadWaitReq = '0' ) then
						sdramReadRead	<= '0';	
					end if;

					if( sdramReadDataValid = '1' ) then
						wordLow			<= sdramReadData;	
						ctr				<= std_logic_vector(to_unsigned(10_000_000, 32));
						sramCtr			<= sramCtr - X"01";
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
						cacheAddress	<= cacheAddressCtr;
						cacheData		<= sdramReadData & wordLow;
						wrenCache		<= '1';	

						
						if( sramCtr = X"00" ) then
							state			<= READ4;
						else
							sramCtr			<= sramCtr - X"01";
							cacheAddressCtr	<= cacheAddressCtr + X"1";
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
				when READ4 =>
					wrenCache	<= '0';
					if(cacheCtr = X"00") then
						state 		<= IDLE;
					else
						cacheCtr	<= cacheCtr - X"01";
						dramAddress	<= dramAddress + X"FF";
						state		<= READ1;
					end if;

				when WRITE1 =>
					-- Prepare the SDRAM bridge
					sdramWriteAddr		<= dramAddress;
					sdramWriteBurstCnt	<=	X"FF";
					sdramWriteWrite		<= '0';
					sramCtr				<= X"FF";
					-- Fetch the first 64-bits from cache
					wrenCache			<= '0';
					cacheAddress		<= cacheAddressCtr;

					state				<= WRITE2;
				when WRITE2 =>
					if( sdramWriteWaitReq = '0' ) then
						sdramWriteWrite		<= '1';
						sdramWriteData		<= cacheQ(31 downto 0);

						cacheAddressCtr		<= cacheAddressCtr + X"1";
	
						sramCtr				<= sramCtr - X"1";

						state				<= WRITE3;
					end if;
				when WRITE3 =>
					if( sdramWriteWaitReq = '0' ) then	
						sdramWriteData		<= cacheQ(63 downto 32);
						cacheAddress		<= cacheAddressCtr;
						
						if( sramCtr = X"00" ) then
							state				<= IDLE;
						else
							sramCtr				<= sramCtr - X"1";
							state				<= WRITE2;
						end if;
					end if;
				when others =>
					state <= IDLE;
			end case;
		end if;
	end process;
end mdefault;
