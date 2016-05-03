// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel, rd_sel, br_sel, pc_rst, pc_write, pc_sel, 
						mm_sel, dm_we, ir_load, reg_swap, swap_en, data_swap, mux_swap);
  
 	input clk, rst_f;
	input [3:0] stat, opcode, mm;
	output reg rf_we, wb_sel, mm_sel, dm_we, ir_load;
	//part 2 output
	output reg br_sel, pc_rst, pc_write, pc_sel;
	output reg [1:0] alu_op;
	output reg [1:0] rd_sel;
	output reg reg_swap, data_swap, swap_en, mux_swap;
	
  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter NOOP = 0, LOD = 1, STR = 2, SWAP = 3, ALU_OP = 8, BRA = 4, BRR = 5, BNE = 6, HLT = 15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state;
  
  initial
  begin
  	pc_rst = 1;
  	pc_write <= 1;
  end
  
  always @(posedge clk or negedge rst_f)
  	begin
    	if (!rst_f) 
    		begin
    			pc_rst <= 1;
      		present_state <= start0;
    		end
    	else
    		begin
    			pc_rst <= 0;
    			present_state <= next_state;
    		end
    end

  /* TODO: Write a process that determines the next state of the fsm. */
  always @(present_state)
  begin
	 	case(present_state)
		   start0: next_state <=start1;
		   start1:  next_state <= fetch;
		   fetch:   next_state <= decode;
 		   decode:  next_state <= execute;
		   execute: next_state <= mem;
   		 mem:  next_state <= writeback;
  		 writeback: next_state <= fetch;     
		endcase
  end

  // Halt on HLT instruction
  always @ (opcode)
  begin
    if (opcode == HLT)
    begin 
      #1 $display ("Halt."); //Delay 1 ns so $monitor will print the halt instruction
      $stop;
    end
  end
    
  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2 and 3, you will
       add the new control signals here. */
  always @(posedge clk)
  	begin
    	if(opcode == NOOP)
    		begin 
      		rf_we <= 1'b0;
      		alu_op <= 2'b00;
      		rd_sel <= 1'b0;
      		wb_sel <= 1'b0;
      		pc_sel <= 0;
      		pc_rst <= 0;
      		br_sel <= 0;
					dm_we <= 0;
					mm_sel <= 0;
					mux_swap <= 0;
					swap_en <= 0;
    		end

  		// fetch
    	if(present_state == fetch)
				begin
					rd_sel <= 0;
					alu_op <= 2'b00;
					rf_we <= 0;
					wb_sel <= 0;
					pc_write <= 1;
					pc_sel <= 0;
					pc_rst <= 0;
					dm_we <= 0;
					data_swap <= 0;
					reg_swap <= 0;
					
					if(opcode == ALU_OP)
						begin
							br_sel <= 0;	
							rf_we <= 0;
							wb_sel <= 0;
							alu_op <= 0;
							pc_sel <= 0;
						end
  
					if((opcode == BRA) || (opcode == BRR) || (opcode == BNE))
						begin
							rf_we <= 0;
							wb_sel <= 0;
							alu_op <= 2'b10;
						end
			
					if((opcode == LOD)||(opcode == STR))
						begin	
							br_sel <= 0;
						end
	
					if(opcode == SWAP)
						begin
							rf_we <= 0;
							br_sel <= 0;
							alu_op <= 2'b10;
							mux_swap <= 0;
							data_swap <= 1;
							reg_swap <= 1;
							swap_en <= 1;
						end
				end

  	// decode
   	else if(present_state == decode) 
			begin 
				pc_write <= 0;
			
				if(opcode == ALU_OP)
		 			begin
						if(mm == 4'b1000)
							rd_sel <= 1;
						else 
							rd_sel <= 0;
		 			end
				else if(opcode == LOD)
					begin
						rd_sel <= 1;
					end
				else
					begin
						rd_sel <= 0;
					end
			if(opcode == SWAP)
				begin	
					rd_sel <= 2'b10;
					mux_swap <= 1;
					swap_en <= 1;
				end
		end

  	// execute
    else if(present_state == execute) 
			begin
				if(opcode == ALU_OP)
		 			begin
						if(mm == 4'b1000) 
        				alu_op <= 2'b01;
						else 
								alu_op <= 2'b00;	  
					end
		
				if(opcode == BNE)
					begin
						if((mm&stat) == 4'b0000)
							begin
								pc_sel <= 1; 
								br_sel <= 1;
								present_state <= fetch;
							end
						else
							begin
								pc_sel <= 0; 
							end
					end

				if(opcode == BRR)
					begin
						if((mm&stat) != 4'b0000)
							begin
								pc_sel <= 1;
								br_sel <= 0; 
								present_state <= fetch;
							end
						else 
							begin
								pc_sel <= 0; 
							end
					end

				if(opcode == BRA)
					begin
						if((mm&stat) != 4'b0000)
							begin
								pc_sel <= 1;
								br_sel <= 1;
								present_state <= fetch;
							end
						else 
							begin	
								pc_sel <= 0;
							end
						end

				if(((opcode == LOD) || (opcode == STR)) && (mm == 4'b0000))
					begin
						alu_op <= 2'b01;
						mm_sel <= 0;
					end
				else if(((opcode == LOD) || (opcode == STR)) && (mm == 4'b1000))
					begin
						alu_op <= 2'b00;
						mm_sel <= 1;
					end

				if(opcode == SWAP)
					begin
						rf_we <= 1;	
						
						mux_swap <= 0;
						reg_swap <= 1'b1;
						data_swap <= 1'b1;				
					end
			end

  	// mem
    else if(present_state == mem) 
			begin 
				if(opcode == ALU_OP)
					begin
						rf_we <= 1;
					end

				if(opcode == LOD)
					begin
						wb_sel <= 1;
					end

				if(opcode == STR)
					begin
						rf_we <= 0;
						dm_we <= 1;
					end

				if(opcode == SWAP)
					begin
						mux_swap <= 1;
						rf_we <= 0;
					end
			end

  	// writeback
  	else if(present_state == writeback) 
			begin 
				if(opcode == LOD)
					begin
						rf_we <= 1;
					end
				if(opcode == SWAP)
					begin
						rf_we = 1;
					end
			end
  end
  
endmodule
