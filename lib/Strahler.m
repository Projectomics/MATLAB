function Strahler()
% Function to determine the Strahler order values for all .SWC neuronal
% reconstructions stored in a particular file directory. Statistics are
% accumulated by branch order and per neuron.

    % Add necessary library paths
    addpath('./lib/');

    % Clear all variables to start fresh
    clear all;

    %% Global initialization
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    neuronSwcFiles = dir('./data/Mouse_Neurons/MouseLight_PRE_SWC_files/*.swc');

    nFiles = length(neuronSwcFiles);

    axonalBranchLengthStatistics = cell(nFiles, 35);
    

    %% Write out the header for the accumulation of axonal branch statistics per file
    lengthOutputFileName = sprintf('./output/branch_statistics_per_neuron__%s.xlsx', nowDateStr);

    lengthHeader = cell(1, 30);

    lengthHeader(1, 1) = {'Neuron'};
    lengthHeader(1, 2:5:27) = {'Mean branch length'};
    lengthHeader(1, 3:5:28) = {'N'};
    lengthHeader(1, 4:5:29) = {'Mean # of nodes per branch'};
    lengthHeader(1, 5:5:30) = {'Strahler order'};
    lengthHeader(1, 6:5:26) = {''};

    writecell(lengthHeader, lengthOutputFileName);


    %% Write out the header for the detailed axonal branch statistics per branch
    perBranchOutputFileName = sprintf('./output/branch_statistics_per_branch__%s.xlsx', nowDateStr);

    header = cell(1, 7);

    header(1, 1) = {'Neuron'};
    header(1, 3) = {'Strahler order'};
    header(1, 5) = {'Branch length'};
    header(1, 7) = {'# of nodes per branch'};
    header(1, 2:2:6) = {''};

    writecell(header, perBranchOutputFileName);


    for iFile = 1:nFiles

        %% Local initialization

        axonalBranchLengthCounter = 0;

        swcFileName = sprintf('./data/Mouse_Neurons/MouseLight_PRE_SWC_files/%s', neuronSwcFiles(iFile).name);
        [ids, types, X, Y, Z, R, pids, swcHeader] = read_swc_file(swcFileName);

        nNodes = length(pids);

        strahlerNos = ones(nNodes, 1);

        % Counter to keep track of which branch nodes have had all child
        % branches assigned Strahler numbers
        nChildBranchesAssignedStrahlerNumbers = zeros(nNodes, 1);

        % Find which pids occur more than once (ignore root node)
        histogramCounts = histcounts(pids(2:end), max(pids));

        % Find the indexes of the histogram counts that are greater than one,
        % taking into account the root node
        idxHistogramCountsGreaterThanOne = find(histogramCounts > 1) + 1;

        nHistogramCountsGreaterThanOne = length(idxHistogramCountsGreaterThanOne);

        idxBranchNodes = zeros(nHistogramCountsGreaterThanOne, 1);

        % Loop through the histogram counts that are greater than one
        for i = 1:nHistogramCountsGreaterThanOne

            % Find the index positions of the first nodes of the children of the
            % branch nodes
            idxFirstNodesOfBranchNodeChildren = find(pids == pids(idxHistogramCountsGreaterThanOne(i)));

            % Find the index positions of the branch nodes
            idxBranchNodes(i) = idxFirstNodesOfBranchNodeChildren(1) - 1;

        end % i

        % Don't count the root node as a branch node
        idxBranchNodes = idxBranchNodes(2:end);


        %% End nodes

        % Find the index positions of all the end nodes
        deltaPids = pids(2:nNodes) - pids(1:nNodes-1);
        idxEndNodes = [find(deltaPids <= 0); nNodes]; % Add the last node to the list of end nodes

        nEndNodes = length(idxEndNodes);

        % Search backward from each end node to the first encountered branch
        % node, the first encountered end node, or the root node
        for iNode = 1:nEndNodes
            
            idxCurrentNodeToCheck = idxEndNodes(iNode);

            idxPreviousNodeToCheck = idxCurrentNodeToCheck;

            currentAxonalBranchLength = 0;
            nCurrentAxonalBranchNodes = 0;

            isContinueBacktracking = 1;

            while isContinueBacktracking

                idxCurrentNodeToCheck = idxCurrentNodeToCheck - 1;

                % Calculate current segment length
                deltaX = X(idxPreviousNodeToCheck) - X(idxCurrentNodeToCheck);
                deltaY = Y(idxPreviousNodeToCheck) - Y(idxCurrentNodeToCheck);
                deltaZ = Z(idxPreviousNodeToCheck) - Z(idxCurrentNodeToCheck);
                currentSegmentLength = sqrt(deltaX^2 + deltaY^2 + deltaZ^2);

                % Check if next node is a branch node
                if any(idxCurrentNodeToCheck == idxBranchNodes)

                    % Update the counter for a branch node that tracks how
                    % many child branches have been assigned Strahler numbers
                    nChildBranchesAssignedStrahlerNumbers(idxCurrentNodeToCheck) = nChildBranchesAssignedStrahlerNumbers(idxCurrentNodeToCheck) + 1;
                    
                    isContinueBacktracking = 0;
    
                % Check if next node is an end node
                elseif any(idxCurrentNodeToCheck == idxEndNodes)

                    % Find the index positions of the pids equal to the pid
                    % of the previously checked node
                    idxAllMatchesOfPreviousNodeToCheck = find(pids == pids(idxPreviousNodeToCheck));

                    % Identify the index position of the branch node
                    % corresponding to the previous node
                    idxBranchNodeOfAllMatchesOfPreviousNodeToCheck = idxAllMatchesOfPreviousNodeToCheck(1) - 1;

                    % Update the counter for a branch node that tracks how
                    % many child branches have been assigned Strahler numbers
                    nChildBranchesAssignedStrahlerNumbers(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck) = nChildBranchesAssignedStrahlerNumbers(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck) + 1;

                    % Calculate current segment length
                    deltaX = X(idxPreviousNodeToCheck) - X(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                    deltaY = Y(idxPreviousNodeToCheck) - Y(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                    deltaZ = Z(idxPreviousNodeToCheck) - Z(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                    currentSegmentLength = sqrt(deltaX^2 + deltaY^2 + deltaZ^2);

                    isContinueBacktracking = 0;
                    
                % Check if the next node to check is the root node
                elseif (idxCurrentNodeToCheck == 1)

                    % Update the counter for the root node that tracks how
                    % many child branches have been assigned Strahler numbers
                    nChildBranchesAssignedStrahlerNumbers(1) = nChildBranchesAssignedStrahlerNumbers(1) + 1;
                    
                    isContinueBacktracking = 0;
    
                end % if sum find

                % Add the current segment length to the current axonal branch
                % length
                if (types(idxPreviousNodeToCheck) == 2)
                    currentAxonalBranchLength = currentAxonalBranchLength + currentSegmentLength;
    
                    nCurrentAxonalBranchNodes = nCurrentAxonalBranchNodes + 1;
                end

                idxPreviousNodeToCheck = idxCurrentNodeToCheck;

            end % while isContinueBacktracking

            % Update axonal branch statistics
            if (currentAxonalBranchLength > 0)
                axonalBranchLengthCounter = axonalBranchLengthCounter + 1;
                axonalBranchLengths(axonalBranchLengthCounter) = currentAxonalBranchLength;
                axonalBranchStrahlerNos(axonalBranchLengthCounter) = 1;
                nAxonalBranchNodes(axonalBranchLengthCounter) = nCurrentAxonalBranchNodes;
            end

        end % iNode


        %% Branch nodes

        % Keep looping through the branch nodes while there is at least one
        % that has not yet been assigned a Strahler number
        while any(strahlerNos(idxBranchNodes) == 1)

            % Find the index positions of the branch nodes not yet assigned a
            % Strahler number
            idxBranchNodesLeftToAssign = idxBranchNodes(strahlerNos(idxBranchNodes) == 1);

            % Loop through the branch nodes not yet assigned a Strahler number
            for iNode = 1:length(idxBranchNodesLeftToAssign)

                idxCurrentBranchNodeToCheck = idxBranchNodesLeftToAssign(iNode);
    
                % Find the index positions of the first nodes of the child
                % branches to the current branch node
                idxChildrenOfCurrentBranchNodeToCheck = find(pids == pids(idxCurrentBranchNodeToCheck+1));
    
                nBranches = length(idxChildrenOfCurrentBranchNodeToCheck);
    
                % Continue if all the child branches have been assigned
                % Strahler numbers
                if (nChildBranchesAssignedStrahlerNumbers(idxCurrentBranchNodeToCheck) == nBranches)
    
                    maxStrahlerNo = 0;
        
                    for iBranch = 1:nBranches
        
                        if (strahlerNos(idxChildrenOfCurrentBranchNodeToCheck(iBranch)) > maxStrahlerNo)
        
                            maxStrahlerNo = strahlerNos(idxChildrenOfCurrentBranchNodeToCheck(iBranch));
        
                            maxStrahlerCounter = 1;
        
                        elseif (strahlerNos(idxChildrenOfCurrentBranchNodeToCheck(iBranch)) == maxStrahlerNo)
        
                            maxStrahlerCounter = maxStrahlerCounter + 1;

                        end
        
                    end % iBranch
        
%                         fprintf('max Strahler number = %d\n', maxStrahlerNo);
%                         fprintf('max Strahler counter = %d\n', maxStrahlerCounter);
        
                    % If the branch node has one and only one child with
                    % maximum Strahler number i, and all other children have
                    % Strahler numbers less than i, then the Strahler number
                    % of the branch node remains i
                    if (maxStrahlerCounter == 1)
        
                        strahlerNos(idxCurrentBranchNodeToCheck) = maxStrahlerNo;
        
                    % If the branch node has two or more children with
                    % maximum Strahler number i, then the Strahler number of
                    % the branch node is i + 1
                    elseif (maxStrahlerCounter > 1)
        
                        strahlerNos(idxCurrentBranchNodeToCheck) = maxStrahlerNo + 1;
        
                    end
        
%                         fprintf('current branch node Strahler number = %d\n', strahlerNos(idxCurrentBranchNodeToCheck));
        
                    idxCurrentNodeToCheck = idxCurrentBranchNodeToCheck;
        
                    idxPreviousNodeToCheck = idxCurrentNodeToCheck;

                    currentAxonalBranchLength = 0;
                    nCurrentAxonalBranchNodes = 0;

                    isContinueBacktracking = 1;
        
                    while isContinueBacktracking
    
                        idxCurrentNodeToCheck = idxCurrentNodeToCheck - 1;
        
                        % Calculate current segment length
                        deltaX = X(idxPreviousNodeToCheck) - X(idxCurrentNodeToCheck);
                        deltaY = Y(idxPreviousNodeToCheck) - Y(idxCurrentNodeToCheck);
                        deltaZ = Z(idxPreviousNodeToCheck) - Z(idxCurrentNodeToCheck);
                        currentSegmentLength = sqrt(deltaX^2 + deltaY^2 + deltaZ^2);

                        % check if next node is a branch node
                        if any(idxCurrentNodeToCheck == idxBranchNodes)
        
                            % Update the counter for a branch node that tracks
                            % how many child branches have been assigned
                            % Strahler numbers
                            nChildBranchesAssignedStrahlerNumbers(idxCurrentNodeToCheck) = nChildBranchesAssignedStrahlerNumbers(idxCurrentNodeToCheck) + 1;
                            
                            isContinueBacktracking = 0;
            
                        % Check if next node is an end node
                        elseif any(idxCurrentNodeToCheck == idxEndNodes)

                            % Find the index positions of the pids equal to the
                            % pid of the previously checked node
                            idxAllMatchesOfPreviousNodeToCheck = find(pids == pids(idxPreviousNodeToCheck));

                            % Identify the index position of the branch node
                            % corresponding to the previous node
                            idxBranchNodeOfAllMatchesOfPreviousNodeToCheck = idxAllMatchesOfPreviousNodeToCheck(1) - 1;

                            % Update the counter for a branch node that tracks
                            % how many child branches have been assigned
                            % Strahler numbers
                            nChildBranchesAssignedStrahlerNumbers(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck) = nChildBranchesAssignedStrahlerNumbers(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck) + 1;

                            % Calculate current segment length
                            deltaX = X(idxPreviousNodeToCheck) - X(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                            deltaY = Y(idxPreviousNodeToCheck) - Y(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                            deltaZ = Z(idxPreviousNodeToCheck) - Z(idxBranchNodeOfAllMatchesOfPreviousNodeToCheck);
                            currentSegmentLength = sqrt(deltaX^2 + deltaY^2 + deltaZ^2);

                            isContinueBacktracking = 0;
  
                        % Check if the next node to check is the root node
                        elseif (idxCurrentNodeToCheck == 1)
                            
                            % Update the counter for the root node that
                            % tracks how many child branches have been
                            % assigned Strahler numbers
                            nChildBranchesAssignedStrahlerNumbers(1) = nChildBranchesAssignedStrahlerNumbers(1) + 1;
                    
                            isContinueBacktracking = 0;

                        % The current node being evaluated is simply a
                        % continuation of the previous node's branch
                        else

                            % The Strahler number of the current node is the
                            % same as that of the previous node
                            strahlerNos(idxCurrentNodeToCheck) = strahlerNos(idxPreviousNodeToCheck);
                            
                        end % if sum find

                        % Add the current segment length to the current axonal
                        % branch length
                        if (types(idxPreviousNodeToCheck) == 2)
                            currentAxonalBranchLength = currentAxonalBranchLength + currentSegmentLength;
                            nCurrentAxonalBranchNodes = nCurrentAxonalBranchNodes + 1;
                        end

                        idxPreviousNodeToCheck = idxCurrentNodeToCheck;
    
                    end % while isContinueBacktracking
    
                    % Update branch statistics
                    if (currentAxonalBranchLength > 0)
                        axonalBranchLengthCounter = axonalBranchLengthCounter + 1;
                        axonalBranchLengths(axonalBranchLengthCounter) = currentAxonalBranchLength;
                        axonalBranchStrahlerNos(axonalBranchLengthCounter) = strahlerNos(idxCurrentBranchNodeToCheck);
                        nAxonalBranchNodes(axonalBranchLengthCounter) = nCurrentAxonalBranchNodes;
                    end

                end % if (nChildBranchesAssignedStrahlerNumbers(idxCurrentBranchNodeToCheck) == nBranches)

            end % iNode

        end % while (any(strahlerNos(idxBranchNodes) == 1))


        %% Root node

        % Find the first nodes of all children of the root node
        idxFirstNodesOfRootNodeChildren = find(pids == 1);

        nFirstNodesOfRootNodeChildren = length(idxFirstNodesOfRootNodeChildren);

        % If there is only one child to the root node, then assign the Strahler
        % number of the root node to be the same as the first axonal child
        if (nFirstNodesOfRootNodeChildren == 1)
        
            strahlerNos(1) = strahlerNos(idxFirstNodesOfRootNodeChildren);

        else % There are more than one children of the root node

            maxStrahlerNo = max(strahlerNos(idxFirstNodesOfRootNodeChildren));

            nMaxStrahlerNos = length(find(strahlerNos(idxFirstNodesOfRootNodeChildren) == maxStrahlerNo));

            % If the root node has one and only one child with maximum Strahler
            % number i, and all other children have Strahler numbers less than
            % i, then the Strahler number of the root node remains i
            if (nMaxStrahlerNos == 1)

                strahlerNos(1) = maxStrahlerNo;

            % If the root node has two or more children with maximum Strahler
            % number i, then the Strahler number of the root node is i + 1
            else

                strahlerNos(1) = maxStrahlerNo + 1;

            end % if (nMaxStrahlerNo == 1)

        end % if (nFirstNodesOfRootNodeChildren == 1)

        strahlerNos = [strahlerNos(1); strahlerNos(2:end)];

        
        %% Write per axonal branch statistics to file

        axonalBranchLengthStatisticsPerBranch = cell(axonalBranchLengthCounter, 7);

        for i = 1:axonalBranchLengthCounter

            axonalBranchLengthStatisticsPerBranch(i, 1) = {neuronSwcFiles(iFile).name(1:end-4)};
            axonalBranchLengthStatisticsPerBranch{i, 2} = [];
            axonalBranchLengthStatisticsPerBranch(i, 3) = {axonalBranchStrahlerNos(i)};
            axonalBranchLengthStatisticsPerBranch{i, 4} = [];
            axonalBranchLengthStatisticsPerBranch(i, 5) = {axonalBranchLengths(i)};
            axonalBranchLengthStatisticsPerBranch{i, 6} = [];
            axonalBranchLengthStatisticsPerBranch(i, 7) = {nAxonalBranchNodes(i)};

        end % i

        writecell(axonalBranchLengthStatisticsPerBranch, perBranchOutputFileName, 'WriteMode', 'append');


        %% Accumulate axonal branch statistics per file

        axonalBranchLengthStatistics(iFile, 1) = {neuronSwcFiles(iFile).name(1:end-4)};

        nAxonalBranchStrahlerNos = max(axonalBranchStrahlerNos);

        for i = 1:nAxonalBranchStrahlerNos
    
            idx = find(axonalBranchStrahlerNos == i);
    
            axonalBranchLengthStatistics(iFile, ((4*(i-1))+i+1)) = {mean(axonalBranchLengths(idx))};
            axonalBranchLengthStatistics(iFile, ((4*(i-1))+i+2)) = {length(idx)};
            axonalBranchLengthStatistics(iFile, ((4*(i-1))+i+3)) = {mean(nAxonalBranchNodes(idx))};
            axonalBranchLengthStatistics(iFile, ((4*(i-1))+i+4)) = {i};
    
            if (i < nAxonalBranchStrahlerNos)
                axonalBranchLengthStatistics{iFile, ((4*(i-1))+i+5)} = [];
            end

        end


        %% Re-write SWC substituting types=2 with types=5 for Strahler order 1-3

        headerModifiedDescription = sprintf('# For Strahler order 1-3, types=2 changed to types=5\n');
        headerModifiedDate = datetime('now', 'Format', 'uuuu/MM/dd');
        headerModfiedStr = sprintf('# Modified %s\n', headerModifiedDate);
        nSwcHeader = length(swcHeader);
        swcHeader(nSwcHeader+1) = {headerModifiedDescription};
        swcHeader(nSwcHeader+2) = {headerModfiedStr};

        swcModifiedDirectory = sprintf('./output/MouseLight_PRE_SWC_files_modified_%s', nowDateStr);
        if ~exist(swcModifiedDirectory, 'dir')
            mkdir(swcModifiedDirectory);
        end
        swcModifiedFileName = sprintf('%s/%s_modified.swc', swcModifiedDirectory, neuronSwcFiles(iFile).name(1:end-4));

        fid = fopen(swcModifiedFileName, 'w');
        for i = 1:length(swcHeader)
            fprintf(fid, '%s', swcHeader{i});
        end

        for i = 1:nNodes
            if (strahlerNos(i) < 4)
                if (types(i) == 2)
                    types(i) = 5;
                end
            end
        end

        for i = 1:nNodes
            fprintf(fid, '%d %d %f %f %f %f %d\n', ids(i), types(i), X(i), Y(i), Z(i), R(i), pids(i));
        end

        fclose(fid);

        %% Clear variables for the next SWC file to be loaded
        clear types X Y Z pids strahlerNos nChildBranchesAssignedStrahlerNumbers histogramCounts edges
        clear idxHistogramCountsGreaterThanOne idxBranchNodes deltaPids idxEndNodes idxFirstNodesOfBranchNodeChildren
        clear axonalBranchLengths nAxonalBranchNodes axonalBranchStrahlerNos idxStrahlerNosWithTypesEqualToTwo

    end % iFile

    writecell(axonalBranchLengthStatistics, lengthOutputFileName, 'WriteMode', 'append');

end % Strahler()