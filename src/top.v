module top #(
    parameter   input_clk_freq  = 100_000_000,      // Input clock 100 MHz
    parameter   output_clk_freq = 10                // Output clock 10 Hz = 100ms
)(
    input   clk,
    input   rst_n,                                  // Negedge reset
    output  SRCLK,
    output  RCLK,
    output  SER
);

    wire        clk_10Hz;
    wire        en_input;
    wire [3:0]  dig_0_bcd;
    wire [3:0]  dig_1_bcd;
    wire [3:0]  dig_2_bcd;
    wire [3:0]  dig_3_bcd;
    wire [7:0]  dig_0_7seg;
    wire [7:0]  dig_1_7seg;
    wire [7:0]  dig_2_7seg;
    wire [7:0]  dig_3_7seg;


    clk_divider #(
        .input_clk_freq (input_clk_freq),
        .output_clk_freq(output_clk_freq)
    ) clk_10Hz_gen(
        .clk        (clk),
        .clk_10Hz   (clk_10Hz)
    );

    gen_eninput_pulse #(
        .input_clk_freq (input_clk_freq),
        .output_clk_freq(output_clk_freq)
    ) eninput_pulse_gen(
        .clk        (clk),
        .clk_10Hz   (clk_10Hz),
        .en_input   (en_input)
    );

    digits digs(
        .clk        (clk_10Hz),
        .rst_n      (rst_n),
        .dig_0      (dig_0_bcd),
        .dig_1      (dig_1_bcd),
        .dig_2      (dig_2_bcd),
        .dig_3      (dig_3_bcd)
    );

    bcd_to_led7seg DIGIT_0(
        .bcd        (dig_0_bcd),
        .led7seg_ca (dig_0_7seg)
    );

    bcd_to_led7seg DIGIT_1(
        .bcd        (dig_1_bcd),
        .led7seg_ca (dig_1_7seg)
    );

    bcd_to_led7seg DIGIT_2(
        .bcd        (dig_2_bcd),
        .led7seg_ca (dig_2_7seg)
    );

    bcd_to_led7seg DIGIT_3(
        .bcd        (dig_3_bcd),
        .led7seg_ca (dig_3_7seg)
    );

    hc595_driver #(.N(32)) hc595_controller(
        .clk        (clk),
        .en_input   (en_input),
        .data_in    ({dig_0_7seg, dig_1_7seg, dig_2_7seg, dig_3_7seg}),
        //.data_in    ({8'b10011001, 8'b10110000, 8'b10100100, 8'b11111001}),
        .RDY        (),
        .SRCLK      (SRCLK),
        .RCLK       (RCLK),
        .SER        (SER)      
    );

endmodule
