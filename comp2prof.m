function perc = comp2prof(pres,par,ro)
% Ingrid M. Angel-Benavides (BSH - EuroArgo) 
% v0 12.09.2018  

% Function to compare two profiles following Gronell & Wijffels (2008)
% 1. Interpolating the one with higher resolution to the one with lower
% resolution (in the overlaping pressure range)
% 2. Rounding the decimal places of the interpolated profiles
% 
% inputs
% 1. pres is a ns x 2 matrix containing pressure 
% 2. par is a ns x 2 matrix containing temperature or salinity profiles
% obs. each profile/column may contain nans to account for different
% profile lenghts.
% 3. ro is the number of decimal places for the rounding. Usually 1 for
% temperature and 2 for salinity.

% outputs
% perc: percentage of samples that are the same in the interpolated
% profiles. If perc = -999 means that the overlaping parts of the profile
% were too short

%% Preparing profile 1
% get the profile data
pres_1 = pres(:,1);
par_1 = par(:,1);

% exclude repeated pressure values
[~,b] = unique(pres_1);
pres_1 = pres_1(b);
par_1 = par_1(b);

% exclude nans
nas = find( isnan(pres_1) == 1 | isnan(par_1) ==1);
if numel(nas)>0
    pres_1(nas) = [];
    par_1(nas) = [];
end

% get pressure range
min_pres_1 = floor(min(pres_1));
max_pres_1 = ceil(max(pres_1));

%% Preparing profile 2

% get the profile data
pres_2 = pres(:,2);
par_2 =par(:,2);

% exclude repeated pressure values
[~,b] = unique(pres_2);
pres_2 = pres_2(b);
par_2 = par_2(b);
% exclude nans
nas = find(isnan(pres_2) == 1 | isnan(par_2) ==1);
if numel(nas)>0
    pres_2(nas) = [];
    par_2(nas) = [];
end

% get pressure range
min_pres_2 = round(min(pres_2));
max_pres_2 = round(max(pres_2));

%% Comparing

% Find overlaping depths
min_pres=max([min_pres_1 min_pres_2]);
max_pres=min([max_pres_1 max_pres_2]);

%resolution (average number of samples per dbar
res_1=length(pres_1)/(max_pres_1-min_pres_1);
res_2=length(pres_2)/(max_pres_2-min_pres_2);

% Cut profiles to the overlaping depths
f=find(pres_1>=min_pres&pres_1<=max_pres);
pres_1=pres_1(f);
par_1=par_1(f);

f=find(pres_2>=min_pres&pres_2<=max_pres);
pres_2=pres_2(f);
par_2=par_2(f);

% Interpolate the profile with the best resolution  profile
res = [res_1 res_2];
finer = find(res == max(res));
% in case both have the same average resolution select the first
if numel(finer)==2
   finer=1;
end
 
if finer == 1
    par_fine = par_1;
    par_coarse = par_2;
    pres_fine = pres_1;
    pres_coarse = pres_2;
elseif finer == 2
    par_fine = par_2;
    par_coarse = par_1;
    pres_fine = pres_2;
    pres_coarse = pres_1;
end

% If profiles too short, skip comparison
if length(par_fine) < 3
    perc = NaN;
    return
end

% Interpolation
par_interp = interp1(pres_fine,par_fine,pres_coarse);
par_interp = par_interp';

% Rounding both profiles and comparing sample by sample 
diff_par1 = abs(round(par_coarse,ro) - round(par_interp',ro));
% Truncating both profiles, compare sample by sample 
diff_par2 = abs(truncate(par_coarse,ro) - truncate(par_interp',ro));
diff_par=min([diff_par1 diff_par2],[],2);

diffi = find(diff_par == 0);
perc = round(((length(diffi)/length(par_coarse)) * 100),2);

end
