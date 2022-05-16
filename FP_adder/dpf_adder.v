`include "utils.v"
module dfp_adder(sa,sb,ea,eb,ma,mb,res,flags);
    input sa,sb;
    input[10:0] ea,eb;
    input[51:0] ma,mb;
    output[63:0] res;
    output[7:0] flags;

    wire[10:0] n,zeroes,Esum,Eres;
    wire[52:0] Ma,Mb,sMb;
    wire[53:0] Msum;
    wire[51:0] Mres;
    wire sres,swap_flag,carry,k;

    //Check validity of numbers and set flags
    validity check_val(sa,sb,ea,eb,ma,mb,flags);

    //Get absolute difference value of exponents
    sub11_abs getn(ea,eb,n,swap_flag);

    //Set A as bigger number
    swapper mswap(ma,mb,swap_flag,Ma,Mb);

    //Shift Mantissa of B(smaller number) to right
    shifter mshift(Mb,n,sMb);

    //Determine sign of output and Adder-Subtractor choice
    control ccn(sa,sb,swap_flag,sres,k);

    //Perform addition or subtraction based on choice
    add_sub52 madd(Ma,sMb,k,Msum,carry);

    //Determine exponent value of result
    exp_sel exp_res(ea,eb,swap_flag,Esum);

    //Find number of leading zeroes and shift amount
    n_zeroes findn(Msum,zeroes);

    //Normalize result mantissa and update result exponent
    normalize mnorm(Msum,zeroes,Esum,Mres,Eres);

    assign res = {sres,Eres,Mres};

endmodule
