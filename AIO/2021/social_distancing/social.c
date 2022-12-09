#define MAX_HIPPOS 100000 \

#define IN_FILE "distin.txt"
#define OUT_FILE "distout.txt"

#include <stdio.h>
#include <stdlib.h>

int compar(const void *p1, const void *p2)
{
    if (*(int *) p1 < *(int *) p2)
	return -1;
    if (*(int *) p1 == *(int *) p2)
	return 0;
    if (*(int *) p1 > *(int *) p2)
	return 1;
}

int main(void)
{

    int N, K;
    int D[MAX_HIPPOS];
    int answer;

    FILE *in_file, *out_file;

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

    fscanf(in_file, "%d %d\n", &N, &K);
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d\n", &D[i]);
    }

    int last = 0;
    answer = 0;

    qsort(D, N, sizeof(int), compar);

    for (int i = 0; i < N; i++) {
	if (i == 0 || D[i] - last >= K) {
	    answer++;
	    last = D[i];
	}
    }

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
