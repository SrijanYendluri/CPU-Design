module instruction_memory (input [15:0] addr,
                           output reg [15:0] instruction);
  
  reg [15:0] memory [0:255];
  
  initial begin
    $readmemb("instructions.mem",memory);
  end
  
  always @(addr) begin
    instruction = memory[addr[7:0]];
  end	
  
endmodule