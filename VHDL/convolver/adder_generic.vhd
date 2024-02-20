-- Xavier Williams
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity adder_generic is
generic
(
	adder_width : integer  := 2
);

port
( -- no saturation needs to be accounted for, so no carry bit is needed
	i_A	: in  std_logic_vector(adder_width - 1 downto 0);
	i_B	: in  std_logic_vector(adder_width - 1 downto 0);
	o_Sum	: out std_logic_vector(adder_width - 1 downto 0)
);

end adder_generic;


architecture RTL of adder_generic is
begin

	o_Sum <= i_A + i_B;

end RTL;
