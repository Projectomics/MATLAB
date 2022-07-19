%% Facet enumeration of a random point set in 3-dimensions

%% Introduction
% A convex polytope P can be specified in two ways:
%
% * as the convex hull of the vertex set V of P, or
% * as the intersection of the set H of its facetinducing halfspaces
%
% The vertex enumeration problem is to compute V from H. The facet
% enumeration problem it to compute H from V. These two problems are
% essentially equivalent under point-hyperplane duality and they are among
% the central computational problems in the theory of polytopes.
% The convex hull algorithm of this package is essentially a _facet
% enumeration algorithm_ , which means that it gives the faces
% (facetinducing halfspaces, H) that constitute the convex hull of a given
% set of vertices (V). However, the reverse (i.e. vertex enumeration) is
% also possible using this algorithm, by making use of the point/hyperplane
% duality. 
% The set of all points in  $I\!\!R^{n}$ whose coordinates satisfy a linear
% equation
%
% $$a_{1}X_{1} + \ldots + a_{n} X_{n} + a_{n + 1} = 0
% \qquad \vec{X}\in I\!\!R^n $$
%
% is called a hyperplane. Substituting homogeneous coordinates  $$X_i =
% x_i/x_{n + 1}$ and multiplying out, we get a homogeneous linear equation
% that represents a hyperplane in $${I\!\!P}^{n}$:
%
% $$ (a_1,\ldots,a_{n+1})\cdot(x_1,\ldots,x_{n+1}) = \sum_{i = 1}^{n + 1}
% a_{i} x_{i} = 0 \qquad\vec{x}\in I\!\!P^{n} $$
%
% Notice the symmetry of the last equation between the hyperplane
% coefficients ($a_1, ..., a_{n + 1}$) and the point coefficients ($x_1,
% ..., x_{n + 1}$). For fixed $\vec{x}$ and variable $\vec{a}$, this
% equation can also be viewed as the equation characterizing the
% hyperplanes $\vec{a}$ passing through a given point $\vec{x}$. In fact,
% the hyperplane coefficients $\vec{a}$ are also only defined up to an
% overall scale factor, so the space of all hyperplanes can be considered
% to be another projective space called the dual of the original space
% ${I\!\!P}^{n}$. By the symmetry of the last equation, the dual of the
% dual is the original space. An extremely important duality principle
% follows from this symmetry:
%
% *Duality Principle* : For any projective result established using points
% and hyperplanes, a symmetrical result holds in which the roles of
% hyperplanes and points are interchanged: points become planes, the points
% in a plane become the planes through a point, etc.
%
% In this example the facet enumeration problem (i.e. find the faces
% (facetinducing halfspaces, H) that constitute the convex hull of a given
% set of vertices (V)) is solved.

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the dimension of the problem.
d=3;
%% 
% Set the points the convex hull of which is to be calculated.
points=rand(100,d);

%% Processing
% Find the point identities defining each facet of the convex hull of the
% point set.
[chull,cf,df]=convhull_nd(points);

%% Verification
% Check if the relation A*x + b <= 0 applies for all the vertices found.
if any(cf*points'+df(:,ones(1,size(points,1)))>0)
    error('At least one vertex is not on the convex hull.')
end
%%
% Each vertex found should satisfy three plane equations (since each vertex
% is the intersection of three planes).
if any(sum(cf*points'+df(:,ones(1,size(points,1)))>-100*eps,2)>d)
    warning('The convex hull is degenerate.')
elseif any(sum(cf*points'+df(:,ones(1,size(points,1)))>-100*eps,2)<d)
    error('At least one vertex does not belong to the convex hull.');
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


