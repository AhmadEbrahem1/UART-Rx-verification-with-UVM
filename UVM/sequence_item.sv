//object class

class uart_Rx_sequence_item extends uvm_sequence_item ;

`uvm_object_utils(uart_Rx_sequence_item)



rand logic [5:0]  prescale ;
 rand logic PAR_EN,PAR_TYP,rx_in,RST;
 rand logic [7:0] tx_Data; // driver
 
 logic [7:0] expec_P_Data;
 logic data_valid,PAR_ERR,STP_ERR;


	function new (string name="uart_Rx_sequence_item");

		super.new(name);
	endfunction:new

endclass:uart_Rx_sequence_item


/*
PAR_EN (Configuration
0: To disable frame parity bit 
1: To enable frame parity bit

PAR_TYP (Configuration)
0: Even parity bit 
1: Odd parity bit
	
*/