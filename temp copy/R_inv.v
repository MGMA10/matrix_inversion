module matrix3x3_upper_triangle_inverse #(parameter  N = 15 ,wordLength = 16,fractionLength = 12) (
    input clk,
    input reset,
    input start,
    input [wordLength-1:0] R11_in, R12_in, R13_in, // Input matrix elements
    input [wordLength-1:0] R22_in, R23_in,
    input [wordLength-1:0] R33_in,
    output reg [32:0] R11_inv, R12_inv, R13_inv, // Inverse matrix elements
    output reg [32:0] R22_inv, R23_inv,
    output reg [32:0] R33_inv,
    output reg done
);


        reg [wordLength-1:0] R11, R12, R13; // Input matrix elements
        reg [wordLength-1:0] R22, R23;
        reg [wordLength-1:0] R33;

    // State declaration
 parameter IDLE = 4'b0000,
        CALC_DET1 = 4'b0001, // Calculate determinant part 1
        CALC_DET2 = 4'b0010, // Calculate determinant part 2
        CALC_DET3 = 4'b0011, // Calculate determinant part 3
        INV_DET = 4'b0100, // Calculate 1/determinant
        ADJ_CALC_1 = 4'b0101, // Calculate adjugate elements part 1
        ADJ_CALC_2 = 4'b0110, // Calculate adjugate elements part 2
        ADJ_CALC_3 = 4'b0111, // Calculate adjugate elements part 3
        INVERSE_MATRIX = 4'b1000, // Calculate final inverse matrix
        DONE = 4'b1001; // Operation complete
  

    reg [3:0] state, next_state;

    // Intermediate registers
    reg [31:0] det_R;       // Determinant
    reg [31:0] det_inv;     // Inverse of the determinant
    reg [31:0] adj11, adj12, adj13; // Adjugate matrix elements
    reg [31:0] adj22, adj23;
    reg [31:0] adj33;

    // Sequential state update
    always @(posedge clk or negedge reset) begin
        if (!reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: if (start) next_state = CALC_DET1; else next_state = IDLE;
            CALC_DET1: next_state = CALC_DET2;
            CALC_DET2: next_state = CALC_DET3;
            CALC_DET3: next_state = INV_DET;
            INV_DET: next_state = ADJ_CALC_1;
            ADJ_CALC_1: next_state = ADJ_CALC_2;
            ADJ_CALC_2: next_state = ADJ_CALC_3;
            ADJ_CALC_3: next_state = INVERSE_MATRIX;
            INVERSE_MATRIX: next_state = DONE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output and Register Calculations
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset outputs and intermediate registers
            det_R <= 32'd0;
            det_inv <= 32'd0;
            adj11 <= 32'd0; adj12 <= 32'd0; adj13 <= 32'd0;
            adj22 <= 32'd0; adj23 <= 32'd0;
            adj33 <= 32'd0;
            R11_inv <= 32'd0; R12_inv <= 32'd0; R13_inv <= 32'd0;
            R22_inv <= 32'd0; R23_inv <= 32'd0;
            R33_inv <= 32'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE:begin
                    R11 <= R11_in;
                    R12 <= R12_in;
                    R13 <= R13_in; 
                    R22 <= R22_in;
                    R23 <= R23_in;
                    R33 <= R33_in;
                    done <= 1'b0;
                end
                CALC_DET1: begin
                    det_R <= R11 * R22; // Calculate R(1,1) * R(2,2)
                end
                CALC_DET2: begin
                    det_R <= det_R * R33; // Multiply by R(3,3)
                end
                CALC_DET3: begin
                    det_inv <= 32'd1 / det_R; // Inverse of the determinant
                end
                ADJ_CALC_1: begin
                    // Calculate adjugate matrix elements
                    adj11 <= R22 * R33;         // R(2,2)*R(3,3)
                    adj12 <= -R12 * R33;        // -R(1,2)*R(3,3)
                    adj13 <= R12 * R23 - R13 * R22; // R(1,2)*R(2,3) - R(1,3)*R(2,2)
                end
                ADJ_CALC_2: begin
                    adj22 <= R11 * R33;         // R(1,1)*R(3,3)
                    adj23 <= -R11 * R23;        // -R(1,1)*R(2,3)
                end
                ADJ_CALC_3: begin
                    adj33 <= R11 * R22;         // R(1,1)*R(2,2)
                end
                INVERSE_MATRIX: begin
                    // Multiply adjugate elements by 1/determinant
                    R11_inv <= adj11 * det_inv;
                    R12_inv <= adj12 * det_inv;
                    R13_inv <= adj13 * det_inv;
                    R22_inv <= adj22 * det_inv;
                    R23_inv <= adj23 * det_inv;
                    R33_inv <= adj33 * det_inv;
                end
                DONE: begin
                    done <= 1'b1; // Set done flag
                end
            endcase
        end
    end
endmodule
