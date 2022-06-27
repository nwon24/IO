@*Social Distancing.
This is a problem from the 2021
Australian Informatics Olympiad.

The problem consists of |N| hippopotami
being invited to a banquet.
There are |N| meals, and meal {\sl i}
is placed $D_i$ metres along the street.
Social distancing requirements state
that each hippo must stay at least |K|
netres away from every other hippo.
This means that if two meals are less
than |K| metres from each other, they cannot
both be eaten.
Our program needs to calcuate the maximum
number of hippos that can be invited given
the number of hippos, and the distance of
the meals along the street, and the social
distancing requirement.
@c
@<Include files@>@;
@<The |compar|...@>;
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

@ This problem looks more difficult
than it actually is.

We just need to realise that an optimal
solution always takes the first meal
available.
To prove this, consider an optimal solution
that does not take the first meal. In this
solution, a certain number of hippos are
invited. If the solution does not take the
first meal, it obviously takes some meal
further along the street. However, it
could easily have taken the first meal
(without changing any of the other hippo locations),
and the resulting number of hippos that are
inviited remains the same, because we have
just shifted the first meal taken back to
the start of the street.
Thus our solution is still optimal when we
take the first meal.

Now that we have established this, it becomes
clear that just taking the first meal we can
creates the optimal solution. By taking the
first meal along the street, we then try to
find the maximum number of hippos that can
be invitied for the remaining part of the street;
this is just a smaller version of the same problem.
Thus we can take the first meal of that smaller
street, which is the same as taking the first meal
we can after our previous one.

This proves that a greedy algorithm gives the
answer to this problem.

Here are the variables that we need to compute
the answer.
We need the input variables |N| and |K|, which
are the number of hippos and the minimum distance
between any two hippos respectively.
We also need an array |D|, which holds the distances
of the meals from the beginning of the street.
Finally, we need a variable to hold the answer.
@d MAX_HIPPOS 100000

@<Local variables@>=
int N, K;
int D[MAX_HIPPOS];
int answer;

@ After initialising |answer| and sorting |D|
in ascending order, we simply loop
over the array |D| to find the first meals we
can, incrementing |answer| for each hippo we
can invite.

The variable |last| refers to the location
of the last meal we encountered; this is what
we compare with in terms of distance to the next
valid meal.
@<Calculate the...@>=
int last = 0;
answer = 0;
@<Sort the input array@>;
for (int i = 0; i < N; i++) {
  if (i==0 ||
      D[i] - last >= K) {
    answer++;
    last = D[i];
  }
}

@ Sorting the array takes a bit more effort.
We use the C standard library |qsort|, but
that requires us to write our own |compar|
function to compare two integers.
@<Sort the...@>=
qsort(D, N, sizeof(int), compar);

@ Our |compar| function is really simple
because we're just comparing integers.
The only painful bit is all the type casting,
because the function is expected to take
arguemtns of type |void *|.
@<The |compar| procedure@>=
int compar(const void *p1, const void *p2)
{
  if (*(int *)p1 < *(int *)p2) /* p1 goes before p2 */
    return -1;
  if (*(int *)p1 == *(int *)p2) /* p1 equivalent to p2 */
    return 0;
  if (*(int *)p1 > *(int *)p2) /* p1 goes after p2 */
    return 1;
}
@*Input/output.
The problem statement gives us the input
and output files, which are perhaps
confusing called {\tt distin.txt} and
{\tt distout.txt}.
We will also need two variables to
reference the input and output files.
These variables are of the type pointer
to |FILE|; they will be passed to the
various |fscanf| and |fprintf| calls.
@d IN_FILE "distin.txt"
@d OUT_FILE "distout.txt"
@<Local variables@>=
FILE *in_file, *out_file;
@ Using |fopen| to open the input and
output files, we could run into an error;
perhaps the file is not found.
This wouldn't happen on the judges' computer,
but it could happen when we are testing it,
so we still need to make sure our program
exits gracefully if |fopen| returns NULL.
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

@ Reading the input data from the input file
is slightly trickier.
The problem statement tells us that the first
line contains two integers, |N| and |K|, separated
by a space.
The next |N| lines then contain a single integer,
with form the elements of the array |D|.
@<Read the input...@>=
fscanf(in_file, "%d %d\n", &N, &K);
for (int i = 0; i < N; i++) {
  fscanf(in_file, "%d\n", &D[i]);
}
@ There is only a single number to
write to the output file, so the
call is fairly straightfoward.
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