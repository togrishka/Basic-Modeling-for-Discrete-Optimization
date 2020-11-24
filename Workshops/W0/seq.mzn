int: d;
set of int: INDEX = 1..d;
array[INDEX] of var 0..3: x;
constraint x[1] = 0;
constraint x[d] = 3;
constraint forall(i in 1..d-1)(x[i]+x[i+1] <= 3);
constraint forall(i in INDEX where i mod 3 = 0)(x[i] >= 2);

solve maximize sum(x);

output ["\(sum(x)) = \(x)"];