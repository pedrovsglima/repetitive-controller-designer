function c = inequacao(a, q, real, imag)
% This function represents an inequality and 
% returns whether the condition is valid or not.
    f1 = a^2 * q - 2*a*q - a^2 + q;
    f2 = 2*a*q - 2*q - 2*a;
    c = ( f1*(real.^2 + imag.^2) + real*f2) < (1-q);

