module cordic_fsm #(parameter  N = 15 ,wordLength = 16,fractionLength = 12)(
    input clk,
    input reset,
    input [wordLength-1:0] a_in, d_in, g_in, b_in, e_in, h_in, c_in, f_in, i_in,
    output reg [wordLength-1:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out, i_out,
    output reg done,
    input valid,
    output reg [wordLength-1:0] sin1,sin2,sin3,
    output reg [wordLength-1:0] cos1,cos2,cos3
);
    reg [wordLength-1:0] cordic_rotate_in1, cordic_rotate_in2, theta_cr;
    wire [wordLength-1:0] cordic_rotate_out1, cordic_rotate_out2;
    wire cordic_rotate_done ;
    reg rotating_start;

    cordic_rotation_fixed #(N, wordLength, fractionLength) dutcr1 (
        .x_in(cordic_rotate_in1),
        .y_in(cordic_rotate_in2),
        .theta_in(theta_cr),
        .x_out(cordic_rotate_out1),
        .y_out(cordic_rotate_out2),
        .clk(clk),
        .done(cordic_rotate_done),
        .valid(rotating_start),
        .rst(reset)
    );

    reg [wordLength-1:0] cordic_rotate1_in1, cordic_rotate1_in2,theta1_cr;
    wire [wordLength-1:0] cordic_rotate1_out1, cordic_rotate1_out2;
    wire cordic_rotate1_done ;
    reg rotating1_start;

    cordic_rotation_fixed #(N, wordLength, fractionLength) dutcr2 (
        .x_in(cordic_rotate1_in1),
        .y_in(cordic_rotate1_in2),
        .theta_in(theta1_cr),
        .x_out(cordic_rotate1_out1),
        .y_out(cordic_rotate1_out2),
        .clk(clk),
        .done(cordic_rotate1_done),
        .valid(rotating1_start),
        .rst(reset)
    );

    reg [wordLength-1:0] cordic_vector_in1, cordic_vector_in2;
    wire [wordLength-1:0] cordic_vector_out1, cordic_vector_out2, theta_cv;
    wire cordic_vector_done;
    reg vectoring_start;

    cordic_vectoring_fixed #(.N(N), .wordLength(wordLength), .fractionLength(fractionLength)) dutcv (
        .x_in(cordic_vector_in1),
        .y_in(cordic_vector_in2),
        .x_out(cordic_vector_out1),
        .y_out(cordic_vector_out2),
        .theta(theta_cv),
        .clk(clk),
        .rst(reset),
        .done(cordic_vector_done),
        .valid(vectoring_start)
      );

   
    parameter IDLE = 4'b0000, VECTOR_STAGE_1 = 4'b0001, ROTATE_STAGE_1_B_E = 4'b0010, VECTOR_STAGE_2 = 4'b0011,
    ROTATE_STAGE_2_B_H = 4'b0100, VECTOR_STAGE_3 = 4'b0101, ROTATE_STAGE_3_F_I = 4'b0110, DONE = 4'b111;

    reg [2:0] state, next_state;

    // Registers to hold matrix elements
    reg [wordLength-1:0] a, b, c, d, e, f, g, h, i;
    reg [wordLength-1:0] theta;  // Theta value computed by vectoring CORDIC
    
    // FSM State Register Update
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (!reset)
                    next_state = IDLE;
                else 
                if (!valid)
                    next_state = IDLE;
                    else 
                    next_state = VECTOR_STAGE_1;
            end

            VECTOR_STAGE_1: begin
                if (cordic_vector_done)
                    next_state = ROTATE_STAGE_1_B_E;
                else
                    next_state = VECTOR_STAGE_1;
            end

            ROTATE_STAGE_1_B_E: begin
                if (cordic_rotate_done)
                    next_state = VECTOR_STAGE_2;
                else
                    next_state = ROTATE_STAGE_1_B_E;
            end

            VECTOR_STAGE_2: begin
                if (cordic_vector_done)
                    next_state = ROTATE_STAGE_2_B_H;
                else
                    next_state = VECTOR_STAGE_2;
            end

            ROTATE_STAGE_2_B_H: begin
                if (cordic_rotate_done)
                    next_state = VECTOR_STAGE_3;
                else
                    next_state = ROTATE_STAGE_2_B_H;
            end

            VECTOR_STAGE_3: begin
                if (cordic_vector_done)
                    next_state = ROTATE_STAGE_3_F_I;
                else
                    next_state = VECTOR_STAGE_3;
            end

            ROTATE_STAGE_3_F_I: begin
                if (cordic_rotate_done)
                    next_state = DONE;
                else
                    next_state = ROTATE_STAGE_3_F_I;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // FSM Output Logic
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset outputs
            vectoring_start <= 0;
            rotating_start <= 0;
            a <= 0;
            b <= 0;
            c <= 0;
            d <= 0;
            e <= 0;
            f <= 0;
            g <= 0;
            h <= 0;
            i <= 0;
            done <= 0;
            a_out <= 0;
            b_out <= 0;
            c_out <= 0;
            d_out <= 0;
            e_out <= 0;
            f_out <= 0;
            g_out <= 0;
            h_out <= 0;
            i_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Load initial matrix values
                    a <= a_in;
                    b <= b_in;
                    c <= c_in;
                    d <= d_in;
                    e <= e_in;
                    f <= f_in;
                    g <= g_in;
                    h <= h_in;
                    i <= i_in;
                    done <= 0;
                end

                VECTOR_STAGE_1: begin
                    // Start vectoring CORDIC with 'a' and 'd'
                    cordic_vector_in1 <= a;
                    cordic_vector_in2 <= d;
                    vectoring_start <= 1;
                    if (cordic_vector_done) begin
                        // Update a and d
                        a <= cordic_vector_out1;  // New 'a'
                        d <= cordic_vector_out2;  // New 'd'
                        theta <= theta_cv;  // Store theta for later
                        vectoring_start <= 0;
                    end
                end

                ROTATE_STAGE_1_B_E: begin
                    // Start rotating CORDIC with 'b' and 'e'
                    cordic_rotate_in1 <= b;
                    cordic_rotate_in2 <= e;
                    theta_cr <= theta;
                    rotating_start <= 1;
                    if (cordic_rotate_done) begin
                        b <= cordic_rotate_out1;  // New 'b'
                        e <= cordic_rotate_out2;  // New 'e'
                        rotating_start <= 0;
                    end
                    cordic_rotate1_in1 <= c;
                    cordic_rotate1_in2 <= f;
                    theta1_cr <= theta;
                    rotating1_start <= 1;
                    if (cordic_rotate1_done) begin
                        c <= cordic_rotate1_out1;  // New 'c'
                        f <= cordic_rotate1_out2;  // New 'f'
                        rotating1_start <= 0;
                    end
                end

                VECTOR_STAGE_2: begin
                    // Vectoring for 'a' and 'g'
                    cordic_vector_in1 <= a;
                    cordic_vector_in2 <= g;
                    vectoring_start <= 1;
                    if (cordic_vector_done) begin
                        a <= cordic_vector_out1;
                        g <= cordic_vector_out2;
                        theta <= theta_cv;
                        vectoring_start <= 0;
                    end
                    
                    // Calculate sine and cos for Q
                    cordic_rotate_in1 <= 16'h1000;
                    cordic_rotate_in2 <= 16'h0000;
                    theta_cr <= -theta;
                    rotating_start <= 1;
                    if (cordic_rotate_done) begin
                        cos1 <= cordic_rotate_out1;
                        sin1 <= cordic_rotate_out2;
                        rotating_start <= 0;
                    end
                end

                ROTATE_STAGE_2_B_H: begin
                    // Rotating for 'b' and 'h'
                    cordic_rotate_in1 <= b;
                    cordic_rotate_in2 <= h;
                    theta_cr <= theta;
                    rotating_start <= 1;
                    if (cordic_rotate_done) begin
                        b <= cordic_rotate_out1;
                        h <= cordic_rotate_out2;
                        rotating_start <= 0;
                    end
                    // Rotating for 'c' and 'i'
                    cordic_rotate1_in1 <= c;
                    cordic_rotate1_in2 <= i;
                    theta1_cr <= theta;
                    rotating1_start <= 1;
                    if (cordic_rotate1_done) begin
                        c <= cordic_rotate1_out1;  // New 'c'
                        i <= cordic_rotate1_out2;  // New 'f'
                        rotating1_start <= 0;
                    end
                end

                VECTOR_STAGE_3: begin
                    // Vectoring for 'e' and 'h'
                    cordic_vector_in1 <= e;
                    cordic_vector_in2 <= h;
                    vectoring_start <= 1;
                    if (cordic_vector_done) begin
                        e <= cordic_vector_out1;
                        h <= cordic_vector_out2;
                        theta <= theta_cv;
                        vectoring_start <= 0;
                    end

                    // Calculate sine and cos for Q
                    cordic_rotate_in1 <= 16'h1000;
                    cordic_rotate_in2 <= 16'h0000;
                    theta_cr <= -theta;
                    rotating_start <= 1;
                    if (cordic_rotate_done) begin
                        cos2 <= cordic_rotate_out1;
                        sin2 <= cordic_rotate_out2;
                        rotating_start <= 0;
                    end
                end

                ROTATE_STAGE_3_F_I: begin
                    // Rotating for 'f' and 'i'
                    cordic_rotate_in1 <= f;
                    cordic_rotate_in2 <= i;
                    theta_cr <= theta;
                    rotating_start <= 1;
                    if (cordic_rotate_done) begin
                        f <= cordic_rotate_out1;
                        i <= cordic_rotate_out2;
                        rotating_start <= 0;
                    end
                    // Calculate sine and cos for Q
                    cordic_rotate1_in1 <= 16'h1000;
                    cordic_rotate1_in2 <= 16'h0000;
                    theta1_cr <= -theta;
                    rotating1_start <= 1;
                    if (cordic_rotate1_done) begin
                        cos3 <= cordic_rotate1_out1;  // New 'c'
                        sin3 <= cordic_rotate1_out2;  // New 'f'
                        rotating1_start <= 0;
                    end
                end


                DONE: begin
                    // Final outputs
                    a_out <= a;
                    b_out <= b;
                    c_out <= c;
                    d_out <= d;
                    e_out <= e;
                    f_out <= f;
                    g_out <= g;
                    h_out <= h;
                    i_out <= i;
                    done <= 1;
                end
            endcase
        end
    end
endmodule
