for l = 0:6
    loss = l * 32
    P = 64 - loss;
    % random habitat loss
        ind = sort(randperm(64, 64-loss));
       XY = landscape64;
        XY = XY(ind,:);
        figure
         myplot(XY(:,1), XY(:,2), 'S', 7); axis([-1 13 -1 13])
         axis off
         title(['P = ' num2str(P)])
end