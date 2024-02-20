-- Xavier Williams
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;


entity conv is
generic
(
	data_depth : integer :=64;
	data_width : integer :=16
);
port
(
	i_clk		: in std_logic;
	i_rst		: in std_logic;
	i_tx		: in signed(data_width-1 downto 0);
	i_rx		: in signed(data_width-1 downto 0);
	o_conv		: out signed((2*data_width)-1 downto 0);
	o_conv_max	: out signed((2*data_width)-1 downto 0)
);

end entity;


architecture RTL of conv is

signal cur_max : std_logic_vector((2*data_width) - 1 downto 0) := (others => '0');

----------------------------------- add registers -------------------------------------------

signal add1_d, add1_q : std_logic_vector((2*data_width) - 1 downto 0) := (others => '0');

type add2_reg is array (1 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add2_d, add2_q : add2_reg := (others => (others => '0'));

type add4_reg is array (3 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add4_d, add4_q : add4_reg := (others => (others => '0'));

type add8_reg is array (7 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add8_d, add8_q : add8_reg := (others => (others => '0'));

type add16_reg is array (15 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add16_d, add16_q : add16_reg := (others => (others => '0'));

type add32_reg is array (31 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add32_d, add32_q : add32_reg := (others => (others => '0'));

type add64_reg is array (63 downto 0) of std_logic_vector((2*data_width)-1 downto 0);
signal add64_d, add64_q : add64_reg := (others => (others => '0'));

------------------------------------ tx rx memory --------------------------------------------

type txrx_mem is array (data_depth-1 downto 0) of std_logic_vector(data_width - 1 downto 0);
signal tx_q : txrx_mem := (others => (others => '0'));
signal rx_d, rx_q : txrx_mem := (others => (others => '0'));
signal tmp_q : txrx_mem := (others => (others => '0'));

-- load mem all at once here
impure function init_rxtx_mem(filename : in string) return txrx_mem is
	file text_file : text open read_mode is filename;
	variable text_line : line;
	variable tmp_line : integer;
	variable content : txrx_mem;
begin
	for i in txrx_mem'RANGE loop
		readline(text_file, text_line);
		read(text_line, tmp_line);
		content(i) := std_logic_vector(to_signed(tmp_line, data_width));
	end loop;
	return content;
end function;

signal tx_d  : txrx_mem := init_txrx_mem("tx.txt");
signal tmp_d : txrx_mem := init_txrx_mem("rx.txt");

---------------------------------------------- yep ---------------------------------------------

begin
	mult_generate : for i in txrx_mem'RANGE generate
		connect : entity work.mult_signed
		generic map
		(
			WIDTHA => data_width,
			WIDTHB => data_width
		)
		port map
		(
			A   => tx_q(i),
			B   => rx_q(i),
			RES => add64_d(i)
		);
	end generate;

	sixtyfour_to_thirtytwo : for i in add32_reg'LENGTH-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add64_q(2*i),
			i_B => add64_q(2*i+1),
			o_Sum => add32_d(i)
		);
	end generate;

	thirtytwo_to_sixteen : for i in add16_reg'LENGTH-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add32_q(2*i),
			i_B => add32_q(2*i+1),
			o_Sum => add16_d(i)
		);
	end generate;

	sixteen_to_eight : for i in add8_reg'LENGTH-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add16_q(2*i),
			i_B => add16_q(2*i+1),
			o_Sum => add8_d(i)
		);
	end generate;

	eight_to_four : for i in add4_reg'LENGTH-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add8_q(2*i),
			i_B => add8_q(2*i+1),
			o_Sum => add4_d(i)
		);
	end generate;

	four_to_two : for i in add2_reg'LENGTH-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add4_q(2*i),
			i_B => add4_q(2*i+1),
			o_Sum => add2_d(i)
		);
	end generate;

	two_to_one : for i in 1-1 downto 0 generate
		add_module : entity work.adder_generic
		generic map
		(
			adder_width => 2*data_width 
		)
		port map
		(
			i_A => add2_q(2*i),
			i_B => add2_q(2*i+1),
			o_Sum => add1_d
		);
	end generate;
	
	add_reg_proc : process(i_clk, i_rst) is -- propagates data through registers
	begin

		if (i_rst = '1') then
			-- something should reset
		elsif Rising_Edge(i_clk) then
			-- shift tmp register into RX
			-- ensures RX starts from the beginning
			tmp_d(data_depth-1 downto 1) <= tmp_d(data_depth-2 downto 0);
			tmp_d(0) <= (others => '0');
		
			-- shift rx_d
			rx_d(data_depth-1 downto 1) <= rx_d(data_depth-2 downto 0);
			rx_d(0) <= tmp_q(data_depth-1);

			tmp_q <= tmp_d;
			tx_q <= tx_d;
			rx_q <= rx_d;
			add64_q <= add64_d;
			add32_q <= add32_d;
			add16_q <= add16_d;
			add8_q <= add8_d;
			add4_q <= add4_d;
			add2_q <= add2_d;
			add1_q <= add1_d;

		end if;
	end process;

	max_compare : process (add1_q)
	begin
		if (signed(add1_q) > signed(cur_max)) then
			cur_max <= add1_q;
		end if;
	end process;

	-- driving output signals
	o_conv <= signed(add1_q);
	o_conv_max <= signed(cur_max);

	

end RTL;
