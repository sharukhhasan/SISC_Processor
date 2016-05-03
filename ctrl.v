// ECE:3350 SISC computer project
// finite state machine

`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rf_we, alu_op, wb_sel, rd_sel, br_sel, pc_rst, pc_write, pc_sel, 
						mm_sel, dm_we, ir_load, rs_en, rsort_sel, data_sel);
  
 	input clk, rst_f;
	input [3:0] stat, opcode, mm;
	output reg rf_we, wb_sel, rd_sel, mm_sel, dm_we, ir_load;
	//part 2 output
	output reg br_sel, pc_rst, pc_write, pc_sel;
	output reg [1:0] alu_op;
	output reg data_sel, rsort_sel, rs_en;
	
  
  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter NOOP = 0, LOD = 1, STR = 2, ALU_OP = 8, BRA = 4, BRR = 5, BNE = 6, HLT = 15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state, format;
  reg [1:0]  alu_sel;
  reg [1:0]  swap;
  
  
  initial
  begin
    pc_rst = 1;
  end
  always @(posedge clk)
  begin
    if (rst_f == 0) begin
      present_state <= start0;
    end
    else
      present_state <= next_state;
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



  always @(present_state)
  begin
	$display("format is ", format);
    case(present_state)

			start1: begin
		  	pc_rst = 0;
		    swap = 0;
		    rs_en = 0;
		    ir_load = 0;
		  end
		
		//Fetch
			fetch: begin
				$display("in fetch");
		  	rf_we = 1'b0;
				pc_write = 1;
				if(swap == 1)
					begin
				 		rf_we = 1'b0;
				 		pc_write = 0;
				   end
				end
		
		//decode
			decode: begin 
					$display("in decode");
				data_sel = 1;
				rf_we = 1'b0;
				pc_write = 0;
				if(opcode == 3 && swap == 0)
					begin
				  	swap = 1;
				  end
				else if(opcode == 3 && swap ==1)
				  begin
				    swap = 2;
				  end
				  
				if((opcode == ALU_OP) && (mm == 0))
					begin
						format = 1;
				  end
				else if(((opcode == ALU_OP) && (mm == 8)) || (opcode == LOD) || (opcode == STR))
				  begin
						format  = 2;
						rd_sel = 1;
				  end
				else if((opcode == NOOP) || (opcode == BRA) || (opcode == BRR) || (opcode == BNE))
				  begin
						format = 3;
				  end
				end

		//execute
		execute: begin
				$display("in execute");
			pc_write = 0;
			br_sel = (opcode == BRR)? 1'b0 : 1'b1;
			
			//swap operation
			if(swap == 1)
				begin
			  	rs_en = 1;
				ir_load = 1;
			  	rsort_sel = 0;
			  	data_sel = 0;	
			  	rd_sel = 0;
				end
			else if(swap == 2)
			begin
			  rsort_sel = 1;
			  data_sel = 0;
			  rd_sel = 1;
			end	
			
			// type format 1;
			if((format == 1) && (opcode == ALU_OP) && (mm == 0)) 
			begin 
			  wb_sel = 1'b0;
			  alu_op = 2'b00;
			  rd_sel = 1'b0;
			  pc_sel = 0;
			end
			
			//format 2;
			else if((format == 2) && (opcode == ALU_OP) && (mm == 8))
			  begin
			  	wb_sel = 1'b0;
			  	alu_op = 2'b01;
			  	rd_sel = 1'b1;
			  	pc_sel = 0;
			end
			else if((opcode == LOD) && (mm == 8))
			  begin
			  	wb_sel = 1'b1;
			  	alu_op = 2'b10;
			  	rd_sel = 1'b1;
			  	pc_sel = 0;
			  	mm_sel = 1;
			  	dm_we = 0;
			end
			else if((opcode == LOD) && (mm == 0))
			  begin
			  	wb_sel = 1'b1;
			  	alu_op = 2'b01;
			  	rd_sel = 1'b1;
			  	pc_sel = 0;
			  	mm_sel = 0;
			  	dm_we = 0;
			end
			else if((opcode == STR) && (mm == 8))
			  begin
			  	wb_sel = 1'b0;
			  	alu_op = 2'b10;
			  	rd_sel = 1'b1;
			  	pc_sel = 0;
			  	mm_sel = 1;
			  	dm_we = 0;
			end
			else if((opcode == STR) && (mm == 0))
			  begin
			  	wb_sel = 1'b0;
			  	alu_op = 2'b01;
			  	rd_sel = 1'b1;
			  	pc_sel = 0;
			  	mm_sel = 0;
			  	dm_we = 0;
			 end
			 
			//format 3
			else if( (format == 3))
				begin
			  	if((opcode == BRA) && ((mm[0] == 1 && stat[0] == 1) || (mm[1] == 1 && stat[1] == 1) || (mm[2] == 1 && stat[2] == 1) || (mm[3] == 1 && stat[3] == 1))) 
			  		begin
			    		pc_sel = 1'b1;
			    		wb_sel = 1'b0;
			    		alu_op = 2'b01;
			    		rd_sel = 1'b1;
			    		br_sel = 1'b1;
			  		end
			  	else if((opcode == BRR) && ((mm[0] == 1 && stat[0] == 1) || (mm[1] == 1 && stat[1] == 1) || (mm[2] == 1 && stat[2] == 1) || (mm[3] == 1 && stat[3] == 1))) 
			  		begin
			    		pc_sel = 1'b1;
			    		wb_sel = 1'b0;
			    		alu_op = 2'b01;
			    		rd_sel = 1'b1;
			    		br_sel = 1'b0;
			  		end
			  	else if(((opcode == BRA) || (opcode == BRR) || (opcode == BNE)) && (mm == 0))
			  		begin
			    		pc_sel = 1'b1;
			    		br_sel = 1'b1;
			    		rd_sel = 1'b1;
			    		alu_op = 2'b01;
			    		wb_sel = 1'b0;
			  		end
			  	else if(opcode == BNE)
			  		begin
			    		pc_sel = 1'b1;
			    		wb_sel = 1'b0;
			    		rd_sel = 1'b1;
			    		alu_op = 2'b01;
			    		br_sel = 1'b1;
			   
			    		if((mm[0] == 1 && stat[0] == 1) || (mm[1] == 1 && stat[1] == 1) || (mm[2] == 1 && stat[2] == 1) || (mm[3] == 1 && stat[3] == 1))
			    			begin
			      			pc_sel = 1'b0;
			    			end
			  		end
			  else
			  	begin
			      pc_sel = 0;
			  	end
			  end
			end
		
		//mem
		mem: begin
				$display("in mem");
			if(opcode == STR)
				begin
			  	wb_sel = 1'b1;
				//ir_load = 1'b1;
			  end
			else if(opcode == LOD)
				begin
			  	rd_sel = 1;
			   	wb_sel = 1'b1;
				//ir_load = 1'b1;
			 	end
		end
      
    //writeback
		writeback: begin
				$display("in writeback");
			pc_write = 1'b0;
			rs_en = 0;
			ir_load = 1;
			  
			if(swap == 1)
				begin
			  	rf_we = 1;
			  end
			else if(swap == 2)
			  begin	
			    rf_we = 1;
			    swap = 0;
			  end
		 	else if((opcode == ALU_OP) && (mm == 0)) 
		 		begin
					rd_sel = 1'b0;
				  rf_we = 1'b1;
				  wb_sel = 1'b0;
			  end
			else if((format == 2) && (opcode == LOD || opcode == ALU_OP))
				begin
					rd_sel = 1'b1; 
				  rf_we = 1'b1;
			  end
			else if(opcode == LOD)
				begin
					rf_we = 1;
				  dm_we = 0;
			  end
			else if(opcode == STR)
			  begin
				  dm_we = 1;
			 	end
			end

    endcase
  end
endmodule
