module Button_Modes #(
    parameter CLK_FREQ = 25_000_000 
) (
    input  wire clk,
    input  wire rst_n,
    input  wire btn,
    output  reg [7:0] leds
);

localparam ONE_SECOND          = CLK_FREQ;
localparam HALF_SECOND         = CLK_FREQ / 2;
localparam QUARTER_OF_A_SECOND = CLK_FREQ / 4;

localparam SHIFFTER        = 3'b000;
localparam COUNTER         = 3'b001;
localparam FIVES           = 3'b010;
localparam BLINK           = 3'b011;
localparam INVERSE_COUNTER = 3'b100;

reg [2:0]  state;
reg [7:0]  led_counter;
reg [31:0] counter;
reg button_pressed;

always @(posedge clk ) begin
    if(!rst_n) begin
        state       <= SHIFFTER;
        leds        <= 8'h1F;
        counter     <= 32'h0;
        led_counter <= 8'h0;
    end else begin
        case (state)
            SHIFFTER: begin
                if(counter >= QUARTER_OF_A_SECOND) begin
                    counter <= 1'b0;
                    leds    <= {leds[6:0], leds[7]};
                end else begin
                    counter <= counter + 1'b1;
                end

                if(button_pressed) begin
                    state   <= COUNTER;
                    leds    <= 8'h00;
                    counter <= 32'h0;
                end
            end
            COUNTER: begin
                if(counter >= HALF_SECOND) begin
                    counter <= 1'b0;
                    led_counter <= led_counter + 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                end

                leds <= led_counter;
                
                if(button_pressed) begin
                    state   <= FIVES;
                    leds    <= 8'h55;
                    counter <= 32'h0;
                end
            end
            FIVES: begin
                if(counter >= QUARTER_OF_A_SECOND) begin
                    counter <= 1'b0;
                    leds    <= {leds[6:0], leds[7]};
                end else begin
                    counter <= counter + 1'b1;
                end

                if(button_pressed) begin
                    state   <= BLINK;
                    leds    <= 8'hFF;
                    counter <= 32'h0;
                end
            end

            BLINK: begin
                if(counter >= HALF_SECOND) begin
                    counter <= 1'b0;
                    leds <= ~leds;
                end else begin
                    counter <= counter + 1'b1;
                end

                if(button_pressed) begin
                    state   <= INVERSE_COUNTER;
                    leds    <= 8'hFF;
                    counter <= 32'h0;
                end
            end

            INVERSE_COUNTER: begin
                if(counter >= HALF_SECOND) begin
                    counter <= 1'b0;
                    led_counter <= led_counter - 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                end

                leds <= led_counter;

                if(button_pressed) begin
                    state   <= SHIFFTER;
                    leds    <= 8'h1F;
                    counter <= 32'h0;
                end
            end

            default: begin
                state   <= SHIFFTER;
                leds    <= 8'h1F;
                counter <= 32'h0;
            end
        endcase
    end
end

reg [28:0] debouncing_counter;
reg btn_reg;

always @(posedge clk ) begin
    button_pressed <= btn;
    btn_reg        <= btn;

    if(!rst_n) begin
        debouncing_counter <= 21'h0;
    end else begin
        if(btn_reg) begin
            debouncing_counter <= debouncing_counter + 1'b1;
        end else begin
            debouncing_counter <= 21'h0;
        end

        if(debouncing_counter >= HALF_SECOND) begin
            debouncing_counter <= 21'h0;
            button_pressed     <= 1'b1;
        end
    end
end
    
endmodule
