\input eplain
@*Introduction. This program is a solution to
the third problem from the 2022 Australian Informatics
Olympiad, which is titled {\it TSP}.

The title of the problem refers to its story, which
tells us that we have apparently got a job
working as a Tomato Salesperson (hence TSP), but for
the next $N$ days only. There are two requirements
that we must satisfy each day when we sell tomatoes:
\unorderedlist
\li We must sell at least $L_i$ and at most $R_i$
tomatoes on the $i$-th day.
\li Each day we must sell at least as many tomatoes
as we sold the previous day.
\endunorderedlist

Given $N$, $L_i$, and $R_i$, our program needs to
determine whether it is possible to satisfy the two
requirements given above. If we can satisfy the
requirements, we must write the string {\tt YES} to
the output file; otherwise, we write {\tt NO}.

The general outline of the program follows. All components
will be filled in later.
@c
#include <stdio.h>

@<Global variables@>@;

int main(void)
{
  @<Open the input and output files@>@;
  @<Read the input data from the input file@>@;
  @<Determine whether or not the requirements can be satisfied@>@;
  @<Write the answer to the output file and close all files@>@;
  return 0;
}
@ For more information on the problem, along with
sample test cases and their explanations, visit
the problem's problem statement, which can be found
at {\tt orac2.info/problem/aio22tsp}.
@*Solving the problem. This problem relies on a few
simple observations. Each day we must sell at $L_i$
tomatoes, and at least as much as we sold yesterday.
Thus on a particular day, we must sell at least
the maximum of $L_i$ and the amount we sold yesterday.

To give us the best possible chance of satisfying
both requirements for all $N$ days, it makes sense
to sell as few tomatoes each day as possible. Thus all
we need to do is to calculate the minimum number of
tomatoes we need to sell for a particular day---the maximum
of $L_i$ and the amount we sold yesterday---and see
whether that number is less than or equal to $R_i$. If it is,
then we sell the least number of tomatoes and move on
to the next day. If that number is greater than $R_i$,
we cannot satisfy the requirements for that particular
day, and thus the entire $N$ days. This is because by
selling the least number of tomatoes each day, we are
creating the best-case scenario and allowing the best
chance of satisfying the requirements.
@ Now that we have a rough idea of how to solve the
problem, let's get into specifics.

Firstly, let's define the global variables that we
will need. We will need two arrays, |L| and |R| to hold
the minimum and maximum requirements each day.
(In case you are wondering why we are choosing such
sparse names, it is for parallism between our code
and the variable names in the problem statement.)
We will also need a variable |N| to hold the number of
days. Finally, we will require a variable named |answer|,
which will be a string that is either |"YES"| or
|"NO"|.
@<Global variables@>=
int N;
int L[100005];
int R[100005];
char *answer;
@ Having thought about how we would solve the problem,
we can now go about translating our solution into
actual code.

Our algorithm fits into a few, nicely-separated pieces.
For each day, we want to calculate the minimum number of
tomatoes we must sell. If that number is greater than
the maximum requirement for that day, then we are done
because the answer is |"NO"|. If we reach the end of
our |L| and |R| arrays, then it is possible to satisfy
the requirements and so our answer is |"YES"|.

@<Determine...@>=
@<Initialise |answer|@>@;
@<Local variables for determining the answer@>@;
for (int i = 0; i < N; i++) {
    /* The minimum number of tomatoes we need to sell today */
    int tomatoes;

    tomatoes = (L[i] > yesterday) ? L[i] : yesterday;
    if (tomatoes > R[i]) {
       answer = "NO";
       break;
    }
    yesterday = tomatoes;
}
@ We initialise the variable |ansewr| to |"YES"| because
it will not change if we finish looping over all the days.
We only change |answer| once we determine it is impossible
to satisfy the requirements.
@<Initialise |answer|@>=
answer = "YES";
@ For our inner loop, we just need a single local variable
to hold the number of tomatoes we sold yesterday. We will
aptly name this variable |yesterday|. We initialise it to
|0|.
@<Local variables for determining...@>=
int yesterday = 0;
@*Input/output. As with any other AIO problem, we need to
read our input data from a specific file and write our answer
to a specific file. The names of both are given the problem statement.

Sometimes it is a good idea to use |freopen| to associate
the necessary files with standard input and standard output,
but that might lead to unecessary complications if we forget
we have done so and are thus bemused when a call to |printf|
does not send any output to the screen. Here, however, we will
take the simpler and more direct approach of declaring two
variables that will point to the input and output files.
@<Global variables@>=
FILE *in_file;
FILE *out_file;
@ Now we can use |fopen| to open both. Fortunately for us,
no error checking is needed because we can expect the input
and output files to exist on the judging machine. The only
problem is if we forget to supply the input file during the
testing of the program.
@<Open...@>=
in_file = fopen("tspin.txt", "r");
out_file = fopen("tspout.txt", "w");
@ The input file consists of three lines. The first consists
of a single integer, |N|. The next two lines each contain
|N| integers, with the $i$-th number on the second line being
$L_i$ and the $i$-th number on the third line being
$R_i$.

We will use |fscanf| to conveniently read the formatted
input into memory.
@<Read...@>=
fscanf(in_file, "%d\n", &N);
for (int i = 0; i < N; i++) {
  fscanf(in_file, "%d ", &L[i]);
}
for (int i = 0; i < N; i++) {
  fscanf(in_file, "%d ", &R[i]);
}
@ Writing the answer to the output file is simple because
it consists of only one piece of data---the string stored
in the variable |answer|. We then use |fclose| to close
both the input and output files as it is always good practice
to close files once we are done with them.
@<Write...@>=
fprintf(out_file, "%s\n", answer);
fclose(in_file);
fclose(out_file);
@*Index.
