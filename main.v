module sampler (
        input CLOCK_50,
	input [9:0] SW, 
        inout PS2_CLK,
        inout PS2_DAT,
	output [2:0] LEDR
        );
    
    assign reset = 0;
    wire q, w, e, r, t, y, u, i, o;
    wire left, right, up, down;
    reg [2:0] out;
    reg [80:0] seq1;
    reg [80:0] seq2;

    keyboard_tracker #(.PULSE_OR_HOLD(1)) keyboard(
        .clock(CLOCK_50),
        .reset(reset),
        
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
    
    wire [8:0] pressed = {q, w, e, r, t, y, u, i, o};
    reg [3:0] counter;
    reg [3:0] counter1;
    reg [3:0] counter2;
    always @(posedge CLOCK_50)
    begin
	if(SW[4:1] == 2'b0000)
		begin
		seq1 <= 0;
		seq2 <= 0;
		counter <= 0;
		case(pressed)
		    9'b100000000: out = 3'b001;//q_output
		    9'b010000000: out = 3'b010;//w_output
		    9'b001000000: out = 3'b100;//e_output
		    9'b000100000: out = 3'b110;//r_output
		    9'b000010000: out = 3'b011;//t_output
		    9'b000001000: out = 3'b011;//y_output
		    9'b000000100: out = 3'b011;//u_output
		    9'b000000010: out = 3'b011;//i_output
		    9'b000000001: out = 3'b011;//o_output
		    default: out = 3'b000; //silence
		endcase
		end
	else if (SW[4:1] == 2'b0001 && counter<4'b1001)
		begin
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
	else if (SW[4:1] == 2'b0010 && counter<4'b1001)
		begin
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
	else
		counter <= 4'b0000;
	if (SW[2:1] == 2'b00 && SW[3] == 1'b1 &&counter<4'b1001)
		begin
		counter1 <= counter1 + 4'b0001;
		case(seq1[80:72])
		    9'b100000000: out = 3'b001;//q_output
		    9'b010000000: out = 3'b010;//w_output
		    9'b001000000: out = 3'b100;//e_output
		    9'b000100000: out = 3'b110;//r_output
		    9'b000010000: out = 3'b011;//t_output
		    9'b000001000: out = 3'b011;//y_output
		    9'b000000100: out = 3'b011;//u_output
		    9'b000000010: out = 3'b011;//i_output
		    9'b000000001: out = 3'b011;//o_output
		endcase
		seq1 <= seq1<<9;
		end
	if (SW[2:1] == 2'b00 && SW[4] == 1'b1 &&counter<4'b1001)
		begin
		counter2 <= counter2 + 4'b0001;
		case(seq2[80:72])
		    9'b100000000: out = 3'b001;//q_output
		    9'b010000000: out = 3'b010;//w_output
		    9'b001000000: out = 3'b100;//e_output
		    9'b000100000: out = 3'b110;//r_output
		    9'b000010000: out = 3'b011;//t_output
		    9'b000001000: out = 3'b011;//y_output
		    9'b000000100: out = 3'b011;//u_output
		    9'b000000010: out = 3'b011;//i_output
		    9'b000000001: out = 3'b011;//o_output
		endcase
		seq2 <= seq2<<9;
		end
    end
    assign LEDR = out;   
endmodule
