interface uart_if (input bit clk,input tx_clk);


//inputs
logic RST,Rx_in,PAR_EN,PAR_TYP;
logic [5:0] prescale;

//outputs
logic [7:0] P_DATA;
logic DATA_Valid,PAR_ERR,STP_ERR;
//modport input_uart (input RST,DATA_Valid,PAR_EN,PAR_TYP,P_DATA,output TX_OUT,BUSY);


//modport output_uart (;output RST,DATA_Valid,PAR_EN,PAR_TYP,P_DATA,input TX_OUT,BUSY);

clocking cb_drive @(posedge tx_clk);
	default input #1step output #0.5ns; 
	/*
	step of time unit it is generic than 3ns
	*/
	input	P_DATA,DATA_Valid,PAR_ERR,STP_ERR;
	output	RST,Rx_in,PAR_EN,PAR_TYP,prescale;	 
endclocking

clocking cb_sample @(posedge clk);
	default input #0.25ns output #0.5ns ; 
	/*
	step of time unit it is generic than 3ns
	*/
	input	P_DATA,DATA_Valid,PAR_ERR,STP_ERR;
	input	RST,Rx_in,PAR_EN,PAR_TYP,prescale;	 
endclocking


endinterface :uart_if