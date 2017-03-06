%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
k = 10; % local community size

%% Species parameters    
    sB = 0.8; % sA =1; sB is the relative body size
    EA = 0.03;  EB = EA; % emigration rate   
    cA = 0.3;    cB = cA/sB^2; % dispersal kernel, small number means long distance
    bBA = 1/sB; % increase pressure on the small species
    bAB = 1*sB; % reduced pressur on the big species

 %% Simulation parameters
    tlim = 300;
    it = 100;
    trec =100;
    ts = (tlim - trec +1) : tlim;
   % ntrace = 10;

%% simulation many many times    
rng(1)
destiny =zeros(it, 2);
tic


for l = 0:5
    loss = l * 8
    P = 64 - loss;
for i = 1:it
    % random habitat loss
        ind = sort(randperm(64, 64-loss));
            XY = landscape64;
        XY = XY(ind,:);
        distance = squareform( pdist(XY)); 
        n0 = repmat(round([k/2  k/sB/2]), P, 1); 
    % Simulation
        % presimulation
        [t, x] = LVmetaGillespie4(n0, tlim, distance, k , sB, EA, EB, cA, cB, bAB, bBA);

    % record the destiny    
        destiny(i,:) = sum(x( :, :, end),1);
end
     
    destinycode(l+1,:) =[sum(all(destiny > 0, 2)), ...
                    sum( all([destiny(:,1) > 0   destiny(:,2) == 0], 2)),...
                    sum( all([destiny(:,2) > 0   destiny(:,1) == 0], 2)),...
                    sum(all(destiny == 0, 2))] 
end

 toc
 str = para2str(P,k, EA, EB, cA, cB)
 str2 =  para2str(bAB, bBA, sB)
 str3 = para2str(tlim)
 save sim5 destinycode str str2 str3
%% show destiny
simlost = [0:8: 40 ];
figure
mysubplot(5, 1, [1:4])
    myplot(simlost, sum(destinycode(:, [1 2]), 2), 'B', 3, [2 1]);
    myplot(simlost, sum(destinycode(:, [1 3]), 2), 'B', 4, [3 1]);
    myplot(simlost, destinycode(:,2), 'B', 3, [2 2]);
    myplot(simlost, destinycode(:,3), 'B', 4, [3 2]);
    myplot(simlost, destinycode(:,1), 'B', 1);
    axis([0 40 0 100])
mysubplot(5, 1, 5)
    axis([0 40 0 100]); box off; axis off
    mytext(0, 50, str, 8, 1)
    mytext(0, 25, str2, 8, 1)   
    mytext(0, 0, str3, 8, 1)
