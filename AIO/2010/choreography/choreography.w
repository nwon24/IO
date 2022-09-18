@*Introduction. This program solves a problem
from the 2010 Australian Informatics Olympiad
named {\bf Choreography}. Its problem statement
may be found at {\tt orac2.info/problem/aio10choreo}.

Here is the essence of the problem. There is a
dance routine consisting of $D$ dancers.
 Each dancer has a unique number
between $1$ and $D$.
The dance routine consists of $T$ hula hoop
throws. In each throw, some dancer, perhaps
dancer $i$, throws a hula loop to another
dancer, perhaps dancer $j$. To throw a hula
loop, a dancer must have at least $1$ hula
hoop intheir possession.

Our job is to {\it determine the minimum number
of hula hoops required} given a particular
dance sequence and a number of dancers.
@c
#include <stdio.h>

@<Global variables@>@;
int main(void)
{
  @<Open the input and output files@>@;
  @<Read the input data from the input file@>@;
  @<Calculate the minimum number of hula hoops required@>@;
  @<Write the answer to the output file@>@;
  @<Close all files@>@;
  return 0;
}
@*The algorithm. The solution to this problem
is fairly straightforward.

In the best case, every single time there is
a throw, the dancer throwing the hoop has a hoop
in their possession. However, at the start we
assume that no dancer has any hoop. Then as we
go through the sequence of throws, whenver a dancer
does not have a loop but needs to throw it, we
add $1$ to the number of hoops needed. This works
because by throwing a hoop when a dancer has one,
we are not `wasting' any hoops. So by assuming
there are no hoops at the beginning and then adding
them when absolutely required, we are optimising
the number of hoops in use.
@ We will need only a few global variables to solve
this problem.

We will of course need to variables $D$ and $T$ to
hold the number of dancers and the number of throws
in the routine.

To keep track of the number of hoops each dancer has,
let's declare an array called |dancers|. The value
of |dancers[i]| will be the number of hoops dancer
$i+1$ has (recall that arrays are zero-indxed in C).

Then we also need a variable called |answer|, which will
hold the minimum number of hoops required. We will
increment this variable when a dancer needs to
throw a hoop but doesn't have one.

To encode the throws, we could have two arrays, one
for the throwers and one for the receivers. However, to make
it a bit simpler, let's declare a simple structure to
encode a throw. Note that we are calling it |a_throw| because
|throw| is a reserved keyword in C++.
@<Global variables@>=
struct a_throw {
  int thrower;
  int receiver;
};
int dancers[100005];
struct a_throw throws[100005];
int answer;
int D;
int T;
@ Given the variables and a high-level overview of
our algorithm, here is the part of our code that
solves the problem.

We don't need to initialise |answer|, as it is
a statically allocated global variable. It is guaranteed
by the C standard that |answer| be initialised to $0$
at the beginning of the program.
@<Calculate...@>=
for (int i = 0; i < T; i++) {
  if (dancers[throws[i].thrower-1] == 0) {
    answer++;
  } else {
    dancers[throws[i].thrower-1]--;
  }
  dancers[throws[i].receiver-1]++;
}
@*Input/output. File input and output in C
is done through its standard library. There are a plethora
of functions to do input and output. We will use the
most common: |fopen| and |fclose| for opening/closing files,
and |fscanf| and |fprintf| for reading/writing files.

Let's declare the two file pointers that will refer
to the input and output files. The variable |in_file| will
point to the input file ({\tt dancein.txt}) and the variable
|out_file| will point to the output file ({\tt danceout.txt}).
@<Global variables@>=
FILE *in_file;
FILE *out_file;
@ Opening the files is fairly straightforward. We open
the input file with |"r"| permissions, which is for reading
only, and we open the output file with |"w"| permissions,
which is for writing only. Note that opening a file with
writing permissions erases everything that was in the file
previously.
@<Open...@>=
in_file = fopen("dancein.txt", "r");
out_file = fopen("danceout.txt", "w");
@ Closing the files is even easier.
@<Close...@>=
fclose(in_file);
fclose(out_file);
@ Now we turn our attention to getting the input data
from the input file and writing our answer to the output
file.

Let's first tackle the output, as that is easier. It consists
of a single call to |fprintf|, as our answer is a single
integer.
@<Write...@>=
fprintf(out_file, "%d\n", answer);
@ Reading the input data from the input file is slightly
trickier. The problem statement tells us that the input file
begins with a line containing two integers: $D$ and $T$.
Then the next $T$ lines contain two integers each. These
lines have the number of the thrower followed by the number
of the receiver for each throw.
@<Read...@>=
fscanf(in_file, "%d %d\n", &D, &T);
for (int i = 0; i < T; i++) {
  fscanf(in_file, "%d %d\n", &throws[i].thrower, &throws[i].receiver);
}
@*Index.