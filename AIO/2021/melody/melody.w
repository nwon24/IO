@*Melody. This is a problem from the 2021
Australian Informatics Olympiad.

In this problem, songs are a sequence
of a certain number of notes, called |N|.
It is guaranteed that |N| will always be
a multiple of 3.
Each number in the sequence of notes
is guaranteed to be between |1| and |K|.
A song is considered {\sl nice}
if and only if it consists only of the same
three notes being repeated.

For example, the song
{\bf 1 2 3 1 2 3 1 2 3} is nice because
the sequence {\bf 1 2 3} is being repeated
over and over again.

Given a sequence of |N| notes, our program
needs to determine the minimum number of
notes that need to be changed so that a
song is nice.

@c
@<Include files@>@;
@<Global variables@>@;

@<Procedure...@>@;

int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input data@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file@>;
  @<Close the input and output files@>;
  return 0;
}

@*Solving the problem.
To solve this problem, we can separate
out each sequence of 3 notes into 3 arrays.
Thus the first array will contain all the first notes
in each sequence of 3, the second will contain
all the second notes, and the third will contain
all the third notes.
For a song to be considered nice, each array
has to consist of only a single distinct note.

Therefore, to make a song nice, we just need
to change the least number of notes in each
array so that all the notes are the same in that array.
We change the least number of notes when we
change notes that are not the mode to the mode.

The first thing we need to do is define
the variables to hold our input data.
We will need two variables to hold the |N|
and |K| values, and three arrays to hold
the first, second, and third notes respectively
of each sequence of three.

@d MAX_NOTES 99999
@d MAX_NOTE_VALUE 100000

@<Global variables@>=
int N, K;
int note1[MAX_NOTES/3];
int note2[MAX_NOTES/3];
int note3[MAX_NOTES/3];

@ Our algorithm for calculating the mode relies
on a very simple table.
We have an arrray that stores the occurances
of a particular number at that index.
For example, the number of times the note |1|
appears in an array is stored in index |1|
of our (very simple) hash table.

To reduce the memory needed, we dynamically
allocate our hash table depending on the value
of |K|.

Note that we do not return the mode itself,
but rather the number of occurances of the mode.
@<Procedure for calculating mode@>=
int mode(int *arr, int size)
{
  int *hash;
  int mode;

  hash = (int *)calloc(K+1, sizeof(int));
  if (hash == NULL) {
    @<Report calloc return NULL and exit@>;
  }
  mode = 0;

  @<Loop over |arr| and update hash table@>;
  free(hash);
  return mode;
}

@ Looping over the array, we simply increment
the value in the appropriate index of the hash table.
If that value is greater than the current mode frequency,
then we have a new modal frequency.
@<Loop over |arr|...@>=
for (int i = 0; i < size; i++) {
  hash[arr[i]-1]++;
  if (hash[arr[i]-1] > mode)
    mode = hash[arr[i]-1];
}

@ The function call to |calloc| shouldn't fail
under normal circumstances, but if it does we
should catch it.
@<Report calloc...@>=
fprintf(stderr, "ERROR: calloc returned NULL\n");
exit(EXIT_FAILURE);

@ Now that we have a function to calculate the
frequency of the modal value of each array, we
can actually calculate the answer.

We know that each of our three arrays will be
of size |N/3|.
All we need to do is to get the mode frequency
by calling |mode|, and the number of notes
we need to change in that array is the size
of that array (|N/3|) take away that mode frequency.
Adding up the number of notes we need to change
in each array gives us the answer.
@<Calculate the...@>=
int len; /* length of each array */
int mode_freq; /* mode frequency */

answer = 0;
len = N/3;
mode_freq = mode(note1, len);
answer += len - mode_freq;
mode_freq = mode(note2, len);
answer += len - mode_freq;
mode_freq = mode(note3, len);
answer += len - mode_freq;

@ Looking at the above code, we realise we
haven't declared a variable to actually hold
our answer.
We rectify that here.
@<Local variables@>=
int answer;

@*Input/output.
The input and output file names are given to
us in the problem statement; we give them
symbolic names so that they are out of the way
and we are not confused by them.

We will also be needing some variables to
refer to the input and output files.
@d IN_FILE "melodyin.txt"
@d OUT_FILE "melodyout.txt"
@<Local variables@>=
FILE *in_file, *out_file;

@ We open the input and output files using
|fopen|, checking for errors (even though
it is unlikely there will be errors if we've
got the input and output file names correct).
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

@ Reading the input data from the input
file requires us to know how the input data
is formatted.
Fortunately, the problem statement tells us
exactly that.

The first line of input contains integers |N|
and |K|, separated by a space.
The next |N| lines each contain a single integer,
which is a note in the song.

Note that we parse the input data into the
three arrays, rather than first putting it into
a single array.
@<Read the...@>=
fscanf(in_file, "%d %d\n", &N, &K);
for (int i = 0; i < N/3; i++)
  fscanf(in_file, "%d\n%d\n%d\n", &note1[i], &note2[i], &note3[i]);

@ Write the answer to the output file is easy;
a single call to |fprintf| suffices.
@<Write the...@>=
fprintf(out_file, "%d\n", answer);

@
@<Close the...@>=
fclose(in_file);
fclose(out_file);

@ We've obviously used functions from the |stdio|,
but we've also used |calloc|, |free|, and |exit|,
so we also need to include |stdlib.h|.
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
