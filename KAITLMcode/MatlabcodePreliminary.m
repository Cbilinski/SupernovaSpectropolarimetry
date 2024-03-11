
[text(:,1,1,1) data(:,1,1,1) text(:,2,1,1) text(:,3,1,1) data(:,2,1,1) text(:,4,1,1) data(:,3,1,1) text(:,5,1,1) data(:,4,1,1)] = textread('finallimitingmagnitudes.list','%s%f%s%s%f%s%f%s%f','delimiter',' _:');
data(:,5,1,1) = juliandate(round(data(:,1,1,1)./10^4),round((data(:,1,1,1)./10^4-round(data(:,1,1,1)./10^4)).*100),((data(:,1,1,1)./10^4-round(data(:,1,1,1)./10^4)).*100-round((data(:,1,1,1)./10^4-round(data(:,1,1,1)./10^4)).*100)).*100);

[textatsn(:,1,1,1) dataatsn(:,1,1,1) textatsn(:,2,1,1) textatsn(:,3,1,1) dataatsn(:,2,1,1) textatsn(:,4,1,1) dataatsn(:,3,1,1)] = textread('finallimitingmagnitudes.atsn.list','%s%f%s%s%f%s%f','delimiter',' _:');
dataatsn(:,4,1,1) = juliandate(round(dataatsn(:,1,1,1)./10^4),round((dataatsn(:,1,1,1)./10^4-round(dataatsn(:,1,1,1)./10^4)).*100),((dataatsn(:,1,1,1)./10^4-round(dataatsn(:,1,1,1)./10^4)).*100-round((dataatsn(:,1,1,1)./10^4-round(dataatsn(:,1,1,1)./10^4)).*100)).*100);

[datacomb(:,1,1,1) textcomb(:,1,1,1) textcomb(:,2,1,1) datacomb(:,2,1,1) textcomb(:,3,1,1) datacomb(:,3,1,1) textcomb(:,4,1,1) datacomb(:,4,1,1)] = textread('finallimitingmagnitudescomb.list','%f%s%s%f%s%f%s%f','delimiter',' _:');
datacomb(:,5,1,1) = juliandate(round(datacomb(:,1,1,1)./10^2),round((datacomb(:,1,1,1)./10^2-round(datacomb(:,1,1,1)./10^2)).*100),15);

[datacombatsn(:,1,1,1) textcombatsn(:,1,1,1) textcombatsn(:,2,1,1) datacombatsn(:,2,1,1) textcombatsn(:,3,1,1) datacombatsn(:,3,1,1)] = textread('finallimitingmagnitudescomb.atsn.list','%f%s%s%f%s%f','delimiter',' _:');
datacombatsn(:,4,1,1) = juliandate(round(datacombatsn(:,1,1,1)./10^2),round((datacombatsn(:,1,1,1)./10^2-round(datacombatsn(:,1,1,1)./10^2)).*100),15);

[ipdata(:,1,1) ipdata(:,2,1) ipdata(:,3,1) ipdataref(:,1,1)] = textread('sn2009ip_master_lightcurve.dat','%f%f%f%s','delimiter',' ');
[etacardata(:,1,1) etacardata(:,2,1) etacardata(:,3,1)] = textread('eta_rev_ascii.txt','%f%f%f','delimiter',' ');
etacardata(:,4,1) = juliandate(floor(etacardata(:,1,1)),1,0) + (etacardata(:,1,1) - floor(etacardata(:,1,1)))*365.242;
etacarreldate(:,1,1) = etacardata(:,4,1) - etacardata(73,4,1);
etacardistance = 0.00230;
etacarabsmag(:,1,1) = etacardata(:,2,1)-5*(log10(etacardistance*10^6)-1);

[snname snyear snmonth snday sndistance] = textread('snnamedatedist.txt','%s%f%f%f%f','delimiter','\t');

distance = sndistance(find(strcmp(text(1,1,1,1),snname) == 1));

%[snname sndate sndistance] = textread('2010jl.info','%s%f%f','delimiter','\n')

absmag(:,1,1) = data(:,2,1)-5*(log10(distance*10^6)-1);
absmag(:,2,1) = data(:,3,1)-5*(log10(distance*10^6)-1);
absmagatsn(:,1,1) = dataatsn(:,2,1)-5*(log10(distance*10^6)-1);

absmagcomb(:,1,1) = datacomb(:,2,1)-5*(log10(distance*10^6)-1);
absmagcomb(:,2,1) = datacomb(:,3,1)-5*(log10(distance*10^6)-1);
absmagcombatsn(:,1,1) = datacombatsn(:,2,1)-5*(log10(distance*10^6)-1);

snjdate = juliandate(2010,11,03);
%snjdate = juliandate(round(sndate/10^4),round((sndate/10^4-round(sndate/10^4))*100),((sndate/10^4-round(sndate/10^4))*100-round((sndate/10^4-round(sndate/10^4))*100))*100);

reldate(:,1,1) = data(:,5,1) - snjdate;
reldateatsn(:,1,1) = dataatsn(:,4,1) - snjdate;
reldatecomb(:,1,1) = datacomb(:,5,1) - snjdate;
reldatecombatsn(:,1,1) = datacombatsn(:,4,1) - snjdate;

plotting = figure
hold all
scatter(reldate(:,1,1),absmag(:,1,1),25,'rs')
scatter(reldate(:,1,1),absmag(:,2,1),25,'rv')
scatter(reldateatsn(:,1,1),absmagatsn(:,1,1),25,'r*')

scatter(reldatecomb(:,1,1),absmagcomb(:,1,1),70,'bs')
scatter(reldatecomb(:,1,1),absmagcomb(:,2,1),70,'bv')
scatter(reldatecombatsn(:,1,1),absmagcombatsn(:,1,1),70,'b*')

plot(ipdata(:,1,1),ipdata(:,2,1),'g')
plot(etacarreldate(:,1,1),etacarabsmag(:,1,1),'k')

axis([[-4500 500],[-20 -10]])
xlabel('Days Relative to Maximum','FontSize',18)
ylabel('Absolue Magnitude','FontSize',18)
title('All 2010jl Data',  'FontSize', 20)
legend('ind image','ind detected','ind atsn','comb image','comb detected','comb atsn','2009ip','etacar')
set(gca,'YDir','reverse');

saveas(plotting, ['Alldata.eps'], 'epsc');
eval(['!epstopdf Alldata.eps']);


hold off
scatter(reldate(:,1,1),absmag(:,1,1),25,'rs')
hold on
scatter(reldate(:,1,1),absmag(:,2,1),25,'rv')
scatter(reldateatsn(:,1,1),absmagatsn(:,1,1),25,'r*')

scatter(reldatecomb(:,1,1),absmagcomb(:,1,1),70,'bs')
scatter(reldatecomb(:,1,1),absmagcomb(:,2,1),70,'bv')
scatter(reldatecombatsn(:,1,1),absmagcombatsn(:,1,1),70,'b*')

plot(ipdata(:,1,1),ipdata(:,2,1),'g')
plot(etacarreldate(:,1,1),etacarabsmag(:,1,1),'k')

axis([[-1000 200],[-20 -10]])
xlabel('Days Relative to Maximum','FontSize',18)
ylabel('Absolue Magnitude','FontSize',18)
title('All 2010jl Data Zoomed',  'FontSize', 20)
legend('ind image','ind detected','ind atsn','comb image','comb detected','comb atsn','2009ip','etacar')
set(gca,'YDir','reverse');

saveas(plotting, ['Alldatazoomed.eps'], 'epsc');
eval(['!epstopdf Alldatazoomed.eps']);

hold off
scatter(reldate(:,1,1),absmag(:,1,1),25,'rs')
hold all
scatter(reldatecomb(:,1,1),absmagcomb(:,1,1),70,'bs')
plot(ipdata(:,1,1),ipdata(:,2,1),'g')
plot(etacarreldate(:,1,1),etacarabsmag(:,1,1),'k')

axis([[-4500 500],[-20 -10]])
xlabel('Days Relative to Maximum','FontSize',18)
ylabel('Absolue Magnitude','FontSize',18)
title('2010jl Fake Star Edges Data',  'FontSize', 20)
legend('ind image','comb image','2009ip','etacar')
set(gca,'YDir','reverse');

saveas(plotting, ['Image.eps'], 'epsc');
eval(['!epstopdf Image.eps']);



hold off
scatter(reldate(:,1,1),absmag(:,2,1),25,'rv')
hold all
scatter(reldatecomb(:,1,1),absmagcomb(:,2,1),70,'bv')
plot(ipdata(:,1,1),ipdata(:,2,1),'g')
plot(etacarreldate(:,1,1),etacarabsmag(:,1,1),'k')

axis([[-4500 500],[-20 -10]])
xlabel('Days Relative to Maximum','FontSize',18)
ylabel('Absolue Magnitude','FontSize',18)
title('2010jl Faintest Detected Data',  'FontSize', 20)
legend('ind detected','comb detected','2009ip','etacar')
set(gca,'YDir','reverse');

saveas(plotting, ['Detected.eps'], 'epsc');
eval(['!epstopdf Detected.eps']);


hold off
scatter(reldateatsn(:,1,1),absmagatsn(:,1,1),25,'r*')
hold on

scatter(reldatecombatsn(:,1,1),absmagcombatsn(:,1,1),70,'b*')

plot(ipdata(:,1,1),ipdata(:,2,1),'g')
plot(etacarreldate(:,1,1),etacarabsmag(:,1,1),'k')

axis([[-4500 500],[-20 -10]])
xlabel('Days Relative to Maximum','FontSize',18)
ylabel('Absolue Magnitude','FontSize',18)
title('2010jl Fake Star AtSN Data',  'FontSize', 20)
legend('ind atsn','comb atsn','2009ip','etacar')
set(gca,'YDir','reverse');

saveas(plotting, ['AtSN.eps'], 'epsc');
eval(['!epstopdf AtSN.eps']);
hold off












% 
% hold all
% scatter(reldate(:,1,1),absmag(:,1,1),'s')
% scatter(reldatecomb(:,1,1),absmagcomb(:,1,1),'*')
% 
% hold all
% scatter(reldate(:,1,1),absmag(:,2,1),'s')
% scatter(reldatecomb(:,1,1),absmagcomb(:,2,1),'*')
% 
% plot(ipdata(:,1,1),ipdata(:,2,1))
% 
% hold all
% scatter(reldateatsn(:,1,1),absmagatsn(:,1,1),'s')
% scatter(reldatecombatsn(:,1,1),absmagcombatsn(:,1,1),'*')
% 
% plot(ipdata(:,1,1),ipdata(:,2,1))
% plot(etacarreldate(:,1,1),etacarabsmag(:,1,1))


%for i=1:length(snname)
%   if file open it up and read in
%      
%   else
%       fill in data array with Nans
%   end
%   
%   
%end

hist(sndistance,50)
xlabel('Distance in Mpc','FontSize',18)
ylabel('# of SN','FontSize',18)
title('Histogram of SN',  'FontSize', 20)

saveas(plotting, ['HistogramDistances.eps'], 'epsc');
eval(['!epstopdf HistogramDistances.eps']);

