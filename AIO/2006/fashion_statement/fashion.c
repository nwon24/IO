#define IN_FILE "fashin.txt"
#define OUT_FILE "fashout.txt"

#include <stdio.h>

int main(void)
{

    int t;
    int answer;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d\n", &t);

    int notes[] = { 100, 20, 5, 1 };
    int i;

    i = 0;
    answer = 0;
    while (t > 0) {
	if (t < 5) {
	    answer += t;
	    break;
	}
	while (notes[i] > t) {
	    i++;
	}
	t -= notes[i];
	answer++;
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);
    return 0;
}
