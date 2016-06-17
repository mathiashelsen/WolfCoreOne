library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mtu is
	port(
		clk	:	in	std_logic;
		rst	:	in	std_logic;
		-- Ports to the Instruction cache
		dataToICache	:	out	std_logic_vector(63 downto 0);
		dataFromICache	:	in	std_logic_vector(63 downto 0);
		addressICache	:	out std_logic_vector(9 downto 0);
		wrenICache		:	out std_logic;
		-- Ports to the Data cache
		dataToDCache	:	out	std_logic_vector(63 downto 0);
		dataFromDCache	:	in	std_logic_vector(63 downto 0);
		addressDCache	:	out std_logic_vector(9 downto 0);
		wrenDCache		:	out std_logic;
		-- Ports to the SDRAM bridge
		-- For writing to the RAM
		sdramWriteAddr		:	out	std_logic_vector(27 downto 0);
		sdramWrtiteData		:	out	std_logic_Vector(31 downto 0);
		sdramWriteBurstCnt	:	out	std_logic_vector(7 downto 0);
		sdramWriteWaitReq	:	in	std_logic;
		sdramWriteWrite		:	out std_logic;
		sdramWriteByteEn	:	out	std_logic_vector(3 downto 0);
		-- For reading from the RAM
		sdramReadAddr		:	out std_logic_vector(27 downto 0);
		sdramReadData		:	in	std_logic_vector(31 downto 0);
		sdramReadBurstCnt	:	out std_logic_Vector(7 downto 0);
		sdramReadWaitReq	:	in	std_logic;
		sdramReadDataValid	:	in	std_logic;
		sdramReadRead		:	out	std_logic;
		-- Control ports
		direction		:	in	std_logic;
		cacheBank		:	in	std_logic_vector(3 downto 0);
		sdramAddress	:	in	std_logic_vector(27 downto 0);
		enableXfer		:	in	std_logic;
		idle			:	out	std_logic
	);
end mtu;

architecture default of mtu is
	type states is (INIT, WRITING, READING);
	signal	state	:	states	:= init;
	signal	ctr	:	std_logic_vector(31 downto 0);
	signal	address	:	std_logic_vector(27 downto 0);
	signal	wordCtr	:	std_logic_vector(7 downto 0); -- Need to update this to the correct value
	process(clk, rst)
		if( rst = '1' ) then
			ctr	<= X"0000_0000";
			address	<= std_logic_vector(to_unsigned(0, address'length));
			state	<= INIT;
		else if( ctr'event and clk = '1' ) then
			case state is
				when IDLE =>
					if( enableXfer = '1' ) then
						if( direction = '1' ) then
							address 	<= sdramAddress;
							addressDCache	<= 
						else

						end if;
					end if;
				when WRITING =>

				when READING =>
			end case;
		end if;
	end process;
end architecture;
