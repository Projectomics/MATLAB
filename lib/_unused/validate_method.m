function [setA, setB, setADifferences, setBDifferences] = validate_method()
    
    addpath('../dir_MouseLight_ASSIP/lib');

    setA = zeros(100, 1);
    setB = zeros(100, 1);
    shuffled = zeros(100, 1);
    for i = 1:20
       setA(i) = rand * (0.1)-1; 
       setB(i) = rand * (0.4)-1;
    end
    
    for i = 21:40
       setA(i) = rand * (0.1)-0.55; 
       setB(i) = rand * (0.4)-0.6;
    end
    
    for i = 41:60
       setA(i) = rand * (0.1)-0.05; 
       setB(i) = rand * (0.4)-0.2;
    end
    
    for i = 61:80
       setA(i) = rand * (0.1)+0.45; 
       setB(i) = rand * (0.4)+0.2;
    end
    
    for i = 81:100
       setA(i) = rand * (0.1)+0.9; 
       setB(i) = rand * (0.4)+0.6;
    end
    
    for i = 1:100
        shuffled(i) = rand * 2 -1;
    end
      
    [setADistances, setADifferences] = validate_analysis(setA, 'setA');
    setADistances = cell2mat(setADistances);
    [setBDistances, setBDifferences] = validate_analysis(setB, 'setB');
    setBDistances = cell2mat(setBDistances);
    [shuffledDistances, shuffledDifferences] = validate_analysis(shuffled, 'shuffled');
    shuffledDistances = cell2mat(shuffledDistances);
    [hA, pA, ciA, statsA] = vartest2(setADistances, shuffledDistances, 'Tail', 'right');
    [hB, pB, ciB, statsB] = vartest2(setBDistances, shuffledDistances, 'Tail', 'right');
    disp(pA);
    disp(pB);

end