%% plot landscape
 myplot(XY(:,1), XY(:,2));
 for p = 1 : length( XY(:, 1) )
     mytext(XY(p,1), XY(p,2), num2str(p), 12,1);
 end
 
 %%
 X = 1:0.1: 32;Y=zeros(1,length(X));
   demodispA = disp_incidence(squareform(pdist([X;Y]')), cA);
   demodispB = disp_incidence(squareform(pdist([X;Y]')), cB);
   myplot(X(2:end)-1, demodispA(2:end, 1), 'L', 3); hold on
    myplot(X(2:end)-1, demodispB(2:end, 1), 'L', 4); 
%%
figure
 X = 1:0.1: 16;Y=zeros(1,length(X));
csim = [1 0.7 0.5 0.3 0.1 0.03]
for c = 1: 5
   demodispA = disp_incidence(squareform(pdist([X;Y]')), csim(c));
   myplot(X(2:end)-1, demodispA(2:end, 1), 'L', c + 3); hold on
end