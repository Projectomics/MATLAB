function neuronNamesByClusterFileName = save_clusters(clusters, nShufflesLabel)
% Function to save cluster data to Excel files

    fprintf('Saving neuron clusters ...\n\n');
    
    % Extract region abbreviation from nShufflesLabel
    idx = strfind(nShufflesLabel,'_');
    regionPrefix = nShufflesLabel(1:idx(1)-1);

    % Get the current date and time in the specified format
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    % Read neuron names from a file
    neuronNamesFileName = sprintf('./data/%s__neuron_names.xlsx', regionPrefix);
    neuronNamesStrArray = readcell(neuronNamesFileName);

    % Define filenames for saving cluster information
    neuronNamesByClusterFileName = sprintf('./output/%s__neuron_names_by_cluster_%s.xlsx', nShufflesLabel, nowDateStr);
    divergenceFileName = sprintf('./data/divergence__%s__neuron_names_by_cluster_%s.xlsx', nShufflesLabel, nowDateStr);
    convergenceFileName = sprintf('./data/convergence__%s__neuron_names_by_cluster_%s.xlsx', nShufflesLabel, nowDateStr);
    somataFileName = sprintf('./data/somata__%s__neuron_names_by_cluster_%s.xlsx', nShufflesLabel, nowDateStr);
    nnlsFileName = sprintf('./data/nnls__%s__neuron_names_by_cluster_%s.xlsx', nShufflesLabel, nowDateStr);
    
    % Iterate through the clusters and save the relevant information
    nRows = size(clusters, 1);
    for row = 1:nRows
        clusterArray = clusters(row, :);
        clusterArray = nonzeros(clusterArray);
        clusterArray = clusterArray.'; % Transpose clusterArray

        neuronNamesByClusterCellArray = {};
        % Populate neuronNamesByClusterCellArray with neuron names from clusterArray
        for i = 1:length(clusterArray)
            neuronNamesByClusterCellArray(1, i) = neuronNamesStrArray(clusterArray(i));
        end % i

        % Write neuron names to the neuronNamesByClusterFileName spreadsheet
        writecell(neuronNamesByClusterCellArray, neuronNamesByClusterFileName, 'WriteMode', 'append');

    end % row
    
    % Copy neuronNamesByClusterFileName to other filenames for different analyses
    copyfile(neuronNamesByClusterFileName, divergenceFileName);
    copyfile(neuronNamesByClusterFileName, convergenceFileName);
    copyfile(neuronNamesByClusterFileName, somataFileName);
    copyfile(neuronNamesByClusterFileName, nnlsFileName);
    
end % save_clusters()