LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;



ENTITY wolfcore IS
		    PORT
			    (
				        CLOCK_50 :  IN  STD_LOGIC;
				        KEY :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				        LED :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
						    );
					END wolfcore;

ARCHITECTURE a OF wolfcore IS
		    signal a: unsigned(24 downto 0);
begin

		    a <= a+1 when rising_edge(CLOCK_50);
			    LED(0) <= a(24);
				    LED(2) <= KEY(0);

			END a;
			~                    
