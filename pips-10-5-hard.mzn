% Solve NYTimes Pips puzzle, Oct 5, 2025, hard
% Ken Shirriff, righto.com
include "alldifferent.mzn";
include "all_equal.mzn";
include "ide/vis.mzn";

int: NDOMINO = 9; % Number of dominoes in the puzzle
% Spots on each domino
spots = [|3,6| 3,4| 2,3| 4,0| 5,4| 3,3 | 2,5| 4,4| 5,3|];

int: W = 6; % Width of the grid in this puzzle
int: H = 5; % Height of the grid in this puzzle
% The grid of allowed domino locations
grid = [|
0,1,1,1,1,0|
0,1,1,1,1,0|
1,1,0,0,1,1|
0,1,0,0,1,0|
0,1,1,1,1,0|];

% The constraints for this puzzle [y,x]
constraint all_equal([pips[1,2], pips[1,3], pips[2,2], pips[2,3]]);
constraint pips[1,4] + pips[1,5] + pips[2,5] == 9;
constraint pips[3,2] + pips[4,2] < 7;
constraint pips[3,5] + pips[4,5] == 8;
constraint pips[3,6] > 2;
constraint pips[5,2] < 6;
constraint pips[5,3] + pips[5,4] + pips[5,5] == 8;

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

any: initial_data = (w: W, h: H, grid: grid, img: "pips-10-5-hard.jpg", xmargin: 77, ymargin: 37);
any: solution_data = ( pips: pips, dominogrid: dominogrid);
output :: vis_server("pips.html", initial_data) solution_data;

