#define MIN(x,y) ((x) <(y) ?(x) :(y) )
#define IN_FILE "rpsin.txt"
#define OUT_FILE "rpsout.txt"

#include <stdio.h>
#include <stdlib.h>

int main(void)
{

    int N;
    int Ra, Pa, Sa;
    int Rb, Pb, Sb;
    int answer;

    if (freopen(IN_FILE, "r", stdin) == NULL) {
	fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
	exit(EXIT_FAILURE);
    }
    if (freopen(OUT_FILE, "w", stdout) == NULL) {
	fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
	exit(EXIT_FAILURE);
    };

    scanf("%d\n", &N);
    scanf("%d %d %d\n", &Ra, &Pa, &Sa);
    scanf("%d %d %d\n", &Rb, &Pb, &Sb);

    int wins, losses;

    int Rwins, Pwins, Swins;
    wins = 0;
    Rwins = MIN(Ra, Pb);
    Pb -= Rwins;
    Ra -= Rwins;
    wins += Rwins;
    Pwins = MIN(Pa, Sb);
    Sb -= Pwins;
    Pa -= Pwins;
    wins += Pwins;
    Swins = MIN(Sa, Rb);
    Sa -= Swins;
    Rb -= Swins;
    wins += Swins;

    int Rloss, Ploss, Sloss;
    Rloss = (Ra - Rb < 0) ? 0 : Ra - Rb;
    Ploss = (Pa - Pb < 0) ? 0 : Pa - Pb;
    Sloss = (Sa - Sb < 0) ? 0 : Sa - Sb;
    losses = Rloss + Ploss + Sloss;

    answer = wins - losses;

    printf("%d\n", answer);
    fclose(stdin);
    fclose(stdout);
    return 0;
}
