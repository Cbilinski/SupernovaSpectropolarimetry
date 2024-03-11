%Last updated 2020-06-30

function [leftEWHalpha,leftNEWerr,leftdEWHalpha,rightEWHalpha,rightNEWerr,rightdEWHalpha,reldate] = measureEWleftright(wavelength,fluxscaled,daysafter)  
%so that it is not at 0, but rather with continuum at 1

if(size(fluxscaled,2) ==1 )
else
	fluxscaled = fluxscaled';
	wavelength = wavelength';
end

plot(wavelength,fluxscaled)
axis([[12000 13200] [0 1]])

leftEWHalpha  = trapz(wavelength(find(wavelength(:) >= 6312.81 & wavelength(:) <= 6562.81)),fluxscaled(find(wavelength(:) >= 6312.81 & wavelength(:) <= 6562.81)));
%old error that never worked out
leftNEWerr  = 5*std(fluxscaled(find(wavelength(:) >= 6000 & wavelength(:) <= 6300)));
leftdEWHalpha  = leftNEWerr  * leftEWHalpha;

rightEWHalpha  = trapz(wavelength(find(wavelength(:) >= 6562.81 & wavelength(:) <= 6812.81)),fluxscaled(find(wavelength(:) >= 6562.81 & wavelength(:) <= 6812.81)));
rightNEWerr  = 5*std(fluxscaled(find(wavelength(:) >= 6000 & wavelength(:) <= 6300)));
rightdEWHalpha  = rightNEWerr  * rightEWHalpha;

reldate = daysafter;

Noise_left = std(fluxscaled(wavelength>6100 & wavelength< 6300));
Noise_right = std(fluxscaled(wavelength>6900 & wavelength< 7100));
%Signal = mean(fluxscaled(wavelength>6000 & wavelength<6200));
%SNR = Signal/Noise;
%gaussfit = fit(wavelength(wavelength>6312.81 & wavelength < 6812.81),-1+fluxscaled(wavelength>6312.81 & wavelength < 6812.81),'gauss1')
%sigma = sqrt((gaussfit.c1^2)/2);
%fwhm = 2 * sqrt(2*log(2)) * sigma
%p = mean(diff(wavelength));
%stdHalphagausserr = 1.5 * sqrt(fwhm * p) / SNR


%totalEWHalpha = (leftEWHalpha+rightEWHalpha);
%leftgausserr = stdHalphagausserr * leftEWHalpha/totalEWHalpha
%rightgausserr = stdHalphagausserr * rightEWHalpha/totalEWHalpha


left_maxest = leftEWHalpha/(1-Noise_left)
left_minest = leftEWHalpha/(1+Noise_left)
left_upper = abs(left_maxest-leftEWHalpha)
left_lower = abs(left_minest-leftEWHalpha)
left_avgerror = (left_upper+left_lower)/2
leftdEWHalpha = left_avgerror
right_maxest = rightEWHalpha/(1-Noise_right)
right_minest = rightEWHalpha/(1+Noise_right)
right_upper = abs(right_maxest-rightEWHalpha)
right_lower = abs(right_minest-rightEWHalpha)
right_avgerror = (right_upper+right_lower)/2
rightdEWHalpha = right_avgerror


%leftdEWHalpha = leftgausserr;
%rightdEWHalpha = rightgausserr;

%figure(1)
%plot(gaussfit,wavelength(wavelength>6000 & wavelength < 6812.81),-1+fluxscaled((wavelength>6000 & wavelength < 6812.81)))
%
%
%hold all
%plot(wavelength(wavelength>5893 & wavelength < 5901),smooth(NaIDcontfitnormsub((wavelength>5893 & wavelength < 5901))))
%plot(wavelength(wavelength>5893 & wavelength < 5901),NaIDcontfitnormsub((wavelength>5893 & wavelength < 5901)))
%xlim([5896,5899])
%ylim([-0.25 0])