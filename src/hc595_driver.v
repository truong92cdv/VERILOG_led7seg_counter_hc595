module hc595_driver #(
    parameter   N = 8                       // number of bits, maximum 32
)(
    input wire  clk,                        // 100 MHz
    input wire  en_input,                   // enable input
    input wire  [N-1:0] data_in,            // data input

    output wire RDY,                        // ready flag
    output wire SRCLK,                      // shift register clock         = SH_CP
    output wire RCLK,                       // register clock               = ST_CP = LATCH
    output wire SER                         // serial data output           = DS
);

    localparam  setup_time      = 200,      // 200 clk cycles = 2 us
                pulse_duration  = 200;      // 200 clk cycles = 2 us

    localparam  [1:0]   IDLE    = 2'b00,    // main FSM
                        SHIFT   = 2'b01,
                        LATCH   = 2'b10;

    localparam  [1:0]   PUSH    = 2'b00,    // sub FSM
                        TGL_ON  = 2'b01,
                        TGL_OFF = 2'b10,
                        CHECK   = 2'b11;

    reg [1:0]   state           = IDLE;
    reg [1:0]   sub_state       = PUSH;
    reg [4:0]   count           = 0;
    reg [N:0]   shift           = 0;
    reg         SRCLK_toggle_r  = 0;
    reg         RCLK_toggle_r   = 0;
    reg         RDY_r           = 1;
    wire        SRCLK_toggle;
    wire        RCLK_toggle;
    
    assign SRCLK_toggle = SRCLK_toggle_r;
    assign RCLK_toggle  = RCLK_toggle_r;
    assign RDY          = RDY_r;
    assign SER          = shift[N];

    gen_pulse #(.setup_time(setup_time), .pulse_duration(pulse_duration)) SRCLK_gen (
        .clk            (clk),
        .toggle         (SRCLK_toggle),
        .pulse          (SRCLK)
    );

    gen_pulse #(.setup_time(setup_time), .pulse_duration(pulse_duration)) RCLK_gen (
        .clk            (clk),
        .toggle         (RCLK_toggle),
        .pulse          (RCLK)
    );

    always @(posedge clk) begin
        case (state)
            IDLE: begin                                 // wait for enable = 1
                if (en_input) begin
                    state           <= SHIFT;
                    sub_state       <= PUSH;
                    shift[N-1:0]    <= data_in;
                    count           <= 0;
                    RDY_r           <= 0;
                    SRCLK_toggle_r  <= 0;
                    RCLK_toggle_r   <= 0;
                end else begin
                    state           <= IDLE;
                    sub_state       <= PUSH;
                    count           <= 0;
                    RDY_r           <= 1;
                    SRCLK_toggle_r  <= 0;
                    RCLK_toggle_r   <= 0;
                end
            end
            SHIFT: begin                                // shift data
                case (sub_state)
                    PUSH: begin                         // push data
                        sub_state           <= TGL_ON;
                        shift               <= {shift[N-1:0], 1'b0};
                    end
                    TGL_ON: begin                       // toggle SRCLK on
                        sub_state           <= TGL_OFF;
                        SRCLK_toggle_r      <= 1;
                    end
                    TGL_OFF: begin                      // toggle SRCLK off
                        if (SRCLK == 1) begin
                            sub_state       <= CHECK;
                            SRCLK_toggle_r  <= 0;
                        end
                    end
                    CHECK: begin                        // check for end of shift
                        if (SRCLK == 0) begin
                            if (count == N-1) begin
                                state       <= LATCH;
                                sub_state   <= TGL_ON;
                                count       <= 0;
                            end else begin
                                sub_state   <= PUSH;
                                count       <= count + 1;
                            end
                        end
                    end
                endcase
            end
            LATCH: begin                                // latch data
                case (sub_state)
                    TGL_ON: begin                       // toggle RCLK on
                        sub_state           <= TGL_OFF;
                        RCLK_toggle_r       <= 1;
                    end
                    TGL_OFF: begin                      // toggle RCLK off
                        if (RCLK == 1) begin
                            sub_state       <= CHECK;
                            RCLK_toggle_r   <= 0;
                        end
                    end
                    CHECK: begin                        // check for end of latch
                        if (RCLK == 0) begin
                            state           <= IDLE;
                            sub_state       <= PUSH;
                            RDY_r           <= 1;
                        end
                    end
                endcase
            end
            default: begin
                state           <= IDLE;
                sub_state       <= PUSH;
                RDY_r           <= 1;
            end
        endcase
    end

endmodule
