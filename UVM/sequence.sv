//object class

class uart_Rx_sequence extends uvm_sequence;

`uvm_object_utils(uart_Rx_sequence)
uart_Rx_sequence_item  test_pkt;




function new (string name="uart_Rx_sequence");

	
	super.new(name);
	`uvm_info("uart_Rx_sequence","inside constructor",UVM_LOW)


endfunction:new

task pre_body;
		test_pkt = uart_Rx_sequence_item::type_id::create("test_pkt");
	 endtask

task body();
	`uvm_info("uart_Rx_sequence","inside the body_task",UVM_LOW)
	
	
	
		
	start_item(test_pkt);
	test_pkt.randomize() with {
	prescale==8;
	PAR_EN==1;
	PAR_TYP==1;
	RST ==1;
	
	
	
	};
	
	
	test_pkt.print();
	finish_item(test_pkt);
	`uvm_info("uart_Rx_sequence","done",UVM_LOW)

endtask: body





endclass:uart_Rx_sequence

