//-------------------------------------------------------------------------------------------------
//
// File        : clockGen.v
//
// Description : This is a clock generator module. It also asserts a reset signal for 2 cycles.  
// Parameters:
//		period : Length of a clock cycle
//		number : Number of clock cycles to generate before stopping
//
//-------------------------------------------------------------------------------------------------
`timescale 1ns / 1ns

module clockGen (clk, reset);

output clk, reset;
reg clk, reset;

parameter period = 10;	// 10ns clock period by default
parameter number = 1000000;	// 1000000 clock cycles by default

integer i;

initial	begin
	clk = 0;
	reset = 1;
	#(period+1);
	for (i = 0; i != number; i = i + 1) begin
		clk = 1;
		#(period/2) clk = 0;
		if (i==1) reset = 0;
		#(period - period/2) ;
	end
	$stop; 
end

endmodule
