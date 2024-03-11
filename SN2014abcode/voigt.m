%Voigt Profile Function: voigt(x,xloc,sigma,gamma)
%Last updated 2018-04-17
%


function [V] = voigt(x,xloc,sigma,gamma)



z = ((x-xloc) + i*gamma) / (sqrt(2) * sigma);

w = exp(-(z.^2)) .* (1-erfz(-i .* z));

V = real(w) ./ (sigma * sqrt(2*pi));

%plot(x,V)
%axis([-0.8 0.8 0 5])





%gamma = 1.593
%height = 5.1
%sigma = 0.5828
%xloc = -0.5177
%
%
%
%z = ((test1-xloc) + i*gamma) / (sqrt(2) * sigma);
%
%w = exp(-(z.^2)) .* (1-erfz(-i .* z));
%
%V = real(w) ./ (sigma * sqrt(2*pi));
%
%
%
%real(w) ./ (sigma * sqrt(2*pi))
%
%
%
%real(exp(-((((x-xloc) + i*gamma) / (sqrt(2) * sigma))^2)) * (1-erfz(-i * (((x-xloc) + i*gamma) / (sqrt(2) * sigma)))))/ (sigma * sqrt(2*pi))
%height*(real(exp(-((((x-xloc) + i*gamma) / (sqrt(2) * sigma))^2)) * (1-erfz(-i * (((x-xloc) + i*gamma) / (sqrt(2) * sigma)))))/ (sigma * sqrt(2*pi)))
%
%vtest = height.*(real(exp(-((((test1-xloc) + i.*gamma) ./ (sqrt(2) .* sigma)).^2)) .* (1-erfz(-i .* (((test1-xloc) + i.*gamma) / (sqrt(2) .* sigma)))))/ (sigma .* sqrt(2.*pi)))
%
%vtest = height.*(real(exp(-((((test1-xloc) + 1i.*gamma) ./ (sqrt(2) .* sigma)).^2)) .* (1-erfz(-1i .* (((test1-xloc) + 1i.*gamma) ./ (sqrt(2) .* sigma)))))./ (sigma .* sqrt(2.*pi)))