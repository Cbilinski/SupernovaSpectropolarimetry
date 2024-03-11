%fit_Serkowski Function: fit_Serkowski_lambdamax_fit
%Last updated 2021-03-23
%
function [c_fit] = fit_Serkowski_lambdamax_fit(dataID,qvals,uvals,wavvals,varargin)

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

figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\serkowskifits\';
dataID(dataID == ' ') = [];
filename = strcat(figuredirectory,'SerkowskiFit_Lmax_',dataID,'.eps');

objective = @(c) myerrorfun_lambdamax_fit(c,qvals,uvals,wavvals);
c_fit = fmincon(objective,[0.1 0.1 5500],[],[],[],[],[-5,-5,4500],[5,5,7000]);

if(contains(dataID,'gas'))
%keyboard
end

wav = 4000:1:7000;

thetatest = 0.5 .* atan(c_fit(2)./c_fit(1));
q =exp(-1.*(-1.13+0.000405*c_fit(3)) .* (log(c_fit(3)./wav)).^2).*(c_fit(1).*(cos(2.*thetatest)).^2 + c_fit(2).*(sin(2.*thetatest).*cos(2.*thetatest)));
u =exp(-1.*(-1.13+0.000405*c_fit(3)) .* (log(c_fit(3)./wav)).^2).*(c_fit(1).*(sin(2.*thetatest).*cos(2.*thetatest)) + c_fit(2).*(sin(2.*thetatest)).^2);

p = sqrt(q.^2+u.^2);

tempfig = figure;
set(gcf,'color','w');
set(tempfig,'units','normalized','outerposition',[0 0 1 1]);
set(tempfig,'PaperUnits','normalized','PaperPosition',[0 0 3 3/3]);
%set(tempfig,'Position',[0 0 6 2]);
colormap jet
clf
hold all
plot(wav,q,'Color','red')
plot(wav,u,'Color','blue')
plot(wav,p,'LineWidth',5)
scatter(wavvals,qvals,15,'red','filled')
scatter(wavvals,uvals,15,'blue','filled')
box on
if(abs(qvals(1))>1)
	axis([[4500 7000] [-3 3]])
else
	axis([[4500 7000] [-3 3]])
end
saveas(tempfig, [filename], 'epsc');
eval(['!epstopdf ' filename]);


%print qmax umax lambda_max K
if(contains(dataID,'sn2017gas2017-12-22MMTcomb'))
	c_fit(1)
	c_fit(2)
	c_fit(3)
end

close(tempfig)

end