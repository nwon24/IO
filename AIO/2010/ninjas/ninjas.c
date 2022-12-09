#define IN_FILE "ninjain.txt"
#define OUT_FILE "ninjaout.txt"

#include <stdio.h>

int main(void)
{

    FILE *in_file;
    FILE *out_file;

    int N, K;

    int answer;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d %d", &N, &K);

    answer = 0;
    if (K != 0) {
	while (N > 0) {
	    int caught;
	    N--;
	    caught = (N >= K) ? K : N;
	    answer += caught;
	    N -= caught;
	}
    };

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);
}
