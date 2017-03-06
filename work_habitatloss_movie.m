%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
k = 10; % local community size
XY = landscape64;
P = length(XY(:,1)); % number of patch
    distance = squareform( pdist(XY)); % spatial implicit model, c is a dummy
%% Species parameters    
sB = 0.8; % sA =1; sB is the relative body size
EA = 0.03;  EB = 0.03; % emigration rate   
cA = 0.3;    cB = cA/sB; % dispersal kernel, small number means long distance
bBA = 1/sB^2; %
bAB = 1*sB;
 %% Simulation parameters
    n0 = repmat([2 2 ], P, 1); 
    tlim = 300;
    it = 1;
    trec =300;
    ts = (tlim - trec +1) :0.2: tlim;
   % ntrace = 10;
%% simulated habitat loss
% rng(2)
loss = 0;
P = 64 - loss;
ind = sort(randperm(64, 64-loss));
XY = XY(ind,:);
  distance = squareform( pdist(XY)); 
   n0 = repmat([2 2 ], P, 1); 
%% simulation and grabbing data
% rng(1)
tic
[t, x] = LVmetaGillespie4(n0, tlim, distance, k , sB, EA, EB, cA, cB, bAB, bBA);
toc
    x1 = permute(x, [1 3 2]); % so the dimensions in x1 are [patch, time, species]
    A = fixsample(t, x1(:,:,1), ts);
    B = fixsample(t, x1(:,:,2), ts);
    destiny = sum(x( :, :, end),1);
%  sum_destiny =sum([all(destiny, 2), destiny>1, any(destiny, 2)==0]);
    str = para2str(P,k, EA, EB, cA, cB)
    str2 =  para2str(bAB, bBA, sB)
    str3 = para2str(tlim)
%% final
figure
   plot_snapshot(A(:,end), B(:,end), XY);
title( {str{:}, [str2{:}, str3]})   

%% Animation
figure
for t = 1:300
       % mysubplot(1, 6 , t)
        tsnap = t*1;
        plot_snapshot(A(:,tsnap), B(:,tsnap), XY);
        hold off
        title(['t = ' num2str( tsnap)])
        drawnow limitrate
        pause(0.2)
end
%% record animation
v = VideoWriter('test2.avi');
open(v);
for t = 1:500
       % mysubplot(1, 6 , t)
        tsnap = t*1;
        plot_snapshot(A(:,tsnap), B(:,tsnap), XY);
        hold off
        title(['t = ' num2str( tsnap)])
       M(t) = getframe;
       writeVideo(v, M(t));
        %   pause(0.3)
end
close(v)
%%
figure
movie(M)


