`timescale 1ns / 1ps

module clk_divider_and_eninput_pulse_tb();
    reg     clk;
    wire    clk_10Hz;
    wire    en_input;

    clk_divider #(
        .input_clk_freq (100_000_000),
        .output_clk_freq(100)
    ) uut (
        .clk            (clk),
        .clk_10Hz       (clk_10Hz)
    );

    gen_eninput_pulse #(
        .input_clk_freq (100_000_000),
        .output_clk_freq(100)
    ) uut2 (
        .clk            (clk),
        .clk_10Hz       (clk_10Hz),
        .en_input       (en_input)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

endmodule

