\input eplain
\enablehyperlinks
@*Introduction. This is a solution to a problem called {\bf Snake Charmer}
from the 2017 Australian Informatics Olympiad.

The problem involves a snake, which starts at the origin facing north.
It can only move in two different ways: {\tt R}, which causes it to
turn right then move forward by one unit, and {\tt L}, which causes
it to turn left and then move forward by one unit. The goal is to reach
a given point $(x,y)$ in the least number of moves.

For more background, have a look at the \href{https://orac2.info/problem/aio17snake/}{{\bf problem statement}}.
@c
@<Include files@>@;
@<Global variables@>;
@<Function to output the answer@>@;
int main(void)
{
    @<Open the input and output files@>;
    @<Read the input data@>;
    calculate();
    @<Close the input and output files@>;
    return 0;
}
@*The solution. There is a nice recusive solution to this problem.

The simplest case is when $(x,y)=(1,0)$ or $(x,y)=(-1,0)$; in that case a
{\tt R} or {\tt L} will be sufficient to reach the square. If we have
not reached the target square, we just rotate the board so that we
take the snake's current position to be the origin, and then repeat
the process.

This means that we just focus on the $x$-coordinate; if we are facing
north and our target is on the left make an {\tt L} move; otherwise,
make an {\tt R} move.
Assume that we have two local variables, $x$ and $y$, that together
hold the coordinates of our target square.
@<Function to output the answer@>=
void calculate(void)
{
    if (x < 0) {
	fprintf(out_file, "L");
	if (x == -1 && y == 0)
	    return;
	x++;
	@<Rotate plane clockwise@>@;
    } else {
	fprintf(out_file, "R");
	if (x == 1 && y == 0)
	    return;
	x--;
	@<Rotate plane anticlockwise@>@;
    }
    calculate();
}
@ Before making the recursive call, we must first rotate the 
board. A bit of mathematics will tell us that a point
$(x,y)$ rotated $90$ degrees anticlockwise will map onto the point
$(-y,x)$, and the same point rotate $90$ degrees clockwise will
map onto the point $(y,-x)$.
@<Rotate plane anticlockwise@>=
int tmp;
tmp = x;
x = -y;
y = tmp;
@ 
@<Rotate plane clockwise@>=
int tmp;
tmp = x;
x = y;
y = -tmp;
@ We will need two global variables, $x$ and $y$, to hold our
target coordinates.
@<Global variables@>=
int x, y;
@*Input/output.
We will need some file pointers to point to the input and output
files; let's declare them.
@<Global variables@>=
FILE *in_file, *out_file;
@ Opening the input and output files is a simple call to |fopen|.
@<Open...@>=
in_file = fopen("snakein.txt", "r");
out_file = fopen("snakeout.txt", "w");
@ The input data is extremely simple (just two numbers), so reading
the it from the input file isn't too difficult; a single call to |fscanf|
suffices.
@<Read...@>=
fscanf(in_file, "%d %d\n", &x, &y);
@
@<Close...@>=
fclose(in_file);
fclose(out_file);
@*Include files. We have only used C standard libray I/O functions, so we
only need to include the |stdio.h| header file.
@<Include files@>=
#include <stdio.h>
@*Index.
