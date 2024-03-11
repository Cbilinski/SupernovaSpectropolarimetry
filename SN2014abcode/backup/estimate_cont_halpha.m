%estimate_cont_halpha Function: estimate_cont_halpha(wav,flux)
%Last updated 2020-04-22
%
function [flux_norm_cont_halpha] = estimate_cont_halpha(wav,flux,varargin)


%%%optional arguments
%default values for optional arguments
options = struct('wavin_stored',[],'test',[]);
%read the acceptable names
optionNames = fieldnames(options);
noptArgs = length(varargin);
%count arguments
if(round(noptArgs/2)~=noptArgs/2)
   error('estimate_cont_halpha needs propertyName/propertyValue pairs for optional arguments')
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

%%%choose wav_locations
if(exist(options.wavin_stored))
	wavin=options.wavin_stored
else
	tempplot = figure;
	clf
	hold all
	plot(wav,flux)
	xlim([lambdaHalpha-750 lambdaHalpha+750])
	[wavin,fluxin] = ginput(2)
	close(tempplot)
end
%%%fit to chosen locations, normalize to continuum fit
fitvalues.ind = [find(wav>wavin(1),3,'first') find(wav<wavin(2),3,'last')];
cont_halpha.fit = fit(wav(fitvalues.ind)',flux(fitvalues.ind)','poly1','Robust','Bisquare');
flux_norm_cont_halpha = flux ./ cont_halpha.fit(wav)';
