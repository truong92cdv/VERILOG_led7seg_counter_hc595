module gen_pulse #(
    parameter   setup_time      = 200,      // 200 clk cycles = 2 us
    parameter   pulse_duration  = 200       // 200 clk cycles = 2 us
)(
    input wire  clk,                        // 100 MHz
    input wire  toggle,
    output wire pulse
);

    localparam  [1:0]   IDLE    = 2'b00,
                        LOW     = 2'b01,
                        HIGH    = 2'b10,
                        WAIT    = 2'b11;
    reg [1:0]   state           = IDLE;    
    integer     count           = 0;
    reg         pulse_r         = 0;

    assign pulse = pulse_r;
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin                             // wait for toogle = 1
                if (toggle) begin
                    state       <= LOW;
                    pulse_r     <= 0;
                    count       <= 0;
                end
            end
            LOW: begin                              // wait for setup time, then set to 1
                if (count == setup_time - 3) begin  // -3 to compensate for the previous 2 cycles
                    state       <= HIGH;
                    pulse_r     <= 1;
                    count       <= 0;
                end else begin
                    count       <= count + 1;
                end
            end
            HIGH: begin                             // wait for pulse duration, then set to 0
                if (count == pulse_duration - 1) begin
                    state       <= WAIT;
                    pulse_r     <= 0;
                    count       <= 0;
                end else begin
                    count       <= count + 1;
                end
            end
            WAIT: begin                             // wait for toogle = 0
                if (~toggle) begin
                    state   <= IDLE;
                end
            end    
        endcase
    end

endmodule
