module matrix_multiply #(parameter WORDLEN=16 ,parameter FRACTION_WIDTH=12)
    (
    input signed [15:0] Q11, Q12, Q13, Q21, Q22, Q23, Q31, Q32, Q33,        // Qatrix
    input signed [15:0] P11, P12, P13, P21, P22, P23, P31, P32, P33,        // Patrix
    output reg signed [15:0] R11, R12, R13, R21, R22, R23, R31, R32, R33,    // Result matrix
    input clk,                       // Clock signal
    input rst,                      // Reset signal
    output reg done,
    input valid
);
			reg signed [WORDLEN-1:0]                                    matrix_in1 [2:0][2:0];
			reg signed [WORDLEN-1:0]                                    matrix_in2 [2:0][2:0];
			reg signed [(2*WORDLEN+2) - 1:0]                            matrix [2:0][2:0]    ;
			reg signed    [(2*WORDLEN) - 1:0]             Temp_reg1,Temp_reg2,Temp_reg3;  
            reg           [3:0]                             counter;
            reg                                             output_flag;
            reg calc;
always @(posedge clk) begin
    if (!rst) begin
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
		Temp_reg1       <= 'b0;
        Temp_reg2       <= 'b0;
        Temp_reg3       <= 'b0;
        counter         <= 'b0;
        output_flag     <= 'b0;
    end
    else if(valid)
    begin
        counter <= 'b0;
        calc <= 1;
        matrix_in1[0][0]<=Q11;
        matrix_in1[0][1]<=Q12;
        matrix_in1[0][2]<=Q13;
        matrix_in1[1][0]<=Q21;
        matrix_in1[1][1]<=Q22;
        matrix_in1[1][2]<=Q23;
        matrix_in1[2][0]<=Q31;
        matrix_in1[2][1]<=Q32;
        matrix_in1[2][2]<=Q33;

        done <= 0;

        matrix_in2[0][0]<=P11;
        matrix_in2[0][1]<=P12;
        matrix_in2[0][2]<=P13;
        matrix_in2[1][0]<=P21;
        matrix_in2[1][1]<=P22;
        matrix_in2[1][2]<=P23;
        matrix_in2[2][0]<=P31;
        matrix_in2[2][1]<=P32;
        matrix_in2[2][2]<=P33;
        end
                                                if (calc)
                                                    begin 
                                                        case (counter)
                                                        4'd0:   begin 
                                                            Temp_reg1     <= matrix_in1 [0][0] * matrix_in2 [0][0]; // A . M
                                                            Temp_reg2     <= matrix_in1 [0][1] * matrix_in2 [1][0]; // B . Z
                                                            Temp_reg3     <= matrix_in1 [0][2] * matrix_in2 [2][0]; // C . N
                                                            counter       <= counter + 1'd1 ;
                                                            end 
                                                        4'd1:   begin
                                                            matrix [0][0] <= Temp_reg1 + Temp_reg2 + Temp_reg3 ;    // i will take 12 + 15 : 12
                                                            Temp_reg1     <= matrix_in1 [0][0] * matrix_in2 [0][1]; // B . W
                                                            Temp_reg2     <= matrix_in1 [0][1] * matrix_in2 [1][1]; // C . G
                                                            Temp_reg3     <= matrix_in1 [0][2] * matrix_in2 [2][1]; // A . X
                                                            counter       <= counter + 1'd1 ;
                                                            end
                                                        4'd2:   begin 
                                                            matrix [0][1] <= Temp_reg1 + Temp_reg2 + Temp_reg3  ;    // i will take 12 + 15 : 12
                                                            Temp_reg1     <= matrix_in1 [0][0] * matrix_in2 [0][2];  // C . H                                                            Temp_reg2     <= matrix_in1 [0][0] * matrix_in2 [0][2];  // h
                                                            Temp_reg3     <= matrix_in1 [0][1] * matrix_in2 [1][2];  // B . U
                                                            Temp_reg2     <= matrix_in1 [0][2] * matrix_in2 [2][2];  // A . Y
                                                            counter       <= counter + 1'd1 ;
                                                            end
                                                        4'd3:   begin
                                                            matrix [0][2] <= Temp_reg1 + Temp_reg2 + Temp_reg3 ;
                                                            Temp_reg1     <= matrix_in1 [1][0] * matrix_in2 [0][0]; 
                                                            Temp_reg2     <= matrix_in1 [1][1] * matrix_in2 [1][0]; 
															Temp_reg3     <= matrix_in1 [1][2] * matrix_in2 [2][0];
                                                            counter       <= counter + 1'd1 ;
                                                            end
                                                        4'd4:   begin
                                                            matrix [1][0] <= Temp_reg1 + Temp_reg2+Temp_reg3  ; 
                                                            Temp_reg1     <= matrix_in1 [1][0] * matrix_in2 [0][1]; 
                                                            Temp_reg2     <= matrix_in1 [1][1] * matrix_in2 [1][1];
															Temp_reg3     <= matrix_in1 [1][2] * matrix_in2 [2][1];

                                                            counter       <= counter + 1'd1 ;
                                                            end
                                                        4'd5: begin 
                                                            matrix [1][1] <= Temp_reg1 + Temp_reg2+Temp_reg3;
                                                            Temp_reg1     <= matrix_in1 [1][0] * matrix_in2 [0][2]; 
                                                            Temp_reg2     <= matrix_in1 [1][1] * matrix_in2 [1][2];
															Temp_reg3     <= matrix_in1 [1][2] * matrix_in2 [2][2];
                                                            counter       <= counter + 1'd1 ;
                                                            end
                                                        4'd6: begin 
                                                            matrix [1][2] <= Temp_reg2 + Temp_reg1+Temp_reg3;
															Temp_reg1     <= matrix_in1 [2][0] * matrix_in2 [0][0]; 
                                                            Temp_reg2     <= matrix_in1 [2][1] * matrix_in2 [1][0];
															Temp_reg3     <= matrix_in1 [2][2] * matrix_in2 [2][0];
															counter       <= counter + 1'd1 ;

                                                        end 
														4'd7: begin 
                                                            matrix [2][0] <= Temp_reg2 + Temp_reg1+Temp_reg3;
															Temp_reg1     <= matrix_in1 [2][0] * matrix_in2 [0][1]; 
                                                            Temp_reg2     <= matrix_in1 [2][1] * matrix_in2 [1][1];
															Temp_reg3     <= matrix_in1 [2][2] * matrix_in2 [2][1];
															counter       <= counter + 1'd1 ;

                                                        end 
														4'd8: begin 
                                                            matrix [2][1] <= Temp_reg2 + Temp_reg1+Temp_reg3;
															Temp_reg1     <= matrix_in1 [2][0] * matrix_in2 [0][2]; 
                                                            Temp_reg2     <= matrix_in1 [2][1] * matrix_in2 [1][2];
															Temp_reg3     <= matrix_in1 [2][2] * matrix_in2 [2][2];
															counter       <= counter + 1'd1 ;

                                                            /*output_flag <= 1'b1 ;
                                                            calc    <= 1'b0 ;
                                                            counter     <= 4'd0 ;*/
                                                        end 
														4'd9: begin 
                                                            matrix [2][2] <= Temp_reg2 + Temp_reg1+Temp_reg3;
															
                                                            output_flag <= 1'b1 ;
                                                            calc    <= 1'b0 ;
                                                            counter     <= 4'd0 ;
                                                        end 
                                                      endcase 
                                                end 
                                                if (output_flag)begin
        R11 <= matrix[0][0][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R12 <= matrix[0][1][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R13 <= matrix[0][2][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R21 <= matrix[1][0][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R22 <= matrix[1][1][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R23 <= matrix[1][2][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R31 <= matrix[2][0][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R32 <= matrix[2][1][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        R33 <= matrix[2][2][WORDLEN + FRACTION_WIDTH - 1: FRACTION_WIDTH];
        done<=1'b1;
        output_flag<=1'b0;
end
end
endmodule


