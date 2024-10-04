module rotation_matrix2(
    input signed [15:0] cos2, sin2, // cos(θ1), sin(θ1)
    output signed [15:0] Q11, Q12, Q13,  // First row of the Qatrix
    output signed [15:0] Q21, Q22, Q23,  // Second row of the Qatrix
    output signed [15:0] Q31, Q32, Q33   // Third row of the Qatrix
);

    // First row of the Qatrix
    assign Q11 =    (cos2);
    assign Q12 =    0;
    assign Q13 =    -(sin2);

    // Second row of the Qatrix
    assign Q21 = 0;//(-sin1 * cos3) + (cos1 * sin2 * sin3);
    assign Q22 = 16'h1000;
    assign Q23 = 0;

    // Third row of the Qatrix
    assign Q31 = sin2;//(sin1 * sin3) + (cos1 * sin2 * cos3);
    assign Q32 = 0;//(-cos1 * sin3) + (sin1 * sin2 * cos3);
    assign Q33 = (cos2);

endmodule
