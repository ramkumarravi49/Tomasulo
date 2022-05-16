`include "dpf_adder.v"
// /*
module tb_dfp_sub();
    reg[63:0] a,b;
    wire[63:0] res;
    wire[7:0] flags;

    dfp_sub dut(a[63],~b[63],a[62:52],b[62:52],a[51:0],b[51:0],res,flags);

    initial begin

        #0

        a = 64'b0_10000000010_0011100000000000000000000000000000000000000000000000;
        b = 64'b0_01111111110_0010000000000000000000000000000000000000000000000000;
        
        #5 print_output();
        #5 $finish; 
    end

    task print_output;
        begin
            $display("%64b",res);
        end
    endtask

endmodule
// */
