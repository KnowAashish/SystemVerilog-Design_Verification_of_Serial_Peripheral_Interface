class driver;

   transaction xtn_drv;
   
   mailbox #(transaction) drv2gen;
  mailbox #(bit [`DATA_WIDTH-1:0]) drv2sb;	// ref data
   
   //event drv_next;
   
   virtual intf vif_drv;
   
  function new(mailbox #(transaction) DRV2GEN, mailbox #(bit [`DATA_WIDTH-1:0])DRV2SB);
      this.drv2gen	= DRV2GEN;
	  this.drv2sb	= DRV2SB;
   endfunction
   
   task reset();
     
      vif_drv.reset		<= 1'b1;
	  vif_drv.new_data	<= 1'b0;
	  //vif_drv.cs		<= 1'b1;
	  //vif_drv.mosi		<= 1'b0;
	  vif_drv.data_in	<=  1'b0;
	  repeat(10)
	     @(posedge vif_drv.clk);
		 
	  vif_drv.reset		<= 1'b0;	// Removing reset after waiting for 10 clks
	  repeat(5)
	     @(posedge vif_drv.clk);
		 
	  $display("at time t=%0t, [DRV] : RESET DONE", $time);
	  $display("---------------------------------------------------------------");
  
   endtask
   
   task run();
   
      forever begin
	     drv2gen.get(xtn_drv);
		 vif_drv.new_data	<= 1'b1; // Signifies we have new data to drive
		 vif_drv.data_in	<= xtn_drv.data_in;
		 
		 drv2sb.put(xtn_drv.data_in);
		 $display("at time t=%0t, Data Sent to SB = 0x%0h", $time, xtn_drv.data_in);
		 
		 @(posedge vif_drv.sclk);
		 vif_drv.new_data	<= 1'b0;

		 @(posedge vif_drv.done);	// end of transaction for spi_top
		 //wait(vif_drv.cs == 1'b1);		// end of transaction
		 $display("at time t=%0t, [DRV], Data Sent to DAC = 0x%0h", $time, xtn_drv.data_in);
		 
        @(posedge vif_drv.sclk);	// This means that new_data will be high in the next clock cycle to when done become high.
		 //->(drv_next);
	  end
	  
   endtask
endclass