
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
		cacheWren		:	in std_logic;
		-- Ports to the Instruction cache
		instr_cache_data :	out	std_logic_vector(63 downto 0);
		instr_cache_q :	in	std_logic_vector(63 downto 0);
		instr_cache_address:	out std_logic_vector(13 downto 0);
		instr_cache_wren :	out std_logic;
		-- Ports to the Data cache
		data_cache_data :	out	std_logic_vector(63 downto 0);
		data_cache_q :	in	std_logic_vector(63 downto 0);
		data_cache_address :	out std_logic_vector(13 downto 0);
		data_cache_wren :	out std_logic
	);
end mux;

architecture mdefault of mux is
begin
	process( sel, cacheData, cacheAddress, cacheWren, instr_cache_q, data_cache_q) begin
		if(sel = '0') then
			instr_cache_data <= cacheData;
			instr_cache_address <= cacheAddress; 

			cacheQ			<= instr_cache_q;

			instr_cache_wren <= cacheWren; 
			data_cache_wren <= '0';
		else
			data_cache_data <= cacheData;
			data_cache_address <= cacheAddress; 

			cacheQ			<= data_cache_q;

			data_cache_wren <= cacheWren; 
			instr_cache_wren <= '0';
		end if;
	end process;
end mdefault;
