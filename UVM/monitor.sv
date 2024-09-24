
class uart_Rx_monitor extends uvm_monitor;

  `uvm_component_utils(uart_Rx_monitor)
	virtual uart_if vif;	
 uart_Rx_sequence_item  item;

  
  uvm_analysis_port #(uart_Rx_sequence_item ) monitor_analysis_port;
  
  
   function new(string name ="uart_Rx_monitor", uvm_component parent);
   
     super.new(name,parent);  
     monitor_analysis_port = new ("monitor_analysis_port",this);
	`uvm_info("uart_Rx_monitor","inside constructor !",UVM_LOW)
   endfunction:new



   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("uart_Rx_monitor","build_phase !",UVM_LOW)
		
     if(! (uvm_config_db #(virtual uart_if ) :: get (this,"*","vif",vif) ))
		begin
			`uvm_error("uart_Rx_monitor","failed to get vif drom DB!!") // takes 2 arguments
		end
		
	endfunction:build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("uart_Rx_monitor","connect_phase !",UVM_LOW)

	endfunction:connect_phase
	
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("uart_Rx_monitor","run_phase !",UVM_LOW)
      
      
      forever  
        begin
		//logic
			item=uart_Rx_sequence_item::type_id::create ("item");
			@(vif.cb_sample);
			
			if(vif.cb_sample.RST)
			begin
			
			//sample inputs
			item.rx_in=		vif.cb_sample.Rx_in;
			item.PAR_EN=	vif.cb_sample.PAR_EN;
			item.PAR_TYP=	vif.cb_sample.PAR_TYP;
			item.prescale=	vif.cb_sample.prescale;
			
			//sample outputs  
			item.expec_P_Data	= vif.cb_sample.P_DATA;
			item.data_valid		= vif.DATA_Valid;
			item.PAR_ERR		= vif.cb_sample.PAR_ERR;
			item.STP_ERR 		= vif.cb_sample.STP_ERR;
			//send to scb
			monitor_analysis_port.write(item);
			end
		  
		  
		  
        end
      
      
	endtask:run_phase
	

endclass : uart_Rx_monitor
