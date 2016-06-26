library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mtu is
	port(
		clk	:	in	std_logic;
		rst	:	in	std_logic;
		-- Ports to the Instruction cache
		instr_cache_data		:	out	std_logic_vector(63 downto 0);
		instr_cache_q			:	in 	std_logic_vector(63 downto 0);
		instr_cache_address	:	out std_logic_vector(13 downto 0);
		instr_cache_wren		:	out std_logic;
		-- Ports to the Data cache
		-- Data input to cache
		data_cache_data		:	out	std_logic_vector(63 downto 0);
		-- Data output to cache
		data_cache_q			:	in 	std_logic_vector(63 downto 0);
		data_cache_address	:	out std_logic_vector(13 downto 0);
		data_cache_wren		:	out std_logic;
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
	signal	dramAddress		:	std_logic_vector(28 downto 0);
	signal	cacheAddress	:	std_logic_vector(13 downto 0);
	signal	cacheAddressCtr	:	std_logic_vector(13 downto 0);
	signal	cacheData		:	std_logic_vector(63 downto 0);
	signal	cacheQ			:	std_logic_vector(63 downto 0);
	signal	cacheQcache		:	std_logic_vector(63 downto 0);
	signal	cacheOutput		:	std_logic_vector(63 downto 0);
	signal	wordLow			:	std_logic_vector(31 downto 0);
	signal	wordHigh		:	std_logic_vector(31 downto 0);
	signal	cacheWren		:	std_logic;
	signal	sramCtr			:	std_logic_vector(7 downto 0);
	signal	cacheCtr		:	std_logic_vector(7 downto 0);

	attribute keep: boolean;
	attribute keep of state: signal is true;
	attribute keep of cacheQcache: signal is true;

	component mux
		port(
				sel				:	in std_logic;
				cacheData		:	in	std_logic_vector(63 downto 0);
				cacheAddress	:	in std_logic_vector(13 downto 0);
				cacheQ			:	out std_logic_vector(63 downto 0);
				cacheWren		:	in std_logic;
				-- Ports to the Instruction cache
				instr_cache_data		:	out	std_logic_vector(63 downto 0);
				instr_cache_q			:	in	std_logic_vector(63 downto 0);
				instr_cache_address	:	out std_logic_vector(13 downto 0);
				instr_cache_wren		:	out std_logic;
				-- Ports to the Data cache
				data_cache_data		:	out	std_logic_vector(63 downto 0);
				data_cache_q			:	in	std_logic_vector(63 downto 0);
				data_cache_address	:	out std_logic_vector(13 downto 0);
				data_cache_wren		:	out std_logic
		);
	end component;
begin	

	mux0 : mux port map(
		cacheBank(7),
		cacheData,
		cacheAddress,
		cacheQ,
		cacheWren,
		-- Ports to the Instruction cache
		instr_cache_data,
		instr_cache_q,
		instr_cache_address,
		instr_cache_wren,	
		-- Ports to the Data cache
		data_cache_data,
		data_cache_q,
		data_cache_address,
		data_cache_wren
		);

	process(clk, rst) begin
		if( rst = '1' ) then
			cacheAddressCtr	<= std_logic_vector(to_unsigned(0, cacheAddressCtr'length));
			sramCtr			<= X"FE";
			state			<= IDLE;
		elsif( clk'event and clk = '1' ) then
			case state is
				when IDLE =>
					sdramWriteByteEn	<= X"F";
					sdramReadRead	<= '0';	
					sdramWriteWrite	<= '0';	
					cacheWren		<= '0';

					if( enableXfer = '1' ) then
						dramAddress			<= sdramAddress;
						cacheAddressCtr		<= cacheBank(6 downto 0) & std_logic_vector(to_unsigned(0, cacheAddress'length-7));
						cacheCtr			<= X"00";
						if(direction = '0') then
							state				<= READ1;
						else
							state				<= WRITE1;
							cacheAddress		<= cacheBank(6 downto 0) & std_logic_vector(to_unsigned(0, cacheAddress'length-7));
						end if;
					end if;
				when READ1 =>
					-- Initial read state, put the right pins high and low
					sdramReadAddr		<= dramAddress;
					sdramReadBurstCnt	<=	X"FE";
					sdramReadRead		<= '1';	
					sramCtr				<= X"FE";
					state				<= READ2;

				when READ2 =>
					cacheWren			<= '0';

					if( sdramReadWaitReq = '0' ) then
						sdramReadRead	<= '0';	
					end if;

					if( sdramReadDataValid = '1' ) then
						wordLow			<= sdramReadData;	
						sramCtr			<= sramCtr - X"01";
						state			<= READ3;
					end if;

				when READ3 =>
					if( sdramReadDataValid = '1' ) then
						cacheAddress	<= cacheAddressCtr;
						cacheData		<= sdramReadData & wordLow;
						cacheWren		<= '1';	

						
						if( sramCtr = X"01" ) then
							state			<= READ4;
						else
							sramCtr			<= sramCtr - X"01";
							cacheAddressCtr	<= cacheAddressCtr + X"1";
							state			<= READ2;	
						end if;	
					end if;
				when READ4 =>
					cacheWren	<= '0';
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
					sdramWriteBurstCnt	<=	X"FE";
					sdramWriteWrite		<= '0';
					sramCtr				<= X"FE";
					-- Fetch the first 64-bits from cache
					cacheWren			<= '0';

					state				<= WRITE2;
				when WRITE2 =>
					cacheQcache <= cacheQ;
					if( sdramWriteWaitReq = '0' ) then
						sdramWriteWrite		<= '1';
						sdramWriteData		<= cacheQ(31 downto 0);

						cacheAddressCtr		<= cacheAddressCtr + X"1";
						cacheAddress		<= cacheAddressCtr + X"1";
	
						sramCtr				<= sramCtr - X"1";

						if( sramCtr = X"00" ) then
							sdramWriteWrite	<= '0';	
							state				<= IDLE;
						else
							state				<= WRITE3;
						end if;
					end if;
				when WRITE3 =>
					if( sdramWriteWaitReq = '0' ) then	
						sdramWriteData		<= cacheQcache(63 downto 32);
						
						if( sramCtr = X"00" ) then
							sdramWriteWrite	<= '0';	
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
