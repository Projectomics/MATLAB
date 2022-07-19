%% Vertices of 3-dimensional convex hull of a random point set

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points the convex hull of which is to be calculated.
points=rand(100,3);
%%
% Plot the point set in blue circles.
figure('Name','Point set','NumberTitle','off')
scatter3(points(:,1),points(:,2),points(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Point set','FontSize',13)

%% Processing
% Find the point identities defining each facet of the convex hull of the
% point set with the new algorithm.
chull1=convhull_nd(points);

%% Plots
%
%%
% Find the coordinates of the vertices of the convex hull.
convhullvert=points(unique(chull1(:)),:);
%%
% Plot the vertices of the convex hull of the point set in orange
% asterisks.
hold on
scatter3(convhullvert(:,1),convhullvert(:,2),convhullvert(:,3),...
    'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);

%% Contact author
%
%  (c) 2014 by George Papazafeiropoulos
%  First Lieutenant, Infrastructure Engineer, Hellenic Air Force
%  Civil Engineer, M.Sc., Ph.D. candidate, NTUA
%
% Email: gpapazafeiropoulos@yahoo.gr
%
% Website: http://users.ntua.gr/gpapazaf/
%


