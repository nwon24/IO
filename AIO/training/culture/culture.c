#define IN_FILE "cultin.txt"
#define OUT_FILE "cultout.txt" \

#include <stdio.h>

int N;
int starting;
int days;

FILE *in_file;
FILE *out_file;

int main(void)
{

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d\n", &N);

    days = 0;
    starting = N;
    while ((starting & 1) == 0) {
	days++;
	starting /= 2;
    }

    fprintf(out_file, "%d %d\n", starting, days);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
