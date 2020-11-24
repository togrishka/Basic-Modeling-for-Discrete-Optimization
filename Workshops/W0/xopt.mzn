var 0..10: x;
%constraint x mod 4 = 0;

% working in gecode, not working in or-tools

var int: y;
constraint y * 4 = x;

solve minimize (x-7)^2;