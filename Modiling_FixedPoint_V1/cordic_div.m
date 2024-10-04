function [quotient] = cordic_div(numerator, denominator, N, wordLength, fractionLength)
    % Constants // parameters
%     disp('***************division***********************:');
    % Initialize variables
    x = fi(numerator,1,wordLength,fractionLength);
    y = fi(denominator,1,wordLength,fractionLength);
    z = fi(0,1,wordLength,fractionLength);
    xsign = sign(x);
    % Iterate the CORDIC algorithm
    for i = 0:N
        if y < 0
            y = fi(y + abs(x)*2^(3-i),1,2*wordLength,fractionLength);
            z = fi(z - 2^(3-i),1,wordLength,fractionLength);
        else
            y = fi(y - abs(x)*2^(3-i),1,2*wordLength,fractionLength);

            z = fi(z + 2^(3-i),1,wordLength,fractionLength);
            
        end
    end
    
%     % Output the quotient (fixed-point format)
    quotient = fi(z * xsign,1,wordLength,fractionLength);
%     quotient.hex
%     quotient
end
