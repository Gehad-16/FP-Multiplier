
	
module try_mult (floatp_A, floatp_B, sign, exponent,
						exp_unbiased, exp_sum, prod,sum);
	input [31:0] floatp_A, floatp_B;
	output sign;
	output [7:0] exponent, exp_unbiased;
	output [8:0] exp_sum;
	output [22:0] prod;
	output [31:0] sum ;

	reg sign_a, sign_b;
	reg [7:0] exp_a, exp_b;
	reg [7:0] exp_a_bias, exp_b_bias;
	reg [8:0] exp_sum;
	reg [22:0] fract_a, fract_b;
	reg [45:0] prod_dbl;
	reg [22:0] prod;
	reg sign;
	reg [31:0] sum ;
	reg [7:0] exponent, exp_unbiased;
//define sign, exponent, and fraction
			always @ (floatp_A or floatp_B)
		begin
		
	sign_a = floatp_A[31];
	sign_b = floatp_B[31];
	exp_a = floatp_A[30:23];
	exp_b = floatp_B[30:23];
	fract_a = floatp_A[22:0];
	fract_b = floatp_B[22:0];
//bias exponents
	exp_a_bias = exp_a + 8'b0111_1111;
	exp_b_bias = exp_b + 8'b0111_1111;
//add exponents
	exp_sum = exp_a_bias + exp_b_bias;
//remove one bias
	exponent = exp_sum - 8'b0111_1111;
	exp_unbiased = exponent - 8'b0111_1111;
//multiply fractions
//if (flp_a != 0 || flp_b!=0) begin
	prod_dbl = fract_a * fract_b;
	prod = prod_dbl[45:23];


	
	
//postnormalize product
		/*for (int i = 0; i < 22;i = i + 1)	// This will not synthesize!
		begin
			prod = prod << 1;
			exp_unbiased = exp_unbiased - 1;
		end*/	
	sign = sign_a ^ sign_b;
	if (prod ==0) begin 
        sum =32'b0;
end	else sum ={sign, exp_unbiased, prod};
		
end		
		
		//end
	endmodule




module try_mult_test;
reg [31:0]floatp_A,floatp_B;
reg sign;
wire [7:0] exponent, exp_unbiased;
	wire [8:0] exp_sum;
	wire [22:0] prod;
	wire [31:0] sum ;
initial 
begin
  
$monitor("in1 = %b , in2 = %b  ,out1 = %b ,out2 = %b ,out3 = %b ,out4 = %b ,out5 = %b" ,floatp_A, floatp_B, sign, exponent,
						exp_unbiased, exp_sum, prod,sum);
#10
floatp_A[31:0]=32'b0_0000_0011_1010_0000_0000_0000_0000_000;
;
floatp_B[31:0]=32'b0_0000_0010_1100_0000_0000_0000_0000_000;

#10
floatp_A[31:0]=1;
floatp_B[31:0]=1;
#10
floatp_A[31:0]=1;
floatp_B[31:0]=0;
#10
floatp_A[31:0]=0;
floatp_B[31:0]=0;

end

try_mult a(floatp_A, floatp_B, sign, exponent,
						exp_unbiased, exp_sum, prod,sum);
endmodule