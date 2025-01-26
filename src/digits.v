module digits(
    input               clk,
    input               rst_n,        // Negedge reset
    output reg [3:0]    dig_0,
    output reg [3:0]    dig_1,
    output reg [3:0]    dig_2,
    output reg [3:0]    dig_3
);

    // dig_0 reg control
    always @(posedge clk)
        if (~rst_n)
            dig_0 <= 0;
        else begin
            if (dig_0 == 9)
                dig_0 <= 0;
            else
                dig_0 <= dig_0 + 1;
        end

    // dig_1 reg control
    always @(posedge clk)
        if (~rst_n)
            dig_1 <= 0;
        else if (dig_0 == 9) begin
            if (dig_1 == 9)
                dig_1 <= 0;
            else
                dig_1 <= dig_1 + 1;
        end

    // dig_2 reg control
    always @(posedge clk)
        if (~rst_n)
            dig_2 <= 0;
        else if (dig_1 == 9 && dig_0 == 9) begin
            if (dig_2 == 9)
                dig_2 <= 0;
            else
                dig_2 <= dig_2 + 1;
        end

    // dig_3 reg control
    always @(posedge clk)
        if (~rst_n)
            dig_3 <= 0;
        else if (dig_2 == 9 && dig_1 == 9 && dig_0 == 9) begin
            if (dig_3 == 9)
                dig_3 <= 0;
            else
                dig_3 <= dig_3 + 1;
        end

endmodule
