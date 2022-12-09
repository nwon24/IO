#define IN_FILE "manin.txt"
#define OUT_FILE "manout.txt" \

#include <stdio.h>
int main(void)
{

    int cx, cd, ix, id, answer;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d %d %d %d\n", &ix, &cx, &id, &cd);

    if (cd == 0) {
	answer = cx;
    } else if (id == 0) {
	answer = ix;
    } else if (cx + cd == ix + id || cx + cd == ix - id) {
	answer = cx + cd;
    } else if (cx - cd == ix + id || cx - cd == ix - id) {
	answer = cx - cd;
    } else {

	printf("UNREACHABLE\n");
	answer = 0;
    }

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
