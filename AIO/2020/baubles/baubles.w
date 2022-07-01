@*Introduction.
This is {\bf Baubles}, a problem from
the 2020 Australian Informatics Olympiad.

An artificer, Olaf, has $R_o$ red baubles,
$B_o$ blue baubles, and $S$ spare unpainted
baubles that can become either red or blue.
He is servicing an order for $R_p$ red
baubles and $B_p$ blue baubles. Our program's
job is to determine the fewest number of
baubles that can be destroyed to stop Olaf
from being able to fulfill the order. Olaf
cannot turn a painted bauble into the opposite
colour.
@c
@<Include files@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input data from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@*The guts of the problem.
We can solve the problem by breaking it into
two parts. Firstly, we check if Olaf can already
fulfill the order with the red and blue baubles
he has; if he can, we destroy the minimum such
that he can no longer fufill the order without
painting spare baubles. Then we figure out
how many spare baubles he needs to complete
the order and destroy those as well.

We'll need variables to hold the input values
$R_o$, $B_o$, $S$, $R_p$, and $B_p$.
Recall that $R_o$ and $B_o$ are the number
of red and blue baubles that Olaf has, $S$
is the number of spare unpainted baubles, and
$R_p$ and $B_p$ are the number of red and
blue baubles on order that Olaf needs to fufill.

To calculate the answer, we'll also need
variables to hold the number of red and blue
baubles that Olaf needs to make to complete
the order.
@<Local variables@>=
int olaf_red; /* The number of red baubles Olaf has */
int olaf_blue; /* The number of blue baubles Olaf has */
int spare; /* The number of spare baubles Olaf has */
int order_red; /* The number of red baubles on order */
int order_blue; /* The number of blue baubles on order */

int red_needed; /* The number of red baubles Olaf needs to create */
int blue_needed; /* The number of blue baubles Olaf needs to create */

int answer; /* Variable to hold our answer in */
@ Our algorithm to calculate the answer can
be broken down neatly into the two components
described above.
@<Calculate...@>=
answer = 0; /* Initialise |answer| */
@<Determine how many baubles to destroy such that
  Olaf can no longer complete the order@>;
@<Determine how many spare baubles to destroy@>;

@ To determine how many of Olaf's baubles we
need to destroy before he can no longer fufill
the order, we look at the difference between
|olaf_red| and |order_red|, and |olaf_blue|
and |order_blue|. If the difference is negative,
Olaf already does not have enough baubles to
complete the order. Otherwise, the minimum number
of Olaf's baubles we need to destroy is the
minimum of the two differences plus $1$.
We also decrease |olaf_red| or |olaf_blue| as
needed so that when we get to the next stage,
those two variables accurately reflect how
many baubles Olaf actually has.

The one edge case we need to consider when
either |order_red| or |order_blue| equals 0;
the problem statement guarantees that both
will not be 0, but one or the other can be.
In that case, no matter how many baubles of
that colour we destroy, Olaf will still be able
fulfill the order because the order is for 0 baubles.
Therefore, if the order for red or blue baubles is
0, we ignore it and just destroy enough baubles
of the other colour so that Olaf is not able to
fulfill the order.
@<Determine how many baubles...@>=
red_needed = order_red-olaf_red;
blue_needed = order_blue-olaf_blue;
/* If |red_needed| and |blue_needed| are both
  negative or zero, that means Olaf already has all
  the baubles he needs. That is when we
  come in to destroy his baubles, unless |order_red|
  or |order_blue| is 0, in which case destroying
  any number of Olaf's red or blue baubles doesn't
  change anything.
 */
if (red_needed<=0&&blue_needed<=0) {
  if (order_red==0) {
    answer+=-blue_needed+1;
    olaf_blue-=answer;
  } else if (order_blue==0) {
    answer+=-red_needed+1;
    olaf_red-=answer;
  } else if (red_needed>blue_needed) {
    answer+=-red_needed+1;
    olaf_red-=answer;
  } else {
    answer+=-blue_needed+1;
    olaf_blue-=answer;
  }
}
@ At this point in the program, Olaf cannot
complete the order regardless of whether we
have destroyed his baubles or not. If he
couldn't fufill the order in the first place,
then we didn't need to destroy any; if he
could complete the order, we have destroyed
enough so that he needs a single spare bauble
to complete the order.

Now we just need to destroy enough spare baubles
so that Olaf cannot paint the necessary baubles.
First we calculate the number of spare baubles
Olaf needs. We calculate |red_needed| and
|blue_needed| again because they may have changed
when we destroyed some of Olaf's baubles.

@<Determine how many spare...@>=
int spare_needed;
red_needed=order_red-olaf_red;
blue_needed=order_blue-olaf_blue;
spare_needed = 0;
if (red_needed>0)
  spare_needed+=red_needed;
if (blue_needed>0)
  spare_needed+=blue_needed;
if (spare_needed<=spare&&spare!=0)
  answer+=spare-spare_needed+1;
@*Input/Output.
As with any other AIO program, input comes from
a specified input file, and out output needs to
go to a specified output file. The problem statement
tells us that the specified input file is {\tt baublesin.txt}
and the specified output file is {\tt baublesout.txt};
let's define symbolic constants for these names
and declare the variables to refer to these files.
@d IN_FILE "baublesin.txt"
@d OUT_FILE "baublesout.txt"
@<Local variables@>=
FILE *in_file; /* Points to the input file */
FILE *out_file; /* Points to the output file */

@ We only the input and output files using the
C standard library function |fopen|. We don't expect
the call to fail, but when we run it on our own
machines we may forget to create the input file;
therefore, error checking is still necessary.
If we can't open either file, we simply print a message
to the screen and exit gracefully.
@<Open the input...@>=
in_file = fopen(IN_FILE, "r");
if (in_file==NULL) {
  fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
  exit(1);
}
out_file = fopen(OUT_FILE, "w");
if (out_file==NULL) {
  fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
  exit(1);
}

@ Reading the input file consists of calling |fscanf|
to get the formatted data from the input file.
The problem statement tells us that the input file
contains only a single line, consisting of $R_o$, $B_o$,
$S$, $R_p$, and $B_p$ separated by spaces.
Recall that they correspond to our local variables
|olaf_red|, |olaf_blue|, |spare|, |order_red|
and |order_blue|, respectively.
@<Read the input...@>=
fscanf(in_file, "%d %d %d %d %d\n", &olaf_red, &olaf_blue, &spare, &order_red, &order_blue);

@ 
@<Write the...@>=
fprintf(out_file, "%d\n", answer);

@ 
@<Close the...@>=
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
