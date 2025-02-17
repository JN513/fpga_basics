module Sum (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [7:0] S
);
    
assign S = A + B;

endmodule
