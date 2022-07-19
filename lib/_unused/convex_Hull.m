function convex_Hull(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    %clear all;

    % Select JSON files to load
    % neuronJsonFiles = dir('./data/JSON/*.json');
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    [nRows, nCols] = size(clusterMatrix);
    
    for r = 1:nRows
        tempNeurons = clusterMatrix(r, :);
        for c = 1:length(tempNeurons)
           if(strcmpi(tempNeurons(c), ''))
              break;
           else
               clusterNeurons(c) = tempNeurons(c);
           end
        end
        if(r==4 || r==5 || r==3)
            continue;
        else
            nFiles = length(clusterNeurons);
            %nFiles = 5;

            strng = 'Loading brain areas from JSON file ...\n';
            disp(strng);

            index = 1;
            for i = 1:nFiles
                strng = sprintf('Loading JSON file %d of %d', i, nFiles);
                disp(strng);

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
            if(r == 1)
                color = 'magenta';
            elseif(r == 2)
                color = 'green';
            elseif(r == 4)
                color = 'red';
            elseif(r == 5)
                color = 'blue';
            else
                color = 'yellow';
            end
            
            [k1,av1] = convhull(xArray,yArray,zArray); 
            trisurf(k1,xArray,yArray,zArray,'FaceColor', color);
            axis equal
            hold on;
            alpha(0.5);
            
            %str = strcat('./output/', region, num2str(r), '_TESTcluster_convexHullfig');
            %saveas(gcf, str);

            if(r == 1)
               points1 = [xArray, yArray, zArray];
            else
               points2 = [xArray, yArray, zArray];
            end   
         
            clear clusterNeurons;
            clear xArray
            clear yArray
            clear zArray
        end
    end
    %str = strcat('./output/', region, num2str(r), '_testcluster_convexHullfig');
    str = strcat('./output/', region, '_D&Ecluster_convexHull');
    saveas(gcf, str);
    
%     figure('Name','Point sets','NumberTitle','off')
%     scatter3(points1(:,1),points1(:,2),points1(:,3),...
%         'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
%     hold on
%     scatter3(points2(:,1),points2(:,2),points2(:,3),...
%         'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
%     xlabel('x','FontSize',13);
%     ylabel('y','FontSize',13);
%     title('Point sets','FontSize',13)
%     axis equal
%     str = strcat('./output/', region, '_testPoints');
%     saveas(gcf, str);
    
    [chull1,cf1,df1]=convhull_nd(points1);
    inconvhull1=~any(cf1*points2'+df1(:,ones(1,size(points2,1)))>0,1);
    inter_points1=points2(inconvhull1,:);
    separate_points2= points2(~inconvhull1,:);
    [chull2,cf2,df2]=convhull_nd(points2);
    inconvhull2=~any(cf2*points1'+df2(:,ones(1,size(points1,1)))>0,1);
    inter_points2=points1(inconvhull2,:);
    separate_points1= points1(~inconvhull2,:);
    inter_points=[inter_points1;inter_points2];
    
%     figure('Name','Points of the 2nd point set belonging to the intersection','NumberTitle','off')
%     trisurf(chull1,points1(:,1),points1(:,2),points1(:,3),...
%         'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
%     hold on
%     scatter3(points2(:,1),points2(:,2),points2(:,3),...
%         'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
%     scatter3(inter_points1(:,1),inter_points1(:,2),inter_points1(:,3),...
%         'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
%     xlabel('x','FontSize',13);
%     ylabel('y','FontSize',13);
%     zlabel('z','FontSize',13);
%     title('Points of the 2nd point set belonging to the intersection','FontSize',13)
%     str = strcat('./output/', region, '_test2nd');
%     saveas(gcf, str);
    
%     figure('Name','Points of the 1st point set belonging to the intersection','NumberTitle','off')
%     trisurf(chull2,points2(:,1),points2(:,2),points2(:,3),...
%         'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
%     hold on
%     scatter3(points1(:,1),points1(:,2),points1(:,3),...
%         'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
%     scatter3(inter_points2(:,1),inter_points2(:,2),inter_points2(:,3),...
%         'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
%     xlabel('x','FontSize',13);
%     ylabel('y','FontSize',13);
%     title('Points of the 1st point set belonging to the intersection','FontSize',13)
%     str = strcat('./output/', region, '_test1st');
%     saveas(gcf, str);
    
%     figure('Name','Intersection of two point sets','NumberTitle','off')
%     trisurf(chull1,points1(:,1),points1(:,2),points1(:,3),...
%         'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
%     hold on
%     trisurf(chull2,points2(:,1),points2(:,2),points2(:,3),...
%         'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
%     scatter3(inter_points(:,1),inter_points(:,2),inter_points(:,3),...
%         'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
%     scatter3(inter_points(:,1),inter_points(:,2),inter_points(:,3),...
%         'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
%     xlabel('x','FontSize',13);
%     ylabel('y','FontSize',13);
%     title('Intersection of two point sets','FontSize',13)
%     str = strcat('./output/', region, '_testintersection');
%     saveas(gcf, str);
    
    [k_inter,av_inter] = convhull(inter_points(:, 1), inter_points(:, 2), inter_points(:, 3));
    [k_sep1,av_sep1] = convhull(separate_points1(:, 1), separate_points1(:, 2), separate_points1(:, 3));
    [k_sep2,av_sep2] = convhull(separate_points2(:, 1), separate_points2(:, 2), separate_points2(:, 3));
    totalVol = av_sep1+av_sep2+av_inter;
    proportion = av_inter/totalVol;
    disp(proportion);
end