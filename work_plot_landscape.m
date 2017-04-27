
%% plot landscape
 myplot(XY(:,1), XY(:,2));
 for p = 1 : length( XY(:, 1) )
     mytext(XY(p,1), XY(p,2), num2str(p), 12,1);
 end
%% gray
 myplot(XY(:,1), XY(:,2), 'S', 7);
 box off
 axis off
 
 %%
 X = 1:32;Y=zeros(1,32);
   demodispA = disp_incidence(squareform(pdist([X;Y]')), cA);
   demodispB = disp_incidence(squareform(pdist([X;Y]')), cB);
   myplot(X(2:end)-1, demodispA(2:end, 1), 'L', 3); hold on
    myplot(X(2:end)-1, demodispB(2:end, 1), 'L', 4); 