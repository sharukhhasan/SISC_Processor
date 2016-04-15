// ECE:3350 SISC computer project
// sisc.v
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc (clk, rst_f, ir);
	//input [31:0] ir;
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
	wire [31:0] IR;
	wire [15:0] pc_out;		
	wire [15:0] pc_inc;
	wire [15:0] branch_address;
	wire br_sel;
	wire pc_rst;
	wire pc_write;
	wire pc_sel;
	
	
	
	// components
	
	// mux4
	mux4 _mux4(.in_a	(ir[15:12]),
				.in_b	(ir[19:16]),
				.sel	(rd_sel),
				.out	(mux4_result));
	
	// rf
	rf _rf(.read_rega	(ir[23:20]),
				 .read_regb    (ir[19:16]),
				 .write_reg    (mux4_result[3:0]),
				 .write_data   (mux32_out[31:0]),
				 .rf_we	       (rf_we),
				 .rsa	       (rsa),
				 .rsb	       (rsb));
	
	// alu
	alu _alu(.rsa	(rsa[31:0]),
			.rsb	(rsb[31:0]),
			.alu_op	(alu_op[1:0]),
			.alu_result	(alu_result),
			.stat	(cc),
			.stat_en	(cc_en),
			.imm (ir[15:0]));
	
	// mux32
	mux32 _mux32(.in_a	(32'h00000000),
		     .in_b	(alu_result[31:0]),
		     .sel	(wb_sel),
		     .out	(mux32_out));
	
	// statreg
	statreg _statreg(.in	   (cc[3:0]),
			 .enable   (cc_en),
			 .out	   (stat_out));
	
	// ctrl
	ctrl _ctrl(.clk	(clk),
		   .rst_f	(rst_f),
		   .opcode	(ir[31:28]),
		   .mm	        (ir[27:24]),
		   .stat	(stat_out),
		   .rf_we (rf_we),
		   .alu_op	(alu_op[1:0]),
		   .wb_sel	(wb_sel),
		   .rd_sel (rd_sel),
		   .br_sel (br_sel),
		   .pc_rst (pc_rst),
		   .pc_write (pc_write),
		   .pc_sel (pc_sel));
		   
	pc _pc();
	
	im _im();
	
	br _br();
	
	
endmodule