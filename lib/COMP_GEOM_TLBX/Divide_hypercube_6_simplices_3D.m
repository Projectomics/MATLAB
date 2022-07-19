%% Divide a cube into six tetrahedra
% There exist only 13 manners to split a cube in tetrahedras built
% exclusively with the 8 corners of the cube without counting simple
% rotations und reflections of the splittings. There are 12 splittings in 6
% tetrahedra and one in 5 tetrahedra.

%% Initial data
% Set the random number generator.
rng(1);
%%
% Set the dimension of the problem.
d=3;
%%
% Define the 3-dimensional hypercube (cube).
vert=[0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
%% Processing
% Perform random perturbations to the vertices of the hypercube to avoid
% roundoff errors in convhull_nd.
vert=vert+0.001*rand(size(vert));
%%
% Find the Delaunay triangulation of the hypercube.
chull=delaunay_nd(vert);
%%
% Delete the simplices with very small volume. Such simplices are created
% due to the small random perturbations performed in the initial hypercube
% vertices.
V=zeros(size(chull,1),1);
for i=1:size(chull,1)
    A=[vert(chull(i,:),:), ones(d+1,1)];
    V(i)=abs(det(A));
end
V=V/prod(1:d);
chull=chull(V>0.01,:);
V=V(V>0.01,:);

%% Verification
% Verify that the volume of the unit cube is unity.
sum(V)

%% Plots
% *Plot the simplex components of the square.*
%%
% Find the first and the second point identity of each edge of the
% hypercube.
node1=[1;2;3;4;5;6;7;8;1;2;3;4];
node2=[2;3;4;1;6;7;8;5;5;6;7;8];
%%
% Find the x and y coordinates of the first and second point of each edge
% of the hypercube.
x1=vert(node1,1);
x2=vert(node2,1);
y1=vert(node1,2);
y2=vert(node2,2);
z1=vert(node1,3);
z2=vert(node2,3);
%%
% Arrange the coordinate data.
X1=[x1,x2]';
Y1=[y1,y2]';
Z1=[z1,z2]';
%%
% Plot the simplices.
FigHandle=figure('Name','Simplices','NumberTitle','off');
set(FigHandle,'Position',[50, 50, 1800, 500]);
for i=1:size(chull,1)
    subplot(1,6,i)
    line(X1,Y1,Z1,'marker','.','markersize',20,'markeredgecolor',[1 0.5 0],...
        'linestyle','-', 'linewidth',2,'color','blue');
    hold on
    tetramesh(chull(i,:),vert,'FaceColor',[1 0.5 0],...
        'EdgeColor',[0 0 1],'FaceAlpha',0.3);
    view(3)
    axis equal
end

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


