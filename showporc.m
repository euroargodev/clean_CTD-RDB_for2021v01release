function showporc(k,n,pstep)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function displays the progress of a loop in percentage according to
% a percentage step defined by the user (PSTEP)
% Input: 
% K is the current iteration of the loop
% N is the total number of iterations
% PSTEP is the percentage step that will be shown. Ex. if pstep = 10 it
% will be displayed when the loop has progressed 10%, 20% , 30%, etc.
% Output: 
% Display of the progress in the command window
% 
% Author: Ingrid M. Angel-Benavides
%         BSH - EURO-ARGO RISE project
%        (ingrid.angel@bsh.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if floor(mod(k,pstep))==0
   f=round(100*k/n,1);
   disp([num2str(f) '% completed'])
end