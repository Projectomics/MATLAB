function sheetFinal = generate_spreadsheet()

    addpath('./lib/');
    
    reply = select_xlsx_file_name('Please select a file of axonal counts per parcel by cluster for a non-negative least squares analysis.', 'NNLS');
    
    if strcmp(reply, '!')
        sheetFinal = reply;
        return;
    end
    
    newSheet = open_str_xlsx_data_file(reply);

%     newSheet = open_str_data_file('NNLS_test_file.csv');
    colIndex = 2;
    [nParcels, nCols] = size(newSheet);

    parcelList = newSheet(2:end, 1);
%     parcelList = {'Presubiculum';	'Subiculum';	'fiber tracts';	'corpus callosum';	'cingulum bundle';	'Hippocampal formation';	'Entorhinal area- lateral part';	'Entorhinal area- medial part- dorsal zone';	'Postsubiculum';	'Fasciola cinerea';	'Parasubiculum';	'Ectorhinal area/Layer 1';	'Posterolateral visual area- layer 5';	'Dentate gyrus- molecular layer';	'Dentate gyrus- granule cell layer';	'Lateral septal nucleus- caudal (caudodorsal) part';	'Septofimbrial nucleus';	'Lateral septal nucleus- rostral (rostroventral) part';	'Medial septal nucleus';	'Bed nuclei of the stria terminalis';	'Lateral hypothalamic area';	'Medial mammillary nucleus';	'Hypothalamus';	'Basic cell groups and regions';	'Dentate gyrus';	'Posterolateral visual area- layer 6a';	'Field CA2';	'Field CA3';	'Triangular nucleus of septum';	'Pallidum';	'Nucleus of reunions';	'Interanterodorsal nucleus of the thalamus';	'Anteroventral nucleus of thalamus';	'Lateral dorsal nucleus of thalamus';	'Anteromedial nucleus';	'lateral forebrain bundle system';	'Field CA1';	'stria terminalis';	'Reticular nucleus of the thalamus';	'Anterodorsal nucleus';	'medial forebrain bundle system';	'Caudoputamen';	'Dorsal auditory area- layer 6b';	'Thalamus';	'Superior colliculus- sensory related';	'Retrosplenial area- ventral part- layer 2/3';	'Retrosplenial area- dorsal part- layer 1';	'Retrosplenial area- lateral agranular part- layer 1';	'Retrosplenial area- lateral agranular part- layer 2/3';	'Retrosplenial area- lateral agranular part- layer 5';	'Retrosplenial area- dorsal part- layer 5';	'Retrosplenial area- ventral part- layer 6a';	'Dorsal part of the lateral geniculate complex';	'Dentate gyrus- polymorph layer';	'Striatum';	'Primary visual area- layer 6b';	'Primary visual area- layer 6a';	'Median preoptic nucleus';	'Ventral part of the lateral geniculate complex';	'thalamus related';	'Retrosplenial area- ventral part- layer 5';	'Retrosplenial area- ventral part';	'Retrosplenial area- dorsal part- layer 6a';	'Retrosplenial area- ventral part- layer 1';	'Retrosplenial area- dorsal part- layer 2/3';	'Lateral mammillary nucleus'};

    for c = 2:nCols
        for l = 1:length(parcelList)
%         	parcelName = extractAfter(newSheet{1,c}, ')');
%             if (strcmp(parcelName, parcelList{l,1}) == 1)
                sheetFinal{colIndex, 1} = newSheet{1, c};
                colIndex = colIndex + 1;
%             end
        end % l
    end % c
    
    sheetFinal{1,2} = 'A28';
    sheetFinal{1,3} = 'B29';
    sheetFinal{1,4} = 'C5';
    sheetFinal{1,5} = 'D15';
    sheetFinal{1,6} = 'E8';
    sheetFinal{1,7} = 'F8';

end % generate_spreadsheet()