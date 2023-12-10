package FPAdder64;

typedef Bit#(64) Word;
typedef Bit#(53) Mantissa53;
typedef Bit#(52) Mantissa52;
typedef Bit#(11) Exponent11;
typedef Bit#(54) Sum54;
typedef Bit#(1) SignBit;

interface FPAdder64_ifc;
    method Action put_A(Bit#(64) a_in);
    method Action put_B(Bit#(64) b_in);
    method ActionValue#(Bit#(64)) get_res();
endinterface: FPAdder64_ifc

(* synthesize *)
module mkFPAdder64 (FPAdder64_ifc);
    Reg#(Word) input_1_64 <- mkReg(0);
    Reg#(Word) input_2_64 <- mkReg(0);
    Reg#(Word) final_sum_64 <- mkReg(0);
    Reg#(SignBit) sign_1_64 <- mkReg(0);
    Reg#(SignBit) sign_2_64 <- mkReg(0);
    Reg#(SignBit) sign_64 <- mkReg(0);
    Reg#(SignBit) sign1_2 <- mkReg(0);
    Reg#(SignBit) sign1_1 <- mkReg(0);
    Reg#(SignBit) sign2_1 <- mkReg(0);
    Reg#(SignBit) sign2_2 <- mkReg(0);
    Reg#(SignBit) sign_64_2 <- mkReg(0);
    Reg#(SignBit) sign_64_3 <- mkReg(0);
    Reg#(SignBit) sign_64_4 <- mkReg(0);
    
    Reg#(Exponent11) exponent_1_64 <- mkReg(0);
    Reg#(Exponent11) exponent_2_64 <- mkReg(0);
    Reg#(Exponent11) exponent_max_64 <- mkReg(0);
    Reg#(Exponent11) exponent1 <- mkReg(0);
    Reg#(Exponent11) exponent2 <- mkReg(0);
    Reg#(Exponent11) exponent3 <- mkReg(0);
    Reg#(Exponent11) exponent4 <- mkReg(0);

    Reg#(Mantissa52) mantissa_1_64 <- mkReg(0);
    Reg#(Mantissa52) mantissa_2_64 <- mkReg(0);

    Reg#(Mantissa53) mantissa_1_53_64 <- mkReg(0);
    Reg#(Mantissa53) mantissa_2_53_64 <- mkReg(0);
    Reg#(Mantissa53) mantissa1_1 <- mkReg(0);
    Reg#(Mantissa53) mantissa2_1 <- mkReg(0);

    Reg#(Sum54) sum_64 <- mkReg(0);
    Reg#(Sum54) sum_64_2 <- mkReg(0);
    Reg#(Mantissa52) sum_64_3 <- mkReg(0);
    Reg#(Sum54) sum_64_4 <- mkReg(0);

    Reg#(Bool) got_A <- mkReg(False);
    Reg#(Bool) got_B <- mkReg(False);
    Reg#(Bool) got_final <- mkReg(False);
    Reg#(Bool) stage1 <- mkReg(False);
    Reg#(Bool) stage2 <- mkReg(False);
    Reg#(Bool) stage3 <- mkReg(False);
    Reg#(Bool) stage4 <- mkReg(False);

    //Reg#(Bit#(11)) shiftAmount <- mkReg(0);
    // Rule for extracting sign and exponent
    rule extractSignExponent(got_A && got_B);
        sign_1_64 <= input_1_64[63];
        sign_2_64 <= input_2_64[63];
        exponent_1_64 <= input_1_64[62:52];
        exponent_2_64 <= input_2_64[62:52];
        mantissa_1_64 <= input_1_64[51:0];
        mantissa_2_64 <= input_2_64[51:0];
    endrule

    // Rule for choosing exponent and appending mantissas
    rule chooseExponentAppendMantissas(got_A && got_B);
        if (exponent_1_64 >= exponent_2_64) begin
            exponent_max_64 <= exponent_1_64;
            if (mantissa_2_64 == 52'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) begin
                mantissa_2_53_64 <= {1'b0, mantissa_2_64};
            end else begin
                mantissa_2_53_64 <= {1'b1, mantissa_2_64} >> (exponent_1_64 - exponent_2_64);
            end
            if (mantissa_2_64 == 52'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) begin
            // append mantissa2 with 0
            mantissa_1_53_64 <= {1'b0, mantissa_1_64};
            end else begin
            // append mantissa2 with 1
            mantissa_1_53_64 <= {1'b1, mantissa_1_64};
            end
        end else begin
            exponent_max_64 <= exponent_2_64;
            if (mantissa_1_64 == 52'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) begin
                mantissa_1_53_64 <= {1'b0, mantissa_1_64};
            end else begin
                mantissa_1_53_64 <= {1'b1, mantissa_1_64} >> (exponent_2_64 - exponent_1_64);
            end
            if (mantissa_2_64 == 52'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) begin
            // append mantissa2 with 0
                mantissa_2_53_64 <= {1'b0, mantissa_2_64};
            end else begin
            // append mantissa2 with 1
                mantissa_2_53_64 <= {1'b1, mantissa_2_64};
            end
        end
    endrule

    // Rule for first stage pipeline
    rule firstStagePipeline(got_A && got_B);
        mantissa1_1 <= mantissa_1_53_64;
        mantissa2_1 <= mantissa_2_53_64;
        exponent1 <= exponent_max_64;
        sign1_1 <= sign_1_64;
        sign2_1 <= sign_2_64;
        stage1 <= True;
    endrule

    // Rule for adding mantissas based on sign
    rule addMantissas(stage1);
        if (sign1_1 == sign2_1) begin
            sign_64 <= sign1_1;
            sum_64 <= {1'b0,mantissa1_1} + {1'b0,mantissa2_1};

        end else begin
            if (mantissa1_1 > mantissa2_1) begin
                sign_64 <= sign1_1;
                sum_64 <= {1'b0,mantissa1_1} + ((~{1'b0,mantissa2_1}) + 54'b000000000000000000000000000000000000000000000000000001);
            end else begin
                sign_64 <= sign2_1;
                sum_64 <= {1'b0,mantissa2_1} + ((~{1'b0,mantissa1_1}) + 54'b000000000000000000000000000000000000000000000000000001);
            end
        end
        
    endrule

    // Rule for second stage pipeline
    rule secondStagePipeline(stage1);
        sum_64_2 <= sum_64;
        sign1_2 <= sign1_1;
        sign2_2 <= sign2_1;
        exponent2 <= exponent1;
        sign_64_2 <= sign_64;
        stage2 <= True;
    endrule
	function Integer leadingBitPosition(Bit#(54)value);
	Integer flag = 1;
	Integer position = 52;
	for(Integer i = 52; i >= 0; i = i-1) begin
		if(value[i] == 1'b1 && flag == 1) begin
			position = i;
			flag = 0;
		end
	end
	return position;
	endfunction
    // Rule for handling overflow and normalization
    rule handleOverflowNormalization(stage2);
    	Integer shiftvalue = 0;
	Integer temp = 0;
	if(sign1_2==sign2_2 && sum_64_2[53]==1'b1)begin
		sum_64_3<=(sum_64_2>>1'b1)[51:0];
		exponent3 <= exponent2 + 11'b00000000001;
	end
	else begin
	    	shiftvalue = leadingBitPosition(sum_64_2);
		sum_64_3 <= (sum_64_2 << (52 - shiftvalue))[51:0];
	    	temp = 52-shiftvalue;
		Bit#(11) shif = fromInteger(temp);    	
	    	exponent3 <= exponent2[10:0] - shif;
	    	
	end
    endrule

    // Rule for third stage pipeline
    rule thirdStagePipeline(stage2);
        //sum_64_3 <= sum_64_2;
        //exponent3 <= exponent2;
        sign_64_3 <= sign_64_2;
        stage3<=True;
    endrule

    // Rule for fourth stage pipeline
    //rule fourthStagePipeline(stage3);
        //sum_64_4 <= sum_64_3;
        //exponent4 <= exponent3;
        //sign_64_4 <= sign_64_3;
        //stage4<=True;
    //endrule

    // Rule for assigning final result
    rule assignFinalResult(stage3);
    	if(input_1_64==64'b0)final_sum_64 <= input_2_64;
    	else if(input_2_64==64'b0)final_sum_64 <= input_1_64;
        else final_sum_64 <= {sign_64_3, exponent3, sum_64_3[51:0]};
        if(final_sum_64==64'b0)got_final <= False;
        else got_final <= True;
    endrule

    // Input mapping to registers
    method Action put_A(Bit#(64) a_in) if (!got_A);
        input_1_64 <= a_in;
        got_A <= True;
    endmethod

    method Action put_B(Bit#(64) b_in) if (!got_B);
        input_2_64 <= b_in;
        got_B <= True;
    endmethod

    // Output mapping from registers
    method ActionValue#(Bit#(64)) get_res() if (got_final && got_A && got_B);
        return final_sum_64;
    endmethod

endmodule

endpackage
