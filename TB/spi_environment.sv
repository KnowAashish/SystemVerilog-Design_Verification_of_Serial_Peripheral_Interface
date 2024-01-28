class environment;

   generator 	gen;
   driver		drv;
   
   monitor		mon;
   scoreboard	sb;
   
   //event drv_next;	// gen -> drv
   event sb_next;	// gen -> sb
   event done;
   event next;
   
   virtual intf vif_env;
   
   mailbox #(transaction) 			gen2drv;	// GEN to DRV
   mailbox #(bit [`DATA_WIDTH-1:0]) ref_data;	// DRV to SB
   mailbox #(bit [`DATA_WIDTH-1:0]) dut_data;	// MON to SB
   
   // Constructor
   function new(virtual intf VIF_ENV);
      gen2drv	= new;
	  ref_data	= new;
	  dut_data	= new;
	  
	  // Connect Mailbox
	  gen   	= new(gen2drv);
	  drv		= new(gen2drv, ref_data);
	  mon		= new(dut_data);
	  sb		= new(ref_data, dut_data);
	  
	  //Connect Events
	  //gen.drv_next	= this.drv_next;
	  //drv.drv_next	= this.drv_next;
	  
	  gen.sb_next	= this.next;
	  sb.sb_next	= this.next;
	  
	  this.vif_env	= VIF_ENV;
	  drv.vif_drv	= this.vif_env;
	  mon.vif_mon	= this.vif_env;
   endfunction
   
   // Task to run pre-test actions
   task pre_test();
      drv.reset();
   endtask
   
   // Task to run the test
   task test();
      fork
	     gen.run();
		 drv.run();
		 mon.run();
		 sb.run();
	  join_any
   endtask
   
   // Task to run the post-test actions
   task post_test();
      wait(gen.gen_done.triggered);
	  $finish;
   endtask
   
   task run();
      pre_test();
	  test();
	  post_test();
   endtask
   
endclass