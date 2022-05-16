`include "rd_cla.v"
// /* Testbench for Modules

module tb_int_adder;
    reg[63:0] a,b;
    reg cin;
    wire[63:0] res;
    wire cout;

    rd_cla dut(a,b,1'b0,res,cout);

    initial begin
        #0
        a = 64'b0000000000000000000000000000000000000000000000000000000000001001;
        b = 64'b0000000000000000000000000000000000000000000000000000000000000101;
        #5 $display("%64b",res);
        #5 $finish; 
    end

endmodule

// */