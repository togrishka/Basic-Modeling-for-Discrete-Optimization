var 1..9: T;
var 0..9: R;
var 0..9: U;
var 0..9: M;
var 1..9: P;
var 1..9: B;
var 0..9: I;
var 0..9: D;
var 0..9: E;
var 0..9: N;

constraint 10000*T + 1000*R + 100*U + 10*M + P + 10000*B + 1000*I + 100*D + 10*E + N = 99999;

include "alldifferent.mzn";
constraint alldifferent([T,R,U,M,P,B,I,D,E,N]);

solve minimize(10000*P + 1000*U + 100*T + 10*I + N);
output ["\(10000*T + 1000*R + 100*U + 10*M + P) + \(10000*B + 1000*I + 100*D + 10*E + N) = \(10000*P + 1000*U + 100*T + 10*I + N)"]
%solve satisfy;
