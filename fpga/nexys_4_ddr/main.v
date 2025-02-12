module top #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,

    input wire CPU_RESETN, // reset

    // BTNs
    input wire BTNC,
    input wire BTNU,
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    
    // SWs and LEDs
    input  wire [15:0] SW,
    output wire [15:0] LED,

    // UART
    input  wire uart_tx,
    output wire uart_rx,

    // 7-segment display
    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire DP,

    output wire [7:0] AN, // 7-segment display anodes

    // VGA
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS

);

`define CLOCK

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

`elsif CLOCK

Clock #(
    .CLK_FREQ(CLK_FREQ)
) clock (
    .clk  (clk),
    .rst_n(CPU_RESETN),
    .BTNC (BTNC),
    .BTNU (BTNU),
    .BTND (BTND),
    .CA   (CA),
    .CB   (CB),
    .CC   (CC),
    .CD   (CD),
    .CE   (CE),
    .CF   (CF),
    .CG   (CG),
    .DP   (DP),
    .AN   (AN)
);

`endif
    
endmodule