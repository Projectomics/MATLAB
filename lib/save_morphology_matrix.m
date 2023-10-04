function save_morphology_matrix(morphologyMatrix, regionStr, nowDateStr)
% Function to save the morphologyMatrix structure array

    % Generate filenames for saving data
    parcelsFileName = sprintf('./data/%s__parcels_%s.xlsx', regionStr, nowDateStr);
    neuronsFileName = sprintf('./data/%s__neurons_%s.xlsx', regionStr, nowDateStr);
    axonDendriteCountsFileName = sprintf('./data/%s__axon-dendrite_counts_%s.xlsx', regionStr, nowDateStr);
    somaLocationsFileName = sprintf('./data/%s__soma_locations_%s.xlsx', regionStr, nowDateStr);

    % Write all the parcels from the morphologyMatrix structure array to an Excel file
    writecell(morphologyMatrix.parcels', parcelsFileName);
    
    % Write all the neuron types from the morphologyMatrix structure array to an Excel file
    writecell(morphologyMatrix.neuronTypes', neuronsFileName);

    % Initialize cell arrays for the axon-dendrite counts and soma locations
    axonDendriteCountsCellArray{1, 1} = "Neurons \ Parcels";
    somaLocationsCellArray{1, 1} = "Neurons \ Parcels";

    % Populate the first row with the parcel names
    for col = 1:morphologyMatrix.nCols
        axonDendriteCountsCellArray{1, col+1} = morphologyMatrix.parcels{col};
        somaLocationsCellArray{1, col+1} = morphologyMatrix.parcels{col};
    end % col

    % Populate cell arrays with the axon-dendrite counts and soma locations
    for row = 1:morphologyMatrix.nRows

        % Axonal and dendritic counts of points per parcel
        axonDendriteCountsCellArray{2*row, 1} = [morphologyMatrix.neuronTypes{row}, ' [A]'];
        for col = 1:morphologyMatrix.nCols
            axonDendriteCountsCellArray{2*row, col+1} = morphologyMatrix.axonCounts(row, col);
        end % col

        axonDendriteCountsCellArray{2*row+1, 1} = [morphologyMatrix.neuronTypes{row}, ' [D]'];
        for col = 1:morphologyMatrix.nCols
            axonDendriteCountsCellArray{2*row+1, col+1} = morphologyMatrix.dendriteCounts(row, col);
        end % col
        
        % Soma locations
        somaLocationsCellArray{row+1, 1} = morphologyMatrix.neuronTypes{row};
        for col = 1:morphologyMatrix.nCols
            if morphologyMatrix.somaCounts(row, col) >= 1
                somaLocationsCellArray{row+1, col+1} = 1;
            else
                somaLocationsCellArray{row+1, col+1} = 0;
            end
        end % col

    end % row
    
    % Write the axon-dendrite counts to an Excel file
    writecell(axonDendriteCountsCellArray, axonDendriteCountsFileName);

    % Write the soma locations to an Excel file
    writecell(somaLocationsCellArray, somaLocationsFileName);

end % save_morphology_matrix()