%Portfolio Optimisation - labour budget
%optimise a list of projects such that the max risk reduction is achieved within the labour budget.
int: n; % number of projects
set of int: OBJ = 1..n;

int: capacity; %max labour hours to allocate
array[OBJ] of int: risk; %risk reduction $ for each project

array[OBJ] of int: cost;%labour hour cost of each project

array[OBJ] of var int: x; % how many of each project

%constraints
%1. you can only select one project
constraint forall(i in OBJ)(x[i] < 2);
constraint forall(i in OBJ)(x[i] >= 0);

%2.Suite of projects must be less than the labour budget
var int: total_cost = sum(i in OBJ)(cost[i] * x[i]);
constraint total_cost <= capacity;

%objective function
var int: objective = sum(i in OBJ)(risk[i] * x[i]);

solve maximize objective;
output ["x = ", show(x), " with risk reduction = ", show(objective), " and labour cost = ", show(total_cost), "\n"];
