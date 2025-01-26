module gen_eninput_pulse #(
	parameter   input_clk_freq  = 100_000_000,      // Input clock 100 MHz
    parameter   output_clk_freq = 10                // Output clock 10 Hz = 100ms
)(
    input       clk,
    input       clk_10Hz,                           // Clock 10 Hz = 100ms
    output      en_input                            // Enable input pulse        
);
    reg         en_input_r = 0;
    integer     count = 0;
    integer     max_count = input_clk_freq / output_clk_freq - 1;
    
    always @(posedge clk)
        if (clk_10Hz) begin
            count <= count + 1;
            if (count == 1000)          // 10 us
                en_input_r <= 1;
            else if (count == 500)      //  5 us
                en_input_r <= 0;
        end else begin
            count <= 0;
            en_input_r <= 0;
        end

    assign en_input = en_input_r;
    
endmodule

