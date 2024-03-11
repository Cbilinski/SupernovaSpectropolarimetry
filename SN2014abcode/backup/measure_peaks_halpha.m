%measure_peaks_halpha Function: measure_peaks_halpha(wav,flux)
%Last updated 2020-04-22
%
function [multiplier] = measure_peaks_halpha(wav,flux,varargin)


%%%optional arguments
%default values for optional arguments
options = struct('test',[]);
%read the acceptable names
optionNames = fieldnames(options);
noptArgs = length(varargin);
%count arguments
if(round(noptArgs/2)~=noptArgs/2)
   error('measure_peaks_halpha needs propertyName/propertyValue pairs for optional arguments')
end
if(~isempty(varargin))
	for pair = reshape(varargin,2,[]) %pair is {paramName;paramValue}
	   inpName = pair{1};
	   if(any(strcmp(inpName,optionNames)))
		  %overwrite the optional arguments
		  options.(inpName) = pair{2};
	   else
		  error('%s is not a recognized parameter name',inpName)
	   end
	end
end

%%%initialize constants
%code is done in angstroms
lambdaHalpha = 6562.81;

%%%choose peak xlower and xhigher bounds for lowres first and then highres
tempplot = figure;
clf
hold all
plot(wav,flux)
xlim([lambdaHalpha-150 lambdaHalpha+150])

user.input.narrow =  input('Is a narrow component present? (y or n)','s');
%if there is a narrow component, mark its locations as well, if not then just mark the low res component bounds
%1 is lower bound lowres 2 is upperbound lowres but below narrow, 3 is lower narrow, 4 is upper narrow, 5 is the missing bound for lowres because of avoiding the narrow
%this assumes currently that the narrow is at higher wavelength than the lowres, which may not always be the case
if(strcmp(user.input.narrow,'y'))
	[wavin,fluxin] = ginput(5)
else
	[wavin,fluxin] = ginput(2)
end

%%%find the peak values
lowres.peak.loc_wav = wav(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux((wav>wavin(1)) & (wav<wavin(2))) == max(flux((wav>wavin(1)) & (wav<wavin(2)))))-1);
lowres.peak.val_flux = max(flux((wav>wavin(1)) & (wav<wavin(2))));
if(strcmp(user.input.narrow,'y'))
	highres.peak.loc_wav = wav(find(((wav>wavin(3)) & (wav<wavin(4))) == 1,1,'first') + find(flux((wav>wavin(3)) & (wav<wavin(4))) == max(flux((wav>wavin(3)) & (wav<wavin(4)))))-1);
	highres.peak.val_flux = max(flux((wav>wavin(3)) & (wav<wavin(4))));
end

%%%normalize flux based on the lowres peak value and then find the 50% height x locations
flux_norm.lowres = flux/lowres.peak.val_flux;

clf
hold all
plot(wav,flux_norm.lowres)
if(strcmp(user.input.narrow,'y'))
	axis([[lambdaHalpha-750 lambdaHalpha+750] [0 highres.peak.val_flux/lowres.peak.val_flux]])
	lowres.halfpeak.loc_wav_start = wav(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(5)))>0.5,1,'first')-1);
	lowres.halfpeak.loc_wav_end = wav(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(5)))>0.5,1,'last')-1);
	lowres.halfpeak.val_flux_end = flux_norm.lowres(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(5)))>0.5,1,'last')-1);
	lowres.halfpeak.val_flux_start = flux_norm.lowres(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(5)))>0.5,1,'first')-1);
else
	axis([[lambdaHalpha-750 lambdaHalpha+750] [0 1]])
	lowres.halfpeak.loc_wav_start = wav(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(2)))>0.5,1,'first')-1);
	lowres.halfpeak.loc_wav_end = wav(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(2)))>0.5,1,'last')-1);
	lowres.halfpeak.val_flux_end = flux_norm.lowres(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(2)))>0.5,1,'last')-1);
	lowres.halfpeak.val_flux_start = flux_norm.lowres(find(((wav>wavin(1)) & (wav<wavin(2))) == 1,1,'first') + find(flux_norm.lowres((wav>wavin(1)) & (wav<wavin(2)))>0.5,1,'first')-1);
end

lowres.halfpeak.loc_wav_mid = (lowres.halfpeak.loc_wav_start + lowres.halfpeak.loc_wav_end)/2;
scatter(lowres.halfpeak.loc_wav_start,lowres.halfpeak.val_flux_start);
scatter(lowres.halfpeak.loc_wav_end,lowres.halfpeak.val_flux_end);
%close(tempplot)

%%%calculate the lowres and highres multipliers
multiplier.lowres = lambdaHalpha/lowres.halfpeak.loc_wav_mid;
if(strcmp(user.input.narrow,'y'))
	multiplier.highres = lambdaHalpha/highres.peak.loc_wav;
end



%%%replot with new scaling based on the chosen peak