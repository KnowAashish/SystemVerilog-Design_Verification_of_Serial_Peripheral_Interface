class monitor;

   transaction xtn_mon;
   
  mailbox #(bit [`DATA_WIDTH-1:0]) mon2sb;	// dut data
   
   virtual intf vif_mon;
   
   //bit [xtn_mon.DATA_WIDTH-1:0] temp;
   
  function new(mailbox #(bit [`DATA_WIDTH-1:0]) MON2SB);
      this.mon2sb = MON2SB;
   endfunction
   
   task run();
     xtn_mon = new();
      forever begin
	     @(posedge vif_mon.sclk);
		 
		 /*
		 wait(vif_mon.cs == 1'b0); // start of transaction
		 @(posedge vif_mon.sclk);
		 
		 for(int i=0; i<xtn_mon.DATA_WIDTH-1; i++) begin
			@(posedge vif_mon.sclk);
		    temp[i]	= vif_mon.mosi;
		 end
		 
		 wait(vif_mon.cs == 1'b1); // end of transaction
		 */
		 
		 @(posedge vif_mon.done);
		 xtn_mon.dout <= vif_mon.dout;
		 
		 @(posedge vif_mon.sclk);	// The delay between different components of the TB i.e. DRV & MON is same. 2 @sclk & 1 @done
		 
        //$display("at time t=%0t, [MON] : Data Sent = %0x%0h", $time, xtn_mon.dout);
		 mon2sb.put(xtn_mon.dout);
	  end
   
   endtask
   
endclass