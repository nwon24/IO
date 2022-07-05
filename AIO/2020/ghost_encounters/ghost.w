\input eplain
\enablehyperlinks
@*Introduction. This is a solution to a problem
called {\bf Ghost Encounters} from the 2020
Australian Informatics Olympiad. Its problem statement
may be found \href{https://orac2.info/problem/aio20ghost/}{{\bf here}}.

The problem consists of a number of ghosts, $N$, appearing at
certain locations along a trail. Ghost $i$ will appear $X_i$
metres along the trail, at $T_i$ seconds after sunset. The protagonist
of this problem, other than the reader, is Tupla, and she will
be walking down this trail to see the ghosts. If she is $K_i$ metres
along the trail $T_i$ seconds after sunset, she will see ghost $i$. She
walks along the trail at $1$ metre per $K$ seconds.
Our job is to determine the maximum number of ghosts Tulpa can encounter
if we pick the best possible time $s$ for her to begin the walk. The
value of $s$ is how long after sunset her walk needs to begin; it can
be negative, in which case she should start her walk before sunset.
@c
@<Include files@>@;
@<Global declarations@>@;
@<Global variables@>@;
@<Procedures@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input data from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close all files@>;
  return 0;
}

@*The Algorithm.
There is an intuitive way to solve this problem, and that is to
determine for each ghost what time Tulpa must begin her walk to
see that ghost. Then, we just need to keep track of how many ghosts
will be seen for the best time. We don't need to deal with two ghosts
appearing at the same time and place because the problem statement
tells us that we should count that as two encounters.

@ The first thing we need is to declare some local variables to
hold our input data and answer. Variables needed for the algorithm
that are not provided by the input data will be introduced later.

Since a ghost consists of two quanitities, namely its $X_i$ value
and its $T_i$ value, it is convenient to define a |struct| to describe it.

The problem statement guarantees that the number of ghosts will
not exceed $100000$, so we can statically allocate our array of ghosts.
@d MAX_GHOSTS 100000
@<Global declarations@>=
struct ghost {
  int X; /* Distance along the trail it will appear */
  int T; /* Time after sunset it will appear */
};
@
@<Local variables@>=
struct ghost ghosts[MAX_GHOSTS];
int N; /* The number of ghosts there are */
int K; /* How long it takes for Tulpa to walk $1$ metre */
int answer; /* The maximum number of ghosts Tulpa can see */
@ Let's have a function that gives us the time $s$ that Tulpa
must set out at to see a particular ghost. The ghost is specified
by the variable conveniently called |ghost|, which is a pointer
to a |struct ghost|, and the speed at which Tulpa walks is specified
by |K|, which matches with what the variable is called in the problem
statement for a bit of parallelism.

We just need to work backwards to determine what time Tulpa needs
to set out to see this particular ghost. Suppose Tulpa walked a metre
every $2$ seconds. If the ghost appeared
$5$ metres along the track $6$ seconds after sunset, we know that if Tulpa
set out at sunset, she will only walk $3$ metres after $6$ seconds
and therefore she will not encounter the ghost. If she needs to be $5$
metres along the track, she needs to walk for $5*2=10$ seconds. Therefore,
she needs to set out at |s=6-10=-4| seconds, i.e., $4$ seconds before
sunset.
@<Procedures@>=
int time_for_ghost(struct ghost *ghost, int K)
{
  return ghost->T-(ghost->X*K);
}

@ We need an array to store the number of ghosts Tulpa will see at
different times. Since the times at which Tulpa can begin her walk
may not be linear (and perhaps even negative), we can't easily use
a normal array. We can instead use a primitive sort of hash table.
We just need to make sure our hashing function guarantees the index
is positive.

Each entry in the hash table is the head of a doubly-linked list
of structures that tell us how many ghosts Tulpa will see at some
particular time of setting out.
@d HASH_SIZE 1000
@<Global declarations@>=
struct ghost_sightings {
  int s; /* Time at which Tulpa must set out to have this many sightings */
  int number; /* How many ghosts she will see */
  struct ghost_sightings *forw;
  struct ghost_sightings *back;
};

@ Here we define the actual hash table itself, which will just be
an array of points to |struc ghost_sightings|. We will dynamically
allocate each |struct ghost_sightings|, so we don't need to
statically allocate another array and take up quite a bit of memory.
@<Global variables@>=
struct ghost_sightings *hash_table[HASH_SIZE];

@ Our hashing function just uses the |%| operator, as out `keys'
will just be integers. We just need to make sure the resulting
index is positive, so we first need to take the absolute value.
@d ABS(n) ((n)<0?-(n):(n))
@d HASH(n) (ABS(n)%HASH_SIZE)

@ Here's the function we will use to dynamically allocate
each structure of type |struct ghost_sightings|. The function
takes in a time, |s|, and the number of ghosts, |number|,
calls |malloc| to allocate the structure, fills in the members
with the given parameters, and then puts it into the hash table
using the hashing function described above.
The means the caller of the function won't have to deal with
any returned variables itself.
@<Procedures@>=
void new_time_for_sightings(int s, int number)
{
  struct ghost_sightings *new_sighting;

  if ((new_sighting=(struct ghost_sightings*)malloc(sizeof(*new_sighting)))==NULL) {
    @<Exit abnormally because |malloc| failed@>;
  }
  new_sighting->s=s;
  new_sighting->number=number;
  @<Put |new_sighting| into the hash table@>;
}

@ Adding something to the hash table is fairly simple.
We find the proper index using the hashing function,
and if that entry in the hash table is {\tt NULL},
then the entry we are adding becomes the first entry
for that time. Otherwise, we manipulate the pointers
to insert the entry at the end of the doubly linked list.
@<Put |new_sighting| into the hash table@>=
struct ghost_sightings **tmp;

tmp = hash_table+HASH(new_sighting->s);
if (*tmp==NULL) {
  *tmp=new_sighting;
  new_sighting->forw=new_sighting->back=NULL;
} else {
  while ((*tmp)->forw!=NULL) {
    *tmp=(*tmp)->forw;
  }
  (*tmp)->forw=new_sighting;
  new_sighting->back=*tmp;
  new_sighting->forw=NULL;
}

@ We don't expect |malloc| to fail, but we must catch
it just in case.
@<Exit abnormally...@>=
fprintf(stderr, "ERROR: malloc returned NULL\n");
exit(EXIT_FAILURE);

@ We will also need a function to check if the entry
for a particular time is in the hash table. If it is,
we want to return that entry so that the caller can
increment the |number| field; if it isn't, we can
return |NULL| so that the caller knows to call |new_time_for_sightings|.

This procedure takes in a single argument, a particular
time at which Tulpa must begin her walk to see a particular ghost.
@<Procedures@>=
struct ghost_sightings *in_hash(int s)
{
  struct ghost_sightings *sighting;

  sighting=hash_table[HASH(s)];
  if (sighting==NULL) {
    return NULL;
  }
  while (sighting!=NULL&&sighting->s!=s) {
    sighting=sighting->forw;
  }
  return sighting;
}

@ Now that we have laid the groundwork for our algorithm,
we can proceed onto its core. The basic idea is that our
variable |answer| will always contain the maximum number
of ghosts current in |hash_table|. Each time we calculate
the starting time for a particular ghost, we check if it
is already in the hash table; if it is, we simply increment
the |number| field in the appropriate entry, and then
update |answer| if needed. If it is not in the hash table,
we add it to the hash table.

We initialise |answer| to $1$ because Tulpa is always
guaranteed to be able to see at least $1$ ghost.
@<Calculate the answer@>=
answer=1;
for (int i=0; i < N; i++) {
  int time; /* Time for a particular ghost */
  struct ghost_sightings *sighting; /* Used to check if the time is already in the hash table */
  
  time=time_for_ghost(ghosts+i, K);
  if ((sighting=in_hash(time))==NULL) {
    new_time_for_sightings(time, 1);
  } else {
    sighting->number++;
    if (sighting->number>answer) {
      answer=sighting->number;
    }
  }
}

@*Input/output.
As with any problem from the Australian Informatics Olympiad,
input and output comes from and goes to files specified by
the problem statement. In this case, the input file is
{\tt ghostin.txt}, and the output file is {\tt ghostout.txt}.

To refer to the opened files, we need variables of type |FILE *|,
which we declare here.
@<Local variables@>=
FILE *in_file; /* Input file, {\tt ghostin.txt} */
FILE *out_file; /* Output file, {\tt ghostout.txt} */

@ The call to |fopen| shouldn't encounter an error
on the judging machine (if we've got the input and output
file names correct, that is), but if we are testing this
program on our own machine, we may forget to provide the
input file. In that case, calling |fopen| on the input file
will return {\tt NULL}, so we have to exit gracefully.
@<Open the...@>=
in_file=fopen("ghostin.txt", "r");
if (in_file==NULL) {
  fprintf(stderr, "Unable to open input file ghostin.txt\n");
  exit(EXIT_FAILURE);
}
out_file=fopen("ghostout.txt", "w");
if (out_file==NULL) {
  fprintf(stderr, "Unable to open output file ghostout.txt\n");
  exit(EXIT_FAILURE);
}

@ Reading the input data from the input file requires us to
know how the data is formatted in the input file. The problem
statement tells us that the first line contains two integers,
$N$ and $K$, which are the number of ghosts and the number of
seconds Tulpa takes to walk each metre respectively. The next
$N$ lines contain two integers, which describe a particular ghost's
location and time of appearance. Remember that the former
corresponds to the |X| member of our |ghost| structure and the latter
corresponds to the |T| member of our |ghost| structure.
@<Read the...@>=
fscanf(in_file, "%d %d\n", &N, &K);
for (int i=0; i<N;i++) {
  fscanf(in_file, "%d %d\n", &ghosts[i].X, &ghosts[i].T);
}

@
@<Write the...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);

@
@<Include files@>=
#include <stdlib.h>
#include <stdio.h>
