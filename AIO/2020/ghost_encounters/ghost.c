#define MAX_GHOSTS 100000
#define HASH_SIZE 1000
#define ABS(n) ((n) <0?-(n) :(n) )
#define HASH(n) (ABS(n) %HASH_SIZE)  \

#include <stdlib.h>
#include <stdio.h>

struct ghost {
    int X;
    int T;
};

struct ghost_sightings {
    int s;
    int number;
    struct ghost_sightings *forw;
    struct ghost_sightings *back;
};

struct ghost_sightings *hash_table[HASH_SIZE];

int time_for_ghost(struct ghost *ghost, int K)
{
    return ghost->T - (ghost->X * K);
}

void new_time_for_sightings(int s, int number)
{
    struct ghost_sightings *new_sighting;

    if ((new_sighting =
	 (struct ghost_sightings *) malloc(sizeof(*new_sighting))) ==
	NULL) {

	fprintf(stderr, "ERROR: malloc returned NULL\n");
	exit(EXIT_FAILURE);

	;
    }
    new_sighting->s = s;
    new_sighting->number = number;

    struct ghost_sightings **tmp;

    tmp = hash_table + HASH(new_sighting->s);
    if (*tmp == NULL) {
	*tmp = new_sighting;
	new_sighting->forw = new_sighting->back = NULL;
    } else {
	while ((*tmp)->forw != NULL) {
	    *tmp = (*tmp)->forw;
	}
	(*tmp)->forw = new_sighting;
	new_sighting->back = *tmp;
	new_sighting->forw = NULL;
    }

}

struct ghost_sightings *in_hash(int s)
{
    struct ghost_sightings *sighting;

    sighting = hash_table[HASH(s)];
    if (sighting == NULL) {
	return NULL;
    }
    while (sighting != NULL && sighting->s != s) {
	sighting = sighting->forw;
    }
    return sighting;
}

int main(void)
{

    struct ghost ghosts[MAX_GHOSTS];
    int N;
    int K;
    int answer;

    FILE *in_file;
    FILE *out_file;

    in_file = fopen("ghostin.txt", "r");
    if (in_file == NULL) {
	fprintf(stderr, "Unable to open input file ghostin.txt\n");
	exit(EXIT_FAILURE);
    }
    out_file = fopen("ghostout.txt", "w");
    if (out_file == NULL) {
	fprintf(stderr, "Unable to open output file ghostout.txt\n");
	exit(EXIT_FAILURE);
    }

    fscanf(in_file, "%d %d\n", &N, &K);
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d %d\n", &ghosts[i].X, &ghosts[i].T);
    }

    answer = 1;
    for (int i = 0; i < N; i++) {
	int time;
	struct ghost_sightings *sighting;

	time = time_for_ghost(ghosts + i, K);
	if ((sighting = in_hash(time)) == NULL) {
	    new_time_for_sightings(time, 1);
	} else {
	    sighting->number++;
	    if (sighting->number > answer) {
		answer = sighting->number;
	    }
	}
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
