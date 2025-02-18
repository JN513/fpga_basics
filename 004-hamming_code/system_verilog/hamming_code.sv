module HammingCode (
    input  logic [3:0] data_in,
    output logic [6:0] data_out
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