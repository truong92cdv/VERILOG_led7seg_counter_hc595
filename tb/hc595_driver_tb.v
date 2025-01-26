`timescale 1ns / 1ps

module hc595_driver_tb();
    reg     clk;
    reg     rst_n;
    wire    SRCLK;
    wire    RCLK;
    wire    SER;

    clk_divider #(
        .input_clk_freq (100_000_000),
        .output_clk_freq(1000)
    ) clk_10Hz_gen(
        .clk        (clk),
        .clk_10Hz   (clk_10Hz)
    );
    
    gen_eninput_pulse #(
        .input_clk_freq (100_000_000),
        .output_clk_freq(1000)
    ) eninput_pulse_gen(
        .clk        (clk),
        .clk_10Hz   (clk_10Hz),
        .en_input   (en_input)
    );
    
    hc595_driver #(.N(32)) hc595_controller(
        .clk        (clk),
        .en_input   (en_input),
        .data_in    ({32'hdeafbeef}),
        .RDY        (),
        .SRCLK      (SRCLK),
        .RCLK       (RCLK),
        .SER        (SER)      
    );

    initial begin
        clk = 0;
        rst_n = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #10 rst_n = 1;
        #100000000 $finish;
    end

endmodule
