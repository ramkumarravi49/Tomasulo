// 1-bit Full Adder
module full_adder_utils(a,b,cin,sum,cout);
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

// 11-bit Exponent Adder
module exp_adder(a,b,res);
    input[10:0] a,b;
    output[10:0] res;

    wire[11:0] carry,borrow;
    assign carry[0] = 1'b0;

    wire[10:0] sum,bias;
    assign bias = 1023;
    assign borrow[0] = 1'b1;

    genvar i,j;

    // Adding exponents
    generate
        for (i = 0;i < 11;i = i+1) begin
            full_adder_utils fa(a[i],b[i],carry[i],sum[i],carry[i+1]);
        end
    endgenerate

    // Subtracting bias
    generate
        for (j = 0;j < 11;j = j+1) begin
            full_adder_utils fa(sum[j],(bias[j]^1'b1),borrow[j],res[j],borrow[j+1]);
        end
    endgenerate

 
endmodule

// 64-bit Mantissa Extender
module ext_mantissa(a,b,Ma,Mb);
    input[51:0] a,b;
    output[63:0] Ma,Mb;

    //Zero extend mantissa for multiplication
    assign Ma = {11'b0,1'b1,a};
    assign Mb = {11'b0,1'b1,b};

endmodule

// Truncate and Normalize mantissa
module man_round(man,esum,mres,eres);
    input[127:0] man;
    input[10:0] esum;

    output[51:0] mres;
    output[10:0] eres;

    assign mres = man[105] ? man[104 -: 52] : man[103 -: 52];
    assign eres = esum + man[105];

endmodule

//Control Module
module control(sa,sb,sres);
    input sa,sb;
    output sres;

    // Determine sign of result
    assign sres = sa ^ sb ;

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