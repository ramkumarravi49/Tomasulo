`include "utils.v"
`include "wallace64.v"

module dfp_multiplier(sa,sb,ea,eb,ma,mb,res,flags);
    input sa,sb;
    input[10:0] ea,eb;
    input[51:0] ma,mb;
    output[63:0] res;
    output[7:0] flags;

    wire[10:0] Esum,Eres;
    wire[63:0] Ma,Mb;
    wire[127:0] Mprod;
    wire[51:0] Mres;
    wire Sres,sft;

    //Check validity of numbers and set flags
    validity check_val(sa,sb,ea,eb,ma,mb,flags);

    //Adding exponents and subtracting bias
    exp_adder exp1(ea,eb,Esum);

    //Determine sign of result
    control get_sign(sa,sb,Sres);

    //Zero extend mantissa
    ext_mantissa get_mantissa(ma,mb,Ma,Mb);

    //Multiply mantissa (using Wallace Tree Multiplier)
    wallace64 mul_mantissa(Ma,Mb,Mprod);

    //Truncate and Normalize Mantissa
    man_round get_round(Mprod,Esum,Mres,Eres);

    assign res = {Sres,Eres,Mres};

endmodule

