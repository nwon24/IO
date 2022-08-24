\input eplain
\enablehyperlinks
@*Introduction. This program is a solution to a problem from the 2006
Australian Informatics Olympiad.

The problem is called 'Fashion Statement.' It boils down to determining the smallest
number of notes needed to make up a certain amount of money. There are only
\$20, \$5, \$1, and \$100 dollar notes.

The problem statement can be founder \href{https://orac2.info/problem/aio06fashion/}{{\bf here}}.
@c
@<Include files@>@;
int main(void)
{
    @<Local variables@>@;
    @<Open the input and output files and read the input data@>@;
    @<Read the input data from the input file@>@;
    @<Calculate the answer@>@;
    @<Write the answer to the output file and close all files@>;
    return 0;
}
@*Calculating the answer.
This program can be solved using a greedy algorithm. That is, if we have $t$ dollars,
we simply find the biggest note less than $j$ and add that to our talley of notes.
Once we are under $5$ dollars, we know the rest will be $1$ dollar notes, so we don't
need to continue iterating.

Suppose that we have declared a local variable |answer| to hold our answer, and |t|
is the cost of the taxi ride that we have make up using notes.
We will have an array of integers that holds the notes in descending order; that way
to find the largest note we can use we can just move through our array.
@<Calculate the answer@>=
int notes[] = { 100, 20, 5, 1 };
int i;

i = 0;
answer = 0;
while (t > 0) {
    if (t < 5) {
	answer += t;
	break;
    }
    while (notes[i] > t) {
	i++;
    }
    t -= notes[i];
    answer++;
}

@ The two variables we used above that we didn't declare were |answer| and |t|; we rectify
that here.
@<Local variables@>=
int t; /* Cost of taxi fare */
int answer; /* The smallest number of notes that will make up the taxi fare */
@*Input/output. This is the boring part of the program. Luckily for us, the C standard
library provides convenient functions for file input and output.
Let's first define the constants for the file names and declare the file pointers that
will refer to the input and output files.
@d IN_FILE "fashin.txt"
@d OUT_FILE "fashout.txt"
@<Local variables@>=
FILE *in_file, *out_file;
@ Usually when opening files, we need to do proper error checking. However, since our code
is meant to be run on a judging machine, it isn't really our problem if the input and output files
in the problem statement don't exist or cannot be opened with the necessary permissions. Let's
hope nothing bad happens as a result of our lack of error checking.
@<Open...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");
@ The input file is extremely simple; it consists of only a single integer, |t|.
@<Read...@>=
fscanf(in_file, "%d\n", &t);
@ Writing the answer to the output file is a one-liner as well. Afterwards we tidy up by
closing both the input and output files.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);
@*Include files. The last thing to do is to include the proper files. We have only used 
C input/output, so we just need to include the {\tt stdio.h} header file.
@<Include files@>=
#include <stdio.h>
@*Index.
