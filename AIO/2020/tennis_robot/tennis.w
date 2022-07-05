@*Introduction. This program is a solution
to the {\bf Tennis Robot} problem from
the 2020 Australian Informatics Olympiad.

The problem involves a robot collecting
tennis balls from a court and putting them
into a certain number of storage bins.
There are $B$ bins that are numbered from
$1$ to $B$, and the $i^{\hbox{th}}$ bin
can hold $A_i$ balls. There are $N$ balls
that the robot needs to pick up, and its
algorithm for putting balls into bins is
very simple: beginning at bin $1$, if
bin $B$ is not yet full, the robot puts
one ball into that bin, and then moves
on to the next bin. Our job is to determine
which bin the robot puts the last ball into.
We know that the total capacity of the bins
is definitely able to contain all $N$ balls.
@c
@<Include files@>@;

@<|struct bin| definition@>@;
@<The |compar|...@>@;

int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close all filese@>;
  return 0;
}

@*The Algorithm.
The most obvious algorithm is to the brute-force
method, in which we iterate over all the balls,
increment values in an array corresponding to how
full each bin is, and then just spit out the last
index. However, this is incredibly slow, because
|N| balls does not guarantee the there will be |N|
iterations. If lots of bins become full, they have
to be skipped decrementing |N|.

Here is a solution that will hopefully be faster.
We first sort our array of bin capacities so
that they are in ascending order. This means bins
closer to the start of the array will be the first
to become full. Then, we keep track of the number
of bins that can still take balls, and then subtract from |N|
the number of balls that would be pbicked up by those
bins until one of the bins becomes full. For example,
if the bin with the lowest capacity could hold $2$ balls
and there were $10$ bins, the robot could place
$2*10=20$ balls before there is a bin we need to skip.
In that case, we simply decrease the number of bins
in play by the number of bins that have now reached
full capacity, and then repeat the exercise. Since our
array of bins is sorted in increasing order, it is
easy to determine which will be the next set of bins
that will be become full.

At some point, there won't be enough balls left to
distribute fully around all the bins. At that point, we
simply need to calculate in which remaining bin the last
ball will end up using modular arithmetic, because we
know that there won't be any more bins that become full.
Since the order of the bins matters once we know no more
bins will become full, we need to sort the remaining bins
(the ones that aren't full yet) in increasing order of
their number.

To implement this algorithm, we need to declare a special structure
for a bin so that they can be rearranged without us
losing the information about their bin number and
capacity.

Additionally, We will need some local variables to hold the
input data, our bin array, and our answer.
The problem statement gurantees that the
number of bins will not exceed $100000$;
thus we can statically allocate our arrays,
at the cost of a little memory.
@d MAX_BINS 100000
@
@<|struct bin| definition@>=
struct bin {
  int number; /* Bin number, from 1 to |B| */
  int capacity; /* How many balls the bin can hold */
};

@
@<Local variables@>=
int B; /* The number of bins */
struct bin bins[MAX_BINS]; /* Our bins */
int N; /* The number of balls to pick up */

int answer; /* Our answer */

@ The first thing we need to do is sort our |bins|
array. As we are using |qsort|, we need to provide our
own |compar| function to compare two elements, which
will be variables of type |struct bin|.
@<The |compar| functions for |qsort|@>=
int compar_cap(const void *p1, const void *p2)
{
  const struct bin *bin1, *bin2;

  bin1 = (const struct bin *)p1;
  bin2 = (const struct bin *)p2;
  if (bin1->capacity<bin2->capacity) {
    return -1;
  } else if (bin1->capacity==bin2->capacity) {
    return 0;
  } else {
    return 1;
  }
}
int compar_num(const void *p1, const void *p2)
{
  const struct bin *bin1, *bin2;

  bin1 = (const struct bin *)p1;
  bin2 = (const struct bin *)p2;
  if (bin1->number<bin2->number) {
    return -1;
  } else if (bin1->number==bin2->number) {
    return 0;
  } else {
    return 1;
  }
}

@ Here is the main bit of code to calculate the answer.
First, we need to sort |bins| using |qsort|. Notice that
in the first call to |qsort|, we use our |compar_cap| function,
which causes |qsort| to sort in ascending order of capacity.
In our loop, we find the bin that will be next to become full,
and simulate putting one ball into each of the bins until that
bin becomes full. Then, we can remove those bins that are full, by changing what
the variable |smallest| so that it points to the next smallest bin, 
and repeat the process.

By repeating the process, we will eventually
get to the point where the number of balls left will not cause
any of the remaining bins to become full. In this case, we now
can determine which bin the last ball will end up in using
modular arithmtic, because we know there won't be any more bins
we have to eliminate. Before we do this, however, we now need to sort
the remaining bins, the first of which is pointed to by |smallest|,
in order of their numbers, because the robot places balls in bins
of increasing number. We didn't have to do this before because we
simulated placing a ball in every bin; this meant we could sort by capacity
instead because we were assured that there were enough balls to put
one in every bin for that round.

After sorting the remaining bins into ascending order by their numbers,
we simply calculate the answer using modular arithmetic, with a few edge cases
we need to be careful of. For example, if the number of balls is divisible
by the number of bins, the answer is the last bin, but using the |%| operator
will result in a value of $0$.

@<Calculate the answer@>=
int low_cap; /* Lowest capacity of a bin */
int bins_not_full; /* Bins we can still balls into */
int balls_placed; /* The number of balls placed into each bin */
struct bin *smallest; /* Smallest bin still in play */

qsort(bins, B, sizeof(bins[0]), compar_cap);
bins_not_full=B; /* Initially all bins are empty */
low_cap = 0;
balls_placed = 0;
smallest = &bins[0];
while (1) {

  @<Find smallest bin not full@>;
  low_cap=smallest->capacity;

  if ((low_cap-balls_placed)*bins_not_full<N) {
    /* Place all the balls we can in bins before the smallest bins are full */
    N-=(low_cap-balls_placed)*bins_not_full;
    balls_placed+=low_cap-balls_placed;
  } else {
    break;
  }
}
qsort(smallest, bins_not_full, sizeof(*smallest), compar_num);

if (N<=bins_not_full) {
  answer=(smallest+N-1)->number;
} else {
  answer=(smallest+(N%bins_not_full==0?bins_not_full:N%bins_not_full)-1)->number;
}
@
@<Find smallest bin not full@>=
while (smallest->capacity==low_cap&&smallest<bins+B) {
  smallest++;
  bins_not_full--;
}

@*Input/Output.
Input/output is done using the C standard library functions
|fopen|, |fprintf|, |fscanf|, and |fclose|.
We first use |fopen| to open the input and output files
specified by the problem statement, which are
{\tt tennisin.txt} and {\tt tennisout.txt}.
If we are testing our program on our local machine, we may
have forgotten to supply the input file, in which case
calling |fopen| to open it for reading results in an error.
If this happens, we need to exit gracefully rather than
running into a segmentation fault because |fopen|
return {\tt NULL}.
@d IN_FILE "tennisin.txt"
@d OUT_FILE "tennisout.txt"
@<Local variables@>=
FILE *in_file;
FILE *out_file;
@
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
if (in_file == NULL) {
  fprintf(stderr,"Unable to open input file %s\n", IN_FILE);
  exit(EXIT_FAILURE);
}
out_file = fopen(OUT_FILE, "w");
if (out_file == NULL) {
  fprintf(stderr,"Unable to open output file %s\n", OUT_FILE);
  exit(EXIT_FAILURE);
}
@ The problem statement tells us
how the data is formatted in the input
file for us to read.
The first two lines contain integers
$B$ and $N$, the number of bins and the
number of balls.
The second line contains $B$ integers, which
are the capacities of the bins.
@<Read the...@>=
fscanf(in_file, "%d %d\n", &B, &N);
for (int i = 0; i < B; i++) {
  bins[i].number=i+1;
  fscanf(in_file, "%d ", &bins[i].capacity);
}

@
@<Write the...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
