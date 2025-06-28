module alu (input [15:0] ALU_SRC1,ALU_SRC2,
            input wire ADD, NAND, PASS1, EQ,
            output reg [15:0] ALU_RESULT,
           output reg EQ_out
);
  
  always @(*) begin
    if (ADD) begin
      ALU_RESULT = ALU_SRC1 + ALU_SRC2;
    end
    else if (NAND) begin
      ALU_RESULT = ~(ALU_SRC1 & ALU_SRC2);
    end
    else if (PASS1) begin
      ALU_RESULT = ALU_SRC1;
    end
    else begin
    	ALU_RESULT = 16'b0;
	end
    
    EQ_out = EQ & (ALU_SRC1 == ALU_SRC2);
    
  end
  
endmodule