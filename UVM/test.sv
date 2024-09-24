
class uart_Rx_TEST extends uvm_test;


uart_Rx_env env;
uart_Rx_sequence  test_seq;

virtual uart_if  vif;
  `uvm_component_utils(uart_Rx_TEST)
  
  
  
  
  
   function new(string name ="uart_Rx_TEST", uvm_component parent);
   
		super.new(name,parent);
		`uvm_info("TEST_CLASS","inside constructor !",UVM_LOW)
   endfunction:new



   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST_CLASS","build_phase !",UVM_LOW)

     env=uart_Rx_env::type_id::create ("env",this);// now test contains  env
	 
	 if(! (uvm_config_db #(virtual uart_if ) :: get (this,"*","vif",vif) ))
		begin
			`uvm_error("uart_Rx_test","failed to get vif drom DB!!") // takes 2 arguments
		end
		
	endfunction:build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("TEST_CLASS","connect_phase !",UVM_LOW)
//connect monitor with scoreborad
	endfunction:connect_phase
	
  //-----------run_phase------------
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("TEST_CLASS","run_phase !",UVM_LOW)
      
      phase.raise_objection(this);
      
      
      //reset sequences
     //repeat(10)
      //begin
	  apply_reset;
     test_seq= uart_Rx_sequence:: type_id:: create("test_seq");
	 
      test_seq.start(env.agent.m_seqr); //run sequence on that sequencer
      #4000;
      `uvm_info("tessssssst","drop nowwwww !",UVM_LOW)
     // end
        phase.drop_objection(this);
    
    endtask:run_phase
	
	task apply_reset();
		
		vif.cb_drive.RST <=0;
		vif.cb_drive.Rx_in<=1;
		vif.cb_drive.PAR_EN<=0;
		vif.cb_drive.PAR_TYP<=0;
		vif.cb_drive.prescale<=0;
			
		repeat(2) @(vif.cb_drive);	
		vif.cb_drive.RST <=1;
	endtask
	
	
	

endclass : uart_Rx_TEST
