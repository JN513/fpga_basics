module Clock #(
    parameter CLK_FREQ = 25_000_000 
) (
    input wire clk,
    input wire rst_n,

    input wire BTNU, // Increment
    input wire BTND, // Decrement

    input wire BTNC, // Select minute, hour, or second

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

localparam ONE_SECOND          = CLK_FREQ;
localparam HALF_SECOND         = CLK_FREQ / 2;
localparam QUARTER_OF_A_SECOND = CLK_FREQ / 4;

// Clock counters

reg [27:0] time_counter;
reg [5:0] second_counter;
reg [5:0] minute_counter;
reg [5:0] hour_counter;

always @(posedge clk ) begin
    if(!rst_n) begin
        time_counter <= 28'b0;
        second_counter <= 6'b0;
        minute_counter <= 6'b0;
        hour_counter <= 6'b0;
    end else begin
        if(btnu_pressed) begin
            case (increment_mode)
                INCLEMENT_SECOND: begin
                    second_counter <= second_counter + 1'b1;
                end
                INCLEMENT_MINUTE: begin
                    minute_counter <= minute_counter + 1'b1;
                end
                INCLEMENT_HOUR: begin
                   hour_counter <= hour_counter + 1'b1;
                end
            endcase 
        end else if(btnd_pressed) begin
            case (increment_mode)
                INCLEMENT_SECOND: begin
                    second_counter <= second_counter - 1'b1;
                end
                INCLEMENT_MINUTE: begin
                    minute_counter <= minute_counter - 1'b1;
                end
                INCLEMENT_HOUR: begin
                   hour_counter <= hour_counter - 1'b1;
                end
            endcase
        end

        if(time_counter == ONE_SECOND) begin
            time_counter <= 28'b0;
            second_counter <= second_counter + 1'b1;
        end else begin
            time_counter <= time_counter + 1'b1;
        end

        if(second_counter == 'd59) begin
            second_counter <= 6'b0;
            minute_counter <= minute_counter + 1'b1;
        end

        if(minute_counter == 'd59) begin
            minute_counter <= 6'b0;
            hour_counter <= hour_counter + 1'b1;
        end

        if(hour_counter >= 'd23) begin
            hour_counter <= 6'b0;
        end
    end
end

// Decoders

wire [3:0] second_units_bcd, second_tens_bcd;
wire [3:0] minute_units_bcd, minute_tens_bcd;
wire [3:0] hour_units_bcd, hour_tens_bcd;

bin_to_bcd U1(
    .bin(second_counter),
    .bcd1(second_units_bcd),
    .bcd2(second_tens_bcd)
);

bin_to_bcd U2(
    .bin(minute_counter),
    .bcd1(minute_units_bcd),
    .bcd2(minute_tens_bcd)
);

bin_to_bcd U3(
    .bin(hour_counter),
    .bcd1(hour_units_bcd),
    .bcd2(hour_tens_bcd)
);

wire [6:0] second_units_seg, second_tens_seg;
wire [6:0] minute_units_seg, minute_tens_seg;
wire [6:0] hour_units_seg, hour_tens_seg;

Decoder U4(
    .hex(second_units_bcd),
    .seg(second_units_seg)
);

Decoder U5(
    .hex(second_tens_bcd),
    .seg(second_tens_seg)
);

Decoder U6(
    .hex(minute_units_bcd),
    .seg(minute_units_seg)
);

Decoder U7(
    .hex(minute_tens_bcd),
    .seg(minute_tens_seg)
);

Decoder U8(
    .hex(hour_units_bcd),
    .seg(hour_units_seg)
);

Decoder U9(
    .hex(hour_tens_bcd),
    .seg(hour_tens_seg)
);

// Inclement mode state machine

localparam INCLEMENT_SECOND = 2'b00;
localparam INCLEMENT_MINUTE = 2'b01;
localparam INCLEMENT_HOUR   = 2'b10;

reg [1:0] increment_mode;

always @(posedge clk ) begin
    if(!rst_n) begin
        increment_mode <= INCLEMENT_SECOND;
    end else begin
        if(btnc_pressed) begin
            increment_mode <= increment_mode + 1'b1;
        end

        if(increment_mode >= INCLEMENT_HOUR) begin
            increment_mode <= INCLEMENT_SECOND;
        end
    end
end

// Button debouncing

reg [28:0] btnu_debouncing_counter, 
    btnd_debouncing_counter, btnc_debouncing_counter;

reg btnu_reg, btnd_reg, btnc_reg;
reg btnu_pressed, btnd_pressed, btnc_pressed;

always @(posedge clk ) begin
    btnu_reg <= BTNU;
    btnd_reg <= BTND;
    btnc_reg <= BTNC;

    if(!rst_n) begin
        btnu_debouncing_counter <= 29'b0;
        btnd_debouncing_counter <= 29'b0;
        btnc_debouncing_counter <= 29'b0;
    end else begin
        if(btnu_reg) begin
            btnu_debouncing_counter <= btnu_debouncing_counter + 1;
        end else begin
            btnu_debouncing_counter <= 29'b0;
        end

        if(btnd_reg) begin
            btnd_debouncing_counter <= btnd_debouncing_counter + 1;
        end else begin
            btnd_debouncing_counter <= 29'b0;
        end

        if(btnc_reg) begin
            btnc_debouncing_counter <= btnc_debouncing_counter + 1;
        end else begin
            btnc_debouncing_counter <= 29'b0;
        end

        if(btnu_debouncing_counter >= HALF_SECOND) begin
            btnu_pressed <= 1;
        end else begin
            btnu_pressed <= 0;
        end

        if(btnd_debouncing_counter >= HALF_SECOND) begin
            btnd_pressed <= 1;
        end else begin
            btnd_pressed <= 0;
        end

        if(btnc_debouncing_counter >= HALF_SECOND) begin
            btnc_pressed <= 1;
        end else begin
            btnc_pressed <= 0;
        end
    end
end

// Multiplexer

seg_multiplexer U10(
    .clk(clk),
    .rst_n(rst_n),

    .second_units_seg(second_units_seg),
    .second_tens_seg(second_tens_seg),
    .minute_units_seg(minute_units_seg),
    .minute_tens_seg(minute_tens_seg),
    .hour_units_seg(hour_units_seg),
    .hour_tens_seg(hour_tens_seg),

    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP),

    .AN(AN)
);

endmodule
