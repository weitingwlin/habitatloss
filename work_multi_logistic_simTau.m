%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
k = 4; % local community size
XY = landscape256;
P = length(XY(:,1)); % number of patch
    distance = squareform( pdist(XY)); % spatial implicit model, c is a dummy
specM = 0.8:0.1:1.2;
S = length(specM) ;
%% Species parameters    
 sA = specM; % sA =1; body sizes in a community
 EA = 0.05; % (individual) Emigration rate; assume to be fixed
 cA = 2; 
 tf1 = 2; % trade-off on r, r = 1 * sA^tf1, 0 means no trade off
 tf2 = 3; %trade-off on cA, cA = 1/sA^tf1

      str1 = para2str( EA, cA, tf1, tf2);
     
 %% Simulation parameters
    tlim = 100;
    it = 10;
    tau =0.01; % with tau = 0.01 ~8 seconds, no fix negative values
    ts = 0:tau:tlim;
   % ntrace = 10;

%% simulation many many times    
rng(1)
specL = 256: -16:32;
L = length(specL);

destiny =zeros(L, S,it);
% destinycode =  zeros();
 P = 256; 
tic   

parfor i = 1: it
% initial metacommunity
dest_temp =zeros(L, S);
   P0 = 256;    
   n0 = zeros(P0,S);
        for s = 1:5
            n0(:, s) = binornd(1, 0.5, P0, 1) .* round(k / sA(s)) ; 
        end
   XY = landscape256;

for l = 1:length(specL)
        P = specL (l);  
    % random habitat loss
        ind = sort(randperm(P0, P)); % index of remaining patches
        P0 = P;
            XY = XY(ind,:);
        distance = squareform( pdist(XY));
         n0 = n0(ind, :);
    % Simulation
         [x, note] = Multi_Logistictauleap(n0, tlim, tau, distance, k , sA, EA,cA,  tf1, tf2);
        % X0 = n0; dist =  distance ;
          n0 = x( :, :, end);
    % record the destiny    
     dest_temp(l, :) =   sum(x( :, :, end), 1) > 1;
     %   destinycode( m,l) =sum(all(destiny > 0, 2)) ;
end % l

   destiny(:, :, i) = dest_temp;
end % i
 toc

 destinycode =sum(destiny, 3);
%% show destiny

%% 
figure
 invbone = flip(bone);
imagesc(destinycode); colormap(invbone)
xticks( [1:1: 5])
xticklabels( num2cellstr(specM))
yticks( [1:1: 15])
yticklabels(specL)
colorbar
xlabel('Body size');
ylabel('Habitat amount (# of patches)')
title(str1)