
class UART_Scoreboard extends uvm_monitor;

  `uvm_component_utils(UART_Scoreboard)

	logic [1:0] rx_stream = 'b11;
	
	logic [7:0] expected_data=0,temp_data =0;
	logic expected_valid , expected_par_err,expected_stp_error;
	
	
	logic [15:0]one_bit ={16{1'b1}} ; // maximum prescale 16
	int bit_count=0 ,Byte_count =0 ;
	bit decision_bit,expec_parity;
	typedef enum 
	{stand_by, data,parity_check,stop_check,valid_assert} uart_state; 
	uart_state state = stand_by;
		
  uart_Rx_sequence_item transactions[$];
  uvm_analysis_imp #(uart_Rx_sequence_item,UART_Scoreboard) scb_analysis_imp;
 // uvm_comparer comp;
  
  
  
   function new(string name ="UART_Scoreboard", uvm_component parent);
   
		super.new(name,parent);
     scb_analysis_imp=new("scb_analysis_imp",this);
		`uvm_info("UART_Scoreboard","inside constructor !",UVM_LOW)
   endfunction:new


		//---------build_phase----------------

   function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("UART_Scoreboard","build_phase !",UVM_LOW)
		//comp =new(); 		
	endfunction:build_phase
  
  
  
  
			//---------connect_phase----------------

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("UART_Scoreboard","connect_phase !",UVM_LOW)

	endfunction:connect_phase
	
	//run phase can  neglected
	//---------run_phase----------------
	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
     
		`uvm_info("UART_Scoreboard","run_phase !",UVM_LOW)
		/*
		comp.verbosity = UVM_LOW;
		comp.sev = UVM_ERROR;
		comp.show_max = 100;
		*/
	  forever  
        begin
           uart_Rx_sequence_item tx_DUT;
		//logic
          wait(transactions.size() !=0);
          tx_DUT=transactions.pop_front(); //FIFO
          Reference_UART(tx_DUT);
        end
      
      
	endtask:run_phase
	
	function  void write (uart_Rx_sequence_item item);
		transactions.push_back(item);
	endfunction: write
  
  
	task Reference_UART (uart_Rx_sequence_item tx_DUT);
			//$display( "bit is : %b" ,tx_DUT.rx_in);
			case(state)
			stand_by:
			begin
				
				//expected_data =0 ;
				expected_valid =0;
				expected_par_err=0;
				expected_stp_error=0;
					
				rx_stream = 'b11;
				rx_stream = rx_stream <<1 | tx_DUT.rx_in ;
				case(rx_stream)
				'b11:
				begin
					//IDLE >> current output should be:

					state = stand_by;
				end
				'b10:
				begin
					//start bit , next shoud be data
					one_bit = one_bit << 1 | tx_DUT.rx_in;
					bit_count++;
					
					if(bit_count==tx_DUT.prescale)
					begin
						bit_count =0;
						decision_bit= find_majority(one_bit,tx_DUT.prescale);
						one_bit ={16{'b1}} ;
						if(decision_bit==0)
						begin
							
							state = data;
						end
						else 
							state = stand_by;
					end
					else
						state = stand_by;
				end
				default:
				begin
					$display("IT ISSSSSSSSSSS : %b",rx_stream);
					//`uvm_error("FATAL","CAN'T BE",UVM_LOW)
					$display("ERRRRRRRRRRRRRRRRRRRORRRRR");
					
					state = stand_by;
				end
				endcase
			end
			data:
			begin
				expected_data = temp_data ;
				//temp_data =0;
				
				expected_valid=0;
				expected_par_err=0;
				expected_stp_error=0;
				
				one_bit =one_bit <<1 | tx_DUT.rx_in ;   // 1111111100000000000000
				bit_count ++;
				if(bit_count != tx_DUT.prescale)
				begin
					state = data;
				end
				else
				begin
					//call majority 
					decision_bit = find_majority(one_bit,tx_DUT.prescale);
					 // lsb should be first
					temp_data[Byte_count] =decision_bit;
						$display("expected_data data is %b",expected_data);
					Byte_count++;
					bit_count=0;
					if(Byte_count == 8)
					begin
						//expected_data = temp_data ;
						//temp_data =0;
						$display("scbbbbb data is %b",expected_data);
						Byte_count=0;
						//cacuate partiy
						if( tx_DUT.PAR_TYP)
						//odd
							expec_parity =~^(temp_data) ;
						else
							expec_parity =^(temp_data) ;
						
						if(tx_DUT.PAR_EN)
							state = parity_check;
						else
							state = stand_by ;
					end
					else
					begin
						//expected_data = 0 ;
						//one_bit ={16{'b1}} ;
						state = data;
						
					
					end	
				end
			end
			parity_check:
			begin
				expected_data = temp_data ;
				one_bit = one_bit << 1 | tx_DUT.rx_in;
					bit_count++;
					
					if(bit_count==tx_DUT.prescale)
					begin
						bit_count =0;
						decision_bit= find_majority(one_bit,tx_DUT.prescale);
						one_bit ={16{'b1}} ;
						if(expec_parity ==  decision_bit )
						begin
							expected_valid =0;
							expected_par_err=0;
							expected_stp_error=0;
						end
						else
						begin
							expected_valid =0;
							expected_par_err=1;
							expected_stp_error=0;
						end
						state = stop_check;
					end
					else
						state = parity_check;
				
			end
			stop_check:
			begin
				//$display("TIME 222 = %t",$time);
				one_bit = one_bit << 1 | tx_DUT.rx_in;
				bit_count++;
				
				if(bit_count==tx_DUT.prescale-1)
				begin
					bit_count =0;
					decision_bit= find_majority(one_bit,tx_DUT.prescale);
					one_bit ={16{'b1}} ;
					
					
					if(decision_bit ==1)
					begin
						//expected_data = 0 ;
						expected_valid=0;
						expected_par_err=0;
						expected_stp_error=0;
						state = valid_assert;
					end
					else
					begin
						//expected_data = 0 ;
						expected_valid =0;
						expected_par_err=0;
						expected_stp_error=1;
					end
					//state = stand_by;
					
				end
				else
					state = stop_check;
						
						
						
				
				
			end
			valid_assert:
			begin
				
				one_bit = one_bit << 1 | tx_DUT.rx_in;
				bit_count++;
				
				if(bit_count==tx_DUT.prescale)
				begin
					bit_count =0;
					decision_bit= find_majority(one_bit,tx_DUT.prescale);
					one_bit ={16{'b1}} ;
					
					
					if(decision_bit ==1) // back to idle
					begin
						//expected_data = 0 ;
					expected_valid=1;
					expected_par_err=0;
					expected_stp_error=0;
					state = stand_by;
					end
					else // new start bit
					begin
					expected_valid=1;
					expected_par_err=0;
					expected_stp_error=0;
					state = data;
					end
					//state = stand_by;
					
				end
				else
					state = valid_assert;
					
					
				//$display("TIME = %t",$time);
				
				
				
			end
			default:
			begin
				
				`uvm_fatal ("STATE ERROR ","CAN'T BE")

			end
			endcase
			
		$display("CURR state is %s @ %t",state,$time);
		
		if( !compare_tx(tx_DUT))
			`uvm_warning ("STATE ERROR ","MISMATCHHHHHHHHHH")
			//uvm_fatal uvm_warning
			
		
	endtask:Reference_UART
  
  
  
  
	function  bit find_majority( logic [15:0]  one_bit,int prescale);
		int zero_cnt=0,one_cnt=0;
		
		for(int i=0;i<prescale;i++)
		begin
			if(one_bit[i] ==0)
				zero_cnt++;
			else
				one_cnt++;
			
		end
		
		if(zero_cnt>= one_cnt)
			return 0;
		else 
			return 1;
	endfunction: find_majority
	
	
	function bit  compare_tx (uart_Rx_sequence_item tx);
		if(   tx.expec_P_Data ==expected_data)
			if( tx.data_valid	==expected_valid)
				if( tx.PAR_ERR	==expected_par_err)
					if(tx.STP_ERR	==expected_stp_error)
						return 1 ;
					
					else
					begin
						$display("STP_ERR MISMATCHHHHHHHHHH");
						return 0;
					end
				else
				begin
					$display(" tx.PAR_ERR	==expected_par_err MISMATCHHHHHHHHHH");
					return 0;
				end
			else
			begin
				$display("data_valid MISMATCHHHHHHHHHH dut= %b and scb is %b",tx.data_valid,expected_valid);
				return 0;
			end
		else
		begin
			$display("dataaaa MISMATCHHHHHHHHHH DUT is : %b , scb is %b",tx.expec_P_Data,expected_data);
			return 0;
		end
				
			
			
		
	endfunction
endclass : UART_Scoreboard
