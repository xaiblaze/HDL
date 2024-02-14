-- Xavier Williams

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity stop_watch is
port
(
i_clk_h		: in	std_logic;
i_sys_rst_h	: in	std_logic;
i_start_stop_h	: in	std_logic;
i_rst_watch_h	: in	std_logic;
o_watch_running_h :out	std_logic;
o_watch_rst_h	: out	std_logic
);

end stop_watch;

architecture RTL of stop_watch is

type state_type is (zero, counting, stop, S1_dummy);
signal cur_state, next_state : state_type;


begin

	mechanism : process (i_clk_h, i_sys_rst_h) is
	begin
		if(i_sys_rst_h = '1') then
			cur_state <= zero; -- this works but it doens't set the state variables correctly?

		elsif Rising_Edge(i_clk_h) then
			cur_state <= next_state;

		end if;
	
	end process;

	state_proc : process (i_start_stop_h, i_rst_watch_h) is
	begin
		if (i_rst_watch_h = '1') or (i_sys_rst_h = '1') then -- added this OR here to force state variables to reset
			o_watch_running_h <= '0';
			o_watch_rst_h <= '1';
			next_state <= zero;
		else
			case cur_state is
				when zero =>
					o_watch_running_h <= '0';	
					o_watch_rst_h <= '1';
					if Rising_Edge(i_start_stop_h) then
						next_state <= counting;
					end if;
				when counting =>
					o_watch_running_h <= '1';
					o_watch_rst_h <= '0';
					if Rising_Edge(i_start_stop_h) then
						next_state <= stop;
					end if;
				when stop =>
					o_watch_running_h <= '0';
					o_watch_rst_h <= '0';
					if Rising_Edge(i_start_stop_h) then
						next_state <= counting;
					end if;
				when others =>
					o_watch_running_h <= '0';
					o_watch_rst_h <= '0';
					next_state <= zero;

			end case;
		end if;
	end process;

	

end RTL;
