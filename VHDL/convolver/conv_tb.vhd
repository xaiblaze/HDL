-- Xavier Williams
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;


entity conv_tb is
end entity;



architecture RTL of conv_tb is

constant data_depth : integer :=64;
constant data_width : integer :=16;

-- conv interface
signal i_clk	: std_logic :='0';
signal i_rst	: std_logic := '0';
signal i_tx	: signed(data_width-1 downto 0) := (others =>'0');
signal i_rx	: signed(data_width-1 downto 0) := (others =>'0');
signal o_conv	: signed((2*data_width)-1 downto 0) := (others => '0');
signal o_conv_max : signed((2*data_width)-1 downto 0) := (others => '0');



begin

i_clk <= not i_clk after 5 ns; -- 100 MHz


conv_int : entity work.conv
generic map
(
	data_depth => data_depth,
	data_width => data_width
)
port map
(
	i_clk	=> i_clk,
	i_rst	=> i_rst,	
	i_tx	=> i_tx,	
	i_rx	=> i_rx,	
	o_conv	=> o_conv,	
	o_conv_max => o_conv_max	
);

output : process(i_clk) is
	file output_file : text open write_mode is "output.txt";
	variable l : line;
	begin
		write(l, to_integer(o_conv));
		writeline(output_file, l);
end process;


end RTL;
