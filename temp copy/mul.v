module matrix_multiplication(
    input  [16*9-1:0] A,  // Flattened 3x3 matrix A (9 elements, each 16 bits)
    input  [16*9-1:0] B,  // Flattened 3x3 matrix B (9 elements, each 16 bits)
    output reg [16*9-1:0] C  // Flattened 3x3 result matrix C (9 elements, each 32 bits)
);
    integer i, j, k;  // Declare loop variables

    reg [16:0] C_temp [0:8]; // Temporary storage for matrix C

    always @(*) begin
        // Initialize the result matrix to zero
        for (i = 0; i < 9; i = i + 1) begin
            C_temp[i] = 0;
        end
        
        // Perform matrix multiplication
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                for (k = 0; k < 3; k = k + 1) begin
                    C_temp[i * 3 + j] = C_temp[i * 3 + j] + 
                                        ((A[(i * 3 + k) * 16 +: 16] * B[(k * 3 + j) * 16 +: 16])>>>12);
                end
            end
        end
        
        // Flatten C_temp into a one-dimensional vector for the output C
        for (i = 0; i < 9; i = i + 1) begin
            C[i * 16 +: 16] = C_temp[i];
        end
    end

endmodule