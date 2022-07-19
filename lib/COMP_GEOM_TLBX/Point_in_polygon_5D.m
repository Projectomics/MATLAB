%% Point in polyhedron (PIP) problem in 5-dimensional space
% The point-in-polyhedron (PIP) problem asks whether each point of an
% arbitrary point set (query points) lies inside, outside, or on the
% boundary of the convex hull of another given point set (polyhedron in
% space).

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points the convex hull of which defines the polyhedron.
points=rand(100,5);
%% 
% Set the query points, i.e. the points for which it will be determined if
% they lie inside or outside the polyhedron formed by the convex hull of
% $points$.
querypoints=0.3+rand(10,5);

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


