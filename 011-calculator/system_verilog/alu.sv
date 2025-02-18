module ALU (
    input  logic [2:0] opcode,
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [7:0] S,
    output logic   zero
);

typedef enum logic [2:0] { 
    AND = 3'b000,
    OR  = 3'b001,
    ADD = 3'b010,
    SUB = 3'b011,
    XOR = 3'b100,
    NOT = 3'b101
} alu_opcode_t;

assign zero = (|S);

always_comb begin
    case (alu_opcode_t'(opcode))
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
