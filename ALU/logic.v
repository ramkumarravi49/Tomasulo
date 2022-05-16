module mux_8x1(inpx,sel,res);
    input[511:0] inpx;
    input[2:0] sel;
    output[63:0] res;
    
    wire[63:0] inp[7:0],temp[7:0];

    assign {inp[7],inp[6],inp[5],inp[4],inp[3],inp[2],inp[1],inp[0]} = inpx;

    assign temp[0] = {64{(~sel[2] & ~sel[1] & ~sel[0])}} & inp[0];
    assign temp[1] = {64{(~sel[2] & ~sel[1] & sel[0])}} & inp[1];
    assign temp[2] = {64{(~sel[2] & sel[1] & ~sel[0])}} & inp[2];
    assign temp[3] = {64{(~sel[2] & sel[1] & sel[0])}} & inp[3];
    assign temp[4] = {64{(sel[2] & ~sel[1] & ~sel[0])}} & inp[4];
    assign temp[5] = {64{(sel[2] & ~sel[1] & sel[0])}} & inp[5];
    assign temp[6] = {64{(sel[2] & sel[1] & ~sel[0])}} & inp[6];
    assign temp[7] = {64{(sel[2] & sel[1] & sel[0])}} & inp[7];

    assign res = temp[7] | temp[6] | temp[5] | temp[4] | temp[3] | temp[2] | temp[1] | temp[0];

endmodule

module comp2(inp,res);
    input[63:0] inp;
    output[63:0] res;

    genvar i;
    assign res[0] = inp[0];
    generate
        for(i=1;i<64;i=i+1)
            assign res[i] = (|inp[i-1:0])? ~inp[i] : inp[i];
    
    endgenerate

endmodule

module logic_unit(a,b,opcode,res);
    input[63:0] a,b;
    input[2:0] opcode;
    output[63:0] res;

    wire[63:0] temp[7:0];
    
    assign temp[0] = a & b;
    assign temp[1] = a ^ b;
    assign temp[2] = ~(a & b);
    assign temp[3] = a | b;
    assign temp[4] = ~a;
    assign temp[5] = ~(a | b);
    assign temp[6] = ~a + 1;
    assign temp[7] = ~(a ^ b);

    mux_8x1 mux({temp[7],temp[6],temp[5],temp[4],temp[3],temp[2],temp[1],temp[0]},opcode,res);

endmodule
