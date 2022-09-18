\input eplain
\enablehyperlinks
@*Introduction. This is a solution to NORT, a problem from the 2012 Australian
Informatics Olympiad.

The problem consists of a $H$ by $W$ grid of square cells; the aim is to get
from the top left corner and pass through the maximum number of squares by
moving to an adjacent square without visiting any square twice.

More information can be found \href{https://orac2.info/problem/aio12nort/}{{\bf here}}.
@c
@<Include files@>@;
int main(void)
{
     @<Local variables@>@;
     @<Open the input and output files@>@;
     @<Read the input data@>@;
     @<Compute the answer@>@;
     @<Write out the answer and close all files@>@;
     return 0;
}
@*Computing the answer. Let's first tackle how to solve the problem.

If either the length or the width is even, we can construct a path that
goes through every cell. We just go from the top left corner down
to the bottom corner parallel with the non-even side (if there is one),
and then `snake' our way through all the squares except for the very
top row. Think of this as going right $1$ cell, going up $H-1$ cells,
right $1$ cell, down $H-1$ cells, and so on. Since the width is even, 
we will eventually end up at the bottom right hand corner after going
right $1$ cell. Then we can go up $H$ cells, and then left $W$ cells
to get back to our start position.

If both the length and the height are odd, we cannot construct a path
through all the squares. If we try doing our snake path again, we
will end up at the second cell from the top in the last column, and
so we will miss $H-2$ squares because we have to go up $1$ and then
left $W$ cells to complete the circuit. To maximise the length of
our path in this case, we can, instead of going up $H-1$ cells in
the second last column as per our snake procedure, we can snake
our way through the last two columns. Using the snake procedure
we used for the even case, we will end up at the bottom square of
the second-last column, and instead of going up, we go right $1$,
up $1$, left $1$, up $1$, right $1$, and so on. We will end up at
the top cell of the second-last column, meaning we will miss
the very top-right cell. Thus the longest path we can create is
$H\cdot W-1$.
@<Compute...@>=
answer = H*W;
if (answer & 1) {
   answer -= 1;
}

@ Let's declare the local variables we needed in our small section of code.
@<Local variables@>=
int answer; /* Used to store our answer */
int H, W; /* The width and height of the grid */

@*Input/output. Now we can turn to the boring part of the program: getting the
input from the input file and sending it to the output file.
We will use the |fopen| function from the C standard library to open the input
and output files.
Let's define some symbolic constants for the file names and declare the needed
file pointer variables.
@d IN_FILE "nortin.txt"
@d OUT_FILE "nortout.txt"
@<Local variables@>=
FILE *in_file, *out_file;

@ Here is where we actually open the files. As long as we have the file names
correct, these calls to |fopen| shouldn't fail.
@<Open...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@ The input consists of only two integers: $W$ and $H$ (in that order). Thus we just need
a single call to |fscanf|.
@<Read...@>=
fscanf(in_file, "%d %d", &W, &H);

@ Writing the answer to the output file is just as easy as reading the input file.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);
@*Include files.
We have only used the standard input/output routines of C, so we just need
the {\tt stdio.h} header file.
@<Include files@>=
#include <stdio.h>

@*Index.
