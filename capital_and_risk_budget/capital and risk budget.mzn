% 2. Capital and Risk budget
% determine project order considering its original optimal risk timing
%include pre-formulated algorithm to assist in solving.
include "alldifferent.mzn";

%number of projects and project data
int: n_p;
set of int: PROJ = 1..n_p;
array[1..n_p] of string: proj_names;
array[1..n_p] of int: proj_local_optimal_years;
int: budget_constraint;

%delivery year data
%set of int: years;  % set of years that the project can occur in
int: n_y; %number of years
array[1..n_y] of int: years;

% cumulative net benefit for each project, lets assume we have all the money to deliver the projects
array[PROJ,1..n_y] of int: cumul_net_benefit;

% NPC of individual proj cost for each project if delivered in that year
array[PROJ,1..n_y] of int: ind_proj_cost;


%solution vector
%delivery year for each project
array[PROJ] of var int: d; %the delivery year of each project

%generic Constraints - each project has to be delivered within the planning horizon
constraint forall(i in PROJ)(d[i] >= 1);
constraint forall(i in PROJ)(d[i] <= n_y);

%simplified budget constraint
% the sum(NPC) of the project budgets will be less than the budget constraint
constraint sum(i in PROJ)(ind_proj_cost[i, d[i]]) < budget_constraint;

%Limit the number of the Projects
%count = the number of projects deliveredin the final year of the planning horizon at a cost of $0 (eg it is not done)
var int:  count = sum([1| i in PROJ where d[i] = n_y]);
%constraint count = 3;

%Portfolio specific constraints
%constraint d[1] = 2; %project one must be done in 2022
%all difference constraint - all projects must be delivered in a different year
%constraint alldifferent(d);
%project 5 must be done less than year 15
%constraint d[5] <= 15;


%objective function
%maximise the cumulative sum of the net benefits
var int: objective = sum(i in PROJ where d[i] != n_y)(cumul_net_benefit[i,d[i]]); %this is using only projects that are delivered.

solve maximize objective;

output ["project " ++ show(proj_names[i]) ++"\t" ++
        "initial local optimal year = " ++ show(proj_local_optimal_years[i]) ++
        " now with delivery year = " ++ show(years[d[i]]) ++
        " with objective function = " ++ show(objective) ++
        " and contribution (%) = " ++ show((100*(cumul_net_benefit[i,d[i]])/objective)*(ind_proj_cost[i, d[i]]/(ind_proj_cost[i, d[i]] + 0.00000000001))) ++ ";\n"
        | i in PROJ];
