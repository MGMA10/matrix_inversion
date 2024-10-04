module cordic_vectoring_fixed #(parameter  N = 15 ,wordLength = 16,fractionLength = 12)(
    input signed [wordLength-1:0] x_in,        // 16-bit input, fixed-point (5 integer bits, 12 fractional bits)
    input signed [wordLength-1:0] y_in,        // 16-bit input, fixed-point
    output reg signed [wordLength-1:0] x_out,  // 16-bit output, fixed-point
    output reg signed [wordLength-1:0] y_out,  // 16-bit output, fixed-point
    output reg signed [wordLength-1:0] theta,  // Angle result (16-bit fixed-point)
    input clk,                       // Clock signal
    input rst,                      // Reset signal
    output reg done,
    input valid
);

    // Internal variables
    reg signed [wordLength+2:0] x, y;          // Internal x and y registers
    reg signed [wordLength:0] atan_table [0:N];  // Precomputed arctangent values
    reg signed [wordLength-1:0] theta_internal;     // Internal theta register
    reg [4:0] i;                                    // Iteration counter
    reg signed [wordLength-1:0]  K = 16'b0000100110110111;  
    reg capt;
    reg [wordLength-1:0] zero;
    // Precompute the atan_table (hardcoded for 16-bit precision)
    initial begin
        atan_table[0]  = 16'b0010000000000000; // atan(2^0)   = 45.0000° = 0.785398 (fixed point 0x2000)
        atan_table[1]  = 16'b0001001011100100; // atan(2^-1)  = 26.5651° = 0.463648 (fixed point 0x12E4)
        atan_table[2]  = 16'b0000100111111010; // atan(2^-2)  = 14.0362° = 0.244979 (fixed point 0x09FA)
        atan_table[3]  = 16'b0000010100010001; // atan(2^-3)  = 7.1250°  = 0.124355 (fixed point 0x0511)
        atan_table[4]  = 16'b0000001010001011; // atan(2^-4)  = 3.5763°  = 0.062419 (fixed point 0x028B)
        atan_table[5]  = 16'b0000000101000101; // atan(2^-5)  = 1.7899°  = 0.031240 (fixed point 0x0145)
        atan_table[6]  = 16'b0000000010100010; // atan(2^-6)  = 0.8952°  = 0.0wordLength-1623 (fixed point 0x00A2)
        atan_table[7]  = 16'b0000000001010001; // atan(2^-7)  = 0.4476°  = 0.007812 (fixed point 0x0051)
        atan_table[8]  = 16'b0000000000101000; // atan(2^-8)  = 0.2238°  = 0.003906 (fixed point 0x0028)
        atan_table[9]  = 16'b0000000000010100; // atan(2^-9)  = 0.1119°  = 0.001953 (fixed point 0x0014)
        atan_table[10] = 16'b0000000000001010; // atan(2^-10) = 0.0560°  = 0.000977 (fixed point 0x000A)
        atan_table[11] = 16'b0000000000000101; // atan(2^-11) = 0.0280°  = 0.000488 (fixed point 0x0005)
        atan_table[12] = 16'b0000000000000010; // atan(2^-12) = 0.0140°  = 0.000244 (fixed point 0x0002)
        atan_table[13] = 16'b0000000000000010; // atan(2^-13) = 0.0070°  = 0.000122 (fixed point 0x0001)
        atan_table[14] = 16'b0000000000000001; // atan(2^-14) = 0.0035°  = 0.000061 (fixed point 0x0001)
        atan_table[15] = 16'b0000000000000001; // atan(2^-wordLength-1) = 0.0016°  = 0.000031 (fixed point 0x0000)
    
    end

    // Main CORDIC process (vectoring mode)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            x_out <= 16'b0;
            y_out <= 16'b0;
            theta <= 16'b0;
            x <= 16'b0;
            y <= 16'b0;
            theta_internal <= 16'b0;
            i <= 0;
            done <=0;
            capt<=1;
        end else
        if (valid)begin
         if (capt) begin
            // Initialize values at start of iteration
            y <= y_in;                  // Initialize y with the input
            theta_internal <= 16'b0;    // Initialize theta
            done <=0;
            capt<=0;
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
            else begin
             if (i < N) begin
                // Perform one iteration of CORDIC
             
                if (y > 0) begin
                    // Update x and y (shift by powers of 2 using right shifts)
                    x <= (x) + (y >>> i);  // Shift and subtract/add based on sigma
                    y <= y - ((x) >>> i);
                    // Update theta
                    theta_internal <= theta_internal + (atan_table[i]);
                end  // Rotate clockwise if y > 0
                else begin
                    // Update x and y (shift by powers of 2 using right shifts)
                    x <= (x) - (y >>> i);  // Shift and subtract/add based on sigma
                    y <= y + ((x) >>> i);
                    // Update theta
                    theta_internal <= theta_internal - (atan_table[i]);
                end        // Rotate counterclockwise if y <= 0     
                i <= i + 1;  // Inc rement iteration counter
            end else begin
                // Output final values after N N
                {zero,x_out} <= ((x * K) >>> ( fractionLength));        // Final x_out after N
                y_out <=0;         // Final y_out after N
                theta <= theta_internal;  // Final theta result
                i <= 0;              // Reset iteration counter
                done <=1;
            end
        end
    end
    else
    begin
        i <= 0;
        done <= 0;
        capt <= 1;
    end
    end
     
endmodule
