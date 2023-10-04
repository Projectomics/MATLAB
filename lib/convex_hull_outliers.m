function convex_hull_outliers(clusterMatrix, regionStr)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('./lib/COMP_GEOM_TLBX');

    nClusters = size(clusterMatrix, 1);
    clusterNames = cell(nClusters);

    for c = 1:nClusters

        tempNeurons = clusterMatrix(c, :);
        nNeurons = 0;
        for n = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        clusterNames{c} = sprintf('%c%d', char(65+nClusters-c), nNeurons);

    end % c (nClusters)

    cluster1 = select_somata_cluster(clusterNames, '1st');

    cluster2 = select_somata_cluster(clusterNames, '2nd');

    % Select JSON files to load
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    for clusterNo = 1:nClusters

        tempNeurons = clusterMatrix(clusterNo, :);
        nNeurons = 0;
        for n = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        clusterNeurons = tempNeurons(1:nNeurons);

        %if(r==1 || r==2 || r==3) % || r==4 ||r==5
        if (clusterNo ~= cluster1 && clusterNo ~= cluster2)
            clear clusterNeurons;
            continue;
        else
            nFiles = length(clusterNeurons);

            fprintf('\nLoading brain areas from JSON file ...\n');

            index = 1;
            for i = 1:nFiles
                fprintf('Loading JSON file %d of %d\n', i, nFiles);

                fileId = strcat(cell2mat(clusterNeurons(i)), '.json');
                % Load JSON file
                neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);        
                data = loadjson(neuronJsonFileName);

                % Determine parcels invaded by axons
                x = data.neurons{1,1}.soma.x;
                if(x > 5700)
                    diff = x-5700;
                    x = 5700-diff;
                end
                y = data.neurons{1,1}.soma.y;
                z = data.neurons{1,1}.soma.z;          
                xArray(index) = x;
                yArray(index) = y;
                zArray(index) = z;      
                index = index+1;
            end % i    

            xArray = xArray.';  
            yArray = yArray.';
            zArray = zArray.';
            if (clusterNo == 1)
                color = 'green';
            elseif (clusterNo == 2)
                color = 'none';
            elseif (clusterNo == 4)
                color = 'red';
            elseif (clusterNo == 5)
                color = 'blue';
            else
                color = 'yellow';
            end

            if (size(xArray, 1) < 4)
        
                fprintf('\nNot enough points to compute a convex hull volume.\n');
                return;
        
            end

            [k1,av1] = convhull(xArray,yArray,zArray); 
            i = 1;
            for row = 1:nFiles
               xArrayTemp = xArray;
               xArrayTemp(row, :) = [];
               yArrayTemp = yArray;
               yArrayTemp(row, :) = [];
               zArrayTemp = zArray;
               zArrayTemp(row, :) = [];

               [kTemp,avTemp] = convhull(xArrayTemp,yArrayTemp,zArrayTemp);
               thresh = (1/nFiles)*av1;
               threshDown = av1-thresh;
               threshUp = av1+thresh;
               if((threshDown <= avTemp) && (avTemp <= threshUp))
                   continue
               else
                   outliers(i) = row;
                   i = i+1;
               end       
            end

            xArrayNew = xArray;
            yArrayNew = yArray;
            zArrayNew = zArray;
            if (clusterNo ~= 1)
            %if(r ~= 1 && r~= 3 && r~=4)
                for row = 1:length(outliers)
                    idx = outliers(row) - (row-1);
                    xArrayNew(idx, :) = [];
                    yArrayNew(idx, :) = [];
                    zArrayNew(idx, :) = [];
                end
            end
            
            [kNew, avNew] = convhull(xArrayNew,yArrayNew,zArrayNew); 
            trisurf(kNew,xArrayNew,yArrayNew,zArrayNew,'FaceColor', color);
            axis equal
            hold on;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            alpha(0.5);
            
            if (clusterNo == cluster1)
               points1 = [xArrayNew, yArrayNew, zArrayNew];
            else
               points2 = [xArrayNew, yArrayNew, zArrayNew];
            end  
         
            clear clusterNeurons;
            clear outliers;
            clear xArray;
            clear yArray;
            clear zArray;

        end % if clusterNo

    end % clusterNo

    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');
    
    clusterStr = sprintf('_cluster%s_and_cluster%s_convex_hulls_with_outliers_%s', clusterNames{cluster1}, ...
        clusterNames{cluster2}, nowDateStr);
    str = strcat('./output/', regionStr, clusterStr);
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', regionStr, clusterStr, '.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    figure('Name','Point sets','NumberTitle','off')
    scatter3(points1(:,1),points1(:,2),points1(:,3),...
        'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
    hold on
    scatter3(points2(:,1),points2(:,2),points2(:,3),...
        'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
    xlabel('x','FontSize',13);
    ylabel('y','FontSize',13);
    title('Point sets','FontSize',13)
    axis equal
    clusterStr = sprintf('_cluster%s_and_cluster%s_somata_locations_%s', clusterNames{cluster1}, ...
        clusterNames{cluster2}, nowDateStr);   
    str = strcat('./output/', regionStr, clusterStr);
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', regionStr, clusterStr, '.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    [chull1, cf1, df1] = convhull_nd(points1);
    inconvhull1 = ~any(cf1*points2' + df1(:, ones(1,size(points2,1)))>0, 1);
    inter_points1 = points2(inconvhull1, :);
    separate_points2 = points2(~inconvhull1, :);
    [chull2,cf2,df2] = convhull_nd(points2);
    inconvhull2 = ~any(cf2*points1' + df2(:, ones(1,size(points1,1)))>0, 1);
    inter_points2 = points1(inconvhull2, :);
    separate_points1 = points1(~inconvhull2, :);
    inter_points = [inter_points1; inter_points2];
    
    figure('Name','Points of the 2nd point set belonging to the intersection','NumberTitle','off')
    trisurf(chull1,points1(:,1),points1(:,2),points1(:,3),...
        'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
    hold on
    scatter3(points2(:,1),points2(:,2),points2(:,3),...
        'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
    scatter3(inter_points1(:,1),inter_points1(:,2),inter_points1(:,3),...
        'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
    xlabel('x','FontSize',13);
    ylabel('y','FontSize',13);
    zlabel('z','FontSize',13);
    title('Points of the 2nd point set belonging to the intersection','FontSize',13)
    clusterStr = sprintf('_cluster%s_somata_locations_in_intersection_with_cluster%s_%s', ...
        clusterNames{cluster2}, clusterNames{cluster1}, nowDateStr);   
    str = strcat('./output/', regionStr, clusterStr);
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', regionStr, clusterStr, '.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    figure('Name','Points of the 1st point set belonging to the intersection','NumberTitle','off')
    trisurf(chull2,points2(:,1),points2(:,2),points2(:,3),...
        'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
    hold on
    scatter3(points1(:,1),points1(:,2),points1(:,3),...
        'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
    scatter3(inter_points2(:,1),inter_points2(:,2),inter_points2(:,3),...
        'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
    xlabel('x','FontSize',13);
    ylabel('y','FontSize',13);
    title('Points of the 1st point set belonging to the intersection','FontSize',13)
    clusterStr = sprintf('_cluster%s_somata_locations_in_intersection_with_cluster%s_%s', ...
        clusterNames{cluster1}, clusterNames{cluster2}, nowDateStr);   
    str = strcat('./output/', regionStr, clusterStr);
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', regionStr, clusterStr, '.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    figure('Name','Intersection of two point sets','NumberTitle','off')
    trisurf(chull1,points1(:,1),points1(:,2),points1(:,3),...
        'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
    hold on
    trisurf(chull2,points2(:,1),points2(:,2),points2(:,3),...
        'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
    scatter3(inter_points(:,1),inter_points(:,2),inter_points(:,3),...
        'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
    scatter3(inter_points(:,1),inter_points(:,2),inter_points(:,3),...
        'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
    xlabel('x','FontSize',13);
    ylabel('y','FontSize',13);
    title('Intersection of two point sets','FontSize',13)
    clusterStr = sprintf('_somata_locations_in_intersection_of_cluster%s_and_cluster%s_%s', ...
        clusterNames{cluster1}, clusterNames{cluster2}, nowDateStr);   
    str = strcat('./output/', regionStr, clusterStr);
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', regionStr, clusterStr, '.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    if (size(inter_points, 1) < 4)

        fprintf('\nNot enough points to compute an overlap convex hull volume\n');
        proportion = 0;

    else

        [k_inter,av_inter] = convhull(inter_points(:, 1), inter_points(:, 2), inter_points(:, 3));
        [k_sep1,av_sep1] = convhull(separate_points1(:, 1), separate_points1(:, 2), separate_points1(:, 3));
        [k_sep2,av_sep2] = convhull(separate_points2(:, 1), separate_points2(:, 2), separate_points2(:, 3));
    
        totalVol = av_sep1+av_sep2+av_inter;
        proportion = av_inter/totalVol;

    end
    
    fprintf('\nOverlap volume = %f%%\n', 100*proportion);

    percentageStr = sprintf('./output/%s_overlap_volume_of_cluster%s_and_cluster%s_is_%d_percent_%s.txt', ...
        regionStr, clusterNames{cluster1}, clusterNames{cluster2}, round(100*proportion), nowDateStr);
    fid = fopen(percentageStr, 'w');
    fprintf(fid, '%f%%', 100*proportion);
    fclose(fid);
    
end % convex_hull_outliers()