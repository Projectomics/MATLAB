function nShufflesLabel = configure_label(nShuffles, nShufflesLabelBase)

    if (mod(nShuffles,1000000000) == 0)
        nShufflesLabel = sprintf('%s_%d%c', nShufflesLabelBase, nShuffles/1000000000, 'B');
    elseif (mod(nShuffles,1000000) == 0)
        nShufflesLabel = sprintf('%s_%d%c', nShufflesLabelBase, nShuffles/1000000, 'M');
    elseif (mod(nShuffles,1000) == 0)
        nShufflesLabel = sprintf('%s_%d%c', nShufflesLabelBase, nShuffles/1000, 'K');
    else
        nShufflesLabel = sprintf('%s_%d', nShufflesLabelBase, nShuffles);
    end

end