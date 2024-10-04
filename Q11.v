module rotation_matrix1 (
    input signed [15:0] cos1, sin1, // cos(θ1), sin(θ1)
    output signed [15:0] m11, m12, m13,  // First row of the matrix
    output signed [15:0] m21, m22, m23,  // Second row of the matrix
    output signed [15:0] m31, m32, m33   // Third row of the matrix
);

    // First row of the matrix
    assign m11 =    (cos1);
    assign m12 =    -(sin1) ;
    assign m13 =    0;

    // Second row of the matrix
    assign m21 = sin1;//(-sin1 * cos3) + (cos1 * sin2 * sin3);
    assign m22 = (cos1);
    assign m23 = 0 ;

    // Third row of the matrix
    assign m31 = 0;//(sin1 * sin3) + (cos1 * sin2 * cos3);
    assign m32 = 0;//(-cos1 * sin3) + (sin1 * sin2 * cos3);
    assign m33 = 16'h1000;

endmodule
