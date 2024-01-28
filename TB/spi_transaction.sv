class transaction;

   // Global Signals are defined in the tb top, Control Signals are defined here.
   // Target is to read din data serially at mosi
   //rand bit						new_data; 
   bit							new_data;
  randc bit [`DATA_WIDTH-1:0] 	data_in;
//   bit							cs;
//   bit							mosi;
  logic [`DATA_WIDTH-1:0] dout;
   
   // Display function for debugging
   function void display(string tag = "XTN");	// What diff would it make if we write input string or just string
     //$display("at time t=%0t, [%s] : new_data = %0b data_in = 0x%0h cs = %0b mosi = %0b", $time, tag, new_data, data_in, cs, mosi);
     $display("at time t=%0t, [%s] : new_data = %0b data_in = 0x%0h", $time, tag, new_data, data_in);
   endfunction
   
   // Transaction copy function
   function transaction copy();
      copy			= new;
	  copy.new_data	= this.new_data;
	  copy.data_in	= this.data_in;
	  //copy.cs		= this.cs;
	  //copy.mosi	= this.mosi;
	  copy.dout		= this.dout;
   endfunction

endclass
