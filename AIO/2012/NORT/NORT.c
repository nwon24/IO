#define IN_FILE "nortin.txt"
#define OUT_FILE "nortout.txt"

#include <stdio.h>

int main(void)
{

    int answer;
    int H, W;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d %d", &W, &H);

    answer = H * W;
    if (answer & 1) {
	answer -= 1;
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
