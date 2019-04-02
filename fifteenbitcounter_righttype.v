module fifteenbitcounter_righttype(EN, clk, clear_b, stored);

//Counts odd-numbered addresses
	 
    input EN;
    input clk;
    input clear_b;
    
    output [0:14] stored;
	         
    reg [0:14] q;
	 
	 assign stored[0:14] = q[0:14];

	 always @(posedge clk)
		begin
			if (~ clear_b)
				begin
				q <= 15'b000000000000001;
				end
			else if (EN)
				begin
					if (q == 15'b111001011010111)
						begin
						q <= 15'b000000000000001;
						end
					else
						begin
						q <= q + 15'b000000000000010;
						end
				end
		end
		
    

endmodule