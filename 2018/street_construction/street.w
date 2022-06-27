\input eplain
@ This is {\it Street Construction}, a problem from
the 2018 Australian Informatics Olympiad.

The problem consists of dividing a new street into parks
and houses.
A group of consecutive houses is called a `block.'
Give the number of chuncks of land on the street
and the required number of parks to be built, we need to
find the minimum possible size of the largest block.

The input consists of two integers, |N| and |K|.
The number |N| will be the number of chunks of land;
the number |K| will be the number of parks that are
to be built.

For more information about the problem, see its problem statement
\href{https://orac2.info/problem/aio18street/}{{\bf here}}.

@ As usual, the structure of our program is to first get the
input data from the specified input file, calculate the answer,
and then write the answer to the specified output file.
@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input file to get the data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@ Let's try working how to get the answer
before dealing with the input/output operations, which
are really just administrative things.
What we know is that |N| is the number of chunks of land,
and |K| is how many parks are to be built.
Thus we know that there will be |N-K| chunks of land
on which there will be houses.

To minimise the length of the largest block of land, we
shouldn't have consecutive chunks of land with parks on them;
rather, we should have parks put alternately between houses
for as much as possible.
As long as this is possible, the minimum possible size of
the largest block will be 1.
However, it is most likely that there will be left over.
That is, we will run out of parks and the final chunks of land
will be taken up by a block of houses.
This is not the answer, since we can distribute those houses
between parks again.
Once we distribute the left over houses, the size of final block
will be the answer.
Of course, in the special case where |K=N|, the answer is 0, as
no houses can be built.

In the following section, we will denote {\it H} to be a house
and {\it P} to be a park.

For example, consider the case where |K=2| and |N=5|.
In this case, we can put a park between every house, like so:
\it
HPHPH\rm. In this case the answer is 1.
If |K=3| and |N=5| the answer is still 1 since a house can
be put between every house, thusly: 
\it PHPHP\rm. The minimum size of the largest block is still 1.
Thus when |K>N/2| the answer is 1, because if there are more parks
than houses to be built, then every house can be sandwiched
between two parks and thus the minimum size of the largest block is 1.

Now if we consider the case where |K=2| and |N=7|.
We can no longer put a park between every house or vice versa,
but we can try for as long as possible: \it HPHPHHH\rm.
Thus we have a block of 3 at the end as the largest block.
To get the minumum size of the largest block, we can distribute
one of the houses from the last block to get the largest block
being only of size 2, and this is the answer.
In this case, we notice that |2=(3+1)/2|.

However, if the |N=6|, the trailing block would be of size 2.
In this case, if we distribute one of the houses as before,
there would be another block of size 2.
So the answer is still 2.

We can see that we just need to distribute the trailing
houses among the blocks the size of one of the sandwiched blocks
is greater than that of the remaining trailing houses.
But then we can see that this is just a matter of determining
what block size we can use to sandwich blocks between every pair of parks
such that the size of any block does not differ from the size of any
other block by more than 1.
This calculation is fairly simple.

We see that for |K| parks, there are |K+1| spots to sandwich blocks, because
we include the start position.
So the answer is simply the number of houses, |N-K|, divided by |K+1|.
When that quotient is not a whole number we need to add 1 since integer
divison truncates.
For example, if |N=17| and |K=4|, there are |4+1=6| spots to put blocks in.
The number of houses is |17-4=13|.
If we just do |13/5|, we get 2, since the answer is between 2 and 3.
So the answer is actually 3, because some blocks will have 2 houses and other
will have 3; the problem is looking for the size of the largest block.

@<Calculate the answer...@>=
if (K == N) {
  answer = 0;
} else if (K >= N/2) {
  answer = 1;
} else {
  int houses; /* number of houses */

  houses = N-K;
  if (houses%(K+1) == 0) {
    answer = houses/(K+1);
  } else {
    answer = houses/(K+1)+1;
  }
}


@ As usual the input and output file names are constant.
@d IN_FILE "streetin.txt"
@d OUT_FILE "streetout.txt"

@
@<Local variables@>=
FILE *in_file, *out_file;

@ We open the files using the C standard library procedure |fopen|.
@<Open the input...@>=
in_file = fopen(IN_FILE, "r");
if (in_file == NULL) {
  printf("I can't find input file %s\n", IN_FILE);
  exit(1);
}
out_file = fopen(OUT_FILE, "w");

@ We close the files using the C standard library procedure |fclose|.
@<Close the input...@>=
fclose(in_file);
fclose(out_file);

@ Let's declare some variables to hold our input data and answer.
Remeber that |N| is the number of chunks of land, and |K| is the
number of parks to be built.
@<Local variables@>=
int N, K, answer;

@ The input file consists of only a single line that contains
|N| and |K|, separated by a space.
We use |fscanf| to easily get the data.
@<Read the input file...@>=
fscanf(in_file, "%d %d\n", &N, &K);

@
@<Write the answer...@>=
fprintf(out_file, "%d\n", answer);

@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>

