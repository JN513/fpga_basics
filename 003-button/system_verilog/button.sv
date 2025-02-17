module Button #(
    parameter CLK_FREQ = 25_000_000 
) (
    input  logic clk,
    input  logic rst_n,
    input  logic btn,
    output logic led
);

    logic [2:0] debouncing;
    logic posedge_btn, negedge_btn, high_btn;

    // Bloco de controle do led
    always_ff @(posedge clk or negedge rst_n) begin // rst_n assinclono
        if (!rst_n) begin
            led <= 1'b0;
        end else begin
            led <= high_btn;
        end
    end

    // Bloco de debouncing do botão
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debouncing <= 3'b000;
        end else begin
            debouncing <= {debouncing[1:0], btn};
        end
    end

    // Assignments para detecção de bordas
    assign high_btn    = &debouncing[2:1];
    assign posedge_btn = (debouncing[2:1] == 2'b01);
    assign negedge_btn = (debouncing[2:1] == 2'b10);

endmodule
