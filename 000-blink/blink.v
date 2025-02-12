module Blink #(
    parameter CLK_FREQ = 25_000_000 
) (
    input wire clk,
    input wire rst,
    output reg led
);

localparam ONE_SECOND  = CLK_FREQ;
localparam HALF_SECOND = CLK_FREQ / 2;

reg [32:0] counter;

always @(posedge clk ) begin
    if(rst) begin
        counter <= 32'h0;
        led     <= 1'b0;
    end else begin
        if(counter >= HALF_SECOND) begin
            counter <= 1'b0;
            led <= ~led;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end
    
endmodule
