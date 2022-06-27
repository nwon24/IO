\input eplain
@*Vases.
This is a problem from the 2019 Australian Informatics Olympiad.

The problem is simple.
Given |N| number of flowers and three vases , we must determine a way
to arrage those flowers such that
\numberedlist
\li Each flower goes into a vase.
\li Each vase contains at least one flower.
\li Each vase contains a different number of flowers.

As with all problems from the AIO, the structure of our |main|
function consists mainly of getting the input and output data
to and from the input and output files.
@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files and read the input data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close all files@>;
  return 0;
}

@ Since our output is not only a single number, let's declare
three variables, |vase1|, |vase2|, and |vase3|, to hold the
number of flowers each vase will hold in our arrangement.
@<Local variables@>=
int vase1, vase2, vase3;

@ The problem may seem difficult at first, but it's really quite simple.
The first thing to notice is that we need at least 6 flowers to
be able to satisfy the rules above.
So if the number of flowers is less than 6, the problem statement
says that we should print three zeroes.
For any other case the arrangement |1|, |2|, |N-3| always works.
@<Calculate the answer@>=
if (N < 6) {
  vase1 = vase2 = vase3 = 0;
} else {
  vase1 = 1;
  vase2 = 2;
  vase3 = N-3;
}

@ Now it is time for the input and output part, which is
not really related to the actual problem.
The first thing to do is to define these constants
for the input and output file names.
@d IN_FILE "vasesin.txt"
@d OUT_FILE "vasesout.txt"

@ We also need a variable, |N|, to hold the number of flowers
as the program's input, as well as variables to point
to the input and output files.
@<Local variables@>=
int N;
FILE *in_file, *out_file;

@ We can now open the input and output files using |fopen|.
Then we use |fscanf| to get the single integer from the input file,
which will be |N|.
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");
fscanf(in_file, "%d\n", &N);

@ Similarly, we use |fprintf| and then |fclose| to write
our answer to the output file and then close by the
input and output files to wrap up our program cleanly.
@<Write the...@>=
fprintf(out_file, "%d %d %d\n", vase1, vase2, vase3);
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>

