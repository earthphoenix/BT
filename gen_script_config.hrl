-define(TC1,true).
-define(TC2,true).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The common case is that both signals tc2ba and tc2bb are equal. In case this is 
% set to false, more test cases are generated which distinguish between both 
% signals, quadrupling the number of test cases (double for the original signal,
% double for the verification signal)
-define(TC2jointtc2batc2bb,true).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-define(TC3,true).
-define(TC4,false).
-define(TC5,false).
-define(TC6,false).
-define(TC7,false).
-define(IMPORTANCE,true).%set true for few important TCs, false to get all TCs
-define(HeaderFile,"tcHeader.txt").
-define(FooterFile,"tcFooter.txt").
-define(OutputFile,"gen_TCs.cs").