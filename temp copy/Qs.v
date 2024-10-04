module rotation_matrix_fixed #(
    parameter i = 1,
    parameter j = 2,
    parameter size = 3,              // Size of the matrix (3x3 for example)
    parameter wordLength = 16,
    parameter fractionLength = 12
)(
    input signed [15:0] cos,          // cos(θ1)
    input signed [15:0] sin,          // sin(θ1)
    output reg signed [(wordLength*size*size)-1:0] Q  // Flattened output rotation matrix
);

    integer m, n;
    
    // Rotation matrix calculation
    always @(*) begin
        // Initialize the identity matrix
        for (m = 0; m < size; m = m + 1) begin
            for (n = 0; n < size; n = n + 1) begin
                if (m == n)
                    Q[(m*size + n)*wordLength +: wordLength] = 16'd1 << fractionLength;  // Fixed-point representation of 1
                else
                    Q[(m*size + n)*wordLength +: wordLength] = 16'd0;
            end
        end

        // Update matrix Q with rotation values
        Q[(i*size + i)*wordLength +: wordLength] = cos;
        Q[(i*size + j)*wordLength +: wordLength] = -sin;
        Q[(j*size + i)*wordLength +: wordLength] = sin;
        Q[(j*size + j)*wordLength +: wordLength] = cos;
    end

endmodule
