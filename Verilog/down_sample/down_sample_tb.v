// Code your testbench here
// or browse Examples


module down_sample_tb();
  
  parameter data_width = 16;
  
  integer fd, tmp;
  reg[data_width-1:0] num;
  
  reg i_clk = 0;
  reg i_rst = 0;
  reg[data_width-1:0] i_data;
  
  wire[15:0] w_ds2;
  wire[15:0] w_ds4;
  wire[15:0] w_ds8;
  
  always #5 i_clk <= !i_clk;
  
  initial begin
    i_rst <= 0;
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    
    
    
    fd = $fopen("data.txt","r");
    
    while (!$feof(fd)) begin
      tmp = $fscanf(fd,"%d\n", num);  
      @(posedge i_clk);
      i_data <= num;
      @(posedge i_clk);
      
      $display("val=%d, ds2=%d, ds4=%d, ds8=%d",
             num, w_ds2,w_ds4,w_ds8);
    end
    
    $finish;
    
  end
  
  down_sample DUT(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(i_data),
    .o_ds2(w_ds2),
    .o_ds4(w_ds4),
    .o_ds8(w_ds8)
  );
  
  
  
  
endmodule
