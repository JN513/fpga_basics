module Seven_Segments #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire DP
);

// 7-segment display

localparam SECOND = CLK_FREQ;

reg [3:0] hex;
wire [6:0] seg;
reg [31:0] time_counter;

always @(posedge clk) begin
    if(!rst_n) begin
        hex          <= 4'h0;
        time_counter <= 32'h0;
    end else begin
        if(time_counter == SECOND) begin
            hex          <= hex + 1'b1;
            time_counter <= 32'h0;
        end else begin
            time_counter <= time_counter + 1'b1;
        end
    end
end

Decoder decoder (
    .hex(hex),
    .seg(seg)
);

assign CA = ~seg[0];
assign CB = ~seg[1];
assign CC = ~seg[2];
assign CD = ~seg[3];
assign CE = ~seg[4];
assign CF = ~seg[5];
assign CG = ~seg[6];
assign DP = 1'b1;
    
endmodule