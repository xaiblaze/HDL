// Code your design here
module down_sample 
  #(parameter data_width=16)
    (
    input i_clk,
    input i_rst,
    input i_data,
      output reg[15:0] o_ds2,
      output reg[15:0] o_ds4,
      output reg[15:0] o_ds8
    );
  
  reg[4:0] count;
  reg r_data1 = 0;
  reg r_data2 = 0;
  
  reg[15:0] r_ds2 = 0;
  reg[15:0] r_ds4 = 0;
  reg[15:0] r_ds8 = 0;
  
  
  //double register input data
  always @(posedge i_clk) begin
  	r_data1 <= i_data;
    r_data2 <= r_data1;
  end
  
  

  always @(posedge i_clk) begin : counter
    if(i_rst) begin
      count <= 0;
      o_ds2 <= 0;
      o_ds4 <= 0;
      o_ds8 <= 0;
      
      r_ds2 <= 0;
      r_ds4 <= 0;
      r_ds8 <= 0;
    end else begin
      count <= count + 1;
    end
  end
    
    always @(posedge i_clk) begin
      if(count[1:0] == 2'b10) begin
        	o_ds2 <= r_data2;
        	r_ds2 <= r_data2;
        	
      end else begin
        	o_ds2 <= r_ds2;
      end
      
      if(count[2:0] == 3'b100) begin
        	o_ds4 <= r_data2;
        	r_ds4 <= r_data2;
        	
      end else begin
        	o_ds4 <= r_ds4;
      end

      if(count[3:0] == 4'b1000) begin
        	o_ds8 <= r_data2;
        	r_ds8 <= r_data2;
        	
      end else begin
        	o_ds8 <= r_ds8;
      end      
      
      
    end
    
    
      
      
endmodule
