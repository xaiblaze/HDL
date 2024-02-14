library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.data_package.all;

entity down_sample is
generic
(
	data_width	: integer := 16
);
port
(
	i_clk		: in  std_logic;
	i_rst		: in  std_logic;
	i_data		: in  signed(data_width - 1 downto 0);
	o_down_sample_data : out data_array
);
end down_sample;


architecture RTL of down_sample is

signal ds2   : signed(data_width - 1 downto 0) := (others => '0');
signal ds4   : signed(data_width - 1 downto 0) := (others => '0');
signal ds8   : signed(data_width - 1 downto 0) := (others => '0');

begin

load_proc : process (i_data) is
	variable count : integer := 0;


begin
	-- o_down_sample_data <= (others => i_data);
	if(count mod 2 = 0) then
		o_down_sample_data(0) <= i_data;
		ds2 <= i_data;
	else
		o_down_sample_data(0) <= ds2;
	end if;

	if(count mod 4 = 0) then
		o_down_sample_data(1) <= i_data;
		ds4 <= i_data;
	else
		o_down_sample_data(1) <= ds4;
	end if;

	if(count mod 8 = 0) then
		o_down_sample_data(2) <= i_data;
		ds8 <= i_data;
	else
		o_down_sample_data(2) <= ds8;
	end if;

	count := count + 1;
end process;
	


end RTL;
