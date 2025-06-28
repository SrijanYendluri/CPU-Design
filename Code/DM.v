module data_memory (input clk,
                    input write_mem,
                    input [15:0] ADDR, DATA_IN,
                    output reg [15:0] DATA_OUT);
  
  reg [15:0] memory [0:255];
  
  always @(posedge clk) begin
    if (write_mem)
      memory[ADDR] <= DATA_IN;
  end
  
  always @(*) begin
    DATA_OUT = memory[ADDR];
  end
  
endmodule