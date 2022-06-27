\input eplain
\enablehyperlinks
@ This is {\it Pirates}, a problem from the 2011 Australian Informatics Olympiad.

The problem is not easy to explain without a diagram, so it is perhaps
better to go to visit \href{https://https://orac2.info/problem/aio11pirates/}{{\bf here}}
to see the full problem statement.

The essence of the problem is that we are given an integer |L|,
the length of an island, an integer |X|, the distance of the
ship {\it Black Pearl} from the west point of the island, and an
integer |Y|, the distance of the ship {\it HMS Smallerout} from the west point of the island.
The island is assumed to have length, but no width.
All measurements are in nautical miles.

The problem is to determine the shortest path in nautical miles from
the {\it Black Pearl} to the {\it HMS Smallerout}.
There are only two ways: for the {\it Black Pearl} go around the west
end of the island, or to go around the east end of the island.

@
@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input file to get the input data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@ Let's tackle how to actually solve the problem first.
Since the width of the island is zero, it is simple to
calculate the distance between the ships.
For example, if |L=6|, |X=2|, and |Y=3|, we can see that
the Black Pearl is |2+3=5| nautical miles away if it goes
around the west side, and |(6-2)+(6-3)=7| nautical miles away
if it goes around the east side.
Thus the closer side is to go around the west side.
@<Calculate the...@>=
int west, east; /* The distancees from the west and east sides */
west = X + Y;
east = (L-X) + (L-Y);
answer = (west < east) ? west : east;

@ Now we just need to negotiate getting the input and output from
the specified files.
We define these constants for the file names.
@d IN_FILE "piratein.txt"
@d OUT_FILE "pirateout.txt"

@ We also need some variables to be references to the open files.
@<Local variables@>=
FILE *in_file, *out_file;

@ Usually it is good programming practice to check the following
two calls to |fopen| for |NULL|, but since this program is
opening files on the judges' computer, it isn't really our problem
if it fails.
@<Open the input...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@ While we're at it, we might as have the code for closing the files.
It's not a big deal, since the program termination will close the files
for us, but it's just good practice.
@<Close the input...@>=
fclose(in_file);
fclose(out_file);

@ Before we can read in the input data, we need variables to hold it in.
We convienently choose the same names as those in the problem statement.
Remember that |L| is the length of the island, and |X| and |Y| are the distances
from the west point of the island of the {\it Black Pearl} and
the {\it HMS Smallerout} respectively.
We also need a variable to hold the answer, which we will obviously call |answer|.
@<Local variables@>=
int L, X, Y;
int answer;

@ As specified in the problem statement, the input file consists
of 3 lines, each consisting of a single integer.
The first integer is |L|, the second |X|, and the third |Y|.
We use calls to |fscanf| to get the input data, remember to add a newline
at the end of each format.
@<Read the input...@>=
fscanf(in_file, "%d\n", &L);
fscanf(in_file, "%d\n", &X);
fscanf(in_file, "%d\n", &Y);

@
@<Write the answer...@>=
fprintf(out_file, "%d\n", answer);

@
@<Include files@>=
#include <stdio.h>
