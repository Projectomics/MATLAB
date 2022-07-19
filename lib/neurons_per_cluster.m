function [clusterParcelsFinal, clusterNum] = neurons_per_cluster(clusterName)
% separates out axonal counts per cluster

    addpath('./lib/');

    if (strcmp(clusterName, "A28") == 1)
        clusterNeurons = {'AA0021';	'AA0024';	'AA0026';	'AA0030';	'AA0032';	'AA0072';	'AA0254';	'AA0255';	'AA0256';	'AA0376';	'AA0382';	'AA0414';	'AA0482';	'AA0483';	'AA0525';	'AA0528';	'AA0529';	'AA0547';	'AA0686';	'AA0705';	'AA0713';	'AA0714';	'AA0715';	'AA0716';	'AA0805';	'AA0812';	'AA0877';	'AA0878'};
        clusterNum = 1;
    elseif (strcmp(clusterName, "B29") == 1)
        clusterNeurons = {'AA0159';	'AA0170';	'AA0173';	'AA0374';	'AA0377';	'AA0379';	'AA0386';	'AA0392';	'AA0454';	'AA0458';	'AA0480';	'AA0526';	'AA0531';	'AA0552';	'AA0570';	'AA0681';	'AA0682';	'AA0689';	'AA0690';	'AA0695';	'AA0700';	'AA0707';	'AA0708';	'AA0710';	'AA0720';	'AA0722';	'AA0723';	'AA0724';	'AA0725'};
        clusterNum = 2;    
    elseif (strcmp(clusterName, "C5") == 1)
        clusterNeurons = {'AA0168';	'AA0171';	'AA0203';	'AA0258';	'AA0378'};
        clusterNum = 3;    
    elseif (strcmp(clusterName, "D15") == 1)
        clusterNeurons = {'AA0031';	'AA0125';	'AA0126';	'AA0251';	'AA0259';	'AA0385';	'AA0387';	'AA0468';	'AA0479';	'AA0494';	'AA0524';	'AA0875';	'AA0881';	'AA0912';	'AA1058'};
        clusterNum = 4;
    elseif (strcmp(clusterName, "E8") == 1)
        clusterNeurons = {'AA0033';	'AA0381';	'AA0384';	'AA0696';	'AA0717';	'AA0813';	'AA0860';	'AA0861'};
        clusterNum = 5;
    elseif (strcmp(clusterName, "F8") == 1)
        clusterNeurons = {'AA0244';	'AA0249';	'AA0476';	'AA0477';	'AA0478';	'AA0538';	'AA0709';	'AA1090'};
        clusterNum = 6;
    end
    
    clusterParcels = open_str_data_file('NNLS_test_file.csv');
    [rows, cols] = size(clusterParcels);
    rowIndex = 2;
    clusterParcelsNew(1, 1:cols) = clusterParcels(1, 1:cols);
    for r = 1:rows
        for l = 1:length(clusterNeurons)
            if (strcmp(clusterParcels(r+1,1), clusterNeurons{l,1}) == 1)
                clusterParcelsNew(rowIndex, 1:cols) = clusterParcels(r+1, 1:cols);
                rowIndex = rowIndex + 1;
                break;
            end
        end
        if (rowIndex > (length(clusterNeurons)+1))
            break;
        end
    end
    colIndex = 2;
    [nrows, ncols] = size(clusterParcelsNew);
    parcelList = {'Presubiculum';	'Subiculum';	'fiber tracts';	'corpus callosum';	'cingulum bundle';	'Hippocampal formation';	'Entorhinal area- lateral part';	'Entorhinal area- medial part- dorsal zone';	'Postsubiculum';	'Fasciola cinerea';	'Parasubiculum';	'Ectorhinal area/Layer 1';	'Posterolateral visual area- layer 5';	'Dentate gyrus- molecular layer';	'Dentate gyrus- granule cell layer';	'Lateral septal nucleus- caudal (caudodorsal) part';	'Septofimbrial nucleus';	'Lateral septal nucleus- rostral (rostroventral) part';	'Medial septal nucleus';	'Bed nuclei of the stria terminalis';	'Lateral hypothalamic area';	'Medial mammillary nucleus';	'Hypothalamus';	'Basic cell groups and regions';	'Dentate gyrus';	'Posterolateral visual area- layer 6a';	'Field CA2';	'Field CA3';	'Triangular nucleus of septum';	'Pallidum';	'Nucleus of reunions';	'Interanterodorsal nucleus of the thalamus';	'Anteroventral nucleus of thalamus';	'Lateral dorsal nucleus of thalamus';	'Anteromedial nucleus';	'lateral forebrain bundle system';	'Field CA1';	'stria terminalis';	'Reticular nucleus of the thalamus';	'Anterodorsal nucleus';	'medial forebrain bundle system';	'Caudoputamen';	'Dorsal auditory area- layer 6b';	'Thalamus';	'Superior colliculus- sensory related';	'Retrosplenial area- ventral part- layer 2/3';	'Retrosplenial area- dorsal part- layer 1';	'Retrosplenial area- lateral agranular part- layer 1';	'Retrosplenial area- lateral agranular part- layer 2/3';	'Retrosplenial area- lateral agranular part- layer 5';	'Retrosplenial area- dorsal part- layer 5';	'Retrosplenial area- ventral part- layer 6a';	'Dorsal part of the lateral geniculate complex';	'Dentate gyrus- polymorph layer';	'Striatum';	'Primary visual area- layer 6b';	'Primary visual area- layer 6a';	'Median preoptic nucleus';	'Ventral part of the lateral geniculate complex';	'thalamus related';	'Retrosplenial area- ventral part- layer 5';	'Retrosplenial area- ventral part';	'Retrosplenial area- dorsal part- layer 6a';	'Retrosplenial area- ventral part- layer 1';	'Retrosplenial area- dorsal part- layer 2/3';	'Lateral mammillary nucleus'};
    clusterParcelsFinal(1:nrows,1) = clusterParcelsNew(1:nrows,1);
    for c = 1:cols
        for l = 1:length(parcelList)
        	parcelName = extractAfter(clusterParcelsNew{1,c+1}, ')');
            if (strcmp(parcelName, parcelList{l,1}) == 1)
                clusterParcelsFinal(1:nrows, colIndex) = clusterParcelsNew(1:nrows, c+1);
                colIndex = colIndex + 1;
                break;
            end
        end
        if (colIndex > 94)
            break;
        end
    end
end % neurons_per_cluster()