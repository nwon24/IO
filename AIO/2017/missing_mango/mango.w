@*Missing Mango.
This is a problem from the 2017 Australian Informatics Olympiad.

The problem consists of helping Ishraq and Clement find their mango.
They are standing on a straight line.
Their position relative to the left-hand end of the line
is given by $I_x$ and $C_x$.
The mango's exact position is unknown, but is known to be on the line.
The two other pieces of information given are how far
Ishraq and Clement are from the mango;
these quanities are $I_d$ and $C_d$ respectively.

These four values, $I_x$, $C_x$, $I_d$, $C_d$,
are on a single line in the input file.

@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the data from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@ Before calculating the answer, let's introduce
some variables to hold the input and output data.
@<Local variables@>=
int cx, cd, ix, id, answer;

@ Calculating the answer is fairly simple.
Given the two positions and their relative distance
from the mango, the mango can only be at
$I_x\pm I_d$ and $C_x\pm C_d$.
The mango is at where a pair of these four values match.
@<Calculate the...@>=
if (cd == 0) {
  answer = cx;
} else if (id == 0) {
  answer = ix;
} else if (cx+cd==ix+id || cx+cd==ix-id) {
  answer = cx+cd;
} else if (cx-cd==ix+id || cx-cd==ix-id) {
  answer = cx-cd;
} else {
  /* Unreachable */
  printf("UNREACHABLE\n");
  answer = 0;
}

@ The input and output file names are constant.
@d IN_FILE "manin.txt"
@d OUT_FILE "manout.txt"

@ We will need some variables of the pointer to |FILE| type
to refer to our input and output files.
@<Local variables@>=
FILE *in_file, *out_file;

@
@<Open the input...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@
@<Close the input...@>=
fclose(in_file);
fclose(out_file);

@ Since we know the data given to us in the input file
is as specified in the problem statement, we can safely
use |fscanf| without fear of foolishly formatted data
messing everything up.
@<Read the...@>=
fscanf(in_file, "%d %d %d %d\n", &ix, &cx, &id, &cd);

@
@<Write the...@>=
fprintf(out_file, "%d\n", answer);

@
@<Include files@>=
#include <stdio.h>