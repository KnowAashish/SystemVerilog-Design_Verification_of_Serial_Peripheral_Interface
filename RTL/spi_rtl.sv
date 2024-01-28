module spi_master #(parameter DATA_WIDTH = 12)(
   input 				  	clk,
   input 				  	reset,
   input [DATA_WIDTH-1:0] 	din,
   input 					new_data,
   output logic 			cs,
   output logic 			mosi,		// Master Our Slave In
   output logic 			sclk);
   
   int count_clk;
   int count_din;
   
   bit [DATA_WIDTH-1:0] temp;
   
   typedef enum bit [1:0] {idle = 2'b00, enable = 2'b01, send = 2'b10, finish = 2'b11} state_type;
   state_type state = idle;
   
   // Generate sclk. In general, SPI sclk is 4 times slower than the input clk. Here Tsclk = 5*Tclk : Refer Screenshot
   always@(posedge clk) begin
      
	  if(reset) begin
	     sclk		<= 0;
		 count_clk	<= 0;
		 state		<= idle;
	  end
	  
	  else if(count_clk < 5) begin
	     count_clk 	<= count_clk + 1;
	  end
	  
	  else begin
	     sclk		<= !sclk;
		 count_clk	<= 0;
	  end
	  
	end
	
	// Write SPI logic based on sclk  
	always@(posedge sclk) begin
	
	  if(reset) begin
	     cs 	<= 1'b1;	// CS = 1 : Valid Data | CS = 0 : Invalid Data
		 mosi 	<= 1'b0;
	  end
	  
      else begin
	  
	     case(state)
		 
		    idle: begin
		       if(new_data) begin
                  state	<= send;
			      temp	<= din;
				  cs	<= 1'b0;
		       end
			   else begin
			      state <= idle;
				  temp	<= 'b0;
			   end
			end
			
			send: begin
              if(count_din <= DATA_WIDTH-1) begin
			      mosi		<= temp[count_din];		// Sending LSB First
				  count_din <= count_din + 1;
			   end
			   else begin
			      state		<= idle;
			      cs 		<= 1'b1;
				  mosi		<= 1'b0;
				  count_din <= 0;
			   end
			end
			
			default : state <= idle;
			
	     endcase
	  end
	  
    end
	  
endmodule

//////////////////////////////////////////////////////////////////////////////////////

module spi_slave #(parameter DATA_WIDTH = 12)(
	input							sclk,
	input							mosi,
	input							cs,
	output logic [DATA_WIDTH-1:0]	dout,
	output logic					done);
	
    typedef enum bit {detect_state = 1'b0, read_state = 1'b1} state_type;
	state_type state = detect_state;
	
	logic [DATA_WIDTH-1:0] temp = 12'h000;
	
	int count;
	
	always@(posedge sclk) begin
      case(state)
	   
			detect_state: begin
				if(cs == 1'b0) begin
					state <= read_state;
					temp <= 1'b0;
				end
				else begin
					state <= detect_state;
                end
			end
			
			read_state: begin
				if (count <= DATA_WIDTH-1) begin
					count <= count+1;
					temp <= {mosi, temp[DATA_WIDTH-1:1]};
				end
				else begin
					count <= 0;
					state <= detect_state;
					done <= 1'b1;
				end
			end	
		endcase
	end
	
	assign dout = temp;
	
endmodule

//////////////////////////////////////////////////////////////////////////////////////

module spi_top #(parameter DATA_WIDTH = 12)(
   input 					clk,
   input 					reset,
   input [DATA_WIDTH-1:0]	din,
   input 					new_data,
   output 					done,
   output [DATA_WIDTH-1:0]	dout);
   
   wire cs, mosi, sclk;
   
   spi_master DUT_master(.clk(clk), .reset(reset), .din(din), .new_data(new_data), .cs(cs), .mosi(mosi), .sclk(sclk));
   spi_slave DUT_slave(.sclk(sclk), .mosi(mosi), .cs(cs), .done(done), .dout(dout));
   
endmodule
