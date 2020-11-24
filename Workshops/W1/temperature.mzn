array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};

array[HOUR] of var CHOICE: choice;
array[HOUR0] of var 25..30: temp;
array[CHOICE] of int: adjustment = [+1,+4,-2,-5,0];
array[CHOICE] of int: cost = [1,5,3,9,0];

constraint temp[0] = start;
constraint forall(i in HOUR)(temp[i] = (temp[i-1] + readings[i]) div 2 +  adjustment[choice[i]] );
var int: costs = sum(i in HOUR)(cost[choice[i]]);
solve minimize costs;

output["temp = \(temp[HOUR0])\nchoice = \(choice)\ncost = \(costs)"];
