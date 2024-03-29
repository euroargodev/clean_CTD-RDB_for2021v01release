%% Initial definitions
% Define the paths
% of the CTD-RDB mat files (inpath)
inpath='\H:\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2020V01\';
% of the outputs (outp)
outp='H:\CodeProjects\CTD-RDB_2020\';
% Define vector with a list of the boxes numbers to be checked
boxlist=1813; %only one for simplicity here

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
F3_contdup(boxlist,inpath,outpath,'test3.mat');
% Step 4 is the check of near duplicates
inpath=outpath;
outpath=[outp 'A4\'];
F4_nearmetadup(boxlist,inpath,outpath,'test4.mat');
% Step 5 is an extra step that puts uses the information of all the output 
% files together 
% FOR WHAT?!?!?!?!
F5_get_orindices('test1.mat','test2.mat','test3.mat','test4.mat','ind.mat')