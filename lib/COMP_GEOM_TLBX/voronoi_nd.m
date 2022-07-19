function V=voronoi_nd(varargin)
% Calculate the vertices of the VORONOI diagram in N Dimensions.
%
% Description
%     #V#=voronoi_nd(#varargin#)
%     gives the coordinates of the vertices of the Voronoi diagram of
%     #points#.
%
% Definitions:
%     (1) A Voronoi diagram is a partitioning of a #n#-dimensional space
%     into regions based on 'closeness' to points in a specific subset of
%     the space. That set of points (called seeds, sites, or generators) is
%     specified beforehand, and for each seed there is a corresponding
%     region consisting of all points closer to that seed than to any
%     other. These regions are called Voronoi cells.
%     (2) The segments of the Voronoi diagram are all the points that are
%     equidistant to the two nearest sites.
%     (3) The Voronoi vertices (nodes) are the points equidistant to three
%     (or more) sites.
%     
% Properties:
%     (1) The dual graph for a Voronoi diagram (in the case of a Euclidean
%     space with point sites) corresponds to the Delaunay triangulation for
%     the same set of points.
%     (2) The closest pair of points corresponds to two adjacent cells in
%     the Voronoi diagram.
%     (3) Assume the setting is the Euclidean plane and a group of
%     different points are given. Then two points are adjacent on the
%     convex hull if and only if their Voronoi cells share an infinitely
%     long side. Similarly for higher dimensions.
%
% Input arguments
%     #varargin# ({#points# #iter2del#}) contains the following arguments:
%         #points# ([#n# x #d#]) is a matrix containing the coordinates of
%         the points the Voronoi diagram of which is to be calculated. #n#
%         is the number of points and #d# is the dimensionality of the
%         problem.
%         #iter2del# (scalar) is a parameter controlling internal point
%         deletion at the convex hull algorithm. Type |help convhull_nd|
%         for more details.
%
% Output arguments
%     #V# ([#u# x #d#]) is a matrix containing the coordinates of the
%     Voronoi diagram vertices. #u# is the number of vertices.
%
% Example:
%     points=[0 0;2 1;1 2;4 0;0 4;4 4];
%     V=voronoi_nd(points);
%     % Plot the initial points and the Voronoi vertices
%     scatter(points(:,1),points(:,2))
%     hold on
%     scatter(V(:,1),V(:,2))
% 
% Parents (calling functions)
% 
% Children (called functions)
%     voronoi_nd > convhull_nd
%     voronoi_nd > convhull_nd > ismembc
%     voronoi_nd > convhull_nd > plane_nd
%

%__________________________________________________________________________
% Contact author
%
%  (c) 2014 by George Papazafeiropoulos
%  First Lieutenant, Infrastructure Engineer, Hellenic Air Force
%  Civil Engineer, M.Sc., Ph.D. candidate, NTUA
%
% Email: gpapazafeiropoulos@yahoo.gr
%
% Website: http://users.ntua.gr/gpapazaf/
%

points=varargin{1};
if nargin>1
    iter2del=varargin{2};
else
    iter2del=Inf;
end
nd=size(points,2);
% Project points onto the R(d+1) paraboloid
w=sum(points.^2,2);
projpoints=[2*points w];
% Find the convex hull of the the R(d+1) paraboloid
[~,cf,df]=convhull_nd(projpoints,iter2del);
% Find the coordinates of the point with the maximum (d+1)th coordinate
% (i.e. w coordinate)
[w0,i]=max(w);
p0=points(i,:);
% Find the point where the plane tangent to the point (p0,w0) on the
% paraboloid crosses the w axis. This is the point that can see the entire
% lower hull.
w_optimal=w0-2*sum(p0.^2);
% Subtract 1000 times the absolute value of w_optimal to ensure that the
% point where the tangent plane crosses the w axis will see all points on
% the lower hull. This avoids numerical roundoff errors.
w_optimal2=w_optimal-1000*abs(w_optimal);
% Set the point where the tangent plane crosses the w axis
p=[zeros(nd,1);w_optimal2];
% Find all faces that are visible from this point (with logical indexing)
visible=cf*p+df>0;
% Extract the simplices in the lower hull in R(d)
V=-cf(:,1:nd)./cf(:,(nd+1)*ones(1,nd));
% Find the coordinates of the Voronoi vertices
V=V(visible,:);

end

