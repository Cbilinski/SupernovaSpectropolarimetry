%measureFW Function: measureFW(wav,flux)
%Last updated 2020-08-10
%returns 1 sigma error 
function [err_avg err_up err_low] = error_EQW_contnorm(EQW,noise,EQW_range,varargin)

%%%optional arguments
%default values for optional arguments
options = struct('test',[]);
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
%need to add the range of the EQW back to it so that 'continuum level is at 1' when the data is scaled by the new continuum measurement then subtract it back off
%so we arent counting the continuum as part of the equivalent width measurement
maxest = (EQW+EQW_range)/(1-noise) - EQW_range;
minest = (EQW+EQW_range)/(1+noise) - EQW_range;
err_up = abs(EQW-maxest);
err_low = abs(EQW-minest);
err_avg = (err_up+err_low)/2;
