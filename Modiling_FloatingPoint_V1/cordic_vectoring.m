function [x_out, y_out, theta] = cordic_vectoring(x, y, N)
    % CORDIC vectoring mode to null y
    atan_table = atan(2.^-(0:N-1));
    K = 1 / prod(sqrt(1 + 2.^(-2*(0:N-1))));  % Constant for scaling factor
    theta = 0;  % Initialize theta
        signx=sign(x);
    for j = 0:N-1  % Loop from 0 to N-1
        if y > 0
            sigma = -1;  % Rotate clockwise if y > 0
        else
            sigma = 1;   % Rotate counterclockwise if y < 0
        end
        
        x_new = abs(x) - sigma * (y) * 2^(-j);
        y_new = y + sigma * abs(x) * 2^(-j);
        theta = theta - sigma * atan_table(j+1);  % atan_table index adjusted for 1-based indexing in MATLAB
        
        % Update the values for the next iteration
        x = x_new;
        y = y_new;
    end
    
    % Output the final values
    x_out = x * K * signx;  % Apply scaling factor K to the final x value
    y_out = y * K;  % Apply scaling factor K to the final y value
end
