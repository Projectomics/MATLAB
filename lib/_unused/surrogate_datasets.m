function surrogate_datasets()
    addpath('../output/');
    addpath('../../dir_MouseLight_ASSIP/');
    addpath('../../dir_shuffle_ASSIP/');
  
    stdev = 100;
    set1 = [];
    nCell = 1000;
    totalDim = 5000;
    cellDiv = nCell/5;
    
    aMean = 0;
    bMean = 50;
    cMean = 100;
    dMean = 150;
    eMean = 900;
        
    for i = 1:cellDiv       
        setA = round(stdev.*rand(totalDim,1) + aMean);
        setA = setA.';  
        setB = round(stdev.*rand(totalDim,1) + bMean);
        setB = setB.';         
        setC = round(stdev.*rand(totalDim,1) + cMean);
        setC = setC.';        
        setD = round(stdev.*rand(totalDim,1) + dMean);
        setD = setD.';        
        setE = round(stdev.*rand(totalDim,1) + eMean);
        setE = setE.';

        tempSet1 = cat(1, setA, setB, setC, setD, setE);
        set1 = cat(1, set1, tempSet1);
    end
    
    str = sprintf('./output/surrogateData_%dx%d.csv', nCell, totalDim);
    writematrix(set1, str);
     
end


%     
%     %100 cells
%     stdev = 100;
%     set1 = [];
%     nCell = 100;
%     totalDim = 100;
%     nDim = totalDim/5;
%         
%     for i = 1:nCell
%         if (1<=i) && (i<=20)
%             aMean = 10;
%             bMean = 10;
%             cMean = 50;
%             dMean = 10;
%             eMean = 20;
%         elseif (21<=i) && (i<=40)
%             aMean = 10;
%             bMean = 50;
%             cMean = 10;
%             dMean = 20;
%             eMean = 10;
%         elseif (41<=i) && (i<=60)
%             aMean = 20;
%             bMean = 10;
%             cMean = 10;
%             dMean = 50;
%             eMean = 10;
%         elseif (61<=i) && (i<=80)
%             aMean = 10;
%             bMean = 20;
%             cMean = 10;
%             dMean = 10;
%             eMean = 50;
%         else
%             aMean = 50;
%             bMean = 10;
%             cMean = 20;
%             dMean = 10;
%             eMean = 10;
%         end
%         
%         setA = round(stdev.*rand(nDim,1) + aMean);
%         setA = setA.';  
%         setB = round(stdev.*rand(nDim,1) + bMean);
%         setB = setB.';         
%         setC = round(stdev.*rand(nDim,1) + cMean);
%         setC = setC.';        
%         setD = round(stdev.*rand(nDim,1) + dMean);
%         setD = setD.';        
%         setE = round(stdev.*rand(nDim,1) + eMean);
%         setE = setE.';
% 
%         tempSet1 = cat(2, setA, setB, setC, setD, setE);
%         set1 = cat(1, set1, tempSet1);
%     end
%     
%     %     for i = 1:nCell
% %         if (1<=i) && (i<=20)
% %             aRange = 20;
% %             a = 0;
% %             bRange = 20;
% %             b = 0;
% %             cRange = 30;
% %             c = 20;
% %             dRange = 20;
% %             d = 0;
% %             eRange = 50;
% %             e = 50;
% %         elseif (21<=i) && (i<=40)
% %             aRange = 20;
% %             a = 0;
% %             bRange = 30;
% %             b = 20;
% %             cRange = 20;
% %             c = 0;
% %             dRange = 50;
% %             d = 50;
% %             eRange = 20;
% %             e = 0;
% %         elseif (41<=i) && (i<=60)
% %             aRange = 50;
% %             a = 50;
% %             bRange = 20;
% %             b = 0;
% %             cRange = 20;
% %             c = 0;
% %             dRange = 30;
% %             d = 20;
% %             eRange = 20;
% %             e = 0;
% %         elseif (61<=i) && (i<=80)
% %             aRange = 20;
% %             a = 0;
% %             bRange = 50;
% %             b = 50;
% %             cRange = 20;
% %             c = 0;
% %             dRange = 20;
% %             d = 0;
% %             eRange = 30;
% %             e = 20;
% %         else
% %             aRange = 30;
% %             a = 20;
% %             bRange = 20;
% %             b = 0;
% %             cRange = 50;
% %             c = 50;
% %             dRange = 20;
% %             d = 0;
% %             eRange = 20;
% %             e = 0;
% %         end
% %         
% %         setA = round(aRange.*rand(nDim,1) + a);
% %         setA = setA.';  
% %         setB = round(bRange.*rand(nDim,1) + b);
% %         setB = setB.';         
% %         setC = round(cRange.*rand(nDim,1) + c);
% %         setC = setC.';        
% %         setD = round(dRange.*rand(nDim,1) + d);
% %         setD = setD.';        
% %         setE = round(eRange.*rand(nDim,1) + e);
% %         setE = setE.';
% % 
% %         tempSet1 = cat(2, setA, setB, setC, setD, setE);
% %         set1 = cat(1, set1, tempSet1);
% %     end
%     
%     str = sprintf('./output/surrogateData_%dx%d.csv', nCell, totalDim);
%     writematrix(set1, str); 
%     
% end