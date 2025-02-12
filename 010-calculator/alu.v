module ALU (
    input wire [2:0] opcode,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] S,
    output wire   zero
);

localparam AND = 3'b000;
localparam OR  = 3'b001;
localparam ADD = 3'b010;
localparam SUB = 3'b011;
localparam XOR = 3'b100;
localparam NOT = 3'b101;

assign zero = (|S);

always @(*) begin
    case (opcode)
        AND: S = A & B;
        OR:  S = A | B;
        ADD: S = A + B;
        SUB: S = A - B;
        XOR: S = A ^ B;
        NOT: S = ~A;
        default: S = A;
    endcase
end

endmodule
