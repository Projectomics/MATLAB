function convexHull_outliers(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    dispStr = sprintf('Enter 1st row number of input file for analysis');
    disp(dispStr);
    r1 = str2num(input('Your selection: ', 's'));
    
    dispStr = sprintf('\nEnter 2nd row number of input file for analysis');
    disp(dispStr);
    r2 = str2num(input('Your selection: ', 's'));    
    
    % Select JSON files to load
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    [nRows, nCols] = size(clusterMatrix);
    
    for r = 1:nRows
        tempNeurons = clusterMatrix(r, :);
        for c = 1:length(tempNeurons)
           if (strcmpi(tempNeurons(c), ''))
              break;
           else
               clusterNeurons(c) = tempNeurons(c);
           end
        end
        %if(r==1 || r==2 || r==3) % || r==4 ||r==5
        if (r ~= r1 && r ~= r2)
            clear clusterNeurons;
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
                color = 'green';
            elseif(r == 2)
                color = 'none';
            elseif(r == 4)
                color = 'red';
            elseif(r == 5)
                color = 'blue';
            else
                color = 'yellow';
            end

%             if(r == 1)
%                 color = 'magenta';
%                 %f8
%             elseif(r == 2)
%                 color = 'none';
%                 %d15
%             elseif(r == 3)
%                 color = 'green';
%                 %e8
%             elseif(r == 5)
%                 color = 'red';
%                 %b29
%             elseif(r == 6)
%                 color = 'blue';
%                 %a28
%             else
%                 color = 'cyan';
%                 %c5
%             end
            
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
            if(r ~= 1)
            %if(r ~= 1 && r~= 3 && r~=4)
                for row = 1:length(outliers)
                    idx = outliers(row) - (row-1);
                    xArrayNew(idx, :) = [];
                    yArrayNew(idx, :) = [];
                    zArrayNew(idx, :) = [];
                end
            end
            
            [kNew,avNew] = convhull(xArrayNew,yArrayNew,zArrayNew); 
            trisurf(kNew,xArrayNew,yArrayNew,zArrayNew,'FaceColor', color);
            axis equal
            hold on;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            alpha(0.5);
            
            %str = strcat('./output/', region, num2str(r), '_TESTcluster_convexHullfig');
            %saveas(gcf, str);

            if(r == r1)
               points1 = [xArrayNew, yArrayNew, zArrayNew];
            else
               points2 = [xArrayNew, yArrayNew, zArrayNew];
            end  
         
            clear clusterNeurons;
            clear outliers;
            clear xArray;
            clear yArray;
            clear zArray;
        end
    end
    clusterStr = sprintf('_%d&%dcluster_convexHull_outliers', r1, r2);
    str = strcat('./output/', region, clusterStr);
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
%     
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
%     
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