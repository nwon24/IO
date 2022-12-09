#define IN_FILE "vasesin.txt"
#define OUT_FILE "vasesout.txt" \

#include <stdio.h>
int main(void)
{

    int vase1, vase2, vase3;

    int N;
    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");
    fscanf(in_file, "%d\n", &N);

    if (N < 6) {
	vase1 = vase2 = vase3 = 0;
    } else {
	vase1 = 1;
	vase2 = 2;
	vase3 = N - 3;
    }

    fprintf(out_file, "%d %d %d\n", vase1, vase2, vase3);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
