module seg_multiplexer (
    input wire clk,
    input wire rst_n,

    input wire [6:0] second_units_seg,
    input wire [6:0] second_tens_seg,
    input wire [6:0] minute_units_seg,
    input wire [6:0] minute_tens_seg,
    input wire [6:0] hour_units_seg,
    input wire [6:0] hour_tens_seg,

    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire DP,

    output wire [7:0] AN
);

localparam SET_SECOND_UNITS = 3'b000;
localparam SET_SECOND_TENS  = 3'b001;
localparam SET_MINUTE_UNITS = 3'b010;
localparam SET_MINUTE_TENS  = 3'b011;
localparam SET_HOUR_UNITS   = 3'b100;
localparam SET_HOUR_TENS    = 3'b101;

localparam WAIT_CICLES = 12'd300000;

reg [2:0] state;

reg [6:0] second_units;
reg [6:0] second_tens;
reg [6:0] minute_units;
reg [6:0] minute_tens;
reg [6:0] hour_units;
reg [6:0] hour_tens;

reg [7:0] AN_reg;
reg [6:0] C_reg;
reg DP_reg;

reg [11:0] time_counter;

always @(posedge clk ) begin
    second_units <= second_units_seg;
    second_tens <= second_tens_seg;
    minute_units <= minute_units_seg;
    minute_tens <= minute_tens_seg;
    hour_units <= hour_units_seg;
    hour_tens <= hour_tens_seg;

    if(!rst_n) begin
        state        <= SET_SECOND_UNITS;
        AN_reg       <= 8'b11111111;
        C_reg        <= 7'b0000000;
        DP_reg       <= 1'b0;
        time_counter <= 12'd0;
    end else begin
        case (state)
            SET_SECOND_UNITS: begin
                AN_reg <= 8'b11111110;
                C_reg  <= second_units;
                DP_reg <= 1'b0;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_SECOND_TENS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            SET_SECOND_TENS: begin
                AN_reg <= 8'b11111101;
                C_reg  <= second_tens;
                DP_reg <= 1'b0;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_MINUTE_UNITS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            SET_MINUTE_UNITS: begin
                AN_reg <= 8'b11111011;
                C_reg  <= minute_units;
                DP_reg <= 1'b0;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_MINUTE_TENS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            SET_MINUTE_TENS: begin
                AN_reg <= 8'b11110111;
                C_reg  <= minute_tens;
                DP_reg <= 1'b0;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_HOUR_UNITS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            SET_HOUR_UNITS: begin
                AN_reg <= 8'b11101111;
                C_reg  <= hour_units;
                DP_reg <= 1'b1;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_HOUR_TENS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            SET_HOUR_TENS: begin
                AN_reg <= 8'b11011111;
                C_reg  <= hour_tens;
                DP_reg <= 1'b0;

                if(time_counter >= WAIT_CICLES) begin
                    time_counter <= 12'd0;
                    state        <= SET_SECOND_UNITS;
                end else begin
                    time_counter <= time_counter + 1;
                end
            end
            default: state <= SET_SECOND_UNITS;
        endcase
    end
end
    
assign CA = ~C_reg[0];
assign CB = ~C_reg[1];
assign CC = ~C_reg[2];
assign CD = ~C_reg[3];
assign CE = ~C_reg[4];
assign CF = ~C_reg[5];
assign CG = ~C_reg[6];
assign DP = ~DP_reg;

assign AN = AN_reg;

endmodule