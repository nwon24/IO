#define MAX_HOLES 100000
#define IN_FILE "artin.txt"
#define OUT_FILE "artout.txt"

#include <stdio.h>
#include <stdlib.h>

int main(void)
{

    int x[MAX_HOLES];
    int y[MAX_HOLES];
    int N;

    int xrange;
    int yrange;
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

    fscanf(in_file, "%d\n", &N);
    for (int i = 0; i < N; i++)
	fscanf(in_file, "%d %d\n", &x[i], &y[i]);

    int xmin, xmax;
    xmax = 0;
    xmin = x[0];
    for (int i = 0; i < N; i++) {
	if (x[i] < xmin)
	    xmin = x[i];
	if (x[i] > xmax)
	    xmax = x[i];
    }
    xrange = xmax - xmin;

    int ymin, ymax;
    ymax = 0;
    ymin = y[0];
    for (int i = 0; i < N; i++) {
	if (y[i] < ymin)
	    ymin = y[i];
	if (y[i] > ymax)
	    ymax = y[i];
    }
    yrange = ymax - ymin;

    answer = xrange * yrange;

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
