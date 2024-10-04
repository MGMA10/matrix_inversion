module matrix_multiplier #(parameter  N = 15 ,wordLength = 16,fractionLength = 12) (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire signed [15:0] sin1, cos1, // Fixed-point representation of sin(theta1) and cos(theta1)
    input wire signed [15:0] sin2, cos2, // Fixed-point representation of sin(theta2) and cos(theta2)
    input wire signed [15:0] sin3, cos3, // Fixed-point representation of sin(theta3) and cos(theta3)
    output reg done,
    output reg signed [31:0] Q11, Q12, Q13, // Output matrix elements
    output reg signed [31:0] Q21, Q22, Q23,
    output reg signed [31:0] Q31, Q32, Q33
);



    // Stage 1: Compute the first row of the matrix
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q11 <= 0;
            Q12 <= 0;
            Q13 <= 0;
        end else if (valid) begin
            Q11 <= cos1 * cos2; // Q11 = cos1 * cos2
            Q12 <= -sin1 * cos3 + cos1 * sin2 * sin3; // Q12 = -sin1 * cos3 + cos1 * sin2 * sin3
            Q13 <= sin1 * sin3 + cos1 * sin2 * cos3; // Q13 = sin1 * sin3 + cos1 * sin2 * cos3
        end
    end

    // Stage 2: Compute the second row of the matrix
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q21 <= 0;
            Q22 <= 0;
            Q23 <= 0;
        end else if (valid) begin
            Q21 <= sin1 * cos2; // Q21 = sin1 * cos2
            Q22 <= cos1 * cos3 + sin1 * sin2 * sin3; // Q22 = cos1 * cos3 + sin1 * sin2 * sin3
            Q23 <= -cos1 * sin3 + sin1 * sin2 * cos3; // Q23 = -cos1 * sin3 + sin1 * sin2 * cos3
        end
    end

    // Stage 3: Compute the third row of the matrix
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q31 <= 0;
            Q32 <= 0;
            Q33 <= 0;
        end else if (valid) begin
            Q31 <= -sin2; // Q31 = -sin2
            Q32 <= cos2 * sin3; // Q32 = cos2 * sin3
            Q33 <= cos2 * cos3; // Q33 = cos2 * cos3
        end
    end

    // Final Stage: Assign output and valid signal
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q11 <= 0; Q12 <= 0; Q13 <= 0;
            Q21 <= 0; Q22 <= 0; Q23 <= 0;
            Q31 <= 0; Q32 <= 0; Q33 <= 0;
            done <= 0;
        end else if (valid) begin
            Q11 <= Q11; Q12 <= Q12; Q13 <= Q13;
            Q21 <= Q21; Q22 <= Q22; Q23 <= Q23;
            Q31 <= Q31; Q32 <= Q32; Q33 <= Q33;
            done <= 1;
        end
    end

endmodule
