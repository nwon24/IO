@ This is a simple problem from the 2010 Australian Informatics Olympiad (AIO).
The problem consists of |N| ninjas trying to get inside our house.
We tie up each ninja, but in the process |K| more ninjas sneak past,
continuing until all ninjas have tried to sneak in.
Our job is to figure out how many ninjas sneak past.

For example, if |K| is 2, then for each ninja we tie up, 2 ninjas sneak past.
So, we tie up the first ninja, while ninjas 2 and 3 sneak past.
Then we tie up ninja 4, but ninjas 5 and 6 sneak past.
This continues up to all |N| ninjas.

The input file |ninjain.txt| consists of only one line of input.
This line of input as |N| followed by |K|, with a space between them.

@ Here is the high-level overview of the program.
It simply consists of reading the input file, doing the calculation,
and then writing the output to the output file.
@c
@<Include files@>;

int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input file to get N and K@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
}
@ Before opening the input and output files, we must declare
variables to associate with the open files.
@<Local variables@>=
FILE *in_file;
FILE *out_file;
@ Our first order of business as always is reading the input file.
We |fopen| to open the files.
We don't need to check for errors because an issue there is not
our problem.
@d IN_FILE "ninjain.txt"
@d OUT_FILE "ninjaout.txt"
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@
@<Local variables@>=
int N, K;
@ Now we need to read the input file and get |N| and |K|.
Since we assume the data provided is in the correct format,
it is a simple call to |fscanf|.
@<Read the input...@>=
fscanf(in_file, "%d %d", &N, &K);

@ We should hold our answer in a variable so that is is easy
to write it to the output file using |fprintf| later.
@<Local variables@>=
int answer;

@ To calculate the answer, we can try to simulate the ninjas
sneaking in.
We do this by simply adding the number of ninjas that sneak
in each time to |answer|.
When |K=0| we don't need to go through all the looping;
the answer is 0.
@<Calculate...@>=
answer = 0;
if (K != 0) {
  while (N > 0) {
    int caught;
    N--; /* We catch a ninja */
    caught = (N >= K) ? K : N;
    answer += caught;
    N -= caught;
  }
}
@
@<Write the answer...@>=
fprintf(out_file, "%d\n", answer);

@
@<Close the input...@>=
fclose(in_file);
fclose(out_file);
@
@<Include files@>=
#include <stdio.h>
