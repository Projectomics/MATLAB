%% Verification of the Upper Bound Theorem (McMullen, 1970) in 3 dimensions

%% Introduction
% The cyclic polytope $CP(n,d)$ may be defined as the convex hull of $n$
% vertices on the moment curve $(t, t^2, t^3, ..., t^d)$. The precise
% choice of which $n$ points on this curve are selected is irrelevant for
% the combinatorial structure of this polytope. The number of
% $(d-1)$ -dimensional facets (faces) of $CP(n,d)$ is given by the formula:
%
% $$f_i(\Delta(n,d)) = \frac{n}{n - \frac{d}{2}} {{n - \frac{d}{2}} \choose
% n-d} \hspace{0.2in} d \quad \textrm{even} \quad $$
%
% $$f_i(\Delta(n,d)) = 2 {{n - \frac{d+1}{2}} \choose n-d} \hspace{0.2in} d
% \quad \textrm{odd} \quad $$
%
% The upper bound theorem states that cyclic polytopes have the largest
% possible number of faces among all convex polytopes with a given
% dimension and number of vertices.

%% Initial data
% Set the points the convex hull of which is to be calculated.
t=(0:0.1:2)';
points=[t,t.^2,t.^3];
%%
% Plot the point set in blue circles.
figure('Name','Point set','NumberTitle','off')
scatter3(points(:,1),points(:,2),points(:,3),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Point set','FontSize',13)

%% Processing
% Find the point identities defining each facet of the convex hull of the
% point set.
chull1=convhull_nd(points);

%% Post-processing
% Find the number of the facets of the convex hull.
nfacets1=size(chull1,1)
%%
% Calculate the number of points the convex hull of which was calculated,
% as well as their dimension.
[n,d]=size(points)
%%
% Calculate the maximum number of faces (2-dimensional facets) that a
% 3-dimensional convex hull ($$d=3$) of 21 points can have.
maxfacets=2*nchoosek(n-(d+1)/2,n-d)
%%
% Check the validity of the Upper Bound Theorem.
if maxfacets<nfacets1
    error('Upper Bound Theorem not satisfied')
end

%% Plots
% Plot the convex hull of the point set.
figure('Name','Convex hull','NumberTitle','off')
trisurf(chull1,points(:,1),points(:,2),points(:,3),...
    'FaceColor',[1 0.5 0],'EdgeColor',[0 0 1]);
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
zlabel('z','FontSize',13);
title('Convex hull','FontSize',13)

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


