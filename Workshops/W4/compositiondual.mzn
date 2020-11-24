% composition problem
int: n = 99;
set of int: NOTE = 1..n;
set of int: DIFF = 1..n-1;

set of int: POS_NOTE = 1..n;
set of int: POS_DIFF = 1..n-1;

array[NOTE] of var POS_NOTE: posn;
array[POS_NOTE] of var NOTE: order;
array[DIFF] of var POS_DIFF: dposn;
array[POS_DIFF] of var DIFF: diffs;


include "inverse.mzn";
constraint inverse(posn,order);

constraint forall(i in DIFF)(diffs[i] = abs(order[i] - order[i+1]));

constraint inverse(diffs,dposn);

constraint abs(posn[1] - posn[n]) = 1;
constraint dposn[n-1] = min(posn[1],posn[n]);

solve satisfy;

output ["order = ",show(order),";\n"]
++ ["diffs = ",show(diffs),";\n"]
++ ["posn  = ",show(posn),";\n"]
++ ["dposn = ",show(dposn),";\n"];
