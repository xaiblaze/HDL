// Code your design here
module stop_watch
	(
	input	i_clk_h,
	input 	i_sys_rst_h,
	input	i_start_stop_h,
	input	i_rst_watch_h,
	output reg	o_watch_running_h,
	output reg	o_watch_rst_h
	);
	
	parameter zero	=	2'b00;
	parameter counting	=	2'b01;
	parameter stop	=	2'b10;
	
	reg [2:0] r_cur_state = 0;
	reg [2:0] r_next_state = 0;
  
  	reg r_watch_running_h = 0;
  	reg r_watch_rst_h = 0;
  
  	//assign o_watch_running_h = r_watch_running_h;
  	//assign o_watch_rst_h = r_watch_running_h;
	
	// mechanism logic
	always @(posedge i_clk_h) begin
			r_cur_state <= r_next_state;
		
	end
	
	
	//state machine logic
	always @(posedge i_clk_h)
		begin
			case (r_cur_state)
				zero :
				begin
						o_watch_running_h <= 1'b0;
						o_watch_rst_h <= 1'b1;
                    if (i_start_stop_h == 1) begin
								r_next_state <= counting;
					end
				end // case: zero 
				
				counting : begin
						o_watch_running_h <= 1'b1;
						o_watch_rst_h <= 1'b0;
                      if (i_start_stop_h == 1)
							begin
								r_next_state <= stop;
							end
				end // case: counting 
				
				
				stop : begin
						o_watch_running_h <= 1'b0;
						o_watch_rst_h <= 1'b0;
                      if ( i_start_stop_h == 1) begin
								r_next_state <= zero;
					  end
				end // case: counting

				default : begin
						o_watch_running_h <= 1'b0;
						o_watch_rst_h <= 1'b0;
						r_next_state <= zero;
				end
				 // case: default
            endcase
        end 
				
endmodule
