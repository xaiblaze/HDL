-- Xavier Williams
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity mult_signed is
generic
(
	WIDTHA : integer := 16;
	WIDTHB : integer := 16
);

port
(
	A   : in  std_logic_vector(WIDTHA - 1 downto 0);
	B   : in  std_logic_vector(WIDTHB - 1 downto 0);
	RES : out std_logic_vector(WIDTHA + WIDTHB - 1 downto 0)
);

end mult_signed;

architecture RTL of mult_signed is
begin

RES <= A * B;

end RTL; 
