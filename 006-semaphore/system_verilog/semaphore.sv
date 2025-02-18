module Semaphore #(
    parameter int CLK_FREQ = 100_000_000
) (
    input  logic clk,
    input  logic rst_n,
    input  logic pedestrian,
    output logic green,
    output logic yellow,
    output logic red
);
    
    // Time constants
    localparam int SECOND              = CLK_FREQ;
    localparam int OPENING_TIME        = 5 * SECOND;
    localparam int CLOSING_TIME        = 7 * SECOND;

    // State enumeration
    typedef enum logic [1:0] {
        CLOSED  = 2'b00,
        OPENING = 2'b01,
        OPEN    = 2'b10,
        CLOSING = 2'b11
    } state_t;

    state_t state;
    logic [31:0] time_counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= CLOSED;
            time_counter <= 32'h0;
        end else begin
            case (state)
                CLOSED: begin
                    if (time_counter == OPENING_TIME) begin
                        state        <= OPENING;
                        time_counter <= 32'h0;
                    end else begin
                        time_counter <= time_counter + 1;
                    end
                end
                OPENING: begin
                    state <= OPEN;
                end
                OPEN: begin
                    if (time_counter == CLOSING_TIME || pedestrian) begin
                        state        <= CLOSING;
                        time_counter <= 32'h0;
                    end else begin
                        time_counter <= time_counter + 1;
                    end
                end
                CLOSING: begin
                    state <= CLOSED;
                end
                default: state <= CLOSED;
            endcase
        end
    end

    always_comb begin
        case (state)
            CLOSED: begin
                green  = 1'b0;
                yellow = 1'b0;
                red    = 1'b1;
            end
            OPENING, CLOSING: begin
                green  = 1'b0;
                yellow = 1'b1;
                red    = 1'b0;
            end
            OPEN: begin
                green  = 1'b1;
                yellow = 1'b0;
                red    = 1'b0;
            end
            default: begin
                green  = 1'b0;
                yellow = 1'b0;
                red    = 1'b1;
            end
        endcase
    end

endmodule
