`include "int_sub.v"
// /* Testbench for Modules

module tb_int_adder;
    reg[63:0] a,b;
    wire[63:0] res;
    wire bout;

    int_sub dut(a,b,res,bout);

    initial begin
        
        #0
        a = 64'b0000000000000000000000000000000000000000000000000000000000010100;
        b = 64'b0000000000000000000000000000000000000000000000000000000000000100;
        
        #5 $display("%64b",res);
        #5 $finish; 
    end

endmodule

// */