%estimate_cont_halpha Function: estimate_cont_paschenbeta(wav,flux)
%Last updated 2020-04-22
%
function [flux_norm_cont_paschenbeta] = estimate_cont_paschenbeta(wav,flux,varargin)


%%%optional arguments
%default values for optional arguments
options = struct('wavin_stored',[],'test',[]);
%read the acceptable names
optionNames = fieldnames(options);
noptArgs = length(varargin);
%count arguments
if(round(noptArgs/2)~=noptArgs/2)
   error('estimate_cont_paschenbeta needs propertyName/propertyValue pairs for optional arguments')
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
lambdaPaschenbeta = 12822;

%%%choose wav_locations
if(exist(options.wavin_stored))
	wavin=options.wavin_stored
else
	tempplot = figure;
	clf
	hold all
	plot(wav,flux)
	xlim([lambdaPaschenbeta-750 lambdaPaschenbeta+750])
	[wavin,fluxin] = ginput(2)
	close(tempplot)
end
%%%fit to chosen locations, normalize to continuum fit
fitvalues.ind = [find(wav>wavin(1),15,'first') find(wav<wavin(2),15,'last')];
cont_paschenbeta.fit = fit(wav(fitvalues.ind)',flux(fitvalues.ind)','poly1','Robust','Bisquare');
flux_norm_cont_paschenbeta = flux ./ cont_paschenbeta.fit(wav)';


%figure
%
%plot(cont_paschenbeta.fit,wav,flux)
%clf
%plot(wav,flux_norm_cont_paschenbeta)
%axis([[12000 13600] [-1 10]])
%
%plot(wav,flux)
%axis([[12000 13600] [-0.5*10^-15 2*10^-15]])
%
%keyboard
