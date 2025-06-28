module program_counter (input clk, reset,
           input [15:0] pc_next,
           output reg [15:0] pc);
  
  always @(posedge clk or posedge reset) begin
    if (reset)
      pc <= 16'b0;
    else
      pc <= pc_next;
  end
  
endmodule