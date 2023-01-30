%% Initial definitions
% Define the paths
% of the CTD-RDB mat files (inpath)
inpath='H:\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2021V02\';
% of the outputs (outp)
outp='H:\CodeProjects\CTD-RDB_2020\x\';
% Define vector with a list of the boxes numbers to be checked
boxlist=[3600        3601        3602        5600        5601        5602        5603        5604 ...
    5605        3700        3701        3702        5700        5701        5702        5703 5704        5705]; %only one for simplicity here

%% Running all the steps  
% The steps are done sequentially
% each of the steps are stored in a different subfolder (A1 for step 1, A2
% for step 2, and so on) and the output and input folder changes with every
% step. What was done in each step is documented in the ouput matfiles that
% stored in the general output folder

% Step 1 is the basic corrections
% https://github.com/euroargodev/clean_CTD-RDB_for2021v01release/wiki/1.-Basic-corrections
outpath=[outp 'A1\'];
F1_basic_corr(boxlist,inpath,outpath,'test1.mat');
% Step 2 is the check of metadata duplicates
inpath=outpath;
outpath=[outp 'A2\'];
F2_exmetadup(boxlist,inpath,outpath,'test2.mat');
% Step 3 is the check of the content duplicates
inpath=outpath;
outpath=[outp 'A3\'];
F3_contdup(boxlist,inpath,outpath,'test3.mat',800:10:2000,[3 3]);
% Step 4 is the check of near duplicates
% inpath=outpath;
% outpath=[outp 'A4\'];
% F4_nearmetadup(boxlist,inpath,outpath,'test4.mat');
% % Step 5 is an extra step that puts uses the information of all the outputs 
% % to make the information of the deleted and modified profiles available in
% % the form of the indices of the original boxes. This is useful to compare
% % the original with the final box.
% F5_get_orindices('test1.mat','test2.mat','test3.mat','test4.mat','ind.mat')