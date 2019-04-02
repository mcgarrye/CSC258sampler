module samplertest(left_out, right_out, reset, clk, code);

	//input select; //RAM/wavefile selector ~ maps to keyboard keys at high level. Set at 1 bit for test
	
	input clk;
	input code;
	input reset;

	output [23:0] left_out;
	output [23:0] right_out;
	
	
	
	wire [14:0] s1_a;
	wire [14:0] s1_b;
	wire [14:0] s2_a;
	wire [14:0] s2_b;
	
	wire [23:0] ram1_l, ram1_r, ram2_l, ram2_r;
	
	wire rate_div_out;

	wire s1_EN, s1_reset, s2_EN, s2_reset;
	
	rateCounter sample_rate_pulse(clk, reset, 1, rate_div_out); //approx. 44.1kHz pulse
	
	sampletrigger st(code, s1_EN, s1_reset, s2_EN, s2_reset);
	
	newseventeenbitcounter s1_al(
		.EN(s1_EN),
		.clk(rate_div_out),
		.clear_b(s1_reset),
		.stored(s1_a));
		
	newseventeenbitcounter s1_ar(
		.EN(s1_EN),
		.clk(rate_div_out),
		.clear_b(s1_reset),
		.stored(s1_b));
		
		
	newseventeenbitcounter s2_al(
		.EN(s2_EN),
		.clk(rate_div_out),
		.clear_b(s2_reset),
		.stored(s2_a));
		
	newseventeenbitcounter s2_ar(
		.EN(s2_EN),
		.clk(rate_div_out),
		.clear_b(s2_reset),
		.stored(s2_b));
		

//	wavfileselect m1(select, ..)

	ram_24bit_audio sample1(
		.address_a(s1_a),
		.address_b(s1_b),
		.clock(clk),
		.data_a(0),
		.data_b(0),
		.wren_a(0),
		.wren_b(0),
		.q_a(ram1_l),
		.q_b(ram1_r));
		
	ram_24bit_audio_2 sample2(
		.address_a(s2_a),
		.address_b(s2_b),
		.clock(clk),
		.data_a(0),
		.data_b(0),
		.wren_a(0),
		.wren_b(0),
		.q_a(ram2_l),
		.q_b(ram2_r));
		
	ram_output_select out_select(left_out, right_out, ram1_l, ram1_r, ram2_l, ram2_r, code);

endmodule

module ram_output_select(left_out, right_out, left_in_1, right_in_1, left_in_2, right_in_2, code);
	
	input code;
	
	input [23:0] left_in_1;
	input [23:0] right_in_1;
	input [23:0] left_in_2;
	input [23:0] right_in_2;
	
	output [23:0] left_out;
	output [23:0] right_out;
	
	reg [23:0] left_out;
	reg [23:0] right_out;
	
	always @(*)
	begin
		case (code)
			1'b0 :
				begin
					left_out <= left_in_1;
					right_out <= right_in_1;
				end
			1'b1 :
				begin
					left_out <= left_in_2;
					right_out <= right_in_2;
				end
			default :				
				begin
					left_out <= left_in_1;
					right_out <= right_in_1;
				end
		endcase
	end

endmodule

//module wavfileselect(select, in_left, in_right)
//	ram_output_select out_select(left_out. right_out, ram1_l, ram1_r, ram2_l, ram2_r, code);
//	// select bits specify a RAM module to probe for audiodata.
//
//	input select;
//	
//	input [16:0] in_left;
//	input [16:0] in_right;
//	
//	reg [16:0] q;
//	reg [16:0] s;
//
//	always @(*)
//    begin
//        if (select == 1'b0)
//				begin
//					assign in_left <= samplertest.s1_a;
//					assign in_right <= samplertest.s1_b;
//				end
//				
//        else if (select == 1'b1)
//				begin
//					assign in_left <= samplertest.s2_a;
//					assign in_right <= samplertest.s2_b;
//				end
//    end
//
//endmodule

