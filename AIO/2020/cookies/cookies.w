\input eplain
@*Introduction.
This is a solution to a problem from the 2020 Australian
Informatics Olympiad, called {\bf Cookies}.

The problem consists of several cookie factories.
To be more precise, there are three factories; the
first factory ({\it factory 0})is the initial factory,
or the one we have already set up, and factories 1 and 2
can be bought, but at the price of $P_1$ and $P_2$ cookies,
respectively. Factory 0 has a production rate of $C_0$
cookies per day; buying factories 1 and 2 increase the
production rate by $C_1$ and $C_2$ cookies per day respectively.

The aim of our program is to maximise the number of cookies
produced given a number of days, $D$, the price and production
increase of the factory 1 and 2, and the production rate
of factory 0.

Factory 1 and 2 can only be bought once, but they can
bought on the same day. Buying occurs at the end of the day,
after that day's cookies have been produced. This means
buying a factory increases the rate of production for the next
day.
@c
@<Include files@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@*Maximising the number of cookies.
One method would just be to simulate
all the scenarios. When there are no
special constraints, here are the the
possibilities:
\numberedlist
\li Buy factory 1 and 2 as soon as possible,
but with factory 1 before factory 2
\li Buy factory 1 and 2 as soon as possible,
but with factory 2 before factory 1
\li Buy only factory 1, as soon as possible
\li Buy only factory 2, as soon as possible
\li Buy no factories
\endnumberedlist

After simulating these scenarios, we just need
to find the maximum of the five values.

The first thing we need to do is to declare
the variables to hold the data. For the sake
of brevity, they will correspond to the names
given in the problem statement.
We will also need an array |cookies| to hold
the number of cookies produced in each scenario.

The two variables |C| and |P| will hold the current
rate of production and number of cookies during our
simulations.
@<Local variables@>=
int C0; /* Production rate of initial factory */
int C1; /* Production rate of factory 1 */
int C2; /* Production rate of factory 2 */
int P1; /* Cost in cookies of factory 1 */
int P2; /* Cost in cookies of factory 2 */
int D; /* The number of days we will be producing cookies */
int cookies[5]; /* The number of cookies produced from each scenario */

int C; /* Current production rate */
int P; /* Current number of cookies */

bool f1_bought; /* Has factory 1 been bought? */
bool f2_bought; /* Has factory 2 been bought? */
@ We will simulate the fifth scenario first, as it
is the easiest. In this scenario, we buy no
factories, so we can caulcate the answer without a loop.
@<Simulate scenario 5@>=
cookies[4]=D*C0;

@ Scenario 3 and 4 are also fairly simple to simulate.
As we are changing the rate of cookie production, we
will need a loop to determine when is the earliest we
can buy the factory.
@<Simulate scenario 4@>=
P=0;
C=C0;
f1_bought=f2_bought=false;
for (int i = 0; i < D; i++) {
  P+=C;
  if (f2_bought==false&&P>=P2) {
    /* We have enough cookies to buy factory 2 */
    P-=P2;
    C+=C2;
    f2_bought=true;
  }
}
cookies[3]=P;
@
@<Simulate scenario 3@>=
P=0;
C=C0;
f1_bought=f2_bought=false;
for (int i = 0; i < D; i++) {
  P+=C;
  if (f1_bought==false&&P>=P1) {
    /* We have enough cookies to buy factory 1 */
    P-=P1;
    C+=C1;
    f1_bought=true;
  }
}
cookies[2]=P;
@ Simulating scenario 1 and 2 are very similar.
Again we loop for the number of days |D|, but this
time, we need to check if the require factory
has been bought first. In scenario 2, we check
if factory 2 has already been bought before checking
if we can buy factory 1; this makes sure we buy
the factories in the correct order for the scenario.
Similarly, in scenario 1, we check if we have already
bought factory 1 before checking if we can buy factory 2.
@<Simulate scenario 2@>=
P=0;
C=C0;
f1_bought=f2_bought=false;
for (int i = 0; i < D; i++) {
  P+=C;
  if (f2_bought==true&&f1_bought==false&&P>=P1) {
    /* We have enough cookies to buy factory 1 */
    P-=P1;
    C+=C1;
    f1_bought=true;
  }
  /* We buy both factories if possible */
  if (f2_bought==false&&P>=P2) {
    /* We have enough cookies to buy factory 2 */
    P-=P2;
    C+=C2;
    f2_bought=true;
  }
}
cookies[1]=P;
@
@<Simulate scenario 1@>=
P=0;
C=C0;
f1_bought=f2_bought=false;
for (int i = 0; i < D; i++) {
  P+=C;
  if (f1_bought==false&&P>=P1) {
    /* We have enough cookies to buy factory 1 */
    P-=P1;
    C+=C1;
    f1_bought=true;
  }
  if (f1_bought==true&&f2_bought==false&&P>=P2) {
    /* We have enough cookies to buy factory 2 */
    P-=P2;
    C+=C2;
    f2_bought=true;
  }
}
cookies[0]=P;
@ After simulating the scenarios, we just
need to find the maximum number of cookies produced.
We use a simple loop for this.
@<Find the maximum of the five scenarios@>=
answer = 0;
for (int i = 0; i < 5; i++) {
  if (cookies[i]>answer) {
    answer=cookies[i];
  }
}
@ Looking at the above code we should realise we
have forgotten to define a variable to hold the
answer; we rectify that here.
@<Local variables@>=
int answer;
@ Finally we can get put all the pieces together
to calculate the answer.
@<Calculate the answer@>=
@<Simulate scenario 1@>;
@<Simulate scenario 2@>;
@<Simulate scenario 3@>;
@<Simulate scenario 4@>;
@<Simulate scenario 5@>;
@<Find the maximum...@>;
@*Input/Output.
Input and output is done using C standard library functions.
The problem statement tells us that the input and output
file names are {\tt cookiesin.txt} and {\tt cookiesout.txt},
so we define them as symbolic constants. Using |fopen|
to open the input and output files, we still need to check
for a bad return value because if we are testing our program
on a local machine, we have have forgotten to provide the
input file.
@d IN_FILE "cookiesin.txt"
@d OUT_FILE "cookiesout.txt"
@<Local variables@>=
FILE *in_file, *out_file;
@
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
if (in_file == NULL) {
  fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
  exit(EXIT_FAILURE);
}
out_file = fopen(OUT_FILE, "w");
if (out_file == NULL) {
  fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
  exit(EXIT_FAILURE);
}
@ To read the input data, we need to know
how the input data is formatted.
The problem statement tells us that the first line
contains the integers $D$ and $C_0$. The second
line contains $P_1$ and $C_1$, and the third line
contains $P_2$ and $C_2$.

The easiest way to get the input data is through
|fscanf|; usually this is not recommended because
humans can input improperly formatted data, but it's
safe to assume the input will be correct on the judging
machine.
@<Read the...@>=
fscanf(in_file, "%d %d\n", &D, &C0);
fscanf(in_file, "%d %d\n", &P1, &C1);
fscanf(in_file, "%d %d\n", &P2, &C2);

@
@<Write the...@>=
fprintf(out_file, "%d\n", answer);

@
@<Close the...@>=
fclose(in_file);
fclose(out_file);

@ We've obviously used input/output functions from
the C library, but we also use |exit| when checking
for {\tt NULL} return from |fopen|, so we need
to include {\tt stdlib.h} as well.
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
