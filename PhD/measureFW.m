%measureFW Function: measureFW(wav,flux)
%Last updated 2020-08-10
%
function [vel_FW] = measureFW(wav,flux,FWheight,varargin)

%FW is measured in km/s

%%%optional arguments
%default values for optional arguments
options = struct('test',[],'interactive',[]);
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
c=3*10^10;

wav_velHalpha = 10^-5 .* c.* (wav-lambdaHalpha)./lambdaHalpha;
wav_indx_blueHalpha100 = find(wav>(lambdaHalpha-100),1,'first');
wav_indx_redHalpha100 = find(wav<(lambdaHalpha+100),1,'last');
[flux_Halpha_peakvalue_contnorm wav_indx_Halphapeak_afterblue] = max(flux(wav_indx_blueHalpha100:wav_indx_redHalpha100));
wav_indx_Halphapeak = wav_indx_blueHalpha100+(wav_indx_Halphapeak_afterblue-1);
flux_n1cont_n2peak = 1+(flux-1)./(flux(wav_indx_Halphapeak)-1);

wav_indx_lessthanFWheight = find(flux_n1cont_n2peak<FWheight);
wav_indx_dif = (wav_indx_Halphapeak-wav_indx_lessthanFWheight);
wav_indx_lessthanFWheight_low = wav_indx_Halphapeak-min(wav_indx_dif(wav_indx_dif>0));
wav_indx_lessthanFWheight_upp =wav_indx_Halphapeak+min(abs(wav_indx_dif(wav_indx_dif<0)));
vel_FW = wav_velHalpha(wav_indx_lessthanFWheight_upp)-wav_velHalpha(wav_indx_lessthanFWheight_low);


