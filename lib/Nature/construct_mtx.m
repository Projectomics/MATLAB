function construct_mtx(input)
    addpath('../output/');
    matrix = readmatrix('matrix.txt');
    barcodes = readmatrix('barcodes.txt');
    genes = readmatrix('genes.txt');
    
    genesRow = matrix(1, 1);
    barcodesRow = matrix(1, 2);
    matRow = matrix(1, 3);
    matrix(1, :) = [];    
    data = zeros(barcodesRow, genesRow);
    
    for i = 1:matRow
       geneId = matrix(i, 1);
       cellId = matrix(i, 2);
       count = matrix(i, 3);
       data(cellId, geneId) = count;
    end
    
    writematrix(data, '../output/natureData.csv');
    
end