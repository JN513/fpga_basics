module HammingCode (
    input  wire [3:0] data_in,
    output wire [7:0] data_out
);

assign data_out = {
    data_in[3],
    data_in[2],
    data_in[1],
    data_in[1] ^ data_in[2] ^ data_in[3],
    data_in[0],
    data_in[0] ^ data_in[2] ^ data_in[3],
    data_in[0] ^ data_in[1] ^ data_in[3]
};
    
endmodule