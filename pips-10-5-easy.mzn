% Solve NYTimes Pips puzzle, Oct 5, 2025, easy
% Ken Shirriff, righto.com
include "alldifferent.mzn";
include "all_equal.mzn";
include "ide/vis.mzn";

int: NDOMINO = 4; % Number of dominoes in the puzzle
% Spots on each domino
spots = [|5,1| 1,4| 4,2| 1,3|];

int: W = 3; % Width of the grid in this puzzle
int: H = 3; % Height of the grid in this puzzle
% The grid of allowed domino locations
grid = [|
1,1,0|
1,1,1|
1,1,1|];

% The constraints for this puzzle [y,x]
constraint pips[1,1] + pips[2,1] == 8;
constraint pips[2,3] < 5;
constraint all_equal([pips[3,1], pips[3,2], pips[3,3]]);

set of int: DOMINO = 1..NDOMINO; % Dominoes are numbered 1 to NDOMINO
set of int: HALF = 1..2; % The domino half is 1 or 2
set of int: xcoord = 1..W; % Coordinate into the grid
set of int: ycoord = 1..H;
array[1..H,1..W] of 0..1: grid; % The grid defining where dominoes can go
array[DOMINO, HALF] of int: spots; % The number of spots on each half of each domino

% Variable that must be solved to find a solution
array[DOMINO, HALF] of var xcoord: x; % X coordinate of each domino half
array[DOMINO, HALF] of var ycoord: y; % Y coordinate of each domino half
array[1..H,1..W] of var 0..6: pips; % The number of pips (0 to 6) at each location.
array[1..H,1..W] of var 0..NDOMINO: dominogrid; % The domino sequence number at each location

% General rules for the puzzle...

% The two halves of a domino must be in adjacent cells, i.e. x or y coords differ by 1
constraint forall(i in DOMINO) (abs(x[i, 1] - x[i, 2]) + abs(y[i, 1] - y[i, 2]) == 1);

% The dominoes must be placed where grid allows (i.e. has the value 1)
constraint forall(i in 1..H, j in 1..W) (dominogrid[i, j] == 0 <-> grid[i, j] == 0);

% Assign the values in pips with the associated domino's entry in spots
constraint forall(i in DOMINO, j in HALF) (pips[y[i,j], x[i, j]] == spots[i, j]);

% Don't put pips where there is no domino
constraint forall(i in 1..H, j in 1..W) (grid[i, j] == 0 -> pips[i, j] == 0);

% Put the domino's number in dominogrid
constraint forall(i in DOMINO, j in HALF) (dominogrid[y[i,j], x[i, j]] == i);

% Information for the HTML display

any: initial_data = (w: W, h: H, grid: grid, img: "pips-10-5-easy.jpg", xmargin: 187, ymargin: 23);
any: solution_data = ( pips: pips, dominogrid: dominogrid);
output :: vis_server("pips.html", initial_data) solution_data;

