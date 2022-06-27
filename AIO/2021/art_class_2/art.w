@*Art Class II. This is a problem from the
2021 Australian Mathematical Olympiad.

The problem consists of determining the area
of the smallest poster that will cover a
certain number of holes in the wall.
Holes are specified in terms of their horizontal
distance from the left edge of the wall
and the vertical distance from the bottom edge
of the wall.

The problem statement refers to the number of
holes as |N|, with $x_i$ and $y_i$ being
the horizontal and vertical coordinates of
the $i^{\hbox{th}}$ hole.

@ Here is our main program.
@c
@<Include files@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files and get input data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close files@>;
  return 0;
}

@ Calculating the answer is a matter of
looking at the horizontal and vertical
extremes.
Any poster with width equal to the range
of the holes' horizontal distances from the
left side of the wall and height equal to
the range of the holes' vertical distances
from the bottom edge of the wall is guaranteed
to cover all the holes.
This is also the smallest possible poster
because it's edges just touch the holes at the
extremes.
@ Before we calculate the answer, we will
need the input data stored in variables.
The variable |N| will be the number of holes,
the array |x| will be the set of horizontal
distance values, and the array |y| will be
the set of vertical distance values.
That way, we can easily find the minimum
and maximum of each array.

To avoid dynamic memory allocation, we
statically allocate the |x| and |y|
arrays to be the maximum size specified
by the problem statement.
The problem statement states that the
maximum value of |N| is 100000.
@d MAX_HOLES 100000
@<Local variables@>=
int x[MAX_HOLES];
int y[MAX_HOLES];
int N;

@ We also need some local variables for
the ranges of the |x| and |y| arrays.
These two values multiplied together will
be our answer.
@<Local variables@>=
int xrange;
int yrange;
int answer;

@
@<Calculate the answer@>=
@<Find |xrange|@>;
@<Find |yrange|@>;
answer = xrange*yrange;

@ Finding the ranges is a simple matter
of finding the minumum and maximum
values.
The algorithm for this is not complex.
We can find both values at the same time
with a single loop to save time.
@<Find |xrange|@>=
int xmin, xmax; /* Variables to hold min and max */
xmax = 0;
xmin = x[0];
for (int i = 0; i < N; i++) {
  if (x[i] < xmin)
    xmin = x[i];
  if (x[i] > xmax)
    xmax = x[i];
}
xrange = xmax-xmin;

@ The algorithm is the same for the |y| array.
@<Find |yrange|@>=
int ymin, ymax; /* Variables to hold min and max */
ymax = 0;
ymin = y[0];
for (int i = 0; i < N; i++) {
  if (y[i] < ymin)
    ymin = y[i];
  if (y[i] > ymax)
    ymax = y[i];
}
yrange = ymax-ymin;

@*Input and output.
The first thing we need to do is to define some
constants for the input and output file names
so that we can open them.
We open them using |fopen| and do some
basic error checking that should never be needed
(if we have the right file names, of course).

We also need some variables to hold our
pointers to the files.
@d IN_FILE "artin.txt"
@d OUT_FILE "artout.txt"
@<Local variables@>=
FILE *in_file, *out_file;
@
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
if (in_file == NULL) {
  @<Report error opening input file and exit@>
}
out_file = fopen(OUT_FILE, "w");
if (out_file == NULL) {
  @<Report error opening output file and exit@>
}
@<Read input data@>;

@
@<Report error opening input...@>=
fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
exit(EXIT_FAILURE);

@
@<Report error opening output...@>=
fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
exit(EXIT_FAILURE);

@ The problem statement tells us exactly how
the input data is formatted.
The first line contains a single integer, |N|.
The next |N| lines of input contain two integers,
which are $x_i$ and $y_i$, separated by a single space.
As we can assume the input data is formatted correctly,
we can use |fscanf|.
@<Read input data@>=
fscanf(in_file, "%d\n", &N);
for (int i = 0; i < N; i++)
  fscanf(in_file, "%d %d\n", &x[i], &y[i])

@ Writing the answer to the output file is
a simple call to |fprintf|.
@<Write the answer...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>