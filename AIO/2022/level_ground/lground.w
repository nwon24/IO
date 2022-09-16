@*Introduction. This program is a solution to
{\it Level Ground}, a problem from the 2022 Australian
Informatics Olympiad. The problem is the second problem
on the paper.

As with many other AIO problems, there is a story to
the problem, although quite mercifully it is not as convuluted and as complicated
as some others have been.

The basic story is that there is a mountain range consisting of
$N$ segments, with the $i$-th segment having an altitude
of $A_i$ kilometres, and our job is to organise a race over
that mountain range. The race must be over a contiguous block
of segments, and each segment in the race must have the same altitude.

The {\it intensity} of a race is defined to be the altitude multiplied
by the number of segments. For example, a race consisting of $3$ segments,
each with an altitude of $2$ kilometres, has an intensity of $6$.

Given the segments and the height of each segment, our job is to
determine the maximum intensity a valid race can have.
@c
#include <stdio.h>

@<Global variables@>@;
int main(void)
{
  @<Open the input and output files@>@;
  @<Read the input data from the input file@>@;
  @<Calculate the maximum intensity that can be achieved@>@;
  @<Write the answer to the output file and close all files@>@;
  return 0;
}
@*Example. Let's start with an example to get a feel for the problem.
Suppose $N=7$ and the segment heights were $3$, $2$, $1$, $2$, $2$, $2$,
and $1$.

There are $4$ possible races that can be made with these segments (remember
that the a race must be across contiguous segments and each segment must
have the same height). The first race has intensity $3\times1=3$,
the second $2\times 1=2$, the third $1\times 1=1$, the fourth
$2\times3=6$, and the fourth $1\times 1=1$. Thus the maximum intensity
that can be achieved is the intensity of the fourth race, which is $6$.

Further examples can be found at {\tt orac2.info/problem/aio22ground/statement.pdf}.
@*Solving the problem. This problem is fairly straightforward. Given
the constraints of a race, we only need a single pass through an array
of segment heights, finding the longest contiguous sequence of equal heights
that constitutes a race. Then we calculate the intensity of that race, compare
it with our current maximum, and update our current maximum if the intensity
is greater.

Let's first define a few variables to hold our input data.
For a bit of parallelism with the problem statement, let |N| be
the number of segments and |A| be an array containing the height
of each segment, where |A[i]| holds the height of segment $i+1$.
We will also need a variable |answer| to hold our answer, the highest
intensity that can be achieved.
@<Global variables@>=
int N; /* The number of segments */
int A[100005]; /* The height of each segment */
int answer; /* The highest intensity that can be achieved */
@ We can calculate the answer with a single loop. On every iteration
of the loop we find the next race, calculate its intensity, and then
compare this value with our current maximum intensity.
@<Calculate the maximum...@>=
answer = 0;
for (int i = 0; i < N;) {
  @<Local variables for inner loop@>@;
  @<Calculate |height| and |length| for next race@>@;
  intensity = height * length;
  if (intensity > answer)
    answer = intensity;
}
@ For our inner loop, we need three local variables. We need
a variable to hold the race's intensity, its' height (the height
of each segment in the race), and it's length (the number of
segments that make up the race).
@<Local variables for...@>=
int height;
int intensity;
int length;
@ Finding the length of the next race is simply a matter of looping
over |A| while |A[i]==height|. We can initialise |height| simply
by setting it equal to |A[i]| before the loop.

At the end of the |while| loop, either |A[i]!=height|, or we have
reached the end of the array |A|; in either case nothing needs
to be done to the index variable |i| to set it up for the next iteration.
@<Calculate |height|...@>=
height = A[i];
length = 0;
while (i < N && A[i] == height) {
  i++;
  length++;
}
@*Input/output. This program requires only simple input/output
mechanisms. We need to be able to open, read, write, and close files.
Luckily, the C language (or, more precisely, the C standard library)
provides convenient functions to perform file input and output.

Let's declare two variables, |in_file| and |out_file|, that will be
used to point to the physical input and output files.
@<Global variables@>=
/* The input file */
FILE *in_file;
/* The output file */
FILE *out_file;
@ Opening the input and output files requires two calls to |fopen|.
Normally we would do error checking here, to make sure that |fopen|
does not return a bad value. However, as the input and output files
are supplied by the remote judging machine on which our program is
going to be run and tested, we can safely assume that the input and
output files as specified by the problem statement will exist and
can be opened with the appropriate permissions for input and output.
@<Open...@>=
in_file = fopen("groundin.txt", "r");
out_file = fopen("groundout.txt", "w");
@ The input file consists of two lines. The first line contains
a single integer, |N|. The second line contains |N| integers,
the $i$-th of which is $A_i$, or the height of the $i$-th segment.
We can efficiently read this information into memory using |fscanf|.
@<Read...@>=
fscanf(in_file, "%d\n", &N);
for (int i = 0; i < N; i++) {
    fscanf(in_file, "%d ", &A[i]);
}
@ We have only one integer to write to the output file, so the code
for this is not particularly complicated; as such, we can throw in
the two calls to |fclose| that close the input and output files as well.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@*Index.