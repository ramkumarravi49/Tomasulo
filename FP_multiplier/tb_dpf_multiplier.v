`include "dfp_multiplier.v"
// /*
module tb_dfp_multipler;
    reg[63:0] a,b;
    wire[63:0] res;
    wire[7:0] flags;

    dfp_multiplier dut(a[63],b[63],a[62:52],b[62:52],a[51:0],b[51:0],res,flags);

    initial begin

        #0

        a = 64'b0_10000000101_1111010010000000000000000000000000000000000000000000;
        b = 64'b0_10000000010_1000001000000000000000000000000000000000000000000000;
        
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
