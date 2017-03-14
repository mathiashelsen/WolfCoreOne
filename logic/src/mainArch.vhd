-- This file contains all constant things, such as bit locations of the
-- instructions, addresses of IOs etc.

package mainArch is


-- Locations of the bits in the instruction --
constant IMMb   : natural := 31;
subtype REGa    is natural range 30 downto 27;
subtype REGb    is natural range 26 downto 23;
subtype IMMv    is natural range 26 downto 16;
constant PTRc   : natural := 15;
constant PTRb   : natural := 14;
constant PTRa   : natural := 13;
subtype OPC     is natural range 12 downto 8;
subtype REGc    is natural range 7 downto 4;
subtype COND    is natural range 3 downto 1;
constant CMP    : natural := 0;

end package;
