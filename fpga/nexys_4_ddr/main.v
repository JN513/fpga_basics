module top #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,

    input wire CPU_RESETN,

    input wire BTNC,
    input wire BTNU,
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    
    input  wire [15:0] SW,
    output wire [15:0] LED,

    input  wire uart_tx,
    output wire uart_rx
);

`define BUTTON_MODES

`ifdef BLINKY // 001-blinky

wire led_temp;

Blinky #(
    .CLK_FREQ(CLK_FREQ)
) blinky (
    .clk  (clk),
    .rst_n(CPU_RESETN),
    .led  (led_temp)
);

assign LED = {15'h0, led_temp};

`elsif LED_COUNTER // 002-led_counter

wire [7:0] leds_temp;

Counter #(
    .CLK_FREQ(CLK_FREQ)
) counter (
    .clk  (clk),
    .rst_n(CPU_RESETN),
    .leds (leds_temp)
);

assign LED = {8'h00, leds_temp};

`elsif SHIFTER // 002-led_shifter

wire [7:0] leds_temp;

Shifter #(
    .CLK_FREQ(CLK_FREQ)
) shifter (
    .clk  (clk),
    .rst_n(CPU_RESETN),
    .leds (leds_temp)
);

assign LED = {8'h00, leds_temp};

`elsif BUTTON // 003-button

wire led_temp;

Button #(
    .CLK_FREQ(CLK_FREQ)
) button (
    .clk   (clk),
    .rst_n (CPU_RESETN),
    .btn   (BTNC),
    .led   (led_temp)
);

assign LED = {15'h0, led_temp};

`elsif HAMMING_CODE // 004-hamming_code

`elsif BUTTON_MODES // 005-button_modes

wire [7:0] leds_temp;

Button_Modes #(
    .CLK_FREQ(CLK_FREQ)
) button_modes (
    .clk   (clk),
    .rst_n (CPU_RESETN),
    .btn   (BTNC),
    .leds  (leds_temp)
);

assign LED = {8'h00, leds_temp};

`endif
    
endmodule