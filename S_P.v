module serial_parallel_interface (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
    input wire start,             // Start signal to initiate data collection
    input wire [7:0] serial_in,   // Serial 8-bit input
    output reg done,              // Done signal, indicates when all data has been processed
    output reg [15:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in, i_in // 16-bit parallel outputs
);

    // Internal signals
    reg [3:0] state;              // State to track which 16-bit chunk we're processing
    reg [7:0] buffer;             // Buffer for temporary storage of 8-bit input
    reg [1:0] phase;              // Tracks whether we are in first or second 8-bit input of the 16-bit output

    // State Encoding
    localparam IDLE    = 4'b0000,
               LOAD_A  = 4'b0001,
               LOAD_B  = 4'b0010,
               LOAD_C  = 4'b0011,
               LOAD_D  = 4'b0100,
               LOAD_E  = 4'b0101,
               LOAD_F  = 4'b0110,
               LOAD_G  = 4'b0111,
               LOAD_H  = 4'b1000,
               LOAD_I  = 4'b1001,
               DONE    = 4'b1010;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset everything
            state <= IDLE;
            done <= 1'b0;
            a_in <= 16'b0;
            b_in <= 16'b0;
            c_in <= 16'b0;
            d_in <= 16'b0;
            e_in <= 16'b0;
            f_in <= 16'b0;
            g_in <= 16'b0;
            h_in <= 16'b0;
            i_in <= 16'b0;
            buffer <= 8'b0;
            phase <= 2'b00;
        end else begin
             begin
                case (state)
                    IDLE: begin
                        done <= 1'b0;
                        phase <= 2'b00;  // Start with the first phase of data collection
                        if (start)
                        state <= LOAD_A;  // Move to the first 16-bit chunk
                    end
                    
                    // Load a_in
                    LOAD_A: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;   // Store the first 8 bits in the buffer
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            a_in <= {buffer, serial_in};  // Combine buffered and serial data into 16-bit output
                            phase <= 2'b00;
                            state <= LOAD_B;  // Move to the next 16-bit chunk
                        end
                    end

                    // Load b_in
                    LOAD_B: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;   // Store the first 8 bits in the buffer
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            b_in <= {buffer, serial_in};  // Combine buffered and serial data into 16-bit output
                            phase <= 2'b00;
                            state <= LOAD_C;
                        end
                    end

                    // Load c_in
                    LOAD_C: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            c_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_D;
                        end
                    end

                    // Load d_in
                    LOAD_D: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            d_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_E;
                        end
                    end

                    // Load e_in
                    LOAD_E: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            e_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_F;
                        end
                    end

                    // Load f_in
                    LOAD_F: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            f_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_G;
                        end
                    end

                    // Load g_in
                    LOAD_G: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            g_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_H;
                        end
                    end

                    // Load h_in
                    LOAD_H: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            h_in <= {buffer, serial_in};
                            phase <= 2'b00;
                            state <= LOAD_I;
                        end
                    end

                    // Load i_in
                    LOAD_I: begin
                        if (phase == 2'b00) begin
                            buffer <= serial_in;
                            phase <= 2'b01;
                        end else if (phase == 2'b01) begin
                            i_in <= {buffer, serial_in};  // Final 16-bit output
                            state <= DONE;
                        end
                    end

                    DONE: begin
                        done <= 1'b1;  // Assert done when all inputs are processed
                        state <= IDLE; // Return to IDLE state
                    end

                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule
