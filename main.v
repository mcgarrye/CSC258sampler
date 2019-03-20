module sampler (
        input CLOCK_50,
        inout PS2_CLK,
        inout PS2_DAT,
        output out
        );
    
    assign reset = 0;
    assign q, w, e, r, t, y, u, i, o, p, a, s, d, f, g, h;
    assign left, right, up, down;
    keyboard #(PULSE_OR_HOLD(1)) keyboard_tracker(
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
    
    assign select = {q, w, e, r, t, y, u, i, o, p, a, s, d, f, g, h};
    
    always @(CLOCK_50)
    begin
        case(select)
            1000000000000000: //q_output
            0100000000000000: //w_output
            0010000000000000: //e_output
            0001000000000000: //r_output
            0000100000000000: //t_output
            0000010000000000: //y_output
            0000001000000000: //u_output
            0000000100000000: //i_output
            0000000010000000: //o_output
            0000000001000000: //p_output
            0000000000100000: //a_output
            0000000000010000: //s_output
            0000000000001000: //d_output
            0000000000000100: //f_output
            0000000000000010: //g_output
            0000000000000001: //h_output
        endcase
    end
		
    
    
    
    
endmodule