#define MAX_INSTRUCTIONS 100000
#define ABS(n) ((n) > 0?(n) :-(n) )  \

#define IN_FILE "robotin.txt"
#define OUT_FILE "robotout.txt" \

#include <stdio.h>
#include <stdlib.h>
int main(void)
{

    int K;
    char string[MAX_INSTRUCTIONS];

    int answer;
    int x;
    int y;

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

    fscanf(in_file, "%d\n", &K);
    fscanf(in_file, "%s\n", string);

    x = y = 0;
    for (int i = 0; i < K; i++) {
	switch (string[i]) {
	case 'N':
	    y++;
	    break;
	case 'E':
	    x++;
	    break;
	case 'S':
	    y--;
	    break;
	case 'W':
	    x--;
	    break;
	}
    }
    answer = ABS(x) + ABS(y);

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
