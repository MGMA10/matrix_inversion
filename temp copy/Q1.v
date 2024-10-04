module rotation_matrix(
    input signed [15:0] cos1, sin1, // cos(θ1), sin(θ1)
    input signed [15:0] cos2, sin2, // cos(θ2), sin(θ2)
    input signed [15:0] cos3, sin3, // cos(θ3), sin(θ3)
    output signed [63:0] m11, m12, m13,  // First row of the matrix
    output signed [63:0] m21, m22, m23,  // Second row of the matrix
    output signed [63:0] m31, m32, m33   // Third row of the matrix
);

    // First row of the matrix
    assign m11 =    (cos1 * cos2);
    assign m12 =    -(sin1 * cos3 + (((cos1) * (sin2) * (sin3) >>> 12))) ;
    assign m13 =    sin1 * sin3 - ((cos1 * sin2 * cos3) >>> 12);

    // Second row of the matrix
    assign m21 = sin1 * cos2;//(-sin1 * cos3) + (cos1 * sin2 * sin3);
    assign m22 = (cos1 * cos3) - ((sin1 * sin2 * sin3) >>>12);
    assign m23 = - (cos1 * sin3 + ((sin1 * sin2 * cos3) >>>12)) ;

    // Third row of the matrix
    assign m31 = sin2;//(sin1 * sin3) + (cos1 * sin2 * cos3);
    assign m32 = cos2 * sin3;//(-cos1 * sin3) + (sin1 * sin2 * cos3);
    assign m33 = cos2 * cos3;

endmodule
