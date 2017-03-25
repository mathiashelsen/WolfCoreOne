--
-- MIT License
-- 
-- Copyright (c) 2017 Mathias Helsen, Arne Vansteenkiste
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
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
