library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

package data_package is 
	-- index 0 => down sample 2
	-- index 1 => down sample 4
	-- index 2 => down sample 8
	type data_array is array (2 downto 0) of signed(15 downto 0);
	attribute s_ram : string;
	-- attribute s_ram of data_array : signal is "block_ram";
end data_package;
