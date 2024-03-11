function [Bbody_bestfit_normalized,bestT,bestalpha1] = blackbodyfit(originalwavelength,originalflux,minlambda,maxlambda,plotname)
	h = 6.626*10^-27; %erg s
	c = 3*10^10; %cm s^-1
	kB = 1.380658 * 10^-16; %erg K^-1
	lengthi =  25;
	lengthii = 25;
	lengthj =  25;
	lengthjj = 25;
	
	plotnameeps = horzcat('C:\Users\Cbilinski\Desktop\Figures\blackbodyfits\',plotname,'.eps');
	plotnameepstopdf = horzcat('!epstopdf C:\Users\Cbilinski\Desktop\Figures\blackbodyfits\',plotname,'.eps');
	
	%Blackbody plot parameters
	blackbodyplotting = figure;
	set(gcf,'color','w');
	set(blackbodyplotting,'units','normalized','outerposition',[0 0 1 1]);
	set(blackbodyplotting,'PaperUnits','normalized','PaperPosition',[0 0 3 1]);
	set(gcf,'renderer','painters')
	colormap jet
	set(blackbodyplotting,'PaperUnits','normalized','PaperPosition',[0 0 3 1.5]);
	

	minlambda = minlambda*10^-8;
	maxlambda = maxlambda*10^-8;
	originalwavelength = originalwavelength.*10^-8;

	flux = originalflux(find(originalwavelength>minlambda,1,'first'):find(originalwavelength<maxlambda,1,'last'));
	wavelength = originalwavelength(find(originalwavelength>minlambda,1,'first'):find(originalwavelength<maxlambda,1,'last'));
	
	%remove halpha region
	fittingwavelengthtemp1 = originalwavelength(find(originalwavelength<(6000*10^-8) | originalwavelength > (7000*10^-8)));
	fittingfluxtemp1 = originalflux(find(originalwavelength<(6000*10^-8) | originalwavelength > (7000*10^-8)));
	%%%fix recursive definition
	%remove hbeta region
	fittingwavelengthtemp2 = fittingwavelengthtemp1(find(fittingwavelengthtemp1<(4700*10^-8) | fittingwavelengthtemp1 > (5100*10^-8)));
	fittingfluxtemp2 = fittingfluxtemp1(find(fittingwavelengthtemp1<(4700*10^-8) | fittingwavelengthtemp1 > (5100*10^-8)));
	%remove high region or skip removing it
	%fittingwavelength = fittingwavelengthtemp2(find(fittingwavelengthtemp2<(8800*10^-8) | fittingwavelengthtemp2 > (9400*10^-8)));
	%fittingfluxunscaled = fittingfluxtemp2(find(fittingwavelengthtemp2<(8800*10^-8) | fittingwavelengthtemp2 > (9400*10^-8)));
	fittingwavelengthraw = fittingwavelengthtemp2;
	fittingfluxunscaled = fittingfluxtemp2;
	
	fittingfluxraw = fittingfluxunscaled .* (1./mean(fittingfluxunscaled));
	
	%sigma clipping prescription
	%smooth fitting data
	scaledoriginalflux= (1/mean(fittingfluxunscaled)).*originalflux;
	smoothedoriginalflux = smooth(scaledoriginalflux,75);
	
	%match fitting wavelength to original wavelength to scale down the smoothed function to just the size of the fitting region
	[intrsctfitorigwav, indxintrsctfitorigwav, indxintrsctorigfitwav] = intersect(fittingwavelengthraw,originalwavelength);
	smoothedwavelength = originalwavelength(indxintrsctorigfitwav);
	smoothedfittingflux = smoothedoriginalflux(indxintrsctorigfitwav);
	
	
	
	%moving std deviation of fitting data
	sigmaflux = movstd(fittingfluxraw,75);
	
	%check on smoothed spectrum
	clf
	semilogy(originalwavelength,scaledoriginalflux,'LineWidth',3,'Color',[0.5 0.5 0.5])
	hold on
	semilogy(fittingwavelengthraw,fittingfluxraw,'LineWidth',2,'Color',[0 0 0],'LineStyle','--')
	semilogy(smoothedwavelength,smoothedfittingflux,'LineWidth',2,'Color',[1 0 0])
	xlabel('Rest Wavelength ($\AA$) ','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	ylabel('$F_\lambda$ (Scaled)','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	axis([[min(originalwavelength)*0.98 max(originalwavelength)*1.02] [0.05 8]])
	ax1 = gca;
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',22)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'FontSize',22)
	set(ax2,'FontSize',22)
	set(ax1,'XMinorTick','on','YMinorTick','on')
	
	%userprompt = input('Is the smoothed spectrum good?','s')

	%compare fittingflux and smoothfittingflux at every point to alpha * sigmaflux and keep good fit indices
	
	j=0;
	for i = 1:length(fittingfluxraw)
		if (abs((fittingfluxraw(i) - smoothedfittingflux(i))./sigmaflux(i))  < 1)
			j=j+1;
			fittingflux(j) = fittingfluxraw(i);
			fittingwavelength(j) = fittingwavelengthraw(i);
		end
	end
	
		
	%check on sigma clipped points
	clf
	semilogy(fittingwavelengthraw,fittingfluxraw,'LineWidth',3,'Color',[0.5 0.5 0.5])
	hold on
	semilogy(fittingwavelength,fittingflux,'LineWidth',2,'Color',[0 1 0])
	%semilogy(smoothedwavelength,smoothedfittingflux,'LineWidth',2,'Color',[1 0 0])
	xlabel('Rest Wavelength ($\AA$) ','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	ylabel('$F_\lambda$ (Scaled)','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	axis([[min(originalwavelength)*0.98 max(originalwavelength)*1.02] [0.05 8]])
	ax1 = gca;
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',22)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'FontSize',22)
	set(ax2,'FontSize',22)
	set(ax1,'XMinorTick','on','YMinorTick','on')
	
	%userprompt = input('Are the sigma clipped points good?','s')
	
	
	
	
	T1 = logspace(log10(5000),log10(15000),lengthi);
	T2 = logspace(log10(100),log10(5000),lengthii);
	alpha1 = linspace(1,3,lengthj);
	alpha2 = linspace(0.005,0.5,lengthjj);
	
	
	%one blackbody fit
	%for i=1:lengthi
	%	for j=1:lengthj
	%		Bbody_lambda(i,:)=2*h*c^2./wavelength.^5*1./(exp((h*c)./(wavelength.*kB.*T1(i)))-1);
	%		Bbody_lambda_normalized(i,j,:) = alpha1(j).*Bbody_lambda(i,:)./max(Bbody_lambda(i,:));
	%		chi(i,j) = sum(((flux(:)-squeeze(Bbody_lambda_normalized(i,j,:))).^2)./squeeze(Bbody_lambda_normalized(i,j,:)));
	%	end
	%end
    %
	%[mini,minj] = find(chi == min(min(chi)))
    %
	%Bbody_bestfit = 2*h*c^2./originalwavelength.^5*1./(exp((h*c)./(originalwavelength.*kB.*T1(mini)))-1);
	%Bbody_bestfit_normalized = alpha1(minj).*Bbody_bestfit./max(Bbody_bestfit);
	%
	%bestT = T1(mini)
	%bestalpha1 = alpha1(minj)
	%
    %
	%clf
	%semilogy(originalwavelength,(1/mean(fittingfluxunscaled)).*originalflux,'LineWidth',2,'Color',[0.5 0.5 0.5])
	%hold on
	%semilogy(originalwavelength,Bbody_bestfit_normalized,'LineWidth',2,'Color',[0 0 0])
	%%semilogy(wavelength,squeeze(Bbody_lambda_normalized(mini,minj-3,:)),'LineWidth',2,'Color',[0 1 0])
	%%semilogy(wavelength,squeeze(Bbody_lambda_normalized(mini,minj+3,:)),'LineWidth',2,'Color',[0 0 1])
	%%semilogy(wavelength,squeeze(Bbody_lambda_normalized(mini+1,minj,:)),'LineWidth',2,'Color',[1 1 0])
	%%semilogy(wavelength,squeeze(Bbody_lambda_normalized(mini-1,minj,:)),'LineWidth',2,'Color',[1 0 1])
	%xlabel('Rest Wavelength ($\AA$) ','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	%ylabel('$F_\lambda$ (Scaled)','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	%%edit this wavelength range
	%axis([[3000*10^-8 12000*10^-8] [0.01 5]])
	%ax1 = gca;
	%ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	%ylabel(ax2,'','FontSize',22)
	%xlabel(ax2,'')
	%set(ax2,'xtick',[],'YTick',[])
	%set(ax1,'FontSize',22)
	%set(ax2,'FontSize',22)
	%set(ax1,'XMinorTick','on','YMinorTick','on')
	

	%userprompt = input('Is the blackbody fit good?','s')
	
	for i=1:lengthi
		Bbody_lambda_fitting1(i,:)=2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T1(i)))-1);
	end

	for ii=1:lengthii
		Bbody_lambda_fitting2(ii,:)=2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T2(ii)))-1);
	end
	
	twobbody_lambda_normalized= zeros(lengthi,lengthi,lengthj,lengthj,length(fittingwavelength));
	twochi = zeros(lengthi,lengthi,lengthj,lengthj);
	
	%if (strcmp(userprompt,'yes'))
		%accept and move on
	%elseif (strcmp(userprompt,'no'))
		%refit with two
		for i=1:lengthi
			i
			for ii=1:lengthi
				ii
				for j=1:lengthj
					for jj=1:lengthj
						twobbody_lambda_normalized(i,ii,j,jj,:) = (alpha1(j) .* Bbody_lambda_fitting1(i,:) ./ max(Bbody_lambda_fitting1(i,:))) + (alpha2(jj) .* Bbody_lambda_fitting2(ii,:) ./ max(Bbody_lambda_fitting2(ii,:)));
						twochi(i,ii,j,jj) = sum(((fittingflux(:)-squeeze(squeeze(squeeze(twobbody_lambda_normalized(i,ii,j,jj,:))))).^2)./squeeze(squeeze(squeeze(twobbody_lambda_normalized(i,ii,j,jj,:)))));
					end
				end
			end
		end
		[mintwochi twochiindx] = min(twochi(:));
		[mini minii minj minjj] = ind2sub(size(twochi),twochiindx)
	%end
	
	bestT1 = T1(mini)
	bestT2 = T2(minii)
	bestalpha11 = alpha1(minj)
	bestalpha12 = alpha2(minjj)
	
	bestT1str = num2str(bestT1);
	bestT2str = num2str(bestT2);
	bestalpha11str = num2str(bestalpha11);
	bestalpha12str = num2str(bestalpha12);
	
	Bbody_bestfit1 = 2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T1(mini)))-1);
	Bbody_bestfit2 = 2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T2(minii)))-1);
	Bbody_bestfit_normalized1 = alpha1(minj ).*Bbody_bestfit1./max(Bbody_bestfit1);
	Bbody_bestfit_normalized2 = alpha2(minjj).*Bbody_bestfit2./max(Bbody_bestfit2);
	Bbody_bestfit_normalized = Bbody_bestfit_normalized1+Bbody_bestfit_normalized2;
	

	clf
	semilogy(originalwavelength,(1/mean(fittingfluxunscaled)).*originalflux,'LineWidth',3,'Color',[0.5 0.5 0.5])
	hold on
	semilogy(fittingwavelength,fittingflux,'LineWidth',2,'Color',[0 0 0],'LineStyle','--')
	semilogy(fittingwavelength,Bbody_bestfit_normalized,'LineWidth',2,'Color',[1 0 0])
	semilogy(fittingwavelength,Bbody_bestfit_normalized1,'LineWidth',2,'Color',[0 1 0],'LineStyle','--')
	semilogy(fittingwavelength,Bbody_bestfit_normalized2,'LineWidth',2,'Color',[0 0 1],'LineStyle','--')
	xlabel('Rest Wavelength ($\AA$) ','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	ylabel('$F_\lambda$ (Scaled)','interpreter','latex','FontSize',24,'FontName','CMU Serif Roman')
	axis([[min(originalwavelength)*0.98 max(originalwavelength)*1.02] [0.05 8]])
	htext = text(5000*10^-8,5,bestT1str,'FontName','CMU Serif Roman','FontSize',15,'Color',[0 1 0]);
	htext = text(5000*10^-8,4.2,bestalpha11str,'FontName','CMU Serif Roman','FontSize',15,'Color',[0 1 0]);
	htext = text(7000*10^-8,5,bestT2str,'FontName','CMU Serif Roman','FontSize',15,'Color',[0 0 1]);
	htext = text(7000*10^-8,4.2,bestalpha12str,'FontName','CMU Serif Roman','FontSize',15,'Color',[0 0 1]);
	htext = text(7500*10^-8,5,plotname,'FontName','CMU Serif Roman','FontSize',15,'interpreter','none');
	ax1 = gca;
	ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
	ylabel(ax2,'','FontSize',22)
	xlabel(ax2,'')
	set(ax2,'xtick',[],'YTick',[])
	set(ax1,'FontSize',22)
	set(ax2,'FontSize',22)
	set(ax1,'XMinorTick','on','YMinorTick','on')

	%userprompt = input('Is the 2nd blackbody fit good?','s')
	
	saveas(blackbodyplotting, [plotnameeps], 'epsc');
	eval([plotnameepstopdf]);
	
	twochi(:,minii,minj,minjj)
	
	contourmap = squeeze(twochi(:,minii,:,minjj))
	size(contourmap);
	
	clf
	%[C,h] = contourf(contourmap,[3,10,20,50,100,500,1000,2000]);
	[C,h] = contourf(contourmap,100);
	clabel(C,h);
	yticks(linspace(1,lengthi,lengthi));
	yticklabels(T1);
	xticks(linspace(1,lengthj,lengthj));
	xticklabels(alpha1);
	
	
	saveas(blackbodyplotting,['contourtest.eps'], 'epsc');
	eval(['!epstopdf contourtest.eps']);
	
	
	close(blackbodyplotting)

	
	
	
	
	
	
	
	
	
	
	
	
%junk code
	
	
	
	
	
	
	
	
	
	%						twobbody_lambda(i,ii,:) = Bbody_lambda_fitting(i,:) + Bbody_lambda_fitting(ii,:);
	%					twobbody_lambda_normalized(i,ii,j,jj,:) = alpha1(j) .* twobbody_lambda(i,ii,:) ./ max(twobbody_lambda(i,ii,:));
	%					
	%					twobbody_lambda(i,ii,:) = Bbody_lambda_fitting(i,:) + Bbody_lambda_fitting(ii,:);
	% twochi(i,ii,j,jj) = sum(((fittingflux(:)-squeeze(squeeze(twobbody_lambda_normalized(i,ii,j,:)))).^2)./squeeze(squeeze(twobbody_lambda_normalized(i,ii,j,:))));
	
	
	%Bbody_bestfit1 = 2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T(mini)))-1);
	%Bbody_bestfit2 = 2*h*c^2./fittingwavelength.^5*1./(exp((h*c)./(fittingwavelength.*kB.*T(minii)))-1);
	%Bbody_bestfit = Bbody_bestfit1 + Bbody_bestfit2;
	%Bbody_bestfit_normalized1 = alpha1(minj).*Bbody_bestfit1./max(Bbody_bestfit);
	%Bbody_bestfit_normalized2 = alpha1(minj).*Bbody_bestfit2./max(Bbody_bestfit);
	%Bbody_bestfit_normalized = alpha1(minj).*Bbody_bestfit./max(Bbody_bestfit);
	
	
	
	
	%fit = Bbody_lambda_normalized(mini,minj,:);
	%wave = wavelength;
	
	%clear chi
	%clear wavelength
	%clear flux
	%minlambda = 7000*10^-8;
	%maxlambda = 10000*10^-8;
	%wavelength = linspace(3000*10^-8,9000*10^-8,6000) %cm
	%wavelength = Lkast1_20120223.*10^-8;
	%flux = Lkast2_20120223_contscaled;
	
	%clear Bbody_lambda
	%clear Bbody_lambda_normalized
	
	%%htext = text(7750,2,'SN 2012ab','interpreter','latex','FontName','CMU Serif');
	%%set(htext, 'Color', 'black')	
	%%set(htext, 'FontSize',26)
	%htext = text(2965,0.1,'.','interpreter','latex','FontName','CMU Serif Roman');
	%Bbody_bestfit_normalizedtest = squeeze(squeeze(squeeze(twobbody_lambda_normalized(mini,minii,minj,:))));

	
	
	
	
end
