module Sum (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [7:0] S
);
    
assign S = A + B;

endmodule
