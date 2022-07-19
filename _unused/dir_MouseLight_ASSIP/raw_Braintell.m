function differences = raw_Braintell(fileName)
    %clear all;

    addpath('./lib/');
    addpath('../dir_MouseLight_ASSIP/lib/');
    
    %fileName = 'MOp_MouseLight_original_binary.csv';

    rawData = open_data_file(fileName);
    %rawData = open_data_file(fileName);
    
    binaryData = rawData >= 10;
    binaryData = rawData;
    
    [nRows, nCols] = size(binaryData)
    
    nNeurons4nParcels = zeros(nCols, 1);
    nNeurons4nParcels(1:27) = [0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    
    %[nNeurons4nParcels, nParcelsMeanSingles, nParcelsStdevSingles] = combine_singles(binaryData, nNeurons4nParcels);
    
    %[nNeurons4nParcels, nParcelsMeanDoubles, nParcelsStdevDoubles] = combine_doubles(binaryData, nNeurons4nParcels);
    
    %[nNeurons4nParcels, nParcelsMeanTriples, nParcelsStdevTriples] = combine_triples(binaryData, nNeurons4nParcels);
    
    %[nNeurons4nParcels, nParcelsMeanQuadruples, nParcelsStdevQuadruples] = combine_quadruples(binaryData, nNeurons4nParcels);
    
    differencesData = raw_angle_double(binaryData);
    %differencesData = raw_differences_double(binaryData);
    
    nDiffRows = size(differencesData, 1);
    differences = {};
    diffIndex = 1;
    
    fullFileName = sprintf('./output/%s_differences_doublesAxon_%s.csv', fileName(1:end-4), datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fullFileName, 'w');
    for i = 1:nDiffRows
        fprintf(fid, '%d,%d,%d\n', differencesData(i, 1), differencesData(i, 2), differencesData(i, 3));
        differences{diffIndex} = differencesData(i, 3);
        diffIndex=diffIndex+1;
    end % i
    fclose(fid)
    
end % MouseLight()