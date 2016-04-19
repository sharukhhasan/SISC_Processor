// ECE:3350 SISC computer project
// sisc.v
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps

module sisc (clk, rst_f, ir);
	input [31:0] ir;
	input clk, rst_f;
	
	// datapath
	wire [3:0] opcode, mm;
	wire [3:0] Rs, Rt;
	wire [3:0] Rd;
	wire [15:0] imm;
	wire [3:0] write_reg;
	wire [31:0] write_data;
	wire clk;
	wire rst_f;
	wire [31:0] mux32in_a;
	wire [3:0] statCode;
	wire [31:0] rsa;
	wire [31:0] rsb;
	wire [31:0] alu_result;
	wire [3:0] stat;
	wire [1:0] alu_op;
	wire stat_en;
	wire rf_we;
	wire wb_sel;
	wire rd_sel;
	//wire [31:0] mux32_out;
	//wire [31:0] in_b;
	//wire [3:0] mux4_result;
	//wire [3:0] cc;
	//wire imm_sel;
	//wire sub;
	//wire cc_en;
	//wire [1:0] log_ctl;
	//wire shf_ctl;
	
	assign opcode = ir[31:28];
	assign mm = ir[27:24];
	assign Rs = ir[23:20];
	assign Rt = ir[19:16];
	assign Rd = ir[15:12];
	assign imm = ir[15:0];
	assign mux32in_a = 0;
	
	
	//wire [31:0] IR;
	//wire [15:0] pc_out;		
	//wire [15:0] pc_inc;
	//wire [15:0] branch_address;
	//wire br_sel;
	//wire pc_rst;
	//wire pc_write;
	//wire pc_sel;
	//wire ir_load;
	
	
	// ctrl
	ctrl my_ctrl(clk, rst_f, opcode, mm, statCode, rf_we, alu_op, wb_sel, rd_sel);
	
	// mux4
	mux4 my_mux4(Rt, Rd, rd_sel, write_reg);
	
	// rf
	rf my_rf(Rs, Rt, write_reg, write_data, rf_we, rsa, rsb);
	
	// alu
	alu my_alu(rsa, rsb, imm, alu_op, alu_result, stat, stat_en);
	
	// mux32
	mux32 my_mux32(zero, alu_result, wb_sel, write_data);
	
	// statreg
	statreg my_statreg(stat, stat_en, statCode);
	
	// components
	
	// mux4
	/*mux4 _mux4(.in_a	(ir[15:12]),
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
				 .rsb	       (rsb),
				 .clk				(clk));
	
	// alu
	alu _alu(.rsa	(rsa[31:0]),
			.rsb	(rsb[31:0]),
			.alu_op	(alu_op[1:0]),
			.alu_result	(alu_result),
			.stat	(cc),
			.stat_en	(cc_en),
			.imm (ir[15:0]),
			.clk (clk));
	
	// mux32
	mux32 _mux32(.in_a	(32'h00000000),
		     .in_b	(alu_result[31:0]),
		     .sel	(wb_sel),
		     .out	(mux32_out));
	
	// statreg
	statreg _statreg(.in	   (cc[3:0]),
			 .enable   (cc_en),
			 .out	   (stat_out),
			 .clk (clk));
	
	ctrl _ctrl(.clk	(clk),
		   .rst_f	(rst_f),
		   .opcode	(ir[31:28]),
		   .mm	        (ir[27:24]),
		   .stat	(stat_out),
		   .rf_we (rf_we),
		   .alu_op	(alu_op[1:0]),
		   .wb_sel	(wb_sel),
		   .rd_sel (rd_sel));*/
		   //.br_sel (br_sel),
		   //.pc_rst (pc_rst),
		   //.pc_write (pc_write),
		   //.pc_sel (pc_sel));
		   
	/*pc _pc(.clk (clk),
				 .br_addr (branch_address[15:0]),
				 .pc_sel (pc_sel),
				 .pc_write (pc_write),
				 .pc_rst (pc_rst),
				 .pc_out (pc_out),
				 .pc_inc (pc_inc));
	
	im _im(.read_addr (read_addr[15:0]),
				 .read_data (IR[31:0]));
	
	br _br(.pc_inc (pc_inc[15:0]),
				 .imm (IR[15:0]),
				 .br_sel (br_sel),
				 .br_addr (branch_address));
				 
  ir _ir(.clk (clk),
  	     .ir_load (ir_load),
  	     .read_data (IR[31:0]),
  	     .instr	(IR[31:0]));*/
	
	
endmodule