\input eplain
@*Laser cutter.
This is the sixth and final problem from the
2021 Australian Informatics Olympiad.

The problem consists of a laser cutter
cutting a shape into a square piece of
plywood |N| centimetres tall.
The laser cutter understands only two
different instructions: {\tt R}, which
causes the laser to move one centimetre
to the right, and {\tt D}, which causes
the laser to move one centimetre down.

The robot is given two sequences of
instructions: |A| and |B|.
The first sequence |A| cuts the lower
boundary of the shape, meaning its
first instruction must be {\tt D}.
The sequence |B| cuts the upper
boundary of the shape, meaning its
first instruction must be {\tt D}.
It is guaranteed that the two sequences
of instructions result in cuts that do
not and intersect except at the top-left
and bottom-right corners.

Our job is to find the {\it side length
of the largest square} that can fit inside
the cut-out shape, with the sides of the
square being parallel to the plywood.
@c
@<Include files@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@* A simple solution. The problem seems complicated, but is
actually quite simple. However, a fully clear explanation
pmost likely requires some visual intuition,
which can be found \href{https://orac2.info/hub/train/editorials-aio21-q6}{{\bf here}},
the problem's page in the 2021 AIO editorial.

The observation we need to make is how the side length
of a square that fits across the diagonal between the current
point in the upper boundary and the lower boundary.
Consider the first steps, which must be {\tt D} for the lower boundary and {\tt R}
for the upper boundary. If we look at just these two lines,
we see that a square of side length $1$ can fitted inside
such that its diagonal connects the two end points
of the upper and lower boundary.
Then, if the next instruction for the lower
boundary is {\tt D} and {\tt R} for the upper boundary, the
side length of the square we can fit across the diagonal of the two points
now has side length $2$. However, if the next instruction is {\tt R}
for the lower boundary and {\tt D} for the upper boundary, the diagonal
between the two new endpoints has decreased and the square that is drawn
between those end points has side length of $1$. The last we need to notice
is that if the two instructions for the upper and lower boundaries are
the same, then the distance between the two endpoints on the boundaries
is unchanged, so the square formed between them has the same side length as before.

In general, if the instruction in $A$ and $B$ are different, the square
able to formed by the current endpoints of our boundaries has a changed
side length, and otherwise, the side length of the square remains the same.
To calculate the length of the largest square, we just need to determine
the side lengths of all the squares that can be formed between diagonal
points on the shape's boundaries and find the maximum.

@ Here are the variables and constants
we will need to work out the answer.
We need a variable |N| to hold the length
of the plywood square.
Then we need arrays |A| and |B|, each of
length |2N| to hold the two sequences of
instructions.
To avoid dynamic memory allocation, we
declare the two arrays with their maximum
lengths as guaranteed by the problem statement.
@d MAX_SQUARE_LEN 200000
@<Local variables@>=
int N;
char A[MAX_SQUARE_LEN*2];
char B[MAX_SQUARE_LEN*2];
int answer;

@
@<Calculate the answer@>=
/* Length of square formed
                 by diagonal between endpoints
                 upper boundary and lower boundary */
int length=0; 
answer=0;           
for (int i=0;i<2*N;i++) {
  if (A[i]!=B[i]) {
    length+=(A[i]=='D')?1:-1;
    if (length>answer)
      answer=length;
  }
}

@*Input/output.
The C standard library routines for file input/output
are convenient for our purpose. To avoid needing variables
to point to the input/output files, we use |freopen|
to associate the input and ouput files with standard input
and standard output, so that we can use the functions |printf|
and |scanf| for the actual input/output.
@<Open the input...@>=
if (freopen("laserin.txt", "r", stdin)==NULL) {
  fprintf(stderr, "Unable to open input file laserin.txt\n");
  exit(EXIT_FAILURE);
}
if (freopen("laserout.txt", "w", stdout)==NULL) {
  fprintf(stderr, "Unable to open output file laserout.txt\n");
  exit(EXIT_FAILURE);
}
@ The problem statement tells us how the
input data is formatted in the input file.
The first line contains a single integer, |N|,
the side length of the plywood square.
Remember that there will be |2*N| instructions
for the upper and lower boundaries.
The next two lines contain sequences of {\tt D}
and {\tt R} instructions, the first corresponding
to the instructions for the lower boundary, and
the second to the instructions for the upper boundary.
@<Read...@>=
scanf("%d\n", &N);
scanf("%s\n%s", A, B);
@ It seems like we are printing the answer
to the terminal, but since the file handle
|stdout| corresponds to the correct output file,
our answer will be sent to the correct place.
@<Write the...@>=
printf("%d\n", answer);
@
@<Close the...@>=
fclose(stdin);
fclose(stdout);
@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
