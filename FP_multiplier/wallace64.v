`include "rd_cla.v"

// 1-bit Full Adder
module full_adder(a,b,cin,sum,cout);
    input a,b,cin;
    output sum,cout;
    wire w1,w2,w3;
    
    // S = (A xor B) xor Cin
    xor x1(w1, a, b);
    xor x2(sum, w1, cin);

    // Cout = (A and B) or (Cin and (A xor B))
    and a1(w2, w1, cin);
    and a2(w3, a, b);
    or o1(cout, w2, w3);

endmodule

// Partial Product generator(without shifting)
module partial_product(a,b,pp);
    input [63:0] a;
    input b;
    output [127:0]pp;

    assign pp = (b == 1'b1)? {64'b0,a} : 128'b0;

endmodule

// 128-bit Ripple Carry Adder
module adder64(a,b,sum,cout);
    input[127:0] a,b;
    output[127:0] sum;
    output cout;

    wire[128:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0;i < 128;i = i+1) begin
            full_adder fa(a[i],b[i],carry[i],sum[i],carry[i+1]);
        end
    endgenerate

    assign cout = carry[128];
 
endmodule

// 128-bit carry Save Adder
module carry_save_adder(a,b,c,sum,carry);
    input[127:0] a,b,c;
    output[127:0] sum,carry;

    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i=0; i<127; i=i+1) begin //as 128th bit is 0 inpp (max 64+63=127bits)
            full_adder FA(a[i],b[i],c[i],sum[i],carry[i+1]);
        end
    endgenerate

    assign sum[127] = 1'b0;

endmodule

// 64-bit Wallace Tree Multiplier
module wallace64(a,b,prod);
    input[63:0] a,b;
    output[127:0] prod;

    wire cout1,cout2;
    wire[127:0] pp[63:0],temp_pp[63:0];
    wire[127:0] sum1[20:0],carry1[20:0];
    wire[127:0] sum2[13:0],carry2[13:0];
    wire[127:0] sum3[7:0],carry3[7:0];
    wire[127:0] sum4[5:0],carry4[5:0];
    wire[127:0] sum5[3:0],carry5[3:0];
    wire[127:0] sum6[3:0],carry6[3:0];
    wire[127:0] sum7[2:0],carry7[2:0];
    wire[127:0] sum8[1:0],carry8[1:0];
    wire[127:0] sum9[1:0],carry9[1:0];

    // Generate Partial Products
    genvar i;
    generate
        for(i=0 ; i<64 ; i=i+1) begin
            partial_product get_pp(a,b[i],temp_pp[i]);
            assign pp[i] = temp_pp[i] << i;
        end
    endgenerate
    
    // Level - 1
    carry_save_adder csa1(pp[0],pp[1],pp[2],sum1[0],carry1[0]);
    carry_save_adder csa2(pp[3],pp[4],pp[5],sum1[1],carry1[1]);
    carry_save_adder csa3(pp[6],pp[7],pp[8],sum1[2],carry1[2]);
    carry_save_adder csa4(pp[9],pp[10],pp[11],sum1[3],carry1[3]);
    carry_save_adder csa5(pp[12],pp[13],pp[14],sum1[4],carry1[4]);
    carry_save_adder csa6(pp[15],pp[16],pp[17],sum1[5],carry1[5]);
    carry_save_adder csa7(pp[18],pp[19],pp[20],sum1[6],carry1[6]);
    carry_save_adder csa8(pp[21],pp[22],pp[23],sum1[7],carry1[7]);
    carry_save_adder csa9(pp[24],pp[25],pp[26],sum1[8],carry1[8]);
    carry_save_adder csa10(pp[27],pp[28],pp[29],sum1[9],carry1[9]);
    carry_save_adder csa11(pp[30],pp[31],pp[32],sum1[10],carry1[10]);
    carry_save_adder csa12(pp[33],pp[34],pp[35],sum1[11],carry1[11]);
    carry_save_adder csa13(pp[36],pp[37],pp[38],sum1[12],carry1[12]);
    carry_save_adder csa14(pp[39],pp[40],pp[41],sum1[13],carry1[13]);
    carry_save_adder csa15(pp[42],pp[43],pp[44],sum1[14],carry1[14]);
    carry_save_adder csa16(pp[45],pp[46],pp[47],sum1[15],carry1[15]);
    carry_save_adder csa17(pp[48],pp[49],pp[50],sum1[16],carry1[16]);
    carry_save_adder csa18(pp[51],pp[52],pp[53],sum1[17],carry1[17]);
    carry_save_adder csa19(pp[54],pp[55],pp[56],sum1[18],carry1[18]);
    carry_save_adder csa20(pp[57],pp[58],pp[59],sum1[19],carry1[19]);
    carry_save_adder csa21(pp[60],pp[61],pp[62],sum1[20],carry1[20]);
 
    // Level - 2 (pp[63] left)
    carry_save_adder csa22(sum1[0],sum1[1],sum1[2],sum2[0],carry2[0]);
    carry_save_adder csa23(sum1[3],sum1[4],sum1[5],sum2[1],carry2[1]);
    carry_save_adder csa24(sum1[6],sum1[7],sum1[8],sum2[2],carry2[2]);
    carry_save_adder csa25(sum1[9],sum1[10],sum1[11],sum2[3],carry2[3]);
    carry_save_adder csa26(sum1[12],sum1[13],sum1[14],sum2[4],carry2[4]);
    carry_save_adder csa27(sum1[15],sum1[16],sum1[17],sum2[5],carry2[5]);
    carry_save_adder csa28(sum1[18],sum1[19],sum1[20],sum2[6],carry2[6]);
    carry_save_adder csa29(carry1[0],carry1[1],carry1[2],sum2[7],carry2[7]);
    carry_save_adder csa30(carry1[3],carry1[4],carry1[5],sum2[8],carry2[8]);
    carry_save_adder csa31(carry1[6],carry1[7],carry1[8],sum2[9],carry2[9]);
    carry_save_adder csa32(carry1[9],carry1[10],carry1[11],sum2[10],carry2[10]);
    carry_save_adder csa33(carry1[12],carry1[13],carry1[14],sum2[11],carry2[11]);
    carry_save_adder csa34(carry1[15],carry1[16],carry1[17],sum2[12],carry2[12]);
    carry_save_adder csa35(carry1[18],carry1[19],carry1[20],sum2[13],carry2[13]);
 
    // Level - 3 (pp[63] left) 
    carry_save_adder csa36(sum2[0],sum2[1],sum2[2],sum3[0],carry3[0]);
    carry_save_adder csa38(sum2[3],sum2[4],sum2[5],sum3[1],carry3[1]);
    carry_save_adder csa39(sum2[6],sum2[7],sum2[8],sum3[2],carry3[2]);
    carry_save_adder csa40(sum2[9],sum2[10],sum2[11],sum3[3],carry3[3]);
    carry_save_adder csa41(carry2[0],carry2[1],carry2[2],sum3[4],carry3[4]);
    carry_save_adder csa42(carry2[3],carry2[4],carry2[5],sum3[5],carry3[5]);
    carry_save_adder csa43(carry2[6],carry2[7],carry2[8],sum3[6],carry3[6]);
    carry_save_adder csa44(carry2[9],carry2[10],carry2[11],sum3[7],carry3[7]);
 
    // Level - 4 (pp[63],sum2[12],sum2[13],carry2[12],carry2[13] left)
    carry_save_adder csa45(sum3[0],sum3[1],sum3[2],sum4[0],carry4[0]);
    carry_save_adder csa46(sum3[3],sum3[4],sum3[5],sum4[1],carry4[1]);
    carry_save_adder csa47(sum3[6],sum3[7],pp[63],sum4[2],carry4[2]);
    carry_save_adder csa48(carry3[0],carry3[1],carry3[2],sum4[3],carry4[3]);
    carry_save_adder csa49(carry3[3],carry3[4],carry3[5],sum4[4],carry4[4]);
    carry_save_adder csa50(carry3[6],carry3[7],128'b0,sum4[5],carry4[5]);
 
    // Level - 5 (sum2[12],sum2[13],carry2[12],carry2[13] left)
    carry_save_adder csa51(sum4[0],sum4[1],sum4[2],sum5[0],carry5[0]);
    carry_save_adder csa52(sum4[3],sum4[4],sum4[5],sum5[1],carry5[1]);
    carry_save_adder csa53(carry4[0],carry4[1],carry4[2],sum5[2],carry5[2]);
    carry_save_adder csa54(carry4[3],carry4[4],carry4[5],sum5[3],carry5[3]);
 
    // Level - 6 (sum2[12],sum2[13],carry2[12],carry2[13] left)
    carry_save_adder csa55(sum5[0],sum5[1],sum5[2],sum6[0],carry6[0]);
    carry_save_adder csa56(sum5[3],sum2[12],sum2[13],sum6[1],carry6[1]);
    carry_save_adder csa57(carry5[0],carry5[1],carry5[2],sum6[2],carry6[2]);
    carry_save_adder csa58(carry5[3],carry2[12],carry2[13],sum6[3],carry6[3]);
 
    // Level - 7
    carry_save_adder csa59(sum6[0],sum6[1],sum6[2],sum7[0],carry7[0]);
    carry_save_adder csa60(carry6[0],carry6[1],carry6[2],sum7[1],carry7[1]);

    //  Level - 8 (sum6[3],carry6[3] left)
    carry_save_adder csa61(sum7[0],sum7[1],sum6[3],sum8[0],carry8[0]);
    carry_save_adder csa62(carry7[0],carry7[1],carry6[3],sum8[1],carry8[1]);
 
    //  Level - 9
    carry_save_adder csa63(sum8[0],sum8[1],carry8[0],sum9[0],carry9[0]);
    carry_save_adder csa64(carry8[1],sum9[0],carry9[0],sum9[1],carry9[1]);
 
    //  Level - 10
    rd_cla final_add1(sum9[1][63:0],carry9[1][63:0],1'b0,prod[63:0],cout1);
    rd_cla final_add2(sum9[1][127:64],carry9[1][127:64],cout1,prod[127:64],cout2);


endmodule