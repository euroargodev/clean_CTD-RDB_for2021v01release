addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\export_fig'
warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved')
[qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded,boxn]...
    =plot_dupanalysis(2,[],[],[],[],1,1);
save dupan2.mat

[qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded,boxn]...
    =plot_dupanalysis(3,[],[],[],[],1,1);
save dupan3.mat


[qckept,qcexcluded,criteria1,criteria2,indkept,indexcluded,boxn]...
    =plot_dupanalysis(4,[],[],[],[],1,1);
save dupan4.mat