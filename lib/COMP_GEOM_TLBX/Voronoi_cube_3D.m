%% Voronoi vertices of a 3D gridded point set inside a cube

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the point set the Voronoi vertices of which are calculated.
d=[-1 1];
[x,y,z]=meshgrid(d,d,d);
points=[x(:),y(:),z(:);zeros(1,3)];
%% 
% Perform random permutation to points to avoid infinite loops in
% convhull_nd.
points=points+0.001*rand(size(points));

%% Processing
% Find the vertices of the Voronoi diagram of the point set.
V=voronoi_nd(points);

%% Plots
%
%%
% Plot the initial point set and the Voronoi vertices defined by $V$.
figure('Name','Cube 3D mesh','NumberTitle','off')
scatter3(points(:,1),points(:,2),points(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter3(V(:,1),V(:,2),V(:,3),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Cube 3D mesh','FontSize',13)
axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])

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


