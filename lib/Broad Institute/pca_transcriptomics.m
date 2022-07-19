function pca_transcriptomics()
    addpath('../output/');

%     %file = 'DG_filtered_bnmorphologyMatrix[A]20210927145215.csv';
%     matrix = readmatrix(file); 

    inputFile = 'transposed_DATA_MATRIX_LOG_TPM.txt';
    %inputFile = 'CA1_filtered_bnmorphologyMatrix[A]20211027104348.csv'
    transcriptionData = readmatrix(inputFile);  
    transcriptionData(:, 1) = [];
    [coeff,score,latent,tsquared,explained,mu] = pca(transcriptionData);
    idx = find(cumsum(explained)>95,1);
    
    newScore = round(score);
    newScore = abs(newScore);
    
    writematrix(newScore, 'test_pca.csv');
    
        
    
end