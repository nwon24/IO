\input eplain
@*Space Mission.
This is a problem from the 2021 Australian Informatics Olympiad.

The problem consists of maximising the number
of gas samples collected from a star.
There are |N| days in which the probe must have
launched and returned.
The launch day cannot be the same as the return day.
For day |i|, the probe requires $C_i$ units of
fuel, whether launching or returning.
Each day, the probe collects one gas sample.
The probe only has |F| units of fuel.
The idea of the problem is to maximise the number
of gas samples collected without using more than
|F| units of fuel.
There is also the possibility that there is not
enough to launch and return on any day.

For more information about the problem, go
\href{https://orac2.info/problem/aio21space/}{{\bf here}}.
The solution presented here can be also found
in the editorial for the 2021 AIO.
The language used there was Python; this is basically
a translation into C.

@ Here is the high level overview of our |main| routine.
Most of it will be filled in later because it
concerns reading and writing to/from the input/output files.
The program is small enough that it can be contained inside
the |main| routine; this is why we can have local variables instead
of global variables.
@c
@<Include files@>;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files and read the input@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close both files@>;
  return 0;
}

@ Before tackling the problem, let's define a few variables
we'll need and constants.
Firstly, the maximum value of |F| is $100000$,
so the array |C| of fuel requirements for day |i| need only
be that big (no dynamic allocatio needed).
We also need variables |N| and |F| to store the number of
days, and the amount of fuel available.
We'll also need a variable to store the answer.
@d DAYS_MAX 100000
@<Local variables@>=
int N, F;
int C[DAYS_MAX];
int answer = -1;

@ Let's take a look at how to solve this problem.
The brute-force way is to look at combinations
of two days from |N| and see which one has the
largest number of days in between without exceeding the limit.
However, this is incredibly slow.

We should realise that our launch day must be a day
such that all days preceding it use more fuel.
This is because if a day before our launch day uses
less fuel, then we can move our launch day to that day
and thus increase the number of samples we collect.
The same is true for the return day.
If any day after our return day uses less fuel, then
we can extend our return day and also increase the
number of samples we collect.

Our solution can be broken down into a few parts.
Firstly, we find all valid starting and ending points
and store them in new arrays.
For the ending points array, we want it to be in
ascending order, just like the starting points array,
but reversing it would cost too much time.
Instead, we just need to loop backwards over it to
simulate looping forwards over the reversed array.

To calculate the answer, we need two loops.
We iterate over the array of endpoints, and check
if the currently selected starting point is valid
(that is, the sum of the two indicies' values is
less than or equal to |F|).
If a start point and end point pair is valid, we
check if it is longer than the current answer,
updating |answer| if that is the case.
At the end of the loop, if |answer=1|, this means
the best launch and return day is the same day;
however, this is not allowed, so the answer
is |-1| in that case.

@<Calculate the...@>=
@<Variables for calculating the answer@>;
@<Find all start points@>;
@<Find all end points@>;
@<Loop through the end points to find the answer@>;

@ We need a few local variables to calculate the answer.
Firstly, we define a structure to encode the starting
and ending points. Each structure has two fields:
one for the index of the starting point, and one for
the value (the fuel needed) of that index.
To avoid dynamic memory allocation and all the mess
that goes along with it, we allocate static arrays
that are as big as the maximum allowed input array
size, which is |DAYS_MAX|.

We also need two variables to be indexes into
the |start_points| and |end_points| arrays.
@<Variables for calculating the answer@>=
struct point {
  int index;
  int val;
};
struct point start_points[DAYS_MAX];
struct point end_points[DAYS_MAX];
int start_index = 0;
int end_index = 0;

@ To find all valid starting points, we simply
loop over the array and if the value is less
than the previously appended starting point's
value, then we append this starting point as well.
@<Find all start...@>=
for (int i = 0; i < N; i++) {
  if (start_index == 0 ||
      C[i] < start_points[start_index-1].val) {
    start_points[start_index].index = i;
    start_points[start_index].val = C[i];
    start_index++;
  }
    
}
@ A similar algorithm is used for the end points.
The difference here is that we find the points
in descending order, so we must loop backwards
when we try to find the longest pair of start
and end points.
@<Find all end...@>=
for (int i = N-1; i >= 0; i--) {
  if (end_index == 0 ||
      C[i] < end_points[end_index-1].val) {
    end_points[end_index].index = i;
    end_points[end_index].val = C[i];
    end_index++;
  }
}

@ Here is the core of our algorithm to find
the answer.
We loop backwards over |end_points| and check for
the longest valid distance between start and end points.
The variable |prev_start| holds the previous best
starting point so we can check whether it is still
the best or is still valid given the end point we
are currently dealing with (remember that it is not
valid if the fuel for the start point plus the
fuel for the end point exceeds |F|).
@<Loop through...@>=
int prev_start = 0;
for (int i = end_index-1; i >= 0; i--) {
  while (prev_start < start_index &&
         end_points[i].val + start_points[prev_start].val > F)
    prev_start++;
  if (prev_start < start_index &&
      end_points[i].val + start_points[prev_start].val <= F) {
    int tmp = end_points[i].index - start_points[prev_start].index + 1;
    if (tmp > answer)
      answer = tmp;
  }
}
if (answer == 1)
  answer = -1;
@*Input and output.
The first thing we need to do is define the constants
for the input/output file names and declare the local
file pointers.
@d IN_FILE "spacein.txt"
@d OUT_FILE "spaceout.txt"
@<Local variables@>=
FILE *in_file, *out_file;

@ We open the files using |fopen|, then read the input
data using |fscanf|.
Recall that the first line of input contains |N|
followed by |F|, and the next |N| lines contain
the values of the array |C|.
@<Open the...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");
fscanf(in_file, "%d %d\n", &N, &F);
for (int i = 0; i < N; i++)
  fscanf(in_file, "%d\n", &C[i]);

@ Writing the answer is easy as it is only a single
number.
@<Write the...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdio.h>
