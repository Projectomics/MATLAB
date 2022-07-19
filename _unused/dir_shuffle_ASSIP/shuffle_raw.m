function fileName = shuffle_raw(inputFile, region)

    addpath('./lib/');
    addpath('./output');
    addpath('../dir_MouseLight_ASSIP/lib/');
    addpath('../dir_shuffle_ASSIP/lib/');

    outfile = sprintf('./output/%s', inputFile);
    fid = fopen(outfile, 'r');
    matrixIn = textscan(fid, '%d', 'delimiter', ',');
    fclose(fid);  

    strng = sprintf('\nLoading raw counts from data file ...\n');
    disp(strng);
    
    fileNameFull = sprintf('./output/%s', inputFile);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ','));
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ',');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        rawCell(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end
    
    for i = 1:nRows
        for j = 1:nCols
            raw(i, j) = str2double(rawCell{i, j});
        end % j
    end % i
   
    rs = sum(raw,2); %zeros(size(matrix,1)) % target row sum
    cs = sum(raw); %zeros(size(matrix,1)) % target column sum

   if abs(sum(rs)-sum(cs)) > 1e-10*abs(sum(rs))
        error('sum(rs) must be equal to sum(cs)'); 
    end
    % This part need to be done once if rs and cs are unchanged
    m = length(rs);
    n = length(cs);
    I = zeros(m,n);
    I(:) = 1:m*n;
    Aeq = accumarray([repmat((1:m)',n,1) I(:); repelem(m+(1:n)',m,1) I(:)],1);
    beq = [rs(:); cs(:)];
    lb = zeros(m*n,1);
    ub = inf(m*n,1);
    B = zeros(m*n);
    for k=1:m*n
        f = accumarray(k, 1, [m*n 1]);
        B(:,k) = linprog(f, [], [], Aeq, beq, lb, ub);   
    end
    % This part generate new random A 
    x = randfixedsum(m*n,1,1,0,1); % Fex
    matrix = reshape(B*x,[m n]);
    % Check
    sumrow = sum(matrix,2); % ~ rs
    sumcol = sum(matrix,1); % ~ cs
    
    % output
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    tag = 'rawShuffled';
    filePath = './output/';
    fileName = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);
    outFile = strcat(filePath, fileName);
    fid = fopen(outFile, 'w');
    for i = 1:nRows
        for j = 1:nCols
            fprintf(fid, '%d,', matrix(i, j));
        end % j
        fprintf(fid, '\n');
    end % i
    fclose(fid)
    
end