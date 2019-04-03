module main (
        input CLOCK_50,
	input [9:0] SW,
	input [0:0] KEY,
        inout PS2_CLK,
        inout PS2_DAT,
	output [9:0] LEDR
        );
    
    wire q, w, e, r, t, y, u, i, o;
    wire left, right, up, down;
    wire clk2;

	
    keyboard_tracker #(.PULSE_OR_HOLD(0)) keyboard(
        .clock(CLOCK_50),
	    .reset(~SW[6]),
        
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        
        .q(q), 
        .w(w), 
        .e(e), 
        .r(r),
        .t(t),
        .y(y), 
        .u(u), 
        .i(i),
			.o(o),
        .left(left), 
        .right(right), 
        .up(up), 
        .down(down)
    );

    clk_div new_clk(
	.clk(CLOCK_50),
	.reset(SW[6]),
	.clk_out(clk2)
    );
	 
    
    wire [8:0] pressed = {q, w, e, r, t, y, u, i, o};
    reg [8:0] out;
    reg [80:0] seq1;
    reg [80:0] seqtemp1;
    reg [80:0] seq2;
    reg [80:0] seqtemp2;
    reg [3:0] counter;
    reg [3:0] counter1;
    reg [3:0] counter2;

    always @(negedge KEY[0])
    begin
	if(SW[6] == 1'b1)
		begin
		seq1 <= 0;
		seqtemp1 <= 0;
		seq2 <= 0;
		seqtemp2 <= 0;
		counter1 <= 0;
		counter2 <= 0;
		end

	if(SW[4:1] == 4'b0000)
		begin
		counter <= 0;
		case(pressed)
		    9'b100000000: out = pressed;//q_output
		    9'b010000000: out = pressed;//w_output
		    9'b001000000: out = pressed;//e_output
		    9'b000100000: out = pressed;//r_output
		    9'b000010000: out = pressed;//t_output
		    9'b000001000: out = pressed;//y_output
		    9'b000000100: out = pressed;//u_output
		    9'b000000010: out = pressed;//i_output
		    9'b000000001: out = pressed;//o_output
		    default: out = 0; //silence
		endcase
		end
	else if (SW[4:0] == 5'b00010 && counter<4'b1010)
		begin
		out <= 9'b000000010;
		counter <= counter + 4'b0001;
		case(pressed)
		    9'b100000000: seq1 <= (seq1<<9) + pressed;//add q to seq1
		    9'b010000000: seq1 <= (seq1<<9) + pressed;//add w to seq1
		    9'b001000000: seq1 <= (seq1<<9) + pressed;//add e to seq1
		    9'b000100000: seq1 <= (seq1<<9) + pressed;//add r to seq1
		    9'b000010000: seq1 <= (seq1<<9) + pressed;//add t to seq1
		    9'b000001000: seq1 <= (seq1<<9) + pressed;//add y to seq1
		    9'b000000100: seq1 <= (seq1<<9) + pressed;//add u to seq1
		    9'b000000010: seq1 <= (seq1<<9) + pressed;//add i to seq1
		    9'b000000001: seq1 <= (seq1<<9) + pressed;//add o to seq1
		endcase
		end
	else if (SW[4:0] == 5'b00100 && counter<4'b1010)
		begin
		out <= 9'b000000100;
		counter <= counter + 4'b0001;
		case(pressed)
		    9'b100000000: seq2 <= (seq2<<9) + pressed;//add q to seq2
		    9'b010000000: seq2 <= (seq2<<9) + pressed;//add w to seq2
		    9'b001000000: seq2 <= (seq2<<9) + pressed;//add e to seq2
		    9'b000100000: seq2 <= (seq2<<9) + pressed;//add r to seq2
		    9'b000010000: seq2 <= (seq2<<9) + pressed;//add t to seq2
		    9'b000001000: seq2 <= (seq2<<9) + pressed;//add y to seq2
		    9'b000000100: seq2 <= (seq2<<9) + pressed;//add u to seq2
		    9'b000000010: seq2 <= (seq2<<9) + pressed;//add i to seq2
		    9'b000000001: seq2 <= (seq2<<9) + pressed;//add o to seq2
		endcase
		end
	else if (SW[2:1] != 2'b10 && SW[2:1] != 2'b01)
		counter <= 4'b0000;
    end

    reg tester;
    reg [8:0] out2;
    always @(negedge clk2)
    begin
	if (SW[4:3] == 2'b00) 
 		begin
		tester <= 0; 
 		seqtemp1 <= seq1; 
 		seqtemp2 <= seq2; 
 		counter1 <= 0; 
 		counter2 <= 0;
		out2 <= 0; 
 		end 

	if (SW[2:1] == 2'b00 && SW[3] == 1'b1 && counter1<4'b1010)
		begin
		tester <= 1;
		counter1 <= counter1 + 4'b0001;
		out2 <= seqtemp1[80:72];
		seqtemp1 <= seqtemp1<<9;
		end
	if (SW[2:1] == 2'b00 && SW[4] == 1'b1 && counter2<4'b1010)
		begin
		tester <= 1;
		counter2 <= counter2 + 4'b0001;
		out2 <= seqtemp2[80:72];
		seqtemp2 <= seqtemp2<<9;
		end
    end

    assign LEDR = (tester == 1'b1) ? out2 : out;   
endmodule


module clk_div (clk, reset, clk_out);
     
    input clk;
    input reset;
    output clk_out;
     
    reg [1:0] r_reg;
    wire [1:0] r_nxt;
    reg clk_track;
     
    always @(posedge clk or posedge reset)
     
    begin
      if (reset)
         begin
            r_reg <= 3'b0;
    	clk_track <= 1'b0;
         end
     
      else if (r_nxt == 2'b10)
     	   begin
    	     r_reg <= 0;
    	     clk_track <= ~clk_track;
    	   end
     
      else 
          r_reg <= r_nxt;
    end
     
     assign r_nxt = r_reg+1;   	      
     assign clk_out = clk_track;
endmodule
