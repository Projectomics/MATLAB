function nShufflesLabel = configure_shuffles_label(nShuffles, nShufflesLabelBase)
% Function to configure a label consisting of the data's base file name and
% a short-hand description of the number of shuffles that the user selected

    if (mod(nShuffles,1000000000) == 0)
        nShufflesLabel = sprintf('%s__%d%c', nShufflesLabelBase, nShuffles/1000000000, 'B');
    elseif (mod(nShuffles,1000000) == 0)
        nShufflesLabel = sprintf('%s__%d%c', nShufflesLabelBase, nShuffles/1000000, 'M');
    elseif (mod(nShuffles,1000) == 0)
        nShufflesLabel = sprintf('%s__%d%c', nShufflesLabelBase, nShuffles/1000, 'K');
    else
        nShufflesLabel = sprintf('%s__%d', nShufflesLabelBase, nShuffles);
    end

end % configure_shuffles_label()