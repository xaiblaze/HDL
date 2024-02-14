// Code your design here
// Code your design here

`include "stop_watch.v"

module stop_watch_tb();


	reg r_clock = 0;
	reg i_sys_rst = 0;
	reg i_start_stop = 0;
	reg i_rst_watch = 0;
	
	wire o_watch_running;
	wire o_watch_rst;

	always #10 r_clock <= !r_clock;
	
	// DUT declaration
	stop_watch DUT (	.i_clk_h(r_clock),
					.i_sys_rst_h(i_sys_rst),
					.i_start_stop_h(i_start_stop),
                    .i_rst_watch_h(i_rst_watch),
					.o_watch_running_h(o_watch_running),
					.o_watch_rst_h(o_watch_rst)
				);  
  
  
	initial begin
           
          	$dumpfile("dump.vcd"); 
            $dumpvars;
          $monitor("running=%2d, reset=%2d",o_watch_running, o_watch_rst); 
			#15
			i_start_stop <= 1'b1;
			#15
			i_start_stop <= 1'b0;
            #30
          	i_start_stop <= 1'b1;
			#15
			i_start_stop <= 1'b0;
          

            #50
            $finish;
        end
endmodule
