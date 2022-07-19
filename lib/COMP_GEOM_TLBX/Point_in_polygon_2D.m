%% Point in polygon (PIP) problem in 2-dimensional space
% The point-in-polygon (PIP) problem asks whether each point of an
% arbitrary point set (query points) lies inside, outside, or on the
% boundary of the convex hull of another given point set (polygon in
% plane).

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points the convex hull of which defines the polygon.
points=rand(100,2);
%% 
% Set the query points, i.e. the points for which it will be determined if
% they lie inside or outside the polygon formed by the convex hull of
% $points$.
querypoints=0.3+rand(10,2);
%%
% Plot the points the convex hull of which defines the polygon (in blue)
% and the query points (in orange).
figure('Name','Point set and query points','NumberTitle','off')
scatter(points(:,1),points(:,2),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter(querypoints(:,1),querypoints(:,2),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Point set and query points','FontSize',13)
axis equal

%% Processing
% Find the plane coefficients of the convex hull of the initial point set.
[chull,cf,df]=convhull_nd(points);
%%
% Determine if the query points are inside or outside the polygon formed by
% the convex hull of $points$. If $inpolygon$ is true, then the
% corresponding point is inside the polygon.
inpolygon=~any(cf*querypoints'+df(:,ones(1,size(querypoints,1)))>0,1);
%%
% Find the coordinates of the query points which are inside the polygon.
inpolygon_points=querypoints(inpolygon,:);

%% Plots
% *Plot the convex hull of the initial point set, the query points, and the
% query points which lie inside the convex hull.*
%%
% Find the first and the second point identity of each edge of the convex
% hull of the initial point set.
node1=chull(:,1);
node2=chull(:,2);
%%
% Find the x and y coordinates of the first and second point of each edge
% of the convex hull of the initial point set.
x1=points(node1,1);
x2=points(node2,1);
y1=points(node1,2);
y2=points(node2,2);
%%
% Arrange the coordinate data.
X=[x1,x2]';
Y=[y1,y2]';
%%
% Plot the convex hull of the initial point set (points in filled orange
% and edges in blue), the query points (in blue circles) and the query
% points which lie inside the convex hull (blue circles with orange
% asterisks).
figure('Name','Query points in convex hull','NumberTitle','off')
line(X,Y,'marker','.','markersize',20,'markeredgecolor',[1 0.5 0],...
    'linestyle','-', 'linewidth',2,'color','blue');
hold on
scatter(querypoints(:,1),querypoints(:,2),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
scatter(inpolygon_points(:,1),inpolygon_points(:,2),...
    'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);
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


