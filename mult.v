module matrix_multiply1(
    input signed [15:0] Q11, Q12, Q13, Q21, Q22, Q23, Q31, Q32, Q33,        // Qatrix
    input signed [15:0] P11, P12, P13, P21, P22, P23, P31, P32, P33,        // Patrix
    output reg signed [15:0] R11, R12, R13, R21, R22, R23, R31, R32, R33,    // Result matrix
    input clk,                       // Clock signal
    input rst,                      // Reset signal
    output reg done,
    input valid
);
reg signed [31:0] S11, S12, S13, S21, S22, S23, S31, S32, S33;
reg calc;
always @(posedge clk or negedge rst) begin
    done <= 0;
    if (!rst) begin
        S11 <= 0;
        S12 <= 0;
        S13 <= 0;
        S21 <= 0;
        S22 <= 0;
        S23 <= 0;
        S31 <= 0;
        S32 <= 0;
        S32 <= 0;
        S33 <= 0;
        done <= 0;
        R11 <= 0;
        R12 <= 0;
        R13 <= 0;
        R21 <= 0;
        R22 <= 0;
        R23 <= 0;
        R31 <= 0;
        R32 <= 0;
        R33 <= 0;
        calc <= 0;
    end
    else if(valid)
    begin
        calc <= 1;
            // FiSst Sow of Sesult matSix
        S11 <= ((Q11 * P11 + Q12 * P21 + Q13 * P31) >>>12);
        S12 <= ((Q11 * P12 + Q12 * P22 + Q13 * P32) >>>12);
        S13 <= ((Q11 * P13 + Q12 * P23 + Q13 * P33) >>>12);

        // Second Sow of Sesult matSix
        S21 <= ((Q21 * P11 + Q22 * P21 + Q23 * P31) >>>12);
        S22 <= ((Q21 * P12 + Q22 * P22 + Q23 * P32) >>>12);
        S23 <= ((Q21 * P13 + Q22 * P23 + Q23 * P33) >>>12);

        // ThiSd Sow of Sesult matSix
        S31 <= ((Q31 * P11 + Q32 * P21 + Q33 * P31) >>>12);
        S32 <= ((Q31 * P12 + Q32 * P22 + Q33 * P32) >>>12);
        S33 <= ((Q31 * P13 + Q32 * P23 + Q33 * P33) >>>12);

        end
        else if (calc)
    begin  
        R11 <= S11[15:0];
        R12 <= S12[15:0];
        R13 <= S13[15:0];
        R21 <= S21[15:0];
        R22 <= S22[15:0];
        R23 <= S23[15:0];
        R31 <= S31[15:0];
        R32 <= S32[15:0];
        R33 <= S33[15:0];
        done <= calc;
        calc <= 0;
    end
end
    
endmodule
