%% Vertices of convex hull of points lying on the perimeter of a circle

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the points the convex hull of which is to be calculated. They form
% the perimeter of the unit circle.
phi=(pi/50:pi/50:2*pi)';
points=[cos(phi),sin(phi)];
%% 
% Perform random permutation to points to avoid infinite loops in
% convhull_nd.
points=points+0.001*rand(size(points));
%%
% Plot the point set in blue circles.
figure('Name','Point set','NumberTitle','off')
scatter(points(:,1),points(:,2),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Point set','FontSize',13)
axis equal

%% Processing
% Find the point identities defining each facet of the convex hull of the
% point set with the new algorithm.
chull1=convhull_nd(points);

%% Verification
% *Error check: hull size*
%%
% Find the initial number of points.
ipoints=size(points,1);
%%
% Find the number of points consisting the convex hull.
hpoints=length(unique(chull1(:)));
%%
% Check if the number of points consisting the convex hull is equal to the
% initial number of points. Since the configuration of the initial points
% is a boundary that is convex everywhere and does not have internal
% points, this point set will be the convex hull of itself. If this is not
% the case, throw an error.
if ipoints~=hpoints
    error('The number of points does not match the true solution.');
end

%% Plots
%
%%
% Find the coordinates of the vertices of the convex hull.
convhullvert=points(unique(chull1(:)),:);
%%
% Plot the vertices of the convex hull of the point set in orange
% asterisks.
hold on
scatter(convhullvert(:,1),convhullvert(:,2),...
    'marker','*','MarkerEdgeColor',[1 0.5 0],'LineWidth',2);

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


