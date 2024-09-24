 `timescale 1ns/1ps
/*
`timescale 1ns / 10ps  timescale/precision
or use this : 
  timeunit 100ps;
  timeprecision 10fs;
section 3.14.2.3 Precedence of timeunit, timeprecision, and `timescale IEEE sv 

*/
 import uvm_pkg::*;

`include "uvm_macros.svh"
//------------------
//includes
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

  
//---------------
  
module top #(parameter Rx_period = 2,Tx_period =16)();



 


bit clk,tx_clk,rst_clk_div;
always #(Rx_period/2) clk=! clk ;
  uart_if  uart_IF(.clk(clk),.tx_clk(tx_clk));


TOP_RX_UART  dut (
.CLK(clk),
.RST(uart_IF.RST),
.RX_IN(uart_IF.Rx_in),
.PAR_EN(uart_IF.PAR_EN),
.PAR_TYPE(uart_IF.PAR_TYP),
.prescale(uart_IF.prescale), 
.P_DATA(uart_IF.P_DATA), 
.valid_DATA(uart_IF.DATA_Valid),
.PAR_ERR(uart_IF.PAR_ERR),
.STP_ERR(uart_IF.STP_ERR)



);




/*
UART_RX  dut (
.CLK(clk),
.RST(uart_IF.RST),
.RX_IN(uart_IF.Rx_in),
.parity_enable(uart_IF.PAR_EN),
.parity_type(uart_IF.PAR_TYP),
.Prescale(uart_IF.prescale), 
.P_DATA(uart_IF.P_DATA), 
.data_valid(uart_IF.DATA_Valid),
.parity_error(uart_IF.PAR_ERR),
.framing_error(uart_IF.STP_ERR)



);
*/


/////////////////
initial
begin
	uvm_config_db #(virtual uart_if ) :: set (null,"*","vif",uart_IF);
end



initial 
begin
	clk=0;
	
	rst_clk_div=1;
	#1;
	rst_clk_div=0;
	#1;
	rst_clk_div=1;
	$dumpfile("uart.vcd");
	$dumpvars();
	
	#5000;
	$display("END OF clk !!!! ");
	$finish();
	
end

initial 
begin
	
	run_test("uart_Rx_TEST");
	
end






 ClkDiv clk_div_inst(
.i_ref_clk(clk) ,   
.i_rst(rst_clk_div) ,       
.i_clk_en(1'b1),     
.i_div_ratio(8'd8),   
.o_div_clk(tx_clk)     
);




endmodule : top

