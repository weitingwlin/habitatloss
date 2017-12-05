function [X, note] = Multi_Logistictauleap(X0, tlim, tau, dist, k , sA, EA, cA, tf1, tf2)
%% set parameters
[ P, S ] = size( X0 ); % number of patches, number of species
if isempty(k)
k = 4; % carrying capacity
end
 r = 1 .* sA .^ tf1; 
 cA = 1 ./ sA .^ tf2;    
 d1 = repmat(0.1, 1, S); % death 
 b1 = d1 + r; % birth so b1-d1 = r; first-order growth rate
 b2 =repmat(0.1, 1, S);
 kn = k ./sA; % k in terms of number
 d2 = r./ kn +  b2; % so b2-d2 = r/kn
 % dispersal kernal
 dispA = zeros(P, P, S);
 for i = 1:S
  dispA(:,:, i) = disp_incidence(dist, cA(i));
 end
%%
note = [];
fixnegative = 0;
%% process
% process (per patch)
nv = 3 * S; % number of event per patch
v = zeros(nv+1, S);
for s = 1: S
   v((s-1)*3 + 1, s) =  1  ;  % birth of species A
   v((s-1)*3 + 2, s) = -1 ;  % death of species A
   v((s-1)*3 + 3, s) = -1  ; % Emigration of species A
end
% last line is a pseudo-event: maintain extinct

%%
 
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
        for s = 1:S
            nA = X(p, s, t);
            temp = [b1(s)*nA + b2(s)*nA^2, ...
                        d1(s)*nA + d2(s)*nA^2, ...  
                        EA * nA,...
                        ]; 
              rates = [rates, temp]; 
        end % s      
    end % p
        a0 = sum(rates, 2); % the rate that "any" event happens
    
    % 2. number of event
        events = random( 'Poisson', a0 * tau );
     
    % 3. witch events
        if events > 0
                eventID = datasample(1:nv*P, events, 'weight', rates);  
           % eventID = min(find(rand < cumsum(rates/a0))); % like the above but zero-prove
                for j = 1:events
                [event(j), patch(j)] = find( L == eventID(j) ); % which of the 6 "events" in which "patch"
                end
     % 4. update state
                for j = 1: events
                temp= X(:, :, t); % current state
                temp(patch(j), :) = temp(patch(j), :) + v(event(j), :); % Updating the state.
         % if the event is dispersal, we also update the state of the
         % detination site
                if mod(event(j), 3) == 0
                     s = ceil(event(j) / 3); % which species
                    dest_patch = datasample( 1:P, 1, 'weight', dispA(patch(j), :, s) ); % chose a destination patch
                    temp(dest_patch, : ) = temp(dest_patch, :) - v(event(j),:);  % add immigrant
                end
                end % for j
    % 5. correction for negative population.
                if ~isempty(find(temp < 0))
                    temp(temp<0) = 0; % avoid negative values
                    fixnegative =   fixnegative + length(find(temp<0));
                end
      % update
                X(:, :, t + 1) = temp;
        else
         %   t(point + 1) = tlim; % end the simulation
           % event = nv+1; patch = 1; % nothing happen
              X(:, :, t + 1) = X(:, :, t );
        end % if
end
%%
note.fixnegative =fixnegative;

