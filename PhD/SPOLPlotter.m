%comments

function [wav1, qRSP_out, uRSP_out, p2_opt_out] = SPOLPlotter(wav1,flx1,q2,u2,date,reldate,name,telescope,numcont,contrange,varargin)

%default values for optional arguments
options = struct('ISP',[],'qsig',[],'usig',[],'qsum',[],'usum',[],'databounds',[],'ISPfitvals',[],'Halphacorewav',[],'Serkowski_template',[]);

%read the acceptable names
optionNames = fieldnames(options);
noptArgs = length(varargin);
%count arguments
if(round(noptArgs/2)~=noptArgs/2)
   error('SPOLPlotter needs propertyName/propertyValue pairs for optional arguments')
end

if(~isempty(varargin))
	for pair = reshape(varargin,2,size(varargin,2)/2) %pair is {paramName;paramValue}
	   inpName = pair{1};

	   if(any(strcmp(inpName,optionNames)))
		  %overwrite the optional arguments
		  options.(inpName) = pair{2};  
	   else
		  error('%s is not a recognized parameter name',inpName)
	   end
	end
end

%constants
%some constants set inside ISP fitting if ISPfitvals are supplied

%locations %phd zzz
%figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\newplots_peakdate\';
%dataoutputdirectory = 'C:\Users\Cbilinski\Dropbox\Astrophysics\Projects\GradSchool\TypeIInsSNSPOL\data\';
%latextabledirectory = 'C:\Users\Cbilinski\Desktop\Figures\LatexTables\';

%%locations post phd
%figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\sn2010jlcolab\';
%dataoutputdirectory = 'C:\Users\Cbilinski\Dropbox\Astrophysics\Projects\Post-Grad_Freetime\SN2010jl\data\';
%latextabledirectory = 'C:\Users\Cbilinski\Desktop\Figures\sn2010jlcolab\LatexTables\';

%locations SNSPOLooza
figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\SNSPOLooza\';
dataoutputdirectory = 'C:\Users\Cbilinski\Desktop\CurrentProjects\SNSPOLooza\dataoutput\';
latextabledirectory = 'C:\Users\Cbilinski\Desktop\Figures\SNSPOLooza\LatexTables\';

%100 Angstroms for smoothing size
smoothsize = round(100/mean(diff(wav1)));

%check if bounds are submitted and, if so, read them in
if(~isempty(options.databounds))
	lowbound = options.databounds(1);
	uppbound = options.databounds(2);
else
	lowbound = 4400;
	uppbound = 7000;
	lowbound = 4000;
	uppbound = 7500;
end

%check if qsum/usum and qsig/usig are submitted and, if so, read them in
if(~isempty(options.qsum))
	qsum = options.qsum;
	usum = options.usum;
else
	qsum = ones(size(q2,1),1);
	usum = ones(size(u2,1),1);
end

if(~isempty(options.qsig))
	qsig = options.qsig;
	usig = options.usig;
	qsig=qsig((wav1>lowbound)&(wav1<uppbound));
	usig=usig((wav1>lowbound)&(wav1<uppbound));
end

%cut data off by bounds
flx1=flx1((wav1>lowbound)&(wav1<uppbound));
q2=q2((wav1>lowbound)&(wav1<uppbound));
u2=u2((wav1>lowbound)&(wav1<uppbound));
qsum=qsum((wav1>lowbound)&(wav1<uppbound));
usum=usum((wav1>lowbound)&(wav1<uppbound));
%must be last or it messes everything up
wav1=wav1((wav1>lowbound)&(wav1<uppbound));


if(~isempty(options.Serkowski_template))
	%change figure directory
	figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\SerkowskiTemplate\';

	%generate template Serkowski curve to overplot on qRSP
	K = -1.13+0.000405*options.Serkowski_template(3); %from Cikota 2018
	Serk_theta = 0.5 .* atan(options.Serkowski_template(2)./options.Serkowski_template(1));
	Serk_q = exp(-1.*K .* (log(options.Serkowski_template(3)./wav1)).^2).*(options.Serkowski_template(1).*(cos(2.*Serk_theta)).^2 + options.Serkowski_template(2).*(sin(2.*Serk_theta).*cos(2.*Serk_theta)));
	Serk_u = exp(-1.*K .* (log(options.Serkowski_template(3)./wav1)).^2).*(options.Serkowski_template(1).*(sin(2.*Serk_theta).*cos(2.*Serk_theta)) + options.Serkowski_template(2).*(sin(2.*Serk_theta)).^2);
	Serk_p = sqrt(Serk_q.^2+Serk_u.^2);
end

if(~isempty(options.ISPfitvals))
	run = 2;
	%constants for ISPfits
	%lmax = 6.5201e+03 %from SN 2017gas fit to the K value of cikota
	lmax = options.ISPfitvals(3);
	K = -1.13+0.000405*lmax; %from Cikota 2018
	
	%filename for ISPscalefactor
	filename_data_ISPscalefactor = strcat(dataoutputdirectory,'data_ISPscalefactor.txt');
	
	%generate ISP q and u segments based on wavelengths used
	ISP_theta = 0.5 .* atan(options.ISPfitvals(2)./options.ISPfitvals(1));
	ISP_q = exp(-1.*K .* (log(lmax./wav1)).^2).*(options.ISPfitvals(1).*(cos(2.*ISP_theta)).^2 + options.ISPfitvals(2).*(sin(2.*ISP_theta).*cos(2.*ISP_theta)));
	ISP_u = exp(-1.*K .* (log(lmax./wav1)).^2).*(options.ISPfitvals(1).*(sin(2.*ISP_theta).*cos(2.*ISP_theta)) + options.ISPfitvals(2).*(sin(2.*ISP_theta)).^2);
	ISP_p = sqrt(ISP_q.^2+ISP_u.^2);
	if(max(ISP_p) > options.ISP)
		ISPscalefactor = options.ISP/max(ISP_p);
		%store previous maximum of ISP and the scale factor for printing
		results_ISPscalefactor = [name,' ',telescope,' ',date,' ',num2str(reldate),' ',num2str(max(ISP_p)),' ',num2str(ISPscalefactor)];
		if(ISPscalefactor < 0.2)
			ISPscalefactor = 0.5;
		end
		ISP_q = ISP_q * ISPscalefactor;
		ISP_u = ISP_u * ISPscalefactor;
		ISP_p = sqrt(ISP_q.^2+ISP_u.^2);
	else
		ISPscalefactor = 0.5;
		ISP_q = ISP_q * ISPscalefactor;
		ISP_u = ISP_u * ISPscalefactor;
		ISP_p = sqrt(ISP_q.^2+ISP_u.^2);
		results_ISPscalefactor = [name,' ',telescope,' ',date,' ',num2str(reldate),' ',num2str(max(ISP_p))];
	end
	dlmwrite(filename_data_ISPscalefactor,results_ISPscalefactor,'-append','delimiter','');
else
	run = 1;
end

%for plotting the ISP on the q/u scatter plots
if(~isempty(options.Halphacorewav))
	indx_Halphacorewav = find(options.Halphacorewav == wav1);
end
%initialize run_noISPsub which will populate as true after one run, meaning that 0 is the run with no ISPsub, and after it has been run its set to true, so run_noISPsub == 1 is a run with the ISP sub happening
run_noISPsub = 0;

while(run > 0)
	%subtract off ISP exact values here if supplied and one run through without the sub has been run
	if(run_noISPsub == 1)
		q2 = q2 - 0.01*ISP_q;
		u2 = u2 - 0.01*ISP_u;
	end

	if(isempty(options.qsig))
		movemeanq = movmean(q2,smoothsize);
		movemeanu = movmean(u2,smoothsize);
		for i=1:length(q2)
			%odd
			if(rem(smoothsize,2) == 1)
				rms_index = i-floor(smoothsize/2):i+floor(smoothsize/2);
				rms_index_p = rms_index((rms_index>0)&(rms_index<length(q2)+1));
				qsig_rms(i) = sqrt(sum((movemeanq(i)-q2(rms_index_p)).^2)/length(rms_index_p));
				usig_rms(i) = sqrt(sum((movemeanu(i)-u2(rms_index_p)).^2)/length(rms_index_p));
			%even
			else
				rms_index = i-(floor(smoothsize/2)-1)-1:i+(floor(smoothsize/2)-1);
				rms_index_p = rms_index((rms_index>0)&(rms_index<length(q2)+1));
				qsig_rms(i) = sqrt(sum((movemeanq(i)-q2(rms_index_p)).^2)/length(rms_index_p));
				usig_rms(i) = sqrt(sum((movemeanu(i)-u2(rms_index_p)).^2)/length(rms_index_p));
			end
			%qsig_rms = qsig_rms';
			%usig_rms = usig_rms';
			qsig = qsig_rms';
			usig = usig_rms';
		end
	end

	%traditional polarization and angle calculations
	p1 = wav1;
	p2 = sqrt((q2.^2+u2.^2) );
	t1 = wav1;
	t2 = atan(u2./q2)*180/pi;
	for i=1:length(t2)
		if(q2(i) < 0)
			if(u2(i) < 0)
				t2(i)=t2(i)+180;
			else
				t2(i)=t2(i)+180;
			end
		else
			if(u2(i) < 0)
				t2(i)=t2(i)+360;
			else
				t2(i)=t2(i);
			end
		end
	end
	t2 = t2./2;
	
	%smoothing
	q2_smooth = smooth(q2,smoothsize);
	u2_smooth = smooth(u2,smoothsize);
	t2_smooth = atan(u2_smooth./q2_smooth)*180/pi;
	for i=1:length(t2_smooth)
		if(q2_smooth(i) < 0)
			if(u2_smooth(i) < 0)
				t2_smooth(i)=t2_smooth(i)+180;
			else
				t2_smooth(i)=t2_smooth(i)+180;
			end
		else
			if(u2_smooth(i) < 0)
				t2_smooth(i)=t2_smooth(i)+360;
			else
				t2_smooth(i)=t2_smooth(i);
			end
		end
	end
	t2_smooth = t2_smooth./2;

	%smooth angle and calculate rotated Stoke Parameters
	qRSP = q2.*cos(2*t2_smooth*pi/180) + u2.*sin(2*t2_smooth*pi/180);
	uRSP = -q2.*sin(2*t2_smooth*pi/180) + u2.*cos(2*t2_smooth*pi/180);
	%rotating the q and u values still keeps the count "weight" in each the same
	qRSPsum = qsum;
	uRSPsum = usum;
	%qRSPsum = abs(qsum.*cos(2*t2_smooth*pi/180)) + abs(usum.*sin(2*t2_smooth*pi/180));
	%uRSPsum = abs(-qsum.*sin(2*t2_smooth*pi/180)) + abs(usum.*cos(2*t2_smooth*pi/180));
	tRSP = atan(uRSP./qRSP)*180/pi;
	for i=1:length(tRSP)
		if(qRSP(i) < 0)
			if(uRSP(i) < 0)
				tRSP(i)=tRSP(i)+180;
			else
				tRSP(i)=tRSP(i)+180;
			end
		else
			if(uRSP(i) < 0)
				tRSP(i)=tRSP(i)+360;
			else
				tRSP(i)=tRSP(i);
			end
		end
	end
	tRSP = tRSP./2;

	if((q2.^2+u2.^2)-(qsig.^2 + usig.^2)<0)
		p2_deb = -sqrt(abs((q2.^2+u2.^2) -(qsig.^2 + usig.^2)));
	else
		p2_deb = sqrt(abs((q2.^2+u2.^2) -(qsig.^2 + usig.^2)));
	end
	psig = sqrt((qsig.*q2./p2).^2+(usig.*u2./p2).^2);
	p2_opt = p2 - (psig.^2./p2);

	tsig = (180/(2*pi))*(1./(1+(u2./q2).^2)).*(u2./q2).*sqrt((qsig./q2).^2+(usig./u2).^2);

	%statistics code stuff to do here zzz
	%psig_opt = 

	if(run_noISPsub == 0)
		qRSP_out{1} = qRSP;
		uRSP_out{1} = uRSP;
		p2_opt_out{1} = p2_opt;
	elseif(run_noISPsub == 1)
		qRSP_out{2} = qRSP;
		uRSP_out{2} = uRSP;
		p2_opt_out{2} = p2_opt;
	end

	%P calculations for particular bins

	%seems like actually using q and u for the traditional, debiased, and optimal polarization calculations
	for i=1:numcont
		contPbinmembersq{i} = q2(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmembersqsig{i} = qsig(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmembersu{i} = u2(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmembersusig{i} = usig(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmembersqsum{i} = qsum(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmeanqsum{i} = mean(contPbinmembersqsum{i});            %
		contPbinmembersusum{i} = usum(wav1>contrange(i,1)&wav1<contrange(i,2));
		contPbinmeanusum{i} = mean(contPbinmembersusum{i});            %
		
		contPbinweightedmeanq_meansum{i} = sum(contPbinmembersq{i}.*contPbinmembersqsum{i})/(contPbinmeanqsum{i}*length(contPbinmembersq{i}));             %
		contPbinweightedmeanu_meansum{i} = sum(contPbinmembersu{i}.*contPbinmembersusum{i})/(contPbinmeanusum{i}*length(contPbinmembersu{i}));             %
		contPbinweightedmeanqsig_meansum{i} = sqrt(sum((contPbinmembersqsig{i}.*contPbinmembersqsum{i}/(contPbinmeanqsum{i}*length(contPbinmembersq{i}))).^2));      %
		contPbinweightedmeanusig_meansum{i} = sqrt(sum((contPbinmembersusig{i}.*contPbinmembersusum{i}/(contPbinmeanusum{i}*length(contPbinmembersu{i}))).^2));      %
		contPbinp_meansum.trad{i} = sqrt(contPbinweightedmeanq_meansum{i}^2 + contPbinweightedmeanu_meansum{i}^2);
		contPbinpsig_meansum{i} = sqrt((contPbinweightedmeanqsig_meansum{i}*contPbinweightedmeanq_meansum{i}/contPbinp_meansum.trad{i})^2+(contPbinweightedmeanusig_meansum{i}*contPbinweightedmeanu_meansum{i}/contPbinp_meansum.trad{i})^2);
		
		%debiased
		if (contPbinp_meansum.trad{i} - (contPbinweightedmeanqsig_meansum{i}^2+contPbinweightedmeanusig_meansum{i}^2)  < 0)
			contPbinp_meansum.debias{i} = -1 * sqrt(abs(contPbinp_meansum.trad{i}^2 - (contPbinweightedmeanqsig_meansum{i}^2+contPbinweightedmeanusig_meansum{i}^2)));
		else
			contPbinp_meansum.debias{i} = sqrt(abs(contPbinp_meansum.trad{i}^2 - (contPbinweightedmeanqsig_meansum{i}^2+contPbinweightedmeanusig_meansum{i}^2)));
		end
		
		%optimal
		if (contPbinp_meansum.trad{i} - (contPbinpsig_meansum{i}^2)./contPbinp_meansum.trad{i}  > 0)
			contPbinp_meansum.opt{i} = abs(contPbinp_meansum.trad{i} - (contPbinpsig_meansum{i}^2)./contPbinp_meansum.trad{i});
		else
			contPbinp_meansum.opt{i} = -1 * abs(contPbinp_meansum.trad{i} - (contPbinpsig_meansum{i}^2)./contPbinp_meansum.trad{i});
		end
		
		%calculate theta across the entire region
		tcont{i} = atan(contPbinweightedmeanu_meansum{i}/contPbinweightedmeanq_meansum{i})*180/pi;
		if(contPbinweightedmeanq_meansum{i} < 0)
			if(contPbinweightedmeanu_meansum{i} < 0)
				tcont{i}=tcont{i}+180;
			else
				tcont{i}=tcont{i}+180;
			end
		else
			if(contPbinweightedmeanu_meansum{i} < 0)
				tcont{i}=tcont{i}+360;
			else
				tcont{i}=tcont{i};
			end
		end
		tcont{i} = tcont{i}./2;
		
		tcontsig{i} = (180/(2*pi))*(1./(1+(contPbinweightedmeanu_meansum{i}./contPbinweightedmeanq_meansum{i}).^2)).*(contPbinweightedmeanu_meansum{i}./contPbinweightedmeanq_meansum{i}).*sqrt((contPbinweightedmeanqsig_meansum{i}./contPbinweightedmeanq_meansum{i}).^2+(contPbinweightedmeanusig_meansum{i}./contPbinweightedmeanu_meansum{i}).^2);
		%not 100% sure if this is right above, but i think so
		%should be something like 1/(1+d(u/q))^2  / 2 
	end


	%Binning for plots into 100 bins
	
	nbins = 300;
	[nwav1,binedgewav1temp,binwav1] = histcounts(wav1,nbins);
	%actually moving the bin edges to the center of the bin
	binedgewav1 = 0.5 * (binedgewav1temp(1:end-1) + binedgewav1temp(2:end));

	for i =1:nbins
		flagbinmembersq = (binwav1==i);
		binmembersq = q2(flagbinmembersq);
		binmembersqsum = qsum(flagbinmembersq);
		binmeanqsum(i) = mean(binmembersqsum);
		binweightedmeanq_meansum(i) = sum(binmembersq.*binmembersqsum)/(binmeanqsum(i)*length(binmembersq));
		
		flagbinmembersqRSP = (binwav1==i);
		binmembersqRSP = qRSP(flagbinmembersqRSP);
		binmembersqRSPsum = qRSPsum(flagbinmembersqRSP);
		binmeanqRSPsum(i) = mean(binmembersqRSPsum);
		binweightedmeanqRSP_meansum(i) = sum(binmembersqRSP.*binmembersqRSPsum)/(binmeanqRSPsum(i)*length(binmembersqRSP));
		
		flagbinmembersu = (binwav1==i);
		binmembersu = u2(flagbinmembersu);
		binmembersusum = usum(flagbinmembersu);
		binmeanusum(i) = mean(binmembersusum);
		binweightedmeanu_meansum(i) = sum(binmembersu.*binmembersusum)/(binmeanusum(i)*length(binmembersu));
		
		flagbinmembersuRSP = (binwav1==i);
		binmembersuRSP = uRSP(flagbinmembersuRSP);
		binmembersuRSPsum = uRSPsum(flagbinmembersuRSP);
		binmeanuRSPsum(i) = mean(binmembersuRSPsum);
		binweightedmeanuRSP_meansum(i) = sum(binmembersuRSP.*binmembersuRSPsum)/(binmeanuRSPsum(i)*length(binmembersuRSP));
		
		flagbinmembersqsig = (binwav1==i);
		binmembersqsig = qsig(flagbinmembersqsig);
		binmembersqsum = qsum(flagbinmembersqsig);
		binmeanqsum(i) = mean(binmembersqsum);
		binweightedmeanqsig_meansum(i) = sqrt(sum((binmembersqsig.*binmembersqsum/(binmeanqsum(i)*length(binmembersqsig))).^2));

		flagbinmembersusig = (binwav1==i);
		binmembersusig = usig(flagbinmembersusig);
		binmembersusum = usum(flagbinmembersusig);
		binmeanusum(i) = mean(binmembersusum);
		binweightedmeanusig_meansum(i) = sqrt(sum((binmembersusig.*binmembersusum/(binmeanusum(i)*length(binmembersusig))).^2));	
	end


	binedgep1 = binedgewav1;
	binedget1 = binedgewav1;


	%P calculations for each of the 100 bins used in plots

	p_meansum.trad = sqrt(binweightedmeanq_meansum.^2+binweightedmeanu_meansum.^2);
	psig_meansum = sqrt((binweightedmeanqsig_meansum.*binweightedmeanq_meansum./p_meansum.trad).^2+(binweightedmeanusig_meansum.*binweightedmeanu_meansum./p_meansum.trad).^2);

	%debiased
	for i = 1:size(p_meansum.trad,2)
		if( p_meansum.trad(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2) < 0)
			p_meansum.debias(i) = -1 * sqrt(abs(p_meansum.trad(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2)));
		else
			p_meansum.debias(i) = sqrt(abs(p_meansum.trad(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2)));
		end
	end

	%optimal
	for i = 1:size(p_meansum.trad,2)
		if( p_meansum.trad(i) - (psig_meansum(i)^2/p_meansum.trad(i)) > 0)
			p_meansum.opt(i) = abs(p_meansum.trad(i) - (psig_meansum(i)^2/p_meansum.trad(i)));
		else
			p_meansum.opt(i) = -1 * abs(p_meansum.trad(i) - (psig_meansum(i)^2/p_meansum.trad(i)));
		end
	end

	t1 = wav1;
	binmeant_meansum = atan(binweightedmeanu_meansum./binweightedmeanq_meansum)*180/pi;
	for i=1:length(binmeant_meansum)
		if(binweightedmeanq_meansum(i) < 0)
			if(binweightedmeanu_meansum(i) < 0)
				binmeant_meansum(i)=binmeant_meansum(i)+180;
			else
				binmeant_meansum(i)=binmeant_meansum(i)+180;
			end
		else
			if(binweightedmeanu_meansum(i) < 0)
				binmeant_meansum(i)=binmeant_meansum(i)+360;
			else
				binmeant_meansum(i)=binmeant_meansum(i);
			end
		end
	end
	binmeant_meansum = binmeant_meansum./2;


	%binning done by here
	%store qRSP uRSP and popt for the entire wavelength range currently implemented in the function call


	if(run_noISPsub == 1)
		%filename when doing ISP Exact removed
		filename = strcat(figuredirectory,'QU_ISPremoved_',name,date,'.eps');
	else
		%filename when running with ISP included
		filename = strcat(figuredirectory,'QU_',name,date,'.eps');
		
		%if an ISP exact was submitted, prepare the multi figure name
		if(~isempty(options.ISPfitvals))
			filenamemulti = strcat(figuredirectory,'QU_multipanel',name,date,'.eps');
			filenamemulti(filenamemulti == ' ') = [];
		end
		
	end
	
	%remove white space between any characters, such as SN name
	filename(filename == ' ') = [];

	for i=1:25
		ang{i} = linspace(0,2*pi,i*100);
		circx{i} = i*0.01*cos(ang{i});
		circy{i} = i*0.01*sin(ang{i});
	end
		
	%cvec = linspace(1,10,length(binedgewav1));
	cvec = jet(length(binedgewav1));

	if(~isempty(options.ISP))
		ISPang = linspace(0,2*pi,options.ISP*100);
		ISPcircx = options.ISP * cos(ISPang);
		ISPcircy = options.ISP * sin(ISPang);
		ISP.print = strcat('ISP $< $ ', string(round(options.ISP,2)), '\%');
	end

	identifier = strcat(name,date,'day',int2str(reldate),telescope);
	%for single day
	%reldateprint = strcat('Day ',int2str(reldate))
	%for multiple day range insert string into SPOLPlotter
	reldateprint = strcat('Day\,',int2str(reldate));

	%check if theta bounces around 0 to 180
	offsettheta = 0;
	if(sum((binmeant_meansum<30)|(binmeant_meansum>150)) > 0.5*size(binmeant_meansum,2))
		offsettheta = 1;
		for i =1:size(binmeant_meansum,2)
			if(binmeant_meansum(i)>90)
				binmeant_meansum(i) = binmeant_meansum(i)-180;
			end
		end
	end

	%rms test code on the binned data
	%keyboard
	%
	%smoothsizebin = round(100/diff(binedgewav1(1:2)));
	%
	%
	%
	%	movemeanqbin = movmean(binweightedmeanq_meansum,smoothsizebin);
	%	movemeanubin = movmean(binweightedmeanu_meansum,smoothsizebin);
	%	for i=1:length(binweightedmeanq_meansum)
	%		%odd
	%		if(rem(smoothsizebin,2) == 1)
	%			rms_indexbin = i-floor(smoothsizebin/2):i+floor(smoothsizebin/2);
	%			rms_indexbin_p = rms_indexbin((rms_indexbin>0)&(rms_indexbin<length(binweightedmeanq_meansum)+1));
	%			qsig_rmsbin(i) = sqrt(sum((movemeanqbin(i)-binweightedmeanq_meansum(rms_indexbin_p)).^2)/length(rms_indexbin_p));
	%			usig_rmsbin(i) = sqrt(sum((movemeanubin(i)-binweightedmeanu_meansum(rms_indexbin_p)).^2)/length(rms_indexbin_p));
	%		%even
	%		else
	%			rms_indexbin = i-(floor(smoothsizebin/2)-1)-1:i+(floor(smoothsizebin/2)-1);
	%			rms_indexbin_p = rms_indexbin((rms_indexbin>0)&(rms_indexbin<length(binweightedmeanq_meansum)+1));
	%			qsig_rmsbin(i) = sqrt(sum((movemeanqbin(i)-binweightedmeanq_meansum(rms_indexbin_p)).^2)/length(rms_indexbin_p));
	%			usig_rmsbin(i) = sqrt(sum((movemeanubin(i)-binweightedmeanu_meansum(rms_indexbin_p)).^2)/length(rms_indexbin_p));
	%		end
	%		%qsig_rms = qsig_rms';
	%		%usig_rms = usig_rms';
	%		%qsig = qsig_rms';
	%		%usig = usig_rms';
	%	end

	opengl software
	plotting = figure;
	set(gcf,'color','w');
	set(plotting,'units','normalized','outerposition',[0 0 1 1]);
	set(plotting,'PaperUnits','normalized','PaperPosition',[0 0 3 3/3]);
	set(gcf,'renderer','painters')
	%set(plotting,'Position',[0 0 6 2]);
	colormap jet

	%set plot boundaries to the nearest 0.5 interval below for minimum and above for maximum, never set 0 as minimum either
	%also make sure the dynamic range is always square as well
	%+- 0.005 is to make sure the plot boundry is not right next to a data point, giving a small buffer around the edges if close
	qminval = min(floor(100 * (binweightedmeanq_meansum-0.0005)*2)/2);
	qmaxval = max(ceil( 100 * (binweightedmeanq_meansum+0.0005)*2)/2);
	uminval = min(floor(100 * (binweightedmeanu_meansum-0.0005)*2)/2);
	umaxval = max(ceil( 100 * (binweightedmeanu_meansum+0.0005)*2)/2);
	%make sure the bounds at least extend to 0.5 in each direction
	qmin_minhalf = min(qminval,-0.5);
	qmax_minhalf = max(qmaxval,0.5);
	umin_minhalf = min(uminval,-0.5);
	umax_minhalf = max(umaxval,0.5);
	%calculate the maximal range needed to _minhalf with a minimum value of 2 seeded in case the ranges on values are small and near the origin
	qurange = max(abs([qmax_minhalf-qmin_minhalf umax_minhalf-umin_minhalf 2]));
	%create a square shaped _minhalf range based on the maximal range and the midpoints of the qmin/qmax values
	qmin_prebound = (qmax_minhalf+qmin_minhalf)/2-0.5*qurange;
	umin_prebound = (umax_minhalf+umin_minhalf)/2-0.5*qurange;
	qmax_prebound = (qmax_minhalf+qmin_minhalf)/2+0.5*qurange;
	umax_prebound = (umax_minhalf+umin_minhalf)/2+0.5*qurange;
	%set a limit to the bounds
	qmin = max(qmin_prebound,-10);
	umin = max(umin_prebound,-10);
	qmax = min(qmax_prebound,10);
	umax = min(umax_prebound,10);
	%if the entire range was very small, make sure the _minhalf covers at least from -1 to 1 rather than being very zoomed in
	if( (abs(qmin)<1)&(abs(qmax)<1)&(abs(umin)<1)&(abs(umax)<1) )
		qmin = -1;
		umin = -1;
		qmax = 1;
		umax = 1;
	end
	tmin=floor(min(binmeant_meansum*0.1))/0.1;
	tmax=ceil(max(binmeant_meansum*0.1))/0.1;
	
	%same for rotated parameters
	qRSPminval = min(floor(100 * (binweightedmeanqRSP_meansum-0.0005)*2)/2);
	qRSPmaxval = max(ceil( 100 * (binweightedmeanqRSP_meansum+0.0005)*2)/2);
	uRSPminval = min(floor(100 * (binweightedmeanuRSP_meansum-0.0005)*2)/2);
	uRSPmaxval = max(ceil( 100 * (binweightedmeanuRSP_meansum+0.0005)*2)/2);
	qRSPmin_minhalf = min(qRSPminval,-0.5);
	qRSPmax_minhalf = max(qRSPmaxval,0.5);
	uRSPmin_minhalf = min(uRSPminval,-0.5);
	uRSPmax_minhalf = max(uRSPmaxval,0.5);
	qRSPuRSPrange = max(abs([qRSPmax_minhalf-qRSPmin_minhalf uRSPmax_minhalf-uRSPmin_minhalf 2]));
	qRSPmin = (qRSPmax_minhalf+qRSPmin_minhalf)/2-0.5*qRSPuRSPrange;
	uRSPmin = (uRSPmax_minhalf+uRSPmin_minhalf)/2-0.5*qRSPuRSPrange;
	qRSPmax = (qRSPmax_minhalf+qRSPmin_minhalf)/2+0.5*qRSPuRSPrange;
	uRSPmax = (uRSPmax_minhalf+uRSPmin_minhalf)/2+0.5*qRSPuRSPrange;
	if( (abs(qRSPmin)<1)&(abs(qRSPmax)<1)&(abs(uRSPmin)<1)&(abs(uRSPmax)<1) )
		qRSPmin = -1;
		uRSPmin = -1;
		qRSPmax = 1;
		uRSPmax = 1;
	end
	
	%qRSPminval = min(floor(100 * (binweightedmeanqRSP_meansum-0.0005)*2)/2);
	%qRSPmaxval = max(ceil( 100 * (binweightedmeanqRSP_meansum+0.0005)*2)/2);
	%uRSPminval = min(floor(100 * (binweightedmeanuRSP_meansum-0.0005)*2)/2);
	%uRSPmaxval = max(ceil( 100 * (binweightedmeanuRSP_meansum+0.0005)*2)/2);
	%qRSPmin = qRSPminval;
	%qRSPmax = qRSPmaxval;
	%uRSPmin = uRSPminval;
	%uRSPmax = uRSPmaxval;

	%binweightedmeanq_meansum_plotrange = binweightedmeanq_meansum(find(binedgep1>4100 & binedgep1<7000));
	%binweightedmeanu_meansum_plotrange = binweightedmeanu_meansum(find(binedgep1>4100 & binedgep1<7000));
	%cvec_plotrange = cvec(find(binedgep1>4100 & binedgep1<7000),:);
	%binweightedmeanusig_meansum_plotrange = binweightedmeanusig_meansum(find(binedgep1>4100 & binedgep1<7000));
	%binweightedmeanqsig_meansum_plotrange = binweightedmeanqsig_meansum(find(binedgep1>4100 & binedgep1<7000));
	%binedgewav1_plotrange = binedgewav1(find(binedgewav1>4100 & binedgewav1<7000));
	%binweightedmeanqRSP_meansum_plotrange = binweightedmeanqRSP_meansum(find(binedgewav1>4100 & binedgewav1<7000));
	%binweightedmeanuRSP_meansum_plotrange = binweightedmeanuRSP_meansum(find(binedgewav1>4100 & binedgewav1<7000));
	%binedget1_plotrange = binedget1(find(binedgewav1>4100 & binedgewav1<7000));
	%binmeant_meansum_plotrange = binmeant_meansum(find(binedgewav1>4100 & binedgewav1<7000));

	%manual zoom for sn2023ixf plots
	qmin = -0.35;
	qmax = 0;
	umin = 0.15;
	umax = 0.5;
	qRSPmin = 0.2;
	qRSPmax = 0.6;
	uRSPmin = -0.1;
	uRSPmax = 0.1;
	tmin = 53;
	tmax = 70;

	set(0, 'CurrentFigure', plotting)
	clf
	subtightplot(3,2,[1 3 5],[0.0,0.0],0.05,0.1)
	hold all
	scatter(binweightedmeanq_meansum.*100,binweightedmeanu_meansum.*100,125,cvec,'filled','MarkerEdgeColor','k')
	for i=1:length(binweightedmeanq_meansum)
		plot_e1 = errorbar(binweightedmeanq_meansum(i).*100,binweightedmeanu_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100);
		set(plot_e1,'Color',cvec(i,:));
		if(i<length(binweightedmeanq_meansum))
			plot_p1 = plot(binweightedmeanq_meansum(i:i+1).*100,binweightedmeanu_meansum(i:i+1).*100);
			set(plot_p1,'Color',cvec(i,:));
		end
	end
	for i=1:25
	scatter(circx{i}.*100,circy{i}*100,75,'.','MarkerEdgeColor','k')
	end
	if(~isempty(options.ISPfitvals))
		if(run_noISPsub == 0)
			scatter(ISP_q(indx_Halphacorewav),ISP_u(indx_Halphacorewav),350,[0.1 0.1 0.1],'filled')
		end
	end
	if(~isempty(options.ISP))
		scatter(ISPcircx,ISPcircy,35,'*','MarkerEdgeColor','b')
		%%%need to make this vary dynamically with the various ISP values
		htext = text(qmin+0.05*(qmax-qmin),umin+0.05*(umax-umin),ISP.print,'interpreter','Latex','Color', 'blue','FontSize',30);
	end
	htext = text(qmin+0.05*(qmax-qmin),umax-0.5*0.1*(umax-umin),name, 'interpreter','LaTex','Color', 'black','FontSize',30);
	htext = text(qmin+0.05*(qmax-qmin),umax-1.0*0.1*(umax-umin),telescope,'interpreter','LaTex', 'Color', 'black','FontSize',30,'FontName','CMU Serif');
	htext = text(qmin+0.05*(qmax-qmin),umax-1.5*0.1*(umax-umin),reldateprint,'interpreter','LaTex', 'Color', 'black','FontSize',30,'FontName','CMU Serif');
	line([qmin qmax],[0 0],'LineStyle','-','Color',[0 0 0])
	line([0 0],[umin umax],'LineStyle','-','Color',[0 0 0])
	axis([[qmin qmax] [umin umax]])
	axis square
	box on
	xlabel('q (\%)','FontSize',28,'interpreter','latex')
	ylabel('u (\%)','FontSize',28,'interpreter','latex')
	ax1 = gca;
	if(size([ceil(qmin*2)/2:0.5:floor(qmax*2)/2],2)>8)
		qticks = [flip(-[0:max(floor((floor(qmax)-ceil(qmin))/6),1):abs(ceil(qmin))]) floor((floor(qmax)-ceil(qmin))/6):max(floor((floor(qmax)-ceil(qmin))/6),1):floor(qmax)];
		uticks = [flip(-[0:max(floor((floor(umax)-ceil(umin))/6),1):abs(ceil(umin))]) floor((floor(umax)-ceil(umin))/6):max(floor((floor(umax)-ceil(umin))/6),1):floor(umax)];
	else
		qticks = [ceil(qmin*2)/2:0.5:floor(qmax*2)/2];
		uticks = [ceil(umin*2)/2:0.5:floor(umax*2)/2];
	end
	if(sum(qticks==0)>1)
		rem0q_indx = find(qticks == 0);
		qticks = qticks([1:(rem0q_indx(2:end)-1) (rem0q_indx(2:end)+1):end]);
	end
	if(sum(uticks==0)>1)
		rem0u_indx = find(uticks == 0);
		uticks = uticks([1:(rem0u_indx(2:end)-1) (rem0u_indx(2:end)+1):end]);
	end
	set(ax1,'XTickMode','manual','XTick',qticks)
	set(ax1,'YTickMode','manual','YTick',uticks)
	axpos = get(gca, 'Position');
	set(gca, 'Position', [axpos(1) axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*1.00])
	set(ax1,'XTickMode','manual','XMinorTick','on','YMinorTick','on')
	set(ax1,'FontSize',24)

	subtightplot(3,2,[2],[0.01,0.075],0.05,0.1)
	hold all
	%original scaling
	plot(wav1,flx1/max(flx1)*(qRSPmax-qRSPmin)+qRSPmin,'Color',[0.2 0.2 0.2])
	%plot(wav1,(flx1-min(flx1))/max(flx1-min(flx1))*(qRSPmax-qRSPmin)+qRSPmin,'Color',[0.2 0.2 0.2])
	%filly = (flx1/max(flx1)*(pmaxpplot-pminpplot));
	%original scaling below
	a1=area(wav1,flx1/max(flx1)*(qRSPmax-qRSPmin)+qRSPmin,qRSPmin);
	%a1=area(wav1,(flx1-min(flx1))/max(flx1-min(flx1))*(qRSPmax-qRSPmin)+qRSPmin,qRSPmin);
	%a1=area(wav1,2*ones(length(wav1),1),pminpplot)
	%max(flx1/max(flx1)*(pmaxpplot-pminpplot))
	a1(1).FaceColor = [0.75 0.75 0.75];
	if(~isempty(options.Serkowski_template))
		plot(wav1,Serk_p,'LineStyle','-','Color',[1 0.5 0],'LineWidth',7)
	end
	%fill([wav1 max(wav1) min(wav1) min(wav1)],[(flx1/max(flx1)*0.095.*100*0.3) 0 0 filly(1)],[0.925 0.925 0.925]);
	for i=1:length(binedgewav1)-1
		plot_p1 = plot(binedgewav1(i:i+1),binweightedmeanqRSP_meansum(i:i+1).*100);
		set(plot_p1,'Color',cvec(i,:));
	end
	scatter(binedgewav1,binweightedmeanqRSP_meansum.*100,75,cvec,'filled','^','MarkerEdgeColor','k')
	axis([[lowbound uppbound] [qRSPmin qRSPmax]])
	for i=1:numcont
		scatter(mean(contrange(i,:)),100*contPbinp_meansum.opt{i},250,'black','filled');
		errorbar(mean(contrange(i,:)),100*contPbinp_meansum.opt{i},100*contPbinpsig_meansum{i},'Color',[0.2 0.2 0.2]);
		line(contrange(i,:),[100*contPbinp_meansum.opt{i} 100*contPbinp_meansum.opt{i}],'LineStyle','-','Color','black','LineWidth',4)
		%for only the two big cont ranges, plot a dotted line near the top for clarity
		%if(i<3)
		%	line(contrange(i,:),[qRSPmax-(qRSPmax-qRSPmin)*0.02 qRSPmax-(qRSPmax-qRSPmin)*0.02],'LineStyle','--','Color','black','LineWidth',1)
		%end
	end
	%line([3000 9000],[0.7 0.7],'LineStyle','--','Color','b')
	%htext = text(5150,3.6,reldateprint ,'interpreter','latex', 'Color', 'black','FontSize',30)
	%scatter(contPwav,100*contPpol,50,'black','filled')
	%scatter(contpR2wav,100*contpR2pol,50,'black','filled')
	%errorbar(contPwav,100*contPpol,100*contPpolsig,'Color',[0.2 0.2 0.2]);
	%errorbar(contpR2wav,100*contpR2pol,100*contpR2polsig,'Color',[0.2 0.2 0.2]);
	%line([5100 5700],[100*contPpol 100*contPpol],'LineStyle','-','Color','black','LineWidth',2)
	%line([6000 6300],[100*contpR2pol 100*contpR2pol],'LineStyle','-','Color','black','LineWidth',2)
	blah1 = line([6563 6563],[-100 100],'LineStyle','--','Color',[0 0 0]);
	blah2 = line([4861 4861],[-100 100],'LineStyle','--','Color',[0 0 0]);
	line([0 10000],[0 0],'LineStyle','--','Color',[0 0 0]);
	ylabel('qRSP (\%)','FontSize',28,'interpreter','latex')
	set(gca,'XTickLabel',[]);
	plot(smooth(wav1,10),smooth(p2_opt*100,10),'LineStyle',':','Color','black','LineWidth',2);
	%plot(wav1,p2_opt*100,'LineStyle',':','Color','black','LineWidth',2);
	%keyboard
	%chandle=cline(binedgewav1,binweightedmeanqRSP_meansum.*100,binedgewav1,cvec(find(binedgewav1>4100 & binedgewav1<7000)),'jet');
	%set(chandle,'linewidth',1);
	ax1 = gca;
	axpos = get(gca, 'Position');
	[axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*0.95];
	set(gca, 'Position', [axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.1 axpos(3)*0.95 axpos(4)*0.85])
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',28)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'XMinorTick','on','YMinorTick','on')
	box on
	if(qRSPmax-qRSPmin<4)
		qRSPyticklabels = qRSPmin:0.5:qRSPmax;
	else
		%qRSPyticklabels = qRSPmin:1:qRSPmax;
		qRSPyticklabels = [flip(-[0:max([floor((floor(qRSPmax)-ceil(qRSPmin))/6),0.5]):abs(ceil(qRSPmin))]) floor((floor(qRSPmax)-ceil(qRSPmin))/6):max(floor((floor(qRSPmax)-ceil(qRSPmin))/6),0.5):floor(qRSPmax)];
	end
	if(sum(qRSPyticklabels==0)>1)
		rem0q_indx = find(qRSPyticklabels == 0);
		qRSPyticklabels = qRSPyticklabels([1:(rem0q_indx(2:end)-1) (rem0q_indx(2:end)+1):end]);
	end
	set(ax1,'YTickMode','manual','YTick',qRSPyticklabels)
	set(ax1,'FontSize',24)
	set(ax1,'xlim',[lowbound uppbound])
	set(ax1,'Layer','top')


	subtightplot(3,2,[4],[0.01,0.075],0.05,0.1)
	hold all
	plot(wav1,flx1/max(flx1)*(uRSPmax-uRSPmin)+uRSPmin,'Color',[0.2 0.2 0.2])
	%filly = (flx1/max(flx1)*(pmaxpplot-pminpplot));
	a1=area(wav1,flx1/max(flx1)*(uRSPmax-uRSPmin)+uRSPmin,uRSPmin);
	%a1=area(wav1,2*ones(length(wav1),1),pminpplot)
	%max(flx1/max(flx1)*(pmaxpplot-pminpplot))
	a1(1).FaceColor = [0.75 0.75 0.75];
	%fill([wav1 max(wav1) min(wav1) min(wav1)],[(flx1/max(flx1)*0.095.*100*0.3) 0 0 filly(1)],[0.925 0.925 0.925]);
	scatter(binedgewav1,binweightedmeanuRSP_meansum.*100,75,cvec,'filled','^','MarkerEdgeColor','k')
	axis([[lowbound uppbound] [uRSPmin uRSPmax]])
	blah1 = line([6563 6563],[-100 100],'LineStyle','--','Color',[0 0 0]);
	blah2 = line([4861 4861],[-100 100],'LineStyle','--','Color',[0 0 0]);
	line([0 10000],[0 0],'LineStyle','--','Color',[0 0 0]);
	ylabel('uRSP (\%)','FontSize',28,'interpreter','latex')
	set(gca,'XTickLabel',[]);
	for i=1:length(binedgewav1)-1
		plot_p1 = plot(binedgewav1(i:i+1),binweightedmeanuRSP_meansum(i:i+1).*100);
		set(plot_p1,'Color',cvec(i,:));
	end
	%chandle=cline(binedgewav1,binweightedmeanuRSP_meansum.*100,binedgewav1,cvec(find(binedgewav1>4100 & binedgewav1<7000)),'jet');
	%set(chandle,'linewidth',1);
	ax1 = gca;
	axpos = get(gca, 'Position');
	[axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*0.95];
	set(gca, 'Position', [axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.125 axpos(3)*0.95 axpos(4)*0.85])
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',28)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'XMinorTick','on','YMinorTick','on')
	if(uRSPmax-uRSPmin<4)
		uRSPyticklabels = uRSPmin:0.5:uRSPmax;
	else
		%uRSPyticklabels = uRSPmin:1:uRSPmax;
		uRSPyticklabels = [flip(-[0:max(floor((floor(uRSPmax)-ceil(uRSPmin))/6),0.5):abs(ceil(uRSPmin))]) floor((floor(uRSPmax)-ceil(uRSPmin))/6):max(floor((floor(uRSPmax)-ceil(uRSPmin))/6),0.5):floor(uRSPmax)];
	end
	if(sum(uRSPyticklabels==0)>1)
		rem0u_indx = find(uRSPyticklabels == 0);
		uRSPyticklabels = uRSPyticklabels([1:(rem0u_indx(2:end)-1) (rem0u_indx(2:end)+1):end]);
	end
	set(ax1,'YTickMode','manual','YTick',uRSPyticklabels)
	set(ax1,'FontSize',24)
	set(ax1,'xlim',[lowbound uppbound])
	%xlabel(ax1,'Rest Wavelength ($\rm{\AA}$) ','interpreter','LaTex','FontSize',28);
	set(ax1,'Layer','top')

	subtightplot(3,2,[6],[0.01,0.075],0.05,0.1)
	hold all
	plot(wav1,flx1/max(flx1)*(tmax-tmin)+tmin,'Color',[0.2 0.2 0.2])
	%plot(wav1,flx1/max(flx1)*0.095.*100*4.10*3.5,'Color',[0.2 0.2 0.2])
	filly = (flx1/max(flx1)*(tmax-tmin)+tmin);
	a1=area(wav1,flx1/max(flx1)*(tmax-tmin)+tmin,tmin);
	a1(1).FaceColor = [0.75 0.75 0.75];
	%fill([wav1 max(wav1) min(wav1) min(wav1)],[(flx1/max(flx1)*0.095.*100*4.10*3.5) 0 0 filly(1)],[0.925 0.925 0.925]);
	scatter(binedget1,binmeant_meansum,75,cvec,'filled','^','MarkerEdgeColor','k')
	%if(offsettheta ==1)
	%	axis([[4100 7000] [-90 90]])
	%else
	%	axis([[4100 7000] [0 180]])
	%end
	axis([[4100 7000] [tmin tmax]])
	blah1 = line([6563 6563],[0 200],'LineStyle','--','Color',[0 0 0]);
	blah2 = line([4861 4861],[0 200],'LineStyle','--','Color',[0 0 0]);
	ylabel('$\theta(^{\circ})$','FontSize',28,'interpreter','latex')
	%set(gca,'XTickLabel',[]);
	for i=1:length(binedget1)-1
		plot_p1 = plot(binedget1(i:i+1),binmeant_meansum(i:i+1));
		set(plot_p1,'Color',cvec(i,:));
	end
	if(tmin == -90)
		for i =1:size(t2_smooth,1)
			if(t2_smooth(i)>90)
				t2_smooth(i) = t2_smooth(i)-180;
			end
		end
		plot(wav1,t2_smooth,'LineStyle',':','Color','black','LineWidth',2);
	else
		plot(wav1,t2_smooth,'LineStyle',':','Color','black','LineWidth',2);
	end
	%chandle=cline(binedget1,binmeant_meansum,binedget1,cvec(find(binedget1>4100)),'jet');
	%set(chandle,'linewidth',1);
	ax1 = gca;
	axpos = get(gca, 'Position');
	[axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*0.95];
	set(gca, 'Position', [axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.35 axpos(3)*0.95 axpos(4)*0.65])
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',28)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'XMinorTick','on','YMinorTick','on')
	%set(ax1,'YTickMode','manual','YTick',[0 90 180])
	set(ax1,'YTickMode','manual','YTick',tmin:round((tmax-tmin)/3*(2/10))*10/2:tmax)
	set(ax1,'FontSize',24)
	set(ax1,'xlim',[lowbound uppbound])
	xlabel(ax1,'Rest Wavelength ($\rm{\AA}$) ','interpreter','LaTex','FontSize',28);
	set(ax1,'Layer','top')

	saveas(plotting, [filename], 'epsc');
	eval(['!epstopdf ' filename]);

	close(plotting)

	%contrange middle calculation
	for i=1:size(contrange,1)
		contmidvalue(i) = (contrange(i,1)+contrange(i,2))/2;
	end

	print_results = [];
	for i=1:numcont
		print_contdata{i} = [num2str(contPbinp_meansum.opt{i}),' ',num2str(contPbinpsig_meansum{i}),' ',num2str(tcont{i}),' ',num2str(tcontsig{i}),' ',num2str(contPbinweightedmeanq_meansum{i}),' ',num2str(contPbinweightedmeanqsig_meansum{i}),' ',num2str(contPbinweightedmeanu_meansum{i}),' ',num2str(contPbinweightedmeanusig_meansum{i}),' ',num2str(contmidvalue(i)),' ']
		print_results = [print_results print_contdata{i}]
	end

	%output continuum polarization region data to file
	filename_data_contpol = strcat(dataoutputdirectory,'data_contpol.txt');
	name_nows = name;
	name_nows(name_nows == ' ') = [];
	results_contpol = [name_nows,' ',telescope,' ',date,' ',num2str(reldate),' ',print_results]
	dlmwrite(filename_data_contpol,results_contpol,'-append','delimiter','');

	%set(plottingmulti,'PaperUnits','normalized','PaperPosition',[0 0 1 1]);
	%set(plottingmulti,'PaperUnits','pixels','PaperPosition',[0 0 1000 1000]);

	%make new 4 panel figure that continues through each run
	%if ispfitvals exists, start contributing to 4 panel figure)
	if(~isempty(options.ISPfitvals))
		%subtightplot to specific figure, if run_noISPsub = 0, plot in first row, else plot in 2nd row
		%initialize figure if it is the first run
		if(run_noISPsub == 0)
			plottingmulti = figure;
			clf
			set(gcf,'color','w');
			set(gcf,'renderer','painters')
			%set(plottingmulti,'units','normalized','outerposition',[0 0 1 1]);
			set(plottingmulti,'units','pixels','outerposition',[0 0 1000 1000]);
			colormap jet
		end
		
		sgtitle([name ' ' telescope ' ' reldateprint],'interpreter','LaTeX','FontSize',28);
		set(0, 'CurrentFigure',plottingmulti)
		if(run_noISPsub == 0)
			subtightplot(2,2,1,[0.01,0.01],[0.0 0.00],[0.00 0])
			%subplot(2,2,1)
			set(gca,'Position',[0.1 0.525 0.4 0.4])
		else
			%subplot(2,2,3)
			subtightplot(2,2,3,[0.01,0.01],0.0,0.0)
			set(gca,'Position',[0.1 0.08 0.4 0.4])
		end
		hold all
		scatter(binweightedmeanq_meansum.*100,binweightedmeanu_meansum.*100,125,cvec,'filled','MarkerEdgeColor','k')
		for i=1:length(binweightedmeanq_meansum)
			plot_e1 = errorbar(binweightedmeanq_meansum(i).*100,binweightedmeanu_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100);
			set(plot_e1,'Color',cvec(i,:));
			if(i<length(binweightedmeanq_meansum))
				plot_p1 = plot(binweightedmeanq_meansum(i:i+1).*100,binweightedmeanu_meansum(i:i+1).*100);
				set(plot_p1,'Color',cvec(i,:));
			end
		end
		for i=1:25
			scatter(circx{i}.*100,circy{i}*100,25,'.','MarkerEdgeColor','k');
		end
		if(run_noISPsub == 0)
			scatter(ISP_q(indx_Halphacorewav),ISP_u(indx_Halphacorewav),350,[0.1 0.1 0.1],'filled');
		else
			htext = text(qmin+0.05*(qmax-qmin),umax-0.05*(umax-umin),'ISP-Corrected','interpreter','Latex','Color', 'black','FontSize',22);
		end
		if(~isempty(options.ISP))
			scatter(ISPcircx,ISPcircy,25,'*','MarkerEdgeColor','b');
			%%%need to make this vary dynamically with the various ISP values
			if(run_noISPsub == 0)
				htext = text(qmin+0.05*(qmax-qmin),umin+0.05*(umax-umin),ISP.print,'interpreter','Latex','Color', 'blue','FontSize',22);
			end
		end
		
		if(run_noISPsub == 0)
			noISPsubqmax = qmax;
			noISPsubqmin = qmin;
			noISPsubumax = umax;
			noISPsubumin = umin;
		end
		%axis([[qmin qmax] [umin umax]])
		line([noISPsubqmin noISPsubqmax],[0 0],'LineStyle','-','Color',[0 0 0])
		line([0 0],[noISPsubumin noISPsubumax],'LineStyle','-','Color',[0 0 0])
		axis([[noISPsubqmin noISPsubqmax] [noISPsubumin noISPsubumax]])		
		axis square
		box on
		ax1 = gca;
		axpos = get(gca, 'Position');
		%set(gca, 'Position', [axpos(1) axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*1.00])
		set(ax1,'XMinorTick','on','YMinorTick','on')
		set(ax1,'FontSize',16)
		if(run_noISPsub == 1)
			xlabel('q (\%)','FontSize',24,'interpreter','latex')
		end
		ylabel('u (\%)','FontSize',24,'interpreter','latex')

		%code for rotated qu panel
		set(0, 'CurrentFigure',plottingmulti)
		if(run_noISPsub == 0)
			%subplot(2,2,2)
			subtightplot(2,2,2,[0.01,0.01],[0.0 0.00],[0.00 0.0])
			set(gca,'Position',[0.5 0.525 0.4 0.4])
		else
			%subplot(2,2,4)
			subtightplot(2,2,4,[0.01,0.01],0.0,0.0)
			set(gca,'Position',[0.5 0.08 0.4 0.4])
		end
		hold all
		scatter(binweightedmeanqRSP_meansum.*100,binweightedmeanuRSP_meansum.*100,125,cvec,'filled','MarkerEdgeColor','k')
		for i=1:length(binweightedmeanqRSP_meansum)
			plot_e1 = errorbar(binweightedmeanqRSP_meansum(i).*100,binweightedmeanuRSP_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100);
			set(plot_e1,'Color',cvec(i,:));
			if(i<length(binweightedmeanqRSP_meansum))
				plot_p1 = plot(binweightedmeanqRSP_meansum(i:i+1).*100,binweightedmeanuRSP_meansum(i:i+1).*100);
				set(plot_p1,'Color',cvec(i,:));
			end
		end
		for i=1:25
			scatter(circx{i}.*100,circy{i}*100,25,'.','MarkerEdgeColor','k')
		end
		if(run_noISPsub == 0)
			scatter(ISP_p(indx_Halphacorewav),0,350,[0.1 0.1 0.1],'filled')
			htext = text(qRSPmin+0.05*(qRSPmax-qRSPmin),uRSPmax-0.05*(uRSPmax-uRSPmin),'Rotated','interpreter','Latex','Color', 'black','FontSize',22);
		else
			htext = text(qRSPmin+0.05*(qRSPmax-qRSPmin),uRSPmax-0.05*(uRSPmax-uRSPmin),'ISP-Corrected, Rotated','interpreter','Latex','Color', 'black','FontSize',22);
		end
		
		if(~isempty(options.ISP))
			scatter(ISPcircx,ISPcircy,25,'*','MarkerEdgeColor','b')
		end
		
		if(run_noISPsub == 0)
			noISPsubqRSPmax = qRSPmax;
			noISPsubqRSPmin = qRSPmin;
			noISPsubuRSPmax = uRSPmax;
			noISPsubuRSPmin = uRSPmin;
		end
		line([noISPsubqRSPmin noISPsubqRSPmax],[0 0],'LineStyle','-','Color',[0 0 0])
		line([0 0],[noISPsubuRSPmin noISPsubuRSPmax],'LineStyle','-','Color',[0 0 0])
		%axis([[qmin qmax] [umin umax]])
		axis([[noISPsubqRSPmin noISPsubqRSPmax] [noISPsubuRSPmin noISPsubuRSPmax]])
		%axis([[qRSPmin qRSPmax] [uRSPmin uRSPmax]])
		axis square
		box on
		ax1 = gca;
		axpos = get(gca, 'Position');
		set(ax1,'XMinorTick','on','YMinorTick','on')
		set(ax1,'FontSize',16)
		if(run_noISPsub == 1)
			xlabel('q (\%)','FontSize',24,'interpreter','latex')
		end


		%at end of 4 panel figure code, if run_noISPsub==1, save figure as complete result
		if(run_noISPsub == 1)
				saveas(plottingmulti, [filenamemulti], 'epsc');
				eval(['!epstopdf ' filenamemulti]);
				close(plottingmulti);
		end

	%end for if ISP exact exists, making the 4 panel figure
	end


run_noISPsub = 1;
run = run -1;
%end while run>0
end




%function end
end













%%%discontinued code

%removed 2021-03-07 for a truncated version instead
%	clf
%	subtightplot(3,2,[1 3 5],[0.0,0.0],0.05,0.1)
%	hold all
%	scatter(binweightedmeanq_meansum.*100,binweightedmeanu_meansum.*100,125,cvec,'filled','MarkerEdgeColor','k')
%	for i=1:length(binweightedmeanq_meansum)
%		plot_e1 = errorbar(binweightedmeanq_meansum(i).*100,binweightedmeanu_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanusig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100,binweightedmeanqsig_meansum(i).*100);
%		set(plot_e1,'Color',cvec(i,:));
%		if(i<length(binweightedmeanq_meansum))
%			plot_p1 = plot(binweightedmeanq_meansum(i:i+1).*100,binweightedmeanu_meansum(i:i+1).*100)
%			set(plot_p1,'Color',cvec(i,:));
%		end
%	end
%	for i=1:10
%	scatter(circx{i}.*100,circy{i}*100,75,'.','MarkerEdgeColor','k')
%	end
%	%if(~isempty(options.ISPexact))
%	%	scatter(options.ISPexact(1)*100,options.ISPexact(2)*100,350,'filled')
%	%end
%	if(~isempty(options.ISP))
%		scatter(ISPcircx,ISPcircy,35,'*','MarkerEdgeColor','b')
%		%%%need to make this vary dynamically with the various ISP values
%		htext = text(qmin+0.05*(qmax-qmin),umin+0.05*(umax-umin),ISP.print,'interpreter','Latex','Color', 'blue','FontSize',30)
%	end
%	htext = text(qmin+0.05*(qmax-qmin),umax-0.5*0.1*(umax-umin),name, 'interpreter','LaTex','Color', 'black','FontSize',30)
%	htext = text(qmin+0.05*(qmax-qmin),umax-1.0*0.1*(umax-umin),telescope,'interpreter','LaTex', 'Color', 'black','FontSize',30,'FontName','CMU Serif')
%	htext = text(qmin+0.05*(qmax-qmin),umax-1.5*0.1*(umax-umin),reldateprint,'interpreter','LaTex', 'Color', 'black','FontSize',30,'FontName','CMU Serif')
%	%htext = text(-0.6,4.2,date,'interpreter','none', 'Color', 'black','FontSize',22)
%	line([qmin qmax],[0 0],'LineStyle','-','Color',[0 0 0])
%	line([0 0],[umin umax],'LineStyle','-','Color',[0 0 0])
%	%chandle=cline(binweightedmeanq_meansum.*100,binweightedmeanu_meansum.*100,binweightedmeanq_meansum.*100,cvec,'jet');
%	%set(chandle,'linewidth',1);
%	axis([[qmin qmax] [umin umax]])
%	axis square
%	box on
%	xlabel('q (\%)','FontSize',28,'interpreter','latex')
%	ylabel('u (\%)','FontSize',28,'interpreter','latex')
%	ax1 = gca;
%	%badindexq = [];
%	%badindexu = [];
%	%qticks = qmin:0.25:qmax;
%	%uticks = umin:0.25:umax;
%	%for i=2:size(qticks,2)-1
%	%	if(~mod(qticks(i),0.5)==0)
%	%		badindexq = [badindexq i];
%	%	end
%	%end
%	%qticks(badindexq) = [];
%	%for i=2:size(uticks,2)-1
%	%	if(~mod(uticks(i),0.5)==0)
%	%		badindexu = [badindexu i];
%	%	end
%	%end
%	%uticks(badindexu) = [];
%	if(size([ceil(qmin*2)/2:0.5:floor(qmax*2)/2],2)>8)
%		qticks = [ceil(qmin*2)/2:1:floor(qmax*2)/2];
%		uticks = [ceil(umin*2)/2:1:floor(umax*2)/2];
%	else
%		qticks = [ceil(qmin*2)/2:0.5:floor(qmax*2)/2];
%		uticks = [ceil(umin*2)/2:0.5:floor(umax*2)/2];
%	end
%	set(ax1,'XTickMode','manual','XTick',[ceil(qmin*2)/2:0.5:floor(qmax*2)/2])
%	set(ax1,'YTickMode','manual','YTick',[ceil(umin*2)/2:0.5:floor(umax*2)/2])
%	%set(ax1,'XTickMode','manual','XTick',qticks)
%	%set(ax1,'YTickMode','manual','YTick',uticks)
%	axpos = get(gca, 'Position')
%	set(gca, 'Position', [axpos(1) axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*1.00])
%	%ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
%	%ylabel(ax2,'','FontSize',28)
%	%xlabel(ax2,'')
%	%set(ax2,'xtick',[],'YTick',[])
%	set(ax1,'XTickMode','manual','XMinorTick','on','YMinorTick','on')
%	set(ax1,'FontSize',24)































%if (j==1)
%	%DEPENDS ON COMPUTER BEING USED
%	figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\newplots\Traditional_';
%elseif(j==2)
%	%DEPENDS ON COMPUTER BEING USED
%	figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\newplots\Debiased_';
%elseif(j==3)
%	%DEPENDS ON COMPUTER BEING USED
%	figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\newplots\Optimal_';
%elseif(j==4)
%	%DEPENDS ON COMPUTER BEING USED
%	figuredirectory = 'c:\Users\Cbilinski\Desktop\Figures\newplots\RSP_';
%end 


%plotting1 = figure;
%clf
%hold all
%plot(t1,t2)
%plot(smooth(t1,200),smooth(t2,200))
%box on
%filenametheta = strcat(figuredirectory,'smooththeta',name,date,'.eps');
%saveas(plotting1, [filenametheta], 'epsc');
%eval(['!epstopdf ' filenametheta]);
%close(plotting1)


%if((q2.^2+u2.^2)-(qsig_rms.^2 + usig_rms.^2)<0)
%	p2_deb_rms = -sqrt(abs((q2.^2+u2.^2) -(qsig_rms.^2 + usig_rms.^2)));
%else
%	p2_deb_rms = sqrt(abs((q2.^2+u2.^2) -(qsig_rms.^2 + usig_rms.^2)));
%end
%
%psig_rms = sqrt((qsig_rms.*q2./p2).^2+(usig_rms.*u2./p2).^2);
%p2_opt_rms = p2 - (psig_rms.^2./p2);

%plotting1 = figure;
%clf
%plot(p1,smooth(p2,15),'Color',[0 0 0],'LineWidth',1)
%hold all
%plot(p1,smooth(p2_deb,15),'Color',[1 0 0],'LineWidth',1)
%plot(p1,smooth(qRSP,15),'Color',[0 1 0],'LineWidth',1)
%plot(p1,smooth(uRSP,15),'Color',[0 1 0],'LineWidth',1)
%plot(p1,smooth(p2_opt,15),'Color',[0 0 1],'LineWidth',1)
%axis([[3800 7900] [0.00 0.045]])
%box on
%legend('Traditional','Debiased','qRSP','uRSP','Optimal')
%filename4pol = strcat(figuredirectory,'4polarization',name,date,'.eps');
%saveas(plotting1, [filename4pol], 'epsc');
%eval(['!epstopdf ' filename4pol]);
%close(plotting1)

%plotting1 = figure;
%clf
%plot(p1,smooth(p2,15),'Color',[0 0 0],'LineWidth',1)
%hold all
%
%size(p1)
%size(p2_deb_rms)

%plot(p1,smooth(p2_deb_rms,15),'Color',[1 0 0],'LineWidth',1)
%plot(p1,smooth(qRSP,15),'Color',[0 1 0],'LineWidth',1)
%plot(p1,smooth(uRSP,15),'Color',[0 1 0],'LineWidth',1)
%plot(p1,smooth(p2_opt_rms,15),'Color',[0 0 1],'LineWidth',1)
%axis([[3800 7900] [0.00 0.045]])
%box on
%legend('Traditional','Debiased','qRSP','uRSP','Optimal')
%filename4pol_rms = strcat(figuredirectory,'4polarization_rms',name,date,'.eps');
%saveas(plotting1, [filename4pol_rms], 'epsc');
%eval(['!epstopdf ' filename4pol_rms]);
%close(plotting1)
%
%plotting1 = figure;
%clf
%hold all
%plot(p1,qsig,'LineWidth',2)
%plot(p1,usig,'LineWidth',2)
%plot(p1,qsig_rms,'LineWidth',2)
%plot(p1,usig_rms,'LineWidth',2)
%legend('qsig','usig','qsig_{rms}','usig_{rms}')
%box on
%filenamesigvssigrms = strcat(figuredirectory,'sigvssigrms',name,date,'.eps');
%saveas(plotting1, [filenamesigvssigrms], 'epsc');
%eval(['!epstopdf ' filenamesigvssigrms]);
%close(plotting1)

%if (j==1)
%	q2=q2;
%	u2=u2;
%elseif(j==2)
%	q2=q2;
%	u2=u2;
%elseif(j==3)
%	q2=q2;
%	u2=u2;
%elseif(j==4)
%	q2=qRSP;
%	u2=uRSP;
%end 


%if (j==1)
%	contpR1p_meansum = contpR1binp_meansum;
%elseif(j==2)
%	if (contpR1binp_meansum - (contpR1binweightedmeanqsig_meansum^2+contpR1binweightedmeanusig_meansum^2)  < 0)
%		contpR1p_meansum = -1 * sqrt(abs(contpR1binp_meansum^2 - (contpR1binweightedmeanqsig_meansum^2+contpR1binweightedmeanusig_meansum^2)));
%	else
%		contpR1p_meansum = sqrt(abs(contpR1binp_meansum^2 - (contpR1binweightedmeanqsig_meansum^2+contpR1binweightedmeanusig_meansum^2)));
%	end
%elseif(j==3)
%	if (contpR1binp_meansum - contpR1binpsig_meansum  < 0)
%		contpR1p_meansum = contpR1binp_meansum - (contpR1binpsig_meansum^2)./contpR1binp_meansum;
%	end
%elseif(j==4)
%	contpR1p_meansum = contpR1binp_meansum;
%end 

%if (contpR1binp_meansum - contpR1binpsig_meansum  < 0)
%	contpR1p_opt_meansum = -1 * sqrt(abs(contpR1binp_meansum^2 - contpR1binpsig_meansum^2));
%else
%	contpR1p_opt_meansum = sqrt(abs(contpR1binp_meansum^2 - contpR1binpsig_meansum^2));
%end

%contpR2wav = 6150;
%contpR2binmembersq = q2(wav1>6000&wav1<6300);
%contpR2binmembersqsig = qsig(wav1>6000&wav1<6300);
%contpR2binmembersu = u2(wav1>6000&wav1<6300);
%contpR2binmembersusig = usig(wav1>6000&wav1<6300);
%contpR2binmembersqsum = qsum(wav1>6000&wav1<6300);
%contpR2binmeanqsum = mean(contpR2binmembersqsum);            %
%contpR2binsumqsum = sum(contpR2binmembersqsum);
%contpR2binmembersusum = usum(wav1>6000&wav1<6300);
%contpR2binmeanusum = mean(contpR2binmembersusum);            %
%contpR2binsumusum = sum(contpR2binmembersusum);
%
%contpR2binweightedmeanq_meansum = sum(contpR2binmembersq.*contpR2binmembersqsum)/(contpR2binmeanqsum*length(contpR2binmembersq));             %
%contpR2binweightedmeanu_meansum = sum(contpR2binmembersu.*contpR2binmembersusum)/(contpR2binmeanusum*length(contpR2binmembersu));             %
%
%contpR2binweightedmeanqsig_meansum = sqrt(sum((contpR2binmembersqsig.*contpR2binmembersqsum/(contpR2binmeanqsum*length(contpR2binmembersq))).^2));      %
%contpR2binweightedmeanusig_meansum = sqrt(sum((contpR2binmembersusig.*contpR2binmembersusum/(contpR2binmeanusum*length(contpR2binmembersu))).^2));      %
%
%contpR2binp_meansum = sqrt(contpR2binweightedmeanq_meansum^2 + contpR2binweightedmeanu_meansum^2);
%contpR2binpsig_meansum = sqrt((contpR2binweightedmeanqsig_meansum*contpR2binweightedmeanq_meansum/contpR2binp_meansum)^2+(contpR2binweightedmeanusig_meansum*contpR2binweightedmeanu_meansum/contpR2binp_meansum)^2)
%
%if (j==1)
%	contpR2p_meansum = contpR2binp_meansum;
%elseif(j==2)
%	if (contpR2binp_meansum - (contpR2binweightedmeanqsig_meansum^2+contpR2binweightedmeanusig_meansum^2)  < 0)
%		contpR2p_meansum = -1 * sqrt(abs(contpR2binp_meansum^2 - (contpR2binweightedmeanqsig_meansum^2+contpR2binweightedmeanusig_meansum^2)));
%	else
%		contpR2p_meansum = sqrt(abs(contpR2binp_meansum^2 - (contpR2binweightedmeanqsig_meansum^2+contpR2binweightedmeanusig_meansum^2)));
%	end
%elseif(j==3)
%	if (contpR2binp_meansum - contpR2binpsig_meansum  < 0)
%		contpR2p_meansum = contpR2binp_meansum - (contpR2binpsig_meansum^2)./contpR2binp_meansum;
%	end
%elseif(j==4)
%	contpR2p_meansum = contpR2binp_meansum;
%end 
%
%%if (contpR2binp_meansum - contpR2binpsig_meansum  < 0)
%%	contpR2p_opt_meansum = -1 * sqrt(abs(contpR2binp_meansum^2 - contpR2binpsig_meansum^2));
%%else
%%	contpR2p_opt_meansum = sqrt(abs(contpR2binp_meansum^2 - contpR2binpsig_meansum^2));
%%end


%if (j==1)
%	p_meth_meansum = p_meansum;
%elseif(j==2)
%	for i = 1:size(p_meansum,2)
%		if( p_meansum(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2) < 0)
%			p_meth_meansum(i) = -1 * sqrt(abs(p_meansum(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2)));
%		else
%			p_meth_meansum(i) = sqrt(abs(p_meansum(i)^2 - (binweightedmeanqsig_meansum(i)^2+binweightedmeanusig_meansum(i)^2)));
%		end
%	end
%elseif(j==3)
%	for i = 1:size(p_meansum,2)
%		if( p_meansum(i) - (psig_meansum(i)^2/p_meansum(i)) < 0)
%			p_meth_meansum(i) = -1 * abs(p_meansum(i) - (psig_meansum(i)^2/p_meansum(i)));
%		else
%			p_meth_meansum(i) = abs(p_meansum(i) - (psig_meansum(i)^2/p_meansum(i)));
%		end
%	end
%elseif(j==4)
%	p_meth_meansum = p_meansum;
%end 
%

%	binmeant = binmeant_meansum;
%	binweightedmeanq = binweightedmeanq_meansum;
%	binweightedmeanu = binweightedmeanu_meansum;
%	binweightedmeanusig = binweightedmeanusig_meansum;
%	binweightedmeanqsig = binweightedmeanqsig_meansum;
%	binweightedmeanp = p_meth_meansum;
%	contpR1pol = contpR1p_meansum;
%	contpR1polsig = contpR1binpsig_meansum;
%	contpR2pol = contpR2p_meansum;
%	contpR2polsig = contpR2binpsig_meansum;

%ang1=linspace(0,2*pi,100);
%ang2=linspace(0,2*pi,200);
%ang3=linspace(0,2*pi,300);
%ang4=linspace(0,2*pi,400);
%ang5=linspace(0,2*pi,500);
%circx1=0.01*cos(ang1);
%circy1=0.01*sin(ang1);
%circx2=0.02*cos(ang2);
%circy2=0.02*sin(ang2);
%circx3=0.03*cos(ang3);
%circy3=0.03*sin(ang3);
%circx4=0.04*cos(ang4);
%circy4=0.04*sin(ang4);
%circx5=0.04*cos(ang5);
%circy5=0.04*sin(ang5);


%qcoord =100*round(median(q2),2);
%qmin = min([100*round((median(q2)-std(q2)^2-std(u2)^2),2),qcoord-2,-1]);
%qmax = max([100*round((median(q2)+std(q2)^2+std(u2)^2),2),qcoord+2,1]);
%
%ucoord = 100*round(median(u2),2);
%umin =  min([100*round((median(u2)-std(q2)^2-std(u2)^2),2),ucoord-2,-1]);
%umax =  max([100*round((median(u2)+std(q2)^2+std(u2)^2),2),ucoord+2,1]);
%
%pcoord = 100*round(median(p2),2);
%pmin =  real(min([100*round((median(p2)-std(p2)^2),2),pcoord-2,0]));
%pmax =  real(max([100*round((median(p2)+std(p2)^2),2),pcoord+2,1]));

%if((qmax-qmin)>(umax-umin))
%	if(ucoord>=0)
%		umax = umax+1;
%	end
%	if(ucoord<0)
%		umin = umin-1;
%	end
%end
%
%if((umax-umin)>(qmax-qmin))
%	if(qcoord>=0)
%		qmax = qmax+1;
%	end
%	if(qcoord<0)
%		qmin = qmin-1;
%	end
%end
%
%if(qmax>8)
%	qmax = 8;
%end
%
%if(qmin<-8)
%	qmin = -8;
%end
%
%if(umax>8)
%	umax = 8;
%end
%
%if(umin<-8)
%	umin = -8;
%end
%
%if(pmax>8)
%	pmax = 8;
%end
%
%if(pmin<-8)
%	pmin = -8;
%end


%qmaxqplot = qmax;
%qminqplot = qmin;
%umaxuplot = umax;
%uminuplot = umin;
%pmaxpplot = pmax;
%pminpplot = pmin;

%while((qmaxqplot-1) > 100*max(binweightedmeanq))
%	qmaxqplot = qmaxqplot-1;
%end
%
%while((qminqplot+1) < 100*min(binweightedmeanq))
%	qminqplot = qminqplot+1;
%end
%
%while((umaxuplot-1) > 100*max(binweightedmeanu))
%	umaxuplot = umaxuplot-1;
%end
%
%while((uminuplot+1) < 100*min(binweightedmeanu))
%	uminuplot = uminuplot+1;
%end
%
%while((pmaxpplot-1) > 100*max(binweightedmeanp))
%	pmaxpplot = pmaxpplot-1;
%end
%
%pmaxpplot
%100*max(binweightedmeanp)
%pminpplot
%100*min(binweightedmeanp)
%
%
%qmaxqplot
%100*max(binweightedmeanq)
%binweightedmeanq
%mean(binweightedmeanq)
%
%while((pminpplot+1) < 100*min(binweightedmeanp))
%	pminpplot = pminpplot+1;
%end


  %
	%binmeant = binmeant_meansum;
	%binweightedmeanq = binweightedmeanq_meansum;
	%binweightedmeanu = binweightedmeanu_meansum;
	%binweightedmeanusig = binweightedmeanusig_meansum;
	%binweightedmeanqsig = binweightedmeanqsig_meansum;
	%binweightedmeanp = p_opt_meansum;
	%contpR1pol = contpR1p_opt_meansum;
	%contpR1polsig = contpR1binpsig_meansum;
	%contpR2pol = contpR2p_opt_meansum;
	%contpR2polsig = contpR2binpsig_meansum;
	%filename = strcat(figuredirectory,'QU_meansum',name,date,'.eps');


%if((qmax+1) < 100*max(binweightedmeanq))
%	qmaxqplot = qmax+1;
%else
%	qmaxqplot = qmax;
%end
%
%if((qmin+1) < 100*min(binweightedmeanq))
%	qminqplot = qmin+1;
%else
%	qminqplot = qmin;
%end
%
%if((umax-1) > 100*max(binweightedmeanu))
%	umaxuplot = umax-1;
%else
%	umaxuplot = umax;
%end
%
%if((umin+1) < 100*min(binweightedmeanu))
%	uminuplot = umin+1;
%else
%	uminuplot = umin;
%end
%
%if((pmax-1) > 100*max(binweightedmeanp))
%	pmaxpplot = pmax-1;
%else
%	pmaxpplot = pmax;
%end
%
%if((pmin+1) < 100*min(binweightedmeanp))
%	pminpplot = pmin+1;
%else
%	pminpplot = pmin;
%end

%qminqplot = -3;
%qmaxqplot = 3;
%pminpplot = -1;
%pmaxpplot = 3;
%uminuplot = -3;
%umaxuplot = 3;

	%binmeant = binmeant_meansum;
	%binweightedmeanq = binweightedmeanq_meansum;
	%binweightedmeanu = binweightedmeanu_meansum;
	%binweightedmeanusig = binweightedmeanusig_meansum;
	%binweightedmeanqsig = binweightedmeanqsig_meansum;
	%binweightedmeanp = p_meth_meansum;
	%contpR1pol = contpR1p_meansum;
	%contpR1polsig = contpR1binpsig_meansum;
	%contpR2pol = contpR2p_meansum;
	%contpR2polsig = contpR2binpsig_meansum;
	
%subtightplot(4,2,[6],[0.01,0.075],0.05,0.1)
%hold all
%plot(wav1,flx1/max(flx1)*(qmaxqplot-qminqplot)+qminqplot,'Color',[0.2 0.2 0.2])
%filly = (flx1/max(flx1)*(qmaxqplot-qminqplot)+qminqplot);
%a1=area(wav1,flx1/max(flx1)*(qmaxqplot-qminqplot)+qminqplot,+qminqplot)
%a1(1).FaceColor = [0.75 0.75 0.75];
%%fill([wav1 max(wav1) min(wav1) min(wav1)],[(flx1/max(flx1)*3.5-2) -2 -2 filly(1)],[0.925 0.925 0.925]);
%scatter(binedgewav1(find(binedgep1>4100 & binedgep1<7000)),binweightedmeanq(find(binedgep1>4100 & binedgep1<7000)).*100,75,cvec(find(binedgep1>4100 & binedgep1<7000)),'filled','^','MarkerEdgeColor','k')
%line([3000 9000],[0 0],'LineStyle','--','Color',[0 0 0])
%axis([[4100 7000] [qminqplot qmaxqplot]])
%blah1 = line([6563 6563],[-4 3],'LineStyle','--','Color',[0 0 0]);
%blah2 = line([4861 4861],[-4 3],'LineStyle','--','Color',[0 0 0]);
%set(gca,'XTickLabel',[]);
%chandle=cline(binedgewav1(find(binedgep1>4100 & binedgep1<7000)),binweightedmeanq(find(binedgep1>4100 & binedgep1<7000)).*100,binedgewav1(find(binedgep1>4100 & binedgep1<7000)),cvec(find(binedgep1>4100 & binedgep1<7000)),'jet');
%set(chandle,'linewidth',1);
%ax1 = gca;
%ylabel('q (\%)','FontSize',28,'interpreter','latex')
%axpos = get(gca, 'Position')
%[axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.05 axpos(3)*0.95 axpos(4)*0.95]
%set(gca, 'Position', [axpos(1)+axpos(3)*0.05 axpos(2)+axpos(4)*0.2 axpos(3)*0.95 axpos(4)*0.93])
%ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
%ylabel(ax2,'','FontSize',28)
%xlabel(ax2,'')
%set(ax2,'xtick',[],'YTick',[])
%set(ax1,'XMinorTick','on','YMinorTick','on')
%qyticklabels = linspace(qminqplot,qmaxqplot,qmaxqplot-qminqplot+1);
%set(ax1,'YTickMode','manual','YTick',qyticklabels)
%set(ax1,'FontSize',24)
%set(ax1,'xlim',[4100 7000.1])
%set(ax1,'Layer','top')
%

%single dayclear a
%filename = strcat(figuredirectory,'QU',name,date,'.eps')
%multiple days
%filename = strcat(figuredirectory,'QU',name,reldateprint,'.eps')
%export_fig filename -pdf