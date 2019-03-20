module sampler (
        input CLOCK_50,
        inout PS2_CLK,
        inout PS2_DAT,
	output [2:0] LEDR
        );
    
    assign reset = 0;
    wire q, w, e, r, t, y, u, i, o, p, a, s, d, f, g, h;
    wire left, right, up, down;
    reg [2:0] out;
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
        .p(p), 
        .a(a), 
        .s(s), 
        .d(d), 
        .f(f), 
        .g(g), 
        .h(h),
        .left(left), 
        .right(right), 
        .up(up), 
        .down(down)
    );
    
    always @(posedge CLOCK_50)
    begin
        case({q, w, e, r, t, y, u, i, o, p, a, s, d, f, g, h})
            16'b1000000000000000: out = 3'b001;//q_output
            16'b0100000000000000: out = 3'b010;//w_output
            16'b0010000000000000: out = 3'b100;//e_output
            16'b0001000000000000: out = 3'b110;//r_output
            16'b0000100000000000: out = 3'b011;//t_output
            16'b0000010000000000: out = 3'b011;//y_output
            16'b0000001000000000: out = 3'b011;//u_output
            16'b0000000100000000: out = 3'b011;//i_output
            16'b0000000010000000: out = 3'b011;//o_output
            16'b0000000001000000: out = 3'b011;//p_output
            16'b0000000000100000: out = 3'b011;//a_output
            16'b0000000000010000: out = 3'b011;//s_output
            16'b0000000000001000: out = 3'b011;//d_output
            16'b0000000000000100: out = 3'b011;//f_output
            16'b0000000000000010: out = 3'b011;//g_output
            16'b0000000000000001: out = 3'b011;//h_output
        endcase
    end
    assign LEDR = out;   
endmodule
