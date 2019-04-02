module fifteenbitcounter_lefttype(EN, clk, clear_b, stored);
	 	 
//counts even numbered addresses

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
				q <= 15'b000000000000000;
				end
			else if (EN)
				begin
					if (q == 15'b111001011011000)
						begin
						q <= 15'b000000000000000;
						end
					else
						begin
						q <= q + 15'b000000000000010;
						end
				end
		end
		
    

endmodule