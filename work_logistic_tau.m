%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
k = 4; % local community size
XY = landscape256;
P = length(XY(:,1)); % number of patch
    distance = squareform( pdist(XY)); % spatial implicit model, c is a dummy
%% Species parameters    
 sA = 1; % sA =1; sB is the relative body size
    EA = 0.1;
    cA = 1;    
 tf1 = 0; % trade-off on r, r = 1 * sA^tf1, 0 means no trade off
 %% Simulation parameters
    tlim = 400;
    it = 1;
    tau =0.05; % with tau = 0.01 ~8 seconds, no fix negative values
    ts = 0:tau:tlim;
   % ntrace = 10;
%% simulated habitat loss
% rng(2)
 loss = 128;
 P = 256 - loss;
ind = sort(randperm(256, P));
XY = XY(ind,:);
  distance = squareform( pdist(XY)); 
%   myplot(XY(:,1), XY(:,2), 'S', 7.5, [], 7); axis([-1 13 -1 13])
     n0 = repmat(round([k/sA/2 ]), P, 1); 
%%
 
% rng(1)
tic
      [x, note] = Logistictauleap(n0, tlim, tau, distance, [] , sA, EA, cA, tf1);
toc

x1 = permute(x, [1 3 2]); % so the dimensions in x1 are [patch, time, species]
 A = x1(:,:,1);
%%

 % B = x1(:,:,2);
 destiny = sum(x( :, :, end),1);
%  sum_destiny =sum([all(destiny, 2), destiny>1, any(destiny, 2)==0]);
 str = para2str(P,k, EA, EB, cA, cB);
 

%%
figure
    indA = find(A(:,end));
    scatter(XY(indA,1), XY(indA,2), A(indA,end)*5, ...
           'MarkerFaceColor', mycolor(3),'MarkerEdgeColor', mycolor(3)); hold on
  %  indB = find(B(:,end));
   % scatter(XY(indB,1)+0.2, XY(indB,2), B(indB,end)*5, ...
   %        'MarkerFaceColor', mycolor(4),'MarkerEdgeColor', mycolor(4)); hold on
 %      axis([-1 13 -1 13])
%    title( {str{:}, [str2{:}, str3]})       

%% Demo
Pshow=5
figure
%mysubplot(Pshow,1,0, str);
for p = 1:Pshow
mysubplot(Pshow,1,p)
    myplot(t, x1(p, :, 1), 'L', 3); hold on
%    myplot(t, x1(p, :, 2), 'L', 4);
    axis([0 tlim 0  2.5*k ])
    if p~=Pshow
            set(gca, 'xtick',[])
    end
end
