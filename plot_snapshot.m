function h = plot_snapshot(A, B, XY)
%figure
    indA = find(A);
    scatter(XY(indA,1), XY(indA,2), A(indA)*5, ...
           'MarkerFaceColor', mycolor(3),'MarkerEdgeColor', mycolor(3)); hold on
    indB = find(B);
    scatter(XY(indB,1)+0.2, XY(indB,2), B(indB)*5, ...
           'MarkerFaceColor', mycolor(4),'MarkerEdgeColor', mycolor(4)); 
       axis([-1 13 -1 13])
   % title( {str{:}, [str2{:}, str3]})   