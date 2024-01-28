class scoreboard;

   mailbox #(bit [`DATA_WIDTH-1:0]) sb2drv;
   mailbox #(bit [`DATA_WIDTH-1:0]) sb2mon;
   
   bit [`DATA_WIDTH-1:0] ref_data;	// data from driver
   bit [`DATA_WIDTH-1:0] dut_data;  // data from monitor
   
   event sb_next;
   
   // Constructor
  function new(mailbox #(bit [`DATA_WIDTH-1:0]) SB2DRV, SB2MON);
      this.sb2drv = SB2DRV;
	  this.sb2mon = SB2MON;
   endfunction
   
   // Task to compare data from driver and monitor
   task run();
      
	  forever begin
	     sb2drv.get(ref_data);	// from DRV
		 sb2mon.get(dut_data);	// from MON
		 
		 $display("at time t=%0t, [SB]  Ref_Data = 0x%0h DUT_Data = 0x%0h", $time, ref_data, dut_data);
		 
		 if(ref_data == dut_data)
		    $display("at time t=%0t, [SB]  : DATA MATCHED", $time);
		 else
		    $display("at time t=%0t, [SB]  : DATA MISMATCHED", $time);
		
		$display("---------------------------------------------------------------");
		
        ->sb_next;	// This trigger notifies GEN to start next transaction
	  end
	  
   endtask
   
endclass