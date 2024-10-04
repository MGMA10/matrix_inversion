 function [x_out, y_out, z_out] = cordic_rotation(x, y, theta, N)
    % Constants
    z=-theta;
    atan_table = atan(2.^-(0:N-1));         % Table stord before for atan
    K = 1/ prod(sqrt(1 + 2.^(-2*(0:N-1))));  % Table stored before for produt of cos
    xsign=sign(x);
    x=abs(x);
    % CORDIC iterations
    for j = 0:N-1
        if z < 0
            sigma = -1;
        else
            sigma = 1;
        end
        
        % Shift and add/subtract
        x_new = x - sigma * (y * 2^(-j));
        y_new = y + sigma * (x * 2^(-j));
        z_new = z - sigma * atan_table(j+1);

        % Update variables for next iteration we make in x and x new for
        % the flipflop
        
        x = x_new;
        y = y_new;
        z = z_new;
    end

    % Adjust final outputs
    x_out = x * K *xsign;
    y_out = y * K;
    z_out = z;
 end