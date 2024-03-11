%estimate_cont_halpha Function: estimate_cont_halpha(wav,flux)
%Last updated 2020-04-22
%
function [flux_norm_cont_halpha] = estimate_cont_halpha(wav,flux,varargin)


%%%optional arguments
%default values for optional arguments
options = struct('wavin_stored',[],'test',[],'interactive',[],'printlabel',[]);
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

%make sure dimensions are in the right orientation for the fit to work
if(size(wav,1)>size(wav,2))
	wav = wav';
	flux = flux';
end

%%%choose wav_locations
if(strcmp(options.interactive,'yes'))
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
else
	wavin = [lambdaHalpha-600 lambdaHalpha+600];
end

%%%fit to chosen locations, normalize to continuum fit
fitvalues.ind = [find(wav>wavin(1),3,'first') find(wav<wavin(2),3,'last')];
cont_halpha.fit = fit(wav(fitvalues.ind)',flux(fitvalues.ind)','poly1','Robust','Bisquare');
flux_norm_cont_halpha = flux ./ cont_halpha.fit(wav)';


%save figure output
figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\continuum_estimates\';
filename = strcat(figuredirectory,options.printlabel,'.eps');
filename(filename == ' ') = [];

tempplot = figure;
set(gcf,'color','w');
set(tempplot,'units','normalized','outerposition',[0 0 1 1]);
set(tempplot,'PaperUnits','normalized','PaperPosition',[0 0 3 1]);
set(gcf,'renderer','painters')
colormap jet
box on
plot(cont_halpha.fit,wav,flux)
saveas(tempplot, [filename], 'epsc');
eval(['!epstopdf ' filename]);
delete(filename)
close(tempplot)
