
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux is
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
end mux;

architecture mdefault of mux is
begin
	process( sel, cacheData, cacheAddress, wrenCache, qICache, qDCache ) begin
		if(sel = '0') then
			dataICache		<= cacheData;
			addressICache	<= cacheAddress; 

			cacheQ			<= qICache;

			wrenICache		<= wrenCache; 
			wrenDCache		<= '0';
		else
			dataDCache		<= cacheData;
			addressDCache	<= cacheAddress; 

			cacheQ			<= qDCache;

			wrenDCache		<= wrenCache; 
			wrenICache		<= '0';
		end if;
	end process;
end mdefault;
