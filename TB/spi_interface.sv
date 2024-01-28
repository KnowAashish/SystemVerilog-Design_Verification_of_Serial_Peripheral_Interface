interface intf();

   bit 						clk;
   logic					reset;
   logic 					new_data;
   logic [DATA_WIDTH-1:0]	data_in;
   bit						sclk;
   //logic					cs;
   //logic					mosi;
   logic					done;
   logic [DATA_WIDTH-1:0]	dout;
   
endinterface