function save_summary_matrix(morphologyMatrix, region)
   
    fprintf('Saving axonal invasion summary ...\n');

    fileName = sprintf('./output/%s_axonal_invasions_summary_%s.xlsx', region, datetime('now', 'Format', 'yyyyMMddHHmmSS'));    
    
    nCols = morphologyMatrix.nCols;

    axonalInvasionsSummary{1}(1, 1) = {'Summary \ Parcels'};
    for col = 1:nCols
        axonalInvasionsSummary{1}(1, col+1) = morphologyMatrix.parcels(col);
    end % col
    
    axonalInvasionsSummary{1}(2, 1) = {'Total Somata in Parcel'};
    totalSomata = sum(morphologyMatrix.somaCounts);
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(2, col+1) = {totalSomata(col)};
    end     
    
    axonalInvasionsSummary{1}(3, 1) = {'Total Regions Invaded by Axons of Neurons in Parcel'};
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(3, col+1) = {morphologyMatrix.numAxonInvasions(col)};
    end
    
    axonalInvasionsSummary{1}(4, 1) = {'Maximum Number of Regions Invaded by Axons of Neurons in Parcel'};
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(4, col+1) = {morphologyMatrix.maxAxonInvasions(col)};
    end
    
    axonalInvasionsSummary{1}(5, 1) = {'Minimum Number of Regions Invaded by Axons of Neurons in Parcel'};
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(5, col+1) = {morphologyMatrix.minAxonInvasions(col)};
    end
    
    axonalInvasionsSummary{1}(6, 1) = {'Mean of Regions Invaded by Axons of Neurons in Parcel'};
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(6, col+1) = {morphologyMatrix.meanAxonInvasions(col)};
    end
    
    axonalInvasionsSummary{1}(7, 1) = {'Standard Deviation of Regions Invaded by Axons of Neurons in Parcel'};
    for col = 1:morphologyMatrix.nCols
        axonalInvasionsSummary{1}(7, col+1) = {morphologyMatrix.stdAxonInvasions(col)};
    end

    writecell(axonalInvasionsSummary{1}, fileName);
    
end 
