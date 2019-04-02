module smalltest(ram_l, ram_r, clk, s1_EN, s1_reset, write_ready);
	
	input s1_EN, s1_reset, clk, write_ready;
	
	wire rate_div_out;
	wire [14:0] address_left_to_ram;
	wire [14:0] address_right_to_ram;
	
	wire [23:0] w1, w2;
	
	output reg [23:0] ram_l, ram_r;
	//reg [23:0] ram_l, ram_r;
	
	//wire [23:0] ram_l_reg, ram_r_reg;

	rateCounter sample_rate_pulse(clk, s1_reset, 1, rate_div_out); //approx. 44.1kHz pulse
	
	
	// note these counters are actually 15 bit
	
	fifteenbitcounter_lefttype s1_addressleft(
		.EN(s1_EN),
		.clk(rate_div_out),
		.clear_b(s1_reset),
		.stored(address_left_to_ram));
		
	fifteenbitcounter_righttype s1_addressright(
		.EN(s1_EN),
		.clk(rate_div_out),
		.clear_b(s1_reset),
		.stored(address_right_to_ram));
	
	ram_24bit_audio sample1(
		.address_a(address_left_to_ram),
		.address_b(address_right_to_ram),
		.clock(clk),
		.data_a(0),
		.data_b(0),
		.wren_a(0),
		.wren_b(0),
		.q_a(w1),
		.q_b(w2));
		
	always @(posedge clk)
	begin
		if (write_ready)
			begin
			ram_l <= w1;
			ram_r <= w2;
			end
		else
			begin
			ram_l <= 24'b000000000000000000000000;
			ram_r <= 24'b000000000000000000000000;
			end
		
	end
//		
		
endmodule