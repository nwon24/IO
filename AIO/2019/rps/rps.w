\input eplain
\enablehyperlinks
@* Introduction. This is a solution to a problem called {\bf RPS}
from the 2019 Australian Informatics Olympiad.
The problem statement can be found
\href{https://orac2.info/problem/aio19rps/}{{\bf here}}.

The problem is based on the famaliar game of Rock Paper Scissors.
Two people play the game $N$ times. Winning a round gains $1$ point,
losing a round loses $1$ point. We know that our opponent will
throw Rock in the first $R_a$ rounds, Paper in the next $R_p$ rounds,
and Scissors in the last $S_a$ rounds. We will throw Rock
in $R_b$ rounds, Paper in $P_b$ rounds, and Scissors in $S_b$ rounds,
but we can throw them in any order we wish. If we win a round,
we get $1$ point; if we lose a round, lose $1$ point. Starting at $0$ points,
our program needs to find the maximum number of points we can finish with.
@c
@<Include files@>@;
int main(void)
{
  @<Local variables@>;
  @<Open the input and output files@>;
  @<Read the input data from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the output file and close all files@>;
  return 0;
}
@* The Algorithm.
To get the maximum number of points, we need to maximise our number of wins
and minimise our number of losses. Maximising our wins is simple; during our
opponent's Rock throws, we just throw Paper for as many rounds as we can, and
during our opponent's Paper throws, we just throw as many Scissors as we can.
The same holds for when our opponent throws Scissors. After we have determined
what is the maximum number of rounds we can win, we need to then minimise
the number of losses by looking at how many draws we can get from the remaining
throws we have. The maximum number of points we can finish with is the
maximum number of wins subtracted by the minimum number of losses.
@
Here are the local variables that we will need to solve the problem.
The variable |N| holds the number of rounds.
The variables |Ra|, |Pa|, and |Sa| hold the number of Rock, Paper,
and Scissors throws our opponent will make. The variables |Rb|,
|Pb|, and |Sb| hold the same for us, except that we can make those
throws in any order we wish.
@<Local variables@>=
int N;
int Ra, Pa, Sa;
int Rb, Pb, Sb;
int answer;
@
@d MIN(x,y) ((x)<(y)?(x):(y))
@<Calculate the answer@>=
int wins, losses;
@<Calculate the maximum number of wins@>;
@<Calculate the minimum number of losses@>;
answer = wins-losses;
@ Whenever our opponent plays Rock, we want to throw Paper to beat it;
therefore, the number of wins we can get in the Rock rounds is the minimum
of the number of Rock hands our opponent has and the number of Paper hands
we have. The same is true for Paper and Scissors.
Then, we subtract the number of wins from the number of Rock, Paper or Scissors
throws we have left so that we can accurately calculate how many draws we
can manage from the remaining rounds.
@<Calculate the maximum number of wins@>=
int Rwins, Pwins, Swins;
wins=0;
Rwins=MIN(Ra,Pb);
Pb-=Rwins;
Ra-=Rwins;
wins+=Rwins;
Pwins=MIN(Pa,Sb);
Sb-=Pwins;
Pa-=Pwins;
wins+=Pwins;
Swins=MIN(Sa,Rb);
Sa-=Swins;
Rb-=Swins;
wins+=Swins;
@ If our opponent has |Ra| Rock hands left and we have |Rb| Rock hands
left, then we can manage |Ra| draws. Therefore, the minimum number of losses
we must take against the remainder of our opponent's Rock hands is |Ra-Rb|.
If that value is negative, then we have enough Rock throws remaining to not
lose any of the remaining Rock rounds. The same is true for Paper and Scissors,
so in this way we can calculate the number of losses.
@<Calculate the minimum...@>=
int Rloss, Ploss, Sloss;
Rloss=(Ra-Rb<0)?0:Ra-Rb;
Ploss=(Pa-Pb<0)?0:Pa-Pb;
Sloss=(Sa-Sb<0)?0:Sa-Sb;
losses=Rloss+Ploss+Sloss;

@*Input/Output.
The C standard library has many functions for file input and output. Here
we use |freopen| to associate the input and output files with standard input
and standard output; this means we can avoid having two variables to be
file pointers.
@d IN_FILE "rpsin.txt"
@d OUT_FILE "rpsout.txt"
@<Open the...@>=
if (freopen(IN_FILE, "r", stdin)==NULL) {
  fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
  exit(EXIT_FAILURE);
}
if (freopen(OUT_FILE, "w", stdout)==NULL) {
  fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
  exit(EXIT_FAILURE);
}
@
@ The problem statement specifies the format of the input file.
The first line of input contains the number of rounds, |N|.
The second line contains $R_a$, $P_a$, $S_a$, separated by spaces.
The third line contains $R_b$, $P_b$, $S_b$, also separated by spaces.
@<Read the...@>=
scanf("%d\n", &N);
scanf("%d %d %d\n", &Ra,&Pa,&Sa);
scanf("%d %d %d\n", &Rb,&Pb,&Sb);
@
@<Write the...@>=
printf("%d\n", answer);
fclose(stdin);
fclose(stdout);
@
@<Include files@>=
#include <stdio.h>
#include <stdlib.h>
