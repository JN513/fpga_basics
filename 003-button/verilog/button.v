module Button #(
    parameter CLK_FREQ = 25_000_000 
) (
    input wire clk,
    input wire rst_n,
    input wire btn,
    output reg led
);

reg [2:0] debouncing;

always @(posedge clk ) begin
    if(!rst_n) begin
        led <= 1'b0;
    end else begin
        led <= high_btn;
    end
end

always @(posedge clk ) begin
    if(!rst_n) begin
        debouncing <= 3'b000;
    end else begin
        debouncing <= {debouncing[1:0], btn};
    end
end

wire posedge_btn, negedge_btn, high_btn;

assign high_btn    = &debouncing[2:1];
assign posedge_btn = (debouncing[2:1] == 2'b01) ? 1'b1 : 1'b0;
assign negedge_btn = (debouncing[2:1] == 2'b10) ? 1'b1 : 1'b0;

endmodule
