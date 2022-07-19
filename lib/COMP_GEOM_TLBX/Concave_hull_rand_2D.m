%% Concave hull from a 2D scattered point set with a cavity

%% Introduction
% In this example, a 2-dimensional random point set is given, which has an
% internal cavity. The idea for the concave hull creation is to create the
% convex hull of the given point set (point set 1) and then the convex hull
% of a point set which is a subset of the point set 1 and defines the
% cavity (point set 2). Afterwards the common facets of the two convex
% hulls are deleted. The remaining facets are the facets of the concave
% hull.

%% Initial data
% Set the random number generator.
rng(1);
%%
% Set the dimension of the problem.
d=2;
%% 
% Define the random point set 1, which includes the cavity formed by the
% point set 2.
points1=rand(100,2);
%%
% Define the random point set 2, which forms the cavity included in the
% point set 1.
ind=find(points1(:,1)>0.5 & points1(:,2)>0.2 & points1(:,2)<0.8);
points2=points1(ind,:);
%%
% Plot the points defining the region the concave hull of which is to be
% extracted.
figure('Name','Point sets','NumberTitle','off')
scatter(points1(:,1),points1(:,2),...
    'marker','o','MarkerEdgeColor',[0 0 1],'LineWidth',2)
hold on
scatter(points2(:,1),points2(:,2),...
    'marker','o','MarkerEdgeColor',[1 0.5 0],'LineWidth',2)
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Point sets','FontSize',13)
axis([-0.1 1.1 -0.1 1.1])

%% Processing
% Find the convex hull of the point set 1. Sort the node identities of each
% facet.
ch1=convhull_nd(points1);
ch1=sort(ch1,2);
%%
% Find the convex hull of the point set 2. Make the correspondence to the
% initial indexing $ind$ and sort the node identities of each facet.
ch2=convhull_nd(points2);
ch2=sort(ind(ch2),2);
%%
% Find the common edges of the two convex hulls.
ind2=zeros(0,d);
k=1;
for i=1:size(ch1,1)
    for j=1:size(ch2,1)
        if isequal(ch1(i,:),ch2(j,:))
            ind2(k,:)=[i,j];
            k=k+1;
        end
    end
end
%%
% Find the common edges of the two convex hulls.
ch1(ind2(:,1),:)=[];
ch2(ind2(:,2),:)=[];
%%
% Assemble the remaining facets of the two convex hulls.
chfinal=[ch1;ch2];

%% Plots
% Find the first and the second point identity of each edge of the convex
% hull.
node1=chfinal(:,1);
node2=chfinal(:,2);
%%
% Find the x and y coordinates of the first and second point of each
% edge of the convex hull.
x1=points1(node1,1);
x2=points1(node2,1);
y1=points1(node1,2);
y2=points1(node2,2);
%%
% Arrange the coordinate data.
X1=[x1,x2]';
Y1=[y1,y2]';
%%
% Plot the convex hull.
figure('Name','Concave hull','NumberTitle','off')
line(X1,Y1,'marker','.','markersize',20,'markeredgecolor',[1 0.5 0],...
    'linestyle','-', 'linewidth',2,'color','blue');
xlabel('x','FontSize',13);
ylabel('y','FontSize',13);
title('Concave hull','FontSize',13)
axis([-0.1 1.1 -0.1 1.1])

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

