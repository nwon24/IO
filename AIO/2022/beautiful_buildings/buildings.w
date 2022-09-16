\input eplain
@*Beautiful Buildings. This program solves a problem from
the 2022 Australian Informatics Olympiad (AIO). The problem
is the fourth problem on the paper.

The problem consists of minimising the {\it ugliness} of
a set of $N$ buildings that are numbered from $1$ to $N$
left to right. The $i$th building has a height of $H_i$.
The ugliness of the set of buildings is defined to be:
$$\sum_{i=1}^{N-1} ^^7c H_i-H_{i+1}^^7c$$
The job of our program is to determine what the minimum
ugliness is if we are allowed to change the height of
only a single building.
@c
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

@<Global variables@>@;
@<Functions@>@;
int main(void)
{
  @<Open the input and output files@>@;
  @<Read the input data from the input file@>@;
  @<Calculate the minimum ugliness of the set of buildings@>@;
  @<Write the answer to the output file and close all files@>@;
  return 0;
}

@*An example. Before we tackle how to solve the problem, let's
get our feet wet with an example. (This example was taken from
the problem statement itself, and forms one of the sample test cases.)

Let's say there were $6$ buildings, with heights of $80$, $60$, $10$,
$40$, $70$, and $20$. The ugliness can be calculate as follows.
$$^^7c 80-60^^7c +^^7c 60-10^^7c +^^7c 10-40^^7c +^^7c 40-70^^7c +^^7c 70-20^^7c =180$$
We can then change the height of the third building to $50$, so that
the ugliness is:
$$^^7c 80-60^^7c +^^7c 60-50^^7c +^^7c 50-40^^7c +^^7c 40-70^^7c +^^7c 70-20^^7c =120$$

Further examples and solutions can be found in the 2022 AIO paper,
or at the online version of the problem statement. This can be found
at {\tt orac2.info.problem/aio22buildings/statement.pdf}.
@*Solving the problem. Now let's tackle how to solve the problem.
We can worry about the tedious task of input and output later.

The first thing to note is that for a building in the middle (that is,
a building not numbered $1$ or numbered $N$), if either building to
the left or right is taller than it, the ugliness of the three buildings
together cannot be lowered by making that building taller or shorter.
More precisely, for building $i$, if $H_{i-1}>H_{i}$ and $H_{i+1}<H_i$,
or $H_{i-1}<H_i$ and $H_{i+1}>H_i$, then the ugliness of the three
buildings can be be made no smaller than its current value of
$^^7c H_{i-1}-H_i^^7c$.
(To see why this is true, refer to the previous example, and try to
change the ugliness of the buildings by changing the the building numbered
$2$, with the height of $60$.)

Thus to change the ugliness by changing the height of a building in
the middle, it must be a building that is shorter than the two buildings
on etiher side, or taller than the two buildings on either side.

The second thing to note is that changing the height of either end
building changes the ugliness, regardless of whether it is shorter
or taller than the next or previous building. This is because
the buildings at the end have only a single neighbour.
(Again, to test this out,
refer to the previous example).

Now that we know how the ugliness changes, we need to figure out how
to know which building to change such that the ugliness is minimised.
What we need to do is for each building that is able to change
the ugliness, calculate the difference between its current ugliness
and its {\it best ugliness}. Its best ugliness can be achieved by
making it the same height as either the building on the left or
the building on the right. To illustrate, let the building in
consideration be building $i$.

The current  ugliness of buildings $H_{i-1}$, $H_i$, and $H_{i+1}$ is given by
$$^^7c H_{i-1}-H_i^^7c+^^7c H_{i}-H_{i+1}^^7c.$$
This follows from the definition of the ugliness of the set of buildings.

The three buildings' best ugliness occurs when $H_i=H_{i+1}$ (or
$H_i=H_{i-1}$); this means the best ugliness is
$$^^7c H_{i-1}-H_{i+1}^^7c.$$

Then we just need to find the difference between these two ugliness
values. We are looking for the maximum difference between the two values,
as that would mean our overall ugliness is minimised. Once we know
which building to change, calcuating the minimum ugliness is a simple
matter of changing the height in the array and calling a function to
calculate the value.
@ OK, now we have figured out that our solution can be broken into
two stages. First, find the building we want to change. Then, calculate
the ugliness based on a change in height of that building.
@<Calculate...@>=
@<Find the building to change@>@;
@<Change the building height and calculate ugliness@>@;
@ To find the building to change, we first see if the building can
be changed; that is, if the building is shorter than both of its
neighbours (we don't need this step for the first and last buildings).
Then we can calulate the current ugliness and the best ugliness
of the building in consideration
and its two neighbours. We keep
the number of the building to change in |building_to_change|, and
the current maximum difference between best ugliness and current ugliness
in |max_diff|.
If the difference of the current building's best ugliness and
current ugliness is greater
than that of the currently selected building to change, we
update the two variables |building_to_change| and |diff|.

For the following code, assume we have declared an array |H| to hold
the heights of the buildings and an integer |N| to hold the number
of buildings.

@
@<Find the building to change@>=
int max_diff; /* Maximum value of $^^7c H_i-H_{i+1}^^7c$ so far */
int building_to_change; /* The building we want to change */

building_to_change=1;
max_diff=abs(H[0]-H[1]);
for (int i=1; i<N-1; i++) {
    if (@<Check if building...@>) {
        /* Calculate difference between best and current ugliness */
        int diff = abs(H[i-1]-H[i])+abs(H[i]-H[i+1])-abs(H[i-1]-H[i+1]);
        if (diff > max_diff) {
	   max_diff = diff;
	   building_to_change=i+1;
	}
    }
}
if (abs(H[N-1]-H[N-2]) > max_diff) {
   max_diff = abs(H[N-1]-H[N-2]);
   building_to_change = N;
}
@ The following piece of C code looks complicated, but it is really
doing only a simple check to see if changing the height of building $i$
will affect the overall ugliness.
@<Check if building is taller or shorter than both neighbouring buildings@>=
(H[i]<H[i-1]&&H[i]<H[i+1]) || (H[i]>H[i-1]&&H[i]>H[i+1])

@ Now we can change the ugliness by changing the height of the selected
building. If the building is the first or last one, we change the height
to the height of the next (or previous) building; that way, the first (or last)
absolute value expressions becomes $0$.

If the building is in the middle, changing its height so that it is as tall
as either its left neighbour or its right neighbour is the way to minimise
the set of building's ugliness. Remember that our variable |building_to_change|
is the number of the building, so we need to subtract $1$ from it to
get the index in the array.

Here we use the function |ugliness| to get the ugliness of the set of buildings;
we will define it later.
@<Change the building height...@>=
if (building_to_change == 1) {
   H[0] = H[1];
} else if (building_to_change == N) {
   H[N-1] = H[N-2];
} else {
   H[building_to_change-1]=H[building_to_change];
}
answer = ugliness(H);
@ Calculating the ugliness is fairly easy. We just need to loop over the array
given and calculate the absolute values.
@<Functions@>=
int ugliness(int *heights)
{
  int sum = 0;
  for (int i = 0; i < N-1; i++) {
    sum += abs(heights[i]-heights[i+1]);
  }
  return sum;
}
@ We have used several global variables. Let's declare them now.

We have used the variable |N| to hold the number of buildings,
|H| to hold the buildings' heights, and |answer| to hold our
answer (the minimum ugliness that can be achieved).
@<Global variables@>=
int N;
int H[100005];
int answer;
@*Input/output. Here is the tedious part of the program. If you
are not interested in how we get the input data from the input file
or our answer to the output file, you can stop reading.

File input/output in C is done through its standard library, which
provides the functions |fopen| and |fclose| to associate and disassociate
files with file pointers. We just need to remember to use the correct
permissions.

Let's define two variables which will point to the input and output files.
@<Global variables@>=
FILE *in_file;
FILE *out_file;
@ Usually a good programmer would include error checking in the following
calls to |fopen|; however, as we are running this code on a remote judging
machine, we can just assume that the files specified by the problem statement
exist and can be opened with the appropriate permissions.
@<Open...@>=
in_file = fopen("buildin.txt", "r");
out_file = fopen("buildout.txt", "w");
@ The problem statement tells us that the input file contains two lines.
The first line contains the integer |N| (the number of buildings), and the
next line contains |N| integers separated by spaces. These integers are the heights
of the buildings.

Given this structure, it is easy to get the input data from |in_file| using
the C standard library function |fscanf|.
@<Read...@>=
fscanf(in_file, "%d\n", &N);
for (int i = 0; i < N; i++) {
  fscanf(in_file, "%d ", &H[i]);
}
@ Writing the answer to the output file is even easier because it is just a single
integer.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
@*Index.
