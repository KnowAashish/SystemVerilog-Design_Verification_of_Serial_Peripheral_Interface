`define DATA_WIDTH 12
`include "spi_interface.sv"
`include "spi_package.sv"

module spi_tb();

   import spi_package::*;
   
   intf if_tb(); // Donot use virtual in tb top
   
   // Instantiate DUT
   //spi DUT (vif.clk, vif.reset, vif.din, vif.new_data, vif.cs, vif.mosi, vif.sclk);
  spi_top DUT (if_tb.clk, if_tb.reset, if_tb.data_in, if_tb.new_data, if_tb.done, if_tb.dout);
   
   // Generate Clock
/*  initial
   forever
      #5 if_tb.clk = !if_tb.clk;
  end
   */
  always begin
      #5 if_tb.clk = !if_tb.clk;
  end
   
   environment env;
  
  assign if_tb.sclk = DUT.DUT_master.sclk;
  
   initial begin
      env = new(if_tb);
      env.gen.no_of_packets	= 4;
	  env.run();
   end
   
   initial begin
      $dumpfile("dump.vcd");
	  $dumpvars;
   end
   
endmodule