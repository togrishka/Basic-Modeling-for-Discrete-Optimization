% composition problem
int: n = 14;
set of int: NOTE = 1..n;
set of int: DIFF = 1..n-1;

set of int: POS_NOTE = 1..n;
set of int: POS_DIFF = 1..n-1;

array[POS_NOTE] of var NOTE: order;
array[POS_DIFF] of var DIFF: diffs;

include "alldifferent.mzn";
constraint alldifferent(diffs);
constraint alldifferent(order);

constraint forall(i in POS_DIFF)(diffs[i] = abs(order[i] - order[i+1]));

solve satisfy;

int: d = ceil(ln(n+1) / ln(10));
string: spaces = concat([ " " | i in 1..d]);
output [show_int(d,order[i]) ++ spaces | i in POS_NOTE]
        ++ ["\n", spaces]
        ++ [show_int(d,diffs[i]) ++ spaces | i in POS_DIFF]

%output ["order = ",show_int(d, order),";\n"]
%++ ["diffs = \t ",show(diffs),"\n"]