@*Introduction. This program solves a problem from
the 2022 Australian Informatics Olympiad called {\bf Election II}.
The problem consists of determining the winner of an election.
There are $N$ votes, each voting for candidate $A$, $B$, or $C$.
Our job is to determine who received the most votes, or if
there were a tie; a tie occurs when any two candidates receive
the same number of votes. Our output should be a single letter:
{\tt A}, {\tt B}, or {\tt C}, if there was an outright winner,
{\tt T} otherwise.

This problem is actually one of the simpler problems from the AIO,
even for the first problem in a problem set.
@c
#include <stdio.h>

int main(void)
{
    @<Local variables@>@;
    @<Open the input and output files@>;
    @<Read the input data@>;
    @<Calculate the answer@>;
    @<Write the answer to the output file and close all files@>;
    return 0;
}
@*Calculating the answer. Our algorithm is fairly simple.
We are given a string of $N$ characters that tells us how the votes
fell. For example, the string could be {\tt BBAC}, in which case
$B$ received $2$ votes, and $A$ and $C$ $1$ each.
We simply need to loop over the string and keep count of the number
of votes for each candidate, and then determine either if there
is a winner of if there is a tie.

We will need a few local variables. First we need three variables
to keep count of the candidates' votes; let's call them |A|, |B|,
and |C|. Then we need a variable to hold the number |N|, and a variable
to hold the string of characters, which we will call |votes|. Finally,
we will need a variable to store our answer.
@<Local variables@>=
int A = 0; /* The number of votes A received */
int B = 0; /* The number of votes B received */
int C = 0; /* The number of votes C received */
int N; /* The number of votes in the election */
char votes[100005]; /* The votes of the election */
int answer;  /* Our answer: the winner of the election or `T' if a tie */

@ Calculating the answer consists of a single loop. After we finish
counting the votes we find the winner, if there is one.
@<Calculate the answer@>=
for (int i = 0; i < N; i++) {
    switch (votes[i]) {
    case 'A':
	A++;
	break;
    case 'B':
	B++;
	break;
    case 'C':
	C++;
	break;
    }
}
@<Determine the winner@>@;
@ Since there are three variables we have to find the maximum of to 
determine the winner, the easiest way is the following. A candidate
wins if their number of votes is greater than the other two. We simply
test this for each candidate, and if the test is false for all of them,
then at least two of them share the same number of votes.
@<Determine...@>=
if (A > B && A > C) {
    answer = 'A';
} else if (B > A && B > C) {
    answer = 'B';
} else if (C > A && C > B) {
    answer = 'C';
} else {
    answer = 'T';
}
@*Input/output. Input/output to the files is fairly simple in this problem.
We use the C standard library routines |fopen|, |fscanf|, |fprintf|,
and |fclose|, to open, read, write, and close our input and output files.

The problem statement tells us the name of the input and output files:
{\tt elecin.txt} and {\tt elecout.txt}.

Let's first declare the local variables |in_file| and |out_file| we will
use to refer to the input and output files.
@<Local...@>=
FILE *in_file, *out_file;
@ Now we can use set those variables to point to the proper file usisng |fopen|.
Usually we would check for errors but because our code is running on a remote
judging machine where it is assumed the input and output files will be present,
we can do away with any error reporting.
@<Open...@>=
in_file = fopen("elecin.txt", "r");
out_file = fopen("elecout.txt", "w");
@ The input file consists of two lines. The first line contains the integer |N|,
the second line contains the string of characters that details how the votes fell.
We can read both pieces of data using a single call to |fscanf|.
@<Read...@>=
fscanf(in_file, "%d\n%s", &N, votes);
@
@<Write...@>=
fprintf(out_file, "%c\n", answer);
fclose(in_file);
fclose(out_file);
@*Index.
