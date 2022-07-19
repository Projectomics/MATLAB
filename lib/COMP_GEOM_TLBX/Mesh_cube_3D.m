%% Mesh generation of a cube

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points defining the region to be meshed.
d=[-1 1];
[x,y,z]=meshgrid(d,d,d);
points=[x(:),y(:),z(:);zeros(1,3)];
%% 
% Perform random permutation to points to avoid infinite loops in
% convhull_nd.
points=points+0.001*rand(size(points));

%% Processing
% Find the Delaunay triangulation of the point set using the new convex
% hull algorithm.
T1=delaunay_nd(points);

%% Plots
%
%%
% Plot the mesh defined by the triangulation $T1$.
figure('Name','Cube 3D mesh','NumberTitle','off')
tetramesh(T1,points,'FaceColor',[1 0.5 0],...
    'EdgeColor',[0 0 1],'FaceAlpha',0.3);
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Cube 3D mesh','FontSize',13)

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


