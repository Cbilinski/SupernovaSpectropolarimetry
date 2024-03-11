%Last updated 2017-12-10

function [leftEWHalpha,leftNEWerr,leftdEWHalpha,rightEWHalpha,rightNEWerr,rightdEWHalpha,reldate] = measureEWleftrightPaschen(wavelength,fluxscaled,daysafter)  

if(size(fluxscaled,2) ==1 )
else
	fluxscaled = fluxscaled';
	wavelength = wavelength';
end
clf
plot(wavelength,fluxscaled)
axis([[12000 13200] [0 1]])

leftEWHalpha  = trapz(wavelength(find(wavelength(:) >= (12822-300) & wavelength(:) <= 12822)),fluxscaled(find(wavelength(:) >= (12822-300) & wavelength(:) <= 12822)));
leftNEWerr  = 5*std(fluxscaled(find(wavelength(:) >= 12000 & wavelength(:) <= 12500)));
leftdEWHalpha  = leftNEWerr  * leftEWHalpha;

rightEWHalpha  = trapz(wavelength(find(wavelength(:) >= 12822 & wavelength(:) <= (12822+300))),fluxscaled(find(wavelength(:) >= 12822 & wavelength(:) <= (12822+300))));
rightNEWerr  = 5*std(fluxscaled(find(wavelength(:) >= 13150 & wavelength(:) <= 13200)));
rightdEWHalpha  = rightNEWerr  * rightEWHalpha;

reldate = daysafter;


Noise_left = std(fluxscaled(wavelength>12300 & wavelength< 12500));
Noise_right = std(fluxscaled(wavelength>13100 & wavelength< 13300));
%Signal = mean(fluxscaled(wavelength>12200 & wavelength<12400));
%SNR = Signal/Noise;
%gaussfit = fit(wavelength(wavelength>6312.81 & wavelength < 6812.81),-1+fluxscaled(wavelength>6312.81 & wavelength < 6812.81),'gauss1')
%sigma = sqrt((gaussfit.c1^2)/2);
%fwhm = 2 * sqrt(2*log(2)) * sigma
%p = mean(diff(wavelength));
%stdHalphagausserr = 1.5 * sqrt(fwhm * p) / SNR


totalEWHalpha = (leftEWHalpha+rightEWHalpha);
%leftgausserr = stdHalphagausserr * leftEWHalpha/totalEWHalpha
%rightgausserr = stdHalphagausserr * rightEWHalpha/totalEWHalpha


left_maxest = leftEWHalpha/(1-Noise_left)
left_minest = leftEWHalpha/(1+Noise_left)
left_upper = abs(left_maxest-leftEWHalpha)
left_lower = abs(left_minest-leftEWHalpha)
left_avgerror = (left_upper+left_lower)/2
leftdEWHalpha = left_avgerror;
right_maxest = rightEWHalpha/(1-Noise_right)
right_minest = rightEWHalpha/(1+Noise_right)
right_upper = abs(right_maxest-rightEWHalpha)
right_lower = abs(right_minest-rightEWHalpha)
right_avgerror = (right_upper+right_lower)/2
rightdEWHalpha = right_avgerror;
