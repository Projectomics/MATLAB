function analysis_convergence(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
        
    dispStr = sprintf('Enter parcel(s) for analysis (input ! to exit)');
    disp(dispStr);

    reply = [];
    parcelIndex = 1;
    while (isempty(reply) | reply ~= '!')
       reply = input('\nYour selection: ', 's');
        if ~strcmp(reply, '!')
            count = 1;
            h1 = strcat('(I) ', reply);
            h2 = strcat('(C) ', reply);
            parcelArray{parcelIndex} = h1;
            parcelIndex = parcelIndex+1;
            parcelArray{parcelIndex} = h2;
            parcelIndex = parcelIndex+1;
        end  
    end
    if(count == 0)
       disp('Exiting'); 
    else
        nParcels = length(parcelArray);
        for i = 1:nParcels
           parcel = parcelArray{i};
           convergence_get_length_updated(clusterMatrix, parcel, region);
        end
    end            
    
end % analysis_convergence()