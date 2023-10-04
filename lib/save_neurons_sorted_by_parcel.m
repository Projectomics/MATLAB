function save_neurons_sorted_by_parcel(groupings, regionStr, nowDateStr)
% Function to save all MouseLight neurons sorted by brain parcel to an Excel file

    fprintf('Saving sorted neurons by parcel ...\n');
    
    % Generate the output file name
    fileName = sprintf('./output/%s_sorted_neurons_by_parcel_%s.xlsx', regionStr, nowDateStr);
    
    % Populate a cell array with the grouped brain parcel names and neuron names
    for row = 1:length(groupings.brainParcels)
        neuronsSortedByParcel{1}(row, 1) = groupings.brainParcels(row);

        for col = 1:length(groupings.neurons)
            neuronsSortedByParcel{1}(row, col+1) = {groupings.neurons(row, col)};
        end % col
    end % row
    
    % Write the sorted neurons by brain parcel to an Excel file
    writecell(neuronsSortedByParcel{1}, fileName);

end % save_neurons_sorted_by_parcel()