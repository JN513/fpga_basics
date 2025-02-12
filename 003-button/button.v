module Button #(
    parameter CLK_FREQ = 25_000_000 
) (
    input wire clk,
    input wire rst,
    input wire btn,
    output reg led
);

reg  [3:0] debouncing;

always @(posedge clk ) begin
    if(rst) begin
        led        <= 1'b0;
        debouncing <= 4'b0;
    end else begin
        led <= high_btn;
    end
end

always @(posedge clk ) begin
    debouncing <= {debouncing[2:0], btn};
end

wire posedge_btn, negedge_btn, high_btn;

assign high_btn    = &debouncing[3:2];
assign posedge_btn = (debouncing[2:1] == 2'b01) ? 1'b1 : 1'b0;
assign negedge_btn = (debouncing[2:1] == 2'b10) ? 1'b1 : 1'b0;

endmodule
