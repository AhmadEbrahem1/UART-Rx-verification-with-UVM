
class uart_Rx_driver extends uvm_driver #(uart_Rx_sequence_item);
//parametrized
  `uvm_component_utils(uart_Rx_driver)
	virtual uart_if vif;	// handler to put configs in it
  uart_Rx_sequence_item  item; // driver now has a handle to sequence_item
  

   function new(string name ="uart_Rx_driver", uvm_component parent);
   
		super.new(name,parent);
		`uvm_info("uart_Rx_driver","inside constructor !",UVM_LOW)
   endfunction:new


//--------------build_phase-----------------//
   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
     `uvm_info("uart_Rx_driver","build_phase !",UVM_LOW)
		
     if(! (uvm_config_db #(virtual uart_if ) :: get (this,"*","vif",vif) ))
		begin
			`uvm_error("uart_Rx_driver","failed to get vif drom DB!!") // takes 2 arguments
		end
		
		
	endfunction:build_phase
	
	//--------------connect_phase-------------//
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("uart_Rx_driver","connect_phase !",UVM_LOW)

	endfunction:connect_phase
	
  
  //------------run_phase----------------
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("uart_Rx_driver","run_phase !",UVM_LOW)
		//logic
      forever
        begin
           item=uart_Rx_sequence_item::type_id::create ("item");
          seq_item_port.get_next_item(item);
         
          // this better than directly drivng it is more modular
          drive(item);
			#1;
          seq_item_port.item_done();
          `uvm_info("uart_Rx_driver","after nowww",UVM_LOW)
        end
      
      
      
	endtask:run_phase
	
  
  /*
  
  try to use vif.modport 
  see if it woeks ***
  */
  task  drive(uart_Rx_sequence_item item); // pass by reference since it is an object
    
	
	//start bit
	@(vif.cb_drive );
    vif.cb_drive.Rx_in<=0;
	//other configs:
	vif.cb_drive.prescale<=item.prescale;
    vif.cb_drive.PAR_EN<=item.PAR_EN;
    vif.cb_drive.PAR_TYP<=item.PAR_TYP;
	vif.cb_drive.RST <=item.RST;
	
    //data
		$display ("data isssssss : %b",item.tx_Data);
		for(int i=0;i<8;i++)
		begin
			@(vif.cb_drive );
			vif.cb_drive.Rx_in <=item.tx_Data[i];
		end
	
	if(item.PAR_EN)
	begin
		@(vif.cb_drive );
		if(item.PAR_TYP)
		begin
			//Odd parity bit
			vif.cb_drive.Rx_in <=~^(item.tx_Data);
		end
		else
		begin
			//even parity 
			vif.cb_drive.Rx_in <=^(item.tx_Data);
			
	
		end
		
	end
	else
	begin
		// won't send anything
	end
	//stop bit 
	@(vif.cb_drive );
	vif.cb_drive.Rx_in<=1;
	
    
  endtask:drive


	
	
endclass : uart_Rx_driver

