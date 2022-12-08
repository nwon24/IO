\input eplain
\enablehyperlinks

@*Introduction. This program is a solution
to a training problem on the Australian Informatic
Olympiad's training webiste called {\bf Culture}.
The problem can be found at \href{https://orac2.info/problem/aic03culture/}.

The problem consists of a culture of bacteria.
Given that the bacteria doubles every day, and that
we started with an odd number of bacterium, our
job is to determine how many bacterium we started with
and for how many days it has been doubling.

Here is the basic overview of our code.
@c
@<Include files@>@;
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
Since we started with an odd number, dividing the
current number of bacteria by the highest power
of two that divides it will give us the initial
size of the population. Then the exponent of that
power of two gives us the number of days that
have elapsed in the experiment.

More intuitively, let's take an example.
In the problem statement the example given is
$136$ for the starting population. This means
that on the previous day the size of
the population was $136/2=68$, and the day
before that was $68/2=34$. Where do we stop?
We stop when we hit an odd number, since we
know we can't have started with an even number.
This process of dividing by $2$ until we can't
(i.e., we get an odd number) is the same as
dividing the number by the highest power of $2$
that divides it.

@ Let's declare some variables that we will
need to solve the problem. The only input variable
is |N|, the current size of the population. We will
need two variables to store our two outputs: the initial
size of the population, and the number of days
elasped.
@<Global variables@>=
int N; /* Current size of bacteria population */
int starting; /* Starting bacteria population size */
int days; /* Number of days the population has been doubling */

@ Now we are ready to calculate the answer. One way is
to find the first non-zero bit from the right, but the
simpler way of repeatedly dividing our initial population
size by $2$ until we get an even number is a little clearer.
@<Calculate the answer@>=
/* Initialise the variables */
days = 0;
starting = N;
while (@<|starting| is even@>) {
  days++;
  starting /= 2;
}
@ To determine if a number is even, we can use the modulo
operator, but a much better way is just to test if
its least significant bit is set.
@<|starting| is even@>=
(starting & 1) == 0
@*File input/output. The input and output needs for
this program are minimal, and are thus readily
handled by the C standard library.

Let's first define two symbolic constants that will
refer to the input and output files.
@d IN_FILE "cultin.txt"
@d OUT_FILE "cultout.txt"

@ Now we need two variables to point to the input
and output files.
@<Global variables@>=
FILE *in_file;
FILE *out_file;
@ The following two calls to |fopen| may return
an error, but since our code will be running on
a remote judging machine, we can dispense with
the error checking.
@<Open...@>=
in_file =fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");

@ Reading the input from the input file is simple,
as it consists of only a single integer, |N|.
@<Read...@>=
fscanf(in_file, "%d\n", &N);

@
@<Write...@>=
fprintf(out_file, "%d %d\n", starting, days);
fclose(in_file);
fclose(out_file);

@*Include files.
We have used only standard input/output facilities
of the standard library, so we just need to include
the {\tt stdio.h} header file.
@<Include files@>=
#include <stdio.h>
@*Index.