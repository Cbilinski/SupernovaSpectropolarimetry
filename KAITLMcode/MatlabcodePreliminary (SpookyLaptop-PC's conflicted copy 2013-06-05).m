
[text(:,1,1) data(:,1,1) text(:,2,1) text(:,3,1) data(:,2,1) text(:,4,1) data(:,3,1) text(:,5,1) data(:,4,1)] = textread('finallimitingmagnitudes.list','%s%f%s%s%f%s%f%s%f','delimiter',' _:');
data(:,5,1) = juliandate(floor(data(:,1,1)./10^4),floor((data(:,1,1)./10^4-floor(data(:,1,1)./10^4)).*100),((data(:,1,1)./10^4-floor(data(:,1,1)./10^4)).*100-floor((data(:,1,1)./10^4-floor(data(:,1,1)./10^4)).*100)).*100);

[textatsn(:,1,1) dataatsn(:,1,1) textatsn(:,2,1) textatsn(:,3,1) dataatsn(:,2,1) textatsn(:,4,1) dataatsn(:,3,1)] = textread('finallimitingmagnitudes.atsn.list','%s%f%s%s%f%s%f','delimiter',' _:');
dataatsn(:,4,1) = juliandate(floor(dataatsn(:,1,1)./10^4),floor((dataatsn(:,1,1)./10^4-floor(dataatsn(:,1,1)./10^4)).*100),((dataatsn(:,1,1)./10^4-floor(dataatsn(:,1,1)./10^4)).*100-floor((dataatsn(:,1,1)./10^4-floor(dataatsn(:,1,1)./10^4)).*100)).*100);

%[snname sndate sndistance] = textread('2010jl.info','%s%f%f','delimiter','\n')

absmag(:,1,1) = data(:,2,1)-5*(log10(sndistance*10^6)-1);
absmag(:,2,1) = data(:,3,1)-5*(log10(sndistance*10^6)-1);
absmagatsn(:,1,1) = dataatsn(:,2,1)-5*(log10(sndistance*10^6)-1);

snjdate = juliandate(floor(sndate/10^4),floor((sndate/10^4-floor(sndate/10^4))*100),((sndate/10^4-floor(sndate/10^4))*100-floor((sndate/10^4-floor(sndate/10^4))*100))*100);

reldate(:,1,1) = data(:,5,1) - snjdate;
reldateatsn(:,1,1) = dataatsn(:,4,1) - snjdate;

[snname sndistance] = textread('snnamedistdate.dat','%s%f','delimiter','\t');

for i=1:length(snname)
   if file open it up and read in
      
   else
       fill in data array with Nans
   end
   
   
end

hist(sndistance,25)
