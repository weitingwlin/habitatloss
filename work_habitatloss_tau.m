%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
k = 5; % local community size
XY = landscape256;
P = length(XY(:,1)); % number of patch
    distance = squareform( pdist(XY)); % spatial implicit model, c is a dummy
%% Species parameters    
sB = 0.8; % sA =1; sB is the relative body size
EA = 0.1;  EB = EA; % emigration rate   
cA = 0.3;    cB = cA/sB; % dispersal kernel, small number means long distance
bBA = 1/sB; %
bAB = 1*sB;
 %% Simulation parameters
    tlim = 300;
    it = 1;
    tau =0.05; % with tau = 0.01 ~8 seconds, no fix negative values
    ts = 0:tau:tlim;
   % ntrace = 10;
%% simulated habitat loss
% rng(2)
loss = 0;
P = 64 - loss;
ind = sort(randperm(64, 64-loss));
XY = XY(ind,:);
  distance = squareform( pdist(XY)); 
%   myplot(XY(:,1), XY(:,2), 'S', 7.5, [], 7); axis([-1 13 -1 13])
     n0 = repmat(round([k/2  k/sB/2]), P, 1); 
%%
 
% rng(1)
tic
      [x, note] = LVtauleap(n0, tlim, tau, distance, k , sB, EA, EB, cA, cB, bAB, bBA);
toc
x1 = permute(x, [1 3 2]); % so the dimensions in x1 are [patch, time, species]
 A = x1(:,:,1);
  B = x1(:,:,2);
 destiny = sum(x( :, :, end),1);
%  sum_destiny =sum([all(destiny, 2), destiny>1, any(destiny, 2)==0]);
 str = para2str(P,k, EA, EB, cA, cB);
 str2 =  para2str(bAB, bBA, sB);
 str3 = para2str(tlim);
%% final
figure
   plot_snapshot(A(:,end), B(:,end), XY);
title( {str{:}, [str2{:}, str3]})   

%% Animation
figure
for t = 1:tlim
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
%%
v = VideoWriter('test.avi');

%%
figure
    indA = find(A(:,end));
    scatter(XY(indA,1), XY(indA,2), A(indA,end)*5, ...
           'MarkerFaceColor', mycolor(3),'MarkerEdgeColor', mycolor(3)); hold on
    indB = find(B(:,end));
    scatter(XY(indB,1)+0.2, XY(indB,2), B(indB,end)*5, ...
           'MarkerFaceColor', mycolor(4),'MarkerEdgeColor', mycolor(4)); hold on
       axis([-1 13 -1 13])
    title( {str{:}, [str2{:}, str3]})       

%% Demo
Pshow=5
figure
mysubplot(Pshow,1,0, str);
for p = 1:Pshow
mysubplot(Pshow,1,p)
    myplot(t, x1(p, :, 1), 'L', 3); hold on
    myplot(t, x1(p, :, 2), 'L', 4);
    axis([0 tlim 0  2.5*k ])
    if p~=Pshow
            set(gca, 'xtick',[])
    end
end
