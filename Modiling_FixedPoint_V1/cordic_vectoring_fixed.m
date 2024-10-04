function [x_out, y_out, theta] = cordic_vectoring_fixed(x, y, N,wordLength,fractionLength)
    % CORDIC vectoring mode to null y (fixed-point)
%     fprintf('********************cordic_vectoring_fixed INPUTS \n  **************************');
     X = fi(x, 1, wordLength, fractionLength);
     Y = fi(y, 1, wordLength, fractionLength);
     
    atan_table = fi(atan(2.^-(0:N-1))/2/pi, 1, wordLength, wordLength);  % Fixed-point arctangent table    
    K = fi(1 / prod(sqrt(1 + 2.^(-2*(0:N-1)))), 1, 2*wordLength, fractionLength);  % Scaling factor (fixed-point)
    theta = fi(0, 1, wordLength, fractionLength);  % Initialize theta
    xsign = sign(x);
    x=abs(x);
    for j = 0:N-1
        if y > 0
            sigma = fi(-1, 1, wordLength, fractionLength);  % Rotate clockwise
        else
            sigma = fi(1, 1, wordLength, fractionLength);   % Rotate counterclockwise
        end
        
        x_new = x - sigma * y * fi(2^(-j), 1, wordLength, fractionLength);
        y_new = y + sigma * x * fi(2^(-j), 1, wordLength, fractionLength);
        
        % Cast the results to fit into the 12-bit word length
        x = fi(x_new, 1, wordLength+1, fractionLength);
        y = fi(y_new, 1, wordLength+1, fractionLength);

        % Update theta
        theta = fi(theta - (sigma * atan_table(j+1)), 1, wordLength, wordLength);
    end
%     fprintf('cordic_rotation_fixed OUTPUTS \n  ');
    % Apply scaling factor K
%     X_out =fi( x * K* xsign, 1, wordLength, fractionLength).hex
%     Y_out = fi(y * K, 1, wordLength, fractionLength).hex
%     THETA = fi(theta, 1, wordLength, wordLength).hex
    
    % Apply scaling factor K to the final values
    x_out =fi( x * K * xsign, 1, wordLength, fractionLength);
    y_out = fi(0, 1, wordLength, fractionLength);

end