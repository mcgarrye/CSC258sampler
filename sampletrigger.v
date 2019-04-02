module sampletrigger(code, s1_EN, s1_reset, s2_EN, s2_reset);

	input [0:0] code;
	
	reg s1_EN_r, s1_reset_r, s2_EN_r, s2_reset_r;
	
	output s1_EN, s2_EN, s1_reset, s2_reset;
	
	always @(*)
	begin
		case (code)
			1'b0 :
				begin
					s1_EN_r <= 1;
					s1_reset_r <= 1;
					s2_EN_r <= 0;
					s2_reset_r <= 0;
				end
			1'b1 :
				begin
				   s1_EN_r <= 0;
					s1_reset_r <= 0;
					s2_EN_r <= 1;
					s2_reset_r <= 1;
				end
			default :
				begin
					s1_EN_r <= 0;
					s1_reset_r <= 0;
					s2_EN_r <= 0;
					s2_reset_r <= 0;
				end
		endcase
	end
	
	assign s1_EN = s1_EN_r;
	assign s2_EN = s2_EN_r;
	assign s1_reset = s1_reset_r;
	assign s2_reset = s2_reset_r;

endmodule