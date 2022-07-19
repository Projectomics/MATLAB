%% Voronoi vertices of 3-dimensional region defined by random point set

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the point set the Voronoi vertices of which are calculated.
points=-5 + (10)*rand(10,3);

%% Processing
% Find the vertices of the Voronoi diagram of the point set.
V=voronoi_nd(points);

%% Plots
%
%%
% Plot the initial point set and the Voronoi vertices defined by $V$.
figure('Name','Voronoi vertices of random 3D point set','NumberTitle','off')
scatter3(points(:,1),points(:,2),points(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter3(V(:,1),V(:,2),V(:,3),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Voronoi vertices of random 3D point set','FontSize',13)
axis([-7 4 -5 4 -5 10])

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


