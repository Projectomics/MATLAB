function x = nnls(inputMatrix)
    addpath('./lib/');
           
    strng = sprintf('\nLoading input matrix ...\n');
    disp(strng);
    
%     c = readmatrix('../output/PRE_summary_single_noLabel.xlsx');
    fullInputFileName = strcat('./data/', inputMatrix);
    c = readmatrix(fullInputFileName);
    %d = [0.042620; 0.000017; 0.007780; 0.001179; 0.013136; 0.000091; 0.001677; 0.000704; 0.000047; 0.000301]; 
    %d represents volume*density of presubiculum, subiculum, entorhinal,
    %parasubiculum (same order as c)
       
    x = lsqnonneg(c,d);  
    num = norm(x);
    
end