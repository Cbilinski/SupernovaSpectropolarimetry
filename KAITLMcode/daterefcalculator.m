function daterefcalculator(year,month,day,hour,minute,second,refyear,refmonth,refday)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
totaldaycount = 0;

if(exist(year)==0)
    year = 0;
end

if(exist(month)==0)
    month = 0;
end

if(exist(day)==0)
    day = 0;
end

if(exist(hour)==0)
    hour = 0;
end

if(exist(minute)==0)
    minute = 0;
end

if(exist(second)==0)
    second = 0;
end

if(exist(refyear)==0)
   refyear = 2000; 
end

if(exist(refmonth)==0)
    refmonth = 0;
end

if(exist(refday)==0)
    refday = 0;
end

if(abs(year-refyear) > 100)
    disp('Date calculation exceeds 100 years and may fail to account for leap years properly as a result.');
end


while(year < refyear)
	if(year == leapyear)
		totaldaycount = totaldaycount + 
	end
	
	year = year+1;
end



totaldaycount



end

