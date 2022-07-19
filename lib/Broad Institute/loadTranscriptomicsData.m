function fileName = loadTranscriptomicsData(inputFile, clusterFile)
    %transpose full dataset and output
%     opts = detectImportOptions(inputFile);
%     cellTypes = opts.VariableNames;
%     rawTable = readtable(inputFile);
%     rawCell = table2cell(rawTable);
%     fullData = [cellTypes; rawCell];
%     fullData = transpose(fullData);
% 
%     %save transposed data
%     filePath = './output/';
%     fileName = sprintf('transposed_DATA_MATRIX_LOG_TPM.txt');
%     outFile = strcat(filePath, fileName);
%     fid = fopen(outFile, 'w');
%     [nRows, nCols] = size(fullData);
%     for i = 1:nRows
%         for j = 1:nCols
%             if(i==1 || j==1)
%                 fprintf(fid, '%s\t', fullData{i, j});
%             else
%                 fprintf(fid, '%d\t', fullData{i, j});
%             end
%         end % j
%         fprintf(fid, '\n');
%     end % i
%     fclose(fid)

    
    %extract numerical data & multiply by 1000
    opts = detectImportOptions(inputFile);
    genes = opts.VariableNames;
    genes(:, 1) = [];
    transcriptionData = readmatrix(inputFile);  
    transcriptionData(:, 1) = [];
    transcriptionData = transcriptionData*1000;
    [nRows, nCols] = size(transcriptionData);
     
    
    %add something to divide by cell type
    cellType = 'DG';
    cellTypeRow = 0;
    
    clusters = table2cell(readtable(clusterFile));
    clusters(1, :) = [];
    sorted.labels = unique(clusters(:, 2)); 
    sorted.cells = zeros(length(sorted.labels), nRows);
    %cluster_Broad_Institute(clusters, cellType);
    
    for i = 1:nRows
       label = char(clusters(i, 2));
       for r = 1:length(sorted.labels)
           if strcmp(label, char(sorted.labels(r)))
              break
           end
       end
       for c = 1:nRows
           if(sorted.cells(r, c) == 0)
               sorted.cells(r, c) = i;
               break
           end
       end
       if(strcmp(cellType, label))
          cellTypeRow = r;
       end
    end
   
    save_clusters(sorted.cells, 'broadOfficial');
    % Labels include CA1, CA2, CA3, DG, Ependymal, GABAergic, Glia, Non
    lines = nonzeros(sorted.cells(cellTypeRow, :));
    newNRows = length(lines);
    newMatrix.axonCounts = zeros(newNRows, nCols);
    newMatrix.nRows = newNRows;
    newMatrix.nCols = nCols;
    newMatrix.parcels = genes;
    for r = 1:newNRows
        for c = 1:nCols
           newMatrix.axonCounts(r, c) = transcriptionData(lines(r), c);
        end        
    end    
    
    %filter matrix
    filteredMatrix = filter_bin_matrix(newMatrix, newMatrix, cellType);
    fileName = save_filtered_bin_matrix(filteredMatrix, cellType); 
    
%     sumCols = sum(newMatrix);
%     filteredMatrix.data = zeros(newNRows, nCols);
%     filteredMatrix.genes = strings(1, nCols);
%     filteredCol = 1;
%     
%     for c = 1:nCols
%        if(sumCols(c)==0) 
%             continue
%        else
%            for r = 1:newNRows
%                 filteredMatrix.data(r, filteredCol) = newMatrix(r, c);
%                 filteredMatrix.genes(filteredCol) = genes(c);
%            end
%            filteredCol = filteredCol + 1;
%        end
%     end   
%     filteredMatrix.nRows = newNRows;
%     filteredMatrix.nCols = filteredCol-1;  
%     filteredMatrix.genes = cell2str(filteredMatrix.genes);
    
    %save parcels
%     fileName = sprintf('./output/%s_filteredGenes_%s.txt', cellType, ...
%     datestr(now, 'yyyymmddHHMMSS'));   
%     fid = fopen(fileName, 'w');
%     for col = 1:filteredMatrix.nCols
%        fprintf(fid, '%s;', filteredMatrix.genes(col));        
%     end
%     fclose(fid);
%     
%     %save matrix
%    filePath = './output/';
%    fileName = sprintf('%s_filtered_exp_Matrix%s.csv', cellType, datestr(now, 'yyyymmddHHMMSS'));
%    fullFileName = strcat(filePath, fileName);
%    fid = fopen(fullFileName, 'w');
%    for r = 1:filteredMatrix.nRows
%        for c = 1:filteredMatrix.nCols
%            if col==1
%                fprintf(fid, '%d', filteredMatrix.data(row,col));
%            else
%                fprintf(fid, ',%d', filteredMatrix.data(row,col));
%            end
%        end
%        fprintf(fid, '\n');
%    end
%    fclose(fid);   
    
end
