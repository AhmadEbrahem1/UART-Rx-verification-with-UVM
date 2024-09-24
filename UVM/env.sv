
class uart_Rx_env extends uvm_env;

  `uvm_component_utils(uart_Rx_env)
uart_Rx_agent agent;
UART_Scoreboard scb;
  

   function new(string name ="uart_Rx_env", uvm_component parent);
   
		super.new(name,parent);
		`uvm_info("uart_Rx_env","inside constructor !",UVM_LOW)
   endfunction:new



   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("uart_Rx_env","build_phase !",UVM_LOW)
     agent= 	uart_Rx_agent ::type_id::create ("agent",this);
     scb = UART_Scoreboard::type_id::create ("scb",this);
     
     
     
	endfunction:build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
      
      agent.m_monitor.monitor_analysis_port.connect(scb.scb_analysis_imp);
		`uvm_info("uart_Rx_env","connect_phase !",UVM_LOW)

	endfunction:connect_phase
	
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("uart_Rx_env","run_phase !",UVM_LOW)
		//logic
	endtask:run_phase
	

endclass : uart_Rx_env
