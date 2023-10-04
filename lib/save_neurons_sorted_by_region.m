function save_neurons_sorted_by_region(groupings, regionStr, nowDateStr)
% Function to save all MouseLight neurons sorted by brain region to an Excel file

    fprintf('Saving sorted neurons by region ...\n');
    
    % Generate the output file name
    fileName = sprintf('./output/%s_sorted_neurons_by_region_%s.xlsx', regionStr, nowDateStr);
    
    % Initialize a cell array to store sorted neurons by region
    neuronsSortedByRegion{1} = {};
    
    % Populate the cell array with the grouped brain region names and neuron names
    for row = 1:length(groupings.brainRegions)
        neuronsSortedByRegion{1}(row, 1) = groupings.brainRegions(row);

        for col = 1:length(groupings.neurons)
            neuronsSortedByRegion{1}(row, col+1) = {groupings.neurons(row, col)};
        end % col
    end % row
    
    % Write the sorted neurons by brain region to an Excel file
    writecell(neuronsSortedByRegion{1}, fileName);

end % save_neurons_sorted_by_region