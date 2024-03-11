%align_halpha Function: align_halpha(wav,multiplier,reldate)
%Last updated 2020-04-22
%
function [wav_aligned] = align_halpha(wav,multiplier,reldate,varargin)

%%%optional arguments
%default values for optional arguments
options = struct('test',[]);
%read the acceptable names
optionNames = fieldnames(options);
noptArgs = length(varargin);
%count arguments
if(round(noptArgs/2)~=noptArgs/2)
   error('align_halpha needs propertyName/propertyValue pairs for optional arguments')
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

%find the dates of the highres data
j=1;
reldate_highres_index = zeros(size(reldate),'logical');
reldate_highres_otherNaN = NaN(size(reldate));
for i=1:size(wav,2)
	if(isfield(multiplier{i},'highres'))
		reldate_highres(j) = reldate(i);
		reldate_highres_index(i) = 1;
		reldate_highres_otherNaN(i) = reldate(i); 
		j=j+1;
	end
end

%calculate the multiplier for each data set based on the relative dates
for i=1:size(wav,2)
	if(isfield(multiplier{i},'highres'))
		wav_aligned{i} = wav{i}*multiplier{i}.highres;
	else
		if(reldate(i) <  reldate(reldate_highres_index))
			wav_aligned{i} = wav{i} * multiplier{i}.lowres/multiplier{find(reldate_highres_index==1,1,'first')}.lowres*multiplier{find(reldate_highres_index==1,1,'first')}.highres;
		elseif(reldate(i) > reldate(reldate_highres_index))
			wav_aligned{i} = wav{i} * multiplier{i}.lowres/multiplier{find(reldate_highres_index==1,1,'last')}.lowres*multiplier{find(reldate_highres_index==1,1,'last')}.highres;
		else
			highres_index_lower(i) = find(reldate(i)>reldate_highres_otherNaN,1,'last');
			highres_index_upper(i) = find(reldate(i)<reldate_highres_otherNaN,1,'first');
			date_highres_lower(i) = reldate(highres_index_lower(i));
			date_highres_upper(i) = reldate(highres_index_upper(i));
			date_frac = (reldate(i) - date_highres_lower(i))/(date_highres_upper(i)-date_highres_lower(i));
			multiplier_lowfromhigh_interp = date_frac*multiplier{highres_index_lower(i)}.lowres + (1-date_frac)*multiplier{highres_index_upper(i)}.lowres;
			multiplier_highfromhigh_interp =  date_frac*multiplier{highres_index_lower(i)}.highres + (1-date_frac)*multiplier{highres_index_upper(i)}.highres;
			wav_aligned{i} = wav{i} * multiplier{i}.lowres/multiplier_lowfromhigh_interp*multiplier_highfromhigh_interp;
		end
	end
end
