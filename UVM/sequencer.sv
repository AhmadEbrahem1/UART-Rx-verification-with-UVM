
class uart_Rx_sequencer extends uvm_sequencer  #(uart_Rx_sequence_item) ;

  `uvm_component_utils(uart_Rx_sequencer)



  function new(string name ="uart_Rx_sequencer", uvm_component parent) ;
   
		super.new(name,parent);
		`uvm_info("uart_Rx_sequencer","inside constructor !",UVM_LOW)
   endfunction:new



   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("uart_Rx_sequencer","build_phase !",UVM_LOW)

	endfunction:build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("uart_Rx_sequencer","connect_phase !",UVM_LOW)

	endfunction:connect_phase
	/* no run phase in here or any phases actually ^^
	task void run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("uart_Rx_sequencer","run_phase !",UVM_LOW)
		//logic
	endtask:run_phase
	*/
	
endclass : uart_Rx_sequencer
