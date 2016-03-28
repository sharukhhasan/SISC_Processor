// ECE:3350 SISC computer project
// sisc.v
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc (clk, rst_f, ir);
	input [31:0] ir;
	input clk, rst_f;
	
	// datapath
	wire [31:0] rsa;
	wire [31:0] rsb;
	wire [31:0] mux32_out;
	wire [31:0] alu_result;
	wire [31:0] in_b;
	wire [3:0] mux4_result;
	wire [3:0] cc;
	wire [3:0] stat_out;
	wire [1:0] alu_op;
	wire rf_we;
	wire wb_sel;
	wire rd_sel;
	wire imm_sel;
	wire sub;
	wire cc_en;
	wire [1:0] log_ctl;
	wire shf_ctl;
	
	// components
	
	// mux4
	mux4 _mux4(
		
	);
	
	// rf
	rf _rf(
		
	);
	
	// alu
	alu _alu(
		
	);
	
	// mux32
	mux32 _mux32(
		
	);
	
	// statreg
	statreg _statreg(
		
	);
	
	// ctrl
	ctrl _ctrl(
		
	);
	
	
endmodule