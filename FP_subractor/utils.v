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

// 53-bit Mantissa Adder-Subtractor
module add_sub52(a,b,k,sum,cout);
    input[52:0] a,b;
    input k;
    output[53:0] sum;
    output cout;

    wire[52:0] carry;

    full_adder fa0(a[0],(b[0]^k),k,sum[0],carry[0]);

    genvar i;
    generate
        for (i = 1;i < 53;i = i+1) begin
            full_adder fa(a[i],(b[i]^k),carry[i-1],sum[i],carry[i]);
        end
    endgenerate

    //If subtraction carry(1) => +ve (so don't concatenate to mantissa)
    assign cout = k ? 1'b0 : carry[52];
    assign sum[53] = cout;
 
endmodule

// 11-bit Exponent Subtractor (Absolute value)
module sub11_abs(a,b,diff,bout);
    input[10:0] a,b;
    output[10:0] diff;
    output bout;
    wire[11:0] borrow;

    wire[10:0] ain,bin;

    //Ckeck and pass such that ain > bin
    assign ain = (b>a) ? b : a ;
    assign bin = (b>a) ? ~a + 1 : ~b + 1 ;
    assign bout = (b>a) ? 1'b1 : 1'b0 ;
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0;i < 11;i = i+1) begin
            full_adder fa(ain[i],bin[i],borrow[i],diff[i],borrow[i+1]);
        end
    endgenerate
 
endmodule

// 52-bit Mantissa Swapper (Ouput is 53 bits)
module swapper(a,b,sel,Ma,Mb);
    input[51:0] a,b;
    input sel;
    output[52:0] Ma,Mb;

    //Concatenate implicit bit
    assign Ma = sel ? {1'b1,b} : {1'b1,a} ;
    assign Mb = sel ? {1'b1,a} : {1'b1,b} ;

endmodule

// N-bit(11 bits) Mantissa Shifter
module shifter(inp,n,out);
    input[52:0] inp;
    input[10:0] n;
    output[52:0] out;

    assign out = inp >> n;

endmodule

// Exponent Selector
module exp_sel(ea,eb,sel,exp);
    input[10:0] ea,eb;
    input sel;
    output[10:0] exp;

    //Select greater exponent value
    assign exp = sel ? eb : ea ;

endmodule

//Leading zeroes detector
module n_zeroes(M,n);
    input[53:0] M;
    output[10:0] n;

    wire[63:0] temp;
    wire[31:0] temp32;
    wire[15:0] temp16;
    wire[7:0] temp8;
    wire[3:0] temp4;
    wire[5:0] res;

    assign temp = {10'b0,M};

    //Divide and Conquer type method to find number of leading zeroes
    assign res[5] = (temp[63:32] == 32'b0) ;
    assign temp32 = res[5] ? temp[31:0] : temp[63:32];

    assign res[4] = (temp32[31:16] == 16'b0) ;
    assign temp16 = res[4] ? temp32[15:0] : temp32[31:16];

    assign res[3] = (temp16[15:8] == 8'b0) ;
    assign temp8 = res[3] ? temp16[7:0] : temp16[15:8];

    assign res[2] = (temp8[7:4] == 4'b0) ;
    assign temp4 = res[2] ? temp8[3:0] : temp8[7:4];

    assign res[1] = (temp4[3:2] == 2'b0) ;
    assign res[0] = res[1] ? ~temp4[1] : ~temp4[3];

    assign n = res - 10; //Adjust added 0s

endmodule

//Normalization
module normalize(M,sft,Esum,Mres,Eres);
    input[53:0] M;
    input[10:0] sft,Esum;
    output[51:0] Mres;
    output[10:0] Eres;

    wire[53:0] temp;
    
    assign temp = M << (sft-1);

    //n = 0 => 2 digits on left of decimal
    assign Mres = sft ? temp[51:0] : M[52:1];
    assign Eres = sft ? Esum - sft + 1 : Esum + 1;

endmodule

//Control Module
module control(sa,sb,sel,sres,k);
    input sa,sb,sel;
    output sres,k;

    //Select sign of number with bigger exponent
    assign sres = sel ? sb : sa ;
    assign k = sa ^ sb ;

endmodule

//Exceptions
module validity(sa,sb,ea,eb,ma,mb,flags);
    input sa,sb;
    input[10:0] ea,eb;
    input[51:0] ma,mb;
    output[7:0] flags;

    wire NaNA,InfA,ZeroA,DeNormA;
    wire NaNB,InfB,ZeroB,DeNormB;

    //Not a Number
    assign NaNA = (ea == 2047 && ma != 0);
    assign NaNB = (eb == 2047 && mb != 0);

    //Infinity
    assign InfA = (ea == 2047 && ma == 0);
    assign InfB = (eb == 2047 && mb == 0);

    //Zero
    assign ZeroA = (ea == 0 && ma == 0);
    assign ZeroB = (eb == 0 && mb == 0);

    //Denormal Number
    assign DeNormA = (ea == 0 && ma != 0);
    assign DeNormB = (eb == 0 && mb != 0);

    assign flags = {NaNA,InfA,ZeroA,DeNormA,NaNB,InfB,ZeroB,DeNormB};


endmodule

/* Testbench for Modules

module tb_modules;
    reg[53:0] a,b;
    reg[10:0] sft,esum;
    reg k;
    wire[10:0] res,res1;
    wire[51:0] mres;
    wire out;

    normalize dut(a,sft,esum,mres,res);

    initial begin
        // #0  a=35;b=44;k=0;
        #0 a=54'b000100001010000000000000000000000000000000000000000000;
        sft=3;esum=11'b10000000010;
        #5 $display("msre = %52b ;\nres = %0b ;",mres,res);
		// #5  k=1;
        // #5 $display("a = %0d ; b = %0d ; k = %b ; sum = %0d ; cout = %b;",a,b,k,res,cout);
        #5 $finish; 
    end

endmodule

*/