module bin_to_bcd (
    input  [5:0] bin,   // Entrada binária de 6 bits
    output reg [3:0] bcd1, // Dígito menos significativo (unidades)
    output reg [3:0] bcd2  // Dígito mais significativo (dezenas)
);
    integer i;
    reg [7:0] temp; // 8 bits para armazenar os cálculos (6 bits + 2 bits extras)

    always @(*) begin
        // Inicializa variáveis
        temp = {2'b00, bin}; // Adiciona dois bits extras à esquerda
        bcd1 = 4'd0;
        bcd2 = 4'd0;

        // Algoritmo de deslocamento (Double Dabble)
        for (i = 5; i >= 0; i = i - 1) begin
            // Se algum dígito BCD for >= 5, soma 3
            if (bcd1 >= 5)
                bcd1 = bcd1 + 3;
            if (bcd2 >= 5)
                bcd2 = bcd2 + 3;

            // Desloca todos os bits para a esquerda
            {bcd2, bcd1, temp} = {bcd2, bcd1, temp} << 1;
        end
    end
endmodule
