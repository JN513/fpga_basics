module Calculator (
    input wire clk,
    input wire rst,

    input wire [3:0] switchs,

    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] S,

    output wire zero
);
    

ALU alu (
    .opcode(switchs),
    .A(A),
    .B(B),
    .S(S),
    .zero(zero)
);


endmodule
