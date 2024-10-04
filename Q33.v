module rotation_matrix3(
    input signed [15:0] cos3, sin3, // cos(θ1), sin(θ1)
    output signed [15:0] P11, P12, P13,  // First row of the Patrix
    output signed [15:0] P21, P22, P23,  // Second row of the Patrix
    output signed [15:0] P31, P32, P33   // Third row of the Patrix
);

    // First row of the Patrix
    assign P11 =    16'h1000;
    assign P12 =    0;
    assign P13 =    0;

    // Second row of the Patrix
    assign P21 = 0;//(-sin1 * cos3) + (cos3 * sin3 * sin3);
    assign P22 = (cos3);
    assign P23 = -(sin3);

    // Third row of the Patrix
    assign P31 = 0;//(sin1 * sin3) + (cos3 * sin3 * cos3);
    assign P32 = sin3;//(-cos3 * sin3) + (sin1 * sin3 * cos3);
    assign P33 = (cos3);

endmodule
