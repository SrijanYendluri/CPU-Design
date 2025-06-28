module register_file (input clk,
                      input [2:0] TGT, REG_SRC1, REG_SRC2,
                      input [15:0] RF_write_data,
                      input write_en_reg,
                      output reg [15:0] REG_DATA1,
                      output reg [15:0] REG_DATA2);
  
  reg [15:0] registers [0:15];
  
  always @(posedge clk) begin
    if(write_en_reg) begin
      registers[TGT] <= RF_write_data;
    end
  end
  
  always @(*) begin
    REG_DATA1 = registers[REG_SRC1];
    REG_DATA2 = registers[REG_SRC2];
  end
  
endmodule