//XOR - Addition
module fast_add(a,b,sum);
    input a,b;
    output sum;

    xor(sum,a,b);

endmodule

//CLA - Operation (*)
module find_nxt(ci_1,ci,res);
    input[1:0] ci_1,ci;
    output[1:0] res;

    assign res = (ci_1 == 2'b00 || ci_1 == 2'b11)? ci_1 : ci ;

endmodule

//Finding final carry array
module gen_carry(kgp,carry);
    input[1:0] kgp;
    output carry;

    assign carry = &kgp;

endmodule

//64-bit Recursive Doubling based Carry Look-Ahead Adder
module rd_cla(a,b,cin,sum,cout);
    input[63:0] a,b;
    input cin;
    output[63:0] sum;
    output cout;

    wire[63:0] fa_sum,carry,res_carry;
    wire[127:0] kgp0,kgp1,kgp2,kgp3,kgp4,kgp5,kgp6,kgp;
    wire[1:0] stable;

    parameter k = 2'b00, g = 2'b11;
    assign stable = cin ? g : k ;

    genvar i,j;

    // Level - 0 (XOR-Sum and Initial kgp)
    generate
        for (i = 0;i < 64;i = i+1) begin
            fast_add fa(a[i],b[i],fa_sum[i]);
            assign kgp0[2*i +: 2] = {a[i],b[i]};
        end
    endgenerate

    // Level - 1
    generate
        for (j = 127;j > 2;j = j-2) begin
            find_nxt prefix(kgp0[j -: 2],kgp0[j-2 -: 2],kgp1[j -: 2]);
        end

        for (i = 1;i > 0;i = i-2) begin
            find_nxt prefix1(kgp0[i -: 2],stable,kgp1[i -: 2]);
        end
    endgenerate
    // find_nxt prefix_l11(kgp0[1:0],stable,kgp1[1:0]);

    // Level - 2
    generate
        for (j = 127;j > 4;j = j-2) begin
            find_nxt prefix(kgp1[j -: 2],kgp1[j-4 -: 2],kgp2[j -: 2]);
        end

        for (i = 3;i > 0;i = i-2) begin
            find_nxt prefix1(kgp1[i -: 2],stable,kgp2[i -: 2]);
        end
    endgenerate
    // find_nxt prefix_l21(kgp1[3:2],stable,kgp2[3:2]);
    // find_nxt prefix_l22(kgp1[1:0],stable,kgp2[1:0]);

    // Level - 3
    generate
        for (j = 127;j > 8;j = j-2) begin
            find_nxt prefix(kgp2[j -: 2],kgp2[j-8 -: 2],kgp3[j -: 2]);
        end
        for (i = 7;i > 0;i = i-2) begin
            find_nxt prefix1(kgp2[i -: 2],stable,kgp3[i -: 2]);
        end
    endgenerate
    // find_nxt prefix_l31(kgp2[7:6],stable,kgp3[7:6]);
    // find_nxt prefix_l32(kgp2[5:4],stable,kgp3[5:4]);
    // find_nxt prefix_l33(kgp2[3:2],stable,kgp3[3:2]);
    // find_nxt prefix_l34(kgp2[1:0],stable,kgp3[1:0]);

    // Level - 4
    generate
        for (j = 127;j > 16;j = j-2) begin
            find_nxt prefix(kgp3[j -: 2],kgp3[j-16 -: 2],kgp4[j -: 2]);
        end
        for (i = 15;i > 0;i = i-2) begin
            find_nxt prefix1(kgp3[i -: 2],stable,kgp4[i -: 2]);
        end
    endgenerate

    // Level - 5
    generate
        for (j = 127;j > 32;j = j-2) begin
            find_nxt prefix(kgp4[j -: 2],kgp4[j-32 -: 2],kgp5[j -: 2]);
        end
        for (i = 31;i > 0;i = i-2) begin
            find_nxt prefix1(kgp4[i -: 2],stable,kgp5[i -: 2]);
        end
    endgenerate

    // Level - 6
    generate
        for (j = 127;j > 64;j = j-2) begin
            find_nxt prefix(kgp5[j -: 2],kgp5[j-64 -: 2],kgp6[j -: 2]);
        end
        for (i = 63;i > 0;i = i-2) begin
            find_nxt prefix1(kgp5[i -: 2],stable,kgp6[i -: 2]);
        end
    endgenerate

    // Final carry (with stable state)
    generate
        for (i = 127;i > 0;i = i-2) begin
            find_nxt prefix1(kgp6[i -: 2],stable,kgp[i -: 2]);
        end
    endgenerate

    // Find carry to add to sum
    generate
        for (i = 0;i < 64;i = i+1) begin
            gen_carry get_carry(kgp[2*i +: 2],carry[i]);
        end
    endgenerate

    assign cout = carry[63];
    assign res_carry = {carry[62:0],cin};

    // Adding carry and sum
    generate
        for (i = 0;i < 64;i = i+1) begin
            fast_add fa(fa_sum[i],res_carry[i],sum[i]);
        end
    endgenerate

endmodule