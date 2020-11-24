% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy;
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

% SET VERSION IS VERY SLOW FOR LARGE NUMBER OF WARRIORS AND PROBABLY STOPS BEFORE FINDING THE BEST SOLUTION
% decision variables
%array[1..u] of var WARRIOR: raid;

% constraints
%constraint card(raid) >= l /\ card(raid) <= u;
%constraint not(dummy in raid);
%constraint sum(i, j in raid where i < j)( hates[clan[i],clan[j]] ) <= m;

%var int: totalStrength;
%constraint totalStrength = sum(i in raid) (strength[i]);

%solve maximize totalStrength;

array[1..u] of var WARRIOR: raid;

constraint forall(i in 1..l)(raid[i] > dummy);
constraint forall(i in 1..u-1)(raid[i] >= (raid[i] != dummy) + raid[i+1]);

var int: totalStrength = sum(i in raid)(strength[i]);
constraint sum(i, j in raid where i < j)(hates[clan[i],clan[j]]) <= m;

solve maximize totalStrength;

output ["raid = {"] ++ [if fix(raid[i]) != dummy then show(raid[i])
                        ++ if i < u /\ fix(raid[i+1]) != dummy then ", " else "" endif
                     else "" endif | i in 1..u ] ++ ["};\n"] ++
                     ["obj = \(totalStrength);\n"];