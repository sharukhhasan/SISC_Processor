// ECE:3350 SISC computer project
// sisc testbench
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc_tb;
	wire clk;
	wire rst_f;
	wire [31:0] ir;
	
	sisc(clk, rst_f, ir);
	
endmodule