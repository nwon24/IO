@*Introduction. This program is a solution to a problem
from the 2017 Australian Informatics Olympiad called
{\bf Tag}.

The problem is fairly simple. A game of tag consists
of $N$ players, numbered from $1$ to $N$.
There are two teams: red and blue.
At the start, player $1$ is on the red team, and player $2$
is on the blue team, while the rest don't have a team.

During the game, those already on a team tag those not on a team,
and a person who has been tagged joins the team of their tagger.
Our job is to figure out how many players are in each team at
the end of the game. The game has $M$ tags that happen in order.
@c
@<Include files@>@;
int main(void)
{
    @<Local variables@>;
    @<Open the input and output files@>;
    @<Read the input data@>;
    @<Initialise the data structures@>;
    @<Calculate the answer@>;
    @<Write the answer to the output file and tidy up@>;
    return 0;
}
@*Getting the input. Let's first focus on the data structures
of our program.

To keep track of the number of people in each team, let's use
an array of $2$ elements: index $0$ will be the red team and
index $1$ will be the blue team.
It's useful to define these values as constants so that we don't
need to use the literal values |0| and |1| in our program.
@d RED_TEAM 0
@d BLUE_TEAM 1
@d NO_TEAM -1
@<Local variables@>=
int teams[2] = { 1, 1 };
@ How do we define a player of the game? The player of a game
is defined by two values: the team, and the number (from $1$ to $N$).
The number cn just be the index in the array, so we really only need
the |team| field in a struct. We might as well decare |players| to an
array of integers, but putting |team| in a structure makes our program clearer.
In terms of memory allocation, the problem statement guarantees us that
$N$ will not exceed $100000$, so we can statically allocate this array.
@<Local variables@>=
struct {
    int team;
} players[100005];

@ During initialisation we want to set all the |team| fields in
the |players| struct to |NO_TEAM| except for the first two.
@<Initialise the data structures@>=
for (int i = 0; i < N; i++) {
    if (i == 0) {
	players[i].team = RED_TEAM;
    } else if (i == 1) {
	players[i].team = BLUE_TEAM;
    } else {
	players[i].team = NO_TEAM;
    }
}
@ Now let's define a structure for each tag action that takes place.
Each action is specified entirely by two values: the number of the
tagger, and the number of the person being tagged.
@<Local variables@>=
struct {
    int tagger;
    int tagged;
} tags[100005];
@ Now we have all the pieces to read the input data from the input file.
We haven't looked at opening the input and output files yet, but assume
for the moment that we have declared two variables, |in_file| and |out_file|,
that point to the appropriate files as specified in the problem statement.
We will declare them later.

Then the matter of reading from the input file is quite simple. After
reading the first line to get $N$ and $M$, we simply
use |fscanf| to get the data into our |tags| array.
Remember that $M$ is the number of tags that occur during the game.
@<Read the...@>=
fscanf(in_file, "%d %d\n", &N, &M);
for (int i = 0; i < M; i++) {
    fscanf(in_file, "%d %d\n", &tags[i].tagger, &tags[i].tagged);
}
@*Calculating the answer. This may look like the meat and potatoes
of our solution, but most of the foundation has already been laid;
it is now just about putting everything together.

We now just loop over the |tags| array and update our |players|
and |teams| arrays accordingly.

The alert reading may be wondering why we didn't do the following
bit at the same time as when we read in the input data; that would
obviate the need for the |tags| array and allow us to use just a single
loop instead of two. That is correct; however, the author believes
that this way is better for clarity.
@<Calculate the answer@>=
for (int i = 0; i < M; i++) {
    teams[players[tags[i].tagger-1].team]++;
    players[tags[i].tagged-1] = players[tags[i].tagger-1];
}
@ We have conveniently forgotten to define the local variables $M$ and $N$.
@<Local variables@>=
int N;
int M;
@*Input/output. The boring part of the program is opening and closing files.
However, the C standard library makes that job fairly easy. Let's first
define symbolic constants for the names of the input and output files.
@d IN_FILE "tagin.txt"
@d OUT_FILE "tagout.txt"
@ Here we declare two local variables we have already seen before: |in_file|
and |out_file|.
@<Local variables@>=
FILE *in_file, *out_file;
@ Opening the files is a simple call to |fopen|. Normally we would do
error checking but as our code is meant to run on remote judging machines
we can just assume the files exist and have the correct permissions to be
opened, read from, and written to.
@<Open...@>=
in_file = fopen(IN_FILE, "r");
out_file = fopen(OUT_FILE, "w");
@ Writing the answer requires writing the two values |teams[RED_TEAM]|
and |teams[BLUE_TEAM]| to the output file. Then we close both |in_file|
and |out_file| to tidy everything up.
@<Write...@>=
fprintf(out_file, "%d %d\n", teams[RED_TEAM], teams[BLUE_TEAM]);
fclose(in_file);
fclose(out_file);
@*Include files. The last thing to do is to include the necessary
header files to make the compiler happy. We have only uesd C standard
input and output routines; the |stdio.h| header should suffice.
@<Include files@>=
#include <stdio.h>
@*Index.
