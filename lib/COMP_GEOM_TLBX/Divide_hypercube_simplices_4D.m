%% Divide a 4-dimensional hypercube into 4-dimensional simplices

%% Initial data
% Set the random number generator.
rng(1);
%% 
% Set the dimension of the problem.
d=4;
%% 
% Define the 4-dimensional hypercube.
extrp=[ones(1,d);zeros(1,d)];
p1 = reshape(extrp(:,1),[2 1 1 1]);
p2 = reshape(extrp(:,2),[1 2 1 1]);
p3 = reshape(extrp(:,3),[1 1 2 1]);
p4 = reshape(extrp(:,4),[1 1 1 2]);
p1 = p1(:,ones(2,1),ones(2,1),ones(2,1));
p2 = p2(ones(2,1),:,ones(2,1),ones(2,1));
p3 = p3(ones(2,1),ones(2,1),:,ones(2,1));
p4 = p4(ones(2,1),ones(2,1),ones(2,1),:);
extrp=[p1(:) p2(:) p3(:) p4(:)];

%% Processing
% Perform random perturbations to the vertices of the hypercube to avoid
% roundoff errors in convhull_nd.
extrp=extrp+0.001*rand(size(extrp));
%%
% Find the Delaunay triangulation of the hypercube.
chull=delaunay_nd(extrp);
%%
% Delete the simplices with very small volume. Such simplices are created
% due to the small random perturbations performed in the initial hypercube
% vertices.
V=zeros(size(chull,1),1);
for i=1:size(chull,1)
    A=[extrp(chull(i,:),:), ones(d+1,1)];
    V(i)=abs(det(A));
end
V=V/prod(1:d);
chull=chull(V>0.01,:);
V=V(V>0.001,:);

%% Post-processing
% Find the number of simplices.
size(chull,1)

%% Verification
% Verify that the volume of the unit hypercube is unity.
sum(V)

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


