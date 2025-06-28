`include "IM.v"
`include "RF.v"
`include "PC.v"
`include "ALU.v"
`include "CU.v"
`include "DM.v"

module processor (input clk, reset,
                  output reg [15:0] debug_instruction, debug_ALUResult, debug_pc, debug_reg1, debug_add, debug_alu_src1, debug_alu_src2, debug_rf_src1, debug_rf_src2, debug_rf_data1, debug_rf_data2);
  
  wire [15:0] instruction;
  wire [2:0] opcode;
  reg write_reg, write_data_mem, add, alu_nand, pass1, br, eq, EQ_out_ALU,EQ_out_CU;
  // wire mux_RF_SRC2, mux_RF_TGT, mux_ALU_SRC1, mux_ALU_SRC2;
  reg [2:0] RF_TGT, RF_SRC1, RF_SRC2;
  reg [15:0] RF_DATA1, RF_DATA2, RF_write_DATA;
  reg [15:0] ALU_SRC1, ALU_SRC2, ALU_RESULT;
  reg [15:0] pc, pc_next;
  reg [15:0] ADDR, DATA_IN, DATA_OUT;
  reg [2:0] rA;
  
  assign opcode = instruction[15:13];
  assign rA = instruction[12:10];
  
  always @(*) begin
        RF_TGT = 3'd0;
        RF_SRC1 = 3'd0;
        RF_SRC2 = 3'd0;
        ALU_SRC1 = 3'd0;
        ALU_SRC2 = 16'd0;
        RF_write_DATA = 16'd0;
        DATA_IN = 16'd0;
        ADDR = 16'd0;
        pc_next = pc + 1;
        EQ_out_CU = 0;
    case (opcode)
      3'b000: begin 
        RF_TGT = rA;
        RF_SRC1 = instruction[9:7];
        RF_SRC2 = instruction[2:0];
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = RF_DATA2;
        RF_write_DATA = ALU_RESULT;
      end
      3'b001: begin
        RF_TGT = rA;
        RF_SRC1 = instruction[9:7];
        RF_SRC2 = instruction[2:0];
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = {{9{instruction[6]}}, instruction[6:0]};
        RF_write_DATA = ALU_RESULT;
      end
      3'b010: begin
        RF_TGT = rA;
        RF_SRC1 = instruction[9:7];
        RF_SRC2 = instruction[2:0];
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = RF_DATA2;
        RF_write_DATA = ALU_RESULT;
      end
      3'b011: begin
        RF_TGT = rA;
        ALU_SRC1 = {6'b0, instruction[9:0]};;
        RF_write_DATA = ALU_RESULT;
      end
      3'b100: begin
        RF_TGT = rA;
        RF_SRC1 = instruction[9:7];
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = {{9{instruction[6]}}, instruction[6:0]};
        ADDR = ALU_RESULT;
        RF_write_DATA = DATA_OUT;
      end
      3'b101: begin
        RF_SRC1 = instruction[9:7];
        RF_SRC2 = rA;
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = {{9{instruction[6]}}, instruction[6:0]};
        ADDR = ALU_RESULT;
        DATA_IN = RF_DATA2;
        RF_write_DATA = DATA_OUT;
      end
      3'b110: begin
        RF_SRC1 = instruction[9:7];
        RF_SRC2 = rA;
        ALU_SRC1 = RF_DATA1;
        ALU_SRC2 = RF_DATA2;
        EQ_out_CU = EQ_out_ALU;
        if (EQ_out_CU == 1) begin
          pc_next = pc + 1 + {{9{instruction[6]}}, instruction[6:0]};
        end
        else
          pc_next = pc + 1;
      end
      3'b111: begin
        RF_TGT = rA;
        RF_SRC1 = instruction[9:7];
        ALU_SRC1 = RF_DATA1;
        RF_write_DATA = pc + 1;
        pc_next = ALU_RESULT;
      end
    endcase
    
    debug_instruction = instruction;
  
    debug_ALUResult = ALU_RESULT;
  
  	debug_pc = pc;
  
  	debug_reg1 = rA;
    
    debug_add = add;
    
    debug_alu_src1 = ALU_SRC1;
    
    debug_alu_src2 = ALU_SRC2;
    
    debug_rf_src1 = RF_SRC1;
    
    debug_rf_src2 = RF_SRC2;
    
    debug_rf_data1 = RF_DATA1;
    
    debug_rf_data2 = RF_DATA2;
    
  end
  
  instruction_memory IM (.addr(pc), .instruction(instruction));
  
  register_file RF (.clk(clk), 
                    .TGT(RF_TGT),
                    .REG_SRC1(RF_SRC1),
                    .REG_SRC2(RF_SRC2),
                    .RF_write_data(RF_write_DATA),
                    .write_en_reg(write_reg),
                    .REG_DATA1(RF_DATA1),
                    .REG_DATA2(RF_DATA2));
  
  alu ALU (.ALU_SRC1(ALU_SRC1),
           .ALU_SRC2(ALU_SRC2),
           .ADD(add),
           .NAND(alu_nand),
           .PASS1(pass1),
           .EQ(eq),
           .EQ_out(EQ_out_ALU),
           .ALU_RESULT(ALU_RESULT));
  
  cu CU (.opcode(opcode),
         .write_en_reg(write_reg),
         .ADD(add), 
         .NAND(alu_nand),
         .PASS1(pass1),
         .write_mem(write_data_mem),
         .EQ(eq),
         .BR(br),
         .EQ_out(EQ_out_CU));
  
  program_counter PC (.clk(clk), .reset(reset), .pc_next(pc_next), .pc(pc));
  
  data_memory DM (.clk(clk),
                  .write_mem(write_data_mem),
                  .ADDR(ADDR),
                  .DATA_IN(DATA_IN),
                  .DATA_OUT(DATA_OUT));
  
endmodule