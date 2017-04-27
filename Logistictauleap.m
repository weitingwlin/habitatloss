function [X, note] = Logistictauleap(X0, tlim, tau, dist, k , sA, EA, cA, tf1)
%% set parameters
if isempty(k)
k = 4; % effect of B on A
end
% r = b1-d1
 r = 1 * sA^tf1; 
 d1 = 0.1;
 b1 = d1 + r;
 % k = r/(d2-b2);
 b2 = 0.1;
% k = 4;
 kn = k /sA;
 d2 = (r + kn * b2)/kn;
 % dispersal kernal
   dispA = disp_incidence(dist, cA);
%%
note = [];
fixnegative = 0;
%% process
% process (per patch)
v = [];
v(1,:) =  [1  ];  % birth of species A
v(2,:) = [-1 ];  % death of species A
v(3,:) = [-1  ]; % Emigration of species A
v(4,:)= [0  ]; % a pseudo-event: maintain extinct
nv = 3; % number of event
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
          temp = [b1*nA + b2*nA^2, ...
                     d1*nA + d2*nA^2, ...  
                     EA * nA,...
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
            event = 4; patch = 1; % nothing happen
        end
     % 4. update state                                       
         temp= X(:, :, t); % current state
         temp(patch, :) = temp(patch, :) + v(event, :); % Updating the state.
         % if the event is dispersal, we also update the state of the
         % detination site
         if ~isempty(find(event == 3))
                l3 = find(event ==3) ;
             for p = 1:length(l3) 
                    dest_patch = datasample( 1:P, 1, 'weight', dispA(patch(l3(p)), :) ); % chose a destination patch
                    temp(dest_patch, : ) = temp(dest_patch, :) - v(3,:);  % add immigrant
             end
         end
    % 5. correction for negative population.
        if ~isempty(find(temp < 0))
             temp(temp<0) = 0; % avoid negative values
             fixnegative =   fixnegative + length(find(temp<0));
        end
      % update
        X(:, :, t + 1) = temp;
end
%%
note.fixnegative =fixnegative;

