function [ids, types, X, Y, Z, R, pids, header] = read_swc_file(swcFileName)

    fprintf('\nLoading SWC file %s ...\n', swcFileName);
    
    fid = fopen(swcFileName, 'r');
    txtLine = fgetl(fid);
    i = 0;
    while strcmp(txtLine(1), '#')
        i = i + 1;
        header{i} = sprintf('%s\n', txtLine);
        txtLine = fgetl(fid);
    end
    fclose(fid);

    fileId = fopen(swcFileName);
    C = textscan(fileId,'%d %d %f %f %f %f %d','CommentStyle','#');
    fclose(fileId);

    % id,type,x,y,z,r,pid
    
    ids = C{1};
    types = C{2};
    X = C{3};
    Y = C{4};
    Z = C{5};
    R = C{6};
    pids = C{7};
    
end % read_swc_file()
