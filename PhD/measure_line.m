%measure_line Function: measure_line(wav,flux)
%Last updated 2021-03-16
function [flux_norm_cont_line indx_linepeak totalEQWline totalEQWerror narrowcoreEQW] = measure_line(wav,flux,varargin)

%%%optional arguments
%default values for optional arguments
options = struct('wavin_stored',[],'test',[],'interactive',[],'printlabel',[],'line',[],'dataID',[]);
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
c=3*10^10;
run_parameters = 0;

if(strcmp(options.line,'Halpha'))
	lambdaline = 6562.81;
elseif(strcmp(options.line,'Hbeta'))
	lambdaline = 4861.35;
elseif(strcmp(options.line,'HeI5876'))
	lambdaline = 5876;
end

%make sure dimensions are in the right orientation for the fit to work
if(size(wav,1)>size(wav,2))
	wav = wav';
	flux = flux';
end

%%%check for wave locations used in previous run which are stored in a parameter file
%remove blanks from options.dataID
options.dataID(options.dataID == ' ') = [];
if(~isempty(options.dataID))
	%% Import data from text file
	% Script for importing data from the following text file:
	%
	%    filename: C:\Users\Cbilinski\Dropbox\Astrophysics\Projects\GradSchool\TypeIInsSNSPOL\data\parameters_measure_line.txt
	%
	% Auto-generated by MATLAB on 23-Mar-2021 07:27:38

	%% Set up the Import Options and import the data
	opts = delimitedTextImportOptions("NumVariables", 10);

	% Specify range and delimiter
	opts.DataLines = [2, Inf];
	opts.Delimiter = " ";

	% Specify column names and types
	opts.VariableNames = ["dataID", "lineID", "wavincont1", "wavincont2", "wavinedge1", "wavinedge2", "wavinleftnoise1", "wavinleftnoise2", "wavinrightnoise1", "wavinrightnoise2"];
	opts.VariableTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double"];

	% Specify file level properties
	opts.ExtraColumnsRule = "ignore";
	opts.EmptyLineRule = "read";
	opts.ConsecutiveDelimitersRule = "join";
	opts.LeadingDelimitersRule = "ignore";

	% Specify variable properties
	opts = setvaropts(opts, "dataID", "WhitespaceRule", "preserve");
	opts = setvaropts(opts, ["dataID", "lineID"], "EmptyFieldRule", "auto");

	% Import the data
	params = readtable("C:\Users\Cbilinski\Dropbox\Astrophysics\Projects\GradSchool\TypeIInsSNSPOL\data\parameters_measure_line.txt", opts);

	%% Clear temporary variables
	clear opts

	for i=1:size(params,1)
		if(strcmp(options.dataID,params.dataID(i)))
			if(strcmp(options.line,params.lineID(i)))
				%assign stored values
				wavin = [params.wavincont1(i) params.wavincont2(i)];
				wavin_lineedge = [params.wavinedge1(i) params.wavinedge2(i)];
				wavin_leftnoise = [params.wavinleftnoise1(i) params.wavinleftnoise2(i)];
				wavin_rightnoise = [params.wavinrightnoise1(i) params.wavinrightnoise2(i)];
				run_parameters = 1;
			end
		end	
	end
end

%if no stored parameters are used
if(run_parameters==0)
	if(strcmp(options.interactive,'yes'))
		tempplot = figure;
		clf
		hold all
		plot(wav,flux)
		xlim([lambdaline-900 lambdaline+900])
		%choose continuum fit locations
		[wavin,fluxin] = ginput(2);
		%choose edges of line for measuring
		[wavin_lineedge,fluxin_lineedge] = ginput(2);
		%choose left noise region
		[wavin_leftnoise,fluxin_leftnoise] = ginput(2);
		%choose right noise region
		[wavin_rightnoise,fluxin_rightnoise] = ginput(2);
		close(tempplot)
	else
	%presets
		%[wavin,fluxin] = 
		%[wavin_lineedge,fluxin_lineedge] = 
		%[wavin_leftnoise,fluxin_leftnoise] = 
		%[wavin_rightnoise,fluxin_rightnoise] = 
	end
	
	%always store the interactive values or the presets used for the run if a dataID was given
	if(~isempty(options.dataID))
		dataoutputdirectory = 'C:\Users\Cbilinski\Dropbox\Astrophysics\Projects\GradSchool\TypeIInsSNSPOL\data\';
		%options.dataID(options.dataID == ' ') = [];
		filename_parameters_measure_line = strcat(dataoutputdirectory,'parameters_measure_line.txt');
		printable_locations_space = [num2str(wavin'),' ',num2str(wavin_lineedge'),' ',num2str(wavin_leftnoise'),' ',num2str(wavin_rightnoise')];
		%edit the previous variable to remove any instances of double spaces in it
		printable_locations_onespace = regexprep(printable_locations_space,' +',' ');
		parameters_measure_line = [options.dataID,' ',options.line,' ',printable_locations_onespace];
		dlmwrite(filename_parameters_measure_line,parameters_measure_line,'-append','delimiter','');
	end
end

%%%fit to chosen locations, normalize to continuum fit
fitvalues.ind = [find(wav>wavin(1),3,'first') find(wav<wavin(2),3,'last')];
cont_line.fit = fit(wav(fitvalues.ind)',flux(fitvalues.ind)','poly1','Robust','Bisquare');
flux_norm_cont_line = flux ./ cont_line.fit(wav)';

%save continuum fit figure output
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
plot(cont_line.fit,wav,flux)
saveas(tempplot, [filename], 'epsc');
eval(['!epstopdf ' filename]);
delete(filename)
close(tempplot)

velline = 10^-5 .* c.* (wav-lambdaline)./lambdaline;
indx_blue100 = find(wav>(lambdaline-100),1,'first');
indx_red100 = find(wav<(lambdaline+100),1,'last');
[line_peakvalue_contnorm indx_linepeak_afterblue] = max(flux_norm_cont_line(indx_blue100:indx_red100));
indx_linepeak = indx_blue100+(indx_linepeak_afterblue-1);

wav_linepeak_contnorm = wav(indx_linepeak);

%zzz would need to implement maybe optional output variables for the fits here, but skip for now since the main code will just do this
%indx_Halphapeakmin200A = find(data(end).wavedez > (data(end).Halpha_peakwav_contnorm - 200),1,'first');
%indx_Halphapeakplu200A = find(data(end).wavedez < (data(end).Halpha_peakwav_contnorm + 200),1,'last');
%lorentzfit_Halpha = lorentzfit(data(end).wavedez(data(end).indx_Halphapeakmin200A:data(end).indx_Halphapeakplu200A),data(end).flux_norm_conthalpha(data(end).indx_Halphapeakmin200A:data(end).indx_Halphapeakplu200A)');
%gaussfit_Halpha = fit(data(end).wavedez(data(end).indx_Halphapeakmin200A:data(end).indx_Halphapeakplu200A),data(end).flux_norm_conthalpha(data(end).indx_Halphapeakmin200A:data(end).indx_Halphapeakplu200A)','gauss2');
%contrange = [contrange
%.wavedez(data(end).indx_Halphapeak-1) data(end).wavedez(data(end).indx_Halphapeak+1)]
%.wavedez(data(end).indx_Halphapeakmin200A) data(end).wavedez(data(end).indx_Halphapeakplu200A)]];


%flux_norm1_linecont_norm2_linepeak = 1+(flux_norm_cont_line-1)./(flux_norm_cont_line(indx_linepeak)-1);

%do this in the main code
%vel_FW = measureFW(data(end).wavedez,data(end).flux_norm_conthalpha,FWheight);
%flux_Halphacoretot = sum(data(end).flux_norm_conthalpha(data(end).indx_Halphapeak-1:data(end).indx_Halphapeak+1));

lineedge.ind = [find(wav>=wavin_lineedge(1),1,'first') find(wav<=wavin_lineedge(2),1,'last')];

%needs to be multiplied by wavelength per pixel
%EQW_line = sum(flux_norm_cont_line(lineedge.ind(1):lineedge.ind(2)));

%recently changed this to only count equivalent widths above the continuum, not including the continuum level, so hence the -1 added to the flux, changed on 2021-05-24
%zzz need to check rest of code file if this is needed anywhere else still


leftEQWline  = trapz(wav(find(wav >= wavin_lineedge(1) & wav <= wav_linepeak_contnorm)),-1+flux_norm_cont_line(find(wav >= wavin_lineedge(1) & wav <= wav_linepeak_contnorm)));
rightEQWline  = trapz(wav(find(wav >= wav_linepeak_contnorm & wav <= wavin_lineedge(2))),-1+flux_norm_cont_line(find(wav >= wav_linepeak_contnorm & wav <= wavin_lineedge(2))));
totalEQWline = leftEQWline + rightEQWline;

narrowcoreEQW = trapz(wav(indx_linepeak-1:indx_linepeak+1),-1+flux_norm_cont_line(indx_linepeak-1:indx_linepeak+1));

Noise_left = std(flux_norm_cont_line(wav>wavin_leftnoise(1) & wav< wavin_leftnoise(2)));
Noise_right = std(flux_norm_cont_line(wav>wavin_rightnoise(1) & wav< wavin_rightnoise(2)));
Range_left = range(wav(find(wav >= wavin_lineedge(1) & wav <= wav_linepeak_contnorm)));
Range_right = range(wav(find(wav >= wav_linepeak_contnorm & wav <= wavin_lineedge(2))));

[left_err_avg left_err_up left_err_low] = error_EQW_contnorm(leftEQWline,Noise_left,Range_left);
[right_err_avg right_err_up right_err_low] = error_EQW_contnorm(rightEQWline,Noise_right,Range_right);

totalEQWerror = sqrt(left_err_avg^2 + right_err_avg^2);

%old code

%if(strcmp(options.interactive,'yes'))
%	if(exist(options.wavin_stored))
%		wavin=options.wavin_stored
%	else
%		tempplot = figure;
%		clf
%		hold all
%		plot(wav,flux)
%		xlim([lambdaline-900 lambdaline+900])
%		%choose continuum fit locations
%		[wavin,fluxin] = ginput(2);
%		%choose edges of line for measuring
%		[wavin_lineedge,fluxin_lineedge] = ginput(2);
%		%choose left noise region
%		[wavin_leftnoise,fluxin_leftnoise] = ginput(2);
%		%choose right noise region
%		[wavin_rightnoise,fluxin_rightnoise] = ginput(2);
%		close(tempplot)
%	end
%else
%	wavin = [lambdaline-600 lambdaline+600];
%	wavin_lineedge = [lambdaline-200 lambdaline+200];
%end


%from measureleftright noise calculations
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














