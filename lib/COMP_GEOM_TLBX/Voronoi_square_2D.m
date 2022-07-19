%% Voronoi vertices of a 2D gridded point set inside a square

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the point set the Voronoi vertices of which are calculated.
d=-1:0.5:1;
[x,y]=meshgrid(d,d);
points=[x(:),y(:);zeros(1,2)];
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
figure('Name','Square 2D mesh','NumberTitle','off')
scatter(points(:,1),points(:,2),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter(V(:,1),V(:,2),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Square 2D mesh','FontSize',13)
axis([-1.5 1.5 -1.5 1.5])

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


