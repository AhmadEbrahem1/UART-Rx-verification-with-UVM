
class uart_Rx_agent extends uvm_agent;
	`uvm_component_utils(uart_Rx_agent)
	uart_Rx_driver m_driver;
	uart_Rx_monitor m_monitor;
	uart_Rx_sequencer m_seqr;


   function new(string name ="uart_Rx_agent", uvm_component parent);
   
		super.new(name,parent);
		`uvm_info("uart_Rx_agent","inside constructor !",UVM_LOW)
   endfunction:new



   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("uart_Rx_agent","build_phase !",UVM_LOW)
		m_driver	= 	uart_Rx_driver ::type_id::create ("m_driver",this);
		m_monitor	= 	uart_Rx_monitor ::type_id::create ("m_monitor",this);
		m_seqr		= 	uart_Rx_sequencer ::type_id::create ("m_seqr",this);

    endfunction:build_phase
  
	//connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("uart_Rx_agent","connect_phase !",UVM_LOW)
		m_driver.seq_item_port.connect(m_seqr.seq_item_export);
	endfunction:connect_phase
	
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("uart_Rx_agent","run_phase !",UVM_LOW)
		//logic
	endtask:run_phase
	

endclass : uart_Rx_agent