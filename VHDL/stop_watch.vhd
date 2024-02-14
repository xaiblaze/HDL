-- Xavier Williams

library IEEE;
use IEEE.std_logic_1164.all;

entity stop_watch_tb is
end stop_watch_tb;

architecture RTL of stop_watch_tb is

	constant clkh_per : time := 100 ns; -- 100MHz
	
	signal i_clk_h		: 	std_logic :='0';
	signal i_sys_rst_h	: 	std_logic :='0';
	signal i_start_stop_h	: 	std_logic :='0';
	signal i_rst_watch_h	: 	std_logic :='0';
	signal o_watch_running_h :	std_logic := '0';
	signal o_watch_rst_h	: 	std_logic :='0';
	
	begin
	
	stop_watch : entity work.stop_watch
	port map
	(
	i_clk_h => i_clk_h,
	i_sys_rst_h => i_sys_rst_h,
	i_start_stop_h => i_start_stop_h,
	i_rst_watch_h => i_rst_watch_h,
	o_watch_running_h => o_watch_running_h,
	o_watch_rst_h => o_watch_rst_h
	);
	
	i_clk_h <= not i_clk_h after 5 ns;

	stim: process is
	begin
		i_start_stop_h <= '1';
		wait for 15 ns;
		i_start_stop_h <= '0';
		wait for 50 ns;

		i_rst_watch_h <= '1';
		wait for 20 ns;
		i_rst_watch_h <= '0';
		wait for 50 ns;

		i_start_stop_h <= '1';
		wait for 15 ns;
		i_start_stop_h <= '0';
		wait for 50 ns;		

		i_sys_rst_h <= '1';
		wait for 20 ns;

		i_start_stop_h <= '1';
		wait for 15 ns;
		i_start_stop_h <= '0';
		wait for 50 ns;		

		i_sys_rst_h <= '0';
		wait for 20 ns;

		i_start_stop_h <= '1';
		wait for 15 ns;
		i_start_stop_h <= '0';
		wait for 50 ns;	

		wait;


	end process;



	
	
end RTL;
