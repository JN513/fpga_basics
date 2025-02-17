module Shiffter #(
    parameter CLK_FREQ = 25_000_000 
) (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0] leds
);

localparam ONE_SECOND          = CLK_FREQ;
localparam HALF_SECOND         = CLK_FREQ / 2;
localparam QUARTER_OF_A_SECOND = CLK_FREQ / 4;

logic [32:0] counter;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 32'h0;
        leds    <= 8'h1F;
    end else begin
        if (counter >= QUARTER_OF_A_SECOND) begin
            counter <= 1'b0;
            leds    <= {leds[6:0], leds[7]};
        end else begin
            counter <= counter + 1'b1;
        end
    end
end
    
endmodule
