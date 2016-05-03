// ECE:3350 SISC computer project
// sisc.v
// Sharukh Hasan & Mark Parise

`timescale 1ns/100ps 

module sisc(clk, rst_f);

input clk, rst_f;
wire [31:0] IR;
wire[3:0] opcode, mm;
wire[3:0] rs, rt;
wire[3:0] rd;
wire[15:0] imm;
//wire clk, rst_f;

assign opcode = IR[31:28];
assign mm = IR[27:24];
assign rs = IR[23:20];
assign rt = IR[19:16];
assign rd = IR[15:12];
assign imm = IR[15:0];

wire[3:0] statcode;
wire rf_we;
wire [1:0] alu_op;
wire wb_sel;
wire rd_sel;
wire [3:0] write_reg;
wire [31:0] write_data, read_data;
wire [31:0] rsa, rsb;
wire [31:0] alu_result, rs_data, rt_data, normal_data, final_result, rsort_data;
wire [3:0] stat;
wire stat_en;
wire ir_load;

wire br_sel, pc_rst, pc_write, pc_sel, mm_sel, dm_we;
wire [15:0] br_adder, pc_out, pc_inc, addr;
wire data_sel, rs_en, rsort_sel;

ctrl control(clk, rst_f, opcode, mm, statcode, rf_we, alu_op, wb_sel, rd_sel, br_sel, pc_rst, pc_write, pc_sel, mm_sel, dm_we, ir_load, rs_en, rsort_sel, data_sel);

im InstructionMem (pc_out , IR);
pc ProgramCounter (clk, br_adder, pc_sel, pc_write, pc_rst, pc_out, pc_inc);
br Branch (pc_inc, imm, br_sel, br_adder);
dm Datamem (addr, addr, rsb, dm_we, read_data);

mux16 Datamux (alu_result[15:0], imm, mm_sel, addr);
rf RF (clk, rs, rt, write_reg, final_result, rf_we, rsa, rsb);
mux4 muxOnleft (rd, rt, rd_sel, write_reg);
alu math (clk, rsa, rsb, imm, alu_op, alu_result, stat, stat_en);
mux32 muxOnRight (read_data, alu_result, wb_sel, normal_data);
statreg st (clk, stat, stat_en, statcode);

ir rtData(clk, ir_load, rsb, rt_data);
ir rsData(clk, ir_load, rsa, rs_data);
mux32 dataWriting(normal_data, rsort_data, data_sel, final_result);//
mux32 rsort(rs_data, rt_data, rsort_sel, rsort_data);

initial
begin
/*$monitor($time,,,"IR: %h, R0: %h, R1: %h, R2: %h,  R3: %h,  R4: %h,  R5: %h, R6: %h, R12 : %h R13 : %h R14 : %h, R15 : %h",
IR, RF.ram_array[0], RF.ram_array[1], RF.ram_array[2], RF.ram_array[3],RF.ram_array[4],RF.ram_array[5],RF.ram_array[6],RF.ram_array[12],RF.ram_array[13],RF.ram_array[14],RF.ram_array[15]);*/
end

endmodule
