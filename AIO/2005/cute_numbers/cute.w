@*Introduction. This is a solution to a simple problem
from the 2005 Australian Informatics Olympiad called
{\bf Cute Numbers}.

The problem boils down to finding the number of zeroes
at the end of a given number, and due to the simplicity
of the problem this will be a good illustration of
the facilities of the {\tt CWEB} language.

The problem statement can be found here: {\tt https://orac2.info/problem/aio05cute/}.
@ Here is the basic outline of the program.
@c
#include <stdio.h>

@<Global variables@>@;

int main(void)
{
  @<Open the input and output files@>@;
  @<Read the input from the input file@>@;
  @<Calculate the answer@>@;
  @<Write the answer to the output file and close all files@>@;
  return 0;
}

@*Solving the problem.
We will first deal with solving the problem; the boring stuff
(file input and output) can wait.

From the problem statement, we know that the input is actually
a list of digits that make up the number we have to count
the trailing zeroes of. This means we don't even need to
store the numbers in an array; as we read the digits in,
whenever we see a zero, we increment an internal counter,
and just reset the counter whenver we see a non-zero digit.

Let's first declare a variable |answer|, to hold
our answer, and a variable |N| to hold the number of digits. This
will be read in later.
@<Global variables@>=
int answer; /* The number of zeroes at the end of the given number */
int N; /* Th number of digits in the number given to us */

@ We will also need some variables to point to the input and output
files. Don't worry, we will initialise them later.
@<Global variables@>=
FILE *in_file, *out_file;

@ Armed with these variables, we can begin calculating our
answer. We use |N| in our loop to know when to stop reading
digits from the input file. As mentioned before, in our loop
we simply keep a count of the number of consecutive zeroes seen,
ressting it when we see a digit that is not zero.
@<Calculate...@>=
answer = 0; /* Initialise */
for (int i = 0; i < N; i++) {
  int digit; /* The next digit to be read */
  fscanf(in_file, "%d\n", &digit);

  if (digit == 0) {
    answer++;
  } else {
    answer = 0;
  }
}

@*File input/output. Now we turn to the boring stuff: input
and output. The input and output needs of this program are
fairly minimal, and are well-handled by the C standard library.

We just need to note the names of the input and output
files, which are stated in the problem statement.
@d IN_FILE "cutein.txt"
@d OUT_FILE "cuteout.txt"

@ We use |fopen| to associate the input and output files
with our file pointers.
@<Open...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@ Note that here we just need to read in the integer |N|---the number
of digits in the number given to us---as we read the individual digits
in the loop where we calculate the answer. This eliminates the need
to store the digits in an array.
@<Read...@>=
fscanf(in_file, "%d\n", &N);

@ Writing the output file is easy, since it consists
of only a single integer. A single call to |fprintf| suffices.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@*Index.
