clear;
clc;
wordLength = 16;
fractionLength = 12;
iterations = 100;
inputFile = fopen('input_matrices.txt', 'w');
outputFile = fopen('output_matrices.txt', 'w');

% Run the process for 100 iterations
for iter = 1:iterations
    % Generate random input matrix A
    A = fi(rand(3)* 4 , 1, wordLength, fractionLength);
    A = double(A);
    
    % Perform QR decomposition using CORDIC-based method
    [Qt, Rt] = matrix_inversion_qr_cordic_fixed(A, wordLength, fractionLength);
    A_inv = matrix_inverse_custom(Qt, Rt, wordLength, fractionLength);
    
    % MATLAB's built-in inverse for comparison
    A_builtin_inv = fi(inv(A), 1, wordLength, fractionLength);
    
    % Calculate error
    error = norm(double(A_inv) - double(A_builtin_inv)) / 9;
    relative_error = 100 * error / mean(mean(A_builtin_inv));
    
    % Only store if error is less than 1%
    if relative_error < 0.01
        % Store input matrix A in hexadecimal
        A_hex = fi(A, 1, wordLength, fractionLength).hex;
        for row = 1:3
             for col = 1:3
            if (col==1)
                index = 1:4;
            else if (col==2)
                    index = 8:11;
                else
                    index = 15:18;
                end
            end
            fprintf(inputFile, '%s \n', A_hex(row,index));
             end
        end
%         fprintf(inputFile, '\n');
        
        % Store output inverse matrix in hexadecimal
        A_inv_hex = fi(A_inv, 1, wordLength, fractionLength).hex;
        for row = 1:3
            for col = 1:3
            if (col==1)
                index = 1:4;
            else if (col==2)
                    index = 8:11;
                else
                    index = 15:18;
                end
            end
            fprintf(outputFile, '%s \n', A_inv_hex(row,index));
            end
        end
%         fprintf(outputFile, '\n');
    end
end

fclose(inputFile);
fclose(outputFile);
