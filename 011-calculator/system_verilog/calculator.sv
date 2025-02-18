module Calculator (
    input  logic clk,
    input  logic rst_n,

    input  logic [3:0] switchs,

    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [7:0] S,

    output logic zero
);
    

ALU alu (
    .opcode (switchs[2:0]),
    .A      (A),
    .B      (B),
    .S      (S),
    .zero   (zero)
);


endmodule
