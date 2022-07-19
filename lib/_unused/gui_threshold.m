function thresholdArray = gui_threshold()

    % Questions & Description of Threshold
    prompt = {sprintf('%s\n\n%s', 'If morphology matrix value > threshold - turns into 1, otherwise - turns into 0', 'Enter axon threshold'), 'Enter dendrite threshold'};
    
    % Sets title of window
    dlgtitle = 'Threshold Input';

    % Sets default value in text boxes
    default = {'0','0'};
    
    % Creates cell array of whatever is typed into the box
    thresholdArray = inputdlg(prompt, dlgtitle, [1 135], default);

end % gui_threshold
