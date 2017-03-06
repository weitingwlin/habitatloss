function [X, note] = LVtauleap(X0, tlim, tau, dist, k , sB, EA, EB, cA, cB, bAB, bBA)
note = [];
fixnegative = 0;
if nargin<10
bAB = 1; % effect of B on A
end
if nargin<11
bBA = 1;% effect of A on B
end
% 
%Default parameters: "otherwise identical species"

  dispA = disp_incidence(dist, cA);
  dispB = disp_incidence(dist, cB);
%% Use global parameters
rA = 1;  rB =1; sA = 1; 
      dA1 = 1;        bA1 = rA*sA + dA1;          dB1 = 1;         bB1 = rB*sB + dB1;
      dA2 = rA*sA*sA/k ;     bA2 = 0;  
      dA3 = rA*bAB*sA*sB/k ;     bA3 = 0;
      dB2 = rB*sB*sB/k ;       bB2 = 0;  
      dB3 = rB*bBA*sB*sA/k ;       bB3 = 0;
     
% process
% process (per patch)
v = [];
v(1,:) =  [1  0];  % birth of species A
v(2,:) = [-1 0];  % death of species A
v(3,:) = [0  1];
v(4,:)= [0  -1];
v(5,:) = [-1  0]; % Emigration of species A
v(6,:) = [0  -1];
v(7,:)= [0  0]; % a pseudo-event: maintain extinct
nv = 6; % number of event
%%
 [ P, S ] = size( X0 ); % number of patches, number of species
 points =tlim/tau;  % 
 X = zeros( P,S, points);
 X( :, :, 1 ) = X0; 
 %point = 1;     
 L = reshape( 1 : nv*P, nv, P ); % event locator, used later   
%%
for t = 1:points
    % 1. calculate rate of each event (for each patch)
          patch =[];event=[];
          rates = [];
    for p = 1:P    % calculate event rate for each patch
          nA = X(p, 1, t);
          nB = X(p, 2, t);
          temp = [bA1*nA + bA2*nA^2 + bA3*nA*nB, ...
                     dA1*nA + dA2*nA^2 + dA3*nA*nB, ...  
                     bB1*nB  + bB2*nB^2  + bB3*nA*nB, ...
                     dB1*nB  + dB2*nB^2  + dB3*nA*nB, ...  
                     EA * nA,...
                     EB * nB
                     ]; 
          rates = [rates, temp]; 
    end
        a0 = sum(rates, 2); % the rate that "any" event happens
    
    % 2. number of event
        events = random( 'Poisson', a0 * tau );
     
    % 3. witch events
        if a0 > 0
            eventID = datasample(1:nv*P, events, 'weight', rates);  
           % eventID = min(find(rand < cumsum(rates/a0))); % like the above but zero-prove
           for j = 1:events
             [event(j), patch(j)] = find( L == eventID(j) ); % which of the 6 "events" in which "patch"
           end
        else
         %   t(point + 1) = tlim; % end the simulation
            event = 7; patch = 1; % nothing happen
        end
     % 4. update state                                       
         temp= X(:, :, t);
         temp(patch, :) = temp(patch, :) + v(event, :); % Updating the state.
         % if the event is dispersal, we also update the state of the
         % setination site
         if ~isempty(find(event ==5))
                l5 = find(event ==5) ;
             for p = 1:length(l5) 
                    dest_patch = datasample( 1:P, 1, 'weight', dispA(patch(l5(p)), :) ); % chose a destination patch
                    temp(dest_patch, : ) = temp(dest_patch, :) - v(5,:);  % add immigrant
             end
         end
          if ~isempty(find(event ==6))
                l6 = find(event ==6) ;
             for p = 1:length(l6) 
                    dest_patch = datasample( 1:P, 1, 'weight', dispB(patch(l6(p)), :) ); % chose a destination patch
                    temp(dest_patch, : ) = temp(dest_patch, :) - v(6,:);  % add immigrant
             end
         end
    % 5. update the point counter.
        if ~isempty(find(temp<0))
             temp(temp<0) = 0; % avoid negative values
             fixnegative =   fixnegative + length(find(temp<0));
        end
        X(:, :, t+1) = temp;
end
%%
note.fixnegative =fixnegative;

