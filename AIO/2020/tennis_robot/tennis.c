#define MAX_BINS 100000
#define IN_FILE "tennisin.txt"
#define OUT_FILE "tennisout.txt"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct bin {
    int number;
    int capacity;
};

int compar_cap(const void *p1, const void *p2)
{
    const struct bin *bin1, *bin2;

    bin1 = (const struct bin *) p1;
    bin2 = (const struct bin *) p2;
    if (bin1->capacity < bin2->capacity) {
	return -1;
    } else if (bin1->capacity == bin2->capacity) {
	return 0;
    } else {
	return 1;
    }
}

int compar_num(const void *p1, const void *p2)
{
    const struct bin *bin1, *bin2;

    bin1 = (const struct bin *) p1;
    bin2 = (const struct bin *) p2;
    if (bin1->number < bin2->number) {
	return -1;
    } else if (bin1->number == bin2->number) {
	return 0;
    } else {
	return 1;
    }
}

int main(void)
{

    int B;
    struct bin bins[MAX_BINS];
    int N;

    int answer;

    FILE *in_file;
    FILE *out_file;

    in_file = fopen(IN_FILE, "r");
    if (in_file == NULL) {
	fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
	exit(EXIT_FAILURE);
    }
    out_file = fopen(OUT_FILE, "w");
    if (out_file == NULL) {
	fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
	exit(EXIT_FAILURE);
    };

    fscanf(in_file, "%d %d\n", &B, &N);
    for (int i = 0; i < B; i++) {
	bins[i].number = i + 1;
	fscanf(in_file, "%d ", &bins[i].capacity);
    }

    int low_cap;
    int bins_not_full;
    int balls_placed;
    struct bin *smallest;

    qsort(bins, B, sizeof(bins[0]), compar_cap);
    bins_not_full = B;
    low_cap = 0;
    balls_placed = 0;
    smallest = &bins[0];
    while (1) {

	while (smallest->capacity == low_cap && smallest < bins + B) {
	    smallest++;
	    bins_not_full--;
	}

	;
	low_cap = smallest->capacity;

	if ((low_cap - balls_placed) * bins_not_full < N) {

	    N -= (low_cap - balls_placed) * bins_not_full;
	    balls_placed += low_cap - balls_placed;
	} else {
	    break;
	}
    }
    qsort(smallest, bins_not_full, sizeof(*smallest), compar_num);

    if (N <= bins_not_full) {
	answer = (smallest + N - 1)->number;
    } else {
	answer =
	    (smallest +
	     (N % bins_not_full ==
	      0 ? bins_not_full : N % bins_not_full) - 1)->number;
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
