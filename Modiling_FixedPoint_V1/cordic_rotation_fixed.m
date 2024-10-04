function [x_out, y_out, z_out] = cordic_rotation_fixed(x, y, theta, N,wordLength,fractionLength)
    %fi parameter to make it fixed
     % Fixed-point CORDIC rotation mode
%          fprintf('*********************cordic_rotation_fixed INPUTS \n*****************  ');
     theta_input = fi(theta, 1, wordLength, fractionLength);
     X = fi(x, 1, wordLength, fractionLength);
     Y = fi(y, 1, wordLength, fractionLength);
    z = fi(-theta, 1, wordLength, fractionLength);
    atan_table = fi(atan(2.^-(0:N-1))/2/pi, 1, wordLength, wordLength);  % Fixed-point arctangent table
    K = fi(1 / prod(sqrt(1 + 2.^(-2*(0:N-1)))), 1, wordLength, fractionLength);  % Scaling factor (fixed-point)
    xsign=sign(x);
    x=abs(x);
    for j = 0:N-1
        if z < 0
            sigma = fi(-1, 1, wordLength, fractionLength);
        else
            sigma = fi(1, 1, wordLength, fractionLength);
        end
        % Perform the rotation and cast the result
        x_new = x - sigma * (y * fi(2^(-j), 1, wordLength, fractionLength));
        y_new = y + sigma * (x * fi(2^(-j), 1, wordLength, fractionLength));
        z_new = z - sigma * atan_table(j+1);
        
        % Cast the results back to fixed-point
        x = fi(x_new, 1, wordLength+1, fractionLength);
        y = fi(y_new, 1, wordLength+1, fractionLength);
        z = fi(z_new, 1, wordLength, wordLength);
    end
%     fprintf('cordic_rotation_fixed OUTPUTS \n  ');
    % Apply scaling factor K
%     X_out =fi( x * K* xsign, 1, wordLength, fractionLength)
%     Y_out = fi(y * K, 1, wordLength, fractionLength)
    x_out = fi( x * K *xsign, 1, wordLength, fractionLength);
    y_out = fi(y * K, 1, wordLength, fractionLength);
    z_out = z;

end