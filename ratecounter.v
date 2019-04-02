module rateCounter(clk, reset, enable, EN_out);

    input clk;
    // determine need
    input reset;
    input enable;
    	 
    output EN_out;
    
    reg [10:0] q;
	 
	 parameter SAMPLE_RATE_DIVISOR = 11'b10001101101;
    
    always @(posedge clk)
    begin
        if (reset == 1'b0)
            q <= 11'b00000000000;
        else if (enable == 1'b1)
            begin
                if (q == 11'b00000000000) // check use of decimal here won't cause issue
                    q <= SAMPLE_RATE_DIVISOR;
                else
                    q <= q - 11'b00000000001;
              end      
    end
    
    assign EN_out = (q == 11'b00000000000) ? 1'b1 : 1'b0;

endmodule

module tflip(t, reset_n, clk, q);

	//width 1

	input t;
	input reset_n;
	input clk;

	output q;

	reg q;

	always @(posedge clk, negedge reset_n)

	begin
		if (~ reset_n)
			q <= 0;
		else
			q <= t ^ q;
	end


endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
endmodule

module mux4to1(u, v, w, x, s0, s1, m);
    input u; //selected when s1s0 is 00
    input v; //selected when s1s0 is 01
    input w; //selected when s1s0 is 10
	 input x; //selected when s1s0 is 11
	 input s0; //first bit of select signal 
	 input s1; //second bit of select signal 
    output m; //output
	 wire wire1;
	 wire wire2;
	 mux2to1 u0(
	  .x(u),
	  .y(v),
	  .s(s0),
	  .m(wire1)
	  );
	  mux2to1 u1(
	  .x(w),
	  .y(x),
	  .s(s0),
	  .m(wire2)
	  );
	  mux2to1 u2(
	  .x(wire1),
	  .y(wire2),
	  .s(s1),
	  .m(m)
	  );
endmodule