%% Point in polyhedron (PIP) problem in 3-dimensional space
% The point-in-polyhedron (PIP) problem asks whether each point of an
% arbitrary point set (query points) lies inside, outside, or on the
% boundary of the convex hull of another given point set (polyhedron in
% space).

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points the convex hull of which defines the polyhedron.
points=rand(100,3);
%% 
% Set the query points, i.e. the points for which it will be determined if
% they lie inside or outside the polyhedron formed by the convex hull of
% $points$.
querypoints=0.3+rand(10,3);
%%
% Plot the points the convex hull of which defines the polyhedron (in blue)
% and the query points (in orange).
figure('Name','Point set and query points','NumberTitle','off')
scatter3(points(:,1),points(:,2),points(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter3(querypoints(:,1),querypoints(:,2),querypoints(:,3),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Point set and query points','FontSize',13)
axis equal

%% Processing
% Find the plane coefficients of the convex hull of the initial point set.
[chull,cf,df]=convhull_nd(points);
%%
% Determine if the query points are inside or outside the polyhedron formed
% by the convex hull of $points$. If $inpolyhedron$ is true, then the
% corresponding point is inside the polyhedron.
inpolyhedron=~any(cf*querypoints'+df(:,ones(1,size(querypoints,1)))>0,1);
%%
% Find the coordinates of the query points which are inside the polyhedron.
inpolyhedron_points=querypoints(inpolyhedron,:);

%% Plots
% Plot the convex hull of the initial point set (points in filled orange
% and edges in blue), the query points (in blue circles) and the query
% points which lie inside the convex hull (blue circles with orange
% asterisks).
figure('Name','Query points in convex hull','NumberTitle','off')
trisurf(chull,points(:,1),points(:,2),points(:,3),...
    'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1],'FaceAlpha',0.3);
hold on
scatter3(querypoints(:,1),querypoints(:,2),querypoints(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
scatter3(inpolyhedron_points(:,1),inpolyhedron_points(:,2),...
    inpolyhedron_points(:,3),'marker','*','MarkerEdgeColor',[1 0.5 0],...
    'LineWidth',2);
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Query points in convex hull','FontSize',13)

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


