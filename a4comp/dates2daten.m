function daten=dates2daten(dates)
daten=zeros(size(dates));
for i=1:numel(daten)
    Date_1=num2str(dates(i));
    full_time_1=[str2double(Date_1(1:4)) str2double(Date_1(5:6))...
        str2double(Date_1(7:8)) str2double(Date_1(9:10))...
        str2double(Date_1(11:12)) str2double(Date_1(14:14))];
    daten(i)= datenum(full_time_1);
end