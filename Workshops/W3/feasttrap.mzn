% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};

array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;

% Decision variables
var int: obj;
constraint obj = sum(d in dish)(value[d])
                + sum(i in 1..len-1)(taste[dish[i]] != taste[dish[i+1]])
                + sum(i in 1..len-1)(temp[dish[i]] != temp[dish[i+1]])
                + sum(i in 1..len-1)(heavy[dish[i]] != heavy[dish[i+1]]);
                         
% Constraints
include "alldifferent.mzn";
constraint alldifferent(dish);

include "regular.mzn";
constraint regular([taste[dish[i]] | i in COURSE], 7, 6, d, 1, {5});
array[1..7,TASTE] of 0..7: d =
     [| 0,0,4,0,0,0
      | 0,0,0,5,0,7
      | 0,0,0,0,6,7
      | 2,3,0,5,6,7
      | 0,3,4,0,0,7
      | 2,3,4,5,0,7
      | 2,3,4,5,6,0 |];

% all these can be replaced by regular global constraint
%constraint forall(i in 1..(len - 1))(taste[dish[i]] != taste[dish[i+1]]); % No flavor twice in a row
%constraint taste[dish[1]] = salty; %salty first
%constraint taste[dish[len]] = sweet; %sweet last
%constraint forall(i in 1..len-1)(taste[dish[i]] = spicy -> taste[dish[i+1]] in {bland, sweet}); %salty -> bland or sweet
%constraint forall(i in 1..len-1)(taste[dish[i]] = sour -> taste[dish[i+1]] in {bland, umame}); % sour -> bland or umame
%constraint forall(i in 1..len-1)(taste[dish[i]] = sweet -> (taste[dish[i+1]] != spicy /\ taste[dish[i+1]] != umame)); % sweet -> not spicy and not umame

constraint regular([temp[dish[i]] | i in COURSE], 2, 3, td, 1, {1,2});
array[1..2,TEMP] of 0..2: td =
     [| 2,1,1
      | 2,0,1 |];
%constraint forall(i in 1..len-1)
%                  ((temp[dish[i]] = hot ->
%                  forall(j in i+1..len)
%                        (temp[dish[j]] = cold -> exists(k in i+1..j-1)(temp[dish[k]] = warm)))); % warm dish between hot and cold

constraint forall(i in 1..len-2)(heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]); % no two heavy dishes in a row

% Solve
output ["DISH = ", show(dish), "\n",
        "obj = ", show(obj)];

solve maximize obj