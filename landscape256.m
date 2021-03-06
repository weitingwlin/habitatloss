% creating a fractal designed landscape with 64 patches
function XY = landscape256
XY = zeros(256, 2);
for n = 0:3
      p4 = n *64 + 1;
          XY(p4, :) = de2bi(n,2) * 20;
        for s = 0:3
                p3 = p4 + s *16;
                XY(p3, :) =   XY(p4, :) +  de2bi(s,2) * 8;
                for r = 0:3
                        p2 =p3 +  r * 4 ;
                        XY( p2, :) = XY(p3, :) + de2bi(r,2) * 3;
                        for q =0:3
                                p1 =p2 +  q ;
                                XY( p1, :) = XY(p2, :) + de2bi(q,2) ;
                        end
                end
        end
end

% demo
% myplot(XY(:,1), XY(:,2));
