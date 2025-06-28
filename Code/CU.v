module cu (input [2:0] opcode,
           input wire EQ_out,
          output reg write_en_reg, ADD, NAND, PASS1, write_mem, EQ, BR);
  
  always @(*) begin
    
    	write_en_reg = 0;
        ADD = 0;
        NAND = 0;
        PASS1 = 0;
        write_mem = 0;
        EQ = 0;
        BR = 0;
    
    case (opcode) 
      3'b000: begin write_en_reg = 1; ADD = 1; end //Add RRR
      3'b001: begin write_en_reg = 1; ADD = 1; end //Add RRI
      3'b010: begin write_en_reg = 1; NAND = 1; end //NAND RRR
      3'b011: begin write_en_reg = 1; PASS1 = 1; end //Load Upper Imm
      3'b100: begin write_en_reg = 1; ADD = 1; end //Load Word RRI
      3'b101: begin write_mem = 1; ADD = 1; end //Store Word RRI
      3'b110: begin EQ = 1; BR = EQ_out; end //Branch if Equal RRI
      3'b111: begin write_en_reg = 1; PASS1 = 1; end //Jump and link reg RRI
      default: begin
        write_en_reg = 0;
        ADD = 0;
        NAND = 0;
        PASS1 = 0;
        write_mem = 0;
        EQ = 0;
        BR = 0;
        
      end
    endcase
  end
  
endmodule