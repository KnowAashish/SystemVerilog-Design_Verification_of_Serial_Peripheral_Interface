class generator;

   transaction xtn_gen;
   
   mailbox #(transaction) gen2drv;
   
   event gen_done;
   //event drv_next;
   event sb_next;
   
   int no_of_packets = 0;	// Total Stimulus Packets. Set from TB
   
   // Constructor
   function new (mailbox #(transaction) GEN2DRV);
      xtn_gen		= new();
	  this.gen2drv	= GEN2DRV;
   endfunction
   
   task run();
   
      repeat (no_of_packets) begin
	     assert(xtn_gen.randomize())
		    else $error("at time t = %0t, [GEN] : RANDOMIZATION FAILED", $time);
		 
		 xtn_gen.display("GEN");
        gen2drv.put(xtn_gen.copy);
		 
		 //@(drv_next);
		 @(sb_next);
	  end
	  ->gen_done;
	  
   endtask
   
endclass