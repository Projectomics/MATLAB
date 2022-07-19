%% Convex hull of a large point set

%% Introduction
% In this example the convex hull of a relatively large point set is
% calculated. For this purpose, the initial point set is divided into
% smaller point sets. The convex hull of each point set is calculated, and
% finally the convex hull of all the resulting convex hulls is calculated.

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the number of points.
np=1e6;
%% 
% Set the points the convex hull of which is to be calculated.
points=rand(np,3);
%% Processing
% Set the number of the subsets into which the initial point set is
% divided.
ni=10;
%% 
% Calculate the convex hull of each point subset and assemble the resulting
% convex hulls.
chull=[];
for i=1:ni
    fp=1+np/ni*(i-1);
    lp=np/ni*i;
    rp=(fp:lp)';
    chulli=convhull_nd(points(rp,:),10);
    chull=[chull;unique(chulli(:))];
end
%% 
% Drop out duplicate points in the convex hull assembly.
chull=unique(chull);
%% 
% Find the convex hull of the convex hull assembly.
chullfinal=convhull_nd(points(chull,:));   

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


