#define RED_TEAM 0
#define BLUE_TEAM 1
#define NO_TEAM -1
#define IN_FILE "tagin.txt"
#define OUT_FILE "tagout.txt"

#include <stdio.h>

int main(void)
{

    int teams[2] = { 1, 1 };

    struct {
	int team;
    } players[100005];

    struct {
	int tagger;
	int tagged;
    } tags[100005];

    int N;
    int M;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d %d\n", &N, &M);
    for (int i = 0; i < M; i++) {
	fscanf(in_file, "%d %d\n", &tags[i].tagger, &tags[i].tagged);
    }

    for (int i = 0; i < N; i++) {
	if (i == 0) {
	    players[i].team = RED_TEAM;
	} else if (i == 1) {
	    players[i].team = BLUE_TEAM;
	} else {
	    players[i].team = NO_TEAM;
	}
    }

    for (int i = 0; i < M; i++) {
	teams[players[tags[i].tagger - 1].team]++;
	players[tags[i].tagged - 1] = players[tags[i].tagger - 1];
    }

    fprintf(out_file, "%d %d\n", teams[RED_TEAM], teams[BLUE_TEAM]);
    fclose(in_file);
    fclose(out_file);
    return 0;
}
