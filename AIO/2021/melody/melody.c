#define MAX_NOTES 99999
#define MAX_NOTE_VALUE 100000 \

#define IN_FILE "melodyin.txt"
#define OUT_FILE "melodyout.txt"

#include <stdio.h>
#include <stdlib.h>

int N, K;
int note1[MAX_NOTES / 3];
int note2[MAX_NOTES / 3];
int note3[MAX_NOTES / 3];

int mode(int *arr, int size)
{
    int *hash;
    int mode;

    hash = (int *) calloc(K + 1, sizeof(int));
    if (hash == NULL) {

	fprintf(stderr, "ERROR: calloc returned NULL\n");
	exit(EXIT_FAILURE);

    }
    mode = 0;

    for (int i = 0; i < size; i++) {
	hash[arr[i] - 1]++;
	if (hash[arr[i] - 1] > mode)
	    mode = hash[arr[i] - 1];
    }

    free(hash);
    return mode;
}

int main(void)
{

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
    for (int i = 0; i < N / 3; i++)
	fscanf(in_file, "%d\n%d\n%d\n", &note1[i], &note2[i], &note3[i]);

    int len;
    int mode_freq;

    answer = 0;
    len = N / 3;
    mode_freq = mode(note1, len);
    answer += len - mode_freq;
    mode_freq = mode(note2, len);
    answer += len - mode_freq;
    mode_freq = mode(note3, len);
    answer += len - mode_freq;

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
