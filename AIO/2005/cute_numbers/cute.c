#define IN_FILE "cutein.txt"
#define OUT_FILE "cuteout.txt" \

#include <stdio.h>

int answer;
int N;

FILE *in_file, *out_file;

int main(void)
{

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d\n", &N);

    answer = 0;
    for (int i = 0; i < N; i++) {
	int digit;
	fscanf(in_file, "%d\n", &digit);

	if (digit == 0) {
	    answer++;
	} else {
	    answer = 0;
	}
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
