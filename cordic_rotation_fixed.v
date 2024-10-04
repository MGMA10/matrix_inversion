module cordic_rotation_fixed #(parameter  N = 15 ,wordLength = 16,fractionLength = 12)(
    input clk, rst, 
    input valid,
    input signed [wordLength-1:0] x_in, y_in, theta_in,                     // 17-bit fixed-point inputs
    output reg signed [wordLength-1:0] x_out, y_out,               // 17-bit fixed-point outputs
                                                            // Clock and reset signals
    
    output reg done
);
    
    // Internal registers for the CORDIC variables
    reg signed [wordLength-1:0] x, y, z;
    reg signed [wordLength-1:0] atan_table [0:15];                          // LUT for atan values (arctan(2^(-i)))
    reg signed [wordLength-1:0]  K = 16'b0000100110110111;                  // Scaling factor// K = 1 / prod(sqrt(1 + 2^(-2j))) for j = 0 to N-1
    reg capt;
    reg [wordLength-1:0] zero;
    // Precompute the atan table (initialize the arctangent values)
    initial begin
        atan_table[0]  = 16'b0010000000000000; // atan(2^0)   = 45.0000° = 0.785398 (fixed point 0x2000)
        atan_table[1]  = 16'b0001001011100100; // atan(2^-1)  = 26.5651° = 0.463648 (fixed point 0x12E4)
        atan_table[2]  = 16'b0000100111111011; // atan(2^-2)  = 14.0362° = 0.244979 (fixed point 0x09FA)
        atan_table[3]  = 16'b0000010100010001; // atan(2^-3)  = 7.1250°  = 0.124355 (fixed point 0x0511)
        atan_table[4]  = 16'b0000001010001011; // atan(2^-4)  = 3.5763°  = 0.062419 (fixed point 0x028B)
        atan_table[5]  = 16'b0000000101000110; // atan(2^-5)  = 1.7899°  = 0.031240 (fixed point 0x0145)
        atan_table[6]  = 16'b0000000010100011; // atan(2^-6)  = 0.8952°  = 0.015623 (fixed point 0x00A2)
        atan_table[7]  = 16'b0000000001010001; // atan(2^-7)  = 0.4476°  = 0.007812 (fixed point 0x0051)
        atan_table[8]  = 16'b0000000000101001; // atan(2^-8)  = 0.2238°  = 0.003906 (fixed point 0x0028)
        atan_table[9]  = 16'b0000000000010100; // atan(2^-9)  = 0.1119°  = 0.001953 (fixed point 0x0014)
        atan_table[10] = 16'b0000000000001010; // atan(2^-10) = 0.0560°  = 0.000977 (fixed point 0x000A)
        atan_table[11] = 16'b0000000000000101; // atan(2^-11) = 0.0280°  = 0.000488 (fixed point 0x0005)
        atan_table[12] = 16'b0000000000000011; // atan(2^-12) = 0.0140°  = 0.000244 (fixed point 0x0002)
        atan_table[13] = 16'b0000000000000001; // atan(2^-13) = 0.0070°  = 0.000122 (fixed point 0x0001)
        atan_table[14] = 16'b0000000000000001; // atan(2^-14) = 0.0035°  = 0.000061 (fixed point 0x0001)
       
    end
    
    // CORDIC Rotation algorithm
    reg [4:0] counter;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset all values
            x <= x_in;
            y <= y_in;
            z <= -theta_in;
            x_out <= 0;
            y_out <= 0;
            counter <= 0;
            done <=0;
            capt <= 1;
        end else 
        if (valid)begin
        if (capt)begin
            // Initialize x, y, and z with input values
            x <= x_in;
            y <= y_in;
            z <= theta_in;
            capt <= 0;
            done <= 0;
            if(x_in[wordLength-1])
            begin
                x <= -x_in;                 // Initialize x with the input
                K <= -16'b0000100110110111;
            end
            else
                begin
                    x <= x_in;                 // Initialize x with the input
                    K <= 16'b0000100110110111;
                end
        end
        else
        begin                        
            // Iteration loop for N cycles
            if (counter < N) begin
                if (z < 0) begin
                    // Perform the shift-add for positive sigma
                    x <= x - (y >>> counter);                   // Shift right by i
                    y <= y + (x >>> counter);
                    z <= z + atan_table[counter];               // Add atan(2^-i)
                end else begin
                    // Perform the shift-add for negative sigma
                    x <= x + (y >>> counter);
                    y <= y - (x >>> counter);
                    z <= z - (atan_table[counter]);            // Subtract atan(2^-i)
                end
                counter <= counter + 1;
                done <= 0;
                {x_out} <= x ; 
            end
            else
            begin
            // Apply scaling factor K
            { zero,x_out } <= ((x * K) >>> ( fractionLength));         // Final x_out after N
            { zero,y_out } <= ((y * K) >>> ( fractionLength)); 
            done <= 1;
            counter <= 0;
        end
    end
    end
    else
    begin
        counter <= 0;
        done <= 0;
        capt <= 1;
    end
    end
endmodule
