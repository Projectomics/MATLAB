%% Bounding box of a random point set in 5-dimensional space

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the dimension of the problem.
d=5;
%% 
% Set the points the bounding box of which is to be calculated.
points=rand(30,d);

%% Processing
% Find the maximum and minimum coordinates.
maxp=max(points);
minp=min(points);
%%
% Form the extreme points.
extrp=[maxp;minp];
p1 = reshape(extrp(:,1),[2 1 1 1 1]);
p2 = reshape(extrp(:,2),[1 2 1 1 1]);
p3 = reshape(extrp(:,3),[1 1 2 1 1]);
p4 = reshape(extrp(:,4),[1 1 1 2 1]);
p5 = reshape(extrp(:,5),[1 1 1 1 2]);
p1 = p1(:,ones(2,1),ones(2,1),ones(2,1),ones(2,1));
p2 = p2(ones(2,1),:,ones(2,1),ones(2,1),ones(2,1));
p3 = p3(ones(2,1),ones(2,1),:,ones(2,1),ones(2,1));
p4 = p4(ones(2,1),ones(2,1),ones(2,1),:,ones(2,1));
p5 = p5(ones(2,1),ones(2,1),ones(2,1),ones(2,1),:);
extrp=[p1(:) p2(:) p3(:) p4(:) p5(:)];
%%
% Perform random perturbations to the extreme points to avoid roundoff
% errors in convhull_nd.
extrp=extrp+0.001*rand(size(extrp));
%%
% Find the point identities defining each facet of the bounding box of the
% point set.
chull=convhull_nd(extrp);
%%
% Delete the facets with very small area. Such facets are created due to
% the small random perturbations performed in the extreme points.
V=zeros(size(chull,1),1);
for i=1:size(chull,1)
    A=extrp(chull(i,:),:);
    V(i)=abs(det(A));
end
V=V/prod(1:d);
chull=chull(V>0.002,:);
%%
% Find the number of facets.
size(chull,1)
%% Plots
% Plot the area distribution between the bounding box simplices.
figure('Name','Area distribution','NumberTitle','off')
plot((1:size(V,1))',sort(V))
xlabel('Simplex identity','FontSize',13);
ylabel('Simplex area','FontSize',13);
title('Area distribution','FontSize',13)
axis([0 size(V,1) 0 1.1*max(V)])

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


