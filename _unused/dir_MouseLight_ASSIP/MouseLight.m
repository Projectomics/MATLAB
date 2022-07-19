function differences = MouseLight(fileName)
    %clear all;

    addpath('./lib/');
    addpath('../dir_MouseLight_ASSIP/lib/');
    
    %fileName = 'MOp_MouseLight_original_binary.csv';

    rawData = open_data_file(fileName);
    
    binaryData = rawData >= 10;
    binaryData = rawData;
    
    [nRows, nCols] = size(binaryData)
    
    nNeurons4nParcels = zeros(nCols, 1);
    nNeurons4nParcels(1:27) = [0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    
    [nNeurons4nParcels, nParcelsMeanSingles, nParcelsStdevSingles] = combine_singles(binaryData, nNeurons4nParcels);
    
    [nNeurons4nParcels, nParcelsMeanDoubles, nParcelsStdevDoubles] = combine_doubles(binaryData, nNeurons4nParcels);
    
    %[nNeurons4nParcels, nParcelsMeanTriples, nParcelsStdevTriples] = combine_triples(binaryData, nNeurons4nParcels);
    
    %[nNeurons4nParcels, nParcelsMeanQuadruples, nParcelsStdevQuadruples] = combine_quadruples(binaryData, nNeurons4nParcels);
    
    xorBinaryData = xor_doubles(binaryData);
    
    nXorRows = size(xorBinaryData, 1);
    differences = {};
    diffIndex = 1;
    
    fullFileName = sprintf('./output/%s_xor_doublesAxon_%s.csv', fileName(1:end-4), datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fullFileName, 'w');
    for i = 1:nXorRows
        fprintf(fid, '%d,%d,%d\n', xorBinaryData(i, 1), xorBinaryData(i, 2), xorBinaryData(i, 3));
        differences{diffIndex} = xorBinaryData(i, 3);
        diffIndex=diffIndex+1;
    end % i
    fclose(fid)
    
end % MouseLight()