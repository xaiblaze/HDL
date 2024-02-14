library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.data_package.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use std.standard.all;

entity down_sample_tb is
end entity;

architecture RTL of down_sample_tb is 

constant data_width : INTEGER := 16;

signal i_clk : std_logic := '0';
signal i_rst : std_logic := '0';
signal i_data : signed(data_width - 1 downto 0) := (others => '0');
signal o_down_sample_data : data_array := (others => (others => '0'));

-- signal expected2, expected4, expected8 : signed(data_width - 1 downto 0) := (others => '0');
-- signal corrupt2, corrupt4, corrupt8 : signed(data_width - 1 downto 0) := (others => '0');

begin

i_clk <= not i_clk after 5 ns;

-- load arrays each with expected values
-- for loop to compare each value


down_sample2 : entity work.down_sample
generic map
(
	data_width => data_width
)
port map
(
	i_clk => i_clk,
	i_rst => i_rst,
	i_data => i_data,
	o_down_sample_data => o_down_sample_data
);



read_process : process
	file file_vectors : text;
	file file_vectors2, file_vectors4, file_vectors8 : text;
	file corrupt2, corrupt4, corrupt8 : text;
	file file_results2, file_results4, file_results8 : text;
	variable int 	  : integer := 0;
	variable v_iline  : line;
	variable v_oline  : line;
	variable data     : signed(data_width - 1 downto 0);
	variable status	  : file_open_status;
	variable count    : integer := 0;

begin
	file_open(status, file_vectors, "data.txt", read_mode);
	file_open(status, file_vectors2, "ds2_expected.txt", read_mode);
	file_open(status, file_vectors4, "ds4_expected.txt", read_mode);
	file_open(status, file_vectors8, "ds8_expected.txt", read_mode);
	file_open(status, corrupt2, "ds2_corrupted.txt", read_mode);
	file_open(status, corrupt4, "ds4_corrupted.txt", read_mode);
	file_open(status, corrupt8, "ds8_corrupted.txt", read_mode);
	file_open(status, file_results2, "ds2_output.txt", write_mode);
	file_open(status, file_results4, "ds4_output.txt", write_mode);
	file_open(status, file_results8, "ds8_output.txt", write_mode);

	if status /= open_ok then
		report "failed to open file";
	elsif status = open_ok then
		report "open file ok";
		while not endfile(file_vectors) loop
			readline(file_vectors, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			i_data <= data;

			 wait for 10 ns;

			readline(file_vectors2, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(0)) report "ds2 error" severity note;

			readline(file_vectors4, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(1)) report "ds4 error" severity note;

			readline(file_vectors8, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(2)) report "ds8 error" severity note;

			readline(corrupt2, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(0)) report "corrupt2 error" severity note;

			readline(corrupt4, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(1)) report "corrupt4 error" severity note;

			readline(corrupt8, v_iline);
			read(v_iline, int);
			data := to_signed(int, data_width);
			ASSERT (data = o_down_sample_data(2)) report "corrupt8 error" severity note;

			write(v_oline, to_integer(o_down_sample_data(0)));
			writeline(file_results2, v_oline);

			write(v_oline, to_integer(o_down_sample_data(1)));
			writeline(file_results4, v_oline);

			write(v_oline, to_integer(o_down_sample_data(2)));
			writeline(file_results8, v_oline);

			count := count + 1;
			report "count ==> " & integer'image(count);

		end loop;

		file_close(file_vectors);
		file_close(file_vectors2);
		file_close(file_vectors4);
		file_close(file_vectors8);
		file_close(corrupt2);
		file_close(corrupt4);
		file_close(corrupt8);
		file_close(file_results2);
		file_close(file_results4);
		file_close(file_results8);
	end if;
	wait;
	end process;
end RTL;
