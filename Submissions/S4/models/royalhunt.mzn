int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

% Decision vars
array[COURT] of var HORSE union {0}: rider2horse;
array[HORSE] of var COURT union {0}: horse2rider;

var int: obj = sum(i in COURT where rider2horse[i] > 0)(enjoy[i, rider2horse[i]]) - penalty;
                         
% Constraints
include "alldifferent_except_0.mzn";
constraint (alldifferent_except_0(rider2horse));

% The emperor enjoys his ride most
constraint forall(i in 2..n where rider2horse[i] != 0) (enjoy[emperor, rider2horse[emperor]] > enjoy[i, rider2horse[i]]);

% Court is riding as many horses as possible
constraint sum(i in COURT)(rider2horse[i] > 0) = min(n, m);

% Channeling constraint
constraint forall(i in COURT, j in HORSE)(rider2horse[i] = j <-> horse2rider[j] = i);

% If a court member holds a higher rank than another, then either 
% (a) the beauty of their horse can be no less than that assigned to the other, 
% (b) the lower rank member does not ride, or
% (c) both court members do not ride. <- redundand rule
% constraint forall(i, j in COURT where rider2horse[i] != 0 /\ rider2horse[j] != 0)(rank[i] > rank[j] -> (beauty[rider2horse[i]] >= beauty[rider2horse[j]] \/ rider2horse[j] = 0));
constraint forall(i, j in COURT where rank[i] < rank[j] /\ rider2horse[i] != 0 /\ rider2horse[j] != 0) (
    rider2horse[i] = 0 \/ (rider2horse[i] = 0 /\ rider2horse[j] = 0) \/ beauty[rider2horse[i]] <= beauty[rider2horse[j]]);

% Lower rank cannot ride if higher rank doesn't ride
constraint forall(i, j in COURT where rank[i] < rank[j])(rider2horse[j] = 0 -> rider2horse[i] = 0);

% If a horse is faster than another then either
% (a) the rider of the faster horse has no less riding ability than that of the slower horse, 
% (b) the faster horse has no rider
% (c) both horses have no rider. <- redundand rule
% -- this constraint can be violated for penalty
%var int: penalty = sum(i, j in HORSE where horse2rider[j] != 0 /\ horse2rider[i] != 0)(bool2int(not((speed[i] > speed[j]) -> (ability[horse2rider[i]] >= ability[horse2rider[j]] \/ horse2rider[j] = 0)))) * 100;
var int: penalty = sum([1 | i, j in HORSE where speed[i] < speed[j] /\ horse2rider[j] != 0 /\
                       ((horse2rider[i] != 0 /\ ability[horse2rider[i]] > ability[horse2rider[j]]) \/ horse2rider[i] = 0)]) * 100;

% Riders have non-negative enjoyment
constraint forall(i in COURT)(rider2horse[i] > 0 -> enjoy[i, rider2horse[i]] >= 0);

% Solve
output ["horse = \(rider2horse);\nobj = \(obj);"];

solve maximize obj;
