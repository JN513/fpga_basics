module Semaphore #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire pedestrian,

    output wire green,
    output wire yellow,
    output wire red
);
    
// Time constants
localparam SECOND              = CLK_FREQ;
localparam HALF_SECOND         = CLK_FREQ / 2;
localparam QUARTER_OF_A_SECOND = CLK_FREQ / 4;
localparam MINUTE              = CLK_FREQ * 60;
localparam OPENING_TIME        = 5 * SECOND;
localparam CLOSING_TIME        = 7 * SECOND;

// 2-bit state machine
localparam CLOSED  = 2'b00;
localparam OPENING = 2'b01;
localparam OPEN    = 2'b10;
localparam CLOSING = 2'b11;

reg [1:0] state;
reg [31:0] time_counter;

always @(posedge clk ) begin
    if(!rst_n) begin
        state        <= CLOSED;
        time_counter <= 32'h0;
    end else begin
        case (state)
            CLOSED: begin
                if(time_counter == OPENING_TIME) begin
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
                if(time_counter == CLOSING_TIME || pedestrian) begin
                    state        <= CLOSING;
                    time_counter <= 32'h0;
                end else begin
                    time_counter <= time_counter + 1;
                end
                
                if(pedestrian) begin
                    state <= CLOSING;
                end
            end
            CLOSING: begin
                state <= CLOSED;
            end
            default: state <= CLOSED;
        endcase
    end
end

always @(*) begin
    case (state)
        CLOSED: begin
            green  <= 1'b0;
            yellow <= 1'b0;
            red    <= 1'b1;
        end
        OPENING: begin
            green  <= 1'b0;
            yellow <= 1'b1;
            red    <= 1'b0;
        end
        OPEN: begin
            green  <= 1'b1;
            yellow <= 1'b0;
            red    <= 1'b0;
        end
        CLOSING: begin
            green  <= 1'b0;
            yellow <= 1'b1;
            red    <= 1'b0;
        end
        default: begin
            green  <= 1'b0;
            yellow <= 1'b0;
            red    <= 1'b1;
        end
    endcase
end

endmodule