%% Spatial explicit model for testing the relationship between body size and sensitivity to habitat loss
clear
clc
%%  landscape parameters
% k = 10; % local community size

k = 5; % local community size
XY = landscape256;

%% Species parameters    
    sB = 0.8; % sA =1; sB is the relative body size
    EA = 0.3; EB = EA; % emigration rate   
    cA = 1;    cB = cA/sB^2; % dispersal kernel, small number means long distance
    tf1 = 0.5;
    tf2 = 1;
    bBA = 1/sB^tf1; % increase pressure on the small species
    bAB = 1*sB^tf2; % reduced pressur on the big species

 %% Simulation parameters
    tlim = 300;
    it = 100;
    tau =0.05;
    ts = 0:tau:tlim;
%%        Ea    c      bBA = 1/sB;

%% simulation many many times    
rng(1)
destiny =zeros(it, 2);
tic
%for s = 1:9
%    EA = simsEC(s, 1)
 %  EB = EA;
 %   cA = simsEC(s,2)
 %   bBA = simsEC(s,3)
    
for l = 0%: 6
        loss = l * 32;
        P = 256 - loss;
        parfor i = 1:it
    % random habitat loss
        ind = sort(randperm(256, P)); % index of remaining patches
            XY = landscape256;
            XY = XY(ind,:);
        distance = squareform( pdist(XY)); 
        n0 = repmat(round([k/2  k/sB/2]), P, 1); 
    % Simulation
        [x, note] = LVtauleap(n0, tlim,tau, distance, k , sB, EA, EB, cA, cB, bAB, bBA);
    % record the destiny    
        destiny(i,:) = sum(x( :, :, end),1);
        end     
        destinycode(l+1,:) =[sum(all(destiny > 0, 2)), ...
                    sum( all([destiny(:,1) > 0   destiny(:,2) == 0], 2)),...
                    sum( all([destiny(:,2) > 0   destiny(:,1) == 0], 2)),...
                    sum(all(destiny == 0, 2))] 
end

 toc
 str1 = para2str( EA, EB, cA, cB, tf1, tf2);
 %str{s} = para2str(P, k, EA, EB, cA, cB);
 %str2{s} =  para2str(bAB, bBA, sB);
% str3{s} = para2str(tlim);
 %descode{s} = destinycode;
 %save sims descode str str2 % str3
%end
%% show destiny
%s=6
%str1 = str{s}
% destinycode = descode{s}
simlost = [0:32: 32*6 ];
figure
mysubplot(5, 1, [1:4])
    myplot(simlost, sum(destinycode(:, [1 2]), 2), 'B', 3, [2 1]);
    myplot(simlost, sum(destinycode(:, [1 3]), 2), 'B', 4, [3 1]);
    myplot(simlost, destinycode(:,2), 'B', 3, [2 2]);
    myplot(simlost, destinycode(:,3), 'B', 4, [3 2]);
    myplot(simlost, destinycode(:,1), 'B', 1);
    axis([0 32*6 0 it])
mysubplot(5, 1, 5)
    axis([0 32*6 0 it]); box off; axis off
    mytext(0, 10, str1, 8, 1)
  %  mytext(0, 25, str2, 8, 1)   
   %mytext(0, 0, str3, 8, 1)
