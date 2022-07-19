%% Intersection of two 4D scattered point sets

%% Introduction
% In this example, two 4-dimensional random point sets are given. The basic
% problem of finding the intersection of the two point sets is addressed
% here. To answer this, the points of both point sets which lie in the
% interior of the intersection of the convex hulls of the two point sets
% must be found. To achieve this, use of the plane coefficients of the two
% convex hulls is made, thus showing their necessity in computational
% geometry calculations.

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Define the first scattered point set.
points1=rand(100,4);
%% 
% Define the second scattered point set.
points2=0.5+rand(100,4);

%% Processing
% Find the plane coefficients of the convex hull of the first point set.
[chull1,cf1,df1]=convhull_nd(points1);
%%
% Find the points belonging to the second point set that are inside the
% convex hull of the first point set.
inconvhull1=~any(cf1*points2'+df1(:,ones(1,size(points2,1)))>0,1);
inter_points1=points2(inconvhull1,:);
%%
% Find the plane coefficients of the convex hull of the second point set.
[chull2,cf2,df2]=convhull_nd(points2);
%%
% Find the points belonging to the first point set that are inside the
% convex hull of the second point set.
inconvhull2=~any(cf2*points1'+df2(:,ones(1,size(points1,1)))>0,1);
inter_points2=points1(inconvhull2,:);
%%
% Find the intersection of the two point sets.
inter_points=[inter_points1;inter_points2];

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

