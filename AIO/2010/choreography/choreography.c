
#include <stdio.h>

struct a_throw {
    int thrower;
    int receiver;
};
int dancers[100005];
struct a_throw throws[100005];
int answer;
int D;
int T;

FILE *in_file;
FILE *out_file;

int main(void)
{

    in_file = fopen("dancein.txt", "r");
    out_file = fopen("danceout.txt", "w");

    fscanf(in_file, "%d %d\n", &D, &T);
    for (int i = 0; i < T; i++) {
	fscanf(in_file, "%d %d\n", &throws[i].thrower,
	       &throws[i].receiver);
    }

    for (int i = 0; i < T; i++) {
	if (dancers[throws[i].thrower - 1] == 0) {
	    answer++;
	} else {
	    dancers[throws[i].thrower - 1]--;
	}
	dancers[throws[i].receiver - 1]++;
    }

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
