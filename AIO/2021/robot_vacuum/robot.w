@*Robot Vacuum. This is a problem
from the 2021 Australian Informatics Olympiad.

The problem consists of a robot following
a sequence of instructions.
The instructions are |N|, |E|, |S|, and |W|,
which instruct the robot to move one step
north, east, south, and west respectively.
After |K| of these instructions, we need to
find the fewest number of steps the robot
needs to make to get back to where it started.

@ Our |main| function consists of opening
the input and output files, parsing the input data,
actually calculating the answer, and then
writing the answer to the output file before
closing all open files.
@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@ We only have a few local variables.
We need a variable |K| to hold the number
of steps, and a variable |string| to be
the string of instructions given to the robot.
Local variables needed for the calculation
of the answer will be introduced later.

From the problem statement, the maximum
number of steps is $100000$, so we can
define a constant that will be used as the
size of our string.
This means we can avoid unnecessary dynamic
memory allocation.
@d MAX_INSTRUCTIONS 100000
@<Local variables@>=
int K;
char string[MAX_INSTRUCTIONS];
@*Calculating the answer.
The solution is fairly simple.
We just need to keep track of the robot's
position relative to its starting place
in terms of horizontal and vertical displacement.
Since the robot can only move up, down, left,
and right (and not diagonally), the answer will
be the sum of the absolute value of the
displacement coordinates.

If we think about a coordinate plane, where
the origin is where the robot begins, we can
see that if the robot finishes at $(-2,3)$,
it needs to take $2+3=5$ steps to get back
to the origin without moving diagonally across squares.

@<Local variables@>=
int answer; /* the answer */
int x; /* horizontal displacement */
int y; /* vertical displacement */

@ 
@<Calculate the...@>=
x = y = 0;
for (int i = 0; i < K; i++) {
  switch (string[i]) {
    case 'N':
      y++;
      break;
    case 'E':
      x++;
      break;
    case 'S':
      y--;
      break;
    case 'W':
      x--;
      break;
  }
}
answer = ABS(x) + ABS(y);

@ We also need a macro to calculate
the absolute value of a number.
@d ABS(n) ((n)>0?(n):-(n))

@*Input and output.
The problem statement tells us that
the input file name is {\tt robotin.txt}
and the output file name is {\tt robotout.txt}.
We define constants for these names here.
@d IN_FILE "robotin.txt"
@d OUT_FILE "robotout.txt"

@ We'll need some variables to point
to the opened input and output files.
@<Local variables@>=
FILE *in_file, *out_file;
@ We open the input and output files
using |fopen|.
Even though we expect the call to |fopen|
to not fail if we've got the names of the
input/output files correct, we still do some
error checking, just in case.
@<Open the input...@>=
in_file = fopen(IN_FILE, "r");
if (in_file == NULL) {
  @<Report error opening input file and abort@>
}
out_file = fopen(OUT_FILE, "w");
if (out_file == NULL) {
  @<Report error opening output file and abort@>
}

@ The aborting routines just print a message
to the terminal and exit with non-zero
exit code.
@<Report error opening input...@>=
fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
exit(EXIT_FAILURE);
@
@<Report error opening output...@>=
fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
exit(EXIT_FAILURE);

@ Once we've got the input and output files opened,
we need to read the data from the input file.
The problem statements tells us that the first
line of input will be a single integer, |K|.
The second line of input will be a string of
|K| characters containing the instructions.
@<Read the input...@>=
fscanf(in_file, "%d\n", &K);
fscanf(in_file, "%s\n", string);

@ Writing the answer to the output file
is a simple call to |fprintf|.
@<Write the...@>=
fprintf(out_file, "%d\n", answer);

@
@<Close the...@>=
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>