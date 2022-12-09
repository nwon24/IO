#define IN_FILE "streetin.txt"
#define OUT_FILE "streetout.txt" \

#include <stdio.h>
#include <stdlib.h>
int main(void)
{

    FILE *in_file, *out_file;

    int N, K, answer;

    in_file = fopen(IN_FILE, "r");
    if (in_file == NULL) {
	printf("I can't find input file %s\n", IN_FILE);
	exit(1);
    }
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d %d\n", &N, &K);

    if (K == N) {
	answer = 0;
    } else if (K >= N / 2) {
	answer = 1;
    } else {
	int houses;

	houses = N - K;
	if (houses % (K + 1) == 0) {
	    answer = houses / (K + 1);
	} else {
	    answer = houses / (K + 1) + 1;
	}
    }

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
