module processor_tb;
    reg clk, reset;
  wire [15:0] debug_pc, debug_instruction, debug_reg1, debug_reg2, debug_ALUResult, debug_mem_data, debug_alu_src2, debug_alu_src1, debug_rf_src1, debug_rf_src2, debug_add, debug_rf_data1, debug_rf_data2;

    processor uut (
        .clk(clk), 
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_reg1(debug_reg1),
      .debug_ALUResult(debug_ALUResult),
      .debug_add(debug_add),
      .debug_alu_src1(debug_alu_src1),
      .debug_alu_src2(debug_alu_src2),
      .debug_rf_src2(debug_rf_src2),
      .debug_rf_src1(debug_rf_src1),
      .debug_rf_data1(debug_rf_data1),
      .debug_rf_data2(debug_rf_data2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $dumpfile("dump.vcd");   
        $dumpvars(0, processor_tb); 

        reset = 1;
        #10 reset = 0;
        
        #100 $finish; 
    end

    initial begin
      $monitor("Time=%0t | PC=%b | Instr=%b | R1=%b | ALU=%b", 
                 $time, debug_pc, debug_instruction, debug_reg1, debug_ALUResult);
    end
endmodule 
