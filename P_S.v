module parallel_to_serial_interface (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [15:0] out_inv11, out_inv12, out_inv13,
    input wire [15:0] out_inv21, out_inv22, out_inv23,
    input wire [15:0] out_inv31, out_inv32, out_inv33,
    output reg [7:0] serial_out,
    output reg done
);

    // Internal states and registers
    reg [4:0] state;  // State counter to keep track of serialization progress
    reg [143:0] parallel_data;  // Flattened version of all inputs into one register

    // State encoding
    localparam IDLE = 5'b00000;
    localparam SERIALIZE = 5'b00001;

    // Counter to manage 8-bit chunks
    reg [4:0] counter;

    // Sequential logic to serialize data
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            serial_out <= 8'b0;
            done <= 0;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        // Combine all 16-bit inputs into a single register (144 bits)
                        parallel_data <= {out_inv11, out_inv12, out_inv13, 
                                          out_inv21, out_inv22, out_inv23, 
                                          out_inv31, out_inv32, out_inv33};
                        state <= SERIALIZE;
                        counter <= 0;
                    end
                end

                SERIALIZE: begin
                    if (counter < 18) begin  // There are 18 pairs of 8-bit data in total
                        serial_out <= parallel_data[143:136];  // Take the most significant 8 bits
                        parallel_data <= parallel_data << 8;  // Shift left by 8 bits for the next cycle
                        counter <= counter + 1;
                    end else begin
                        done <= 1;  // All data serialized, indicate done
                        state <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
