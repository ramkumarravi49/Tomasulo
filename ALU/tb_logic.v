`include "logic.v"
// /* Testbench for Modules
module tb_logic;
    reg[63:0] a,b;
    reg[2:0] opcode;
    wire[63:0] res;

    logic_unit dut(a,b,opcode,res);


    initial begin
        
        #0
        a = 64'b0000000000000000000000000000000000000000000000000000000000000100;
        b = 64'b0000000000000000000000000000000000000000000000000000000000010000;
        opcode = 3'b011;

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