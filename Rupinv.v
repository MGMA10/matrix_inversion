module inv_3x3_upper_triangular (
    input signed [15:0] a11, a12, a13,
    input signed [15:0] a22, a23,
    input signed [15:0] a33,
    output reg signed [15:0] inv_a11, inv_a12, inv_a13,
    output reg signed [15:0] inv_a22, inv_a23,
    output reg signed [15:0] inv_a33,
    input clk,    
    input rst,           
    output reg done,
    input valid,
    output Error
);
    // Intermediate variables for calculations
reg signed [15:0] inv_a11_full, inv_a22_full, inv_a33_full;
reg signed [31:0] inv_a12_full, inv_a13_full, inv_a23_full , temp1,temp2,temp3,temp4,temp5,temp6;
reg [2:0] calc;
wire done1,done2,done3;
wire [15:0] quotient1,quotient2,quotient3;
wire Error1,Error2,Error3;
assign Error = Error1 | Error2 | Error3;
always @(posedge clk or negedge rst) begin
    done <= 0;
    if (!rst) begin
        inv_a11 <= 0;
        inv_a12 <= 0;
        inv_a13 <= 0;
        inv_a22 <= 0;
        inv_a23 <= 0;
        inv_a33 <= 0;
        inv_a11_full <= 0;
        inv_a22_full <= 0;
        inv_a33_full <= 0;
        inv_a12_full <= 0;
        inv_a13_full <= 0;
        inv_a23_full <= 0;
        calc <= 0;
        done <= 0;
    end
    else if(done1 && done2 && done3)
    begin
            inv_a11_full <= quotient1;
            inv_a22_full <= quotient2;
            inv_a33_full <= quotient3;
            calc<=1;
    end
        else if (calc == 1)
        begin
            // Fixed point calculations for off-diagonal elements
            temp1 <= (inv_a11_full * inv_a22_full) >>> 12;
            temp2 <= (inv_a22_full * inv_a33_full) >>> 12;
            temp3 <= (a12 * a23) >>> 12 ;
            temp4 <= (a13 * a22) >>> 12 ;
        calc <= 2;
        end
        else if (calc==2)
        begin
            inv_a12_full <= -((a12 * temp1) >>> 12);  // -a12 / (a11 * a22)
            inv_a23_full <= -((a23 * temp2)>>> 12);  // -a23 / (a22 * a33)
            temp5 <= (temp1 * inv_a33_full) >>> 12;
            temp6 <= (temp3 - temp4);
            calc <= 3;
        end
    else if (calc==3)
    begin
        inv_a13_full <= (temp6 * temp5 ) >>> 12;
        calc <= 4;
    end
    else if (calc==4) begin
        //inv_a13_full <= ((temp3 - temp4) * temp5 ) >>> 12 ;  // (a12 * a23 - a13 * a22) / (a11 * a22 * a33)
         inv_a11 <= inv_a11_full;
        inv_a12 <= inv_a12_full;
        inv_a13 <= inv_a13_full;
        inv_a22 <= inv_a22_full;
        inv_a23 <= inv_a23_full;
        inv_a33 <= inv_a33_full;
        done <= 1;
        calc <= 0;
    end

        
end

cordic_div #(.WORD_LENGTH(16), .FRACTION_LENGTH(12), .N(15)) 
    DUT1 (
        .clk(clk),
        .reset(rst),
        .start(valid),
        .numerator(a11),
        .denominator(16'h1000 ),
        .quotient(quotient1),
        .done(done1),
        .Error(Error1)
    );
    cordic_div #(.WORD_LENGTH(16), .FRACTION_LENGTH(12), .N(15)) 
    DUT2 (
        .clk(clk),
        .reset(rst),
        .start(valid),
        .numerator(a22),
        .denominator(16'h1000 ),
        .quotient(quotient2),
        .done(done2),
        .Error(Error2)
    );
    cordic_div #(.WORD_LENGTH(16), .FRACTION_LENGTH(12), .N(15)) 
    DUT3 (
        .clk(clk),
        .reset(rst),
        .start(valid),
        .numerator(a33),
        .denominator(16'h1000),
        .quotient(quotient3),
        .done(done3),
        .Error(Error3)
    );
endmodule
