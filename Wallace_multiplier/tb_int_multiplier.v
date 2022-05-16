`include "wallace64.v"
// /* Testbench for Modules
module tb_int_multiplier;
    reg[63:0] a,b;
    wire[127:0] res;


    wallace64 dut(a,b,res);


    initial begin
        #0

        a = 64'b0000000000000000000000000000000000000000000000000000000000001000;
        b = 64'b0000000000000000000000000000000000000000000000000000000000001010;
        
        #5 $display("%64b",res[63:0]);
        #5 $finish; 
    end

endmodule
// */